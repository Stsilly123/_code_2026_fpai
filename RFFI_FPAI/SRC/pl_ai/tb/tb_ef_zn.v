`timescale 1ns / 1ps
// ef_zn 自测：真实 ef_sqrt，8 帧。
// TB 自己从 expert_in.hex 累加 Σ(x²+q²) 喂给 DUT；zn 逐点、rms 逐帧与 golden 比对
// （要求逐位相同）。运行目录需要：expert_in.hex、gold_zn.hex、gold_rms.hex。
module tb_ef_zn;
    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    reg signed [39:0] sum_sq;
    wire [8:0]  src_addr;
    wire signed [15:0] src_i, src_q;
    wire        sq_req;
    wire [31:0] sq_in;
    wire        sq_ack;
    wire [16:0] sq_out;
    wire [7:0]  wr_addr;
    wire [31:0] wr_data;
    wire        wr_en;
    wire        rms_zero;
    wire [16:0] rms_q10;
    wire        done, busy;

    reg [31:0] raw  [0:2047];
    reg [31:0] gzn  [0:2047];
    reg [31:0] grms [0:7];
    reg [31:0] raw_word;
    reg [31:0] znout [0:2047];

    integer fi, k, errs, guard, nbad;
    reg signed [63:0] ssum;
    reg signed [15:0] xi, xq;
    reg signed [63:0] xi2, xq2;

    ef_zn dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .sum_sq(sum_sq),
        .src_addr(src_addr), .src_i(src_i), .src_q(src_q),
        .sq_req(sq_req), .sq_in(sq_in), .sq_ack(sq_ack), .sq_out(sq_out),
        .wr_addr(wr_addr), .wr_data(wr_data), .wr_en(wr_en),
        .rms_zero(rms_zero), .rms_q10(rms_q10),
        .done(done), .busy(busy)
    );

    ef_sqrt u_sqrt (
        .clk(clk), .rst_n(rst_n),
        .req(sq_req), .din(sq_in),
        .ack(sq_ack), .dout(sq_out)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk)
        raw_word <= raw[fi*256 + src_addr];

    assign src_i = raw_word[15:0];
    assign src_q = raw_word[31:16];

    always @(posedge clk)
        if (wr_en) znout[fi*256 + wr_addr] <= wr_data;

    initial begin
        $readmemh("expert_in.hex", raw);
        $readmemh("gold_zn.hex", gzn);
        $readmemh("gold_rms.hex", grms);
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            ssum = 0;
            for (k = 0; k < 256; k = k + 1) begin
                xi = $signed(raw[fi*256 + k][15:0]);
                xq = $signed(raw[fi*256 + k][31:16]);
                xi2 = $signed(xi) * $signed(xi);
                xq2 = $signed(xq) * $signed(xq);
                ssum = ssum + xi2 + xq2;
            end
            sum_sq = ssum[39:0];

            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            guard = 0;
            while (!done && guard < 100000) begin
                @(negedge clk);
                guard = guard + 1;
            end
            if (!done) begin
                $display("FAIL fi=%0d timeout state=%0d idx=%0d", fi, dut.state, dut.idx);
                errs = errs + 1;
            end else begin
                @(negedge clk);
                nbad = 0;
                if (rms_q10 !== grms[fi]) begin
                    $display("  RMSDIFF fi=%0d got=%0d exp=%0d", fi, rms_q10, grms[fi]);
                    nbad = nbad + 1;
                end
                for (k = 0; k < 256; k = k + 1) begin
                    if (znout[fi*256 + k] !== gzn[fi*256 + k]) begin
                        if (nbad < 6)
                            $display("  ZNDIFF fi=%0d k=%0d got=%04h/%04h exp=%04h/%04h",
                                     fi, k, znout[fi*256+k][15:0], znout[fi*256+k][31:16],
                                     gzn[fi*256+k][15:0], gzn[fi*256+k][31:16]);
                        nbad = nbad + 1;
                    end
                end
                if (nbad == 0) $display("fi=%0d OK (rms + 256 zn exact)", fi);
                else errs = errs + 1;
            end
            repeat (6) @(negedge clk);
        end

        $display("ZN TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #20000000;
        $display("ZN TIMEOUT fi=%0d state=%0d idx=%0d", fi, dut.state, dut.idx);
        $finish;
    end
endmodule
