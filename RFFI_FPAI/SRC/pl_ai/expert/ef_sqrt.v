`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_sqrt : 32-bit 无符号整数 -> 最近整数平方根（17-bit），与黄金模型
//           sqrt_nearest 完全一致。
//
//   digit-by-digit 逐位开方，流水 16 级（每级吃 2 bit），最后一级舍入：
//     k = floor(sqrt(n))，rem = n - k^2，rem > k 时输出 k+1。
//   （整数输入下 n-k^2 不可能恰好等于 k+0.25，故不存在 0.5 平局）
//
//   接口与 cordic_vl.vhd 的 cordic_sqrt_vl 同义：req 单拍，18 拍后 ack 单拍，
//   dout 同时有效。吞吐 1/拍。
//   （原为 17 拍；第 16 级只落 root/rem 寄存器，舍入另起一拍。见下方 rootf_r。）
//
//   不用 CORDIC sqrt 的原因：实测该 IP 输出并非“最近整数”，在 2048 个真实
//   样点里有 267 个差 1（如 sqrt(1500)=38.73 出 38），无法与黄金模型逐位对上。
// -----------------------------------------------------------------------------
module ef_sqrt (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        req,
    input  wire [31:0] din,
    output reg         ack,
    output reg  [16:0] dout
);
    reg [31:0] din_p  [0:15];
    reg [15:0] root_p [0:15];
    reg [16:0] rem_p  [0:15];
    reg [15:0] vld;

    wire [1:0]  pair   [0:15];
    wire [18:0] rem2   [0:15];
    wire [16:0] root_s [0:15];      // root<<1
    wire [17:0] test   [0:15];      // 2*(root<<1)+1 = 4*root+1
    wire        ge     [0:15];
    wire [18:0] remn   [0:15];
    wire [16:0] rootn  [0:15];

    genvar g;
    generate
        for (g = 0; g < 16; g = g + 1) begin : gen_stage
            assign pair[g]   = din_p[g][31:30];
            assign rem2[g]   = {rem_p[g], pair[g]};       // rem<<2 | pair
            assign root_s[g] = {root_p[g], 1'b0};         // root<<1
            assign test[g]   = {root_s[g], 1'b1};         // (root<<1)<<1 | 1
            assign ge[g]     = (rem2[g] >= {1'b0, test[g]});
            assign remn[g]   = ge[g] ? (rem2[g] - {1'b0, test[g]}) : rem2[g];
            assign rootn[g]  = ge[g] ? (root_s[g] | 17'd1) : root_s[g];
        end
    endgenerate

    // 第 16 级先只把 bit-15 的商/余数落寄存器，舍入（比较 + 加 1）放到下一拍。
    // 原来 rem_p[15] -> ge/remn/rootn -> dout_c 一整条 11 级链（4.835 ns）还要
    // 穿过模块边界，被 hist 平方 DSP 的 AREG 吸收当输入，端点直接落在 DSP A 口，
    // 整版 -0.092 ns。拆开后：级内逻辑 -> rootf_r/remf_r，舍入 -> dout。
    reg  [16:0] rootf_r, remf_r;
    reg         vld16;
    wire [16:0] rootf  = rootn[15];
    wire [16:0] remf   = remn[15][16:0];
    wire [16:0] dout_c = (remf_r > rootf_r) ? (rootf_r + 17'd1) : rootf_r;

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            vld <= 16'd0;
            vld16 <= 1'b0;
            ack <= 1'b0;
            dout <= 17'd0;
            rootf_r <= 17'd0; remf_r <= 17'd0;
            for (i = 0; i < 16; i = i + 1) begin
                din_p[i]  <= 32'd0;
                root_p[i] <= 16'd0;
                rem_p[i]  <= 17'd0;
            end
        end else begin
            vld[0]    <= req;
            din_p[0]  <= din;
            root_p[0] <= 16'd0;
            rem_p[0]  <= 17'd0;
            for (i = 1; i < 16; i = i + 1) begin
                vld[i]    <= vld[i-1];
                din_p[i]  <= din_p[i-1] << 2;
                root_p[i] <= rootn[i-1][15:0];   // 中间级 root < 2^15
                rem_p[i]  <= remn[i-1];
            end
            vld16   <= vld[15];
            rootf_r <= rootf;
            remf_r  <= remf;
            ack     <= vld16;
            dout    <= dout_c;
        end
    end

endmodule
