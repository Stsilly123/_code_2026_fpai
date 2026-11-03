`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// lstf_eq 单元测试：9 帧（2304 字）对 eq_gold.hex，允许 |Δ|<=1 LSB
//   帧 0..8 的输入/期望输出/旁路标志都由 tools/gen_lstf_eq_vectors.py 生成
//   （eq_case.hex：1 = 该帧应旁路）
//   帧 8 是弱信号（|tap|>1），专门回归抽头定标 TAP_SFT 的第二遍。
//////////////////////////////////////////////////////////////////////////////////
module tb_lstf_eq;

    reg         clk = 0;
    reg         rst_n = 0;
    always #2.5 clk = ~clk;         // 200 MHz

    reg  [31:0] din = 0;
    reg         din_valid = 0;

    wire [31:0] m_tdata;
    wire        m_tvalid;
    reg         m_tready = 1;
    wire [3:0]  m_tkeep;
    wire        m_tlast;
    wire        m_tuser;
    wire [31:0] stat_drop;
    wire [22:0] stat_theta;
    wire        stat_gate;
    wire        busy;

    lstf_eq u_dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .din        (din),
        .din_valid  (din_valid),
        .m_tdata    (m_tdata),
        .m_tvalid   (m_tvalid),
        .m_tready   (m_tready),
        .m_tkeep    (m_tkeep),
        .m_tlast    (m_tlast),
        .m_tuser    (m_tuser),
        .stat_drop  (stat_drop),
        .stat_theta (stat_theta),
        .stat_gate  (stat_gate),
        .busy       (busy)
    );

    reg [31:0] in_mem   [0:2303];
    reg [31:0] gold_mem [0:2303];
    reg [31:0] case_mem [0:8];

    initial begin
        $readmemh("eq_in.hex",   in_mem);
        $readmemh("eq_gold.hex", gold_mem);
        $readmemh("eq_case.hex", case_mem);
    end

    integer widx;
    integer oidx = 0;
    integer frame_cnt = 0;
    integer nerr = 0;
    integer maxerr = 0;
    integer timeout = 0;
    integer ferr [0:8];
    integer fi;
    initial for (fi = 0; fi < 9; fi = fi + 1) ferr[fi] = 0;

    // ── 输入：2304 字，一字一拍 ─────────────────────────────────────────────
    initial begin
        rst_n = 0;
        repeat (10) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        for (widx = 0; widx < 2304; widx = widx + 1) begin
            din       <= in_mem[widx];
            din_valid <= 1'b1;
            @(posedge clk);
            // 帧间留 80us（16k 拍）：9 帧超过 8 槽缓冲，连续灌会丢帧。
            // 真实系统里 HLS 也是 ~101us 一帧，这样更接近板端节奏。
            if (widx % 256 == 255) begin
                din_valid <= 1'b0;
                repeat (16000) @(posedge clk);
            end
        end
        din_valid <= 1'b0;
    end

    // ── 输出记分板 ─────────────────────────────────────────────────────────
    reg [15:0] oi, gi, oq, gq;
    integer di, dq;

    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
            if (oidx < 2304) begin
                oi = m_tdata[15:0];
                gi = gold_mem[oidx][15:0];
                oq = m_tdata[31:16];
                gq = gold_mem[oidx][31:16];
                di = $signed({1'b0, oi}) - $signed({1'b0, gi});
                dq = $signed({1'b0, oq}) - $signed({1'b0, gq});
                if (di < 0) di = -di;
                if (dq < 0) dq = -dq;
                if (di > maxerr) maxerr = di;
                if (dq > maxerr) maxerr = dq;
                if (di > 1 || dq > 1) begin
                    nerr = nerr + 1;
                    ferr[oidx/256] = ferr[oidx/256] + 1;
                    if (nerr <= 10)
                        $display("MISMATCH word %0d: got %08x want %08x (di=%0d dq=%0d)",
                                 oidx, m_tdata, gold_mem[oidx], di, dq);
                end
            end else begin
                nerr = nerr + 1;
                if (nerr <= 10) $display("EXTRA output word at %0d", oidx);
            end
            if (oidx % 256 == 255) begin
                if (m_tuser !== case_mem[oidx/256][0]) begin
                    nerr = nerr + 1;
                    $display("TUSER mismatch frame %0d: got %0d want %0d",
                             oidx/256, m_tuser, case_mem[oidx/256][0]);
                end
                if (m_tlast !== 1'b1) begin
                    nerr = nerr + 1;
                    $display("frame %0d: missing TLAST", oidx/256);
                end
            end
            if (m_tlast) frame_cnt = frame_cnt + 1;
            oidx = oidx + 1;
        end
    end

    // ── 每帧耗时（看第二遍 IDFT 是否吃掉帧预算；预算 20.2k 拍 @200MHz/101us）──
    integer cyc_busy = 0, cyc_idft = 0, npass2 = 0;
    reg tap_scale_d = 0;
    always @(posedge clk) begin
        if (rst_n) begin
            if (busy)              cyc_busy = cyc_busy + 1;
            if (u_dut.state == 5'd13) cyc_idft = cyc_idft + 1;   // ST_IDFT
            if (u_dut.tap_scale && !tap_scale_d) npass2 = npass2 + 1;
            tap_scale_d = u_dut.tap_scale;
            if (m_tvalid && m_tready && m_tlast) begin
                $display("frame %0d timing: busy %0d cyc, IDFT %0d cyc, second-pass starts %0d",
                         frame_cnt, cyc_busy, cyc_idft, npass2);
                cyc_busy = 0; cyc_idft = 0; npass2 = 0;
            end
        end
    end

    // ── 结束/看门狗 ────────────────────────────────────────────────────────
    initial begin
        wait (rst_n);
        while (frame_cnt < 9 && timeout < 500000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
        repeat (200) @(posedge clk);
        $display("---------------------------------------------");
        $display("output words : %0d", oidx);
        $display("frames       : %0d", frame_cnt);
        $display("max |err|    : %0d LSB", maxerr);
        $display("errors       : %0d", nerr);
        $display("  per frame  : %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                 ferr[0], ferr[1], ferr[2], ferr[3],
                 ferr[4], ferr[5], ferr[6], ferr[7], ferr[8]);
        $display("stat_drop    : %0d", stat_drop);
        $display("gate/theta   : last gate=%0d theta=%0d", stat_gate, stat_theta);
        if (nerr == 0 && oidx == 2304 && frame_cnt == 9)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");
        $display("---------------------------------------------");
        $finish;
    end

endmodule
