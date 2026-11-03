# 专家特征提取（193 维）PL RTL 交付说明

纯 PL RTL 实现，输入直接抽 `Signal_process.v` 里 HLS 的那路样点流（`hls_din[31:0]` /
`hls_wr`），输出 32-bit AXI4-Stream，每帧 256 字、word 255 带 TLAST，接到新增的
AXI DMA S2MM 上。不含 MLP/NPU/PS 解析。

---

## 1. 数据契约

### 输入
- 抽头点：`Signal_process` 里 `hls_din[31:0]` / `hls_wr`，与 `lstf_eq` 同一个源（`stream_buf` 输出）。
- 每个字 `{Q[15:0], I[15:0]}`（高 16 位 Q，低 16 位 I，16-bit 有符号）。
- 256 字/帧，HLS 一次调用 8 帧；`din_last`（`hls_din[32]`）只用来重同步字计数。
- 模块内部锁 `clk = sclk = 200 MHz`。

### 输出（AXIS，`m_tdata[31:0]`，`m_tkeep = 4'hF`）
每帧 256 个 32-bit 字，**word 255 上 TLAST**，一次 HLS 调用输出 8 帧 = 8192 B。

| 字 | 内容 |
|---|---|
| 0..127 | FFT 对数幅度（去均值），Q12 |
| 128..132 | DWT I 通道 cA4, cD4, cD3, cD2, cD1 |
| 133..137 | DWT Q 通道 cA4, cD4, cD3, cD2, cD1 |
| 138..153 | 幅度直方图 16 格（计数 ×16） |
| 154..165 | 相位直方图 12 格（计数 ×16） |
| 166..171 | 累积量模 c20, c40, c41, c42, c60, c63 |
| 172..177 | 累积量相角 |
| 178..186 | CFO [ang20, mag20, ang1, mag1, b0, b1, b2, b3, bstd] |
| 187..192 | 功率 [log_rms, std_az, mean_az3, mean_az4, mean_x, mean_q] |
| 193 | 帧头 `0x45584631`（"EXF1"） |
| 194 | 版本 1 |
| 195 | 帧序号（8 bit，回绕） |
| 196 | 12 |
| 197..255 | 0 |

数值口径与 `tools/gen_expert_vectors.py` 的黄金模型一致（Q12；atan 区间 ±2 LSB）。

### 缓存与反压
- 输入：8 帧环形缓冲。处理不过来时**整帧丢弃新来的帧**，`stat_drop` 计数。
- 输出：2 个 bank 的乒乓缓冲。DMA 不取走时，处理会停在 `S_PACK`，输入环满后开始丢帧。
  → **PS 侧必须持续挂 S2MM**。
- 每帧处理预算约 101.6 µs（200 MHz 下 20,320 拍）；所有子模块共享一个 sqrt/atan/log2
  串行执行，仿真里 8 帧连续跑不丢帧。

---

## 2. 要加进 Vivado 的文件

### 2.1 设计源文件（13 个 .v + 1 个 .vhd）

全部在 `SRC/pl_ai/expert/` 下，**平铺添加，不要按目录递归把 tb/tools 加进来**：

```
ef_zn.v                归一化 + 帧统计
ef_sqrt.v              16 级流水整数平方根（自写 RTL，不用 CORDIC IP）
ef_log2lut.v           log2 LUT 查表（例化 log2_lut_rom IP）
ef_fft_log.v           例化 xfft_256 IP + 对数幅度
ef_dwt_db4.v           db4 4 级小波（单通道，I/Q 各跑一遍）
ef_dwt_feat.v          小波带能量 -> 对数特征
ef_hist.v              幅度/相位直方图 + az 矩
ef_cumulant.v          6 个复累积量
ef_cmul16.v / ef_cmul24.v   复乘小工具
ef_cfo.v               CFO 估计
ef_power.v             功率统计
expert_feat_rffi.v     顶层（FSM、RAM、AXIS 输出；直接例化 cordic_0 IP）
```

- **Verilog 头文件**：`expert_rom.vh` 被多个模块 `` `include ``。把它按
  *Verilog Header* 类型加进工程（Vivado 会自动把所在目录加进 include 搜索路径），
  或手动在 `Project Settings → Verilog Options → Include Files Search Paths` 里加
  `SRC/pl_ai/expert`。
- `cordic_vl.vhd` **不再需要**（早期绕 xsim 绑定问题的包装，现已改成直接例化
  `cordic_0`）。可以把它从设计源里移除；先刷新 module reference 再删，见 2.4。
- 平方根是自写的 `ef_sqrt.v`，不用 `cordic_sqrt` IP。

### 2.2 IP（已经在工程里，确认输出产品都已生成）

| IP | 配置 |
|---|---|
| `xfft_256` | xfft 9.1；256 点、`unscaled`、输入 16 bit、**输出位反序**（`bit_reversed_order`）、自动选实现、数据存 BRAM |
| `cordic_0` | cordic 6.0；`Arc_Tan`、Parallel、SignedFraction、16 bit 输入/输出、粗旋转开、无缩放补偿、NonBlocking |
| `log2_lut_rom` | blk_mem_gen；Single_Port_ROM、1024 深 × 36 宽、`log2_lut.coe`、Port A 输出寄存 |

- 三个 IP 都要 `Generate Output Products`（OOC 综合也依赖它们）。
- `log2_lut_rom` 的 `.coe` 路径在 xci 里写死为
  `../../../../SRC/pl_ai/expert/log2_lut.coe`（相对 IP 目录 → 仓库根），
  **`log2_lut.coe` 不能挪位置**。
- `expert_feat_rffi.v` 直接例化 `cordic_0`（IP 生成的顶层实体），所以
  `cordic_0` 的 output products 必须完整生成。

### 2.3 `Signal_process.v`

已经在工程里（`$PPRDIR/SRC/pl_ai/Signal_process.v`），已加好：

- 端口：`expert_TDATA/TVALID/TREADY/TKEEP/TLAST`（AXIS 接口名 `expert`，
  `FREQ_HZ 200000000`）、`expert_stat_drop[31:0]`、`expert_stat_frames[31:0]`、`expert_busy`。
- 例化：`expert_feat_rffi u_expert`，输入接 `hls_din[31:0]` / `hls_wr` / `hls_din[32]`。

BD 里的 module reference 在打开 BD 时会自动刷新出这些新端口（必要时右键
*Refresh Module Reference*）。**不要手改 `ps_ai.bd` / `ps_ai_wrapper.v` /
`ps_ai_Signal_process_0_0` 目录下的生成物**。

### 2.4 module reference 必须刷新（否则综合报 cordic 的 VHDL 错误）

BD 的 module reference 会生成一个独立的 OOC 综合跑（`ps_ai_Signal_process_0_0`），
它的文件表是**按 Verilog 里出现的 IP 名**扫出来的：`xfft_256`、`log2_lut_rom`、
`LcwtMLP_RFFI_0`、`fifo_generator_hls` 都在，但 `cordic_0` 以前只在
`cordic_vl.vhd` 里以 `entity cordic_v6_0_14.cordic_v6_0_14` 的库级形式出现，扫描器
看不到 → 那次跑没有 `read_ip cordic_0.xci` → `cordic_v6_0_14` 库不存在 →
`cordic_vl.vhd` 分析失败：

```
ERROR: [Synth 8-2398] near string "zynq" ; 6 visible types match here [cordic_vl.vhd:24]
ERROR: [Synth 8-2396] near character '1' ... [cordic_vl.vhd:36]
INFO:  [Synth 8-2810] unit cordic_atan_vl ignored due to previous errors
```

现在 `expert_feat_rffi.v` 直接例化 `cordic_0`（和 `xfft_256` / `log2_lut_rom` 一样），扫描器能认出来。
**改完 RTL 后要在 BD 里刷新一次 module reference**（打开 `ps_ai` BD → 右键
`Signal_process` 的 module reference → *Refresh Module Reference*，或对 BD 重新
*Generate Output Products*），确认生成的
`RFFI_FPAI.runs/ps_ai_Signal_process_0_0_synth_1/ps_ai_Signal_process_0_0.tcl`
里出现 `read_ip .../cordic_0/cordic_0.xci`，再综合。

---

## 3. BD 要做的改动（用户侧）

1. 打开 `ps_ai` BD → 让 `Signal_process` 的 module reference 刷新出新端口。
2. 新增一个 **AXI DMA**，只开 S2MM（或按现有 dout 的方式配）：
   - 数据宽度 **32 bit**
   - **Simple 模式**（不用 SG 也可以）——见下面的 TLAST 注意项
   - Buffer Length Register 至少要能表示 8192 B
3. 连接：
   - `expert_TDATA/TVALID/TLAST/TKEEP` → DMA 的 `S_AXIS_S2MM`（TDATA/TVALID/TLAST；
     TKEEP 若 DMA 侧没有对应端口可悬空，本模块固定 `4'hF`）
   - DMA 的 `S_AXIS_S2MM_TREADY` → `expert_TREADY`
   - DMA `s_axi_lite` 挂到 PS，`m_axi_s2mm` 挂到 HP 口（照 dout 那条）
   - `sclk` / `s_rst_n` 与 eq/dout 同一套
4. `expert_stat_drop` / `expert_stat_frames` / `expert_busy` 是普通输出（不在 AXIS
   接口里）：可以先悬空（会有 unconnected 警告），或引到 ILA/GPIO 观察丢帧。

### ⚠ TLAST 与 DMA 长度（重要）

本模块**每帧（1024 B）在 word 255 发 TLAST**，和 dout 的 684 B/帧 是同一口径。
板上已实测：S2MM 直读模式**遇到 TLAST 就结束一次传输**，`S2MM_LENGTH` 给大了也只收一帧。

所以 PS 侧要**按帧挂 8 次**（每次 `S2MM_LENGTH = 1024`，共 8192 B/次 HLS 调用），
和现有 dout（每次 684）的做法一致。

如果希望"一次挂 8192 B 收完 8 帧"，需要把 PL 改成**只在第 8 帧的 word 255 发 TLAST**
（帧内 256 字边界不变）——这是契约变更，要改 RTL + TB，说一声再做。

---

## 4. 验证结果

### 仿真（Vivado 2018.3 xsim）
- E2E：8 帧 × 256 字与黄金模型逐字比对，**0/256 越界**（atan 区间允许 ±2 LSB），
  `EXPERT E2E TB done: 0 errors`。
- 压力 TB：反压/断流/全零/满幅/直方图边界/相位 ±π/中途复位，6 帧
  `TLAST errors: 0`，`EXPERT STRESS TB done: 0 errors`。
- 覆盖：`SRC/pl_ai/tb/tb_expert_feat.v`、`tb_expert_feat_stress.v`；
  黄金向量由 `SRC/pl_ai/tools/gen_expert_vectors.py` 生成。

### OOC 综合 + 实现（默认流程）
`SRC/pl_ai/tools/ooc_expert_synth.tcl`：`synth_design -mode out_of_context` →
**默认** `opt_design → place_design → route_design`（没有 phys_opt / 激进 directive）。

| 项目 | 结果 |
|---|---|
| 时钟 | 200 MHz（5.000 ns），输入/输出各按 0.5 ns 外部延迟约束 |
| **布线后 WNS（带 0.5 ns 输入延迟）** | **+0.060 ns，TNS = 0，失败端点 0 / 41,151** |
| LUT | 14,380（LUT as Logic 13,676 + LUTRAM 704） |
| FF | 13,183 |
| DSP48E1 | 54 |
| BRAM | 5.5 |

> 前面一版带输入延迟的 WNS 是 **−0.797 ns / 74 个失败端点**，两类路径：
> 70 条 `din → 平方 → 40 bit 累加`（输入端口直接进 DSP）和 4 条
> `zn_ram → xfft 内部 FIFO`（BRAM 到 FFT 之间 3.5 ns 纯长线）。这次靠 RTL 修掉：
> - `expert_feat_rffi`：输入 `din/din_valid/din_last` 先打一拍（`din_r`），平方结果
>   再寄存一拍（`di2_r/dq2_r`）后下一拍才累加；帧尾的 `sum_x/sum_q/sum_sq` 写 RAM
>   整体后移一拍（`wr_done_d`），`nfull`/满判据同步改成延时后的口径。
>   代价是输入侧多 2 拍延迟，帧处理总时长 +1.3 µs（8 帧 749.6 µs，预算 812.8 µs）。
> - `ef_fft_log`：`zn_rdata` 先采到 `fft_dat` 再送 xfft（`rd_wait → rd_wait_q →
>   fft_vld`），每样点 3 拍（原来 2 拍）。
>
> 修完后最差路径不再是数据通路，而是 `rst_n` → `u_cum` 同步复位端（扇出 7814，
> 98.9% 是布线）。这是 OOC 把异步复位当 I/O 数据输入约束出来的产物；整版里
> `rst_n` 来自 BD 的 proc_sys_reset，不是外部 I/O，实际路径不同。

优化过程：路由后 WNS 从 −2.300（1959 个失败端点）逐步修到 +0.060，全部靠 RTL
（打断 DSP 输出→算术→DSP 输入的长链、运算操作数寄存、长累积拆两级、输入/FFT 前各插一级流水）。

**预算 vs 实际**：目标 LUT ≤12k / DSP ≤30 / BRAM ≤16，实际 14,380 / 54 / 5.5。
LUT 和 DSP 超预算，主要花在 6 个复累积量（`u_cum` 约 5k LUT）和两路并行小波/FFT 的
乘法器上。整版估算：LUT ≈70.0k/78.6k（89%）、DSP ≈346/400（86.5%）、BRAM ≈106/265
——能装下，但余量薄；整版 P&R 后要再确认一次时序。

> OOC 的数字只代表这个模块在 200 MHz、0.5 ns I/O 假设下的局部结果；整版实现会因
> 布局/拥塞/跨模块路径而不同。

---

## 5. 复现命令

```bash
# OOC 综合 + 默认实现（约 10 分钟），结果在 ef_ooc/
/d/Xilinx/Vivado/2018.3/bin/vivado -mode batch -source SRC/pl_ai/tools/ooc_expert_synth.tcl

# 查看结果
grep -A6 "Design Timing Summary" ef_ooc/timing_impl.rpt
grep -E "^\| (Slice LUTs|Slice Registers|Block RAM Tile|DSP48E1)" ef_ooc/util_impl.rpt
```

仿真（干净目录，xsim 的 work 库损坏时换目录重编可绕开）：

```bash
cd <空目录>
export PATH=/d/Xilinx/Vivado/2018.3/bin:$PATH
cp SRC/pl_ai/expert/*.v SRC/pl_ai/expert/*.vhd SRC/pl_ai/expert/expert_rom.vh .
cp SRC/pl_ai/tb/tb_expert_feat.v SRC/pl_ai/tb/tb_expert_feat_stress.v .
cp SRC/pl_ai/tb/vector/expert_in.hex SRC/pl_ai/tb/vector/expert_gold.hex .
cp -r SRC/pl_ai/tb/vector/synthetic .        # 压力 TB 用
cp RFFI_FPAI.srcs/sources_1/ip/xfft_256/sim/xfft_256.vhd .
cp RFFI_FPAI.srcs/sources_1/ip/log2_lut_rom/sim/log2_lut_rom.v .
cp RFFI_FPAI.srcs/sources_1/ip/log2_lut_rom/simulation/blk_mem_gen_v8_4.v .
cp RFFI_FPAI.srcs/sources_1/ip/log2_lut_rom/log2_lut_rom.mif .
# 黄金向量若缺失：python SRC/pl_ai/tools/gen_expert_vectors.py（默认写到 SRC/pl_ai/tb/vector/）

xvlog -sv -i . ef_*.v expert_feat_rffi.v tb_expert_feat.v tb_expert_feat_stress.v
xvlog log2_lut_rom.v blk_mem_gen_v8_4.v
cp RFFI_FPAI.srcs/sources_1/ip/cordic_0/sim/cordic_0.vhd .
xvhdl --work xil_defaultlib xfft_256.vhd cordic_0.vhd

xelab -L xbip_utils_v3_0_9 -L axi_utils_v2_0_5 -L c_reg_fd_v12_0_5 \
      -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_5 -L xbip_dsp48_addsub_v3_0_5 \
      -L xbip_addsub_v3_0_5 -L c_addsub_v12_0_12 -L c_mux_bit_v12_0_5 \
      -L c_shift_ram_v12_0_12 -L xbip_bram18k_v3_0_5 -L mult_gen_v12_0_14 \
      -L cmpy_v6_0_16 -L cordic_v6_0_14 -L floating_point_v7_0_15 -L xfft_v9_1_1 \
      -L xil_defaultlib -L work -L xilinx_vip -L unisims_ver -L unimacro_ver \
      -L secureip -L xpm -s top work.tb_expert_feat
xsim top -R
```

---

## 6. 没做 / 需要注意

- PS 侧解析这些特征、MLP/NPU、两者融合：不在本次范围。
- 设备树 / 驱动：本次不动（新 DMA 的节点和用户态程序由用户侧加）。
- `stat_drop/stat_frames/busy` 只是观测用，未接进 AXI。
- 整版工程没有重跑综合/实现；上面整版资源是"原工程 + 本模块"的估算。
- 时序余量：OOC +0.060 ns 是默认实现流的结果；剩下最差的一条是 `rst_n → u_cum`
  复位扇出（OOC 才有的伪路径）。整版布局后若低于目标，优先看 `u_cum` 的复位/归一化
  和 `zn_ram → dwt win` 这两族。
