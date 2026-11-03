`timescale 1ns / 1ps
// ef_hist 自测：真实 ef_sqrt / cordic_atan_vl，8 帧。
// 直方图与 Python golden 对拍（CORDIC 与理想 sqrt/atan 有 ±1 LSB 差异，
// 正好落在阈值上的点会让 bin 挪一格，TB 允许并统计这类差异）；
// 矩累加与 TB 自己按实际 az 算的值必须逐位相同。
// 运行目录需要：gold_zn.hex、gold_hist.hex。
module tb_ef_hist;
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

    wire [4:0]  rd_addr;
    wire [8:0]  rd_data;
    wire [47:0] acc1, acc2, acc3, acc4;
    wire        done, busy;

    reg [31:0] zn   [0:2047];
    reg [31:0] gold [0:223];
    reg [31:0] src_word;

    reg [4:0] raddr;
    integer fi, k, errs, guard;
    integer nbad, nflip;
    integer fdut;

    // TB 侧按实际 az 累加
    reg [63:0] tacc1, tacc2, tacc3, tacc4;

    ef_hist dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .src_addr(src_addr), .src_i(src_i), .src_q(src_q),
        .sq_req(sq_req), .sq_in(sq_in), .sq_ack(sq_ack), .sq_out(sq_out),
        .at_req(at_req), .at_in(at_in), .at_ack(at_ack), .at_out(at_out),
        .rd_addr(raddr), .rd_data(rd_data),
        .acc1(acc1), .acc2(acc2), .acc3(acc3), .acc4(acc4),
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

    // 顶层 zn RAM 模型：1 拍读延迟
    always @(posedge clk)
        src_word <= zn[fi*256 + src_addr];

    assign src_i = src_word[15:0];
    assign src_q = src_word[31:16];

    always @(posedge clk) begin
        if (sq_ack) begin
            tacc1 <= tacc1 + sq_out;
            tacc2 <= tacc2 + sq_out * sq_out;
            tacc3 <= tacc3 + ((sq_out * sq_out) >> 12) * sq_out;
            tacc4 <= tacc4 + ((sq_out * sq_out) >> 12) * ((sq_out * sq_out) >> 12);
        end
    end

    initial begin
        $readmemh("gold_zn.hex", zn);
        $readmemh("gold_hist.hex", gold);
        fdut = $fopen("hist_dut.hex", "w");
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            tacc1 = 0; tacc2 = 0; tacc3 = 0; tacc4 = 0;
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
                $display("FAIL fi=%0d: timeout state=%0d in=%0d sqn=%0d atn=%0d",
                         fi, dut.state, dut.in_cnt, dut.sqn, dut.atn);
                errs = errs + 1;
            end else begin
                @(negedge clk);
                // 读 28 个计数
                nbad = 0; nflip = 0;
                for (k = 0; k < 28; k = k + 1) begin
                    raddr = k[4:0];
                    #1;
                    $fdisplay(fdut, "%03x", rd_data * 16);
                    if ((rd_data * 16) !== gold[fi*28 + k]) begin
                        nbad = nbad + 1;
                        if (nbad <= 6)
                            $display("  HISTDIFF fi=%0d k=%0d got=%0d exp=%0d",
                                     fi, raddr, rd_data * 16, gold[fi*28+k]);
                    end
                end
                if (nbad != 0) begin
                    $display("fi=%0d hist: %0d/28 entries differ (CORDIC LSB)", fi, nbad);
                    nflip = nflip + 1;
                end
                // 矩：必须与 TB 按实际 az 累加的一致
                if (acc1 !== tacc1[47:0] || acc2 !== tacc2[47:0] ||
                    acc3 !== tacc3[47:0] || acc4 !== tacc4[47:0]) begin
                    $display("fi=%0d MOMFAIL acc1 %0d/%0d acc2 %0d/%0d acc3 %0d/%0d acc4 %0d/%0d",
                             fi, acc1, tacc1, acc2, tacc2, acc3, tacc3, acc4, tacc4);
                    errs = errs + 1;
                end
                if (nbad == 0)
                    $display("fi=%0d OK (hist exact, moments exact)", fi);
            end
            repeat (6) @(negedge clk);
        end

        $fclose(fdut);
        $display("HIST TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #40000000;
        $display("HIST TIMEOUT fi=%0d state=%0d in=%0d sqn=%0d atn=%0d",
                 fi, dut.state, dut.in_cnt, dut.sqn, dut.atn);
        $finish;
    end
endmodule
