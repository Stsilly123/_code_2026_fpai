# L-STF 信道均衡器 —— Verilog 实现指南

> 算法唯一事实来源：`scripts/make_pl_preproc_cache.py` 的 `--mode eq`（`lstf_equalize`，`reg=0.1`，`snr_min=3.0`）。
> 本文只写 RTL 方案，不改 `FPAI_PL/`。
> 适用对象：**XF（Transformer）输入前的预处理**。PL 侧 AI 模型仍吃 raw IQ。

---

## 0. 结论先行

- 这套均衡在 host 上已验证：XF raw **0.7398 → 0.7784**（+3.86 点）。
- **输入输出契约（已定）**：raw IQ 为 int16 Q10，本模块输出均衡后的 int16 Q10，
  与 `data_cache_20cls_lstfeq_rawonly_q10` 同一格式；之后才做 XF 的 per-sample norm。
- INT16/Q10 已实测不掉点：XF 五折 TTA **0.8220**（float 0.8221），
  与 PL 融合 **0.8333**（float 0.8332）。所以 Verilog 的末级直接饱和到 int16 即可。
- **PL 的 AI 模型不要接均衡输出**：同权重控制变量臂只有 +0.16 点，CI 跨 0；
  而去 CFO 会掉 10.4 点（CFO 是设备指纹）。
- 如果 XF 不在板上跑，这个模块没有部署价值——host 上 20 行 numpy 就够了。
  值得写 Verilog 的场景只有两个：把 XF 预处理从 host 挪到 PL，或比赛叙事需要"PL 有经典 DSP"。
- 硬件规模估算：8 条复数 MAC 流水，约 **24~32 DSP + 4~8k LUT + 6~8 个 BRAM18**；
  200 MHz 下一帧约 **8.5 µs**（帧周期 10.24 µs），有约 17% 余量，250 MHz 更稳。
- 直译 float 算法会写出 20 点 FFT、除法器、atan 和一堆乘法。实际不需要：第 3 节有 5 个
  数学化简，能把它们全绕开。

---

## 1. 目标算法（与 Python 逐行对应）

输入一段 256 点复数 IQ：`x[0..255]`。前 200 点是 10 个重复的 20 点 L-STF，
每个 20 点块内有 12 个导频音。25 MSps 下 20 点 = 0.8 µs。

### 1.1 常量

```text
N        = 256                       # 段长
FS       = 25e6                      # 采样率（只用于解释，不参与运算）
P        = 20                        # L-STF 周期
NBLK     = 10                        # 前 200 点 = 10 块
LSTF_K   = [-6,-5,-4,-3,-2,-1, 1,2,3,4,5,6]
LSTF_SIGN= [ 1,-1, 1,-1,-1, 1,-1,-1,1,1,1,1]      # 与 LSTF_K 一一对应
LSTF_S   = (1+j) * LSTF_SIGN
LSTF_K20 = [14,15,16,17,18,19, 1,2,3,4,5,6]       # 20 点 DFT 的 bin 号，与 LSTF_K 顺序一致
REG      = 0.1
SNR_MIN  = 3.0
```

### 1.2 处理链

```text
x ──► CFO 估计 r ──► θ = angle(r)
     │
     ├─► 10 个块对齐 (乘 e^{-jθb}) ──► 12 个导频 bin 的 20 点 DFT
     │                                        │
     │                                        ▼
     │                             相干平均 10 块 / LSTF_S
     │                                        ▼
     │                             H[k], k=±1..±6（12 个）
     │                                        ▼
     │                             插值到 20 个 bin
     │                                        ▼
     │                          MMSE  w = conj(H)/(|H|²+0.1·median(|H|²))
     │                                        ▼
     │                          20 点 IDFT → 20 个复数抽头 taps
     │                                        │
     └────────────────────────────────────────┴──► 20 抽头零相位复数 FIR ──► y[0..255]
```

关键点：**CFO 只用于把 10 个块对齐后估信道，不作用在输出上**。
均衡器本身是时不变的，输入和输出都保留 CFO。

### 1.3 Python 参考（逐字）

```python
r = sum(blocks[:,1:,:] * conj(blocks[:,:-1,:]))          # 180 个复数积
f = angle(r) / (2*pi*20)                                 # 圈/采样
aligned = blocks * exp(-1j*2*pi*f*20*b)                   # b = 0..9
yb  = fft(aligned, axis=2)                               # 20 点 DFT
hk  = mean(yb[:,:,LSTF_K20], axis=1) / LSTF_S
h   = interp_to_20(hk)                                   # 线性插值 + 边缘保持
eps = 0.1 * median(abs(h)**2)
w   = conj(h) / (abs(h)**2 + eps)
taps= ifft(ifftshift(w))                                 # 20 点 IDFT
# 零相位 20 抽头 FIR，m=-10..9
for m in range(-10, 10):
    hm  = taps[m % 20]
    ind = arange(256) - m
    ext = where(ind < 0, 200 + ind, where(ind > 255, 0, ind))
    valid = (ind <= 255)
    out += hm * x[ext] * valid
```

门控：

```python
snr  = mean(|FFT20(block)|² over 12 pilot bins) / mean(|FFT20(block)|² over other 8 bins)
mask = snr >= 3.0          # False 时整段原样输出
```

---

## 2. 顶层接口

建议做成独立的 AXI-Stream 模块，输入输出都是 32 位复数打包：

```verilog
// {Q[15:0], I[15:0]}，每拍一个复数样本
module lstf_eq_top #(
    parameter int N        = 256,
    parameter int P        = 20,
    parameter int NPILOT   = 12,
    parameter int OUT_W    = 16,      // 输出 int16 Q10；内部累加见 7.3
    parameter bit BYPASS_B = 1'b1     // 门控失败时旁路
)(
    input  logic         clk,
    input  logic         rst_n,

    // 输入：每帧恰好 256 个样本，tlast 在第 256 个
    input  logic         s_axis_tvalid,
    output logic         s_axis_tready,
    input  logic [31:0]  s_axis_tdata,   // {Q[15:0], I[15:0]}
    input  logic         s_axis_tlast,

    // 输出：均衡后（或旁路原样）256 个样本
    output logic         m_axis_tvalid,
    input  logic         m_axis_tready,
    output logic [31:0]  m_axis_tdata,
    output logic         m_axis_tlast,
    output logic         m_axis_tuser,   // 1 = 门控失败，本帧旁路

    // 观测（可选，接 ILA）
    output logic [15:0]  stat_theta,     // Q2.13 rad
    output logic [15:0]  stat_snr_q8,    // 门控 SNR，Q8
    output logic         busy
);
```

输入约定：

| 项 | 值 |
|---|---|
| 数据 | I/Q 各 int16，`code = round(x * 1024)`（Q10） |
| 排布 | 连续 256 个复数，不交错字段 |
| 帧率 | 25 MSps / 256 ≈ **97,657 帧/秒**（10.24 µs 一帧） |
| 旁路 | 门控失败时输出原始 256 点，不能输出零、也不能丢帧 |

它是并行支路，不替换现有 PL 模型：

```text
IQ ──┬──► PL AI（raw IQ，现有 HLS，不动）
     └──► lstf_eq_top ──► per-sample norm ──► XF
```

输出是 **int16 Q10 的均衡 IQ**，与 `data_cache_20cls_lstfeq_rawonly_q10`
（XF 分支的训练/评估缓存）同一契约。**XF 的 per-sample norm 不在本模块里**：
512 个值（I、Q 合在一起）求一个 mean 和 std，`(x-mean)/(std+1e-6)`，
输出按通道优先 `[I×256, Q×256]`。这一步可以在 PS 侧做，也可以照同一公式加一级。

> 注意：不要把 `FPAI_PL` 那个 33 位 `dout` 流（token + logits）和这个模块混在一起。
> 这是独立的 IQ 预处理块，输入输出都是 32 位。

---

## 3. 五个硬件化简（核心）

### 3.1 CFO 不需要算出 f，甚至不需要 sin/cos 合成

由 `f = angle(r)/(2π·20)`，代入块对齐因子：

```text
exp(-j·2π·f·20·b) = exp(-j·angle(r)·b)
```

所以只需要 `r` 的相角 `θ = angle(r)`，第 `b` 块乘 `e^{-jθb}`。`f` 完全不出现在硬件里。

更进一步，`r` 不用先分块再算：

```text
r = Σ_{b=1..9} Σ_{n=0..19} x[20b+n]·conj(x[20(b-1)+n])
  = Σ_{n=20..199} x[n]·conj(x[n-20])
```

就是一个 **lag-20 自相关**。输入流式到达时，用一条 20 深延迟线，每来一个样本
`n>=20` 就累加一次，180 个复数 MAC 全部在加载阶段完成。

### 3.2 12→20 bin 的插值只有三种情况

Python 的 `_interp_to_20` 在整数 bin 上其实没有"两个导频之间的新 bin"——
20 点 DFT 的 bin 间隔就是 1，导频在 k=±1..±6 连续排列。真正的插值只有：

```text
k = -10,-9,-8,-7   → H[-6]                      # 边缘保持（4 个）
k = -6..-1, 1..6   → H[k]                       # 12 个导频，原值
k = 0              → (H[-1] + H[1]) / 2         # 唯一的插值（1 个）
k = 7,8,9          → H[6]                       # 边缘保持（3 个）
```

没有乘法，只有 mux 和一个 `(a+b)>>1`。

### 3.3 除以 `(1+j)·s` 是加减 + 移位

```text
1 / ((1+j)·s) = (1-j)·s / 2
```

对复数 `a+jb`：

```text
(a+jb)·(1-j)·s = s·[(a+b) + j(b-a)]
```

只要两个加法器、一个条件取反。再和"10 块平均"的 `1/10` 合并，正好是 `1/20`。

### 3.4 两个 1/20 可以完全抵消

这是最容易写错的地方，也是能省两次常量乘法的地方。

```text
H_raw = acc·(1-j)·s              # 不除 20
P_raw = |H_raw|² = 400·|H|²
eps_raw = 0.1·median(P_raw) = 400·eps
W_raw = conj(H_raw)/(P_raw+eps_raw) = W/20
taps_raw = Σ W_raw·e^{j2πkm/20}     = taps     # 因为 taps = (1/20)Σ W·e^{...}
```

**LS 的 1/20 和 IDFT 的 1/20 精确抵消**。硬件里两个都别做，只在最后对拍时知道
`H_raw = 20H`、`W_raw = W/20` 即可。注意正则项也是按平方缩放的，所以 MMSE 结构不变。

### 3.5 SNR 门限是能量比，不需要除法

Python 的 SNR 是"12 个导频 bin 的平均功率 / 8 个其余 bin 的平均功率"，
且先对 10 块求和再相除（不是每块比值再平均）：

```text
Sp = Σ_{b,k∈pilot} |X_b[k]|²
So = Σ_{b,k∉pilot} |X_b[k]|²
SNR = (Sp/(10·12)) / (So/(10·8)) = (2/3)·(Sp/So)
```

由 Parseval，20 点 DFT 全 bin 功率和 = `20 × Σ|x[n]|²`：

```text
Stot = Sp + So = 20·Σ_{n=0..199}|x[n]|²
SNR >= 3  ⇔  Sp/So >= 4.5  ⇔  11·Sp >= 9·Stot
```

所以门控只需要累加两个整数：导频 bin 功率 `Sp` 和时域能量 `Et = Σ|x|²`。
判据写成 **`11·Sp >= 180·Et`**（因为 `Stot = 20·Et`），无除法、无浮点。

> 门控功率可以用对齐后的 `X_b` 算：块对齐只是乘一个单位模的常数相位，
> `|X|` 不变，和 Python 用未对齐块算的结果一致。

---

## 4. 定点格式

| 信号 | 格式 | 位宽 | 说明 |
|---|---|---|---|
| 输入 I/Q | signed Q10 | 16 | `code = round(x*1024)` |
| 内部样本 | signed Q10 | 18 | 2 位保护位 |
| DFT 旋转因子 | signed Q15 | 16 | `cos/sin`，±32767 |
| DFT 乘积 | — | 34 | 18×16 |
| DFT 累加 | — | 40 | 20 项，留 6 位余量 |
| `X_b` | signed | 24~28 | 每块 DFT 后舍入，相对精度 <2⁻²³ |
| 块相位 `e^{-jθb}` | signed Q15 | 16×2 | 单位模 |
| `acc`（10 块相干累加） | signed | 40~44 | 10 项 |
| `H_raw` | signed | 28 | 只做 `(a+b)`、`(b-a)`、符号翻转 |
| `P_raw = |H|²` | unsigned | 56 | 28×28 |
| `eps_raw` | unsigned | 56 | `0.1·median(P_raw)` |
| `W_raw` | signed | 24×2 | 复数，1/(P+eps) 后 |
| `taps` | signed | 24×2 | 20 点 IDFT 后 |
| FIR 乘积 | — | 42 | 18×24 |
| FIR 累加 | — | 48 | 20 项 |
| 输出 | signed Q10 | 16 | 末级 48 位累加后 round/saturate，见 7.3 |

角度建议用 **Q2.13 rad**（范围 ±4，覆盖 ±π，分辨率 1.2e-4 rad），
CORDIC 直接在这个域工作。若想用"圈"为单位，把 CORDIC 的 arctan 表整体除以 `2π` 即可，
不要两套格式混用。

---

## 5. 模块划分与状态机

```text
lstf_eq_top
├── u_buf        : 双缓冲 256×32（或 2×256×32），ping-pong
├── u_cfo        : lag-20 相关 + 能量累加（加载阶段）
├── u_cordic     : atan2(r) → θ；rotation 模式生成 e^{-jθb}
├── u_dft12      : 12 导频 bin × 10 块，直接 DFT（20 项点积）
├── u_align_acc  : X_b[p]·e^{-jθb}，10 块累加
├── u_ls_interp  : (1-j)s 缩放 + 20 bin 插值
├── u_power      : |H[k]|²
├── u_reg        : median（或 mean）→ eps
├── u_recip      : 1/(P+eps)，LUT + Newton-Raphson
├── u_mmse       : conj(H)·recip
├── u_idft20     : 20 点 IDFT → taps
├── u_fir20      : 20 抽头零相位复数 FIR
└── u_gate       : 11·Sp >= 180·Et，决定 bypass
```

主状态机（单帧）：

```text
IDLE
 → LOAD        # 256 拍写入 buffer；同时做 lag-20 相关和 Et
 → CFO         # CORDIC atan2 + 生成 10 个块相位
 → DFT         # 10 块 × 12 bin（240 个 20 项点积）
 → ALIGN_ACC   # 乘块相位，累加到 acc[12]
 → LS_INTERP   # 缩放 + 插值 → H[20]
 → GATE        # 若失败 → BYPASS
 → MMSE        # 功率、eps、20 次倒数、W[20]
 → IDFT        # 400 个复数 MAC → taps[20]
 → FIR         # 256 输出，边算边出
 → BYPASS      # 原样流出 u_buf
 → IDLE
```

`LOAD` 与上一帧的 `DFT..FIR` 用 ping-pong 并行；如果输入是 DMA 整帧突发而不是
25 MSps 连续流，也可以单缓冲顺序做，代价是吞吐减半。

---

## 6. 逐级实现

### 6.1 加载：lag-20 相关 + 能量

```verilog
// n = 0..255，输入 x[n]
// 延迟线 dl[0..19]，dl[0] = x[n-20]
if (n >= 20 && n < 200) begin
    // r += x[n] * conj(x[n-20])
    r_re <= r_re + (x_i*dl_i + x_q*dl_q);
    r_im <= r_im + (x_q*dl_i - x_i*dl_q);
end
if (n < 200)
    Et <= Et + x_i*x_i + x_q*x_q;
```

- `r` 40~44 位，`Et` 40 位足够（200×(24000²+24000²) < 2³⁸）。
- 注意相关只覆盖 `n=20..199`，正好对应 Python 的 9 个相邻块对。
- `Et` 只累加前 200 点，不是 256 点。

### 6.2 CORDIC：atan2 与块相位

- `atan2`：把 `r_re/r_im` 按最大绝对值归一化到 18 位（角度与缩放无关），
  16~20 次迭代，输出 `θ`（Q2.13 rad）。
- 块相位 `e^{-jθb}`，b=0..9，两种做法：
  1. **迭代旋转**：先算 `p1 = e^{-jθ} = (cosθ, -sinθ)`，然后
     `p_b = p_{b-1}·p1`。9 次复数乘法，误差 ~10⁻⁴，够用。
  2. **每块 CORDIC rotation**：以 `z = -bθ` 跑 10 次，每次 16~20 拍。
     更准，不积累幅度漂移；总代价约 200 拍。
- **CORDIC 增益**：rotation 模式输出带 1.64676 的增益。所有块相位乘同一个增益，
  等价于 `acc`、`H` 乘一个公共常数；在 `W = conj(H)/(|H|²+eps)` 里会变成
  `W/增益`，最终输出一个公共缩放。per-sample norm 会消掉它，但**逐级对拍时必须补**。
  要么在 CORDIC 后乘 1/1.64676，要么在 golden 里显式记录这个公共因子。

### 6.3 12 导频 bin 的 DFT + 块对齐

按 `LSTF_K20` 的顺序算，顺序与 `LSTF_SIGN` 一一对应，后面不用再重排：

```text
for b in 0..9:
    for p in 0..11:
        X[b][p] = Σ_{n=0..19} x[20b+n] · e^{-j2π·LSTF_K20[p]·n/20}
    for p in 0..11:
        acc[p] += X[b][p] · e^{-jθb}
```

- 旋转因子表：`12×20` 个复数（`LSTF_K20[p]` 只有 12 个值，n 只有 20 个），
  16 位 Q15，约 7.7 kbit，一个 BRAM18 就够。**不要现场算 cos/sin**。
- 块对齐的 12 次复数乘法可以在每块 DFT 之后立刻做，也可以最后统一做；
  前者只需要存 `acc[12]`，不必存 `X[10][12]`。
- MAC 调度：20 项点积用 8 条复数 lane 是 3 拍（8+8+4），12 bin × 10 块 = 360 拍。
- 加法树/累加器要流水，否则 18×16 乘法 + 20 项累加会成为 4 ns 的关键路径。

导频顺序与符号（**照抄，别自己按 k 从小到大排**）：

| p | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| k | -6 | -5 | -4 | -3 | -2 | -1 | 1 | 2 | 3 | 4 | 5 | 6 |
| DFT bin | 14 | 15 | 16 | 17 | 18 | 19 | 1 | 2 | 3 | 4 | 5 | 6 |
| sign | +1 | -1 | +1 | -1 | -1 | +1 | -1 | -1 | +1 | +1 | +1 | +1 |

### 6.4 LS + 插值

```text
H_raw[p] = sign[p] · [ (acc_i[p]+acc_q[p]) + j·(acc_q[p]-acc_i[p]) ]
```

（没有除法；`H_raw = 20·H`，见 3.4。）

按 k=-10..9 生成 20 个 bin：

```text
H20[0..3]   = H_raw[p=0]     // k=-10..-7，保持 H[-6]
H20[4..9]   = H_raw[p=0..5]  // k=-6..-1
H20[10]     = (H_raw[p=5] + H_raw[p=6]) >> 1   // k=0
H20[11..16] = H_raw[p=6..11] // k=1..6
H20[17..19] = H_raw[p=11]    // k=7..9
```

注意 `H20` 的索引 j=0..19 对应 `k=j-10`，后面 IDFT 直接用这个顺序。

### 6.5 MMSE

```text
P[k] = H_i² + H_q²                       // 56 位
eps  = 0.1 · median(P[0..19])            // 或 mean，见下
W[k] = (H_i - j·H_q) / (P[k] + eps)
```

**中值 vs 均值**：Python 用的是 20 个 bin 的中值。硬件上精确中值要么用 20 输入
选择网络（约 100 个 24~32 位比较器），要么把 `P` 归一化成 `(6 位指数,16 位尾数)`
后排序。先建议用 **均值**（`sum(P)/20`）跑端到端对拍：eps 只影响深衰落 bin 的
正则强度，均值和中值通常只差一个常数因子；但这是假设，**必须用第 9 节的
XF top1 验证**。如果掉点超过 0.1，再上精确中值。

倒数（20 次）：

1. 找 `d = P+eps` 的最高有效位，规格化成 `m·2^e`，`m ∈ [1,2)`，Q17。
2. 用 256~512 项 LUT 取 `1/m` 初值（Q18）。
3. 1~2 次 Newton：`r ← r·(2 − m·r)`。1 次约 16 位，2 次约 24 位。
4. 右移 `e` 位恢复量级，饱和到 Q4.16（最大增益 16）。

- 20 个倒数可以串行算：约 20×8 = 160 拍，可接受。
- 也可以用 Xilinx 的 divider IP，但 20 次 × 20+ 拍会吃掉帧预算，不推荐。
- `0.1` 用常量乘：`eps = (median · 6554) >> 16`（6554/65536 ≈ 0.100006）。

### 6.6 20 点 IDFT → taps

```text
taps[m] = Σ_{j=0..19} W[j] · e^{+j2π(j-10)m/20}      // m=0..19，无 1/20
```

- 400 个复数 MAC，8 lane 约 50 拍。
- 旋转因子 400 项（j,m），16 位 Q15，约 12.8 kbit，一个 BRAM18。
  直接用 400 项表，别做 `(j-10)*m mod 20` 的取模运算。
- 顺序 `j=0..19 ↔ k=-10..9`，与 6.4 的 `H20` 一致。

### 6.7 20 抽头零相位复数 FIR

抽头映射（Python 的 `m % 20`）：

```text
m = -10..-1  → taps[10..19]
m =  0.. 9   → taps[0..9]
```

输出：

```text
y[n] = Σ_{m=-10..9} h[m] · x[d],   d = n - m
d < 0    → x[200+d]        // 只用 L-STF 尾部 191..199 循环补齐
0<=d<=255→ x[d]
d > 255  → 0               // 尾部补零，该项不累加
```

**窗口法实现**（推荐）：为输出 `n` 维护一个 20 深寄存器窗口
`W[j] = x[n-9+j]`（j=0..19），则：

```text
y[n] = Σ_{j=0..19} W[j] · taps[(29-j) % 20]
```

检查：j=0 ↔ m=9 → `taps[9]`；j=9 ↔ m=0 → `taps[0]`；j=10 ↔ m=-1 → `taps[19]`；
j=19 ↔ m=-10 → `taps[10]`。与 Python 一致。

- **预装载**：n=0 时窗口是 `[x191..x199, x0..x10]`，直接预装，之后每拍移入
  `x[n+11]`；`n>245` 时移入 0。
- 每输出一拍移位 + 3 拍 MAC（8 lane 做 20 个抽头），约 4 拍/输出，
  256 输出约 **1024 拍**。
- 如果不想移位，可以用 21 深寄存器堆 + 20 个读端口（fabric 里可综合，但面积大），
  不推荐。
- 注意：`d<0` 的循环是回到 **200+d（191..199）**，不是回到段尾 256。

### 6.8 门控与旁路

```text
Sp   = Σ |X_b[p]|²        // 12 个导频，10 块
Et   = Σ |x[n]|²          // 前 200 点
bypass = !(11*Sp >= 180*Et)
```

- 两个累加器都留够位宽（`11*Sp` 约 50 位，`180*Et` 约 46 位），用 56 位比较。
- 门控在 `DFT` 后就能定；失败时跳过 `MMSE/IDFT/FIR`，直接把 `u_buf` 里的原样数据
  流出去，`m_axis_tuser=1`。
- 旁路路径必须仍然输出 256 个样本、`tlast` 正确、时序和正常路径一致。
- Python 是 `snr >= 3.0`，所以硬件用 `>=`，不是 `>`。

---

## 7. 调度、吞吐与位宽细节

### 7.1 每帧拍数（200 MHz，帧周期 2048 拍）

| 阶段 | 复数 MAC 数 | 8 lane 拍数 | 备注 |
|---|---:|---:|---|
| 加载 + lag-20 + 能量 | 180 + 200 | 与加载并行 | 若 DMA 突发，180 拍 |
| CORDIC atan2 | — | 20~40 | 16~20 次迭代 |
| DFT 12×10 | 2400 | 360 | 20 项点积，3 拍/bin |
| 块对齐 | 120 | 15 | 可并入 DFT 尾 |
| LS/插值 | 0 | 10 | 只有加减和 mux |
| MMSE 功率+倒数+权重 | ~60 | 150~200 | 倒数是瓶颈 |
| IDFT 20 点 | 400 | 50 | |
| FIR | 5120 | 1024 | 4 拍/输出 |
| **合计** | ~8000 | **~1700** | 剩余 ~350 拍余量 |

- 200 MHz：1700 拍 = 8.5 µs < 10.24 µs，余量约 17%。
- 250 MHz（4 ns）：6.8 µs，余量约 34%。
- 12 lane：DFT 240 拍、FIR 768 拍，合计约 1400 拍 = 7.0 µs @200 MHz，更稳。
- 如果系统允许背压/离线处理，4 lane 也能做，但一帧会跨过帧周期，需要 ping-pong
  并在下游加 FIFO。

### 7.2 复数乘法用 3 乘还是 4 乘

```text
(a+jb)(c+jd) = (ac-bd) + j[(a+b)(c+d) - ac - bd]     // 3 个实乘
```

8 条复数 lane：3 乘 = **24 DSP**，4 乘 = **32 DSP**。
18×18 在 DSP48E1（25×18）上正好，注意寄存乘法器和加法树。

### 7.3 输出位宽与饱和

均衡器在深衰落处的增益可以大于 1：`|W| <= 1/(2√eps)`。
输入 absmax 是 Q10 的 24,101（原始 23.54），均衡后可能超过 int16。
**部署契约已经定为 int16 Q10**，所以末级必须饱和；但不能把中间级也截到 16 位。

**实测（rawonly 部署 split，`data_cache_20cls_lstfeq_rawonly`）**：

| split | 段数 | max abs | 饱和码值 |
|---|---:|---:|---:|
| train | 46,613 | 22.53 | 0 |
| val | 7,258 | 15.81 | 0 |
| test | 12,879 | 15.76 | 0 |

- **Q10 在部署 split 内零饱和**；全 cache 132,340 段里有 77 个越界码值，
  全部落在 split 之外（来自未使用的均衡样本）。
- 已实测：INT16/Q10 输入下 XF 五折 TTA **0.8220**（float 0.8221），
  与 PL 融合 **0.8333**（float 0.8332）。⇒ **输出直接给 16 位 Q10**。
- 内部仍按第 4 节的宽位宽走（DFT/IDFT/FIR 累加 40~48 位），只在最后一级
  round + saturate 到 int16；不要每个中间级都截 16 位。
- 量化的参考实现是 `np.rint(x*1024)`（round-half-to-even）。Verilog 用
  round-half-away 也可以，差 ±1 LSB 对下游无影响；如果要逐位对拍，就统一成
  round-half-to-even。
- 如果换数据集/换均衡参数，先重跑上面的统计再确认饱和策略。
- 公共缩放（包括 3.4 的 `1/20`、CORDIC 增益）会被 XF 的 per-sample norm 消掉，
  但**逐级对拍时不能忽略**。

---

## 8. 资源估算

| 资源 | 8 lane（3 乘） | 8 lane（4 乘） | 说明 |
|---|---:|---:|---|
| DSP48 | 24 | 32 | DFT/IDFT/FIR 共用 MAC 阵列 |
| LUT | 4~8k | 4~8k | 控制、地址、CORDIC、加法树 |
| FF | 6~10k | 6~10k | 流水线 |
| BRAM18 | 6~8 | 6~8 | 双缓冲 16 kbit + 两张旋转表 22 kbit |
| 中值网络（可选） | +3~5k LUT | +3~5k LUT | 均值方案不需要 |

参照现有 PL 设计的 317 DSP / 46,235 LUT / 60.5 BRAM tiles：
加 24~32 DSP 后约 341~349 DSP（85%~87%），LUT 约 50~54k。
**能放下，但 DSP 余量只剩 12%~15%，上板前必须做 OOC 综合看 WNS。**
如果只是为了演示，优先考虑 250 MHz + 8 lane，而不是堆 20 lane。

---

## 9. 验证

### 9.1 先做 golden 向量

用 Python 生成逐级中间量，而不是只比最终输出：

```python
import numpy as np
from scripts.make_pl_preproc_cache import lstf_equalize

c = np.load("data_cache_20cls_rawonly/segs.npy")[:128]   # complex64, (N,256)
# 先量化输入：Verilog 的输入就是 int16 Q10
xq = (np.rint(np.stack([c.real, c.imag], -1) * 1024)
      .clip(-32768, 32767).astype(np.int16))
c_q = (xq[..., 0] + 1j * xq[..., 1]) / 1024.0
y = lstf_equalize(c_q, reg=0.1)
yq = np.rint(np.stack([y.real, y.imag], -1) * 1024).clip(-32768, 32767).astype(np.int16)

# 逐级 dump：r, theta, X[b,p], acc[p], H_raw[20], P[20], eps, W[20], taps[20], yq
np.savez("tb/eq_golden.npz", x=xq, y=yq, theta=..., ...)
```

现成缓存 `data_cache_20cls_lstfeq_rawonly_q10` 的 `segs_int16.npy` 是
`np.rint(equalize(float_raw)*1024)`，可以用作 XF 侧参考；但**逐级对拍**要按上面的
流程从同一份 int16 输入重算 golden ——缓存是"先 float 均衡再量化"，硬件是
"先量化输入再均衡"，两者只差输入量化误差，但不能拿来当逐位基准。
Verilog testbench 和 Python 必须用**同一份 int16 输入**，否则误差分析没有意义。

### 9.2 分级容差

| 级 | 指标 | 目标 |
|---|---|---|
| `r` | 相对 RMS 误差 | < 1e-3 |
| `θ` | 绝对误差 | < 1e-3 rad |
| `X_b[p]` | 相对 RMS（按最大 bin 归一） | < 1e-3 |
| `H[20]` | 相对 RMS（按 max|H| 归一） | < 1e-3 |
| `taps` | 绝对误差 / max|tap| | < 1e-2 |
| `y` | RMSE | < 0.5 LSB（Q10） |
| 门控 | 决策一致率 | 100%（含临界样本） |

不要追求和 float64 逐位一致；追"误差预算内 + 下游不掉点"。

### 9.3 边界用例（必须显式测）

1. **门控旁路**：低 SNR 窗（实测约 5.5%），输出必须与输入逐样本一致。
   同时放一些 `snr≈3` 的临界样本，确认 `>=` 的方向。
2. **全零输入**：不能出 NaN、不能死锁；门控应失败并旁路。
3. **CFO 大**：构造块间相位差 ±π/4、±π/2，验证 CORDIC 和相位展开。
4. **深衰落**：让某个 bin 的 `|H|` 很小，验证 eps 限幅和输出不饱和/不爆。
5. **幅度极值**：输入接近 ±32767，检查中间累加不溢出。
6. **帧边界**：`n<9` 的窗口预装（191..199）和 `n>245` 的补零。
7. **旁路与正常帧交替**：tlast/tuser 和流水线不能错位。

### 9.4 端到端验收（唯一的硬证据）

Verilog 输出本来就是 int16 Q10，直接按 `data_cache_20cls_lstfeq_rawonly_q10`
的格式建一个新 cache（`segs_int16.npy` 写 Verilog 输出，split/meta 照抄），跑：

```bash
python scripts/collect_xf_folds_tta.py \
  --cache <verilog_eq_cache> --out outputs/diag/xf_verilog_tta.npz
python scripts/fuse_xf_pl.py \
  --xf-probs outputs/diag/xf_verilog_tta.npz \
  --pl-pool outputs/diag/pl_base_tta_pool.npz --w 0.3333
```

验收线（INT16 Q10 参考缓存 `data_cache_20cls_lstfeq_rawonly_q10`）：

- XF 五折 × 5 平移 TTA：参考 **0.8220**（float 是 0.8221），Verilog 掉点 **≤0.2 点**。
- 最终融合：参考 **0.8333**（float 是 0.8332），Verilog 后 **≥0.831**（仍要过 83）。
- 如果掉点超线，按顺序查：输出饱和 → taps 精度 → 门控误判 → eps 的均值/中值差异。

---

## 10. 坑清单

1. **不要把 CFO 从输出里去掉**。块对齐只用于估信道；输出仍含 CFO。
   单独去 CFO 会让 PL 模型从 0.72 掉到 0.40，XF 也会丢掉指纹。
2. **FIR 的负下标是 `200+d`**，回到 L-STF 尾部 191..199，不是段尾。
   `d>255` 才是补零。
3. **Python 的 `m % 20`**：`-10 % 20 = 10`，不是 `-10`。抽头映射见 6.7。
4. **门控是全段 10 块 × 12/8 bin 的比值**，不是每块 SNR 再平均。
   用 `11·Sp >= 180·Et`，不要写成 `Sp >= 9·Et`（差一个 20 倍）。
5. **导频顺序是 `LSTF_K20`**，不是 k 从 -6 到 6 的自然顺序。符号表见 6.3。
6. **两个 1/20 抵消**（3.4）。如果只省了一个，输出会差 20 倍。
7. **CORDIC 增益**要么补偿，要么把它当公共缩放并在对拍时还原。
8. **输出位宽**：部署 split 内 Q10 零饱和，末级直接输出 int16；
   但中间级要保留 40~48 位，不能提前截断。换数据集先重测。
9. **旁路路径**要输出原始 256 点，不能输出零、不能少拍。
10. **中值换均值是近似**，必须用 9.4 验证；不要默认它等价。
11. **不要给这个模块加窗**。算法没有窗，加 Hann/Blackman 是另一条已经测死的轴。
12. **不要把均衡输出接给 PL 的 AI 模型**。PL 模型吃 raw IQ，实测均衡为零收益。

---

## 11. 上板顺序

1. Python golden + 量化输入，`xsim` 逐级对拍（先只跑 `LOAD/CFO`）。
2. 接 `DFT/ALIGN`，对 `X_b` 和 `acc`。
3. 接 `MMSE/IDFT`，对 `taps`；这一步最容易暴露符号/顺序错。
4. 接 `FIR`，对 `y`；先跑 9.3 的 7 个边界用例。
5. 用 ILA 抓一帧的 `theta / Sp / Et / bypass / taps`，和 Python 同一段比。
6. 跑 9.4 的端到端；过线再谈时序收敛和资源。
7. OOC 综合看 WNS，确认加进现有 HLS 设计后 4 ns 仍能过。

---

## 12. 一句话总结

这个均衡器的硬件实现难点不在算法，而在**别把它直译成 float**：
lag-20 相关代替分块 CFO，`θ` 代替 `f`，能量比代替 SNR 除法，
加减代替复数除法，两个 `1/20` 抵消，插值退化成 mux。
做完这五步，剩下的就是一张 12×20 的旋转表、一张 20×20 的 IDFT 表、
8 条复数 MAC 和一个 20 抽头 FIR。
