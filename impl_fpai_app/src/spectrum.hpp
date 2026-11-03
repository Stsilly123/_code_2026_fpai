// 分析模式用的小工具：256 点复 FFT（基-2，原地）。
//
// 只是给上位机看频谱，**不进任何模型** —— 模型用的特征（FFT/星座/累积量…）
// 是 PL 的专家模块算的，头文件不需要和它逐位对齐。所以这里用 double 算，
// 也不加窗（加窗那条轴在训练侧已测死，别在这里"顺手"加）。
//
// 输出是**自然顺序**的幅度：mag[0] = DC，mag[1..n/2-1] = 正频率，
// mag[n/2..n-1] = 负频率。要和 matplotlib 的 fftshift 对齐由上位机自己做。
#pragma once

#include <cmath>
#include <cstddef>
#include <utility>
#include <vector>

namespace rffi {

// 原地基-2 FFT。n 必须是 2 的幂；调用方保证 re/im 长度为 n。
inline void fft_pow2(std::vector<double> &re, std::vector<double> &im) {
    const size_t n = re.size();
    if (n < 2) return;

    // 位反转置换
    for (size_t i = 1, j = 0; i < n; ++i) {
        size_t bit = n >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if (i < j) {
            std::swap(re[i], re[j]);
            std::swap(im[i], im[j]);
        }
    }

    constexpr double kPi = 3.14159265358979323846;
    for (size_t len = 2; len <= n; len <<= 1) {
        const double ang = -2.0 * kPi / static_cast<double>(len);
        const double wr = std::cos(ang);
        const double wi = std::sin(ang);
        for (size_t i = 0; i < n; i += len) {
            double cr = 1.0;
            double ci = 0.0;
            for (size_t k = 0; k < len / 2; ++k) {
                const size_t a = i + k;
                const size_t b = a + len / 2;
                const double tr = re[b] * cr - im[b] * ci;
                const double ti = re[b] * ci + im[b] * cr;
                re[b] = re[a] - tr;
                im[b] = im[a] - ti;
                re[a] += tr;
                im[a] += ti;
                const double ncr = cr * wr - ci * wi;
                ci = cr * wi + ci * wr;
                cr = ncr;
            }
        }
    }
}

// iq: 2*n_complex 个 float，交错 I/Q（与线格式一致）。mag: n_complex 个 |X(k)|。
inline void fft_magnitude(const float *iq, size_t n_complex, std::vector<float> &mag) {
    std::vector<double> re(n_complex, 0.0), im(n_complex, 0.0);
    for (size_t k = 0; k < n_complex; ++k) {
        re[k] = static_cast<double>(iq[2 * k]);
        im[k] = static_cast<double>(iq[2 * k + 1]);
    }
    fft_pow2(re, im);
    mag.resize(n_complex);
    for (size_t k = 0; k < n_complex; ++k) {
        mag[k] = static_cast<float>(std::sqrt(re[k] * re[k] + im[k] * im[k]));
    }
}

}  // namespace rffi
