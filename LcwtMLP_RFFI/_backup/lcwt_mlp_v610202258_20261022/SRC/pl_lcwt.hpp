// ---------------------------------------------------------------------------
// pl_lcwt.hpp -- WaveMLP (LCWT + patch embed + residual MLP) block.
//
// The IP top level lives in top.cpp (LcwtMLP_RFFI).  This header exposes one
// extra entry point used only by the C testbench: it runs a single frame and
// returns every intermediate stage so they can be compared against the Python
// reference bit-for-bit.  The debug entry point is never reached from the
// synthesised top, so it costs nothing in hardware.
// ---------------------------------------------------------------------------
#ifndef PL_LCWT_HPP
#define PL_LCWT_HPP

#include <ap_int.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

#include "pl_lcwt_config.hpp"

// 32-bit AXI4-Stream beat.  ap_axiu lives in the global namespace.
typedef ap_axiu<OUT_W, 0, 0, 0> beat_t;

// One frame end to end, no streams.  Declared here because top.cpp (the IP
// top level) and the testbench both go through it.
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
                        ap_int<16> logits[HEAD_CO]);

// Debug entry: one frame in, all stages out (frame 0 of the golden set).
// Stage layouts are token-major [t][d] exactly like the Python reference.
void LcwtMLP_RFFI_debug(const ap_int<16> x_in[SEG_LEN][2],
                        ap_int<32> lcwt_re[SEG_LEN],
                        ap_int<32> lcwt_im[SEG_LEN],
                        ap_int<32> tok[N_TOKEN][TOK_DIM],
                        ap_int<16> ln[N_TOKEN][TOK_DIM],
                        ap_int<32> pre[N_TOKEN][TOK_DIM],
                        ap_int<16> gelu[N_TOKEN][TOK_DIM],
                        ap_int<32> fc2[N_TOKEN][TOK_DIM],
                        ap_int<32> gap[TOK_DIM],
                        ap_int<16> logits[HEAD_CO]);

#endif
