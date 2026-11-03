# pl_dma_io —— PL 四个 AXI DMA 的收发封装

**只做一件事**：把「灌 IQ 进 HLS / 收 dout 回来」封成一个阻塞调用，另外给信道均衡
（`axi_dma_2`）和专家特征（`axi_dma_3`, `0x8043_0000`）各留一个接收调用。
不是推理库、不含图案、不含判读、不认识模型 —— 那些都在 `sw/pl_dma_test/pl_dma_test.c`（工具）和
`pl_dma_io_demo.c`（自测程序）里。

```
pl_dma_io.h / .c     库本身（C99，无第三方依赖）
pl_dma_io_demo.c     自测程序：probe / check / soak / zerocopy
build.sh             编库 + 编 demo（docker 优先，回退 2018.3 SDK 原生交叉编译器）
libpl_dma_io.a       产物（静态、aarch64）
```

```sh
sh build.sh          # libpl_dma_io.a + pl_dma_io_demo（demo 链库）
sh build.sh src      # 不建库，两个 .c 直接一起编 -> pl_dma_io_demo_src
sh build.sh lib       # 只产 .a
```

自己写程序用：

```sh
aarch64-linux-gnu-gcc -O2 -static -I. 你的程序.c -L. -lpl_dma_io -o 你的程序
# 或者把 pl_dma_io.c + pl_dma_io.h 直接抄进你的工程 —— 它就是普通 C99
```

## 接口（全部）

```c
pl_dma_io_cfg cfg;
pl_dma_io_cfg_default(&cfg);
cfg.log = pl_dma_io_log_vprintf;            /* 想看库在做什么就接上，可空 */
pl_dma_io *io = pl_dma_io_open(&cfg);       /* 失败 NULL，errno 有效 */
if (!io) { perror("open"); return 1; }

long got = pl_dma_io_xfer(io, in, 8192, out, 9728);   /* ← dout 那一路 */
if (got < 0)        perror("xfer");                   /* EINVAL/ETIMEDOUT/EIO */
else if (got != 9728) /* out 里只有前 got 个字节可信 */ ;

/* 均衡 / 专家两路：各单独收，必须在下一轮 xfer 之前 */
long egot = pl_dma_io_eq_recv(io, eq, 8192, NULL);
if (egot != 8192)   /* eq 里只有前 egot 个字节可信 */ ;
long xgot = pl_dma_io_expert_recv(io, exp, 8192, NULL);
if (xgot != 8192)   /* exp 里只有前 xgot 个字节可信 */ ;

pl_dma_io_close(io);
```

零拷贝（省两次 memcpy）：`pl_dma_io_in_ptr()` / `pl_dma_io_out_ptr()` / `pl_dma_io_eq_ptr()` /
`pl_dma_io_expert_ptr()` 拿 udmabuf 里的裸指针，填完/读完调 `xfer_ptr()` / `eq_recv_ptr()` /
`expert_recv_ptr()` —— 和拷贝版走**同一段时序**。

两个小工具：`pl_dma_io_mode()`（0 = SG 环，1 = 直读，开库时按硬件 `DMASR.bit3` 自动定）、
`pl_dma_io_drain()`（把 dout 里残留的帧收干净）；均衡 / 专家那两路用
`pl_dma_io_eq_drain()` / `pl_dma_io_expert_drain()`。

**单实例、非线程安全**（四个 DMA 是全局硬件，两个句柄同时开会互相踩）。
库**从不** `printf`、**从不** `exit()`、不碰全局变量 —— 日志只走 `cfg.log`，默认一个字都不打。

## 一次调用的字节数

| | 值 | 拆法 |
|---|---|---|
| 进 | 8192 B | 1024 个 64bit beat = 2048 个字 = 8 帧 × 256 字（一帧 1024 B） |
| 出（dout） | 9728 B | 8 帧 × 1216 B = 8 × 304 拍 × 4 B |
| 出（eq） | 8192 B | 8 帧 × 1024 B = 8 × 256 拍 × 4 B |
| 出（专家） | 8192 B | 8 帧 × 1024 B = 8 × 256 拍 × 4 B |

均衡输出（`axi_dma_2`，只收、直读）每拍 `{Q[31:16], I[15:0]}`，两个 int16、Q10；
每帧 256 拍、`TLAST` 在第 255 拍。它和 dout 的帧**没有下标对应关系**，
只是共用“一次 xfer 灌 8 帧输入”这个大节拍。

一帧 1216 B 的出处（`IP改动说明_20261022.md` §2/§4，逐位对偶于 `SRC/top.cpp`）：
拍 0..303 = 304 个 token 拍（2×INT16/拍，Q4：物理值 = code/16）→ 1216 B。
旧版帧末 10 拍（拍 304..313，2×INT16 Q8 的 20 类 logits）**已随 HLS MLP 一起删除**；
分类要在软件侧用这份 token 走训练侧的 LN/MLP/head。
**TLAST 在每帧第 303 拍**（旧版 313）。token 拍序为 token-major：`b = t*19 + j`
（t = 0..15，j = 0..18）。`S2MM_LENGTH` 必须给 1216 —— 给 1256 会靠短包行为收尾，不可依赖。

专家输出（`axi_dma_3`，只收、直读）每帧 256 字：字 0..192 = 193 个 int32（Q12，
物理值 = code/4096），字 193 = magic `0x45584631`（"EXF1"），194 = 版本 1，
195 = 本批帧号（0..7，RTL 里自由计数 mod 8），196 = 12（Q 格式），197 = 0（flags），
198..255 填充 0。特征顺序：`[0:128]` FFT、`[128:138]` 小波、`[138:166]` 常量、
`[166:178]` 累积量、`[178:187]` CFO、`[187:193]` 功率。
`TLAST` 在第 255 字，一帧 1024 B。

- 输入打包顺序 `[15:0]=I0 [31:16]=Q0 [47:32]=I1 [63:48]=Q1` —— **这条是假设、没实测过**
  （见 `doc/issues.md #3`）。若实测反了/斜了，**改 PL 里的 `stream_buf.v`，不是改这个库**。
- **帧边界不由库保证**：库只往里灌字节，切帧是 PL 里 `Signal_process` 按字数强切的。
  所以 `in_bytes` 必须是整数个"调用"，给 8192 的 1/2 虽然不报错但没有意义。
- **直读模式下 LENGTH 给 9728 也只收 1 帧 1216**（TLAST 一置就收工），所以库内部按帧挂 8 次。
  别想着"一次大 LENGTH 更省事"。

## udmabuf 布局（还是 128 KB，设备树不用改）

| 偏移 | 大小 | 用途 |
|---|---|---|
| `0x000000` | 64 B | MM2S 描述符 |
| `0x000100` | 0x200 | S2MM(dout) 描述符环（8 个） |
| `0x001000` | 64 KB 上限 | MM2S 源缓冲 |
| `0x010000` | 48 KB | dout 目标区（`PL_DMA_DST_MAX` = 0xC000） |
| `0x01BB00` | 1216 B | dout / eq / 专家共用的排空角落 |
| `0x01C000` | 8 KB | 均衡输出（固定，8 帧 × 1024 B） |
| `0x01E000` | 8 KB | 专家特征输出（固定，8 帧 × 1024 B，到 0x20000 为止） |

`PL_DMA_MAP_LEN` 固定 `0x20000`。**别把它改写成 `DST_OFF + DST_MAX`** —— 那样
映射只到 0x1C000，eq / 专家两块就落在 mmap 之外了。

## 均衡 / 专家那两路的硬规矩

1. **每轮 xfer 之后各收一次，且在下一轮 xfer 之前。** `lstf_eq` 和专家模块
   各只有 8 个槽，一次 xfer 正好灌满 8 帧；eq 不收会从第 9 帧开始丢输入
   （`stat_drop` 涨），专家不收会反压它的输出口。
2. **这一轮不用某一路，就先 `pl_dma_io_eq_drain()` / `pl_dma_io_expert_drain()`
   再进下一轮。**
3. 专家特征只对 **shift 0、每帧第一份** 有意义（TTA 平移对专家分支中性），
   上层通常只取第 0 帧、其余 7 帧丢弃。

eq / 专家和 dout 是三条独立的流：某一路上游不收**不会**反压 dout，所以它收失败/超时
**不作废**同一轮的 dout，反之亦然。

## 实收字节数从哪来

只有这两个是权威：

- **SG 模式**：描述符 `STATUS[25:0]` 的硬件回写值
- **直读模式**：`S2MM_LENGTH` 读回来就是**已收字节数**（**不是**剩余量；旧格式 684/684、652/652 两两对上过，与帧长无关）

内存里的 0xA5 底色边界（`PL_DMA_FILL_BYTE`）只是**旁证**，不作数 —— 数据里恰好出现一个 0xA5
就会数错（旧格式有过 682 vs 684 的实例）。`pl_dma_io_demo.c` 里的 `find_data_end` 就是干这个的。

**AXI DMA 没有任何可以读 TLAST 的寄存器**，"收够没够"只能按帧长和返回值判。

## 已知坑（改这个库之前先看这段）

1. **先挂 S2MM、再起 MM2S。** 反了第 1 帧会从帧中间切进去（实测 668 = 少 4 拍）。
2. **热路径里不许夹慢活。** 收完一帧到挂下一帧之间只能做 MMIO；一旦塞进 memset / sysfs 同步 /
   挤缓存 / `printf`，就是几百 µs 的窗口，而 HLS 每帧只要 ~50~113 µs（一次调用
   10,056~22,600 拍 @200 MHz）。所以库里在稳态循环里**一条日志都不发**，短帧的信息先攒着、循环外再报。
3. **流上有数据时不许复位通道。** 复位会让 S2MM 的 TREADY 抖，抖一下从流里吃掉几拍。
   dout 的 `xfer` 可以在挂第 1 帧前复位——那时 MM2S 还没起、流上是空的；**eq / 专家不行**：
   `eq_recv` 被调用时 `lstf_eq` 的 ofifo 里已经压着数据，复位实测**每轮第 1 帧固定
   1008/1024（少 4 拍）**，帧 2~8 因为不复位全整。专家通路的输出口同理。所以
   `eq_recv` / `expert_recv` 开头都不复位，直接挂；`chan_reset` 只出现在出错/超时路径。
4. **MM2S 是单描述符自环**，传完必须立刻复位，否则硬件会把同一条描述符再跑一遍。
5. **收不满就走人 = 给下一轮留存货**（下一轮的第 1 帧变 668/652）。所以 `xfer` 在"没收满"
   这条分支上自动排空，`cfg.drain_on_open` 默认也开（约 900 ms 一次性成本，dout / eq /
   专家各一次收空尝试）。连跑多轮前调一次 `pl_dma_io_drain()` / `pl_dma_io_eq_drain()` /
   `pl_dma_io_expert_drain()` 是好习惯。
6. **等 20 ms 再读缓冲。** DMA 的写是投递到 DDR 的，IOC 置起来那一刻最后几拍可能还在路上。
   板上实测（旧格式）：收完当场读是 134/150 个高字节"不合规"，等 20 ms 再读是 0 个 ——
   是读早了，不是数据错。
7. **软复位不能当"重挂"用**（`pl_dma_test.c` 的教训）：软复位后重挂，S2MM 可能不再往前走。

### 与工具（`pl_dma_test.c`）的三处有意不同

1. **`memset` 之后发 `SYNC_FOR_DEVICE`**，不照抄工具里的 `SYNC_FOR_CPU`（那是反的；
   板上因为 udmabuf 的 `dma_coherent = 1` 是空操作才没暴露 —— 而那条 DT 声明 2026-10-16 已删掉）。
2. **排空的落点是 `PL_DMA_DRAIN_OFF`(0xBB00 / 47872)**，不是偏移 0 —— 免得排空盖掉
   调用者刚收到的帧。dout（1216 B）/ eq（1024 B）/ 专家（1024 B）共用这一小块。
3. **稳态循环里一条日志都不打**（工具是打 `printf` 的，工具能那么干是因为它跑完就不管下一轮）。

## 出错时

`EINVAL` 尺寸不合法（不猜、直接拒） / `ETIMEDOUT` / `EIO` DMASR 报错位或复位超时 /
`ENODEV` 寄存器窗口没译码 / `EACCES` 没权限 / `ENOMEM` mmap 失败。全部走返回值 + `errno`。

前提：root（要 mmap `/dev/mem` 和 `/dev/udmabuf0`）、`/dev/udmabuf0` ≥ 128 KB、
四个 DMA 窗口（默认 `0x8040_0000` / `0x8041_0000` / `0x8042_0000` / `0x8043_0000`）已译码。
dma2 / dma3 不想用就把 `cfg.dma2_base` / `cfg.dma3_base` 置 0（对应 `eq_*` / `expert_*`
全部返回 `ENODEV`）。
dma2 / dma3 只支持直读；硬件 `DMASR.bit3` 回显是 SG 时，开库按 `ENOTSUP` 失败。
**不用中断** —— 全部轮询 DMASR，所以 IRQ_F2P 落到哪个 SPI 无所谓。

## 验到哪一步了

- 本机：`-Wall -Wextra` 交叉编译干净（库、demo、example 三个产物）。
- 本机（宿主 gcc + 假句柄/假寄存器，不碰硬件）：判读逻辑 8 组、错误路径 10 条，全部符合预期。
- **板上（2026-10-20，旧 IP：1256 B/帧、只有 dma0/1/2）**：`probe → check → soak 20 →
  zerocopy` 全部通过，`soak 20` 20/20 干净。
- 上板过程中修掉一处：`eq_recv` 开头原来有一次 `chan_reset`，板上稳定复现"每轮 eq 第 1 帧
  1008/1024（少 4 拍）"，去掉该复位后 check/soak 全干净。机理见"已知坑 3"。
- **2026-10-22 的改动（HLS 删 MLP → 1216 B/帧、新增 dma3 专家）还没上板**：
  IP 侧 C 仿真 / cosim 已过，但本节板上的结论都来自旧帧长，**不能直接套到新版**。
  新 bitstream 出来之后按 `probe → check → soak 20 → zerocopy` 重跑一遍。
- ⚠ 板上跑之前确认 bitstream 里 `axi_dma_2`（`0x8042_0000`）和 `axi_dma_3`
  （`0x8043_0000`）都已译码、设备树里也有对应节点，否则 `pl_dma_io_open` 会按
  `ENODEV` 失败（这是故意的：宁可开不了，也不要等第一次 recv 才炸）。
- ⚠ **`pl_dma_test.c` 没有跟着迁移**，它仍是更早的 CNN 格式（684 B/帧）的基线工具：
  `FRAME_OUT_BYTES 684` / `TOK_BEATS 96` 等常量、以及靠"logits 高字节必是 0x00/0xFF"
  找分界的那套判读都只对旧格式成立。换 IP 之后它只适合当**寄存器/通道诊断**用，
  别拿它和本库对拍。要和它对拍就得先把那 8 个宏和 `count_bad_int16` 那套判读一起改。
