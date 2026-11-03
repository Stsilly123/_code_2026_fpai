# LcwtMLP_RFFI IP 交付说明

本文是 PL 侧 WaveMLP 前端（LCWT + Patch Embed）IP 的交付契约。
软件侧解包以下面第 5、6 节为准，逐位对偶于 `SRC/top.cpp` 的 `drain_frame()`。

> **2026-10-22 起：MLP 与分类头已删除。** 本 IP 只出 **16 × 38 的 Q8 token 矩阵**
> （LayerNorm / fc1 / GELU / fc2 / GAP / Linear 全部移除），分类改由软件侧做。
> 端口与 RFFI_FFT_ConvNet 的对齐关系不变，只是每帧输出从 314 拍缩到 **304 拍**。

---

## 1. 交付物

| 项 | 值 |
| --- | --- |
| IP 包 | `proj_export/solution1/impl/ip/xilinx_com_hls_LcwtMLP_RFFI_1_0.zip`（294,520 B） |
| 元数据 | `proj_export/solution1/impl/ip/component.xml`（94,357 B） |
| VLNV | `xilinx.com:hls:LcwtMLP_RFFI:1.0` |
| 顶层 | `LcwtMLP_RFFI` |
| 器件 | `xc7z030ffg676-2`（FMQL30TAI 的替身） |
| 时钟约束 | `create_clock -name ap_clk -period 5.000`；本项目另加 20% uncertainty ⇒ 有效目标 4.00 ns |
| 打包脚本 | `export_ip.tcl`（重综合 + 导出）、`pack_ip.tcl`（修 HLS `core_revision` 日期溢出） |

`core_revision` 打包值为 `610222026`（HLS 原始值 `2610222026` 超过 INT32_MAX，已取模修正）。
**每轮重新 export 后都要再跑一次 `pack_ip.tcl`。**

---

## 2. 资源与时测

### 2.1 csynth（pre-synthesis 估计）

| 项 | 值 |
| --- | --- |
| 时序 | Target 5.00 / Estimated **3.884** / Uncertainty 1.00 ns |
| 延迟（一次调用 = 8 帧） | min **34,081** / max **134,433** 拍 |
| 约合每帧 | 4,260 ~ 16,804 拍 ⇒ **21 ~ 84 µs @200 MHz** |
| 一次调用 | 0.17 ~ 0.67 ms @200 MHz（数据相关） |
| BRAM_18K / DSP / FF / LUT | 14 / 140 / 19,526 / 7,684 |

### 2.2 OOC 综合（真实数字，以这一节为准）

| 资源 | 实测 | 红线（器件 90%） | 判定 |
| --- | --- | --- | --- |
| LUT | **4,664（5.93%）** | 70,740 | ✅ |
| FF | **10,285（6.54%）** | 141,480 | ✅ |
| BRAM | **7 tiles（2.64%）**（3 × RAMB36 + 8 × RAMB18） | 477 | ✅ |
| DSP | **183（45.75%）** | 360 | ✅ |
| WNS | **+1.838 ns** | 4.00 ns 有效目标 | ✅（真实路径 3.162 ns） |

报告位：`proj_csynth/sol_csynth/ooc_rpt/`（`util_flat.rpt` / `timing.rpt` / `timing_paths.rpt`）。
LUT 全是 LUT as Logic（**4,664**），LUT as Memory **0**。

### 2.3 相对 MLP 版（2026-10-22 删 MLP）

| | MLP 版（上一交付） | **token-only（当前）** | 差 |
| --- | --- | --- | --- |
| OOC LUT | 9,439 | **4,664** | **−4,775（−50.6%）** |
| OOC FF | 17,378 | **10,285** | −7,093 |
| OOC BRAM | 10.5 tiles | **7** | −3.5 |
| OOC DSP | 318 | **183** | −135 |
| OOC WNS | +1.259 ns | **+1.838 ns** | +0.579 |
| csynth 延迟（8 帧） | 91,329 / 191,681 | **34,081 / 134,433** | 大幅缩短 |

删掉的是 LayerNorm、fc1/GELU、fc2/GAP、Linear head 以及它们的所有中间缓冲
（`lns` / `pres` / `gels` / `fc2s` / `gps` / `GELU_LUT`）。LCWT 分析与合成两级**代码一字未动**，
token 与 LCWT 内部级在 csim 和 cosim 中都逐位一致。

---

## 3. 端口

### 3.1 输入（与 CNN `RFFI_FFT_ConvNet` 完全一致）

| 端口 | 方向 | 宽度 | 总线 |
| --- | --- | --- | --- |
| `din_V_V_dout` | in | 33 | `acc_fifo_read` |
| `din_V_V_empty_n` | in | 1 | 高 = 非空 |
| `din_V_V_read` | out | 1 | 读使能 |

含义是**外部 FIFO 的读侧**，IP 内部没有输入 FIFO。PL 侧接法：

```
fifo.dout     -> din_V_V_dout
fifo.rd_en    -> din_V_V_read
!fifo.empty   -> din_V_V_empty_n      // native FWFT 的 empty 要取反
```

### 3.2 输出（一条 AXI4-Stream）

| 端口 | 方向 | 宽度 |
| --- | --- | --- |
| `dout_TDATA` | out | 32 |
| `dout_TVALID` | out | 1 |
| `dout_TREADY` | in | 1 |
| `dout_TKEEP` | out | 4（恒 `0xF`） |
| `dout_TSTRB` | out | 4（恒 `0xF`） |
| `dout_TLAST` | out | 1（每帧最后一拍） |

`TDATA_NUM_BYTES = 4`，总线类型 `axis`。

### 3.3 控制与复位

| 端口 | 说明 |
| --- | --- |
| `ap_clk` | 时钟 |
| `ap_rst_n` | **低电平复位**（`POLARITY = ACTIVE_LOW`） |
| `ap_start` / `ap_done` / `ap_idle` / `ap_ready` | 与 CNN 相同的块级握手，无 AXI-Lite |

---

## 4. 输入格式

- 每拍一个 33 位字：`[32] = last`、`[31:16] = Q`、`[15:0] = I`。
- `I/Q` 是 **Q10 定点**：`code = round(x * 1024)`，按 `int16` 解释（有符号）。
- 每帧 **256 拍**；一帧最后一拍 `last = 1`。
- 一次 `ap_start` 收 **8 帧 = 2048 拍**，按帧顺序。
- `last` 提前到来时：该帧剩余拍补 0，且在下一帧开始前不再读端口（定长 256 拍，最坏延迟有界）。
- 超过 256 拍的长帧不做重同步；上游必须按 256 拍/帧切好。

---

## 5. 输出格式（逐位契约）

一次调用输出 **8 × 304 = 2432 拍**，每帧 304 拍，**全部是 token**（没有 logits 段）：

| 拍号 `b` | 内容 | 每拍打包 |
| --- | --- | --- |
| `0 .. 303` | 16 个 token × 38 维 | 2 × `int16` |

### 5.1 token 段

`b = t * 19 + j`，`t = 0..15`，`j = 0..18`：

```
word[15:0]  = int16 sat16( (tok[t][2j]   + 8) >> 4 )     // Q4
word[31:16] = int16 sat16( (tok[t][2j+1] + 8) >> 4 )     // Q4
```

- 物理含义：**token 值 = `int16_code / 16.0`**（Q4）。
- 每个 token 19 拍，覆盖 38 维；拍序是 token-major（先 t，再 j）。
- 38 维是内部 Q8 的 patch-embed 结果右移 4 位并饱和到 `int16`；`+8` 是四舍五入。

### 5.2 帧边界

- `TLAST = 1` **只在每帧第 303 拍**（`b == 303`）。
- `TKEEP = TSTRB = 0xF` 恒定。
- 一帧 **304 拍 = 1216 B**；一次调用 **2432 拍 = 9,728 B**。

> 与 MLP 版的差别只在**少了第 304..313 那 10 拍 logits**；token 段的字节与拍序
> 与上一版**逐位相同**，软件侧 token 解包代码不用改。

---

## 6. 软件侧要求

### 6.1 DMA（AXI DMA 7.1，simple mode / 仅写通道）

当前 BD 的配置不用改（`Stream Data Width = 32`、`Memory Map Data Width = 32`、
`Width of Buffer Length Register = 14`，上限 16,383 B）。

**要改的是每次 S2MM 的 `S2MM_LENGTH`：**

| | CNN | LcwtMLP（token-only） |
| --- | --- | --- |
| 每帧字节数 | 684（171 拍） | **1216（304 拍）** |
| 一次 `ap_start` 的帧数 | 8 | 8 |
| 每次调用的 DMA 次数 | 8 | 8 |

```c
/* 每帧一次传输；TLAST 在 1216 字节处结束 */
Xil_Out32(base + XAXIDMA_RX_OFFSET + 0x28, 304 * 4);  /* S2MM_LENGTH */
```

**注意：** S2MM 的结束条件是 **TLAST 或 length 到，先到先停**。TLAST 不会把 length 放大。
如果把长度留在 684，会在一帧第 171 拍处截断，后 133 拍丢失。
**不要**用一次 DMA 收整次调用（9,728 B）：流里有 8 个 TLAST，DMA 会在第一个 TLAST 就结束。

### 6.2 解包（与 `drain_frame()` 逐位对偶）

```c
/* buf 指向一次 1216 字节的 S2MM 接收缓冲（32 位对齐），
   收完后先 Xil_DCacheInvalidateRange()。 */
static inline int16_t w_lo(uint32_t w) { return (int16_t)(w & 0xFFFFu); }
static inline int16_t w_hi(uint32_t w) { return (int16_t)(w >> 16);     }

void unpack_frame(const uint32_t *buf, float tok[16][38])
{
    for (int t = 0; t < 16; ++t) {
        for (int j = 0; j < 19; ++j) {
            uint32_t w = buf[t * 19 + j];
            tok[t][2 * j]     = (float)w_lo(w) / 16.0f;   /* Q4 */
            tok[t][2 * j + 1] = (float)w_hi(w) / 16.0f;
        }
    }
}
```

转换常数 **token: `/ 16`**（Q4）是契约的一部分。
分类（以及以前那 10 拍 logits）已不在 PL 上，若软件侧要分类，用这份 token 走训练侧的
Patch/MLP/head 路径（权重与定标由训练侧导出侧给出）。

### 6.3 调用流程

```
1. 取一帧 IQ（256 拍，Q10 的 I/Q），写满输入 FIFO
2. 拉 ap_start；IP 连续收 8 帧（2048 拍）
3. 每收到一帧的 TLAST（1216 B），解包一次，共 8 次
4. 等 ap_done，再处理下一次调用
```

### 6.4 超时

一次调用最长 **134,433 拍 ≈ 0.67 ms @200 MHz**（数据相关）。PS 侧轮询 `ap_done`
的超时不要沿用在 CNN 上的值，建议 **≥ 10 ms**。

### 6.5 校验建议

- 每帧第 303 拍必须有 TLAST；若提前结束，先查 `S2MM_LENGTH`。
- token 全是 0 或全为同一值，说明权重/标定不对，不要当成正常输出。
- 同一帧重复送两次，token 应逐位相同（IP 无跨帧状态）。

---

## 7. BD 替换清单

1. 把 `xilinx_com_hls_LcwtMLP_RFFI_1_0.zip` 加入 IP Repository。
2. 用 `LcwtMLP_RFFI` 替换 `RFFI_FFT_ConvNet` 实例。
   端口名、方向、宽度、总线类型完全一致，连线可自动对上。
3. `Validate Design`，确认：
   - `din_V_V` → `acc_fifo_read`
   - `dout` → `axis`
   - `ap_rst_n` 低有效
4. 软件：`S2MM_LENGTH` 684 → 1216；token 段解包为 304 拍 × 2 × int16(Q4)；
   删掉原来的 logits 解包段；超时放宽。

**不用改：** 输入 FIFO 深度、DMA 数据位宽、时钟、复位接法、输入 256 拍/帧、8 帧/次。

---

## 8. 与 CNN IP 的差异

| 项 | `RFFI_FFT_ConvNet` | `LcwtMLP_RFFI` |
| --- | --- | --- |
| 端口/协议 | 33 位 FIFO 读侧 + 32 位 axis | **相同** |
| 复位 | `ap_rst_n` 低有效 | 相同 |
| 输入 | 256 拍/帧 × 8 帧，Q10 | 相同 |
| 每帧输出 | 171 拍（96 + 75） | **304 拍（纯 token）** |
| token 打包 | 4 × int8 / 拍 | **2 × int16(Q4) / 拍** |
| logits | 150 类，2 × int16 / 拍 | **无（MLP/head 已删）** |
| 每次调用输出 | 1,368 拍 | **2,432 拍** |
| VLNV | `xilinx.com:hls:RFFI_FFT_ConvNet:1.0` | `xilinx.com:hls:LcwtMLP_RFFI:1.0` |

---

## 9. 验证状态

| 项 | 状态 |
| --- | --- |
| csim | **PASS**（2026-10-22，token-only）。8 帧 2,432 拍 / leftover 0；TLAST 0 坏帧、TKEEP/TSTRB 0 坏拍；stream token 608/608、lcwt_re/im 256/256、内部 tok 608/608 全部逐位一致；跨帧非退化检查通过；0 `ERROR` |
| csynth | 3.884 ns（≤ 4.00 ns 有效目标）；延迟 34,081 / 134,433 拍 |
| OOC 综合 | LUT **4,664** / FF **10,285** / BRAM **7 tiles** / DSP **183**，WNS **+1.838 ns**（真实 3.162 ns < 4.00），四条红线全过 |
| IP 打包 | 成功（`610222026`，0 `ERROR`），端口/总线/复位/约束逐条核过；输出只剩一条 `dout`，logit 相关端口 0 匹配 |
| **C/RTL cosim** | **PASS**（`cosim_design -rtl verilog -tool xsim`，2026-10-22 20:28）。8 帧 2,432 拍、TLAST 8/8 在第 303 拍、TKEEP/TSTRB 全对；stream token 608/608、lcwt_re/im 256/256、内部 tok 608/608 **逐位一致** |
| 上板 | 未跑（新网表尚未重新走 iCraft 编译） |
