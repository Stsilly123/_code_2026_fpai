// XF（均衡 Transformer，五折 × 平移 TTA）与 PL（LcwtMLP）的决策级融合。
//
// 两边都已输出**同一套 20 类的概率**（各自已经对本模型的折/平移做过平均）。
// 采用的公式与 Transformer_Train/scripts/fuse_xf_pl.py 完全一致：
//
//     log p_fused(c) = (1 - w) · log p_xf(c) + w · log p_pl(c)
//
// 正式口径 w = 1/3（XF 权重是 PL 的两倍）。w=0 严格退化为纯 XF，w=1 为纯 PL。
// 注意：是 **log 概率**加权，不是 logits 相加；两者差一个常数偏移，只影响标定，
// 但这里仍按脚本口径先取 log(prob) 再融合。
#pragma once

#include <algorithm>
#include <cmath>
#include <vector>

#include "postprocess.hpp"

namespace rffi {

// 把概率转成 log 概率并加权。返回长度 n 的分数（log 域），调用方 softmax 取 top-k。
inline std::vector<float> fuse_log_prob_scores(const float *p_xf, const float *p_pl, int n,
                                               float w_pl) {
    if (n <= 0) return {};
    if (!(w_pl >= 0.0f)) w_pl = 0.0f;
    if (w_pl > 1.0f) w_pl = 1.0f;
    const float w_xf = 1.0f - w_pl;
    std::vector<float> out(static_cast<size_t>(n));
    for (int i = 0; i < n; ++i) {
        const float a = std::max(p_xf[i], 1e-12f);
        const float b = std::max(p_pl[i], 1e-12f);
        out[static_cast<size_t>(i)] = w_xf * std::log(a) + w_pl * std::log(b);
    }
    return out;
}

// 融合 + softmax top-k。
inline std::vector<TopKItem> fuse_log_prob_topk(const float *p_xf, const float *p_pl, int n,
                                                int k, float w_pl) {
    if (n <= 0 || k <= 0) return {};
    const auto fused = fuse_log_prob_scores(p_xf, p_pl, n, w_pl);
    return softmax_topk(fused.data(), n, k);
}

// ── 三路（XF + PL + 专家）──
// 与 Transformer_Train/scripts/fuse_int8_3way_20cls.py 同一公式：
//
//     log p_fused(c) = w_xf·log p_xf(c) + w_pl·log p_pl(c) + w_ex·log p_ex(c)
//
// 正式口径 0.6 / 0.2 / 0.2；权重和不必为 1（softmax 前是常数偏移，不影响 argmax，
// 但 top-k 的概率标定会变，所以配置里要求三者都是非负数、和为正）。
inline std::vector<float> fuse3_log_prob_scores(const float *p_xf, const float *p_pl,
                                                const float *p_ex, int n, float w_xf,
                                                float w_pl, float w_ex) {
    if (n <= 0) return {};
    std::vector<float> out(static_cast<size_t>(n));
    for (int i = 0; i < n; ++i) {
        const float a = std::max(p_xf[i], 1e-12f);
        const float b = std::max(p_pl[i], 1e-12f);
        const float c = std::max(p_ex[i], 1e-12f);
        out[static_cast<size_t>(i)] = w_xf * std::log(a) + w_pl * std::log(b) +
                                      w_ex * std::log(c);
    }
    return out;
}

inline std::vector<TopKItem> fuse3_log_prob_topk(const float *p_xf, const float *p_pl,
                                                 const float *p_ex, int n, int k, float w_xf,
                                                 float w_pl, float w_ex) {
    if (n <= 0 || k <= 0) return {};
    const auto fused = fuse3_log_prob_scores(p_xf, p_pl, p_ex, n, w_xf, w_pl, w_ex);
    return softmax_topk(fused.data(), n, k);
}

}  // namespace rffi
