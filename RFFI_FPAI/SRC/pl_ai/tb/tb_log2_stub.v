`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_log2_stub : log2_lut_rom 的仿真行为模型
//   （Vivado 的 BRAM IP 默认没有行为模型；真 IP 是 1024x36，2 拍读）
//   tb_expert_feat / tb_expert_feat_stress 共用，只编译一次。
// -----------------------------------------------------------------------------
module log2_lut_rom (
    input  wire        clka,
    input  wire        ena,
    input  wire [9:0]  addra,
    output reg  [35:0] douta
);
    reg [35:0] mem [0:1023];
    reg [35:0] q1;
    initial $readmemh("log2_lut.hex", mem);
    always @(posedge clka) begin
        if (ena) begin
            q1    <= mem[addra];
            douta <= q1;
        end
    end
endmodule
