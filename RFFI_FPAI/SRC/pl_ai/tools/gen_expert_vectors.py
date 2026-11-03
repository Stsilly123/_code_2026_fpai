#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成 PL 专家特征（193 维）的定点 golden、RTL 常数头和测试向量。

口径与 Float 参考（Transformer_Train/scripts/expert_feature_probe_20cls.py）
逐项对齐，但所有运算按 RTL 的整数顺序做，方便 TB 逐位比对：

  输入 x/q : Q10 int16 (code)
  rms      : Q10 (CORDIC sqrt，最近偶数)
  1/rms    : Q20
  zn       : Q12 int16
  FFT 输入 : zn Q12；IP 输出 25 bit（bit-reversed）；P=re^2+im^2
  log2     : Q16（64 bit 前导零 + 1024 项尾数 LUT + 线性插值）
  特征     : int32 Q12

输出（默认 SRC/pl_ai/tb/vector/）：
  expert_in.hex    8 帧 ×256 字 {Q[31:16],I[15:0]}
  expert_gold.hex  8 帧 ×256 字（193 特征 + 头 + 0）
  gold_*.hex       中间量（rms/zn/fft/dwt/hist/cum/cfo/power）
expert_rom.vh 写到 SRC/pl_ai/expert/，log2_lut.coe 也一并重生成。

用法：
  D:/Anaconda3/python.exe SRC/pl_ai/tools/gen_expert_vectors.py
  ... --inputs D:/FPGA/FPGA/impl_fpai_app/samples/frames.bin --nframe 8
  ... --fft-capture SRC/pl_ai/tb/vector/fft_cap.hex   # 用 IP 实测输出做 FFT golden
"""
from __future__ import annotations

import argparse
import json
import math
import os
import random
import sys
from typing import List, Tuple

import numpy as np

# ----------------------------------------------------------------------------
# 常数（与 RTL 共用，统一在这里算，expert_rom.vh 里再落成 localparam）
# ----------------------------------------------------------------------------
LN2_Q15 = int(round(math.log(2.0) * (1 << 15)))          # 22713
LN2_Q16 = int(round(math.log(2.0) * (1 << 16)))          # 45426
LN2_Q12 = math.log(2.0) * 4096.0

LOG10LN2_Q12 = int(round(10.0 * LN2_Q12))                # log(rms) Q10→自然对数
LOG20LN2_Q12 = int(round(20.0 * LN2_Q12))                # 小波能量 Q20
LOG24LN2_Q12 = int(round(24.0 * LN2_Q12))                # 备用（能量 Q24）
LOG_EPS_WAVELET = int(round(math.log(1e-12) * 4096.0))   # -113177
LOG_EPS_FFT = int(round(math.log(1e-6) * 4096.0))        # -56588
PI_Q12 = int(round(math.pi * 4096.0))                    # 12868
Q12_ONE = 4096

RCP_236 = int(round(65536.0 / 236.0))                    # lag-20 全帧
RCP_255 = int(round(65536.0 / 255.0))                    # lag-1 全帧
RCP_44 = int(round(65536.0 / 44.0))                      # 4 个 block
RCP_DWT = [int(round(65536.0 / n)) for n in (22, 22, 38, 69, 131)]

# ----------------------------------------------------------------------------
# 基础定点算子
# ----------------------------------------------------------------------------


def sra(x: int, n: int) -> int:
    """算术右移（Python 的 >> 对负数已经是 floor）。"""
    return x >> n


def sat16(x: int) -> int:
    return -32768 if x < -32768 else (32767 if x > 32767 else x)


def sat18(x: int) -> int:
    return -131072 if x < -131072 else (131071 if x > 131071 else x)


def sat32(x: int) -> int:
    return -2147483648 if x < -2147483648 else (2147483647 if x > 2147483647 else x)


def sqrt_nearest(n: int) -> int:
    """CORDIC sqrt：无符号整数输入，最近整数输出（偶数舍入）。"""
    if n < 0:
        raise ValueError("sqrt of negative")
    if n == 0:
        return 0
    k = int(math.sqrt(float(n)))
    while k * k > n:
        k -= 1
    while (k + 1) * (k + 1) <= n:
        k += 1
    if n - k * k > k:          # 小数部分 > 0.5
        k += 1
    return k


def atan2_q12(y: int, x: int) -> int:
    """理想 atan2，输出 Q12。CORDIC 输出 Q13 后算术右移 1。"""
    if x == 0 and y == 0:
        return 0
    q13 = int(round(math.atan2(y, x) * 8192.0))
    return q13 >> 1


# log2 LUT：1024 项，lut/slope 都是 Q16
_LOG_N = 1024
_LOG_LUT = [int(round(math.log2(1.0 + i / _LOG_N) * 65536.0)) for i in range(_LOG_N)]
_LOG_SLOPE = [_LOG_LUT[i + 1] - _LOG_LUT[i] for i in range(_LOG_N - 1)]
_LOG_SLOPE.append((1 << 16) - _LOG_LUT[-1])


def log2_q16(p: int) -> int:
    """64-bit 正整数 -> log2(p) Q16，与 RTL 的 clz+1024 项 LUT 完全一致。"""
    if p <= 0:
        raise ValueError("log2_q16 requires p>0")
    e = p.bit_length() - 1
    m = p << (63 - e)                       # 64 bit，MSB=1
    idx = (m >> 53) & 0x3FF
    low = (m >> 32) & 0x1FFFFF
    return (e << 16) + _LOG_LUT[idx] + ((_LOG_SLOPE[idx] * low) >> 21)


def ln_q12(p: int, offset_q12: int = 0) -> int:
    """ln(p) Q12 = log2(p)*ln2 Q12 - offset。p>0。"""
    return ((log2_q16(p) * LN2_Q16) >> 20) - offset_q12


def cmul_q12(ar: int, ai: int, br: int, bi: int) -> Tuple[int, int]:
    """Q12 复乘 -> Q12（舍入 +2048 后算术右移 12）。不饱和。"""
    re = (ar * br - ai * bi + 2048) >> 12
    im = (ar * bi + ai * br + 2048) >> 12
    return re, im


def cmul_real_q12(a: int, br: int, bi: int) -> Tuple[int, int]:
    return ((a * br + 2048) >> 12, (a * bi + 2048) >> 12)


def hist_bins(vals: List[int], edges: List[int]) -> List[int]:
    counts = [0] * (len(edges) + 1)
    for v in vals:
        counts[sum(1 for e in edges if v >= e)] += 1
    return counts


# ----------------------------------------------------------------------------
# DWT db4
# ----------------------------------------------------------------------------
def _filt_q14(w: str, which: str) -> List[int]:
    import pywt
    c = pywt.Wavelet(w).dec_lo if which == "lo" else pywt.Wavelet(w).dec_hi
    return [int(round(float(v) * 16384.0)) for v in c]


LO_Q14 = _filt_q14("db4", "lo")
HI_Q14 = _filt_q14("db4", "hi")


def dwt_level(a: List[int], lo: List[int], hi: List[int]) -> Tuple[List[int], List[int]]:
    """Q10 输入 -> Q10 cA/cD；symmetric 整段镜像；Q14 系数，Q24 累加后 >>14。"""
    n = len(a)
    ln = (n + 7) // 2

    def ext(i: int) -> int:
        if i < 0:
            i = -i - 1
        if i >= n:
            i = 2 * n - i - 1
        return a[i]

    ca, cd = [], []
    for t in range(ln):
        acca = 0
        accd = 0
        for k in range(8):
            v = ext(2 * t + 1 - k)
            acca += lo[k] * v
            accd += hi[k] * v
        ca.append(sat18((acca + 8192) >> 14))
        cd.append(sat18((accd + 8192) >> 14))
    return ca, cd


def dwt_sums(zn: List[int]) -> List[int]:
    """5 个带的 Q24 能量和（cA4,cD4,cD3,cD2,cD1），给 RTL 对拍用。"""
    a = [int(v) for v in zn]
    sums = [0] * 5
    for level in range(1, 5):
        a, cd = dwt_level(a, LO_Q14, HI_Q14)
        if level == 4:
            sums[0] = sum(int(v) * int(v) for v in a)
        sums[5 - level] = sum(int(v) * int(v) for v in cd)
    return sums


def dwt_features(zn: List[int], ln_rms_q12: int, rms_zero: bool = False) -> List[int]:
    """在 zn(Q12) 上算 5 个带的对数能量，再加 2*log(rms) 还原 raw 口径。

    返回 cA4,cD4,cD3,cD2,cD1 的 Q12 特征（自然对数）。
    """
    a = [int(v) for v in zn]
    bands: List[List[int]] = [None] * 5    # 0=cA4,1=cD4,2=cD3,3=cD2,4=cD1
    for level in range(1, 5):
        a, cd = dwt_level(a, LO_Q14, HI_Q14)
        if level == 4:
            bands[0] = a
        bands[5 - level] = cd
    out = []
    for idx, c in enumerate(bands):
        length = len(c)
        s = sum(int(v) * int(v) for v in c)  # Q24
        rcp = (RCP_DWT[0] if length == 22 else
               RCP_DWT[2] if length == 38 else
               RCP_DWT[3] if length == 69 else RCP_DWT[4])
        mean = (s * rcp) >> 16               # Q24
        if mean == 0 or rms_zero:
            out.append(LOG_EPS_WAVELET)      # 与 log(energy_raw + 1e-12) 一致
        else:
            out.append(ln_q12(mean, LOG24LN2_Q12) + 2 * ln_rms_q12)
    return out


# ----------------------------------------------------------------------------
# 单帧定点模型
# ----------------------------------------------------------------------------
def fft_from_capture(cap: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """cap: [(re,im)] ×256 自然序（已从 bit-reversed 还原）。抓取文件是 32-bit 二补码。"""
    def sext(v):
        v = v.astype(np.int64)
        return np.where(v >= (1 << 31), v - (1 << 32), v)
    return sext(cap[:, 0]), sext(cap[:, 1])


def fixed_frame(x: np.ndarray, q: np.ndarray, fft_cap: np.ndarray | None = None):
    """输入 int16 Q10，返回 (features 193, mids dict)。"""
    x = [int(v) for v in x]
    q = [int(v) for v in q]
    n = len(x)
    assert n == 256 and len(q) == 256

    # ---- LOAD ----
    sum_x = sum(x)
    sum_q = sum(q)
    sum_sq = sum(x[i] * x[i] + q[i] * q[i] for i in range(n))   # Q20

    # ---- RMS ----
    mean_sq = sum_sq >> 8
    rms_q10 = sqrt_nearest(mean_sq)          # Q10，17 bit
    inv_q20 = 0 if rms_q10 == 0 else ((1 << 30) // rms_q10)

    # ---- ZN + m2 + az/phase ----
    zi = [0] * n
    zq = [0] * n
    m2 = [0] * n
    az = [0] * n
    ph = [0] * n
    for i in range(n):
        zi[i] = sat16((x[i] * inv_q20 + (1 << 17)) >> 18)
        zq[i] = sat16((q[i] * inv_q20 + (1 << 17)) >> 18)
        m2sum = zi[i] * zi[i] + zq[i] * zq[i]          # Q24
        m2[i] = m2sum >> 12                            # Q12（截断）
        az[i] = sqrt_nearest(m2sum)                    # Q12
        ph[i] = atan2_q12(zq[i], zi[i])                # Q12

    # ---- FFT ----
    lm = [0] * 128
    if rms_q10 == 0:
        # zn 全 0 -> 全部 |Z|=0
        for k in range(128):
            lm[k] = LOG_EPS_FFT
    else:
        if fft_cap is None:
            z = np.array(zi, dtype=np.float64) + 1j * np.array(zq, dtype=np.float64)
            Z = np.fft.fft(z)[:128]
            # 用 IP 的整数输出近似：四舍五入到整数
            re = np.round(Z.real).astype(np.int64)
            im = np.round(Z.imag).astype(np.int64)
        else:
            re, im = fft_from_capture(fft_cap)
        for k in range(128):
            p = int(re[k]) * int(re[k]) + int(im[k]) * int(im[k])
            lm[k] = LOG_EPS_FFT if p == 0 else ((log2_q16(p) * LN2_Q15) >> 20)
    lm_mean = sum(lm) >> 7
    fft_feat = [lm[k] - lm_mean for k in range(128)]

    # ---- DWT（zn Q12，I/Q 各 5 带；再加 2*log(rms) 还原 raw 能量口径）----
    if rms_q10 == 0:
        ln_rms = LOG_EPS_WAVELET
    else:
        ln_rms = ln_q12(rms_q10, LOG10LN2_Q12)
    dwt_feat = (dwt_features(zi, ln_rms, rms_q10 == 0) +
                dwt_features(zq, ln_rms, rms_q10 == 0))

    # ---- HIST ----
    amp_edges = [int(round(v * 4096.0)) for v in np.linspace(0.2, 2.5, 15)]
    ph_edges = [int(round(v * 4096.0)) for v in np.linspace(-np.pi, np.pi, 13)[1:-1]]
    ha = hist_bins(az, amp_edges)
    hp = hist_bins(ph, ph_edges)
    hist_feat = [c * 16 for c in ha] + [c * 16 for c in hp]

    # ---- CUMULANT ----
    Sz2 = [0, 0]
    Sz4 = [0, 0]
    Sz6 = [0, 0]
    Sm2z = [0, 0]
    Sm2 = 0
    Sm4 = 0
    Sm6 = 0
    for i in range(n):
        a, b = zi[i], zq[i]
        z2r, z2i = cmul_q12(a, b, a, b)
        z4r, z4i = cmul_q12(z2r, z2i, z2r, z2i)
        z6r, z6i = cmul_q12(z4r, z4i, z2r, z2i)
        m2zr, m2zi = cmul_real_q12(m2[i], a, b)
        m4 = (m2[i] * m2[i]) >> 12
        m6 = (m4 * m2[i]) >> 12
        Sz2[0] += z2r; Sz2[1] += z2i
        Sz4[0] += z4r; Sz4[1] += z4i
        Sz6[0] += z6r; Sz6[1] += z6i
        Sm2z[0] += m2zr; Sm2z[1] += m2zi
        Sm2 += m2[i]
        Sm4 += m4
        Sm6 += m6
    c20 = (Sz2[0] >> 8, Sz2[1] >> 8)
    c21 = Sm2 >> 8
    c20sq = cmul_q12(c20[0], c20[1], c20[0], c20[1])
    c40 = ((Sz4[0] >> 8) - 3 * c20sq[0], (Sz4[1] >> 8) - 3 * c20sq[1])
    c20c21 = cmul_real_q12(c21, c20[0], c20[1])
    c41 = ((Sm2z[0] >> 8) - 3 * c20c21[0], (Sm2z[1] >> 8) - 3 * c20c21[1])
    c20abs2 = ((c20[0] * c20[0] + c20[1] * c20[1]) + 2048) >> 12
    c21sq = (c21 * c21 + 2048) >> 12
    c42 = (Sm4 >> 8) - c20abs2 - 2 * c21sq
    c20x4 = cmul_q12(c20[0], c20[1], c20sq[0], c20sq[1])   # c20^3
    c20c4 = cmul_q12(c20[0], c20[1], Sz4[0] >> 8, Sz4[1] >> 8)
    c60 = ((Sz6[0] >> 8) - 15 * c20c4[0] + 30 * c20x4[0],
           (Sz6[1] >> 8) - 15 * c20c4[1] + 30 * c20x4[1])
    c21x3 = cmul_real_q12(c21sq, c21, 0)[0]
    c63 = ((Sm6 >> 8) - 9 * ((c42 * c21 + 2048) >> 12) - 6 * c21x3, 0)

    cums = [c20, c40, c41, (c42, 0), c60, (c63[0], 0)]
    cum_mag = []
    cum_ang = []
    for c in cums:
        re, im = c
        maxabs = max(abs(re), abs(im))
        s = 0
        if maxabs:
            s = max(0, maxabs.bit_length() - 14)
        rs, ims = re >> s, im >> s
        cum_mag.append(sqrt_nearest(rs * rs + ims * ims) << s)
        cum_ang.append(atan2_q12(ims, rs) if not (rs == 0 and ims == 0) else 0)
    # 实数量（c42,c63）的相位：0 或 +pi
    cum_ang[3] = 0 if cums[3][0] >= 0 else PI_Q12
    cum_ang[5] = 0 if cums[5][0] >= 0 else PI_Q12
    cum_all = cum_mag + cum_ang

    # ---- CFO ----
    R20 = [0, 0]
    R1 = [0, 0]
    BLK = [[0, 0] for _ in range(4)]
    for t in range(1, n):
        a, b = zi[t], zq[t]
        c, d = zi[t - 1], zq[t - 1]
        sr, si = cmul_q12(a, b, c, -d)
        R1[0] += sr; R1[1] += si
        if t >= 20:
            c, d = zi[t - 20], zq[t - 20]
            sr, si = cmul_q12(a, b, c, -d)
            R20[0] += sr; R20[1] += si
            u = t - 20
            if (u % 64) < 44 and (u // 64) < 4:
                bi = u // 64
                BLK[bi][0] += sr
                BLK[bi][1] += si
    def mean_c(s, rcp):
        # cmul_q12 输出已经是 Q12，均值仍为 Q12
        return ((s[0] * rcp) >> 16, (s[1] * rcp) >> 16)
    def mag_ang(re, im):
        return sqrt_nearest(re * re + im * im), atan2_q12(im, re)
    m20 = mean_c(R20, RCP_236)
    m1 = mean_c(R1, RCP_255)
    mag20, ang20 = mag_ang(*m20)
    mag1, ang1 = mag_ang(*m1)
    bangs = []
    for bb in BLK:
        mm = mean_c(bb, RCP_44)
        bangs.append(atan2_q12(mm[1], mm[0]))
    sb = sum(bangs)
    var_num = 4 * sum(v * v for v in bangs) - sb * sb
    if var_num < 0:
        var_num = 0
    var = var_num >> 4
    bstd = sqrt_nearest(var)
    cfo_feat = [ang20, mag20, ang1, mag1] + bangs + [bstd]

    # ---- POWER ----
    log_rms = ln_rms
    acc1 = sum(az)
    acc2 = sum(a * a for a in az)                  # Q24
    acc3 = sum(((a * a) >> 12) * a for a in az)    # Q24
    acc4 = sum(((a * a) >> 12) * ((a * a) >> 12) for a in az)  # Q24
    mean1 = acc1 >> 8                              # Q12
    mean2 = acc2 >> 8                              # Q24
    var_az = mean2 - mean1 * mean1
    if var_az < 0:
        var_az = 0
    std_az = sqrt_nearest(var_az)                  # Q12
    mean_az3 = acc3 >> 20                          # Q24 和 /256 /4096 -> Q12
    mean_az4 = acc4 >> 20
    mean_x = abs(sum_x >> 8) << 2
    mean_q = abs(sum_q >> 8) << 2
    pow_feat = [log_rms, std_az, mean_az3, mean_az4, mean_x, mean_q]

    feats = fft_feat + dwt_feat + hist_feat + cum_all + cfo_feat + pow_feat
    if len(feats) != 193:
        raise AssertionError("feature len %d: fft %d dwt %d hist %d cum %d cfo %d pow %d"
                             % (len(feats), len(fft_feat), len(dwt_feat), len(hist_feat),
                                len(cum_all), len(cfo_feat), len(pow_feat)))
    cum_raw = [c20[0], c20[1], c40[0], c40[1], c41[0], c41[1],
               c42, c60[0], c60[1], c63[0]]
    mids = dict(rms=rms_q10, zn=list(zip(zi, zq)), fft=fft_feat, dwt=dwt_feat,
                dwt_sum=dwt_sums(zi) + dwt_sums(zq),
                hist=hist_feat, cum=cum_all, cum_raw=cum_raw,
                cfo=cfo_feat, power=pow_feat,
                az=az, ph=ph, m2=m2, lm_raw=lm, lm_mean=lm_mean)
    return feats, mids


# ----------------------------------------------------------------------------
# 输入/输出
# ----------------------------------------------------------------------------
def load_frames(path: str) -> np.ndarray:
    """frames.bin: 每帧 2080B = 32B 头 + 256×(I,Q) float32。返回 (N,256,2) 的 Q10 code。"""
    raw = open(path, "rb").read()
    fs = 2080
    n = len(raw) // fs
    out = np.zeros((n, 256, 2), dtype=np.int16)
    for i in range(n):
        a = np.frombuffer(raw[i * fs + 32:(i + 1) * fs], dtype="<f4").reshape(256, 2)
        c = np.round(a.astype(np.float64) * 1024.0)
        out[i] = np.clip(c, -32768, 32767).astype(np.int16)
    return out


def write_hex(path: str, vals, width: int = 8):
    mask = (1 << (4 * width)) - 1
    with open(path, "w", newline="\n") as f:
        for v in vals:
            f.write("%0*x\n" % (width, int(v) & mask))


def write_rom_header(path: str):
    def arr(name, vals):
        # Verilog-2001：展开成标量 localparam，避免 unpacked array
        return "".join("localparam signed [15:0] %s%d = %d;\n" % (name, i, v)
                       for i, v in enumerate(vals))
    lines = []
    lines.append("// 自动生成，勿手改：tools/gen_expert_vectors.py\n")
    lines.append("// db4 分析滤波器（pywt dec_lo/dec_hi），Q14\n")
    lines.append(arr("DB4_LO", LO_Q14))
    lines.append(arr("DB4_HI", HI_Q14))
    amp_edges = [int(round(v * 4096.0)) for v in np.linspace(0.2, 2.5, 15)]
    ph_edges = [int(round(v * 4096.0)) for v in np.linspace(-np.pi, np.pi, 13)[1:-1]]
    lines.append("// 直方图内部阈值（Q12，相等进高 bin）\n")
    lines.append(arr("HIST_AMP_E", amp_edges))
    lines.append(arr("HIST_PH_E", ph_edges))
    lines.append("// 常数\n")
    for nm, val in [("LN2_Q15", LN2_Q15), ("LN2_Q16", LN2_Q16),
                    ("LOG10LN2_Q12", LOG10LN2_Q12), ("LOG20LN2_Q12", LOG20LN2_Q12),
                    ("LOG_EPS_WAVELET", LOG_EPS_WAVELET),
                    ("LOG_EPS_FFT", LOG_EPS_FFT), ("PI_Q12", PI_Q12),
                    ("RCP_236", RCP_236), ("RCP_255", RCP_255), ("RCP_44", RCP_44)]:
        lines.append("localparam signed [31:0] %s = %d;\n" % (nm, val))
    lines.append("localparam signed [15:0] RCP_DWT_22 = %d;\n" % RCP_DWT[0])
    lines.append("localparam signed [15:0] RCP_DWT_38 = %d;\n" % RCP_DWT[2])
    lines.append("localparam signed [15:0] RCP_DWT_69 = %d;\n" % RCP_DWT[3])
    lines.append("localparam signed [15:0] RCP_DWT_131 = %d;\n" % RCP_DWT[4])
    open(path, "w", encoding="utf-8", newline="\n").write("".join(lines))


def write_coe(path: str):
    vals = [((_LOG_SLOPE[i] & 0x3FFFF) << 18) | (_LOG_LUT[i] & 0x3FFFF)
            for i in range(_LOG_N)]
    with open(path, "w", encoding="ascii", newline="\n") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        for i, v in enumerate(vals):
            f.write("%09X%s\n" % (v, "," if i + 1 < len(vals) else ";"))
    # 仿真 stub 用（COE 头不是 $readmemh 能读的格式）
    with open(path[:-4] + ".hex", "w", encoding="ascii", newline="\n") as f:
        for v in vals:
            f.write("%09X\n" % v)


# ----------------------------------------------------------------------------
def make_synthetic() -> List[Tuple[str, np.ndarray, np.ndarray]]:
    n = 256
    t = np.arange(n)
    cases = []
    cases.append(("zero", np.zeros(n, np.int16), np.zeros(n, np.int16)))
    # 最大幅度：交替 ±32767，Q 同相/正交
    cases.append(("maxamp", np.tile([32767, -32768], 128).astype(np.int16),
                  np.tile([32767, -32768], 128).astype(np.int16)))
    # 直方图边界：幅度正好落在 0.2 / 0.3643...
    e = np.linspace(0.2, 2.5, 15)
    a = np.zeros(n); q = np.zeros(n)
    for i in range(14):
        a[i] = int(round(e[i] * 1024)); q[i] = 0
    cases.append(("hist_edge", a.astype(np.int16), q.astype(np.int16)))
    # 相位 ±pi：I 负、Q 取最小正负
    a = np.full(n, -1000, np.int16)
    q = np.zeros(n, np.int16); q[0] = 1; q[1] = -1
    cases.append(("phase_pi", a, q))
    # 随机（固定种子）
    rs = np.random.RandomState(1234)
    a = rs.randint(-32768, 32767, n).astype(np.int16)
    q = rs.randint(-32768, 32767, n).astype(np.int16)
    cases.append(("random", a, q))
    return cases


def float_ref(x, q):
    """与训练脚本同口径的 float 参考（用于打印误差，不参与 golden）。"""
    import pywt
    xf = x.astype(np.float32) / 1024.0
    qf = q.astype(np.float32) / 1024.0
    z = xf + 1j * qf
    rms = np.sqrt((xf * xf + qf * qf).mean()) + 1e-12
    zn = z / rms
    az = np.abs(zn)
    Z = np.fft.fft(zn)[:128]
    lm = np.log(np.abs(Z) + 1e-6); lm -= lm.mean()
    e = []
    for ch in (xf, qf):
        e.append(np.stack([(c * c).mean() for c in pywt.wavedec(ch, "db4", level=4)]))
    dw = np.log(np.concatenate(e) + 1e-12)
    ph = np.angle(zn)
    h = lambda v, b: (np.bincount(np.digitize(v, b), minlength=len(b) + 1) / len(v))
    hist = np.concatenate([h(az, np.linspace(0.2, 2.5, 15)),
                           h(ph, np.linspace(-np.pi, np.pi, 13)[1:-1])])
    c20 = (zn * zn).mean()
    c21 = (np.abs(zn) ** 2).mean()
    c40 = (zn ** 4).mean() - 3 * c20 ** 2
    c41 = ((np.abs(zn) ** 2) * zn).mean() - 3 * c20 * c21
    c42 = (np.abs(zn) ** 4).mean() - np.abs(c20) ** 2 - 2 * c21 ** 2
    c60 = ((zn ** 6).mean() - 15 * c20 * (zn ** 4).mean() + 30 * c20 ** 3)
    c63 = ((np.abs(zn) ** 6).mean() - 9 * c42 * c21 - 6 * c21 ** 3)
    cum = [c20, c40, c41, c42, c60, c63]
    cfa = np.stack([np.abs(c) for c in cum] + [np.angle(c) for c in cum])
    cfo = []
    for lag in (20, 1):
        r = (zn[lag:] * np.conj(zn[:-lag])).mean()
        cfo += [np.angle(r), np.abs(r)]
    bl = [np.angle((zn[i * 64 + 20:(i + 1) * 64] * np.conj(zn[i * 64:(i + 1) * 64 - 20])).mean())
          for i in range(4)]
    cfo += bl + [np.std(bl)]
    pw = [np.log(rms), az.std(), (az ** 3).mean(), (az ** 4).mean(),
          abs(xf.mean()), abs(qf.mean())]
    return np.concatenate([lm, dw, hist, cfa, cfo, pw])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--inputs", default="D:/FPGA/FPGA/impl_fpai_app/samples/frames.bin")
    ap.add_argument("--nframe", type=int, default=8)
    ap.add_argument("--out", default="SRC/pl_ai/tb/vector")
    ap.add_argument("--fft-capture", default=None)
    args = ap.parse_args()

    root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
    outdir = args.out if os.path.isabs(args.out) else os.path.join(root, args.out)
    os.makedirs(outdir, exist_ok=True)
    expdir = os.path.join(root, "SRC", "pl_ai", "expert")
    os.makedirs(expdir, exist_ok=True)

    frames = load_frames(args.inputs)
    if len(frames) < args.nframe:
        raise SystemExit("输入帧不足: %d" % len(frames))
    frames = frames[:args.nframe]

    fft_cap = None
    if args.fft_capture:
        a = np.loadtxt(args.fft_capture, dtype=np.int64,
                       converters={0: lambda s: int(s, 16), 1: lambda s: int(s, 16)})
        a = a.reshape(args.nframe, 256, 2)
        if a.shape[0] != args.nframe:
            raise SystemExit("fft capture 帧数不符")
        fft_cap = a

    feats_all, mids_all = [], []
    for fi in range(args.nframe):
        x = frames[fi, :, 0].astype(np.int64)
        q = frames[fi, :, 1].astype(np.int64)
        cap = fft_cap[fi] if fft_cap is not None else None
        f, m = fixed_frame(x, q, cap)
        feats_all.append(f)
        mids_all.append(m)
        # 打印 float 参考误差（只给一眼，不作为判定）
        try:
            fr = float_ref(x, q)
            df = np.array(f, dtype=np.float64) / 4096.0
            print("frame %d: max |fixed-float| = %.4f (fft %.4f, dwt %.4f, hist %.4f)"
                  % (fi, np.max(np.abs(df - fr)), np.max(np.abs(df[:128] - fr[:128])),
                     np.max(np.abs(df[128:138] - fr[128:138])),
                     np.max(np.abs(df[138:166] - fr[138:166]))))
        except Exception as ex:
            print("frame %d: float ref skipped (%s)" % (fi, ex))

    # ---- hex 向量 ----
    din = []
    for fi in range(args.nframe):
        for i in range(256):
            wi = int(frames[fi, i, 0]) & 0xFFFF
            wq = int(frames[fi, i, 1]) & 0xFFFF
            din.append((wq << 16) | wi)
    write_hex(os.path.join(outdir, "expert_in.hex"), din)

    gold = []
    for fi in range(args.nframe):
        f = feats_all[fi]
        words = [int(v) & 0xFFFFFFFF for v in f]
        words += [0x45584631, 1, fi & 7, 12, 0]
        words += [0] * (256 - len(words))
        gold += words
    write_hex(os.path.join(outdir, "expert_gold.hex"), gold)

    # 中间量
    write_hex(os.path.join(outdir, "gold_rms.hex"),
              [m["rms"] for m in mids_all], 8)
    write_hex(os.path.join(outdir, "gold_zn.hex"),
              [(zq << 16) | (zi & 0xFFFF) for m in mids_all for (zi, zq) in m["zn"]])
    for key, nm, per in (("fft", "fft", 128), ("dwt", "dwt", 10),
                         ("dwt_sum", "dwtsum", 10),
                         ("hist", "hist", 28), ("cum", "cum", 12),
                         ("cfo", "cfo", 9), ("power", "power", 6),
                         ("cum_raw", "cumraw", 10)):
        w = 16 if key == "dwt_sum" else (12 if key == "cum_raw" else 8)
        write_hex(os.path.join(outdir, "gold_%s.hex" % nm),
                  [v for m in mids_all for v in m[key]], w)

    # ---- 常数 / LUT ----
    write_rom_header(os.path.join(expdir, "expert_rom.vh"))
    write_coe(os.path.join(expdir, "log2_lut.coe"))

    # log2 单元测试向量（p>0；p=0 由 TB 单独测 pzero）
    rng = random.Random(20261022)
    ps = [1, 2, 3, 4, 5, 7, 8, 15, 16, 17, 255, 256, 257,
          (1 << 63), (1 << 63) - 1, (1 << 63) + 1, (1 << 64) - 1]
    ps += [rng.randrange(1, 1 << 64) for _ in range(200)]
    write_hex(os.path.join(outdir, "log2_p.hex"), ps, 16)
    write_hex(os.path.join(outdir, "log2_exp.hex"),
              [log2_q16(p) for p in ps], 8)
    print("wrote %s (%d frames)" % (outdir, args.nframe))
    print("wrote %s" % os.path.join(expdir, "expert_rom.vh"))
    print("wrote %s" % os.path.join(expdir, "log2_lut.coe"))

    # ---- 合成边界用例单独落盘（给 TB 的额外用例） ----
    syn = make_synthetic()
    sdir = os.path.join(outdir, "synthetic")
    os.makedirs(sdir, exist_ok=True)
    for name, x, q in syn:
        f, m = fixed_frame(x.astype(np.int64), q.astype(np.int64))
        din = [((int(q[i]) & 0xFFFF) << 16) | (int(x[i]) & 0xFFFF) for i in range(256)]
        write_hex(os.path.join(sdir, "%s_in.hex" % name), din)
        words = [int(v) & 0xFFFFFFFF for v in f] + [0x45584631, 1, 0, 12, 0]
        words += [0] * (256 - len(words))
        write_hex(os.path.join(sdir, "%s_gold.hex" % name), words)
        write_hex(os.path.join(sdir, "%s_rms.hex" % name), [m["rms"]], 8)


if __name__ == "__main__":
    main()
