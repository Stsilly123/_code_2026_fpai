# PL 侧专家特征提取：Verilog 实现指南

> 配套 `PL_专家系统_RTL+NPU实现指南.md`。本文写到**可交给 RTL 工程师直接开工**
> 的颗粒度：模块划分、端口、FSM、每块的算法与位宽、BRAM 组织、testbench 判据。
> 专家 MLP 在 NPU，**PL 里没有 MLP/GELU/μσ**。

---

## 1. 交付边界

```
FPAI_PL/HLS/LcwtMLP_RFFI（只读，一行不改）
         ↑ 现有 33-bit 流
   ┌─────┴─────┐
   │ Broadcaster│
   └──┬─────┬──┘
      │     │
 现有 IP    Expert_Feat_RFFI（本文）
                │
                └─ 32-bit AXIS，256 字/帧 → AXI DMA3 → PS → NPU
```

要求：

1. 输入流、时钟、复位与现有 IP 同域（250 MHz，4.00 ns 约束）。
2. 现有 IP 的 314 拍 `dout` 不动；专家输出是**独立**的 32-bit AXIS。
3. 专家模块对输入流**连续工作**，不要求 start/done 寄存器；一次 DMA 8 帧，
   内部按 TLAST 分帧。
4. 只读 `FPAI_PL`，RTL/综合/IP 包放独立工作区。

---

## 2. 顶层端口

```verilog
module expert_feat_rffi (
    input  wire         aclk,
    input  wire         aresetn,          // 低有效，同步释放

    // AXI4-Stream slave: {last, Q[15:0], I[15:0]}，Q10，256 拍/帧
    input  wire [32:0]  s_axis_din_tdata,
    input  wire         s_axis_din_tvalid,
    output wire         s_axis_din_tready,

    // AXI4-Stream master: 32-bit 特征，256 拍/帧，TLAST=第 255 拍
    output wire [31:0]  m_axis_feat_tdata,
    output wire         m_axis_feat_tvalid,
    input  wire         m_axis_feat_tready,
    output wire         m_axis_feat_tlast,

    // 可选状态（接 AXI-GPIO/ILA；不接也能工作）
    output wire         feat_busy,
    output wire [31:0]  frames_done,
    output wire [7:0]   err_flags       // bit0 非256拍, bit1 帧溢出, bit2 输出欠载
);
```

接到现有 IP 的 `din_V_V_*` 时，只是换名字，握手语义完全一致：

```verilog
// Broadcaster 的 branch A（AXIS master）→ 现有 LcwtMLP_RFFI 的 FIFO 读侧
assign lcwt_din_V_V_empty_n = bcast_a_tvalid;
assign bcast_a_tready       = lcwt_din_V_V_read;
assign lcwt_din_V_V_dout    = bcast_a_tdata;

// branch B → expert_feat_rffi
assign expert_s_tvalid = bcast_b_tvalid;
assign bcast_b_tready  = expert_s_tready;
assign expert_s_tdata  = bcast_b_tdata;
```

> 现有 IP 的 `din` 本来就是 valid/ready 握手，不要为它写 AXIS 转换器。

---

## 3. 模块划分

| 文件 | 模块 | 职责 |
| --- | --- | --- |
| `expert_feat_rffi.v` | 顶层 FSM、帧 RAM、特征缓冲、输出打包 |
| `ef_zn.v` | 平方和、rms、倒数、zn Q12 |
| `ef_fft_log.v` | FFT IP 包装、P=re²+im²、log2 LUT、128 维谱 |
| `ef_log2lut.v` | 前导零 + 1024 项尾数 LUT + 插值（组合/流水） |
| `ef_dwt_db4.v` | 4 级 db4、symmetric 延拓、5 带能量 |
| `ef_hist.v` | 幅度/相位直方图、az 统计 |
| `ef_cumulant.v` | z²/z⁴/z⁶、累积量、模/相 |
| `ef_cfo.v` | lag-20/lag-1/4 block、std |
| `ef_power.v` | log(rms)、az 矩、raw 均值 |
| `ef_atan2.v` | CORDIC 包装/sqrt 包装（或直接例化 IP） |
| `ef_pack.v` | 193 特征 + 头 + 填充，256 拍输出 |
| `tb/tb_expert_feat.sv` | golden 对拍、反压、边界 |

推荐例化关系：

```
expert_feat_rffi
 ├─ frame_ram          (8 × 256 × 32b，TDP BRAM)
 ├─ u_zn      (ef_zn)
 ├─ u_fft     (FFT IP) + u_fftlog (ef_fft_log)
 ├─ u_dwt     (ef_dwt_db4)
 ├─ u_hist    (ef_hist)   ← CORDIC sqrt/atan2
 ├─ u_cum     (ef_cumulant) ← 共享复乘引擎
 ├─ u_cfo     (ef_cfo)      ← 共享复乘引擎
 ├─ u_power   (ef_power)
 ├─ u_pack    (ef_pack)
 └─ feat_ram  (256 × 32b，ping-pong)
```

---

## 4. 输入缓存与 FSM

### 4.1 frame_ram

- 容量：`8 × 256 × 32 bit = 8192 B`，TDP BRAM。
- 写侧：每接受一拍写 `{Q,I}`；地址 `wr_frame*256 + wr_cnt`。
- 读侧：计算 FSM 逐帧读；与写侧不同端口，互不阻塞。
- `wr_frame` 0..7 循环；`frame_ready[7:0]` 标记已写满。
- `s_axis_din_tready = (inflight < 8)`。一次 DMA 正好 8 帧，下一批要等 PS
  取走结果；`inflight` 在计算消费一帧后减 1。
- 非 TLAST 时 `wr_cnt` 到 256 → 置 `err_flags[0]`，丢弃该帧并重新对齐。

### 4.2 帧 FSM

```
S_IDLE
  frame_ready!=0 → S_LOAD

S_LOAD        256 拍：读 frame_ram，累加 Σx、Σq、Σ(x²+q²)
S_RMS         1 次 sqrt + 1 次倒数
S_ZN          256 拍：算 zn，写 zn_ram；同时累加 raw 均值/功率所需量
S_FFT         FFT 256 点：灌 256 拍、收 256 拍
S_LOG         128 个 bin：P=re²+im² → log2 → lm，累加 Σlm
S_LOGMEAN     128 拍：lm -= Σlm>>7，写 feature[0:128]
S_DWT         4 级 db4（I/Q），算 10 个能量
S_SAMPLE      256 拍：一路喂直方图/CORDIC，一路喂累积量，一路喂 CFO，
              一路累加 az 矩；共享复乘引擎按时分复用
S_FINAL       累积量/CFO/功率/小波能量的 log、sqrt、atan2、std
S_PACK        写 256 字到 feat_ram，置 TLAST
S_DONE        frame_ready 清位，inflight--，回 S_IDLE
```

顺序执行即可，预算充足。不要第一版就上多块并行 DATAFLOW。

### 4.3 拍数预算

| 状态 | 拍数（估） |
| --- | --- |
| LOAD | 256 |
| ZN | 256 + 除法 ~40 |
| FFT | ~1,500 |
| LOG/mean | ~600 |
| DWT | ~2,000 |
| SAMPLE | ~1,500（时分复用） |
| FINAL | ~600 |
| PACK | 256 |
| **合计** | **~7k 拍/帧（28 µs @250 MHz）** |

按 15k 拍/帧做时序预算，8 帧 <0.5 ms。

---

## 5. 关键模块实现

### 5.1 ef_zn：rms 与 zn

```verilog
// 输入 x,q: signed [15:0] Q10
wire signed [31:0] x2 = x * x;          // DSP 16x16
wire signed [31:0] q2 = q * q;
// acc_sq: signed [63:0]；256 帧累加后
// mean_q20 = acc_sq >>> 8；rms_q10 = isqrt(mean_q20)
// isqrt 用 CORDIC Square Root 或 32-bit 整数开方，延迟 ≤40 拍
```

倒数（只在帧首做一次）：

```verilog
// rms_q10 == 0 → inv_q20 = 0（后续 zn 全 0，走保护）
// 否则 inv_q20 = (1 << 30) / rms_q10;   32-bit 无符号除法
```

zn：

```verilog
wire signed [47:0] p = x * $signed({1'b0, inv_q20});  // Q30
wire signed [47:0] pr = p + (48'sd1 << 17);           // round
wire signed [31:0] zn_q12 = pr >>> 18;
// 饱和到 [-32768, 32767]
```

`q` 同样处理。`zn_ram` 存 `{zn_q, zn_i}` 32 bit。

### 5.2 FFT + log 幅度

FFT IP 配置（v9.1）：

| 项 | 值 |
| --- | --- |
| Transform Length | 256 |
| Implementation | Radix-2 Lite, Burst I/O（或 Pipelined Streaming） |
| Data Format | Fixed Point |
| Input Width | 16 |
| Phase Factor Width | 16 |
| Output Width | **25** |
| Scaling | **Unscaled**（或 Block Floating Point） |
| Rounding | Convergent Rounding |
| Output Ordering | **Natural Order** |
| Forward/Inverse | Forward |

- 输入 `{im,re}` 两个 int16 Q12；灌 256 拍，`fwd_inv=1`。
- 输出取前 128 bin。**不能把输出缩到 16 bit**，否则 P 溢出。
- `P = re*re + im*im`：`re/im` 25 bit signed，平方 50 bit，和 51 bit；
  零扩展到 64 bit 后送 log LUT。

log2 LUT：

```verilog
// P: unsigned [63:0], P>0
// e = 63 - clz(P)                 // 0..63
// m = P << (63-e)                 // Q63，[1,2)
// idx = m[62:53]                  // 1024 项
// frac = lut[idx] + slope[idx]*(m[52:32]) >>> 21
// log2P_q16 = (e << 16) + frac
// lm_q12 = (log2P_q16 * 22713) >>> 20   // 0.5*ln2*4096
```

- LUT 用 Python 生成：`round(log2(1+i/1024)*65536)`，`slope` 用相邻差。
- `P==0`：`lm_q12 = -56588`（`log(1e-6)*4096`）。
- 128 个 lm 累加（int32），`mean = sum >>> 7`，逐项减均值写 `feature[0:128]`。

### 5.3 db4 小波

单层：

```
cA[t] = Σ_{k=0..7} lo[k] * x_ext(2t+1-k)
cD[t] = Σ_{k=0..7} hi[k] * x_ext(2t+1-k)

// mode='symmetric' = 半样本对称（整段镜像），不是只复制一个端点：
//   n < 0   → x[-n-1]
//   n >= N  → x[2N-n-1]
// 例：x_ext(-1)=x[0], x_ext(-2)=x[1], x_ext(N)=x[N-1], x_ext(N+1)=x[N-2]
```

- 系数 Q14（`round(coef*16384)`），输入 Q12，MAC 累加 Q26，输出
  `(acc + 8192) >>> 14` → Q12。
- 输出长度：256→131→69→38→22。
- 每个节点算 cA 和 cD；只保留 cA 进入下一级。
- 能量：`Σ c²` int64（Q24），除以实际长度（131/69/38/22），再 log。
- 顺序：`[I cA4, I cD4, I cD3, I cD2, I cD1, Q ...]`。
- 定点先在 `zn` 上算，最后每维加 `2*log(rms)`（Q12）。
- 实现建议：8 抽头移位寄存器 + 4 个乘法器，I/Q 分时；一个 level 约
  2×(131+69+38+22)×4 ≈ 2,080 拍。

### 5.4 直方图与 az

每个样点：

```
az_q12    = sqrt(zi² + zq²)          // CORDIC sqrt，输入 Q12
phase_q12 = atan2(zq, zi) * 4096     // CORDIC atan2，弧度 Q12
```

幅度 16 bin：

```verilog
// 15 个阈值：edge_j = 0.2 + j*(2.3/14)，Q12
// bin = (az >= e0) + (az >= e1) + ... + (az >= e14)   // 0..15
```

相位 12 bin：

```verilog
// 11 个内部阈值：-π + j*(π/6)，j=1..11，Q12
// bin = (phase >= e0) + ... + (phase >= e10)          // 0..11
```

- 计数器 9 bit（最大 256）。
- 输出 `count << 4` 即 Q12（`count/256*4096`）。
- 同一遍累加：`Σaz`、`Σaz²`、`Σaz³`、`Σaz⁴`，供功率组。
- 边界必须与 numpy `right=False` 一致：**等于阈值算进高 bin**。

### 5.5 累积量

按样点迭代：

```verilog
z2 = cmul(z, z);        // Q12*Q12 -> Q24 -> round >>>12
z4 = cmul(z2, z2);
z6 = cmul(z4, z2);
m2 = (zr*zr + zi*zi) >>> 12;      // Q12
m4 = (m2*m2) >>> 12;
m6 = (m4*m2) >>> 12;
```

累加器（int64，Q12）：

```
Sz2, Sz4, Sz6 (complex), Sm2, Sm4, Sm6 (real)
```

帧末除 256：

```
c20 = Sz2 >> 8
c21 = Sm2 >> 8
c40 = (Sz4>>8) - 3*c20²
c41 = (S(|z|² z)>>8) - 3*c20*c21
c42 = (Sm4>>8) - |c20|² - 2*c21²
c60 = (Sz6>>8) - 15*c20*(Sz4>>8) + 30*c20³
c63 = (Sm6>>8) - 9*c42*c21 - 6*c21³
```

- 所有复乘/幂用同一个共享复乘引擎，按时分复用。
- `c41` 需要单独累加 `|z|²·z`（第三组复乘），不能由 `c20/c21` 推。
- 中间结果用 int64；最终 Q12 饱和到 int32。
- 幅度：`sqrt(re²+im²)`；角度：`atan2(im,re)`；`atan2(0,0)=0`。
- 输出顺序：6 个模 + 6 个角。

### 5.6 CFO

```
r20 = Σ_{t=20..255} z[t]·conj(z[t-20]) / 236
r1  = Σ_{t=1..255}  z[t]·conj(z[t-1])  / 255
block_i = Σ_{t=i*64+20..(i+1)*64-1} z[t]·conj(z[t-20]) / 44
feat = [atan2(r20), |r20|, atan2(r1), |r1|,
        atan2(b0), atan2(b1), atan2(b2), atan2(b3), std(b0..b3)]
```

- 每个复乘 Q12×Q12 → Q24；累加 int64。
- 除以常数用 Q16 倒数：`(sum * recip) >>> 16`，常数在 Python 里生成并核对。
- `std`：`mean = (b0+b1+b2+b3)>>>2`；`var = mean(b²) - mean²`；
  `std = sqrt(var)`。**不 unwrap**，角度跨 ±π 时 std 会很大，这是训练口径。
- `|r|` 用 sqrt；角度用 atan2。

### 5.7 功率

```
[ log(rms), std(az), mean(az³), mean(az⁴), |mean(x)|, |mean(q)| ]
```

- `log(rms)`：rms Q10 → log2 LUT → 自然对数 Q12。
- `std(az)`：`Σaz`、`Σaz²`，`var = mean(az²) - mean(az)²`，sqrt。
- `mean(az³)`、`mean(az⁴)`：int64 累加，`>>>8`，截到 Q12。
- `|mean(x)|`：`Σx` int32，`>>>8`，取绝对值；Q10→Q12 左移 2。
- 注意第 0/4/5 维依赖原始 Q10 定标，不能把 rms 替换成 1。

### 5.8 输出打包

```
word 0..192   feature[0..192]（int32 Q12）
word 193      32'h45584631   // "EXF1"
word 194      32'd1          // version
word 195      frame_idx      // 0..7
word 196      32'd12         // Q format
word 197      32'd0
word 198..255 32'd0
TLAST          word 255
```

- 每帧 256 字；8 帧一次 DMA = 8192 B。
- `feat_ram` ping-pong：FSM 写一帧，输出侧读另一帧；输出侧 tready 反压时
  不阻塞计算（只要另一块空着）。
- `m_axis_feat_tlast = (rd_cnt == 255)`。

---

## 6. 复乘与共享算力

建议一个 3 乘法器复乘引擎：

```
pr = ar*br - ai*bi
pi = ar*bi + ai*br
```

- 每拍 1 个复乘（3 个 DSP + 若干加法），Q12×Q12→Q24→`>>>12`。
- 服务对象：累积量 z²/z⁴/z⁶、|z|²z、CFO 相关。用简单的 round-robin 调度。
- 若 DSP 有余量，可例化 2 个复乘引擎，把 SAMPLE 状态压到 ~800 拍。

矩/能量用单独的 16×16 或 24×24 乘法器，不要和复乘抢。

---

## 7. BRAM 与资源

| 存储 | 深度×位宽 | 说明 |
| --- | --- | --- |
| frame_ram | 2048×32 | 8 帧 `{Q,I}`，TDP |
| zn_ram | 256×32 | 当前帧 `{q,i}` Q12 |
| fft_ram | 256×50 | FFT 输出 `{im,re}`（25+25） |
| fft_log_ram | 128×32 | lm Q12 |
| feat_ram ×2 | 256×32 ×2 | 输出 ping-pong |
| log2_lut | 1024×18 | ROM |
| db4 系数 | 16×16 | ROM |
| 直方图 | 28×9 | LUTRAM/寄存器 |
| 特征缓冲 | 193×32 | BRAM/寄存器 |

预估：LUT 6~9k、FF 6~9k、BRAM 8~12 tile、DSP 18~24。最终以 OOC 为准。

综合注意：

- 所有 RAM 写 `(* ram_style = "block" *)`，不要让工具把 8 KB 展开成 LUTRAM。
- 时钟约束 4.00 ns（与 LCWT 相同）；OOC 报告 WNS 必须为正。
- 不要用不可综合的变量部分选择；LUT 索引用寄存后的整数。

---

## 8. Testbench 判据

### 8.1 golden 文件

由 Python 定点模型生成，二进制小端：

```
din_8f.bin     8 × 256 × 33 bit（按 64 bit 字存，低 33 位有效）
feat_8f.bin    8 × 256 × 32 bit（Q12）
```

同时保存中间量（可选，定位用）：

```
rms_q10, zn_q12, fft_log_q12[128], dwt_q12[10],
hist_q12[28], cum_q12[12], cfo_q12[9], power_q12[6]
```

### 8.2 必须测的用例

| 用例 | 判据 |
| --- | --- |
| 8 帧连续输入、输出全程 ready | 特征逐位一致；TLAST 每 256 拍 |
| 输出随机反压（tready 每 3~10 拍拉低） | 数据不丢、不重复、顺序不变 |
| 输入随机间隔 | 帧边界仍正确 |
| 全零帧 | 不除零、不产生 X；输出等于 golden |
| 最大幅度帧 | zn/FFT/累积量不溢出 |
| 直方图边界帧 | 边界值落 bin 与 numpy 一致 |
| 相位 ±π 帧 | atan2/CFO std 与 golden 一致 |
| 复位中途 | 复位后第一帧完整，无残留 |
| 8 帧 RAM 满 | 第 9 帧 tready=0，不覆盖未算帧 |

### 8.3 板端对拍

- PS 把 dma3 的 8 KB 原样落盘；PC 用同一批输入跑 Python 定点模型；
- 1,000 帧以上逐位比；任何一维不一致都先查**该维的中间量**，不要端到端猜。
- 同时抓 `frames_done`、`err_flags`，确认没有丢帧/拍数错。

---

## 9. 集成顺序（建议）

1. **单块仿真**：ef_zn → ef_fft_log → ef_dwt → ef_hist → ef_cumulant → ef_cfo
   → ef_power，各自用 golden 中间量逐位过。
2. **整帧仿真**：8 帧、无反压，特征逐位过。
3. **握手仿真**：输入间隔 + 输出反压。
4. **OOC 综合**：先只综合 FFT+log 微基准，确认 DSP/WNS；再整模块。
5. **上板**：先用 ILA 抓第一帧的 rms/FFT 头几个 bin，和 golden 对上，再接 DMA。
6. **接 NPU**：特征先落盘核对，再开专家 session。

---

## 10. 常见错误（按踩坑概率排）

1. **FFT 输出缩到 16 bit**：频谱、log、累积量全错。必须 ≥24 bit。
2. **db4 用了 periodic/zero padding**：10 维全错。必须 symmetric，端点复制。
3. **直方图边界写成 `>`**：整维偏移。必须 `>=`（等于阈值进高 bin）。
4. **CFO 对角度先 unwrap**：训练口径没有 unwrap，std 会错。
5. **`atan2(0,0)` 没定义**：golden 按 0，RTL 也要按 0。
6. **有符号右移写成 `>>` 逻辑右移**：负数舍入错。用 `>>>` 和 `$signed`。
7. **舍入不一致**：所有 `>>>` 前统一 `+ (1<<(S-1))`，并在 golden 里用同一规则。
8. **帧 RAM 满时仍拉高 tready**：覆盖未算帧。用 inflight 计数。
9. **TLAST 位置错**：DMA 按 TLAST 收包，错一拍整批错位。
10. **日志/状态没判新鲜度**：旧 buffer 会让 PS 读到上一批特征；magic +
    帧号 + 全零/全同退化检查都要做。
11. **拿 csynth/估算的 DSP 签字**：2018.3 对乘法器低估；只认 OOC。
12. **改了现有 LCWT 的 314 拍输出**：会破坏已验证的板端调用，禁止。

---

## 11. 与 NPU 的接口（PS 侧只要这些）

```cpp
// dma3 收 8192 B；只取第 0 帧（word 0..255）
const uint32_t *w = (const uint32_t *)feat_buf;
if (w[193] != 0x45584631u || w[194] != 1u || w[195] != 0u) { /* 丢弃/报错 */ }

float in[256];
for (int k = 0; k < 193; ++k) {
    float f = (float)(int32_t)w[k] / 4096.0f;
    float z = (f - mu[k]) / sd[k];
    z = std::clamp(z, -2.0f, 2.0f) / 2.0f;   // C=2，int8 版本
    in[k] = z;
}
for (int k = 193; k < 256; ++k) in[k] = 0.0f;
```

- 优先走 **fp16** 图，`C=16`（n=256：argmax 一致 **99.61%**，cos 1.0000，
  top1 只差 −0.39）。
- 吞吐兜底走 **int8** 图，`C=2`（n=256：一致 96.48%，top1 +0.39）。
- 两套图都已编好，见 `icraft_work/json&raw_zg/expert_mlp_20cls_{c2,fp16}_ZG.*`。
- 融合仍是 `0.6/0.2/0.2` 的 log 概率加权。

---

## 12. 参考

- 架构/接口/IP 清单：`PL_专家系统_RTL+NPU实现指南.md`
- 特征算法真值：`scripts/expert_feature_probe_20cls.py`
- NPU 编译：`icraft_work/expert_mlp_20cls_zg.toml`
- 现有 PL 端口：`FPAI_PL/HLS/LcwtMLP_RFFI/.../SRC/top.hpp`
- 现有板端 DMA 节奏：`impl_fpai_app/src/pl_side.hpp`
