// PL 侧的数据通路封装：
//   dma0/dma1  LcwtMLP_RFFI（已裁掉 MLP/head）→ 每帧 304 拍 token
//   dma2       均衡后 IQ（XF 的输入）
//   dma3       专家特征（193 维 int32 Q12 + 5 字头）
//
// LCWT 头现在在 NPU：dma1 收到的是 16×38 的 Q4 token（2×int16/拍），
// 本类解包成 float（除以 token_divisor）后逐槽喂给 LcwtHead，得到 20 类 logits。
//
// 数据契约（`FPAI_PL/RFFI_FPAI/sw/pl_dma_io/README.md` + `IP改动说明_20261022.md`）：
//
//   进 8192 B = 8 帧 × 256 字；每个 32bit 字 [15:0]=I、[31:16]=Q，**Q10**。
//   出 dout 9728 B = 8 帧 × 1216 B：
//       每帧 304 拍，拍 b = t*19 + j（t=0..15，j=0..18）
//       低 16 位 = tok[t][2j]，高 16 位 = tok[t][2j+1]，都是 int16、Q4
//       物理 token = code / 16（PL 的 TOK_OUT_SHIFT=4）
//       TLAST 在每帧第 303 拍；旧版的 10 拍 logits 已删除。
//   eq 8192 B = 8 帧 × 1024 B；每拍 {Q[31:16], I[15:0]}，两个 int16、Q10。
//   expert 8192 B = 8 帧 × 1024 B；每帧 256 字：
//       0..192 = 193 个 int32 Q12；193 = magic "EXF1"；194 = 版本；195 = 帧号；
//       196 = 12；197 = flags；198..255 = 0。
//       专家特征只对 shift 0 / 每帧第一份有意义；第一轮收，第二轮排空。
//
// 一次调用 = 8 帧，而本工程是「网口一条消息一帧」。TTA 因此拆成**两轮 xfer**：
//
//   第一轮：8 帧全是 shift 0 —— eq 从这里取，shift 0 的 token 也从这里取。
//   第二轮：其余平移各占一槽，空槽复制最后一个平移；这一轮 eq/专家收走即扔。
//
// 两轮之间没有依赖：第二轮的 logits 不喂 XF。所以 overlap_xf=true 时第二轮
// 交给工作线程，与主线程的 XF 并行（见 infer_a/infer_b）。
//
// NPU：LCWT 头一次 forward 算一批槽（部署图输入 [5,608]）。同一轮里的槽先按
// token 内容去重（同平移的复制帧逐字节相同），唯一行打包成一次前向 —— 一轮
// xfer 只花 1 次 NPU 前向。调用时持 npu_mutex()，和 XF 的 forward 串行
// （ZG330 只有一个 NPU，另一路在 PL 工作线程上）。
#pragma once

#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <vector>

#include <icraft-xrt/core/device.h>

#include "expert_head.hpp"
#include "lcwt_head.hpp"

namespace rffi {

struct PlConfig {
    bool enable = true;
    bool required = true;             // 打不开就退出（true）还是关掉 PL（false）
    bool fallback_to_xf = true;       // 单帧 PL 失败时用 XF 结果继续服务
    std::string udmabuf = "udmabuf0";
    uint64_t dma0_base = 0x80400000ull;   // MM2S
    uint64_t dma1_base = 0x80410000ull;   // S2MM(dout/token)
    uint64_t dma2_base = 0x80420000ull;   // S2MM(eq)；0 = 不用均衡通路
    uint64_t dma3_base = 0x80430000ull;   // S2MM(expert)；0 = 不用专家通路
    int timeout_ms = 5000;
    int total_timeout_ms = 15000;

    // XF 的输入来自 dma2，所以部署口径下这里必须 true。
    bool eq_enable = true;
    // 每轮 xfer 后收一次 dma3，避免专家模块的输出口被反压堵住。
    bool expert_enable = true;

    // 专家 MLP（NPU）：dma3 的 193 维特征 → 20 类 logits。第三路融合用。
    // 部署件与预处理口径见 Transformer_Train/deploy_artifacts/expert_mlp/。
    std::string expert_json = "./imodel/expert/expert_mlp_20cls_fp16_ZG.json";
    std::string expert_raw = "./imodel/expert/expert_mlp_20cls_fp16_ZG.raw";
    float expert_clamp = 16.0f;       // 与 expert_norm_fp16.h / fp16 权重成对

    // LCWT 头（NPU）。PL 已经不算 logits，头缺失时 PL 这一路没有输出。
    // 图里**没有 LayerNorm**：LN 由 PS 用 head_aux 的权重算好再喂进去。
    // 原图（lcwt_head_20cls_fp16_ZG）的 LN 被编成 host 算子 Sqrt/Div，板端
    // HostBackend 没注册这两个算子，上板 apply() 必挂。
    std::string head_json = "./imodel/lcwt_head/lcwt_head_20cls_lnps_ZG.json";
    std::string head_raw = "./imodel/lcwt_head/lcwt_head_20cls_lnps_ZG.raw";
    // LN 的 γ/β + head 的 W/b：PS 算 LN 和常数项 head(mean z) - b 用。
    std::string head_aux = "./imodel/lcwt_head/lcwt_head_20cls_aux.bin";
    // token 反量化除数：PL 的 TOK_OUT_SHIFT=4 → Q4 → 16；
    // 改成 3 → Q5 → 32；改成 2 → Q6 → 64。**必须和 PL 侧一致。**
    float token_divisor = 16.0f;

    // LCWT 头图的固定 batch。部署图是 [5,608]（一次算 5 行 token），
    // 1 = 旧图 [1,608]。必须和图一致，LcwtHead::open() 会核。
    int head_batch = 1;

    // PL 的圆周平移 TTA。与 Transformer_Train/scripts/collect_pl_logits.py --tta 的
    // shifts 一致；空 = 不做 TTA（只跑 shift 0）。eq_enable 时列表里必须有 0。
    std::vector<int> tta_shifts{-2, -1, 0, 1, 2};

    // 第一轮 8 份 shift 0 里至少几帧与逐类中位数一致。正常应是 8。
    int min_agree_frames = 4;
    // eq 的 8 帧同样自检（整轮都是 shift 0，相同输入应完全一致）。
    int min_eq_agree_frames = 4;

    // true = PL 的第二轮（非零平移）交给工作线程，与 XF 并行跑。
    bool overlap_xf = true;

    // true = 跨帧流水：整轮 PL（A+B）丢给工作线程，和「上一帧」的 XF 并行。
    // 只在 XF 也打开时生效；关掉就退回 overlap_xf 那条老路径。
    bool cross_frame = true;

    std::string weights_hash;         // 仅用于日志（与 HLS 权重对账）

    // 诊断导出：非空时，第一轮把 8192 B 输入、9728 B dout、8192 B eq、
    // 8192 B 专家特征写成 <prefix>_fNN.in/.out/.eq/.exp，并打 [PLDBG] 的 20 个
    // logits（float）。测延迟时留空。
    std::string diag_dump;
};

struct PlResult {
    bool ok = false;                  // PL 头输出可用（与 eq/专家是否成功无关）
    std::string error;                // ok=false 时的原因
    std::string eq_error;             // eq 失败原因（ok 仍可为 true）
    std::string expert_error;         // 专家失败原因（ok 仍可为 true）
    std::vector<float> probs;         // num_classes 个概率（PL TTA 平均）
    std::vector<float> eq;            // 2*seg_len 个交错 float（Q10 反量化）
    bool eq_ok = false;
    int eq_frames_agree = 0;

    std::vector<float> expert;        // 193 维专家特征（Q12 反量化）
    bool expert_ok = false;
    std::vector<float> expert_logits; // 20 个 logits（专家 MLP 前向结果）
    bool expert_head_ok = false;      // expert_logits 可用
    std::string expert_head_error;    // 头前向失败原因（特征本身仍可能可用）
    int expert_frames_agree = 0;
    int expert_frame = -1;            // 所选帧的批内帧号（0..7）

    // 复制帧（shift 0 那几槽）逐类一致数的最小值；单槽平移没有可比的副本。
    int frames_agree = 0;
    int clipped = 0;                  // 本帧量化到 int16 时饱和的样本数（诊断）
    int shifts_ok = 0;
    int shifts_total = 0;
    double infer_ms = 0.0;            // 含 LCWT 头 NPU 前向
};

// 每一帧要 PL 做多少事。快速模式只要 eq（XF 的输入），头和 TTA 都关掉。
// eq / 专家特征本身照收 —— 它们挂在 PL 的输出口上，不收会把流水堵住。
struct PlWorkOpts {
    bool head = true;         // 跑 LCWT 头（PL 这一路的 logits）
    bool expert_head = true;  // 跑专家 MLP（第三路 logits）
    bool tta = true;          // 跑第二轮（非零平移）。false = 只跑 shift 0
};

// infer_a / infer_b 之间传递的中间状态。两段之间只有**同一个线程**能碰它，
// 典型用法是 A 在主线程、B 在工作线程，A 返回后主线程不再动它。
struct PlTtaState {
    PlWorkOpts opts{};                // 本帧做哪些活（见上）
    const float *raw = nullptr;       // 本帧 2*256 个交错 IQ（调用方保证活到 B 跑完）
    std::vector<int> nz;              // 非零平移列表（第二轮要跑的）
    std::vector<size_t> all_slots;    // 0..7
    std::vector<double> acc;          // 已成功的平移概率累加
    int good = 0;                     // 成功的平移组数
    int agree_min = 0;                // 复制帧逐类一致数的最小值
    int eq_agree = 0;
    int shift_groups = 0;
    long this_frame = 0;              // 诊断导出用
    bool dump_this = false;
    bool do_b = false;                // 是否还需要第二轮
    double a_ms = 0.0;                // 第一轮耗时
};

class PlSide {
public:
    explicit PlSide(PlConfig cfg);
    ~PlSide();

    PlSide(const PlSide &) = delete;
    PlSide &operator=(const PlSide &) = delete;

    // 打开 DMA 和 LCWT 头的 NPU Session。device 必须活到 close() 之后。
    bool open(icraft::xrt::Device &device, std::string &err);
    void close();
    bool is_open() const { return io_ != nullptr; }

    std::string describe() const;

    // raw: 2*256 个交错 IQ（I0,Q0,I1,Q1,…），float，量纲与训练 cache 一致（±30 档）。
    // 失败时 ok=false；eq / 专家失败单独放在 eq_ok / expert_ok 里。
    // opts 默认全开（聚合/分析模式）；快速模式传 {head=false, expert_head=false,
    // tta=false}，此时 ok 只表示「eq 可用」。
    PlResult infer(const float *raw, size_t n_complex, const PlWorkOpts &opts = {});

    // 两段式：A 出 eq + 专家 + shift 0 的 logits（XF 只等这一半），B 补非零平移。
    PlResult infer_a(const float *raw, size_t n_complex, PlTtaState &st,
                     const PlWorkOpts &opts = {});
    void infer_b(PlTtaState &st, PlResult &r);

    // 把 dout / eq / 专家三个输出口的残帧全排空。
    // **整轮重发之前必须调**：不排空直接重发，上一轮的尾帧会混进新一轮，
    // 重发出来的 8 槽还是一致不起来（板上实测）。
    void drain_all();

    const PlConfig &config() const { return cfg_; }

private:
    // 圆周平移后量化，写进 8192 B 输入里第 slot 帧（每帧 1024 B）。
    bool quantize_shift(const float *raw, size_t n, int shift, size_t slot);
    bool xfer_once(long &got, std::string &err);

    // dout 第 slot 帧的 304 拍 -> 608 个 float token（行主序 t*38+d）。
    void read_slot_tokens(size_t slot, float *tok) const;
    // 多个槽一起过 LCWT 头：先按 token 内容去重（同平移的复制帧逐字节相同），
    // 再把唯一行按图的 batch 打包前向。logits[slot] 逐槽填好；
    // 一致性仍由 emit_group 在 logits 上比，语义与逐槽前向完全相同。
    bool run_slots_head(const std::vector<size_t> &slots,
                        std::vector<std::vector<float>> &logits, std::string &err);

    // 20 个 logits -> 概率（max-subtraction softmax）。
    bool softmax_logits(const std::vector<float> &logits, std::vector<float> &probs,
                        std::string &err) const;

    // 收 dma2 的 8 帧 eq，只取 frames 里列出的帧，按元素取中位数后反量化。
    bool recv_eq(std::vector<float> &eq, int &agree, std::string &err,
                 const std::vector<size_t> &frames);
    // 收 dma3 的 8 帧专家特征，取 magic 校验通过且逐字节重复最多的那一帧
    // （第 0 槽是专家模块的首帧暂态，不能取第一帧）。agree = 得票数。
    bool recv_expert(std::vector<float> &feat, int &agree, int &frame_idx,
                     std::string &err);
    void drain_eq();
    void drain_expert();
    // 第二轮不要 eq / 专家特征，但必须收走；给 NULL 时驱动只收不拷。
    void discard_eq();
    void discard_expert();

    // 一组槽（同一平移）-> 逐类中位数 logits -> softmax -> 累加进 st.acc。
    void emit_group(const std::vector<size_t> &slots,
                    const std::vector<std::vector<float>> &logits, int shift,
                    PlTtaState &st, PlResult &r);
    void finalize(PlTtaState &st, PlResult &r) const;

    PlConfig cfg_;
    void *io_ = nullptr;              // pl_dma_io*（不透明句柄）
    std::unique_ptr<LcwtHead> head_;  // NPU 版的 LCWT 分类头
    std::unique_ptr<ExpertHead> expert_;  // NPU 版的专家 MLP（第三路）
    std::vector<int16_t> iq_;         // 2*256，当前 shift 的量化结果
    std::vector<uint8_t> in_buf_;     // 8192
    std::vector<uint8_t> out_buf_;    // 9728
    std::vector<uint8_t> eq_buf_;     // 8192
    std::vector<uint8_t> exp_buf_;    // 8192
    std::vector<float> tok_;          // 608，当前槽的 token
    std::vector<float> last_logits_;  // 最近一个平移的 20 个 logits（诊断日志用）
    int last_clipped_ = 0;
    long frame_no_ = 0;
};

}  // namespace rffi
