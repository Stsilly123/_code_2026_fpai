// LCWT 分类头的 NPU 封装（LayerNorm 在 PS 侧算）。
//
// PL 侧 LcwtMLP_RFFI 裁掉了 LN/fc1/GELU/fc2/GAP/head，dma1 每帧只给 304 拍
// = 16 token × 38 维（2×int16/拍，Q4）。本类接在后面：
//
//   z = tok[t][d]（解包后 /16）
//   n = LayerNorm(z)                      ← PS 用 aux 权重算（float32）
//   NPU: head(mean_t(fc2(gelu(fc1(n)))))  ← 新图 lcwt_head_20cls_lnps_b5_ZG
//   logits = NPU 输出 + W·mean_t(z)       ← PS 加常数项
//
// 为什么 LN 不进图：原图把 LN 编成了 host 算子 Sqrt/Div，板端 aarch64 的
// libicraft_hostbackend.so 没注册这两个算子，apply() 会抛
//   "Op is NOT bound to any backend, op_id = 7, type_key = icraft::xir::SqrtNode"。
// 拆图后新图只剩 21 个 @zhuget(330) 硬算子 + Input/Output。
//
// 等价性（head 是仿射的）：
//   head(mean(z + δ)) = head(mean z) + head(mean δ)
//                     = [W·mean z] + [NPU 输出]
// 所以 PS 只补一项 W·mean z，不加 bias —— 图里的 head 已经带过一次 bias。
//
// 线程：一次 forward 全程持有 npu_mutex()，和 XF 互斥；详见 npu_lock.hpp。
#pragma once

#include <cstddef>
#include <memory>
#include <string>
#include <vector>

#include <icraft-xir/core/network.h>
#include <icraft-xrt/core/device.h>
#include <icraft-xrt/core/session.h>

namespace rffi {

struct LcwtHeadConfig {
    std::string json;
    std::string raw;
    std::string aux;           // LN(γ,β) + head(W,b)
    int input_dim = 608;       // 16 × 38（一行）
    int num_classes = 20;
    int tokens = 16;
    int dim = 38;
    // 图输入的固定 batch。1 = 一次一个平移；5 = 一次算 5 个平移（部署用，
    // 见 icraft_work/lcwt_head_20cls_lnps_b5_zg.toml）。必须和 json 的输入
    // shape 一致，open() 会核。
    int batch = 1;
};

class LcwtHead {
public:
    LcwtHead();
    ~LcwtHead();

    LcwtHead(const LcwtHead &) = delete;
    LcwtHead &operator=(const LcwtHead &) = delete;

    // device 必须活到 close() 之后。
    bool open(icraft::xrt::Device &device, const LcwtHeadConfig &cfg, bool profile,
              std::string &err);
    void close();
    bool is_open() const;

    std::string describe() const;

    // tok: input_dim 个 float（已反量化，原始 token）；logits: num_classes 个 float。
    // LN 与常数项都在内部处理，调用方拿到的就是整头 logits。
    bool forward(const float *tok, size_t n, float *logits, std::string &err);

    // 一次前向算 rows 行（rows ≤ cfg_.batch），toks 行主序 rows×input_dim。
    // 不足 batch 的行在图内用第 0 行补（结果丢弃）。logits 只要 rows×num_classes。
    // rows == 1 时与 forward() 逐位一致。
    bool forward_batch(const float *toks, int rows, float *logits, std::string &err);

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
    LcwtHeadConfig cfg_;
    bool profile_ = false;
    bool logged_ = false;
};

}  // namespace rffi
