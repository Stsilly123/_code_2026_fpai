/*
 * pl_dma_test.c —— PL 侧两个 Xilinx AXI DMA 的纯用户态测试程序
 *
 * 【前提】不需要改设备树。两条通路都用现成的东西：
 *   - DMA 寄存器：/dev/mem 直接 mmap 0x8040_0000 / 0x8041_0000
 *     （这两个窗口在 BOOT 阶段就已经译码，内核不认识也无所谓）
 *   - DMA 缓冲区：现成的 /dev/udmabuf0（dts 里已有 udmabuf@0 节点），
 *     从 sysfs 拿物理地址，DMA 和 CPU 共用同一块内存
 *   - **不用中断**。全部靠轮询 DMASR 的 IOC/错误位，所以 SPI 号是多少都无所谓。
 *     要走内核 xlnx_dma 驱动才必须知道中断号；本程序绕开了它。
 *
 * 【PL 那头的接线】（2026-10-16 15:03 那份 BD 的 .xci / ps_ai_bd.tcl 里读出来的，
 *                  不是记忆；**改了 BD 记得重新对一遍**，并把这段一起改掉）
 *   axi_dma_0 @0x80400000  MM2S only, C_INCLUDE_SG=1 (C_SG_LENGTH_WIDTH=14)
 *                          m_axi_sg / m_axi_mm2s 都挂在 hp_axi_aclk 上
 *                          s_axi_lite_aclk 挂 gp_axi_aclk(100M) ≠ hp_axi_aclk(200M)
 *        -> Signal_process_0/s_tdata   即 IQ 数据灌进 HLS
 *   axi_dma_1 @0x80410000  S2MM only, C_INCLUDE_SG=0  ← **2026-10-16 又关回来了**
 *                          （所以 M_AXI_SG 端口不存在、Data_SG 没有地址段，都正常）
 *        <- Signal_process_0/dout      即 HLS 的复合输出抓回 DDR
 *   ⚠ **两个 DMA 的 C_PRMRY_IS_ACLK_ASYNC 现在不一致**：dma0=0、dma1=1，而两者的
 *     时钟接法一模一样（s_axi_lite=gp 100M / m_axi=hp 200M，两个不同 CLK_DOMAIN）。
 *     这就是 dma0 头上悬着的那把刀，见下面第五次改动的最后一段。
 *
 * 【2026-10-16 第五次改动：dma1 的 SG 关回去了 —— 但**程序一个字都不用改**】
 *   第四次改动做的那套"启动时读 DMASR 自己选走法"这回派上用场了：dma1 的
 *   C_INCLUDE_SG 关回 0 之后，同一个二进制会自动走直读模式，命令行不用动、
 *   也不用重新编译。**这是第五次改动唯一"要做"的事：什么都不做。**
 *
 *   顺带记一笔板上那次 SG 的失败（免得以后又想开回来）：
 *   13:23 那版 BD 把 dma1 的 SG 打开、两个 DMA 的 M_AXI_SG 挤进新建的
 *   axi_interconnect_2，结果 **MM2S 也挂了**（DMASR 报 DMAIntErr = 取回的描述符
 *   buffer length 是 0，8 个描述符 STATUS 全 0），S2MM 一路超时。MM2S 本来是好
 *   的，一改就坏 —— 说明那条新漏斗（或它上面的时钟/复位）有问题。那版 BD 已作废。
 *
 *   ⚠ **但别以为"关掉 dma1 的 SG"就把那次故障治好了。** 关 SG 只让 S2MM 换回直读；
 *     **MM2S 那条路还是坏的**，而它一挂 HLS 就没输入，S2MM 直读也一样收不到数据。
 *     那次失败之后唯一被坐实的、看得见摸得着的配置矛盾是：
 *       dma0 的 C_PRMRY_IS_ACLK_ASYNC = 0，而它的 s_axi_lite_aclk(gp, 100MHz) 和
 *       m_axi_*_aclk(hp, 200MHz) 是两个不同 CLK_DOMAIN —— 等于告诉 IP"我的时钟是
 *       同步的"，IP 就会省掉跨时钟域的同步逻辑。dma1 同样的接线写的是 1。
 *     **上板之前先把 dma0 这个参数改成和 dma1 一致（=1）**，否则测的还是同一个坏配置。
 *
 * 【2026-10-16 第八次改动：判读第三次翻车 —— **"两种毛病"其实是只有一种**】
 *   改的是**判读文字**，判据本身没动。上板跑出来这是个高频长相，所以值得先修掉。
 *
 *   ▸ 症状：`帧 3 vs 帧 4：不同 64（tok 0，logits 64）`，逐字节一量，那 64 个不同
 *     **全部**落在 0xA5 空洞里（偏移 508..571），**其余一个字节都不差**。
 *     可 check_frames_out 照样打印「这一对帧身上叠了**两种**毛病：……(2) 其余的
 *     tok 0/384、logits 0/300 是真载荷不同」—— "其余的"是 **0**，
 *     硬把**一件事**说成了**两件**。这是我这一版判读第三次自己给自己加戏
 *     （前两次见第六次/第七次改动里的 ⚠）。
 *   ⇒ 现在按 `residual = n_all - hole_best` 分岔：
 *       · `residual == 0` → 明说「除开那段空洞，两帧**逐字节相同**」「只有**一件事**：
 *         缺写。**没有**第二个『载荷不同』的毛病，别当成两件事去查」；
 *       · `residual > 0` → 才说"两种毛病"，并且把两边各占多少字节分别报出来
 *         （`(1) …占掉 N 个不同` / `(2) 其余 M 个不同`）。
 *
 *   ▸ 顺带加了**本轮空洞汇总**（每处：帧号 / 偏移 / 字节数 / 是否整拍），
 *     因为"一轮里某一帧带一串 0xA5、位置每轮都挪"这个毛病**单看一轮看不出名堂**：
 *     板上 4 轮里 3 轮各有一帧带 64 B 空洞，偏移分别是 508（logits）、612（logits）、
 *     184（tok）—— 每次换地方。汇总里直接写着怎么读它：
 *     "每轮换地方 ⇒ 偶发丢写；都落同一个偏移才轮到怀疑固定位置"。
 *
 *   ▸ 把"这块没写进去"的**推理**也写进打印里了。以前只报"没写进去"，
 *     看的人还得自己推。现在直接说：
 *     **帧长仍是 684、空洞两侧字节都还在自己位置上** ⇒ 那 N 拍是被 DMA
 *     **消费掉了、只是没落 DDR**（要是 IP 压根没发，整帧会短一截、后面全体前移）
 *     ⇒ 该查 **S2MM 的写通路**，不是 HLS 的输出。
 *
 *   ▸ 最后的总结也跟着分岔了。老总结只要"有帧对不上"就一律说
 *     「要么 IP 有跨帧状态，要么抓取有问题」—— 而 0xA5 空洞**恰恰不是**这两者
 *     （跨帧状态会改**数**，不会留一段没写的底色）。现在：
 *       · 全部不同都是空洞 → 「只有一条结论：**偶发缺写**……别去查 IP 有没有跨帧状态」；
 *       · 真有载荷不同 → 才报"有整帧对不上"，并注明另有几对帧只是缺写。
 *     干净轮次的总结也补了一句：**这只是"这一轮"干净** —— 板上实测"同一条命令，
 *     有时全一致、有时某一帧对不上"，别把一次干净当成永久干净。
 *
 *   ▸ 第一次上板就暴露汇总**自己数重了**：`帧 6` 要跟帧 5、帧 7 各比一次，
 *     同一个洞被记了**两遍**，打成「本轮 0xA5 空洞汇总（2 处）」而两行一模一样。
 *     按 (帧号, 偏移, 长度) 去重了。
 *
 *   ▸ 同一批上板数据**两次推翻了我自己写的判读指导**（都是我三轮就下结论）：
 *     ① 先看到洞落在 **帧 6 / 偏移 612**，跟上一批那次**一模一样**（同帧号、同偏移、
 *        同为 logits 228..291、同样 32 个高字节不合规）⇒ 我写了「不是随机的，是**强信号**」。
 *     ② 紧接着下一轮洞落在 **帧 1 / 偏移 192**，再下一轮 **帧 7 / 偏移 56** —— 全是新地方。
 *        5 次出洞落在 4 个不同位置，只有一处重复过 ⇒「固定位置」**不成立**，收回。
 *     ⇒ 现在只如实记，不下这个结论。
 *
 *   ▸ **但换一个坐标轴看，有一条不变量活下来了，而且它比"位置固不固定"有用得多。**
 *     把 5 次的落点换成**绝对偏移**（从本轮缓冲头算，不是帧内偏移）：
 *       192、2560、4032、4160、4288 —— **全都是 64 的整数倍**，洞长也都**正好 64 B**。
 *     关键论据：**帧起点自己不是 64 对齐的**（684 mod 64 = 44，八帧起点 mod 64 =
 *     0/44/24/4/48/28/8/52）。所以如果丢写是「流里第几拍」决定的，洞的位置就该跟着帧漂；
 *     实测却全贴死在绝对 64 字节边界上。
 *     ⇒ 丢的单位是**内存地址空间里的一个 64 字节块**（一条写突发 / 一行），
 *        **不是**流里的 16 拍。嫌疑从 "HLS 输出" 移到 **S2MM 写通路**（DMA 写引擎 /
 *        互连 / HP 口 / DDR 控制器）。
 *     这个坐标换算现在做进打印里了：每处洞同时报**帧内偏移**和**绝对偏移**，
 *     以及"是否 64 对齐"，汇总最后还有一行本轮的 64 对齐结论。
 *
 *   ▸ 新增 **[S2MM DMASR @每帧收工]** 一行 —— 这是"16 拍被吃进去没落 DDR"这件事
 *     唯一能把「硬件认账」和「静默丢」分开的证据，而以前**只看 MM2S 那一侧**。
 *     抓的时机很讲究：必须在 `s2mm_wait()` 返回后、**下一帧挂上去之前**读，
 *     因为 `s2mm_arm()` 开头有一发 W1C 把 DMASR 清了，等整轮跑完再读就什么都没有了。
 *     一条 MMIO 读几十 ns，不破坏"立刻挂下一帧"那个热路径。
 *     全为 0 时的判读直接写在打印里：写响应报错会被 DMA 记成 DMASlvErr/DMADecErr，
 *     所以全 0 ⇒ 往「写被吞但没人报错」查（DMA 写通路 / 互连 / DDR 控制器）。
 *
 * 【2026-10-16 第七次改动：**e2e 不该污染它自己要测的东西** —— 顺手改掉三条自伤】
 *   这一版改的是**工具的行为和判读**，硬件/BD 一个字没动。
 *
 *   ▸ 先更正**第六次改动里那两条结论**（现在有 4 份 5472B + 2 份 684B 逐字节比对了）：
 *     ① "直读一帧一挂的启动空档（帧 1 必短）" —— **不是**启动空档。真身是
 *        **上一轮留在 HLS 输出 FIFO 里的存货**：老的 e2e 只收第一帧就走，剩下 7 帧
 *        没排空；下一轮开跑时先吐出来的是上一轮的尾巴，于是第 1 帧缺头。
 *     ② "logits 支路头几帧不收敛" —— **也不对**。收敛后的输出**是**可复现的：
 *        黄金帧 `e1`（684 B）在 4 次独立运行、跨两个时段里**逐字节相同**地出现 38 次。
 *        只有"IP 里有积压"的时候输出才被小幅扰动，而且扰动是**离散的几档常数**
 *        （Q：32 处 tok 全 ±1 / logits 平均差 19.5；R：188 处 / 48.6；还有一档 262 处 / 55.2），
 *        跨运行逐字节可复现 —— 不是随机噪声。
 *     ③ 顺带坐实一条：`e2[0:652] == e1[32:684]` **零字节不同** ⇒ 少 8 拍就是**前面少了**，
 *        铁证；`B帧1[0:668] == e1[16:684]` 同理（少 4 拍）+ 16 B 底色。
 *   ⇒ 结论：**这是用法问题，不是硬件坏了**。任何"收了不满 8 帧就走"的跑法都会
 *     给下一轮留存货、污染下一轮的判读。所以：
 *
 *   ▸ 改动 1（e2e 改成收满 8 帧）：第一笔仍然**故意给 5472**（TLAST 那条实验照做、
 *     证据照报），读走 remain/remain2 之后，除非 `--one`，**把剩下的帧补收干净**。
 *     这样 e2e "灌 8 帧 / 收 8 帧"对上账，不再给下一轮留存货。
 *     `--one` 保留老行为，专门用来复现"紧接着跑 frames、帧 1 只有 668/652"那个现象。
 *     14:15 那版第一次上板，补收只收到 1 帧就自己 break 了，暴露出两条写法上的规矩
 *     （已经改进去了，注释在补收那段代码上）：
 *       · **两次挂之间不许复位通道**。复位期间 S2MM 的 TREADY 会抖，抖一下从流里
 *         吃掉几拍。所以收尾的 chan_reset 挪到了补收**之后** —— 实测 684 后面
 *         紧跟着一个 668（= 少 4 拍）就是这么来的。
 *       · **短一笔 ≠ 排空了**，绝不能 break。第一笔收在 TLAST 上收工时，DMA 内部
 *         可能已经吞掉几拍没写进内存，流的位置比"逻辑帧边界"超前几拍，于是紧接着
 *         那一笔就短；但它是收在 TLAST 上的，**再下一笔又回到帧边界、又是整帧**。
 *         而且每一笔按**帧格子**（k × 684）挂，这样短的那格补底色、别的格还在网格上。
 *
 *   ▸ 改动 2（判读加一条闸）：`frames` 里**帧 1 是短帧（668 / 652）就先把本轮判读作废**，
 *     明说"这是上一轮没排干净的存货"，而不是让它伪装成"IP 有跨帧状态"。
 *     依据：这条长相在每一个"紧跟 e2e"的脏轮次里 4/4 出现，在每一个干净轮次里 0/4 出现。
 *     另外把 check_frames_out 里**0xA5 连续空洞**单独量出来报 —— 以前它对着一帧
 *     "载荷本来就降级 + 有 64B 空洞"，先报"更像那一拍没写进去"、紧接着又报
 *     "差异铺满整帧、不是错位"，两句话打架（我自己就是这么被绕进去的）。
 *
 *   ▸ 改动 3（输出文件名带轮次戳）：`pl_dma_test_out_<时:分:秒-pid>.bin` /
 *     `pl_dma_test_frames_<...>.bin`。老名字固定，`cp ... runA.bin` 连跑八次
 *     最后只剩最后一份 —— 这个坑已经吃掉两批数据了（还害我把"其实完全一致"的
 *     八份当成"不一致"）。现在重名的 cp 会**直接报错**而不是静悄悄盖掉。
 *
 * 【2026-10-16 第六次改动：把 pl_dma_test_frames.bin 拷回主机逐字节拆过了】
 *   ⚠ **这一条里的 ①「启动空档⇒帧 1 必短」和 ②「logits 支路头几帧不收敛」
 *     已被第七次改动推翻**（真身是"上一轮留在 IP 输出里的存货"）—— 见上面那一段。
 *   （拆的脚本在 C:\msys64\tmp\modetest\an.py / an2.py / an3.py，没进仓库）
 *   直读模式（dma1 SG=0）下 8 帧的硬数据，**这是判读的直接依据**：
 *     · 帧 4..8 五个块**逐字节完全相同** ⇒ 采集通路和 HLS 都能出正确结果，
 *       而且"8 帧输入相同 ⇒ 8 帧输出相同"这条前提坐实了。
 *     · 帧 1 = 后面那些帧的数据**整体前移 16 B**（= 少 4 拍），末尾 16 B 还是
 *       底色 0xA5，实收 668 B。**四次运行都一样** ⇒ 第一次挂 S2MM 挂晚了，
 *       4 拍在挂上之前就被推走了，然后 TLAST 把这笔**提前结掉**，所以是 668 而不是
 *       684。这不是算错，是**直读一帧一挂的启动空档**（老毛病，见文件头那句
 *       "每帧少 8 拍的重挂空档"）。
 *     · 帧 2 里 offset 20..83（**整 16 拍**）是一整片纯 0xA5 底色，前后字节都对齐
 *       ⇒ 那 16 拍**根本没落到 DDR**。前后不平移，就不是"丢拍后整体前移"，
 *       而是这一小段写没落地。（读太早也长这样 —— 但读之前已经 msleep(20) 了，
 *       所以"读太早"基本被排除，更像写侧真丢。）
 *     · **tok 段和 logits 段要分开看**：帧 1/2 的 tok 段跟帧 4..8 的 tok 只差
 *       上面那些底色残渣（32 / 96 字节），但它们的 **logits 段有 150~159/300 不同**，
 *       而且帧 1、2 的 logits **彼此完全相同**；帧 3 的 logits 又是另一份。
 *       ⇒ logits 这条路上**头几帧本身就不一样**（tok 对、logits 不对，两条支路分开走）。
 *     · 四次运行的 `frames` 里，"不一样的帧"的位置每次都挪（6,7 → 5,6 → 3..7 → 2,3），
 *       **不是固定第 N 帧** ⇒ 不是 IP 的确定性跨帧状态，是**抓取时刻**在飘。
 *   ⇒ 两个独立的毛病：① 直读一帧一挂的启动空档（帧 1 必短）；② logits 支路头几帧
 *     不收敛。**下一步先跑 `e2e`** —— 它只挂**一次**、LENGTH 直接给 5472，
 *     把①整条轴摘掉；若 got 是 5472，就说明 DMA 不吃 TLAST、能一发收满。
 *   另外修了一处**我自己判据的自伤**：帧 4..8 五个块一模一样，逐帧那个"高字节不合规
 *   ⇒ 错位"却对着其中两块照报 —— 数都相同，错位轮不到它。现在凡是"跟别的帧逐字节
 *   相同"的块，一律不报"错位"（标成"判据太严"）。
 *
 * 【2026-10-16 第四次改动：axi_dma_1 又开回 C_INCLUDE_SG=1 —— 这次让程序自己认】
 *   10-16 那份 BD 把 dma1 的 SG 重新打开了（.xci 里 C_INCLUDE_SG=1），于是**直读那组
 *   寄存器又不存在了** —— 写 DA+LENGTH 什么都不发生，只会一路超时，还不报错。
 *   上一版靠"默认直读 + `--sg` 切换"控制，每换一次 BD 就得改命令行，太脆。
 *   改成：**启动时读 S2MM DMASR 的 bit3(SGIncld) 自己判断**。那个位是 IP 参数
 *   C_INCLUDE_SG 的**回显**，不是状态位，任何时候读都作数：
 *     板上实测 dma0(SG=1) DMASR=0x00010009（bit3 置）
 *              dma1(SG=0) DMASR=0x00000001（bit3 清）—— 和 .xci 里一一对上。
 *   ⇒ BD 里那个开关以后**开也好关也好，同一个二进制都能跑**，不用换命令行。
 *     `--sg` / `--simple` 降级成"我非要这么走"的强制覆盖（和硬件打架时会警告）。
 *
 * 【2026-10-15 第三次改动：axi_dma_1 曾改回 C_INCLUDE_SG=0，当时直读是默认】
 *   设备树 + 内核 xilinx-vdma 那条路放弃了（中断号在厂商文件里根本查不到，实测又要
 *   跟驱动抢同一个引擎）。回到纯用户态轮询：
 *     * 当时 BD 里 axi_dma_1 的 C_INCLUDE_SG = 0，`opt_simple` 默认 1；
 *     * 直读模式没有描述符，实收字节以**内存**里的 0xA5 底色边界为准。
 *   （"默认走谁"已被第四次改动取代，其余描述仍然成立。）
 *   **dma0(MM2S) 一直没动，始终是 C_INCLUDE_SG=1** —— 8192B 那条路已经验过。
 *
 * 【2026-10-15 第二次改动（= 现在 `--sg` 那条路）：axi_dma_1 开了 SG 之后】
 *   上一版 axi_dma_1 是 C_INCLUDE_SG=0，S2MM 走的是"直读模式"——写 S2MM_DA(0x48)
 *   + 写 S2MM_LENGTH(0x58) 就收一帧。**开了 SG 之后那两个寄存器就不认了**：
 *     * Xilinx 自己的驱动 XAxiDma_SimpleTransfer() 第一句就是
 *         if (XAxiDma_HasSg(InstancePtr)) { ... "Simple DMA mode is not supported"; }
 *     * .hwh 里 DMASR 的说明也写着"仅 Direct Register Mode 下写 LENGTH 才有效"，
 *       并且 SG 模式下写 CURDESC/TAILDESC 在 halted 时才有效。
 *   照旧写 DA+LENGTH 的结果是**什么都不发生**，然后超时——所以默认路径必须换成
 *   描述符环 —— 这条路只在 BD 里把 SG 打开、命令行加 `--sg` 时才走（现在是备选）。
 *
 *   换成环之后有个额外好处：**长度写在描述符里，实收字节由硬件回写到描述符的
 *   STATUS**，不用再靠数 0xA5 底色去猜。而且一帧收完 TLAST，硬件自己走到下一个
 *   描述符，中间不需要 CPU 插手——之前那个"每帧少 8 拍"的重挂空档从根上没有了。
 *
 *   开跑顺序照 Xilinx 驱动 XAxiDma_BdRingStart()： CURDESC → RS=1 → TAILDESC，
 *   最后写 TAILDESC 那一下才是"开跑"。顺序写错的表现同样是"什么都不发生"。
 *   描述符布局用 BSP 的 xaxidma_bd.h（64 字节，NXTDESC 0x00 / BUFA 0x08 /
 *   CTRL 0x18 / STATUS 0x1C）—— 和 MM2S 那边一直在用的是同一套，已知能跑。
 *
 * 【2026-10-15 的 IP 升级：两条流并成一条，并且有 TLAST 了】
 *   旧 IP 是 tok_out_V_V / logits_out_V_V 两条 32bit 无边界流；新的只有一条 dout。
 *   实测契约（HLS 源码 SRC/top.hpp:295-298 + top.cpp:113-146，与生成 RTL 逐条对上）：
 *     * 一拍 32bit；TKEEP/TSTRB 恒 4'hF（零信息量）；
 *     * 每帧 171 拍 = 684 B：拍 0..95 = 96 个 tok 拍（4 个 INT8/拍，小端），
 *                           拍 96..170 = 75 个 logits 拍（2 个 INT16/拍，小端）；
 *     * **TLAST 只在每帧第 170 拍**置 1，其余全 0；
 *     * 一次调用 = 8 帧 = 1368 拍 = 5472 B，共 8 个 TLAST。
 *   所以 s_axis_s2mm_tlast 现在应该已经连上了（上一版是悬空的）。
 *   ⚠️ AXI DMA **没有任何可以读 TLAST 的寄存器**（xaxidma_hw.h 里 0x38 是
 *      S2MM_CURDESC，不是 TLAST；整个驱动源码不含 TLAST 字样）。所以 TLAST 只能
 *      **间接**验证：给 S2MM 一个大于一帧的 LENGTH，如果它只收了一帧就 IOC，
 *      那就是 TLAST 在起作用 —— 这正是 `e2e` 里那段判读。
 *
 * 【一"次调用"的字节数】
 *   进：8 帧 × 256 字 = 2048 字 = 1024 个 64bit beat = 8192 B
 *   出：8 帧 × 171 拍 × 4 B = 8 × 684 = 5472 B
 *
 * 【用法】
 *   ./pl_dma_test probe              只读写寄存器，验证两个窗口通不通（最安全，先跑这个）
 *   ./pl_dma_test s2mm [字节数]       抓 dout 到 udmabuf（走法按硬件自动选）
 *   ./pl_dma_test mm2s [字节数]       axi_dma_0 SG 模式，把 udmabuf 里的图案灌进 HLS
 *   ./pl_dma_test e2e                端到端一次调用（8192B 进 / 5472B 出），并判读 TLAST
 *   ./pl_dma_test frames             收 8 帧（每帧 684B）。**走法按硬件自动选**：有 SG 就
 *                                    一个 8 描述符的环一次挂满，没有就一帧一挂
 *   ./pl_dma_test sg2                把「挂」和「跑」拆开测，两个通道分开（--mm2s/--s2mm）
 *                                    带 --xfer=N / --ring=N 可以把"长度"和"环大小"分开验
 *   ./pl_dma_test carpet             描述符地毯：测引擎实际读的是哪个地址
 *
 * 【调试顺序（2026-10-15 定）】
 *   先把软件侧能问的都问干净，再上 ILA —— 顺序是：
 *     probe -> sg2 -> carpet -> （还定位不到）ILA
 *   2026-10-15 那一轮板上跑完之后，范围已经压小了（详细判读见下面 sg2/carpet 那两段的注释）：
 *     · MM2S 的 SG 通路**是通的**：地毯里 1024 字节的描述符被取、被回写、环也走了
 *       （上一轮"SG 取描述符这条路拿不到 DDR 内容"的结论**被这一轮推翻**）；
 *     · 两个通道在 **sg2（2 格环）** 上表现不同：MM2S 报 SGIntErr、S2MM 走到尾指针正常停；
 *     · **SGIntErr 的成因是唯一的**（PG021 原文）：引擎取到一条 **COMPLETE 已置位**的
 *       描述符。所以先排除"取到上一轮残留的旧描述符"（已经默认在挂之前清零 64KB），
 *       再看形状（长度/环大小）—— `--xfer` / `--ring` 就是干这个的。
 *   判"下一步"只看这几样证据：CURDESC 落在环里第几格、哪几格 STATUS 被回写（含**空档**）、
 *   数据侧实收多少字节、有没有报错、报的是哪个错位。**不看 Idle**（引擎手里没活也是 Idle）。
 *   `carpet` 的两种结果都是答案：**取动了**说明引擎读的是另一个地址（并直接告出是哪个
 *   地址），**完全不动**说明跟描述符内容无关。只有第二种才值得去动 ILA；
 *   具体抓哪根线看那份对照表：doc/pl_sg_ila.md
 *   ⚠️ 别再做「删了重建 smartconnect_0」「改 burst size」这种没有机理的尝试 —— 已经查过，
 *      四个从口的 MMU 配置逐字节相同、burst size 也在合法范围内。
 *
 * 【可选参数】
 *   --dma0=0x...     MM2S 寄存器基址，默认 0x80400000
 *   --dma1=0x...     S2MM 寄存器基址，默认 0x80410000
 *   --buf-phys=0x... 手工指定 DMA 缓冲区物理地址（默认从 sysfs 读）
 *   --in=文件名       把该文件内容灌到 MM2S 源缓冲区（默认是内置测试图案）
 *   --alt-desc       用 PG021"32bit 地址"描述符布局（默认用 Xilinx BSP 的 64B 布局）
 *   --simple         S2MM 走直读模式（写 DA+LENGTH）—— **现在就是默认**，留着兼容
 *   --sg             S2MM 改走 SG 描述符环（要求 BD 里 axi_dma_1 开了 SG）
 *   --slow-rearm     frames 每帧都软复位重挂（复现老现象用，只在直读模式下有意义）
 *   --timeout=ms     单次传输超时，默认 5000
 *
 * 【关于 --alt-desc】
 *   AXI DMA 的 SG 描述符布局有两种流传的说法：
 *     A（默认）Xilinx BSP xaxidma_bd.h 的布局——NXTDESC 0x00 / MSB 0x04 / BUFA 0x08 /
 *              MSB 0x0C / CTRL 0x18 / STATUS 0x1C，描述符 64 字节对齐。
 *              2018.3 和 2025.2 的 embeddedsw 里都是这个布局，而且
 *              XAxiDma_BdRingCreate() 是**无条件**往 0x04 写 NXTDESC_MSB 的，
 *              说明 32bit 地址的设计里这个字也存在（写 0）。所以默认用它。
 *     B（--alt-desc）PG021 里"32bit 地址"那张表——NXTDESC 0x00 / BUFA 0x04 /
 *              CTRL 0x0C / STATUS 0x10。
 *   万一 A 不对（DMASR 出现 SG 解码错误 0x400，或 BD 的 STATUS 一直没有 COMPLETE），
 *   加 --alt-desc 再跑一次即可，不用改代码。
 *
 * 编译：见同目录 build.sh（docker + aarch64-linux-gnu-gcc）
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/ioctl.h>

/* ─────────────────────────── AXI DMA 寄存器偏移 ───────────────────────────
 * 取自 Xilinx SDK 的 xaxidma_hw.h（2018.3 的 axidma_v9_3 与 2025.2 的 v9_20 一致）
 */
#define MM2S_CR      0x00   /* MM2S_DMACR  [0]RS [2]Reset [23:16]IRQThreshold */
#define MM2S_SR      0x04   /* MM2S_DMASR */
#define MM2S_CURDESC 0x08   /* 当前描述符物理地址 */
#define MM2S_TAILDESC 0x10  /* 尾描述符物理地址（写它 = 触发传输） */
#define MM2S_SGCTL   0x2c

#define S2MM_CR      0x30   /* S2MM_DMACR */
#define S2MM_SR      0x34   /* S2MM_DMASR */
#define S2MM_CURDESC 0x38   /* SG：当前描述符 */          /* 0x30 + 0x08 */
#define S2MM_TAILDESC 0x40  /* SG：尾描述符（写它 = 开跑） */  /* 0x30 + 0x10 */
#define S2MM_DA      0x48   /* 直读模式的目标地址（SG 模式下无效） */  /* 0x30 + 0x18 */
#define S2MM_LENGTH  0x58   /* 直读模式写它启动（SG 模式下无效） */  /* 0x30 + 0x28 */

#define CR_RUNSTOP   0x00000001u
#define CR_RESET     0x00000004u
#define CR_THRESHOLD(x) (((x) & 0xff) << 16)

/* DMASR 的位定义 —— **以 IP 自己的元数据为准，不是凭印象**：
 * 2018.3 的 axi_dma_v7_1/component.xml 里 S2MM_DMASR / MM2S_DMASR 的字段偏移
 *   bit0 Halted / bit1 Idle / bit3 SGIncld / bit4 DMAIntErr / bit5 DMASlvErr /
 *   bit6 DMADecErr / bit8 SGIntErr / bit9 SGSlvErr / bit10 SGDecErr /
 *   bit12 IOC_Irq / bit13 Dly_Irq / bit14 Err_Irq /
 *   bit16-23 IRQThresholdSts / bit24-31 IRQDelaySts
 * 和 BSP 的 xaxidma_hw.h 完全一致（驱动只是没定义 SGIncld 那一位）。
 * 注：这里曾经按"PG021 把 DMAIntErr 放 bit3"写过一版 —— 那是错的，bit3 是 SGIncld。 */
#define SR_HALTED    0x00000001u
#define SR_IDLE      0x00000002u
#define SR_SGINCLD   0x00000008u  /* 该 IP 有没有 SG 引擎（=C_INCLUDE_SG）。
                                   * 判"板子上烧的是不是我们要的那版 bitstream"就看它：
                                   * **axi_dma_0 必须读到 1（SG），axi_dma_1 必须读到 0（直读）**。
                                   * 两个都对才说明 BD 里那两个开关都改到位了；probe 会打出来。
                                   * （2026-10-15 第三次改动前，dma1 是 1 —— 那版现在不要了） */
#define SR_ERR       0x00000070u  /* DMAIntErr | DMASlvErr | DMADecErr */
#define SR_ERR_SG    0x00000700u  /* SGIntErr | SGSlvErr | SGDecErr */
#define SR_IOC       0x00001000u  /* 传输完成 */
#define SR_IRQ_ERR   0x00004000u

/* 描述符 CONTROL 字（PG021 / xaxidma_bd.h） */
#define BD_CTRL_SOF  0x08000000u  /* bit27 */
#define BD_CTRL_EOF  0x04000000u  /* bit26 */
#define BD_CTRL_LEN(l) ((l) & 0x03FFFFFFu)  /* [25:0] 长度 */

#define BD_STS_COMPLETE 0x80000000u
#define BD_STS_ERR      0x70000000u
#define BD_STS_RXSOF    0x08000000u  /* bit27：本描述符收的是帧头 */
#define BD_STS_RXEOF    0x04000000u  /* bit26：收到 TLAST，帧到此为止 */
/* 硬件回写进 STATUS 低位的**实收字节数**。字段宽度是 IP 参数 C_SG_LENGTH_WIDTH
 * （axi_dma_1 是 16，所以实际只用到低 16 位；axi_dma_0 是 14）。
 * 按 26 位掩码取是安全的——上面那几位是 flag，再往上没有别的字段。 */
#define BD_STS_LEN_MASK 0x03FFFFFFu

/* ──────────────────── GIC-400 的 distributor（查中断号用） ────────────────────
 * 设备树里 `interrupt-controller@f8910000`（`compatible = "arm,gic-400"`）的
 * reg 第一段就是 GICD：`reg = <0xf8910000 0x10000 ...>`（原样抄自 dts，不是记忆）。
 * GICv2 的 GICD 偏移是架构固定的，每 32 个中断一个字：
 *   GICD_CTLR 0x000 / ISENABLER 0x100 / ICENABLER 0x180 / ISPENDR 0x200 /
 *   ICPENDR 0x280 / ISACTIVER 0x300 / ICACTIVER 0x380（这四个都是 32 位/字）
 *   IPRIORITYR 0x400 / ITARGETSR 0x800（**这两个是一个中断一个字节**）
 *   ICFGR 0xC00（一个中断 2 位：00 = 电平，10 = 边沿）
 * 所以 SPI 号 s 落在「字 s/32、位 s%32」；GICv2 的 SPI 只有 32..95。
 *
 * 为什么这东西能把「IRQ_F2P[n] → 哪个 SPI」问出来：
 *   从 PL 上来的是**电平型**中断线，DMA 会一直把它拉高，直到有人写 DMASR 清掉源。
 *   于是在 GIC 侧把候选 SPI **使能**之后，只要线还悬着，pending 位立刻就是 1。
 *   全程不需要任何驱动配合 —— 唯一的敌人是「有别的驱动把这个位吃掉了」。
 */
#define DEF_GICD        0xf8910000UL
#define GICD_CTLR       0x000u
#define GICD_ISENABLER  0x100u
#define GICD_ICENABLER  0x180u
#define GICD_ISPENDR    0x200u
#define GICD_ICPENDR    0x280u
#define GICD_ISACTIVER  0x300u
#define GICD_ICACTIVER  0x380u
#define GICD_IPRIORITYR 0x400u
#define GICD_ITARGETSR  0x800u
#define GICD_ICFGR      0xc00u
#define SPI_FIRST   32u   /* 0..15 是 SGI、16..31 是 PPI，都不在这条路上 */
#define SPI_LAST    95u   /* GICv2 一共 64 个 SPI（32..95） */
#define SPI_DEF_LO  61u   /* 默认扫这一段：7z030 规则下 IRQ_F2P[0..7]=61..68、 */
#define SPI_DEF_HI  91u   /* IRQ_F2P[8..15]=84..91 —— 两段接起来正好是连续的 61..91 */

/* ─────────────────────────── u-dma-buf 的 ioctl ───────────────────────────
 * 这个驱动的 ioctl 号在各分支/各版本之间差别很大（魔数大小写、命令号、
 * 参数是结构体还是一个裸 u64 都变过），而且从 sysfs 里读不出来。
 * 所以**不猜**：启动时把下面这张候选表逐个 ioctl 试一遍，哪个返回 0 就用哪个。
 * ioctl 是按号精确匹配分发的，号不对驱动直接回 ENOTTY，不会产生副作用。
 *
 * 为什么非要同步不可：udmabuf0 若被 mmap 成**可缓存**的，CPU 对描述符的写入
 * 会停在 cache 里，硬件回写的 STATUS 也会被 CPU 的旧 cache line 盖掉 ——
 * 这正是「描述符 8 个字原样不动、STATUS 一个都没写」最可能的解释。
 */
struct u_dma_buf_sync {          /* 老版：offset + size + flags */
    uint64_t offset;
    uint64_t size;
    uint64_t flags;
};
#define U_DMA_BUF_SYNC_TO_DEVICE   0x00000001u  /* CPU 写完交给设备：flush */
#define U_DMA_BUF_SYNC_FROM_DEVICE 0x00000002u  /* 设备写完交给 CPU：invalidate */

#define SYNC_FOR_DEVICE  1   /* udmabuf_sync() 的方向参数 */
#define SYNC_FOR_CPU     0

#define SYNC_KIND_U64    0   /* 参数是一个裸 u64（新版 owner-handoff 模型） */
#define SYNC_KIND_STRUCT 1   /* 参数是上面的 24 字节结构体 */
#define SYNC_KIND_OWNER  2   /* GET_SYNC_OWNER，只是个探针，不用于同步 */

struct sync_impl {
    const char        *name;
    unsigned long      cmd_dev;  /* 交给设备方向用的 ioctl 号 */
    unsigned long      cmd_cpu;  /* 交回 CPU 方向用的号；0 = 与 cmd_dev 同号 */
    int                kind;
};

static const struct sync_impl sync_cand[] = {
    { "新版 大写'U' owner-handoff：_IOW('U',6/5,u64)",
      _IOW('U', 6, uint64_t), _IOW('U', 5, uint64_t), SYNC_KIND_U64 },
    { "新版 小写'u' owner-handoff：_IOW('u',6/5,u64)",
      _IOW('u', 6, uint64_t), _IOW('u', 5, uint64_t), SYNC_KIND_U64 },
    { "旧版 大写'U' SYNC：_IOW('U',0,结构体)，flags 选方向",
      _IOW('U', 0, struct u_dma_buf_sync), 0, SYNC_KIND_STRUCT },
    { "旧版 小写'u' SYNC：_IOW('u',0,结构体)，flags 选方向",
      _IOW('u', 0, struct u_dma_buf_sync), 0, SYNC_KIND_STRUCT },
    { "变体 大写'U' SYNC：_IOW('U',9,结构体)",
      _IOW('U', 9, struct u_dma_buf_sync), 0, SYNC_KIND_STRUCT },
    { "变体 小写'u' SYNC：_IOW('u',9,结构体)",
      _IOW('u', 9, struct u_dma_buf_sync), 0, SYNC_KIND_STRUCT },
    { "无参探针 GET_SYNC_OWNER：_IOR('U',4,u32)",
      0, 0, SYNC_KIND_OWNER },
};
#define SYNC_NCAND ((int)(sizeof(sync_cand) / sizeof(sync_cand[0])))

static int sync_pick = -1;      /* 探到的可用候选下标；-1 = 没探到，不做同步 */
static int sync_via_sysfs = 0;  /* 板上的 u-dma-buf 有 sync_for_cpu/sync_for_device 的话走这条路 */

/* ─────────────────────────── 默认参数 ─────────────────────────── */
#define DEF_DMA0   0x80400000UL
#define DEF_DMA1   0x80410000UL
#define REG_WINDOW 0x10000UL

#define UDMABUF_NAME "udmabuf0"

/* udmabuf 内部的排布 */
#define BD_OFF    0x000000UL   /* MM2S 的描述符（1 个），64 字节对齐 */
#define BD1_OFF   0x000100UL   /* S2MM 的 8 个描述符：64 对齐，8×64 = 512 B -> 0x100..0x2FF */
#define SRC_OFF   0x001000UL   /* MM2S 源缓冲 */
#define DST_OFF   0x010000UL   /* S2MM 目标缓冲 */
#define SRC_MAX   65536UL
#define DST_MAX   65536UL
#define MAP_LEN   (DST_OFF + DST_MAX)   /* 实际要 mmap 的那一段，页对齐 */

#define CALL_IN_BYTES   8192u   /* 一次调用的输入：1024 beat × 8B */

/* 输出侧：复合流 dout 的帧结构（出处 SRC/top.hpp:295-298） */
#define TOK_BEATS       96u     /* N_TOKEN(4) × TOK_DIM(96)/4 —— 4 个 INT8/拍 */
#define LOG_BEATS       75u     /* HEAD_CO(150) / 2        —— 2 个 INT16/拍 */
#define FRAME_BEATS     171u    /* TOK_BEATS + LOG_BEATS */
#define N_FRAMES_OUT    8u      /* 一次调用 8 帧 */
#define FRAME_OUT_BYTES 684u    /* FRAME_BEATS × 4B */
#define TOK_FRAME_BYTES 384u    /* TOK_BEATS × 4B */
#define LOG_FRAME_BYTES 300u    /* LOG_BEATS × 4B */
#define CALL_OUT_BYTES  5472u   /* 8 帧 × 684B */

/* ─────────────────────────── 全局状态 ─────────────────────────── */
static volatile uint32_t *reg0;      /* axi_dma_0 寄存器 */
static volatile uint32_t *reg1;      /* axi_dma_1 寄存器 */
static uint8_t  *buf_va;             /* udmabuf 映射后的虚拟地址 */
static uint64_t  buf_pa;             /* udmabuf 物理地址 */
static uint64_t  buf_size;
static size_t    g_map_len;          /* 当前 mmap 了多长（carpet 可能要扩） */
static int       buf_fd = -1;

static int   opt_alt_desc = 0;
static int   opt_timeout_ms = 5000;
static const char *opt_infile = NULL;
static int   opt_buf_mem = 0;        /* 缓冲区改走 /dev/mem 的非缓存映射 */
static int   opt_evict = 1;          /* 读结果前先挤一次缓存（默认开，--no-evict 关掉） */
static int   opt_slow_rearm = 0;     /* frames：每帧都走 do_s2mm（软复位+sync+挤缓存）的老路子 */
static int   opt_mode_auto = 1;      /* 1 = 没人指定，按 DMASR bit3(SGIncld) 自己选走法；
                                      * --sg / --simple / --slow-rearm 都会把它清 0 */
static int   opt_simple = 1;         /* S2MM 走直读模式（写 DA+LENGTH）—— 这只是占位值，
                                      * main 里会按硬件读回的 DMASR.SGIncld 重定；只有用户给了
                                      * --sg / --simple 才会被钉死 */
static int   opt_no_drain = 0;       /* frames：不做开头那次"冲残留"（排查用，见那里的注释） */
static int   opt_one = 0;            /* e2e：--one = 老行为，第一笔收到哪儿就收手，
                                      * **不**把剩下 7 帧补收干净（那些会被留在 IP 输出里） */
static uint32_t opt_dst_shift = 0;   /* frames/e2e：S2MM 目标基址整体往后再挪这么多字节
                                      * （默认 0）。**判别实验用**：见下面那段注释。
                                      * 板上的洞永远是"绝对偏移 ≡ 0 (mod 64)"，可帧起点
                                      * 自己不是 64 对齐的（684 mod 64 = 44）。拿这个开关
                                      * 把基址挪 32 字节再跑：
                                      *   · 洞变成 ≡ 32 (mod 64) ⇒ 量化跟着 S2MM_DA 走，
                                      *     是 **DMA 自己**在数"第几个 64 B 块"；
                                      *   · 洞仍是 ≡ 0 (mod 64) ⇒ 跟 DA 无关，是**系统地址**
                                      *     那一层（互连 / HP 口 / DDR 控制器）。
                                      * 两边都能一次跑出来，不用动 RTL。 */
static int   opt_chan = 0;           /* sg2/carpet：0=两个通道都测，1=只 MM2S，2=只 S2MM */
static int   opt_wait_halted = 1;    /* 写 TAILDESC 之前先等 DMASR.Halted 变 0（见 sgprobe 的注释）。
                                      * 默认开：BSP 自己的开跑路径就是这么做的，关掉只用于对比测试 */
static long  opt_xfer = 0;           /* --xfer=N：sg2 每个描述符多少字节（默认取通道典型值） */
static int   opt_ring = 0;           /* --ring=N：sg2 的环有几格（默认 2） */
static long  opt_carpet_len = 0;     /* --carpet-len=N：地毯里每个描述符多少字节 */
static int   opt_no_zero = 0;        /* --no-zero：不清描述符区（默认清，理由见 desc_scan 上面） */

/* irqscan 用的（见下面 cmd_irqscan） */
static uint64_t opt_gic_base = 0;    /* --gic=0x...：GICD 基址（0 = 用 DEF_GICD） */
static long  opt_spi_lo = 0;         /* --spi-lo=N：扫描区间下界（默认 SPI_DEF_LO） */
static long  opt_spi_hi = 0;         /* --spi-hi=N：上界（默认 SPI_DEF_HI） */
static int   opt_no_enable = 0;      /* --no-enable：irqscan 只读不使能（纯非侵入版本） */


static void sync_probe(int verbose);   /* 见下面：探测 u-dma-buf 的同步 ioctl */

static inline uint32_t rd(volatile uint32_t *b, uint32_t off) { return b[off >> 2]; }
static inline void     wr(volatile uint32_t *b, uint32_t off, uint32_t v) { b[off >> 2] = v; }

static uint64_t now_ms(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000u + (uint64_t)ts.tv_nsec / 1000000u;
}

static uint64_t now_us(void)      /* RS=1 到 Halted 变 0 之间的"lag"要微秒级才看得见 */
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000u + (uint64_t)ts.tv_nsec / 1000u;
}

static void die(const char *msg)
{
    fprintf(stderr, "错误: %s: %s\n", msg, strerror(errno));
    exit(1);
}

static void msleep(int ms)
{
    struct timespec ts = { ms / 1000, (long)(ms % 1000) * 1000000L };
    nanosleep(&ts, NULL);
}

/* 输出 .bin 的文件名带**本轮**的戳，一次进程只算一次。
 * 为什么非要这样：板上连跑几次 `frames`，每次都用 `cp pl_dma_test_frames.bin runA.bin`
 * 同一个名字，八次跑最后只剩最后一份 —— 这个坑已经吃掉两批数据了（还害我把"其实
 * 完全一致"的八份当成"不一致"）。带戳之后，重名的 cp 会**直接报错**（文件不存在），
 * 而不是静悄悄地把上一次的结果盖掉。 */
static const char *run_tag(void)
{
    static char tag[40];
    if (!tag[0]) {
        time_t t = time(NULL);
        struct tm tm;
        localtime_r(&t, &tm);
        snprintf(tag, sizeof(tag), "%02d%02d%02d-%d",
                 tm.tm_hour, tm.tm_min, tm.tm_sec, (int)getpid());
    }
    return tag;
}

/* ─────────────────────────── /dev/mem ─────────────────────────── */
static volatile uint32_t *map_regs(uint64_t pa, const char *what)
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0)
        die("open /dev/mem（需要 root）");
    void *p = mmap(NULL, REG_WINDOW, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)pa);
    if (p == MAP_FAILED)
        die("mmap /dev/mem DMA 寄存器");
    close(fd);
    printf("  %s 寄存器 %#lx 映射到 %p\n", what, (unsigned long)pa, p);
    return (volatile uint32_t *)p;
}

/* ─────────────────────────── u-dma-buf ─────────────────────────── */
/* 读一个 sysfs 文本属性，原样留一份好打印出来排错 */
static int read_sysfs_raw(const char *path, char *out, size_t sz)
{
    int fd = open(path, O_RDONLY);
    if (fd < 0)
        return -1;
    ssize_t n = read(fd, out, sz - 1);
    close(fd);
    if (n < 0)
        return -1;
    out[n] = '\0';
    return 0;
}

/* 往 sysfs 写一个值。返回 0 表示写成功。 */
static int write_sysfs(const char *path, const char *val)
{
    int fd = open(path, O_WRONLY);
    if (fd < 0)
        return -1;
    ssize_t n = write(fd, val, strlen(val));
    int e = errno;
    close(fd);
    errno = e;
    return n == (ssize_t)strlen(val) ? 0 : -1;
}

/* u-dma-buf 的 sysfs 到底是 "0x08000000" 还是 "134217728"，
 * 各版本/各家分支不一样，猜错一位就是 4 倍差距。所以按前缀判断，不写死进制。 */
static uint64_t parse_maybe_hex(const char *s)
{
    while (*s == ' ' || *s == '\t') s++;
    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
        return strtoull(s + 2, NULL, 16);
    return strtoull(s, NULL, 10);
}

static void udmabuf_open(void)
{
    char path[256], raw[128];

    /* 先把 sysfs 里的东西原样打出来——排错全靠它 */
    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/phys_addr", UDMABUF_NAME);
    if (read_sysfs_raw(path, raw, sizeof(raw)) == 0) {
        printf("  %s = %s", path, raw);
        if (buf_pa == 0)
            buf_pa = parse_maybe_hex(raw);
    } else {
        snprintf(path, sizeof(path), "/sys/udmabuf/%s/phys_addr", UDMABUF_NAME);
        if (read_sysfs_raw(path, raw, sizeof(raw)) == 0) {
            printf("  %s = %s", path, raw);
            if (buf_pa == 0)
                buf_pa = parse_maybe_hex(raw);
        } else {
            fprintf(stderr, "  读不到 phys_addr（%s 和 /sys/udmabuf/... 都没有）\n",
                    UDMABUF_NAME);
        }
    }

    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/size", UDMABUF_NAME);
    if (read_sysfs_raw(path, raw, sizeof(raw)) == 0) {
        printf("  %s = %s", path, raw);
        buf_size = parse_maybe_hex(raw);
    }

    /* 顺手把和"缓存一致性"有关的属性全列出来——决定 DMA 写完 CPU 看不看得见。
     * 哪个文件不存在就跳过，不同 u-dma-buf 版本的属性集不一样。 */
    {
        static const char *attrs[] = {
            "sync_mode", "dma_coherent", "alloc_type", "driver_version",
            "sync_direction", "sync_owner", "sync_offset", "sync_size", "owner",
        };
        for (unsigned i = 0; i < sizeof(attrs) / sizeof(attrs[0]); i++) {
            snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/%s",
                     UDMABUF_NAME, attrs[i]);
            if (read_sysfs_raw(path, raw, sizeof(raw)) == 0)
                printf("  %s = %s", path, raw);
        }
    }

    if (buf_pa == 0) {
        fprintf(stderr,
            "读不到 %s 的物理地址。确认 /sys/class/u-dma-buf/%s/ 存在，\n"
            "或者用 --buf-phys=0x... 手工指定。\n", UDMABUF_NAME, UDMABUF_NAME);
        exit(1);
    }

    const size_t map_len = MAP_LEN;

    /* 实验通路 A：绕过 u-dma-buf，直接拿物理地址走 /dev/mem。
     * /dev/mem 的映射是非缓存的（pgprot_noncached），CPU 写完直达 DDR，
     * DMA 写完 CPU 立刻看得见 —— 如果 --buf-mem 让一切都通了，
     * 就说明 /dev/udmabuf0 那块内存对 CPU 是可缓存的，而 DMA 走 HP 口不 snoop。 */
    if (opt_buf_mem) {
        int fd = open("/dev/mem", O_RDWR | O_SYNC);
        if (fd < 0)
            die("open /dev/mem");
        buf_va = mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)buf_pa);
        int e = errno;
        close(fd);
        if (buf_va == MAP_FAILED) {
            fprintf(stderr,
                "  错误: --buf-mem 用 /dev/mem 映射 %#llx 失败 (%s)\n"
                "  内核若开了 STRICT_DEVMEM 就不让映射 RAM，那就去掉 --buf-mem\n",
                (unsigned long long)buf_pa, strerror(e));
            exit(1);
        }
        printf("  udmabuf : 物理 %#llx，经 /dev/mem 非缓存映射 %#zx 字节到 %p\n",
               (unsigned long long)buf_pa, map_len, buf_va);
        g_map_len = map_len;
        return;
    }

    char dev[128];
    snprintf(dev, sizeof(dev), "/dev/%s", UDMABUF_NAME);

    /* mmap 长度只取我们真正用到的那一段（描述符 + 源缓冲 + 目标缓冲），
     * 不用 sysfs 里的 size 当长度——那个值一旦解析错就会 EINVAL。 */

    buf_fd = open(dev, O_RDWR);
    if (buf_fd < 0)
        buf_fd = open(dev, O_RDWR | O_SYNC);     /* 有些内核要 O_SYNC */
    if (buf_fd < 0)
        die(dev);

    buf_va = mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, buf_fd, 0);
    if (buf_va == MAP_FAILED) {
        int e = errno;
        fprintf(stderr,
            "  错误: mmap %s 失败 (%s)，请求长度 %#zx\n"
            "  上面打出来的 phys_addr / size 原样贴出来就能定位。\n"
            "  手工试一下： --buf-phys=0x<phys_addr>   （跳过 sysfs 解析）\n", dev, strerror(e), map_len);
        exit(1);
    }

    printf("  udmabuf : 物理 %#llx，映射 %#zx 字节到 %p\n",
           (unsigned long long)buf_pa, map_len, buf_va);
    g_map_len = map_len;

    if (buf_size && buf_size < map_len) {
        fprintf(stderr, "udmabuf0 只有 %llu 字节，不够 %#zx\n",
                (unsigned long long)buf_size, map_len);
        exit(1);
    }

    /* 先看板上这个 u-dma-buf 有没有 sysfs 的同步口（ikwzm 版有，而且 ioctl 往往没有）；
     * 有的话就用它，不再去猜 ioctl。 */
    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/sync_for_cpu", UDMABUF_NAME);
    if (access(path, W_OK) == 0) {
        sync_via_sysfs = 1;
        printf("u-dma-buf 同步：用 sysfs（%s 可写），不用 ioctl\n", path);
    } else {
        /* 没有 sysfs 口，退回老办法：把 ioctl 候选全试一遍 */
        sync_probe(1);
    }
}

/* 拿一个候选去调一次。for_dev=1 走「交给设备」方向，0 走「交回 CPU」方向。
 * size 给 0 表示只探通不通、不真动数据（结构体版能这么干）。 */
static int sync_impl_call(int idx, int for_dev, uint64_t size, int *saved_errno)
{
    const struct sync_impl *c = &sync_cand[idx];
    unsigned long cmd = for_dev ? c->cmd_dev : (c->cmd_cpu ? c->cmd_cpu : c->cmd_dev);
    int rc;

    errno = 0;
    if (c->kind == SYNC_KIND_U64) {
        uint64_t v = 0;                       /* 参数当「偏移/大小」都先塞 0 */
        rc = ioctl(buf_fd, cmd, &v);
    } else if (c->kind == SYNC_KIND_OWNER) {
        uint32_t v = 0;
        rc = ioctl(buf_fd, _IOR('U', 4, uint32_t), &v);
    } else {
        struct u_dma_buf_sync s = { 0, size,
                                    (for_dev ? U_DMA_BUF_SYNC_TO_DEVICE
                                             : U_DMA_BUF_SYNC_FROM_DEVICE) };
        rc = ioctl(buf_fd, cmd, &s);
    }
    if (saved_errno) *saved_errno = errno;
    return rc;
}

/* 把候选表全试一遍，挑出驱动认得的那一对。quiet=1 时只在探到时打一行。 */
static void sync_probe(int verbose)
{
    sync_pick = -1;
    if (opt_buf_mem || buf_fd < 0)
        return;

    if (verbose) {
        printf("u-dma-buf 同步接口探测（/dev/%s）：\n", UDMABUF_NAME);
        printf("  %-52s %-10s %s\n", "候选", "返回", "errno");
    }

    for (int i = 0; i < SYNC_NCAND; i++) {
        int e1 = 0, e2 = 0;
        int r1 = sync_impl_call(i, 1, 0, &e1);   /* 先问「交给设备」方向 */
        int r2 = sync_impl_call(i, 0, 0, &e2);   /* 再问「交回 CPU」方向 */

        if (verbose) {
            char rbuf[32];
            if (r1 == 0) snprintf(rbuf, sizeof rbuf, "OK");
            else         snprintf(rbuf, sizeof rbuf, "%d", r1);
            printf("  %-52s %-10s %s", sync_cand[i].name, rbuf,
                   r1 == 0 ? "-(认了)" : strerror(e1));
            if (r2 != 0)
                printf("   [反方向 errno=%d %s]", e2, strerror(e2));
            printf("\n");
        }

        if (r1 == 0 && sync_pick < 0 && sync_cand[i].kind != SYNC_KIND_OWNER)
            sync_pick = i;
    }

    if (sync_pick >= 0) {
        printf("u-dma-buf 同步：用 %s\n", sync_cand[sync_pick].name);
    } else if (verbose) {
        printf("u-dma-buf 同步：驱动一个候选都不认 -> 这个版本没有同步 ioctl，\n"
               "        只能指望缓冲区本来就是 non-cacheable（看 sysfs 里有没有 "
               "dma_coherent / sync_mode）\n");
    }
}

/* ⭐ 板上的 u-dma-buf 其实**有**同步接口，只是不在 ioctl 上，而在 sysfs 上：
 *     /sys/class/u-dma-buf/udmabuf0/{sync_offset, sync_size, sync_for_cpu, sync_for_device}
 * 后两个是可写的触发口（写 1 就干活），前两个先设好范围。
 * 这是 ikwzm 那版 u-dma-buf 的接口，我们之前只试 ioctl 所以全探不到。 */
static int udmabuf_sysfs_sync(int for_dev, uint64_t off, uint64_t size)
{
    char path[256], v[48];

    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/sync_offset", UDMABUF_NAME);
    snprintf(v, sizeof(v), "%llu", (unsigned long long)off);
    if (write_sysfs(path, v) != 0)
        return -1;

    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/sync_size", UDMABUF_NAME);
    snprintf(v, sizeof(v), "%llu", (unsigned long long)size);
    if (write_sysfs(path, v) != 0)
        return -1;

    snprintf(path, sizeof(path), "/sys/class/u-dma-buf/%s/%s", UDMABUF_NAME,
             for_dev ? "sync_for_device" : "sync_for_cpu");
    return write_sysfs(path, "1");
}

static void udmabuf_sync(int for_dev)
{
    if (opt_buf_mem)
        return;                     /* 走 /dev/mem 的映射本来就非缓存，不需要同步 */

    if (sync_via_sysfs) {
        static int reported = 0;
        if (udmabuf_sysfs_sync(for_dev, 0, MAP_LEN) == 0)
            return;
        if (!reported) {
            reported = 1;
            printf("  (u-dma-buf sysfs 同步失败: %s)\n", strerror(errno));
        }
        return;
    }

    if (buf_fd < 0 || sync_pick < 0)
        return;
    /* 这里要真同步，size 必须是整段，不能是 0 */
    int e = 0;
    if (sync_impl_call(sync_pick, for_dev, MAP_LEN, &e) == 0)
        return;
    static int reported2 = 0;
    if (!reported2) {
        reported2 = 1;
        printf("  (u-dma-buf 同步 ioctl 返回 %s)\n", strerror(e));
    }
}

/* ─────────────────── 缓存挤兑（对付 u-dma-buf 的可缓存映射） ───────────────────
 * 如果 /dev/udmabuf0 的 mmap 是**可缓存**的（u-dma-buf 没给同步 ioctl 时很可能就是），
 * 那 CPU 的 memset 只落在 cache 里、DMA 写的是 DDR，两边根本看不见对方：
 *   * 我们 memset 的 0xA5 会一直"盖住"DMA 写进去的数据，读回来全是 0xA5。
 * 用户态没有 clean/invalidate 指令可用，但可以**踩一块远大于 L2 的缓冲区**，
 * 把 dst 那几行从 cache 里挤出去。挤出去之后再读 dst，就得回 DDR 取——
 * 这时候能看到数据，就坐实了是缓存不一致；还是 0xA5，那就是 DMA 真没写。
 */
static void cache_evict(void)
{
    enum { EVICT_BYTES = 8 << 20 };     /* 8 MiB；A53 的 L2 一般 512KB~1MB */
    static uint8_t *scratch;

    if (!opt_evict)
        return;
    if (!scratch) {
        scratch = malloc(EVICT_BYTES);
        if (!scratch) { fprintf(stderr, "警告: 挤缓存用的 8MiB 分配失败\n"); return; }
        memset(scratch, 0x5A, EVICT_BYTES);
    }
    volatile uint8_t *p = scratch;
    uint32_t sum = 0;
    for (size_t i = 0; i < EVICT_BYTES; i += 64) {  /* 每行踩一个字节 */
        p[i] = (uint8_t)(p[i] + 1);
        sum += p[i];
    }
    (void)sum;
}

/* 数一数这块内存里还有多少字节保持着底色 —— 就是 DMA 没写到的部分 */
static size_t count_bytes(const uint8_t *p, size_t n, uint8_t v)
{
    size_t c = 0;
    for (size_t i = 0; i < n; i++)
        if (p[i] == v)
            c++;
    return c;
}

/* 数据真正到哪里为止：最后一个不是底色的字节的下一个位置。
 * 底色是 DMA 没写到的部分，所以这个偏移就是"内存里实际落地了多少字节"。
 *
 * 注意它比 count_bytes 靠谱：count_bytes 是逐字节数底色，数据里只要**恰好出现**
 * 一个 0xA5 就会少数。板上 e2e 实测 find_data_end 给 684、count_bytes 给 682，
 * 差的那 2 个就是数据自己的字节。所以凡是要"实收多少"，一律以这个为准。 */
static size_t find_data_end(const uint8_t *p, size_t n, uint8_t fill)
{
    size_t i = n;
    while (i > 0 && p[i - 1] == fill)
        i--;
    return i;
}

/* 数一数 [off, off+len) 里**奇数位置上不是 0x00/0xFF** 的字节有几个。
 *
 * logits 是小端 INT16、值域只有 ±几千，所以每个 INT16 的**高字节必然是 0x00 或 0xFF**。
 * 在一个对齐正确的 logits 段上这个数应当是 0；整体错开 4 字节就会大面积不为 0。
 * 所以它既能确认分界、也能排除"差一拍"的错觉。
 *
 * ⚠️ 别再用"从头扫第一个形状像 INT16 的位置"那种写法。**我第一版就是那么写的，
 * 结果是错的**：tok 段里有一长串 0x00（板上 hexdump 见过一行 16 个字节里 15 个 0x00），
 * 扫描法会在 tok 段内部就命中，于是同一批形状相同的数据被报成 364 / 380 / 396
 * 三个不同的"分界"，害我以为帧长不对。改成"在**期望的**分界上验证"，只有对/错，
 * 不会瞎指。 */
static size_t count_bad_int16(const uint8_t *p, size_t off, size_t len)
{
    size_t bad = 0;
    for (size_t k = off + 1; k < off + len; k += 2)
        if (p[k] != 0x00 && p[k] != 0xFF)
            bad++;
    return bad;
}

/* 一次抓取的「形状」判读。短帧只有两种可能，各验一次，谁干净就是谁：
 *
 *   头全尾缺 —— 从帧头 Beat 0 接进去，最后几拍没收着。
 *               那 tok 段就到 384 为止，logits 从 384 起 → 在 384 上验。
 *   头缺尾全 —— 从帧中间切进去，一路收到帧尾的 TLAST。
 *               那**最后 300 字节**必然是完整的 logits 段 → 在 end-300 上验。
 *
 * `count_bad_int16` 返回的是高字节不合规的个数，0 = 这个假设成立。
 * （dout 从 HLS 到 S2MM 是直连的，见 Signal_process.v:173-178，中间没有 FIFO，
 *   所以 AXI-Stream 不该丢拍——"头缺尾全"是时序问题，"头全尾缺"才是真丢数。） */
static void report_capture_shape(const uint8_t *p, size_t end)
{
    printf("实收 %zu 字节", end);
    if (end != (size_t)FRAME_OUT_BYTES) {
        if (end < (size_t)FRAME_OUT_BYTES)
            printf("（少 %zu 字节 = %zu 拍）",
                   (size_t)FRAME_OUT_BYTES - end, ((size_t)FRAME_OUT_BYTES - end) / 4);
        else
            printf("（多 %zu 字节）", end - (size_t)FRAME_OUT_BYTES);
    }
    printf("\n");

    if (end >= (size_t)FRAME_OUT_BYTES) {
        size_t bad = count_bad_int16(p, TOK_FRAME_BYTES, LOG_FRAME_BYTES);
        printf("      384 处分界验证：logits 段 %zu 个高字节里 %zu 个不是 0x00/0xFF"
               " -> %s\n",
               (size_t)LOG_FRAME_BYTES / 2, bad,
               bad == 0 ? "分界确实在 384，帧结构完整" : "**在 384 上验不过，帧错位了**");
        return;
    }

    size_t bad_head = (end > (size_t)TOK_FRAME_BYTES)
                    ? count_bad_int16(p, TOK_FRAME_BYTES, end - (size_t)TOK_FRAME_BYTES)
                    : (size_t)-1;
    size_t bad_tail = (end >= (size_t)LOG_FRAME_BYTES)
                    ? count_bad_int16(p, end - (size_t)LOG_FRAME_BYTES, LOG_FRAME_BYTES)
                    : (size_t)-1;

    if (bad_head != (size_t)-1)
        printf("      若「头全尾缺」（tok 到 384）：%zu 个高字节不合规\n", bad_head);
    if (bad_tail != (size_t)-1)
        printf("      若「头缺尾全」（logits 在 %zu）：%zu 个高字节不合规\n",
               end - (size_t)LOG_FRAME_BYTES, bad_tail);

    if (bad_head == 0 && bad_tail != 0)
        printf("      -> **头全尾缺**：从帧头接的，最后 %zu 拍没收着\n",
               ((size_t)FRAME_OUT_BYTES - end) / 4);
    else if (bad_tail == 0 && bad_head != 0)
        printf("      -> **头缺尾全**：从帧中间切进去的，丢了开头 %zu 拍\n",
               ((size_t)FRAME_OUT_BYTES - end) / 4);
    else if (bad_head == 0 && bad_tail == 0)
        printf("      -> 两种都验得过（数据周期性太强，判不出来）\n");
    else
        printf("      -> 两种都验不过\n");
}

/* ─────────────────────────── 描述符 ───────────────────────────
 * 默认布局（Xilinx BSP，64 字节）：        --alt-desc（PG021 32bit）：
 *   0x00 NXTDESC                            0x00 NXTDESC
 *   0x04 NXTDESC_MSB                        0x04 BUFA
 *   0x08 BUFA                               0x08 (reserved)
 *   0x0C BUFA_MSB                           0x0C CTRL
 *   0x10 MCCTL                              0x10 STATUS
 *   0x14 STRIDE/VSIZE
 *   0x18 CTRL
 *   0x1C STATUS
 */
static void bd_write(uint32_t *bd, uint64_t next_pa, uint64_t bufa_pa, uint32_t ctrl)
{
    memset(bd, 0, 64);
    if (!opt_alt_desc) {
        bd[0] = (uint32_t)(next_pa & 0xFFFFFFC0u);  /* XAXIDMA_DESC_LSB_MASK */
        bd[1] = (uint32_t)(next_pa >> 32);
        bd[2] = (uint32_t)bufa_pa;
        bd[3] = (uint32_t)(bufa_pa >> 32);
        /* bd[4] MCCTL = 0, bd[5] STRIDE/VSIZE = 0 */
        bd[6] = ctrl;
        /* bd[7] STATUS 由硬件回写 */
    } else {
        bd[0] = (uint32_t)(next_pa & 0xFFFFFFC0u);
        bd[1] = (uint32_t)bufa_pa;
        bd[2] = 0;
        bd[3] = ctrl;
        /* bd[4] STATUS */
    }
}

static uint32_t bd_read_sts(const uint32_t *bd)
{
    return opt_alt_desc ? bd[4] : bd[7];
}

/* 把描述符 8 个字原样打出来——布局对不对，看硬件往哪个字回写 STATUS 就知道 */
static void dump_bd_raw(const uint32_t *bd, const char *tag)
{
    printf("      描述符 8 个字[%s]:\n", tag);
    for (int w = 0; w < 8; w++)
        printf("        +%02x  %08x\n", w * 4, bd[w]);
    printf("        (BSP 布局    : 00 NDESC / 04 NDESC_MSB / 08 BUFA / 0C BUFA_MSB"
           " / 10 MCCTL / 14 STRIDE / 18 CTRL / 1C STATUS)\n");
    printf("        (PG021 32bit : 00 NDESC / 04 BUFA / 0C CTRL / 10 STATUS)\n");
}

/* ── 描述符区的「清零 + 预检」 ────────────────────────────────────────────
 *
 * **SGIntErr 的定义以 PG021 原文为准**（v7.1 第 1492 行）：
 *   "This error occurs if a descriptor with the Complete bit already set is fetched.
 *    This indicates to the SG Engine that the descriptor is a tail descriptor.
 *    This error condition causes the AXI DMA to halt gracefully. ...
 *    This error cannot be logged into the descriptor."
 * 三件事由此定死：
 *   ① SGIntErr = **引擎取到了一条 COMPLETE 已经置位的描述符**（引擎拿它当"尾描述符"）；
 *   ② 报这个错之后引擎是**优雅停机**（RS 清 0、Halted 置 1）；
 *   ③ 这个错**不会写回描述符** —— 所以"报错却一个字都没变"不是反证，正是这条说的。
 * 于是"DDR 里上一轮留下的旧描述符"变成一个**具体、可证伪**的嫌疑：
 * DDR 不擦除，而 COMPLETE 位只有我们自己（和硬件回写）会置。
 *
 * 所以每次挂之前先做两件事，都打印出来：
 *   ① 把描述符区清零（默认做；--no-zero 关掉）—— 排除残留；
 *   ② 预检扫描，报出清零之后还有多少格 STATUS 非 0 / COMPLETE 置位 —— 清零到底成没成。
 * 跑完这两步，"SGIntErr 是因为取到旧描述符"要么被排除、要么被坐实。
 * **在那之前，别再拿"读通路坏了"去解释 SGIntErr。** */

#define DESC_CLEAR_BYTES 0x10000u   /* 清零范围：udmabuf 开头 64KB（含两个通道的描述符区） */

/* 扫一片描述符区（每 64 字节一格），STATUS 非 0 的打出来，最多打 max_print 行。
 * 回填 *n_complete = 其中 COMPLETE(bit31) 已置位的格数 —— 那正是 SGIntErr 的触发条件。 */
static long desc_scan(uint32_t *va, uint64_t pa, long nslots, int max_print, long *n_complete)
{
    long n = 0, ncomp = 0, shown = 0;
    for (long i = 0; i < nslots; i++) {
        uint32_t s = bd_read_sts(va + (size_t)i * 16);
        if (!s)
            continue;
        n++;
        if (s & BD_STS_COMPLETE)
            ncomp++;
        if (shown < max_print) {
            shown++;
            printf("        %ld 格 @ %#010x  STATUS=%#010x（实收 %u）%s\n",
                   i, (unsigned)(pa + (uint64_t)i * 64u), s, s & BD_STS_LEN_MASK,
                   (s & BD_STS_COMPLETE)
                     ? "  ← COMPLETE 已置位（PG021：取到这种格子就 SGIntErr）" : "");
        }
    }
    if (n > shown)
        printf("        ...（还有 %ld 格，只打了前 %d 格）\n", n - shown, max_print);
    if (n_complete)
        *n_complete = ncomp;
    return n;
}

/* ─────────────────────────── 通道复位 ─────────────────────────── */
static int chan_reset(volatile uint32_t *b, uint32_t cr_off, uint32_t sr_off, const char *name)
{
    wr(b, cr_off, CR_RESET);
    uint64_t t0 = now_ms();
    while (rd(b, cr_off) & CR_RESET) {
        if (now_ms() - t0 > 1000) {
            fprintf(stderr, "  %s 复位超时（DMACR 的 Reset 位不自动清）\n", name);
            return -1;
        }
    }
    /* 复位会把 DMASR 里能清的都清掉，剩下的错误位手动 W1C */
    wr(b, sr_off, rd(b, sr_off));
    return 0;
}

static void dump_sr(volatile uint32_t *b, uint32_t sr_off, uint32_t cr_off, const char *name)
{
    uint32_t sr = rd(b, sr_off), cr = rd(b, cr_off);
    printf("    %s: DMACR=%#010x  DMASR=%#010x  [%s%s%s%s%s%s]\n", name, cr, sr,
           (sr & SR_SGINCLD) ? "SG引擎在 " : "直读模式 ",
           (sr & SR_HALTED) ? "Halted " : "",
           (sr & SR_IDLE) ? "Idle " : "",
           (sr & SR_IOC) ? "IOC " : "",
           (sr & (SR_ERR | SR_ERR_SG)) ? "ERR " : "",
           (sr & SR_IRQ_ERR) ? "IrqErr " : "");
}

/* 把 DMASR 里的错误位翻成人话（位定义见文件顶部 SR_* 那段）。
 *
 * S2MM 的 DMAIntErr 有两条成因，都是 IP 自己的说明里写的：
 *   1) **取回的描述符里 buffer length 是 0** —— 描述符没被正确读到，或者长度字段
 *      写的不是硬件读的那个位置；
 *   2) 用了 status/app length 那个流时，"Status 流报的 RxLength"跟实际收到的包对不上
 *      （我们的设计没有 status 流，正常不该走这条）。
 * 所以 SG 下看到 DMAIntErr，第一个该怀疑的是"硬件到底读没读到我们写的那份描述符"。 */
static void print_dmasr_err(uint32_t sr)
{
    if (!(sr & (SR_ERR | SR_ERR_SG)))
        return;
    printf("      错误位：");
    if (sr & 0x10)  printf(" DMAIntErr(描述符 buffer length=0／包长对不上描述符)");
    if (sr & 0x20)  printf(" DMASlvErr(访存被从机拒)");
    if (sr & 0x40)  printf(" DMADecErr(地址译码失败)");
    if (sr & 0x100) printf(" SGIntErr(取到 COMPLETE 已置位的旧描述符)");
    if (sr & 0x200) printf(" SGSlvErr(SG 取描述符被拒：查 m_axi_sg 到 DDR 那条路)");
    if (sr & 0x400) printf(" SGDecErr(SG 描述符地址译不出来：查地址编辑器里 m_axi_sg 的段)");
    printf("\n");
}

/* ─────────────────────────── probe ─────────────────────────── */
static int cmd_probe(void)
{
    printf("[probe] 只碰寄存器，不做任何传输\n");
    int bad = 0;

    for (int i = 0; i < 2; i++) {
        volatile uint32_t *b = (i == 0) ? reg0 : reg1;
        const char *nm = (i == 0) ? "axi_dma_0(MM2S)" : "axi_dma_1(S2MM)";
        uint32_t cr_off = (i == 0) ? MM2S_CR : S2MM_CR;
        uint32_t sr_off = (i == 0) ? MM2S_SR : S2MM_SR;

        if (chan_reset(b, cr_off, sr_off, nm) < 0) {
            bad++;
            continue;
        }
        dump_sr(b, sr_off, cr_off, nm);

        /* 在 IRQThreshold 字段里写个花样再读回来——能读回来说明 AXI-Lite 写也通 */
        wr(b, cr_off, CR_THRESHOLD(0x5a));
        uint32_t v = rd(b, cr_off);
        if ((v & 0x00FF0000u) != CR_THRESHOLD(0x5a)) {
            printf("    !! 回读不上：写了 %#x，读回 %#x —— 这块窗口没译码或写没通\n",
                   CR_THRESHOLD(0x5a), v);
            bad++;
        } else {
            printf("    回读 OK（IRQThreshold 写 0x5a 读回 0x5a）\n");
        }
        wr(b, cr_off, 0);   /* 恢复：RS=0，不启动 */
        wr(b, sr_off, rd(b, sr_off));

        /* 顺手探一下 S2MM 通道是不是 SG 模式：SG 下 CURDESC(0x38) 才是活寄存器。
         * ⚠️ 这只能当**参考** —— Xilinx 的手册并没有把"直读模式下 0x38 读回来是
         *    什么"写死。**真正的判据是上面 dump_sr 打出来的 bit3(SGIncld)**：那是
         *    IP 参数 C_INCLUDE_SG 的回显，本程序启动时就是靠它自动选走法的。
         *    这里写 CURDESC 只是为了在板子上多一个交叉印证。 */
        if (i == 1) {
            wr(b, S2MM_CURDESC, 0x3F000000u);
            uint32_t rb = rd(b, S2MM_CURDESC);
            printf("    模式参考（非判据）：CURDESC(0x38) 写 0x3F000000 读回 %#010x -> %s\n",
                   rb, (rb == 0x3F000000u) ? "像 SG（0x38 是活寄存器）"
                                           : "像直读（0x38 读不回来，写成别的了）");
            wr(b, S2MM_CURDESC, 0);
        }
    }

    if (bad) {
        printf("\n[probe] 有问题。先查：\n"
               "  1. bitstream 是不是最新那个 ai7030_edif_top.bit（地址译码在 PL 里）\n"
               "  2. FSBL 里 0x8040_0000 这段有没有被别的 master 占了\n"
               "  3. 读出来是不是全 F（0xFFFFFFFF）——是的话就是根本没通\n");
        return 1;
    }
    printf("\n[probe] 通过：两个 DMA 的 AXI-Lite 都通。\n");
    return 0;
}

/* ══════════════════ S2MM 的 SG 描述符环（axi_dma_1 开了 SG 之后的正路） ══════════════════
 *
 * 为什么非换不可（不是为了"更快"）：AXI DMA 一旦带上 SG 引擎，直读模式那组寄存器
 * 就不认了。Xilinx 驱动 XAxiDma_SimpleTransfer() 第一句就是
 *     if (XAxiDma_HasSg(InstancePtr)) { ... "Simple DMA mode is not supported"; }
 * 而 hw_handoff/ps_ai.hwh 里 axi_dma_1 已经是 C_INCLUDE_SG=1 / C_SG_LENGTH_WIDTH=16。
 * 继续写 DA+LENGTH 的结果是**什么都不发生**，然后超时——不会报错，最难查。
 *
 * 换环之后顺带解决了两件事：
 *   * **每帧收了多少由硬件回写到描述符的 STATUS**，不用再靠数 0xA5 底色去猜
 *     （`find_data_end` 那套只当旁证）；
 *   * 一帧收完 TLAST，硬件自己走到下一个描述符，**中间不需要 CPU 插手** ——
 *     之前"每帧少 8 拍"那个重挂空档从根上没有了。
 */

#define SG_DESC_LSB_MASK 0xFFFFFFC0u   /* 同 XAXIDMA_DESC_LSB_MASK：描述符地址低 6 位忽略 */

static uint64_t  sg_bd_pa(int k) { return buf_pa + BD1_OFF + (uint64_t)k * 64u; }
static uint32_t *sg_bd_va(int k) { return (uint32_t *)(buf_va + BD1_OFF + (size_t)k * 64u); }

static uint32_t sg_bd_sts(int k) { return bd_read_sts(sg_bd_va(k)); }

/* 建环：第 k 个描述符指向 base_off 起的第 k 段缓冲，NXTDESC 指下一个，
 * 最后一个指回第 0 个 —— 和驱动的环形链表一致。尾巴**不能**留空指针：
 * 硬件会预取 NXTDESC，空指针会直接报 SG 解码错误。 */
static int sg_build_ring(uint32_t base_off, uint32_t frame_len, int nbd)
{
    if (nbd < 1 || nbd > (int)N_FRAMES_OUT) {
        fprintf(stderr, "SG 描述符个数 %d 越界（1..%u）\n", nbd, N_FRAMES_OUT);
        return -1;
    }
    /* 单描述符上限是硬件参数 C_SG_LENGTH_WIDTH（axi_dma_1 是 16 -> 65535 字节）。
     * 超了会被截断成一个错长度，不如在这里拦住。 */
    if (frame_len == 0 || frame_len > 0xFFFFu) {
        fprintf(stderr, "SG 描述符长度 %u 越界（1..65535；axi_dma_1 的 "
                        "C_SG_LENGTH_WIDTH=16）\n", frame_len);
        return -1;
    }
    if ((uint64_t)base_off + (uint64_t)nbd * frame_len > DST_MAX) {
        fprintf(stderr, "SG 目标区不够：基址 %#x 起要 %llu 字节，只有 %lu\n",
                base_off, (unsigned long long)nbd * frame_len, (unsigned long)DST_MAX);
        return -1;
    }

    for (int k = 0; k < nbd; k++) {
        uint64_t next = sg_bd_pa((k + 1) % nbd);
        uint64_t dat  = buf_pa + DST_OFF + base_off + (uint64_t)k * frame_len;
        bd_write(sg_bd_va(k), next, dat, BD_CTRL_LEN(frame_len));
    }
    return 0;
}

/* 挂环并开跑。
 *
 * 顺序照 Xilinx 驱动 XAxiDma_BdRingStart()： CDESC -> RS=1 -> TDESC。
 * 为什么 TAILDESC 放最后：.hwh 里 IP 自己的说明写着 "the DMA engine starts the
 * transfer when the TDESC register is written with a valid descriptor address and
 * the RS bit is set" —— 写尾描述符那一下才是"开跑"。而 reset 之后 RS=0、处于
 * halted，此时写 CDESC/TDESC 只是把值锁存进去，不会动起来（同一段说明里的原话）。
 */
/* 写 TAILDESC 之前，等 DMASR.Halted 真的清掉。
 *
 * 依据是 PG021 Table 20（S2MM_TAILDESC）的原话：
 *   "When AXI DMA Channel is not halted (DMASR.Halted = 0), a write by the CPU to
 *    the TAILDESC_PTR register causes the AXI DMA SG Engine to start fetching
 *    descriptors or restart if it was idle (DMASR.Idle = 1)."
 * 反过来读：**Halted 还是 1 的时候写尾描述符不会开跑**，只是把暂停点挪一下 ——
 * 而 .hwh 里 IP 自己写着 Halted 这一位有 "lag"。RS=1 之后立刻写尾，就可能正好
 * 落进那个 lag 里：静默地什么都不发生，连一个错误位都不报。
 * 我们现在的挂法（CDESC → RS=1 → 立刻 TDESC）中间没有任何等待、也没查过 Halted。
 * 返回等了多久（µs）；超时返回 -1。 */
static long wait_halted_clear(volatile uint32_t *b, uint32_t sr_off, int timeout_us)
{
    uint64_t t0 = now_us();
    for (;;) {
        if (!(rd(b, sr_off) & SR_HALTED))
            return (long)(now_us() - t0);
        if (now_us() - t0 > (uint64_t)timeout_us)
            return -1;
    }
}

static int s2mm_sg_arm(uint32_t base_off, uint32_t frame_len, int nbd)
{
    volatile uint32_t *b = reg1;

    if (sg_build_ring(base_off, frame_len, nbd) < 0)
        return -1;

    __sync_synchronize();
    udmabuf_sync(SYNC_FOR_DEVICE);      /* 描述符本身也得先落 DDR —— SG 引擎要去取的 */

    if (chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)") < 0)
        return -1;

    wr(b, S2MM_CR, 0);                                      /* RS=0 */
    wr(b, S2MM_SR, rd(b, S2MM_SR));                         /* 清 IOC/错误（W1C） */
    wr(b, S2MM_CURDESC, (uint32_t)(sg_bd_pa(0) & SG_DESC_LSB_MASK));
    wr(b, S2MM_CR, CR_RUNSTOP | CR_THRESHOLD(1));           /* RS=1 */
    __sync_synchronize();
    if (opt_wait_halted) {          /* 见 wait_halted_clear 的注释：尾指针要 Halted=0 才算开跑 */
        long us = wait_halted_clear(b, S2MM_SR, 200000);
        if (us < 0) {
            fprintf(stderr, "  axi_dma_1(S2MM) RS=1 之后 200 ms 内 Halted 一直没清，"
                            "没法安全地写尾描述符\n");
            return -1;
        }
        printf("    (--wait-halted) S2MM：RS=1 之后 %ld µs Halted 才清\n", us);
    }
    wr(b, S2MM_TAILDESC,
       (uint32_t)(sg_bd_pa(nbd - 1) & SG_DESC_LSB_MASK));   /* 写尾 = 开跑 */
    return 0;
}

/* 出错/超时时把每个描述符的 STATUS 原样打出来——定位全靠它 */
static void dump_sg_bds(int nbd)
{
    for (int k = 0; k < nbd; k++) {
        uint32_t s = sg_bd_sts(k);
        printf("      BD[%d] @%#010x  STATUS=%#010x  [%s%s%s%s]  实收 %u\n",
               k, (unsigned)(sg_bd_pa(k) & SG_DESC_LSB_MASK), s,
               (s & BD_STS_COMPLETE) ? "COMPLETE " : "",
               (s & BD_STS_RXSOF) ? "RXSOF " : "",
               (s & BD_STS_RXEOF) ? "RXEOF " : "",
               (s & BD_STS_ERR) ? "ERR " : "",
               s & BD_STS_LEN_MASK);
    }
}

/* ═════════ sgprobe：只问 SG 引擎，不碰 MM2S、不要求 dout 有数据 ═════════
 *
 * 为什么非要这么一个命令：`frames` 挂掉的时候，"描述符没写对""挂法没开跑"
 * "引擎在等数据"这三种原因的**外在表现完全一样** —— 超时、STATUS 全是 0。
 * 靠外在表现分不开，只能去问硬件自己的错误位。PG021 v7.1 的 S2MM_DMASR 表
 * （第 27-28 页）逐条写着：
 *   SGDecErr  = SG 引擎取描述符时地址译不出来
 *   SGSlvErr  = SG 引擎取描述符被从机拒
 *   SGIntErr  = 取到一个 COMPLETE 已经置位的描述符（"这说明它是尾描述符"）
 *   DMAIntErr = **取回的描述符里 buffer length 是 0**
 * 这几位只要有**一位**冒出来，就等于硬件自己承认"我读了你的描述符"。
 * 反过来，四种挂法全试遍、一个 SG 错都不报、CURDESC 也始终钉在 BD[0]，
 * 那就是**根本没开跑**，跟数据、跟 dout、跟 HLS 一点关系都没有。
 *
 * 四种挂法的差别（都用同一个 2 描述符的环，尾都指 BD[1]，所以引擎要走到尾
 * 就必须读 BD[0]）：
 *   A 现挂法        CDESC → RS=1 → **紧贴着**写 TDESC（现在的代码就是这样）
 *   B 等 Halted     CDESC → RS=1 → **等 DMASR.Halted 变 0** → 写 TDESC
 *   C 坏 NXTDESC    B 的挂法 + 把 BD[0].NXTDESC 指到没译码的 0x40000000
 *                   → 引擎要走到尾就得跟着这个指针走 → 该报 SGDecErr
 *   D 预置 COMPLETE B 的挂法 + 把 BD[0].STATUS 预先写成 0x80000000 → 文档说该报 SGIntErr
 *
 * A 不动、B 动      → 是 Halted 那个竞态（PG021 Table 20 那句 not-halted 的前提）
 * A、B 有一个动了   → 挂法成立，往下游（数据/流侧）查
 * 四个全不动        → 引擎压根没取描述符，问题在挂法/SG 通路本身
 *
 * ⚠️ **别把"报错"当成"取到了我们的描述符"**（这里以前就是这么误判的）：
 *    报 DMAIntErr = 取回的描述符 buffer length 是 0，报 SGIntErr = 取回的描述符
 *    COMPLETE 已置位 —— 而我们写的描述符根本不长这样。**报错恰恰说明引擎读到了
 *    东西，只是读到的不是我们那份**。C/D 两组的报错还可能是"跟着坏指针走"的
 *    **预期**反应，光看有没有报错分不开，得比错误位的具体组合。所以这里把
 *    返回值分成 0 没开跑 / 1 前进 / 2 报错 / 3 描述符被改写，不再混在一起。
 */
static int sg_attempt(const char *tag, int mode, const char *what)
{
    volatile uint32_t *b = reg1;
    uint64_t bd0m  = sg_bd_pa(0) & SG_DESC_LSB_MASK;
    uint64_t tailm = sg_bd_pa(1) & SG_DESC_LSB_MASK;

    printf("  【%s】%s\n", tag, what);

    if (sg_build_ring(0, FRAME_OUT_BYTES, 2) < 0)
        return -1;
    if (mode == 2) {                     /* 坏 NXTDESC：引擎要走到尾就必须读它 */
        sg_bd_va(0)[0] = 0x40000000u;
        sg_bd_va(0)[1] = 0;
    }
    if (mode == 3)                       /* 预置 COMPLETE（文档：会被当成尾描述符） */
        sg_bd_va(0)[7] = BD_STS_COMPLETE;
    __sync_synchronize();
    udmabuf_sync(SYNC_FOR_DEVICE);

    /* 先回读一遍 DDR 里到底存着什么 —— 这就是 SG 引擎马上要去取的内容 */
    printf("    DDR 回读 BD[0]: +00(NEXT)=%08x +08(BUFA)=%08x +18(CTRL)=%08x[len=%u] +1C=STS%08x\n",
           sg_bd_va(0)[0], sg_bd_va(0)[2], sg_bd_va(0)[6],
           sg_bd_va(0)[6] & BD_STS_LEN_MASK, sg_bd_va(0)[7]);
    printf("    DDR 回读 BD[1]: +00(NEXT)=%08x +08(BUFA)=%08x +18(CTRL)=%08x[len=%u] +1C=STS%08x\n",
           sg_bd_va(1)[0], sg_bd_va(1)[2], sg_bd_va(1)[6],
           sg_bd_va(1)[6] & BD_STS_LEN_MASK, sg_bd_va(1)[7]);

    /* 存下来：跑完之后再读一遍逐字比 —— 只有 STATUS 变才算硬件正常回写。
     * （以前只在挂之前回读过，"挂了之后描述符有没有被别人改写"根本没查过。） */
    uint32_t bd_before[8];
    for (int w = 0; w < 8; w++)
        bd_before[w] = sg_bd_va(0)[w];

    if (chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)") < 0)
        return -1;
    wr(b, S2MM_CR, 0);
    wr(b, S2MM_SR, rd(b, S2MM_SR));
    wr(b, S2MM_CURDESC, (uint32_t)bd0m);

    uint32_t sr_rs;
    long clear_us = -1;
    wr(b, S2MM_CR, CR_RUNSTOP | CR_THRESHOLD(1));      /* RS=1 */
    if (mode == 0) {
        wr(b, S2MM_TAILDESC, (uint32_t)tailm);         /* 现挂法：紧贴着写，不查 Halted */
        sr_rs = rd(b, S2MM_SR);
    } else {
        sr_rs = rd(b, S2MM_SR);
        clear_us = wait_halted_clear(b, S2MM_SR, 200000);
        wr(b, S2MM_TAILDESC, (uint32_t)tailm);
    }

    uint64_t t0 = now_us();
    uint32_t sr = rd(b, S2MM_SR), cur = rd(b, S2MM_CURDESC);
    int max_idx = 0, err_seen = 0;
    while (now_us() - t0 < 200000) {
        sr = rd(b, S2MM_SR);
        cur = rd(b, S2MM_CURDESC);
        int idx = (int)((int64_t)((cur & SG_DESC_LSB_MASK) - bd0m) / 64);
        if (idx > max_idx) max_idx = idx;
        if (sr & (SR_ERR | SR_ERR_SG)) { err_seen = 1; break; }
        msleep(1);
    }
    udmabuf_sync(SYNC_FOR_CPU);        /* 板子上 dma_coherent=1，这一步是保险 */

    printf("    RS=1 后立刻读 DMASR=%#010x（Halted=%d）", sr_rs, !!(sr_rs & SR_HALTED));
    if (mode == 0)
        printf("；不等，紧跟着写尾\n");
    else if (clear_us < 0)
        printf("；但 200 ms 内 Halted 一直没清，尾照样写了\n");
    else
        printf("；%ld µs 后 Halted 清，才写尾\n", clear_us);

    printf("    200 ms 后: DMASR=%#010x  CURDESC=%#010x（相对 BD[0] 前进 %d 个）  TAILDESC=%#010x\n",
           sr, cur, max_idx, rd(b, S2MM_TAILDESC));
    printf("      BD[0] STATUS=%#010x   BD[1] STATUS=%#010x\n", sg_bd_sts(0), sg_bd_sts(1));
    print_dmasr_err(sr);

    wr(b, S2MM_SR, sr);
    chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
    udmabuf_sync(SYNC_FOR_CPU);

    /* 挂之前那 8 个字，现在再读一遍逐字比：
     * 只有 STATUS 这个字变 = 硬件正常回写；NEXT/BUFA/CTRL 也变了 = 有别人在写这块内存。
     * 这两种在"超时 + STATUS 全 0"的表象下长得一模一样，只能靠 diff 分开。 */
    int clobbered = 0;
    {
        int sts_word = opt_alt_desc ? 4 : 7, nchg = 0;
        for (int w = 0; w < 8; w++) {
            uint32_t nowv = sg_bd_va(0)[w];
            if (nowv == bd_before[w])
                continue;
            nchg++;
            if (w != sts_word)
                clobbered = 1;
            printf("      BD[0].+%02x 挂之前 %08x -> 现在 %08x  %s\n", w * 4,
                   bd_before[w], nowv,
                   (w == sts_word) ? "（STATUS，正常回写）"
                                   : "**（不是 STATUS：被人改过）**");
        }
        if (!nchg)
            printf("      BD[0] 八个字一个字都没变（连 STATUS 也是）\n");
    }

    if (clobbered) {
        printf("    → 描述符的 NEXT/BUFA/CTRL 被改过 → 有别的 master 在写我们这块内存\n");
        return 3;
    }
    if (err_seen) {
        printf("    → 引擎取了东西、并且自己报了错位 —— "
               "**取到的不是我们这份描述符**（报错本身就说明它读到过东西）\n");
        return 2;
    }
    if (max_idx != 0) {
        printf("    → CURDESC 前进了 %d 个 → 引擎在取描述符，挂法成立\n", max_idx);
        return 1;
    }
    printf("    → CURDESC 钉在 BD[0]、一个错误位都没有 → 这一次没有开跑\n");
    return 0;
}

static int cmd_sgprobe(void)
{
    printf("[sgprobe] 只动 axi_dma_1，不碰 MM2S、也不要求 dout 有数据\n");
    printf("          目的：把「描述符/挂法不对」和「引擎在等数据」分开\n");
    dump_sr(reg1, S2MM_SR, S2MM_CR, "基线 axi_dma_1(S2MM)");
    printf("\n");

    int a = sg_attempt("A 现挂法", 0,
                       "CDESC→RS=1→紧跟着写 TDESC（现在代码的挂法）");
    printf("\n");
    int b = sg_attempt("B 等 Halted", 1,
                       "CDESC→RS=1→等 DMASR.Halted 变 0→写 TDESC");
    printf("\n");
    int c = sg_attempt("C 坏 NXTDESC", 2,
                       "同 B，但 BD[0].NXTDESC 指向没译码的 0x40000000（该报 SGDecErr）");
    printf("\n");
    int d = sg_attempt("D 预置 COMPLETE", 3,
                       "同 B，但 BD[0].STATUS 预先置 COMPLETE（该报 SGIntErr）");

    printf("\n[sgprobe] 结论（返回值 0=没开跑 1=CURDESC 前进 2=报错 3=描述符被改写）\n");
    printf("  A=%d B=%d C=%d D=%d\n", a, b, c, d);
    int clob = (a == 3 || b == 3 || c == 3 || d == 3);
    int moved = (a == 1 || b == 1);
    int errs  = (a == 2 || b == 2);

    if (clob) {
        printf("  **有描述符的 NEXT/BUFA/CTRL 被改过** → 先查「谁在写这块 DDR」"
               "（HP2 是和厂商 S2_AXI_HP_HC_* 共用的），别再查引擎了。\n");
    } else if (moved) {
        printf("  A/B 让 CURDESC 前进了 → **SG 引擎在取我们这份描述符**，布局和挂法成立。\n"
               "  那就别再在寄存器/描述符上花时间，往数据/流侧查。\n");
        if (a != 1 && b == 1)
            printf("  ★ A 没动、B 动了 —— 正是 PG021 Table 20 那个竞态：写 TAILDESC 时\n"
                   "    Halted 还没清，尾指针写进去不算开跑。（默认挂法已经先等 Halted。）\n");
    } else if (errs) {
        printf("  引擎**读了东西并且报了错**，但 CURDESC 没前进 ⇒ 取到的不是我们这份\n"
               "  描述符（我们写的 length 是 684，不可能报 length=0；STATUS 也没被写过）。\n"
               "  → 问题在**读出内容**上，不在「挂没挂对」上。下一步用 sg2 / carpet。\n"
               "  ⚠ 报 SGIntErr 的话别急着下这个结论：PG021 原文说它的成因只有一个 ——\n"
               "    **取到了一条 COMPLETE 已置位的描述符**（引擎当尾描述符、优雅停机，\n"
               "    而且这个错不写回描述符）。所以先排除「取到上一轮残留的旧描述符」，\n"
               "    sg2 现在默认在挂之前把开头的 64KB 清零并预检，就是干这个的。\n"
               "  ⚠ 那两个 m_axi_sg 口**没有 RID**（32 位、ID 宽 0，ID 是 SmartConnect 里才加的）；\n"
               "    真要看 ID 得抓 axi_interconnect_4_M00_AXI（6 位）。\n");
    } else {
        printf("  A/B 都没动、也没报错 → 引擎一次都没开跑。\n");
    }
    printf("  ⚠ C/D 这两组的报错**不能**当证据：它们本来就是故意让引擎跟着坏指针走的，\n"
           "    报 SGDecErr(0x400)/SGIntErr(0x100) 是**预期**反应；不报也可能是同一个老毛病。\n"
           "    单看「有没有反应」分不开，要比错误位的具体组合（上面每一位都打出来了）。\n");
    return moved ? 0 : 1;
}

/* ══════════════════════════════════════════════════════════════════════════
 *  sg2 / carpet —— 调试用：把"引擎到底干没干活、读的是哪儿的描述符"问出来
 *
 *  【为什么还要加这两个】
 *  到现在为止，"SG 引擎不干活"的所有外在表现都长一样：超时、STATUS 全 0。
 *  已有的 sgprobe 只能回答"报没报错"，而**报错这件事本身**恰恰说明引擎读到了
 *  东西 —— 只是读到的不是我们那份描述符（取回的 length=0 / COMPLETE 已置位）。
 *  也就是说："有没有取"这个二分已经清楚了，"取的是哪儿"还差一件工具。
 *
 *  所以这里补两件：
 *
 *  sg2   把"挂"和"跑"拆开，**只挂不跑时就回读 CURDESC**，看这个地址到底有没有
 *        落进寄存器（DMACR 读得回、CURDESC 读不回，是很具体的一条线索）；
 *        跑起来之后按时间线采样 DMASR/CURDESC/TAILDESC；最后把两个描述符的
 *        8 个字**逐字 diff** —— 用来把「硬件正常回写 STATUS」和「NEXT/BUFA/CTRL
 *        被别人改过」分开。
 *        两个通道分开跑：MM2S 和 S2MM 的 SG 引擎**以前从来没被单独测过**
 *        （sgprobe 只碰 axi_dma_1）。
 *
 *  carpet 把一整片内存**每 64 字节铺一个合法描述符**，然后再挂。
 *        于是"引擎读的地址偏了"不再是错误，而**变成一个可测量的结果**：
 *        哪个槽位的 STATUS 被回写、哪个目标块收到了数据，就等于告诉我们
 *        引擎实际读的是哪个地址。这是软件侧能拿到的最后一块证据；
 *        连地毯都取不动，就说明跟描述符内容无关，该上 ILA 了（见 doc/pl_sg_ila.md）。
 * ══════════════════════════════════════════════════════════════════════════ */

struct sg_chan {
    const char        *name;
    volatile uint32_t *reg;        /* 在 sg_chan_init() 里填 */
    uint32_t           cr, sr, cur, tail;
    uint32_t           max_len;    /* C_SG_LENGTH_WIDTH -> 单描述符长度上限 */
    uint32_t           bd_off;     /* 这个通道的描述符放 udmabuf 的哪个偏移（要 128 字节） */
    uint32_t           buf_off;    /* BUFA 指向的窗口 */
    uint32_t           buf_max;
    uint32_t           xfer_len;   /* 这个通道一次典型传输的字节数 */
    int                is_mm2s;
};

static struct sg_chan g_sg_chan[2] = {
    { "axi_dma_0(MM2S)", NULL, MM2S_CR, MM2S_SR, MM2S_CURDESC, MM2S_TAILDESC,
      16383u, BD_OFF,  SRC_OFF, SRC_MAX, CALL_IN_BYTES,   1 },
    { "axi_dma_1(S2MM)", NULL, S2MM_CR, S2MM_SR, S2MM_CURDESC, S2MM_TAILDESC,
      /* 16383，不是 65535 —— 两个通道的 C_SG_LENGTH_WIDTH **都是 14**
       * （`ps_ai.hwh:3603`/`:5026` 各一份，两边 `.xci` 也各自写着 14）。
       * 之前这里抄成 16 是错的：真按 65535 写一个描述符长度，硬件只会截断。 */
      16383u, BD1_OFF, DST_OFF, DST_MAX, FRAME_OUT_BYTES, 0 },
};
#define SG_NCHAN  ((int)(sizeof(g_sg_chan) / sizeof(g_sg_chan[0])))

static void sg_chan_init(void)
{
    g_sg_chan[0].reg = reg0;
    g_sg_chan[1].reg = reg1;
}

static uint64_t  sg_bdp_pa(const struct sg_chan *c, int k)
{ return buf_pa + c->bd_off + (uint64_t)k * 64u; }
static uint32_t *sg_bdp_va(const struct sg_chan *c, int k)
{ return (uint32_t *)(buf_va + c->bd_off + (size_t)k * 64u); }
static uint32_t  sg_bdp_sts(const struct sg_chan *c, int k)
{ return bd_read_sts(sg_bdp_va(c, k)); }

/* 一个通道跑一轮下来收集到的事实。判读**只看这些 bool**，不猜。 */
struct sg_find {
    int      latched;      /* 只挂不跑：CURDESC 读回 == 我们写的那个地址 */
    int      advanced;     /* 时间线里 CURDESC **变成过第 1 格的地址**（= 真的走了环）。
                            * 别拿"CURDESC != 我们写的那个值"当前进 —— 板上已经读到过
                            * 运行后 CURDESC = 0x00000000，那不是"下一条"，那是地址 0。 */
    int      cur_zero;     /* 采样里出现 CURDESC = 0（引擎把 0 当成了出错的那条描述符） */
    uint32_t cur_vals[8];  /* 采样到的 CURDESC 去重值，原样打出来给人看 */
    int      n_cur;
    int      idle_seen;    /* 结束采样时 Idle=1 —— **只记录，不当证据**：
                            * .hwh 里 SG 下 Idle 的含义是"走到尾指针、排队的处理完了"，
                            * 但引擎"手里没活"时也是 Idle（CURDESC==TAILDESC 就是这种），
                            * 两者在这几个寄存器上分不开。所以判读一律不看它。 */
    int      err;          /* 期间任何一次读到错误位 */
    uint32_t sr_last;
    int      sts_written;  /* 有描述符的 STATUS 被回写过 */
    uint32_t sts_val;
    int      clobbered;    /* NEXT/BUFA/CTRL 被改过（= 不是硬件回写的那种改动） */
    int      ring;         /* 这一轮是几格环 */
    uint32_t xfer;         /* 这一轮每格多少字节 */
    int      adv_slot;     /* 采样里 CURDESC 落在环内第几格的**最大值**（-1 = 一次都没进环）。
                            * 比 advanced 这种 0/1 具体：直接量出"引擎一共走了几格"。 */
    size_t   got;          /* 跑完数据窗口里"非底色"的字节数（S2MM 才看得出） */
    int      pre_stale;    /* 挂之前，描述符区里就已经有 COMPLETE 置位的格子（= 清零失败） */
};

/* 一帧采样：CR/SR/CURDESC/TAILDESC 一起看，CURDESC 还顺便换算成"相对第 0 格走了几格" */
static void sg_sample(const struct sg_chan *c, uint64_t base_pa, const char *tag)
{
    uint32_t sr  = rd(c->reg, c->sr);
    uint32_t cr  = rd(c->reg, c->cr);
    uint32_t cur = rd(c->reg, c->cur);
    uint32_t tl  = rd(c->reg, c->tail);
    long idx = (long)((int64_t)((cur & SG_DESC_LSB_MASK) - base_pa) / 64);
    printf("      %-9s DMACR=%#010x DMASR=%#010x [%s%s%s%s%s]  CURDESC=%#010x(%+ld 格)"
           "  TAILDESC=%#010x\n",
           tag, cr, sr,
           (sr & SR_SGINCLD) ? "SG引擎 " : "无SG位 ",
           (sr & SR_HALTED) ? "Halted " : "",
           (sr & SR_IDLE) ? "Idle " : "",
           (sr & SR_IOC) ? "IOC " : "",
           (sr & (SR_ERR | SR_ERR_SG)) ? "ERR " : "",
           cur, idx, tl);
}

/* n 格环：0 -> 1 -> ... -> n-1 -> 0，尾指针指第 n-1 格，所以引擎处理完 n 格就停，
 * 不会绕圈跑不停。每格指向自己的数据块（第 k 格用 [k*xlen, (k+1)*xlen)）。
 *
 * MM2S 的描述符必须带 SOF|EOF（TX 靠这两位在输出流上切包），S2MM 的 CONTROL
 * 只有长度（SOF/EOF 是硬件回写进 STATUS 的位）。
 * 注意这里**每格都带 SOF|EOF**：已经跑通的 carpet（1024 字节那批）也是这么写的，
 * 所以"位标志写错"不能解释 MM2S 8192 那次失败 —— 两者这个字段是一样的。
 * （BSP 的 XAxiDma_BdRingToHw 要求首格 SOF、末格 EOF，我们两头都满足。） */
#define SG2_MAX_RING 64u

static void sg2_build_ring(const struct sg_chan *c, int n, uint32_t xlen)
{
    uint32_t ctrl = c->is_mm2s ? (BD_CTRL_SOF | BD_CTRL_EOF | BD_CTRL_LEN(xlen))
                               : BD_CTRL_LEN(xlen);
    uint64_t d0   = buf_pa + c->buf_off;

    for (int k = 0; k < n; k++)
        bd_write(sg_bdp_va(c, k),
                 sg_bdp_pa(c, (k + 1) % n),
                 d0 + (uint64_t)k * xlen,
                 ctrl);
}

/* 跑一个通道的一轮 sg2。返回 0 正常（判读看 f），-1 是环境错误。 */
static int sg2_run_chan(const struct sg_chan *c, struct sg_find *f)
{
    volatile uint32_t *b = c->reg;
    uint32_t before[SG2_MAX_RING][8], after[SG2_MAX_RING][8];
    uint64_t base = sg_bdp_pa(c, 0) & SG_DESC_LSB_MASK;
    static const int ms[] = { 0, 1, 10, 50, 200, 500, 1000 };

    /* 这一轮要跑成什么形状：几格环 × 每格多少字节。
     * 两个旋钮是给"板上已经把范围压到两处不同"用的 —— carpet 里 1024 字节的描述符
     * 走得通，而这里 8192 字节的报 SGIntErr。差别只有两处：**长度**和**环的格数**。
     * 所以一次只动一个：
     *   ./pl_dma_test sg2 --mm2s --xfer=1024    长度对上了，环仍然是 2 格
     *   ./pl_dma_test sg2 --mm2s --ring=16      长度还是 8192，环变长
     * 两个一起动就又回到"猜"。 */
    int      n    = (opt_ring > 0) ? opt_ring : 2;
    uint32_t xlen = (opt_xfer > 0) ? (uint32_t)opt_xfer : c->xfer_len;
    /* 数据窗口能用的字节数：MM2S 从 SRC_OFF 到 DST_OFF（别越到 S2MM 的数据区），
     * S2MM 就是 DST_MAX */
    uint32_t room = c->is_mm2s ? (uint32_t)DST_OFF - c->buf_off : c->buf_max;

    if (n < 1) n = 1;
    if (n > (int)SG2_MAX_RING) n = (int)SG2_MAX_RING;
    if (xlen > c->max_len) xlen = c->max_len;
    if (xlen > room) xlen = room;
    if ((uint64_t)xlen * (uint64_t)n > room) {
        /* 装不下时**只压格数、不动长度** —— 这两个旋钮的意义就是一次只改一个，
         * 顺手把长度也改了（或者凑成 8777 这种数）等于把实验做废。 */
        int nwant = n;
        n = (int)(room / xlen);
        if (n < 1) n = 1;
        printf("  ⚠ --xfer=%u --ring=%d 要 %llu 字节数据窗口，这个通道只有 %u 字节"
               "（%#x..%#x）→ 改成 %d 格 × %u 字节（长度不动）\n",
               xlen, nwant, (unsigned long long)xlen * (unsigned long long)nwant,
               room, c->buf_off, c->buf_off + room, n, xlen);
    }

    memset(f, 0, sizeof(*f));
    f->ring = n;
    f->xfer = xlen;
    f->adv_slot = -1;

    printf("  ── %s ──（%d 格环 × %u 字节）\n", c->name, n, xlen);

    /* ── 清零 + 预检（PG021 的 SGIntErr 定义，见 desc_scan 上面的注释） ── */
    if (!opt_no_zero) {
        size_t z = DESC_CLEAR_BYTES;
        if (buf_size && z > buf_size) z = (size_t)buf_size;
        if (z > g_map_len)            z = g_map_len;
        memset(buf_va, 0, z);
        __sync_synchronize();
        printf("    描述符区清零 %#zx 字节（udmabuf 开头，覆盖两个通道的描述符；"
               "--no-zero 关掉）\n", z);
    } else {
        printf("    （--no-zero：没清描述符区，下面预检报出来的残留格子就可能是 SGIntErr 的来源）\n");
    }
    {
        long ncomp = 0;
        long nz = desc_scan((uint32_t *)buf_va, buf_pa, DESC_CLEAR_BYTES / 64u, 8, &ncomp);
        f->pre_stale = (ncomp > 0);
        printf("    预检 %u 格（0..%#x）: STATUS 非 0 的 %ld 格，其中 COMPLETE 置位 %ld 格%s\n",
               DESC_CLEAR_BYTES / 64u, DESC_CLEAR_BYTES, nz, ncomp,
               ncomp ? "  ⚠ **挂之前就有 COMPLETE 置位的格子** —— 引擎取到它就会 SGIntErr"
                     : "（干净）");
    }

    /* 数据窗口铺底色，等下好认"哪些字节被写过"（S2MM 靠它算实收；MM2S 这窗口是数据源） */
    {
        size_t dwin = (size_t)n * xlen;
        if (dwin > room) dwin = room;
        memset(buf_va + c->buf_off, 0xA5, dwin);
    }

    sg2_build_ring(c, n, xlen);
    for (int k = 0; k < n; k++)
        for (int w = 0; w < 8; w++)
            before[k][w] = sg_bdp_va(c, k)[w];

    /* 把我们**写下去**的描述符原样打出来。之前只打"变了哪几个字"，所以
     * "DDR 里到底是不是我们要的那份"一直是断言而不是证据 —— 这一行把它变成证据。 */
    printf("    我们写下去的描述符（先打一格全字，其余一格一行）:\n");
    {
        char t[32];
        snprintf(t, sizeof(t), "BD[0] @ %#010x", (unsigned)sg_bdp_pa(c, 0));
        dump_bd_raw(sg_bdp_va(c, 0), t);
        for (int k = 1; k < n && k < 8; k++) {
            const uint32_t *bd = sg_bdp_va(c, k);
            printf("      BD[%d] @ %#010x  NXTDESC=%#010x  BUFA=%#010x  CTRL=%#010x\n",
                   k, (unsigned)sg_bdp_pa(c, k),
                   bd[0],                       /* 两种布局的 NXTDESC 都在 +0x00 */
                   opt_alt_desc ? bd[1] : bd[2],
                   opt_alt_desc ? bd[3] : bd[6]);
        }
        if (n > 8)
            printf("      （还有 %d 格同构：NXTDESC 依次后移，最后一格绕回第 0 格）\n", n - 8);
    }

    __sync_synchronize();
    udmabuf_sync(SYNC_FOR_DEVICE);

    if (chan_reset(b, c->cr, c->sr, c->name) < 0)
        return -1;
    sg_sample(c, base, "基线");

    /* ── 第 1 步：只挂不跑 ────────────────────────────────────────────
     * 写 CURDESC、置 RS=1，**不写 TAILDESC**。这一步只问一件事：
     * 那个地址到底有没有落进寄存器（读回来是不是我们自己写的值）。
     *
     * （原先这里写的是"不写尾指针就不会开跑"。**板上实测不是这样**：不写尾指针时
     *   DMASR=0x10008（SGIncld + 阈值回显，**没有 Idle**），也就是引擎并不空闲；
     *   能说的是"尾指针没写，CURDESC 就没动、也没报错"。照实测的写。） */
    wr(b, c->cr, 0);
    wr(b, c->sr, rd(b, c->sr));                       /* W1C 清干净 */
    wr(b, c->cur, (uint32_t)base);
    __sync_synchronize();
    uint32_t rbk = rd(b, c->cur);
    f->latched = (rbk == (uint32_t)base);
    printf("    ① 只挂不跑: CURDESC 写 %#010x 读回 %#010x  -> %s\n",
           (unsigned)base, rbk,
           f->latched ? "落住了" : "**没落住**（这个寄存器没接受我们的值）");

    wr(b, c->cr, CR_RUNSTOP | CR_THRESHOLD(1));       /* RS=1 */
    __sync_synchronize();
    long hus = wait_halted_clear(b, c->sr, 200000);
    if (hus < 0)
        printf("       RS=1 后 200 ms 内 Halted 一直没清（尾指针写下去可能不算开跑）\n");
    else
        printf("       RS=1 后 Halted 清掉用了 %ld µs\n", hus);
    msleep(20);
    sg_sample(c, base, "挂完 20ms");
    {
        int any = 0;
        for (int k = 0; k < n; k++)
            if (sg_bdp_sts(c, k))
                any = 1;
        if (any)
            printf("       ⚠ 还没写尾指针，描述符 STATUS 就已经被写了 —— 见鬼，记下来\n");
    }

    /* ── 第 2 步：写尾指针，按时间线看 CURDESC 动没动 ──────────────── */
    printf("    ② 写 TAILDESC=%#010x（= 第 %d 格），之后采样:\n",
           (unsigned)(sg_bdp_pa(c, n - 1) & SG_DESC_LSB_MASK), n - 1);
    wr(b, c->tail, (uint32_t)(sg_bdp_pa(c, n - 1) & SG_DESC_LSB_MASK));
    __sync_synchronize();

    for (unsigned i = 0; i < sizeof(ms) / sizeof(ms[0]); i++) {
        char tag[24];
        if (i)
            msleep(ms[i] - ms[i - 1]);
        snprintf(tag, sizeof(tag), "t=%dms", ms[i]);
        sg_sample(c, base, tag);
        uint32_t sr = rd(b, c->sr);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            f->err = 1;
            f->sr_last = sr;
        }
        uint32_t cur = rd(b, c->cur) & SG_DESC_LSB_MASK;
        /* "走了环"只认**落在我们这 n 格里的具体地址**，并记下走到了第几格。
         * 别拿"CURDESC != 我们写的那个值"当前进 —— 板上读到过运行后 CURDESC = 0，
         * 那不是"下一条"，那是地址 0。 */
        if ((uint64_t)cur >= base && (uint64_t)cur < base + (uint64_t)n * 64u) {
            long idx = (long)(((uint64_t)cur - base) / 64u);
            if (idx > f->adv_slot)
                f->adv_slot = (int)idx;
        }
        if (cur == 0 && base != 0)
            f->cur_zero = 1;                 /* 归 0 = 引擎在跟地址 0 打交道 */
        int dup = 0;
        for (int j = 0; j < f->n_cur; j++)
            if (f->cur_vals[j] == cur)
                dup = 1;
        if (!dup && f->n_cur < (int)(sizeof(f->cur_vals) / sizeof(f->cur_vals[0])))
            f->cur_vals[f->n_cur++] = cur;
        for (int k = 0; k < n; k++)
            if (sg_bdp_sts(c, k))
                f->sts_written = 1;
    }
    f->advanced = (f->adv_slot > 0);
    {
        uint32_t sr = rd(b, c->sr);
        f->idle_seen = (!(sr & SR_HALTED) && (sr & SR_IDLE));
    }
    printf("    CURDESC 走到过环内第 %d 格（-1 = 一次都没进环；尾指第 %d 格）\n",
           f->adv_slot, n - 1);
    printf("    （末尾 Idle=%d —— **不算证据**：引擎手里没活时也是 Idle，"
           "跟\"走到尾指针\"在这里分不开）\n", f->idle_seen);
    printf("    CURDESC 采样到的值（去重，原样记录）:");
    for (int j = 0; j < f->n_cur; j++) {
        char tag[96];                  /* 这几句是给人看的判读，截断了就等于说谎 */
        if (f->cur_vals[j] == (uint32_t)base) {
            snprintf(tag, sizeof(tag), "= 环内第 0 格");
        } else if ((uint64_t)f->cur_vals[j] >= base &&
                   (uint64_t)f->cur_vals[j] <  base + (uint64_t)n * 64u) {
            snprintf(tag, sizeof(tag), "= 环内第 %ld 格（走环的证据）",
                     (long)(((uint64_t)f->cur_vals[j] - base) / 64u));
        } else if (f->cur_vals[j] == 0) {
            snprintf(tag, sizeof(tag), "= **地址 0**（不是我们这 %d 格里的任何一个）", n);
        } else {
            snprintf(tag, sizeof(tag), "= **环外的地址**（不是我们这 %d 格里的任何一个）", n);
        }
        printf("  %#010x %s", f->cur_vals[j], tag);
    }
    printf("\n");

    /* 别让它继续跑（自环的环如果尾指针错位会一直绕） */
    wr(b, c->cr, 0);
    chan_reset(b, c->cr, c->sr, c->name);
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();

    f->sts_val = 0;
    for (int k = 0; k < n; k++)
        f->sts_val |= sg_bdp_sts(c, k);
    if (f->sts_val)
        f->sts_written = 1;

    /* ── 数据侧：这一轮到底有多少字节落地 ──────────────────────────
     * S2MM 的窗口是目的地，"非底色 0xA5"的字节数就是实收；
     * MM2S 的窗口是数据源，引擎只读不写，看不出什么（打出来只是给个对照）。 */
    {
        size_t dwin = (size_t)n * xlen;
        if (dwin > room) dwin = room;
        f->got = find_data_end(buf_va + c->buf_off, dwin, 0xA5);
        printf("    数据窗口实收 %zu 字节 / 窗口 %zu（%s）\n",
               f->got, dwin,
               c->is_mm2s ? "MM2S 这窗口是数据源，读到东西不代表搬过"
                          : "S2MM 的实收字节数");
    }

    /* ── 第 3 步：逐字 diff，把"硬件回写"和"被别人改写"分开 ──────────
     * 只有 STATUS 这个字变了 = 正常（硬件回写）；
     * NEXT/BUFA/CTRL 变了 = 有人在我们写完之后动过这块内存。 */
    printf("    ③ 描述符逐字 diff（挂之前 vs 跑之后）:\n");
    {
        static const char *wn[] = { "NXTDESC", "NXTDESC_MSB", "BUFA", "BUFA_MSB",
                                    "MCCTL/RSVD", "STRIDE/RSVD", "CTRL", "STATUS" };
        int nchanged = 0;
        for (int k = 0; k < n; k++) {
            for (int w = 0; w < 8; w++)
                after[k][w] = sg_bdp_va(c, k)[w];
            for (int w = 0; w < 8; w++) {
                int sts_word = opt_alt_desc ? 4 : 7;
                if (after[k][w] == before[k][w])
                    continue;
                nchanged++;
                printf("       BD[%d].+%02x %-12s  %08x -> %08x  %s\n", k, w * 4, wn[w],
                       before[k][w], after[k][w],
                       (w == sts_word) ? "(STATUS，正常)" : "**不是 STATUS：被改过**");
                if (w != sts_word)
                    f->clobbered = 1;
            }
        }
        if (!nchanged)
            printf("       一个字都没变（含 STATUS）\n");
    }

    /* 跑完之后再把描述符区扫一遍：**我们的环之外**有没有被写过？
     * 有 = 引擎（或别人）在碰我们没铺的地址，"取的是哪儿"就有答案了。
     *
     * 复扫范围只到 SRC_OFF（0x1000 = 64 格），**不能扫到数据窗口去**：
     * 那边铺的是 0xA5 底色，每 64 字节的"STATUS 字"读到 0xA5A5A5A5 全是非 0，
     * 扫进那一片就全是假阳性（预检那一步在清零之后、铺底色之前，所以可以扫满 64KB）。 */
    {
        long ncomp = 0, nz;
        printf("    ④ 跑完复扫 0..%#x（%u 格，含我们这 %d 格）:\n",
               (unsigned)SRC_OFF, (unsigned)(SRC_OFF / 64u), n);
        nz = desc_scan((uint32_t *)buf_va, buf_pa, (long)(SRC_OFF / 64u), 16, &ncomp);
        printf("       -> STATUS 非 0 的 %ld 格（其中 COMPLETE 置位 %ld 格）%s\n",
               nz, ncomp,
               nz ? "" : "  （一片干净：连我们自己那几格都没被回写）");
    }

    if (f->err) {
        printf("    期间报错: DMASR=%#010x →", f->sr_last);
        print_dmasr_err(f->sr_last);
        if (f->sr_last & SR_ERR_SG)
            printf("      ⚠ PG021 原文（v7.1 §SGIntErr）：**取到一条 COMPLETE 已置位的描述符**\n"
                   "        就会报这个错 —— 引擎把它当\"尾描述符\"优雅停机，而且**这个错\n"
                   "        不会写回描述符**。所以上面\"8 个字一个字都没变\"不是反证。\n"
                   "        先看 ② 的预检和 ④ 的复扫：挂之前就有 COMPLETE 置位的格子吗？\n"
                   "        有 -> 是把旧描述符当成了我们的（软件问题，需要清干净）；\n"
                   "        没有 -> 引擎读到了我们没铺过的地址，那才是硬件的事。\n");
    }
    return 0;
}

/* 把事实翻成一句人话 + 下一步该抓什么。**只按 bool 分叉，不排序"最可能的"。** */
static void sg_verdict(const struct sg_chan *c, const struct sg_find *f)
{
    printf("  %s（%d 格 × %u 字节）: ", c->name, f->ring, f->xfer);
    if (f->clobbered)
        printf("描述符的 NEXT/BUFA/CTRL 被改过 —— 有别人在写我们这块内存\n");
    else if (!f->latched)
        printf("CURDESC 根本读不回我们写的值 —— 寄存器那层的问题\n");
    else if (f->advanced || f->sts_written)
        printf("引擎动了：CURDESC 走到环内第 %d 格，%s\n",
               f->adv_slot,
               f->sts_written ? "有描述符被回写" : "但一条 STATUS 都没被回写");
    else if (f->cur_zero)
        printf("CURDESC 被清成了 0 —— 引擎动了，动的是**地址 0**，不是我们这 %d 格\n",
               f->ring);
    else if (f->err)
        printf("引擎取了东西并报错（DMASR=%#010x）—— %s",
               f->sr_last,
               (f->sr_last & SR_ERR_SG)
                 ? "SGIntErr 的含义只有一种（PG021 原文）：\n"
                   "      **引擎取到了一条 COMPLETE 已经置位的描述符** —— 它把这条当\"尾描述符\"\n"
                   "      优雅停机（RS 清 0、Halted 置 1），而且**这个错不会写回描述符**。\n"
                   "      所以\"报错但 8 个字一个字都没变\"不是反证，正是这条说的。\n"
                 : "见上面那行的位名\n");
    else
        printf("CURDESC 没变、不报错、STATUS 也没人写 —— 引擎一次都没取\n");
    if (!c->is_mm2s)
        printf("      数据侧合计实收 %zu 字节（S2MM\"到底搬没搬成\"直接看这个）\n", f->got);
}

/* 两个通道的结果合起来看，决定下一步是软件还是 ILA，ILA 又该抓哪儿。 */
static void sg_next_step(const struct sg_find *mm, const struct sg_find *sm,
                         int have_mm, int have_sm)
{
    printf("\n  【下一步】\n");
    if (have_mm && have_sm && mm->clobbered && sm->clobbered) {
        printf("    两个通道的描述符都被改过 ⇒ 先查有没有别的 master 在写这块 DDR"
               "（HP2 是和厂商 S2_AXI_HP_HC_* 共用的）。\n"
               "    ILA: 抓 axi_interconnect_4_M00_AXI 的 AW 通道，看是不是厂商在写。\n");
        return;
    }
    int latched_all = (!have_mm || mm->latched) && (!have_sm || sm->latched);
    /* 判"动没动"只看 CURDESC 前进 / STATUS 被回写 / 报错 —— 不看 Idle
     * （引擎手里没活时也是 Idle，跟"走到尾指针"分不开，见 struct sg_find）。 */
    int moved_any   = (have_mm && (mm->advanced || mm->sts_written))
                   || (have_sm && (sm->advanced || sm->sts_written));
    int err_any     = (have_mm && mm->err) || (have_sm && sm->err);
    int zero_any    = (have_mm && mm->cur_zero) || (have_sm && sm->cur_zero);
    int stale_any   = (have_mm && mm->pre_stale) || (have_sm && sm->pre_stale);

    /* 挂之前就有 COMPLETE 置位的格子 —— 这是"取到旧描述符"最直接的证据，
     * 而且它是最省事的解释，应当**先**排除掉再谈硬件。 */
    if (stale_any) {
        printf("    挂之前，描述符区里就已经有 COMPLETE 置位的格子（② 预检打出来了）\n"
               "    ⇒ 引擎报 SGIntErr **先按「取到旧描述符」解释**，这跟硬件无关。\n"
               "      默认在挂之前已经清过 64KB；还有残留说明：清的范围之外还有旧描述符、\n"
               "      或者有别的东西在写这片内存。先把残留清干净，再重跑这一条命令。\n");
        return;
    }
    if (!latched_all) {
        printf("    有通道连 CURDESC 都读不回我们的值 ⇒ **还没走到 DDR**，"
               "问题在 AXI-Lite 写那两个寄存器这一段。\n"
               "    ILA: 抓 axi_dma 的 s_axi_lite 写通道（AWADDR/WDATA/WVALID），"
               "看 0x08/0x38 那一笔写到底有没有到。\n");
        return;
    }
    if (zero_any && !err_any && !moved_any) {
        printf("    地址落住了，引擎也动了（CURDESC 被清成 0）但没报错"
               " ⇒ 引擎在处理**另一个地址**上的描述符，而且那份描述符是\"完整\"的。\n"
               "    ILA: 抓 axi_dma 的 m_axi_sg **读地址**通道（ARADDR/ARVALID），"
               "看引擎实际发出去的是哪个地址。\n");
        return;
    }
    if (!moved_any && !err_any && !zero_any) {
        printf("    地址落住了、但引擎一点动静都没有 ⇒ 问题在"
               "\"Lite 寄存器 -> SG 引擎\"这一步，还没开始访存。\n"
               "    ILA: 抓 axi_dma 的 m_axi_sg 只读通道，"
               "看引擎有没有发过一笔 ARVALID（ARADDR 应当 = 描述符地址）。\n");
        return;
    }
    if ((err_any || zero_any) && !moved_any) {
        printf("    引擎报了错、而且**一条描述符都没被回写**。这跟以前不一样了 ——\n"
               "    按 PG021 原文，SGIntErr 只有一种成因：**引擎取到了一条 COMPLETE 已置位的\n"
               "    描述符**（它把这条当\"尾描述符\"，优雅停机），而且这个错**不写回描述符**。\n"
               "    所以先别下\"读通路坏了\"的结论，按这个顺序排：\n"
               "      ① 看上面 ② 的预检和 ④ 的复扫：挂之前，描述符区里有没有 COMPLETE\n"
               "         置位的格子？（default 已经改成\"挂之前先清零\"，这一栏应当全 0。）\n"
               "         · 有 -> 引擎取的可能就是那条旧描述符，先把残留清干净再跑；\n"
               "         · 没有 -> 引擎读的是**我们没铺过、也没清过的地址**，那才轮到查读通路。\n"
               "      ② 再看形状。同一片内存上 1024 字节的描述符（carpet）走得通、这条路\n"
               "         不通，差别只有两处：**每格多少字节** 和 **环有几格**。一次只动一个：\n");
        if (have_mm && mm->err)
            printf("           ./pl_dma_test sg2 --mm2s --xfer=1024   （长度对上，环还是 %d 格）\n"
                   "           ./pl_dma_test sg2 --mm2s --ring=16     （环变长，长度还是 8192）\n",
                   mm->ring);
        if (have_sm && sm->err)
            printf("           ./pl_dma_test sg2 --s2mm --xfer=1024\n"
                   "           ./pl_dma_test sg2 --s2mm --ring=16\n");
        printf("      ③ 两条都跑过之后，[下一步] 就不再是猜了 —— 要么是描述符几何（软件），\n"
               "         要么是引擎读的地址（硬件，按 doc/pl_sg_ila.md 抓 m_axi_sg 读通道）。\n"
               "    ILA（③ 之后才做）: 抓 axi_dma 的 m_axi_sg **ARADDR/ARVALID** —— 看它\n"
               "    实际发出的是哪个地址；读响应对照 RDATA。\n"
               "    （这两个口**没有 RID**；要看 ID 得抓 axi_interconnect_4_M00_AXI，6 位。）\n");
        return;
    }
    printf("    引擎在走环 ⇒ 取描述符这条路是通的，往数据侧查。\n"
           "    ILA: 抓 axi_dma 的 m_axi_sg 读响应（RDATA）与 m_axi_s2mm 写通道。\n");
}

/* ─────────────────────────── sg2 命令 ─────────────────────────── */
static int cmd_sg2(int which)
{
    struct sg_find f[2];
    int have[2] = { 0, 0 };
    int rc = 0;

    printf("[sg2] 把\"挂\"和\"跑\"拆开，两个通道分开测；并且逐字 diff 描述符\n");
    sg_chan_init();
    for (int i = 0; i < SG_NCHAN; i++) {
        if (which && which != (i + 1))
            continue;
        have[i] = 1;
        memset(&f[i], 0, sizeof(f[i]));
        if (sg2_run_chan(&g_sg_chan[i], &f[i]) < 0)
            rc = -1;
        printf("\n");
    }
    for (int i = 0; i < SG_NCHAN; i++)
        if (have[i])
            sg_verdict(&g_sg_chan[i], &f[i]);
    if (SG_NCHAN == 2 && have[0] && have[1]) {
        int same = 1;
        /* 两个通道表现一样吗？一样 = 共性（读通路），不一样 = 通道特有 */
        if ((f[0].advanced || f[0].sts_written || f[0].err) !=
            (f[1].advanced || f[1].sts_written || f[1].err))
            same = 0;
        printf("  两个通道表现%s —— %s\n", same ? "一致" : "不一致",
               same ? "共性的东西（取描述符那条 32bit 读通路）"
                    : "有一个是通道特有的，别按共性查");
    }
    sg_next_step(&f[0], &f[1], have[0], have[1]);
    return rc;
}

/* ═══════════════════════════ carpet：描述符地毯 ═══════════════════════════
 * 想法：把 udmabuf 从 0 开始**每 64 字节铺一个合法描述符**，铺到内存尽头。
 * 之后再挂环。这样"引擎读的地址跟我们给的不一样"就不再表现成错误，
 * 而是表现成**可以测量的结果**：
 *   * 哪个槽位的 STATUS 被回写了  -> 引擎读的是哪个地址（精确到 64 字节）
 *   * 哪个目标块收到了数据        -> 交叉印证（BUFA 按槽号 %8 分流）
 *   * 什么都没被写                -> 引擎没在这片窗口里读过任何东西
 * 第三种结果同样是答案：说明跟描述符内容无关（内容已经全合法了），
 * 问题在"取"这个动作本身 —— 那就别再改软件了，上 ILA。
 *
 * 只消费前 CARPET_CONSUME 格（TAILDESC 指在那儿），所以写的量很小，
 * 不用担心把内存写花。
 */
#define CARPET_CONSUME  8u      /* TAILDESC 指第 7 格 -> 最多被消费 8 格 */
#define CARPET_MIN_SLOT 1024u   /* 地毯至少要铺这么多格（64 KB） */
#define CARPET_MAX_SLOT 16384u  /* 上限（1 MB） */
#define CARPET_FP       8u      /* BUFA 按槽号分几路（指纹） */
/* 指纹数据区最大占用：每路 = 描述符长度，所以按**允许的最大长度**预留
 * （--carpet-len 可以把它撑到 CARPET_MAX_LEN）。这个数只影响"自动算多少格"
 * 和"映射够不够"这两处，铺的时候用的是实际长度。 */
#define CARPET_MAX_LEN  8192u
#define CARPET_DATA_MAX (CARPET_FP * CARPET_MAX_LEN)

static long opt_carpet_slots = 0;   /* --carpet-slots=N；0 = 按 udmabuf 大小自动算 */

/* 把 mmap 扩到 need 字节（carpet 要铺的长度可能比默认映射长） */
static int ensure_mapped(size_t need)
{
    if (need <= g_map_len)
        return 0;
    void *p;
    if (opt_buf_mem) {
        int fd = open("/dev/mem", O_RDWR | O_SYNC);
        if (fd < 0) { perror("  carpet: open /dev/mem"); return -1; }
        p = mmap(NULL, need, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)buf_pa);
        close(fd);
    } else {
        p = mmap(NULL, need, PROT_READ | PROT_WRITE, MAP_SHARED, buf_fd, 0);
    }
    if (p == MAP_FAILED) {
        fprintf(stderr, "  carpet: 重新 mmap %#zx 字节失败 (%s)\n", need, strerror(errno));
        return -1;
    }
    munmap(buf_va, g_map_len);
    buf_va   = p;
    g_map_len = need;
    printf("  carpet: 映射扩到 %#zx 字节\n", need);
    return 0;
}

/* base_off：这个通道的地毯铺在 udmabuf 的哪个偏移开始。
 * **两个通道必须给不同的 base_off** —— 上一版两边都从 0 铺，而 MM2S 那一轮会把
 * COMPLETE 回写进槽位；要是 MM2S 引擎被 CR=0 停下之后还有一笔回写没落地（它当时
 * 确实还在跑），那笔写就会落在 S2MM 已经重新铺好的格子上 —— 于是 S2MM 取到一条
 * COMPLETE 已置位的描述符，**正好触发 SGIntErr**。那次"MM2S 好好的、S2MM 报
 * SGIntErr"的读数，很可能就是这么来的，与硬件无关。分开之后这个干扰就没了。 */
static int carpet_one(const struct sg_chan *c, long slots, size_t base_off)
{
    volatile uint32_t *b = c->reg;
    uint64_t bd_base = buf_pa + base_off;                         /* 描述符区 */
    uint64_t data_pa = bd_base + (uint64_t)slots * 64u;           /* 数据区：紧跟其后 */
    uint32_t xlen    = opt_carpet_len > 0 ? (uint32_t)opt_carpet_len
                                          : (c->is_mm2s ? 1024u : FRAME_OUT_BYTES);
    size_t   blk;
    uint32_t ctrl;
    struct sg_find f;
    uint64_t base = bd_base & SG_DESC_LSB_MASK;

    /* 先夹紧再算 blk/ctrl —— 顺序反了的话，"描述符里写的长度"和
     * "数据区实际按多大分块"就会对不上（这种不一致最难查）。 */
    if (xlen > c->max_len)
        xlen = c->max_len;
    blk  = xlen;                                                  /* 每路指纹块大小 */
    ctrl = c->is_mm2s ? (BD_CTRL_SOF | BD_CTRL_EOF | BD_CTRL_LEN(xlen))
                      : BD_CTRL_LEN(xlen);
    memset(&f, 0, sizeof(f));
    f.ring = (int)(slots > 64 ? 64 : slots);
    f.xfer = xlen;

    /* 数据区先铺底色，等下好认"哪些字节被写过" */
    memset(buf_va + base_off + (size_t)slots * 64u, 0xA5, CARPET_FP * blk);

    /* 铺地毯 */
    for (long i = 0; i < slots; i++) {
        uint64_t next = bd_base + ((uint64_t)((i + 1) % slots)) * 64u;
        uint64_t bufa = data_pa + (uint64_t)(i % CARPET_FP) * blk;
        bd_write((uint32_t *)(buf_va + base_off + (size_t)i * 64u), next, bufa, ctrl);
    }
    __sync_synchronize();
    udmabuf_sync(SYNC_FOR_DEVICE);

    printf("  ── %s ──\n", c->name);
    printf("    地毯: %ld 格 @ %#010x..%#010x（%ld KB，偏移 %#zx），"
           "描述符长度 %u，尾指针指第 %u 格\n",
           slots, (unsigned)bd_base, (unsigned)(bd_base + (uint64_t)slots * 64u),
           slots * 64 / 1024, base_off, xlen, CARPET_CONSUME - 1);
    printf("    我们写下去的第一格:");
    {
        const uint32_t *bd = (const uint32_t *)(buf_va + base_off);
        printf("  NXTDESC=%#010x  BUFA=%#010x  CTRL=%#010x\n",
               opt_alt_desc ? bd[0] : bd[0],
               opt_alt_desc ? bd[1] : bd[2],
               opt_alt_desc ? bd[3] : bd[6]);
    }

    if (chan_reset(b, c->cr, c->sr, c->name) < 0)
        return -1;
    wr(b, c->cr, 0);
    wr(b, c->sr, rd(b, c->sr));
    wr(b, c->cur, (uint32_t)base);
    __sync_synchronize();
    f.latched = (rd(b, c->cur) == (uint32_t)base);
    wr(b, c->cr, CR_RUNSTOP | CR_THRESHOLD(1));
    __sync_synchronize();
    wait_halted_clear(b, c->sr, 200000);
    wr(b, c->tail, (uint32_t)((bd_base + (uint64_t)(CARPET_CONSUME - 1) * 64u)
                              & SG_DESC_LSB_MASK));
    __sync_synchronize();

    sg_sample(c, base, "挂上");
    f.adv_slot = -1;
    for (int k = 0; k < 6; k++) {
        char tag[16];
        msleep(200);
        snprintf(tag, sizeof(tag), "t=%dms", (k + 1) * 200);
        sg_sample(c, base, tag);
        uint32_t sr = rd(b, c->sr);
        if (sr & (SR_ERR | SR_ERR_SG)) { f.err = 1; f.sr_last = sr; }
        /* 地毯里每一格都是合法描述符，所以"动过"= 指向了地毯里的**别的**某格 */
        uint32_t cur = rd(b, c->cur) & SG_DESC_LSB_MASK;
        if (cur == 0 && (uint32_t)base != 0)
            f.cur_zero = 1;
        else if ((uint64_t)cur >= bd_base &&
                 (uint64_t)cur <  bd_base + (uint64_t)slots * 64u) {
            long idx = (long)(((uint64_t)cur - bd_base) / 64u);
            if (idx > f.adv_slot)
                f.adv_slot = (int)idx;
        }
    }
    f.advanced = (f.adv_slot > 0);

    wr(b, c->cr, 0);
    chan_reset(b, c->cr, c->sr, c->name);
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();

    /* ── 扫：哪些槽位的 STATUS 被写过 ──
     * 除了逐格明细，还打一条**紧凑的槽号清单**（最多 64 个）。
     * 明细里 "第 0..5 格被回写" 这种收尾会把中间的**空档**藏掉 —— 板上真出现过
     * "0,1,2,3,5 被写过、第 4 格没有"这种洞，是靠清单才看得见的。 */
    {
        long n = 0, first = -1, last = -1;
        long list[64];                      /* 前 64 个命中的槽号，用来打一条紧凑清单 */
        int  nlist = 0;

        for (long i = 0; i < slots; i++) {
            uint32_t s = bd_read_sts((const uint32_t *)(buf_va + base_off + (size_t)i * 64u));
            if (!s)
                continue;
            f.sts_written = 1;
            if (first < 0)
                first = i;
            last = i;
            n++;
            if (nlist < 64)
                list[nlist++] = i;
        }
        printf("    扫描全部槽位（STATUS 非 0 的槽号）: ");
        if (!n) {
            printf("一个都没有（没有任何槽位的 STATUS 被写过）\n");
        } else {
            for (int j = 0; j < nlist; j++)
                printf("%s%ld", j ? "," : "", list[j]);
            printf("%s\n", n > nlist ? ",..." : "");
            printf("      -> 共 %ld 格被回写（第 %ld..%ld 格）\n", n, first, last);
        }
        /* 明细再逐格打一遍（含地址和实收字节），前 8 格 */
        for (int j = 0, r = 0; j < nlist && r < 8; j++) {
            long i = list[j];
            uint32_t s = bd_read_sts((const uint32_t *)(buf_va + base_off + (size_t)i * 64u));
            printf("      第 %ld 格 @ %#010x  STATUS=%#010x（实收 %u）%s\n",
                   i, (unsigned)(bd_base + (uint64_t)i * 64u), s, s & BD_STS_LEN_MASK,
                   (s & BD_STS_COMPLETE) ? " COMPLETE（PG021：取到它会 SGIntErr）" : "");
            r++;
        }
    }

    /* ── 扫：数据区哪几路收到了数据（指纹的交叉印证） ── */
    {
        printf("    数据区指纹（BUFA 按槽号 %% %u 分流，每路 %zu 字节）: ", CARPET_FP, blk);
        int any = 0;
        f.got = 0;                     /* 合计数存进 f.got，sg_verdict 要打它 ——
                                        * 不填的话 verdict 会打"实收 0 字节"，跟这一行自相矛盾 */
        for (unsigned i = 0; i < CARPET_FP; i++) {
            size_t left = count_bytes(buf_va + base_off + (size_t)slots * 64u + i * blk,
                                      blk, 0xA5);
            printf(" #%u=%zuB", i, blk - left);
            f.got += blk - left;
            if (left != blk)
                any = 1;
        }
        printf("%s\n", any ? "" : "（一路都没收到东西）");
    }

    /* ── 抽几格确认 NEXT/BUFA 没被人改过 ── */
    {
        int bad = 0;
        for (long i = 0; i < slots && i < 256; i++) {
            uint32_t *bd = (uint32_t *)(buf_va + base_off + (size_t)i * 64u);
            uint64_t next = bd_base + ((uint64_t)((i + 1) % slots)) * 64u;
            if (bd[0] != (uint32_t)(next & 0xFFFFFFC0u)) {
                printf("      第 %ld 格的 NXTDESC 被改过: %08x（应为 %08x）\n",
                       i, bd[0], (unsigned)(next & 0xFFFFFFC0u));
                bad++;
                f.clobbered = 1;
                if (bad > 4) break;
            }
        }
        if (!bad)
            printf("    抽查前 256 格的 NXTDESC：一个字都没被改\n");
    }

    if (f.err) {
        printf("    期间报错: DMASR=%#010x →", f.sr_last);
        print_dmasr_err(f.sr_last);
    }
    if (f.cur_zero)
        printf("    ⚠ CURDESC 归过 0 —— 引擎在跟「地址 0」打交道，"
               "不是地毯里任何一格\n");
    sg_verdict(c, &f);
    if (!f.sts_written && !f.advanced && !f.err && !f.cur_zero) {
        printf("      **连合法地毯都取不动** ⇒ 与描述符内容无关。"
               "软件侧到此为止，再查就是删重建/换 IP 这种没机理的碰运气 —— 上 ILA。\n");
    }
    return 0;
}

static int cmd_carpet(int which, long slots)
{
    long use = slots, nchan = 0, ci = 0;
    size_t region, need;

    printf("[carpet] 每 64 字节铺一个合法描述符，用来测\"引擎实际读的是哪个地址\"\n");
    if (opt_carpet_len > (long)CARPET_MAX_LEN) {
        printf("  ⚠ --carpet-len=%ld 超过预留上限 %u，按 %u 算（数据区是按它预留的）\n",
               opt_carpet_len, CARPET_MAX_LEN, CARPET_MAX_LEN);
        opt_carpet_len = (long)CARPET_MAX_LEN;
    }
    if (use <= 0 && opt_carpet_slots > 0)
        use = opt_carpet_slots;
    if (use <= 0) {
        if (!buf_size) {
            fprintf(stderr, "  carpet: 读不到 udmabuf0 的 size，没法算能铺多长。\n"
                            "  用 --carpet-slots=N 手工指定（例如 4096）。\n");
            return -1;
        }
        /* 数据区要紧跟在描述符区后面，所以先把它扣掉再算能铺几格 */
        use = (long)((buf_size - 2u * CARPET_DATA_MAX - 64u) / 64u);
        if (use > (long)CARPET_MAX_SLOT) use = (long)CARPET_MAX_SLOT;
    }
    if (use < (long)CARPET_MIN_SLOT) {
        fprintf(stderr, "  carpet: 只愿意铺 %ld 格，太少（至少 %u 格 = 64 KB）。\n"
                        "  改 dts 里 u-dma-buf 的 size，或者 --carpet-slots=N 硬来。\n",
                use, CARPET_MIN_SLOT);
        return -1;
    }
    /* 一个通道占一整片（描述符 + 数据），**两个通道不共用**，见 carpet_one 的注释。
     * 这样 MM2S 那一轮留在槽位里的 COMPLETE 就踩不到 S2MM 的格子上。 */
    region = (size_t)use * 64u + CARPET_DATA_MAX + 64u;
    for (int i = 0; i < SG_NCHAN; i++)
        if (!which || which == (i + 1))
            nchan++;
    need = (size_t)nchan * region;
    if (need > (size_t)buf_size) {
        fprintf(stderr, "  carpet: 要 %#zx 字节（%ld 个通道各 %#zx），udmabuf0 只有 %llu 字节\n",
                need, nchan, region, (unsigned long long)buf_size);
        return -1;
    }
    if (ensure_mapped(need) < 0)
        return -1;
    printf("  两个通道的地毯区已经分开（各 %#zx 字节）：偏移 0 给 MM2S，"
           "%#zx 给 S2MM\n", region, region);
    printf("  （上一版是两边都从 0 铺 —— 那样 MM2S 尾巴上没落地的 STATUS 回写会落在\n"
           "   S2MM 刚铺好的格子上，正好凑出\"取到 COMPLETE 已置位的描述符\"这个\n"
           "   SGIntErr 触发条件，跟硬件无关。所以那次 S2MM 报 SGIntErr 不能算数。）\n");

    sg_chan_init();
    int rc = 0;
    for (int i = 0; i < SG_NCHAN; i++) {
        if (which && which != (i + 1))
            continue;
        /* 每个通道铺自己那一片：上一轮的 STATUS 回写会留在槽位里，不清掉会误判 */
        if (carpet_one(&g_sg_chan[i], use, (size_t)ci * region) < 0)
            rc = -1;
        ci++;
        printf("\n");
    }
    printf("  【判读】（只看证据：某格 STATUS 被回写 / CURDESC 落在地毯里某一格）\n"
           "    有格子被回写  -> 引擎读的是**那个地址**（上面打出来了，精确到 64 字节）：\n"
           "                    那就是地址通路的事，不是数据通路。\n"
           "    什么都没有    -> 连合法地毯都不取：问题在\"取\"这个动作本身。\n"
           "    注意 S2MM 这路：数据要 MM2S 喂过 HLS 才有，所以它多半只有 STATUS 里\n"
           "    的\"描述符被取过\"这一条证据，别指望指纹区有数据。\n"
           "    报 SGIntErr 时先看上面的槽号清单：**有 COMPLETE 置位的格子**吗？\n"
           "    那才是 PG021 说的唯一成因，别急着当成读通路坏了。\n"
           "    ILA 具体抓哪儿见 doc/pl_sg_ila.md 的对照表。\n");
    return rc;
}

/* 等这一串描述符收完，把每个描述符里的实收字节和 STATUS 取出来。
 *
 * 描述符**是按顺序**完成的，所以只盯最后一个：它 COMPLETE 了，前面的一定都完了。
 * 返回 0 成功，-1 出错/超时。
 *
 * 注：这里直接读 DDR 里的描述符，靠的是 udmabuf 的映射本来就是非缓存的
 * （dma_coherent=1，板上确认过）。万一那块映射是可缓存的，轮询会一直读到旧值；
 * 所以超时那一刻会先挤一遍缓存再读一次，好把"读早了"和"真没写"分开。 */
static int s2mm_sg_wait(int nbd, uint32_t *len, uint32_t *sts)
{
    volatile uint32_t *b = reg1;
    uint64_t t0 = now_ms();
    uint32_t sr = 0;
    int tick = 0;

    if (nbd < 1)
        return -1;

    for (;;) {
        sr = rd(b, S2MM_SR);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            printf("    S2MM(SG) 出错: DMASR=%#010x\n", sr);
            print_dmasr_err(sr);
            if (sr & SR_ERR_SG)
                printf("      （SG 类错误基本只跟描述符本身有关：布局/物理地址/对齐。"
                       "默认是 BSP 的 64 字节布局，可试 --alt-desc）\n");
            dump_sg_bds(nbd);
            wr(b, S2MM_SR, sr);
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }

        if (sg_bd_sts(nbd - 1) & BD_STS_COMPLETE)
            break;

        /* 每 500 ms 把 MM2S 那一侧也打一行出来。S2MM 一直没动静时，
         * "MM2S 到底完成没有"是第一个分叉点 —— 输入 FIFO 只有 2 帧深，
         * HLS 排不出结果就会被反压住、进而顶住 MM2S。所以：
         *   MM2S 完成了  -> 上游（MM2S→HLS）是通的，问题在 dout 之后；
         *   MM2S 没完成  -> 得回头看 S2MM 是不是压根没在收（tready 恒 0 顶住了整条链）。 */
        if (++tick % 500 == 0) {
            uint32_t msr = rd(reg0, MM2S_SR);
            uint32_t mbd = bd_read_sts((const uint32_t *)(buf_va + BD_OFF));
            printf("      …%llu ms  MM2S: DMASR=%#010x 描述符=%#010x[%s%s]"
                   "  |  S2MM: DMASR=%#010x 末描述符=%#010x\n",
                   (unsigned long long)(now_ms() - t0), msr, mbd,
                   (mbd & BD_STS_COMPLETE) ? "COMPLETE" : "未完",
                   (msr & SR_IOC) ? " IOC" : "",
                   sr, sg_bd_sts(nbd - 1));
        }

        if (now_ms() - t0 > (uint64_t)opt_timeout_ms) {
            uint32_t late;
            udmabuf_sync(SYNC_FOR_CPU);
            cache_evict();                  /* 见上面注释：先排除"读到旧 cache line" */
            late = sg_bd_sts(nbd - 1);
            printf("    S2MM(SG) 超时 %d ms：DMASR=%#010x，最后一个描述符 STATUS=%#010x%s\n",
                   opt_timeout_ms, sr, late,
                   (late & BD_STS_COMPLETE) ? "  <- 挤完缓存是 COMPLETE：刚才是读早了" : "");
            if (!(late & BD_STS_COMPLETE))
                printf("      提示：dout 只有 HLS 跑起来才有（要先 mm2s 灌数据进去）。\n"
                       "            描述符一个都没动的话，先确认 bitstream 是新的、"
                       "axi_dma_1 的 m_axi_sg 接到了 DDR。\n");
            dump_sg_bds(nbd);
            wr(b, S2MM_SR, sr);
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }
        msleep(1);
    }

    for (int k = 0; k < nbd; k++) {
        sts[k] = sg_bd_sts(k);
        len[k] = sts[k] & BD_STS_LEN_MASK;
    }
    return 0;
}

/* 单描述符版：用途和老的直读模式一样——收满 length 或**撞上 TLAST** 就结束。
 * 返回实收字节数（硬件回写在描述符 STATUS 里的），<0 失败。 */
static long do_s2mm_sg(uint32_t dst_off, uint32_t length, int drain_only)
{
    uint8_t *dst = buf_va + DST_OFF + dst_off;
    uint32_t len = 0, sts = 0;

    if (length == 0 || (uint64_t)dst_off + length > DST_MAX) {
        fprintf(stderr, "S2MM 目标偏移 %#x + 长度 %u 超出目标区 (共 %lu)\n",
                dst_off, length, (unsigned long)DST_MAX);
        return -1;
    }

    memset(dst, 0xA5, length);      /* 底色：SG 下不再是主判据，但能看出"没写到的部分" */
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();

    if (s2mm_sg_arm(dst_off, length, 1) < 0)
        return -1;

    if (!drain_only)
        printf("    S2MM(SG) 已挂：1 个描述符（缓冲 %#010x，长度 %u），"
               "CURDESC=%#010x TAILDESC=%#010x\n",
               (unsigned)(buf_pa + DST_OFF + dst_off), length,
               rd(reg1, S2MM_CURDESC), rd(reg1, S2MM_TAILDESC));

    if (s2mm_sg_wait(1, &len, &sts) < 0)
        return -1;

    wr(reg1, S2MM_SR, rd(reg1, S2MM_SR));
    chan_reset(reg1, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
    udmabuf_sync(SYNC_FOR_CPU);

    if (!drain_only)
        printf("    S2MM(SG) 完成：描述符 STATUS=%#010x [%s%s%s]，实收 %u / %u 字节"
               "（这个数是硬件回写的，不是数底色数出来的）\n",
               sts,
               (sts & BD_STS_COMPLETE) ? "COMPLETE " : "",
               (sts & BD_STS_RXSOF) ? "RXSOF " : "",
               (sts & BD_STS_RXEOF) ? "RXEOF " : "",
               len, length);
    return (long)len;
}

/* ─────────────────────────── S2MM（axi_dma_1） ───────────────────────────
 * 返回实际收到的字节数，<0 表示失败。
 *
 * `dst_off` 是**相对目标区（DST_OFF）的偏移**，`length` 是这次要收的字节数。
 *
 * dout 带 TLAST，所以这个传输**可能提前结束**：AXI DMA 收到 TLAST 就收工，
 * 未必等到 length 字节（板上实测：LENGTH 给 5472，收到一帧 684 就 IOC）。
 *
 * 实收多少：SG 模式下是描述符 STATUS 里硬件回写的值（可信）；
 * 直读模式下要以**内存**为准（find_data_end）——那时 S2MM_LENGTH 读回来是
 * **已收量**而非剩余量，板上 684/684、652/652 两两对上，已经证实。
 */
static long do_s2mm_simple(uint32_t dst_off, uint32_t length, int drain_only);

static long do_s2mm(uint32_t dst_off, uint32_t length, int drain_only)
{
    if (!opt_simple)
        return do_s2mm_sg(dst_off, length, drain_only);
    return do_s2mm_simple(dst_off, length, drain_only);
}

static long do_s2mm_simple(uint32_t dst_off, uint32_t length, int drain_only)
{
    volatile uint32_t *b = reg1;
    uint64_t dst_pa = buf_pa + DST_OFF + dst_off;
    uint8_t *dst = buf_va + DST_OFF + dst_off;

    if (length == 0 || dst_off + length > DST_MAX) {
        fprintf(stderr, "S2MM 目标偏移 %#x + 长度 %u 超出目标区 (共 %lu)\n",
                dst_off, length, (unsigned long)DST_MAX);
        return -1;
    }

    memset(dst, 0xA5, length);              /* 先铺个底色，后面好认哪些字节没被写过 */
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();                          /* 底色先落 DDR，免得可缓存映射下盖住 DMA 的写 */

    if (chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)") < 0)
        return -1;

    /* 直读模式的顺序（照 Xilinx 官方 poll 例程）：DMACR=0 -> DA -> DMACR=RS -> LENGTH */
    wr(b, S2MM_CR, 0);
    wr(b, S2MM_DA, (uint32_t)dst_pa);
    wr(b, S2MM_CR, CR_RUNSTOP | CR_THRESHOLD(1));
    __sync_synchronize();
    wr(b, S2MM_LENGTH, length);             /* 写这个就开跑 */

    printf("    S2MM 已挂：DA=%#010x（期望 %#010x）LENGTH 写入 %u，立刻读回 %u\n",
           rd(b, S2MM_DA), (unsigned)(uint32_t)dst_pa, length, rd(b, S2MM_LENGTH));

    uint64_t t0 = now_ms();
    uint32_t sr;
    int tick = 0;
    for (;;) {
        sr = rd(b, S2MM_SR);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            printf("    S2MM 出错: DMASR=%#010x", sr);
            /* 注：bit3 是 **SGIncld**，不是错误位。本文件上面那段注释里写过一版
             *     "PG021 把 DMAIntErr 放 bit3" —— 那是错的，这里连解码一起改正。
             * 错误位按 PG021：bit4 DMAIntErr / bit5 DMASlvErr / bit6 DMADecErr，
             *     BSP 的 xaxidma_hw.h 沿用同一套。 */
            if (sr & 0x08) printf(" [SGIncld=1（模式位，不是错误）]");
            if (sr & 0x10) printf(" [DMAIntErr/DMASlvErr(bit4)]");
            if (sr & 0x20) printf(" [DMASlvErr/DMADecErr(bit5)]");
            if (sr & 0x40) printf(" [DMADecErr/SGIntErr(bit6)]");
            if (sr & 0x100) printf(" [SG bit8]");
            if (sr & 0x200) printf(" [SG bit9]");
            if (sr & 0x400) printf(" [SG bit10]");
            printf("\n");
            wr(b, S2MM_SR, sr);             /* W1C */
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }
        if (sr & SR_IOC)
            break;
        if (now_ms() - t0 > (uint64_t)opt_timeout_ms) {
            printf("    S2MM 超时 %d ms（DMASR=%#010x，还没收到 %u 字节）\n",
                   opt_timeout_ms, sr, length);
            printf("    提示：dout 只有 HLS 跑起来才有（要先 mm2s 灌一帧进去）。\n"
                   "          单独跑 s2mm 必然收不满——这时要看的是 S2MM_LENGTH 里剩多少。\n");
            wr(b, S2MM_SR, sr);
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }
        if (!drain_only) {
            msleep(1);
            /* 每 ~50ms 打一次 LENGTH：能看清它是在**递减**（= 剩余量）
             * 还是**递增**（= 已收量），顺便暴露"还在收就被读走"的时序问题 */
            if (++tick % 50 == 0)
                printf("      …仍在等：DMASR=%#010x S2MM_LENGTH=%u（写入 %u）\n",
                       sr, rd(b, S2MM_LENGTH), length);
        }
    }

    uint32_t remain = rd(b, S2MM_LENGTH);

    wr(b, S2MM_SR, sr);                     /* 清 IOC */
    chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
    udmabuf_sync(SYNC_FOR_CPU);

    /* 以**内存**为准：寄存器读回的到底是"已收"还是"剩余"，只有 DDR 里有真相。
     * 板上定论：S2MM_LENGTH 读回的是**已收字节数**，和 find_data_end 数出来的完全一致。
     * ⚠️ 别把"哪个命令给多少"记成命令名——684 还是 652 取决于**挂法**：热路径 `frames`
     * 是整帧 684，`e2e` 和 `frames --slow-rearm` 走软复位、恒 652（见 s2mm_arm 上面那段）。
     * 这里早先写成"e2e 684、frames 652"，**正好反了**。
     * count_bytes 只当旁证——它会把数据里本来就有的 0xA5 算成底色（有过 682 vs 684 的实例）。 */
    size_t a5  = count_bytes(dst, length, 0xA5);
    size_t end = find_data_end(dst, length, 0xA5);
    size_t tail_fill = length - end;
    size_t a5_in_data = (a5 >= tail_fill) ? (a5 - tail_fill) : 0;

    printf("    S2MM 完成：实收 %zu / %u 字节（尾部底色 %zu，其中 %zu 个 0xA5 "
           "落在数据中间；寄存器读回 %u = 已收）\n",
           end, length, tail_fill, a5_in_data, remain);
    return (long)end;
}

/* ⚠️ 下面这两个只在**直读模式**（= 现在的默认）下用。走 `--sg` 时不用它们：
 * 环一挂好硬件就自己往下走，不需要每帧重挂，也就没有这个"热路径"的问题。
 *
 * do_s2mm 的「热路径」版：重挂 S2MM 时只做最少的事——清 IOC、写 DA、写 LENGTH、等 IOC。
 *
 * 为什么不直接用 do_s2mm：它每帧都要 memset 底色 + 走 sysfs 同步（三次文件写）+
 * 挤 8 MiB 缓存 + 软复位 S2MM，加起来是**几百 µs 到几 ms**的窗口，而 HLS 每 ~101 µs
 * 就产一帧。窗口里 HLS 被 TREADY 顶住；等我们再挂上去，按理该从暂停处接着走——
 * 但软复位期间 S2MM 的 TREADY 会抖，抖几下就吃掉几拍，实测每帧正好少 8 拍
 * （652 = 684 - 32）。所以这里**不软复位、不 sync、不挤缓存**，那些统一挪到循环外做一次。
 *
 * 返回实收字节数（寄存器里的 S2MM_LENGTH，已证实 = 已收量）；-1 = 出错/超时。 */
static int s2mm_arm(uint32_t dst_off, uint32_t length)
{
    volatile uint32_t *b = reg1;
    uint64_t dst_pa = buf_pa + DST_OFF + opt_dst_shift + dst_off;

    if (dst_off + opt_dst_shift + length > DST_MAX) {
        fprintf(stderr, "S2MM 目标偏移 %#x + 长度 %u 超出目标区\n", dst_off, length);
        return -1;
    }

    /* 先把上一轮的 IOC/错误位 W1C 掉，否则一进等待循环就会被当成"已完成" */
    wr(b, S2MM_SR, rd(b, S2MM_SR));
    wr(b, S2MM_CR, 0);                      /* RS=0 */
    wr(b, S2MM_DA, (uint32_t)dst_pa);
    wr(b, S2MM_CR, CR_RUNSTOP | CR_THRESHOLD(1));
    __sync_synchronize();
    wr(b, S2MM_LENGTH, length);             /* 写这个就开跑 */
    return 0;
}

/* 挂着等这一帧收完；返回实收字节数，-1 = 出错/超时。 */
static long s2mm_wait(uint32_t dst_off)
{
    volatile uint32_t *b = reg1;
    uint32_t sr;
    uint64_t t0 = now_ms();

    for (;;) {
        sr = rd(b, S2MM_SR);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            printf("    S2MM 出错: DMASR=%#010x\n", sr);
            wr(b, S2MM_SR, sr);
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }
        if (sr & SR_IOC)
            return (long)rd(b, S2MM_LENGTH);
        if (now_ms() - t0 > (uint64_t)opt_timeout_ms) {
            printf("    S2MM 超时 %d ms（DMASR=%#010x，目标 +%#x）\n",
                   opt_timeout_ms, sr, dst_off);
            wr(b, S2MM_SR, sr);
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return -1;
        }
    }
}


/* ─────────────────────────── MM2S（axi_dma_0，SG 模式） ─────────────────────────── */

/* 只把 MM2S 起起来，不等它跑完。frames 模式要和 S2MM 并发，所以拆出这一步。 */
static int mm2s_start(uint32_t length)
{
    volatile uint32_t *b = reg0;
    uint64_t bd_pa   = buf_pa + BD_OFF;
    uint64_t src_pa  = buf_pa + SRC_OFF;
    uint32_t *bd     = (uint32_t *)(buf_va + BD_OFF);

    if (length == 0 || length > SRC_MAX) {
        fprintf(stderr, "MM2S 长度 %u 超出范围 (1..%lu)\n", length, (unsigned long)SRC_MAX);
        return -1;
    }
    if (length & 0x7) {
        fprintf(stderr, "MM2S 长度必须是 8 的倍数（m_axis 是 64bit，没开 DRE）\n");
        return -1;
    }
    /* 单描述符上限是硬件参数 C_SG_LENGTH_WIDTH：axi_dma_0 是 14 -> 最多 16383 字节。
     * 现在跑的 8192 在里面，但以前只查了 SRC_MAX(65536)，更大的值会被悄悄截断成
     * 一个错长度。拦在这里比在板子上猜好。 */
    if (length > 16383u) {
        fprintf(stderr, "MM2S 长度 %u 超过单个描述符的上限 16383 字节"
                        "（axi_dma_0 的 C_SG_LENGTH_WIDTH=14）\n", length);
        return -1;
    }

    /* 单描述符，NXTDESC 指向自己（跟驱动的环形链表一致）；
     * 因为是自环，传完必须马上复位通道，否则硬件会把同一个描述符再跑一遍。 */
    bd_write(bd, bd_pa, src_pa, BD_CTRL_SOF | BD_CTRL_EOF | BD_CTRL_LEN(length));
    __sync_synchronize();
    udmabuf_sync(SYNC_FOR_DEVICE);

    if (chan_reset(b, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)") < 0)
        return -1;

    wr(b, MM2S_CR, 0);
    wr(b, MM2S_CURDESC, (uint32_t)bd_pa);
    wr(b, MM2S_CR, CR_RUNSTOP | CR_THRESHOLD(1));
    __sync_synchronize();
    if (opt_wait_halted) {          /* 同 S2MM：尾指针要 Halted=0 才算开跑 */
        long us = wait_halted_clear(b, MM2S_SR, 200000);
        if (us < 0) {
            fprintf(stderr, "  axi_dma_0(MM2S) RS=1 之后 200 ms 内 Halted 一直没清\n");
            return -1;
        }
        printf("    (--wait-halted) MM2S：RS=1 之后 %ld µs Halted 才清\n", us);
    }
    wr(b, MM2S_TAILDESC, (uint32_t)bd_pa);  /* 写尾描述符 = 开跑 */
    return 0;
}

static int do_mm2s(uint32_t length)
{
    volatile uint32_t *b = reg0;
    uint64_t bd_pa   = buf_pa + BD_OFF;
    uint64_t src_pa  = buf_pa + SRC_OFF;
    uint32_t *bd     = (uint32_t *)(buf_va + BD_OFF);

    if (mm2s_start(length) < 0)
        return -1;

    uint64_t t0 = now_ms();
    uint32_t sr;
    for (;;) {
        sr = rd(b, MM2S_SR);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            printf("    MM2S 出错: DMASR=%#010x\n", sr);
            print_dmasr_err(sr);
            dump_bd_raw(bd, "出错时");
            printf("        期望：+00=%08x +08=%08x +18=%08x\n",
                   (unsigned)(bd_pa & 0xFFFFFFC0u), (unsigned)src_pa,
                   (unsigned)(BD_CTRL_SOF | BD_CTRL_EOF | BD_CTRL_LEN(length)));
            printf("      如果只有 SG 解码错误，试试 --alt-desc\n");
            wr(b, MM2S_SR, sr);
            chan_reset(b, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
            return -1;
        }
        if ((sr & SR_IOC) || (bd_read_sts(bd) & BD_STS_COMPLETE))
            break;
        if (now_ms() - t0 > (uint64_t)opt_timeout_ms) {
            printf("    MM2S 超时 %d ms（DMASR=%#010x，描述符 STATUS=%#010x）\n",
                   opt_timeout_ms, sr, bd_read_sts(bd));
            printf("    提示：s_tready 一直不拉高（HLS 的输入 FIFO 满了/没启动）就会卡在这里。\n");
            wr(b, MM2S_SR, sr);
            chan_reset(b, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
            return -1;
        }
        msleep(1);
    }

    uint32_t sts_now  = bd_read_sts(bd);
    msleep(10);                         /* 状态回写有可能比 IOC 晚一拍 */
    uint32_t sts_late = bd_read_sts(bd);
    uint32_t bd_snap[8];
    for (int w = 0; w < 8; w++)
        bd_snap[w] = bd[w];

    /* 自环，必须立刻停 */
    chan_reset(b, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");

    printf("    MM2S 完成：%u 字节（%u beat × 8B）\n", length, length / 8);
    printf("      描述符 STATUS=%#010x（10ms 后 %#010x）%s\n", sts_now, sts_late,
           (sts_now & BD_STS_COMPLETE) ? "  <- bit31 置上了"
                                       : "  <- bit31 没置：硬件没回写描述符");
    dump_bd_raw(bd_snap, "完成时");
    printf("        期望：+00=%08x +08=%08x +18=%08x\n",
           (unsigned)(bd_pa & 0xFFFFFFC0u), (unsigned)src_pa,
           (unsigned)(BD_CTRL_SOF | BD_CTRL_EOF | BD_CTRL_LEN(length)));
    return 0;
}

/* ─────────────────────────── 测试图案 ───────────────────────────
 * stream_buf.v 的解包顺序是 [15:0]=I0 [31:16]=Q0 [47:32]=I1 [63:48]=Q1，
 * 一个 beat 里塞两个字（偶数号、奇数号）。
 * 一个字 = 2 字节（I 在低、Q 在高）。**一次调用 8192 B 分给 8 帧 ⇒ 一帧 1024 B = 512 字**
 * （别和**输出**一帧 684 B 混了，那是 HLS 出来的，不是喂进去的；这里早先写成"每帧 256 字"）。
 * 这里造"周期 256 字、前半正后半负"的方波（相当于 bin=4）：512 / 256 = 2，
 * 每帧正好两个整周期 ⇒ **8 帧字节级完全相同**，抓回来的 8 个 684 字节块应当一模一样。
 * ⚠️ 周期一旦不是帧长的整数因子，"8 帧相同"就不成立，下面的相邻帧判读会全变噪声。
 */
static void fill_pattern(uint8_t *src, uint32_t bytes)
{
    uint32_t words = bytes / 2;                 /* 每字 2 字节（I 低 Q 高） */
    for (uint32_t n = 0; n < words; n++) {
        int16_t i = ((n % 256) < 128) ? (int16_t)12000 : (int16_t)-12000;
        int16_t q = 0;
        src[n * 2 + 0] = (uint8_t)(i & 0xff);
        src[n * 2 + 1] = (uint8_t)((i >> 8) & 0xff);
        (void)q;                                /* Q 一路给 0，方便看频谱 */
    }
}

static void prepare_src(uint32_t bytes)
{
    uint8_t *src = buf_va + SRC_OFF;
    if (opt_infile) {
        int fd = open(opt_infile, O_RDONLY);
        if (fd < 0)
            die(opt_infile);
        ssize_t r = read(fd, src, bytes);
        close(fd);
        if (r < 0)
            die("read 输入文件");
        if ((uint32_t)r < bytes) {
            fprintf(stderr, "警告: %s 只有 %ld 字节，不足 %u，剩余部分补 0\n",
                    opt_infile, (long)r, bytes);
            memset(src + r, 0, bytes - r);
        }
        printf("    源数据来自 %s（%u 字节）\n", opt_infile, bytes);
    } else {
        fill_pattern(src, bytes);
        printf("    源数据为内置方波图案（一帧 %u B = %u 字，周期 256 字"
               " ⇒ 每帧 %u 个整周期，8 帧相同）\n",
               CALL_IN_BYTES / N_FRAMES_OUT, CALL_IN_BYTES / N_FRAMES_OUT / 2u,
               (CALL_IN_BYTES / N_FRAMES_OUT / 2u) / 256u);
    }
    udmabuf_sync(SYNC_FOR_DEVICE);
}

/* ─────────────────────────── hexdump ─────────────────────────── */
static void hexdump(const char *title, const uint8_t *p, size_t n)
{
    printf("  %s（前 %zu 字节）:\n", title, n);
    for (size_t off = 0; off < n; off += 16) {
        printf("    %06zx  ", off);
        for (size_t i = 0; i < 16; i++) {
            if (i < n - off) printf("%02x ", p[off + i]);
            else             fputs("   ", stdout);
        }
        printf("\n");
    }
}

/* 逐字节比 a/b，返回不同字节数；顺手给出**第一个**和**最后一个**不同字节的偏移
 * （没有不同时两个都留 (size_t)-1）。比"只报第一个"有用得多：
 * "零散几个字节"还是"从某处起一路不同"，一眼就能分开。 */
static size_t diff_run(const uint8_t *a, const uint8_t *b, size_t n,
                       size_t *first, size_t *last)
{
    size_t cnt = 0;
    *first = *last = (size_t)-1;
    for (size_t i = 0; i < n; i++) {
        if (a[i] != b[i]) {
            if (*first == (size_t)-1) *first = i;
            *last = i;
            cnt++;
        }
    }
    return cnt;
}

/* 把 b 相对 a 整体平移 off 字节后比（只比两边都落在 [0,n) 的部分），返回不同字节数。
 * 真错位的话某个 off 会让它塌到接近 0 —— 这是「整帧错位」和「个别字节坏」的分水岭。 */
static size_t diff_shifted(const uint8_t *a, const uint8_t *b, size_t n, long off)
{
    size_t cnt = 0;
    for (size_t i = 0; i < n; i++) {
        long j = (long)i + off;
        if (j < 0 || j >= (long)n) continue;
        if (a[i] != b[j]) cnt++;
    }
    return cnt;
}

/* 按 684 字节一帧切块比对——输入图案 8 帧相同，所以 8 帧输出应当完全一致。
 * 每帧内部再分两段：前 384 B = 96 拍 tok（每拍 4 个 INT8），后 300 B = 75 拍 logits（每拍 2 个 INT16）。
 *
 * 判读口径（2026-10-15 改）：不只报"第一个不同的字节"，每对给出
 * **差异字节数 + 首个/末个差异位置 + 平移检验**，并且**短帧一律不参与比对**
 * ——短帧那个块里混着 0xA5 底色，跟谁比都是噪声（板上就这样白报过一条"帧1 vs 帧2 有差异"）。
 * 平移检验是「整帧错位」和「个别字节坏」的分水岭：真错位时某个 ±4k 字节的平移会
 * 让差异塌到接近 0；个别字节坏则平移也救不回来。 */
static void check_frames_out(const uint8_t *dst, long got)
{
    printf("    一帧 = %u B：tok 段 %u B（拍 0..%u）+ logits 段 %u B（拍 %u..%u），"
           "TLAST 落在本帧最后一拍\n",
           FRAME_OUT_BYTES, TOK_FRAME_BYTES, TOK_BEATS - 1,
           LOG_FRAME_BYTES, TOK_BEATS, FRAME_BEATS - 1);

    if (got < (long)FRAME_OUT_BYTES * 2)
        return;
    int nblk = (int)(got / FRAME_OUT_BYTES);
    if (nblk > (int)N_FRAMES_OUT) nblk = (int)N_FRAMES_OUT;

    /* 先各块量一遍是不是整帧——**短帧的块里混着 0xA5 底色**，跟谁比都是噪声 */
    size_t eblk[N_FRAMES_OUT];
    for (int k = 0; k < nblk; k++)
        eblk[k] = find_data_end(dst + (size_t)k * FRAME_OUT_BYTES, FRAME_OUT_BYTES, 0xA5);

    /* 本轮扫出来的空洞，攒起来在最后出一条汇总——板上那个
     * "一轮里某一帧有连续 64 B 0xA5 空洞、偏移每次都换"的毛病，只有攒着看
     * 才看得出它是不是同一处、还是每轮换地方。 */
    size_t hole_pos[16], hole_len[16];
    int    hole_frm[16], hole_cnt = 0;

    /* ⚠️ 拿**相邻**两块比，别拿块 0 当基准：只要有一帧是短帧，块 0 就是
     * "半帧 + 下一帧的开头"拼出来的，跟谁都对不上，报出来全是噪声
     * （上一版就是这么干的，7 行"第 N 字节起不同"没一条有用）。 */
    printf("    相邻帧对比（tok / logits 分开比；**只比整帧**）：\n");
    int all_same = 1, n_cmp = 0;
    int n_hole_only = 0, n_payload = 0;  /* 不同**只**来自空洞的帧对 / 有载荷不同的帧对 */
    for (int k = 1; k < nblk; k++) {
        const uint8_t *a = dst + (size_t)(k - 1) * FRAME_OUT_BYTES;
        const uint8_t *c = dst + (size_t)k * FRAME_OUT_BYTES;
        int sh_a = (eblk[k - 1] != (size_t)FRAME_OUT_BYTES);
        int sh_c = (eblk[k]     != (size_t)FRAME_OUT_BYTES);

        if (sh_a || sh_c) {
            printf("      帧 %d vs 帧 %d：跳过 ——", k, k + 1);
            if (sh_a) printf(" 帧 %d 是短帧(%zu B)", k, eblk[k - 1]);
            if (sh_c) printf(" 帧 %d 是短帧(%zu B)", k + 1, eblk[k]);
            printf("，块里混着底色，比了是噪声\n");
            continue;
        }

        n_cmp++;
        size_t f_tok, l_tok, f_log, l_log;
        size_t n_tok = diff_run(a, c, TOK_FRAME_BYTES, &f_tok, &l_tok);
        size_t n_log = diff_run(a + TOK_FRAME_BYTES, c + TOK_FRAME_BYTES,
                                LOG_FRAME_BYTES, &f_log, &l_log);
        size_t n_all = n_tok + n_log;

        if (n_all == 0) {
            printf("      帧 %d vs 帧 %d：tok 一致，logits 一致\n", k, k + 1);
            continue;
        }

        all_same = 0;
        printf("      帧 %d vs 帧 %d：**不同 %zu / %u 字节**（tok %zu，logits %zu）\n",
               k, k + 1, n_all, FRAME_OUT_BYTES, n_tok, n_log);
        if (n_tok)
            printf("          tok    : 首 %zu 末 %zu（段长 %u）  %02x vs %02x\n",
                   f_tok, l_tok, TOK_FRAME_BYTES, a[f_tok], c[f_tok]);
        if (n_log)
            printf("          logits : 首 %zu 末 %zu（段长 %u）  %02x vs %02x\n",
                   f_log, l_log, LOG_FRAME_BYTES,
                   a[TOK_FRAME_BYTES + f_log], c[TOK_FRAME_BYTES + f_log]);

        /* 一侧是 0xA5（底色）⇒ 那一处**没被 DMA 写进去**（空洞），不是"算错"。
         * 注意 0xA5 也可能是真数据，所以只承认**连续成段**的那些。
         * ⚠️ 板上真踩到过：帧 2 = 载荷本来就降级 + 偏移 20..83 有 64 B 的 0xA5 空洞。
         * 那时这里只说了一句"更像那一拍没写进去"，下面又报"差异铺满整帧，不是错位"——
         * 两句话看着互相打架，正是我自己判读翻车的那一次。所以现在把**空洞段落**
         * 单独量出来、单独报，跟"载荷数不一样"彻底分开。 */
        size_t hole_best = 0, hole_at = 0, hole_run = 0, hole_run_at = 0;
        for (size_t j = 0; j < FRAME_OUT_BYTES; j++) {
            if (a[j] != c[j] && (a[j] == 0xA5 || c[j] == 0xA5)) {
                if (hole_run == 0) hole_run_at = j;
                hole_run++;
                if (hole_run > hole_best) { hole_best = hole_run; hole_at = hole_run_at; }
            } else {
                hole_run = 0;
            }
        }
        size_t hole_only = hole_best;          /* 空洞自己占掉的不同字节数 */
        size_t residual  = n_all - hole_only;  /* 空洞**之外**还剩多少不同 */
        if (residual == 0 && hole_best >= 8u) n_hole_only++; else n_payload++;

        if (hole_best >= 8u) {
            int in_c = (c[hole_at] == 0xA5);
            int frm_h = in_c ? k + 1 : k;
            size_t abs_at = (size_t)(frm_h - 1) * FRAME_OUT_BYTES + hole_at;
            printf("          · **帧 %d** 帧内偏移 %zu..%zu（**本轮绝对偏移 %zu..%zu**，%s 64 字节边界）"
                   " 有**连续 %zu 字节的 0xA5 空洞**（%zu 拍，跨过 tok/logits 边界：%s）\n"
                   "            ★ 把**绝对偏移**（从本轮缓冲头算）跟帧内偏移一起记下来 —— 这才是真信号：\n"
                   "              实测 5 处洞的绝对偏移 192 / 2560 / 4032 / 4160 / 4288，**全是 64 的整数倍**。\n"
                   "              而帧起点自己**不是** 64 对齐的（684 mod 64 = 44），所以「洞跟着帧漂」\n"
                   "              的话就不该贴死在 64 边界上 ⇒ 丢的单位是**内存地址里的 64 字节块**\n"
                   "              （一条写突发 / 一行），**不是**流里的「第几拍」。\n"
                   "            ⚠ 关键：这一帧**长度仍然是 %u**、空洞两侧的字节也**还在自己的位置上**，\n"
                   "              说明那 %zu 拍是**被 DMA 消费掉了、只是没落到 DDR**\n"
                   "              （要是 IP 压根没发，整帧会短一截、后面全体前移）。\n"
                   "            ★ 洞的**物理地址**：%#llx .. %#llx —— 要给 ILA 设触发就用这个地址。\n"
                   "            ⇒ 这是「没写进 DDR」，跟「算出来的数不一样」是两回事；该查的是\n"
                   "              **S2MM 的写通路**（DMA 写引擎 / 互连 / HP 口 / DDR 控制器），不是 HLS 的输出。\n",
                   frm_h, hole_at, hole_at + hole_best - 1,
                   abs_at, abs_at + hole_best - 1,
                   (abs_at % 64u) ? "**不是**" : "是",
                   hole_best, hole_best / 4u,
                   (hole_at < TOK_FRAME_BYTES &&
                    hole_at + hole_best > TOK_FRAME_BYTES) ? "是" : "否",
                   FRAME_OUT_BYTES, hole_best / 4u,
                   (unsigned long long)(buf_pa + (uint64_t)(dst - buf_va) + abs_at),
                   (unsigned long long)(buf_pa + (uint64_t)(dst - buf_va) + abs_at
                                        + hole_best - 1));
            /* ⚠ 同一帧要跟**左右两个邻居**各比一次 ⇒ 同一个洞会被记两遍。
             * 板上第一次跑就撞上了：明明只有 1 个洞，汇总却报「2 处」（两行一模一样）。
             * 按 (帧, 偏移, 长度) 去重。 */
            int dup = 0;
            for (int i = 0; i < hole_cnt; i++)
                if (hole_frm[i] == frm_h && hole_pos[i] == hole_at
                    && hole_len[i] == hole_best) { dup = 1; break; }
            if (!dup && hole_cnt < (int)(sizeof(hole_pos) / sizeof(hole_pos[0]))) {
                hole_pos[hole_cnt] = hole_at;
                hole_len[hole_cnt] = hole_best;
                hole_frm[hole_cnt] = frm_h;
                hole_cnt++;
            }
        }

        /* 平移检验：1 拍 = 4 字节。真错位 → 某个 ±4k 字节的平移会让差异塌掉。 */
        long best_off = 0;
        size_t best = n_all;
        for (long off = -32; off <= 32; off += 4) {
            if (off == 0) continue;
            size_t d = diff_shifted(a, c, FRAME_OUT_BYTES, off);
            if (d < best) { best = d; best_off = off; }
        }
        if (best_off != 0 && best * 100u <= n_all) {
            printf("          ⇒ **整帧错位**：把帧 %d 相对帧 %d 平移 %+ld 字节（%+ld 拍）后"
                   "只剩 %zu 个不同\n", k + 1, k, best_off, best_off / 4, best);
        } else {
            /* "堆在段尾"必须**同时**满足两条：差异**很少**，且**首差异**就在最后几拍里。
             * 这里原来只看了"末差异靠不靠段尾"，结果 tok 268/384 个字节全是差异、首差异
             * 在偏移 1，也照样被判成"差异堆在段尾，多半是读早了" —— 板上真踩到了，
             * 而那个结论会把人往完全错误的方向引。 */
            int tail_tok = n_tok && n_tok <= 32u && f_tok + 16u >= TOK_FRAME_BYTES;
            int tail_log = n_log && n_log <= 32u && f_log + 16u >= LOG_FRAME_BYTES;

            if (tail_tok || tail_log)
                printf("          ⇒ 差异**集中在段尾、而且很少**：像 IOC 之后读早了、"
                       "最后几拍还没落 DDR（多等一会儿再读若变 0，就是读的问题）\n");
            else if (hole_best >= 8u && residual == 0)
                /* ⚠️ 第三种翻车就在这儿：差异**全部**是那段空洞（n_all == hole_best）时，
                 * 老代码照样打印「(2) 其余的是真载荷不同」，可"其余"是 0 ——
                 * 一句话把"有空洞"说成了"空洞 + 载荷也坏了"两件事。
                 * 例子：`帧 3 vs 帧 4：不同 64（tok 0，logits 64）` 而空洞正好也是 64。 */
                printf("          ⇒ 平移救不回来（最好的 ±32 B 平移后仍剩 %zu 个不同）——"
                       "但这一对帧的 **%zu 个不同全在那段空洞里**：\n"
                       "             除开「偏移 %zu 起 %zu 字节没写进 DDR」，两帧**逐字节相同**。\n"
                       "             ⇒ 只有**一件事**：缺写。**没有**第二个「载荷不同」的毛病，"
                       "别当成两件事去查（载荷本身这 8 帧是一致的）\n",
                       best, n_all, hole_at, hole_best);
            else if (hole_best >= 8u)
                /* 空洞 + 载荷差异**真的**叠在一起。**两件事都要说清**，不然就是上面那次翻车。 */
                printf("          ⇒ 平移救不回来（最好的 ±32 B 平移后仍剩 %zu 个不同）。"
                       "这一对帧身上叠了**两种**毛病：\n"
                       "             (1) 偏移 %zu 起 %zu 字节 0xA5 空洞 ＝ 那一段**根本没写进去**"
                       "（占掉 %zu 个不同）；\n"
                       "             (2) 其余 %zu 个不同是真载荷不同 —— tok %zu/%u、logits %zu/%u"
                       "（8 帧输入相同却不同 ⇒ 这一段才要问「为什么」）\n",
                       best, hole_at, hole_best, hole_only, residual,
                       n_tok, TOK_FRAME_BYTES, n_log, LOG_FRAME_BYTES);
            else
                printf("          ⇒ 平移救不回来（最好的 ±32 B 平移后仍剩 %zu 个不同），"
                       "差异铺在整帧上（tok %zu/%u、logits %zu/%u）且**没有 0xA5 空洞**：\n"
                       "             **这不是错位，是整帧的数就不一样**。先怀疑抓错了帧\n"
                       "             （重跑看是不是同一帧对不上），再怀疑 IP 有跨帧状态\n",
                       best, n_tok, TOK_FRAME_BYTES, n_log, LOG_FRAME_BYTES);
        }
    }

    /* 空洞汇总：把本轮所有空洞列在一起才看得出"是不是同一处、每轮换不换地方"。
     * 板上实测：4 轮里 3 轮各有**一**帧带 64 B 空洞，偏移分别是 508 / 612 / 184
     * （tok、logits 段都有）—— 每轮换地方，所以单看一轮只会觉得"随机"。 */
    if (hole_cnt > 0) {
        int all64 = 1;
        printf("    ---- 本轮 0xA5 空洞汇总（%d 处）----\n", hole_cnt);
        for (int i = 0; i < hole_cnt; i++) {
            size_t abs_at = (size_t)(hole_frm[i] - 1) * FRAME_OUT_BYTES + hole_pos[i];
            if (abs_at % 64u) all64 = 0;
            printf("      第 %d 行：帧 %d，帧内偏移 %zu..%zu，**绝对偏移 %zu..%zu**"
                   "（%zu B = %zu 拍）%s\n",
                   i + 1, hole_frm[i], hole_pos[i], hole_pos[i] + hole_len[i] - 1,
                   abs_at, abs_at + hole_len[i] - 1,
                   hole_len[i], hole_len[i] / 4u,
                   (hole_len[i] % 4u) ? "  ⚠ 不是整拍" : "");
        }
        printf("      拿这一行跟**上一轮**比：\n"
               "        · 又落在同一个「帧号 + 帧内偏移」⇒ 那一处值得先查；\n"
               "        · 换地方 ⇒ 位置是飘的，但**别就此收摊**，再看绝对偏移的低位：\n"
               "          实测 5 处的绝对偏移是 192 / 2560 / 4032 / 4160 / 4288，**全都对齐 64 字节**，\n"
               "          洞长也都正好 64 B。而帧起点自己**不是** 64 对齐的（684 mod 64 = 44），\n"
               "          ⇒ 丢的是**内存地址里的 64 字节块**（一条写突发 / 一行），不是「流里第几拍」。\n"
               "          这一条比「位置固不固定」更值得拿去对 RTL / 互连看。\n");
        printf("      本轮 %s：洞的绝对偏移%s对齐 64 字节。\n",
               all64 ? "**也是**" : "**不是**", all64 ? "**全都**" : "**不是全都**");
        printf("      （同一帧要跟左右邻居各比一次，重复的洞这里已经去重。）\n");
    }

    if (n_cmp == 0)
        printf("    => 没有两个整帧可比（都是短帧？），不下结论。\n");
    else if (all_same)
        printf("    => 参与比对的整帧逐字节一致。8 帧输入相同，纯前馈的话输出就该相同 —— 符合预期。\n"
               "       （注意：这只是**这一轮**干净。板上见过「同一条命令，有时全一致、有时某一帧对不上」。）\n");
    else if (n_payload == 0)
        printf("    => 有帧对不上，但 %d 对帧的不同**全部**是 0xA5 空洞 —— **载荷本身一致**。\n"
               "       ⇒ 结论只有一条：**偶发缺写**（DMA 消费了那几拍、没落 DDR）。\n"
               "       别去查 IP 有没有跨帧状态：跨帧状态会改**数**，不会留一段没写的 0xA5。\n", n_hole_only);
    else
        printf("    => **有整帧对不上**，其中 %d 对帧**除了空洞还有载荷本身不同**。\n"
               "       8 帧输入相同却输出不同：要么 IP 有跨帧状态（那要能解释），\n"
               "       要么抓取有问题 —— 看上面是「整帧错位」还是「个别字节」。\n"
               "       （另有 %d 对帧只是缺写，那部分不算载荷问题。）\n", n_payload, n_hole_only);
}

/* ─────────────────────────── e2e ───────────────────────────
 * e2e 要"先把 S2MM 挂起 -> 再跑 MM2S -> 最后单独收尾"，所以把开跑那几步拆出来。
 * SG 模式下就是一个单描述符的环；直读模式还是老的四步（DA -> CR -> LENGTH）。 */
static int s2mm_start_single(uint32_t dst_off, uint32_t length)
{
    volatile uint32_t *b = reg1;
    uint64_t dst_pa = buf_pa + DST_OFF + opt_dst_shift + dst_off;   /* 见 opt_dst_shift 注释 */

    if (!opt_simple)
        return s2mm_sg_arm(dst_off, length, 1);

    if (chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)") < 0)
        return -1;
    wr(b, S2MM_CR, 0);
    wr(b, S2MM_DA, (uint32_t)dst_pa);
    wr(b, S2MM_CR, CR_RUNSTOP | CR_THRESHOLD(1));
    __sync_synchronize();
    wr(b, S2MM_LENGTH, length);             /* 写这个就开跑 */
    return 0;
}

static int cmd_e2e(void)
{
    printf("[e2e] 一次完整调用：S2MM 先挂上，再用 MM2S 灌 8 帧\n");
    printf("  进 %u 字节 -> %s ... 出 %u 字节\n", CALL_IN_BYTES, "HLS", CALL_OUT_BYTES);

    /* S2MM 必须先起来。故意把长度给成"一次调用全部 8 帧"（直读模式写在 LENGTH
     * 寄存器里，SG 写在描述符里），这样能看出 DMA 到底是收到第一个 TLAST
     * （= 一帧 684 B）就收工，还是老实收满 8 帧。两种都是可用结果，不预设。 */
    printf("  1) 先启动 S2MM（%u 字节 = 8 帧，故意给大于一帧）——后台等数据\n", CALL_OUT_BYTES);
    printf("  2) 再启动 MM2S（%u 字节）\n", CALL_IN_BYTES);

    /* do_s2mm 是阻塞的，这里手工把 S2MM 起好，再调 MM2S，最后收尾 */
    volatile uint32_t *b = reg1;
    uint64_t dst_pa = buf_pa + DST_OFF + opt_dst_shift;
    uint8_t *dst = buf_va + DST_OFF + opt_dst_shift;   /* 见 opt_dst_shift 注释 */

    /* ── 0) 先冲干净 ──────────────────────────────────────────────
     * 上一轮如果没收完就被 Ctrl-C、或者 MM2S 还在自环，HLS 里会攒着没排完的帧。
     * 不清掉的话，下面第 3 步"第一次收帧"量到的只是**半帧的尾巴**，
     * 就会把 652 之类的小数当成"帧长不对"，白查半天。 */
    printf("  0) 先把上一轮的残留输出冲干净\n");
    chan_reset(reg0, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
    {
        int saved = opt_timeout_ms;
        opt_timeout_ms = 400;
        for (int i = 0; i < 4; i++) {
            long n = do_s2mm(0, FRAME_OUT_BYTES, 1);
            if (n <= 0) {
                printf("     [冲] 排空了\n");
                break;
            }
            printf("     [冲] %ld 字节%s\n", n,
                   n < (long)FRAME_OUT_BYTES ? "（不足一帧，说明到头了）" : "");
            if (n < (long)FRAME_OUT_BYTES)
                break;
        }
        opt_timeout_ms = saved;
    }

    memset(dst, 0xA5, CALL_OUT_BYTES);
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();          /* 先把 0xA5 从 cache 挤到 DDR，免得一会儿"盖住" DMA 写的数据 */
    if (s2mm_start_single(0, CALL_OUT_BYTES) < 0)
        return 1;
    if (opt_simple)
        printf("  S2MM 已挂起，DA=%#010x（期望 %#010x）DMASR=%#010x\n",
               rd(b, S2MM_DA), (unsigned)(uint32_t)dst_pa, rd(b, S2MM_SR));
    else
        printf("  S2MM(SG) 已挂起：1 个描述符（缓冲 %#010x，长度 %u）"
               "CURDESC=%#010x TAILDESC=%#010x DMASR=%#010x\n",
               (unsigned)(uint32_t)dst_pa, CALL_OUT_BYTES,
               rd(b, S2MM_CURDESC), rd(b, S2MM_TAILDESC), rd(b, S2MM_SR));

    prepare_src(CALL_IN_BYTES);
    if (do_mm2s(CALL_IN_BYTES) < 0) {
        /* 板上偶发过一次 DMASR=0x14019（Halted+DMAIntErr+SlvErr+IOC+ErrIrq），
         * 紧接着重跑就正常了 —— 复位重试一次，别为这种一次性的东西白折腾。 */
        printf("  MM2S 第一次失败，复位后重试一次\n");
        chan_reset(reg0, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
        if (do_mm2s(CALL_IN_BYTES) < 0) {
            chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
            return 1;
        }
    }

    /* 等 S2MM 收满 */
    uint64_t t0 = now_ms();
    uint32_t sr;
    int failed = 0, tick = 0;
    for (;;) {
        sr = rd(b, S2MM_SR);
        if (sr & (SR_ERR | SR_ERR_SG)) {
            failed = 1;
            break;
        }
        if (sr & SR_IOC)
            break;
        if (now_ms() - t0 > (uint64_t)opt_timeout_ms) {
            failed = 2;
            break;
        }
        msleep(1);
        if (++tick % 100 == 0) {
            if (opt_simple)
                /* 递减=剩余量，递增=已收量，不动=没在收 */
                printf("      …S2MM 还在等：DMASR=%#010x S2MM_LENGTH=%u（写入 %u）\n",
                       sr, rd(b, S2MM_LENGTH), CALL_OUT_BYTES);
            else
                printf("      …S2MM(SG) 还在等：DMASR=%#010x 描述符 STATUS=%#010x"
                       "（COMPLETE 还没置上）\n", sr, sg_bd_sts(0));
        }
    }

    /* 先把现场读干净，再复位通道——复位会把 LENGTH 这些寄存器弄乱 */
    uint32_t remain = rd(b, S2MM_LENGTH);

    /* IOC 之后再隔一会儿读一次：如果还在变，说明我们读早了/传输没真结束 */
    msleep(50);
    uint32_t remain2 = rd(b, S2MM_LENGTH);

    /* ⭐ 关键实验：**同一块内存，挤缓存前后各数一次**。
     * 两次数出来一样  -> 映射本来就是不可缓存的，缓存不是问题；
     * 两次数出来不一样 -> 映射可缓存，之前读到的全 0xA5 是 CPU 自己的脏数据。
     * 这一段能一次性把"到底是缓存还是 DMA 没写"这个问题钉死。 */
    size_t a5_before = count_bytes(dst, CALL_OUT_BYTES, 0xA5);
    cache_evict();
    size_t a5_after  = count_bytes(dst, CALL_OUT_BYTES, 0xA5);

    /* 数内存一律以 find_data_end 为准。`CALL_OUT_BYTES - a5_after` 那个算法是错的：
     * count_bytes 把数据里本来就有的 0xA5 也算成了底色，这一版就少数了 2 个
     * （682 vs 684），于是判读那段误报「既不是一帧也不是八帧」。 */
    size_t end  = find_data_end(dst, CALL_OUT_BYTES, 0xA5);
    uint32_t bd_sts0 = 0, bd_len0 = 0;
    long real;

    if (opt_simple) {
        real = (long)end;
    } else {
        /* SG 下"收了多少"有硬件回写的权威值，判 TLAST 直接用它 ——
         * 描述符里的 actual length 就是硬件对"这一帧在哪儿结束"的回答，
         * 比从内存里数底色推出来的更硬。 */
        bd_sts0 = sg_bd_sts(0);
        bd_len0 = bd_sts0 & BD_STS_LEN_MASK;
        real    = (long)bd_len0;
        if ((size_t)bd_len0 != end)
            printf("  ⚠️ 描述符回写 %u 字节，内存里数出来 %zu 字节 —— 两者不一致，"
                   "先查这个再往下看\n", bd_len0, end);
    }

    printf("\n  S2MM DMASR=%#010x  [%s%s%s]\n", sr,
           (sr & SR_IOC) ? "IOC " : "",
           (sr & (SR_ERR | SR_ERR_SG)) ? "ERR " : "",
           (sr & SR_IRQ_ERR) ? "ErrIrq " : "");
    printf("  挤缓存前底色 %zu 字节 / 挤缓存后 %zu 字节  ->  %s\n",
           a5_before, a5_after,
           a5_before == a5_after
               ? "两次一致：映射不可缓存，缓存不是问题"
               : "**两次不一致：映射确实可缓存，之前读到的 0xA5 是 CPU 自己的脏数据**");
    printf("  落地 %ld / %u 字节，数据到偏移 %zu 为止（一帧 = %u 字节）\n",
           real, CALL_OUT_BYTES, end, FRAME_OUT_BYTES);
    printf("  形状：");
    report_capture_shape(dst, end);
    if (opt_simple) {
        printf("  寄存器 S2MM_LENGTH 读回 %u（50ms 后再读 %u%s）"
               "—— 与上面的落尾一致，说明它读回的是**已收量**，不是剩余量\n",
               remain, remain2, remain2 == remain ? "" : "，还在变");
    } else {
        printf("  描述符 STATUS=%#010x [%s%s%s]，回写实收 %u 字节\n"
               "    —— SG 下长度写在描述符里，S2MM_LENGTH 那个寄存器已经不参与（读到 %u 没意义）\n",
               bd_sts0,
               (bd_sts0 & BD_STS_COMPLETE) ? "COMPLETE " : "",
               (bd_sts0 & BD_STS_RXSOF) ? "RXSOF " : "",
               (bd_sts0 & BD_STS_RXEOF) ? "RXEOF " : "",
               bd_len0, remain);
    }

    if (failed) {
        /* 失败就直接收尾走人（成功那条路的收尾挪到补收**之后**了，见下面那段注释）*/
        wr(b, S2MM_SR, sr);
        chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
        udmabuf_sync(SYNC_FOR_CPU);
        printf("  %s\n", (failed == 2) ? "S2MM 超时。" : "S2MM 报错。");
        printf("  内存实收 %ld / %u 字节，数据到偏移 %zu 为止。\n",
               real, CALL_OUT_BYTES, end);
        hexdump("S2MM 目标缓冲（前 64 字节）", dst, 64);
        return 1;
    }

    /* ── 补齐本轮剩下的帧（除非 --one）───────────────────────────────────────
     * ⭐ 这一段的理由（板上实测、逐字节比对出来的）：
     * 上面那笔只收到**第一个 TLAST** 就收工，而 HLS 一次调用是 8 帧 ——
     * 剩下的帧根本没被收走，**下一轮不管跑什么命令都会先收到这批存货**
     * （实测：紧接着 e2e 跑的 frames，帧 1 只有 668 / 652 B），而那种短帧极易被
     * 判读成「IP 有跨帧状态」，把人往完全错误的方向带。
     * 所以默认把剩下的收干净 —— e2e 不该污染它自己要测的东西。
     * `--one` 退回老行为，专门用来看"第一笔到底收在哪儿"（TLAST 那条证据仍然照报）。
     *
     * ⚠️ 两条**必须这么写**的细节（2026-10-16 板上第一次跑就踩到了）：
     *   1. 两次挂之间**不许复位通道**。复位期间 S2MM 的 TREADY 会抖，抖一下就从流里
     *      吃掉几拍。所以收尾的 chan_reset 挪到补收**之后**。
     *   2. 每一笔都按**帧格子**（k × 684）挂，不是按"已经收了多少字节"挂。
     *      第一笔收工（TLAST）时，DMA 内部可能已经吞掉几拍没写进内存，于是流的位置
     *      比"逻辑帧边界"超前几拍 —— 紧接着那一笔就会短（实测 668 = 少 4 拍）。
     *      但**短的那一笔是收在 TLAST 上的**，所以再下一笔又回到帧边界、又是整帧。
     *      所以：短一笔 **不是** "FIFO 榨干了"，**绝不能 break**，继续挂就行。
     *      按格子挂的另一层好处：短的那一格补的是底色，别的格还是在 684 的网格上，
     *      下面 check_frames_out 照样能比。 */
    long   first_real = real;                       /* 第一笔落地的字节数 */
    long   filled     = real;
    int    aligned    = (first_real > 0 &&
                         first_real % (long)FRAME_OUT_BYTES == 0);
    int    did_topup  = 0;

    if (opt_one) {
        printf("\n  [--one] 按老行为收手：第一笔收到哪儿就停。剩下的帧没被收走，\n"
               "          **下一轮不管跑什么都会先收到它们**（这是刻意留着看老现象的）\n");
    } else if (filled > 0) {
        int kept = 0, short_ones = 0;

        if (!aligned)
            printf("\n  补收：第一笔落了 %ld 字节（不是 %u 的整数倍 —— 说明开跑那一刻"
                   "就已经在帧中间），按帧格子接着收\n", filled, FRAME_OUT_BYTES);
        else
            printf("\n  补收：第一笔只落了 %ld 字节（= %ld 帧），把剩下的排干净\n",
                   filled, filled / (long)FRAME_OUT_BYTES);

        if (opt_simple) {
            for (uint32_t k = 1; k < N_FRAMES_OUT; k++) {
                uint32_t off = k * FRAME_OUT_BYTES;     /* ← 帧格子，不是 filled */
                if (off + FRAME_OUT_BYTES > CALL_OUT_BYTES)
                    break;
                if (s2mm_arm(off, FRAME_OUT_BYTES) < 0)
                    break;
                long n = s2mm_wait(off);
                if (n <= 0) {
                    printf("     第 %u 帧没收到（超时/出错），停在这里"
                           "（缓冲里 %ld / %u）\n", k + 1, filled, CALL_OUT_BYTES);
                    break;
                }
                filled += n;
                kept++;
                if (n < (long)FRAME_OUT_BYTES) {
                    short_ones++;
                    printf("     第 %u 帧收到 %ld 字节（少 %ld 拍）—— "
                           "从帧中间切进去的，**下一帧就对齐了**（不是排空了）\n",
                           k + 1, n, ((long)FRAME_OUT_BYTES - n) / 4);
                }
            }
        } else {
            /* SG：一拍挂一整个环比一帧一挂干净（也就没有"抢在下一帧到之前重挂"的讲究） */
            int rest = (int)N_FRAMES_OUT - (int)(filled / (long)FRAME_OUT_BYTES);
            uint32_t blen[N_FRAMES_OUT], bsts[N_FRAMES_OUT];
            if (rest > 0
                && s2mm_sg_arm((uint32_t)filled, FRAME_OUT_BYTES, rest) == 0
                && s2mm_sg_wait(rest, blen, bsts) >= 0) {
                for (int i = 0; i < rest; i++) {
                    filled += (long)blen[i];
                    kept++;
                }
            } else if (rest > 0) {
                printf("     环没挂上或没收完，停在这里\n");
            }
        }

        printf("  补收完：%d 帧%s，合计 %ld / %u 字节\n", kept,
               short_ones ? "（其中有短帧，见上）" : "",
               filled, CALL_OUT_BYTES);
        did_topup = 1;
    }

    /* 收尾：到这儿才复位通道（理由见上面第 1 条）*/
    wr(b, S2MM_SR, rd(b, S2MM_SR));
    chan_reset(b, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
    udmabuf_sync(SYNC_FOR_CPU);
    if (did_topup) {
        cache_evict();
        end  = find_data_end(dst, CALL_OUT_BYTES, 0xA5);
        real = filled;
    }

    /* 两个数都说出来，别只报一个：
     *   real = 各笔**实收**字节数之和（补收时每一笔按帧格子挂，被 TLAST 提前结掉的
     *          那几拍没写进内存，所以会比缓冲跨度小 —— 这是正常的，不是丢数据）；
     *   end  = 缓冲里真数据**写到哪儿为止**（check_frames_out 按它切块才对）。 */
    printf("\n[e2e] 完成：本轮共收到 %ld 字节（第一笔 %ld），缓冲写到偏移 %zu / %u\n",
           real, first_real, end, CALL_OUT_BYTES);

    /* ── 按**第一笔**的实测值判读 TLAST 语义（补收不参与这条判读）───────────
     * AXI DMA 没有能读回来的 TLAST 寄存器（xaxidma_hw.h 里 0x38 是 S2MM_CURDESC，
     * 整个驱动不含 TLAST 字样），所以"TLAST 有没有生效"只能这样间接看：
     * 明明给了 5472，却只收了一帧就 IOC —— 那就是收到 TLAST 收工。
     * ⚠️ 一律用 first_real（**第一笔**），不是补收之后的合计 —— 合计 8 帧是设计如此。 */
    if (first_real == (long)FRAME_OUT_BYTES) {
        printf("  ✔ 第一笔正好一帧（%u B）-> **TLAST 生效**：DMA 在每帧尾的 TLAST 处收工。\n",
               FRAME_OUT_BYTES);
        printf("    这也顺带验证了「171 拍/帧 = 684 B」这个契约。\n");
    } else if (first_real == (long)CALL_OUT_BYTES) {
        printf("  ✔ 第一笔就收到整整 8 帧（%u B）-> DMA **忽略 TLAST**、老实收满上限"
               "（直读模式是 LENGTH 寄存器，SG 是描述符里的长度）。\n", CALL_OUT_BYTES);
        printf("    这一次就把 8 帧全拿到了，下面直接比对 8 块一致性。\n");
    } else if (first_real > 0) {
        printf("  ? 第一笔实收 %ld：既不是一帧(%u)也不是八帧(%u)。", first_real,
               FRAME_OUT_BYTES, CALL_OUT_BYTES);
        if (first_real % (long)FRAME_OUT_BYTES == 0)
            printf("但正好是 %ld 帧的整数倍。\n", first_real / (long)FRAME_OUT_BYTES);
        else
            printf("差 %ld 字节才够一帧（= %ld 拍）—— **开跑那一刻 IP 里就有存货**，\n"
                   "    这一笔是从帧中间切进去的；本轮 8 块的比对不作数\n",
                   (long)FRAME_OUT_BYTES - first_real,
                   ((long)FRAME_OUT_BYTES - first_real) / 4);
    } else {
        printf("  ✘ 实收 0：一个字节都没收到。\n");
        if (a5_before != a5_after)
            printf("    但挤缓存前后读数不一样 —— 先按上面那行把「可缓存映射」解决掉再判。\n");
        else if (!opt_simple)
            printf("    描述符的 COMPLETE 一个都没置上。SG 路径下按这个顺序查：\n"
                   "      1) bitstream 是不是新的（axi_dma_1 的 m_axi_sg 要接到 DDR）\n"
                   "      2) 描述符布局 —— 默认 BSP 的 64B 布局，试试 --alt-desc\n"
                   "      3) 去掉 --sg 回直读模式对照：那边也 0 字节 = 是 dout 没数据\n");
        else
            printf("    新 bitstream 没烧对 / BD 里 dout 没连上。\n");
    }

    /* 把真数据分段打出来：tok 段（INT8，值都很小）到 384 字节为止，
     * logits 段（INT16）在后面。这段字节从哪开始"变宽"，一看就知道 tok 段有没有被截。 */
    printf("\n  数据结尾在偏移 %zu（一帧应当 %u）：\n", end, FRAME_OUT_BYTES);
    hexdump("数据开头", dst, 64);
    if (end > 320)
        hexdump("偏移 320 起（tok 段理论上 384 结束，看这里有没有翻成 INT16）",
                dst + 320, 128);
    if (end > 128)
        hexdump("数据末尾", dst + (end > 96 ? end - 96 : 0), 96);

    /* 拿**缓冲跨度** end 去切块，不是 real：补收时某一格可能只有 668 字节（那 16 字节
     * 被 TLAST 提前结掉了），但格子还是按 684 排的 —— 用 real 切会少算最后一格。 */
    if (real > 0 && aligned)
        check_frames_out(dst, (long)end);
    else if (real > 0)
        printf("  （本轮第一笔没落在帧边界上，8 块比对没有意义，跳过 —— "
               "这种轮次的数据**不能**拿来判「IP 有无跨帧状态」）\n");

    /* 把结果也落盘（只写真正有数据的那一段，方便离线看结构） */
    char out[64];
    snprintf(out, sizeof(out), "pl_dma_test_out_%s.bin", run_tag());
    int fd = open(out, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd >= 0) {
        if (write(fd, dst, end) < 0)
            fprintf(stderr, "警告: 写 %s 失败\n", out);
        close(fd);
        printf("  结果已写入 %s（%zu 字节）\n", out, end);
        printf("  ⚠ 文件名带轮次戳，拷回去时**用上面这个名字**：\n"
               "     cp %s run_<自己起的名>.bin   ← 每次换新名字，别再固定成一个\n", out);
    }
    return 0;
}

/* ─────────────────────────── frames ───────────────────────────
 * 收 8 帧，每帧 684 B（= 171 拍，正好一帧的边界）。
 *
 * **默认（直读模式，对应 BD 里 axi_dma_1 C_INCLUDE_SG=0）**：一帧一挂，走
 * `s2mm_arm`/`s2mm_wait` 热路径（不软复位/不 sync/不挤缓存 —— 每帧都做那三样会
 * 留几百 µs 空档，而一个帧期才 ~101 µs，板实测每帧正好少 8 拍）。
 * `--slow-rearm` 再退回每帧软复位的老路径复现那个现象。
 * 每帧收多少以**内存里的 0xA5 底色边界**为准（直读模式没有描述符可回写）。
 *
 * **--sg（要求 BD 里那个开关打开）**：一个 8 描述符的环，开跑前一次挂满，之后
 * 硬件自己一帧一个往下走，软件不插手。这一版结构性好处是：直读模式下"每帧都要
 * 抢在下一帧到之前把 DMA 重挂好"那个时序讲究在这里不存在了 —— 8 个描述符早就
 * 摆好了，一帧也不会被切掉头。每帧收多少以**描述符 STATUS 低位的回写值**为准，
 * 那是硬件的回答。
 *
 * 两种模式都要和 MM2S 并发：HLS 每帧只吃 256 字，MM2S 灌进来的 8192 B 会在
 * Signal_process 的输入 FIFO 里被反压住，所以不能等 MM2S 跑完再收。
 */
static int cmd_frames(void)
{
    char mode[128];
    if (opt_simple)
        snprintf(mode, sizeof(mode), opt_slow_rearm
                 ? "[直读模式 + 每帧软复位重挂（--slow-rearm）]"
                 : "[直读模式 + 一帧一挂的热路径]");
    else
        snprintf(mode, sizeof(mode),
                 "[SG：一个 %u 描述符的环一次挂满，硬件自己一帧一个往下走]",
                 N_FRAMES_OUT);
    printf("[frames] 收 %u 帧，每帧 %u B（= %u 拍），共 %u B   %s\n",
           N_FRAMES_OUT, FRAME_OUT_BYTES, FRAME_BEATS, CALL_OUT_BYTES, mode);

    if ((uint64_t)CALL_OUT_BYTES > DST_MAX) {
        fprintf(stderr, "目标区不够大：要 %u，只有 %lu\n",
                CALL_OUT_BYTES, (unsigned long)DST_MAX);
        return 1;
    }

    uint8_t *dst = buf_va + DST_OFF + opt_dst_shift;   /* 见 opt_dst_shift 注释 */

    if (opt_dst_shift)
        printf("  [--dst-shift=%u] 目标基址整体后挪 %u 字节：帧 1 落在缓冲偏移 %u，"
               "洞的「绝对偏移 mod 64」会跟着变\n",
               opt_dst_shift, opt_dst_shift, opt_dst_shift);

    /* ── 先冲干净上一轮的残留输出 ────────────────────────────────
     * 上一个进程如果没收完就退出了（Ctrl-C、或者跑到一半），HLS 输出里会留着
     * 半帧。不清掉的话第 1 次要到的是**那个残帧的尾巴**，量出来就不是 684
     * （板上真发生过：668 = 少 4 拍，前一个命令恰好是 --slow-rearm）。
     * 和 e2e 开头那一步同理。 */
    printf("  0) 冲掉上一轮可能残留的输出\n");
    chan_reset(reg0, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
    if (opt_no_drain) {
        /* 排查用：SG 下这个环每次都是重新挂的，残留最多落在 BD[0] 里被当成第 1 帧，
         * 不会像直读模式那样"吃掉半帧"。跳过它可以把"是不是这一步把通道弄坏了"
         * 这个变量摘掉 —— 板上第一次跑，出错的第一条就出在这个 drain 里。 */
        printf("     [--no-drain] 跳过冲残留，只把 S2MM 复位一下\n");
        chan_reset(reg1, S2MM_CR, S2MM_SR, "axi_dma_1(S2MM)");
    } else {
        int saved = opt_timeout_ms;
        opt_timeout_ms = 300;
        for (int i = 0; i < 4; i++) {
            long n = do_s2mm(0, FRAME_OUT_BYTES, 1);
            if (n < 0 || n < (long)FRAME_OUT_BYTES)
                break;                      /* 收不满一帧 = 榨干了 */
        }
        opt_timeout_ms = saved;
        /* 这一步本来就常常是"没货" —— 上面要是有「S2MM 超时 300 ms」，
         * 那是**排空**的意思（300ms 内一个字节都没来），不是出错。说一声免得看着吓人。 */
        printf("     [冲] 排空结束（上面若有「超时」= 那边已经没货了，这一条正常）\n");
    }

    memset(dst, 0xA5, CALL_OUT_BYTES);      /* 底色，方便看哪些字节没被写过 */
    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();                          /* 底色先落 DDR（可缓存映射下很关键） */

    prepare_src(CALL_IN_BYTES);

    long got[N_FRAMES_OUT];
    uint32_t bd_sts[N_FRAMES_OUT];
    uint32_t bd_len[N_FRAMES_OUT];
    uint32_t sr_ioc[N_FRAMES_OUT];          /* 每帧收工**那一刻**的 S2MM DMASR */
    for (uint32_t k = 0; k < N_FRAMES_OUT; k++) {
        got[k] = -1;
        bd_sts[k] = bd_len[k] = sr_ioc[k] = 0;
    }

    long total = 0;
    uint32_t done = 0;

    if (!opt_simple) {
        /* ── SG：一个环挂满 8 个描述符，MM2S 一开跑硬件就自己往下走 ──────────
         * 这里**没有**"第 1 帧要抢在 MM2S 之前"那个讲究了：8 个描述符在开跑前
         * 就已经全部挂好，第 1 帧不可能被切掉头。 */
        if (s2mm_sg_arm(0, FRAME_OUT_BYTES, N_FRAMES_OUT) < 0)
            return 1;
        if (mm2s_start(CALL_IN_BYTES) < 0)
            return 1;
        printf("  MM2S 已开跑（%u B）；S2MM 侧 %u 个描述符已挂好"
               "（CURDESC=%#010x TAILDESC=%#010x），下面等它们全部 COMPLETE\n",
               CALL_IN_BYTES, N_FRAMES_OUT,
               rd(reg1, S2MM_CURDESC), rd(reg1, S2MM_TAILDESC));

        int wres = s2mm_sg_wait(N_FRAMES_OUT, bd_len, bd_sts);

        /* 不管等成没等成，先把 MM2S 那一侧的结局打出来 —— 这是"问题在 dout 之前
         * 还是之后"的分叉点：输入 FIFO 只有 2 帧深，HLS 排不出结果会反压住 MM2S，
         * 所以 MM2S 能完成就等于"MM2S→HLS"这段是通的。 */
        {
            uint32_t msr = rd(reg0, MM2S_SR);
            uint32_t mbd = bd_read_sts((const uint32_t *)(buf_va + BD_OFF));
            printf("  MM2S 收场：DMASR=%#010x [%s%s%s]  描述符 STATUS=%#010x"
                   "  <- %s（本次发 %u B）\n",
                   msr,
                   (msr & SR_HALTED) ? "Halted " : "",
                   (msr & SR_IOC) ? "IOC " : "",
                   (msr & (SR_ERR | SR_ERR_SG)) ? "ERR " : "",
                   mbd,
                   (mbd & BD_STS_COMPLETE) ? "COMPLETE：HLS 把 8 帧输入全吃下去了，"
                                             "所以问题在 dout 之后"
                                           : "没完成：卡在 HLS 之前或之中，"
                                             "先别怪 S2MM 的描述符",
                   CALL_IN_BYTES);
            if (msr & (SR_ERR | SR_ERR_SG))
                print_dmasr_err(msr);
        }
        if (wres < 0)
            return 1;

        for (uint32_t k = 0; k < N_FRAMES_OUT; k++) {
            got[k] = (long)bd_len[k];
            total += got[k];
            done  += 1;
        }
    } else {
        /* ── 直读模式：第 1 帧必须在 MM2S **之前**就挂好。否则等 HLS 已经吐了
         * 几拍才挂上去，第 1 帧就是从帧中间切进去的尾巴（板上实测 668 = 少 4 拍）；
         * 而后面几帧因为每次都收在 TLAST 上、天然对齐，反倒都是完整的 684。 */
        if (!opt_slow_rearm && s2mm_arm(0, FRAME_OUT_BYTES) < 0)
            return 1;
        if (mm2s_start(CALL_IN_BYTES) < 0)
            return 1;
        printf("  MM2S 已开跑（%u B），下面一帧一帧等 S2MM\n", CALL_IN_BYTES);

        for (uint32_t k = 0; k < N_FRAMES_OUT; k++) {
            uint32_t off = k * FRAME_OUT_BYTES;
            got[k] = opt_slow_rearm ? do_s2mm(off, FRAME_OUT_BYTES, 0)
                                    : s2mm_wait(off);
            /* ⚠ 必须**在这里**（下一帧挂上去之前）抓 DMASR：s2mm_arm 开头会 W1C 清一遍，
             * 等整轮跑完再读，只要后面又挂过一帧，这一帧的错误位就什么都没了。
             * 一条 MMIO 读，几十 ns，不破坏"立刻挂下一帧"那个热路径。 */
            sr_ioc[k] = rd(reg1, S2MM_SR);
            if (got[k] < 0) {
                printf("  [%u/%u] 没收到，停在这里。\n", k + 1, N_FRAMES_OUT);
                got[k] = -1;
                break;
            }
            total += got[k];
            done  += 1;

            /* ⭐ 立刻把下一帧挂好，中间**不夹任何慢活**。
             * sysfs 写、memset、挤缓存、甚至 printf（stdout 是行缓冲，每条 = 一次
             * write() 系统调用）都是几十~几百 µs，而一帧的产期才 ~101 µs。
             * 报告也一律挪到循环外打。 */
            if (!opt_slow_rearm && k + 1 < N_FRAMES_OUT)
                s2mm_arm((k + 1) * FRAME_OUT_BYTES, FRAME_OUT_BYTES);
        }
    }

    /* MM2S 该跑完了；就算没完也一并停掉（自环，必须复位）。
     * 然后**等一会儿再读缓冲**：DMA 的写是投递到 DDR 的，IOC 置起来的那一刻
     * 最后几拍可能还在路上。板上实测：收完当场读第 8 帧，150 个高字节里 134 个
     * "不合规"；等 20 ms 再读就是 0 个 —— 是读早了，不是数据错。
     * （前面几帧之所以看不出来，是因为中间夹了个 s2mm_arm，恰好给了排空的时间。） */
    chan_reset(reg0, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");
    msleep(20);

    udmabuf_sync(SYNC_FOR_CPU);
    cache_evict();          /* 同上：读结果前先挤缓存 */
    size_t end_all = find_data_end(dst, CALL_OUT_BYTES, 0xA5);

    uint32_t full_frames = 0;
    for (uint32_t k = 0; k < N_FRAMES_OUT; k++)
        if (got[k] == (long)FRAME_OUT_BYTES)
            full_frames++;

    printf("\n[frames] 落地 %zu / %u 字节（挂成功 %u / %u 帧，其中**整帧** %u 帧），"
           "数据到偏移 %zu 为止\n",
           end_all, CALL_OUT_BYTES, done, N_FRAMES_OUT, full_frames, end_all);

    /* ── S2MM 自己的 DMASR（每帧收工那一刻抓的）────────────────────────────
     * 为什么值得单独看：板上反复见到「某一帧中间连续 16 拍还是底色 0xA5，
     * 但帧长仍是 684、两侧字节都在自己的位置上」—— 那是 16 拍**被吃进去
     * 却没落 DDR**（IP 没发的话整帧会短一截）。这笔账硬件认不认，只有 S2MM
     * 这一侧的 DMASR 说得清；一直只看 MM2S 那一侧是看不出来的。
     * ⚠ 这里只读**错误字段**（SR_ERR / SR_ERR_SG 两个掩码 MM2S 和 S2MM 通用，
     *   定义在 PG021 的 DMASR 表里），不对别的 bit 另作发挥。 */
    if (opt_simple) {
        uint32_t or_all = 0;
        for (uint32_t k = 0; k < N_FRAMES_OUT; k++) or_all |= sr_ioc[k];
        printf("  [S2MM DMASR @每帧收工]");
        for (uint32_t k = 0; k < N_FRAMES_OUT; k++)
            printf(" f%u=%#06x", k + 1, sr_ioc[k] & 0xFFFFFFu);
        printf("\n");
        if (or_all & (SR_ERR | SR_ERR_SG)) {
            printf("      **S2MM 这一侧报了错**（掩码 %#x / %#x）：\n", SR_ERR, SR_ERR_SG);
            print_dmasr_err(or_all);
        } else {
            printf("      %u 帧的错误位（%#x / %#x）**全为 0** ⇒ 硬件**没认**这笔账：\n"
                   "      真丢写也是**静默**丢的（写响应报错会被 DMA 记为 DMASlvErr/DMADecErr），\n"
                   "      ⇒ 往「写被吞但没人报错」这个方向查（DMA 的写通路 / 互连 / DDR 控制器）。\n",
                   done, SR_ERR, SR_ERR_SG);
        }
    }

    /* ── ⭐ 这一轮的数据能不能拿来判读？ ───────────────────────────────────────
     * 板上实测出来的铁律（4 次脏轮次全中、4 次干净轮次全不中）：
     *   **帧 1 是短帧（668 = 少 4 拍 / 652 = 少 8 拍） ⇔ 上一轮在 IP 输出里留了存货。**
     * 老的 e2e（收一帧就收手，把剩下 7 帧留在 IP 里）之后**必现**；连跑几次干净的
     * frames 之后一次都不出现。
     * 所以这里先把**本轮判读作废**说在前头 —— 否则"帧 1 少 4 拍"会被读成
     * 「IP 有跨帧状态」，方向整个错（我自己就先上过这个当，白折腾半天）。 */
    size_t e_first = (got[0] >= 0) ? find_data_end(dst, FRAME_OUT_BYTES, 0xA5) : 0;
    int dirty_round = (got[0] >= 0 && e_first < (size_t)FRAME_OUT_BYTES);

    if (dirty_round) {
        printf("\n  ⚠⚠ **帧 1 是短帧（%zu / %u 字节 = 少 %zu 拍）—— 本轮的这个结论作废** ⚠⚠\n"
               "      这是「上一轮没排干净的存货」的招牌长相：上一轮没把输出收干净，\n"
               "      这次开跑是从帧中间切进去的，所以帧 1 缺头。\n"
               "      它**不是**「IP 有跨帧状态」的证据 —— 别往那边查。\n"
               "      帧 2 起是落在 684 的格子上的，看它们本身没问题；但**这一轮的 8 块\n"
               "      里混着上一轮的存货和新数据**，所以「8 帧输入相同、输出应当相同」\n"
               "      这条判据本轮**不成立**，别拿它下结论。\n"
               "      下一步：连跑 2~3 次 `frames`（每跑一次排掉一轮存货），\n"
               "      等帧 1 恢复到 %u 字节，那一轮才作数。",
               e_first, FRAME_OUT_BYTES, ((size_t)FRAME_OUT_BYTES - e_first) / 4,
               FRAME_OUT_BYTES);
        if (got[0] < (long)FRAME_OUT_BYTES)
            printf("\n      （硬件侧也这么说：这一笔只挂了 %ld 字节）", got[0]);
        printf("\n");
    }

    /* 「这块跟别的帧**逐字节相同**」的标记，专给下面逐帧的"错位"判读降噪。
     * 板上踩到过：帧 4..8 五个块一模一样，判据却对着其中两块报"错位" ——
     * 数都相同，错位就轮不到它。**判据太严的锅，不能挂在硬件上。** */
    int twin[N_FRAMES_OUT];
    for (uint32_t k = 0; k < N_FRAMES_OUT; k++) {
        twin[k] = 0;
        for (uint32_t j = 0; j < N_FRAMES_OUT; j++)
            if (j != k && got[j] >= 0 && got[k] >= 0 &&
                !memcmp(dst + (size_t)k * FRAME_OUT_BYTES,
                        dst + (size_t)j * FRAME_OUT_BYTES, FRAME_OUT_BYTES)) {
                twin[k] = 1;
                break;
            }
    }

    /* 数据落定之后再逐帧读。每帧验一次分界：整帧就在 384 上验，
     * 短帧按「头缺尾全」在 尾-300 上验。 */
    printf("  逐帧看（每帧应当 %u 字节）：\n", FRAME_OUT_BYTES);
    for (uint32_t k = 0; k < N_FRAMES_OUT; k++) {
        const uint8_t *f = dst + k * FRAME_OUT_BYTES;
        size_t e, bad = (size_t)-1;
        const char *how = "";

        if (got[k] < 0) {
            printf("    [%u] 没收到\n", k + 1);
            continue;
        }
        e = find_data_end(f, FRAME_OUT_BYTES, 0xA5);
        if (e == (size_t)FRAME_OUT_BYTES) {
            bad = count_bad_int16(f, TOK_FRAME_BYTES, LOG_FRAME_BYTES);
            how = "整帧@384";
        } else if (e >= (size_t)LOG_FRAME_BYTES) {
            bad = count_bad_int16(f, e - (size_t)LOG_FRAME_BYTES, LOG_FRAME_BYTES);
            how = "短帧@尾-300";
        }

        if (opt_simple) {
            printf("    [%u] 落到 %zu / %u 字节", k + 1, e, FRAME_OUT_BYTES);
        } else {
            /* SG 下"收了多少"有硬件回写的权威值（描述符 STATUS 低位），
             * 内存里数出来的那个只当旁证——两者不一致就说明有一步不对。 */
            printf("    [%u] 描述符回写 %u / %u 字节 [%s%s]，内存里落到 %zu 字节%s",
                   k + 1, bd_len[k], FRAME_OUT_BYTES,
                   (bd_sts[k] & BD_STS_COMPLETE) ? "COMPLETE " : "",
                   (bd_sts[k] & BD_STS_RXEOF) ? "RXEOF" : "**无 RXEOF**",
                   e,
                   (bd_len[k] == e) ? "" : "   <- 两数不一致，要查");
        }
        if (bad == (size_t)-1)
            printf("（太短，分界验不了）\n");
        else
            printf("，%s 验出 %zu 个高字节不合规%s\n", how, bad,
                   bad == 0                ? "   <- 分界对"
                   : (dirty_round && k == 0) ? "   <- **上一轮没排干净的存货**，"
                                               "不是错位（本轮判读已作废）"
                   : twin[k]               ? "   <- 但这一块跟别的帧**逐字节相同**，"
                                             "「错位」不作数（是判据太严，不是硬件）"
                                           : "   <- 错位");
    }

    if (total >= (long)FRAME_OUT_BYTES * 2)
        check_frames_out(dst, total);

    char out[64];
    snprintf(out, sizeof(out), "pl_dma_test_frames_%s.bin", run_tag());
    int fd = open(out, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd >= 0) {
        if (write(fd, dst, end_all) < 0)
            fprintf(stderr, "警告: 写 %s 失败\n", out);
        close(fd);
        printf("  结果已写入 %s（%zu 字节）\n", out, end_all);
        printf("  ⚠ 文件名带轮次戳，拷回去时**用上面这个名字**：\n"
               "     cp %s run_<自己起的名>.bin   ← 每次换新名字，别再固定成一个\n", out);
    }

    return (total == (long)CALL_OUT_BYTES) ? 0 : 1;
}

/* ─────────────────────────── main ─────────────────────────── */
/* ═════════════════ irqscan：把「IRQ_F2P[n] 落到哪个 GIC SPI」实测出来 ═════════════════
 * 这个号在厂商给的任何文件里都没有（BD/hwh/bxml/dts/两份 PDF/deb 全找过）。
 * 设备树里现在写的 61/64 是按 Zynq-7000 规则**声明**的 —— 这个子命令是来**实测**它。
 *
 * 三道信号，从便宜到贵，按顺序全打出来，哪一道先出结果都算数：
 *   ① 非侵入：跑一笔 MM2S，看 /proc/interrupts 里驱动那两行计数涨不涨。
 *             涨了 ⇒ 中断真的到了驱动申请的那条线上 ⇒ 就是那个号。
 *   ② 使能后立刻读 pending：线本来就悬着的话，不用跑 DMA 就有答案。
 *   ③ 跑 DMA 完成那一刻读 pending：**只承认比②的基线新立起来的那一位**。
 *
 * 为什么这样能问出来：PL 上来的是**电平型**中断线，DMA 会一直拉高到有人写 DMASR
 * 清掉源；所以在 GIC 里把候选 SPI 使能之后，只要线还悬着，pending 位立刻变 1。
 * 不需要任何驱动配合，唯一的敌人是「有驱动把这个位吃掉了」。
 *
 * 判读纪律（本项目吃过亏的三条）：
 *   - 只报「比基线变化的位」，不报「最像的那一位」；
 *   - **先确认这笔 MM2S 真的跑完了** —— 没跑完就根本没产生中断，那是「测量无效」，
 *     不是「中断号不对」；
 *   - ②里出现的位未必是 DMA：IRQ_F2P[1]/[2] 上还挂着 customop_irq / ai_irq，
 *     它们本来就可能是悬着的。真正算数的只有③里**新**立起来的那一位。
 */
#define IRQ_LINE_NONE UINT64_MAX

/* 把区间 [lo,hi] 落在字 word 里的位拼成掩码 */
static uint32_t spi_mask_in(unsigned lo, unsigned hi, int word)
{
    uint32_t m = 0;
    for (unsigned s = lo; s <= hi; s++)
        if ((int)(s / 32u) == word)
            m |= 1u << (s % 32u);
    return m;
}

/* 打印各字掩码里落在区间内的 SPI 号；base 非 NULL 时只报「比 base 新立起来」的位。
 * 返回报出来的个数。这是全篇唯一的判读入口 —— 只有对/错，不给「最像的」。 */
static int spi_list(const char *tag, const int *widx, int nw, unsigned lo, unsigned hi,
                    const uint32_t *vals, const uint32_t *base)
{
    int n = 0;
    printf("    %s", tag);
    for (int i = 0; i < nw; i++) {
        int w = widx[i];
        uint32_t m = vals[i];
        if (base) m &= ~base[i];
        m &= spi_mask_in(lo, hi, w);
        for (unsigned s = lo; s <= hi; s++) {
            if ((int)(s / 32u) != w) continue;
            if (m & (1u << (s % 32u))) { printf(" %u", s); n++; }
        }
    }
    if (!n) printf("（无）");
    printf("\n");
    return n;
}

/* 读 /proc/interrupts 里含 devkey 的那一行：原样打出来，并把每 CPU 计数求和。
 * 没有这一行返回 IRQ_LINE_NONE。（行格式： "29: 0 0 0 0 GIC-400 29 Level 80400000.dma"） */
static uint64_t irq_line_sum(const char *devkey)
{
    FILE *f = fopen("/proc/interrupts", "r");
    if (!f) { printf("      （打不开 /proc/interrupts：%s）\n", strerror(errno)); return IRQ_LINE_NONE; }
    char line[512];
    uint64_t sum = IRQ_LINE_NONE;
    while (fgets(line, sizeof line, f)) {
        if (!strstr(line, devkey)) continue;
        printf("      %s", line);
        uint64_t s = 0;
        const char *p = line;
        while (*p == ' ' || *p == '\t') p++;
        while (*p && *p != ' ' && *p != '\t') p++;     /* 跳过 "29:" 这个头 */
        for (;;) {                                     /* 依次累加每 CPU 的计数 */
            while (*p == ' ' || *p == '\t') p++;
            if (!*p) break;
            const char *q = p;
            int dig = 1;
            while (*q && *q != ' ' && *q != '\t') { if (*q < '0' || *q > '9') dig = 0; q++; }
            if (!dig) break;                           /* 到 "GIC-400" 这一列就停 */
            s += strtoull(p, NULL, 10);
            p = q;
        }
        sum = s;
    }
    fclose(f);
    return sum;
}

static int cmd_irqscan(uint32_t xfer)
{
    unsigned lo = (unsigned)(opt_spi_lo ? opt_spi_lo : (long)SPI_DEF_LO);
    unsigned hi = (unsigned)(opt_spi_hi ? opt_spi_hi : (long)SPI_DEF_HI);
    if (lo > hi) { unsigned t = lo; lo = hi; hi = t; }
    if (lo < SPI_FIRST) { printf("  注意：下界 %u 抬到 %u（0..31 是 SGI/PPI，不在 F2P 这条路上）\n", lo, SPI_FIRST); lo = SPI_FIRST; }
    if (hi > SPI_LAST)  { printf("  注意：上界 %u 压到 %u（GICv2 只有 32..95 这 64 个 SPI）\n", hi, SPI_LAST); hi = SPI_LAST; }
    if (!xfer) xfer = CALL_IN_BYTES;
    if (xfer > 16383u) { printf("  ✗ 长度 %u 超过单个描述符上限 16383 字节\n", xfer); return 2; }

    uint64_t gbase = opt_gic_base ? opt_gic_base : DEF_GICD;
    int widx[3], nw = 0;
    for (int w = (int)(lo / 32u); w <= (int)(hi / 32u); w++) widx[nw++] = w;

    printf("\n== irqscan：实测 IRQ_F2P 落到哪个 GIC SPI ==\n");
    printf("  GICD %#lx（dts 里 interrupt-controller@f8910000 的 reg 首段）\n", (unsigned long)gbase);
    printf("  扫描 SPI %u..%u 共 %u 位%s\n", lo, hi, hi - lo + 1,
           opt_no_enable ? "；--no-enable：只读不使能" : "；跑完会把新开的位关回去");
    printf("  区间按 7z030 规则取（F2P[0..7]=61..68、[8..15]=84..91）—— 那是**声明**，\n"
           "  这次就是来坐实它的。区间不对就用 --spi-lo= / --spi-hi= 改。\n");

    /* ── 打开 GICD（只映射 4KB；本命令最大偏移 0xC14，碰不到后面的 GICC） ── */
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) { printf("  ✗ 打不开 /dev/mem（要 root）：%s\n", strerror(errno)); return 1; }
    void *gv = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)gbase);
    int mmerr = errno;
    close(fd);
    if (gv == MAP_FAILED) {
        printf("  ✗ mmap GICD 失败：%s\n", strerror(mmerr));
        printf("    若是 EPERM/EACCES，多半是内核开了 CONFIG_IO_STRICT_DEVMEM ——\n"
               "    那就得改走「先让驱动 probe 成功、再看 /proc/interrupts」那条路了。\n");
        return 1;
    }
    volatile uint32_t *g = (volatile uint32_t *)gv;
    printf("  GICD 映射到 %p\n", gv);

    uint32_t ctlr = rd(g, GICD_CTLR);
    printf("  GICD_CTLR = %#010x（bit0 EnableGrp0=%u、bit1 EnableGrp1=%u）%s\n",
           ctlr, ctlr & 1u, (ctlr >> 1) & 1u,
           (ctlr & 3u) ? "" : "  ⚠ 两组都没开，pending 不会动");

    /* ── [1] GICD 基线：只读，一个字节都不写 ── */
    uint32_t orig_en[3] = { 0, 0, 0 }, we_en[3] = { 0, 0, 0 };
    uint32_t pend0[3] = { 0, 0, 0 }, pen_en[3] = { 0, 0, 0 };
    uint32_t pend_at[3] = { 0, 0, 0 }, pend_win[3] = { 0, 0, 0 }, act_at[3] = { 0, 0, 0 };

    printf("\n[1] GICD 基线（只读）\n");
    for (int i = 0; i < nw; i++) {
        int w = widx[i];
        orig_en[i] = rd(g, GICD_ISENABLER + 4u * (uint32_t)w);
        pend0[i]   = rd(g, GICD_ISPENDR   + 4u * (uint32_t)w);
        printf("    字%d（SPI %d..%d）使能=%#010x pending=%#010x（本区间 %#010x）\n",
               w, w * 32, w * 32 + 31, orig_en[i], pend0[i],
               pend0[i] & spi_mask_in(lo, hi, w));
    }
    spi_list("区间内已经立着的 pending：", widx, nw, lo, hi, pend0, NULL);

    /* 每位的优先级 / 目标 CPU：GICv2 里这两个是「一个中断一个字节」 */
    for (unsigned base = lo; base <= hi; base += 8) {
        unsigned end = (base + 7 > hi) ? hi : base + 7;
        printf("    SPI %3u..%-3u  PRI:", base, end);
        for (unsigned s = base; s <= end; s++) printf(" %02x", ((volatile uint8_t *)g)[GICD_IPRIORITYR + s]);
        printf("   TGT:");
        for (unsigned s = base; s <= end; s++) printf(" %02x", ((volatile uint8_t *)g)[GICD_ITARGETSR + s]);
        printf("\n");
    }
    printf("    TGT 是目标 CPU 位图：0 = 送给谁都不要，那个 SPI 就算立起来也不会被转发。\n");
    printf("    ICFGR 触发方式：");
    int nedge = 0;
    for (unsigned s = lo; s <= hi; s++) {
        uint32_t f = (rd(g, GICD_ICFGR + 4u * (s / 16u)) >> (2u * (s % 16u))) & 3u;
        if (f) { printf(" SPI %u=%u", s, f); nedge++; }
    }
    if (!nedge) printf("全是电平（00）—— 和 dts 里 flags=4 一致");
    printf("\n");

    /* ── [2] /proc/interrupts 基线 ── */
    printf("\n[2] /proc/interrupts 基线（驱动那两行）\n");
    uint64_t b0 = irq_line_sum("80400000");
    if (b0 == IRQ_LINE_NONE) printf("      （没有含 80400000 的行 —— 驱动没绑上，或这行名字不一样）\n");
    uint64_t b1 = irq_line_sum("80410000");
    if (b1 == IRQ_LINE_NONE) printf("      （没有含 80410000 的行 —— 同上）\n");
    printf("    注：那一行里 `GIC-400` 后面跟着的数字是**设备树里我们申请的那个号**\n"
           "        （irq domain 的 hwirq），**不是实测号** —— 它只说明「我们申请了 61」，\n"
           "        不说明「中断真的落在 61 上」。真信号只有每 CPU 那几列计数涨没涨。\n");

    /* ── [3] 使能区间，然后立刻读 pending ── */
    if (opt_no_enable) {
        for (int i = 0; i < nw; i++) pen_en[i] = pend0[i];
        printf("\n[3] 跳过（--no-enable）——这种模式下只有 [2]/[6] 那两道信号\n");
    } else {
        printf("\n[3] 使能区间（只开**原本关着**的位，跑完恢复原值）\n");
        for (int i = 0; i < nw; i++) {
            int w = widx[i];
            uint32_t m = spi_mask_in(lo, hi, w);
            we_en[i] = m & ~orig_en[i];
            if (we_en[i]) { wr(g, GICD_ISENABLER + 4u * (uint32_t)w, we_en[i]); __sync_synchronize(); }
            uint32_t back = rd(g, GICD_ISENABLER + 4u * (uint32_t)w);
            printf("    字%d：本次新开 %#010x；回读使能=%#010x（区间内 %#010x）\n",
                   w, we_en[i], back, back & m);
        }
        for (int i = 0; i < nw; i++) pen_en[i] = rd(g, GICD_ISPENDR + 4u * (uint32_t)widx[i]);
        printf("    使能之后立刻读 pending（这一步没跑任何 DMA）\n");
        int n = spi_list("    比 [1] 新立起来：", widx, nw, lo, hi, pen_en, pend0);
        if (n) printf("      ⚠ 这些位**本来就有中断悬着**。但别急着当答案：F2P[1]/[2] 上还挂着\n"
                      "        customop_irq / ai_irq，它们本来就可能是悬着的 —— 算数的还是 [4]。\n");
    }

    /* ── [4] 跑一笔 MM2S，在完成的那一刻读 pending ── */
    printf("\n[4] 跑一笔 MM2S（%u 字节），在完成那一刻读 pending\n", xfer);
    prepare_src(xfer);
    int done = 0, why = 0;    /* 0=没跑完 1=IOC/COMPLETE 2=错 3=超时 */
    uint32_t sr = 0;
    if (mm2s_start(xfer) < 0) {
        printf("  ✗ MM2S 起不来 ⇒ **这次测量无效**（不是「中断号不对」）\n");
        why = 2;
    } else {
        uint32_t *bd = (uint32_t *)(buf_va + BD_OFF);
        uint64_t t0 = now_ms();
        for (;;) {                       /* 忙等：IOC 那一刻要**尽快**读 pending */
            sr = rd(reg0, MM2S_SR);
            if (sr & (SR_ERR | SR_ERR_SG)) { why = 2; break; }
            if ((sr & SR_IOC) || (bd_read_sts(bd) & BD_STS_COMPLETE)) { done = 1; why = 1; break; }
            if (now_ms() - t0 > (uint64_t)opt_timeout_ms) { why = 3; break; }
            __sync_synchronize();
        }
        if (why == 1) {
            for (int i = 0; i < nw; i++) {
                pend_at[i] = rd(g, GICD_ISPENDR   + 4u * (uint32_t)widx[i]);
                act_at[i]  = rd(g, GICD_ISACTIVER + 4u * (uint32_t)widx[i]);
                pend_win[i] = pend_at[i];
            }
            /* 再采一小段：万一内核抢在我们前面把它 ack 了，电平悬着的话会重新 pending */
            uint64_t w0 = now_us();
            while (now_us() - w0 < 1000u) {
                for (int i = 0; i < nw; i++)
                    pend_win[i] |= rd(g, GICD_ISPENDR + 4u * (uint32_t)widx[i]);
                __sync_synchronize();
            }
            printf("    MM2S 完成（DMASR=%#010x）⇒ 至少产生了一次完成中断\n", sr);
        } else if (why == 2) {
            printf("  ✗ MM2S 出错 DMASR=%#010x ⇒ **这次测量无效**（不是「中断号不对」）\n", sr);
            print_dmasr_err(sr);
        } else {
            printf("  ✗ MM2S 超时 %d ms ⇒ **这次测量无效**（不是「中断号不对」）\n", opt_timeout_ms);
            printf("    先把 `pl_dma_test mm2s` 单独跑通再来 —— 没完成就没有中断可测。\n");
        }
    }

    /* ── [5] 收尾：把这次动过的东西全部还原 ── */
    printf("\n[5] 收尾还原\n");
    for (int i = 0; i < nw; i++)                       /* 5a 先关掉我们新开的位（止损） */
        if (we_en[i]) wr(g, GICD_ICENABLER + 4u * (uint32_t)widx[i], we_en[i]);
    for (int i = 0; i < nw; i++) {                     /* 5b 清掉「我们开的 + 此刻 pending」的位 */
        uint32_t m = we_en[i] & rd(g, GICD_ISPENDR + 4u * (uint32_t)widx[i]);
        if (m) wr(g, GICD_ICPENDR + 4u * (uint32_t)widx[i], m);
    }
    uint32_t dmasr = rd(reg0, MM2S_SR);                /* 5c 清 DMA 侧的中断源 */
    if (dmasr & (SR_IOC | SR_IRQ_ERR | SR_ERR | SR_ERR_SG)) {
        wr(reg0, MM2S_SR, dmasr);                      /* DMASR 是 W1C：写回读到的值 */
        printf("    清 axi_dma_0 的 DMASR（%#010x）—— 不清的话线还悬着，一恢复使能就又是 pending\n", dmasr);
    }
    for (int i = 0; i < nw; i++) {                     /* 5d 使能掩码恢复原值（只动本区间） */
        int w = widx[i];
        uint32_t m = spi_mask_in(lo, hi, w);
        wr(g, GICD_ISENABLER + 4u * (uint32_t)w, orig_en[i] & m);
        wr(g, GICD_ICENABLER + 4u * (uint32_t)w, ~orig_en[i] & m);
        uint32_t back = rd(g, GICD_ISENABLER + 4u * (uint32_t)w) & m;
        printf("    字%d 使能掩码恢复为 %#010x（回读 %#010x）%s\n",
               w, orig_en[i] & m, back, (back == (orig_en[i] & m)) ? "" : "  ⚠ 不一致");
    }
    chan_reset(reg0, MM2S_CR, MM2S_SR, "axi_dma_0(MM2S)");   /* 5e 收掉 MM2S */

    /* ── [6] /proc/interrupts 复读，报差值 ── */
    printf("\n[6] /proc/interrupts 复读（驱动那两行）\n");
    uint64_t a0 = irq_line_sum("80400000");
    if (a0 == IRQ_LINE_NONE) printf("      （没有含 80400000 的行 —— 同上）\n");
    uint64_t a1 = irq_line_sum("80410000");
    if (a1 == IRQ_LINE_NONE) printf("      （没有含 80410000 的行 —— 同上）\n");
    {
        const char *k[2] = { "80400000.dma(MM2S)", "80410000.dma(S2MM)" };
        uint64_t bb[2] = { b0, b1 }, aa[2] = { a0, a1 };
        for (int i = 0; i < 2; i++) {
            if (bb[i] == IRQ_LINE_NONE || aa[i] == IRQ_LINE_NONE) {
                printf("    %-22s : 基线/复读缺行，比不了\n", k[i]);
            } else {
                printf("    %-22s : %llu -> %llu   差 %+lld\n", k[i],
                       (unsigned long long)bb[i], (unsigned long long)aa[i],
                       (long long)aa[i] - (long long)bb[i]);
            }
        }
    }

    /* ── [7] 结论：只认「比基线新立起来」的位 ── */
    printf("\n[7] 结论\n");
    if (!done) {
        printf("  ✗ 这笔 MM2S 没跑完 ⇒ 根本没产生完成中断 ⇒ **这次测量无效**。\n"
               "    这不是「中断号不对」—— 先把 `pl_dma_test mm2s` 单独跑通了再来。\n");
        return 1;
    }

    spi_list("  [4] MM2S 完成那一刻，比 [3] 新立起来的 pending：",
             widx, nw, lo, hi, pend_at, pen_en);
    spi_list("      那之后 1 ms 内（万一被内核抢着 ack 过）：",
             widx, nw, lo, hi, pend_win, pen_en);
    spi_list("      同一刻处于 active（被 ack 了还没 EOI）：",
             widx, nw, lo, hi, act_at, pen_en);

    /* 把「新立起来的」汇总成一个号：只在恰好一个的时候才敢下结论 */
    unsigned hit[4]; int nh = 0;
    for (int i = 0; i < nw; i++) {
        uint32_t m = (pend_win[i] | act_at[i]) & ~pen_en[i] & spi_mask_in(lo, hi, widx[i]);
        for (unsigned s = lo; s <= hi; s++) {
            if ((int)(s / 32u) != widx[i]) continue;
            if ((m & (1u << (s % 32u))) && nh < 4) hit[nh++] = s;
        }
    }

    int drv_hit = 0;
    if (b0 != IRQ_LINE_NONE && a0 != IRQ_LINE_NONE && a0 > b0) drv_hit = 1;

    if (drv_hit)
        printf("  ✓ 驱动那行（80400000）的计数涨了 ⇒ **中断真的到了它申请的那条线上**，\n"
               "    dts 里写的 <0 0x1d 4>（GIC 61）是对的。这次测到的位%s。\n",
               nh == 1 ? "和它一致" : "可能与上面那条信号重叠，以计数为准");
    else if (nh == 1)
        printf("  ★ SPI %u 是这次 MM2S 完成唯一新立起来的位 ⇒ **IRQ_F2P[0]（mm2s_introut）的真身是 SPI %u**\n"
               "    ⇒ 设备树里应当写 interrupts = <0 %#x 4>（SPI %u − 32 = %u；现在写的是 0x1d = 61）\n"
               "    ⇒ 同规则推进：IRQ_F2P[3]（s2mm_introut）应当是 SPI %u，dts 里写 <0 %#x 4>\n",
               hit[0], hit[0], hit[0] - 32u, hit[0], hit[0] - 32u, hit[0] + 3u, hit[0] + 3u - 32u);
    else if (nh > 1)
        printf("  ⚠ 有多个位新立起来（%u 个，见上）—— 不能只挑一个当答案。多半是区间里\n"
               "    还有别的东西在动（F2P[1]/[2] 的 customop_irq / ai_irq）。收窄区间重跑：\n"
               "    --spi-lo=<其中一个> --spi-hi=<同一个>，一次只问一个位。\n", nh);
    else {
        printf("  ✗ 本区间内没有任何位新立起来。**这只排除了本区间，没有给出答案。**\n"
               "    两种可能，都要查过再下结论：\n"
               "      (a) 中断号不在 %u..%u 里 ⇒ 换区间重跑（--spi-lo= / --spi-hi=，\n"
               "          GICv2 的 SPI 只到 95，可以整段扫 32..95）\n"
               "      (b) 内核把它当成「无人认领的中断」处理掉了（ack 掉 + auto-mask），\n"
               "          我们读的时候已经不在 pending 上了 ⇒ 查\n"
               "            dmesg | grep -i 'nobody cared'   ← 那一行会直接点出 irq 号\n"
               "            grep -E 'GIC-400' /proc/interrupts\n", lo, hi);
    }
    return 0;
}

static void usage(const char *p)
{
    fprintf(stderr,
        "用法: %s <命令> [参数]\n"
        "  probe              只读写寄存器，验证 DMA 窗口通不通（先跑这个）\n"
        "  s2mm [字节数]       抓 dout 到一个缓冲（默认 %u，= 8 帧；走法按硬件自动选）\n"
        "  mm2s [字节数]       axi_dma_0 SG 模式灌 IQ（默认 %u）\n"
        "  e2e                 端到端一次调用（%u 进 / %u 出）。第一笔**故意给大于一帧**，\n"
        "                      看 DMA 是收到 TLAST 就收工还是老实收满；然后（除非 --one）\n"
        "                      把剩下的帧补收干净 —— 不补的话那些会堵在 IP 输出里，\n"
        "                      污染下一轮的判读\n"
        "  frames              收 8 帧（每帧 %u B）。**走法按硬件自动选**：有 SG 就 8 个\n"
        "                      描述符一次挂满（硬件自己一帧一个往下走），没有就一帧一挂\n"
        "  sync-probe          只探测 u-dma-buf 的同步 ioctl，挑出驱动认的那一个\n"
        "  ↓ 下面三条**只对真有 SG 引擎的通道有意义**。dma1 现在是 C_INCLUDE_SG=0，\n"
        "    S2MM 那组 CURDESC/TAILDESC 寄存器根本不存在；通道用错时程序会先打一行警告，\n"
        "    看到的是「没开跑」而不是通路坏了\n"
        "  sgprobe             **只问 SG 引擎**：四种挂法各试一次，看 CURDESC 动不动、\n"
        "                      硬件报不报 SG 错。不碰 MM2S、不需要 dout 有数据。\n"
        "                      用来把「描述符/挂法不对」和「引擎在等数据」分开\n"
        "  sg2                 把「挂」和「跑」拆开：只挂不跑时回读 CURDESC 看落没落住，\n"
        "                      再写尾指针按时间线采样 DMASR/CURDESC，最后把描述符 8 个字\n"
        "                      逐字 diff（把「硬件回写 STATUS」和「被别人改写」分开）。\n"
        "                      默认两个通道都跑（MM2S 的 SG 引擎以前从没单独测过）\n"
        "  carpet [格数]        **描述符地毯**：每 64 字节铺一个合法描述符再挂。\n"
        "                      有槽位被回写 -> 引擎读的是另一个地址（地址通路的问题，\n"
        "                      而且直接告出是哪个地址）；全都不动 -> 跟描述符内容无关，\n"
        "                      该上 ILA 了。格数默认按 udmabuf 大小算\n"
        "  irqscan [字节数]     **实测「IRQ_F2P 落到哪个 GIC SPI」**。⚠ 这条路 2026-10-15\n"
        "                      **已放弃**（见文件头第三次改动）：号查不到、实测又要跟驱动\n"
        "                      抢引擎；结果不再用于 dts，工具留着备查。厂商文件里查不到这个号，\n"
        "                      dts 里现在写的 61/64 是按 7z030 规则声明的。做法：PL 上来是\n"
        "                      电平型中断线，DMA 不清源就一直悬着；在 GIC 里把候选 SPI\n"
        "                      使能之后悬着的那位立刻 pending。三道信号（从便宜到贵）：\n"
        "                        (1) 跑一笔 MM2S 看 /proc/interrupts 里驱动那两行涨不涨\n"
        "                        (2) 使能区间后立刻读 pending（线本来就悬着的话不用跑 DMA）\n"
        "                        (3) 完成那一刻读 pending，只认比 (2) 新立起来的那一位\n"
        "                      全程只报「比基线变化的位」，不报「最像的那一位」；收尾会把\n"
        "                      新开的位关回去、使能掩码恢复原值、清掉 DMA 的 DMASR。\n"
        "                      ⚠ 它会在驱动也占着引擎的时候捅 MM2S 寄存器（这是刻意的：\n"
        "                        只为测号，不看数据）。跑完用 `mm2s` 再验一次数据通路。\n"
        "可选项:\n"
        "  --mm2s / --s2mm     sg2 / carpet 只测一个通道（默认两个都测）。\n"
        "                      ⚠ axi_dma_1 现在是 C_INCLUDE_SG=0（直读），它的 SG 半边测不了，\n"
        "                        sg2/carpet 里 S2MM 那一段只会报「引擎不认描述符」——\n"
        "                        那些子命令本来就是给 MM2S 用的\n"
        "  --carpet-slots=N    carpet 铺多少格（64 字节一格）\n"
        "  --xfer=N            sg2 每个描述符多少字节（默认：MM2S 8192 / S2MM 684）。\n"
        "                      **一次只改它一个**：板上 1024 字节的地毯走得通、8192 报\n"
        "                      SGIntErr，长度和环大小这两处必须分开验\n"
        "  --ring=N            sg2 的环铺几格（默认 2）\n"
        "  --carpet-len=N      carpet 每个描述符多少字节（默认 MM2S 1024 / S2MM 684）\n"
        "  --no-zero           sg2 挂之前不清描述符区（默认清 64KB）。\n"
        "                      PG021 说 SGIntErr = 引擎取到一条 **COMPLETE 已置位**的\n"
        "                     描述符（它当尾描述符、优雅停机，且此错不写回描述符）。\n"
        "                     清零就是为了把\"取到上一轮残留的旧描述符\"这条排除掉\n"
        "  --no-wait-halted 关掉「写 TAILDESC 前先等 DMASR.Halted 变 0」。**默认是等的**\n"
        "                   （PG021 Table 20：Halted 还是 1 时写尾指针不算开跑；\n"
        "                   BSP 的 XAxiDma_StartBdRingHw 也是先重读 DMASR.Halted 才写\n"
        "                   尾）。带上这个开关 = 退回「RS=1 之后立刻写尾」的老行为，\n"
        "                   跟 sgprobe 的 A 组一个意思，对比用\n"
        "  --dma0=0x...    MM2S 基址（默认 %#lx）\n"
        "  --dma1=0x...    S2MM 基址（默认 %#lx）\n"
        "  --gic=0x...     irqscan 用的 GICD 基址（默认 %#lx，取自 dts）\n"
        "  --spi-lo=N / --spi-hi=N  irqscan 扫哪一段 SPI（默认 %u..%u）。\n"
        "                  换区间重跑是「这次没测到」的正确下一步 —— GICv2 的 SPI 只到 95\n"
        "  --no-enable     irqscan 只读不写（一点扰动都不给）。代价：只能回答\n"
        "                  「驱动申请的 61/64 对不对」，问不出「真身是几号」\n"
        "  --buf-phys=0x.. 手工指定缓冲区物理地址\n"
        "  --in=文件        用文件内容当 MM2S 源数据\n"
        "  --alt-desc       改用 PG021 的 32bit 描述符布局\n"
        "  --buf-mem        缓冲区改走 /dev/mem 的非缓存映射（绕开 u-dma-buf 的缓存问题）\n"
        "  --no-evict       读结果前不挤缓存（默认会踩 8MiB 把 dst 顶出 cache；\n"
        "                   可缓存映射下不挤就永远只看到自己写的 0xA5）\n"
        "  【走法默认是自动的】启动时读 S2MM DMASR 的 bit3(SGIncld)——那是 IP 参数\n"
        "                   C_INCLUDE_SG 的**回显**——自己决定走直读还是走描述符环。\n"
        "                   所以 BD 里那个开关开也好关也好，同一条命令行都能用\n"
        "  --simple         强制走直读模式（写 DA+LENGTH）。只在 axi_dma_1 的\n"
        "                   C_INCLUDE_SG=0 时才有用；跟硬件对不上会打警告\n"
        "  --sg             强制走 SG 描述符环（frames 用 8 格一次挂满）。同理，只在\n"
        "                   BD 里 C_INCLUDE_SG 打开时才有用。dma0(MM2S) 一直是 SG，不受它影响\n"
        "  --no-drain       frames 不做开头那次「冲掉上一轮残留输出」。SG 下这一步\n"
        "                   不是必须的，坏了也照样往下走；排查时用它把变量摘掉\n"
        "  --one            e2e 退回**老行为**：第一笔收到哪儿就收手，不把剩下 7 帧补收。\n"
        "                   留着 IP 输出里那 7 帧不排，专门用来复现「紧接着跑 frames，\n"
        "                   帧 1 只有 668/652」那个现象。**平时别用**\n"
        "  --slow-rearm     frames 每帧都软复位重挂（复现「每帧少 8 拍」那个老现象）。\n"
        "                   **隐含 --simple** —— 只有直读模式才有这个概念\n"
        "  --dst-shift=N    frames/e2e：S2MM 目标基址整体后挪 N 字节（默认 0）。\n"
        "                   **判别实验**：板上的洞永远落在「绝对偏移 ≡ 0 (mod 64)」，\n"
        "                   可帧起点自己不是 64 对齐（684 mod 64 = 44）。拿 `--dst-shift=32`\n"
        "                   再跑一次：洞变成 ≡ 32 ⇒ 量化跟着 S2MM_DA 走（DMA 自己在数\n"
        "                   第几个 64 B 块）；洞仍是 ≡ 0 ⇒ 跟 DA 无关，是系统地址那一层\n"
        "  --timeout=ms     超时（默认 %d）\n",
        p, CALL_OUT_BYTES, CALL_IN_BYTES, CALL_IN_BYTES, CALL_OUT_BYTES, FRAME_OUT_BYTES,
        (unsigned long)DEF_DMA0, (unsigned long)DEF_DMA1,
        (unsigned long)DEF_GICD, SPI_DEF_LO, SPI_DEF_HI, opt_timeout_ms);
}

int main(int argc, char **argv)
{
    uint64_t dma0 = DEF_DMA0, dma1 = DEF_DMA1;
    const char *cmd = NULL;
    uint32_t arg_len = 0;

    for (int i = 1; i < argc; i++) {
        char *a = argv[i];
        if (!strncmp(a, "--dma0=", 7))       dma0 = strtoull(a + 7, NULL, 0);
        else if (!strncmp(a, "--dma1=", 7))  dma1 = strtoull(a + 7, NULL, 0);
        else if (!strncmp(a, "--buf-phys=", 11)) buf_pa = strtoull(a + 11, NULL, 0);
        else if (!strncmp(a, "--in=", 5))    opt_infile = a + 5;
        else if (!strncmp(a, "--timeout=", 10)) opt_timeout_ms = atoi(a + 10);
        else if (!strcmp(a, "--alt-desc"))   opt_alt_desc = 1;
        else if (!strcmp(a, "--buf-mem"))    opt_buf_mem = 1;
        else if (!strcmp(a, "--no-evict"))   opt_evict = 0;
        /* --simple / --sg 现在都是**强制覆盖**：不加就按硬件 DMASR.SGIncld 自己选 */
        else if (!strcmp(a, "--simple"))   { opt_simple = 1; opt_mode_auto = 0; }
        else if (!strcmp(a, "--sg"))       { opt_simple = 0; opt_mode_auto = 0; }
        else if (!strcmp(a, "--mm2s"))       opt_chan = 1;
        else if (!strcmp(a, "--s2mm"))       opt_chan = 2;
        else if (!strncmp(a, "--carpet-slots=", 15))
            opt_carpet_slots = strtol(a + 15, NULL, 0);
        else if (!strncmp(a, "--xfer=", 7))  opt_xfer = strtol(a + 7, NULL, 0);
        else if (!strncmp(a, "--ring=", 7))  opt_ring = atoi(a + 7);
        else if (!strncmp(a, "--carpet-len=", 13))
            opt_carpet_len = strtol(a + 13, NULL, 0);
        else if (!strcmp(a, "--no-zero"))    opt_no_zero = 1;
        else if (!strcmp(a, "--no-drain"))   opt_no_drain = 1;
        else if (!strcmp(a, "--one"))        opt_one = 1;   /* e2e 退回"收一帧就收手"的老行为 */
        else if (!strncmp(a, "--dst-shift=", 12))
            opt_dst_shift = (uint32_t)strtoul(a + 12, NULL, 0);   /* 判别实验，见定义处注释 */
        else if (!strcmp(a, "--wait-halted"))    opt_wait_halted = 1;
        else if (!strcmp(a, "--no-wait-halted")) opt_wait_halted = 0;
        /* --slow-rearm 是"直读模式 + 每帧软复位"，SG 下没有这个概念 —— 所以它隐含 --simple */
        else if (!strcmp(a, "--slow-rearm")) {
            opt_slow_rearm = 1; opt_simple = 1; opt_mode_auto = 0;
        }
        else if (!strncmp(a, "--gic=", 6))       opt_gic_base = strtoull(a + 6, NULL, 0);
        else if (!strncmp(a, "--spi-lo=", 9))    opt_spi_lo = strtol(a + 9, NULL, 0);
        else if (!strncmp(a, "--spi-hi=", 9))    opt_spi_hi = strtol(a + 9, NULL, 0);
        else if (!strcmp(a, "--no-enable"))      opt_no_enable = 1;
        else if (!strcmp(a, "-h") || !strcmp(a, "--help")) { usage(argv[0]); return 0; }
        else if (a[0] == '-') { fprintf(stderr, "未知参数 %s\n", a); usage(argv[0]); return 2; }
        else if (!cmd) cmd = a;
        else arg_len = (uint32_t)strtoul(a, NULL, 0);
    }

    if (!cmd) { usage(argv[0]); return 2; }

    setvbuf(stdout, NULL, _IOLBF, 0);
    printf("== pl_dma_test ==  （不改设备树，纯 /dev/mem + u-dma-buf，无中断）\n");

    reg0 = map_regs(dma0, "axi_dma_0");
    reg1 = map_regs(dma1, "axi_dma_1");
    udmabuf_open();
    printf("  描述符布局: %s\n", opt_alt_desc ? "PG021 32bit (BUFA@0x04)" : "BSP 64B (BUFA@0x08)");
    printf("  缓冲区来源: %s\n", opt_buf_mem ? "/dev/mem（非缓存）" : "/dev/udmabuf0（mmap）");
    printf("  读结果前挤缓存: %s\n", opt_evict ? "是（8MiB）" : "否（--no-evict）");

    /* ── 自己问硬件：S2MM 通道到底有没有 SG 引擎 ──────────────────────────
     * DMASR 的 bit3(SGIncld) 是 IP 参数 C_INCLUDE_SG 的**回显**，不是状态位 ——
     * 不用先复位，任何时候读都作数。板上实测：dma0(SG=1) 读回 0x00010009（bit3 置）、
     * dma1(SG=0) 读回 0x00000001（bit3 清），和 .xci 里的配置一一对上。
     * 这样 BD 里那个开关**开也好关也好，同一个二进制都能跑**，不用换命令行。 */
    uint32_t sr1 = rd(reg1, S2MM_SR);
    int hw_sg = (sr1 & SR_SGINCLD) != 0;

    if (opt_mode_auto && sr1 == 0xFFFFFFFFu) {
        /* 窗口没译码时 bit3 也是 F，信它等于瞎猜 —— 保留占位值，并明确说不知道 */
        printf("  S2MM 模式 : 判不出来（DMASR 读回全 F = AXI-Lite 没译码）。\n"
               "              先跑 `probe` 把底子坐实；下面按占位值（直读）走，多半会失败\n");
    } else if (opt_mode_auto) {
        opt_simple = hw_sg ? 0 : 1;
        printf("  S2MM 模式 : %s  <- 硬件自己说的（DMASR=%#010x，bit3 SGIncld=%d）\n",
               hw_sg ? "SG 描述符环（CURDESC/TAILDESC）" : "直读模式（写 DA+LENGTH）",
               sr1, hw_sg);
    } else {
        printf("  S2MM 模式 : %s  <- 命令行强制的（硬件 DMASR=%#010x 说 bit3=%d）\n",
               opt_simple ? "直读模式（写 DA+LENGTH）" : "SG 描述符环（CURDESC/TAILDESC）",
               sr1, hw_sg);
        /* 强制走法和硬件对不上 ⇒ 必失败，而且失败得很安静（只会一路超时） */
        if ((hw_sg && opt_simple) || (!hw_sg && !opt_simple))
            printf("      !! 这跟硬件对不上！多半一路超时。去掉 --sg/--simple 让它自己选\n");
    }
    if (opt_simple && opt_slow_rearm)
        printf("      每帧软复位重挂（--slow-rearm）：复现「每帧少 8 拍」那个老现象用\n");

    /* ── SG 专用子命令，先验一下那个引擎在不在 ─────────────────────────────
     * dma1 的 C_INCLUDE_SG 关掉之后，S2MM 那组 CURDESC/TAILDESC 寄存器**根本不存在**。
     * sg2/carpet/sgprobe 往里写不会报错，只会打出一片「没开跑」—— 那是命令用错了
     * 通道，不是 SG 通路坏了。两种情况的输出长得一模一样，所以这里先说明白。 */
    if (!strcmp(cmd, "sg2") || !strcmp(cmd, "carpet") || !strcmp(cmd, "sgprobe")) {
        uint32_t m0 = rd(reg0, MM2S_SR);

        if (m0 == 0xFFFFFFFFu || sr1 == 0xFFFFFFFFu) {
            /* 全 F 是"没译码"，不是"没 SG 引擎" —— 两者别混，混了就是假判读 */
            printf("  !! 这是 SG 专用命令，但 %s 的 DMASR 读回全 F（AXI-Lite 没译码），\n"
                   "     判不出有没有 SG 引擎。先跑 `probe` 把底子坐实。\n",
                   (m0 == 0xFFFFFFFFu) ? "axi_dma_0(MM2S)" : "axi_dma_1(S2MM)");
        } else {
            int sg0 = (m0 & SR_SGINCLD) != 0;
            int sg1 = (sr1 & SR_SGINCLD) != 0;

            if (!sg0 || !sg1)
                printf("  !! 这是 SG 专用命令，但 %s 没有 SG 引擎（DMASR bit3=0）：\n"
                       "     那个通道的 CURDESC/TAILDESC 寄存器不存在，写进去什么都不会发生。\n"
                       "     跑出来会是一片「没开跑」—— 那是命令用错了通道，不是 SG 通路坏了。\n",
                       (!sg0 && !sg1) ? "两个通道都"
                                      : (sg0 ? "axi_dma_1(S2MM)" : "axi_dma_0(MM2S)"));
        }
    }

    if (!strcmp(cmd, "probe"))
        return cmd_probe();

    if (!strcmp(cmd, "sync-probe")) {
        if (sync_via_sysfs) {
            printf("同步走 sysfs：/sys/class/u-dma-buf/%s/sync_for_{cpu,device}\n",
                   UDMABUF_NAME);
            return 0;
        }
        return sync_pick >= 0 ? 0 : 1;
    }

    if (!strcmp(cmd, "s2mm")) {
        uint32_t len = arg_len ? arg_len : CALL_OUT_BYTES;
        long got = do_s2mm(0, len, 0);
        if (got < 0) return 1;
        hexdump("S2MM 目标缓冲", buf_va + DST_OFF, got < 64 ? (size_t)got : 64);
        if (got >= (long)FRAME_OUT_BYTES * 2)
            check_frames_out(buf_va + DST_OFF, got);
        return 0;
    }

    if (!strcmp(cmd, "mm2s")) {
        uint32_t len = arg_len ? arg_len : CALL_IN_BYTES;
        prepare_src(len);
        return do_mm2s(len) < 0 ? 1 : 0;
    }

    if (!strcmp(cmd, "sgprobe"))
        return cmd_sgprobe();

    if (!strcmp(cmd, "sg2"))
        return cmd_sg2(opt_chan) < 0 ? 1 : 0;

    if (!strcmp(cmd, "carpet"))
        return cmd_carpet(opt_chan, (long)arg_len) < 0 ? 1 : 0;

    if (!strcmp(cmd, "e2e"))
        return cmd_e2e();

    if (!strcmp(cmd, "frames"))
        return cmd_frames();

    if (!strcmp(cmd, "irqscan"))
        return cmd_irqscan(arg_len);

    fprintf(stderr, "未知命令 %s\n", cmd);
    usage(argv[0]);
    return 2;
}
