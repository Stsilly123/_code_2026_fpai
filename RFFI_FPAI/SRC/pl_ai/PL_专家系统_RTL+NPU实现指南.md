# PL 侧专家系统：RTL 特征提取 + NPU MLP 实现指南

> 本文件是**现行方案**。旧文 `PL_专家系统_HLS实现指南.md` 里的特征算法和定点口径
> 仍然有效，但凡涉及「MLP 放 PL / HLS 写 MLP / GELU LUT / 权重 ROM」的章节全部作废。
>
> 变化只有一句：**PL 只算 193 维手工特征，MLP 放到 NPU（iCraft ZG330）。**

---

## 0. 一句话结论

```
raw IQ(Q10) ──┬─→ LcwtMLP_RFFI（现有，不动）──→ 20 类 logits
              │
              └─→ Expert_Feat_RFFI（新增 RTL）──→ 193×int32 Q12
                                                     │
                                     PS 标准化 + 补零到 256
                                                     │
                                     NPU: expert_mlp_20cls_ZG
                                                     │
                                     20 类 logits ──→ 三路融合 0.6/0.2/0.2
```

- 现有 LCWT 模型**一行不改**，比赛「PL 必须载 AI 模型」仍由它满足。
- 专家 MLP 只有 84,736 MAC，放 NPU 后 PL 省掉 ~85 KB 权重 ROM、8 个 MAC 和
  标准化/GELU，PL 只剩特征提取。
- NPU 图已经**实测跑通**（int8 和 fp16 两版）：12/11 个 `@zhuget(330)`
  + 2 个 `@hostt`，无 unsupported 算子。
- **部署推荐 fp16（C=16）**：test 256 条 argmax 一致 99.61%、cos 1.0000、
  top1 只差 −0.39 点；int8 版作为吞吐兜底（C=2，一致 96.48%）。

---

## 1. 分工与硬约束

| 侧 | 做什么 | 不做什么 |
| --- | --- | --- |
| PL | 收 33-bit IQ 流；算 193 维特征；打 256 字/帧的特征流 | 不做 MLP、不做标准化、不做 GELU |
| PS | 读特征 DMA；Q12→float；`(x-μ)/σ`、钳位、补零；调 NPU；三路融合 | 不碰原始 IQ 预处理（现有代码已做） |
| NPU | 193(补到 256)→256→128→20，INT8 | 不做特征提取 |

硬约束（不要违反）：

1. `D:\FPGA\FPGA\FPAI_PL\` **只读**，新 RTL 放在你自己的 PL 工作区。
2. `impl_fpai_app` 里已验证的 XF/PL 调用、8 帧 DMA 节奏、TTA 两轮流程不动；
   专家路径是**新增**的第四条 DMA 和第二个 NPU session。
3. 校准集只用 **train** split；test 只用来验收，不用来调参。
4. 融合权重固定 `0.6/0.2/0.2`（XF/PL/EX），不在 test 上重新搜。
5. 去掉专家路径时，系统必须逐位退化为现有的 `XF+PL 2:1` 行为。

---

## 2. 接口契约

### 2.1 输入：与现有 LCWT IP 完全一致

- 33-bit FIFO/流：`{bit32=TLAST, bit31:16=Q, bit15:0=I}`，两个 int16，**Q10**。
- 每帧 256 拍；现有顶层一次调用 8 帧（8192 B）。
- 1→2 分叉**自己写 RTL**（`valid && ready_lcwt && ready_expert` 即可），不要用
  标准 AXI4-Stream Broadcaster：AXIS 的 TDATA 必须按字节对齐，33 bit 会被迫
  补到 40 bit，两路还要处理 TKEEP，反而更麻烦。专家侧有 8 帧 RAM，一次 DMA
  正好 8 帧，写满时正好是批尾，不会在批中反压 LCWT。
- 如果一定要用现成 FIFO，用 **FIFO Generator v13.2 的 Native 接口**（33-bit），
  不要用 AXI4-Stream FIFO（同样受字节对齐限制）。

### 2.2 输出：新增特征流（不动现有 314 拍 logits 流）

- 位宽 32-bit，AXI4-Stream，`TLAST` 每帧第 255 拍。
- 每帧 **256 个字 = 1024 B**；8 帧 = **8192 B**，正好一个 DMA buffer。
- 字 0..192：特征，`int32` 二进制补码，**Q12**（浮点值 ×4096）。
- 字 193..197：头（可选但强烈建议，防陈旧/错位）：

| 字 | 值 | 含义 |
| --- | --- | --- |
| 193 | `0x45584631` | magic，ASCII `"EXF1"` |
| 194 | `1` | 版本 |
| 195 | `0..7` | 本批内的帧号 |
| 196 | `12` | Q 格式（Q12） |
| 197 | `0` | flags，保留 |
| 198..255 | `0` | 填充 |

- PS 侧先验 magic/版本/帧号，再解特征；**陈旧 buffer 必须能被识别**。
- 字节序：AXI 小端；PS 按 `uint32` 读后符号扩展成 `int32`，再 `/4096.0f`。

### 2.3 帧对应关系

- 专家特征只对 **shift 0、每帧第一份** 有意义；TTA 平移对专家分支中性（已测）。
- 现有 PL 第一轮 8 个槽全是 shift 0 的副本。PS **只取第 0 帧的特征**，
  其余 7 帧丢弃。简单、不改变现有两轮 TTA 流程。
- 专家特征不吃均衡后的 IQ，直接吃 raw；不要用 dma2 的 eq 数据。

### 2.4 DMA / 地址

- 新增一路 **S2MM**（建议 dma3，AXI DMA v7.1 Simple mode，32-bit）。
- 参考现有 `dma0=0x80400000/MM2S`、`dma1=0x80410000/S2MM(dout)`、
  `dma2=0x80420000/S2MM(eq)`，dma3 顺延 **0x80430000**；最终以你的
  device tree/驱动为准。
- 目标 buffer：**8192 B**，单独一块 udmabuf 或现有 buffer 的独立偏移。
- 每次 PL 调用只收 **一次** 8192 B；不要一帧一次，避免 8 倍中断/驱动开销。

---

## 3. 193 维特征（唯一口径）

顺序固定：

```
[0:128]  fft        128
[128:138] wavelet   10
[138:166] const     28
[166:178] cumulant  12
[178:187] cfo        9
[187:193] power      6
```

来源脚本 `scripts/expert_feature_probe_20cls.py::extract_groups`，逐位照做。

### 3.1 预处理

```
rms = sqrt(mean(x² + q²)) + 1e-12          # 1e-12 在 sqrt 外面
zn  = (x + jq) / rms
az  = |zn|
```

`zn` 实测 absmax ≈7.60，Q12 int16 正好（7.6×4096=31,130）。

### 3.2 FFT（128）

```python
Z  = np.fft.fft(zn)[:128]
lm = log(|Z| + 1e-6)
lm -= lm.mean()
```

- 256 点复数 FFT，取前 128 bin；`log` 是自然对数。
- 实现用 `0.5·log2(P)`，`P=|Z|²`；整体 FFT 定标不影响（会被均值减掉）。
- `P=0` 时输出 `log(1e-6)`。

### 3.3 db4 小波（10）

```python
for ch in (x, q):                      # 原始 x,q，不是 zn
    coeffs = pywt.wavedec(ch, "db4", level=4)   # mode='symmetric'
    energies = [(c*c).mean() for c in coeffs]
feat = log(concat(energies) + 1e-12)   # 10 维
```

顺序：`[I cA4, I cD4, I cD3, I cD2, I cD1, Q cA4, ..., Q cD1]`。

单层：

```
cA[t] = Σ_k dec_lo[k] · x_ext[2t+1-k]
cD[t] = Σ_k dec_hi[k] · x_ext[2t+1-k]

# symmetric = 半样本对称（整段镜像）：
#   n<0  → x[-n-1]；n>=N → x[2N-n-1]
#   例：x_ext(-1)=x[0], x_ext(-2)=x[1], x_ext(N)=x[N-1]
```

长度 131/69/38/22；能量除以该级实际长度。定点利用线性性：在 `zn` 上做 DWT，
最后每维 `+2·log(rms)`。

db4 系数直接用旧指南 §3.3 的两行 8 抽头表（小数位不能改）。

### 3.4 星座直方图（28）

```
amp_edges   = linspace(0.2, 2.5, 15)              # 15 边界 → 16 bin
phase_edges = linspace(-π, π, 13)[1:-1]          # 11 边界 → 12 bin
feat = [hist(az)/256, hist(angle(zn))/256]
```

- `right=False`：`edges[j-1] <= v < edges[j]`；小于首边界进 bin 0，大于末边界进最后 bin。
- 相位 `(-π, π]`，`atan2(0,0)=0`。
- 计数除以 **256**。

### 3.5 高阶累积量（12）

```python
c20 = mean(z²)
c21 = mean(|z|²)
c40 = mean(z⁴) - 3c20²
c41 = mean(|z|² z) - 3c20 c21
c42 = mean(|z|⁴) - |c20|² - 2c21²
c60 = mean(z⁶) - 15c20·mean(z⁴) + 30c20³
c63 = mean(|z|⁶) - 9c42·c21 - 6c21³

feat = [|c20|,|c40|,|c41|,|c42|,|c60|,|c63|,
        angle(c20),...,angle(c63)]
```

六阶项一个都不能漏。幅度/角度都用 Q12；幅度接近 0 时角度噪声大，**不要加门控**。

### 3.6 CFO（9）

```python
r20 = mean(zn[20:] * conj(zn[:-20]))
r1  = mean(zn[1:]  * conj(zn[:-1]))
blocks[i] = angle(mean(zn[i*64+20:(i+1)*64] * conj(zn[i*64:(i+1)*64-20])))
feat = [angle(r20), |r20|, angle(r1), |r1|, blocks[0..3], std(blocks)]
```

- `std` 是 population std（ddof=0），**不 unwrap**。
- 每 block 44 个乘积；CFO 只当特征，不补偿。

### 3.7 功率/包络（6）

```python
feat = [log(rms), std(az), mean(az³), mean(az⁴), |mean(x)|, |mean(q)|]
```

第 0/4/5 维依赖原始 Q10 定标；`std` 是 population std。

---

## 4. 定点格式

| 量 | 格式 | 位宽 | 说明 |
| --- | --- | --- | --- |
| x/q 输入 | Q10 | int16 | `code = round(x*1024)` |
| rms | Q10 | int32 | 平方和 int64，mean 后 sqrt |
| 1/rms | Q20 | uint32 | 一次倒数；`rm=0` 用保护值 |
| zn | Q12 | int16 | `zn = (x_q10 · inv_q20) >> 18` |
| FFT 输入 | Q12 | int16 | 256 点，unscaled/BFP |
| FFT 输出 | 25 bit | int32 | 不缩放；P 用 int64 |
| log2 中间 | Q16 | int32 | 前导零 + 1024 项尾数 LUT |
| db4 系数 | Q14 | int16 | 8 抽头，累加 Q26 → 输出 Q12 |
| 特征缓冲 | Q12 | int32 | 输出到 PS 的格式 |
| MLP 输入 | float32 | — | PS 做标准化，不在这里定点 |

统一规则：

```
复乘：Q12 × Q12 = Q24 → 算术右移 12（+half 舍入）→ Q12
db4 ：Q12 × Q14 = Q26 → 8 抽头累加 → 右移 14 → Q12
能量：Q12² = Q24；int64 累加；除以长度；log2 → Q12
角度：atan2 输出弧度，×4096 → Q12
```

所有中间量用 int64；只有最终特征落 int32 Q12。累积量在 test 有 3388 的离群值，
Q12 也只有 13.9M，远离 int32 上限。

**注意**：板端输入是 Q10（`code/1024`），训练 `segs.npy` 也是同一量纲；
不要假设别的 scale，先用一帧回归核对 `scale`。

---

## 5. RTL 微架构

### 5.1 数据流

```
33b in → Broadcaster → FIFO → 8×1KB 输入 RAM（可整批吸收 8 帧）
                                 │
    ┌────────────────────────────┼────────────────────────────┐
    │                            │                            │
 RMS/zn Q12                 FFT 256 → |Z|² → log2        db4 4 级 I/Q
    │                            │                            │
    ├─ 直方图（az/phase，CORDIC）│                            │
    ├─ 累积量（z²,z⁴,z⁶）       │                            │
    ├─ CFO（lag-20/lag-1/4 block）                           │
    └─ 功率（rms/az 矩/raw mean）                            │
                                 │                            │
                        193×int32 特征缓冲（Q12）
                                 │
                     打包 256 字/帧 + 头 + TLAST → AXIS → DMA3
```

- 输入 RAM 建议 **8 KB**，写侧可以整批吸收 8 帧，计算侧逐帧读；两边用
  true-dual-port BRAM，互不阻塞。
- 各特征块可以**顺序**做（预算足够），不要第一版就上复杂 DATAFLOW。
- 帧间双缓冲：第 n 帧打包输出时，第 n+1 帧可以开始算。

### 5.2 各块要点

| 块 | 做法 | 注意 |
| --- | --- | --- |
| RMS/zn | 256 次平方和 → 1 次 sqrt → 1 次倒数 → 256 次乘 | 倒数用 Divider 或 Newton；`rms` 保护 |
| FFT | FFT IP 256 点，Radix-2 Lite + Burst I/O | unscaled/BFP，输出 ≥24 bit |
| log2 | 前导零 + 1024 项尾数 LUT + 线性插值 | 输入 P int64；全零走 `log(1e-6)` |
| db4 | 8 抽头、decimate=2；每级算 cA/cD | symmetric 延拓；只累加需要的 5 个带 |
| 直方图 | 28 个计数器；阈值 Q12 比较 | `right=False`，边界逐点核 |
| 累积量 | z²→z⁴→z⁶ 迭代；int64 累加 | 六阶组合式不能化简错 |
| CFO | 延迟线 20/1；4 个 block 累加器 | block std 不 unwrap |
| 功率 | 与直方图共用 az | az 由 CORDIC sqrt 得到 |
| 打包 | 193 特征 + 5 头 + 填充到 256 | TLAST 第 255 拍 |

CORDIC 两块（sqrt、atan2）建议 parallel 模式、1 样本/拍；256 个样本约 256 拍，
足够快，不必串行省资源。若 DSP 超预算，再改串行。

### 5.3 拍数（@250 MHz，单帧）

| 阶段 | 估算 | 说明 |
| --- | --- | --- |
| RMS + zn | ~600 | 平方和 + sqrt + 倒数 + 256 乘 |
| FFT 256 | ~1,300 | Radix-2 Lite |
| 128 log2 | ~400 | LUT 流水 |
| db4 I/Q | ~1,000 | 960 MAC，2 MAC/cycle |
| 直方图 | ~300 | CORDIC 1/cycle |
| 累积量 | ~1,500 | 复用复乘引擎 |
| CFO | ~1,000 | ~687 复乘 |
| 功率 | ~500 | 与 az 共用 |
| 打包 | ~256 | 1 字/cycle |
| **合计** | **~6~8k** | **24~32 µs/帧** |

保守按 **15k 拍/帧（60 µs）** 做预算；8 帧 < **0.5 ms**，仍远小于 7.5 ms
帧周期，也小于现有 PL 第一轮 ~2.25 ms。时序上完全藏得住。

### 5.4 存储

| 缓冲 | 大小 | 类型 |
| --- | --- | --- |
| 输入 8 帧 | 8 KB | BRAM（TDP） |
| zn 当前帧 | 1 KB | BRAM |
| FFT 输出 | 1.5~2 KB | BRAM |
| db4 中间 | ~1 KB | BRAM |
| 特征缓冲 | 193×4 B = 772 B | BRAM |
| log2 LUT | 1024×18 bit ≈ 2.3 KB | ROM |
| 直方图计数 | 28×9 bit | LUTRAM |
| 常数（db4、阈值） | <1 KB | ROM/LUT |

合计约 **8~12 个 BRAM36 tile**。MLP 权重 ROM（~19 tile）和 GELU LUT 全部消失。

---

## 6. IP 核清单（给定制 IP 的人）

| # | IP / 组件 | 版本 | 关键配置 | 用途 | 必需 |
| --- | --- | --- | --- | --- | --- |
| 1 | Fast Fourier Transform | v9.1 | 256 点，16-bit 输入，forward，natural order，Radix-2 Lite + Burst I/O，unscaled/BFP，输出 25 bit | 128 bin 频谱 | **是** |
| 2 | CORDIC | v6.0 | 16/24-bit，parallel；实例 A=Square Root，实例 B=Arc Tan | `sqrt`、`atan2` | **是** |
| 3 | Block Memory Generator | v8.4 | TDP RAM（输入帧、zn、FFT、特征）；ROM（log2 LUT、db4、阈值） | 存储 | **是** |
| 4 | AXI4-Stream Broadcaster | v1.1 | 1→2，TDATA=33，TLAST 透传 | 同一帧分给 LCWT 和专家 | **是** |
| 5 | AXI4-Stream Data FIFO | v2.0 | 33-bit 入/出，深度 32~64，两路各一个 | 隔离背压 | **是** |
| 6 | AXI DMA | v7.1 | Simple mode，32-bit，1 channel，S2MM，8192 B | 特征搬 PS | **是** |
| 7 | AXI Interconnect / SmartConnect | v2.1 | 把 dma3 接到 PS HP 口 | 总线 | **是** |
| 8 | Divider Generator | v5.1 | 32-bit，或自写 Newton 倒数 | `1/rms` | 可选 |
| 9 | Multiplier | v12.0 | 16×16 / 24×16，流水 | 复乘/矩 | 可选（建议自写共享引擎） |
| 10 | FIR Compiler | v7.2 | 8-tap，decimation=2，coefficient reload | db4 替代 | 可选（建议自写） |
| 11 | ILA | v6.1 | 32-bit probe ×2 | 板上抓特征/状态 | 可选 |
| 12 | AXI GPIO / AXI-Lite | v2.0 | 32-bit | enable/status/soft reset | 可选 |

**明确不要**：

- 不要再例化 MLP MAC 阵列、GELU LUT、μ/σ ROM。
- 不要用 DPU（ZG330 侧由 iCraft 编译，不在 PL 里）。
- 不要改现有 `LcwtMLP_RFFI` 的 314 拍输出格式。

---

## 7. 资源预算

红线（与 LCWT 同一器件）：

```
LUT ≤ 70,740 / FF ≤ 141,480 / BRAM ≤ 477 / DSP ≤ 360
现有 LCWT：LUT 9,439 / FF 17,378 / BRAM 60.5 / DSP 318
```

专家特征分支预估：

| 块 | DSP |
| --- | --- |
| FFT 256 | 4~6 |
| CORDIC ×2 | 0~4 |
| db4（4 乘共享） | 4 |
| 复乘引擎（累积量+CFO 共用） | 4 |
| 矩/功率/平方 | 4 |
| 其他 | 2 |
| **合计** | **18~24** |

- 318 + 24 = **342 < 360**，余量约 18 DSP。
- LUT 预估 6~9k，FF 6~9k，BRAM 8~12 tile；都远低于红线。
- **必须跑 OOC 综合拿真数字**：FFT/CORDIC 的 DSP 与 LUT 不能靠估算，
  尤其 2018.3 对乘法器的推断。

---

## 8. PS + NPU 集成

### 8.1 iCraft 编译（已实测）

工程里已经放好三件东西：

| 文件 | 作用 |
| --- | --- |
| `scripts/export_expert_icraft.py` | checkpoint → ONNX（193 补到 256，第一层权重补零） |
| `scripts/make_expert_calib.py` | train 特征 → 256 条 float32 校准集 |
| `scripts/verify_expert_icraft.py` | Host 后端定点 vs PyTorch fp32 对拍 |
| `icraft_work/expert_mlp_20cls_zg.toml` | ZG330 int8 五阶段编译配置 |
| `icraft_work/expert_mlp_20cls_c2_zg.toml` | int8 + 输入钳位 C=2（更准的 int8 版） |
| `icraft_work/expert_mlp_20cls_fp16_zg.toml` | **fp16 版（推荐）** |

命令（在 `Transformer_Train` 根目录）：

```bash
export ICRAFT_VERSION=v3.36.1
export PATH="/c/Icraft/CLI/bin:$PATH"

python scripts/export_expert_icraft.py --check-acc
python scripts/make_expert_calib.py --n 256
icraft compile icraft_work/expert_mlp_20cls_zg.toml
python scripts/verify_expert_icraft.py --n 256
```

产物：

```
icraft_work/json&raw_zg/expert_mlp_20cls_ZG.json          int8 C=16
icraft_work/json&raw_zg/expert_mlp_20cls_c2_ZG.json       int8 C=2
icraft_work/json&raw_zg/expert_mlp_20cls_fp16_ZG.json     fp16 C=16
```

算子分布：**12（int8）/11（fp16）个 `@zhuget(330)` + 2 个 `@hostt`**，
没有 `@buyit`，没有 unsupported。ONNX 里的 `Erf`（精确 GELU）被编译器
融合进 HardOp，不需要改成 tanh 近似。

Host 后端 quantized 对拍（test 等间隔抽样 n=256，同一批样本）：

| 版本 | 输入钳位 | iCraft top1 | fp32 top1 | Δ | argmax 一致 | cos |
| --- | --- | --- | --- | --- | --- | --- |
| int8 | C=16 | 75.78% | 77.34% | −1.56 | 94.14% | 0.9995 |
| int8 | **C=2** | 78.12% | 77.73% | +0.39 | 96.48% | 0.9995 |
| **fp16** | **C=16** | **76.95%** | **77.34%** | **−0.39** | **99.61%** | **1.0000** |

- **默认用 fp16**（准确率几乎无损，模型只有 221 KB，NPU 算 84K MAC 可忽略）。
- 如果 fp16 在板上的吞吐/延迟不达标，退 int8+C=2。
- 不要为了 int8 去改融合权重；先按上表选版本。

复现：

```bash
# fp16（推荐）
cp icraft_work/models/expert_mlp_20cls.onnx icraft_work/models/expert_mlp_20cls_fp16.onnx
icraft compile icraft_work/expert_mlp_20cls_fp16_zg.toml
python scripts/verify_expert_icraft.py --net expert_mlp_20cls_fp16 --clamp 16 --n 256

# int8 C=2
python scripts/export_expert_icraft.py --clamp 2 --out icraft_work/models/expert_mlp_20cls_c2.onnx
python scripts/make_expert_calib.py --clamp 2 --out icraft_work/calib_expert_c2
icraft compile icraft_work/expert_mlp_20cls_c2_zg.toml
python scripts/verify_expert_icraft.py --net expert_mlp_20cls_c2 --clamp 2 --n 256
```

> ZG330 只支持 `qdtype = int8/bf16/fp16/tf32`，`int16` 会在 quantize 阶段
> 报 `Qdtype error`；不要试 int16。

### 8.2 PS 侧每帧预处理（必须与校准逐位同口径）

```cpp
const uint32_t *w = (const uint32_t *)feat_buf;   // 8192 B
// 校验 magic/version/frame_idx
float in[256];
for (int k = 0; k < 193; ++k) {
    float f = (float)(int32_t)w[k] / 4096.0f;     // Q12 反量化
    float z = (f - mu[k]) / sd[k];                // μ/σ 来自 checkpoint
    z = std::clamp(z, -C, C) / C;                 // fp16: C=16；int8: C=2
    in[k] = z;
}
for (int k = 193; k < 256; ++k) in[k] = 0.0f;     // 补零
```

- `mu/sd` 用 checkpoint 里的 193 维；已导出
  `deploy_artifacts/expert_mlp/expert_norm_fp16.h` 和 `expert_norm_int8.h`。
  **两个版本的 `C` 不能混用**：fp16 用 16，int8 用 2。
- 必须在 **定点特征** 上重算 μ/σ（M0），浮点 μ/σ 只作初值。
- 输入张量 `[1,256]` float32；输出 `[1,20]` float32 logits。
- 复用现有 XF session 的打开方式（`openDevice("zg330")` / `loadNetwork` /
  `initSession(..., mmuMode=true)`），新建**第二个 session** 加载专家图。

### 8.3 每帧调用与融合

```
PL 第一轮 xfer（8 帧 shift 0）
  ├─ 收 dma1：现有 PL logits
  ├─ 收 dma2：eq（给 XF）
  └─ 收 dma3：专家特征（只取第 0 帧）
        ↓
PS: 标准化 + 补零 → expert session.forward → 20 logits
        ↓
softmax(PL logits)、softmax(XF logits)、softmax(EX logits)
        ↓
log p = 0.6·log p_xf + 0.2·log p_pl + 0.2·log p_ex
```

- 专家分支**不做 TTA**（实测对融合 -0.02）。
- 专家只吃 raw，不吃 eq。
- 现有 `fuse_log_prob_scores` 是两路；新增三路函数，保留两路函数作为
  专家关闭时的退化路径。
- **不要在 test 上重搜 0.6/0.2/0.2**。

### 8.4 延迟

- 专家 NPU 前向 84,736 MAC，计算量 < XF 的 1%；风险在**每次调用的固定开销**。
- 第一版按 batch=1 每帧一次，实测 `forward` 墙钟时间。
- 若固定开销 >0.5 ms：把专家图改成 batch=8（一次 PL 调用凑 8 帧）再前向；
  或与 XF 图合并成多输入图（工程量大，最后再考虑）。
- 现有跨帧流水周期 = max(PL, XF)；专家 NPU 是串在 PS 上的额外时间，
  必须实测周期是否仍 < 8 ms。

---

## 9. 验证

| 级别 | 做什么 | 判据 |
| --- | --- | --- |
| L0 | iCraft INT8 vs fp32（已做） | argmax ≥99%（目标），cos ≥0.999 |
| L1 | Python 定点特征 vs fp32 特征 | 每维相对误差 <1e-3；solo ≥0.744 |
| L2 | RTL vs Python 定点 | 特征缓冲 **逐位一致**（允许 ±1 LSB 的项要单独列出） |
| L3 | 板端 PL 特征 dump vs golden | 1,000 帧逐位一致 |
| L4 | 板端 NPU logits vs Host quantized | argmax ≥99% |
| L5 | 完整 test 12,879 帧 | 三路融合 ≥0.850 |

golden 集从 rawonly 的 14 个 test cell 各抽 ≥70 帧，另加低/高幅度、全零、
直方图边界、相位 ±π 帧。落盘所有中间量（zn/FFT/小波/直方图/累积量/CFO/功率）。

必须单独测的边界：

- db4 symmetric 延拓在 x[0]/x[N-1] 附近；
- 直方图正好落在 bin 边界（`right=False`）；
- atan2 在 ±π 交界；CFO block std 不 unwrap；
- 累积量近零的 atan2(0,0)；
- rms 近零（全零帧）不能除零；
- 输入饱和/Q10 定标；
- DMA 陈旧 buffer：magic/帧号必须能识别。

---

## 10. 里程碑

| 里程碑 | 内容 | 产出 |
| --- | --- | --- |
| **M0** | Python 定点特征复刻 + 在定点特征上重算 μ/σ | golden、solo 读数 |
| **M1** ✅ | 专家 MLP 导出/校准/ZG330 编译/INT8 对拍 | `expert_mlp_20cls_ZG.*` |
| **M2** ⭐ | FFT + log2 + CORDIC 微基准 OOC | DSP/LUT/WNS 真数字；go/no-go |
| **M3** | db4/直方图/累积量/CFO/功率 RTL + 逐位对拍 | 特征模块 |
| **M4** | 顶层 Broadcaster、dma3、打包、8 帧 | IP 包 + OOC |
| **M5** | PS 接入 NPU session + 三路融合 | app 改动 |
| **M6** | 上板（你自己编译部署） | 延迟/精度读数 |

M2 是 go/no-go：专家分支 OOC DSP >42 就先降并行度/共享复乘，不要硬上。

---

## 11. 已知坑

1. **不要把 MLP 再放回 PL。** 本方案的重点就是砍掉 85 KB ROM 和 GELU。
2. **不要改现有 314 拍 logits 流。** 专家输出走独立的 256 字流。
3. **不要用 eq 数据算专家特征。** 已实测 MMSE 均衡输入更差。
4. **校准集只用 train。** test 单元混进校准会让量化精度虚高。
5. **iCraft 的 ZG 配置**：parse/quantize 用 `zhuge`，optimize/adapt 用
   `ZHUGE`；parse 必须显式 `inputs_dtype="fp32"`，quantize 必须显式
   `qdtype="int8"`；`no_imagemake` 不要写。
6. **FFT 不能缩放到 16 bit。** 用 unscaled/BFP，输出至少 24 bit。
7. **db4 不是 periodic。** 默认 `mode='symmetric'`，端点复制。
8. **直方图边界必须逐点对 numpy。** 差一个 `<` 就是整维偏移。
9. **DMA 收完要判新鲜度。** 写错输入路径时 iCraft/驱动可能返回 0，旧
   buffer 原样躺着；magic + 帧号 + 内容退化检查都要做。
10. **2018.3 OOC 之前别信 csynth 的 DSP 数**（旧工程实测低估 1.6~1.8×）。
11. **`FPAI_PL` 只读。** 新 RTL 放你自己的目录，别跨工作区写。
12. **不要动 `impl_fpai_app` 已验证的 XF/PL 调用与 TTA 两轮节奏。**

---

## 12. 参考

- **Verilog 模块/端口/FSM/testbench 细节：`docs/PL_专家系统_Verilog实现指南.md`**
- 特征与定点细节：`docs/PL_专家系统_HLS实现指南.md` §3/§4（MLP 章节作废）
- 特征真值：`scripts/expert_feature_probe_20cls.py::extract_groups`
- 权重：`checkpoints/expert_mlp_data_cache_20cls_rawonly.pt`
- NPU：`scripts/export_expert_icraft.py`、`scripts/make_expert_calib.py`、
  `scripts/verify_expert_icraft.py`、`icraft_work/expert_mlp_20cls_zg.toml`
- 现有 PL 契约：`FPAI_PL/HLS/LcwtMLP_RFFI/.../IP交付说明.md`
- 板端应用：`impl_fpai_app/src/pl_side.hpp`、`src/fusion.hpp`

## 附录 A：验收数字（不要改口径）

- 专家 solo test：**0.7486**（fp32，rawonly）
- 专家 + PL：0.8159（w=0.20）
- XF 五折：0.8221
- XF + PL：0.8332（2:1）
- XF + PL + EX，固定 0.6/0.2/0.2：**0.8532**
- vs XF：+3.11 点，CI [+1.60,+4.63]
- vs 现部署：+2.00 点，CI [+0.64,+3.27]

## 附录 B：特征流速查

```
每帧 256 字 × 4 B = 1024 B
word 0..192   int32 Q12 特征
word 193      magic 0x45584631
word 194      version 1
word 195      frame_idx 0..7
word 196      qformat 12
word 197      flags 0
word 198..255 0
TLAST = word 255
一次 DMA = 8 帧 = 8192 B
```
