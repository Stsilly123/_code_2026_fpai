# LcwtMLP_RFFI IP 交付说明

本文是 PL 侧 WaveMLP（LCWT + Patch Embed + Residual MLP + GAP/Linear）IP 的交付契约。
软件侧解包以下面第 5、6 节为准，逐位对偶于 `SRC/top.cpp` 的 `drain_frame()`。

---

## 1. 交付物

| 项 | 值 |
| --- | --- |
| IP 包 | `proj_export/solution1/impl/ip/xilinx_com_hls_LcwtMLP_RFFI_1_0.zip`（709,740 B） |
| 元数据 | `proj_export/solution1/impl/ip/component.xml`（226,905 B） |
| VLNV | `xilinx.com:hls:LcwtMLP_RFFI:1.0` |
| 顶层 | `LcwtMLP_RFFI` |
| 器件 | `xc7z030ffg676-2`（FMQL30TAI 的替身） |
| 时钟约束 | `create_clock -name ap_clk -period 5.000`；本项目另加 20% uncertainty ⇒ 有效目标 4.00 ns |
| 打包脚本 | `export_ip.tcl`（重综合 + 导出）、`pack_ip.tcl`（修 HLS `core_revision` 日期溢出） |

`core_revision` 打包值为 `610202258`（HLS 原始值 `2610202258` 超过 INT32_MAX，已取模修正）。
**每轮重新 export 后都要再跑一次 `pack_ip.tcl`。**

---

## 2. 资源与时测

### 2.1 csynth（pre-synthesis 估计）

| 项 | 值 |
| --- | --- |
| 时序 | Target 5.00 / Estimated **3.994** / Uncertainty 1.00 ns |
| 延迟（一次调用 = 8 帧） | min **91,329** / max **191,681** 拍 |
| 约合每帧 | 11,416 ~ 23,960 拍 ⇒ **57 ~ 120 µs @200 MHz** |
| 一次调用 | 0.46 ~ 0.96 ms @200 MHz（数据相关） |
| BRAM_18K / DSP / FF / LUT | 21 / 275 / 39,633 / 16,600 |

### 2.2 OOC 综合（真实数字，以这一节为准）

| 资源 | 实测 | 红线（器件 90%） | 判定 |
| --- | --- | --- | --- |
| LUT | **9,439（12.01%）** | 70,740 | ✅ |
| FF | **17,378（11.05%）** | 141,480 | ✅ |
| BRAM | **10.5 tiles（3.96%）** | 477 | ✅ |
| DSP | **318（79.5%）** | 360 | ✅ |
| WNS | **+1.259 ns** | 4.00 ns 有效目标 | ✅（真实路径 3.741 ns） |

报告位：`proj_csynth/sol_csynth/ooc_rpt/`（`util_flat.rpt` / `timing.rpt` / `timing_paths.rpt`）。

LUT 明细：LUT as Logic **9,322**、LUT as Memory **117**。

**2026-10-20 BRAM 换 LUT**：`lns` / `gels`（帧内，`RAM_1P_BRAM`）与顶层 `tokT`（`RAM_2P_BRAM`）
从 LUTRAM 改成 BRAM。这三个数组的两端都是逐元素顺序访问（写 1 个/拍、读 1 个/拍或 2 个/拍），
单口/双口 BRAM 即可覆盖，**一拍都没多**：csynth 延迟仍是 80,449 / 180,801 拍，
OOC 的 LUT 18,835 → 15,698（−3,137，−16.7%），代价是 BRAM 7 → 9 tiles 与 WNS −0.507 ns
（仍 +1.279，真实 3.721 ns < 4.00）。`toks` 故意留在 LUTRAM —— 它两端都是 38 路并行访问，
转 BRAM 需要串行化，约 +1,216 拍/帧。

**2026-10-20 `toks` → BRAM 已实测，判为负结果，不再动。** 把帧内 `toks` 改成直接写顶层
`tokT`（BRAM）、GAP 残差改成单累加器串行趟之后：csynth 3.939 ns、延迟 85,113 / 185,465 拍，
**OOC LUT 17,368 / FF 29,163 / DSP 313 / WNS +1.109**。相对本节数字 LUT +1,670、FF +3,691、
WNS −0.170 ns、每帧多 613 拍，**四个轴上全是亏**。原因是 `toks` 本来就被 HLS 铺成分布式 RAM
（LUT as Memory 1,186 里的 1,079），换 BRAM 只还回 1,039，抵不上串行化和 GAP 残差趟的成本。
源码已回退到本节这一版，csim 逐级输出与本 IP 逐位一致，csynth 报告的 18/275/48,523/23,158、
延迟 80,449 / 180,801 与导出时逐行相同，重新生成的 RTL 与包内 RTL 逐字节一致（仅生成时间戳行不同）
⇒ 当时无需重新导出（该状态已被下一段的 GAP 重构取代）。

**2026-10-20 GAP 重构（当前交付版，17:18）**：`fc2_gap` 原来用了 **38 个并行的 44 位累加器**
（`gsum[]`）跨整个 token 循环常驻，加上 `GAP_DIV` 的 38:1 读回 mux，OOC 网表里是 **2,774 LUT**，
全设计最大的一块。现在改成：38 路重量化结果先进 `yreg[38]`，再经流水循环一拍一路写进
`fc2s`（**单口 BRAM**，`RAM_1P_BRAM`），GAP 的两半（fc2 残差 + 原始 token）用**一次平铺的
II=1 扫描**直接从两块 BRAM 读出来相加。整数加法精确且可结合、项集完全相同
（最坏 16×(2³¹+2³¹)=2³⁷，远在 44 位内）⇒ **逐位不变**，csim 逐级逐位 PASS、0 `ERROR`。

| | 上一交付版 | **GAP 重构后** |
| --- | --- | --- |
| OOC LUT | 15,698 | **9,774（−5,924，−37.7%）** |
| OOC FF | 25,472 | **17,817（−7,655，−30.1%）** |
| OOC DSP | 318 | **308** |
| OOC BRAM | 9 tiles | **10.5 tiles** |
| OOC WNS | +1.279 ns | **+1.283 ns**（真实 3.717 ns） |
| csynth 延迟 | 80,449 / 180,801 拍 | **91,329 / 191,681 拍** |

代价是每帧 +1,360 拍（+13.5%）。这一版已经重新综合、导出、打包（`610201729`）。

**2026-10-20 GELU LUT 偏置修复（当前交付版，22:58）**：C/RTL 联合仿真暴露 **csim 对、RTL 错**，
错在 `gelu` 这一级（下游 fc2/gap/head 只是把错误值传下去）。根因是 HLS 2018.3 为
GELU 插值生成的 DSP 宏 `LcwtMLP_RFFI_ama_*.v` 把有符号操作数**零扩展**
（`assign b = $unsigned(in2)` / `assign c = $unsigned(in3)`）：LUT 里任何负值、
以及 `l1*frac` 的任何负积，在 RTL 里都被当成无符号大数，而 C 模型知道它们是有符号的。
**修法**：`GELU_LUT` 改为存 `value + GELU_LUT_BIAS(8192)`（`ap_uint<16>`），
插值全程无符号，`acc>>2` 后减回 8192。因为 `(4−frac)+frac == 4` 且 `8192*4>>2 == 8192`，
结果与原公式**逐位相同**；csim 侧 `gelu()` 的语义未变，只有表本身换了表示。
tb 新增 check 0 钉住表示（0 个负项、`LUT[0]=8192`、`LUT[end]=10240`）。

| | GAP 重构版 | **GELU 修复版（当前）** |
| --- | --- | --- |
| OOC LUT / FF | 9,774 / 17,817 | **9,439 / 17,378** |
| OOC DSP / BRAM | 308 / 10.5 | **318 / 10.5** |
| OOC WNS | +1.283 ns | **+1.259 ns**（真实 3.741 ns） |
| csynth 延迟 | 91,329 / 191,681 拍 | 91,329 / 191,681 拍（不变） |
| cosim | 未跑 | **PASS，logits 160/160 逐位一致** |

打包件里逐条核过：`GELU_LUT_V_q0` 是 `[13:0]` 无符号、`phitmp = $signed(15'd24576) + …`
（24576 = −8192 的 15 位补码）。**以后重生成权重头时，导出脚本必须继续带
`GELU_LUT_BIAS`**（`SRC/tools/export_pl_lcwt_hls.py` 已改），否则故障原样复现。

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

一次调用输出 **8 × 314 = 2512 拍**，每帧 314 拍：

| 拍号 `b` | 内容 | 每拍打包 |
| --- | --- | --- |
| `0 .. 303` | token 段，16 个 token × 38 维 | 2 × `int16` |
| `304 .. 313` | logits 段，20 类 | 2 × `int16` |

### 5.1 token 段

`b = t * 19 + j`，`t = 0..15`，`j = 0..18`：

```
word[15:0]  = int16 sat16( (tok[t][2j]   + 8) >> 4 )     // Q4
word[31:16] = int16 sat16( (tok[t][2j+1] + 8) >> 4 )     // Q4
```

- 物理含义：**token 值 = `int16_code / 16.0`**（Q4）。
- 每个 token 19 拍，覆盖 38 维；拍序是 token-major（先 t，再 j）。

### 5.2 logits 段

`b = 304 + j`，`j = 0..9`：

```
word[15:0]  = logits[2j]      // 有符号 int16
word[31:16] = logits[2j+1]    // 有符号 int16
```

- 物理含义：**logit 值 = `int16_code / 256.0`**（Q8）。
- PL 只出 logits，**不出概率**；`softmax(logits_real)` 在软件侧。

### 5.3 帧边界

- `TLAST = 1` **只在每帧第 313 拍**（`b == 313`）。
- `TKEEP = TSTRB = 0xF` 恒定。
- 一帧 **314 拍 = 1256 B**；一次调用 **2512 拍 = 10,048 B**。

---

## 6. 软件侧要求

### 6.1 DMA（AXI DMA 7.1，simple mode / 仅写通道）

当前 BD 的配置不用改（`Stream Data Width = 32`、`Memory Map Data Width = 32`、
`Width of Buffer Length Register = 14`，上限 16,383 B）。

**要改的是每次 S2MM 的 `S2MM_LENGTH`：**

| | CNN | LcwtMLP |
| --- | --- | --- |
| 每帧字节数 | 684（171 拍） | **1256（314 拍）** |
| 一次 `ap_start` 的帧数 | 8 | 8 |
| 每次调用的 DMA 次数 | 8 | 8 |

```c
/* 每帧一次传输；TLAST 在 1256 字节处结束 */
Xil_Out32(base + XAXIDMA_RX_OFFSET + 0x28, 314 * 4);  /* S2MM_LENGTH */
```

**注意：** S2MM 的结束条件是 **TLAST 或 length 到，先到先停**。TLAST 不会把 length 放大。
如果把长度留在 684，会在一帧第 171 拍处截断，后 143 拍丢失。
**不要**用一次 DMA 收整次调用（10,048 B）：流里有 8 个 TLAST，DMA 会在第一个 TLAST 就结束。

### 6.2 解包（与 `drain_frame()` 逐位对偶）

```c
/* buf 指向一次 1256 字节的 S2MM 接收缓冲（32 位对齐），
   收完后先 Xil_DCacheInvalidateRange()。 */
static inline int16_t w_lo(uint32_t w) { return (int16_t)(w & 0xFFFFu); }
static inline int16_t w_hi(uint32_t w) { return (int16_t)(w >> 16);     }

void unpack_frame(const uint32_t *buf, float tok[16][38], float logits[20])
{
    for (int t = 0; t < 16; ++t) {
        for (int j = 0; j < 19; ++j) {
            uint32_t w = buf[t * 19 + j];
            tok[t][2 * j]     = (float)w_lo(w) / 16.0f;   /* Q4 */
            tok[t][2 * j + 1] = (float)w_hi(w) / 16.0f;
        }
    }
    for (int j = 0; j < 10; ++j) {
        uint32_t w = buf[304 + j];
        logits[2 * j]     = (float)w_lo(w) / 256.0f;      /* Q8 */
        logits[2 * j + 1] = (float)w_hi(w) / 256.0f;
    }
}
```

两个转换常数是契约的一部分：

- **token: `/ 16`**（Q4）
- **logit: `/ 256`**（Q8）

少除或多除不改变 `argmax`，但会改变 logits 的温度，进而改变融合后的判决。

### 6.3 调用流程

```
1. 取一帧 IQ（256 拍，Q10 的 I/Q），写满输入 FIFO
2. 拉 ap_start；IP 连续收 8 帧（2048 拍）
3. 每收到一帧的 TLAST（1256 B），解包一次，共 8 次
4. 等 ap_done，再处理下一次调用
```

### 6.4 超时

一次调用最长 **191,681 拍 ≈ 0.96 ms @200 MHz**（数据相关）。PS 侧轮询 `ap_done`
的超时不要沿用在 CNN 上的值，建议 **≥ 10 ms**。

### 6.5 校验建议

- 每帧第 313 拍必须有 TLAST；若提前结束，先查 `S2MM_LENGTH`。
- logits 全是 0 或全部饱和，说明权重/标定不对，不要当成正常输出。
- 同一帧重复送两次，logits 应逐位相同（IP 无跨帧状态）。

---

## 7. BD 替换清单

1. 把 `xilinx_com_hls_LcwtMLP_RFFI_1_0.zip` 加入 IP Repository。
2. 用 `LcwtMLP_RFFI` 替换 `RFFI_FFT_ConvNet` 实例。
   端口名、方向、宽度、总线类型完全一致，连线可自动对上。
3. `Validate Design`，确认：
   - `din_V_V` → `acc_fifo_read`
   - `dout` → `axis`
   - `ap_rst_n` 低有效
4. 软件：`S2MM_LENGTH` 684 → 1256；token 段解包改为 304 拍 × 2 × int16(Q4)；
   logits 改为 10 拍 × 2 × int16(Q8)；超时放宽。

**不用改：** 输入 FIFO 深度、DMA 数据位宽、时钟、复位接法、输入 256 拍/帧、8 帧/次。

---

## 8. 与 CNN IP 的差异

| 项 | `RFFI_FFT_ConvNet` | `LcwtMLP_RFFI` |
| --- | --- | --- |
| 端口/协议 | 33 位 FIFO 读侧 + 32 位 axis | **相同** |
| 复位 | `ap_rst_n` 低有效 | 相同 |
| 输入 | 256 拍/帧 × 8 帧，Q10 | 相同 |
| 每帧输出 | 171 拍（96 + 75） | **314 拍（304 + 10）** |
| token 打包 | 4 × int8 / 拍 | **2 × int16(Q4) / 拍** |
| logits | 150 类，2 × int16 / 拍 | **20 类，2 × int16(Q8) / 拍** |
| 每次调用输出 | 1,368 拍 | **2,512 拍** |
| VLNV | `xilinx.com:hls:RFFI_FFT_ConvNet:1.0` | `xilinx.com:hls:LcwtMLP_RFFI:1.0` |

---

## 9. 验证状态

| 项 | 状态 |
| --- | --- |
| csim | **PASS**，8 帧逐级逐位一致，流打包/解包对偶校验通过，0 `ERROR`（2026-10-20 GELU 修复后重跑；新增 LUT 表示检查） |
| csynth | 3.994 ns（≤ 4.00 ns 有效目标）；延迟 91,329 / 191,681 拍 |
| OOC 综合 | LUT 9,439 / FF 17,378 / BRAM 10.5 / DSP 318，WNS **+1.259 ns**（真实 3.741 ns < 4.00），四条红线全过 |
| IP 打包 | 成功（`610202258`，0 `ERROR`），端口/总线/复位/约束逐条核过；包内 RTL 的 GELU LUT 是 14 位无符号 + −8192 偏置 ⇒ 确认打的是修复后的网表 |
| **C/RTL cosim** | **PASS**（`cosim_design -rtl verilog -tool xsim`，2026-10-20 23:00）。8 帧 2,512 拍、TLAST 8/8、TKEEP/TSTRB 全对；**logits 160/160 逐位一致**（`[-6047, 4453]`，160/160 非零），全部内部级（lcwt/tok/ln/pre/gelu/fc2/gap/logits_db）逐位一致 |
| 上板 | 未跑 |
