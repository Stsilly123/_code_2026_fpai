# PL 侧证据：expert_feat_rffi 无问题（配合 expert_dma3_issue.md v3）

日期：2026-10-26　　范围：`SRC/pl_ai/expert/` + `SRC/pl_ai/Signal_process.v` 的实例化
结论：**PL 侧没有发现缺陷。** 板上那 3 个"旧槽"是 PL 用**上一次调用的样点重新算出来的**；
expert 只有一个样点入口，所以上一轮的 3×256 样点确实在**本次调用期间又进了输入通路**。
把它再送一遍的是输入流的写方（PS 的 MM2S），不是 expert。

下面五组证据互相独立，任何一组单独都足以把责任指到输入侧。

---

## 证据 A：RTL 结构 —— 一个输入口，一帧进、一帧出

`SRC/pl_ai/expert/expert_feat_rffi.v`：

| 事实 | 位置 |
|---|---|
| 样点唯一来源是 `din/din_valid`（`din_r` 打一拍）；`frame_ram` 全模块只有两处访问：输入写、流水读 | L548 写、L373 读 |
| 一个 256 字帧只在写完第 255 字时 `wr_done` 一次，`nfull + 1` | L154-164 |
| S_IDLE 每消费一帧，`nfull - 1`；离开 S_IDLE 后本拍不可能再消费第二帧 | L583-584, L592-603 |
| 每帧流水**只在 S_PACK 的 `pk_idx==255`** 置 `feat_valid` 并 `out_idx+1`；没有任何路径能跳过 S_PACK 回到 S_IDLE | L701-711, L720 |
| AXIS 引擎只在 `feat_valid[ob]` 时起一帧 | L788 |
| 输出 bank 只在第 255 字握手那一拍释放（不会读半写 bank） | L587-588 |
| `feat_ram` 只有打包写、输出读 | L386-387 |

⇒ 输出帧数恒等于被消费的输入帧数；PL **没有第二写口、没有回放通路、没有重复打包路径**。
它没有办法凭空产生一帧，也没有办法把同一帧算两遍。

---

## 证据 B：板上数据 —— 旧槽是"上一轮输入"的完整重算（逐位可核）

数据：`Transformer_Train/_f31/expdiag0_f30.exp`、`expdiag0_f31.exp`，以及用
`gold/`、`gold30/` 里对 f31.in / f30.in 重新生成的定点 golden。
比较时去掉第 195 字（滚动帧号，本来就每帧 +1）。

| 比较 | 不同字数 | 超容差字数 | 结论 |
|---|---|---|---|
| f31 槽 0/1/2 vs f30 稳态槽（去 195） | **0** | — | 逐位相同 |
| f31 槽 0/1/2 vs golden(**f30.in**) | 40 | **0**（最大 10 LSB，全在 FFT 区） | 就是 f30 输入的结果 |
| f31 槽 3..7 vs golden(**f31.in**) | 111 | **0**（最大 9 LSB） | 本轮结果 |
| f31 槽 0/1/2 vs golden(f31.in) | 191 | 190 | 绝不是本轮结果 |

补充：

- 40 个差异字的下标集合与「f30 稳态槽 vs golden(f30.in)」**完全相同**
  （2,3,5,...,127,174，即 FFT log 幅度的既有小差）。
- CFO 9 字 178..186：f31 槽 0/1/2 与 f30 稳态槽、golden(f30.in) **9/9 逐位相等**；
  与 f31 的 golden 则明显不同（例：178 板端 −86 / f31 golden −517）。
- ctr（第 195 字）在 f31 是 0,1,2,3,4,5,6,7；旧槽恰好是 ctr 0,1,2。

**推理链：**

1. ctr 0/1/2 ⇒ 这 3 帧是本次调用窗口里**第 1、2、3 个打包**的帧；
2. 每打包一帧必先消费一帧（证据 A），所以它们是本次调用窗口里**前 3 个被消费的输入帧**；
3. 这 3 帧的输出逐位等于 golden(f30.in)，而不是"上一轮留下的输出字节"
   （输出 bank 每帧重写、DDR 每次先 memset 0xA5、`got==8192`、8 槽 magic 全 1）；
4. ⇒ 本次调用窗口里，前 3 个送进 expert 的输入帧携带的是 **f30 的 8×256 样点**；
5. expert 只有 `din` 一个样点入口（证据 A）⇒ 这些样点是输入流送进来的。

这不是"旧 bank 残留"能解释的：残留不可能恰好是一份完整、逐位一致的上一轮重算结果；
也不是"上一轮没读完的输出"：那样 ctr 会是 5,6,7,0,...，而实测是 0,1,2,...。

也不是"PL 只写了 5 帧，DDR 里那 3 槽是上一轮残留"：
`pl_dma_io.c` 的 `s2mm_recv_stream()` 在挂 DMA 前把 8 帧格子全部铺 `0xA5`
（未写到的槽会是 0xA5，不会碰巧是上一轮的完整特征），8 次按帧挂 S2MM（每帧 1024 B，
TLAST 收尾），diag6.log 里 **0 条"专家短收"**，8 槽 magic/valid 全对，
`got == 8192`。8 帧都是 PL 写出来的。

---

## 证据 C：同一 tap 上的另一个模块同步出现 3/8 分歧

`SRC/pl_ai/Signal_process.v`：`lstf_eq` 与 `expert_feat_rffi` 接的是**同一根**
`hls_din[31:0] / hls_wr`（stream_buf 输出，L253 / L274）。

`diag6.log` 的逐帧一致性（eq 的干净基线本来就是 7，它第 0 槽有已知首帧暂态）：

```
f00-f03:  dout agree=8   eq agree=7   expert xagree=8   (干净)
f08-f31:  dout agree=8   eq agree=5   expert xagree=5   (eq 与 expert 同为 3/8 分歧)
f04/f07/f11/f15/f19/f26/f29: 三条路同时掉（eq 掉到 0，expert 3~4，dout 6~7/超时）
```

eq 与 expert 是两个完全独立的模块，却在**同一帧开始**出现同样的 3/8 分歧；
HLS/dout 有自己的 8 帧输入 FIFO 与分组，表现不同但也从 f04 起掉到 6/7/0。
⇒ 异常在**共享输入流**上，不在某个模块的内部状态里。

---

## 证据 D：仿真 —— 8 进 8 出必须干净；只多 3 帧输入就复现板上形态

TB：`SRC/pl_ai/tb/tb_expert_input_queue.v`（xsim 2018.3 + IP 仿真模型，
`SRC/pl_ai/tools/sim_expert.sh` 同一套 lib）。

模型：expert 前面放一个"待发帧队列"（= SRC/DMA/stream_buf/FIFO 这段）。
每次调用 PS 往队尾追加 8 帧（本轮 SRC），HLS 侧每次正好从队头取 8 帧给 expert。
两组唯一的差别是 **SEED=1 时第 0 次调用后队里多 3 帧**（= 自环重发）。

判据：每个输出槽必须逐字等于**它实际收到的那一帧**的 golden
（0..127 ±16、172..186 ±2、其余逐位；195 不参与）。

**SEED=0（对照组，8 进 8 出）—— 实测日志：**

```
TB INPUT-QUEUE: NCALL=8 SEED=0
  call 0: slots=8 stale=0 ctr0..7 = 0..7 in_frames=8  drops=0
  call 1: slots=8 stale=0 ctr0..7 = 0..7 in_frames=16 drops=0
  call 2: slots=8 stale=0 ctr0..7 = 0..7 in_frames=24 drops=0
  call 3: slots=8 stale=0 ctr0..7 = 0..7 in_frames=32 drops=0
  call 4: slots=8 stale=0 ctr0..7 = 0..7 in_frames=40 drops=0
  call 5: slots=8 stale=0 ctr0..7 = 0..7 in_frames=48 drops=0
  call 6: slots=8 stale=0 ctr0..7 = 0..7 in_frames=56 drops=0
  call 7: slots=8 stale=0 ctr0..7 = 0..7 in_frames=64 drops=0
RESULT: SEED=0 calls=8 out_frames=64 in_frames=64 drops=0 stale_slots=0 mismatched_slots=0 -> GOLD-EXACT-ALL-SLOTS
```

**SEED=1（唯一差别：第 0 次调用后队列里多 3 帧）—— 实测日志：**

```
  call 0: slots=8 stale=0 ctr0..7 = 0..7 in_frames=8 drops=0
---- call 1  (queue tail=3, ring nfull=0) ----
  call 1 slot 0 feed=0 OLD ctr=0 mis=0
  call 1 slot 1 feed=0 OLD ctr=1 mis=0
  call 1 slot 2 feed=0 OLD ctr=2 mis=0
  call 1 slot 3 feed=1 cur ctr=3 mis=0
  call 1 slot 4 feed=1 cur ctr=4 mis=0
  call 1 slot 5 feed=1 cur ctr=5 mis=0
  call 1 slot 6 feed=1 cur ctr=6 mis=0
  call 1 slot 7 feed=1 cur ctr=7 mis=0
  call 1: slots=8 stale=3 ctr0..7 = 0..7 in_frames=16 drops=0
  call 2 .. call 7: 同形态（槽 0/1/2 = 上一次调用的帧，槽 3..7 = 本轮）
  call 7: slots=8 stale=3 ctr0..7 = 0..7 in_frames=64 drops=0
RESULT: SEED=1 calls=8 out_frames=64 in_frames=64 drops=0 stale_slots=21 mismatched_slots=0 -> GOLD-EXACT-ALL-SLOTS
```

几点和板上现象的逐条对应：

- 槽 0/1/2 是**上一次调用**的帧 —— 与 `diag6.log` 的 `XXX.....` 完全同形；
- 这个滞后**从第 2 次调用起一直存在**（3 帧塞进去就吊着），与板上 f04..f31 连续 28 次一致；
- `ctr 0..7` 每轮仍是严格的 0..7 —— 与板上“每轮正好打包 8 帧”一致；
- `in_frames == out_frames == 64`，`drops=0`：每轮 8 进 8 出、一帧未丢；
- `mismatched_slots=0`：**包括 21 个旧槽在内，每个输出都逐字等于它实际收到那一帧的 golden**。

**两组里所有输出槽都等于"实际喂入帧"的 golden**，连旧槽也是：
PL 的行为永远是"忠实计算我收到的帧"。SEED=1 的旧槽不是 PL 算错，
而是输入序列里那段确实就是上一轮的帧。

---

## 证据 E：板端日志指向 PS 的 MM2S 单描述符自环

- `sw/pl_dma_io/pl_dma_io.c` L785-787：MM2S 单描述符，`NXTDESC` 指向自己；
  注释已经写明"传完必须马上复位，否则硬件会把同一个描述符再跑一遍"。
- 同文件 L1018-1019：`mm2s_stop()`（里面才做 `chan_reset(MM2S)`）要等
  `xfer()` 把整轮 8 帧 dout 都收完之后才调用。
- 于是从"描述符第一次完成"到"收完 8 帧 dout"的**整段**（≈ 一轮 HLS 处理时间，
  上百 µs），自环一直在把同一份 8192 B 往输入通路里灌；输入 FIFO 一有空位就被补满。
  这解释了为什么滞后量是**稳定的 3 帧**而不是"多送了一整批 8 帧"：
  每次调用边界 FIFO 都被自环顶满，滞留量 = FIFO 可用深度（实测约 3 帧 = 3 KB），
  下一轮从队头取出的头 3 帧自然是上一批数据，槽 3..7 才是本轮。
- `diag6.log`：`MM2S 收场异常：DMASR=0x0001100a [IOC] 描述符 STATUS=0000000000 <- 没完成`，
  随后 `DMASR=0x00014019 [Halted ERR]` + `DMAIntErr(描述符 buffer length=0)` ——
  描述符完成后被重新取过。
- 重发的就是本轮 SRC 的同一批 8192 B；这与证据 B 的"旧槽 = 上一轮输入的完整重算"逐条对上。

---

## 给 PS 的结论与动作

1. **根因在 PS**：MM2S 自环在本轮收完 8 帧 dout 之前一直把同一份 8192 B 往 PL 里送
   （`mm2s_stop()` 在 8 帧收完之后才复位，见证据 E）。
   PL 无法区分重发帧和正常帧（它本来也不该区分），只能照收照算。
   滞后量就是每次调用边界上被自环顶满的输入 FIFO 滞留量（板上 = 3 帧）。
2. 修法（PS 侧）：
   - 收 dout 的等待循环里轮询 `MM2S_SR.IOC`，一见完成立刻 `chan_reset(MM2S)`；
   - 更彻底：让自环能真正终止，而不是靠事后复位。
3. **改完要做一次 PL 复位/排空**：输入通路上已经积着的 3 帧不会自己消失
   （稳态是 8 进 8 出、同速，会一直吊着）。PL 复位会同时清掉 FIFO/stream_buf 和 expert 的环。
   这一步只做一次；之后 FIFO 不再被自环顶满，滞留自然为 0。
4. 验收：64 次调用 × 8 帧，每轮 8 槽逐位相同、且等于该帧 golden，0 次失败。
   若改完仍稳定出现 `XXX.....`，说明还有第二处往输入通路重复写入的路径；
   用证据 B 的同一套比对（旧槽 vs 上一轮 golden）即可判定重发的是哪一批输入。

---

## 附：仿真怎么跑

```bash
# 2018.3 xsim；工作目录、lib 列表与 SRC/pl_ai/tools/sim_expert.sh 完全相同
xvlog -sv -i . ef_*.v expert_feat_rffi.v tb_expert_input_queue.v   # 对照组
xvlog -sv -d QUEUE_SEED -i . ef_*.v expert_feat_rffi.v tb_expert_input_queue.v  # 复现组
# 其余 IP 模型/glbl/xelab 步骤照 sim_expert.sh
```

两次运行的完整日志（2026-10-26 13:10 跑完）：

- 对照：`SRC/pl_ai/tb/sim_logs/tb_expert_input_queue_seed0.log`
- 复现：`SRC/pl_ai/tb/sim_logs/tb_expert_input_queue_seed1.log`

输入激励与判据用的是 `SRC/pl_ai/tb/vector/` 下的 `expert_in.hex` / `expert_gold.hex`
（gold 由 `SRC/pl_ai/tools/gen_expert_vectors.py` 定点生成，`sim_expert.sh` 会拷进工作目录）。
证据 B 里对 f30/f31 的 golden 用的是同一套定点模型对两帧 `.in` 重新生成的结果。
