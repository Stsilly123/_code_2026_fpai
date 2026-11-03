/*
 * pl_dma_io_demo.c —— pl_dma_io 的自测 / 演示程序
 *
 *   ./pl_dma_io_demo probe                 四个寄存器窗口 + udmabuf 通不通（最安全，先跑）
 *   ./pl_dma_io_demo check [--golden=f]    跑一次调用，dout / eq / 专家三路都判
 *   ./pl_dma_io_demo soak [N]              连跑 N 轮（默认 20）—— **防残留的主测试**
 *   ./pl_dma_io_demo zerocopy              零拷贝接口 vs 拷贝接口，逐字节比
 *
 * 开关：
 *   --in=文件      用真实 IQ 替掉内置图案（≤16383 字节，8 的倍数；不是 8192 会提醒）
 *   --dump=名字    把收到的 9728 字节落盘（**名字自动带轮次戳**，见 usage）
 *   --golden=文件  check 时把输出跟这个 1216 字节的黄金帧逐字节比
 *   --timeout=ms   单次等待超时（默认库自己的 5000）
 *   --quiet        不把库的日志接出来（默认接，方便看库在做什么）
 *
 * 判据对齐 IP 改动说明（2026-10-22）§8：
 *   dout：8 帧 × 1216 B、每帧铺满、8 帧**逐字节相同**、token 不退化；
 *   eq  ：8 帧 × 1024 B、每帧都被写过；
 *   专家：8 帧 × 1024 B、每帧 magic/版本/Q 格式/填充、帧号连续、特征不退化。
 *
 * 这一份是**测试脚手架**，不是库的一部分 —— 图案、判读、比对都留在这里。
 */

#define _GNU_SOURCE
#include "pl_dma_io.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <sys/mman.h>

/* 用户参数 */
static const char *opt_in     = NULL;
static const char *opt_dump   = NULL;
static const char *opt_golden = NULL;
static int         opt_timeout = 0;
static int         opt_quiet  = 0;
static int         opt_verbose = 1;

#define DEF_DMA0   0x80400000UL
#define DEF_DMA1   0x80410000UL
#define DEF_DMA2   0x80420000UL
#define DEF_DMA3   0x80430000UL
#define REG_WINDOW 0x10000UL

#define MM2S_CR 0x00
#define MM2S_SR 0x04
#define S2MM_CR 0x30
#define S2MM_SR 0x34
#define CR_RUNSTOP 0x00000001u
#define CR_THRESHOLD(x) (((x) & 0xff) << 16)
#define SR_SGINCLD 0x00000008u
#define SR_HALTED  0x00000001u
#define SR_IDLE    0x00000002u
#define SR_IOC     0x00001000u
#define SR_ERR     0x00000070u
#define SR_ERR_SG  0x00000700u

/* ─────────────────── 判读用的小工具（从 pl_dma_test.c 搬，只这一份）─────────────────── */

/* 数据真正到哪里为止：最后一个不是底色的字节的下一个位置。
 * 比"逐字节数底色"靠谱 —— 数据里只要恰好出现一个 0xA5 就会数错。 */
static size_t find_data_end(const uint8_t *p, size_t n, uint8_t fill)
{
    size_t i = n;
    while (i > 0 && p[i - 1] == fill)
        i--;
    return i;
}

static int16_t rd_le16(const uint8_t *p)
{
    return (int16_t)(uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static uint32_t rd_le32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

/* token 段健全性（IP 改动说明 §8.2）：16 token × 19 拍 × 2 个 int16(Q4)。
 * 全 0 说明 IP 没算或没接上；全同一个值说明退化。 */
static int tok_sane(const uint8_t *f, size_t *nz_out, size_t *n_out)
{
    size_t n = PL_DMA_TOK_FRAME_BYTES / 2, nz = 0;
    int16_t first = rd_le16(f);
    int same = 1;
    for (size_t j = 0; j < n; j++) {
        int16_t v = rd_le16(f + 2 * j);
        if (v != 0) nz++;
        if (v != first) same = 0;
    }
    if (nz_out) *nz_out = nz;
    if (n_out)  *n_out  = n;
    return nz != 0 && !same;         /* 非全 0 且不是全同一个值 */
}

/* 内置图案：一帧 512 字、周期 256 字、前半 +12000 后半 −12000、Q 恒 0。
 * 周期是帧长的整数因子 ⇒ 8 帧字节级完全相同，8 个 1216 B 块应当一模一样。
 * （逐字照抄 pl_dma_test.c 的 fill_pattern。） */
static void fill_pattern(uint8_t *src, uint32_t bytes)
{
    uint32_t words = bytes / 2;
    for (uint32_t n = 0; n < words; n++) {
        int16_t i = ((n % 256) < 128) ? (int16_t)12000 : (int16_t)-12000;
        src[n * 2 + 0] = (uint8_t)(i & 0xff);
        src[n * 2 + 1] = (uint8_t)((i >> 8) & 0xff);
    }
}

/* 输出的取戳文件名：`名字_时分秒-pid.bin`。
 * 为什么非要带戳 —— 固定文件名连跑几次用 `cp` 重名会**静悄悄盖掉**上一份
 * （这个坑在板上已经吃掉两批数据了）。带戳之后重名的 cp 直接报错。 */
static void tagged_name(const char *base, char *out, size_t sz)
{
    time_t t = time(NULL);
    struct tm tm;
    char stem[256];
    localtime_r(&t, &tm);
    snprintf(stem, sizeof(stem), "%s", base);
    char *dot = strrchr(stem, '.');
    if (dot && dot != stem)
        *dot = '\0';
    snprintf(out, sz, "%s_%02d%02d%02d-%d.bin", stem,
             tm.tm_hour, tm.tm_min, tm.tm_sec, (int)getpid());
}

static int write_file(const char *path, const void *p, size_t n)
{
    FILE *f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "  打不开 %s: %s\n", path, strerror(errno));
        return -1;
    }
    size_t w = fwrite(p, 1, n, f);
    fclose(f);
    if (w != n) {
        fprintf(stderr, "  只写进去 %zu / %zu 字节\n", w, n);
        return -1;
    }
    printf("  已落盘 %s（%zu 字节）\n", path, n);
    return 0;
}

static uint8_t *read_file(const char *path, size_t *n_out, size_t max)
{
    FILE *f = fopen(path, "rb");
    uint8_t *p;
    size_t n;
    if (!f) {
        fprintf(stderr, "  打不开 %s: %s\n", path, strerror(errno));
        return NULL;
    }
    p = malloc(max);
    if (!p) {
        fclose(f);
        return NULL;
    }
    n = fread(p, 1, max, f);
    fclose(f);
    *n_out = n;
    return p;
}

/* ─────────────────── 判读：一次调用的输出 ───────────────────
 * 返回不合规的条目数。判据四条，缺一条都算不合规（都对齐板上的已知好结果）。 */
static int check_frames(const uint8_t *out, uint32_t got, uint32_t want,
                        const uint8_t *golden, size_t golden_n)
{
    int bad = 0;
    uint32_t nframes = want / PL_DMA_FRAME_OUT_BYTES;

    if (got != want) {
        printf("  ✗ 实收 %u / %u 字节\n", got, want);
        bad++;
    } else {
        printf("  ✓ 实收 %u / %u 字节\n", got, want);
    }

    /* ① 每帧：内存里的数据都要铺满 1216（末尾不能还剩底色） */
    for (uint32_t k = 0; k < nframes; k++) {
        size_t end = find_data_end(out + k * PL_DMA_FRAME_OUT_BYTES,
                                   PL_DMA_FRAME_OUT_BYTES, (uint8_t)PL_DMA_FILL_BYTE);
        if (end != PL_DMA_FRAME_OUT_BYTES) {
            printf("  ✗ 帧 %u 只铺到 %zu / %u 字节（末尾 %zu 字节还是底色）\n",
                   k + 1, end, PL_DMA_FRAME_OUT_BYTES,
                   (size_t)PL_DMA_FRAME_OUT_BYTES - end);
            bad++;
        }
    }

    /* ② 每帧 token 段（16 token × 19 拍，2×int16 Q4）不能全 0、不能全同值 */
    for (uint32_t k = 0; k < nframes; k++) {
        size_t nz = 0, n = 0;
        if (!tok_sane(out + k * PL_DMA_FRAME_OUT_BYTES, &nz, &n)) {
            printf("  ✗ 帧 %u：token 段 %zu / %zu 个非零 -> %s（IP 没算或退化？）\n",
                   k + 1, nz, n, nz == 0 ? "全是 0" : "全是同一个值");
            bad++;
        }
    }

    /* ③ 8 帧逐字节相同（输入 8 帧相同 ⇒ 输出 8 帧相同，这条前提板上坐实过） */
    for (uint32_t k = 1; k < nframes; k++) {
        if (memcmp(out, out + k * PL_DMA_FRAME_OUT_BYTES,
                   PL_DMA_FRAME_OUT_BYTES) != 0) {
            size_t d = 0;
            for (size_t b = 0; b < PL_DMA_FRAME_OUT_BYTES; b++)
                if (out[b] != out[k * PL_DMA_FRAME_OUT_BYTES + b])
                    d++;
            printf("  ✗ 帧 1 vs 帧 %u：%zu 个字节不同\n", k + 1, d);
            bad++;
        }
    }

    /* ④ 给了黄金帧就逐字节比（这一条的干净与否只看它自己，别被上面几条带跑） */
    if (golden) {
        if (golden_n != PL_DMA_FRAME_OUT_BYTES) {
            printf("  ✗ 黄金帧是 %zu 字节，应当是 %u\n", golden_n,
                   PL_DMA_FRAME_OUT_BYTES);
            bad++;
        } else {
            int god = 0;
            for (uint32_t k = 0; k < nframes; k++) {
                if (memcmp(golden, out + k * PL_DMA_FRAME_OUT_BYTES,
                           PL_DMA_FRAME_OUT_BYTES) != 0) {
                    printf("  ✗ 帧 %u 与黄金帧不同\n", k + 1);
                    god++;
                }
            }
            bad += god;
            if (!god)
                printf("  ✓ %u 帧全部与黄金帧逐字节相同\n", nframes);
        }
    }

    if (!bad)
        printf("  ✓ 四条判据全过（%u 帧 × %u B，逐字节一致，token 段 %u B）\n",
               nframes, PL_DMA_FRAME_OUT_BYTES, PL_DMA_TOK_FRAME_BYTES);
    return bad;
}

/* ─────────────────── 判读：均衡那一路 ───────────────────
 * 均衡输出是未知数据，没法像 dout 那样逐字节比。这里只判两件事：
 *   ① 一次收满 8 帧 × 1024 B；
 *   ② 每帧都不是**整帧底色**（整帧都没被写过 = 这一帧根本没收到）。
 * 末尾有没有恰好落在 0xA5 上只能当旁证，不当判据。 */
static int check_eq(const uint8_t *eq, long got, uint32_t want)
{
    int bad = 0;
    uint32_t nframes = want / PL_DMA_EQ_FRAME_BYTES;

    if (got != (long)want) {
        printf("  ✗ eq 实收 %ld / %u 字节\n", got, want);
        bad++;
    } else {
        printf("  ✓ eq 实收 %ld / %u 字节（%u 帧 × %u B）\n",
               got, want, nframes, PL_DMA_EQ_FRAME_BYTES);
    }

    for (uint32_t k = 0; k < nframes; k++) {
        const uint8_t *f = eq + k * PL_DMA_EQ_FRAME_BYTES;
        size_t end = find_data_end(f, PL_DMA_EQ_FRAME_BYTES,
                                   (uint8_t)PL_DMA_FILL_BYTE);
        if (end == 0) {
            printf("  ✗ eq 帧 %u 整帧还是底色 —— 这一帧没写进来\n", k + 1);
            bad++;
        }
    }

    if (got >= 4) {
        int16_t i0 = rd_le16(eq + 0), q0 = rd_le16(eq + 2);
        printf("    eq 帧 1 的 I/Q[0] = %d/%d（Q10: %.3f/%.3f）\n",
               i0, q0, i0 / 1024.0, q0 / 1024.0);
    }
    return bad;
}

/* ─────────────────── 判读：专家特征那一路 ───────────────────
 * 契约见 PL_专家系统_RTL+NPU实现指南 §2.2：
 *   字 0..192 特征 int32(Q12)；193 magic；194 版本 1；195 本批帧号 0..7；
 *   196 Q 格式 12；197 flags 0；198..255 填充 0。
 * 8 帧**不能**逐字节比 —— 帧号就写在帧里。RTL 的 out_idx 是自由计数 mod 8，
 * 不保证每批从 0 开始，所以只验相邻帧号 +1（mod 8）。 */
static int check_expert(const uint8_t *ex, long got, uint32_t want)
{
    int bad = 0;
    uint32_t nframes = want / PL_DMA_EXP_FRAME_BYTES;

    if (got != (long)want) {
        printf("  ✗ 专家实收 %ld / %u 字节\n", got, want);
        bad++;
    } else {
        printf("  ✓ 专家实收 %ld / %u 字节（%u 帧 × %u B）\n",
               got, want, nframes, PL_DMA_EXP_FRAME_BYTES);
    }

    int idx0 = -1;
    for (uint32_t k = 0; k < nframes; k++) {
        const uint8_t *f = ex + k * PL_DMA_EXP_FRAME_BYTES;
        size_t end = find_data_end(f, PL_DMA_EXP_FRAME_BYTES,
                                   (uint8_t)PL_DMA_FILL_BYTE);
        if (end != PL_DMA_EXP_FRAME_BYTES) {
            printf("  ✗ 专家帧 %u 只铺到 %zu / %u 字节\n",
                   k + 1, end, PL_DMA_EXP_FRAME_BYTES);
            bad++;
        }

        uint32_t magic = rd_le32(f + 193 * 4);
        uint32_t ver   = rd_le32(f + 194 * 4);
        uint32_t idx   = rd_le32(f + 195 * 4);
        uint32_t qf    = rd_le32(f + 196 * 4);
        uint32_t fl    = rd_le32(f + 197 * 4);

        if (magic != PL_DMA_EXP_MAGIC) {
            printf("  ✗ 专家帧 %u magic=%#010x（应是 %#010x）—— 陈旧 buffer 或错位\n",
                   k + 1, magic, PL_DMA_EXP_MAGIC);
            bad++;
        }
        if (ver != 1) {
            printf("  ✗ 专家帧 %u 版本=%u（应是 1）\n", k + 1, ver);
            bad++;
        }
        if (idx >= PL_DMA_EXP_N_FRAMES) {
            printf("  ✗ 专家帧 %u 帧号=%u（应在 0..7）\n", k + 1, idx);
            bad++;
        } else if (idx0 < 0) {
            idx0 = (int)idx;
        } else if (idx != (uint32_t)((idx0 + (int)k) & 7)) {
            printf("  ✗ 专家帧 %u 帧号=%u，按上一帧应是 %u（帧错位/丢帧）\n",
                   k + 1, idx, (uint32_t)((idx0 + (int)k) & 7));
            bad++;
        }
        if (qf != 12) {
            printf("  ✗ 专家帧 %u Q 格式=%u（应是 12）\n", k + 1, qf);
            bad++;
        }
        if (fl != 0) {
            printf("  ✗ 专家帧 %u flags=%#x（保留位应 0）\n", k + 1, fl);
            bad++;
        }
        for (uint32_t j = 198; j < 256; j++) {
            if (rd_le32(f + j * 4) != 0) {
                printf("  ✗ 专家帧 %u 字 %u 填充非 0\n", k + 1, j);
                bad++;
                break;
            }
        }

        /* 特征不退化：193 个 int32 不能全 0、不能全同一个值 */
        size_t nz = 0;
        int32_t first = (int32_t)rd_le32(f);
        int same = 1;
        for (uint32_t j = 0; j < 193; j++) {
            int32_t v = (int32_t)rd_le32(f + j * 4);
            if (v != 0) nz++;
            if (v != first) same = 0;
        }
        if (nz == 0 || same) {
            printf("  ✗ 专家帧 %u 特征退化（%zu / 193 个非零，%s）\n",
                   k + 1, nz, nz == 0 ? "全 0" : "全同一个值");
            bad++;
        }
    }

    if (got >= 4) {
        int32_t f0 = (int32_t)rd_le32(ex + 0);
        printf("    专家帧 1 的 feature[0] = %d（Q12: %.4f）\n",
               f0, f0 / 4096.0);
    }
    return bad;
}

/* ─────────────────── 跑一次调用 ─────────────────── */
static pl_dma_io *open_lib(void)
{
    pl_dma_io_cfg cfg;
    pl_dma_io_cfg_default(&cfg);
    if (!opt_quiet)
        cfg.log = pl_dma_io_log_vprintf;
    if (opt_timeout > 0)
        cfg.timeout_ms = opt_timeout;

    pl_dma_io *io = pl_dma_io_open(&cfg);
    if (!io) {
        fprintf(stderr, "pl_dma_io_open 失败: %s\n", strerror(errno));
        return NULL;
    }
    printf("库已开：dout S2MM 走 %s，输入上限 %u B，dout 上限 %u B，"
           "eq 一次 %u B（%u 帧），专家一次 %u B（%u 帧）\n",
           pl_dma_io_mode(io) == 0 ? "SG 描述符环" : "直读模式",
           PL_DMA_IN_CAP, PL_DMA_OUT_CAP,
           PL_DMA_EQ_CALL_BYTES, PL_DMA_EQ_N_FRAMES,
           PL_DMA_EXP_CALL_BYTES, PL_DMA_EXP_N_FRAMES);
    return io;
}

/* 准备输入：--in=文件 或内置图案 */
static uint8_t *make_input(uint32_t *n_out)
{
    if (opt_in) {
        size_t n = 0;
        uint8_t *p = read_file(opt_in, &n, PL_DMA_IN_CAP);
        if (!p)
            return NULL;
        if (n & 7) {
            n &= ~(size_t)7;
            printf("  %s 不是 8 的倍数，截到 %zu 字节\n", opt_in, n);
        }
        if (n != PL_DMA_CALL_IN_BYTES && opt_verbose)
            printf("  提醒：%s 有 %zu 字节，不是一次调用的 %u 字节 —— 帧边界由 PL 切，"
                   "半截输入没有意义\n", opt_in, n, PL_DMA_CALL_IN_BYTES);
        *n_out = (uint32_t)n;
        return p;
    }
    *n_out = PL_DMA_CALL_IN_BYTES;
    uint8_t *p = malloc(*n_out);
    if (p)
        fill_pattern(p, *n_out);
    return p;
}

/* ─────────────────── probe ─────────────────── */
static volatile uint32_t *map_regs(uint64_t pa)
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0)
        return NULL;
    void *p = mmap(NULL, REG_WINDOW, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)pa);
    close(fd);
    return p == MAP_FAILED ? NULL : (volatile uint32_t *)p;
}

static int cmd_probe(void)
{
    printf("[probe] 只碰寄存器，不做任何传输\n");

    /* 开库这一步本身就把「窗口译码没有」「udmabuf 在不在」都验了 */
    pl_dma_io *io = open_lib();
    if (!io)
        return 1;

    volatile uint32_t *r0 = map_regs(DEF_DMA0);
    volatile uint32_t *r1 = map_regs(DEF_DMA1);
    volatile uint32_t *r2 = map_regs(DEF_DMA2);
    volatile uint32_t *r3 = map_regs(DEF_DMA3);
    int bad = 0;
    if (!r0 || !r1 || !r2 || !r3) {
        fprintf(stderr, "  自己再映射一遍寄存器窗口失败: %s\n", strerror(errno));
        if (r0) munmap((void *)r0, REG_WINDOW);
        if (r1) munmap((void *)r1, REG_WINDOW);
        if (r2) munmap((void *)r2, REG_WINDOW);
        if (r3) munmap((void *)r3, REG_WINDOW);
        pl_dma_io_close(io);
        return 1;
    }

    struct { volatile uint32_t *b; const char *nm; uint32_t cr, sr; int want_sg; } ch[4] = {
        { r0, "axi_dma_0(MM2S)", MM2S_CR, MM2S_SR, 1 },   /* 板上必须是 SG */
        { r1, "axi_dma_1(S2MM dout)", S2MM_CR, S2MM_SR, 0 },  /* 板上必须是直读 */
        { r2, "axi_dma_2(S2MM eq)", S2MM_CR, S2MM_SR, 0 },    /* 只收、直读 */
        { r3, "axi_dma_3(S2MM expert)", S2MM_CR, S2MM_SR, 0 },/* 只收、直读 */
    };

    for (int i = 0; i < 4; i++) {
        uint32_t sr = ch[i].b[ch[i].sr >> 2];
        uint32_t cr = ch[i].b[ch[i].cr >> 2];
        int sg = (sr & SR_SGINCLD) != 0;

        printf("  %s: DMACR=%#010x DMASR=%#010x  [%s%s%s%s%s]\n",
               ch[i].nm, cr, sr,
               sg ? "SG引擎在 " : "直读模式 ",
               (sr & SR_HALTED) ? "Halted " : "",
               (sr & SR_IDLE) ? "Idle " : "",
               (sr & SR_IOC) ? "IOC " : "",
               (sr & (SR_ERR | SR_ERR_SG)) ? "ERR " : "");
        if (sr == 0xFFFFFFFFu) {
            printf("    !! 读回全 F = 这个窗口没译码\n");
            bad++;
            continue;
        }
        if (sg != ch[i].want_sg) {
            printf("    !! SGIncld=%d，按 .xci 应当是 %d —— bitstream 不是我们要的那版？\n",
                   sg, ch[i].want_sg);
            bad++;
        }

        /* 在 IRQThreshold 字段里写个花样再读回来：能读回来说明 AXI-Lite 写也通。
         * 这一步只在开跑之前做，写完就恢复 RS=0。 */
        ch[i].b[ch[i].cr >> 2] = CR_THRESHOLD(0x5a);
        uint32_t v = ch[i].b[ch[i].cr >> 2];
        if ((v & 0x00FF0000u) != CR_THRESHOLD(0x5a)) {
            printf("    !! 回读不上：写了 %#x 读回 %#x —— 窗口没译码或写没通\n",
                   CR_THRESHOLD(0x5a), v);
            bad++;
        } else {
            printf("    回读 OK（IRQThreshold 写 0x5a 读回 0x5a）\n");
        }
        ch[i].b[ch[i].cr >> 2] = 0;                  /* 恢复：RS=0，不启动 */
        ch[i].b[ch[i].sr >> 2] = ch[i].b[ch[i].sr >> 2];   /* W1C */
    }

    munmap((void *)r0, REG_WINDOW);
    munmap((void *)r1, REG_WINDOW);
    munmap((void *)r2, REG_WINDOW);
    munmap((void *)r3, REG_WINDOW);
    pl_dma_io_close(io);

    if (bad) {
        printf("\n[probe] 有问题。先查：bitstream 是不是最新那版（地址译码在 PL 里）、"
               "0x8040_0000 这段有没有被别的 master 占了\n");
        return 1;
    }
    printf("\n[probe] 通过。\n");
    return 0;
}

/* ─────────────────── check ─────────────────── */
static int cmd_check(void)
{
    printf("[check] 跑一次调用（8192 B 进 / 9728 B 出），三路都按契约逐条判\n");
    pl_dma_io *io = open_lib();
    if (!io)
        return 1;

    uint32_t in_bytes = 0;
    uint8_t *in = make_input(&in_bytes);
    if (!in) {
        pl_dma_io_close(io);
        return 1;
    }
    /* 输出留 1 个字节的余量，好在漏收时能看出"第 9729 个字节"是什么 */
    uint8_t *out = malloc(PL_DMA_CALL_OUT_BYTES + 1);
    uint8_t *eq  = malloc(PL_DMA_EQ_CALL_BYTES);
    uint8_t *ex  = malloc(PL_DMA_EXP_CALL_BYTES);
    if (!out || !eq || !ex) {
        free(in); free(out); free(eq); free(ex);
        pl_dma_io_close(io);
        return 1;
    }
    out[PL_DMA_CALL_OUT_BYTES] = 0xEE;

    uint8_t *golden = NULL;
    size_t golden_n = 0;
    if (opt_golden) {
        golden = read_file(opt_golden, &golden_n, PL_DMA_FRAME_OUT_BYTES * 2);
        if (!golden) {
            free(in); free(out); free(eq); free(ex); pl_dma_io_close(io);
            return 1;
        }
    }

    long got = pl_dma_io_xfer(io, in, in_bytes, out, PL_DMA_CALL_OUT_BYTES);
    if (got < 0) {
        fprintf(stderr, "  xfer 失败: %s\n", strerror(errno));
        pl_dma_io_eq_drain(io);         /* 这一轮不用 eq / 专家，别把输出槽灌满 */
        pl_dma_io_expert_drain(io);
        free(in); free(out); free(eq); free(ex); free(golden);
        pl_dma_io_close(io);
        return 1;
    }

    /* 均衡 / 专家两路：各单独一次收，必须在下一轮 xfer 之前。 */
    uint32_t egot = 0, xgot = 0;
    long eq_got = pl_dma_io_eq_recv(io, eq, PL_DMA_EQ_CALL_BYTES, &egot);
    if (eq_got < 0)
        fprintf(stderr, "  eq_recv 失败: %s\n", strerror(errno));

    long exp_got = pl_dma_io_expert_recv(io, ex, PL_DMA_EXP_CALL_BYTES, &xgot);
    if (exp_got < 0)
        fprintf(stderr, "  expert_recv 失败: %s\n", strerror(errno));

    int bad = check_frames(out, (uint32_t)got, PL_DMA_CALL_OUT_BYTES, golden, golden_n);

    printf("  均衡那一路：\n");
    if (eq_got < 0) {
        printf("  ✗ 没收到（dout 那一路的判读照旧）\n");
        bad++;
    } else {
        bad += check_eq(eq, eq_got, PL_DMA_EQ_CALL_BYTES);
    }

    printf("  专家特征那一路：\n");
    if (exp_got < 0) {
        printf("  ✗ 没收到（dma3 = 0x%08lx）\n", (unsigned long)DEF_DMA3);
        bad++;
    } else {
        bad += check_expert(ex, exp_got, PL_DMA_EXP_CALL_BYTES);
    }

    if (out[PL_DMA_CALL_OUT_BYTES] != 0xEE)
        printf("  !! 第 %u 个字节被写了：实收其实超过 %u，返回值却在骗人\n",
               PL_DMA_CALL_OUT_BYTES + 1, PL_DMA_CALL_OUT_BYTES);

    if (opt_dump) {
        char path[512], base[600], bpath[512];
        tagged_name(opt_dump, path, sizeof(path));
        write_file(path, out, (size_t)got);
        if (eq_got > 0) {
            snprintf(base, sizeof(base), "%s_eq", opt_dump);
            tagged_name(base, bpath, sizeof(bpath));
            write_file(bpath, eq, (size_t)eq_got);
        }
        if (exp_got > 0) {
            snprintf(base, sizeof(base), "%s_exp", opt_dump);
            tagged_name(base, bpath, sizeof(bpath));
            write_file(bpath, ex, (size_t)exp_got);
        }
    }

    free(in); free(out); free(eq); free(ex); free(golden);
    pl_dma_io_close(io);
    return bad ? 1 : 0;
}

/* ─────────────────── soak ─────────────────── */
static int cmd_soak(int n)
{
    printf("[soak] 连跑 %d 轮 —— 这个测的是**残留**：上一轮没收干净，下一轮第 1 帧必短\n", n);
    pl_dma_io *io = open_lib();
    if (!io)
        return 1;

    uint32_t in_bytes = 0;
    uint8_t *in = make_input(&in_bytes);
    /* 专家帧只判头，用逐帧指针就够；但 check_expert 要吃整块，留一份 8 KB */
    uint8_t *out = malloc(PL_DMA_CALL_OUT_BYTES);
    uint8_t *ex  = malloc(PL_DMA_EXP_CALL_BYTES);
    if (!in || !out || !ex) {
        free(in); free(out); free(ex); pl_dma_io_close(io);
        return 1;
    }

    int fails = 0;
    for (int r = 0; r < n; r++) {
        long got = pl_dma_io_xfer(io, in, in_bytes, out, PL_DMA_CALL_OUT_BYTES);
        if (got < 0) {
            printf("  第 %d 轮：xfer 失败 %s\n", r + 1, strerror(errno));
            pl_dma_io_eq_drain(io);    /* 这一轮不用 eq / 专家，别把输出槽灌满 */
            pl_dma_io_expert_drain(io);
            fails++;
            continue;
        }

        /* 每轮都必须把 eq / 专家两路收掉，否则输出槽满了之后上游开始反压 */
        uint32_t egot = 0, xgot = 0;
        long eq_got = pl_dma_io_eq_recv(io, NULL, PL_DMA_EQ_CALL_BYTES, &egot);
        if (eq_got < 0)
            printf("  第 %d 轮：eq_recv 失败 %s\n", r + 1, strerror(errno));

        long exp_got = pl_dma_io_expert_recv(io, ex, PL_DMA_EXP_CALL_BYTES, &xgot);
        if (exp_got < 0)
            printf("  第 %d 轮：expert_recv 失败 %s\n", r + 1, strerror(errno));

        int bad = 0;
        if (got != (long)PL_DMA_CALL_OUT_BYTES)
            bad++;
        if (eq_got != (long)PL_DMA_EQ_CALL_BYTES)
            bad++;
        if (exp_got != (long)PL_DMA_EXP_CALL_BYTES)
            bad++;
        /* 每帧 magic + 帧号连续（帧号自由计数 mod 8，不假设从 0 起） */
        if (exp_got == (long)PL_DMA_EXP_CALL_BYTES) {
            uint32_t idx0 = rd_le32(ex + 195 * 4);
            for (uint32_t k = 0; k < PL_DMA_EXP_N_FRAMES; k++) {
                const uint8_t *f = ex + k * PL_DMA_EXP_FRAME_BYTES;
                if (rd_le32(f + 193 * 4) != PL_DMA_EXP_MAGIC ||
                    rd_le32(f + 195 * 4) != ((idx0 + k) & 7)) {
                    bad++;
                    break;
                }
            }
        }
        for (uint32_t k = 1; k < PL_DMA_N_FRAMES_OUT && !bad; k++)
            if (memcmp(out, out + k * PL_DMA_FRAME_OUT_BYTES,
                       PL_DMA_FRAME_OUT_BYTES) != 0)
                bad++;

        if (bad) {
            printf("  第 %d 轮：**不干净**（dout %ld B，eq %ld B，专家 %ld B）\n",
                   r + 1, got, eq_got, exp_got);
            fails++;
        } else {
            printf("  第 %d 轮：dout %ld B / %u 帧，eq %ld B / %u 帧，专家 %ld B / %u 帧\n",
                   r + 1, got, PL_DMA_N_FRAMES_OUT,
                   eq_got, PL_DMA_EQ_N_FRAMES, exp_got, PL_DMA_EXP_N_FRAMES);
        }
    }

    printf("[soak] %d/%d 轮干净\n", n - fails, n);
    /* 收尾再排一次，别把存货留给紧接着要跑的那条命令 */
    int nd = pl_dma_io_drain(io);
    int ne = pl_dma_io_eq_drain(io);
    int nx = pl_dma_io_expert_drain(io);
    printf("  收尾排空：dout %d 帧，eq %d 帧，专家 %d 帧\n", nd, ne, nx);

    free(in); free(out); free(ex);
    pl_dma_io_close(io);
    return fails ? 1 : 0;
}

/* ─────────────────── zerocopy ─────────────────── */
static int cmd_zerocopy(void)
{
    printf("[zerocopy] 同一份输入，走两次：拷贝接口 vs 零拷贝接口，输出必须逐字节相同\n");
    pl_dma_io *io = open_lib();
    if (!io)
        return 1;

    uint32_t in_bytes = 0;
    uint8_t *in = make_input(&in_bytes);
    uint8_t *out_copy = malloc(PL_DMA_CALL_OUT_BYTES);
    uint8_t *ex  = malloc(PL_DMA_EXP_CALL_BYTES);
    if (!in || !out_copy || !ex) {
        free(in); free(out_copy); free(ex); pl_dma_io_close(io);
        return 1;
    }

    /* 第一次：拷贝接口 */
    long got1 = pl_dma_io_xfer(io, in, in_bytes, out_copy, PL_DMA_CALL_OUT_BYTES);
    if (got1 < 0) {
        fprintf(stderr, "  拷贝接口失败: %s\n", strerror(errno));
        pl_dma_io_eq_drain(io);
        pl_dma_io_expert_drain(io);
        free(in); free(out_copy); free(ex); pl_dma_io_close(io);
        return 1;
    }

    /* 均衡 / 专家也要在第二次 xfer 之前收掉 */
    uint32_t egot1 = 0, xgot1 = 0;
    long eq1 = pl_dma_io_eq_recv(io, NULL, PL_DMA_EQ_CALL_BYTES, &egot1);
    long exp1 = pl_dma_io_expert_recv(io, ex, PL_DMA_EXP_CALL_BYTES, &xgot1);

    /* 第二次：零拷贝接口 —— 自己往 udmabuf 里填同一份图案 */
    uint32_t cap_in = 0, cap_out = 0;
    uint8_t *zin  = pl_dma_io_in_ptr(io, &cap_in);
    uint8_t *zout = pl_dma_io_out_ptr(io, &cap_out);
    if (!zin || !zout || in_bytes > cap_in) {
        fprintf(stderr, "  拿不到 udmabuf 指针（in cap=%u，需要 %u）\n", cap_in, in_bytes);
        free(in); free(out_copy); free(ex); pl_dma_io_close(io);
        return 1;
    }
    memcpy(zin, in, in_bytes);

    long got2 = pl_dma_io_xfer_ptr(io, in_bytes, PL_DMA_CALL_OUT_BYTES);
    if (got2 < 0) {
        fprintf(stderr, "  零拷贝接口失败: %s\n", strerror(errno));
        pl_dma_io_eq_drain(io);
        pl_dma_io_expert_drain(io);
        free(in); free(out_copy); free(ex); pl_dma_io_close(io);
        return 1;
    }

    uint32_t egot2 = 0, xgot2 = 0;
    long eq2 = pl_dma_io_eq_recv(io, NULL, PL_DMA_EQ_CALL_BYTES, &egot2);
    long exp2 = pl_dma_io_expert_recv(io, ex, PL_DMA_EXP_CALL_BYTES, &xgot2);

    int bad = 0;
    if (eq1 != (long)PL_DMA_EQ_CALL_BYTES || eq2 != (long)PL_DMA_EQ_CALL_BYTES) {
        printf("  ✗ 均衡两趟没收满：%ld / %ld（期望 %u）\n",
               eq1, eq2, PL_DMA_EQ_CALL_BYTES);
        bad++;
    } else {
        printf("  ✓ 均衡两趟各收满 %u 字节\n", PL_DMA_EQ_CALL_BYTES);
    }
    if (exp1 != (long)PL_DMA_EXP_CALL_BYTES || exp2 != (long)PL_DMA_EXP_CALL_BYTES) {
        printf("  ✗ 专家两趟没收满：%ld / %ld（期望 %u）\n",
               exp1, exp2, PL_DMA_EXP_CALL_BYTES);
        bad++;
    } else {
        printf("  ✓ 专家两趟各收满 %u 字节\n", PL_DMA_EXP_CALL_BYTES);
    }
    /* 专家帧里有自由计数的帧号，两次收的内容本就不必相同；只验第二次的帧头 */
    if (exp2 == (long)PL_DMA_EXP_CALL_BYTES)
        bad += check_expert(ex, exp2, PL_DMA_EXP_CALL_BYTES);
    if (got1 != got2) {
        printf("  ✗ 两次实收不同：%ld vs %ld\n", got1, got2);
        bad++;
    }
    if (memcmp(out_copy, zout, PL_DMA_CALL_OUT_BYTES) != 0) {
        size_t d = 0;
        for (uint32_t b = 0; b < PL_DMA_CALL_OUT_BYTES; b++)
            if (out_copy[b] != zout[b])
                d++;
        printf("  ✗ 两次输出有 %zu 个字节不同\n", d);
        bad++;
    } else {
        printf("  ✓ 两次输出逐字节相同（%u 字节）\n", PL_DMA_CALL_OUT_BYTES);
    }

    /* 零拷贝那次的输出也顺手判一遍 */
    printf("  零拷贝那次的输出：\n");
    bad += check_frames(zout, (uint32_t)got2, PL_DMA_CALL_OUT_BYTES, NULL, 0);

    if (opt_dump) {
        char path[512], base[600], bpath[512];
        tagged_name(opt_dump, path, sizeof(path));
        write_file(path, zout, (size_t)got2);
        if (exp2 > 0) {
            snprintf(base, sizeof(base), "%s_exp", opt_dump);
            tagged_name(base, bpath, sizeof(bpath));
            write_file(bpath, ex, (size_t)exp2);
        }
    }

    free(in); free(out_copy); free(ex);
    pl_dma_io_close(io);
    return bad ? 1 : 0;
}

/* ─────────────────── main ─────────────────── */
static void usage(const char *argv0)
{
    printf(
      "用法: %s <命令> [开关]\n"
      "\n"
      "命令:\n"
      "  probe                四个寄存器窗口 + 开库，不做传输（最安全，先跑这个）\n"
      "  check                跑一次调用，dout / eq / 专家三路按契约逐条判\n"
      "  soak [N]             连跑 N 轮（默认 20）—— 防残留的主测试\n"
      "  zerocopy             零拷贝接口 vs 拷贝接口，dout 输出必须逐字节相同\n"
      "\n"
      "开关:\n"
      "  --in=文件            用真实 IQ 替掉内置图案\n"
      "  --dump=名字          收到的东西落盘。**会自动加轮次戳**：\n"
      "                       名字.bin -> 名字_时分秒-pid.bin\n"
      "                       （固定名字被 cp 静默盖掉这个坑吃过两批数据了）\n"
      "  --golden=文件        check 时把输出跟这个 %u 字节的黄金帧逐字节比\n"
      "  --timeout=ms         单次等待超时（默认 5000）\n"
      "  --quiet              不把库的日志接出来\n"
      "\n"
      "板上推荐的跑法：\n"
      "  ./pl_dma_io_demo probe && ./pl_dma_io_demo check && ./pl_dma_io_demo soak 20\n"
      "交叉污染双向对拍（和原来那条已跑通的路对账）：\n"
      "  ./pl_dma_test frames && ./pl_dma_io_demo check && ./pl_dma_test frames\n",
      argv0, PL_DMA_FRAME_OUT_BYTES);
}

int main(int argc, char **argv)
{
    const char *cmd = NULL;
    long arg = 0;

    setvbuf(stdout, NULL, _IOLBF, 0);

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (!strncmp(a, "--in=", 5))          opt_in = a + 5;
        else if (!strncmp(a, "--dump=", 7))   opt_dump = a + 7;
        else if (!strncmp(a, "--golden=", 9)) opt_golden = a + 9;
        else if (!strncmp(a, "--timeout=", 10)) opt_timeout = (int)strtol(a + 10, NULL, 0);
        else if (!strcmp(a, "--quiet"))       opt_quiet = 1;
        else if (!strcmp(a, "-h") || !strcmp(a, "--help")) { usage(argv[0]); return 0; }
        else if (a[0] == '-') {
            fprintf(stderr, "未知参数 %s\n", a);
            usage(argv[0]);
            return 2;
        }
        else if (!cmd) cmd = a;
        else arg = strtol(a, NULL, 0);
    }

    if (!cmd) {
        usage(argv[0]);
        return 2;
    }
    if (!strcmp(cmd, "probe"))    return cmd_probe();
    if (!strcmp(cmd, "check"))    return cmd_check();
    if (!strcmp(cmd, "soak"))     return cmd_soak(arg > 0 ? (int)arg : 20);
    if (!strcmp(cmd, "zerocopy")) return cmd_zerocopy();

    fprintf(stderr, "未知命令 %s\n", cmd);
    usage(argv[0]);
    return 2;
}
