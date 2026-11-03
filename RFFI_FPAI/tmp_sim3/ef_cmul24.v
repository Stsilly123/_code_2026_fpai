`timescale 1ns / 1ps
// Q12 复乘：24-bit 输入（累积量中间量），输出 24-bit Q12（饱和）。
// 3 乘法器结构；流水 3 拍：operand -> product -> result。
module ef_cmul24 (
    input  wire                clk,
    input  wire                rst_n,
    input  wire signed [23:0]  ar,
    input  wire signed [23:0]  ai,
    input  wire signed [23:0]  br,
    input  wire signed [23:0]  bi,
    output reg  signed [23:0]  pr,
    output reg  signed [23:0]  pi
);
    reg signed [23:0] ar_r, ai_r, br_r, bi_r;
    reg signed [47:0] p1, p2, p3;

    wire signed [48:0] re_adj = {p1[47], p1} - {p2[47], p2} + 49'sd2048;
    wire signed [48:0] im_adj = {p3[47], p3} - {p1[47], p1} - {p2[47], p2} + 49'sd2048;
    wire signed [48:0] re_shr = re_adj >>> 12;
    wire signed [48:0] im_shr = im_adj >>> 12;

    always @(posedge clk) begin
        if (!rst_n) begin
            ar_r <= 24'sd0; ai_r <= 24'sd0; br_r <= 24'sd0; bi_r <= 24'sd0;
            p1 <= 48'sd0; p2 <= 48'sd0; p3 <= 48'sd0;
            pr <= 24'sd0; pi <= 24'sd0;
        end else begin
            ar_r <= ar; ai_r <= ai; br_r <= br; bi_r <= bi;
            p1 <= ar_r * br_r;
            p2 <= ai_r * bi_r;
            p3 <= (ar_r + ai_r) * (br_r + bi_r);

            pr <= (re_shr > 49'sd8388607)  ? 24'sd8388607 :
                  (re_shr < -49'sd8388608) ? -24'sd8388608 : re_shr[23:0];
            pi <= (im_shr > 49'sd8388607)  ? 24'sd8388607 :
                  (im_shr < -49'sd8388608) ? -24'sd8388608 : im_shr[23:0];
        end
    end
endmodule
