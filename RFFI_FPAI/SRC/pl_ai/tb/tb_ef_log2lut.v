`timescale 1ns / 1ps
// ef_log2lut 自测：随机/边界 64-bit p 对 log2_exp.hex。
// 仿真用 2 拍读延迟的 ROM stub；运行目录里要有 log2_lut.hex。
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

module tb_ef_log2lut;
    reg clk, rst_n, req;
    reg [63:0] p_in;
    wire ack, pzero, busy;
    wire signed [31:0] log2_q16;

    reg [63:0] pv  [0:216];
    reg [31:0] expv [0:216];
    integer i, errs, guard;

    ef_log2lut dut (
        .clk(clk), .rst_n(rst_n), .req(req), .p(p_in),
        .ack(ack), .pzero(pzero), .log2_q16(log2_q16), .busy(busy)
    );

    initial clk = 0;
    always #2.5 clk = ~clk;

    initial begin
        $readmemh("log2_p.hex", pv);
        $readmemh("log2_exp.hex", expv);
        rst_n = 0; req = 0; p_in = 0; errs = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (i = 0; i < 217; i = i + 1) begin
            @(negedge clk);
            req = 1; p_in = pv[i];
            @(negedge clk);
            req = 0;
            guard = 0;
            while (!ack && guard < 30) begin
                @(negedge clk);
                guard = guard + 1;
            end
            if (!ack) begin
                $display("FAIL p=%016h: no ack", pv[i]);
                errs = errs + 1;
            end else if (pzero || log2_q16 !== expv[i]) begin
                $display("FAIL p=%016h got=%08h exp=%08h pz=%b e=%0d idx=%0d douta=%09h lut=%0d sl=%0d",
                         pv[i], log2_q16, expv[i], pzero,
                         dut.e_d, dut.m_r[62:53], dut.douta, dut.lut_q16, dut.slope_q16);
                errs = errs + 1;
            end
            @(negedge clk);
        end

        // p=0 特例
        @(negedge clk);
        req = 1; p_in = 64'd0;
        @(negedge clk);
        req = 0;
        guard = 0;
        while (!ack && guard < 30) begin @(negedge clk); guard = guard + 1; end
        if (!ack || !pzero || log2_q16 !== 32'sd0) begin
            $display("FAIL p=0: ack=%b pz=%b val=%0d", ack, pzero, log2_q16);
            errs = errs + 1;
        end

        $display("LOG2 TB done: %0d errors", errs);
        $finish;
    end
endmodule
