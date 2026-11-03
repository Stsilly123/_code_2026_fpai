`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_off : 诊断用 —— 只跑 golden 偏移 GOFF 起的 NCALLRUN 次调用，
//   并逐字打印失配（tb_expert_accept 在 call 23/24 上报 14~16 字失配，
//   要看是哪些 index、差多少）。
//
//   激励与 tb_expert_accept 完全相同，只是块号从 GOFF 开始。
// -----------------------------------------------------------------------------
module tb_expert_off;
    parameter NCALLW   = 32;
    parameter NCALLRUN = 4;
    parameter GOFF     = 23;
    parameter OCCMAX   = 4;
    parameter TOLMAX   = 12;

    localparam NFW    = NCALLW * 8 * 256;
    localparam MAXOUT = NCALLRUN * 8;

    reg clk = 0;
    reg rst_n = 0;

    reg [31:0] din = 0;
    reg        din_valid = 0;
    reg        din_last = 0;
    reg        m_tready = 1;

    wire [31:0] m_tdata;
    wire        m_tvalid, m_tlast;
    wire [3:0]  m_tkeep;
    wire [31:0] stat_drop, stat_frames;
    wire        busy;

    reg [31:0] raw  [0:NFW-1];
    reg [31:0] gold [0:NCALLW*256-1];
    reg [31:0] got  [0:MAXOUT*256-1];

    integer nout_w, nframe, collisions;
    integer errs, i, j, k, f, call, d, nmis, nd;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
            if (nout_w < MAXOUT*256) got[nout_w] = m_tdata;
            nout_w = nout_w + 1;
            if (m_tlast) nframe = nframe + 1;
        end
    end

    // 与 accept TB 同一条判据（195 是滚动帧号，不比）
    function automatic integer word_mis;
        input [31:0] a, b;
        input integer widx;
        integer dd;
        begin
            dd = a - b;
            if (widx == 195)
                word_mis = 0;
            else if (widx <= 127 || (widx >= 172 && widx <= 186))
                word_mis = ((dd > 2) || (dd < -2) || ((^dd) === 1'bx)) ? 1 : 0;
            else
                word_mis = ((dd != 0) || ((^dd) === 1'bx)) ? 1 : 0;
        end
    endfunction

    initial begin
        $readmemh("expert_in_rep.hex", raw);
        $readmemh("gold_rep.hex", gold);
        nout_w = 0; nframe = 0; collisions = 0; errs = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        for (k = 0; k < NCALLRUN*2048; k = k + 1) begin
            if ((k % 256) == 0) begin
                j = 0;
                while ((({1'b0, dut.nfull} + {4'd0, dut.rd_busy}) > OCCMAX) && (j < 200000)) begin
                    @(negedge clk);
                    j = j + 1;
                end
            end
            @(negedge clk);
            din = raw[((((k / 2048) + GOFF) % NCALLW) * 2048) + (k % 2048)];
            din_valid = 1'b1;
            din_last  = ((k % 256) == 255);
        end
        @(negedge clk); din_valid = 1'b0; din_last = 1'b0;

        for (j = 0; j < 2000000; j = j + 1) begin
            @(posedge clk);
            if ((dut.nfull == 4'd0) && (dut.state == 5'd0) &&
                (dut.out_active == 1'b0) && (dut.feat_valid == 2'b00)) j = 2000000;
        end

        $display("---- 输出 %0d 帧（golden %0d..%0d）----", nframe, GOFF, GOFF+NCALLRUN-1);

        for (f = 0; f < nframe && f < MAXOUT; f = f + 1) begin
            call = ((f / 8) + GOFF) % NCALLW;
            nmis = 0;
            for (i = 0; i < 256; i = i + 1)
                nmis = nmis + word_mis(got[f*256+i], gold[call*256+i], i);

            $display("  frame %0d (g%0d): mis=%0d ctr=%0d", f, call, nmis, got[f*256+195] & 7);
            if (nmis > 0 && (f % 8) == 0) begin
                nd = 0;
                for (i = 0; i < 256; i = i + 1) begin
                    d = got[f*256+i] - gold[call*256+i];
                    if (word_mis(got[f*256+i], gold[call*256+i], i) != 0 && nd < 40) begin
                        nd = nd + 1;
                        $display("      idx %0d: got=%0d gold=%0d d=%0d", i,
                                 $signed(got[f*256+i]), $signed(gold[call*256+i]), $signed(d));
                    end
                end
            end
        end

        $display("RESULT: %s (frames=%0d)", (errs == 0) ? "DONE" : "DONE", nframe);
        $finish;
    end

    initial begin
        #60000000;
        $display("TIMEOUT: nout_w=%0d state=%0d", nout_w, dut.state);
        $finish;
    end
endmodule
