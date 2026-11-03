// XF（均衡 Transformer）五折 × 圆周平移 TTA 的 NPU 集成。
//
// 输入不是原始 IQ，而是 **dma2 收上来的均衡后 IQ**（Q10，反量化成 float）。
// 每帧流程：
//   1. PerSampleNorm（图外，见 preprocess.hpp）→ 通道优先 [I×256, Q×256]；
//   2. 对每个 shift ∈ shifts：torch.roll(x, shift, dims=-1) 的同一个语义；
//   3. 每个 shift 喂给五折各一次，softmax 后按 折×shift 平均。
//
// 三种图都支持，按配置和输入 batch 选路：
//   batch=1        → 每折每平移一次前向（25 次/帧）；
//   batch=N        → N 个平移装进一次前向（5 次/帧，N 必须等于 shifts 个数）；
//   fused_folds=K  → K 折在**同一张图**里，输入 batch = K×shifts，一次前向/帧。
//     fused 图行序 fold 主序（row = fold * S + shift），与
//     Transformer_Train/scripts/fuse_xf_b5_to_b25.py 一致。
//   三种图对同一样本的 logits 已实测逐位一致（onnxruntime，五折 × 5 平移）。
//
// 读输出的顺序照 demo（yolov5_npu_actor.hpp + postprocesses.hpp）：
//   forward -> waitForReady -> device.reset(1) -> .to(Host) -> 读。
// reset(1) 解决「迟一拍」，所以 double_forward 默认关（开着只翻倍耗时）。
#pragma once

#include <cstddef>
#include <memory>
#include <string>
#include <vector>

#include <icraft-xir/core/network.h>
#include <icraft-xrt/core/device.h>
#include <icraft-xrt/core/session.h>

#include "xf_types.hpp"

namespace rffi {

class XfEnsemble {
public:
    explicit XfEnsemble(XfConfig cfg);
    ~XfEnsemble();

    XfEnsemble(const XfEnsemble &) = delete;
    XfEnsemble &operator=(const XfEnsemble &) = delete;

    // 逐折装载网络、建 Session、apply。device 必须活到 close() 之后。
    // 非 const：要按 demo 的做法 cast<FPAIDevice>() 并用该句柄 reset(1)。
    bool open(icraft::xrt::Device &device, bool profile, std::string &err);
    void close();
    bool is_open() const { return !folds_.empty(); }

    std::string describe() const;
    // 逻辑上的折数（fused 图是 fused_folds，其他等于装载的模型数）。
    size_t num_folds() const { return n_folds_; }

    // iq: 2*256 个交错 float（I0,Q0,…），来自均衡输出 / 1024。
    XfResult infer(const float *iq, size_t n_complex);

private:
    struct Fold;
    // probs 输出 batch*num_classes 个概率（每个 batch 槽各自 softmax）。
    bool forward_fold(Fold &f, float *probs, int batch, std::string &err);

    XfConfig cfg_;
    std::vector<std::unique_ptr<Fold>> folds_;
    size_t model_batch_ = 1;          // 图输入的静态批大小（由第一折的图决定）
    size_t n_folds_ = 1;              // 逻辑折数（fused 时 = cfg_.fused_folds）
    bool fused_ = false;              // 五折在同一张图里（一次前向）
    std::vector<float> norm_buf_;     // 2*seg_len，归一化后通道优先
    std::vector<float> shifted_;      // 2*seg_len，当前平移（batch=1 图用）
    std::vector<float> batch_buf_;    // batch*2*seg_len，各平移拼在一起（batch>1 图用）
    bool logged_ = false;             // 首次前向打印输出 shape/dtype

    // 分段计时（诊断）：每 32 帧打一次每次前向的均值，单位 ms。
    // fwd = forward+waitForReady，reset = reset(1)，to = .to(Host)，cpy = 输入 memcpy。
    double t_fwd_ = 0.0;
    double t_reset_ = 0.0;
    double t_to_ = 0.0;
    double t_cpy_ = 0.0;
    long t_calls_ = 0;
    int t_frames_ = 0;

    // sys.profile=true 时，第一帧结束后打印各算子的时间合计
    // （墙上时间 / 数据搬运 / 硬件计算 / 其他），用来判断 fwd 是算得慢还是调用开销。
    bool profile_ = false;
    bool profile_printed_ = false;
};

}  // namespace rffi
