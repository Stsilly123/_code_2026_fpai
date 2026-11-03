#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
L-STF 均衡器 —— 定点模型 + ROM 表 + xsim 向量生成

三件事：
  1) float 参考：照《LSTF均衡器Verilog实现指南.md》§1.3 逐行实现（median 版 = Python 事实来源）
  2) 整数模型：**RTL 的规格**。所有移位/位宽与 lstf_eq.v 一一对应；
     拿 float 参考当尺子，验证定点误差在 §9.2 的预算内
  3) 生成 lstf_eq_rom.vh + tb/eq_in.hex + tb/eq_gold.hex + tb/eq_case.hex

改 RTL 的算术 = 改这里，两边必须同步。

跑法：
    python SRC/pl_ai/tools/gen_lstf_eq_vectors.py
"""

import math
import os
import sys

# ── 算法常量（指南 §1.1）─────────────────────────────────────────────────────
K20 = [14, 15, 16, 17, 18, 19, 1, 2, 3, 4, 5, 6]     # 20 点 DFT 的 bin 号
LSTF_SIGN = [1, -1, 1, -1, -1, 1, -1, -1, 1, 1, 1, 1]
LSTF_K = [-6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6]
REG = 0.1
SNR_MIN = 3.0
N = 256
P = 20
NBLK = 10

# ── 定点参数（与 lstf_eq.v 的 localparam 一致）────────────────────────────────
SX      = 13      # DFT 累加 -> X 的右移（X 必须放进 DSP48 的 25bit A 口）
Q_TW    = 17      # DFT/IDFT 旋转因子 + p_b 的 Q 格式（18bit 有符号，P 在 DSP 端口内）
H_TGT   = 23      # 归一化后 |Hn|max 的位号（留 1bit 余量，25bit 有符号 = DSP A 口）
K_W     = 44      # Wq = W_norm * 2^K_W（压到 DSP 25bit A 口内）
T_Q     = 24      # taps_final 的 Q 格式（Q24），FIR 末级 >>(T_Q-TAP_SFT)
TAP_SFT = 13      # Q24 抽头放不进 25bit 时整帧重算并右移：Q24 -> Q11（±4096）
ATAN_Q  = 18      # CORDIC 角度 Q2.18（22bit，范围 +-4rad）
CORDIC_N = 18
CORDIC_P = 21     # CORDIC 旋转内部定点（Q21），输出右移到 Q_TW
INV_LUT_BITS = 7  # 128 项倒数 LUT
Q15 = 32767
Q13_1K = 1 << ATAN_Q
# 门控：Sp_hw = Sp_code * 2^(2*(Q_TW-SX))；float 版 11*Sp >= 180*Et
GATE_K = 180 << (2 * (Q_TW - SX))


# ════════════════════════════════════════════════════════════════════════════
#  1. 浮点参考（指南 §1.3）
# ════════════════════════════════════════════════════════════════════════════
def interp_to_20(hk):
    """hk[k] for k = -6..-1, 1..6（按 LSTF_K 顺序），返回 k=-10..9 的 20 个 bin。"""
    d = {k: hk[i] for i, k in enumerate(LSTF_K)}
    out = []
    for k in range(-10, 10):
        if k in d:
            out.append(d[k])
        elif k == 0:
            out.append((d[-1] + d[1]) / 2)
        elif k < -6:
            out.append(d[-6])
        else:                       # k = 7,8,9
            out.append(d[6])
    return out


def lstf_equalize_float(x, eps_mode="median"):
    """
    x: 长度 256 的 complex 列表（float 单位，即 int16/1024）
    eps_mode: "median" = Python 事实来源；"mean" = 硬件近似
    返回 (y, theta, snr, bypass)
    """
    if max(abs(v) for v in x) == 0:
        return x.copy(), 0.0, 0.0, True
    blocks = [x[20 * b:20 * b + 20] for b in range(NBLK)]

    # lag-20 相关（指南 §1.3 的 blocks[:,1:,:]*conj(blocks[:,:-1,:])：
    # blocks 是 (段, 块, 20)，第 1 个下标 1:/-1: 是**块**方向 -> 块间元素相关 = lag-20）
    r = 0j
    for b in range(1, NBLK):
        for n in range(P):
            r += blocks[b][n] * blocks[b - 1][n].conjugate()
    theta = math.atan2(r.imag, r.real)

    # 块对齐
    p = [complex(math.cos(-theta * b), math.sin(-theta * b)) for b in range(NBLK)]
    aligned = [[blocks[b][n] * p[b] for n in range(P)] for b in range(NBLK)]

    # 20 点 DFT（numpy: e^{-j2πkn/N}）
    def dft20(row):
        return [sum(row[n] * complex(math.cos(-2 * math.pi * k * n / P),
                                     math.sin(-2 * math.pi * k * n / P))
                    for n in range(P)) for k in range(P)]

    yb = [dft20(aligned[b]) for b in range(NBLK)]
    ls_s = [complex(1, 1) * s for s in LSTF_SIGN]
    hk = [sum(yb[b][K20[i]] for b in range(NBLK)) / NBLK / ls_s[i] for i in range(12)]
    h = interp_to_20(hk)

    Pw = [abs(v) ** 2 for v in h]
    if sum(Pw) == 0:
        return x.copy(), theta, 0.0, True
    if eps_mode == "median":
        srt = sorted(Pw)
        med = (srt[9] + srt[10]) / 2
        eps = REG * med
    else:
        eps = REG * (sum(Pw) / 20)
    w = [h[k].conjugate() / (Pw[k] + eps) for k in range(20)]

    # 20 点 IDFT（含 1/20），ifftshift：k=0 在索引 10
    wsh = w[10:] + w[:10]
    taps = [sum(wsh[j] * complex(math.cos(2 * math.pi * j * m / P),
                                 math.sin(2 * math.pi * j * m / P))
                 for j in range(20)) / 20 for m in range(20)]

    # 门控（未对齐块；|X| 与对齐无关）
    Xr = [dft20(blocks[b]) for b in range(NBLK)]
    Sp = sum(abs(Xr[b][K20[i]]) ** 2 for b in range(NBLK) for i in range(12))
    Stot = sum(abs(Xr[b][k]) ** 2 for b in range(NBLK) for k in range(20))
    So = Stot - Sp
    snr = (Sp / 120.0) / (So / 80.0) if So > 0 else float("inf")
    bypass = not (snr >= SNR_MIN)

    if bypass:
        return x.copy(), theta, snr, True

    y = [0j] * N
    for m in range(-10, 10):
        hm = taps[m % 20]
        for n in range(N):
            ind = n - m
            if ind < 0:
                ind = 200 + ind
            elif ind > 255:
                continue
            y[n] += hm * x[ind]
    return y, theta, snr, False


# ════════════════════════════════════════════════════════════════════════════
#  2. ROM 表
# ════════════════════════════════════════════════════════════════════════════
def q_clip(v, bits):
    lo, hi = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
    return max(lo, min(hi, v))


def rnd_shift(v, s):
    """与 Verilog (v + (1<<(s-1))) >>> s 一致（s>0）"""
    if s <= 0:
        return v << (-s)
    return (v + (1 << (s - 1))) >> s


def build_roms():
    QT = 1 << Q_TW
    dft = []
    for p in range(12):
        for n in range(P):
            a = -2 * math.pi * K20[p] * n / P
            c = max(-QT, min(QT - 1, int(round(math.cos(a) * QT))))
            s = max(-QT, min(QT - 1, int(round(math.sin(a) * QT))))
            dft.append((c, s))                       # 系数 = c + j s

    idft = []
    for m in range(20):
        for j in range(20):
            a = 2 * math.pi * (j - 10) * m / P
            c = max(-QT, min(QT - 1, int(round(math.cos(a) * QT))))
            s = max(-QT, min(QT - 1, int(round(math.sin(a) * QT))))
            idft.append((c, s))

    atan = []   # Q2.13
    for i in range(CORDIC_N):
        atan.append(int(round(math.atan(2.0 ** -i) * Q13_1K)))

    inv = []    # Q15 of 1/m_norm，m_norm 取区间中点 1 + (idx+0.5)/128
    for idx in range(1 << INV_LUT_BITS):
        mn = 1.0 + (idx + 0.5) / float(1 << INV_LUT_BITS)
        inv.append(min(Q15, int(round(Q15 / mn))))
    return dft, idft, atan, inv


DFT_ROM, IDFT_ROM, ATAN_ROM, INV_LUT = build_roms()


def write_rom_vh(path):
    """生成 lstf_eq.v 里用函数形式的常数表（Vivado 会综合成 ROM/LUTRAM）"""
    L = []
    L.append("// 自动生成，别手改 —— 生成器：SRC/pl_ai/tools/gen_lstf_eq_vectors.py")
    L.append("// 用法：always @(posedge clk) rom_q <= lstf_dft_rom(addr);")

    L.append("// DFT 12x20：index = p*20 + n，36bit = {cos[17:0], sin[17:0]}（Q17）")
    L.append("`define LSTF_DFT_N 240")
    L.append("function [35:0] lstf_dft_rom;")
    L.append("    input [7:0] idx;")
    L.append("    begin case (idx)")
    for i, (c, s) in enumerate(DFT_ROM):
        L.append("        %3d: lstf_dft_rom = 36'h%09x;" % (i, ((c & 0x3ffff) << 18) | (s & 0x3ffff)))
    L.append("        default: lstf_dft_rom = 36'h0;")
    L.append("    endcase end")
    L.append("endfunction")

    L.append("// IDFT 20x20：index = m*20 + j")
    L.append("`define LSTF_IDFT_N 400")
    L.append("function [35:0] lstf_idft_rom;")
    L.append("    input [8:0] idx;")
    L.append("    begin case (idx)")
    for i, (c, s) in enumerate(IDFT_ROM):
        L.append("        %3d: lstf_idft_rom = 36'h%09x;" % (i, ((c & 0x3ffff) << 18) | (s & 0x3ffff)))
    L.append("        default: lstf_idft_rom = 36'h0;")
    L.append("    endcase end")
    L.append("endfunction")

    L.append("// CORDIC atan(2^-i)，Q2.18")
    L.append("`define LSTF_ATAN_N %d" % CORDIC_N)
    L.append("function [18:0] lstf_atan;")
    L.append("    input [4:0] idx;")
    L.append("    begin case (idx)")
    for i, v in enumerate(ATAN_ROM):
        L.append("        %2d: lstf_atan = 19'd%d;" % (i, v))
    L.append("        default: lstf_atan = 19'd0;")
    L.append("    endcase end")
    L.append("endfunction")

    L.append("// 倒数 LUT：idx -> round(32767/(1+(idx+0.5)/128))，Q15")
    L.append("`define LSTF_INV_N %d" % (1 << INV_LUT_BITS))
    L.append("`define LSTF_INV_BITS %d" % INV_LUT_BITS)
    L.append("function [15:0] lstf_inv;")
    L.append("    input [6:0] idx;")
    L.append("    begin case (idx)")
    for i, v in enumerate(INV_LUT):
        L.append("        %3d: lstf_inv = 16'd%d;" % (i, v))
    L.append("        default: lstf_inv = 16'd0;")
    L.append("    endcase end")
    L.append("endfunction")

    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(L) + "\n")
    print("wrote", path)


# ════════════════════════════════════════════════════════════════════════════
#  3. 整数模型（= RTL 规格）
# ════════════════════════════════════════════════════════════════════════════
def msb(v):
    return v.bit_length() - 1 if v else -1


def cplx_mul_q(ar, ai, br, bi, q=Q_TW):
    """(ar+j ai)*(br+j bi)，Qq*Qq -> Qq，带舍入和饱和（RTL: p_b 链 18bit）"""
    r = 1 << (q - 1)
    re = (ar * br - ai * bi + r) >> q
    im = (ar * bi + ai * br + r) >> q
    return q_clip(re, q + 1), q_clip(im, q + 1)   # 18bit 有符号（DSP B 口）


def cordic_atan2(re_in, im_in, trace=None):
    """Q2.13 角度 atan2(im, re)。输入为 44bit 累加器原值。"""
    m = max(abs(re_in), abs(im_in))
    if m == 0:
        return 0
    sh = max(0, msb(m) - 17)
    x = re_in >> sh
    y = im_in >> sh
    z = 0
    for i in range(CORDIC_N):
        if y < 0:
            x, y = x - (y >> i), y + (x >> i)
            z -= ATAN_ROM[i]
        else:
            x, y = x + (y >> i), y - (x >> i)
            z += ATAN_ROM[i]
    if trace is not None:
        trace["sh"] = sh
    return z


def cordic_rot(z):
    """z(Q2.ATAN_Q) -> (cos,sin) Q_TW。初值 (1/K)*2^CORDIC_P，内部 CORDIC_P。"""
    x = int(round(0.6072529350088814 * (1 << CORDIC_P)))
    y = 0
    for i in range(CORDIC_N):
        if z >= 0:
            x, y, z = x - (y >> i), y + (x >> i), z - ATAN_ROM[i]
        else:
            x, y, z = x + (y >> i), y - (x >> i), z + ATAN_ROM[i]
    sh = CORDIC_P - Q_TW
    qmax = (1 << Q_TW) - 1
    return (min(qmax, (x + (1 << (sh - 1))) >> sh),
            max(-qmax - 1, min(qmax, (y + (1 << (sh - 1))) >> sh)))


def reciprocal_W(Hn_i, Hn_q, eps, eH, dbg=None):
    """
    Wq = conj(Hn) * 2^K_W / (|Hn|^2 + eps)，返回 40bit 有符号整数（Q(K_W) on normalized H）
    倒数：d = m*2^(e-17), 1/d = r2*2^(-15-e), r2 = Q15(1/m_norm)（2 次 Newton）
    """
    Pw = Hn_i * Hn_i + Hn_q * Hn_q
    d = Pw + eps
    if d <= 0:
        return 0, 0, 0
    e = msb(d)
    if e >= 17:
        m = d >> (e - 17)
    else:
        m = d << (17 - e)
    m &= (1 << 18) - 1                      # 18bit 无符号寄存器（bit17 恒 1）
    # 尾数 = m 的低 17 位，取高 7 位做 LUT 索引（RTL: idx = m[16:10]）
    idx = (m >> (17 - INV_LUT_BITS)) & ((1 << INV_LUT_BITS) - 1)
    r = INV_LUT[idx]

    # Newton 1、2：r <- r*(2 - m*r)，m 是 Q17
    for _ in range(2):
        t = (m * r) >> 17                   # Q15，[32768, 65536)
        u = (1 << 16) - t                   # 2 - m*r，Q15
        r = (r * u) >> 15
        r = q_clip(r, 17)
        if r <= 0:
            r = 1

    s = e - (K_W - 15)                # Hn*r*2^(e-K_W+15) -> Hn*2^K_W/d
    wr = rnd_shift(Hn_i * r, s) if s > 0 else (Hn_i * r) << (-s)
    wi = rnd_shift(-Hn_q * r, s) if s > 0 else (-Hn_q * r) << (-s)
    wr = q_clip(wr, 25)               # DSP A 口 25bit
    wi = q_clip(wi, 25)
    if dbg is not None:
        dbg.update(e=e, m=m, idx=idx, r0=INV_LUT[idx], r=r, s=s)
    return wr, wi, e


def lstf_equalize_fixed(xi, xq, trace=None):
    """
    xi,xq: 长度 256 的 int（Q10 码值，已量化）
    返回 (yi, yq, bypass, dbg)
    与 lstf_eq.v 的每一级逐一对应。
    """
    assert len(xi) == N and len(xq) == N
    dbg = {}

    # ---- LOAD/CORR：lag-20 相关 + 前 200 点能量（精确）----------------------
    rr = ri = Et = 0
    for n in range(20, 200):
        rr += xi[n] * xi[n - 20] + xq[n] * xq[n - 20]
        ri += xq[n] * xi[n - 20] - xi[n] * xq[n - 20]
    for n in range(200):
        Et += xi[n] * xi[n] + xq[n] * xq[n]
    dbg["r"] = (rr, ri)
    dbg["Et"] = Et

    # ---- CFO：atan2 + 旋转 + p_b 链 ----------------------------------------
    theta = cordic_atan2(rr, ri)
    dbg["theta"] = theta
    c, s = cordic_rot(theta)
    dbg["cos_sin"] = (c, s)
    pb = [(q_clip(1 << Q_TW, Q_TW + 1), 0)]        # p_0 = 1.0 -> Q17 里最大 131071
    for b in range(1, NBLK):
        pb.append(cplx_mul_q(pb[-1][0], pb[-1][1], c, -s))
    dbg["p"] = pb

    # ---- DFT(12bin x 10blk) + 对齐累加 + Sp --------------------------------
    acc = [(0, 0)] * 12
    Sp = 0
    for b in range(NBLK):
        for pidx in range(12):
            yr = yi = 0
            for n in range(P):
                tw = DFT_ROM[pidx * P + n]
                cw, sw = tw
                vx, vy = xi[b * P + n], xq[b * P + n]
                yr += vx * cw - vy * sw
                yi += vx * sw + vy * cw
            Xr = rnd_shift(yr, SX)
            Xi = rnd_shift(yi, SX)
            Sp += Xr * Xr + Xi * Xi
            ar, ai = acc[pidx]
            acc[pidx] = (ar + Xr * pb[b][0] - Xi * pb[b][1],
                         ai + Xr * pb[b][1] + Xi * pb[b][0])
    dbg["X0"] = acc
    dbg["Sp"] = Sp

    # ---- 门控：11*Sp >= GATE_K*Et，GATE_K = 180*2^(2*(Q_TW-SX)) -----------
    # Sp_hw = Sp_code * 2^(2*(Q_TW-SX))，float 版门控是 11*Sp >= 180*Et
    gate_ok = (Et != 0) and (11 * Sp >= GATE_K * Et)
    dbg["gate_ok"] = gate_ok
    if not gate_ok:
        return xi[:], xq[:], True, dbg

    # ---- LS：H_raw = sign*[(acc_i+acc_q) + j(acc_q-acc_i)] ------------------
    H = []
    for pidx in range(12):
        ar, ai = acc[pidx]
        hri = (ar + ai) * LSTF_SIGN[pidx]
        hrq = (ai - ar) * LSTF_SIGN[pidx]
        H.append((hri, hrq))
    dbg["H_raw"] = H

    # ---- 归一化到 |Hn|max ~ 2^H_TGT ---------------------------------------
    hm = 0
    for hri, hrq in H:
        hm = max(hm, abs(hri), abs(hrq))
    if hm == 0:
        return xi[:], xq[:], True, dbg
    eH = msb(hm)
    nH = H_TGT - eH
    Hn = [(q_clip(rnd_shift(hri, -nH), 25) if nH < 0 else q_clip(hri << nH, 25),
           q_clip(rnd_shift(hrq, -nH), 25) if nH < 0 else q_clip(hrq << nH, 25))
          for hri, hrq in H]
    dbg["eH"] = eH
    dbg["nH"] = nH
    dbg["Hn"] = Hn

    # ---- 12 -> 20 bin（mux + 一次 (a+b)>>1）-------------------------------
    H20 = []
    for k in range(-10, 10):
        i = LSTF_K.index(k) if k in LSTF_K else None
        if i is not None:
            H20.append(Hn[i])
        elif k == 0:
            H20.append(((Hn[5][0] + Hn[6][0]) >> 1, (Hn[5][1] + Hn[6][1]) >> 1))
        elif k < -6:
            H20.append(Hn[0])
        else:
            H20.append(Hn[11])
    dbg["H20"] = H20

    # ---- MMSE：P、eps(mean)、Wq -------------------------------------------
    Pl = [a * a + b * b for a, b in H20]
    sumP = sum(Pl)
    eps = (sumP * 5243) >> 20                 # 0.1*mean = sumP/200
    W = []
    for k in range(20):
        wr, wi, e = reciprocal_W(H20[k][0], H20[k][1], eps, eH)
        W.append((wr, wi))
    dbg["P"] = Pl
    dbg["eps"] = eps
    dbg["W"] = W

    # ---- IDFT -> taps_q，再 >> (eH+2) 到 Q24，再 >> TAP_SFT 进 25bit A 口 ----
    # taps_q = sum_j Wq[j]*tw  (Wq = W_norm*2^K_W, tw = Q15)
    # taps_final(Q24) = taps_q >> (K_W + 5 - nH - T_Q) = taps_q >> (eH + 2)
    # 定标推导（K_W=47, log2(20)=4.322, log2(1.1)=0.138）：
    #   H_raw = 20*1024*hk*2^(2*Q_TW-SX)      (p_b 与 DFT 各带 2^Q_TW)
    #   Hn    = H_raw * 2^(H_TGT-eH)
    #   Wq    = Hn * 2^K_W / (|Hn|^2+eps) = 2^K_W / (1.1*Hn)   (平信道)
    #   taps_q= 20*2^Q_TW*Wq = taps_float * 2^(11+eH+SX-Q_TW)
    #   taps_final(Q24) = taps_q >> S_TAP
    #   => S_TAP = eH + K_W - Q_TW + SX - H_TGT - 34
    S_TAP = eH + K_W - Q_TW + SX - H_TGT - 34
    taps24 = []
    for m in range(20):
        tr = ti = 0
        for j in range(20):
            cw, sw = IDFT_ROM[m * 20 + j]
            tr += W[j][0] * cw - W[j][1] * sw
            ti += W[j][0] * sw + W[j][1] * cw
        taps24.append((rnd_shift(tr, S_TAP), rnd_shift(ti, S_TAP)))
    # 硬件里 tap 走 DSP48 A 口（25bit）。真实 MMSE 抽头在弱信号/深衰落帧
    # 能到 10~1000，Q24 下 25bit 只有 ±1.0，直接裁会削平主瓣。
    # RTL 的做法：第一遍按 Q24 算，同时记「有分量放不进 25bit」；有就整帧
    # 重跑第二遍，这一遍先 >>>TAP_SFT（截断，与 Verilog >>> 一致）再饱和。
    # 所以这里必须先判断是否需要缩放，再对整帧统一做同样的 >>，不能逐个裁。
    lo25, hi25 = -(1 << 24), (1 << 24) - 1
    tap_scaled = any(v < lo25 or v > hi25 for pair in taps24 for v in pair)
    tap_sft = TAP_SFT if tap_scaled else 0
    taps = [(q_clip(a >> tap_sft, 25), q_clip(b >> tap_sft, 25))
            for a, b in taps24]
    dbg["taps"] = taps
    dbg["tap_scaled"] = tap_scaled

    # ---- FIR（窗口法，j=0..19 -> taps[(29-j)%20]）-------------------------
    fir = [taps[(29 - j) % 20] for j in range(20)]
    win = [(xi[191 + j], xq[191 + j]) for j in range(9)] + \
          [(xi[j], xq[j]) for j in range(11)]
    yi_o, yq_o = [], []
    for n in range(N):
        yr = yq = 0
        for j in range(20):
            yr += fir[j][0] * win[j][0] - fir[j][1] * win[j][1]
            yq += fir[j][0] * win[j][1] + fir[j][1] * win[j][0]
        # 抽头是 Q(T_Q-tap_sft)，右移 T_Q-tap_sft 得到与 Q10 输入同定标的 Q10 输出
        yi_o.append(q_clip(rnd_shift(yr, T_Q - tap_sft), 16))
        yq_o.append(q_clip(rnd_shift(yq, T_Q - tap_sft), 16))
        nxt = n + 11
        if nxt <= 255:
            win = win[1:] + [(xi[nxt], xq[nxt])]
        else:
            win = win[1:] + [(0, 0)]
    return yi_o, yq_o, False, dbg


# ════════════════════════════════════════════════════════════════════════════
#  4. 测试帧
# ════════════════════════════════════════════════════════════════════════════
def l_stf_block():
    """20 点时域 L-STF：DFT20(x) 在这 12 个 bin 上等于 (1+j)*sign"""
    s = [complex(1, 1) * sg for sg in LSTF_SIGN]
    return [sum(s[p] * complex(math.cos(2 * math.pi * K20[p] * n / P),
                               math.sin(2 * math.pi * K20[p] * n / P))
                for p in range(12)) / P for n in range(P)]


def make_data_frame(amp=6000.0, seed=9):
    """非 L-STF 帧（随机 QPSK）：门控必须失败 -> 旁路"""
    import random
    rnd = random.Random(seed)
    ampf = amp / 1024.0 / math.sqrt(2)
    xi, xq = [], []
    for _ in range(N):
        xi.append(q_clip(int(round(rnd.choice([-1, 1]) * ampf * 1024)), 16))
        xq.append(q_clip(int(round(rnd.choice([-1, 1]) * ampf * 1024)), 16))
    return xi, xq


def make_frame(amp=6000.0, ch=(1.0,), cfo=0.0, snr_db=None, seed=1, fill=0):
    """
    amp: 时域 L-STF 的峰值**码值**（内部 /1024 变成 float 单位）
    ch: 复数抽头（线性卷积）
    cfo: 每采样相位增量（圈/采样）
    返回 int16 码值 (list xi, list xq)
    """
    import random
    rnd = random.Random(seed)
    blk = l_stf_block()
    # 归一化到时域峰值 amp
    pk = max(abs(v) for v in blk)
    ampf = amp / 1024.0
    tx = [v / pk * ampf for v in blk] * NBLK         # 200 点（float 单位）

    # 后 56 点：填 L-STF 继续（周期延拓）或随机 QPSK
    if fill == 0:
        tail = [0j] * 56
    elif fill == 1:
        tail = [(tx[int(rnd.random() * 200)]) for _ in range(56)]
    else:
        tail = [complex(rnd.choice([-1, 1]), rnd.choice([-1, 1])) * amp / math.sqrt(2)
                for _ in range(56)]
    x = tx + tail

    # 多径：线性卷积（零填充尾部）
    y = [0j] * N
    for n in range(N):
        for t, h in enumerate(ch):
            if n - t >= 0:
                y[n] += h * x[n - t]

    # CFO（保留在输出里）
    if cfo:
        y = [v * complex(math.cos(2 * math.pi * cfo * n), math.sin(2 * math.pi * cfo * n))
             for n, v in enumerate(y)]

    # 噪声
    if snr_db is not None:
        sp = sum(abs(v) ** 2 for v in y) / N
        np_ = sp / (10 ** (snr_db / 10.0))
        sg = math.sqrt(np_ / 2)
        y = [v + complex(rnd.gauss(0, sg), rnd.gauss(0, sg)) for v in y]

    xi = [q_clip(int(round(v.real * 1024)), 16) for v in y]
    xq = [q_clip(int(round(v.imag * 1024)), 16) for v in y]
    return xi, xq


CASES = []


def add_case(name, xi, xq, expect_bypass=None):
    CASES.append((name, xi, xq, expect_bypass))


def build_cases():
    # 1 平信道
    add_case("flat  g=1", *make_frame(amp=8000.0))
    # 2 平信道 + 相位 + CFO pi/4 per block
    add_case("flat  g=0.5e^{j0.7}, cfo(theta=pi/4)",
             *make_frame(amp=6000.0, ch=(0.5 * complex(math.cos(0.7), math.sin(0.7)),),
                         cfo=math.pi / 4 / (2 * math.pi * 20)))
    # 3 两径 + 小 CFO
    add_case("2tap [1,0.6e^{jpi/3}] + cfo(theta=-0.3)",
             *make_frame(amp=7000.0, ch=(1.0, 0.6 * complex(math.cos(math.pi / 3),
                                                            math.sin(math.pi / 3))),
                         cfo=-0.3 / (2 * math.pi * 20), fill=2, seed=3))
    # 4 非 L-STF 随机数据 -> 旁路
    add_case("random data (no L-STF)", *make_data_frame(amp=8000.0), expect_bypass=True)
    # 5 全零 -> 旁路
    add_case("all zero", [0] * N, [0] * N, expect_bypass=True)
    # 6 满幅 + 两径
    add_case("near full scale", *make_frame(amp=23000.0,
                                            ch=(1.0, 0.45 * complex(math.cos(-1.1),
                                                                    math.sin(-1.1))),
                                            fill=2, seed=6))
    # 7 深衰落：两径在导频 bin 上打零点（h=[1, e^{-j2pi*k/20}]）
    k_null = K20[3]
    add_case("deep fade on bin %d" % k_null,
             *make_frame(amp=9000.0,
                         ch=(1.0, complex(math.cos(-2 * math.pi * k_null / 20),
                                          math.sin(-2 * math.pi * k_null / 20))),
                         cfo=0.12 / (2 * math.pi * 20), fill=2, seed=7))
    # 8 平信道 + 大 CFO theta=pi/2
    add_case("flat g=0.8, cfo(theta=pi/2)",
             *make_frame(amp=5000.0, ch=(0.8 * complex(math.cos(-0.4), math.sin(-0.4)),),
                         cfo=math.pi / 2 / (2 * math.pi * 20)))
    # 9 弱信号（真实帧量级 amp≈60，std≈0.017）：抽头 |t|≈4.6 > 1.0，
    #   旧 25bit Q24 会削顶，这一帧是 TAP_SFT 的回归用例
    add_case("weak flat amp=60 (|tap|>1)", *make_frame(amp=60.0, ch=(1.0,)))


# ════════════════════════════════════════════════════════════════════════════
#  5. 主流程
# ════════════════════════════════════════════════════════════════════════════
def main():
    here = os.path.dirname(os.path.abspath(__file__))
    plai = os.path.dirname(here)
    tbdir = os.path.join(plai, "tb")
    os.makedirs(tbdir, exist_ok=True)

    write_rom_vh(os.path.join(plai, "lstf_eq_rom.vh"))

    build_cases()
    ins, golds, cases = [], [], []
    print("\n%-42s %-8s %-10s %-10s %s" %
          ("frame", "bypass", "max|y_g-y_f|", "RMSE(LSB)", "note"))

    all_ok = True
    for idx, (name, xi, xq, expect_bypass) in enumerate(CASES):
        # float 参考（硬件版：mean eps）
        xf = [complex(a, b) / 1024.0 for a, b in zip(xi, xq)]
        y_f, theta_f, snr_f, byp_f = lstf_equalize_float(xf, eps_mode="mean")
        # median 版只用来报告差异
        y_m, _, snr_m, byp_m = lstf_equalize_float(xf, eps_mode="median")
        yq_f = [(q_clip(int(round(v.real * 1024)), 16),
                 q_clip(int(round(v.imag * 1024)), 16)) for v in y_f]

        yi, yq, byp, dbg = lstf_equalize_fixed(xi, xq)

        if byp != byp_f:
            print("  !! gate mismatch: model=%s float=%s snr=%.3f" % (byp, byp_f, snr_f))
            all_ok = False
        if expect_bypass is not None and byp != expect_bypass:
            print("  !! expected bypass=%s got %s" % (expect_bypass, byp))
            all_ok = False

        # 误差
        ref = list(zip(xi, xq)) if byp_f else yq_f
        errs = [abs(complex(a - b, c - d)) for (a, c), (b, d) in zip(zip(yi, yq), ref)]
        mx = max(errs) if errs else 0
        rmse = math.sqrt(sum(e * e for e in errs) / len(errs)) if errs else 0

        # median vs mean 的差（仅信息）
        if not byp_f and not byp_m:
            dm = max(abs(complex(a.real * 1024 - b.real * 1024, a.imag * 1024 - b.imag * 1024))
                     for a, b in zip(y_f, y_m))
        else:
            dm = 0
        note = ""
        if mx > 2.0 or rmse > 0.7:
            note = "  <-- 超预算"
            all_ok = False
        if byp_f and not byp_m:
            note += " (median 版不旁路)"
        print("%2d %-40s %-8s %10.2f %10.3f %s" % (
            idx, name, str(byp), mx, rmse, note))
        if dm > 8:
            print("      median/mean 输出最大差 %.2f 码值（eps 近似的影响）" % dm)

        ins.append((xi, xq))
        golds.append((yi, yq))
        cases.append(1 if byp_f else 0)

    # ---- 写 hex ------------------------------------------------------------
    def pack(a, b):
        return ((a & 0xffff) << 16) | (b & 0xffff)

    pin = os.path.join(tbdir, "eq_in.hex")
    pg = os.path.join(tbdir, "eq_gold.hex")
    pc = os.path.join(tbdir, "eq_case.hex")
    with open(pin, "w", newline="\n") as f:
        for xi, xq in ins:
            for a, b in zip(xi, xq):        # 字 = {Q,I}
                f.write("%08x\n" % pack(b, a))
    with open(pg, "w", newline="\n") as f:
        for yi, yq in golds:
            for a, b in zip(yi, yq):
                f.write("%08x\n" % pack(b, a))
    with open(pc, "w", newline="\n") as f:
        for c in cases:
            f.write("%08x\n" % c)
    print("\nwrote %s (%d frames)" % (pin, len(ins)))
    print("wrote", pg)
    print("wrote", pc)
    print("\n结果:", "PASS" if all_ok else "FAIL")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
