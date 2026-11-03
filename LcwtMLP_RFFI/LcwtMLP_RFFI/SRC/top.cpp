// ---------------------------------------------------------------------------
// top.cpp -- IP top level: stream in, 8 frames, stream out.
//
// Interface matches RFFI_FFT_ConvNet (33-bit FIFO read side + one 32-bit axis
// output with TLAST per frame), so the block design / DMA plumbing does not
// change.  See top.hpp for the exact word and beat layouts.
// ---------------------------------------------------------------------------
#include "top.hpp"
#include "pl_lcwt.hpp"

#include <ap_int.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

// ---------------------------------------------------------------------------
// Receive one frame from the FIFO read side.
//   256 words, each {last, Q[15:0], I[15:0]}.
//   If `last` arrives early the frame is zero padded and the port is no longer
//   read (the loop stays a fixed 256 beats, which keeps the worst-case latency
//   bounded and the frame boundary deterministic).
// ---------------------------------------------------------------------------
static void rx_frame(hls::stream<ap_uint<33> >& din,
                     ap_int<16> xr[SEG_LEN],
                     ap_int<16> xi[SEG_LEN]) {
#pragma HLS INLINE
    ap_uint<1> fin = 0;
RX:
    for (int i = 0; i < SEG_LEN; ++i) {
#pragma HLS PIPELINE II=1
        ap_uint<33> w = 0;
        if (!fin) {
            w   = din.read();
            fin = w[32];
        }
        xr[i] = (ap_int<16>)w.range(15, 0);    // I
        xi[i] = (ap_int<16>)w.range(31, 16);   // Q
    }
}

// Local int32 -> int16 saturation (pl_lcwt.cpp keeps its own static copy).
static inline ap_int<16> sat16o(ap_int<32> v) {
#pragma HLS INLINE
    if (v > 32767) v = 32767;
    if (v < -32768) v = -32768;
    return (ap_int<16>)v;
}

// ---------------------------------------------------------------------------
// Emit one frame: 304 token beats, TLAST on the last one (2026-10-22: the
// 10 logit beats were removed with the MLP).  Token packing is done on 32-bit
// words straight out of tokT, so the drain loop needs only two array reads
// per beat.
// ---------------------------------------------------------------------------
static void drain_frame(hls::stream<beat_t>& dout,
                        const ap_int<32> tokT[TOK_DIM][N_TOKEN]) {
#pragma HLS INLINE

DR_TOK:
    for (int t = 0; t < N_TOKEN; ++t) {
        for (int j = 0; j < TOK_WORDS; ++j) {
#pragma HLS PIPELINE II=1
            beat_t b;
            ap_int<32> v0 = (tokT[2 * j][t] + 8) >> TOK_OUT_SHIFT;
            ap_int<32> v1 = (tokT[2 * j + 1][t] + 8) >> TOK_OUT_SHIFT;
            ap_int<16> s0 = sat16o(v0);
            ap_int<16> s1 = sat16o(v1);
            b.data = ((ap_uint<32>)(ap_uint<16>)s1 << 16)
                   | (ap_uint<32>)(ap_uint<16>)s0;
            b.keep = 0xF;
            b.strb = 0xF;
            b.last = (t == N_TOKEN - 1 && j == TOK_WORDS - 1) ? 1 : 0;
            dout.write(b);
        }
    }
}

// ---------------------------------------------------------------------------
// Top level.
// ---------------------------------------------------------------------------
void LcwtMLP_RFFI(hls::stream<ap_uint<33> >& din,
                  hls::stream<beat_t>& dout) {
#pragma HLS INTERFACE axis port=dout
    // No interface pragma for din: a bare hls::stream argument already maps to
    // the ap_fifo read side (dout shows the axis sidebands).

    ap_int<16> xr0[SEG_LEN], xi0[SEG_LEN];

    ap_int<32> tokT[TOK_DIM][N_TOKEN];
    // BRAM, not LUTRAM.  tokT is written one element per cycle (PT_WR) and
    // read two elements per beat (drain_frame), so a two-port BRAM covers both
    // sides with no extra cycles -- unlike the dim=1-partitioned copy inside
    // the frame, which has to be 38-wide.
#pragma HLS RESOURCE variable=tokT core=RAM_2P_BRAM

FRAME:
    for (int f = 0; f < N_FRAMES; ++f) {
        rx_frame(din, xr0, xi0);
        LcwtMLP_RFFI_frame(xr0, xi0, tokT);
        drain_frame(dout, tokT);
    }
}
