// ---------------------------------------------------------------------------
// top.hpp -- IP top level for the WaveMLP (LCWT + patch embed + residual MLP).
//
// The streaming interface is IDENTICAL to RFFI_FFT_ConvNet so the block design
// does not change:
//
//   input   : 33-bit FIFO read side (FIFO lives in the PL), word layout
//             {last[32], Q[31:16], I[15:0]} in Q10 codes, 256 beats/frame,
//             8 frames per function call.
//             ports: din_V_V_dout / din_V_V_empty_n / din_V_V_read
//
//   output  : ONE 32-bit AXI4-Stream, 314 beats per frame, TLAST on the last
//             beat of every frame.
//               beat   0 .. 303 : tokens, 2 x INT16 per beat, 19 beats/token
//                                 [15:0]  = sat16((tok[t][2j]   + 8) >> 4)
//                                 [31:16] = sat16((tok[t][2j+1] + 8) >> 4)
//                                 beat index = t * 19 + j
//               beat 304 .. 313 : logits, 2 x INT16 per beat
//                                 [15:0] = logits[2j], [31:16] = logits[2j+1]
//             ports: dout_TDATA / dout_TVALID / dout_TREADY /
//                    dout_TKEEP / dout_TSTRB / dout_TLAST
//
// Do NOT put "#pragma HLS INTERFACE ap_fifo port=din" on the stream: it is a
// hard compile error in 2018.3 (the variadic _ssdm_op_SpecInterface needs a
// by-value POD).  A bare hls::stream<T>& argument already has the ap_fifo
// read-side interface.  The "axis" pragma IS legal on a stream, and that is
// what gives dout its TLAST/TKEEP/TSTRB sidebands; for that the element type
// must be ap_axiu<32,0,0,0> (global namespace, not hls::).
// ---------------------------------------------------------------------------
#ifndef LCWT_MLP_RFFI_TOP_HPP
#define LCWT_MLP_RFFI_TOP_HPP

#include <ap_int.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

#include "pl_lcwt_config.hpp"

typedef ap_axiu<OUT_W, 0, 0, 0> beat_t;

void LcwtMLP_RFFI(hls::stream<ap_uint<33> >& din,
                  hls::stream<beat_t>& dout);

#endif
