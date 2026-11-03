# 问题记录（待确认/待处理）

> 更新（2026-10-14）：#1 已在硬件里解决（`stream_buf` 按字数强制切帧 + 补零），
> #2 的 ap 控制部分也已实现（启动/空闲全在 `Signal_process` 内部）；
> 代码见 [SRC/pl_ai/stream_buf.v](../SRC/pl_ai/stream_buf.v) 与
> [SRC/pl_ai/Signal_process.v](../SRC/pl_ai/Signal_process.v)。

## #1 HLS 输入帧契约：256 字/帧 —— 已由 stream_buf 硬件兜底

**背景**

`RFFI_FFT_ConvNet_0` 内部 `rx_frame` 的循环边界是**硬编码**的
（2026-10-14 IP 升级为 stream 输出后，输入侧契约**未变**，模块名由 `rx_frame301` 改为 `rx_frame`）：

```verilog
assign exitcond_fu_155_p2 = ((i_reg_128 == 9'd256) ? 1'b1 : 1'b0);
```

即每次推理固定消费 **256 个 33bit 字**（`{last, Q[31:16], I[15:0]}`），
对应 **128 个 64bit AXIS beat**。

`din_V_V_dout[32]`（我们的 `s_tlast`）只被写进内部 `fin_V`：

```verilog
fin_V_fu_66 <= din_V_V_dout[32'd32];            // 读到带标记的字后置位
...
if (fin_V == 1'd1 && exitcond == 1'd0)
    p_Val2_1_reg_139 <= 33'd0;                  // 之后的数据字补 0
```

也就是说 **bit32=1 只表示"本帧数据到此为止，后面补零"，并不会结束本次推理**，
循环次数仍然是固定的 256。

**问题**

上游一帧如果不是正好 128 beat，帧边界会整体错位且**没有任何报错**：

- 多发 → 多出来的字被下一帧吃掉，下一帧等于少数据、再下一帧再错位；
- 少发 → 本帧尾部补零，但下一帧的前面几个字会被本帧循环吃掉。

表现只是分类结果错乱，不会报错，很难查。

**当前实现（已按方案 B 落地）**

`stream_buf` 现在以**写出的字数**为准切帧，不再透传 `s_tlast`：

- 每写满 256 字，第 256 字的 bit32 强制置 1；
- 上游 `s_tlast` **提前**（本帧不足 256 字）→ 帧尾补 0 补满 256 字，
  不吃掉下一帧的头（补零阶段 `s_tready=0`，AXIS 天然顶住上游）；
- 上游 `s_tlast` **迟到/缺席**（超过 256 字）→ 忽略它，第 256 字照样切帧，
  多出来的字顺延进下一帧（先补满当前帧的尾部，再进下一帧）。

这与 HLS 源码里作者自己写下的意图一致
（`SRC/top.cpp:143-145`：长帧恢复"刻意不做……真要恢复，正确的位置是在**用户侧那个 FIFO 的前面**做错位检测"）
——`stream_buf` 就摆在那个位置。

于是"帧边界错位"在进 FIFO 之前就被钉死了。**上游唯一的义务**变成：
发的 beat 序列在调用级别是连续的（每 2048 字 = 8 帧 = 一次推理），
帧长本身已经不需要上游保证。

离线仿真（`SRC/pl_ai/tb_stream_buf.v`，xsim 逐字比对，不进工程）：
clean 128beat/帧、short 100beat/帧（每帧补 56 字）、
long 160beat/帧（1 上游帧拆 2 输出帧）以及两种 FIFO 反压版本，全部 `errs = 0`。

**遗留**：`last` 只对 *下游 HLS* 有"补零"语义，
所以上游 `s_tlast` 提前只影响本帧尾部；但**调用级**（8 帧）仍要求字数连续，
若某次 DMA 传输在中途被截断（少整帧），后续结果会整体错位且不报错——
这一层目前没有硬件兜底（要兜底就得在顶层再数 2048 字，或在 IP 外加 `ap_done` 计数校验）。

---

## #2 吞吐/缓存余量（关联之前"要不要双缓冲"）

`HLS_SYN_LAT = 20270` 个时钟/帧，200 MHz 下约 **101 µs 出一次结果**，
平均只能吃 `256 字 / 101 µs ≈ 2.5 字/µs`（≈ 0.0125 字/时钟）。

`fifo_hls` 只有 512 深（2 帧）。上游 AXIS 一旦持续灌数，FIFO 必然满，
只能靠 `s_tready` 反压：

- 上游**能**被反压（DMA 支持 tready）→ 不丢数，但整体进数速率被 HLS 拖到 ~2.5 字/µs；
- 上游**不能**被反压（连续 ADC 流）→ 必丢数，需要加大缓存（双缓冲/帧乒乓）或先降采样。

**待确认**：上游 IQ 的实际速率、DMA 是否支持反压。

**ap 控制（已实现，不对外暴露）**

`Signal_process` 内部自己管启动，BD 里看不到 `ap_start/ap_done/ap_ready`：

- `ap_idle` 是 `~ap_start & state1` 的**组合**输出（`RFFI_FFT_ConvNet.v:291`），
  直接拿它当启动条件会和 `ap_start` 成组合环 → 先打一拍成 `ip_idle_r` 再判；
- `ap_start = ip_idle_r & (avail_words >= 256)`，即**空闲 + FIFO 里够一帧**就发一个脉冲；
- FIFO 没开 data count 端口（`C_HAS_DATA_COUNT=0`），字数靠 `wr_words - rd_words` 自记；
- 下游不收结果时 IP 停在 state3，`ap_idle` 不拉高 → 不会重复启动，整链自然被反压。

`START_THRESHOLD = WORDS_PER_FRAME = 256`（常量在 `Signal_process.v` 顶部），
按现在 512 深 FIFO（2 帧余量）是稳的；想再放宽对上游抖动的容忍度，加深 FIFO 即可。

---

## #3 64bit 交织顺序是假设，未验证

`stream_buf.v` 里按下面这个顺序解包（见文件顶注释与输出赋值）：

```
[15:0] = I0    [31:16] = Q0    [47:32] = I1    [63:48] = Q1
```

即每 32bit 内**低 16bit 是 I、高 16bit 是 Q**，与 HLS 要的 `{Q[31:16], I[15:0]}` 一致。
如果实际上每个 16bit 槽里 Q 在前，需要在 `stream_buf.v` 里把
`[31:16]/[15:0]` 与 `[63:48]/[47:32]` 两两对调。

**待确认**：用一次实测数据比对 I/Q 是否反了（最简单的验证：灌一段已知的单音 IQ，
看 HLS 的 FFT 结果频谱是否符合预期）。

---

## #4 输出两条 AXIS **没有 TLAST** —— 已解决（2026-10-15 IP 再升级，两流合一 + TLAST）

> **结论**：IP 已于 2026-10-15 重新生成，`tok_out_V_V` / `logits_out_V_V` 合并成**一条**
> `dout` 32bit 复合流，并补上了 `TLAST`/`TKEEP`/`TSTRB`。每帧 **171 拍**（96 拍 tok + 75 拍 logits），
> **TLAST 在每帧第 170 拍**；一次调用 8 帧 = 1368 拍 = 5472 B，共 8 个 TLAST。
> RTL 侧 `SRC/pl_ai/Signal_process.v` 已把输出端口改成 `dout_*`，测试程序 `sw/pl_dma_test`
> 已按 684 B/帧适配（`e2e` 判读 TLAST 语义、`frames` 逐帧收 8 帧）。
> ⚠️ AXI DMA **没有可读 TLAST 的寄存器**，所以"TLAST 是否生效"只能间接验证
> （给一个大于一帧的 LENGTH，看是否提前 IOC）—— 见 `pl_dma_test.c` 的 `e2e` 判读段。
> 另：旧 IP 的 `logits_out_V_V_TREADY` 恒 0 造成的**硬死锁**（`ap_idle` 不再拉高、
> S2MM 一个字节都收不到）也随两流合一在结构上消失了。
>
> **板上实测（FMQLMP，2026-10-15）：TLAST 确实生效，契约全部成立。**
> `./pl_dma_test frames` 8/8 帧都落在 **684 字节**（不多不少），每帧在偏移 384
> 验出 **0 个高字节不合规**（logits 是 INT16，高字节必为 `0x00`/`0xFF`）→
> 96 拍 tok + 75 拍 logits 的分界、第 170 拍 TLAST 都被证实；
> **相邻帧逐字节一致**（8 帧输入相同 ⇒ 纯前馈，无跨帧状态）。
> `S2MM_LENGTH` 读回的是**已收字节数**（684/684、652/652 两两对上），不是剩余量。

<details><summary>升级前的记录（保留备查）</summary>

`tok_out_V_V` / `logits_out_V_V` 都是 `TDATA_NUM_BYTES=4`、`HAS_TLAST 0`、`HAS_TKEEP 0`
（见 `RFFI_FFT_ConvNet_0.veo`），即一条无边界标记的 32bit 流。

**每帧拍数（已从 RTL 与 HLS C 源码两头对上）**

两条流都由 `conv_tail` 排出，**每次 conv_tail 调用 = 1 帧**（它在帧级 dataflow 区域内，每帧启动一次）：

| 流 | 一拍内容 | 每帧拍数 | 出处 |
|---|---|---|---|
| `tok_out_V_V` | 4 个连续 INT8 token，小端 | **96** | `conv_tail.v:18499` `indvar_flatten == 7'd96`；C 侧 `N_TOKEN×(TOK_DIM/4) = 4×24` |
| `logits_out_V_V` | 2 个连续 INT16 logits，小端 | **75** | `conv_tail.v:18501` `j1_reg == 7'd75`；C 侧 `HEAD_CO/2 = 150/2` |

所以接 DMA（S2MM）时，TLAST 生成规则很简单：
**tok 每 96 拍一个 TLAST、logits 每 75 拍一个 TLAST**，两条流各自独立计数即可
（不需要知道 8 帧的调用边界，帧边界就是 96/75 拍）。
时序上注意：两路是**同时**排的（同一个 conv_tail 里先 DRAIN_TOK 96 拍、再 DRAIN_LOG 75 拍，
串行），所以接一个双通道 DMA 时，两条流的 TLAST 不会对齐。

**待确认**：最终怎么收（DMA / 自定义从机）。

</details>
