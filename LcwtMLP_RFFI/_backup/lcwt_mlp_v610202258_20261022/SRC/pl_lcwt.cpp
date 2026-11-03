// ---------------------------------------------------------------------------
// pl_lcwt.cpp -- WaveMLP datapath (LCWT + patch embed + residual MLP + head).
//
// Everything here is a direct integer mirror of SRC/tools/export_pl_lcwt_hls.py.
// The Python side is normative: rounding is "add 2^(S-1), arithmetic shift",
// LayerNorm uses a per-token block-float shift, GELU is a 1025-entry Q8 LUT
// with linear interpolation.  Do not "simplify" any of these.
//
// Scheduling notes (Vivado HLS 2018.3):
//  * LCWT analysis / synthesis walk all four levels through ONE loop body
//    (runtime `lv`).  Four separate calls would instantiate four multiplier
//    arrays and blow the DSP budget; one body with II=2 costs 64 multipliers.
//  * Because `lv` is a runtime value the filters cannot be folded into
//    constants, so each level first copies its 64 taps into registers (`war`
//    / `wsr`), 64 sequential ROM reads.  After that every MAC operand is a
//    register, so the point loops carry no ROM port pressure.
//  * The sliding windows (`wr/wi` and `wlr/wli/whr/whi`) are register arrays
//    with compile-time indices, so K taps cost TWO BRAM reads per output
//    instead of K.
// ---------------------------------------------------------------------------
#include <ap_int.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>

#include "pl_lcwt_config.hpp"
#include "pl_lcwt_weights.hpp"
#include "pl_lcwt.hpp"

// ---------------------------------------------------------------------------
// Fixed-point helpers
// ---------------------------------------------------------------------------
typedef ap_int<44> acc_t;

// LCWT coefficient storage.  These were int32 in the first cut; the extra
// 7 bits made every LCWT / patch multiply a 32x16, which needs TWO DSP48E1
// (25x18 max) instead of one.  A worst-case bound for this interface
// (|x| <= 2^15, 16 taps, |w| <= 2^14, >>13) puts the analysis output below
// 2^21, so 25 bits has >= 3 bits of headroom even at full-scale input and
// keeps every multiply inside a single DSP48E1.
typedef ap_int<25> lcwt_t;

// Round-to-nearest arithmetic shift, no saturation.  Mirrors rq() in Python.
template <int S>
static inline ap_int<32> rq(acc_t a) {
#pragma HLS INLINE
    ap_int<48> t = (ap_int<48>)a + (ap_int<48>)(1 << (S - 1));
    return (ap_int<32>)(t >> S);
}

static inline ap_int<16> sat16(ap_int<32> v) {
#pragma HLS INLINE
    if (v > 32767) v = 32767;
    if (v < -32768) v = -32768;
    return (ap_int<16>)v;
}

// 32-bit floor sqrt (restoring, one bit per 2 steps => 16 iterations).
static ap_uint<32> isqrt_u32(ap_int<64> vin) {
#pragma HLS INLINE
    ap_uint<32> v   = (ap_uint<32>)vin;
    ap_uint<32> res = 0;
    ap_uint<32> bit = (ap_uint<32>)1 << 30;
ISQ:
    // II=2: the loop-carried path is add -> compare -> select, which csynth
    // put at 4.567 ns and made the design's critical path.  Two cycles spread
    // it to ~2.3 ns; the cost is 16 extra cycles per token (256/frame)
    // against a ~15k-cycle frame.
    for (int i = 0; i < 16; ++i) {
#pragma HLS PIPELINE II=2
        ap_uint<32> t = res + bit;
        if (v >= t) {
            v   = v - t;
            res = (res >> 1) + bit;
        } else {
            res = res >> 1;
        }
        bit = bit >> 2;
    }
    return res;
}

static int bitlen_u32(ap_uint<32> v) {
#pragma HLS INLINE
    int n = 0;
BL:
    for (int i = 0; i < 32; ++i) {
#pragma HLS UNROLL
        if (v >> i) n = i + 1;
    }
    return n;
}

// GELU on Q8 codes: identity above +8, zero below -8, LUT+lerp in between.
static ap_int<32> gelu_q8(ap_int<32> v) {
#pragma HLS INLINE
    if (v >= GELU_OFFSET)  return v;
    if (v <= -GELU_OFFSET) return (ap_int<32>)0;
    ap_int<32> pos  = v + GELU_OFFSET;
    int idx  = (int)(pos >> 2);
    int frac = (int)(pos & 3);
    int i1   = (idx < GELU_LUT_SIZE - 1) ? (idx + 1) : idx;
    // Unsigned on purpose: the table is biased by GELU_LUT_BIAS, so no operand
    // can be negative.  In the signed form HLS 2018.3 emitted a zero-extending
    // DSP "ama" -- csim was correct but RTL corrupted every negative LUT entry.
    ap_uint<32> l0  = (ap_uint<32>)GELU_LUT[idx];
    ap_uint<32> l1  = (ap_uint<32>)GELU_LUT[i1];
    ap_uint<32> acc = l0 * (ap_uint<32>)(4 - frac) + l1 * (ap_uint<32>)frac;
    return (ap_int<32>)((ap_int<32>)(acc >> 2) - (ap_int<32>)GELU_LUT_BIAS);
}

// ---------------------------------------------------------------------------
// Buffers shared by the LCWT analysis and synthesis.
//   lr/li layout: level lv input lives at LOFF[lv], size 256 >> lv
//   hr/hi layout: level lv detail lives at HOFF[lv], size 128 >> lv
// ---------------------------------------------------------------------------
static const int LCWT_LEN  = 256 + 128 + 64 + 32 + 16;   // 496
static const int LCWT_HLEN = 128 + 64 + 32 + 16;         // 240

static const int LOFF[5] = {0, 256, 384, 448, 480};
static const int HOFF[4] = {0, 128, 192, 224};

// ---------------------------------------------------------------------------
// LCWT analysis: 4 levels, one shared loop body.
//   stride 2, circular padding, idx(t,k) = 2t + k - 7
//   imag sign is MINUS (conjugate filters)
// ---------------------------------------------------------------------------
static void lcwt_analysis(lcwt_t lr[LCWT_LEN], lcwt_t li[LCWT_LEN],
                          lcwt_t hr[LCWT_HLEN], lcwt_t hi[LCWT_HLEN]) {
#pragma HLS INLINE

    ap_int<16> war[2][2][LCWT_K];   // [band][comp][tap]
#pragma HLS ARRAY_PARTITION variable=war dim=0 complete

AN_LV:
    for (int lv = 0; lv < N_LEVEL; ++lv) {
        int n    = SEG_LEN >> lv;
        int np   = n >> 1;
        int ioff = LOFF[lv];
        int ooff = LOFF[lv + 1];
        int hoff = HOFF[lv];

    AN_WLOAD:
        for (int k = 0; k < LCWT_K; ++k) {
#pragma HLS PIPELINE II=1
            for (int b = 0; b < 2; ++b) {
#pragma HLS UNROLL
                for (int c = 0; c < 2; ++c) {
#pragma HLS UNROLL
                    war[b][c][k] = LCWT_A[((lv * 2 + b) * 2 + c) * LCWT_K + k];
                }
            }
        }

        lcwt_t wr[LCWT_K], wi[LCWT_K];
#pragma HLS ARRAY_PARTITION variable=wr dim=1 complete
#pragma HLS ARRAY_PARTITION variable=wi dim=1 complete

    AN_PRE:
        for (int k = 0; k < LCWT_K; ++k) {
#pragma HLS PIPELINE II=1
            int idx = ioff + (((k - (LCWT_K / 2 - 1)) + n) & (n - 1));
            wr[k] = lr[idx];
            wi[k] = li[idx];
        }

    AN_PT:
        for (int t = 0; t < np; ++t) {
            // One accumulator per (complex term, unrolled lane).  The first
            // version accumulated `ar0 += A - B` with AN_UR=4 taps in the
            // same cycle, so the loop-carried path was eight 44-bit DSP-ALU
            // ops in series (measured 21.3 ns).  Splitting the terms makes
            // every chain a single MACC per iteration, which maps to one
            // DSP48E1 (25x18 multiplier + 48-bit P register) and fits II=1.
            // Integer addition is exact and the 44-bit range has >8 bits of
            // headroom, so the regrouped order is bit-identical.
            acc_t ac[8][AN_UR];
#pragma HLS ARRAY_PARTITION variable=ac dim=0 complete

        AN_INIT:
            for (int u = 0; u < AN_UR; ++u) {
#pragma HLS UNROLL
                for (int j = 0; j < 8; ++j) {
#pragma HLS UNROLL
                    ac[j][u] = 0;
                }
            }

        AN_MAC:
            for (int m = 0; m < LCWT_K / AN_UR; ++m) {
#pragma HLS PIPELINE II=1
            AN_LANE:
                for (int u = 0; u < AN_UR; ++u) {
#pragma HLS UNROLL
                    int k = m * AN_UR + u;
                    ap_int<16> w0r = war[0][0][k];
                    ap_int<16> w0i = war[0][1][k];
                    ap_int<16> w1r = war[1][0][k];
                    ap_int<16> w1i = war[1][1][k];
                    acc_t x = (acc_t)wr[k];
                    acc_t y = (acc_t)wi[k];
                    ac[0][u] += (acc_t)w0r * x;
                    ac[1][u] += (acc_t)w0i * y;
                    ac[2][u] += (acc_t)w0i * x;
                    ac[3][u] += (acc_t)w0r * y;
                    ac[4][u] += (acc_t)w1r * x;
                    ac[5][u] += (acc_t)w1i * y;
                    ac[6][u] += (acc_t)w1i * x;
                    ac[7][u] += (acc_t)w1r * y;
                }
            }

            // ar0 = sum(ac0) - sum(ac1), ai0 = sum(ac2) + sum(ac3),
            // ar1 = sum(ac4) - sum(ac5), ai1 = sum(ac6) + sum(ac7).
            acc_t s0 = 0, s1 = 0, s2 = 0, s3 = 0;
            acc_t s4 = 0, s5 = 0, s6 = 0, s7 = 0;
        AN_SUM:
            for (int u = 0; u < AN_UR; ++u) {
#pragma HLS UNROLL
                s0 += ac[0][u];
                s1 += ac[1][u];
                s2 += ac[2][u];
                s3 += ac[3][u];
                s4 += ac[4][u];
                s5 += ac[5][u];
                s6 += ac[6][u];
                s7 += ac[7][u];
            }

            // SH_AN0 == SH_AN == 13 in this configuration.
            lr[ooff + t] = rq<SH_AN>(s0 - s1);
            li[ooff + t] = rq<SH_AN>(s2 + s3);
            hr[hoff + t] = rq<SH_AN>(s4 - s5);
            hi[hoff + t] = rq<SH_AN>(s6 + s7);

            // Window shift, written out: `#pragma HLS UNROLL` on this loop
            // was silently ignored (csynth still reported a 14-iteration,
            // 4-cycle loop = 56 cycles per point).  Straight-line register
            // moves are unambiguous and cost 0 cycles.
            wr[0] = wr[2];   wi[0] = wi[2];
            wr[1] = wr[3];   wi[1] = wi[3];
            wr[2] = wr[4];   wi[2] = wi[4];
            wr[3] = wr[5];   wi[3] = wi[5];
            wr[4] = wr[6];   wi[4] = wi[6];
            wr[5] = wr[7];   wi[5] = wi[7];
            wr[6] = wr[8];   wi[6] = wi[8];
            wr[7] = wr[9];   wi[7] = wi[9];
            wr[8] = wr[10];  wi[8] = wi[10];
            wr[9] = wr[11];  wi[9] = wi[11];
            wr[10] = wr[12]; wi[10] = wi[12];
            wr[11] = wr[13]; wi[11] = wi[13];
            wr[12] = wr[14]; wi[12] = wi[14];
            wr[13] = wr[15]; wi[13] = wi[15];
            {
                int b0 = 2 * (t + 1) - (LCWT_K / 2 - 1);
                int i0 = ioff + ((b0 + LCWT_K - 2) & (n - 1));
                int i1 = ioff + ((b0 + LCWT_K - 1) & (n - 1));
                wr[LCWT_K - 2] = lr[i0];
                wr[LCWT_K - 1] = lr[i1];
                wi[LCWT_K - 2] = li[i0];
                wi[LCWT_K - 1] = li[i1];
            }
        }
    }
}

// ---------------------------------------------------------------------------
// LCWT synthesis: 4 levels (3 -> 0), one shared loop body.
//   output sample t accumulates the taps of parity 1-t only:
//     even t = 2u : k = 2w+1, kk = 14-2w
//     odd  t = 2u+1: k = 2w,   kk = 15-2w
//   both use the same 8-entry lo/hi window w[j] = lo[(u-7+j) mod n]
// ---------------------------------------------------------------------------
static void lcwt_synthesis(lcwt_t lr[LCWT_LEN], lcwt_t li[LCWT_LEN],
                           const lcwt_t hr[LCWT_HLEN],
                           const lcwt_t hi[LCWT_HLEN]) {
#pragma HLS INLINE

    ap_int<16> wsr[2][2][LCWT_K];   // [band][comp][kk]
#pragma HLS ARRAY_PARTITION variable=wsr dim=0 complete

SY_LV:
    for (int lv = N_LEVEL - 1; lv >= 0; --lv) {
        int n    = SEG_LEN >> (lv + 1);   // this level's lo length
        int ioff = LOFF[lv + 1];
        int ooff = LOFF[lv];
        int hoff = HOFF[lv];

    SY_WLOAD:
        for (int k = 0; k < LCWT_K; ++k) {
#pragma HLS PIPELINE II=1
            for (int b = 0; b < 2; ++b) {
#pragma HLS UNROLL
                for (int c = 0; c < 2; ++c) {
#pragma HLS UNROLL
                    wsr[b][c][k] = LCWT_S[((lv * 2 + b) * 2 + c) * LCWT_K + k];
                }
            }
        }

        lcwt_t wlr[8], wli[8], whr[8], whi[8];
#pragma HLS ARRAY_PARTITION variable=wlr dim=1 complete
#pragma HLS ARRAY_PARTITION variable=wli dim=1 complete
#pragma HLS ARRAY_PARTITION variable=whr dim=1 complete
#pragma HLS ARRAY_PARTITION variable=whi dim=1 complete

    SY_PRE:
        for (int j = 0; j < 8; ++j) {
#pragma HLS PIPELINE II=1
            int idx = ioff + ((j - 7 + n) & (n - 1));
            wlr[j] = lr[idx];
            wli[j] = li[idx];
            whr[j] = hr[hoff + ((j - 7 + n) & (n - 1))];
            whi[j] = hi[hoff + ((j - 7 + n) & (n - 1))];
        }

    SY_PT:
        for (int u = 0; u < n; ++u) {
            // Same per-term split as AN_PT: 16 product terms per tap, one
            // accumulator each, so every loop-carried path is one MACC.
            acc_t ac[16][SY_UR];
#pragma HLS ARRAY_PARTITION variable=ac dim=0 complete

        SY_INIT:
            for (int q = 0; q < SY_UR; ++q) {
#pragma HLS UNROLL
                for (int j = 0; j < 16; ++j) {
#pragma HLS UNROLL
                    ac[j][q] = 0;
                }
            }

        SY_MAC:
            for (int m = 0; m < 8 / SY_UR; ++m) {
#pragma HLS PIPELINE II=1
            SY_LANE:
                for (int q = 0; q < SY_UR; ++q) {
#pragma HLS UNROLL
                    int w = m * SY_UR + q;
                    ap_int<16> s0rE = wsr[0][0][14 - 2 * w];
                    ap_int<16> s0iE = wsr[0][1][14 - 2 * w];
                    ap_int<16> s1rE = wsr[1][0][14 - 2 * w];
                    ap_int<16> s1iE = wsr[1][1][14 - 2 * w];
                    ap_int<16> s0rO = wsr[0][0][15 - 2 * w];
                    ap_int<16> s0iO = wsr[0][1][15 - 2 * w];
                    ap_int<16> s1rO = wsr[1][0][15 - 2 * w];
                    ap_int<16> s1iO = wsr[1][1][15 - 2 * w];

                    acc_t lr_ = (acc_t)wlr[w];
                    acc_t li_ = (acc_t)wli[w];
                    acc_t hr_ = (acc_t)whr[w];
                    acc_t hi_ = (acc_t)whi[w];

                    ac[0][q]  += (acc_t)s0rE * lr_;
                    ac[1][q]  += (acc_t)s0iE * li_;
                    ac[2][q]  += (acc_t)s1rE * hr_;
                    ac[3][q]  += (acc_t)s1iE * hi_;
                    ac[4][q]  += (acc_t)s0iE * lr_;
                    ac[5][q]  += (acc_t)s0rE * li_;
                    ac[6][q]  += (acc_t)s1iE * hr_;
                    ac[7][q]  += (acc_t)s1rE * hi_;
                    ac[8][q]  += (acc_t)s0rO * lr_;
                    ac[9][q]  += (acc_t)s0iO * li_;
                    ac[10][q] += (acc_t)s1rO * hr_;
                    ac[11][q] += (acc_t)s1iO * hi_;
                    ac[12][q] += (acc_t)s0iO * lr_;
                    ac[13][q] += (acc_t)s0rO * li_;
                    ac[14][q] += (acc_t)s1iO * hr_;
                    ac[15][q] += (acc_t)s1rO * hi_;
                }
            }

            // er0 = +(0) -(1) +(2) -(3),  ei0 = +(4)+(5)+(6)+(7),
            // er1 = +(8) -(9) +(10)-(11), ei1 = +(12)+(13)+(14)+(15).
            acc_t s0 = 0, s1 = 0, s2 = 0, s3 = 0;
            acc_t s4 = 0, s5 = 0, s6 = 0, s7 = 0;
            acc_t s8 = 0, s9 = 0, s10 = 0, s11 = 0;
            acc_t s12 = 0, s13 = 0, s14 = 0, s15 = 0;
        SY_SUM:
            for (int q = 0; q < SY_UR; ++q) {
#pragma HLS UNROLL
                s0 += ac[0][q];   s1 += ac[1][q];
                s2 += ac[2][q];   s3 += ac[3][q];
                s4 += ac[4][q];   s5 += ac[5][q];
                s6 += ac[6][q];   s7 += ac[7][q];
                s8 += ac[8][q];   s9 += ac[9][q];
                s10 += ac[10][q]; s11 += ac[11][q];
                s12 += ac[12][q]; s13 += ac[13][q];
                s14 += ac[14][q]; s15 += ac[15][q];
            }

            lr[ooff + 2 * u]     = rq<SH_SYN>((s0 - s1) + (s2 - s3));
            li[ooff + 2 * u]     = rq<SH_SYN>((s4 + s5) + (s6 + s7));
            lr[ooff + 2 * u + 1] = rq<SH_SYN>((s8 - s9) + (s10 - s11));
            li[ooff + 2 * u + 1] = rq<SH_SYN>((s12 + s13) + (s14 + s15));

            // Same written-out shift as AN_PT (dead on the last u).
            wlr[0] = wlr[1]; wli[0] = wli[1]; whr[0] = whr[1]; whi[0] = whi[1];
            wlr[1] = wlr[2]; wli[1] = wli[2]; whr[1] = whr[2]; whi[1] = whi[2];
            wlr[2] = wlr[3]; wli[2] = wli[3]; whr[2] = whr[3]; whi[2] = whi[3];
            wlr[3] = wlr[4]; wli[3] = wli[4]; whr[3] = whr[4]; whi[3] = whi[4];
            wlr[4] = wlr[5]; wli[4] = wli[5]; whr[4] = whr[5]; whi[4] = whi[5];
            wlr[5] = wlr[6]; wli[5] = wli[6]; whr[5] = whr[6]; whi[5] = whi[6];
            wlr[6] = wlr[7]; wli[6] = wli[7]; whr[6] = whr[7]; whi[6] = whi[7];
            {
                int nn = ((u + 1) & (n - 1));
                wlr[7] = lr[ioff + nn];
                wli[7] = li[ioff + nn];
                whr[7] = hr[hoff + nn];
                whi[7] = hi[hoff + nn];
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Patch embedding + per-token LayerNorm, fused (2026-10-20).
//
// Conv1d(2 -> 38, k=16, s=16), no padding, no kernel flip:
//   tok[t][d] = bias[d] + sum_{c,k} W[d][c*16+k] * lcwt[c][16t+k]
//
// LayerNorm per token, dynamic block-float (mirrors Python layernorm()):
//   s  = max(0, bitlen(max|z|) - 11)
//   zz = z >> s
//   mu4 = trunc_div(4*sum(zz), 38)
//   var4 = trunc_div(16*(38*sum(zz^2) - sum(zz)^2), 38^2), clamped to >= 1
//   R = 2^22 / floor(sqrt(var4))
//   n = ((zz*4 - mu4) * R + 2^11) >> 12
//   y = ((n * norm_w + 2^9) >> 10) + norm_b      (Q10, saturated to int16)
//
// Why the two stages are fused: `toks` used to be a dim=1-partitioned 38-bank
// array (~2,100 LUT, of which 1,080 was LUTRAM) and every read with a runtime
// `d` became a 38:1 mux (LN_STAT 312, LN_APPLY 322, CP_OUT_T 312 = 946 LUT).
// The 38 token lanes now go straight into the caller's `tokT` BRAM -- which
// the frame has to fill anyway -- and both LN passes read them back through
// the BRAM address port, so no token value is ever selected by a mux.  The
// serialised store costs TOK_DIM cycles per token, exactly what CP_OUT_T used
// to cost at the end of the frame, so frame latency is unchanged.
// No per-lane token sum is kept here: `fc2_gap` reads tokT back serially for
// the raw-token half of the GAP residual.  The old `acc_t tsum[38]` was 38
// parallel 44-bit adders (1,240 LUT cells plus 1,672 FFs in the netlist) to
// save a 152-cycle read-back pass.  Integer addition is exact and
// associative, so both forms give bit-identical GAP values.
//
// (Tried first: keeping the lanes in a register file rotated one lane per
// cycle.  HLS built one copy per LN pass plus entry-reload muxes on every
// lane -- OOC 19,232 LUT / 31,206 FF, i.e. +3,534 LUT over the baseline.
// Do not go back to the rotation.)
// ---------------------------------------------------------------------------
static void patch_ln(const lcwt_t lr[LCWT_LEN],
                     const lcwt_t li[LCWT_LEN],
                     ap_int<32> tokT[TOK_DIM][N_TOKEN],
                     ap_int<16> lnT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=PATCH_W dim=1 complete
#pragma HLS ARRAY_PARTITION variable=NORM_W dim=1 complete
#pragma HLS ARRAY_PARTITION variable=NORM_B dim=1 complete

PL_TOKEN:
    for (int t = 0; t < N_TOKEN; ++t) {
        acc_t acc[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=acc dim=1 complete
        ap_int<32> vv[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=vv dim=1 complete
        ap_int<32> amax = 0;

    PT_INIT:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            acc[d] = (acc_t)PATCH_B[d];
        }

    PT_RE:
        for (int i = 0; i < LCWT_K; ++i) {
#pragma HLS PIPELINE II=1
            lcwt_t xv = lr[16 * t + i];
        PT_RE_MAC:
            for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
                acc[d] += (acc_t)PATCH_W[d][i] * (acc_t)xv;
            }
        }

    PT_IM:
        for (int i = 0; i < LCWT_K; ++i) {
#pragma HLS PIPELINE II=1
            lcwt_t xv = li[16 * t + i];
        PT_IM_MAC:
            for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
                acc[d] += (acc_t)PATCH_W[d][LCWT_K + i] * (acc_t)xv;
            }
        }

    // Round once into `vv` (all indices compile-time), then push the lanes
    // into tokT one per cycle.  tokT has to be written for this token anyway,
    // so the store is not extra work -- it just happens here instead of in
    // the old end-of-frame copy-out pass.
    PT_STORE:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            vv[d] = rq<SH_PATCH>(acc[d]);
        }

    // One 38:1 mux on the 32-bit value per cycle (38 cycles/token); the
    // address side is just a counter, so nothing else is multiplexed.
    PT_WR:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            tokT[d][t] = vv[d];
        }

    // amax = max_d |tok[d][t]|, read back through the BRAM address port with a
    // runtime `d`: one abs, one compare, 38 cycles.  The old form (38 parallel
    // abs + a 38-deep `if (a > amax)` chain inside an unrolled loop) was
    // retimed into ~1,000 pipeline registers -- 2,230 LUT cells in the OOC
    // netlist, the single largest bucket.  max() does not care about order,
    // so the value of amax (and bitlen(amax)) is unchanged.
    PT_MAX:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            ap_int<32> a = tokT[d][t];
            if (a < 0) a = -a;
            if (a > amax) amax = a;
        }

        int sh = bitlen_u32((ap_uint<32>)amax) - 11;
        if (sh < 0) sh = 0;

        // Narrow types are exact, not an approximation.  By construction
        // amax = max_d |tok| and sh = max(0, bitlen(amax) - 11), so
        // |z| <= 2047, hence |s1| <= 38*2047 < 2^17 and s2 <= 38*2^22 < 2^28.
        // Keeping the statistics 64-bit made HLS lower the constant divide by
        // 1444 into a 6-DSP, 4.5 ns multiplier (the design's critical path).
        ap_int<18> s1 = 0;
        ap_int<29> s2 = 0;
    // Both passes read tokT with a runtime `d` -- that is a BRAM address,
    // not a value mux, so the 38 banks and their 38:1 muxes never appear.
    LN_STAT:
        for (int i = 0; i < TOK_DIM; ++i) {
#pragma HLS PIPELINE II=1
            ap_int<32> cur = tokT[i][t];
            // 25 x 18 is exactly one DSP48E1 multiplier.
            ap_int<13> z = (ap_int<13>)(cur >> sh);
            s1 += z;
            s2 += (ap_int<29>)(((ap_int<25>)z) * ((ap_int<18>)z));
        }

        ap_int<19> s1x4 = (ap_int<19>)s1 * 4;
        ap_int<40> mu4  = (ap_int<40>)s1x4 / TOK_DIM;           // trunc division
        ap_int<35> s2x  = (ap_int<35>)s2;
        ap_int<35> p38  = (s2x << 5) + (s2x << 2) + (s2x << 1); // 38 * s2
        ap_int<43> sq   = ((ap_int<25>)s1) * ((ap_int<18>)s1);
        ap_int<40> num  = ((ap_int<40>)p38 - (ap_int<40>)sq) * 16;
        ap_int<40> var4 = num / 1444;
        if (var4 < 1) var4 = 1;
        ap_uint<32> r = isqrt_u32(var4);
        if (r == 0) r = 1;
        ap_uint<32> R = ((ap_uint<32>)1 << 22) / r;

    LN_APPLY:
        for (int i = 0; i < TOK_DIM; ++i) {
#pragma HLS PIPELINE II=1
            ap_int<32> cur = tokT[i][t];
            ap_int<32> z  = cur >> sh;
            ap_int<64> dd = (ap_int<64>)((ap_int<32>)((ap_int<32>)(z << 2) - (ap_int<32>)mu4));
            ap_int<64> n  = (dd * (ap_int<64>)R + 2048) >> 12;
            ap_int<64> y  = ((n * (ap_int<64>)NORM_W[i] + 512) >> 10)
                          + (ap_int<64>)NORM_B[i];
            lnT[i][t] = sat16((ap_int<32>)y);
        }
    }
}

// ---------------------------------------------------------------------------
// fc1 (38x38, bias) followed by the GELU epilogue.
// ---------------------------------------------------------------------------
static void fc1_gelu(const ap_int<16> lnT[TOK_DIM][N_TOKEN],
                     ap_int<32> preT[TOK_DIM][N_TOKEN],
                     ap_int<16> gelT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=FC1_W dim=1 complete

F1_TOKEN:
    for (int t = 0; t < N_TOKEN; ++t) {
        acc_t acc[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=acc dim=1 complete

    F1_INIT:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            acc[d] = (acc_t)FC1_B[d];
        }

    F1_MAC:
        for (int i = 0; i < TOK_DIM; ++i) {
#pragma HLS PIPELINE II=1
            ap_int<16> xv = lnT[i][t];
        F1_LANE:
            for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
                acc[d] += (acc_t)FC1_W[d][i] * (acc_t)xv;
            }
        }

    F1_EP:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            ap_int<32> p = rq<SH_FC1>(acc[d]);
            preT[d][t] = p;
            // GELU output is bounded by the LUT range for |p| < 8.0 and by p
            // itself above it; sat16 keeps the fc2 lane at 16x16 (measured
            // absmax 6,639 vs 32,767 -> >4x margin on real frames).
            gelT[d][t] = sat16(gelu_q8(p));
        }
    }
}

// ---------------------------------------------------------------------------
// fc2 (38x38, bias) + residual add + global average pooling.
// GAP is a sum over T (division by 4 is a floor shift, per the reference).
// ---------------------------------------------------------------------------
// The raw-token half of the residual is read back here from the caller's tokT
// BRAM (one word per cycle, runtime `d`), so no per-lane token accumulator is
// kept alive across the whole frame.
static void fc2_gap(const ap_int<16> gelT[TOK_DIM][N_TOKEN],
                    ap_int<32> fc2T[TOK_DIM][N_TOKEN],
                    ap_int<32> gap[TOK_DIM],
                    const ap_int<32> tokT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=FC2_W dim=1 complete

    acc_t ts = 0;   // running token sum for the current d (GAP_DIV)

    // One token's 38 requantized outputs, held just long enough to be pushed
    // into the fc2 BRAM one lane per cycle.
    ap_int<32> yreg[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=yreg dim=1 complete

F2_TOKEN:
    for (int t = 0; t < N_TOKEN; ++t) {
        acc_t acc[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=acc dim=1 complete

    F2_BIAS:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            acc[d] = (acc_t)FC2_B[d];
        }

    F2_MAC:
        for (int i = 0; i < TOK_DIM; ++i) {
#pragma HLS PIPELINE II=1
            ap_int<16> xv = gelT[i][t];
        F2_LANE:
            for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
                acc[d] += (acc_t)FC2_W[d][i] * (acc_t)xv;
            }
        }

    // Requantize all 38 lanes in parallel (no array read, all indices are
    // compile-time), then push them into the fc2 BRAM one per cycle.  Doing
    // the write serially is what lets the array be a single-port BRAM.
    F2_EP:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            yreg[d] = rq<SH_FC2>(acc[d]);
        }
    F2_WR:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            fc2T[d][t] = yreg[d];
        }
    }

    // Q_MLP == Q_TOKEN here, so the residual needs no rescale.  The fc2 half
    // and the raw-token half are now summed in one sweep, straight out of the
    // two BRAMs, instead of keeping 38 parallel 44-bit accumulators alive
    // across the whole token loop (those were 2,774 LUT in the OOC netlist:
    // 38 adders plus the 38:1 read-back mux).  Integer addition is exact and
    // associative, so adding y[d][t] + tok[d][t] term by term gives the same
    // 44-bit total -- the set of terms is identical, only the order changes,
    // and the worst case is 16*(2^31+2^31) = 2^37, well inside 44 bits.
GAP_DIV:
    // One flat sequential sweep (linear index == loop counter), so both BRAM
    // addresses are just the counter and the whole pass runs at II=1.
    for (int k = 0; k < TOK_DIM * N_TOKEN; ++k) {
#pragma HLS PIPELINE II=1
        int d = k / N_TOKEN;
        int t = k % N_TOKEN;               // N_TOKEN is a power of two
        acc_t v = (acc_t)tokT[d][t] + (acc_t)fc2T[d][t];
        ts = (t == 0) ? v : (acc_t)(ts + v);
        if (t == N_TOKEN - 1) {
            gap[d] = (ap_int<32>)(ts >> 4);
        }
    }
}

// ---------------------------------------------------------------------------
// Linear head 38 -> 20 (bias), output int16 logits.
// ---------------------------------------------------------------------------
static void head(const ap_int<32> gap[TOK_DIM], ap_int<16> logits[HEAD_CO]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=HEAD_W dim=1 complete

    acc_t acc[HEAD_CO];
#pragma HLS ARRAY_PARTITION variable=acc dim=1 complete

HD_INIT:
    for (int c = 0; c < HEAD_CO; ++c) {
#pragma HLS UNROLL
        acc[c] = (acc_t)HEAD_B[c];
    }

HD_MAC:
    for (int i = 0; i < TOK_DIM; ++i) {
#pragma HLS PIPELINE II=1
        ap_int<32> xv = gap[i];
    HD_LANE:
        for (int c = 0; c < HEAD_CO; ++c) {
#pragma HLS UNROLL
            acc[c] += (acc_t)HEAD_W[c][i] * (acc_t)xv;
        }
    }

HD_EP:
    for (int c = 0; c < HEAD_CO; ++c) {
#pragma HLS UNROLL
        logits[c] = sat16(rq<SH_HEAD>(acc[c]));
    }
}

// ---------------------------------------------------------------------------
// One frame end to end (no streams): used by both the IP top and the TB.
// ---------------------------------------------------------------------------
void LcwtMLP_RFFI_frame(const ap_int<16> xr0[SEG_LEN],
                        const ap_int<16> xi0[SEG_LEN],
                        ap_int<32> lcwt_r[SEG_LEN],
                        ap_int<32> lcwt_i[SEG_LEN],
                        ap_int<32> tokT[TOK_DIM][N_TOKEN],
                        ap_int<16> lnT[TOK_DIM][N_TOKEN],
                        ap_int<32> preT[TOK_DIM][N_TOKEN],
                        ap_int<16> gelT[TOK_DIM][N_TOKEN],
                        ap_int<32> fc2T[TOK_DIM][N_TOKEN],
                        ap_int<32> gap[TOK_DIM],
                        ap_int<16> logits[HEAD_CO]) {
#pragma HLS INLINE

    lcwt_t lr[LCWT_LEN], li[LCWT_LEN];
    lcwt_t hr[LCWT_HLEN], hi[LCWT_HLEN];

    ap_int<16> lns[TOK_DIM][N_TOKEN];
    // BRAM, not LUTRAM: both ends of this array are sequential in `d`
    // (LN_APPLY writes one element per cycle, F1_MAC reads one per cycle), so
    // a single-port BRAM costs no cycles and gives back ~600 LUTRAM.
    // The dim=1 partition must NOT be kept: a partitioned array can never be
    // a BRAM (the pragma silently does nothing -- measured in Resnet_RFFI).
#pragma HLS RESOURCE variable=lns core=RAM_1P_BRAM
    ap_int<32> pres[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=pres dim=1 complete
    ap_int<16> gels[TOK_DIM][N_TOKEN];
    // Same argument: F1_EP writes sequentially, F2_MAC reads sequentially.
#pragma HLS RESOURCE variable=gels core=RAM_1P_BRAM
    ap_int<32> fc2s[TOK_DIM][N_TOKEN];
    // BRAM, not registers: F2_WR fills it one lane per cycle and GAP_DIV sweeps
    // it linearly, so a single-port BRAM is enough.  Partitioning it (the old
    // form) made the GAP half's read-back a 38:1 mux over 38 live accumulators.
#pragma HLS RESOURCE variable=fc2s core=RAM_1P_BRAM
    ap_int<32> gps[TOK_DIM];
#pragma HLS RESOURCE variable=gps core=RAM_1P_BRAM   // see the note in _debug

// 1) input frame -> int32 LCWT level-0 buffer
CP_IN:
    for (int i = 0; i < SEG_LEN; ++i) {
#pragma HLS PIPELINE II=1
        lr[i] = (ap_int<32>)xr0[i];
        li[i] = (ap_int<32>)xi0[i];
    }

// 2) LCWT analysis + synthesis
    lcwt_analysis(lr, li, hr, hi);
    lcwt_synthesis(lr, li, hr, hi);

    for (int i = 0; i < SEG_LEN; ++i) {
#pragma HLS PIPELINE II=1
        lcwt_r[i] = lr[i];
        lcwt_i[i] = li[i];
    }

// 3+4) patch embed fused with LayerNorm; writes tokT and lnT directly
    patch_ln(lr, li, tokT, lns);

// 5) fc1 + GELU, then fc2 + residual + GAP, then head
    fc1_gelu(lns, pres, gels);
    fc2_gap(gels, fc2s, gps, tokT);
    head(gps, logits);

// 6) publish the debug stage buffers to the caller
CP_OUT_L:
    for (int t = 0; t < N_TOKEN; ++t) {
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            lnT[d][t]  = lns[d][t];
            preT[d][t] = pres[d][t];
            gelT[d][t] = gels[d][t];
            fc2T[d][t] = fc2s[d][t];
        }
    }
CP_OUT_G:
    for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
        gap[d] = gps[d];
    }
}

// ---------------------------------------------------------------------------
// Debug entry point (testbench only).
// ---------------------------------------------------------------------------
void LcwtMLP_RFFI_debug(const ap_int<16> x_in[SEG_LEN][2],
                        ap_int<32> lcwt_re[SEG_LEN],
                        ap_int<32> lcwt_im[SEG_LEN],
                        ap_int<32> tok[N_TOKEN][TOK_DIM],
                        ap_int<16> ln[N_TOKEN][TOK_DIM],
                        ap_int<32> pre[N_TOKEN][TOK_DIM],
                        ap_int<16> gelu[N_TOKEN][TOK_DIM],
                        ap_int<32> fc2[N_TOKEN][TOK_DIM],
                        ap_int<32> gap[TOK_DIM],
                        ap_int<16> logits[HEAD_CO]) {
    ap_int<16> xr0[SEG_LEN], xi0[SEG_LEN];
    for (int i = 0; i < SEG_LEN; ++i) {
        xr0[i] = x_in[i][0];
        xi0[i] = x_in[i][1];
    }

    ap_int<32> tokT[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=tokT dim=1 complete
    ap_int<16> lnT[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=lnT dim=1 complete
    ap_int<32> preT[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=preT dim=1 complete
    ap_int<16> gelT[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=gelT dim=1 complete
    ap_int<32> fc2T[TOK_DIM][N_TOKEN];
#pragma HLS ARRAY_PARTITION variable=fc2T dim=1 complete
    // gps is produced and consumed strictly in increasing `d` (GAP_DIV writes
    // it, the debug copy and the head MAC read it), so a single-port BRAM
    // turns all three passes into an address counter.  As registers it cost a
    // 38:1 32-bit read mux (352 LUT in the OOC netlist) plus 1,216 FFs.
    ap_int<32> gps[TOK_DIM];
#pragma HLS RESOURCE variable=gps core=RAM_1P_BRAM
    ap_int<16> lgs[HEAD_CO];
#pragma HLS ARRAY_PARTITION variable=lgs dim=1 complete

    LcwtMLP_RFFI_frame(xr0, xi0, lcwt_re, lcwt_im,
                       tokT, lnT, preT, gelT, fc2T, gps, lgs);

    for (int t = 0; t < N_TOKEN; ++t) {
        for (int d = 0; d < TOK_DIM; ++d) {
            tok[t][d]  = tokT[d][t];
            ln[t][d]   = lnT[d][t];
            pre[t][d]  = preT[d][t];
            gelu[t][d] = gelT[d][t];
            fc2[t][d]  = fc2T[d][t];
        }
    }
    for (int d = 0; d < TOK_DIM; ++d) gap[d] = gps[d];
    for (int c = 0; c < HEAD_CO; ++c) logits[c] = lgs[c];
}
