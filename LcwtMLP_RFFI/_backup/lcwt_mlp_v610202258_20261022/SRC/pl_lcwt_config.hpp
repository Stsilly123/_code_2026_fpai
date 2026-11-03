// ---------------------------------------------------------------------------
// pl_lcwt_config.hpp -- constants shared by the HLS design.
//
// They are a mirror of SRC/tools/export_pl_lcwt_hls.py and must stay in sync
// with it.  The Python side is the *normative* fixed-point reference: every
// shift / rounding / saturation rule implemented in C++ is the one written
// there, and the testbench compares the two bit-for-bit.
// ---------------------------------------------------------------------------
#ifndef PL_LCWT_CONFIG_HPP
#define PL_LCWT_CONFIG_HPP

// ---- model shape ----------------------------------------------------------
static const int SEG_LEN    = 256;   // IQ samples per frame
static const int N_LEVEL    = 4;     // LCWT decomposition levels (J)
static const int LCWT_K     = 16;    // LCWT filter length
static const int N_TOKEN    = 16;    // SEG_LEN / PATCH_STRIDE
static const int PATCH_STRIDE = 16;
static const int TOK_DIM    = 38;    // embed dim D
static const int HEAD_CO    = 20;    // classes
static const int N_FRAMES   = 8;     // frames per function call
static const int PATCH_IN   = 2 * LCWT_K;  // patch input width (re||im)

// ---- fixed-point formats --------------------------------------------------
static const int Q_IN    = 10;   // 33-bit FIFO word carries round(x*1024)
static const int Q_LCWT  = 10;
static const int Q_TOKEN = 8;
static const int Q_NORM  = 10;
static const int Q_MLP   = 8;

static const int QW_LCWT  = 13;
static const int QW_PATCH = 14;
static const int QW_NORM  = 10;
static const int QW_MLP   = 12;

// requantisation right shifts (must equal the Python SH_* values)
static const int SH_AN0   = Q_IN    + QW_LCWT  - Q_LCWT;   // 13  (level 0)
static const int SH_AN    = Q_LCWT  + QW_LCWT  - Q_LCWT;   // 13  (levels 1..3)
static const int SH_SYN   = Q_LCWT  + QW_LCWT  - Q_LCWT;   // 13
static const int SH_PATCH = Q_LCWT  + QW_PATCH - Q_TOKEN;  // 16
static const int SH_FC1   = Q_NORM  + QW_MLP   - Q_MLP;    // 14
static const int SH_FC2   = Q_MLP   + QW_MLP   - Q_MLP;    // 12
static const int SH_HEAD  = Q_MLP   + QW_MLP   - Q_MLP;    // 12

// ---- LCWT MAC parallelism -------------------------------------------------
// The analysis point loop does 8 products per tap (2 bands x 2 comps, each
// 2 complex terms) and the synthesis loop does 16 products per tap.  Fully
// unrolling them makes HLS instantiate 128 (analysis) + 128 (synthesis)
// 32-bit multipliers -- 823 DSP / 161k FF, i.e. 205% of the device.  These
// factors bound the lane count instead; latency is explicitly allowed to grow
// (the CNN reference is ~2.6k cycles/frame, this design is far below the
// 1 ms application budget either way).
//   analysis lanes = AN_UR * 8   multipliers, ~2 DSP each
//   synthesis lanes = SY_UR * 16 multipliers, ~2 DSP each
static const int AN_UR = 4;   // 16 taps / 4 = 4 iterations per point
static const int SY_UR = 2;   // 8 taps  / 2 = 4 iterations per point

// ---- GELU lookup table (Q8, [-8, 8], step 1/64, linear interpolation) ------
static const int GELU_LUT_SIZE = 1025;
static const int GELU_OFFSET   = 2048;   // Q8 code of +8.0
// The table is stored as (value + GELU_LUT_BIAS) so every entry is non-negative.
// HLS 2018.3 generated a zero-extending DSP "ama" for the signed lerp
// (assign b = $unsigned(in2) in LcwtMLP_RFFI_ama_*.v), which corrupted every
// LUT entry below zero in RTL while csim stayed correct.  Biasing makes the
// whole datapath unsigned; (4-frac)+frac == 4 and BIAS*4 >> 2 == BIAS exactly,
// so the result after the subtract is bit-identical to the signed formula.
static const int GELU_LUT_BIAS = 8192;

// ---- output stream contract ----------------------------------------------
// 32-bit beats, TLAST on the last beat of every frame:
//   beat 0 .. 303 : tokens, 2 x INT16 per beat, 19 beats per token
//                   word[15:0]  = sat16((tok[t][2j]   + 8) >> 4)   (Q4)
//                   word[31:16] = sat16((tok[t][2j+1] + 8) >> 4)
//                   beat index  = t * 19 + j
//   beat 304..313 : logits, 2 x INT16 per beat
//                   word[15:0]  = logits[2j], word[31:16] = logits[2j+1]
static const int OUT_W          = 32;
static const int TOK_WORDS      = TOK_DIM / 2;            // 19
static const int TOK_BEATS      = N_TOKEN * TOK_WORDS;    // 304
static const int LOG_BEATS      = HEAD_CO / 2;            // 10
static const int FRAME_BEATS    = TOK_BEATS + LOG_BEATS;  // 314
static const int TOK_OUT_SHIFT  = 4;                      // Q8 -> Q4

#endif
