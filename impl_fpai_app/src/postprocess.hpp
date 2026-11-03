// 网络输出是 **150 个原始 logits 的 float32**，不是概率。
//
// 依据：BY 图的最后一个算子（op 18 `Output`，v_id 1090）输入是 `@fp(32)`、shape
// `[1,150]`；`RFFITransformer.forward` 的 `self.head` 就是一个裸的
// `nn.Linear(embed_dim, num_classes)`，softmax 从来没写进图。所以这一层得自己做。
#pragma once

#include <algorithm>
#include <cmath>
#include <numeric>
#include <vector>

namespace rffi {

struct TopKItem {
    int index;
    float prob;
};

// max-subtraction softmax + 取 top-k。logits 长度 n，返回按概率降序的前 k 个。
// k 会被夹到 [0, n]；n<=0 直接返回空 —— 调用方必须自己判空（top.front() 越界是 UB）。
inline std::vector<TopKItem> softmax_topk(const float *logits, int n, int k) {
    if (n <= 0 || k <= 0) return {};

    float m = logits[0];
    for (int i = 1; i < n; ++i) m = std::max(m, logits[i]);

    double sum = 0.0;
    for (int i = 0; i < n; ++i) sum += std::exp(static_cast<double>(logits[i] - m));

    std::vector<int> idx(static_cast<size_t>(n));
    std::iota(idx.begin(), idx.end(), 0);
    if (k > n) k = n;
    std::partial_sort(idx.begin(), idx.begin() + k, idx.end(), [&](int a, int b) {
        return logits[a] > logits[b];
    });

    std::vector<TopKItem> out;
    out.reserve(static_cast<size_t>(k));
    for (int i = 0; i < k; ++i) {
        const int c = idx[static_cast<size_t>(i)];
        out.push_back({c, static_cast<float>(std::exp(static_cast<double>(logits[c] - m)) / sum)});
    }
    return out;
}

// 纯 softmax：logits → 概率（长度 n）。专家 MLP 的输出是 logits，融合前要转概率。
inline std::vector<float> softmax_probs(const float *logits, int n) {
    if (n <= 0) return {};
    float m = logits[0];
    for (int i = 1; i < n; ++i) m = std::max(m, logits[i]);
    double sum = 0.0;
    std::vector<float> out(static_cast<size_t>(n));
    for (int i = 0; i < n; ++i) {
        const double e = std::exp(static_cast<double>(logits[i] - m));
        out[static_cast<size_t>(i)] = static_cast<float>(e);
        sum += e;
    }
    for (int i = 0; i < n; ++i) out[static_cast<size_t>(i)] = static_cast<float>(out[i] / sum);
    return out;
}

// 输入已经是概率（XF/PL 两路都是概率），直接取 top-k，不再做 softmax。
inline std::vector<TopKItem> topk_from_probs(const float *probs, int n, int k) {
    if (n <= 0 || k <= 0) return {};
    if (k > n) k = n;
    std::vector<int> idx(static_cast<size_t>(n));
    std::iota(idx.begin(), idx.end(), 0);
    std::partial_sort(idx.begin(), idx.begin() + k, idx.end(),
                      [&](int a, int b) { return probs[a] > probs[b]; });
    std::vector<TopKItem> out;
    out.reserve(static_cast<size_t>(k));
    for (int i = 0; i < k; ++i) {
        const int c = idx[static_cast<size_t>(i)];
        out.push_back({c, probs[c]});
    }
    return out;
}

}  // namespace rffi
