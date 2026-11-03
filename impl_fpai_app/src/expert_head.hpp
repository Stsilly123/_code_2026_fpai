// 专家 MLP 的 NPU 封装（第三路：PL 定点特征 → 20 类 logits）。
//
// 来源：Transformer_Train/checkpoints/expert_mlp_rtl_noconst_20cls.pt
//   165 → 256 → 128 → 20 的三层 MLP（GELU），已用 iCraft 编成 fp16 ZG330 图。
//   部署件和口径见 Transformer_Train/deploy_artifacts/expert_mlp/README.md。
//
// 输入是 PL 侧 dma3 给的 193 个特征（Q12，PS 侧已除 4096 变成 float）。
// **只用其中 165 维**：const 组（幅度/相位直方图，第 138..165 维）在 RTL 侧
// 没有信息量（去掉 test 0.7257 vs 0.7153），部署图也就不吃它。
// 调用方按 kExpertSrcIdx 把 193 维压成 165 维再传进来。
//
// 本类内部做与训练完全一致的预处理：
//
//   z = clamp((f - μ[k]) / σ[k], -C, C) / C      ← μ/σ 来自 expert_norm_fp16.h
//   右侧补 0 到 256 维                            ← ZG330 通道对齐，权重已补零
//   NPU forward → 20 个 float logits
//
// C 必须和权重文件成对：fp16 版 C=16，int8 版 C=2。改动其中一个就重新验图。
//
// 线程：一次 forward 全程持有 npu_mutex()，和 XF / LCWT 头互斥。
#pragma once

#include <cstddef>
#include <memory>
#include <string>

#include <icraft-xir/core/network.h>
#include <icraft-xrt/core/device.h>
#include <icraft-xrt/core/session.h>

#include "expert_norm_fp16.h"

namespace rffi {

struct ExpertHeadConfig {
    std::string json;
    std::string raw;
    int src_dim = expert::kExpertSrcDim;    // PL dma3 给的维数（193）
    int feat_dim = expert::kExpertFeatDim;  // 部署图吃的前 N 维（现在 165）
    int pad_dim = 256;       // 图输入维数（第一层权重已补零）
    int num_classes = 20;
    float clamp = 16.0f;     // 与 expert_norm_fp16.h / 权重成对
};

class ExpertHead {
public:
    ExpertHead();
    ~ExpertHead();

    ExpertHead(const ExpertHead &) = delete;
    ExpertHead &operator=(const ExpertHead &) = delete;

    // device 必须活到 close() 之后。
    bool open(icraft::xrt::Device &device, const ExpertHeadConfig &cfg, bool profile,
              std::string &err);
    void close();
    bool is_open() const;

    std::string describe() const;

    // feat: src_dim(=193) 个 float（Q12 已除 4096），内部按 kExpertSrcIdx 取 165 维；
    // logits: num_classes 个 float。
    bool forward(const float *feat, size_t n, float *logits, std::string &err);

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
    ExpertHeadConfig cfg_;
    bool profile_ = false;
    bool logged_ = false;
};

}  // namespace rffi
