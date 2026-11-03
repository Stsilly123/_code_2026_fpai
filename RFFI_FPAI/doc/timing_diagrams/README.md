# Signal_process 时序图与系统结构图

Visio 风格的 SVG，覆盖整条 PL 信号处理链、四个子模块、上下位机通信帧结构、
上位机软件总体结构、PL-DMA 零拷贝引擎的收发调度与内存映射，以及 PS 侧预处理与
三路融合流程。全部由 `gen_timing_svgs.py` 生成，不依赖任何 Python 第三方库。

| 文件 | 内容 | 坐标 |
|---|---|---|
| `00_system_timing.svg` | Signal_process 整链路：一轮 8 帧 = 812.8 µs，三路并行 + 三个 S2MM | 0…812.8 µs |
| `01_stream_buf_timing.svg` | stream_buf：64 bit beat → 两个 33 bit 字、隔拍握手、256 字强切帧 | 0…16 拍 + 帧边界放大 |
| `02_lcwt_hls_timing.svg` | LcwtMLP_RFFI（HLS）：一次 ap_start 吞 8 帧，输出 8×304 拍 | 0…140k 拍 |
| `03_expert_timing.svg` | expert_feat_rffi：12 个 FSM 状态、输入环、双 bank、256 字输出 | 0…20,320 拍 |
| `04_lstf_eq_timing.svg` | lstf_eq：14 个 FSM 状态、共享 MAC/移位器、FIR 期每 24 拍推 1 字 | 0…20,320 拍 |
| `05_frame_format.svg` | 上下位机通信帧结构（图 2-6）：请求 32 B 头 + IQ 负载、结果 40 B 头 + k×8 B 条目、控制命令与 CommandAck | 字节偏移 |
| `06_host_arch.svg` | 上位机总体结构（PySide6）：IQSource 三种数据源、定时器发送节拍、组帧 / BoardLink::send、结果拆包与 seq 在途窗口匹配、自动重连 / 背压保护、六张界面卡片 | 无（框图） |
| `07_dma_arch.svg` | PL-DMA 多通道零拷贝引擎：初始化 4 步、单轮 8 帧收发 6 步、四路 DMA 分工与硬约束、udmabuf0 128 KB 内存布局 | udmabuf0 字节偏移 |
| `08_ps_fusion.svg` | PS 侧预处理与三路融合（按文案）：Q10 量化下发、均衡 IQ 中值 / 反量化 / 5 平移 → Transformer、token Q4 与 PS 补归一化、专家特征归一化 / 钳位 / 补零、三路概率取对数 → 权重线性加权 → Softmax | 无（框图） |

同目录的 `.png` 是预览图（headless Edge 渲染），方便快速查看；正式插图用 SVG。

## 怎么用

- **Visio**：`插入 → 图片` 选 SVG（Visio 2016 及以上），或直接把 SVG 拖进画布。
  导入后是一个组合，取消组合即可改文字、挪标注。整图按 1240 px 宽绘制。
- **浏览器**：直接打开 SVG 也可以，矢量缩放不糊。
- **改图**：编辑 `gen_timing_svgs.py` 里对应函数，然后

  ```bash
  python gen_timing_svgs.py
  ```

  重新生成全部九个 SVG。脚本只写同目录下的文件，不碰 RTL/约束。

## 数据口径

- 时钟 200 MHz，1 拍 = 5 ns；一帧实时预算 101.6 µs = 20,320 拍。
- **expert**：一帧 ≈18,877 拍 ≈94.4 µs。状态拍数是按 RTL 计数器取的标称值：
  ZN 990 / LNRMS 47 / FFT 6314 / DWT_I 750 / DWTF_I 40 / DWT_Q 750 /
  DWTF_Q 40 / HIST 700 / CUM 3900 / CFO 4300 / POW 790 / PACK 256。
  输出 256 字（1024 B），字 0…196 有效、197…255 补 0，TLAST 在第 255 字。
  数据来源：`SRC/pl_ai/expert/expert_feat_rffi.v` 的 FSM 与输出引擎。
- **lstf_eq**：每段取 RTL 计数上限合计 14,202 拍（71 µs），标称 ≈11k 拍（55 µs）。
  ATAN / NORM / RECIP / IDFT 的扫描与牛顿迭代长度随数据变化，所以图上同时标了
  “上限”和“标称”；FIR 期每 24 拍往输出 FIFO 推一个字，TLAST 在 fn==255。
  数据来源：`SRC/pl_ai/lstf_eq.v`；最差路径取自
  `RFFI_FPAI.runs/impl_1/ai7030_edif_top_timing_summary_routed.rpt`
  （`rr_reg[0] → scan_v_reg[33]`，4.865 ns，WNS +0.008 ns）。
- **HLS**：一次 ap_start 处理 8 帧，延迟 34,081…134,433 拍（数据相关）；
  每帧输出 304 拍（1216 B，TLAST 在第 303 拍），8 帧共 9728 B。
  数据来源：`HLS/LcwtMLP_RFFI/IP交付说明.md`、`Signal_process.v` 的 ap_start 逻辑。
- **帧结构（05）**：字段字节宽度文案里没有给，按总长 32 B / 40 B 自洽分配（均为小端序）：
  请求头 magic 4 / version 2 / dtype 2 / label 4 / seq 4 / n_complex 4 / value_scale 4 /
  timestamp_ns 8；结果头 magic 4 / version 2 / status 2 / seq 4 / label 4 / n_result 2 /
  top-1 2 / confidence 4 / latency_us 4 / reserved 4 / timestamp_ns 8。
  IQ 负载 = n_complex × 4 B（I、Q 各 int16 交错），与现有 MM2S 一次 8192 B = 2048 复样点吻合；
  top-k 条目 = class_id u16 + 保留 2 B + score float32。**宽度若与真实协议不同，改这里的表即可。**
- **DMA 引擎（07）**：偏移与字节数全部取自 `sw/pl_dma_io/pl_dma_io.h`，不取参考图：
  udmabuf0 `MAP_LEN = 0x20000`，`0x00000` MM2S 描述符（64 B）、`0x00100` S2MM 环（8×64 B）、
  `0x01000` SRC、`0x10000` DST/dout、`0x1BB00` 排空角落（1216 B，三路共用）、
  `0x1C000` EQ、`0x1E000` EXP；dma0 MM2S 8192 B、dma1 dout 9728 B = 8×1216 B、
  dma2 / dma3 各 8192 B。超时为单次 5 s、整轮 15 s（`cfg.timeout_ms` / `total_timeout_ms`）。
  描述符区按比例不可见，图上用放大示意块单独画出。
- **PS 融合（08）**：只画“PS 侧按序完成以下处理”那段文案里的环节，不展开 PL 侧支路、
  融合权重数值与专家 MLP 结构；融合节点按文案写“三路输出概率”，本段只描述了两路的
  PS 侧预处理，第三路未画出。文案未给出的两处——`Q4` token 的反量化系数、
  “逐元素取中位数”的具体维度——图上只写操作名。
- **stream_buf**：128 beat = 256 字 = 1 帧；`s_tready = ~full & ~pending & ~padding`，
  因此 beat 隔拍接收；帧边界由 256 字计数强切，不等 tlast。
  数据来源：`SRC/pl_ai/stream_buf.v`。

## 画法上的约定

- 时钟在压缩轴上无法逐拍画出，统一用“200 MHz 连续”的虚线带表示；
  只有 01 的 16 拍视图按真实方波画。
- 1 拍宽的脉冲在压缩轴上小于 1 px，凡属这种情况都改用竖线 + 文字标注
  （例如 TLAST、wr_done、nfull 的 1→0）。
- 颜色沿用 Visio 默认主题：蓝=输入/时钟，绿=有效/完成，橙=输出/反压，
  紫=第二路输出，黄=判决/窗口。
