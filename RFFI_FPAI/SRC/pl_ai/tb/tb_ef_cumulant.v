`timescale 1ns / 1ps
// ef_cumulant 自测：真实 ef_sqrt / cordic_atan_vl，8 帧。
//   - 帧尾原始 c 量（c20r,i c40r,i c41r,i c42 c60r,i c63）必须与 golden 逐位相同；
//   - 6 个模 / 6 个相允许 ±2 LSB（CORDIC 舍入 vs 理想 sqrt/atan2）。
// 运行目录需要：gold_zn.hex、gold_cum.hex、gold_cumraw.hex。
module tb_ef_cumulant;
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

    wire signed [31:0] mag0, mag1, mag2, mag3, mag4, mag5;
    wire signed [31:0] ang0, ang1, ang2, ang3, ang4, ang5;
    wire done, busy;

    reg [31:0] zn    [0:2047];
    reg [31:0] gold  [0:95];     // 12 值/帧：6 模 + 6 相
    reg [47:0] craw  [0:79];     // 10 值/帧
    reg [31:0] src_word;
    reg [47:0] cexp, cgot;
    reg signed [31:0] vgot, vexp;
    integer fi, k, errs, guard, nbad;
    integer fdut, fraw;

    ef_cumulant dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .src_addr(src_addr), .src_i(src_i), .src_q(src_q),
        .sq_req(sq_req), .sq_in(sq_in), .sq_ack(sq_ack), .sq_out(sq_out),
        .at_req(at_req), .at_in(at_in), .at_ack(at_ack), .at_out(at_out),
        .mag0(mag0), .mag1(mag1), .mag2(mag2), .mag3(mag3), .mag4(mag4), .mag5(mag5),
        .ang0(ang0), .ang1(ang1), .ang2(ang2), .ang3(ang3), .ang4(ang4), .ang5(ang5),
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

    // 当前帧原始 c 量（与 RTL 内部寄存器同刻，done 后一拍采样）
    task check_raw;
        input integer idx;
        input [47:0] got;
        input [47:0] exp;
        begin
            if (got !== exp) begin
                $display("  CUMRAW fi=%0d idx=%0d got=%0d exp=%0d",
                         fi, idx, $signed(got), $signed(exp));
                nbad = nbad + 1;
            end
        end
    endtask

    task check_feat;
        input integer idx;
        input signed [31:0] got;
        input signed [31:0] exp;
        reg signed [33:0] d;
        begin
            d = got - exp;
            if (d > 34'sd2 || d < -34'sd2) begin
                $display("  CUMDIFF fi=%0d idx=%0d got=%0d exp=%0d",
                         fi, idx, got, exp);
                nbad = nbad + 1;
            end
        end
    endtask

    initial begin
        $readmemh("gold_zn.hex", zn);
        $readmemh("gold_cum.hex", gold);
        $readmemh("gold_cumraw.hex", craw);
        fdut = $fopen("cum_dut.hex", "w");
        fraw = $fopen("cumraw_dut.hex", "w");
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
                $display("FAIL fi=%0d: timeout state=%0d sp=%0d sqc=%0d atc=%0d",
                         fi, dut.state, dut.sp, dut.sqc, dut.atc);
                errs = errs + 1;
            end else begin
                @(negedge clk);   // 等 done 后的结果寄存器落定
                nbad = 0;

                // 原始 c 量逐位
                check_raw(0, dut.c20r, craw[fi*10 + 0]);
                check_raw(1, dut.c20i, craw[fi*10 + 1]);
                check_raw(2, dut.c40r, craw[fi*10 + 2]);
                check_raw(3, dut.c40i, craw[fi*10 + 3]);
                check_raw(4, dut.c41r, craw[fi*10 + 4]);
                check_raw(5, dut.c41i, craw[fi*10 + 5]);
                check_raw(6, dut.c42,  craw[fi*10 + 6]);
                check_raw(7, dut.c60r, craw[fi*10 + 7]);
                check_raw(8, dut.c60i, craw[fi*10 + 8]);
                check_raw(9, dut.c63,  craw[fi*10 + 9]);

                // 6 模 + 6 相（±2）
                check_feat(0, mag0, gold[fi*12 + 0]);
                check_feat(1, mag1, gold[fi*12 + 1]);
                check_feat(2, mag2, gold[fi*12 + 2]);
                check_feat(3, mag3, gold[fi*12 + 3]);
                check_feat(4, mag4, gold[fi*12 + 4]);
                check_feat(5, mag5, gold[fi*12 + 5]);
                check_feat(6, ang0, gold[fi*12 + 6]);
                check_feat(7, ang1, gold[fi*12 + 7]);
                check_feat(8, ang2, gold[fi*12 + 8]);
                check_feat(9, ang3, gold[fi*12 + 9]);
                check_feat(10, ang4, gold[fi*12 + 10]);
                check_feat(11, ang5, gold[fi*12 + 11]);

                $fdisplay(fdut, "%08h %08h %08h %08h %08h %08h %08h %08h %08h %08h %08h %08h",
                          mag0, mag1, mag2, mag3, mag4, mag5,
                          ang0, ang1, ang2, ang3, ang4, ang5);
                $fdisplay(fraw, "%012h %012h %012h %012h %012h %012h %012h %012h %012h %012h",
                          dut.c20r, dut.c20i, dut.c40r, dut.c40i, dut.c41r,
                          dut.c41i, dut.c42, dut.c60r, dut.c60i, dut.c63);

                if (nbad == 0)
                    $display("fi=%0d OK (c raw exact, mag/ang within 2)", fi);
                else
                    errs = errs + 1;
            end
            repeat (6) @(negedge clk);
        end

        $fclose(fdut);
        $fclose(fraw);
        $display("CUMULANT TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #40000000;
        $display("CUM TIMEOUT fi=%0d state=%0d sp=%0d sqc=%0d atc=%0d",
                 fi, dut.state, dut.sp, dut.sqc, dut.atc);
        $finish;
    end
endmodule
