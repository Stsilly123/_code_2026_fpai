# impl_fpai_app —— RFFI Transformer 在 FPAI 上的部署实现

把 RFFI 的 20 类部署链路装进一个跑在板子 PS 侧的可执行程序。**数据来源不是
PL/SDI 相机，而是 PS 网口收到的 IQ 帧**，结果打到控制台并回帧：

```
PS 网口收 IQ 帧
  ├─ PL dma0/dma1：LCWT 主干 -> 16×38 token -> NPU 的 LCWT 头 -> p_pl[20]
  ├─ PL dma2     ：均衡 IQ -> PerSampleNorm -> XF 五折×平移 TTA（NPU） -> p_xf[20]
  └─ PL dma3     ：193 维专家特征 -> NPU 上的专家 MLP -> p_ex[20]
-> 三路 log 空间融合（XF 0.6 / PL 0.2 / EX 0.2；专家缺了退回 w=1/3 两路）
-> softmax top-k -> 控制台 + 回帧
```

细节见「三·五、四 DMA 数据通路与决策融合」。`exp_wide_ls`（150 类）是更早的
单主干实验，相关小节只作历史参考。

体例照 `fpai_demo_app/examples/1_single_input+ai/PLin+SingleNet+HDMI`，但**砍掉了**
actor / BufferManager / 多线程 / HDMI / opencv —— RFFI 是分类不是视频流，一个主循环就够，
少一层调试难度。

> **本仓库的模型产物只读来自 `Transformer_Train/icraft_work/`，那份被冻结的读数一行没动。**

---

> ## ⚠ 平台：30TAI（ZG330），不是 100TAI
>
> 本仓库最初整套是按 **100TAI（布衣 / BY）** 写的，实测部署目标是 **30TAI（ZG330）**。
> 两者不可互换，而且错了会以「板子硬死」的形式表现出来：
>
> | | 100TAI（布衣） | **30TAI（ZG330）← 本板** |
> |---|---|---|
> | `TARGET_CHIP` / `build.sh -c` | `BY` | **`ZG`** |
> | `sys.run_backend` | `buyi` | **`zg330`** |
> | 设备 URL | `axi://ql100aiu` | **`axi://zg330aiu`** |
> | 模型 `ai_target` / `compile_target` | `@buyit` | **`@zhuget(330)`（要重编）** |
> | `mmuModeSwitch` | 必须调 | ZG330 设备类没有这个方法，`#if` 掉 |
>
> **代价**：在 ZG 的 bitstream 上跑 `buyi`（`axi://ql100aiu`），`Device::Open()`
> 会去读该设计里不存在的寄存器，PS 的 AXI 事务永远等不到响应 → CPU 卡死在 `readl`，
> 表现为进程硬死、SSH 同时断开、`dmesg` 里只有 rcu stall、没有 panic。我们踩过一次。
>
> 模型 `imodel/exp_wide_ls_BY.*` 是 100TAI 的，**ZG330 上跑不了**；要在
> `Transformer_Train` 里把 target 换成 ZG330 重新编译，产出 `exp_wide_ls_ZG.json/.raw`。
> **已产出并上板跑通**：32 帧 `top1 = 71.88%`（fp32 75.00%）、argmax 一致率 **87.50%**。
> `CMakeLists.txt`、`build.sh`、`configs/rffi_transformer.yaml` 的默认值现已全部改成 ZG。

---

## 一、上板前必须知道的四件事

这四条最早是从 `exp_wide_ls_BY.json` 逐字段读出来的，**结论对现在所有图同样成立**
（XF 五折图和 LCWT 头都是图内 Cast、裸 float32 logits 输出）：

1. **网络输入是 float32，输出是 float32 裸 logits。**（单主干 `[1,2,256]`→`[1,150]`；
   XF 图 `[25,2,256]`→`[25,20]`；LCWT 头 `[1,608]`→`[1,20]`。）
   float→int8 的量化（含 `normratio 0.03374513`）由**图内的 CPU Cast 算子**自己做
   （op2，`@hostt`）。所以本程序既**不**手算量化、**不**需要 `getInputNormratio`、
   也**不**需要 `removeInputCast`/`removeOutputCast`。512 个 float 直接 memcpy 进去，
   出来就是 150 个 float logits。

2. **但 `PerSampleNorm` 在图外。** 它在 `src/data/dataset.py::PerSampleNorm`，由
   `IQDataset.__getitem__` 施加，`export_onnx` 没有写进图。**这一步必须由 app 复刻**
   （`src/preprocess.hpp`）。忘了归一化、或**双重归一化**，都不会报错、只会静默掉精度。

3. **输出是 logits，不是概率。** `RFFITransformer.forward` 的 `self.head` 是裸
   `nn.Linear`，softmax 从来没写进图（图里那 6 个 `@fpgat` 的 Softmax 是 attention 里的，
   不是分类头）。分类 softmax 在 `src/postprocess.hpp`。

4. **不要 include `icraft_utils.hpp`。** 它 `#include "PicPre.hpp"`，会把 opencv 整条
   依赖拖进来。本程序需要的 `openDevice`/`loadNetwork`/`initSession` 三个函数各 5~20 行，
   已经内联写在 `src/main.cpp` 里，换掉了整个 opencv/ffmpeg/OpenEXR 依赖。

---

## 二、目录

```
impl_fpai_app/
├── CMakeLists.txt              # 抄 demo 骨架，砍掉 opencv/ffmpeg/OpenEXR
├── build.sh                    # 板端构建脚本（自动找 deps / iCraft SDK / cmake）
├── configs/rffi_transformer.yaml
├── imodel/xf20/fused_b25_ZG.*  # XF 五折×五平移合成图（部署口径）
├── imodel/lcwt_head/           # LCWT 头：lnps_b5_ZG 图（无 LN，输入 [5,608]）+ aux.bin
├── imodel/exp_wide_ls_ZG.*     # 早期单主干产物，仅留档
├── names/class_names_20.txt    # 20 行，tools/export_class_names.py 生成
├── src/
│   ├── main.cpp                # argv/YAML -> 设备/会话 -> 主循环 -> 打印
│   ├── config.hpp              # YAML -> 结构体（yaml-cpp）
│   ├── iq_frame.hpp            # 线格式头 —— **协议的唯一真相**
│   ├── net_source.hpp/.cpp     # TcpFrameSource + FileFrameSource
│   ├── preprocess.hpp          # 反交错 + PerSampleNorm
│   ├── postprocess.hpp         # softmax + top-k
│   ├── xf_ensemble.hpp/.cpp    # XF 五折图 / 平移 TTA
│   ├── lcwt_head.hpp/.cpp      # LCWT 头：PS 侧 LN + NPU（dma1 的 token 解包后）
│   ├── npu_lock.hpp            # XF 与 LCWT 头共用一个 NPU 的互斥
│   ├── pl_side.hpp/.cpp        # PL 侧全部：量化、四 DMA、eq/专家接收、TTA
│   ├── spectrum.hpp            # 分析模式的 256 点 FFT（只给人看，不进模型）
│   └── fusion.hpp              # log-softmax + log-pool 决策融合
└── tools/
    ├── export_class_names.py   # data_cache/meta.npz:class_names -> names/class_names.txt
    ├── send_iq.py              # PC 端发送端（读 data_cache/segs.npy）
    ├── send_cmd.py             # 控制帧：切 fast/fusion/analysis、查当前模式
    ├── analyze_signal.py       # 分析模式客户端：收 FFT/星座/专家特征并存 npz
    ├── preprocess_check.cpp    # 离线自检，**不依赖 icraft/设备**，PC 上就能跑
    ├── check_preprocess.py     # C++ 预处理 vs IQDataset 对拍
    └── check_roundtrip.py      # 板子 argmax vs PyTorch fp32 对拍
```

---

## 三、线格式（TCP，**板子做服务端**，默认端口 9527）

定长 32 B 头 + 载荷，**全小端**。一帧 = 一段 256 点 IQ。

| off | 类型 | 字段 | 说明 |
|---|---|---|---|
| 0 | u32 | `magic` | `0x51494652`（字节序列 `R F I Q`） |
| 4 | u16 | `version` | `1` |
| 6 | u16 | `dtype` | `0`=float32，`1`=int16，`2`=控制帧（见三·四） |
| 8 | i32 | `label` | 真值类别，`-1`=未知（只为算准确率，真实接收机填 -1） |
| 12 | u32 | `seq` | 发送端自增，用于对丢帧；**对拍靠它对齐** |
| 16 | u32 | `n_complex` | 复样本数，**必须 == `seg_len`(256)** |
| 20 | f32 | `value_scale` | `dtype=1` 时 `raw * scale` 还原原浮点；`dtype=0` 忽略 |
| 24 | u64 | `timestamp_ns` | 可选，仅打印 |

载荷 `n_complex` 个复样本，**交错 `I0,Q0,I1,Q1,…`**（真实接收机的天然输出顺序）。
f32 时 2048 B，int16 时 1024 B。

两条硬约定（写在 `iq_frame.hpp` 的注释里）：

- **载荷永远是「原始未归一化」的 IQ**（与 `segs.npy` 同量纲，±30 那一档）。
  归一化由板子做。这一条是故意的 —— 它是最容易被两边各做一次而没人发现的地方。
- **模型要的是通道优先 `[I×256, Q×256]`，不是交错。** 反交错在 `preprocess.hpp` 里做。

帧头校验失败（magic/version/`n_complex` 不符、`recv` 短读）→ 记日志、**丢掉这条连接回
`accept()`**，不做「在字节流里找 magic」那种重同步（会把噪声当帧，越修越乱）。

### 回程：推理结果（板子 → 上位机）

**同一条 TCP 连接**上一帧请求配一帧结果，按 `seq` 对齐。全小端，40 B 定长头 +
`k` 个 top-k 条目：

| off | 大小 | 类型 | 字段 | 说明 |
|---|---|---|---|---|
| 0 | 4 | u32 | `magic` | `0x4F494652`（字节序列 `R F I O`）—— 和请求的 `RFIQ` 区分开 |
| 4 | 2 | u16 | `version` | `2` |
| 6 | 2 | u16 | `status` | `0`=Ok，`1`=NoSignal，`2`=Error，`3`=Analysis，`4`=CommandAck |
| 8 | 4 | u32 | `seq` | 回显请求帧的 `seq` |
| 12 | 4 | i32 | `label` | 回显请求帧的 `label`（`-1` = 上位机没填） |
| 16 | 4 | i32 | `pred` | top-1 类别下标 `0..149`；`status != Ok` 时为 `-1` |
| 20 | 4 | f32 | `prob` | top-1 概率；`status != Ok` 时为 `0` |
| 24 | 4 | u32 | `latency_us` | 本帧耗时（微秒） |
| 28 | 2 | u16 | `k` | 后面跟几条条目（`0..input.topk`） |
| 30 | 2 | u16 | `reserved` | `0` |
| 32 | 8 | u64 | `timestamp_ns` | 回显请求帧的 `timestamp_ns`，方便对齐上位机自己的流水 |

随后 `k` 条，每条 8 B：`u32 class_idx` + `f32 prob`（按概率降序）。

- **只发下标不发名字** —— 名字让上位机自己读 `names/class_names.txt`（第 k 行 = 类别 k），
  免得每帧多背 20 字节、也不怕两边名字表不同步；
- `status=NoSignal` 只在配了 `input.signal_min_std` 时出现；若同时 `skip_nosignal: true`，
  那一帧**跳过前向**、`k=0`；
- 收完一帧结果就按 `40 + 8*k` 一次性 `recv`，不要依赖「一次 recv 一定收全」——
  仍然要用 `recv` 循环补齐。

---

## 三·四、运行模式与控制帧（上位机可切）

同一端口、同一套定长头。控制帧的 `dtype=2`、`n_complex=0`，载荷是 8 B：

| 偏移 | 类型 | 字段 | 说明 |
|---:|---|---|---|
| 0 | u32 | `cmd` | `1`=SetMode（`arg` = 模式），`2`=QueryMode（不改，只回 ack） |
| 4 | i32 | `arg` | SetMode 时：`0`=fast，`1`=fusion，`2`=analysis |

板子收到命令后回一帧普通结果头：`status=4`（CommandAck）表示接受；不接受（未知命令、
或该模式在本进程里跑不了，比如 XF 没打开时切 fast）回 `status=2`（Error）。
`pred` = **当前模式**，`label` = 回显的命令号，`seq`/`timestamp_ns` 原样带回，`k=0`。

三种模式：

| 模式 | 跑什么 | 回帧 |
|---|---|---|
| `fast` | 只跑 transformer（XF）。PL 只取 dma2 的均衡 IQ，LCWT 头 / TTA 第二轮 / 专家 MLP 全不做 | 普通 `status=0`，top-k 是 XF |
| `fusion`（默认） | XF + PL + 专家三路融合，权重 0.6/0.2/0.2 | 普通 `status=0` |
| `analysis` | 三路都跑，但**不看预测**：把这一帧的信号本身交给上位机 | `status=3`，`k` 条 = 专家 top-k，后面跟分析块 |

`fast` 的帧周期明显短（省掉 PL 头的 NPU 前向、第二轮 TTA 和专家 MLP）；它仍然要跑
PL 的 shift 0 那一趟，因为 XF 的输入就是 dma2 的均衡输出。

**分析块**（`status=3` 时紧跟在 top-k 条目后）：40 B 的 `IqAnalysisHeader`，之后按
`flags` 位序依次跟各段 float32：

| bit | 段 | 长度 | 内容 |
|---:|---|---|---|
| 0 | raw | `n_raw` | 原始 IQ，I/Q 交错（星座图） |
| 1 | eq | `n_eq` | 均衡后 IQ，I/Q 交错（均衡后的星座图） |
| 2 | fft | `n_fft` | `|FFT|` 幅度，256 点，自然顺序（DC 在 0，不 fftshift） |
| 3 | feat | `n_feat` | 专家那一路的 193 维特征（Q12 反量化） |
| 4 | pl | `n_pl` | PL 20 类概率 |
| 5 | xf | `n_xf` | XF 20 类概率 |
| 6 | ex | `n_ex` | 专家 MLP 20 类概率 |
| 7 | `kAnaFftSrcEq` | — | 置位 = FFT 用均衡后 IQ 算的，清零 = 用原始 IQ |

头字段：`magic=0x41494652`（`RFIA`）、`version=1`、`flags`，然后 8 个 u32：
`n_raw/n_eq/n_fft/n_feat/n_pl/n_xf/n_ex/reserved`。段长就是这些数，没置位的位不占字节。

FFT 是板端用 `src/spectrum.hpp` 的 256 点基-2 FFT 现算的，**只给人看**，不参与任何
模型（模型用的 FFT 特征在 PL 专家模块里，两者不要求逐位一致）。

两个上位机小工具：

```bash
python tools/send_cmd.py --host <板子IP> --mode fast     # 切模式 / 看 ack
python tools/analyze_signal.py --host <板子IP> --n 16 --save analysis.npz
```

`analyze_signal.py` 会先切到 analysis、发 N 帧、把每帧的 raw/eq/fft/feat/三路概率
存成 npz（`--save`），最后把板子切回 fusion。

---

## 三·五、四 DMA 数据通路与决策融合（20 类）

PL 侧的 `LcwtMLP_RFFI` 已经**裁掉 LN/fc1/GELU/fc2/GAP/Linear**，只发 16×38 的
token；分类头改在 NPU 上跑。因此一条消息（一帧 256 复点）要动四条 DMA：

```
网口 float IQ（交错 I,Q，±30 那档）
        │
        ├─ 按帧峰值量化 int16 Q10 ─→ dma0/dma1（8 帧一调）
        │        dma1 每帧 1216 B = 304 拍 = 16 token × 38 维（2×int16/拍，Q4）
        │        → 解包 ÷ token_divisor → [1,608] float
        │        → PS 算 LayerNorm（608 个数）+ NPU 头（fc1/GELU/fc2/GAP/head）
        │        → logits[20]
        ├─ dma2 每帧 1024 B = 256 拍 {Q[31:16],I[15:0]}（int16 Q10）
        │        → 逐类中位数（8 帧）→ PerSampleNorm → XF 五折×平移 TTA（NPU）
        └─ dma3 每帧 1024 B = 193 维 int32 Q12 + 5 字头（magic "EXF1"）
                 → 目前只收下并打印，尚未参与融合
```

- **喂给 PL 的是网口原始 float IQ**，不是归一化后的 `norm_buf`。PL 的
  `normalize_512` 会自己做 PerSampleNorm；喂归一化过的数据等于归一化两次。
- **float→int16**：每帧按 `max|x|` 缩放到 ±32760（`quantize_shift`，Q10）。
  PL 内部逐样本归一化会把全局增益约掉，所以这个缩放只决定量化噪声。
- **8 帧复制**：一次 xfer 固定 8 帧，本程序一次只来一帧，所以把当前帧复制 8 份。
- **token 解包**：拍 `b = t*19 + j`（t=0..15，j=0..18），低 16 位是
  `tok[t][2j]`、高 16 位是 `tok[t][2j+1]`；物理值 = `code / token_divisor`。
  `token_divisor` **必须等于 PL 的 `TOK_OUT_SHIFT` 对应值**（默认 shift 4 → 16），
  写错不会报错、只会静默掉精度。
- **去重后批量过 NPU 头**：8 个槽先按 token 内容去重（同平移的复制帧逐字节
  相同），唯一行打包成一次 `[5,608]` 的前向；结果逐槽回填，仍逐类取中位数，
  不一致数低于 `min_agree_frames` 就不认这一轮。一轮 xfer 只花 1 次前向
  （busy 时唯一行超过 5 行才分多次）。
- **eq 的 8 帧**同样取中位数并做一致性自检（`min_eq_agree_frames`），再交给 XF。
- **两轮 xfer**：第一轮 8 份 shift 0（eq/专家/shift 0 的 token 都从这轮取），
  第二轮其余平移各占一槽（这一轮的 eq/专家收走即扔）。**eq/专家必须在下一轮
  xfer 之前收掉**，否则 `lstf_eq` / 专家模块的输出口会被 TREADY 反压堵住。
- **LCWT 头的 LayerNorm 在 PS 侧**：图是 `lcwt_head_20cls_lnps_b5_ZG`（21 个
  `@zhuget(330)` 硬算子 + Input/Output），输入是 LN 之后的 token，不是原始 token。
  输入 `[5,608]`、输出 `[5,20]`：5 行 = 5 个 TTA 平移，一次前向算完。
  `pl.head_batch: 5` 必须和图一致，头打开时会核（写错会报「pl.head_batch 和图
  不配套」）。b5 图与原先 `[1,608]` 的图在同一输入上**逐位相同**（50 样本 ×
  20 类 0 差异），所以换图不影响精度。
  原图 `lcwt_head_20cls_fp16_ZG` 把 LN 编成了 host 算子 `Sqrt`/`Div`，而板端
  aarch64 的 `libicraft_hostbackend.so` 没注册这两个，上板 `apply()` 直接抛
  `Op is NOT bound to any backend, op_id = 7, type_key = icraft::xir::SqrtNode`。
  LN 的 γ/β 与 head 的 W/b 在 `imodel/lcwt_head/lcwt_head_20cls_aux.bin` 里；
  PS 还要补常数项 `W·mean(z)`（**不加** head bias，图里已带一次）：
  `logits = 图输出 + W·mean_t(z)`。头打开时会校验 aux 的尺寸，对不上直接报错。
- **NPU 串行**：LCWT 头和 XF 共用一块 NPU，两边 forward（含 `reset(1)`）都由
  `npu_mutex()` 串行，别在别处再开一条 NPU 前向。

### 融合公式

```
log p_fused(c) = (1-w)·log p_xf(c) + w·log p_pl(c)
```

`w = fusion.pl_weight`，正式口径 1/3。20 类 test 上 XF 五折×平移 82.2%、
PL 71.2%、融合 83.0%；板端 INT8 融合 83.20%。**别用 XF 五折的官方 val 选 w**
（那是样本内的，val 0.90~0.96 vs test 0.79）。
回给上位机的 `pred/prob/top-k` 都是融合后的结果；控制台同一行会额外打出 XF 和 PL
各自的 top1。

### 失败语义

| 情况 | 行为 |
|---|---|
| `pl.enable=false` / 配置里没有 `pl:` 节 | 完全不碰 `/dev/mem`（XF 也起不来，因为它吃 dma2） |
| 启动时 `pl_dma_io_open` 或 LCWT 头打开失败 + `required=true` | 直接退出 |
| 同上 + `required=false` | 打 error，程序继续；没有 eq 就没有 XF |
| 单帧 PL 头失败 + `fallback_to_xf=true` | 本帧只用 XF 结果 |
| 单帧 PL 头失败 + `fallback_to_xf=false` | 本帧回 `status=Error`，不拿 XF 冒充融合 |

汇总里打印 **XF(一折) / PL / EX / 最终** 的 top1，以及 PL 参与/失败、eq 不可用、
专家不可用的帧数。`最终` = 部署口径（三路优先、专家缺了退两路），并单独给出只用
三路那些帧的 top1。

### 专家模型只吃 193 维里的 165 维

dma3 的 193 维 = fft128 + wavelet10 + **const28** + cumulant12 + cfo9 + power6。
其中 const 组（幅度/相位直方图，第 138..165 维）是 PL 定点算的，实测没有信息量：
去掉后重训 test **0.7257**，带上反而 0.7153（其余 5 组与 float 探针等价：
非 const 定点 0.7311 ≈ float 0.7313）。所以部署图只吃 165 维，PS 侧按
`src/expert_norm_fp16.h` 里的 `kExpertSrcIdx` 从 193 维里挑，再补零到 256。

配套模型是 **`imodel/expert/expert_mlp_165_fp16_ZG.{json,raw}`**（165→256→128→20，
fp16，C=16）。旧图 `expert_mlp_20cls_fp16_ZG` 还在，但配置已指向新名字 ——
两者输入都是 `[1,256]`，换错**不会报错**，只会静默掉精度。

### 和 HLS 的关系（只读）

本工程**不修改** `FPAI_PL/` 下任何文件。四 DMA 版的驱动 `pl_dma_io.c/.h`
已**拷贝**到 `third_party/pl_dma_io/`，唯一的改动是把上游写死的 20 ms 收后等待
改成编译期宏 `PL_DMA_POST_MS`（默认 0；上游每帧 2 次 xfer + eq/专家各一次接收，
20 ms 会变成 ~80 ms/帧）。要恢复上游行为就加 `-DPL_DMA_POST_MS=20` 重编。
来源与差异见 `third_party/pl_dma_io/SOURCE.txt`；CMake 编的是这份拷贝，
**不跨工作区取源文件**。`-DENABLE_PL_CNN=OFF` 可关掉 PL 通路只编主干。

⚠️ **权重、IP、bitstream 是三件事**：PL 侧改了网络（比如这次裁掉 MLP/head、
dout 改成 304 拍）之后，必须重跑 csynth → export IP → 综合/实现，否则板上跑的
还是旧 IP。启动日志里的 `weights=<yaml 里的 hash>` 只能和 YAML 对账，
**不能探测板上的 bitstream**。dma3 的 `EXF1` magic 校验才会真正暴露
「驱动/PL 版本不匹配」——收不到 magic 时日志会直接报。

---

## 四、构建

### 两种主机：板子上原生编，或 x86_64 上交叉编

两种主机都用 `bash build.sh`：**板子上原生编**，或 **x86_64 上交叉编**。

demo 的实际构建产物就是在板子上原生编的。板端需要 iCraft SDK 3.36.1
（我们的 ZG json 就是 v3.36.1 生成的；`exp_wide_ls_ZG.json` 的 `compile_target` 是
**413 `@zhuget(330)` + 2 `@hostt`**，没有 `@buyit`）。

#### x86_64 主机（PC / docker）：自动交叉编译

`uname -m` 不是 aarch64 时，`build.sh` 自动带 `cmake/toolchain-aarch64.cmake`，
用 `aarch64-linux-gnu-g++` 编。先装工具链：

```bash
apt-get install -y g++-aarch64-linux-gnu
# 工具链前缀不是 aarch64-linux-gnu- 时：CROSS_PREFIX=aarch64-none-linux-gnu- bash build.sh
```

**交叉编译在这儿不是可选项**，因为板端 iCraft SDK 只带 aarch64 那一套 cmake targets。
iCraft 的 `*-config.cmake` **不看编译器，只看 `CMAKE_SYSTEM_PROCESSOR`** 挑 targets
文件（`icraft-utils-config.cmake:28-40`，每个包的 config 都是同一套 `if`）：

| 条件 | 挑中的文件 |
|---|---|
| UNIX + `aarch64` / `arm64` / `armv*` | `icraft-*-targets-aarch64.cmake` |
| UNIX + 其它（x86_64） | `icraft-*-targets-x64.cmake` ← **板端 SDK 里没有** |
| WIN32 | `icraft-*-targets-win.cmake` |

所以在 x86_64 上原生 `cmake` 一定停在：

```
CMake Error at /usr/cmake/icraft-utils-config.cmake:32 (include):
  include could not find requested file: /usr/cmake/icraft-utils-targets-x64.cmake
```

demo 的绕法是在 CMakeLists 的 UNIX 分支里硬写 `SET(CMAKE_SYSTEM_PROCESSOR aarch64)`
（`PLin+SingleNet+HDMI/CMakeLists.txt:110`）。那句话在 `project()` **之后**才执行 ——
骗得过 config 文件，**改不动编译器**：编出来还是 x86 目标文件，链 `libfmt.a` /
`libyaml-cpp.a` / iCraft 的 arm64 库时会撞 `file format not recognized`。
正确位置是 toolchain 文件，本仓库放在 `cmake/toolchain-aarch64.cmake`，`build.sh` 自动带。

另外 `deps/thirdparty/a/` 只有 aarch64 的静态库，`thirdparty/lib/` 是 Windows 的 `.lib` ——
**没有 x86 Linux 的库**，所以本仓库不支持在 PC 上原生编出能跑的版本（想这么做要另配一套
x86 deps + x64 SDK）。交叉编出来的 `rffi_deploy` / `preprocess_check` 都是 aarch64，
**本机跑不了**，要拷到板子上跑；第 0 步的本地自检要么在板子上跑，要么拿主机 g++ 单独编：

```bash
g++ -std=c++17 -O2 tools/preprocess_check.cpp -o /tmp/preprocess_check   # 不依赖任何第三方库
```

**用 `build.sh`** —— 它把 deps / iCraft SDK / cmake 都自动找出来，找不到就给明确提示：

```bash
cd impl_fpai_app
bash build.sh                                  # 自动探测，默认 TARGET_CHIP=ZG（30TAI）
bash build.sh -d /root/fpai_demo_app/deps -p /usr   # 装的位置不标准就显式给
bash build.sh -c ZG -j 4                       # 换芯片 / 限并发
bash build.sh --clean                          # 删掉 build/ 重来
```

用 `bash build.sh` 而不是 `./build.sh`：本仓库 `core.fileMode=false`，所以 git **不记录
可执行位**，脚本从 Windows 提交、在板子上 clone 出来会是 644。想修就用
`git add --chmod=+x build.sh` 提交，或者直接在板上 `chmod +x build.sh`。

自动探测的搜索范围（找不到才报错，报错里会说清找过哪些地方）：

| 找什么 | 顺序 |
|---|---|
| `cmake` | `$PATH` → `/usr/cmake/bin` → `/usr/local/cmake/bin` → `/opt/cmake/bin` → `/usr/bin` |
| `deps`（要含 `thirdparty/include`） | `../deps` → `../fpai_demo_app/deps` → `~/fpai_demo_app/deps` → `/root/…` → `/opt/…` |
| iCraft SDK（要含 `cmake/icraft-<backend>-config.cmake`） | `/usr` → `/usr/local` → `/opt/icraft` |

都能用同名环境变量覆盖：`CMAKE` / `DEPS_DIR` / `ICRAFT_PREFIX` / `TARGET_CHIP` / `JOBS` /
`CROSS_PREFIX`。

懒得用脚本的话，等价的裸 cmake 是：

```bash
cd impl_fpai_app
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DTARGET_CHIP=ZG \
      -DDEPS_DIR=<fpai_demo_app>/deps \
      -DCMAKE_PREFIX_PATH=/usr \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-aarch64.cmake   # x86_64 主机上必须带这一行
cmake --build build -j
```

（板子上原生编就去掉 `-DCMAKE_TOOLCHAIN_FILE` —— 主机本来就是 aarch64，
`CMAKE_SYSTEM_PROCESSOR` 自然对得上，SDK 会挑到 `-targets-aarch64.cmake`。)

（CMakeLists 里也给 `CMAKE_BUILD_TYPE` 兜了个 Release 默认值 —— 不给的话 CMake 一个 `-O`
都不加，编出来是个没优化的二进制。）

### Windows（x86，**没验证过**）

```powershell
cmake -S . -B build -DTARGET_CHIP=ZG -DICRAFT_ROOT="C:/Icraft/CLI v3.36.1"
cmake --build build --config Release
```

`find_package` 的包名与 iCraft 安装目录 `cmake/` 下的文件名是对得上的
（`Icraft-BuyiBackend` → `icraft-buyibackend-config.cmake`，CMake 会试小写形式），
导入目标 `Icraft::BuyiBackend` / `Icraft::HostBackend` / `Icraft::ZG330Backend` 也都
确实存在（已核）。但**这台 PC 上既没有 cmake 也没有 MSVC，所以 Windows 分支从没编过**。

路径都是 **CWD 相对**（demo 也是这个约定），所以必须从 `impl_fpai_app/` 下运行：

```bash
./build/rffi_deploy configs/rffi_transformer.yaml
```

---

## 五、上板步骤（按顺序，别跳）

### 先用 `run.sh` 把进程管起来

板端别手敲 `nohup`，用仓库根的 `run.sh`：它负责切模式、起停、日志、pid。

```bash
bash run.sh start tcp        # 网口模式：等上位机连 <板子IP>:9527
bash run.sh start file      # 离线帧流模式：读 samples/frames.bin
bash run.sh status          # pid / 运行时长 / 监听端口 / 最近日志
bash run.sh log -f          # 跟日志
bash run.sh stop            # 优雅退出（SIGTERM，10 s 不退再 KILL）
bash run.sh restart tcp     # 改完配置/换二进制后重启
```

可选覆盖（只影响本次，不改 `configs/` 里的源文件）：

```bash
bash run.sh start tcp --port 9600 --topk 3
bash run.sh start file --file samples/frames.bin --idle 3000
bash run.sh config           # 看本次真正生效的 run/active.yaml
```

它做的事：把 `configs/rffi_transformer.yaml` 拷成 `run/active.yaml` 再按参数覆盖那几行，
然后 `cd` 到仓库根目录启动（配置里的路径都是 CWD 相对）。日志在 `run/rffi_deploy.log`，
上一轮的留成 `.prev`。启动后 2 秒内挂掉会直接把日志尾巴打出来。

**第 0 步：本地离线自检（不需要板子）**

```bash
# 默认读 ../Transformer_Train/data_cache_20cls（20 类标签，labels 0..19）
../Transformer_Train/transformer_4_rf/Scripts/python.exe tools/send_iq.py \
    --n 32 --dump-frames samples/frames.bin
./build/preprocess_check samples/frames.bin samples/preprocess.raw
./transformer_4_rf/Scripts/python.exe tools/check_preprocess.py
```

三条独立路径过同一批数据：`send_iq.py` 编码 → `preprocess_check`（C++）解帧+归一化 →
和 `IQDataset`（训练时真正喂给模型的那条路）对答案。

**这一步已经跑通了**，实测最大绝对差 **2.384e-07**、逐位相同 52.06%、mean/std 六位小数
全同。残差正是 float32-vs-double 求和顺序差，比量化步长 0.0337 小 5 个数量级。

**第 1 步：离线帧流（绕开网络）** — 把 `configs/rffi_transformer.yaml` 的 `input.mode`
改成 `file`，板端跑：

```bash
./build/rffi_deploy configs/rffi_transformer.yaml
```

应逐帧打印 top-1。**这一步不通就别碰 socket。**

**已实测（ZG330 / 32 帧 / file 模式）**：32 行全部打出、`top1 = 71.88%`、
`0.90 ms/帧`（其中含「两枪」的那一次多余前向，见坑 9）。

**第 2 步：对拍** — 判「部署链是对的」的唯一硬证据：

```bash
./transformer_4_rf/Scripts/python.exe tools/send_iq.py --host <板子IP> --n 256 \
    | tee samples/board.log
./transformer_4_rf/Scripts/python.exe tools/check_roundtrip.py --board-log samples/board.log
```

| 读数 | **本 32 帧样本实测（ZG330 板端）** | 全测试集参考（host backend） |
|---|---|---|
| PyTorch fp32 top1 | 75.00% | 62.50% |
| 板子 top1 | **71.88%**（Δ = −3.12） | ≈ 62.11% |
| **argmax 一致率** | **87.50%** | ≈ 87.50% |

32 帧样本的 top1 天然高于全测试集（`send_iq.py` 是等距抽样，样本里简单类更多）。
**判对错看一致率，不看 top1 的绝对值**：它精确落在 87.50%，即板子和 fp32 只有
4/32 帧 argmax 不同 —— 这就是量化本身的代价。

**期望的不是 100%。** 主机上 INT8 与 fp32 的 argmax 一致率本来就只有 87.5%，
对到 ~87% 才算对；对到 100% 反而要怀疑是不是拿了同一份结果在比。

**第 3 步：实时性** — `profile: true` 下看每帧 forward 耗时。主机 csynth 参考是
2,590 拍/帧 ≈ 13 µs，但那只是 PL 部分，端到端以板端实测为准。

PL 一帧的总延迟几乎全是驱动的固定等待，不是模型算得慢：每次 `xfer`/`eq_recv`
收完都要 `msleep(20)` 再读 DDR，而 `eq_drain` 以 **300 ms 空读超时**收尾。
所以「5 个平移」时，每个非 0 平移若走 `eq_drain` 就是 +300 ms，4 个就是 +1.2 s
（板上实测 1.4 s/帧就是这么来的）。现在非 0 平移改用 `eq_recv`（约 20 ms）把
eq 收走再丢弃，只在短收时才退回 `eq_drain`。还想再快就把 `pl.tta_shifts`
改成 `[0]`（约再省 4 次 xfer）。

**PL 第二轮和 XF 并行**（`pl.overlap_xf: true`，默认开）。第一轮 8 份 shift 0
出 eq 后，第二轮（4 个非零平移，~1.9 ms）丢到工作线程，主线程同时跑 XF
（~7.8 ms），融合前 join。XF 只依赖第一轮的 eq，所以两路没有数据依赖。
单帧预期从 11.61 ms 降到 ~9.7 ms。`overlap_xf: false` 一键退回串行；
首帧日志会打 `PL 两轮：并行/串行`。

**五折合成一张图**（`xf.fused_folds: 5`，默认开）：五折的权重不同，不能靠 batch
共享，所以图里放了 5 份网络（`Slice` 切行 → 5 个网络 → `Concat`）。输入
`[25,2,256]`、输出 `[25,20]`，一帧一次前向（之前 5 次）。省的是每次调用的固定开销
（reset / 提交 / `.to(Host)`）。产物 `imodel/xf20/fused_b25_ZG.*`，
与五张 b5 图数值逐位一致。`fused_folds: 0` + 解开 `xf.models` 的五张图可回退。

**跨帧流水**（`pl.cross_frame: true`，默认开）：上面那条只藏住了第二轮，
第一轮（A，~2.25 ms）还在关键路径上——XF 要等它的 eq。但 A、B 都不依赖 XF，
所以把**整轮 PL** 丢到工作线程，和**上一帧**的 XF 并行：

```
[PL(N) 整轮] ∥ [──── XF(N-1) ────] → 出 N-1 的结果 → [PL(N+1)] ∥ [XF(N)] → ...
```

稳态每帧周期 = `max(PL, XF)`，PL 的 ~3.7 ms 全部藏进 XF 的 ~6.8 ms。
代价是每个结果的「收到→出结果」多一帧流水延迟，所以日志里 `ms` 是**帧周期**、
`lat` 是**真延迟**；汇总里两个都打。eq 在 `infer_a` 里已拷进 `PlResult`，
工作线程下一帧再写 `eq_buf_` 不会串帧；PL 用的是 PL DMA、XF 用 NPU，互不等待。
`cross_frame: false` 一键退回上面 `overlap_xf` 那条老路径。

预取有硬规矩：**只在下一帧整帧已经在内核缓冲里时才提前收**（`FrameSource::next_frame_ready()`，
TCP 用 `FIONREAD` + `MSG_PEEK` 验头）。否则先出本帧结果、出完再阻塞收帧 ——
上位机若是「发一帧等一帧」，一边等帧一边等结果会互等死锁。

三者叠加后的实测：整帧 26.35 → 11.61（batch=5）→ 10.45（PL 并行）→ 9.08（fused）→
**7.52 平均 / 7.36 p50**（cross_frame，32 帧）。并发下 XF 从 6.76 慢到 7.19（DDR/AXI
抢带宽），周期基本就是 XF + 收尾开销。单帧真延迟 14.61 ms（二级流水）。
汇总不再打单折准确率（板端验收只看 XF / PL / 融合三个数）。

---

## 六、踩过的坑（都写进代码注释了）

1. **`mmuMode` 必须 true，且不能调 `compressFtmp()`/`speedMode()`。**
   编译期已经把 569 个算子（563 `@buyit` + 6 `@fpgat`）合并成 13 个 HardOp，
   mmu 模式下运行期再合并会**直接抛异常**。
   本程序不调这两个。`mmuModeSwitch()` 只在 `USE_BUYI_BACKEND` 下调 ——
   ZG330 的设备类**没有这个方法**（它叫 `setMMUMode`），demo 自己也是 `#if` 掉的。

2. **deps 里没有 `fmt/` 头。** `deps/thirdparty/include` 下有 `spdlog/` 和 `yaml-cpp/`、
   `opencv2/`…，但**没有 `fmt/`**（只有 `fmt.lib` / `libfmt.a`）。所以源码里写的是
   `<spdlog/fmt/fmt.h>` 而不是 `<fmt/format.h>` —— 后者会静默落到 icraft 安装目录自带的
   那一份上（一个没写进 CMake 的隐式 include 路径）。两份 fmt 都是 8.1.1、
   include guard 都是 `FMT_CORE_H_`，所以不会重复编译，但别去碰这个运气。
   demo 的 CMakeLists 里也有这个不存在的 `include/fmt` 路径，照抄只会掩盖问题。

3. **每帧那行输出必须是裸消息。** 用 `spdlog::info` 会带 `[时间] [info]` 前缀，
   `tools/check_roundtrip.py` 的 `^seq …` 正则就匹配不上。所以逐帧行走 `fmt::print`。

4. **`Device::cast<T>()` 返回的是句柄的值拷贝**（`icraft-xir/base/any.h`）。
   和 demo 一样存成具名变量再交给 `Session` —— 改动落在同一个底层设备上。

5. **硬件 forward 的第一次**：主机上只有 mock（明确不支持 forward），所以本仓库最初的
   62.11% 是 **host backend** 跑出来的。第一次真正上板（ZG330）时前向路径是全新的 ——
   也正是这一步暴露了坑 9 和坑 10。现在已跑通：`71.88%` / 一致率 `87.50%`。

6. **`reset(1)` 必须调在 `cast<FPAIDevice>()` 的句柄上，不是基类 `Device` 上。**
   demo 的 actor 里 `device_` 的类型是 `FPAIDevice&`，所以 `device_.reset(1)` 打的是
   ZG330 设备句柄。顺序也照 demo（`yolov5_npu_actor.hpp` + `postprocesses.hpp`）：
   `forward` → 逐输出 `waitForReady(10000)` → `fpai_device.reset(1)` → `.to(Host)` → 读。
   在基类句柄上调 reset 时，板上表现为**下一折 forward 直接卡住**（第一折输出正常，
   第二折不出结果）。时机由 `xf.reset_mode` 控制：`fold`（默认，每次前向后 reset）/
   `frame`（一帧所有前向做完后 reset 一次）/ `off`。换模式不用重新编译。
   fused 图一帧只有一次前向，`fold` 与 `frame` 等价。
   `xf.double_forward` 默认 **false** —— reset 非 off 时不需要双前向。

7. **类名与类别下标**：`names/class_names.txt` 第 k 行 = 类别 k，来自
   `data_cache/meta.npz:class_names`，是 `['1-1','1-10',…,'9-7']` 这样的 150 个名字，
   **不是** `0..149`。只影响显示，不影响 argmax。若文件缺失，只打裸下标。

8. **`find_package(Icraft-*)` 报 `include could not find requested file:
   .../icraft-utils-targets-x64.cmake`**，不是 SDK 装漏了。SDK 按 `CMAKE_SYSTEM_PROCESSOR`
   挑 targets 文件，板端包只有 aarch64 那套；x86_64 主机上必须交叉编译
   （`cmake/toolchain-aarch64.cmake`，`build.sh` 自动带）。demo 里那句
   `SET(CMAKE_SYSTEM_PROCESSOR aarch64)` 写在 `project()` 之后，只按得住这一处报错，
   改不动编译器 —— 照抄过去下一步会在链接期炸。详见「四、构建」。

9. **`session.forward()` 迟一拍 —— 板端实测，最反直觉的一条。**
   用常量输入连喂 5 次（zeros, zeros, ones, ones, zeros）把语义测出来：
   `A = B = C = f(zeros)`、`D = E = f(ones)`，即第 k 次 forward 算的是**第 k−1 次
   write 进去**的数据。表现就是「第 i 帧的预测 == 第 i−1 帧的标签」：top1 = 0%、
   argmax 一致率 0.00%，而把两边错开一帧比就命中 23/32。

   曾经的工作区是「连打两枪取第二枪」，但真正的原因是少了 `device.reset(1)`。
   照 demo 的顺序写就一枪对一帧：`forward` → `waitForReady` → `reset(1)` → 读。
   反面教材（都踩过）：
   - 每帧新建 host Tensor 直接 `forward` → 迟一拍，且 `forward` 之后那个 Tensor 的
     内存块会被改绑到设备侧，复用它就读到不再更新的旧缓冲（所有帧输出同一个常数）；
   - 漏了 `reset(1)` 直接读 → 输出滞后，且会读到未落盘的脏数据（NaN）。

10. **forward 的输出不能直接 `.cptr()`。** 输出落在 PL-DDR 上，那个 `MemPtr` 是
    `PtrType::ADDR`（只有物理地址），`cptr()` 按设计抛 `The MemPtr is of ADDR type!`
    （`device.cpp:56`）。先 `.to(icraft::xrt::HostDevice::MemRegion())` 搬一份到 host
    再读 —— demo 的 `postprocesses.hpp:153` 就是这个写法。

---

## 七、还没验证的部分（诚实清单）

| 项 | 状态 |
|---|---|
| C++ 预处理 vs `IQDataset` | ✅ 跑通，最大绝对差 2.384e-07 |
| 两个 TU × 两个芯片分支的**语法/类型**检查 | ✅ 用 GCC + MSVC 垫片跑过，0 错 0 警 |
| `build.sh` 的探测/报错/参数校验 | ✅ 各条错误路径都跑过（拿假 cmake 走完全程） |
| `rffi_deploy` 的**编译+链接** | ✅ x86_64 交叉编（`build.sh -c ZG`），产物是 aarch64 ELF |
| BY（100TAI）硬件前向 | ❌ 没有 BY 板子；本仓库实际部署目标是 ZG330 |
| ZG330 模型 | ✅ `imodel/exp_wide_ls_ZG.*` 已生成（413 `@zhuget(330)` + 2 `@hostt`，无 `@buyit`）；Host 后端核 quantized 图 **62.11% vs fp32 62.50%**，argmax 一致率 88.67% |
| **ZG330 硬件前向** | ✅ 上板跑通：32 帧 `top1=71.88%`（fp32 75.00%，Δ=−3.12）、**argmax 一致率 87.50%**、0.90 ms/帧（两枪，见坑 9） |
| 四 DMA 版 PS 代码（token 解包 + NPU 头 + eq + 专家） | ✅ 已实现，aarch64 交叉编译通过；**还没上板跑过** |
| PL 与 iCraft **同时**占用 PL 资源 / DMA 地址 | ❌ 没验证；两套地址/中断若有冲突，先在配置里改 `pl.dma0_base` 等 |
| dma1 的 1216 B / dma3 的 `EXF1` 在板上对拍 | ❌ 待验证；对不上先看 `[PLHASH]` 指纹和专家的 magic 报错 |
| Windows `find_package(Icraft-*)` | ❌ 从没解析过 |

「语法检查用 GCC + MSVC 垫片」具体是：vendor 头是给 MSVC 写的（`_declspec`、全局
`nullptr_t`、非严格模式下的 `##__VA_ARGS__`），所以要
`-std=gnu++17 -D_declspec(x)= -D__declspec(x)= -include <补 nullptr_t 的垫片>`。
**这只证明签名/头文件引用是对的，不能替代真正的编译链接。**
