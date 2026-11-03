/*
 * pl_dma_io.h —— 把「一次调用」封成一个阻塞函数
 *
 *   灌 8192 B 的 IQ 进 HLS（axi_dma_0 / MM2S）
 *   收 9728 B 的 dout 回来（axi_dma_1 / S2MM）
 *   收 8192 B 的信道均衡输出回来（axi_dma_2 / S2MM，**单独一次调用**）
 *   收 8192 B 的 193 维专家特征回来（axi_dma_3 / S2MM，**单独一次调用**）
 *
 * 这**不是**推理库，只是那四个 AXI DMA 的收发封装 —— 所以名字就这么直白。
 * 所有的图案、判读、比对都在自测程序 pl_dma_io_demo.c 里，不进这个库。
 *
 * ── 用法 ────────────────────────────────────────────────────────────────────
 *   pl_dma_io_cfg cfg;
 *   pl_dma_io_cfg_default(&cfg);
 *   cfg.log = pl_dma_io_log_vprintf;         // 想看库在做什么就接上，可空
 *   pl_dma_io *io = pl_dma_io_open(&cfg);    // 失败 NULL，errno 有效
 *   if (!io) { perror("pl_dma_io_open"); return 1; }
 *
 *   while (...) {
 *       long got = pl_dma_io_xfer(io, in_buf, 8192, out_buf, 9728);
 *       if (got < 0)  { perror("xfer"); break; }     // ETIMEDOUT / EIO / EINVAL
 *       if (got != 9728) { ... 没收满，out_buf 里只有前 got 字节可信 ... }
 *       // out_buf 现在就是 8 帧 × 1216 B 的 dout（token）
 *
 *       // 均衡和专家特征是另外两条链路，各自一趟调用，也必须在下一轮
 *       // xfer 之前收掉（见下）
 *       uint32_t egot, xgot;
 *       long eq  = pl_dma_io_eq_recv(io, eq_buf, 8192, &egot);     // 8 帧 × 1024 B
 *       long exp = pl_dma_io_expert_recv(io, ex_buf, 8192, &xgot); // 8 帧 × 1024 B
 *   }
 *   pl_dma_io_close(io);
 *
 * 想省掉那两次 memcpy 就用 pl_dma_io_in_ptr / pl_dma_io_out_ptr 拿 udmabuf
 * 里的裸指针，自己往里填 / 往外读，再用 pl_dma_io_xfer_ptr() 触发同一段时序。
 * 均衡 / 专家同理：pl_dma_io_eq_ptr() + pl_dma_io_eq_recv_ptr()、
 * pl_dma_io_expert_ptr() + pl_dma_io_expert_recv_ptr()。
 *
 * ── 均衡这条链路（axi_dma_2）────────────────────────────────────────────────
 *   dma2 只收不发，源是 `Signal_process_0/eq`，和 dout 那条（HLS 的 m_axis）是
 *   **两条完全独立的流**，时间尺度也差很多，所以拆成单独一个阻塞调用。
 *
 *   一次 pl_dma_io_xfer 灌进去的 8192 B 在 PL 里同时喂给模型和均衡器；均衡器
 *   对每帧只产 1024 B，8 帧就是 8192 B。`lstf_eq` 内部有 8 个输入槽 + 2 帧的
 *   输出 FIFO，所以**一次 xfer 之后再来 eq_recv 不会丢帧**。
 *
 *   ⚠ **eq_recv 必须在下一轮 xfer 之前调用**。链条最多缓 8 个输入帧；
 *     连续 xfer 而不收 eq，第 9 帧起均衡器就会丢输入（stat_drop 涨）。
 *     某一轮不用 eq，就先调一次 pl_dma_io_eq_drain() 再进下一轮。
 *
 * ── 专家特征这条链路（axi_dma_3）────────────────────────────────────────────
 *   dma3 只收不发，源是 `Signal_process_0/expert`（`expert_feat_rffi` 的输出）。
 *   它吃的是同一份 raw IQ（与均衡器同一个抽头），一帧输入出一帧 256 字的特征，
 *   一次 xfer 的 8 帧正好出 8 帧 = 8192 B。
 *
 *   ⚠ 和 eq 一样，**expert_recv 必须在下一轮 xfer 之前调用**：专家模块的输出
 *     流被 TREADY 反压，不收就会把它的输出口堵住，后面的特征帧拿不到。
 *     某一轮不用，就先 pl_dma_io_expert_drain()。
 *
 *   dma3 和 dma2 一样是 S2MM-only、C_INCLUDE_SG=0，只走直读。
 *
 * ── 前提（不满足就只能报错，不猜）────────────────────────────────────────────
 *   * root 权限（要 mmap /dev/mem 和 /dev/udmabuf0）
 *   * /dev/udmabuf0 存在，且 ≥ 128 KB（我们只用开头 MAP_LEN 那段）
 *   * 四个 DMA 的寄存器窗口（默认 0x8040_0000 / 0x8041_0000 / 0x8042_0000 /
 *     0x8043_0000）已译码；dma2 / dma3 不想用就把 cfg.dma2_base / cfg.dma3_base
 *     置 0（那 eq_* / expert_* 全部返回 ENODEV）
 *   * **不用中断**，全部轮询 DMASR —— 所以 IRQ_F2P 落到哪个 SPI 无所谓
 *
 * ── 一次调用的字节数 ────────────────────────────────────────────────────────
 *   进：8192 B = 1024 个 64bit beat = 2048 个字 = 8 帧 × 256 字（一帧 1024 B）
 *   出：9728 B = 8 帧 × 1216 B = 8 × 304 拍 × 4 B
 *   均衡：8192 B = 8 帧 × 1024 B = 8 × 256 拍 × 4 B
 *   专家：8192 B = 8 帧 × 1024 B = 8 × 256 拍 × 4 B
 *
 *   均衡输出（axi_dma_2，一条流、带 TLAST）：
 *       一拍 32bit = { Q[31:16], I[15:0] }，两个都是 int16、Q10
 *       每帧 256 拍，**TLAST 在第 255 拍**；一次调用 8 个 TLAST、8 个独立 1024 B
 *       帧和 dout 的 1216 B 帧**没有对齐关系**，别按同一下标去对。
 *
 *   均衡帧和 dout 帧不是一一对应的“同一帧的两种表示”：dout 的 1216 B 是
 *   LCWT 的 16×38 token，均衡的 1024 B 是同一段输入经过信道估计和补偿之后的 IQ。
 *   两边共用的是“一次 xfer 对应 PL 收到 8 帧输入”这个大节拍。
 *
 *   输入打包顺序（stream_buf.v 的解包顺序，**这条是假设、没实测过**）：
 *       一个字 2 字节（I 低、Q 高）；一个 64bit beat 塞两个字 ——
 *       [15:0]=I0 [31:16]=Q0 [47:32]=I1 [63:48]=Q1
 *     若实测发现反了/斜了，**改 PL 里的 stream_buf.v**，不是改这个库
 *     （见 doc/issues.md #3）。
 *
 *   输出（dout，一条流、带 TLAST；LcwtMLP_RFFI IP 改动说明 2026-10-22）：
 *       一拍 32bit；每帧 304 拍 = 1216 B
 *         拍 0..303 = 304 个 token 拍（2 × int16/拍，小端）→ 1216 B
 *                       b = t*19 + j，t = 0..15，j = 0..18
 *                       word[15:0] = tok[t][2j]   word[31:16] = tok[t][2j+1]
 *                       物理值 = int16 / 16.0（Q4）
 *         **旧版的 10 拍 logits（304..313）已经从 IP 里删掉**，IP 每帧只发 304 拍。
 *       **TLAST 只在每帧第 303 拍**，一次调用 8 个 TLAST
 *     ⚠ AXI DMA **没有任何可以读 TLAST 的寄存器**，"收够没够"只能按帧长和
 *       返回值判，别指望从寄存器里看到 TLAST。
 *     ⚠ 每帧必须按 1216 B 挂一次 S2MM。给 9728 只在第一帧的 TLAST 处就收工。
 *     ⚠ **LENGTH 必须写 1216**。IP 每帧只发 304 拍，S2MM 的结束条件是
 *       "TLAST 或 length 到，先到先停"；写大了（旧值 1256）是短包，
 *       不要把正确性建立在短包的处理上；写小了必定截断。
 *
 *   专家输出（axi_dma_3，一条流、带 TLAST）：
 *       一拍 32bit = 一个 int32；每帧 256 拍 = 1024 B，**TLAST 在第 255 拍**
 *         字 0..192  = 193 维特征，int32 二进制补码，Q12（物理值 = code / 4096）
 *         字 193     = 0x45584631（ASCII "EXF1"，magic）
 *         字 194     = 1（版本）
 *         字 195     = 0..7（本批内的帧号 —— **8 帧不是逐字节相同的**）
 *         字 196     = 12（Q 格式）
 *         字 197     = 0（flags，保留）
 *         字 198..255 = 0（填充）
 *       一次调用 8 帧 = 8192 B；特征顺序见
 *       `SRC/pl_ai/PL_专家系统_RTL+NPU实现指南.md` §3。
 *
 * ── 调用者必须知道的两条 ────────────────────────────────────────────────────
 *   1) **帧边界不由这个库保证**。库只是把字节灌进去；切帧是 PL 里
 *      Signal_process 按字数强切的。所以 in_bytes 给半个"调用"的长度
 *      （不是 8 的整数倍、或不是 8192 的整数倍）虽然不会报错，但没有意义。
 *   2) **直读模式下 LENGTH 给 9728 也只收 1 帧 1216**（TLAST 一置就收工）。
 *      所以库内部是按帧挂 8 次，别想着"一次大 LENGTH 更省事"。
 *
 * ── 实收字节数从哪来（只有这两个是权威）─────────────────────────────────────
 *   * SG 模式  ：描述符 STATUS[25:0] 的硬件回写值
 *   * 直读模式：S2MM_LENGTH 读回来就是**已收字节数**（不是剩余量；旧格式
 *               684/684、652/652 两两对上过，与帧长无关）
 *   内存里的 0xA5 底色边界（PL_DMA_FILL_BYTE）只是旁证，不作数 —— 数据里
 *   只要恰好出现一个 0xA5 就会数错（旧格式有过 682 vs 684 的实例）。
 *
 * ── head 里没有、但代码里必须守的硬件时序 ───────────────────────────────────
 *   这些是从 pl_dma_test.c 的注释里逐条抄过来的，写进实现里了；列在这里是为了
 *   将来改这个库的人不会顺手把它们优化掉：
 *   * **先挂 S2MM、再起 MM2S**。反了第 1 帧会从帧中间切进去（实测 668 = 少 4 拍）。
 *   * **热路径里不许夹慢活**。收完一帧到挂下一帧之间只能做 MMIO 读写；一旦塞进
 *     memset / sysfs 同步 / 挤缓存 / printf，就是几百 µs 的窗口，而 HLS 每帧
 *     只要 ~50~113 µs（一次调用 10,056~22,600 拍 @200 MHz）。所以本库在稳态
 *     循环里**一条日志都不发**。
 *   * **流上有数据时不许复位通道**。复位会让 S2MM 的 TREADY 抖，抖一下从流里
 *     吃掉几拍。dout 可以在挂第 1 帧前复位（那时 MM2S 还没起、流是空的）；
 *     **eq_recv / expert_recv 开头不能复位**——lstf_eq 的 ofifo / 专家模块的
 *     输出口里已压着数据，复位会从流里吃掉头几拍（eq 板上实测每轮第 1 帧固定
 *     1008/1024，少 4 拍；专家通路同样不冒这个险）。
 *     两条支路都直接挂，chan_reset 只留给出错/超时路径。
 *   * **MM2S 是单描述符自环**，传完必须立刻复位，否则硬件会把同一条描述符再跑一遍。
 *   * **收不满就走人 = 给下一轮留存货**（下一轮的第 1 帧会变成 668/652）。
 *     所以 xfer 在"没收满"这条分支上会自动排空；cfg.drain_on_open 默认也开。
 *
 * ── 线程 / 实例 ─────────────────────────────────────────────────────────────
 *   单实例、**非线程安全**：几个 DMA 是全局硬件，两个句柄同时开会互相踩。
 *   库自己不发 printf、不 exit()、不碰任何全局变量。
 */

#ifndef PL_DMA_IO_H
#define PL_DMA_IO_H

#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ── udmabuf 内部的排布（零拷贝调用者会看到 DST_OFF，藏不住）───────────────
 * 0x000000  MM2S 的描述符（1 个，64B 对齐）
 * 0x000100  S2MM 的描述符环（8 个，64B 对齐，0x100..0x2FF）
 * 0x001000  MM2S 源缓冲
 * 0x010000  S2MM 目标缓冲 dout（DST_MAX = 48 KB，最后 0x4C0 留作排空）
 * 0x01BB00  排空用的角落（DRAIN_OFF，0xBB00；dout / eq / 专家共用，一帧够）
 * 0x01C000  均衡输出（EQ_OFF，固定 8 KB = 8 帧 × 1024 B）
 * 0x01E000  专家特征输出（EXP_OFF，固定 8 KB = 8 帧 × 1024 B，到 0x20000 为止）
 *
 * 整块还是 128 KB（MAP_LEN = 0x20000），设备树不用动。dout 区从 56 KB 缩到
 * 48 KB，给专家通道腾出 8 KB；eq / 专家两块都在尾部，三边的 DMA 目标地址
 * 互不相交。 */
#define PL_DMA_BD_OFF    0x000000u
#define PL_DMA_BD1_OFF   0x000100u
#define PL_DMA_SRC_OFF   0x001000u
#define PL_DMA_DST_OFF   0x010000u
#define PL_DMA_EQ_OFF    0x01C000u
#define PL_DMA_EXP_OFF   0x01E000u
#define PL_DMA_SRC_MAX   65536u
#define PL_DMA_DST_MAX   0xC000u    /* 48 KB；0x10000..0x1C000 */
#define PL_DMA_EQ_MAX    8192u      /* 0x1C000..0x1E000，8 帧 × 1024 B */
#define PL_DMA_EXP_MAX   8192u      /* 0x1E000..0x20000，8 帧 × 1024 B */
#define PL_DMA_MAP_LEN   0x20000u   /* 128 KB。**不能**写成 DST_OFF+DST_MAX，
                                     * 那会把 EQ / 专家区切在 mmap 之外 */
#define PL_DMA_FILL_BYTE 0xa5u    /* 收之前铺的底色，用来旁证"哪些字节没被写过" */

/* ── 字节数常量 ──────────────────────────────────────────────────────────── */
#define PL_DMA_CALL_IN_BYTES   8192u
#define PL_DMA_CALL_OUT_BYTES  9728u    /* 8 帧 × 1216 B（LcwtMLP_RFFI，已删 logits） */
#define PL_DMA_FRAME_OUT_BYTES 1216u    /* 304 拍 × 4 B */
#define PL_DMA_N_FRAMES_OUT    8u
#define PL_DMA_TOK_FRAME_BYTES 1216u    /* 304 拍 × 4 B，16 token × 38 维，2×int16(Q4)/拍 */

#define PL_DMA_EQ_FRAME_BYTES  1024u    /* 256 拍 × 4 B，{Q[31:16], I[15:0]}，Q10 */
#define PL_DMA_EQ_N_FRAMES     8u
#define PL_DMA_EQ_CALL_BYTES   8192u    /* 8 帧 × 1024 B，与一次 xfer 的输入对齐 */

#define PL_DMA_EXP_FRAME_BYTES 1024u    /* 256 拍 × 4 B，193×int32(Q12) + 5 字头 + 填充 */
#define PL_DMA_EXP_N_FRAMES    8u
#define PL_DMA_EXP_CALL_BYTES  8192u    /* 8 帧 × 1024 B，与一次 xfer 的输入对齐 */
#define PL_DMA_EXP_MAGIC       0x45584631u  /* 字 193，ASCII "EXF1" */

/* out_bytes 的上限。DST 区最后 0x4C0 字节留给"排空"用 —— 一帧 1216 B，必须整
 * 落在 DST_MAX 以内，否则会写到 udmabuf 映射之外。排空落在那一小块里，
 * 不会盖掉调用者刚收到的帧（见 pl_dma_io.c 的 DRAIN_OFF）。
 * eq / 专家排空也用这个角落：1024 B < 1216 B，三边都能用。 */
#define PL_DMA_DRAIN_OFF 0xBB00u  /* 47872；47872 + 1216 = 49088 ≤ DST_MAX(0xC000) */
#define PL_DMA_OUT_CAP   PL_DMA_DRAIN_OFF
#define PL_DMA_EQ_CAP    PL_DMA_EQ_MAX
#define PL_DMA_EXP_CAP   PL_DMA_EXP_MAX
#define PL_DMA_IN_CAP    16383u   /* MM2S 单描述符上限（axi_dma_0 的 C_SG_LENGTH_WIDTH=14） */

/* 日志回调。**必须是 va_list 版**，库才能把可变参数原样转发给你；
 * 想直接打到 stdout 就把 pl_dma_io_log_vprintf 填进 cfg.log。 */
typedef void (*pl_dma_io_logfn)(void *user, const char *fmt, va_list ap);
void pl_dma_io_log_vprintf(void *user, const char *fmt, va_list ap);

typedef struct pl_dma_io pl_dma_io;    /* 不透明句柄 */

typedef struct {
    uint64_t    dma0_base;       /* MM2S 寄存器基址，默认 0x80400000 */
    uint64_t    dma1_base;       /* S2MM(dout) 寄存器基址，默认 0x80410000 */
    uint64_t    dma2_base;       /* S2MM(eq) 寄存器基址，默认 0x80420000；
                                  * 置 0 = 不用均衡通路，eq_* 返回 ENODEV */
    uint64_t    dma3_base;       /* S2MM(专家特征) 寄存器基址，默认 0x80430000；
                                  * 置 0 = 不用专家通路，expert_* 返回 ENODEV */
    const char *udmabuf_name;    /* 默认 "udmabuf0" */
    uint64_t    buf_phys;        /* 0 = 自己从 sysfs 读 */
    uint32_t    in_bytes;        /* 0 = PL_DMA_CALL_IN_BYTES */
    uint32_t    out_bytes;       /* 0 = PL_DMA_CALL_OUT_BYTES */
    uint32_t    eq_bytes;        /* 0 = PL_DMA_EQ_CALL_BYTES（8192）；
                                  * 必须是 1024 的整数倍且 ≤ PL_DMA_EQ_CAP */
    uint32_t    expert_bytes;    /* 0 = PL_DMA_EXP_CALL_BYTES（8192）；
                                  * 必须是 1024 的整数倍且 ≤ PL_DMA_EXP_CAP */
    int         timeout_ms;      /* 单次等待超时，默认 5000 */
    int         total_timeout_ms;/* 整轮的预算，默认 15000；0 = 不设 */
    int         evict;           /* 读结果前挤一次缓存，默认 1（保险，见 .c 里的注释）*/
    int         drain_on_open;   /* 开库时先排掉 dout/eq/专家上一轮的残留，默认 1
                                  * （约 900 ms：三条通道各一次收空尝试）*/
    int         alt_desc;        /* 描述符布局：0 = Xilinx BSP 64B（默认），1 = PG021 32bit */
    int         force_mode;      /* -1 = 按硬件自动选（默认），0 = 强制 SG，1 = 强制直读 */
    pl_dma_io_logfn log;         /* 可空 —— 库默认一个字都不打 */
    void       *log_user;
} pl_dma_io_cfg;

void pl_dma_io_cfg_default(pl_dma_io_cfg *cfg);

/* 开库：映射四个寄存器窗口 + udmabuf，探同步口，按硬件选 S2MM 走法。
 * 失败返回 NULL 并把 errno 设好（ENODEV 窗口没译码 / EACCES 权限 / ENOMEM mmap）。
 * dma2 / dma3 只支持直读（BD 里 C_INCLUDE_SG=0）；若硬件回显是 SG 模式，
 * 按 ENOTSUP 失败，不猜也不悄悄降级。 */
pl_dma_io *pl_dma_io_open(const pl_dma_io_cfg *cfg);
void       pl_dma_io_close(pl_dma_io *h);

/* ── 唯一那个阻塞调用 ──────────────────────────────────────────────────────
 * 一次调用 = 把 in_bytes 灌进去 + 把 out_bytes 收回来，返回即数据就绪。
 *
 *   in   : in_bytes 字节的普通内存（库内部 memcpy 进 udmabuf）；可给 NULL，
 *          表示"源缓冲里已经是我要的数据"（配合 pl_dma_io_in_ptr 用）
 *   out  : out_bytes 字节的普通内存，收完 memcpy 出来；可给 NULL 表示不要拷贝
 *   返回 : **实收字节数**（≤ out_bytes），<0 出错（errno: EINVAL / ETIMEDOUT / EIO）
 *
 * out_bytes 必须是 PL_DMA_FRAME_OUT_BYTES(1216) 的整数倍且 ≤ PL_DMA_OUT_CAP；
 * in_bytes 必须是 8 的倍数且 ≤ PL_DMA_IN_CAP。不满足直接 EINVAL，不猜。
 * **两个都给 0 = 用开库时 cfg 里配的那个尺寸**（默认 8192 / 9728）。
 *
 * 实收 < out_bytes 时，只有前 got 个字节可信；库会顺手排空 HLS 里的残帧
 * （所以下一轮不会被污染），并在 total_timeout 用完时放弃。
 *
 * xfer **只碰 dma0/dma1**，不会给 dma2/dma3 挂任何东西；均衡和专家特征
 * 分别由 eq_recv / expert_recv 单独收。*/
long pl_dma_io_xfer(pl_dma_io *h, const void *in, uint32_t in_bytes,
                                 void *out, uint32_t out_bytes);

/* ── 零拷贝那一对 ────────────────────────────────────────────────────────── */
void *pl_dma_io_in_ptr (pl_dma_io *h, uint32_t *cap);   /* udmabuf + SRC_OFF，cap = 16383 */
void *pl_dma_io_out_ptr(pl_dma_io *h, uint32_t *cap);   /* udmabuf + DST_OFF，cap = 47872 (0xBB00) */

/* 和 pl_dma_io_xfer(h, NULL, in_bytes, NULL, out_bytes) 是同一件事，
 * 只是写法上直说"我用的是那两个指针"。返回实收字节数，<0 出错。 */
long pl_dma_io_xfer_ptr(pl_dma_io *h, uint32_t in_bytes, uint32_t out_bytes);

/* ── 均衡那一路（axi_dma_2）───────────────────────────────────────────────
 * 单独一次阻塞调用，**不灌输入、不碰 dma0/dma1**：只把信号处理链路已经算好的
 * 均衡输出收回来。返回实收字节数（≤ eq_bytes），<0 出错。
 *
 *   eq_recv     : eq 非空时把数据 memcpy 出去；eq 给 NULL 表示不要拷贝
 *   eq_recv_ptr : 零拷贝版，收完直接读 pl_dma_io_eq_ptr() 那块
 *   eq_got      : 可空；返回实收字节数（出错时为 0）
 *
 * eq_bytes 必须是 PL_DMA_EQ_FRAME_BYTES(1024) 的整数倍且 ≤ PL_DMA_EQ_CAP(8192)；
 * 给 0 = 用 cfg.eq_bytes（再 0 就是 8192）。默认 8192 = 一次 xfer 对应的 8 帧。
 *
 * 时序上和 xfer 完全分开，但**数据上有先后**：xfer 灌进去的输入经过 PL 才有
 * 均衡输出。所以第一次 eq_recv 之前必须先有一次 xfer（否则等超时）。
 * 每轮 xfer 之后调一次 eq_recv；不调也行，但下一轮 xfer 之前要 eq_drain，
 * 否则 lstf_eq 的 8 个输入槽会被灌满、开始丢输入。
 *
 * 收不满（或超时）时返回实收值 / 负值，**这不会作废同一轮的 dout** ——
 * 两条链路的成败各自判。出错路径会顺手把 eq 通道排空，给下一轮一个干净起点。 */
long pl_dma_io_eq_recv(pl_dma_io *h, void *eq, uint32_t eq_bytes, uint32_t *eq_got);
long pl_dma_io_eq_recv_ptr(pl_dma_io *h, uint32_t eq_bytes, uint32_t *eq_got);
/* udmabuf + EQ_OFF，cap = 8192。指针只在**下一次 eq_recv 之前**有效（下一次
 * 调用会先铺底色再收），要留数据就自己拷走。 */
void *pl_dma_io_eq_ptr(pl_dma_io *h, uint32_t *cap);

/* 把均衡输出里残留的帧收掉（一帧 1024 B，最多 16 帧）。
 * 和 pl_dma_io_drain() 是两回事：那个只收 dout。返回排掉的帧数，<0 出错。 */
int pl_dma_io_eq_drain(pl_dma_io *h);

/* ── 专家特征那一路（axi_dma_3）───────────────────────────────────────────
 * 和 eq 同一套用法，只是通道、缓冲、帧内容不同：
 *
 *   expert_recv     : 收 expert_bytes（默认 8192 = 8 帧 × 1024 B）
 *   expert_recv_ptr : 零拷贝版，收完直接读 pl_dma_io_expert_ptr() 那块
 *   expert_got      : 可空；返回实收字节数（出错时为 0）
 *
 * expert_bytes 必须是 1024 的整数倍且 ≤ PL_DMA_EXP_CAP(8192)。
 * 同样必须在下一轮 xfer 之前收掉（否则专家模块的输出口被 TREADY 堵住）。
 * dma3 置 0 时全部返回 ENODEV。 */
long pl_dma_io_expert_recv(pl_dma_io *h, void *exp, uint32_t expert_bytes,
                           uint32_t *expert_got);
long pl_dma_io_expert_recv_ptr(pl_dma_io *h, uint32_t expert_bytes,
                               uint32_t *expert_got);
/* udmabuf + EXP_OFF，cap = 8192。指针只在**下一次 expert_recv 之前**有效。 */
void *pl_dma_io_expert_ptr(pl_dma_io *h, uint32_t *cap);
/* 把专家输出里残留的帧收掉（一帧 1024 B，最多 16 帧）。返回排掉的帧数，<0 出错。 */
int pl_dma_io_expert_drain(pl_dma_io *h);

/* ── 两个小工具 ──────────────────────────────────────────────────────────── */
/* 0 = SG 描述符环，1 = 直读（写 DA+LENGTH）。开库时按 dma1 的 DMASR.bit3 定的。 */
int pl_dma_io_mode(const pl_dma_io *h);

/* 把 dout 里残留的帧收掉（一帧一收，直到收不满或超时）。**只收 dma1**。
 * 想连跑多轮又怕污染，可以在轮与轮之间调一次；close() 之前调一次也是好习惯。
 * 均衡那一路用 pl_dma_io_eq_drain()，专家那一路用 pl_dma_io_expert_drain()，
 * 三者互不影响。返回排掉的帧数，<0 出错。 */
int pl_dma_io_drain(pl_dma_io *h);

/* ── 失败现场的信息 ────────────────────────────────────────────────────────
 * 上一次 xfer 收满的帧数（出错/超时也有效：出错时是"已经收全的那几帧"）。
 * 只作诊断，不参与任何重发决策 —— "补喂对齐"那套上板实测是负优化：
 * PL 的输出比输入滞后，按输出帧数推不出还欠多少输入，盲补只会固定多塞 2 帧。 */
int pl_dma_io_last_rx_frames(pl_dma_io *h);

#ifdef __cplusplus
}
#endif
#endif /* PL_DMA_IO_H */
