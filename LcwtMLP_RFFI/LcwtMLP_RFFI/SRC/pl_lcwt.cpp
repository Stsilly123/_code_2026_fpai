// ---------------------------------------------------------------------------
// pl_lcwt.cpp -- WaveMLP *front end*: LCWT + patch embed only (2026-10-22).
//
// The LayerNorm, fc1/GELU, fc2/GAP and the linear head were removed together
// with the MLP; this file now stops at the 16 x 38 Q8 token matrix.  What
// remains is a direct integer mirror of SRC/tools/export_pl_lcwt_hls.py.
// The Python side is normative: rounding is "add 2^(S-1), arithmetic shift".
// Do not "simplify" any of it.
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
// Patch embedding (2026-10-22: the per-token LayerNorm that used to be fused
// into this pass was removed together with the MLP).
//
// Conv1d(2 -> 38, k=16, s=16), no padding, no kernel flip:
//   tok[t][d] = bias[d] + sum_{c,k} W[d][c*16+k] * lcwt[c][16t+k]
//
// The 38 lanes are rounded in parallel (`vv`, all indices compile-time) and
// then pushed into the caller's `tokT` BRAM one lane per cycle.  `tokT` has to
// be filled for this token anyway, so the serialised store costs no extra
// cycles compared with an unrolled write (a single-port BRAM could not take
// all 38 in one cycle either).  The old fused-LN comments about `toks` and the
// 38:1 muxes no longer apply -- there is no second pass reading tokT back.
// ---------------------------------------------------------------------------
static void patch_embed(const lcwt_t lr[LCWT_LEN],
                        const lcwt_t li[LCWT_LEN],
                        ap_int<32> tokT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE
#pragma HLS ARRAY_PARTITION variable=PATCH_W dim=1 complete
#pragma HLS ARRAY_PARTITION variable=PATCH_B dim=1 complete

PL_TOKEN:
    for (int t = 0; t < N_TOKEN; ++t) {
        acc_t acc[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=acc dim=1 complete
        ap_int<32> vv[TOK_DIM];
#pragma HLS ARRAY_PARTITION variable=vv dim=1 complete

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

    PT_STORE:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS UNROLL
            vv[d] = rq<SH_PATCH>(acc[d]);
        }

    PT_WR:
        for (int d = 0; d < TOK_DIM; ++d) {
#pragma HLS PIPELINE II=1
            tokT[d][t] = vv[d];
        }
    }
}

// ---------------------------------------------------------------------------
// LCWT + patch embed core.  The level buffers are owned by the caller so the
// debug entry can read the post-synthesis LCWT result without forcing the
// synthesised top to copy it out (the top no longer needs lcwt_r/lcwt_i).
// ---------------------------------------------------------------------------
static void lcwt_patch_core(const ap_int<16> xr0[SEG_LEN],
                            const ap_int<16> xi0[SEG_LEN],
                            ap_int<32> tokT[TOK_DIM][N_TOKEN],
                            lcwt_t lr[LCWT_LEN], lcwt_t li[LCWT_LEN],
                            lcwt_t hr[LCWT_HLEN], lcwt_t hi[LCWT_HLEN]) {
#pragma HLS INLINE

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

// 3) patch embed -> tokT (Q8)
    patch_embed(lr, li, tokT);
}

// ---------------------------------------------------------------------------
// One frame end to end (no streams), used by the IP top.  No MLP: the frame
// ends at the 38 x 16 Q8 token matrix.
// ---------------------------------------------------------------------------
void LcwtMLP_RFFI_frame(const ap_int<16> xr0[SEG_LEN],
                        const ap_int<16> xi0[SEG_LEN],
                        ap_int<32> tokT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE

    lcwt_t lr[LCWT_LEN], li[LCWT_LEN];
    lcwt_t hr[LCWT_HLEN], hi[LCWT_HLEN];

    lcwt_patch_core(xr0, xi0, tokT, lr, li, hr, hi);
}

// ---------------------------------------------------------------------------
// Debug entry point (testbench only).
// ---------------------------------------------------------------------------
void LcwtMLP_RFFI_debug(const ap_int<16> x_in[SEG_LEN][2],
                        ap_int<32> lcwt_re[SEG_LEN],
                        ap_int<32> lcwt_im[SEG_LEN],
                        ap_int<32> tok[N_TOKEN][TOK_DIM]) {
    ap_int<16> xr0[SEG_LEN], xi0[SEG_LEN];
    for (int i = 0; i < SEG_LEN; ++i) {
        xr0[i] = x_in[i][0];
        xi0[i] = x_in[i][1];
    }

    // tokT is written by PT_WR one lane per cycle and copied out once, so the
    // debug copy can sweep it linearly; no need to partition it (and a
    // partitioned array could never be a BRAM).
    ap_int<32> tokT[TOK_DIM][N_TOKEN];

    lcwt_t lr[LCWT_LEN], li[LCWT_LEN];
    lcwt_t hr[LCWT_HLEN], hi[LCWT_HLEN];

    lcwt_patch_core(xr0, xi0, tokT, lr, li, hr, hi);

    for (int i = 0; i < SEG_LEN; ++i) {
        lcwt_re[i] = (ap_int<32>)lr[i];
        lcwt_im[i] = (ap_int<32>)li[i];
    }
    for (int t = 0; t < N_TOKEN; ++t) {
        for (int d = 0; d < TOK_DIM; ++d) {
            tok[t][d] = tokT[d][t];
        }
    }
}
