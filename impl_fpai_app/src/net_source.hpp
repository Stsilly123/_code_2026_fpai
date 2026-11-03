// 帧从哪来。两条实现共用同一份线格式（iq_frame.hpp）：
//
//   TcpFrameSource  —— PS 网口，板子做服务端。部署时的真实路径。
//   FileFrameSource —— 读一个同样格式的帧流文件。
//
// 之所以留 FileFrameSource：上板第一件事是用它把网络变量摘掉。BY 硬件前向在这块
// 板子上从没跑过（主机上只有 mock，而 mock 不支持 forward），一旦出问题，先要能
// 分清是「模型/会话不对」还是「网络不对」。
#pragma once

#include <atomic>
#include <cstdint>
#include <cstdio>
#include <string>
#include <vector>

#include "iq_frame.hpp"

namespace rffi {

// SIGINT 置位。信号处理里只能碰无锁原子，std::atomic<bool> 在 x86-64 与 aarch64
// 上都是 lock-free 的，可以安全地用。
extern std::atomic<bool> g_stop;

enum class FrameStatus {
    Ok,      // 拿到一帧 IQ
    Retry,   // 这次没拿到（没客户端 / 断线 / 帧头非法），继续
    End,     // 没有更多数据了（文件读完，或收到了停止信号）
    Command, // 收到的是控制帧（dtype=2），不是 IQ；内容在 last_command()
};

class FrameSource {
public:
    virtual ~FrameSource() = default;
    // 成功时把 2*seg_len 个**原始未归一化**的 float 交错写进 in_raw，并填好 hdr。
    virtual FrameStatus next_frame(std::vector<float> &in_raw, IqFrameHeader &hdr) = 0;
    virtual const char *describe() const = 0;

    // 最近一次 next_frame 返回 Command 时的命令内容。
    const IqCommand &last_command() const { return last_cmd_; }

    // 下一帧是否**已经整帧**在缓冲里，且这个调用不会阻塞。跨帧流水靠它决定能不能
    // 提前取下一帧：上位机若是「发一帧等一帧」，下一帧没到就绝不能先去收，
    // 否则板子等帧、上位机等结果，互等死锁。
    // 文件源永远返回 true（本地读盘不算阻塞）。
    virtual bool next_frame_ready() const { return true; }

    // 把一帧推理结果回给上位机。默认什么都不做（file 模式没有对端）。
    // extra 非空时原样跟在 top-k 之后（分析模式的 IqAnalysis 块）；
    // 整帧字节数必须由调用方和上位机按同一个头算出来。
    // 返回 false 表示对端已断，调用方不必处理（源内部会自己回收连接）。
    virtual bool send_result(const IqResultHeader &, const std::vector<IqTopKEntry> &,
                             const std::vector<uint8_t> * = nullptr) {
        return true;
    }

protected:
    IqCommand last_cmd_{};
};

// 板子做服务端：bind -> listen -> accept -> 逐帧收，处理完当场把结果写回同一条连接。
// 断线后回到 accept 等下一个客户端。
class TcpFrameSource : public FrameSource {
public:
    TcpFrameSource(const std::string &bind_addr, int port, int seg_len);
    ~TcpFrameSource() override;

    FrameStatus next_frame(std::vector<float> &in_raw, IqFrameHeader &hdr) override;
    bool next_frame_ready() const override;
    bool send_result(const IqResultHeader &h, const std::vector<IqTopKEntry> &top,
                     const std::vector<uint8_t> *extra = nullptr) override;
    const char *describe() const override { return desc_.c_str(); }

    long long frames() const { return frames_; }
    long long commands() const { return commands_; }
    long long bad_frames() const { return bad_frames_; }
    long long disconnects() const { return disconnects_; }

private:
    bool recv_exact(void *buf, size_t n);
    bool send_exact(const void *buf, size_t n);
    bool wait_readable(int timeout_us);
    void drop_client();

    std::string desc_;
    int seg_len_;
    int listen_fd_ = -1;
    int client_fd_ = -1;
    std::vector<char> payload_;  // 复用，避免每帧分配
    long long frames_ = 0;
    long long commands_ = 0;
    long long bad_frames_ = 0;
    long long disconnects_ = 0;
    bool logged_waiting_ = false;
};

// 读 `tools/send_iq.py --dump-frames` 写出的同一个帧流。
class FileFrameSource : public FrameSource {
public:
    FileFrameSource(const std::string &path, int seg_len);
    ~FileFrameSource() override;

    FrameStatus next_frame(std::vector<float> &in_raw, IqFrameHeader &hdr) override;
    const char *describe() const override { return desc_.c_str(); }

    long long frames() const { return frames_; }
    long long bad_frames() const { return bad_frames_; }

private:
    std::string desc_;
    FILE *fp_ = nullptr;
    int seg_len_;
    std::vector<char> payload_;
    long long frames_ = 0;
    long long bad_frames_ = 0;
};

}  // namespace rffi
