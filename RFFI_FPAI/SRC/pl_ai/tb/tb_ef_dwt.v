`timescale 1ns / 1ps
// ef_dwt_db4 自测：8 帧 × (I,Q)，对 gold_dwtsum.hex 的 5 个 Q24 能量和。
// 运行：xsim tb_ef_dwt -testplusarg ZN=<abs>/gold_zn.hex -testplusarg GOLD=<abs>/gold_dwtsum.hex
module tb_ef_dwt;
    reg clk, rst_n, start;
    wire [8:0] src_addr;
    wire       src_sel;
    reg  signed [23:0] src_data;
    wire [63:0] e_ca4, e_cd4, e_cd3, e_cd2, e_cd1;
    wire done, busy;

    reg [31:0] zn   [0:2047];
    reg [63:0] gold [0:79];

    integer fi, ch, errs, guard;
    reg [1023:0] zn_path, gold_path;

    wire [31:0] znw = zn[fi*256 + src_addr];

    always @(posedge clk) begin
        if (src_sel)
            src_data <= ch ? $signed(znw[31:16]) : $signed(znw[15:0]);
        else
            src_data <= 24'sd0;
    end

    ef_dwt_db4 dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .src_addr(src_addr), .src_sel(src_sel), .src_data(src_data),
        .e_ca4(e_ca4), .e_cd4(e_cd4), .e_cd3(e_cd3),
        .e_cd2(e_cd2), .e_cd1(e_cd1),
        .done(done), .busy(busy)
    );

    initial clk = 0;
    always #2.5 clk = ~clk;   // 200 MHz

    task check_band;
        input [63:0] got;
        input [63:0] exp;
        input [8*8-1:0] nm;
        begin
            if (got !== exp) begin
                $display("FAIL f%0d ch%0d %0s got=%0d (%h) exp=%0d (%h)",
                         fi, ch, nm, got, got, exp, exp);
                errs = errs + 1;
            end
        end
    endtask

    initial begin
        if (!$value$plusargs("ZN=%s", zn_path))   zn_path = "gold_zn.hex";
        if (!$value$plusargs("GOLD=%s", gold_path)) gold_path = "gold_dwtsum.hex";
        $readmemh(zn_path, zn);
        $readmemh(gold_path, gold);

        rst_n = 0; start = 0; errs = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            for (ch = 0; ch < 2; ch = ch + 1) begin
                if (fi == 0 && ch == 0)
                    $display("TB zn0..7 = %0d %0d %0d %0d %0d %0d %0d %0d",
                             $signed(zn[0][15:0]), $signed(zn[1][15:0]),
                             $signed(zn[2][15:0]), $signed(zn[3][15:0]),
                             $signed(zn[4][15:0]), $signed(zn[5][15:0]),
                             $signed(zn[6][15:0]), $signed(zn[7][15:0]));
                @(negedge clk);
                start <= 1'b1;
                @(negedge clk);
                start <= 1'b0;

                guard = 0;
                while (!done && guard < 200000) begin
                    @(negedge clk);
                    guard = guard + 1;
                end
                if (!done) begin
                    $display("FAIL f%0d ch%0d timeout (busy=%b)", fi, ch, busy);
                    errs = errs + 1;
                end else begin
                    check_band(e_ca4, gold[fi*10 + ch*5 + 0], "cA4");
                    check_band(e_cd4, gold[fi*10 + ch*5 + 1], "cD4");
                    check_band(e_cd3, gold[fi*10 + ch*5 + 2], "cD3");
                    check_band(e_cd2, gold[fi*10 + ch*5 + 3], "cD2");
                    check_band(e_cd1, gold[fi*10 + ch*5 + 4], "cD1");
                end
                repeat (4) @(posedge clk);
            end
        end

        $display("DWT TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #2000000;
        $display("GLOBAL TIMEOUT");
        $finish;
    end
endmodule
