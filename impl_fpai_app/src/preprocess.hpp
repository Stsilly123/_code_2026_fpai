// 把一帧线上的交错 IQ 变成模型要的那 512 个 float。
//
// 这一步是**逐位复刻** `Transformer_Train/src/data/dataset.py::PerSampleNorm` +
// `IQDataset.__getitem__` 里的那个转置。之所以不能省：
//
//   * PerSampleNorm **不在 ONNX 图里** —— `src/export/deploy.py::export_onnx` 只做
//     BN 折叠和 `torch.onnx.export`，没有任何归一化。图的第一层卷积直接吃归一化后的
//     iq。模型是拿归一化输入训练的，少这一步会静默掉一大截精度。
//   * 转置同理：训练时喂的是 (2, 256) 通道优先，不是 (256, 2) 交错。
//
// 两处都**不会报错**，只会让准确率莫名下降。改动前先跑 README 里的对拍。
#pragma once

#include <cmath>
#include <cstddef>

namespace rffi {

// PerSampleNorm 的 eps，一个字节都不能改（dataset.py 默认 1e-6）。
constexpr float kNormEps = 1e-6f;

// in  : 2*n 个原始实测值，交错 (I0,Q0,I1,Q1,…)
// out : 2*n 个归一化值，通道优先 [I0..I(n-1), Q0..Q(n-1)]，与 iCraft 输入张量 (1,2,n) 逐位对应
//
// mean/std 是**整段 2n 个值共用一个标量**（I 和 Q 一起算），不是逐通道算的。
// std 用总体标准差（ddof=0），即先求均值再取二阶矩，不要用样本标准差。
inline void deinterleave_normalize(const float *in, size_t n, float *out) {
    const size_t total = 2 * n;

    // 用 double 累加：Python 那边 numpy 的 pairwise 求和也是奔着「接近真值」去的，
    // 这里按顺序累加同样落在真值附近，差异量级 ~1e-7，远小于量化步长 0.0337。
    double sum = 0.0;
    for (size_t i = 0; i < total; ++i) sum += static_cast<double>(in[i]);
    const double mean = sum / static_cast<double>(total);

    double sq = 0.0;
    for (size_t i = 0; i < total; ++i) {
        const double d = static_cast<double>(in[i]) - mean;
        sq += d * d;
    }
    const double var = sq / static_cast<double>(total);
    const double stddev = std::sqrt(var);
    const double denom = stddev + static_cast<double>(kNormEps);

    // 交错 -> 通道优先。这一步就是 seg.T。
    for (size_t k = 0; k < n; ++k) {
        out[k] = static_cast<float>((static_cast<double>(in[2 * k]) - mean) / denom);          // I
        out[n + k] = static_cast<float>((static_cast<double>(in[2 * k + 1]) - mean) / denom);  // Q
    }
}

// 算出来给人看的 mean/std（启动自检用，和 Python 侧打印的对一下就知道对不对）。
struct NormStats {
    double mean;
    double stddev;
};

inline NormStats norm_stats(const float *in, size_t n) {
    const size_t total = 2 * n;
    double sum = 0.0;
    for (size_t i = 0; i < total; ++i) sum += static_cast<double>(in[i]);
    const double mean = sum / static_cast<double>(total);
    double sq = 0.0;
    for (size_t i = 0; i < total; ++i) {
        const double d = static_cast<double>(in[i]) - mean;
        sq += d * d;
    }
    return {mean, std::sqrt(sq / static_cast<double>(total))};
}

}  // namespace rffi
