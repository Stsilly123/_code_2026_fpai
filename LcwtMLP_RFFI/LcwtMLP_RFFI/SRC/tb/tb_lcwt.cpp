// ---------------------------------------------------------------------------
// tb_lcwt.cpp -- C simulation testbench for the WaveMLP PL front end.
//
// 2026-10-22: the residual MLP and the head were removed, so this bench now
// covers the LCWT + patch-embed path only.  Checks, in order:
//   1. stream protocol : 8 x 304 beats, TLAST exactly on beat 303 of a frame,
//                        TKEEP/TSTRB all ones, 2432 beats total (no extras)
//   2. stream tokens   : frame 0 tokens bit-exact vs sat16((tok+8)>>4)
//   3. internal stages : LCWT re/im and tok bit-exact vs the Python reference
//                        (frame 0), via the debug entry
//   4. non-degeneracy  : no stage may be all zero and frames must not be
//                        identical (a silent fixed-point collapse would
//                        otherwise "pass" a bit-exact comparison of zeros)
//
// Golden vectors were produced by SRC/tools/export_pl_lcwt_hls.py; the header
// pl_lcwt_weights.hpp comes from the same run.
// ---------------------------------------------------------------------------
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "../top.hpp"
#include "../pl_lcwt.hpp"
#include "../pl_lcwt_weights.hpp"

static const int NG = 8;    // frames in the golden set

// ---------------------------------------------------------------------------
// Golden file loader (csim runs from <solution>/csim/build).
// ---------------------------------------------------------------------------
static void read_bin(const char* name, int n, int* buf) {
    // csim runs from <proj>/<sol>/csim/build, which sits beside the workspace
    // folder, and that folder has the same name as the project -- so try both
    // "<up>/SRC/tb/golden" and "<up>/LcwtMLP_RFFI/SRC/tb/golden" for a range
    // of depths instead of hard-coding one path.
    FILE* fp = NULL;
    char up[64];
    char path[512];
    up[0] = 0;
    for (int d = 0; d <= 8 && fp == NULL; ++d) {
        static const char* forms[2] = { "%sSRC/tb/golden/%s",
                                        "%sLcwtMLP_RFFI/SRC/tb/golden/%s" };
        for (int k = 0; k < 2 && fp == NULL; ++k) {
            snprintf(path, sizeof(path), forms[k], up, name);
            fp = fopen(path, "rb");
        }
        if (fp == NULL) strncat(up, "../", sizeof(up) - strlen(up) - 1);
    }
    if (fp == NULL) {
        printf("FATAL: cannot open golden file %s\n", name);
        exit(1);
    }
    int got = (int)fread(buf, 4, (size_t)n, fp);
    fclose(fp);
    if (got != n) {
        printf("FATAL: %s has %d int32 values, expected %d\n", name, got, n);
        exit(1);
    }
}


static int g_fail = 0;

// Compare n int32 values; prints the first mismatch and a min/max/nonzero
// summary (so a collapsed stage is visible even when it matches).
static void cmp_i32(const char* stage, const int* got, const int* exp, int n) {
    int bad = 0, first = -1;
    long mn = 0, mx = 0, nz = 0;
    for (int i = 0; i < n; ++i) {
        if (got[i] < mn) mn = got[i];
        if (got[i] > mx) mx = got[i];
        if (got[i] != 0) ++nz;
        if (got[i] != exp[i]) {
            if (first < 0) first = i;
            ++bad;
        }
    }
    if (bad == 0) {
        printf("  %-10s OK    %5d values bit-exact   range[%6ld,%6ld] nonzero %4ld/%4d\n",
               stage, n, mn, mx, nz, n);
    } else {
        printf("  %-10s FAIL  %5d/%d mismatch, first at %d: got %d expected %d\n",
               stage, bad, n, first, got[first], exp[first]);
        g_fail = 1;
    }
    if (nz == 0) {
        printf("  %-10s FAIL  all zero (degenerate) -> comparison is meaningless\n", stage);
        g_fail = 1;
    }
}

static inline int sat16i(long v) {
    if (v > 32767) return 32767;
    if (v < -32768) return -32768;
    return (int)v;
}

// ---------------------------------------------------------------------------
int main() {
    static int xin[NG][SEG_LEN][2];
    static int g_lr[SEG_LEN], g_li[SEG_LEN];
    static int g_tok[N_TOKEN * TOK_DIM];

    printf("== WaveMLP PL front-end testbench (LCWT + tokens) ==\n");
    read_bin("x_in.bin", NG * SEG_LEN * 2, &xin[0][0][0]);
    read_bin("gold_lcwt_re.bin", SEG_LEN, g_lr);
    read_bin("gold_lcwt_im.bin", SEG_LEN, g_li);
    read_bin("gold_tok.bin", N_TOKEN * TOK_DIM, g_tok);
    printf("  golden vectors loaded (%d frames)\n", NG);

    // ---- 1. drive the top with 8 frames on the 33-bit FIFO read side ------
    hls::stream<ap_uint<33> > s_din;
    hls::stream<beat_t>       s_dout;

    for (int f = 0; f < NG; ++f) {
        for (int i = 0; i < SEG_LEN; ++i) {
            ap_uint<33> w;
            w.range(15, 0)  = (ap_uint<16>)(ap_int<16>)xin[f][i][0];   // I
            w.range(31, 16) = (ap_uint<16>)(ap_int<16>)xin[f][i][1];   // Q
            w[32] = (i == SEG_LEN - 1) ? 1 : 0;
            s_din.write(w);
        }
    }

    LcwtMLP_RFFI(s_din, s_dout);

    // ---- 2. drain and unpack the output stream ---------------------------
    // Every beat is a token beat now: beats per frame == FRAME_BEATS == 304.
    static int st_tok[NG][N_TOKEN][TOK_DIM];
    int nbeat = 0, last_bad = 0, side_bad = 0, extra = 0;
    for (int f = 0; f < NG; ++f) {
        for (int b = 0; b < FRAME_BEATS; ++b) {
            if (s_dout.empty()) {
                printf("FATAL: output stream ended at frame %d beat %d\n", f, b);
                exit(1);
            }
            beat_t o = s_dout.read();
            ++nbeat;
            ap_uint<32> d = o.data;
            int i16lo = (int)(ap_int<16>)(ap_uint<16>)d.range(15, 0);
            int i16hi = (int)(ap_int<16>)(ap_uint<16>)d.range(31, 16);

            if ((int)o.last != (b == FRAME_BEATS - 1 ? 1 : 0)) ++last_bad;
            if (o.keep != 0xF || o.strb != 0xF) ++side_bad;

            int t = b / TOK_WORDS;
            int j = b - t * TOK_WORDS;
            st_tok[f][t][2 * j]     = i16lo;
            st_tok[f][t][2 * j + 1] = i16hi;
        }
    }
    while (!s_dout.empty()) { (void)s_dout.read(); ++extra; }

    printf("  stream: %d beats (expect %d), leftover %d\n",
           nbeat, NG * FRAME_BEATS, extra);
    if (extra != 0 || nbeat != NG * FRAME_BEATS) g_fail = 1;
    printf("  TLAST placement : %s (%d bad frames)\n",
           last_bad ? "FAIL" : "OK", last_bad);
    printf("  TKEEP/TSTRB     : %s (%d bad beats)\n",
           side_bad ? "FAIL" : "OK", side_bad);
    if (last_bad || side_bad) g_fail = 1;

    // ---- 3. stream tokens (frame 0) vs sat16((tok+8)>>4) -----------------
    printf("-- stream tokens (frame 0) --\n");
    {
        static int got[N_TOKEN * TOK_DIM], exp[N_TOKEN * TOK_DIM];
        for (int i = 0; i < N_TOKEN * TOK_DIM; ++i) {
            got[i] = ((int*)st_tok[0])[i];
            exp[i] = sat16i(((long)g_tok[i] + 8) >> 4);
        }
        cmp_i32("tok_out", got, exp, N_TOKEN * TOK_DIM);
    }

    // ---- 4. internal stages (frame 0), via the debug entry ---------------
    printf("-- internal stages (frame 0) --\n");
    {
        static ap_int<16> x16[SEG_LEN][2];
        static ap_int<32> lr[SEG_LEN], li[SEG_LEN];
        static ap_int<32> tok[N_TOKEN][TOK_DIM];

        for (int i = 0; i < SEG_LEN; ++i) {
            x16[i][0] = (ap_int<16>)xin[0][i][0];
            x16[i][1] = (ap_int<16>)xin[0][i][1];
        }

        LcwtMLP_RFFI_debug(x16, lr, li, tok);

        static int a[SEG_LEN];
        static int v[N_TOKEN * TOK_DIM];

        for (int i = 0; i < SEG_LEN; ++i) a[i] = (int)lr[i];
        cmp_i32("lcwt_re", a, g_lr, SEG_LEN);
        for (int i = 0; i < SEG_LEN; ++i) a[i] = (int)li[i];
        cmp_i32("lcwt_im", a, g_li, SEG_LEN);

        for (int i = 0; i < N_TOKEN * TOK_DIM; ++i) v[i] = (int)((ap_int<32>*)tok)[i];
        cmp_i32("tok", v, g_tok, N_TOKEN * TOK_DIM);
    }

    // ---- 5. non-degeneracy across frames ---------------------------------
    printf("-- non-degeneracy --\n");
    {
        int diff = 0;
        for (int i = 0; i < N_TOKEN * TOK_DIM; ++i)
            if (((int*)st_tok[0])[i] != ((int*)st_tok[1])[i]) ++diff;
        printf("  frame0 vs frame1 stream tokens differ in %d/%d\n",
               diff, N_TOKEN * TOK_DIM);
        if (diff == 0) {
            printf("  FAIL: identical frames -> the datapath is not data dependent\n");
            g_fail = 1;
        }
        // Also pin that the stream is not a constant: at least two distinct
        // Q4 codes must appear across the 8 frames.
        int distinct = 0;
        for (int i = 0; i < N_TOKEN * TOK_DIM && distinct < 2; ++i) {
            if (((int*)st_tok[0])[i] != ((int*)st_tok[0])[0]) distinct = 1;
        }
        printf("  frame0 token codes are non-constant: %s\n",
               distinct ? "OK" : "FAIL");
        if (!distinct) g_fail = 1;
    }

    if (g_fail) {
        printf("**FAIL**\n");
        return 1;
    }
    printf("**PASS**\n");
    return 0;
}
