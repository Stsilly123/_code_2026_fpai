`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_calls : 跨调用回归（issue: expert_dma3_issue.md 现象 A）
//
//   上板用法是「一次调用灌 8 帧、收 8 帧输出」，下一次调用接着来。
//   这里按同样的节奏跑 NCALL 次：每次灌 expert_in.hex 的 8 帧，
//   等 8 帧输出收齐再灌下一次，逐字对拍 expert_gold.hex。
//
//   目的：第一次调用（tb_expert_feat 已覆盖）之后，模块里有没有跨调用残留，
//   让 ang20/ang1（特征 178/180）滞后一帧。
// -----------------------------------------------------------------------------
module tb_expert_calls;
    parameter NCALL = 8;

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

    reg [31:0] raw  [0:2047];
    reg [31:0] gold [0:2047];
    reg [31:0] got  [0:2047*8-1];

    integer nout;
    integer k, rep, guard, errs, nbad, idx, d;
    integer base, nbad_rep;

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
            if (nout < 2048*8) got[nout] = m_tdata;
            nout = nout + 1;
        end
    end

    initial begin
        $readmemh("expert_in.hex", raw);
        $readmemh("expert_gold.hex", gold);
        nout = 0;
        errs = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        for (rep = 0; rep < NCALL; rep = rep + 1) begin
            base = nout;
            // 一次调用：8 帧连续灌
            for (k = 0; k < 2048; k = k + 1) begin
                @(negedge clk);
                din = raw[k];
                din_valid = 1'b1;
                din_last = ((k % 256) == 255);
            end
            @(negedge clk);
            din_valid = 0;
            din_last = 0;

            // 等这次调用的 8 帧输出收齐
            guard = 0;
            while ((nout < base + 2048) && (guard < 3000000)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (nout < base + 2048) begin
                $display("FAIL: call %0d timeout, nout=%0d", rep, nout - base);
                errs = errs + 1;
                rep = NCALL;
            end else begin
                // 逐字对拍
                nbad_rep = 0;
                for (k = 0; k < 2048; k = k + 1) begin
                    idx = k % 256;
                    d   = got[base+k] - gold[k];
                    if ((idx >= 172) && (idx <= 186)) begin
                        if ((d > 2) || (d < -2)) begin
                            if ((nbad_rep < 10) && (idx == 178 || idx == 180))
                                $display("  call %0d frame %0d idx %0d: got=%0d exp=%0d d=%0d",
                                         rep, k/256, idx, $signed(got[base+k]),
                                         $signed(gold[k]), d);
                            nbad_rep = nbad_rep + 1;
                        end
                    end else if (got[base+k] !== gold[k]) begin
                        if (nbad_rep < 10)
                            $display("  call %0d frame %0d idx %0d: got=%08h exp=%08h",
                                     rep, k/256, idx, got[base+k], gold[k]);
                        nbad_rep = nbad_rep + 1;
                    end
                end
                $display("call %0d: %0d/2048 words out of tolerance (drop=%0d)",
                         rep, nbad_rep, stat_drop);
                if (nbad_rep != 0) errs = errs + 1;
            end
        end

        $display("EXPERT CALLS TB done: %0d errors over %0d calls", errs, NCALL);
        $finish;
    end

    initial begin
        #200000000;
        $display("TIMEOUT: nout=%0d state=%0d drops=%0d in_frames=%0d",
                 nout, dut.state, stat_drop, stat_frames);
        $finish;
    end
endmodule
