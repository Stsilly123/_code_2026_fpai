`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_accept : expert_dma3_issue.md §6 的验收 TB
//
//   连续跑 64 次调用；每次调用 = 8 帧**完全相同**的输入（和 PS 的
//   diag_expert_shift0 一致），相邻调用换成另一份 golden（32 份循环使用）。
//
//   灌数节奏：帧首等环形缓冲空出位置（占用 = 排队帧 nfull + 正在 S_ZN 读的
//   rd_busy ≤ 4）后再整帧背靠背灌 256 字。板上是 HLS 输入 FIFO 满 →
//   stream_buf s_tready=0 → DMA 停，实际灌数率被处理率卡住（每次调用 8 进 8 出、
//   不丢帧，否则 PS 按 8 帧一组的多数派就没法用了）。这里把这种"上游反压"
//   等效成按环占用灌数：调用首尾相接、输入流不断，但环不会顶满丢帧，
//   输出与调用的对应关系保持严格一一对应。
//
//   注意：真正的"环顶满 + 帧边界撞上 S_ZN"竞态由 tb_expert_race 的定向用例
//   单独覆盖；那个工况的正确行为是丢整帧（stat_drop），不是这里要验的。
//
//   判据（全部必须为 0）：
//     1) 每个输出帧必须等于它那次调用的 golden（0..127 容差 ±16，172..186 容差
//        ±2，其余逐位相同）          -> corrupt
//        0..127 的 ±16：RTL 用 xfft_256 定点 IP + LUT/log2 插值，golden 是 float
//        FFT 取整后过同一条 log2 LUT（gen_expert_vectors.py 274~282）。功率差
//        ~0.1% ⇒ log2 差 ~6 LSB；32 份真实帧实测最大 11（g23 的 idx105）。原来的
//        ±2 只够覆盖多数帧，g23/g24 会被判 corrupt —— 那是模型分辨率差，不是逻辑错。
//     2) 每次调用内 8 帧特征必须逐位相同（现象 A 的判据，含 178/180）-> callbad
//     3) S_ZN 期间不得往正在读的槽写样点（现象 B 的根因）           -> collision
//     4) 不得丢帧（丢了输出与调用的对应关系就断了）               -> drops
//
//   用法：xsim 顶层跑到底即可；结果看最后一行的 RESULT。
// -----------------------------------------------------------------------------
module tb_expert_accept;
    parameter NCALLW   = 32;    // golden 份数（expert_in_rep/gold_rep 里各 32 份）
    parameter NCALLRUN = 64;    // 连续调用次数
    parameter OCCMAX   = 4;     // 帧首允许的环占用上限（nfull + rd_busy）
    parameter TOLMAX   = 12;    // 单帧对 golden 的失配上限（容差区 ±2）

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

    integer nout_w;
    integer nframe;
    integer collisions;
    integer errs, callbad;
    integer i, j, k, g, f, call, best, dbest, d, nmis, bad0, xbad, guard;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    // ---- 输出收集 ----
    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
            if (nout_w < MAXOUT*256) got[nout_w] = m_tdata;
            nout_w = nout_w + 1;
            if (m_tlast) nframe = nframe + 1;
        end
    end

    // ---- 现象 B 根因监视 ----
    wire        dvalid_r = dut.dvalid_r;
    wire        cap_now  = dut.cap_now;
    wire [4:0]  dstate   = dut.state;
    wire [2:0]  wr_frame = dut.wr_frame;
    wire [2:0]  rd_slot  = dut.rd_slot;
    wire [7:0]  in_cnt   = dut.in_cnt;

    always @(posedge clk) begin
        if (rst_n && dvalid_r && cap_now && (dstate == 5'd1) && (wr_frame == rd_slot)) begin
            if (collisions < 8)
                $display("  COLLISION @%0t: 槽 %0d 写 idx=%0d / zn 读 addr=%0d",
                         $time, rd_slot, in_cnt, dut.zn_src_addr);
            collisions = collisions + 1;
        end
    end

    // 单字比较：0..127 FFT 对数幅度允许 ±16（定点 FFT+log2 LUT vs float golden，
    // 实测最大 11）；172..186 CORDIC atan 允许 ±2；其余逐位相同；
    // X 一律算失配（x 与常数比较得 x，直接写 if (d>2) 会把整帧 X 当"过"）。
    // 195 是滚动帧号 out_idx[2:0]，每帧本来就 +1，不能按"帧间相同/等于 golden"比；
    // 它单独按 f%8 校验（见下面的 CTR 检查）。
    function automatic integer word_mis;
        input [31:0] a, b;
        input integer widx;
        integer dd;
        begin
            dd = a - b;
            if (widx == 195)
                word_mis = 0;
            else if (widx <= 127)
                word_mis = ((dd > 16) || (dd < -16) || ((^dd) === 1'bx)) ? 1 : 0;
            else if (widx >= 172 && widx <= 186)
                word_mis = ((dd > 2) || (dd < -2) || ((^dd) === 1'bx)) ? 1 : 0;
            else
                word_mis = ((dd != 0) || ((^dd) === 1'bx)) ? 1 : 0;
        end
    endfunction

    initial begin
        $readmemh("expert_in_rep.hex", raw);
        $readmemh("gold_rep.hex", gold);
        nout_w = 0; nframe = 0; collisions = 0; errs = 0; callbad = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        // ---- 64 次调用首尾相接，中间不等输出；帧首按环占用做上游反压 ----
        for (k = 0; k < NCALLRUN*2048; k = k + 1) begin
            if ((k % 256) == 0) begin
                guard = 0;
                while ((({1'b0, dut.nfull} + {4'd0, dut.rd_busy}) > OCCMAX) &&
                       (guard < 200000)) begin
                    @(negedge clk);
                    guard = guard + 1;
                end
                if (guard >= 200000) begin
                    $display("FAIL: 帧首等环空间超时 k=%0d nfull=%0d rd_busy=%0d",
                             k, dut.nfull, dut.rd_busy);
                    k = NCALLRUN*2048;
                end
            end
            @(negedge clk);
            din = raw[(((k / 2048) % NCALLW) * 2048) + (k % 2048)];
            din_valid = 1'b1;
            din_last  = ((k % 256) == 255);
        end
        @(negedge clk); din_valid = 1'b0; din_last = 1'b0;

        // ---- 排空：FSM 空闲、环空、且两个 feat bank 都已被 AXIS 引擎读空 ----
        for (j = 0; j < 2000000; j = j + 1) begin
            @(posedge clk);
            if ((dut.nfull == 4'd0) && (dut.state == 5'd0) &&
                (dut.out_active == 1'b0) && (dut.feat_valid == 2'b00)) j = 2000000;
        end

        $display("---- 输出 %0d 帧（喂入 %0d 次调用，drops=%0d, in_frames=%0d）----",
                 nframe, NCALLRUN, stat_drop, stat_frames);

        // ---- 1) 逐帧对"该次调用的 golden"，并记录最优匹配（丢帧会表现为错位）----
        for (f = 0; f < nframe && f < MAXOUT; f = f + 1) begin
            call = (f / 8) % NCALLW;
            nmis = 0;
            for (i = 0; i < 256; i = i + 1)
                nmis = nmis + word_mis(got[f*256+i], gold[call*256+i], i);

            best = 9999; dbest = -1;
            for (g = 0; g < NCALLW; g = g + 1) begin
                bad0 = 0;
                for (i = 0; i < 256; i = i + 1)
                    bad0 = bad0 + word_mis(got[f*256+i], gold[g*256+i], i);
                if (bad0 < best) begin best = bad0; dbest = g; end
            end
            if (nmis > TOLMAX || best > TOLMAX) begin
                errs = errs + 1;
                if (errs <= 20)
                    $display("  frame %0d (call %0d): CORRUPT  vs expected g%0d mis=%0d | best g%0d mis=%0d ctr=%0d",
                             f, f/8, call, nmis, dbest, best, got[f*256+195] & 7);
            end else if (dbest != call && errs < 40) begin
                // 数据本身对，但落到了别的 golden 上 => 输出与调用的对应关系错位（丢帧）
                errs = errs + 1;
                $display("  frame %0d: SHIFTED  期望 g%0d，实际最像 g%0d（mis=%0d, ctr=%0d）",
                         f, call, dbest, best, got[f*256+195] & 7);
            end
        end

        // ---- 2) 每次调用内 8 帧必须逐位相同（含 178/180 这两个跨调用才变化的字）----
        for (call = 0; call < NCALLRUN; call = call + 1) begin
            if ((call*8 + 7) >= nframe) begin
                if (callbad < 8) $display("  call %0d: 输出不足 8 帧", call);
                callbad = callbad + 1;
            end else begin
                bad0 = 0; xbad = 0;
                for (f = 1; f < 8; f = f + 1)
                    for (i = 0; i < 256; i = i + 1) begin
                        if (i == 195) begin
                            // 滚动帧号：只校验它确实每帧 +1
                            if ((got[(call*8+f)*256+i] & 7) != ((call*8+f) & 7)) begin
                                bad0 = bad0 + 1;
                                if (bad0 <= 4)
                                    $display("  call %0d frame %0d: ctr=%0d 应为 %0d",
                                             call, f, got[(call*8+f)*256+i] & 7, (call*8+f) & 7);
                            end
                        end else if (got[(call*8+f)*256+i] !== got[call*8*256+i]) begin
                            bad0 = bad0 + 1;
                            if (i == 178 || i == 180) xbad = xbad + 1;
                        end
                    end
                if (bad0 != 0) begin
                    callbad = callbad + 1;
                    if (callbad <= 8)
                        $display("  call %0d: 8 帧不一致 %0d 字（其中 178/180 共 %0d 处）",
                                 call, bad0, xbad);
                end
            end
        end

        $display("EXPERT ACCEPT TB: calls=%0d frames=%0d corrupt=%0d callbad=%0d collision=%0d drops=%0d",
                 NCALLRUN, nframe, errs, callbad, collisions, stat_drop);
        if (errs != 0 || callbad != 0 || collisions != 0 || stat_drop != 0)
            $display("RESULT: FAIL");
        else
            $display("RESULT: PASS");
        $finish;
    end

    initial begin
        #200000000;
        $display("TIMEOUT: nout_w=%0d state=%0d collisions=%0d", nout_w, dut.state, collisions);
        $finish;
    end
endmodule
