# pl_dma_test —— PL 两个 AXI DMA 的用户态测试

**不改设备树、不装内核驱动、不用中断。** 只用 `/dev/mem`（mmap DMA 寄存器）
和现成的 `/dev/udmabuf0`（DMA 缓冲区），全部靠轮询 `DMASR` 判断完成。

## 为什么能不改 dtb

| 需要的东西 | 从哪来 | 要不要 dts 节点 |
|---|---|---|
| `axi_dma_0` 寄存器 `0x80400000` | `/dev/mem` mmap | 不要（窗口在 BOOT 阶段已译码） |
| `axi_dma_1` 寄存器 `0x80410000` | `/dev/mem` mmap | 不要 |
| DMA 缓冲区（物理连续） | `/dev/udmabuf0` 的 sysfs + mmap | 不用改，**当前 dts 已经有了** |
| 完成通知 | 轮询 `DMASR` 的 IOC 位 | **不要**（中断号猜都不用猜） |

要中断号的只有内核 `xlnx_dma` 驱动（dmaengine API）。本程序绕开了它，
所以之前那个 `IRQ_F2P → GIC SPI` 号是多少，跟这个测试完全无关。

## 编译

```sh
sh build.sh          # docker 里跑 aarch64-linux-gnu-gcc，产物静态链接
sh build.sh clean    # 重来
```

产物 `pl_dma_test`：AArch64 / 静态链接（`ET_EXEC`，无解释器），拷到板子上直接跑。

> 镜像基础用 `docker.m.daocloud.io/library/ubuntu:20.04`——本机到
> `registry-1.docker.io` 连不通（IPv6 路由不通），只有镜像站能拉。
> `build.sh` 会按 `daocloud → ubuntu:20.04 → 本地已有镜像` 的顺序自己挑。

## 板子上怎么跑

```sh
chmod +x pl_dma_test
./pl_dma_test probe     # ① 先跑这个
./pl_dma_test e2e       # ② 端到端
```

### ① `probe` —— 只读写寄存器

对两个 DMA 各做：复位 → 读 `DMACR/DMASR` → 往 `IRQThreshold` 字段写 `0x5a` 再读回。
读回一致 = AXI-Lite 读写都通 = PL 地址译码 OK。

读出来全是 `0xFFFFFFFF` 就是根本没通，别往下走了，先查 bitstream / FSBL 地址分配。

### ② `e2e` —— 一次完整调用

```
8192 B ──axi_dma_0(MM2S, SG模式)──> Signal_process_0/s_tdata ──> HLS
                                                                 │
3072 B <──axi_dma_1(S2MM, 直读模式)── Signal_process_0/tok_out_V_V_TDATA
```

- **8192 B = 8 帧 × 256 字 = 1024 beat × 8 B**
- **3072 B = 8 帧 × 96 拍 × 4 B**（每拍 4 个 INT8 token）

顺序很关键：**S2MM 必须先挂上**（`s_axis_s2mm_tlast` 在 BD 里没连，S2MM 只会傻等到
收满 `LENGTH` 字节）。所以先写 `S2MM_DA`/`S2MM_LENGTH`，再用 MM2S 灌数据。

内置源数据是**每帧相同的方波图案**（256 字周期，前半 +12000 后半 −12000，Q 恒 0）。
8 帧完全一样 → 抓回来的 8 个 384 B 块**必须逐字节相同**，程序会自动比一遍。
不一样就说明帧边界或者 DMA 通路有问题，一眼能看出来。

结果同时落盘到 `pl_dma_test_out.bin`。

## 单跑某一路

```sh
./pl_dma_test s2mm 3072      # 只抓（不灌数据的话必然超时，那是正常的）
./pl_dma_test mm2s 8192      # 只灌（HLS 会跑，但没人收结果）
./pl_dma_test mm2s 8192 --in=iq.bin    # 用自己的数据，raw、小端、每字 2 字节 {I 低 Q 高}
```

## 描述符布局（只有 MM2S 用得到）

`axi_dma_0` 是 SG 模式（`C_INCLUDE_SG=1`），**没有**简单模式的 `MM2S_SA/LENGTH` 寄存器，
必须自己造描述符。默认按 Xilinx BSP `xaxidma_bd.h` 的布局（2018.3 和 2025.2 一致，
且 `XAxiDma_BdRingCreate()` 无条件往 `0x04` 写 `NXTDESC_MSB`，说明 32bit 地址下这个字也在）：

```
0x00 NXTDESC   0x04 NXTDESC_MSB   0x08 BUFA   0x0C BUFA_MSB
0x18 CTRL      0x1C STATUS        描述符 64 字节对齐
```

万一报 **SG 解码错误**（`DMASR` 里的 `0x400`）或者描述符 `STATUS` 一直没有 `bit31`，
加上 `--alt-desc` 换成 PG021 的 32bit 布局（`BUFA@0x04 / CTRL@0x0C / STATUS@0x10`）再跑。

## 已知的坑

- **自环描述符**：单描述符的 `NXTDESC` 指向自己（跟驱动的环形链表一致），
  所以传完程序会**立刻复位通道**，否则硬件会把同一个描述符再跑一遍。
- **MM2S 会卡住是正常的**：`Signal_process_0` 的输入 FIFO（512 深）满了就会拉低
  `s_tready`，MM2S 一直等到 HLS 把 FIFO 吃掉。HLS 约 101 µs/帧，8192 B 大概
  0.6~0.8 ms 传完。超时设 5 s 足够了。
- **帧数不够会超时**：S2MM 要 3072 B，如果 HLS 只吐了 7 帧就只有 2688 B，
  S2MM 会一直等到超时。程序会打印 `S2MM_LENGTH` 里剩多少，反推收了多少。
- **缓存**：当前 dts 里 `udmabuf@0` 带 `dma-coherent`，缓冲区不可缓存，不需要同步。
  程序仍然容错地调了一次 u-dma-buf 的 SYNC ioctl（失败就忽略），
  万一换回老的 `sync-mode=1` 那种 dts 也能用。
