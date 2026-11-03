
// 顶层：射�?? IQ 数据通路
//   AXI-Stream(64bit IQ) -> stream_buf(帧切�?? + 拆成 33bit {last,Q,I}) -> fifo_hls(33bit/FWFT)
//   -> RFFI_FFT_ConvNet_0 (HLS：FFT + ConvNet 推理)
//   -> dout �??�?? AXI-Stream master(32bit，带 TLAST) 输出
//
// �??次推理的输入契约（从 IP �?? RTL 读出，不是推断）�??
//   * 每次调用固定 **8 �??**   —�?? imp.v  bound_minus_1 = (4'd8 - 4'd1)
//   * 每帧固定 **256 个字**   —�?? rx_frame.v  i < SEG_LEN(256)
//   �?? 2048 �?? = 2048 �?? IQ = 1024 �?? 64bit beat�??
//   帧间�?? last 只用�??"本帧剩下的字�?? 0"�??**不会**改变每帧 256 字的消费量，
//   �??以帧边界�?? stream_buf 按字数钉死；只要字数连续�??
//   �?? 2048 字自然是�??次调用，不需要在顶层再做调用级的对齐�??
//
// 输出契约�??2026-10-15 起的复合流；出处 SRC/top.hpp:295-298 �?? top.cpp:113-146）：
//   �?? IP �?? tok_out_V_V / logits_out_V_V 两条流已合并�??**�??�??** dout�??
//     * �??�?? 32bit（TDATA_NUM_BYTES=4），TKEEP/TSTRB �?? 4'hF（零信息量）�??
//     * 每帧 **171 �?? = 684 B**：拍 0..95 �?? 96 �?? tok 拍（4 个连�?? INT8，小端）�??
//       �?? 96..170 �?? 75 �?? logits 拍（2 个连�?? INT16，小端）�??
//     * **TLAST 只在每帧�?? 170 �??**（logits 段最后一拍）�?? 1，其�?? 169 拍全 0�??
//     * �??次调�?? = 8 �?? = 1368 �?? = **5472 B**，共 8 �?? TLAST�??
//   �?? �?? IP 的死锁在这里消失了：那时 logits_out_V_V_TREADY �?? BD 里恒 0�??
//     �?? ap_block_state3 �?? tok/logits 两个 ack_in �??起算�?? FSM �??"�??"�??
//     于是 IP 永远停在 state3、ap_idle 再不拉高。现在只有一条输出，
//     它的 TREADY �?? axi_dma_1 �?? s_axis_s2mm_tready，不会再被憋死�??
//
// 复位极�?�：全链路同�?? sclk、s_rst_n 低有效�??
//   * 新版 IP �?? ap_rst_n（低有效，component.xml POLARITY ACTIVE_LOW），直接�?? s_rst_n�??
//   * fifo_generator_hls �?? srst �??**高有效同步复�??**，所以取反�??
//
// ap 控制：由本模块内部完成，不对外暴露（外面只管�?? AXIS、收�??�?? AXIS）�??
//   * IP �?? ap_idle �?? `~ap_start & state1` �??**组合**输出（RFFI_FFT_ConvNet.v:421），
//     直接拿它当启动条件会�?? ap_start 成组合环，所以先打一拍再用；
//   * ap_start 必须�??**脉冲**（state1 的组合转移条件），这里由寄存�?? ip_idle_r 产生�??
//     发出去后 IP 立刻离开 state1 -> ip_idle_r 自动�?? 0 -> 恰好 1 拍脉冲�??
//   * 启动条件：IP 空闲 �?? 输入 FIFO 里至少有 1 整帧。够 1 帧就启动�??
//     IP 每帧只吃 256 字（平均 ~1 �?? / 9.9 拍），跟不上时由 s_tready 反压上游�??
module Signal_process(
    // 接口属�?�：BD 靠这几个属�?�才知道 AXIS 接口挂在 sclk 上�?�FREQ_HZ �?? 200MHz�??
    // 少了它们 Vivado 会按默认 100MHz 推断 -> [BD 41-967] + [BD 41-237]
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sclk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sclk, ASSOCIATED_BUSIF s:dout:eq:expert, ASSOCIATED_RESET s_rst_n, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0" *)
    input               sclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_rst_n RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
    input               s_rst_n,
    // AXI-Stream 从端�??64bit IQ
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TDATA" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0" *)
    input      [63:0]   s_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TKEEP" *)
    input      [7:0]    s_tkeep,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TVALID" *)
    input               s_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TLAST" *)
    input               s_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TREADY" *)
    output              s_tready,
    // HLS 输出流：tok + logits 合并后的�??�?? 32bit 复合流，每帧�?? 170 拍有 TLAST�??
    //
    // ⚠️ HAS_TKEEP/HAS_TLAST 必须�?? axi_dma_1 �?? S_AXIS_S2MM 声明**完全�??�??**�??
    //    而且**不能多出成员**：DMA 侧是 HAS_TKEEP 1 / HAS_TLAST 1 / 没有 TSTRB�??
    //    上一版正是源端写�?? HAS_TKEEP 0 / HAS_TLAST 0，标志不匹配�??
    //    Vivado 就把 s_axis_s2mm_tkeep / _tlast 撂在空中没连（ps_ai.hwh 里没 SIGNAME）�??
    //    �??以这�?? HAS_TSTRB �??律写 0，dout_TSTRB 不做成模块端口，在内部接�??�??
    //    不用�?? wire（恒 4'hF，AXI DMA 也不看，综合会剪掉）�??
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TDATA" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dout, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0" *)
    output [31:0]       dout_TDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TVALID" *)
    output              dout_TVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TREADY" *)
    input               dout_TREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TKEEP" *)
    output [3:0]        dout_TKEEP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TLAST" *)
    output              dout_TLAST,
    // L-STF 均衡器输出（32bit {Q,I}，每帧 256 字，TLAST 在帧末）
    // 旁路帧（门控失败或信道全零）原样输出，eq_tuser=1
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TDATA" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME eq, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0" *)
    output [31:0]       eq_TDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TVALID" *)
    output              eq_TVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TREADY" *)
    input               eq_TREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TKEEP" *)
    output [3:0]        eq_TKEEP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TLAST" *)
    output              eq_TLAST,
    // 旁路标志（不是 AXIS 信号，BD 里可悬空）：1 = 本帧未均衡
    output              eq_tuser,
    // 诊断口（BD 里可悬空，或接 ILA）
    output [31:0]       eq_stat_drop,
    output [22:0]       eq_stat_theta,
    output              eq_stat_gate,
    output              eq_busy,
    // Expert (193-dim feature) AXIS: 32bit, 256 words/frame, TLAST on word 255
    // 8 frames per DMA transfer = 8192 B
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TDATA" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME expert, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0" *)
    output [31:0]       expert_TDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TVALID" *)
    output              expert_TVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TREADY" *)
    input               expert_TREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TKEEP" *)
    output [3:0]        expert_TKEEP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TLAST" *)
    output              expert_TLAST,
    // Expert diagnostics (may be left unconnected in BD)
    output [31:0]       expert_stat_drop,
    output [31:0]       expert_stat_frames,
    output              expert_busy
);

localparam WORDS_PER_FRAME = 256;   // 每帧 256 字（IP 内部硬编码）
localparam N_FRAMES        = 8;     // �??次调�?? 8 帧（IP 内部硬编码）
localparam START_THRESHOLD = WORDS_PER_FRAME;   // FIFO 里攒够一帧就启动�??�??

wire [32:0] hls_din;
wire        hls_wr;
wire [32:0] hls_dout;
wire        hls_rd;
wire        hls_full;
wire        hls_empty;

wire        ap_idle;    // 只用它判空闲；ap_done/ap_ready 顶层不需要，悬空
wire        ap_start;

wire [3:0]  dout_tstrb_unused;  // IP �?? TSTRB �?? 4'hF、且 axi_dma_1 没有这个口，不引�??

// AXIS(64bit) -> 33bit {last, Q[31:16], I[15:0]}，同时在�?? FIFO 前按 256 字切�??
stream_buf #(
    .WORDS_PER_FRAME (WORDS_PER_FRAME)
) u_stream_buf (
    .sclk       (sclk),
    .s_rst_n    (s_rst_n),
    .s_tlast    (s_tlast),
    .s_tvalid   (s_tvalid),
    .s_tready   (s_tready),
    .s_tdata    (s_tdata),
    .s_tkeep    (s_tkeep),
    .din_full   (hls_full),
    .data_o     (hls_din),
    .data_valid (hls_wr)
);

// HLS 输入 FIFO�??33bit × 512、FWFT、Common_Clock、高有效同步 srst�??
// FWFT：empty 撤销�?? dout 即为当前字，din_V_V_read �??拍弹出；empty 是寄存输出，
// 不会�?? IP 内部 "empty_n -> read" 的组合路径成环�??
`ifndef LSTF_EQ_SIM
fifo_generator_hls u_fifo_hls(
    .clk   (sclk),
    .srst  (~s_rst_n),
    .din   (hls_din),
    .wr_en (hls_wr),
    .rd_en (hls_rd),
    .dout  (hls_dout),
    .full  (hls_full),
    .empty (hls_empty)
);
`else
// 仿真桩：fifo_generator 的 IP 没有行为模型，这里给"永不满、永远空"
assign hls_full  = 1'b0;
assign hls_empty = 1'b1;
`endif

// �??�?? FIFO 字数记账 �??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??
// 这个 FIFO 没开 data count 端口（C_HAS_DATA_COUNT=0），自己数进/出�??
// 两个计数器自由回绕，(wr - rd) 就是当前 FIFO 里的字数（深�?? 512 < 2^16，恒正确）�??
reg  [15:0] wr_words;
reg  [15:0] rd_words;
wire [15:0] avail_words = wr_words - rd_words;

always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n)
        wr_words <= 16'd0;
    else if(hls_wr)
        wr_words <= wr_words + 1'b1;
end

always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n)
        rd_words <= 16'd0;
    else if(hls_rd & ~hls_empty)    // 空读不计数（IP 不会空读，这里只是兜底）
        rd_words <= rd_words + 1'b1;
end

// �??�?? ap_start / ap_done 管理 �??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??�??
// ap_idle 组合依赖 ap_start，先打一拍再参与启动判决，避免组合环�??
reg ip_idle_r;

always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n)
        ip_idle_r <= 1'b0;
    else
        ip_idle_r <= ap_idle;
end

// IP 回到 state1（空闲）�?? FIFO 里至少有 1 整帧 -> �?? 1 拍启动脉冲�??
// 上一轮算完（state3 -> state1）后自动重新武装；下游不收结果时 IP 会停�?? state3�??
// ap_idle 不拉高，这里也就不会再启动，整条链自然被下游反压住�??
assign ap_start = ip_idle_r & (avail_words >= START_THRESHOLD);

// HLS 推理�??
// RFFI_FFT_ConvNet_0 u_rffi_fft_convnet_0(
//     .ap_clk               (sclk),
//     .ap_rst_n             (s_rst_n),          // 低有效，�?? s_rst_n 同极性，直接�??
//     .ap_start             (ap_start),
//     // ap_done / ap_ready 不用，直接不接（顶层�?? ap_idle 判空闲就够）
//     .ap_idle              (ap_idle),
//     .din_V_V_dout         (hls_dout),
//     .din_V_V_empty_n      (~hls_empty),
//     .din_V_V_read         (hls_rd),
//     .dout_TDATA           (dout_TDATA),
//     .dout_TVALID          (dout_TVALID),
//     .dout_TREADY          (dout_TREADY),
//     .dout_TKEEP           (dout_TKEEP),
//     .dout_TLAST           (dout_TLAST),
//     .dout_TSTRB           (dout_tstrb_unused)
// );

`ifndef LSTF_EQ_SIM
LcwtMLP_RFFI_0 u_rffi_Lcwt_0 (
  .ap_clk(sclk),                    // input wire ap_clk
  .ap_rst_n(s_rst_n),                // input wire ap_rst_n
  .ap_start(ap_start),                // input wire ap_start
  .ap_idle(ap_idle),                  // output wire ap_idle
  .din_V_V_dout(hls_dout),        // input wire [32 : 0] din_V_V_dout
  .din_V_V_empty_n(~hls_empty),  // input wire din_V_V_empty_n
  .din_V_V_read(hls_rd),        // output wire din_V_V_read
  .dout_TVALID(dout_TVALID),          // output wire dout_TVALID
  .dout_TREADY(dout_TREADY),          // input wire dout_TREADY
  .dout_TDATA(dout_TDATA),            // output wire [31 : 0] dout_TDATA
  .dout_TLAST(dout_TLAST),            // output wire [0 : 0] dout_TLAST
  .dout_TKEEP(dout_TKEEP),            // output wire [3 : 0] dout_TKEEP
  .dout_TSTRB(dout_tstrb_unused)            // output wire [3 : 0] dout_TSTRB
);
`else
// 仿真桩：HLS IP 没有行为模型，dout 拉 0，不读 FIFO
assign ap_idle     = 1'b0;
assign hls_rd      = 1'b0;
assign dout_TDATA  = 32'd0;
assign dout_TVALID = 1'b0;
assign dout_TKEEP  = 4'd0;
assign dout_TLAST  = 1'b0;
`endif

// ── L-STF 均衡器 ────────────────────────────────────────────────────────────
// 直接吃 stream_buf 吐出的 IQ 字（{Q[31:16], I[15:0]}），不再单开一路 stream；
// 按 256 字切帧，与输入帧严格一一对应。HLS 那条路照旧并行工作。
lstf_eq u_lstf_eq (
    .clk         (sclk),
    .rst_n       (s_rst_n),
    .din         (hls_din[31:0]),
    .din_valid   (hls_wr),
    .m_tdata     (eq_TDATA),
    .m_tvalid    (eq_TVALID),
    .m_tready    (eq_TREADY),
    .m_tkeep     (eq_TKEEP),
    .m_tlast     (eq_TLAST),
    .m_tuser     (eq_tuser),
    .stat_drop   (eq_stat_drop),
    .stat_theta  (eq_stat_theta),
    .stat_gate   (eq_stat_gate),
    .busy        (eq_busy)
);

// -- Expert feature extractor --------------------------------------------------
// Same tap point as lstf_eq: hls_din[31:0] / hls_wr from stream_buf.
// Independent of the equalizer output; the 256-word frame boundary is cut
// internally (din_last only resynchronizes the word counter).
expert_feat_rffi u_expert (
    .clk               (sclk),
    .rst_n             (s_rst_n),
    .din               (hls_din[31:0]),
    .din_valid         (hls_wr),
    .din_last          (hls_din[32]),
    .m_tdata           (expert_TDATA),
    .m_tvalid          (expert_TVALID),
    .m_tready          (expert_TREADY),
    .m_tlast           (expert_TLAST),
    .m_tkeep           (expert_TKEEP),
    .stat_drop         (expert_stat_drop),
    .stat_frames       (expert_stat_frames),
    .busy              (expert_busy)
);

endmodule
