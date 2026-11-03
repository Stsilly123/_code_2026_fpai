#include "pl_side.hpp"

#include <algorithm>
#include <cerrno>
#include <chrono>
#include <cmath>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <utility>
#include <vector>

#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
#include <spdlog/spdlog.h>

#include "pl_dma_io.h"
#endif

namespace rffi {

namespace {

// PL 侧契约（LcwtMLP_RFFI IP 改动说明 2026-10-22 / pl_dma_io README）。
constexpr size_t kSegLen = 256;
constexpr size_t kNumClasses = 20;
constexpr size_t kNFrames = 8;
constexpr size_t kFrameInBytes = kSegLen * 4;                // 256 × (I16,Q16)
constexpr size_t kCallInBytes = kNFrames * kFrameInBytes;    // 8192
constexpr size_t kFrameOutBytes = 1216;                      // 304 拍
constexpr size_t kCallOutBytes = kNFrames * kFrameOutBytes;  // 9728
constexpr size_t kTokBeats = 304;                            // 16 token × 19 拍
constexpr size_t kTokens = 16;
constexpr size_t kTokDim = 38;
constexpr size_t kHeadIn = kTokens * kTokDim;                // 608
constexpr size_t kEqFrameBytes = 1024;                       // 256 拍
constexpr size_t kCallEqBytes = kNFrames * kEqFrameBytes;    // 8192
constexpr size_t kExpFrameBytes = 1024;                      // 256 字
constexpr size_t kCallExpBytes = kNFrames * kExpFrameBytes;  // 8192
constexpr size_t kExpFeat = 193;
constexpr uint32_t kExpMagic = 0x45584631u;                  // "EXF1"，字 193
constexpr float kExpQ = 4096.0f;                             // int32 Q12

static_assert(kCallInBytes == 8192, "pl_dma_io 的进缓冲契约是 8192 B");
static_assert(kCallOutBytes == 9728, "pl_dma_io 的出缓冲契约是 9728 B");
static_assert(kTokBeats * 4 == kFrameOutBytes, "每帧 304 拍 × 4 B");
static_assert(kCallEqBytes == 8192, "eq 缓冲契约是 8192 B");
static_assert(kCallExpBytes == 8192, "专家缓冲契约是 8192 B");

#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
// pl_dma_io 的日志只在开库/错误路径出现，稳态循环里一条都没有。
void pl_log_bridge(void *, const char *fmt, va_list ap) {
    char buf[1024];
    std::vsnprintf(buf, sizeof(buf), fmt, ap);
    spdlog::info("[PLD] {}", buf);
}
#endif

// 诊断导出：整块写文件，失败只报一次，不影响推理。用 fprintf 而不是 spdlog，
// 这样非 aarch64（未编入 PL DMA）的构建也能编译。
inline void dump_block(const std::string &path, const void *data, size_t n) {
    FILE *f = std::fopen(path.c_str(), "wb");
    if (!f) {
        std::fprintf(stderr, "[PL] 诊断导出失败 %s\n", path.c_str());
        return;
    }
    const size_t w = std::fwrite(data, 1, n, f);
    std::fclose(f);
    std::fprintf(stderr, "[PL] 诊断导出 %s（%zu B%s）\n", path.c_str(), w,
                 w == n ? "" : "，短写");
}

// FNV-1a 64：给整块数据一个指纹，日志里一贴就能和 PC 端参考逐位对。
inline uint64_t fnv1a64(const void *data, size_t n) {
    const uint8_t *b = static_cast<const uint8_t *>(data);
    uint64_t h = 1469598103934665603ull;
    for (size_t i = 0; i < n; ++i) {
        h ^= b[i];
        h *= 1099511628211ull;
    }
    return h;
}

inline std::string dump_path(const std::string &prefix, long frame, const char *ext) {
    char suffix[32];
    std::snprintf(suffix, sizeof(suffix), "_f%02ld", frame);
    return prefix + suffix + ext;
}

// 小端读。不直接强转指针：缓冲偏移不一定对齐，且这样与板端字节序解耦。
inline int16_t read_le_i16(const uint8_t *p) {
    const uint16_t u = static_cast<uint16_t>(p[0]) | (static_cast<uint16_t>(p[1]) << 8);
    return (u <= 0x7fffu) ? static_cast<int16_t>(u)
                          : static_cast<int16_t>(static_cast<int32_t>(u) - 65536);
}

inline uint32_t read_le_u32(const uint8_t *p) {
    return static_cast<uint32_t>(p[0]) | (static_cast<uint32_t>(p[1]) << 8) |
           (static_cast<uint32_t>(p[2]) << 16) | (static_cast<uint32_t>(p[3]) << 24);
}

inline int32_t read_le_i32(const uint8_t *p) {
    return static_cast<int32_t>(read_le_u32(p));
}

// 任意个样本的中位数。返回 2×中位数，便于和逐帧码值做「2*code == sum」的整数比较。
inline int median2(std::vector<int> &v) {
    std::sort(v.begin(), v.end());
    const size_t n = v.size();
    if (n & 1) return 2 * v[n / 2];
    return v[n / 2 - 1] + v[n / 2];
}

inline float median_f(std::vector<float> &v) {
    std::sort(v.begin(), v.end());
    const size_t n = v.size();
    if (n == 0) return 0.0f;
    if (n & 1) return v[n / 2];
    return 0.5f * (v[n / 2 - 1] + v[n / 2]);
}

}  // namespace

PlSide::PlSide(PlConfig cfg) : cfg_(std::move(cfg)) {
    iq_.resize(kSegLen * 2);
    in_buf_.resize(kCallInBytes);
    out_buf_.resize(kCallOutBytes);
    eq_buf_.resize(kCallEqBytes);
    exp_buf_.resize(kCallExpBytes);
    tok_.assign(kHeadIn, 0.0f);
    last_logits_.assign(kNumClasses, 0.0f);
}

PlSide::~PlSide() { close(); }

bool PlSide::open(icraft::xrt::Device &device, std::string &err) {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (io_) {
        err = "PL DMA 已经打开";
        return false;
    }
    if (cfg_.tta_shifts.empty()) cfg_.tta_shifts = {0};
    int zero_count = 0;
    for (int s : cfg_.tta_shifts) {
        if (s == 0) ++zero_count;
    }
    if (cfg_.eq_enable && zero_count != 1) {
        err = "pl.eq_enable=true 时 pl.tta_shifts 必须恰好包含一个 0";
        return false;
    }
    if (!(cfg_.token_divisor > 0.0f)) {
        err = "pl.token_divisor 必须为正";
        return false;
    }

    // LCWT 头先开：PL 已经不算 logits，头打不开这一路就没有输出。
    head_ = std::make_unique<LcwtHead>();
    LcwtHeadConfig hc;
    hc.json = cfg_.head_json;
    hc.raw = cfg_.head_raw;
    hc.aux = cfg_.head_aux;
    hc.input_dim = static_cast<int>(kHeadIn);
    hc.num_classes = static_cast<int>(kNumClasses);
    hc.tokens = static_cast<int>(kTokens);
    hc.dim = static_cast<int>(kTokDim);
    hc.batch = cfg_.head_batch;
    std::string herr;
    if (!head_->open(device, hc, false, herr)) {
        head_.reset();
        err = "LCWT 头打开失败: " + herr;
        return false;
    }

    // 专家 MLP（第三路）。expert_enable=true 时必须有图：少了就报错退出，
    // 不做"悄悄退回两路"——那样准确率对不上还查不出原因。
    if (cfg_.expert_enable) {
        if (cfg_.expert_json.empty() || cfg_.expert_raw.empty()) {
            err = "pl.expert_enable=true 时必须给 pl.expert_json / pl.expert_raw";
            return false;
        }
        expert_ = std::make_unique<ExpertHead>();
        ExpertHeadConfig xc;
        xc.json = cfg_.expert_json;
        xc.raw = cfg_.expert_raw;
        xc.clamp = cfg_.expert_clamp;
        std::string xerr;
        if (!expert_->open(device, xc, false, xerr)) {
            expert_.reset();
            err = "专家头打开失败: " + xerr;
            return false;
        }
    }

    pl_dma_io_cfg c;
    pl_dma_io_cfg_default(&c);
    c.dma0_base = cfg_.dma0_base;
    c.dma1_base = cfg_.dma1_base;
    c.dma2_base = cfg_.eq_enable ? cfg_.dma2_base : 0;
    c.dma3_base = cfg_.expert_enable ? cfg_.dma3_base : 0;
    c.udmabuf_name = cfg_.udmabuf.c_str();
    c.in_bytes = static_cast<uint32_t>(kCallInBytes);
    c.out_bytes = static_cast<uint32_t>(kCallOutBytes);
    c.eq_bytes = static_cast<uint32_t>(kCallEqBytes);
    c.expert_bytes = static_cast<uint32_t>(kCallExpBytes);
    c.timeout_ms = cfg_.timeout_ms;
    c.total_timeout_ms = cfg_.total_timeout_ms;
    // evict=0：**实测开着更差，别开**。
    // 2026-10-12 14:12 板端（evict=1，其余与 13:53 那版相同）对比：
    //   帧周期 14.84 → 82.65 ms（每帧 4~6 趟 8 MiB 写回 ≈ 68 ms）；
    //   隔帧 eq 整块失效（eqstd=0.000000 agree=0）→ eq 不可用 → XF 也没输入，
    //   15/32 帧没有结果、融合 53%。evict=0 时 eq 32/32 都是 agree=7。
    // 挤缓存既没解决帧尾可见性，自己又引入一种整块异常，所以关掉。
    // 专家 magic 时有时无（xagree 0/1）在 evict=0 下仍在，但它暂不参与融合；
    // 要修就单独给专家接收加等待，别全局开 evict。
    c.evict = 0;
    c.drain_on_open = 1;
    c.log = pl_log_bridge;
    c.log_user = nullptr;

    io_ = pl_dma_io_open(&c);
    if (!io_) {
        const int e = errno;
        head_->close();
        head_.reset();
        err = std::string("pl_dma_io_open 失败: ") + std::strerror(e);
        return false;
    }
    return true;
#else
    (void)device;
    err = "PL DMA 未编入本二进制（CMake ENABLE_PL_CNN=OFF，或目标不是 aarch64）";
    return false;
#endif
}

void PlSide::close() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (io_) {
        auto *h = static_cast<pl_dma_io *>(io_);
        // 收干净三条支路里可能残留的半帧，免得下一次打开从帧中间切进去。
        pl_dma_io_drain(h);
        if (cfg_.eq_enable) pl_dma_io_eq_drain(h);
        if (cfg_.expert_enable) pl_dma_io_expert_drain(h);
        pl_dma_io_close(h);
    }
#endif
    io_ = nullptr;
    if (expert_) {
        expert_->close();
        expert_.reset();
    }
    if (head_) {
        head_->close();
        head_.reset();
    }
}

std::string PlSide::describe() const {
    char addr[144];
    std::snprintf(addr, sizeof(addr), "0x%08llx/0x%08llx/0x%08llx/0x%08llx",
                  static_cast<unsigned long long>(cfg_.dma0_base),
                  static_cast<unsigned long long>(cfg_.dma1_base),
                  static_cast<unsigned long long>(cfg_.dma2_base),
                  static_cast<unsigned long long>(cfg_.dma3_base));
    std::string s = cfg_.udmabuf + "  DMA " + addr;
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (io_) {
        s += std::string("  模式=") +
             (pl_dma_io_mode(static_cast<const pl_dma_io *>(io_)) == 0 ? "SG 描述符环"
                                                                       : "直读");
    } else {
        s += "  未打开";
    }
#else
    s += "  未编入（桩）";
#endif
    s += cfg_.eq_enable ? "  eq=开" : "  eq=关";
    s += cfg_.expert_enable ? "  expert=开" : "  expert=关";
    s += "  TTA=";
    if (cfg_.tta_shifts.empty()) {
        s += "off";
    } else {
        for (size_t i = 0; i < cfg_.tta_shifts.size(); ++i) {
            if (i) s += "/";
            s += std::to_string(cfg_.tta_shifts[i]);
        }
    }
    s += "  token/" + std::to_string(cfg_.token_divisor);
    if (head_) s += "  " + head_->describe();
    if (expert_) s += "  " + expert_->describe();
    if (!cfg_.weights_hash.empty()) s += "  weights=" + cfg_.weights_hash;
    return s;
}

bool PlSide::quantize_shift(const float *raw, size_t n, int shift, size_t slot) {
    const int N = static_cast<int>(n);
    last_clipped_ = 0;
    for (size_t k = 0; k < n; ++k) {
        int src = static_cast<int>(k) - shift;
        src %= N;
        if (src < 0) src += N;

        long qi = std::lrintf(raw[2 * static_cast<size_t>(src)] * 1024.0f);
        long qq = std::lrintf(raw[2 * static_cast<size_t>(src) + 1] * 1024.0f);
        if (qi > 32767) { qi = 32767; ++last_clipped_; }
        if (qi < -32768) { qi = -32768; ++last_clipped_; }
        if (qq > 32767) { qq = 32767; ++last_clipped_; }
        if (qq < -32768) { qq = -32768; ++last_clipped_; }
        iq_[2 * k] = static_cast<int16_t>(qi);
        iq_[2 * k + 1] = static_cast<int16_t>(qq);
    }

    // 一帧 256 个 32bit 字：[15:0]=I、[31:16]=Q。写进第 slot 帧。
    uint8_t *dst = in_buf_.data() + slot * kFrameInBytes;
    for (size_t k = 0; k < kSegLen; ++k) {
        const uint32_t w = (static_cast<uint32_t>(static_cast<uint16_t>(iq_[2 * k])) |
                            (static_cast<uint32_t>(static_cast<uint16_t>(iq_[2 * k + 1])) << 16));
        const size_t off = k * 4;
        dst[off + 0] = static_cast<uint8_t>(w & 0xffu);
        dst[off + 1] = static_cast<uint8_t>((w >> 8) & 0xffu);
        dst[off + 2] = static_cast<uint8_t>((w >> 16) & 0xffu);
        dst[off + 3] = static_cast<uint8_t>((w >> 24) & 0xffu);
    }
    return true;
}

bool PlSide::xfer_once(long &got, std::string &err) {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    // 驱动那边出错会自己排空残帧、复位通道；这里再给一次机会。
    // 上一轮板端见过一次 MM2S 自环描述符读到旧 COMPLETE 直接 SGIntErr，
    // 之后那一帧白等 5 s。重试一次通常就过了，别让整帧丢掉。
    for (int attempt = 0; attempt < 2; ++attempt) {
        got = pl_dma_io_xfer(static_cast<pl_dma_io *>(io_), in_buf_.data(),
                             static_cast<uint32_t>(kCallInBytes), out_buf_.data(),
                             static_cast<uint32_t>(kCallOutBytes));
        if (got == static_cast<long>(kCallOutBytes))
            return true;
        if (got < 0) {
            const int e = errno;
            err = std::string("pl_dma_io_xfer 失败: ") + std::strerror(e);
        } else {
            // 短收：驱动会自己排空，这一轮的数据不可信。
            err = "PL 短收 " + std::to_string(got) + "/" +
                  std::to_string(kCallOutBytes) + " 字节";
        }
        if (attempt == 0) {
            std::fprintf(stderr, "[PL] xfer 失败，重试一次：%s\n", err.c_str());
            // 别再"补喂对齐"了（板上实测是负优化：补喂 8 帧默认输出滞后输入，
            // 每次都多塞 2 帧、之后稳定错开，而且失败频率还涨了）。
            // 现在把判断放在 mm2s_start 里就地做：取指失败当场重挂，不白等 timeout。
            if (cfg_.eq_enable) drain_eq();
            if (cfg_.expert_enable) drain_expert();
        }
    }
    return false;
#else
    (void)got;
    err = "PL DMA 未编入本二进制";
    return false;
#endif
}

void PlSide::read_slot_tokens(size_t slot, float *tok) const {
    // 每帧 1216 B：304 拍，拍 b = t*19 + j；低 16 位 tok[t][2j]，高 16 位 tok[t][2j+1]。
    const uint8_t *base = out_buf_.data() + slot * kFrameOutBytes;
    for (size_t t = 0; t < kTokens; ++t) {
        for (size_t j = 0; j < kTokBeats / kTokens; ++j) {   // 19
            const uint32_t w = read_le_u32(base + (t * (kTokBeats / kTokens) + j) * 4);
            const int16_t lo = static_cast<int16_t>(w & 0xffffu);
            const int16_t hi = static_cast<int16_t>(w >> 16);
            tok[t * kTokDim + 2 * j] = static_cast<float>(lo) / cfg_.token_divisor;
            tok[t * kTokDim + 2 * j + 1] = static_cast<float>(hi) / cfg_.token_divisor;
        }
    }
}

bool PlSide::run_slots_head(const std::vector<size_t> &slots,
                            std::vector<std::vector<float>> &logits, std::string &err) {
    if (!head_ || !head_->is_open()) {
        err = "LCWT 头未打开";
        return false;
    }
    if (slots.empty()) return true;

    // 1) 解包每个槽的 token，按**逐字节相同**去重。
    //    同平移的复制帧在 PL 里就是同一份输入算出来的，dout 逐字节相同；
    //    DMA 漏写/串帧的槽字节不同，会自己占一行（它的 logits 也就和别人不同，
    //    下游 emit_group 的一致性检查照样能发现）。
    std::vector<std::vector<float>> uniq;
    std::vector<size_t> row_of(slots.size(), 0);
    for (size_t i = 0; i < slots.size(); ++i) {
        read_slot_tokens(slots[i], tok_.data());
        size_t r = uniq.size();
        for (size_t j = 0; j < uniq.size(); ++j) {
            if (std::memcmp(uniq[j].data(), tok_.data(),
                            kHeadIn * sizeof(float)) == 0) {
                r = j;
                break;
            }
        }
        if (r == uniq.size()) uniq.push_back(tok_);
        row_of[i] = r;
    }

    // 2) 唯一行按图的 batch 打包前向（不足一批的由头内部补第 0 行）。
    const int B = std::max(1, cfg_.head_batch);
    std::vector<std::vector<float>> uni_logits(uniq.size(),
                                               std::vector<float>(kNumClasses, 0.0f));
    std::vector<float> in, out;
    for (size_t b = 0; b < uniq.size(); b += static_cast<size_t>(B)) {
        const int rows = static_cast<int>(std::min<size_t>(B, uniq.size() - b));
        in.assign(static_cast<size_t>(rows) * kHeadIn, 0.0f);
        for (int r = 0; r < rows; ++r) {
            std::memcpy(in.data() + static_cast<size_t>(r) * kHeadIn,
                        uniq[b + static_cast<size_t>(r)].data(),
                        kHeadIn * sizeof(float));
        }
        out.assign(static_cast<size_t>(rows) * kNumClasses, 0.0f);
        std::string e;
        if (!head_->forward_batch(in.data(), rows, out.data(), e)) {
            err = e;
            return false;
        }
        for (int r = 0; r < rows; ++r) {
            std::copy(out.begin() + static_cast<size_t>(r) * kNumClasses,
                      out.begin() + static_cast<size_t>(r + 1) * kNumClasses,
                      uni_logits[b + static_cast<size_t>(r)].begin());
        }
    }

    // 3) 逐槽回填：复制帧拿到同一份 logits，emit_group 的中位数/一致性不变。
    for (size_t i = 0; i < slots.size(); ++i) {
        logits[slots[i]] = uni_logits[row_of[i]];
    }
    return true;
}

bool PlSide::softmax_logits(const std::vector<float> &logits, std::vector<float> &probs,
                            std::string &err) const {
    if (logits.size() != kNumClasses) {
        err = "LCWT 头 logits 维数不是 20";
        return false;
    }
    float m = logits[0];
    for (size_t c = 1; c < kNumClasses; ++c) m = std::max(m, logits[c]);
    double sum = 0.0;
    probs.assign(kNumClasses, 0.0f);
    for (size_t c = 0; c < kNumClasses; ++c) {
        const double e = std::exp(static_cast<double>(logits[c]) - m);
        probs[c] = static_cast<float>(e);
        sum += e;
    }
    if (!(sum > 0.0)) {
        err = "PL logits 无法归一化";
        return false;
    }
    for (size_t c = 0; c < kNumClasses; ++c) {
        probs[c] = static_cast<float>(static_cast<double>(probs[c]) / sum);
    }
    return true;
}

bool PlSide::recv_eq(std::vector<float> &eq, int &agree, std::string &err,
                    const std::vector<size_t> &frames) {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    uint32_t egot = 0;
    const long got = pl_dma_io_eq_recv(static_cast<pl_dma_io *>(io_), eq_buf_.data(),
                                       static_cast<uint32_t>(kCallEqBytes), &egot);
    if (got < 0) {
        const int e = errno;
        err = std::string("pl_dma_io_eq_recv 失败: ") + std::strerror(e);
        return false;
    }
    if (got != static_cast<long>(kCallEqBytes)) {
        err = "eq 短收 " + std::to_string(got) + "/" + std::to_string(kCallEqBytes) + " 字节";
        return false;
    }
#else
    err = "PL DMA 未编入本二进制";
    return false;
#endif

    // 每帧 256 拍，每拍 {Q[31:16], I[15:0]}，两个 int16、Q10。
    // 只取 frames 里列出的槽（都是 shift 0 的复制帧），其余槽是别的平移，不要。
    std::vector<size_t> use = frames;
    if (use.empty()) use.push_back(0);
    eq.assign(kSegLen * 2, 0.0f);
    int min_agree = static_cast<int>(use.size());
    std::vector<int> vals(use.size());
    for (size_t k = 0; k < kSegLen; ++k) {
        for (size_t comp = 0; comp < 2; ++comp) {
            for (size_t i = 0; i < use.size(); ++i) {
                const uint8_t *p = eq_buf_.data() + use[i] * kEqFrameBytes + k * 4;
                const uint32_t w = read_le_u32(p);
                const uint16_t u = static_cast<uint16_t>(comp == 0 ? (w & 0xffffu) : (w >> 16));
                vals[i] = (u <= 0x7fffu) ? static_cast<int>(u)
                                         : static_cast<int>(u) - 65536;
            }
            const int sum = median2(vals);
            int a = 0;
            for (int v : vals) {
                if (2 * v == sum) ++a;
            }
            min_agree = std::min(min_agree, a);
            // 中位数 / 1024 还原到原始 IQ 量纲（Q10）。
            eq[2 * k + comp] = static_cast<float>(sum) * 0.5f / 1024.0f;
        }
    }
    agree = min_agree;
    // 只有一帧时没有可比的副本，不做一致性判定。
    const int need = std::min(cfg_.min_eq_agree_frames, static_cast<int>(use.size()));
    if (use.size() > 1 && need > 0 && agree < need) {
        // 逐槽现场：整槽指纹 + 首字 + 两种底色的字数（0xA5 是驱动铺底，
        // 0x5A 是挤缓存 scratch 的初值）。哪个槽没被 DMA 写过一眼就能看出来。
        for (size_t s = 0; s < kNFrames; ++s) {
            const uint8_t *p = eq_buf_.data() + s * kEqFrameBytes;
            int n_a5 = 0, n_5a = 0;
            for (size_t w = 0; w < kEqFrameBytes / 4; ++w) {
                const uint32_t v = read_le_u32(p + w * 4);
                if (v == 0xA5A5A5A5u) ++n_a5;
                else if (v == 0x5A5A5A5Au) ++n_5a;
            }
            std::fprintf(stderr,
                         "[EQDBG] f%02ld slot=%zu h=%016llx w0=%08x w1=%08x "
                         "nA5=%d n5A=%d\n",
                         frame_no_ - 1, s,
                         static_cast<unsigned long long>(fnv1a64(p, kEqFrameBytes)),
                         read_le_u32(p), read_le_u32(p + 4), n_a5, n_5a);
        }
        err = "eq 复制帧输出不一致（最少仅 " + std::to_string(agree) +
              " 帧与中位数相同，阈值 " + std::to_string(need) + "）";
        return false;
    }
    return true;
}

bool PlSide::recv_expert(std::vector<float> &feat, int &agree, int &frame_idx,
                         std::string &err) {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    uint32_t xgot = 0;
    const long got = pl_dma_io_expert_recv(static_cast<pl_dma_io *>(io_), exp_buf_.data(),
                                           static_cast<uint32_t>(kCallExpBytes), &xgot);
    if (got < 0) {
        const int e = errno;
        err = std::string("pl_dma_io_expert_recv 失败: ") + std::strerror(e);
        return false;
    }
    if (got != static_cast<long>(kCallExpBytes)) {
        err = "专家短收 " + std::to_string(got) + "/" + std::to_string(kCallExpBytes) +
              " 字节";
        return false;
    }
#else
    err = "PL DMA 未编入本二进制";
    return false;
#endif

    // 每帧 1024 B：字 0..192 特征，193 magic，194 版本，195 帧号，196 Q 格式，197 flags。
    const size_t feat_bytes = kExpFeat * 4;
    int chosen = -1;
    int valid = 0;
    for (size_t f = 0; f < kNFrames; ++f) {
        const uint8_t *base = exp_buf_.data() + f * kExpFrameBytes;
        if (read_le_u32(base + kExpFeat * 4) == kExpMagic) {
            ++valid;
            if (chosen < 0) chosen = static_cast<int>(f);
        }
    }
    if (chosen < 0) {
        err = "专家特征帧没有 EXF1 magic（驱动/PL 版本不匹配？）";
        return false;
    }

    // 选多数派，不取第一帧：实测每轮第 0 槽是首帧暂态（193 个特征里 2 个不同），
    // 且偶有 1~2 槽混进邻轮输出。第一轮 8 槽本该一致，正常时多数派 = 7 或 8 票。
    // 平票（4:4）取占位更靠后的那组——块是 FIFO，旧帧先出。
    int best = chosen;
    int best_hi = -1;
    agree = 0;
    for (size_t f = 0; f < kNFrames; ++f) {
        const uint8_t *p = exp_buf_.data() + f * kExpFrameBytes;
        if (read_le_u32(p + kExpFeat * 4) != kExpMagic) continue;
        int cnt = 0;
        int hi = -1;
        for (size_t g = 0; g < kNFrames; ++g) {
            const uint8_t *q = exp_buf_.data() + g * kExpFrameBytes;
            if (read_le_u32(q + kExpFeat * 4) == kExpMagic &&
                std::memcmp(p, q, feat_bytes) == 0) {
                ++cnt;
                hi = static_cast<int>(g);
            }
        }
        if (cnt > agree || (cnt == agree && hi > best_hi)) {
            agree = cnt;
            best = static_cast<int>(f);
            best_hi = hi;
        }
    }
    const uint8_t *base = exp_buf_.data() + static_cast<size_t>(best) * kExpFrameBytes;
    frame_idx = static_cast<int>(read_le_u32(base + 195 * 4) & 0x7u);
    feat.resize(kExpFeat);
    for (size_t k = 0; k < kExpFeat; ++k) {
        feat[k] = static_cast<float>(read_le_i32(base + k * 4)) / kExpQ;
    }

    // 诊断：第一轮 8 槽是同一份 shift 0 输入，专家输出本该逐字节一致（见
    // docs/PL_专家系统_Verilog实现指南.md 的自测表）。对不齐时把逐槽的
    // magic / 帧号 / 指纹 / 与多数派的差异打出来，直接区分三种原因：
    //   1) valid < 8 —— 只有部分槽带 magic，是切帧/错位；
    //   2) valid = 8、帧号不连续 —— 收到的是上一轮的旧帧（队列滞后）；
    //   3) valid = 8、帧号连续、特征不同 —— 专家模块本身跨帧有残留状态。
    if (agree < static_cast<int>(kNFrames)) {
        std::fprintf(stderr, "[EXDBG] f%02ld valid=%d agree=%d chosen=%d pick=%d\n",
                     frame_no_ - 1, valid, agree, chosen, best);
        for (size_t f = 0; f < kNFrames; ++f) {
            const uint8_t *p = exp_buf_.data() + f * kExpFrameBytes;
            int nz = 0;
            int diff = 0;
            int64_t maxd = 0;
            for (size_t k = 0; k < kExpFeat; ++k) {
                const int32_t v = read_le_i32(p + k * 4);
                if (v != 0) ++nz;
                int64_t d = static_cast<int64_t>(v) - read_le_i32(base + k * 4);
                if (d < 0) d = -d;
                if (d != 0) ++diff;
                if (d > maxd) maxd = d;
            }
            std::fprintf(stderr,
                         "[EXDBG] f%02ld slot=%zu magic=%d ctr=%u ver=%u flags=%u "
                         "h=%016llx nz=%d d=%d maxd=%lld\n",
                         frame_no_ - 1, f,
                         read_le_u32(p + kExpFeat * 4) == kExpMagic ? 1 : 0,
                         read_le_u32(p + 195 * 4), read_le_u32(p + 194 * 4),
                         read_le_u32(p + 197 * 4),
                         static_cast<unsigned long long>(fnv1a64(p, feat_bytes)),
                         nz, diff, static_cast<long long>(maxd));
            // 只差几个字时直接列出下标，给 RTL 侧定位哪一级寄存器有残留。
            if (diff > 0 && diff <= 8) {
                std::fprintf(stderr, "[EXDBG] f%02ld slot=%zu idx=", frame_no_ - 1, f);
                for (size_t k = 0; k < kExpFeat; ++k) {
                    const int32_t v = read_le_i32(p + k * 4);
                    const int32_t b = read_le_i32(base + k * 4);
                    if (v != b) {
                        std::fprintf(stderr, " %zu:%d/%d", k, v, b);
                    }
                }
                std::fprintf(stderr, "\n");
            }
        }
    }
    (void)valid;
    return true;
}

void PlSide::drain_eq() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (!io_ || !cfg_.eq_enable) return;
    const int n = pl_dma_io_eq_drain(static_cast<pl_dma_io *>(io_));
    if (n < 0) {
        static int warned = 0;
        if (warned++ < 3) spdlog::warn("[PL] eq_drain 返回 {}", n);
    }
#endif
}

void PlSide::drain_expert() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (!io_ || !cfg_.expert_enable) return;
    const int n = pl_dma_io_expert_drain(static_cast<pl_dma_io *>(io_));
    if (n < 0) {
        static int warned = 0;
        if (warned++ < 3) spdlog::warn("[PL] expert_drain 返回 {}", n);
    }
#endif
}

void PlSide::drain_all() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (!io_) return;
    const int nd = pl_dma_io_drain(static_cast<pl_dma_io *>(io_));
    if (nd > 0) std::fprintf(stderr, "[PL] 重发前排空 dout %d 帧\n", nd);
    drain_eq();
    drain_expert();
#endif
}

void PlSide::discard_eq() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (!io_ || !cfg_.eq_enable) return;
    uint32_t got = 0;
    const long n = pl_dma_io_eq_recv(static_cast<pl_dma_io *>(io_), nullptr,
                                     static_cast<uint32_t>(kCallEqBytes), &got);
    if (n < 0) drain_eq();
#endif
}

void PlSide::discard_expert() {
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (!io_ || !cfg_.expert_enable) return;
    uint32_t got = 0;
    const long n = pl_dma_io_expert_recv(static_cast<pl_dma_io *>(io_), nullptr,
                                         static_cast<uint32_t>(kCallExpBytes), &got);
    if (n < 0) drain_expert();
#endif
}

void PlSide::emit_group(const std::vector<size_t> &slots,
                       const std::vector<std::vector<float>> &logits, int shift,
                       PlTtaState &st, PlResult &r) {
    if (slots.empty()) return;
    std::vector<float> vals(slots.size());
    std::vector<float> med(kNumClasses, 0.0f);
    int agree = static_cast<int>(slots.size());
    for (size_t c = 0; c < kNumClasses; ++c) {
        for (size_t j = 0; j < slots.size(); ++j) vals[j] = logits[slots[j]][c];
        med[c] = median_f(vals);
        if (slots.size() > 1) {
            int a = 0;
            for (float v : vals) {
                if (v == med[c]) ++a;
            }
            agree = std::min(agree, a);
        }
    }

    if (slots.size() > 1) {
        st.agree_min = std::min(st.agree_min, agree);
        // shift 0 那轮和旧版逐位一致，按配置的严格阈值查；
        // 其余平移装在同一批里，实测相同的输入也会有个别槽不同
        // （eq 那 4 个 shift 0 槽就只对上 3 个），只要够多数就能信中位数。
        const int need =
            (shift == 0)
                ? std::min(cfg_.min_agree_frames, static_cast<int>(slots.size()))
                : static_cast<int>(slots.size() / 2 + 1);
        if (need > 0 && agree < need) {
            if (r.error.empty()) {
                r.error = "PL 复制帧 logits 不一致（shift " + std::to_string(shift) +
                          "，最少仅 " + std::to_string(agree) + " 帧与中位数相同，阈值 " +
                          std::to_string(need) + "）";
            }
            return;
        }
    }

    std::vector<float> probs;
    std::string serr;
    if (!softmax_logits(med, probs, serr)) {
        if (r.error.empty()) r.error = serr;
        return;
    }
    for (size_t c = 0; c < kNumClasses; ++c) st.acc[c] += probs[c];
    ++st.good;
    for (size_t c = 0; c < kNumClasses; ++c) last_logits_[c] = med[c];
#if defined(IMPL_HAS_PL_DMA) && IMPL_HAS_PL_DMA
    if (st.dump_this) {
        // 诊断：逐帧逐平移打印 20 个 logits（LCWT 头输出），和参考对拍。
        std::string line = "[PLDBG] f" + std::to_string(st.this_frame) +
                           " shift=" + std::to_string(shift) +
                           " agree=" + std::to_string(agree) + " logits=";
        for (size_t c = 0; c < kNumClasses; ++c) {
            if (c) line += ',';
            line += std::to_string(last_logits_[c]);
        }
        spdlog::info("{}", line);
    }
#endif
}

void PlSide::finalize(PlTtaState &st, PlResult &r) const {
    r.shifts_ok = st.good;
    r.shifts_total = st.shift_groups;
    if (!st.opts.head) {
        // 快速模式：PL 这一路不产生 logits，本帧唯一的产出是 eq（XF 的输入）。
        // 成败就按 eq 判，重发逻辑（pl_infer）也按 ok 走同一条路。
        r.ok = r.eq_ok;
        if (r.eq_error.empty() && cfg_.eq_enable && !r.eq_ok) {
            r.eq_error = "未收到 shift 0 的均衡输出";
        }
        if (!r.ok && r.error.empty()) {
            r.error = r.eq_error.empty() ? "eq 不可用" : r.eq_error;
        }
        return;
    }
    if (st.good == 0) {
        if (r.error.empty()) r.error = "PL 所有平移前向都失败";
        return;
    }

    r.probs.assign(kNumClasses, 0.0f);
    for (size_t c = 0; c < kNumClasses; ++c) {
        r.probs[c] = static_cast<float>(st.acc[c] / static_cast<double>(st.good));
    }
    r.frames_agree = st.agree_min;
    r.eq_frames_agree = st.eq_agree;
    r.ok = (st.good == r.shifts_total);
    if (!r.ok && r.error.empty()) {
        r.error = "PL 平移 TTA 只成功 " + std::to_string(st.good) + "/" +
                  std::to_string(r.shifts_total) + " 次";
    }
    if (r.eq_error.empty() && cfg_.eq_enable && !r.eq_ok) {
        r.eq_error = "未收到 shift 0 的均衡输出";
    }
    if (r.expert_error.empty() && cfg_.expert_enable && !r.expert_ok) {
        r.expert_error = "未收到 shift 0 的专家特征";
    }
}

PlResult PlSide::infer(const float *raw, size_t n_complex, const PlWorkOpts &opts) {
    PlTtaState st;
    PlResult r = infer_a(raw, n_complex, st, opts);
    if (st.do_b) infer_b(st, r);
    return r;
}

PlResult PlSide::infer_a(const float *raw, size_t n_complex, PlTtaState &st,
                         const PlWorkOpts &opts) {
    const auto t0 = std::chrono::steady_clock::now();
    PlResult r;
    st = PlTtaState{};
    st.opts = opts;

    if (!io_) {
        r.error = "PL DMA 未打开";
        return r;
    }
    if (n_complex != kSegLen) {
        r.error = "PL 只支持 256 个复点/帧，收到 " + std::to_string(n_complex);
        return r;
    }

    // 全帧只做一次有限性/幅度检查。全零帧在 PL 里归一化成全零，logits 无意义。
    float maxabs = 0.0f;
    for (size_t i = 0; i < kSegLen * 2; ++i) {
        const float v = raw[i];
        if (!std::isfinite(v)) {
            r.error = "IQ 含 NaN/Inf（下标 " + std::to_string(i) + "）";
            return r;
        }
        maxabs = std::max(maxabs, std::fabs(v));
    }
    if (!(maxabs > 1e-20f)) {
        r.error = "IQ 全零或幅度低到无法量化";
        return r;
    }

    const long this_frame = frame_no_++;
    const bool dump_this = !cfg_.diag_dump.empty();

    std::vector<int> shifts = cfg_.tta_shifts;
    if (shifts.empty()) shifts.push_back(0);
    int zero_count = 0;
    for (int s : shifts) {
        if (s == 0) ++zero_count;
    }
    if (cfg_.eq_enable && zero_count != 1) {
        r.error = "eq 开启时 TTA shifts 必须恰好包含一个 0";
        return r;
    }

    // eq / 专家特征只能从「整轮 8 帧都是 shift 0」里取。所以拆两轮：
    //   第一轮 = 8 份 shift 0（eq + 专家 + shift 0 的 token）
    //   第二轮 = 其余平移装一次 xfer（eq/专家收走即扔）
    std::vector<int> nz;
    for (int s : shifts) {
        if (s != 0) nz.push_back(s);
    }
    const bool do_zero = (zero_count == 1);
    if (nz.size() > kNFrames) {
        r.error = "非零 TTA 平移最多 " + std::to_string(kNFrames) + " 个，当前 " +
                  std::to_string(nz.size());
        return r;
    }

    st.raw = raw;
    st.nz = nz;
    st.acc.assign(kNumClasses, 0.0);
    st.agree_min = static_cast<int>(kNFrames);
    st.this_frame = this_frame;
    st.dump_this = dump_this;
    st.do_b = st.opts.tta && !nz.empty();
    for (size_t slot = 0; slot < kNFrames; ++slot) st.all_slots.push_back(slot);

    // ── 第一轮：8 份 shift 0 ──
    if (do_zero) {
        ++st.shift_groups;
        for (size_t slot = 0; slot < kNFrames; ++slot) {
            quantize_shift(raw, kSegLen, 0, slot);
            r.clipped = std::max(r.clipped, last_clipped_);
        }

        long got = 0;
        std::string xerr;
        const bool xok = xfer_once(got, xerr);
        if (!xok) r.error = xerr;

        if (xok) {
            if (dump_this) {
                dump_block(dump_path(cfg_.diag_dump, this_frame, ".in"), in_buf_.data(),
                           kCallInBytes);
                dump_block(dump_path(cfg_.diag_dump, this_frame, ".out"), out_buf_.data(),
                           kCallOutBytes);
            }
            // 指纹不受 diag_dump 控制：关掉落盘测延迟时，也要能和参考对表。
            std::fprintf(stderr, "[PLHASH] f%02ld in=%016llx out=%016llx\n",
                         this_frame,
                         static_cast<unsigned long long>(fnv1a64(in_buf_.data(),
                                                                 kCallInBytes)),
                         static_cast<unsigned long long>(fnv1a64(out_buf_.data(),
                                                                 kCallOutBytes)));
        }

        if (cfg_.eq_enable) {
            if (xok) {
                std::vector<float> eq;
                int a = 0;
                std::string eerr;
                if (recv_eq(eq, a, eerr, st.all_slots)) {
                    r.eq = std::move(eq);
                    r.eq_ok = true;
                    st.eq_agree = a;
                } else {
                    r.eq_error = eerr;
                    r.eq_ok = false;
                }
                if (dump_this) {
                    dump_block(dump_path(cfg_.diag_dump, this_frame, ".eq"), eq_buf_.data(),
                               kCallEqBytes);
                }
                double s1 = 0.0;
                double s2 = 0.0;
                for (float v : r.eq) {
                    s1 += v;
                    s2 += static_cast<double>(v) * v;
                }
                const double n = static_cast<double>(r.eq.size());
                const double m = n > 0.0 ? s1 / n : 0.0;
                const double sd = n > 0.0 ? std::sqrt(std::max(0.0, s2 / n - m * m)) : 0.0;
                std::fprintf(stderr, "[PLHASH] f%02ld eq=%016llx eqstd=%.6f agree=%d\n",
                             this_frame,
                             static_cast<unsigned long long>(fnv1a64(eq_buf_.data(),
                                                                     kCallEqBytes)),
                             sd, a);
            } else {
                drain_eq();
            }
        }

        if (cfg_.expert_enable) {
            if (xok) {
                std::vector<float> ex;
                int a = 0;
                int fi = -1;
                std::string xerr2;
                if (recv_expert(ex, a, fi, xerr2)) {
                    r.expert = std::move(ex);
                    r.expert_ok = true;
                    r.expert_frames_agree = a;
                    r.expert_frame = fi;
                } else {
                    r.expert_error = xerr2;
                    r.expert_ok = false;
                }
                if (dump_this) {
                    dump_block(dump_path(cfg_.diag_dump, this_frame, ".exp"), exp_buf_.data(),
                               kCallExpBytes);
                }
                std::fprintf(stderr, "[PLHASH] f%02ld exp=%016llx xagree=%d frame=%d\n",
                             this_frame,
                             static_cast<unsigned long long>(fnv1a64(exp_buf_.data(),
                                                                     kCallExpBytes)),
                             r.expert_frames_agree, r.expert_frame);
            } else {
                drain_expert();
            }
        }

        // eq/专家 必须先收（输出口被 TREADY 反压，不收会堵住 PL），收完再跑
        // 每个槽的 LCWT 头。头是 NPU 前向，几个 ms，放在 recv 之前就可能把
        // 专家模块的输出口压住，连带拖慢下一轮 xfer。
        if (xok && st.opts.head) {
            // 8 槽全是 shift 0，token 逐字节相同 ⇒ 去重后只跑 1 次头前向；
            // 复制帧的一致性仍由 emit_group 在 logits 上比（同一份 logits，
            // 所以检查退化成「DMA 有没有把槽写花了」——正是它要查的东西）。
            std::vector<std::vector<float>> logits(kNFrames,
                                                   std::vector<float>(kNumClasses, 0.0f));
            std::string herr;
            if (!run_slots_head(st.all_slots, logits, herr)) {
                r.error = "LCWT 头所有槽都失败: " + herr;
            } else {
                emit_group(st.all_slots, logits, 0, st, r);
            }
        }

        // 专家 MLP 放在所有收帧之后跑：它是 NPU 前向，提前跑会拖住
        // 专家模块的输出口（和上面 LCWT 头同一个理由）。
        if (st.opts.expert_head && cfg_.expert_enable && r.expert_ok && expert_) {
            std::vector<float> lg(kNumClasses, 0.0f);
            std::string xh;
            if (expert_->forward(r.expert.data(), r.expert.size(), lg.data(), xh)) {
                r.expert_logits = std::move(lg);
                r.expert_head_ok = true;
            } else {
                r.expert_head_error = xh;
            }
        }
    }

    st.a_ms = std::chrono::duration<double, std::milli>(
                  std::chrono::steady_clock::now() - t0)
                  .count();
    if (!st.do_b) {
        finalize(st, r);
        r.infer_ms = st.a_ms;
    }
    return r;
}

void PlSide::infer_b(PlTtaState &st, PlResult &r) {
    const auto t0 = std::chrono::steady_clock::now();
    if (st.nz.empty()) {
        finalize(st, r);
        r.infer_ms = st.a_ms;
        return;
    }

    // ── 第二轮：其余平移装进一次 xfer ──
    {
        // 槽位：非零平移各占一帧，空槽复制最后一个平移（顺带做一致性自检）。
        std::vector<int> slot_shift(kNFrames, st.nz.back());
        for (size_t i = 0; i < st.nz.size(); ++i) slot_shift[i] = st.nz[i];

        std::vector<std::vector<size_t>> groups;
        std::vector<int> group_shift;
        for (size_t slot = 0; slot < kNFrames; ++slot) {
            size_t gi = groups.size();
            for (size_t i = 0; i < group_shift.size(); ++i) {
                if (group_shift[i] == slot_shift[slot]) {
                    gi = i;
                    break;
                }
            }
            if (gi == groups.size()) {
                group_shift.push_back(slot_shift[slot]);
                groups.emplace_back();
            }
            groups[gi].push_back(slot);
        }
        st.shift_groups += static_cast<int>(groups.size());

        for (size_t slot = 0; slot < kNFrames; ++slot) {
            quantize_shift(st.raw, kSegLen, slot_shift[slot], slot);
            r.clipped = std::max(r.clipped, last_clipped_);
        }

        long got = 0;
        std::string xerr;
        const bool xok = xfer_once(got, xerr);
        if (!xok) {
            if (r.error.empty()) r.error = xerr;
            drain_eq();
            drain_expert();
        } else {
            // 这一轮的 eq / 专家特征没人要，但下一轮 xfer 之前必须收走：
            // 专家模块的输出口被 TREADY 反压，拖着不收会堵住 PL。
            discard_eq();
            discard_expert();

            std::vector<std::vector<float>> logits(kNFrames,
                                                   std::vector<float>(kNumClasses, 0.0f));
            std::string herr;
            std::vector<size_t> all_slots(kNFrames);
            for (size_t s = 0; s < kNFrames; ++s) all_slots[s] = s;
            // 8 槽里只有 4 个不同平移（空槽复制的是最后一个平移），
            // 去重后 4 个唯一 token 一次 batch=5 前向就够。
            if (run_slots_head(all_slots, logits, herr)) {
                for (size_t i = 0; i < groups.size(); ++i) {
                    emit_group(groups[i], logits, group_shift[i], st, r);
                }
            } else if (r.error.empty()) {
                r.error = "LCWT 头所有槽都失败: " + herr;
            }
        }
    }

    finalize(st, r);
    r.infer_ms = st.a_ms +
                 std::chrono::duration<double, std::milli>(
                     std::chrono::steady_clock::now() - t0)
                     .count();
}

}  // namespace rffi
