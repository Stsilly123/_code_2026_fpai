#include "net_source.hpp"

#include <cerrno>
#include <cstring>

#include <spdlog/spdlog.h>

#if defined(_WIN32)
#include <winsock2.h>
#include <ws2tcpip.h>
using sock_t = SOCKET;
static constexpr sock_t kInvalidSock = INVALID_SOCKET;
static inline int close_sock(sock_t s) { return ::closesocket(s); }
#else
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
using sock_t = int;
static constexpr sock_t kInvalidSock = -1;
static inline int close_sock(sock_t s) { return ::close(s); }
#endif

namespace rffi {

std::atomic<bool> g_stop{false};

static constexpr const char *kLogP = "[PSIN]";

// --------------------------------------------------------------------------- //
// TCP 服务端
// --------------------------------------------------------------------------- //
TcpFrameSource::TcpFrameSource(const std::string &bind_addr, int port, int seg_len)
    : seg_len_(seg_len) {
#if defined(_WIN32)
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        throw std::runtime_error("WSAStartup 失败");
    }
#endif

    listen_fd_ = static_cast<int>(::socket(AF_INET, SOCK_STREAM, 0));
    if (listen_fd_ < 0) throw std::runtime_error("socket() 失败");

    int on = 1;
    ::setsockopt(static_cast<sock_t>(listen_fd_), SOL_SOCKET, SO_REUSEADDR,
                 reinterpret_cast<const char *>(&on), sizeof(on));

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(static_cast<uint16_t>(port));
    if (bind_addr.empty() || bind_addr == "0.0.0.0") {
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
    } else if (::inet_pton(AF_INET, bind_addr.c_str(), &addr.sin_addr) != 1) {
        throw std::runtime_error("bind 地址解析不了: " + bind_addr);
    }

    if (::bind(static_cast<sock_t>(listen_fd_), reinterpret_cast<sockaddr *>(&addr), sizeof(addr)) <
        0) {
        throw std::runtime_error("bind(" + bind_addr + ":" + std::to_string(port) +
                                 ") 失败：" + std::strerror(errno));
    }
    if (::listen(static_cast<sock_t>(listen_fd_), 1) < 0) {
        throw std::runtime_error("listen 失败");
    }
    desc_ = "tcp://" + bind_addr + ":" + std::to_string(port);
}

TcpFrameSource::~TcpFrameSource() {
    drop_client();
    if (listen_fd_ >= 0) close_sock(static_cast<sock_t>(listen_fd_));
#if defined(_WIN32)
    WSACleanup();
#endif
}

void TcpFrameSource::drop_client() {
    if (client_fd_ >= 0) {
        close_sock(static_cast<sock_t>(client_fd_));
        client_fd_ = -1;
        ++disconnects_;
    }
    logged_waiting_ = false;
}

// 等可读，最多 timeout_us 微秒。返回 true=可读，false=超时或出错。
// 用超时而不是阻塞，是为了让 Ctrl-C 能在一个短周期内被响应。
bool TcpFrameSource::wait_readable(int timeout_us) {
    const int fd = (client_fd_ >= 0) ? client_fd_ : listen_fd_;
    if (fd < 0) return false;
    fd_set rf;
    FD_ZERO(&rf);
    FD_SET(static_cast<sock_t>(fd), &rf);
    timeval tv{timeout_us / 1000000, timeout_us % 1000000};
    const int r = ::select(fd + 1, &rf, nullptr, nullptr, &tv);
    if (r < 0 && errno == EINTR) return false;
    return r > 0;
}

bool TcpFrameSource::recv_exact(void *buf, size_t n) {
    char *p = static_cast<char *>(buf);
    size_t got = 0;
    while (got < n) {
        if (g_stop) return false;
        if (!wait_readable(200000)) {
            if (g_stop) return false;
            continue;  // 超时，回头再看停止标志
        }
        const ssize_t k = ::recv(static_cast<sock_t>(client_fd_), p + got, n - got, 0);
        if (k <= 0) return false;  // 对端关连接或出错
        got += static_cast<size_t>(k);
    }
    return true;
}

// 把一段字节写完。对端断了就回收连接 —— 结果发不出去不算致命，下一帧会重新 accept。
bool TcpFrameSource::send_exact(const void *buf, size_t n) {
    if (client_fd_ < 0) return false;
    const char *p = static_cast<const char *>(buf);
    size_t sent = 0;
    while (sent < n) {
#if defined(MSG_NOSIGNAL)
        const ssize_t k = ::send(static_cast<sock_t>(client_fd_), p + sent, n - sent, MSG_NOSIGNAL);
#else
        const ssize_t k = ::send(static_cast<sock_t>(client_fd_), p + sent, n - sent, 0);
#endif
        if (k <= 0) {
            spdlog::warn("{} 结果发不出去（对端可能已断），回收连接", kLogP);
            drop_client();
            return false;
        }
        sent += static_cast<size_t>(k);
    }
    return true;
}

bool TcpFrameSource::send_result(const IqResultHeader &h, const std::vector<IqTopKEntry> &top,
                                 const std::vector<uint8_t> *extra) {
    // 字节数必须严格等于「40 + 8*k + extra」，k 以**头里的**为准：
    // 上位机是先读头、再按 k 读条目的，多一个少一个都会让它后面的帧全部错位。
    // 所以 top 不够时补 0 条目，多出来的忽略。
    const size_t k = static_cast<size_t>(h.k);
    const size_t nx = extra ? extra->size() : 0;
    std::vector<char> buf(sizeof(h) + k * sizeof(IqTopKEntry) + nx, 0);
    std::memcpy(buf.data(), &h, sizeof(h));
    const size_t avail = std::min(k, top.size());
    if (avail > 0) {
        std::memcpy(buf.data() + sizeof(h), top.data(), avail * sizeof(IqTopKEntry));
    }
    if (nx > 0) {
        std::memcpy(buf.data() + sizeof(h) + k * sizeof(IqTopKEntry), extra->data(), nx);
    }
    return send_exact(buf.data(), buf.size());
}

// 非阻塞：内核缓冲里是否已经有一整个帧（头 + 载荷）。只 peek 不消费。
// 头本身非法时返回 true —— 让 next_frame 去走「丢连接」那条路，这里不替它判断。
bool TcpFrameSource::next_frame_ready() const {
    if (client_fd_ < 0) return false;
    unsigned long avail = 0;
#if defined(_WIN32)
    u_long a = 0;
    if (::ioctlsocket(static_cast<sock_t>(client_fd_), FIONREAD, &a) != 0) return false;
    avail = static_cast<unsigned long>(a);
#else
    int a = 0;
    if (::ioctl(client_fd_, FIONREAD, &a) != 0) return false;
    avail = (a > 0) ? static_cast<unsigned long>(a) : 0;
#endif
    if (avail < sizeof(IqFrameHeader)) return false;

    IqFrameHeader h{};
    const int k = static_cast<int>(::recv(static_cast<sock_t>(client_fd_),
                                          reinterpret_cast<char *>(&h), sizeof(h), MSG_PEEK));
    if (k < static_cast<int>(sizeof(h))) return false;
    std::string err;
    if (!validate_header(h, seg_len_, err)) return true;  // 交给 next_frame 报错并断连
    return avail >= sizeof(h) + payload_bytes(h);
}

FrameStatus TcpFrameSource::next_frame(std::vector<float> &in_raw, IqFrameHeader &hdr) {
    if (g_stop) return FrameStatus::End;

    if (client_fd_ < 0) {
        if (!logged_waiting_) {
            spdlog::info("{} 等上位机连接 {}", kLogP, desc_);
            logged_waiting_ = true;
        }
        if (!wait_readable(300000)) return FrameStatus::Retry;
        client_fd_ = static_cast<int>(::accept(static_cast<sock_t>(listen_fd_), nullptr, nullptr));
        if (client_fd_ < 0) return FrameStatus::Retry;
        spdlog::info("{} 上位机已连接，开始收帧", kLogP);
    }

    if (!recv_exact(&hdr, sizeof(hdr))) {
        if (g_stop) return FrameStatus::End;
        drop_client();
        return FrameStatus::Retry;
    }

    std::string err;
    if (!validate_header(hdr, seg_len_, err)) {
        // 帧头不对说明对端和本程序对协议的理解不一致 —— 丢掉这条连接重来，
        // 不做「在字节流里找 magic」那种重同步（会把噪声当帧，越修越乱）。
        spdlog::error("{} 帧头非法：{}（丢弃这条连接）", kLogP, err);
        ++bad_frames_;
        drop_client();
        return FrameStatus::Retry;
    }

    payload_.resize(payload_bytes(hdr));
    if (!recv_exact(payload_.data(), payload_.size())) {
        if (g_stop) return FrameStatus::End;
        drop_client();
        return FrameStatus::Retry;
    }
    if (hdr.dtype == static_cast<uint16_t>(FrameDType::Command)) {
        std::memcpy(&last_cmd_, payload_.data(), sizeof(last_cmd_));
        ++commands_;
        return FrameStatus::Command;
    }
    if (!decode_payload(hdr, payload_.data(), payload_.size(), seg_len_, in_raw)) {
        spdlog::error("{} 载荷解不出来（seq={}）", kLogP, hdr.seq);
        ++bad_frames_;
        drop_client();
        return FrameStatus::Retry;
    }

    ++frames_;
    return FrameStatus::Ok;
}

// --------------------------------------------------------------------------- //
// 帧流文件
// --------------------------------------------------------------------------- //
FileFrameSource::FileFrameSource(const std::string &path, int seg_len) : seg_len_(seg_len) {
    fp_ = std::fopen(path.c_str(), "rb");
    if (!fp_) throw std::runtime_error("打不开帧流文件 " + path);
    desc_ = "file://" + path;
}

FileFrameSource::~FileFrameSource() {
    if (fp_) std::fclose(fp_);
}

FrameStatus FileFrameSource::next_frame(std::vector<float> &in_raw, IqFrameHeader &hdr) {
    if (g_stop) return FrameStatus::End;

    if (std::fread(&hdr, sizeof(hdr), 1, fp_) != 1) return FrameStatus::End;  // 正常读完

    std::string err;
    if (!validate_header(hdr, seg_len_, err)) {
        spdlog::error("{} 第 {} 帧帧头非法：{}", kLogP, frames_ + 1, err);
        ++bad_frames_;
        return FrameStatus::End;  // 文件流错位了就没法继续，直接停
    }

    payload_.resize(payload_bytes(hdr));
    if (std::fread(payload_.data(), 1, payload_.size(), fp_) != payload_.size()) {
        spdlog::warn("{} 文件在帧 {} 处截断", kLogP, frames_ + 1);
        return FrameStatus::End;
    }
    if (hdr.dtype == static_cast<uint16_t>(FrameDType::Command)) {
        std::memcpy(&last_cmd_, payload_.data(), sizeof(last_cmd_));
        return FrameStatus::Command;
    }
    if (!decode_payload(hdr, payload_.data(), payload_.size(), seg_len_, in_raw)) {
        ++bad_frames_;
        return FrameStatus::End;
    }

    ++frames_;
    return FrameStatus::Ok;
}

}  // namespace rffi
