`timescale 1ns / 1ps
// ef_power 自测：真实 ef_sqrt + ef_log2lut，8 帧对 gold_power.hex。
//   acc1..acc4 由 TB 用独立 sqrt 从 gold_zn 算（与 ef_hist 同口径）；
//   sum_x/sum_q 从原始输入 expert_in.hex 累加；rms 取 gold_rms.hex。
//   6 个输出要求逐位相同。
// 运行目录需要：expert_in.hex、gold_zn.hex、gold_rms.hex、gold_power.hex、
//               log2_lut.hex、expert_rom.vh。仿真用 2 拍读延迟的 ROM stub。
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

module tb_ef_power;
    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    reg signed [23:0] sum_x, sum_q;
    reg [47:0] acc1, acc2, acc3, acc4;
    reg [16:0] rms;

    wire        sq_req;
    wire [31:0] sq_in;
    wire        sq_ack;
    wire [16:0] sq_out;

    wire        log_req;
    wire [63:0] log_p;
    wire        log_ack, log_busy;
    wire signed [31:0] log2q16;
    wire        log_pzero;

    wire signed [31:0] log_rms, std_az, mean_az3, mean_az4, mean_x, mean_q;
    wire done, busy;

    // TB 独立 sqrt（算 acc）
    reg        asq_req = 0;
    reg [31:0] asq_p = 0;
    wire       asq_ack;
    wire [16:0] asq_out;

    reg [31:0] raw  [0:2047];
    reg [31:0] gzn  [0:2047];
    reg [31:0] grms [0:7];
    reg [31:0] gpow [0:47];

    integer fi, k, errs, guard, nbad;
    reg signed [63:0] sx, sq;
    reg signed [15:0] xi, xq;
    reg signed [63:0] xi2, xq2;
    reg [47:0] a1, a2, a3, a4;

    ef_power dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .sum_x(sum_x), .sum_q(sum_q),
        .acc1(acc1), .acc2(acc2), .acc3(acc3), .acc4(acc4),
        .rms_q10(rms),
        .sq_req(sq_req), .sq_in(sq_in), .sq_ack(sq_ack), .sq_out(sq_out),
        .log_req(log_req), .log_p(log_p), .log_ack(log_ack), .log_busy(log_busy),
        .log2_q16(log2q16), .log_pzero(log_pzero),
        .log_rms(log_rms), .std_az(std_az),
        .mean_az3(mean_az3), .mean_az4(mean_az4),
        .mean_x(mean_x), .mean_q(mean_q),
        .done(done), .busy(busy)
    );

    ef_sqrt u_sqrt (
        .clk(clk), .rst_n(rst_n),
        .req(sq_req), .din(sq_in),
        .ack(sq_ack), .dout(sq_out)
    );

    ef_sqrt u_asq (
        .clk(clk), .rst_n(rst_n),
        .req(asq_req), .din(asq_p),
        .ack(asq_ack), .dout(asq_out)
    );

    ef_log2lut u_log (
        .clk(clk), .rst_n(rst_n),
        .req(log_req), .p(log_p),
        .ack(log_ack), .pzero(log_pzero), .log2_q16(log2q16), .busy(log_busy)
    );

    always #2.5 clk = ~clk;

    // 用独立 sqrt 从 gold_zn 累加 acc1..acc4
    task calc_acc;
        input integer f;
        integer j;
        reg signed [15:0] zi, zq;
        reg [16:0] az;
        reg [33:0] az2;
        reg [19:0] az2q;
        begin
            a1 = 0; a2 = 0; a3 = 0; a4 = 0;
            for (j = 0; j < 256; j = j + 1) begin
                zi = $signed(gzn[f*256 + j][15:0]);
                zq = $signed(gzn[f*256 + j][31:16]);
                @(negedge clk);
                asq_p = zi * zi + zq * zq;
                asq_req = 1'b1;
                @(negedge clk);
                asq_req = 1'b0;
                while (!asq_ack) @(negedge clk);
                az = asq_out;
                az2 = az * az;
                az2q = az2 >> 12;
                a1 = a1 + az;
                a2 = a2 + az2;
                a3 = a3 + az2q * az;
                a4 = a4 + az2q * az2q;
                @(negedge clk);
            end
        end
    endtask

    task chk;
        input integer idx;
        input signed [31:0] got;
        input signed [31:0] exp;
        begin
            if (got !== exp) begin
                $display("  POWDIFF fi=%0d idx=%0d got=%0d exp=%0d", fi, idx, got, exp);
                nbad = nbad + 1;
            end
        end
    endtask

    initial begin
        $readmemh("expert_in.hex", raw);
        $readmemh("gold_zn.hex", gzn);
        $readmemh("gold_rms.hex", grms);
        $readmemh("gold_power.hex", gpow);
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            // sum_x / sum_q：来自原始样点（有符号）
            sx = 0; sq = 0;
            for (k = 0; k < 256; k = k + 1) begin
                xi = $signed(raw[fi*256 + k][15:0]);
                xq = $signed(raw[fi*256 + k][31:16]);
                sx = sx + xi;
                sq = sq + xq;
            end
            sum_x = sx[23:0];
            sum_q = sq[23:0];
            rms = grms[fi][16:0];

            calc_acc(fi);
            acc1 = a1; acc2 = a2; acc3 = a3; acc4 = a4;

            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            guard = 0;
            while (!done && guard < 10000) begin
                @(negedge clk);
                guard = guard + 1;
            end
            if (!done) begin
                $display("FAIL fi=%0d timeout state=%0d", fi, dut.state);
                errs = errs + 1;
            end else begin
                @(negedge clk);
                nbad = 0;
                chk(0, log_rms,  $signed(gpow[fi*6 + 0]));
                chk(1, std_az,   $signed(gpow[fi*6 + 1]));
                chk(2, mean_az3, $signed(gpow[fi*6 + 2]));
                chk(3, mean_az4, $signed(gpow[fi*6 + 3]));
                chk(4, mean_x,   $signed(gpow[fi*6 + 4]));
                chk(5, mean_q,   $signed(gpow[fi*6 + 5]));
                if (nbad == 0) $display("fi=%0d OK (6 power features exact)", fi);
                else errs = errs + 1;
            end
            repeat (4) @(negedge clk);
        end

        $display("POWER TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #5000000;
        $display("POWER TIMEOUT fi=%0d state=%0d", fi, dut.state);
        $finish;
    end
endmodule
