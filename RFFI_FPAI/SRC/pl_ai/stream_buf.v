
// AXI-Stream 从端(64bit IQ) -> HLS 输入字(33bit) + 帧切片
//
// 输出字格式与 RFFI_FFT_ConvNet 的 din_V_V 完全一致：
//   data_o[32]    = last（帧结束标记，HLS 内部 fin_V）
//   data_o[31:16] = Q
//   data_o[15:0]  = I
//
// 输入打包假设：64bit = 两对 IQ 以 16bit 为间隔交织
//   [15:0] = I0   [31:16] = Q0   [47:32] = I1   [63:48] = Q1
// 即 低32bit = {Q0,I0}、高32bit = {Q1,I1}，正好就是 HLS 要的高Q低I。
// 若实际交织顺序是每个 16bit 槽里 Q 在前，把下面 data_o 里
// [31:16]/[15:0] 与 [63:48]/[47:32] 两两对调即可。
//
// ── 帧切片（为什么必须有） ────────────────────────────────────────────────
// HLS 侧 rx_frame 的循环边界是**硬编码**的 256 字
//   (rx_frame.v:425  exitcond_fu_155_p2 = (i_reg_128 == 9'd256))，
// 且读满 256 字**不依赖** last：last 只把帧内剩余的字替换成 0
//   (rx_frame.v:191  if (fin_V && !exitcond) p_Val2_1_reg_139 <= 33'd0;)。
// 即：一次推理固定吃掉 256 个字，帧边界错一次，后面**全部错位且不报错**。
// 所以帧长必须在进 FIFO 之前由硬件钉死，本模块就是干这个的：
//
//   * 以**字数**为准切帧：每 256 字一帧，第 256 字的 bit32 强制为 1；
//   * 上游 s_tlast **提前**（不足 256 字）→ 补 0 补满 256 字，不吞掉下一帧的头；
//   * 上游 s_tlast **迟到/缺席**（超过 256 字）→ 忽略它，第 256 字照样切帧，
//     多出来的字顺延进下一帧（不丢数，但上游帧语义已经错位，属于上游违约）。
//
// 因为 256 是偶数、每个 beat 固定出 2 个字，帧边界**恒落在 beat 的第二个字**上。
// 假定 beat 用满 tkeep（无效字节按 0 处理），不支持"半 beat 结尾"。
module stream_buf #(
    parameter WORDS_PER_FRAME = 256     // 每帧 256 个字 = 256 对 IQ = 128 个 64bit beat
)(
    input               sclk,
    input               s_rst_n,
    input               s_tlast,
    input               s_tvalid,
    output wire         s_tready,
    input      [63:0]   s_tdata,
    input      [7:0]    s_tkeep,
    input               din_full,   // 下游（HLS 输入 FIFO）满
    //native output: 33bit {last, Q[31:16], I[15:0]}
    output wire [32:0]  data_o,
    output wire         data_valid  // 即 fifo_hls 的 wr_en
);

localparam CNT_W = $clog2(WORDS_PER_FRAME);

wire [63:0] tdata_m;    // tkeep 掩码后的数据
wire        wr_low;     // 本拍写入 beat 的低 32bit 字
wire        wr_high;    // 本拍写入 beat 的高 32bit 字
wire        wr_pad;     // 本拍写入补零字

reg  [CNT_W-1:0] wcnt;      // 本帧已写入 FIFO 的字数（0 .. WORDS_PER_FRAME-1）
reg         pending;        // 高 32bit 字待发
reg  [31:0] hi_r;           // 接收那一拍锁下来的高 32bit（{Q1,I1}）
reg         last_r;         // 待发的高字是否带 last（本 beat 正好把本帧写满）
reg         tlast_r;        // 本 beat 的上游 s_tlast
reg         padding;        // 补零阶段（上游帧不足一帧）

// tkeep 掩码：无效字节补 0（与 iq_decoder 一致）
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_tkeep
        assign tdata_m[i*8+:8] = s_tdata[i*8+:8] & {8{s_tkeep[i]}};
    end
endgenerate

// 本 beat 的高字正好是本帧第 WORDS_PER_FRAME 个字
wire last_beat = (wcnt == WORDS_PER_FRAME - 2);
// 补零补到本帧最后一字
wire pad_last  = padding & (wcnt == WORDS_PER_FRAME - 1);

// 一个 64bit beat 拆成两个字，低 32bit 先出；pending 时先把手上的高字推完，
// 因此数据通路不需要额外缓存，背压全靠 s_tready + din_full。
// 三个写使能互斥，且每个字的写使能都在自己那一拍判 full，符合 FIFO full 用法。
// 补零阶段不收新 beat（s_tready=0），上游 AXIS 自然会顶住。
assign s_tready   = s_rst_n & ~din_full & ~pending & ~padding;
assign wr_low     = s_tready & s_tvalid;
assign wr_high    = pending & ~din_full;
assign wr_pad     = padding & ~din_full;

assign data_valid = wr_low | wr_high | wr_pad;
// 高字必须用接收那一拍锁下来的 hi_r：beat 被接收后 tready 会拉低一拍，
// 此时上游有权把下一个 beat 摆上来，实时取 tdata 会串到下一个 beat 的高半字。
assign data_o     = wr_high ? {last_r, hi_r[31:16],   hi_r[15:0]}       // 字1 = {Q1,I1}
                  : wr_pad  ? {pad_last, 16'd0,       16'd0}            // 补零
                  :           {1'b0,     tdata_m[31:16], tdata_m[15:0]}; // 字0 = {Q0,I0}

always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n) begin
        wcnt    <= {CNT_W{1'b0}};
        pending <= 1'b0;
        hi_r    <= 32'd0;
        last_r  <= 1'b0;
        tlast_r <= 1'b0;
        padding <= 1'b0;
    end
    else if(wr_pad) begin
        // 一字一拍往本帧末尾补 0
        if(pad_last) begin
            wcnt    <= {CNT_W{1'b0}};
            padding <= 1'b0;
        end
        else
            wcnt <= wcnt + 1'b1;
    end
    else if(wr_high) begin
        pending <= 1'b0;
        if(last_r) begin
            wcnt   <= {CNT_W{1'b0}};    // 本帧刚写满，下一帧从 0 开始
            last_r <= 1'b0;
        end
        else begin
            wcnt <= wcnt + 1'b1;
            if(tlast_r) begin           // 上游帧提前结束 -> 补 0 补满整帧
                padding <= 1'b1;
                tlast_r <= 1'b0;
            end
        end
    end
    else if(wr_low) begin
        pending <= 1'b1;                // 还要发高字
        hi_r    <= tdata_m[63:32];      // 锁住本 beat 的高半字
        last_r  <= last_beat;
        tlast_r <= s_tlast;
        wcnt    <= wcnt + 1'b1;
    end
end

endmodule
