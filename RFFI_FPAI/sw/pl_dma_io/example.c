/*
 * example.c —— 上层程序怎么用 pl_dma_io（照这几十行抄）
 *
 * 编： aarch64-linux-gnu-gcc -O2 -static -I. example.c -L. -lpl_dma_io -o example
 * 跑： root 下 ./example [轮数] [--zerocopy]      （要 /dev/mem 和 /dev/udmabuf0）
 *
 * 三个概念，记住就够：
 *   ① 一次 xfer = 8192 B 进去（8 帧 IQ）+ 9728 B 出来（8 帧 dout），返回实收字节数；
 *   ② 块内是 8 帧，每帧 1216 B = 304 拍 × 2×int16(Q4) token，帧边界 PL 已经切好了；
 *      旧版帧末那 40 B logits 已随 HLS MLP 一起删掉，分类要在软件侧做；
 *   ③ 返回 9728 才算这轮干净。不够就是短帧，只有前 got 字节可信 —— 库自己会排空，
 *      你不用管下一轮，但这一轮的数据别用。
 *
 * 均衡（axi_dma_2）和专家特征（axi_dma_3, 0x80430000）是**两条独立的流**：
 * 一次 xfer 灌进去的 8 帧输入，同时让均衡器和专家模块各产出 8 帧 × 1024 B。
 * 所以每轮 xfer 之后 eq_recv / expert_recv 各来一次，顺序不能反、也不能攒着
 * 不收 —— 上游只有 8 个槽，满了就丢输入 / 反压。
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "pl_dma_io.h"

#define FRAME      PL_DMA_FRAME_OUT_BYTES   /* 1216 */
#define N_FRAMES   PL_DMA_N_FRAMES_OUT      /* 8    */
#define TOK_BYTES  PL_DMA_TOK_FRAME_BYTES   /* 1216（整帧都是 token） */
#define EQ_FRAME   PL_DMA_EQ_FRAME_BYTES    /* 1024 */
#define EXP_FRAME  PL_DMA_EXP_FRAME_BYTES   /* 1024 */

/* ── 一次调用 ────────────────────────────────────────────────────────────────
 * iq   : 8192 B，打包顺序 [15:0]=I0 [31:16]=Q0 [47:32]=I1 [63:48]=Q1
 * dout : 9728 B，收不下就返回 <0，别读它
 * 返回 0 = 干净的一轮；-1 = 失败，原因在 errno */
static int infer_once(pl_dma_io *io, const void *iq, uint8_t *dout)
{
    long got = pl_dma_io_xfer(io, iq, PL_DMA_CALL_IN_BYTES, dout, PL_DMA_CALL_OUT_BYTES);

    if (got < 0) {
        fprintf(stderr, "xfer 失败: %s\n", strerror(errno));   /* EINVAL/ETIMEDOUT/EIO */
        return -1;
    }
    if (got != PL_DMA_CALL_OUT_BYTES) {
        fprintf(stderr, "没收满：%ld / %u 字节 —— 这轮作废\n", got, PL_DMA_CALL_OUT_BYTES);
        return -1;
    }
    return 0;
}

/* ── 一帧怎么解（IP 改动说明 2026-10-22 §4.2）────────────────────────────────
 * 拍 0..303 = 304 拍 × 2 个 INT16 = 1216 B token（Q4：物理值 = code / 16）
 *   拍序 token-major：b = t*19 + j，t = 0..15，j = 0..18
 * 每拍低半字在前（小端）。**TLAST 在第 303 拍**（旧版 313，因为 logits 删了）；
 * AXI DMA 里读不到 TLAST，所以"这帧齐了没"靠 xfer 的返回值和帧长判。 */
static int16_t rd_le16(const uint8_t *p)
{
    return (int16_t)(uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static void dump_frame(const uint8_t *f, int which)
{
    int16_t t0 = rd_le16(f + 0), t1 = rd_le16(f + 2);
    int16_t t2 = rd_le16(f + 4), t3 = rd_le16(f + 6);

    printf("  帧 %d: tok[0..3]=%d,%d,%d,%d (Q4: %.2f,%.2f,%.2f,%.2f)\n",
           which, t0, t1, t2, t3, t0 / 16.0, t1 / 16.0, t2 / 16.0, t3 / 16.0);
}

/* ── 均衡那一路：8 帧 × 1024 B，每拍 {Q[31:16], I[15:0]}，int16/Q10 ───────── */
static int eq_once(pl_dma_io *io, uint8_t *eq, uint32_t *got)
{
    long n = pl_dma_io_eq_recv(io, eq, PL_DMA_EQ_CALL_BYTES, got);

    if (n < 0) {
        fprintf(stderr, "eq_recv 失败: %s\n", strerror(errno));
        return -1;
    }
    if (n != PL_DMA_EQ_CALL_BYTES) {
        fprintf(stderr, "eq 没收满：%ld / %u 字节 —— 这一轮均衡作废\n",
                n, PL_DMA_EQ_CALL_BYTES);
        return -1;
    }
    return 0;
}

static void dump_eq_frame(const uint8_t *f, int which)
{
    int16_t i0 = rd_le16(f + 0), q0 = rd_le16(f + 2);
    int16_t i1 = rd_le16(f + 4), q1 = rd_le16(f + 6);

    printf("  eq 帧 %d: I/Q[0]=%d/%d (%.3f/%.3f)  I/Q[1]=%d/%d (%.3f/%.3f)\n",
           which, i0, q0, i0 / 1024.0, q0 / 1024.0,
           i1, q1, i1 / 1024.0, q1 / 1024.0);
}

/* ── 专家特征那一路（axi_dma_3 = 0x80430000）：8 帧 × 1024 B ─────────────────
 * 每帧 256 字：字 0..192 = 193 个 int32(Q12，物理值 = code / 4096)，
 * 字 193 = magic "EXF1"，194 = 版本，195 = 帧号，196 = 12，197 = flags。 */
static int exp_once(pl_dma_io *io, uint8_t *ex, uint32_t *got)
{
    long n = pl_dma_io_expert_recv(io, ex, PL_DMA_EXP_CALL_BYTES, got);

    if (n < 0) {
        fprintf(stderr, "expert_recv 失败: %s\n", strerror(errno));
        return -1;
    }
    if (n != PL_DMA_EXP_CALL_BYTES) {
        fprintf(stderr, "专家没收满：%ld / %u 字节 —— 这一轮专家特征作废\n",
                n, PL_DMA_EXP_CALL_BYTES);
        return -1;
    }
    return 0;
}

static uint32_t rd_le32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void dump_exp_frame(const uint8_t *f, int which)
{
    uint32_t magic = rd_le32(f + 193 * 4);
    uint32_t idx   = rd_le32(f + 195 * 4);
    int32_t  f0    = (int32_t)rd_le32(f + 0 * 4);
    int32_t  f1    = (int32_t)rd_le32(f + 1 * 4);

    printf("  专家帧 %d: magic=%#010x 帧号=%u  feature[0..1]=%d,%d (Q12: %.4f,%.4f)%s\n",
           which, magic, idx, f0, f1, f0 / 4096.0, f1 / 4096.0,
           magic == PL_DMA_EXP_MAGIC ? "" : "  ← magic 不对，buffer 陈旧或错位");
}

/* ── 输入图案：随便一对 I/Q，规则是"一个 int32 = [15:0]I [31:16]Q" ───────── */
static void fill_iq(uint8_t *iq, int round)
{
    for (int beat = 0; beat < 1024; beat++) {          /* 1024 个 64bit beat */
        for (int w = 0; w < 2; w++) {                   /* 每个 beat 两个 32bit 字 */
            int32_t i = (int16_t)((beat * 2 + w + round) % 2000 - 1000);   /* I */
            int32_t q = (int16_t)((beat * 2 + w + round) %  500 -  250);   /* Q */
            uint32_t v = ((uint32_t)(q & 0xffff) << 16) | (uint32_t)(i & 0xffff);
            memcpy(iq + (beat * 2 + w) * 4, &v, sizeof v);
        }
    }
}

int main(int argc, char **argv)
{
    int rounds = (argc > 1) ? atoi(argv[1]) : 3;
    int zerocopy = 0;
    for (int i = 1; i < argc; i++)
        if (!strcmp(argv[i], "--zerocopy")) zerocopy = 1;

    /* ① 开库：一次，整个程序活多久就开多久 */
    pl_dma_io_cfg cfg;
    pl_dma_io_cfg_default(&cfg);
    cfg.log = pl_dma_io_log_vprintf;      /* 想看库在做什么就接上；不要就删掉这行 */
    cfg.timeout_ms = 5000;

    pl_dma_io *io = pl_dma_io_open(&cfg);
    if (!io) {
        fprintf(stderr, "开库失败: %s\n", strerror(errno));  /* EACCES 没 root / ENODEV 窗口没译码 */
        return 1;
    }
    printf("模式: %s   (0=SG 环, 1=直读)\n", pl_dma_io_mode(io) == 0 ? "SG" : "直读");

    static uint8_t iq[PL_DMA_CALL_IN_BYTES];
    static uint8_t dout[PL_DMA_CALL_OUT_BYTES];
    static uint8_t eq[PL_DMA_EQ_CALL_BYTES];
    static uint8_t ex[PL_DMA_EXP_CALL_BYTES];
    int bad = 0;

    for (int r = 0; r < rounds; r++) {
        fill_iq(iq, r);                              /* 这一轮的输入 */

        if (zerocopy) {
            /* ②b 零拷贝：自己往 udmabuf 里填、自己去读，省两次 memcpy。
             *     注意 in_ptr 拿到的指针**要一直用**，别 free、别 memcpy 给别人再改。 */
            uint32_t icap, ocap, ecap, xcap;
            uint8_t *ip = (uint8_t *)pl_dma_io_in_ptr(io, &icap);
            uint8_t *op = (uint8_t *)pl_dma_io_out_ptr(io, &ocap);
            uint8_t *ep = (uint8_t *)pl_dma_io_eq_ptr(io, &ecap);
            uint8_t *xp = (uint8_t *)pl_dma_io_expert_ptr(io, &xcap);
            if (!ip || !op || !ep || !xp || icap < PL_DMA_CALL_IN_BYTES ||
                ecap < PL_DMA_EQ_CALL_BYTES || xcap < PL_DMA_EXP_CALL_BYTES) {
                bad++;
                break;
            }

            memcpy(ip, iq, PL_DMA_CALL_IN_BYTES);
            long got = pl_dma_io_xfer_ptr(io, PL_DMA_CALL_IN_BYTES, PL_DMA_CALL_OUT_BYTES);
            if (got < 0) {
                fprintf(stderr, "第 %d 轮 xfer: %s\n", r, strerror(errno));
                pl_dma_io_eq_drain(io);              /* 这一轮不用 eq / 专家，别把槽灌满 */
                pl_dma_io_expert_drain(io);
                bad++;
                continue;
            }

            /* ③ 收均衡 / 专家：一定要在下一轮 xfer 之前 */
            uint32_t egot = 0, xgot = 0;
            long en = pl_dma_io_eq_recv_ptr(io, PL_DMA_EQ_CALL_BYTES, &egot);
            if (en != (long)PL_DMA_EQ_CALL_BYTES) {
                fprintf(stderr, "第 %d 轮 eq: %ld / %u 字节\n",
                        r, en, PL_DMA_EQ_CALL_BYTES);
                pl_dma_io_expert_drain(io);
                bad++;
                continue;
            }
            long xn = pl_dma_io_expert_recv_ptr(io, PL_DMA_EXP_CALL_BYTES, &xgot);
            if (xn != (long)PL_DMA_EXP_CALL_BYTES) {
                fprintf(stderr, "第 %d 轮 专家: %ld / %u 字节\n",
                        r, xn, PL_DMA_EXP_CALL_BYTES);
                bad++;
                continue;
            }
            if (got != PL_DMA_CALL_OUT_BYTES) {
                fprintf(stderr, "第 %d 轮 dout: %ld / %u 字节\n",
                        r, got, PL_DMA_CALL_OUT_BYTES);
                bad++;
                continue;
            }
            dump_frame(op, r);                       /* op 里就是 8 帧 dout */
            dump_eq_frame(ep, r);                    /* ep 里就是 8 帧 eq */
            dump_exp_frame(xp, r);                   /* xp 里就是 8 帧专家特征 */
        } else {
            /* ②a 普通拷贝版：给两块自己的内存，库内部自己进出 udmabuf */
            if (infer_once(io, iq, dout) < 0) {
                pl_dma_io_eq_drain(io);              /* 这一轮不用 eq / 专家，别把槽灌满 */
                pl_dma_io_expert_drain(io);
                bad++;
                continue;
            }
            uint32_t egot = 0, xgot = 0;
            if (eq_once(io, eq, &egot) < 0) {
                pl_dma_io_expert_drain(io);
                bad++;
                continue;
            }
            if (exp_once(io, ex, &xgot) < 0) { bad++; continue; }
            dump_frame(dout, r);
            dump_eq_frame(eq, r);
            dump_exp_frame(ex, r);
        }
        printf("第 %d 轮 ok（dout 8 帧 × %d B，eq 8 帧 × %d B，专家 8 帧 × %d B）\n",
               r, FRAME, EQ_FRAME, EXP_FRAME);
    }

    /* ③ 关库：它会把 HLS 输出里的残帧排掉再放手，免得下一次开库的第一帧是短帧 */
    pl_dma_io_close(io);
    printf("%d 轮，%d 轮不干净\n", rounds, bad);
    return bad ? 1 : 0;
}
