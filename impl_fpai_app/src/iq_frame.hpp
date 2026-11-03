// PS 网口 IQ 帧的**线格式定义** —— 整个协议的唯一真相。
//
// 板子做 TCP 服务端，上位机把一段 IQ 打成一帧发过来。一帧 = 一段 256 点。
//
//   ┌──────────── 32 B 定长头 ────────────┬──────── 载荷 ────────┐
//   │ magic/version/dtype/label/seq/...   │ n_complex 个复样本    │
//   └─────────────────────────────────────┴──────────────────────┘
//
// 三条必须记住的约定（写错不会报错，只会静默掉精度）：
//
// 1. **载荷是「原始未归一化」的 IQ**，量纲与 data_cache/segs.npy 一致（±30 那一档）。
//    PerSampleNorm 由板子做（见 preprocess.hpp）。发之前归一化过 = 双重归一化。
//
// 2. **载荷复样本按 I,Q 交错**（I0,Q0,I1,Q1,…）—— 真实接收机的天然输出顺序。
//    模型要的是通道优先 [I×256, Q×256]，那个转置在 preprocess.hpp 里做。
//
// 3. **全小端**。PC 和板子都是小端，但发 int16 时别用网络字节序（big-endian）打包。
#pragma once

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

namespace rffi {

// magic 的字节序列是 'R' 'F' 'I' 'Q'（0x52 0x46 0x49 0x51）。
// 小端读成 u32 就是 0x51494652。校验时比较这个整数。
constexpr uint32_t kFrameMagic = 0x51494652u;
constexpr uint16_t kFrameVersion = 1u;

// 载荷元素类型。
enum class FrameDType : uint16_t {
    Float32 = 0,  // 每个 I/Q 是 4 字节 float，一帧 2048 B
    Int16 = 1,    // 每个 I/Q 是 2 字节有符号整数，一帧 1024 B；真值 = raw * value_scale
    Command = 2,  // 控制帧（上位机 -> 板子），n_complex 必须为 0，载荷是 8 B 的 IqCommand
};

// ---------------------------------------------------------------------------
// 控制帧（上位机 -> 板子）：和 IQ 帧走同一条 TCP 连接，插在任何两帧之间。
// ---------------------------------------------------------------------------
// 32 B 头里：dtype=2、n_complex=0、seq 由上位机自增（板子用它回 ack），
// 载荷是 8 B 的 {cmd, arg}。命令不会丢帧：板子收完命令后回一帧
// status=CommandAck 的结果帧（见下），seq 原样带回。
enum class CommandId : uint32_t {
    SetMode = 1,    // arg = RunMode
    QueryMode = 2,  // 不改行为，只回 ack（ack.pred = 当前模式）
};

// 运行模式（命令设置，也可以在配置里给默认值 runtime.mode）。
enum class RunMode : uint32_t {
    Fast = 0,      // 快速：只跑 transformer（XF）一路，PL 只取均衡 IQ，不跑头/专家
    Fusion = 1,    // 聚合（默认）：XF + PL + 专家三路融合
    Analysis = 2,  // 信号分析：三路都跑，回帧给专家的 top-k，控制台打各路诊断
};

inline const char *run_mode_name(RunMode m) {
    switch (m) {
        case RunMode::Fast: return "fast";
        case RunMode::Fusion: return "fusion";
        case RunMode::Analysis: return "analysis";
    }
    return "?";
}

#pragma pack(push, 1)
struct IqCommand {
    uint32_t cmd;   // CommandId
    int32_t arg;    // SetMode: RunMode；其余命令填 0
};
#pragma pack(pop)

static_assert(sizeof(IqCommand) == 8, "IqCommand 必须是 8 字节，改字段要同步改 tools/send_cmd.py");

// 未知真值。上位机不填 label 时用它，板子就只打印不统计准确率。
constexpr int32_t kLabelUnknown = -1;

#pragma pack(push, 1)
struct IqFrameHeader {
    uint32_t magic;         // 必须 == kFrameMagic
    uint16_t version;       // 必须 == kFrameVersion
    uint16_t dtype;         // FrameDType
    int32_t  label;         // 真值类别 0..149，或 kLabelUnknown
    uint32_t seq;           // 发送端自增；板子用它发现丢帧
    uint32_t n_complex;     // 复样本数，必须 == config 里的 seg_len（256）
    float    value_scale;   // dtype=Int16 时的还原系数（真值 = raw * value_scale）；Float32 忽略
    uint64_t timestamp_ns;  // 可选，仅用于打印
};
#pragma pack(pop)

static_assert(sizeof(IqFrameHeader) == 32, "IqFrameHeader 必须是 32 字节，改字段要同步改 tools/send_iq.py");

// 一帧的载荷字节数。
inline size_t payload_bytes(const IqFrameHeader &h) {
    if (h.dtype == static_cast<uint16_t>(FrameDType::Command)) return sizeof(IqCommand);
    const size_t per_sample = (h.dtype == static_cast<uint16_t>(FrameDType::Int16)) ? 2 : 4;
    return static_cast<size_t>(h.n_complex) * 2 * per_sample;
}

// 帧头是否合法。err 收错误描述（给日志用，不合法时才有意义）。
inline bool validate_header(const IqFrameHeader &hdr, int seg_len, std::string &err) {
    if (hdr.magic != kFrameMagic) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "magic 0x%08X", hdr.magic);
        err = std::string("magic 不对（") + buf + "，期望 0x51494652）";
        return false;
    }
    if (hdr.version != kFrameVersion) {
        err = "version 不对（" + std::to_string(hdr.version) + "，期望 1）";
        return false;
    }
    if (hdr.dtype == static_cast<uint16_t>(FrameDType::Command)) {
        // 控制帧：没有 IQ 载荷，只跟 8 B 的 {cmd, arg}。
        if (hdr.n_complex != 0) {
            err = "控制帧的 n_complex 必须是 0，收到 " + std::to_string(hdr.n_complex);
            return false;
        }
        return true;
    }
    if (hdr.dtype != static_cast<uint16_t>(FrameDType::Float32) &&
        hdr.dtype != static_cast<uint16_t>(FrameDType::Int16)) {
        err = "dtype 不认识（" + std::to_string(hdr.dtype) +
              "，只有 0=f32 / 1=int16 / 2=命令）";
        return false;
    }
    if (static_cast<int>(hdr.n_complex) != seg_len) {
        err = "n_complex 是 " + std::to_string(hdr.n_complex) + "，本模型要求 " +
              std::to_string(seg_len);
        return false;
    }
    return true;
}

// 载荷 -> 2*seg_len 个 float，交错 (I0,Q0,I1,Q1,…)。int16 载荷按 value_scale 还原。
inline bool decode_payload(const IqFrameHeader &hdr, const char *payload, size_t nbytes,
                           int seg_len, std::vector<float> &out) {
    const size_t want = payload_bytes(hdr);
    if (nbytes < want) return false;
    out.resize(static_cast<size_t>(seg_len) * 2);

    if (hdr.dtype == static_cast<uint16_t>(FrameDType::Float32)) {
        std::memcpy(out.data(), payload, want);
    } else {
        const int16_t *p = reinterpret_cast<const int16_t *>(payload);
        const float s = hdr.value_scale;
        for (size_t i = 0; i < out.size(); ++i) out[i] = static_cast<float>(p[i]) * s;
    }
    return true;
}

// ---------------------------------------------------------------------------
// 回程：推理结果（板子 -> 上位机），和请求帧走**同一条** TCP 连接
// ---------------------------------------------------------------------------
// 一帧请求配一帧结果，按 seq 对齐。全小端、定长头 + k 个 top-k 条目：
//
//   ┌──────────── 40 B 定长头 ────────────┬── k × 8 B ──┐
//   │ magic/status/seq/label/pred/...     │ top-k 条目   │
//   └─────────────────────────────────────┴──────────────┘
//
// status 让上位机能区分「有信号但没把握」和「根本没信号」：
//   Ok(0)        正常，k = input.topk，条目按概率降序
//   NoSignal(1)  判为无信号（只有配了 input.signal_min_std 才会出现）：
//                若 skip_nosignal=true 则跳过前向、k=0；否则照常给 top-k
//   Error(2)     本帧出错（前向失败等），k=0，连接不复用
//   Analysis(3)  分析模式：k 条 = 专家 top-k，后面跟一块 IqAnalysis（见文件末尾）
//   CommandAck(4) 对控制帧（dtype=2）的应答，pred = 当前 RunMode
constexpr uint32_t kResultMagic = 0x4F494652u;  // 'R' 'F' 'I' 'O'
constexpr uint16_t kResultVersion = 2u;         // 2026-10 加回程，从 2 起

enum class ResultStatus : uint16_t {
    Ok = 0,
    NoSignal = 1,
    Error = 2,
    // 分析模式：k 条 = 专家这一路的 top-k，后面紧跟一块 IqAnalysis（见下）。
    Analysis = 3,
    // 控制帧（dtype=2）的应答：pred = 当前 RunMode，label = 回显的命令号。
    // 命令不被接受时回 Error（pred=-1）。
    CommandAck = 4,
};

#pragma pack(push, 1)
struct IqResultHeader {
    uint32_t magic;         // 必须 == kResultMagic
    uint16_t version;       // 必须 == kResultVersion
    uint16_t status;        // ResultStatus
    uint32_t seq;           // 回显请求帧的 seq
    int32_t  label;         // 回显请求帧的 label（-1 = 上位机没填真值）
    int32_t  pred;          // top-1 类别下标 0..149；status != Ok 时 -1
    float    prob;          // top-1 概率；status != Ok 时 0
    uint32_t latency_us;    // 本帧耗时（收完到出结果），微秒
    uint16_t k;             // 后面跟几条 IqTopKEntry（0..input.topk）
    uint16_t reserved;      // 0
    uint64_t timestamp_ns;  // 回显请求帧的 timestamp_ns，方便上位机对齐自己的流水
};

// top-k 的一条：类别下标 + 概率（已 softmax）。
// 只发下标不发名字 —— 名字是 150 行文本，让上位机自己读 names/class_names.txt，
// 免得每帧多背 20 字节且两边名字表不同步。
struct IqTopKEntry {
    uint32_t class_idx;
    float    prob;
};
#pragma pack(pop)

static_assert(sizeof(IqResultHeader) == 40, "IqResultHeader 必须是 40 字节");
static_assert(sizeof(IqTopKEntry) == 8, "IqTopKEntry 必须是 8 字节");

// 一帧结果的字节数。
inline size_t result_bytes(uint16_t k) {
    return sizeof(IqResultHeader) + static_cast<size_t>(k) * sizeof(IqTopKEntry);
}

// ---------------------------------------------------------------------------
// 分析模式（status = Analysis）的附加块：紧跟在 top-k 条目后面
// ---------------------------------------------------------------------------
// 「分析模式」不看最终预测，而是把板子这一帧看到的信号本身交给上位机：
//   原始 IQ（星座图）、均衡后 IQ（均衡后的星座图）、归一化频谱（FFT 幅度）、
//   专家那一路的 193 维特征（专家模型的输入：FFT/星座/累积量/CFO/功率），
//   以及 XF / PL / 专家三路各自的 20 类概率（对照用）。
//
// 布局：40 B 的 IqAnalysisHeader，后面按 **flags 的位序** 依次跟各段 float32：
//   bit0 raw → bit1 eq → bit2 fft → bit3 feat → bit4 pl → bit5 xf → bit6 ex
// 段长就是头里的 n_*，所以上位机只要按 flags 顺序读一遍就能对齐。
// fft 用哪路信号算由 bit7 说明：置位 = 均衡后 IQ，清零 = 原始 IQ。
constexpr uint32_t kAnalysisMagic = 0x41494652u;  // 'R' 'F' 'I' 'A'
constexpr uint16_t kAnalysisVersion = 1u;

enum AnalysisFlags : uint16_t {
    kAnaRaw = 1u << 0,      // n_raw 个 float，I/Q 交错（= 星座图）
    kAnaEq = 1u << 1,       // n_eq 个 float，均衡后 I/Q 交错
    kAnaFft = 1u << 2,      // n_fft 个 |FFT|，自然顺序（DC 在 0，无 fftshift）
    kAnaFeat = 1u << 3,     // n_feat 维专家特征（Q12 反量化后的 float）
    kAnaPl = 1u << 4,       // 20 类 PL 概率
    kAnaXf = 1u << 5,       // 20 类 XF 概率
    kAnaEx = 1u << 6,       // 20 类专家 MLP 概率
    kAnaFftSrcEq = 1u << 7, // fft 是均衡后 IQ 算的（否则是原始 IQ）
};

#pragma pack(push, 1)
struct IqAnalysisHeader {
    uint32_t magic;      // kAnalysisMagic
    uint16_t version;    // kAnalysisVersion
    uint16_t flags;      // AnalysisFlags
    uint32_t n_raw;      // 512（2 × seg_len）或 0
    uint32_t n_eq;       // 512 或 0
    uint32_t n_fft;      // 256 或 0
    uint32_t n_feat;     // 193 或 0
    uint32_t n_pl;       // 20 或 0
    uint32_t n_xf;       // 20 或 0
    uint32_t n_ex;       // 20 或 0
    uint32_t reserved;   // 0
};
#pragma pack(pop)

static_assert(sizeof(IqAnalysisHeader) == 40, "IqAnalysisHeader 必须是 40 字节");

// 按 flags 顺序数一遍段长（上位机/板端共用同一份口径）。
inline size_t analysis_floats(const IqAnalysisHeader &h) {
    size_t n = 0;
    if (h.flags & kAnaRaw) n += h.n_raw;
    if (h.flags & kAnaEq) n += h.n_eq;
    if (h.flags & kAnaFft) n += h.n_fft;
    if (h.flags & kAnaFeat) n += h.n_feat;
    if (h.flags & kAnaPl) n += h.n_pl;
    if (h.flags & kAnaXf) n += h.n_xf;
    if (h.flags & kAnaEx) n += h.n_ex;
    return n;
}

inline size_t analysis_bytes(const IqAnalysisHeader &h) {
    return sizeof(IqAnalysisHeader) + analysis_floats(h) * sizeof(float);
}

}  // namespace rffi
