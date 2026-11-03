`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_board : 按 PS 端 diag_expert_shift0.yaml 的真实用法回放
//
//   PS 的用法（src/pl_side.cpp: quantize_shift(raw, kSegLen, 0, slot) x8）：
//     第 f 次调用 = samples/frames.bin 的第 f 帧，重复 8 份（逐位相同），
//     收完 8 帧输出再发下一次。相邻两次调用的输入帧不同。
//
//   激励文件 expert_in_rep.hex 由 32 次调用 × 8 份 = 256 帧拼成，
//   gold_rep.hex 是第 0..31 帧的 golden（每帧 256 字）。
//
//   判据：
//     * 每次调用内 8 槽必须与 golden 该帧一致（172..186 容差 ±2，其余逐位）；
//     * 打印每次调用 slot0 / slot1 的 178、180，和板上日志直接对照
//       （板上现象 A：slot0 的 178/180 是上一次调用的值）。
// -----------------------------------------------------------------------------
module tb_expert_board;
    parameter NCALL = 32;

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

    reg [31:0] raw  [0:65535];
    reg [31:0] gold [0:8191];
    reg [31:0] got  [0:65535];

    integer nout;
    integer k, rep, s, guard, errs, nbad_rep, idx, d, base, wcnt;
    integer bad_slot0, bad_slot;

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
            if (nout < 65536) got[nout] = m_tdata;
            nout = nout + 1;
        end
    end

    initial begin
        wcnt = $fopen("board_run.csv", "w");
        $fwrite(wcnt, "call,slot,idx178,idx180,ok\n");
    end

    initial begin
        $readmemh("expert_in_rep.hex", raw);
        $readmemh("gold_rep.hex", gold);
        nout = 0;
        errs = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        for (rep = 0; rep < NCALL; rep = rep + 1) begin
            base = nout;
            // 一次调用：同一帧 8 份
            for (k = 0; k < 2048; k = k + 1) begin
                @(negedge clk);
                din = raw[rep*2048 + k];
                din_valid = 1'b1;
                din_last = ((k % 256) == 255);
            end
            @(negedge clk);
            din_valid = 0;
            din_last = 0;

            guard = 0;
            while ((nout < base + 2048) && (guard < 4000000)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (nout < base + 2048) begin
                $display("FAIL: call %0d timeout, nout=%0d", rep, nout - base);
                errs = errs + 1;
                rep = NCALL;
            end else begin
                nbad_rep = 0;
                for (s = 0; s < 8; s = s + 1) begin
                    bad_slot = 0;
                    for (k = 0; k < 256; k = k + 1) begin
                        idx = k;
                        d   = got[base + s*256 + k] - gold[rep*256 + k];
                        if ((idx >= 172) && (idx <= 186)) begin
                            if ((d > 2) || (d < -2)) begin
                                bad_slot = bad_slot + 1;
                                if (s == 0)
                                    $display("  call %0d slot0 idx %0d: got=%0d exp=%0d",
                                             rep, idx, $signed(got[base + k]),
                                             $signed(gold[rep*256 + k]));
                            end
                        end else if (got[base + s*256 + k] !== gold[rep*256 + k]) begin
                            bad_slot = bad_slot + 1;
                            if (s == 0)
                                $display("  call %0d slot0 idx %0d: got=%08h exp=%08h",
                                         rep, idx, got[base + s*256 + k],
                                         gold[rep*256 + k]);
                        end
                    end
                    $fwrite(wcnt, "%0d,%0d,%0d,%0d,%0d\n", rep, s,
                            $signed(got[base + s*256 + 178]),
                            $signed(got[base + s*256 + 180]), bad_slot == 0);
                    nbad_rep = nbad_rep + bad_slot;
                end
                $display("call %0d: slot0 178/180 = %0d/%0d  slot1 = %0d/%0d  %0d bad words (drop=%0d)",
                         rep,
                         $signed(got[base + 178]), $signed(got[base + 180]),
                         $signed(got[base + 256 + 178]), $signed(got[base + 256 + 180]),
                         nbad_rep, stat_drop);
                if (nbad_rep != 0) errs = errs + 1;
            end
        end

        $display("EXPERT BOARD TB done: %0d errors over %0d calls", errs, NCALL);
        $fclose(wcnt);
        $finish;
    end

    initial begin
        #400000000;
        $display("TIMEOUT: nout=%0d state=%0d drops=%0d in_frames=%0d",
                 nout, dut.state, stat_drop, stat_frames);
        $finish;
    end
endmodule
