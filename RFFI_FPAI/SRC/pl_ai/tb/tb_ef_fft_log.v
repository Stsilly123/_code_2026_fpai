`timescale 1ns / 1ps
// ef_fft_log 自测：真实 xfft_256 + 共享 ef_log2lut，8 帧对 gold_fft.hex。
// 运行目录需要：gold_zn.hex、gold_fft.hex、log2_lut.hex、expert_rom.vh。
// 仿真用 2 拍读延迟的 ROM stub。
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

module tb_ef_fft_log;
    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    wire [8:0] src_addr;
    wire signed [15:0] src_i, src_q;

    wire        log_req;
    wire [63:0] log_p;
    wire        log_ack, log_busy, log_pzero;
    wire signed [31:0] log2_q16;

    wire [6:0] res_addr;
    wire signed [31:0] res_data;
    wire res_we, done, busy;

    reg [31:0] zn   [0:2047];
    reg signed [31:0] gold [0:1023];
    reg signed [31:0] cap  [0:127];
    reg [31:0] src_word;

    // 抓 IP 实际输出，与 fft_cap.hex 对拍
    reg [31:0] fcap [0:4095];
    reg [63:0] pgot [0:255];
    reg signed [31:0] lg [0:127];
    reg signed [24:0] r_t, i_t;
    reg signed [49:0] p_t;

    integer fi, k, errs, guard;
    integer nchk, perr;
    reg done_ok;

    ef_log2lut u_log (
        .clk(clk), .rst_n(rst_n), .req(log_req), .p(log_p),
        .ack(log_ack), .pzero(log_pzero), .log2_q16(log2_q16), .busy(log_busy)
    );

    ef_fft_log dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .src_addr(src_addr), .src_i(src_i), .src_q(src_q),
        .log_req(log_req), .log_p(log_p), .log_ack(log_ack),
        .log_busy(log_busy), .log2_q16(log2_q16), .log_pzero(log_pzero),
        .res_addr(res_addr), .res_data(res_data), .res_we(res_we),
        .done(done), .busy(busy)
    );

    always #2.5 clk = ~clk;

    // 顶层 zn RAM 模型：1 拍读延迟
    always @(posedge clk)
        src_word <= zn[fi*256 + src_addr];

    assign src_i = src_word[15:0];
    assign src_q = src_word[31:16];

    always @(posedge clk)
        if (res_we)
            cap[res_addr] <= res_data;

    function [7:0] bitrev8;
        input [7:0] x;
        integer j;
        begin
            for (j = 0; j < 8; j = j + 1)
                bitrev8[j] = x[7-j];
        end
    endfunction

    always @(posedge clk)
        if (dut.log_ack)
            lg[dut.cur_k] = dut.log2_q16;

    // 每次 m_axis 握手都按自然序存 P
    always @(posedge clk) begin
        if (dut.m_tvalid && dut.m_tready) begin
            r_t = $signed(dut.m_tdata[24:0]);
            i_t = $signed(dut.m_tdata[56:32]);
            p_t = r_t * r_t + i_t * i_t;
            pgot[bitrev8(dut.out_cnt[7:0])] = p_t;
        end
    end

    initial begin
        $readmemh("gold_zn.hex", zn);
        $readmemh("gold_fft.hex", gold);
        $readmemh("fft_cap.hex", fcap);
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (3) @(posedge clk);

        for (fi = 0; fi < 8; fi = fi + 1) begin
            for (k = 0; k < 128; k = k + 1)
                cap[k] = 32'hdeadbeef;
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            guard = 0;
            while (!done && guard < 200000) begin
                @(negedge clk);
                guard = guard + 1;
            end
            done_ok = done;
            // done 那拍 res_we 仍有效，再等一个上升沿把最后一笔写收进来
            repeat (2) @(posedge clk);
            if (!done_ok) begin
                $display("FAIL fi=%0d: timeout state=%0d out_cnt=%0d in_cnt=%0d",
                         fi, dut.state, dut.out_cnt, dut.in_cnt);
                errs = errs + 1;
            end else begin
                nchk = 0;
                for (k = 0; k < 128; k = k + 1) begin
                    if (cap[k] !== gold[fi*128 + k]) begin
                        if (nchk < 8)
                            $display("FAIL fi=%0d k=%0d got=%0d(%08h) exp=%0d(%08h) p=%0d l2=%0d raw=%0d mean=%0d",
                                     fi, k, cap[k], cap[k],
                                     gold[fi*128+k], gold[fi*128+k],
                                     pgot[k], lg[k], dut.lm_ram[k], dut.lm_mean);
                        nchk = nchk + 1;
                    end
                end
                if (nchk != 0) begin
                    $display("fi=%0d: %0d/128 mismatches", fi, nchk);
                    errs = errs + 1;
                end else
                    $display("fi=%0d OK", fi);

                perr = 0;
                for (k = 0; k < 128; k = k + 1) begin
                    r_t = fcap[fi*512 + 2*k];
                    i_t = fcap[fi*512 + 2*k + 1];
                    p_t = r_t * r_t + i_t * i_t;
                    if (pgot[k] !== p_t) begin
                        if (perr < 8)
                            $display("  PDIFF fi=%0d k=%0d got=%0d exp=%0d",
                                     fi, k, pgot[k], p_t);
                        perr = perr + 1;
                    end
                end
                if (perr != 0)
                    $display("fi=%0d: %0d/128 P mismatches", fi, perr);
            end
            repeat (6) @(negedge clk);
        end

        $display("FFTLOG TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #40000000;
        $display("FFTLOG TIMEOUT fi=%0d state=%0d out_cnt=%0d in_cnt=%0d",
                 fi, dut.state, dut.out_cnt, dut.in_cnt);
        $finish;
    end
endmodule
