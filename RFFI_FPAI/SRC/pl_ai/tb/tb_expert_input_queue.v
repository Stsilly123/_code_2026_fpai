`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_input_queue : expert 输入侧滞后（expert_dma3_issue.md v3）的定向复现
//
//   板上现象（diag6.log）：稳态每次调用 8 帧输入，读窗口 8 帧输出，
//   但槽 0..2 是上一次调用的结果、槽 3..7 是本轮，且跨调用不消失。
//
//   这个 TB 把「输入侧上游（SRC/DMA/stream_buf/FIFO 这段）多积了几帧」
//   建模成一个**待发帧队列**：expert 只会看到队列里轮到的帧，PS 每轮往队列尾
//   追加 8 帧（= MM2S 这一轮的 SRC）。SEED=1 时在第一次调用后多追加 3 帧
//   （= 单描述符自环重发的那 3 帧）。
//
//   判据（任何一条不满足都算 PL 的问题）：
//     1) 每个输出槽必须逐字等于「该槽实际喂进去的那一帧」的 golden
//        （0..127 容差 ±16，172..186 容差 ±2，其余逐位；195 是 out_idx 不参与）。
//        —— 只要 PL 是一进一出、不改数据，无论喂的是哪一帧都必须过。
//     2) 打印每槽的 feed=<第几次调用的帧>，观察 SEED 是否复现板上形态。
//
//   对照：
//     SEED=0：队列永远 8 进 8 出，任何槽都不该是旧帧；
//     SEED=1：队列从第 1 次调用起永久多 3 帧，槽 0..2 变成上一次调用的帧。
//   两次的唯一差别就是那 3 帧输入，PL 自身没有状态差异。
// -----------------------------------------------------------------------------
module tb_expert_input_queue;
    parameter NCALL  = 8;      // 调用次数；每次用 expert_in.hex 的第 call 帧重复 8 份
    parameter NFRAME = 8;      // 每次调用的帧数
    parameter OCCMAX = 4;      // 帧首允许的环占用上限（nfull + rd_busy）
    parameter QMAX   = 128;    // 待发帧队列深度（帧号）

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

    reg [31:0] fin  [0:2047];      // 8 帧输入
    reg [31:0] gold [0:2047];      // 8 帧 golden
    reg [31:0] got  [0:NCALL*2048-1];

    integer qid [0:QMAX-1];        // 队列里每一帧的调用号
    integer qh, qt;

    integer nout_w;                // 已收字数
    integer deliv [0:7];           // 本次调用第 s 槽实际喂的帧号
    integer seed_mode;
    integer call, s, k, f, fid, g, guard, nmis, bad, nstale, errs, total_stale;
    integer ctr_first, ctr_prev;

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
            if (nout_w < NCALL*2048) got[nout_w] = m_tdata;
            nout_w = nout_w + 1;
        end
    end

    // 与 tb_expert_accept 相同：FFT 定点+log2 LUT vs float golden 的既有分辨率差
    function automatic integer word_mis;
        input [31:0] a, b;
        input integer widx;
        integer dd;
        begin
            dd = a - b;
            if (widx == 195)                       // out_idx 每帧 +1，不参与比较
                word_mis = 0;
            else if (widx <= 127)
                word_mis = ((dd > 16) || (dd < -16) || ((^dd) === 1'bx)) ? 1 : 0;
            else if (widx >= 172 && widx <= 186)
                word_mis = ((dd > 2) || (dd < -2) || ((^dd) === 1'bx)) ? 1 : 0;
            else
                word_mis = ((dd != 0) || ((^dd) === 1'bx)) ? 1 : 0;
        end
    endfunction

    task enq(input integer id);
        begin
            qid[qt] = id;
            qt = qt + 1;
        end
    endtask

    // 从队列头取一帧喂给 DUT（帧首按环占用做上游反压，模拟 HLS FIFO 满）
    task feed_head;
        begin
            guard = 0;
            while ((({1'b0, dut.nfull} + {4'd0, dut.rd_busy}) > OCCMAX) &&
                   (guard < 200000)) begin
                @(negedge clk);
                guard = guard + 1;
            end
            fid = qid[qh];
            for (k = 0; k < 256; k = k + 1) begin
                @(negedge clk);
                din       = fin[fid*256 + k];
                din_valid = 1'b1;
                din_last  = (k == 255);
            end
            @(negedge clk);
            din_valid = 0;
            din_last  = 0;
            qh = qh + 1;
        end
    endtask

    initial begin
        $readmemh("expert_in.hex",   fin);
        $readmemh("expert_gold.hex", gold);
`ifdef QUEUE_SEED
        seed_mode = 1;
`else
        seed_mode = 0;
`endif

        nout_w = 0; qh = 0; qt = 0; errs = 0; total_stale = 0; ctr_prev = -1;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        $display("TB INPUT-QUEUE: NCALL=%0d SEED=%0d", NCALL, seed_mode);

        for (call = 0; call < NCALL; call = call + 1) begin
            // PS 这一轮往 SRC 写 8 帧相同的第 call 帧
            for (f = 0; f < 8; f = f + 1) enq(call);
            // MM2S 自环重发：只在第一次调用后多进 3 帧（与板上一样的「多 3 帧」）
            if (seed_mode != 0 && call == 0)
                for (f = 0; f < 3; f = f + 1) enq(0);

            // HLS 这一轮正好从队列头取 8 帧
            for (s = 0; s < 8; s = s + 1) begin
                deliv[s] = qid[qh];
                feed_head;
            end

            // 收这一轮的 8 帧输出
            guard = 0;
            while ((nout_w < (call+1)*2048) && (guard < 4000000)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (nout_w < (call+1)*2048) begin
                $display("FAIL: call %0d timeout, nout=%0d state=%0d",
                         call, nout_w - call*2048, dut.state);
                errs = errs + 1;
                call = NCALL;
            end else begin
                nstale = 0;
                ctr_first = -1;
                $display("---- call %0d  (queue tail=%0d, ring nfull=%0d) ----",
                         call, qt - qh, dut.nfull);
                for (s = 0; s < 8; s = s + 1) begin
                    fid = deliv[s];
                    nmis = 0;
                    for (k = 0; k < 256; k = k + 1)
                        nmis = nmis + word_mis(got[call*2048 + s*256 + k],
                                               gold[fid*256 + k], k);
                    if (fid != call) nstale = nstale + 1;
                    if (s == 0) ctr_first = got[call*2048 + 195] & 7;
                    $display("  call %0d slot %0d feed=%0d %s ctr=%0d mis=%0d",
                             call, s, fid, (fid == call) ? "cur" : "OLD",
                             got[call*2048 + s*256 + 195], nmis);
                    if (nmis != 0) errs = errs + 1;
                end
                total_stale = total_stale + nstale;
                $display("  call %0d: slots=%0d stale=%0d ctr0..7 = %0d..%0d in_frames=%0d drops=%0d",
                         call, 8, nstale, ctr_first,
                         got[call*2048 + 7*256 + 195],
                         stat_frames, stat_drop);
            end
        end

        $display("RESULT: SEED=%0d calls=%0d out_frames=%0d in_frames=%0d drops=%0d stale_slots=%0d mismatched_slots=%0d -> %s",
                 seed_mode, NCALL, nout_w/256, stat_frames, stat_drop,
                 total_stale, errs, (errs == 0) ? "GOLD-EXACT-ALL-SLOTS" : "MISMATCH");
        $finish;
    end

    initial begin
        #400000000;
        $display("TIMEOUT: nout=%0d state=%0d drops=%0d in_frames=%0d",
                 nout_w, dut.state, stat_drop, stat_frames);
        $finish;
    end
endmodule
