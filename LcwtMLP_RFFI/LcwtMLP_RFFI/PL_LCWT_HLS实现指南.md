# PL 侧 WaveMLP + LCWT 的 HLS 实现指南

> **权限约束：只读，不写。先读这一条。**
>
> HLS 实现对本工作区 `d:\FPGA\FPGA\Transformer_Train\` **只有读权限，没有写权限**。
> 下文列出的文件只用于读算法、读数据契约、读金标准；**不得修改、移动、删除或回写**。
> 新代码、综合工程、报告一律放在独立目录（如 `d:\FPGA\FPGA\PL_LCWT_HLS\`），
> 等方案批准后再单独评审接入。
>
> 同理，`D:\FPGA\FPGA\FPAI_PL\` 也只读，不得写入。

> 目标模型：`configs/compress/tx20_cmp_p16_d38_j4k16_q10.yaml`
> （P=S=16，D=38，16 token，LCWT J=4/K=16，1 个残差 MLP 块，20 类，INT16/Q10 输入）。
>
> 部署权重：`checkpoints/tx20_cmp_p16_d38_j4k16_q10/best.pt`（epoch 84，val 0.6479）。
> 精度口径：`data_cache_20cls_q10` test top1 **0.7034**（fp32 基线 **0.7067**，
> 差 −0.34 点，cell 聚类 bootstrap CI [−1.29, +0.66] 含 0 ⇒ 无显著损失）。
> 权重本身仍是 float，QAT/PTQ 尚未做。

---

## 参考文件（本工作区绝对路径，全部只读）

HLS 只需要读这些文件。路径固定为绝对路径，不依赖当前目录。

| 绝对路径 | 内容 / 用途 |
| --- | --- |
| `d:\FPGA\FPGA\Transformer_Train\src\models\lcwt.py` | **LCWT 的唯一真相**：gaussian 初始化、circular pad（左 K/2−1、右 K/2）、stride 2、分析/合成符号、`shift`。HLS 位精确实现以它为准 |
| `d:\FPGA\FPGA\Transformer_Train\src\models\wavemlp.py` | WaveMLP 拓扑：patch embedding、`ResidualMLPBlock`（LN→fc1→GELU→fc2→残差）、GAP、Linear head；含 `extra_macs` 口径 |
| `d:\FPGA\FPGA\Transformer_Train\src\models\factory.py` | 配置字段 → 模型的构建逻辑（确认 shape/参数名） |
| `d:\FPGA\FPGA\Transformer_Train\src\data\dataset.py` | 数据布局与归一化口径（本模型 `normalize: none`，直接吃缓存） |
| `d:\FPGA\FPGA\Transformer_Train\configs\compress\tx20_cmp_p16_d38_j4k16_q10.yaml` | **部署配置**（INT16 输入，与基线只差 `cache_dir`） |
| `d:\FPGA\FPGA\Transformer_Train\configs\compress\tx20_cmp_p16_d38_j4k16.yaml` | fp32 基线配置（对照 / QAT 起点） |
| `d:\FPGA\FPGA\Transformer_Train\checkpoints\tx20_cmp_p16_d38_j4k16\best.pt` | fp32 基线权重（epoch 84，test 0.7067） |
| `d:\FPGA\FPGA\Transformer_Train\checkpoints\tx20_cmp_p16_d38_j4k16_q10\best.pt` | INT16 输入模型的权重（训练完成后作为部署权重） |
| `d:\FPGA\FPGA\Transformer_Train\data_cache_20cls_q10\segs_int16.npy` | `(N,256,2)` int16 码，**HLS golden 输入直接读它** |
| `d:\FPGA\FPGA\Transformer_Train\data_cache_20cls_q10\segs.npy` | 同一数据的 float32 视图（= `code/1024`），供 PyTorch 对拍 |
| `d:\FPGA\FPGA\Transformer_Train\data_cache_20cls_q10\split.npz` | train/val/test 索引；复现 0.7067 必须用同一 test 集 |
| `d:\FPGA\FPGA\Transformer_Train\data_cache_20cls_q10\meta.npz` | 标签、cell/采集日，用于 cell 聚类置信区间 |
| `d:\FPGA\FPGA\Transformer_Train\data_cache_20cls_q10\int16.json` | 量化契约实测值：Q10、scale、absmax、clipping 计数 |
| `d:\FPGA\FPGA\Transformer_Train\scripts\make_int16_cache.py` | 生成 int16 码的映射公式（`code = round(x·1024)`） |
| `d:\FPGA\FPGA\Transformer_Train\scripts\eval_pl_arm.py` | 评估口径（overall / raw / eq 子集） |
| `d:\FPGA\FPGA\Transformer_Train\docs\PL_LCWT_HLS实现指南.md` | 本文件 |

---

## 0. 先看结论

| 项 | 数值 |
| --- | --- |
| 参数量 | **5,586**（LCWT 512 / patch 1,254 / MLP 3,040 / head 780） |
| MAC/帧（解析口径，与既有预算表一致） | **158,584** |
| ├ LCWT（分析+合成） | 92,160 |
| ├ patch embedding | 19,456 |
| ├ 残差 MLP（fc1+fc2） | 46,208 |
| └ GAP + head | 760 |
| **HLS 实际 MAC**（合成端跳过插零乘法） | **127,864**（LCWT 61,440） |
| 现有 PL CNN 的预算 | 158,206 MAC（几乎相同） |
| 现有 IP 实测 | 2,593 拍/帧 ≈ 12.97 µs @200 MHz |

三句话：

1. **这不是给现有 `RFFI_FFT_ConvNet` 加一个模块，而是换一个模型。** 现有 CNN 吃的是
   `FFT → |X|²` 的 255 点功率谱；WaveMLP 吃的是 LCWT 重建后的时域 I/Q。两者不能拼。
2. **最重的不是 MLP，是 LCWT。** 按解析口径 LCWT 占 58% 的 MAC（HLS 跳过合成端的
   插零乘法后仍占 48%），而且是复数 FIR；先做 LCWT 的微基准，它决定整个方案能不能落。
3. **精度目前是 fp32。** 还没有做过 QAT/PTQ。HLS 之前必须先有定点金标准，否则
   综合出来的是"能跑"而不是"能验收"。

---

## 1. 目标模型拓扑（逐层、逐形状）

输入 `x: (2, 256)`，通道 0/1 = I/Q，float（训练时 `normalize: none`）。

```
x (2,256)
 └─ LCWT(level=4, K=16, complex, gaussian init)      -> (2,256)
     └─ patch_embed: Conv1d(2→38, k=16, s=16, no pad) -> (38,16)
         └─ transpose                                     -> (16,38)
             └─ ResidualMLPBlock(D=38, r=1)              -> (16,38)
                 z = z + W2 · GELU(W1 · LN(z))
                 └─ GAP(mean over 16 tokens)             -> (38,)
                     └─ Linear(38→20)                     -> (20,)
```

已从 checkpoint 核实：

| 项 | 值 | 为什么重要 |
| --- | --- | --- |
| `lcwt.analysis` | `(4,2,2,16)`，512 个数里占 256 | `[level, band(lo/hi), re/im, K]` |
| `lcwt.synthesis` | `(4,2,2,16)`，256 | 同一布局 |
| `lcwt.shift` | **0** | gaussian 初始化不做完美重构标定；不是可学习参数 |
| `|imag|/|real|`（分析） | 0.857 | **不能把复数卷积退化成实数滤波** |
| `|imag|/|real|`（合成） | 1.102 | 同上 |
| LCWT 权重 absmax | 1.312 | 权重位宽与定点步长 |
| `patch_embed.weight` | `(38,2,16)`，absmax 1.402 | PyTorch 是**相关**，不翻核 |
| `blocks.0.norm` | weight 0.90~3.17，bias ±0.70 | LayerNorm，不能折进权重 |
| `fc1/fc2` | `(38,38)`，absmax 1.66 | — |
| `head` | `(20,38)`，absmax 2.22 | — |

---

## 2. 接口契约（沿用现有 IP 的板端接法）

### 2.1 输入

沿用 `RFFI_FFT_ConvNet` 的 **33 位 FIFO 读侧**，板端不用改连线：

| 位 | 含义 |
| --- | --- |
| `[15:0]` | I，INT16 |
| `[31:16]` | Q，INT16 |
| `[32]` | `last`，帧边界（第 256 拍） |

一次调用收 **8 帧 = 2048 拍**（与现有 IP 一致，便于复用 PS 侧驱动）。
若第一批只想跑 1 帧/调用，把 `FRAMES_PER_CALL` 改成 1 即可，接口位宽不变。

> **输入契约（已定，2026-10-19）：I/Q 各为 INT16，Q10 定标。**
> 码值与训练值的关系是 `code = round(x * 1024)`，饱和到 `[-32768, 32767]`；
> 训练缓存 `data_cache_20cls_q10` 就是按这条映射生成的（全量 absmax 23.54
> ⇒ 最大码 24,101，**零饱和**；量化步长 9.8e-4）。
> 模型在 `configs/compress/tx20_cmp_p16_d38_j4k16_q10.yaml` 上训练，
> 因此训练输入与 FIFO 码逐位同域，不再依赖"上板再标定"。
>
> ⚠️ 仍要单独核对的是 **ADC 原始码 → Q10 码**这一段：如果接收链路输出的
> 码值量纲与 WiSig 浮点值不同，必须在前端乘一个固定的 2 的幂做对齐。
> 这条用一个可回读的 AXI-Lite 寄存器配置，不要写死在 HLS 里。

### 2.2 输出

| 端口 | 格式 | 说明 |
| --- | --- | --- |
| `logits_V_*` | `ap_memory`，`INT16[8][20]` | `addr = f*20 + c`，单口写 |
| （可选）`tok_V_*` | `INT16[8][16][38]` | 调试/融合用，可以第一版不做 |

**softmax 不在 PL**：和现有 IP 的契约一致，PS 侧拿 `logits / SCALE_LOGIT` 再做 softmax。
本模型没有 BN，logits 的定标由导出侧算好，**不要硬编码**。

---

## 3. 逐位算法规格（照着抄，别自己推）

### 3.1 LCWT 分析：一层

数学上就是 `F.conv1d`，**stride=2，无内置 padding，周期边界**。
对 K=16、N=256：

* `offset = K/2 = 8`
* 左补 `K-1-offset = 7`，右补 `offset = 8`（周期补）
* 输入补后第 `j` 个点 = `x[(j-7) mod N]`
* 输出 `t ∈ [0, N/2)` 用到补后 `j = 2t .. 2t+15`，即原信号下标

```
idx(t,k) = (2*t + k - 7) & (N-1)        // N=256 是 2 的幂
```

四个输出通道（低通 re/im、高通 re/im），复数乘法展开：

```cpp
// a[band][0] = 实部, a[band][1] = 虚部, band: 0=lo, 1=hi
lo_re[t] = Σ_k  ar_lo[k]*xr[idx] - ai_lo[k]*xi[idx];
lo_im[t] = Σ_k  ai_lo[k]*xr[idx] + ar_lo[k]*xi[idx];
hi_re[t] = Σ_k  ar_hi[k]*xr[idx] - ai_hi[k]*xi[idx];
hi_im[t] = Σ_k  ai_hi[k]*xr[idx] + ar_hi[k]*xi[idx];
```

**只有低通（lo）进入下一层；高通（hi）存起来给合成。**
长度为 256 → 128 → 64 → 32 → 16；四层高通共 128+64+32+16 = 240 个复数点。

### 3.2 LCWT 合成：一层

**这一层和分析的符号、翻核方向都不一样，是最容易写错的地方。** 直接照
`src/models/lcwt.py::_synthesis_level` 抄：

1. 上采样：长度为 `N` 的低通 + 同层高通，插零到 `2N`（偶数位置有值，奇数位置 0）。
2. 左补 `K-1 = 15`，右补 0，周期长度 `2N`。
3. 卷积核**沿 k 翻转**（PyTorch 的 `conv1d` 是相关，代码里显式 `.flip(-1)` 把它变成卷积）。
4. 输出加和，再 `torch.roll(y, shift)`；**本模型 shift=0**。

实数展开（`s[band][0]=实部, s[band][1]=虚部`）：

```cpp
// 输出 t ∈ [0, 2N)
// 插零后只有 (t+k-15) 为偶数的 k 有贡献 ⇒ 每点只有 K/2=8 个非零抽头
k0 = (1 - t) & 1;                     // t 偶 -> k0=1；t 奇 -> k0=0
for (int k = k0; k < K; k += 2) {
    int j   = t + k - (K-1);          // 偶数
    int n   = j / 2;                  // 负数除法对偶数也是精确的
    n = (n % N + N) % N;
    int kk  = K-1-k;                  // 翻核后的权重下标
    int lo_r = lo_re[n], lo_i = lo_im[n];
    int hi_r = hi_re[n], hi_i = hi_im[n];
    acc_re += s[0][0][kk]*lo_r - s[0][1][kk]*lo_i
            + s[1][0][kk]*hi_r - s[1][1][kk]*hi_i;
    acc_im += s[0][1][kk]*lo_r + s[0][0][kk]*lo_i
            + s[1][1][kk]*hi_r + s[1][0][kk]*hi_i;
}
```

注意和分析相比：**合成端虚部是 `+`（`si*lo_r + sr*lo_i`），分析端是 `-`。**
不要为了"复用代码"把两者统一，那是静默掉点。

### 3.3 patch embedding

PyTorch `Conv1d(2, 38, k=16, stride=16, padding=0)`，**相关，不翻核**：

```
token[j][d] = bias[d] + Σ_{c=0,1} Σ_{k=0..15} w[d][c][k] * lcwt_out[c][16*j + k]
j = 0..15, d = 0..37
```

16 个 token、无重叠。

### 3.4 LayerNorm（逐 token，D=38）

PyTorch `nn.LayerNorm(38)`，**biased variance**，`eps=1e-5`：

```
mu  = (1/38) Σ_i z[i]
var = (1/38) Σ_i (z[i]-mu)^2
y[i] = (z[i]-mu) * rsqrt(var + 1e-5) * gamma[i] + beta[i]
```

不要把 LN 折进 fc1：`var` 依赖当前样本。16 个 token × 38 维，计算量很小，但
`rsqrt` 是唯一的新原语 —— 用 `hls::rsqrt` 或 256 项 LUT，**不要引入浮点**。

### 3.5 MLP 与分类头

```
h[d] = b1[d] + Σ_i W1[d][i] * ln[i]        // 38→38
g[d] = GELU(h[d])                           // 精确 erf 版，approximate='none'
o[d] = b2[d] + Σ_i W2[d][i] * g[i]          // 38→38
z[d] = z0[d] + o[d]                         // 残差
feat[i] = (1/16) Σ_t z[t][i]                // GAP
logit[c] = bh[c] + Σ_i Wh[c][i] * feat[i]   // 38→20
```

GELU 用 LUT（见 §4.4），不要用 `erff()`。

---

## 4. 定点方案

### 4.1 实测动态范围（3,000 条 test 随机抽样，raw+eq 混合；absmax / p99.99）

| 张量 | absmax | p99.99 | 建议 Q | 建议 scale |
| --- | --- | --- | --- | --- |
| 输入 I/Q | 23.54（全量） | 5.57 | **Q10** | **1024** |
| L1 lo | 11.8 | 6.2 | Q5 | 32 |
| L1 hi | 17.3 | 10.9 | Q5 | 32 |
| L2 lo | 20.0 | 9.4 | Q5 | 32 |
| L2 hi | 39.1 | 14.9 | Q4 | 16 |
| L3 lo | 23.0 | 11.8 | Q4 | 16 |
| L3 hi | 54.3 | 31.4 | Q4 | 16 |
| L4 lo | 23.3 | 15.6 | Q4 | 16 |
| L4 hi | 24.8 | 14.6 | Q4 | 16 |
| S4 out | 45.2 | 25.8 | Q4 | 16 |
| S3 out | 171.4 | 72.4 | Q3 | 8 |
| S2 out | 149.2 | 77.7 | Q3 | 8 |
| S1 out（LCWT 输出） | 247.9 | 100.7 | Q3 | 8 |
| patch token | **900.4** | 246.5 | **Q2** | **4** |
| LN out | 10.4 | 8.0 | Q10 | 1024 |
| fc1 pre-GELU | 47.9 | 39.5 | Q8 | 256 |
| GELU out | 25.4 | 21.4 | Q8 | 256 |
| fc2 out | 41.7 | 29.7 | Q8 | 256 |
| GAP | 20.3 | 11.5 | Q10 | 1024 |
| logits | 86.6 | 75.4 | Q8 | 256 |

两条判读：

1. **patch token 必须是 INT16。** absmax 900，INT8 会直接削掉；这也是本模型与
   现有 CNN 的一个硬差别（现有 `tok` 是 INT8）。
2. **LCWT 输出 p99.99 已经到 100**，越靠合成末级动态范围越大。逐级用不同的
   2 的幂缩放（block floating），不要全链一套 Q。

> 上表只是 3,000 条的抽样。**导出前必须在完整 calibration 集（建议 ≥ 20,000 条，
> 覆盖全部采集单元）上重算**，取 `16384 / absmax` 向下取 2 的幂作为 scale，留 2×
> 余量。任何一级溢出都会让后续全错，且不会报错。

### 4.2 位宽

| 对象 | 位宽 | 理由 |
| --- | --- | --- |
| 输入 I/Q | INT16 | 与现有 FIFO 一致 |
| LCWT 激活 | INT16 | p99.99 到 100，INT8 太粗 |
| LCWT 权重 | **INT16** | 只有 512 个，先不引入权重量化误差 |
| patch/MLP 权重 | INT8（第一版也可 INT16） | absmax ≤2.22，INT8 步长 0.017 |
| patch token | INT16 | absmax 900 |
| 累加器 | INT32 | 最大 fan-in 128（LCWT 分析），16-bit × 16-bit × 128 < 2^31 |
| logits | INT16 | softmax 在 PS |

第一版建议**权重全部 INT16**（总共 11 KB，BRAM 无压力），先把激活定点跑通；
等精度验收通过，再把 MLP/patch 权重降到 INT8 去省 DSP。

### 4.3 重量化

每一级输出都要从 `Q_in·Q_w` 的累加域回到下一级 Q：

```cpp
static inline ap_int<16> requant(ap_int<32> acc, ap_int<32> M, int S) {
#pragma HLS INLINE
    ap_int<64> t = (ap_int<64>)acc * (ap_int<64>)M;
    // 必须保证算术右移：t 可能是负数
    return (ap_int<16>)(t >> S);
}
```

> ⚠️ C++ 对负数 `>>` 在 C++20 前是实现定义行为。用 `ap_int<64>` 做乘加后显式
> 算术右移，并在 C/RTL 协同仿真里逐位对；这条坑在现有工程里已经踩过一次。

### 4.4 GELU LUT

精确 GELU：`0.5x(1+erf(x/√2))`。定点实现：

* 输入 clamp 到 `[-8, 8]`：`x > 8` 时 GELU(x) 与 x 的差 < 1e-15；`x < -8` 时 < 1e-15。
* 1024 项表，步长 `1/64`，线性插值。
* 表值用与输出相同的 Q8（scale 256），表占 2 KB。

验收：在完整 test 集上，LUT GELU 与浮点 GELU 的最终 argmax 一致率 ≥ 99.9%；
不一致的样本要人工看，不能只看平均误差。

### 4.5 INT16 输入契约（已定）

```
code  = sat_int16( round(x_model * 1024) )      // PL 收到的 I/Q 码
x_q   = code / 1024                              // 训练缓存里的值
```

* scale 选 **Q10** 的依据：`data_cache_20cls` 全量 absmax = 23.54，
  `23.54 × 1024 = 24,101 < 32,767` ⇒ Q10 是**不饱和的最大 2 的幂**；
  Q11 会把波峰切掉。
* 实测量化误差 `max|x_q - x| = 4.88e-4`，输入 std ≈ 0.5 ⇒ 约 500 级/σ。
* 训练用 `data_cache_20cls_q10`（`scripts/make_int16_cache.py --q 10`），
  其中 `segs_int16.npy` 就是 PL 要吃的码，golden 导出直接用它。

**剩下唯一要对的是 ADC 原始码到 Q10 码的映射。** 如果接收链路输出的量纲
与 `segs.npy` 不同：

1. 用同一物理帧对齐一段 PL 抓的码和 `segs.npy` 的浮点值；
2. 线性回归求 `x_model = adc_code / 2^k` 的 `k`；
3. 前端乘 `2^(10-k)` 得到 Q10 码，`k` 用 AXI-Lite 寄存器可配，**不写死**。

> 本模型 `normalize: none`，但第一层 LN 在后段会吸收整体尺度；真正受影响的是
> **量化步长与饱和**，不是整体倍数。因此：宁可选择不饱和的 Q10，也不要用
> "看起来更精细但会切波峰"的 Q11。

---

## 5. HLS 微架构

### 5.1 数据流

```
s_axis_iq (33b)
   │  1 帧 = 256 个复样本
   ▼
┌──────────── 帧缓存 (2×256 INT16) ────────────┐
│                                             │
│  ANALYSIS L1 → L2 → L3 → L4                 │  低通链 256→128→64→32→16
│      │        │      │      │               │  高通存 240 个复点
│      ▼        ▼      ▼      ▼               │
│  SYNTH  S4 → S3 → S2 → S1                   │  16→32→64→128→256
│                                             │
└──────────────────┬──────────────────────────┘
                   ▼
          patch_embed (16 token × 38)
                   ▼
          LN → fc1 → GELU → fc2 → +residual
                   ▼
          GAP → head(38→20) → logits BRAM
```

建议第一版**不做 `DATAFLOW` 全流水**：LCWT 的层间依赖是硬串行，MLP 只有 16 个
token，全流水的收益小于调 FIFO 深度的成本。先按顺序状态机把拍数做对，再按需重叠。

### 5.2 并行度与拍数

分析每输出点：4 个输出通道 × 2 个输入通道 × K=16 = **128 MAC**。
合成每输出点（利用插零）：2 × 4 × K/2 = **64 MAC**。

| 阶段 | 位置数 | MAC | 64 MAC/clk | 128 MAC/clk |
| --- | --- | --- | --- | --- |
| 分析 L1..L4 | 128+64+32+16=240 | 30,720 | 480 clk | 240 clk |
| 合成 S4..S1（跳零） | 32+64+128+256=480 | 30,720 | 480 clk | 240 clk |
| patch embed | 16×38 | 19,456 | 304 clk | 152 clk |
| LN | 16×38 | ~2,500 | ~40 clk | ~20 clk |
| fc1 + GELU | 16 | 23,104+608 | 371 clk | 186 clk |
| fc2 | 16 | 23,104 | 361 clk | 181 clk |
| GAP + head | — | 760 | 12 clk | 6 clk |
| **合计** | | **≈127,900** | **≈2,050 clk ≈10.2 µs** | **≈1,030 clk ≈5.1 µs** |

> 64 MAC/clk 的档位比现有 IP（12.97 µs、2,593 拍）还快一点，DSP 需求只有
> 64~80 个，**余量最大**。128 MAC/clk 档约 5.1 µs。
>
> 若要追 NPU 满速的 **4.33 µs = 866 拍**，按 127,864 MAC 只需持续
> **≥148 MAC/clk**（约 150 个 DSP），比解析口径的 183 更宽松。
> **第一版仍建议 64 MAC/clk**：先把"能跑 + 精度对"做实，再决定要不要压。

### 5.3 存储

| 缓冲 | 大小 | 类型 |
| --- | --- | --- |
| 输入帧 | 256×2×INT16 = 1 KB | BRAM（双缓冲 2 KB） |
| 分析低通链 | 256→128→64→32→16，各 2 通道 | 复用同一块，约 1.5 KB |
| 4 层高通 | 240×2×INT16 = 960 B | BRAM |
| LCWT 权重 | 512×INT16 = 1 KB | ROM |
| patch/MLP 权重 | ~5,074×INT16 ≈ 10 KB | ROM/BRAM |
| token/激活 | 16×38×INT16 ≈ 1.2 KB | BRAM |
| GELU LUT | 1024×INT16 = 2 KB | ROM |

总计 < 20 KB。**BRAM 不是瓶颈，DSP 和时序才是。**

### 5.4 分析层参考代码

```cpp
// src/pl_lcwt/lcwt_analysis.hpp  （新目录，不放进 FPAI_PL）
template <int N, int K>
void analysis_level(
    const ap_int<16> xr[N], const ap_int<16> xi[N],
    const ap_int<16> ar[2][K], const ap_int<16> ai[2][K],   // [band][tap]
    ap_int<16> lo_re[N/2], ap_int<16> lo_im[N/2],
    ap_int<16> hi_re[N/2], ap_int<16> hi_im[N/2])
{
    for (int t = 0; t < N/2; ++t) {
#pragma HLS PIPELINE II=1
        ap_int<32> acc[4] = {0, 0, 0, 0};
        for (int k = 0; k < K; ++k) {
#pragma HLS UNROLL
            int idx = (2*t + k - (K/2 - 1)) & (N - 1);
            ap_int<16> xrv = xr[idx], xiv = xi[idx];
            for (int b = 0; b < 2; ++b) {
#pragma HLS UNROLL
                acc[2*b+0] += ar[b][k]*xrv - ai[b][k]*xiv;
                acc[2*b+1] += ai[b][k]*xrv + ar[b][k]*xiv;
            }
        }
        lo_re[t] = requant(acc[0], M_LO, S_LO);
        lo_im[t] = requant(acc[1], M_LO, S_LO);
        hi_re[t] = requant(acc[2], M_HI, S_HI);
        hi_im[t] = requant(acc[3], M_HI, S_HI);
    }
}
```

`II=1` + K 全展开 ⇒ 每拍 128 个乘法。若 DSP 超预算（见 §8 的 1.6~1.8× 低估），
把 K 展开因子降到 8，`II=2`，拍数翻倍、DSP 减半。

---

## 6. 权重导出

### 6.1 必须导出的 state_dict

| key | shape | HLS 用途 |
| --- | --- | --- |
| `lcwt.analysis` | `(4,2,2,16)` | 4 层分析核 |
| `lcwt.synthesis` | `(4,2,2,16)` | 4 层合成核 |
| `lcwt.shift` | 标量（=0） | 编译期常量；从 ckpt 读，不要猜 |
| `patch_embed.weight/bias` | `(38,2,16)` / `(38)` | patch 卷积 |
| `blocks.0.norm.weight/bias` | `(38)` | LN |
| `blocks.0.fc1.weight/bias` | `(38,38)` / `(38)` | — |
| `blocks.0.fc2.weight/bias` | `(38,38)` / `(38)` | — |
| `head.weight/bias` | `(20,38)` / `(20)` | — |

### 6.2 导出脚本要求

放在 `scripts/export_pl_lcwt_hls.py`（新文件），输出：

```
pl_lcwt_weights.hpp
  - LCWT_A[4][2][2][16]   int16
  - LCWT_S[4][2][2][16]   int16
  - LCWT_SHIFT            0
  - PATCH_W[38][2][16], PATCH_B[38]
  - NORM_W[38], NORM_B[38]
  - FC1_W[38][38], FC1_B[38], FC2_W..., FC2_B...
  - HEAD_W[20][38], HEAD_B[20]
  - 每级的 (M, S) 重量化参数、输入 scale、logits scale
```

导出时必须做三件事：

1. **逐数组打印哈希**（现有工程用 `hash 78f88b6a` 同一套做法），HLS 侧编译后
   回读核对，防止拿到旧权重。
2. **用真权重而不是周期性桩权重**跑第一次 csynth —— 桩权重会让 HLS 压缩 ROM，
   BRAM 数字偏小（现有工程实测 10.5 → 121 tiles）。
3. **翻转核对**：分析核按 k 顺序直接落；合成核在 C++ 里已经显式 `K-1-k`，
   导出时**不要再翻一次**。写一个 1 层、K=16 的 C 微测试，与 PyTorch 的
   `_analysis_level`/`_synthesis_level` 逐位比对后再继续。

---

## 7. 验证方案

### 7.1 三级

| 级别 | 做什么 | 判据 |
| --- | --- | --- |
| L1 Python 定点模拟 | 用 numpy 整数算子复刻 §3/§4，和 PyTorch 浮点比 | test top1 掉 ≤ 0.5 点；argmax 一致率 ≥ 99% |
| L2 C 仿真 | 同一批 golden 输入，C 模型 vs Python 定点 | **逐位一致**（每个中间数组） |
| L3 协同仿真 | RTL vs C | 逐位一致 |
| L4 决策级 | 定点 logits 在完整 test 上评估 | 与 fp32 0.7067 的差 ≤ 0.5 点，聚类 bootstrap CI 不跨 0 |

### 7.2 逐级 golden

抽 ≥1,000 条 test 样本（覆盖全部 14 个 raw 采集单元；部署口径是 raw），落盘：

```
x_in[2][256] INT16        (含 ADC 定标)
lo/hi[level]              每层分析与合成输出
lcwt_out[2][256]
patch_tok[38][16]
ln_out / fc1_pre / gelu_out / fc2_out / block_out
gap[38] / logits[20]
```

逐级比对的理由和现有指南相同：端到端对了但中间错，说明两个错误互相抵消；
逐级能把定位时间从一周压到一小时。

### 7.3 必须专门测的边界

* 低幅度窗：本次抽样里输入 absmax 只有 8.8（std 0.43），而全量到 ±30。
  两种幅度都要覆盖；**M0 的 calibration 必须按 absmax 取，不能用随机抽样的
  局部最大值**。
* INT16 量化：同一批样本，`x_q = round(x*1024)/1024` 与浮点输入的
  argmax 一致率应 ≥ 99.5%；不一致的样本单独看是不是低幅度窗。
* 饱和：人为把输入放大到超过 ±32，确认 C 模型与 `sat_int16` 的行为一致；
  真实数据不该触发饱和（全量 absmax 23.54）。
* 低幅度窗与全量波峰窗都要有 —— 量化误差对前者的影响更大。
* 门控不需要：本模型没有 L-STF 门控，**不要**把均衡 cache 的处理混进来。

---

## 8. HLS 2018.3 已知坑（都是本工程踩过的）

1. `#pragma HLS ... type=` 不能写，会编译错。
2. `ap_fifo` 写在 `hls::stream` 上是硬编译错 —— 默认就是 `ap_fifo`，**别写**。
3. `vivado_hls` **退出码恒 0**：必须 grep 日志里的 `ERROR` 才判成败。
4. `csynth` 不会清 `syn/`、`report/`；改代码前用 `open_project -reset`。
5. `ARRAY_PARTITION` 治不了"同一行内的并行读"；需要改数据布局或复制寄存器。
6. **csynth 的 DSP 数对卷积层不可信**（低估 1.6~1.8×）；只有 OOC 综合给真数字和
   真实 WNS。M1 微基准必须跑 OOC。
7. 顶层直接用 `axis` 端口会把 `DATAFLOW` 区的时序估计顶上去；沿用现有 IP 的
   "FIFO 读侧裸端口"写法。
8. 周期性桩权重会让 HLS 压缩 ROM、少报 BRAM；**用真权重**。
9. VS Code 的 TerosHDL 会占用 solution 目录，export 报 "permission denied"；
   在 `.vscode/settings.json` 排除 solution 目录。
10. 用 GUI 关工程会覆盖 `.app`；批量流程只用 tcl。

现有 IP 的真实红线（`xc7z030ffg676-2` 替身）：

```
LUT ≤ 70,740 / FF ≤ 141,480 / BRAM ≤ 477 / DSP ≤ 360
```

本方案的解析需求约 64~128 DSP、<20 KB BRAM，**余量远大于现有 CNN**；
真正的风险在时序收敛和 LCWT 的 DSP 映射，不在容量。

---

## 9. 里程碑（按"先杀最大风险"排序）

| 里程碑 | 内容 | 产出 | 预估 |
| --- | --- | --- | --- |
| **M0** | PTQ/QAT + Python 定点模拟 + 输入定标 | 定点模型、test top1、`SCALE_IN` | 2~3 天 |
| **M1** ⭐ | **LCWT 分析层微基准**（含 OOC 综合） | 单层 II/拍数/DSP/LUT/WNS | 1 天 |
| **M2** | LCWT 合成层 + 四层级联 | C 仿真逐位对 Python | 2~3 天 |
| **M3** | patch + LN + GELU + MLP + head | 端到端 C 仿真 | 3~5 天 |
| **M4** | 顶层、AXI-Stream、8 帧/调用、cosim | IP 包 + 综合报告 | 2~3 天 |
| **M5** | 决策级复核（§7.1 L4） | 定点 vs 浮点对照 | 1 天 |
| **M6** | 接入 PL 工程 | 上板 | 需另行批准 |

**M1 是 go/no-go**：如果分析层在 OOC 下 DSP 超 200 或 WNS 为负，先降并行度
（K 展开 8、II=2），不要硬啃。半天就能得到的否定结果，比两周后才发现便宜得多。

---

## 10. 取舍与不做什么

* **不做"LCWT + 现有 FFT-CNN"的拼接**：现有 CNN 的输入是 255 点功率谱，
  LCWT 输出是时域 I/Q，形状和语义都对不上。要拼就得重训整个 CNN，且没有
  任何精度证据支持它比现在的 WaveMLP 好。
* **不改现有 IP、不动 `FPAI_PL`**：本指南全部在新目录实现；现有
  `RFFI_FFT_ConvNet` 的 zip 和 OOC 报告保持原样，作为回退。
* **第一版不做全 DATAFLOW、不做 INT8 激活、不做 4.33 µs 对等口径**：
  先把"定点精度对 + 能综合"做实，再谈吞吐。
* **精度口径**：本模型是 20 类 test 0.7067。现有 HLS CNN 的 0.3823 是 150 类，
  **两者不可比**，材料里不要并列。
