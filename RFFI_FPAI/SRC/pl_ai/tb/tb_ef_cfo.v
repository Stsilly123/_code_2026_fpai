`timescale 1ns / 1ps
// ef_cfo 自测：真实 ef_sqrt / cordic_atan_vl，8 帧，对拍 gold_cfo.hex。
//   角度（ang20/ang1/b0..b3）容差 ±2 LSB(Q12)；bstd ±2 LSB；
//   幅度 mag20/mag1 用相对容差 max(4, |exp|>>12)（CORDIC sqrt 舍入）。
// 运行目录需要：gold_zn.hex、gold_cfo.hex。
module tb_ef_cfo;
    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    wire [8:0] src_addr;
    wire signed [15:0] src_i, src_q;

    wire        sq_req, at_req;
    wire [31:0] sq_in, at_in;
    wire        sq_ack, at_ack;
    wire [16:0] sq_out;
    wire signed [15:0] at_out;

    wire signed [31:0] ang20, mag20, ang1, mag1;
    wire signed [31:0] b0, b1, b2, b3, bstd;
    wire done, busy;

    reg [31:0] zn   [0:2047];
    reg [31:0] gold [0:71];
    reg [31:0] src_word;

    integer fi, k, errs, guard, nbad;
    integer fdut;

    ef_cfo dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .src_addr(src_addr), .src_i(src_i), .src_q(src_q),
        .sq_req(sq_req), .sq_in(sq_in), .sq_ack(sq_ack), .sq_out(sq_out),
        .at_req(at_req), .at_in(at_in), .at_ack(at_ack), .at_out(at_out),
        .ang20(ang20), .mag20(mag20), .ang1(ang1), .mag1(mag1),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3), .bstd(bstd),
        .done(done), .busy(busy)
    );

    ef_sqrt u_sqrt (
        .clk(clk), .rst_n(rst_n),
        .req(sq_req), .din(sq_in),
        .ack(sq_ack), .dout(sq_out)
    );

    cordic_atan_vl u_atan (
        .aclk(clk), .aresetn(rst_n),
        .s_axis_cartesian_tvalid(at_req),
        .s_axis_cartesian_tdata(at_in),
        .m_axis_dout_tvalid(at_ack),
        .m_axis_dout_tdata(at_out)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk)
        src_word <= zn[fi*256 + src_addr];

    assign src_i = src_word[15:0];
    assign src_q = src_word[31:16];

    task chk;
        input integer idx;
        input signed [31:0] got;
        input signed [31:0] exp;
        input integer tol;
        reg signed [33:0] d;
        begin
            d = got - exp;
            if (d > tol || d < -tol) begin
                $display("  CFODIFF fi=%0d idx=%0d got=%0d exp=%0d diff=%0d",
                         fi, idx, got, exp, d);
                nbad = nbad + 1;
            end
        end
    endtask

    initial begin
        $readmemh("gold_zn.hex", zn);
        $readmemh("gold_cfo.hex", gold);
        fdut = $fopen("cfo_dut.hex", "w");
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        // DSP48E1 是原语，仿真里 glbl.GSR 前 100 ns 会把它的 P 寄存器按死；
        // 等过这段时间再发第一帧，否则第 0 帧会丢头几拍的累加（只影响仿真）。
        repeat (30) @(posedge clk);
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            guard = 0;
            while (!done && guard < 200000) begin
                @(negedge clk);
                guard = guard + 1;
            end
            if (!done) begin
                $display("FAIL fi=%0d: timeout state=%0d t=%0d cyc=%0d sqc=%0d atc=%0d",
                         fi, dut.state, dut.t, dut.cyc, dut.sqc, dut.atc);
                errs = errs + 1;
            end else begin
                @(negedge clk);
                nbad = 0;
                chk(0, ang20, gold[fi*9 + 0], 2);
                chk(1, mag20, gold[fi*9 + 1], (mag20 > 0 ? (mag20 >> 12) : 4) + 4);
                chk(2, ang1,  gold[fi*9 + 2], 2);
                chk(3, mag1,  gold[fi*9 + 3], (mag1 > 0 ? (mag1 >> 12) : 4) + 4);
                chk(4, b0,    gold[fi*9 + 4], 2);
                chk(5, b1,    gold[fi*9 + 5], 2);
                chk(6, b2,    gold[fi*9 + 6], 2);
                chk(7, b3,    gold[fi*9 + 7], 2);
                chk(8, bstd,  gold[fi*9 + 8], 2);

                $fdisplay(fdut, "%08h %08h %08h %08h %08h %08h %08h %08h %08h",
                          ang20, mag20, ang1, mag1, b0, b1, b2, b3, bstd);

                if (nbad == 0) $display("fi=%0d OK (cfo within tol)", fi);
                else errs = errs + 1;
            end
            repeat (6) @(negedge clk);
        end

        $fclose(fdut);
        $display("CFO TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #40000000;
        $display("CFO TIMEOUT fi=%0d state=%0d t=%0d cyc=%0d sqc=%0d atc=%0d",
                 fi, dut.state, dut.t, dut.cyc, dut.sqc, dut.atc);
        $finish;
    end
endmodule
