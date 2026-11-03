# SG 取描述符：出问题时的 ILA 对照表

> 配套 `sw/pl_dma_test` 的 `sg2` / `carpet` 两条子命令。
> 它们跑完会打一行【下一步】，**照着那一行翻到本文对应的行**，别自己挑。
> 触发条件的地址要用**当次程序打印出来的那个**（`buf_pa` / 描述符地址），
> 本文里出现的地址只是举例，是历史值。

---

## ⚠️ 2026-10-15 板上跑完之后的更正（先读这段，下面 §2/§4 的框架已经被它改了）

那轮 `probe / sg2 / carpet / carpet --mm2s` 的读数把原来的假设**推翻了一部分**，
所以在照着 §2/§4 挑 ILA 之前，先看清现在剩下的问题是什么：

**已经站住的事实**

| 读到什么 | 说明什么 |
|---|---|
| `carpet --mm2s`：槽位 0,1,2,3,5 的 `STATUS=0x80000400`（COMPLETE + 实收 1024） | **MM2S 的 SG 取描述符这条路是通的**：描述符被取、数据被搬、STATUS 被硬件回写、环也走了。之前"SG 拿不到 DDR 里的内容"这个结论**不成立** |
| `carpet --mm2s` 的 NXTDESC 抽查全对、CURDESC 走到环里第 4/7 格 | 描述符链被正确解析 ⇒ **布局（BSP 64B）、长度字段位置、地址都对** |
| 同一条命令下 S2MM 那一路：CURDESC 走到尾格、**没有任何槽位被回写** | S2MM 的 SG 引擎会"空转着取描述符"（取比搬快），没有数据可搬就不回写 STATUS —— 这是正常的，别当成故障 |
| `sg2 --s2mm`：CURDESC 落住、写尾后 DMASR=`0x1100a`（IDLE+IOC，**无错**） | S2MM 的挂/开跑/停机**完全符合预期** |
| `sg2 --mm2s`：DMASR=`0x00015109` = Halted + SGIncld + **SGIntErr** + IOC + IrqErr；CURDESC 一直停在环内第 0 格；描述符 8 个字**一个字都没变** | 两通道**表现不同**，问题在 MM2S 这一路；而且它跟"挂法"无关（同一个挂法 S2MM 好着） |

**SGIntErr 到底是什么（PG021 v7.1 原文，这条决定了往下怎么查）**

> "This error occurs if a descriptor with the Complete bit already set is fetched.
> This indicates to the SG Engine that the descriptor is a tail descriptor.
> This error condition causes the AXI DMA to halt gracefully. …
> **This error cannot be logged into the descriptor.**"

三件事由此定死：
1. **SGIntErr 的成因是唯一的**：引擎取到了一条 **COMPLETE 已经置位**的描述符；
2. 报完这个错引擎是**优雅停机**（RS 清 0、Halted 置 1）；
3. **这个错不写回描述符** —— 所以"报错却一个字都没变"不是反证，正是这条说的。

**于是按顺序只有两种可能，而它们在软件上就能分开：**

- **A. 引擎取到的是"旧描述符"**（不一定是我们的）：DDR 不擦除，COMPLETE 位只有
  硬件回写和我们自己会置。上一轮跑剩的描述符、或者我们**没铺也没清**的那片地址。
- **B. 引擎取的是"我们的描述符、但读回来的数据不是我们写的"**（读通路）。

`sg2` 已经默认做了排除 A 的两步：**挂之前把开头的 64 KB 清零**（`--no-zero` 可关），
并且打两遍扫描 —— **② 预检**（清完之后还有没有 COMPLETE 置位的格子）和
**④ 跑完复扫**（我们的环之外有没有被写过）。判读：

- 预检 > 0 或复扫在环外有命中 ⇒ **A 成立**，先按残留/地址查，别上 ILA；
- 两处都干净，且报的仍是 SGIntErr ⇒ **B 或第三种可能**（引擎读的地址不在我们清过
  的那片里），这时才按 §2/§4 挑 ILA，而且**只抓 m_axi_sg 的读地址/读响应**。

另**形状**这条旋钮（`--xfer=` / `--ring=`）是给"长度 8192 vs 1024"和"2 格环 vs 大环"
分开用的 —— 同一片内存上地毯的 1024 字节描述符走得通、sg2 的 8192 报错，
差别只在这两处。**一次只动一个**：

```sh
./pl_dma_test sg2 --mm2s --xfer=1024    # 长度对上，环还是 2 格
./pl_dma_test sg2 --mm2s --ring=16      # 环变长，长度还是 8192
```

（顺带记一条**我自己犯过的判读错**：`carpet` 原来让 MM2S 和 S2MM 从同一个偏移铺
描述符，而 MM2S 被停下时还有一笔 STATUS 回写没落地 —— 那笔会落在 S2MM 刚铺好的
格子上，正好凑出"取到 COMPLETE 已置位的描述符"这个 SGIntErr 触发条件。
**那次"S2MM 也报 SGIntErr"的读数不能算数**，与硬件无关。现在已经把两个通道的
地毯区彻底分开了。）

---

## 0. 现状盘点（下面每条都查过出处，不是推测）

| 事实 | 出处 |
|---|---|
| **这个工程到现在一个 ILA 都没有** | 全仓库 `grep -rn create_debug_core` 为空；`RFFI_FPAI.srcs/ip/` 里没有 `ila`；`impl_1/` 里没有 `dbg_hub` |
| 有 **3 根 net 已经标着 `MARK_DEBUG`**，但没人消费 —— **标了 ≠ 抓了**，还得真插一个 debug core | `RFFI_FPAI.srcs/sources_1/bd/ps_ai/ps_ai.bd` 三处 `hdl_attributes` |
| 项目里**没有用户约束文件**（`RFFI_FPAI.srcs/constrs_1/` 不存在），现有 xdc 全是 IP/BD 自己生成的 | `ls RFFI_FPAI.srcs/` |

已经标了 `MARK_DEBUG` 的三根（可以直接拿来做 ILA，不用再标）：

- `S_AXI_HP2_0_1`：厂商 master → `axi_interconnect_4/S00_AXI`
- `axi_interconnect_4_M00_AXI`：`axi_interconnect_4` → PS 的 `S_AXI_HP2`（**我们四个 DMA master 和厂商共用这一根**）
- `proc_sys_reset_1_peripheral_aresetn`

### 时钟（决定 ILA 得挂在哪个时钟上）

- **`hp_axi_aclk` = 200 MHz**（DDR/MIG 出来的；`SRC/utils/demo_clkrst_wrapper.v` 里
  `assign hp_clk = ddr_clk;`）。挂在这根上的有：两个 DMA 的
  `m_axi_sg_aclk` / `m_axi_mm2s_aclk` / `m_axi_s2mm_aclk`、`smartconnect_0`、
  `axi_interconnect_4`、`Signal_process_0`。
  出处 `RFFI_FPAI.srcs/sources_1/bd/ps_ai/synth/ps_ai.v:3469,3502,3519,3574,3591,3891,4022`。
- **`gp_axi_aclk` = 100 MHz**（PS FCLK_CLK0 → `clk_wiz_0`）。两个 DMA 的
  `s_axi_lite_aclk` 在这根上，中间还隔着 `smartconnect_1`
  （`synth/ps_ai.v:3487` 把 BD 端口 `processing_system7_1_FCLK_CLK0` 直接 `assign` 成
  `gp_axi_aclk`，`3555/3622` 是 lite 脚，`3645` 起是 `smartconnect_1`）。

BD 是**全局综合**的（`ps_ai.bd` 里没有 `SYNTH_CHECKPOINT_MODE`），
BD 顶层实例在 wrapper 里叫 **`ps_ai_i`**（`SRC/ps_ai_wrapper.sv:413`）。

---

## 1. 怎么把 ILA 加进去

### 路线 A（推荐）：在 BD 里标 net

1. 打开 `ps_ai` BD → 找到要抓的 net（见 §2 表）→ 右键 → **Mark Debug**。
   已经标好的那三根跳这一步。
2. 保存 BD → **Run Synthesis** → `Open Synthesized Design`。
3. 菜单 **Tools → Set up Debug**，向导把标过的 net 列成树：
   - 每个信号要指定**时钟**（见 §2 表，全是 `hp_axi_aclk`）；
   - 位宽大的接口**只勾要看的信号**（读通道那几个），全勾会把 BRAM 吃光；
   - 采样深度先用 **1024**（够抓几笔描述符访存了）。
4. 走完向导会生成 debug 约束、**再跑 Implementation 和 Write Bitstream**。
5. 下载新 bitstream，用硬件管理器开 ILA。

### 路线 B：写约束文件

项目里现在没有 `constrs_1`，要自己建 `RFFI_FPAI.srcs/constrs_1/debug.xdc` 再加进工程：

```tcl
set_property MARK_DEBUG true [get_nets -hier -filter {NAME =~ "*axi_dma_1_M_AXI_SG_ARADDR"}]
```

**这条路能不能成，先自己验**：跑完综合后

```tcl
get_nets -hier *axi_dma_1_M_AXI_SG_ARADDR*
```

有回显才说明这根 net 在 `synth_1` 的网表里活着。理由是：BD 里的 IP
（`axi_dma_0/1`）都是 **OOC 单独综合**的（`runs/` 下那一堆 `ps_ai_axi_dma_*_synth_1`），
**IP 内部的信号取不到**；能取到的只有 BD 顶层（`ps_ai`）里连接各 IP **端口**的那根 net。
上面 §3 给的名字全是这一类，所以是可行的；但名字是 Vivado 生成的，
**以 `get_nets` 的回显为准，别照抄本文**。

### 三条硬注意事项

1. **别抓 IP 内部信号**（比如 axi_dma 里的 `sg_ctl`）。OOC 综合的 IP 内部已经定型，
   XDC 里按名字取不到；这类信号只能在**它连出来的那根 net** 上抓。
2. **ILA 的时钟必须和被测信号同域**：抓 SG / S2MM / HP2 一律用 `hp_axi_aclk`（200 MHz）；
   抓 Lite 写寄存器才用 `gp_axi_aclk`（100 MHz）。用错时钟 ILA 会报跨时钟、抓到的全是垃圾。
3. **加完必须重新综合 → 实现 → 出 bitstream → 重新下载**，而且板子要能连 JTAG。
   ILA 不是"软件跑起来就能看"的东西 —— 这是本次要上 ILA 的主要代价。

---

## 2. 抓哪儿：软件现象 → ILA 对照表

| 软件那边看到（`sg2` 的【下一步】原话） | 说明问题在哪一层 | 抓哪根 net | ILA 时钟 | 触发条件 | 看什么 |
|---|---|---|---|---|---|
| **CURDESC 读不回我们写的值** | 还没走到 DDR，Lite 写寄存器这一段 | `smartconnect_1_M00_AXI_*`（`axi_dma_0`）或 `_M01_AXI_*`（`axi_dma_1`） | **`gp_axi_aclk` 100 MHz** | `AWVALID && AWADDR[15:0]==0x08`（MM2S_CURDESC）或 `0x38`（S2MM_CURDESC） | AWADDR/AWPROT/WDATA/WSTRB 有没有真的发出去、AWREADY 有没有回、BRESP 是不是 OKAY |
| **地址落住了，引擎一点动静都没有** | Lite 寄存器 → SG 引擎 这一步，还没开始访存 | `axi_dma_0_M_AXI_SG_*` / `axi_dma_1_M_AXI_SG_*` | `hp_axi_aclk` | `ARVALID`（不加地址条件，看有没有任何一笔） | 有没有出现过 `ARVALID=1`。一次都没有 ⇒ 引擎根本没发读请求 |
| **引擎取了东西并报错 / CURDESC 归 0** | 读了、也回来了，但**回来的不是我们那份描述符**<br>⚠ 报 `SGIntErr` 时**先**做本节开头更新的 A/B 排除（预检/复扫），排干净了才用这一行 | ① `axi_dma_*_M_AXI_SG_*` 的读通道<br>② `smartconnect_0_M00_AXI_*` 的读通道 | `hp_axi_aclk` | ① `ARVALID && ARADDR==<描述符地址>`<br>② `ARVALID`（不限地址，看上游把它变成了什么） | 见 §4 —— **这是最关键的一张表** |
| **两个通道的描述符都被改过** | 有别的 master 在写我们这块 DDR（HP2 和厂商共用） | `axi_interconnect_4_M00_AXI_*`（已标 MARK_DEBUG） | `hp_axi_aclk` | `AWVALID && AWADDR[31:6]==<我们的 DDR 区间>` | 是厂商那路在写，还是我们两个 DMA 在写（`AWID` 能分出来：M00 的 ID 是 6 位，两路 SI 各占一半） |
| **连合法地毯都取不动** | 与描述符内容无关，问题在"取"这个动作本身 | ① `axi_dma_*_M_AXI_SG_*` 读通道<br>② `smartconnect_0_M00_AXI_*` 读通道 | `hp_axi_aclk` | 同第 3 行 | 同 §4 |
| **引擎在走环**（取描述符通了） | 往数据侧查 | `axi_dma_1_M_AXI_S2MM_*` 写通道 / `axi_dma_0_M_AXI_MM2S_*` 读通道 | `hp_axi_aclk` | `AWVALID` / `ARVALID` | 数据有没有按 684 B / 8192 B 的规模搬 |

---

## 3. 精确信号名（从 `synth/ps_ai.v` 抄的，宽度也抄的）

层次路径从顶层起是 `ps_ai_i/` 前缀（BD 实例名），例如
`ps_ai_i/axi_dma_1_M_AXI_SG_ARADDR`。加 ILA 时选 net 即可，下面是完整名单。

**`axi_dma_1_M_AXI_SG_*`（S2MM 那路的取描述符，32 位读）**

```
ARADDR[31:0] ARLEN[7:0] ARSIZE[2:0] ARBURST[1:0] ARPROT[2:0] ARVALID ARREADY
RDATA[31:0]  RRESP[1:0] RLAST RVALID RREADY
（另有 AW*/W*/B* —— 引擎回写 STATUS 用，一般不用抓）
```

`axi_dma_0_M_AXI_SG_*` 同名同宽（`synth/ps_ai.v:2732-2760` 是 0，
`2778` 起是 1）。**注意这两个接口没有 `ARID`/`RID`** —— 32 位、
ID 宽 0，ID 是在 SmartConnect 内部才被加上去的。

**`smartconnect_0_M00_AXI_*`（上变换之后、真正去 HP2 的那根，64 位）**

```
ARADDR[31:0] ARLEN[7:0] ARSIZE[2:0] ARBURST[1:0] ARLOCK[0:0] ARCACHE[3:0]
ARPROT[2:0]  ARQOS[3:0]  ARVALID ARREADY
RDATA[63:0]  RRESP[1:0]  RLAST RVALID RREADY
AWADDR[31:0] AWLEN[7:0]  AWSIZE[2:0] AWBURST[1:0] AWVALID AWREADY
WDATA[63:0]  WSTRB[7:0]  WLAST WVALID WREADY  BRESP[1:0] BVALID BREADY
```
（`synth/ps_ai.v:3059-3090`。**这里也没有 ID** —— SmartConnect 自己就是 ID 的起点。）

**`axi_interconnect_4_M00_AXI_*`（两路共用、去 PS HP2 的 AXI3 口，已 MARK_DEBUG）**

```
ARADDR[31:0] ARLEN[3:0] ARSIZE[2:0] ARID[5:0] ARLOCK[1:0] ARVALID ARREADY
RDATA[63:0]  RRESP[1:0] RID[5:0] RLAST RVALID RREADY
AWADDR[31:0] AWLEN[3:0] AWID[5:0] AWVALID ... WDATA[63:0] WSTRB[7:0] BID[5:0] ...
```
（`synth/ps_ai.v:2960-2979`。**这里才有 ID，而且是 6 位** ——
厂商那路上来是 5 位（`S_AXI_HP2_0_1_ARID[4:0]`，`2623`），
互联内部加了一位用来分辨两路 SI。**ID 对不上就是在这里能抓到。**）

**Lite 侧（只在"寄存器都没落住"时才用）**

```
smartconnect_1_M00_AXI_*   → axi_dma_0 的 s_axi_lite   (gp 100MHz)
smartconnect_1_M01_AXI_*   → axi_dma_1 的 s_axi_lite   (gp 100MHz)
AWADDR[31:0] AWVALID AWREADY WDATA[31:0] WSTRB[3:0] WVALID WREADY BRESP[1:0] BVALID BREADY
ARADDR[31:0] ARVALID ARREADY RDATA[31:0] RRESP[1:0] RVALID RREADY
```
（`synth/ps_ai.v:3555-3575 / 3622-3642`。）

---

## 4. 判读：读通道那张表（最关键）

实验只有一句话：**程序把描述符写进 DDR 了，硬件读回来的是不是那 64 个字节。**

先记下程序当次打印的描述符内容（`sg2` 的 ③ 那一步会打 8 个字，
`carpet` 会打槽位地址）。举例（历史值，别照抄）：

```
BD[0] @ <描述符地址>: NXTDESC=<下一格>  BUFA=<数据地址>  CTRL=0x000002ac
```

把 ILA 触在 `ARVALID && ARADDR == <描述符地址>` 上，然后看：

| ILA 看到 | 结论 | 
|---|---|
| **一次 `ARVALID` 都没有**（抓了 1 秒也没触发） | 引擎没发读请求 ⇒ 问题在引擎→总线这一步，**不在 DDR、不在描述符内容**。往上查 Lite 有没有把 CURDESC/TAILDESC 落住（§2 第 1 行）。 |
| 有 `ARVALID`，`ARREADY` 一直不回 | 请求发出去了、没被接收 ⇒ 卡在 `smartconnect_0` 或它上游的仲裁/译码。去 `smartconnect_0_M00_AXI_*` 看这根有没有继续透传，再上 `axi_interconnect_4_M00_AXI_*`。 |
| 有请求、有 `RVALID`，**但 `RDATA` 不是我们写的那些字** | **逮到了**：读回来的数据是错的（地址译码错了 / 回的数据配错了请求 / 32→64 上变换把字节通道放错了）。用 `axi_dma_*_M_AXI_SG_RDATA` 看**进去**的、`smartconnect_0_M00_AXI_RDATA` 看**出来**的，差异在谁那里产生就是谁的问题。 |
| `RRESP != 2'b00`（SLVERR/DECERR） | 总线明确报错 ⇒ 地址没被任何从设备认领，或从设备拒绝。此时 `smartconnect_0_M00_AXI_ARADDR` 那根才是真相（上游可能改了地址）。 |
| **`RDATA` 完全正确**，但引擎还是报错 | 先看**报的是哪个错**：<br>· `SGIntErr` —— 按 PG021 原文成因只有一个：**取到了一条 COMPLETE 已置位的描述符**。先回去做本节开头那条更新里的 A/B 排除（预检/复扫扫干净了吗），**别直接怀疑读通路**。<br>· `DMAIntErr` —— 才轮到位宽/长度/描述符内容，那时再核 `C_SG_LENGTH_WIDTH`（本工程两个通道都是 **14** ⇒ 单描述符上限 16383，8192 合法；这条已经查过，不是它）。 |

**32 位读 → 64 位口这条上变换是重点怀疑对象**，理由：这两个 SG 口
（`S00_AXI`/`S03_AXI`）是整块设计里**唯一的 32 位读 master**
（`axi_dma_0_M_AXI_MM2S_RDATA` 是 64 位、`axi_dma_1_M_AXI_S2MM_WDATA` 是 32 位写），
只有它走 SmartConnect 内部"窄读→宽"的那条路；已经实测跑通的两条（64 位读、32 位写）
都不碰这条路。所以 §4 第 3 行那个"进/出 RDATA 对照"是最值钱的一笔。

---

## 5. 别做的事（同样重要）

- **别删了重建 `smartconnect_0`**：四个从口的 MMU 配置逐字节相同
  （`bd_e4a7_s0Nmmu_0.xci`），stub 口 134 个全连满，重建没有已知机理。
- **别改 burst size**：`C_MM2S_BURST_SIZE=128` / `C_S2MM_BURST_SIZE=128` 是**字节**，
  64 位口上 = 16 beat，正好等于 HP2（AXI3）的 `MAX_BURST_LENGTH 16`，合法。
- **别再去勾 `C_PRMRY_IS_ACLK_ASYNC`**：它不是用户参数（`xgui/axi_dma_v7_1.tcl`
  里没为它建 widget），值是 `bd/bd.tcl` 的 `post_propagate` 按时钟推的；
  我们这个拓扑必然算成 0。
- **别在没跑过 `sg2`/`carpet` 的情况下上 ILA**：ILA 的代价是重综合+重出比特流，
  先用软件把范围压到 §2 的某一行，只抓那一根 net，比全抓一圈便宜得多。

---

## 附：板子本次该按什么顺序跑

```sh
./pl_dma_test probe          # 底子：0x8040_0000 / 0x8041_0000 通不通
./pl_dma_test sg2            # 两个通道：清区+预检 / 只挂不跑 / 写尾 / 时间线 / diff / 复扫
./pl_dma_test carpet         # 满屏合法描述符：引擎到底读了哪个地址（两个通道已分开铺）
./pl_dma_test carpet --mm2s  # 同上，只看 MM2S 那路

# 上面两轮跑完之后，按【下一步】里给的两条做形状二分（**一次只动一个**）：
./pl_dma_test sg2 --mm2s --xfer=1024    # 长度对上，环还是 2 格
./pl_dma_test sg2 --mm2s --ring=16      # 环变长，长度还是 8192
```

三条都跑完，按它们各自打的【下一步】决定是不是真的需要上 ILA、
以及只上 §2 表里的哪一行。
