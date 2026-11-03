`timescale 1ns / 1ps
// Q12 复乘（16-bit 输入，CFO 相关用），输出 24-bit Q12。
// 流水 3 拍。
module ef_cmul16 (
    input  wire                clk,
    input  wire                rst_n,
    input  wire signed [15:0]  ar,
    input  wire signed [15:0]  ai,
    input  wire signed [15:0]  br,
    input  wire signed [15:0]  bi,
    output reg  signed [23:0]  pr,
    output reg  signed [23:0]  pi
);
    reg signed [15:0] ar_r, ai_r, br_r, bi_r;
    reg signed [31:0] p1, p2, p3;

    wire signed [33:0] re_adj = {p1[31], p1} - {p2[31], p2} + 34'sd2048;
    wire signed [33:0] im_adj = {p3[31], p3} - {p1[31], p1} - {p2[31], p2} + 34'sd2048;
    wire signed [33:0] re_shr = re_adj >>> 12;
    wire signed [33:0] im_shr = im_adj >>> 12;

    always @(posedge clk) begin
        if (!rst_n) begin
            ar_r <= 16'sd0; ai_r <= 16'sd0; br_r <= 16'sd0; bi_r <= 16'sd0;
            p1 <= 32'sd0; p2 <= 32'sd0; p3 <= 32'sd0;
            pr <= 24'sd0; pi <= 24'sd0;
        end else begin
            ar_r <= ar; ai_r <= ai; br_r <= br; bi_r <= bi;
            p1 <= ar_r * br_r;
            p2 <= ai_r * bi_r;
            p3 <= (ar_r + ai_r) * (br_r + bi_r);

            pr <= (re_shr > 34'sd8388607)  ? 24'sd8388607 :
                  (re_shr < -34'sd8388608) ? -24'sd8388608 : re_shr[23:0];
            pi <= (im_shr > 34'sd8388607)  ? 24'sd8388607 :
                  (im_shr < -34'sd8388608) ? -24'sd8388608 : im_shr[23:0];
        end
    end
endmodule
