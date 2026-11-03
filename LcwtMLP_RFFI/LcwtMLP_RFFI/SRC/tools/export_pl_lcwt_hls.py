#!/usr/bin/env python3
"""Export WaveMLP (LCWT + MLP) weights for the PL HLS implementation.

Generates, into ``SRC/`` and ``SRC/tb/golden/``:

* ``pl_lcwt_weights.hpp``  -- quantised weights / biases / GELU LUT
* ``tb/golden/*.bin``      -- 8-frame input, end-to-end logits, and per-stage
                              reference vectors for frame 0 (little-endian int32)

The fixed-point reference in this file is the *normative* definition: the HLS
C++ code is written to reproduce it bit-exactly (same shifts, same saturation,
same truncating division, same floor isqrt).

Quantisation plan (matches SRC/pl_lcwt_config.hpp):

    input          Q10   code = round(x * 1024)          (data cache contract)
    LCWT in/out    Q10   int32 -- the per-sample amplitude spans ~60 dB
                         (median absmax 45 codes, max 9000), so an int16
                         token path silently loses most small frames.
                         int32 + Q10 keeps the relative precision.
    LCWT weights   Q13
    patch weights  Q14, token Q8 (int32)
    LayerNorm      gamma/beta Q10, output Q10 (dynamic block float)
    MLP weights    Q12, fc1 output/GELU/fc2/GAP/logits Q8

All requantisations round to nearest (add half before the arithmetic
right shift); the LayerNorm uses a per-token power-of-two input shift so
the integer rsqrt sees a fixed 11-bit mantissa, and a 22-bit reciprocal.

Run:
    transformer_4_rf/Scripts/python.exe SRC/tools/export_pl_lcwt_hls.py
"""

from __future__ import annotations

import argparse
import hashlib
import math
import os
import sys
from pathlib import Path

import numpy as np

# --------------------------------------------------------------------------
# Fixed-point constants (single source of truth; mirrored in C++ config)
# --------------------------------------------------------------------------
SEG_LEN = 256
N_LEVEL = 4
LCWT_K = 16
N_TOKEN = 16
TOK_DIM = 38
HEAD_CO = 20
N_FRAMES = 8
N_CLASSES = 20

Q_IN = 10
Q_LCWT = 10
Q_TOKEN = 8
Q_NORM = 10
Q_MLP = 8

QW_LCWT = 13
QW_PATCH = 14
QW_NORM = 10
QW_MLP = 12

SH_AN0 = Q_IN + QW_LCWT - Q_LCWT       # 13
SH_AN = Q_LCWT + QW_LCWT - Q_LCWT     # 13
SH_SYN = Q_LCWT + QW_LCWT - Q_LCWT    # 13
SH_PATCH = Q_LCWT + QW_PATCH - Q_TOKEN  # 16
SH_FC1 = Q_NORM + QW_MLP - Q_MLP      # 14
SH_FC2 = Q_MLP + QW_MLP - Q_MLP       # 12
SH_HEAD = Q_MLP + QW_MLP - Q_MLP      # 12

GELU_MIN = -8.0
GELU_STEP = 1.0 / 64.0
GELU_LUT_SIZE = 1025
GELU_OFFSET = 2048  # Q8 code of +8
# The table is emitted biased so every entry is non-negative; gelu_q8() subtracts
# GELU_LUT_BIAS after the >>2.  Required because HLS 2018.3 emits a zero-extending
# DSP "ama" for the signed lerp (csim right, RTL wrong for negative entries).
GELU_LUT_BIAS = 8192

INT16_MIN = -32768
INT16_MAX = 32767


# --------------------------------------------------------------------------
# Basic integer helpers (numpy mirrors of the C++ arithmetic)
# --------------------------------------------------------------------------
def qround(x: np.ndarray, scale: float) -> np.ndarray:
    """round(x * scale), half-up; clamped to int32 for biases."""
    q = np.floor(np.asarray(x, dtype=np.float64) * float(scale) + 0.5)
    q = q.astype(np.int64)
    return np.clip(q, -(2**31), 2**31 - 1)


def qw(x: np.ndarray, scale: float, lo: int = INT16_MIN, hi: int = INT16_MAX) -> np.ndarray:
    return np.clip(qround(x, scale), lo, hi)


def rq(acc: np.ndarray, shift: int) -> np.ndarray:
    """Round-to-nearest arithmetic shift, no saturation (int32 datapath).

    Same as `requant_round<S>` in C++: add 2^(S-1), then arithmetic shift.
    The LCWT / token path is int32; its measured absmax is ~3.3e5 (19 bit),
    far below the 2^31 clamp.
    """
    a = np.asarray(acc, dtype=np.int64)
    if shift > 0:
        a = a + (1 << (int(shift) - 1))
    v = a >> int(shift)
    return np.clip(v, -(2**31), 2**31 - 1).astype(np.int64)


def sat16(acc: np.ndarray) -> np.ndarray:
    return np.clip(np.asarray(acc, dtype=np.int64), INT16_MIN, INT16_MAX).astype(np.int64)


def trunc_div(a, b):
    """C++ integer division (truncates toward zero)."""
    a = np.asarray(a, dtype=np.int64)
    q = np.abs(a) // int(b)
    return np.where(a < 0, -q, q)


def isqrt_u32(v: int) -> int:
    return int(math.isqrt(int(v)))


def gelu_float(x: np.ndarray) -> np.ndarray:
    # 0.5 * x * (1 + erf(x / sqrt(2))) computed via tanh-free vector form
    from math import sqrt
    z = np.asarray(x, dtype=np.float64) / sqrt(2.0)
    # numpy has no erf; use math.erf elementwise (small LUT only)
    e = np.vectorize(math.erf)(z)
    return 0.5 * np.asarray(x, dtype=np.float64) * (1.0 + e)


# --------------------------------------------------------------------------
# Normative fixed-point model
# --------------------------------------------------------------------------
class FixedPointWaveMLP:
    def __init__(self, sd: dict):
        self.A = qw(sd["lcwt.analysis"].astype(np.float64), 1 << QW_LCWT)
        self.S = qw(sd["lcwt.synthesis"].astype(np.float64), 1 << QW_LCWT)
        self.PW = qw(sd["patch_embed.weight"].astype(np.float64), 1 << QW_PATCH)
        self.PB = qround(sd["patch_embed.bias"].astype(np.float64),
                         1 << (Q_LCWT + QW_PATCH))
        self.NW = qw(sd["blocks.0.norm.weight"].astype(np.float64), 1 << QW_NORM)
        self.NB = qround(sd["blocks.0.norm.bias"].astype(np.float64), 1 << QW_NORM)
        self.F1W = qw(sd["blocks.0.fc1.weight"].astype(np.float64), 1 << QW_MLP)
        self.F1B = qround(sd["blocks.0.fc1.bias"].astype(np.float64),
                          1 << (Q_NORM + QW_MLP))
        self.F2W = qw(sd["blocks.0.fc2.weight"].astype(np.float64), 1 << QW_MLP)
        self.F2B = qround(sd["blocks.0.fc2.bias"].astype(np.float64),
                          1 << (Q_MLP + QW_MLP))
        self.HW = qw(sd["head.weight"].astype(np.float64), 1 << QW_MLP)
        self.HB = qround(sd["head.bias"].astype(np.float64),
                         1 << (Q_MLP + QW_MLP))

        # GELU LUT: Q8 over [-8, 8], step 1/64, linear interpolation
        xs = GELU_MIN + GELU_STEP * np.arange(GELU_LUT_SIZE)
        lut = np.floor(gelu_float(xs) * 256.0 + 0.5).astype(np.int64)
        self.gelu_lut = np.clip(lut, INT16_MIN, INT16_MAX)

    # ---------------- LCWT ----------------
    def analysis_level(self, xr, xi, lv):
        N = xr.shape[0]
        t = np.arange(N // 2, dtype=np.int64)[:, None]
        idx = (2 * t + np.arange(LCWT_K, dtype=np.int64)[None, :]
               - (LCWT_K // 2 - 1)) & (N - 1)
        xrv = xr[idx]
        xiv = xi[idx]
        ar = self.A[lv, :, 0, :]   # (2, K): low/high real
        ai = self.A[lv, :, 1, :]   # (2, K): low/high imag
        lo_r = np.sum(ar[0] * xrv - ai[0] * xiv, axis=1)
        lo_i = np.sum(ai[0] * xrv + ar[0] * xiv, axis=1)
        hi_r = np.sum(ar[1] * xrv - ai[1] * xiv, axis=1)
        hi_i = np.sum(ai[1] * xrv + ar[1] * xiv, axis=1)
        sh = SH_AN0 if lv == 0 else SH_AN
        return rq(lo_r, sh), rq(lo_i, sh), rq(hi_r, sh), rq(hi_i, sh)

    def synthesis_level(self, lo_r, lo_i, hi_r, hi_i, lv):
        N = lo_r.shape[0]
        out_len = 2 * N
        t = np.arange(out_len, dtype=np.int64)
        acc_r = np.zeros(out_len, dtype=np.int64)
        acc_i = np.zeros(out_len, dtype=np.int64)
        s = self.S[lv]  # (2 band, 2 comp, K)
        for k in range(LCWT_K):
            valid = ((t + k) & 1) == 1          # synthesis uses k of parity 1-t
            j = t + k - (LCWT_K - 1)
            n = (j >> 1) & (N - 1)              # j is even wherever valid
            kk = (LCWT_K - 1) - k
            sr0 = int(s[0, 0, kk]); si0 = int(s[0, 1, kk])
            sr1 = int(s[1, 0, kk]); si1 = int(s[1, 1, kk])
            er = sr0 * lo_r[n] - si0 * lo_i[n] + sr1 * hi_r[n] - si1 * hi_i[n]
            ei = si0 * lo_r[n] + sr0 * lo_i[n] + si1 * hi_r[n] + sr1 * hi_i[n]
            acc_r += np.where(valid, er, 0)
            acc_i += np.where(valid, ei, 0)
        return rq(acc_r, SH_SYN), rq(acc_i, SH_SYN)

    def lcwt(self, xr, xi):
        details = []
        lo_r, lo_i = xr, xi
        for lv in range(N_LEVEL):
            lo_r, lo_i, h_r, h_i = self.analysis_level(lo_r, lo_i, lv)
            details.append((h_r, h_i))
        for lv in reversed(range(N_LEVEL)):
            h_r, h_i = details[lv]
            lo_r, lo_i = self.synthesis_level(lo_r, lo_i, h_r, h_i, lv)
        return lo_r, lo_i

    # ---------------- MLP ----------------
    def patch(self, xr, xi):
        tok = np.zeros((N_TOKEN, TOK_DIM), dtype=np.int64)
        w = self.PW.reshape(TOK_DIM, 2 * LCWT_K)
        for t in range(N_TOKEN):
            xw = np.concatenate([xr[16 * t:16 * t + 16],
                                 xi[16 * t:16 * t + 16]]).astype(np.int64)
            acc = w.dot(xw) + self.PB
            tok[t] = rq(acc, SH_PATCH)
        return tok

    def layernorm(self, tok):
        """Dynamic (per-token) block-float LayerNorm.

        The token amplitude spans ~60 dB, so a fixed shift cannot work: the
        integer rsqrt collapses when the variance is large.  Each token is
        first shifted down to an 11-bit mantissa (`s` below), which is exact
        for the scale-invariant statistics; the result is Q_NORM (Q10).
        """
        ln = np.zeros_like(tok)
        nw = self.NW.astype(np.int64)
        nb = self.NB.astype(np.int64)
        for t in range(N_TOKEN):
            z = tok[t].astype(np.int64)
            am = int(np.abs(z).max())
            s = max(0, am.bit_length() - 11)
            zz = z >> s
            s1 = int(zz.sum())
            s2 = int((zz * zz).sum())
            mu4 = int(trunc_div(s1 * 4, TOK_DIM))
            num = 16 * (TOK_DIM * s2 - s1 * s1)
            var4 = int(trunc_div(num, TOK_DIM * TOK_DIM))
            if var4 < 1:
                var4 = 1
            r = max(isqrt_u32(var4), 1)
            R = (1 << 22) // r
            # n = 2^10 * (z - mu)/std,  rounding right shift (>>12)
            n = (((zz << 2) - mu4) * R + (1 << 11)) >> 12
            y = ((n * nw + (1 << 9)) >> 10) + nb
            ln[t] = sat16(y)
        return ln

    def fc1(self, x):
        y = np.zeros_like(x)
        for t in range(N_TOKEN):
            acc = self.F1W.astype(np.int64).dot(x[t].astype(np.int64)) + self.F1B
            y[t] = rq(acc, SH_FC1)
        return y

    def gelu(self, x):
        out = np.zeros_like(x)
        lut = self.gelu_lut
        for t in range(N_TOKEN):
            for d in range(TOK_DIM):
                v = int(x[t, d])
                if v >= GELU_OFFSET:
                    g = v
                elif v <= -GELU_OFFSET:
                    g = 0
                else:
                    pos = v + GELU_OFFSET
                    idx = pos >> 2
                    frac = pos & 3
                    i1 = idx + 1 if idx < GELU_LUT_SIZE - 1 else idx
                    g = int((int(lut[idx]) * (4 - frac)
                             + int(lut[i1]) * frac) >> 2)
                out[t, d] = g
        return out

    def fc2(self, x):
        y = np.zeros_like(x)
        for t in range(N_TOKEN):
            acc = self.F2W.astype(np.int64).dot(x[t].astype(np.int64)) + self.F2B
            y[t] = rq(acc, SH_FC2)
        return y

    def gap_head(self, tok, fc2):
        # residual: tok is Q_TOKEN, fc2 is Q_MLP -> align tok to Q_MLP
        s = np.zeros(TOK_DIM, dtype=np.int64)
        for t in range(N_TOKEN):
            s += (tok[t].astype(np.int64) << (Q_MLP - Q_TOKEN)) + fc2[t].astype(np.int64)
        gap = s >> 4
        acc = self.HW.astype(np.int64).dot(gap) + self.HB
        logits = rq(acc, SH_HEAD)
        return gap, logits

    def forward(self, x_code: np.ndarray):
        """x_code: (256, 2) int16 IQ codes (or (2,256) float-ish)."""
        x = np.asarray(x_code, dtype=np.int64)
        if x.shape == (SEG_LEN, 2):
            xr, xi = x[:, 0], x[:, 1]
        elif x.shape == (2, SEG_LEN):
            xr, xi = x[0], x[1]
        else:
            raise ValueError(f"bad input shape {x.shape}")
        xr = xr.copy().astype(np.int64)
        xi = xi.copy().astype(np.int64)
        lr, li = self.lcwt(xr, xi)
        tok = self.patch(lr, li)
        ln = self.layernorm(tok)
        pre = self.fc1(ln)
        gel = self.gelu(pre)
        fc2 = self.fc2(gel)
        gap, logits = self.gap_head(tok, fc2)
        return {
            "lcwt_re": lr, "lcwt_im": li,
            "tok": tok, "ln": ln, "pre": pre, "gelu": gel,
            "fc2": fc2, "gap": gap, "logits": logits,
        }


# --------------------------------------------------------------------------
# Header emission
# --------------------------------------------------------------------------
def _fmt_array(name, arr, ctype, per_line=16, indent="  "):
    flat = np.asarray(arr).reshape(-1)
    lines = [f"static const {ctype} {name}[{flat.size}] = {{"]
    for i in range(0, flat.size, per_line):
        chunk = ", ".join(str(int(v)) for v in flat[i:i + per_line])
        lines.append(f"{indent}{chunk},")
    lines.append("};")
    return "\n".join(lines)


def _fmt_array2d(name, arr, ctype, indent="  "):
    """Row-major 2-D literal: arr[rows][cols].

    The C++ side partitions the *first* dimension completely, so the lane
    index (output neuron) is a bank and the runtime index (input dim) is the
    address -- one read port per bank.
    """
    a = np.asarray(arr)
    rows, cols = a.shape
    lines = [f"static const {ctype} {name}[{rows}][{cols}] = {{"]
    for r in range(rows):
        chunk = ", ".join(str(int(v)) for v in a[r].reshape(-1))
        lines.append(f"{indent}{{{chunk}}},")
    lines.append("};")
    return "\n".join(lines)


def emit_header(fp: FixedPointWaveMLP, path: Path, ckpt_hash: str):
    parts = []
    parts.append("#ifndef PL_LCWT_WEIGHTS_HPP")
    parts.append("#define PL_LCWT_WEIGHTS_HPP")
    parts.append("")
    parts.append('#include <ap_int.h>')
    parts.append('#include "pl_lcwt_config.hpp"')
    parts.append("")
    parts.append("// =====================================================================")
    parts.append("// GENERATED by SRC/tools/export_pl_lcwt_hls.py -- do not edit by hand.")
    parts.append(f"// checkpoint sha256[0:16] = {ckpt_hash}")
    parts.append("// =====================================================================")
    parts.append("")
    parts.append(f'static const char PL_LCWT_CKPT_HASH[] = "{ckpt_hash}";')
    parts.append("")

    def arr(name, a, ctype="ap_int<16>"):
        parts.append(f"// {name}: shape {tuple(np.asarray(a).shape)}")
        parts.append(_fmt_array(name, a, ctype))
        parts.append("")

    def arr2(name, a, ctype="ap_int<16>"):
        parts.append(f"// {name}: shape {tuple(np.asarray(a).shape)}  [lane][addr]")
        parts.append(_fmt_array2d(name, a, ctype))
        parts.append("")

    arr("LCWT_A", fp.A, "ap_int<16>")
    arr("LCWT_S", fp.S, "ap_int<16>")
    arr2("PATCH_W", fp.PW.reshape(TOK_DIM, 2 * LCWT_K), "ap_int<16>")
    arr("PATCH_B", fp.PB, "ap_int<32>")
    arr("NORM_W", fp.NW, "ap_int<16>")
    arr("NORM_B", fp.NB, "ap_int<16>")
    arr2("FC1_W", fp.F1W, "ap_int<16>")
    arr("FC1_B", fp.F1B, "ap_int<32>")
    arr2("FC2_W", fp.F2W, "ap_int<16>")
    arr("FC2_B", fp.F2B, "ap_int<32>")
    arr2("HEAD_W", fp.HW, "ap_int<16>")
    arr("HEAD_B", fp.HB, "ap_int<32>")
    arr("GELU_LUT", fp.gelu_lut + GELU_LUT_BIAS, "ap_uint<16>")

    parts.append("#endif  // PL_LCWT_WEIGHTS_HPP")
    path.write_text("\n".join(parts) + "\n", encoding="utf-8")


# --------------------------------------------------------------------------
# Golden vectors
# --------------------------------------------------------------------------
def write_i32(path: Path, arr):
    a = np.asarray(arr, dtype="<i4")
    a.tofile(path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--train-root", type=Path,
                    default=Path("D:/FPGA/FPGA/Transformer_Train"))
    ap.add_argument("--ckpt", type=Path, default=None,
                    help="checkpoint (default: <train-root>/checkpoints/tx20_cmp_p16_d38_j4k16_q10/best.pt)")
    ap.add_argument("--out", type=Path, default=None,
                    help="HLS project SRC dir (default: <script>/..)")
    ap.add_argument("--eval-n", type=int, default=2000,
                    help="number of test samples for the accuracy check (0 = skip)")
    args = ap.parse_args()

    here = Path(__file__).resolve().parent          # SRC/tools
    srcdir = (args.out or (here.parent)).resolve()  # SRC
    golden = srcdir / "tb" / "golden"
    golden.mkdir(parents=True, exist_ok=True)

    ckpt = args.ckpt or (args.train_root / "checkpoints" /
                         "tx20_cmp_p16_d38_j4k16_q10" / "best.pt")
    raw = ckpt.read_bytes()
    ckpt_hash = hashlib.sha256(raw).hexdigest()[:16]

    import torch
    ck = torch.load(str(ckpt), map_location="cpu", weights_only=False)
    sd = {k: v.detach().cpu().numpy() for k, v in ck["model"].items()}
    fp = FixedPointWaveMLP(sd)

    print(f"checkpoint : {ckpt}")
    print(f"sha256[:16]: {ckpt_hash}")
    print(f"epoch/acc  : {ck.get('epoch')} / {ck.get('acc')}")

    # ---------------- data ----------------
    cache = args.train_root / "data_cache_20cls_q10"
    segs = np.load(cache / "segs_int16.npy", mmap_mode="r")
    meta = np.load(cache / "meta.npz", allow_pickle=True)
    labels = meta["labels"]
    test_idx = np.load(cache / "split.npz")["test"]

    # 8 frames: first test sample of 8 distinct classes (fall back to prefix)
    chosen = []
    seen = set()
    for idx in test_idx:
        lab = int(labels[idx])
        if lab not in seen:
            seen.add(lab)
            chosen.append(int(idx))
        if len(chosen) == N_FRAMES:
            break
    if len(chosen) < N_FRAMES:
        for idx in test_idx:
            if int(idx) not in chosen:
                chosen.append(int(idx))
            if len(chosen) == N_FRAMES:
                break

    x_frames = np.stack([np.asarray(segs[i]) for i in chosen])  # (8,256,2) int16
    print("golden frames (test idx, label):",
          [(i, int(labels[i])) for i in chosen])
    print("input absmax:", int(np.abs(x_frames.astype(np.int32)).max()))

    # ---------------- golden vectors ----------------
    out_logits = np.zeros((N_FRAMES, HEAD_CO), dtype=np.int64)
    first = None
    for f in range(N_FRAMES):
        r = fp.forward(x_frames[f])
        out_logits[f] = r["logits"]
        if f == 0:
            first = r

    write_i32(golden / "x_in.bin", x_frames.astype(np.int32))
    write_i32(golden / "logits.bin", out_logits)
    write_i32(golden / "gold_lcwt_re.bin", first["lcwt_re"])
    write_i32(golden / "gold_lcwt_im.bin", first["lcwt_im"])
    write_i32(golden / "gold_tok.bin", first["tok"])
    write_i32(golden / "gold_ln.bin", first["ln"])
    write_i32(golden / "gold_pre.bin", first["pre"])
    write_i32(golden / "gold_gelu.bin", first["gelu"])
    write_i32(golden / "gold_fc2.bin", first["fc2"])
    write_i32(golden / "gold_gap.bin", first["gap"])

    print("\nframe-0 stage ranges (fixed point):")
    for k in ("lcwt_re", "lcwt_im", "tok", "ln", "pre", "gelu", "fc2", "gap", "logits"):
        a = np.asarray(first[k]).reshape(-1)
        print(f"  {k:8s} min {a.min():7d} max {a.max():7d} absmax {int(np.abs(a).max()):6d}")

    # ---------------- weights header ----------------
    hdr = srcdir / "pl_lcwt_weights.hpp"
    emit_header(fp, hdr, ckpt_hash)
    print(f"\nwrote {hdr}  ({hdr.stat().st_size} bytes)")
    print(f"wrote golden files under {golden}")

    # ---------------- accuracy check vs float model ----------------
    if args.eval_n <= 0:
        return

    sys.path.insert(0, str(args.train_root))
    import torch
    import yaml
    from src.models.factory import build_model
    cfg_path = (args.train_root / "configs" / "compress" /
                "tx20_cmp_p16_d38_j4k16_q10.yaml")
    with open(cfg_path, encoding="utf-8") as fh:
        cfg = yaml.safe_load(fh)
    model = build_model(cfg, num_classes=N_CLASSES, seg_len=SEG_LEN)
    model.load_state_dict(ck["model"])
    model.eval()

    n_eval = min(int(args.eval_n), len(test_idx))
    eval_idx = test_idx[:n_eval]
    x_eval = np.asarray(segs[eval_idx], dtype=np.int16)[:, :, :]  # (n,256,2)
    lab_eval = labels[eval_idx].astype(np.int64)

    # float reference
    xt = torch.from_numpy(np.ascontiguousarray(
        x_eval.transpose(0, 2, 1))).float() / 1024.0
    with torch.no_grad():
        float_logits = model(xt).numpy()

    # fixed point (per-sample; the reference is intentionally simple)
    fp_logits = np.zeros((n_eval, HEAD_CO), dtype=np.int64)
    for i in range(n_eval):
        fp_logits[i] = fp.forward(np.asarray(segs[eval_idx[i]]))["logits"]

    float_pred = float_logits.argmax(1)
    fp_pred = fp_logits.argmax(1)
    top1_float = float((float_pred == lab_eval).mean())
    top1_fp = float((fp_pred == lab_eval).mean())
    agree = float((fp_pred == float_pred).mean())
    print(f"\neval on {n_eval} test samples:")
    print(f"  float top1     = {top1_float:.6f}")
    print(f"  fixed top1     = {top1_fp:.6f}   (delta {100*(top1_fp-top1_float):+.4f} pt)")
    print(f"  argmax agree   = {agree:.6f}")

    # logit scale for the PS side: fp logit code / 2^Q_MLP = real logit
    print(f"  PL logit scale = 1/{1 << Q_MLP} (software: logits_real = code / {1 << Q_MLP})")


if __name__ == "__main__":
    main()
