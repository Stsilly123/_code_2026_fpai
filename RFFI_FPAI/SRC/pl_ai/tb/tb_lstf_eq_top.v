`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 顶层联调 TB：顶层就是 Signal_process，lstf_eq 在里面例化
//   编译时必须带 -d LSTF_EQ_SIM（把 fifo_generator / LcwtMLP IP 换成空桩）
//
//   输入：9 帧 × 128 beat（64bit = {Q1,I1,Q0,I0}），共 1152 beat / 2304 字
//   输出：eq 口 2304 字，与 eq_gold.hex 逐字比 |Δ|<=1 LSB
//         每 256 字一个 TLAST，eq_tuser 与 eq_case.hex 对齐（1 = 旁路帧）
//////////////////////////////////////////////////////////////////////////////////
module tb_lstf_eq_top;

    reg         sclk = 0;
    reg         s_rst_n = 0;
    always #2.5 sclk = ~sclk;           // 200 MHz

    reg  [63:0] s_tdata  = 0;
    reg  [7:0]  s_tkeep  = 8'hFF;
    reg         s_tvalid = 0;
    reg         s_tlast  = 0;
    wire        s_tready;

    wire [31:0] dout_TDATA;
    wire        dout_TVALID;
    reg         dout_TREADY = 1;
    wire [3:0]  dout_TKEEP;
    wire        dout_TLAST;

    wire [31:0] eq_TDATA;
    wire        eq_TVALID;
    reg         eq_TREADY = 1;
    wire [3:0]  eq_TKEEP;
    wire        eq_TLAST;
    wire        eq_tuser;
    wire [31:0] eq_stat_drop;
    wire [22:0] eq_stat_theta;
    wire        eq_stat_gate;
    wire        eq_busy;

    Signal_process u_dut (
        .sclk           (sclk),
        .s_rst_n        (s_rst_n),
        .s_tdata        (s_tdata),
        .s_tkeep        (s_tkeep),
        .s_tvalid       (s_tvalid),
        .s_tlast        (s_tlast),
        .s_tready       (s_tready),
        .dout_TDATA     (dout_TDATA),
        .dout_TVALID    (dout_TVALID),
        .dout_TREADY    (dout_TREADY),
        .dout_TKEEP     (dout_TKEEP),
        .dout_TLAST     (dout_TLAST),
        .eq_TDATA       (eq_TDATA),
        .eq_TVALID      (eq_TVALID),
        .eq_TREADY      (eq_TREADY),
        .eq_TKEEP       (eq_TKEEP),
        .eq_TLAST       (eq_TLAST),
        .eq_tuser       (eq_tuser),
        .eq_stat_drop   (eq_stat_drop),
        .eq_stat_theta  (eq_stat_theta),
        .eq_stat_gate   (eq_stat_gate),
        .eq_busy        (eq_busy)
    );

    reg [31:0] in_mem   [0:2303];
    reg [31:0] gold_mem [0:2303];
    reg [31:0] case_mem [0:8];

    initial begin
        $readmemh("eq_in.hex",   in_mem);
        $readmemh("eq_gold.hex", gold_mem);
        $readmemh("eq_case.hex", case_mem);
    end

    integer b;
    integer beat_total = 0;

    // ── 上游：1152 个 64bit beat，低 32bit 先出 ─────────────────────────────
    initial begin
        s_rst_n <= 1'b0;
        repeat (10) @(posedge sclk);
        s_rst_n <= 1'b1;
        @(posedge sclk);

        s_tkeep  = 8'hFF;
        b = 0;
        while (b < 1152) begin
            // 在下降沿摆数据，避免和 DUT 在上升沿采样竞争
            @(negedge sclk);
            s_tdata  = {in_mem[2*b+1], in_mem[2*b]};
            s_tlast  = ((b % 128) == 127);
            s_tvalid = 1'b1;
            @(posedge sclk);
            if (s_tready) begin
                beat_total = beat_total + 1;
                b = b + 1;
                // 帧间留 80us（16k 拍）：9 帧超过 lstf_eq 的 8 槽缓冲，
                // 连续灌会丢帧；真实系统也是 ~101us 一帧。
                if (b % 128 == 0) begin
                    s_tvalid = 1'b0;            // 帧间空闲，别让同一个 beat 被重复接收
                    s_tlast  = 1'b0;
                    repeat (16000) @(posedge sclk);
                end
            end
        end
        @(negedge sclk);
        s_tvalid = 1'b0;
        s_tlast  = 1'b0;
    end

    // ── 记分板 ─────────────────────────────────────────────────────────────
    integer widx = 0;
    integer frame_cnt = 0;
    integer nerr = 0;
    integer maxerr = 0;
    reg [15:0] oi, gi, oq, gq;
    integer di, dq;

    always @(posedge sclk) begin
        if (s_rst_n && eq_TVALID && eq_TREADY) begin
            if (widx < 2304) begin
                oi = eq_TDATA[15:0];
                gi = gold_mem[widx][15:0];
                oq = eq_TDATA[31:16];
                gq = gold_mem[widx][31:16];
                di = $signed({1'b0, oi}) - $signed({1'b0, gi});
                dq = $signed({1'b0, oq}) - $signed({1'b0, gq});
                if (di < 0) di = -di;
                if (dq < 0) dq = -dq;
                if (di > maxerr) maxerr = di;
                if (dq > maxerr) maxerr = dq;
                if (di > 1 || dq > 1) begin
                    nerr = nerr + 1;
                    if (nerr <= 10)
                        $display("MISMATCH word %0d: got %08x want %08x (di=%0d dq=%0d)",
                                 widx, eq_TDATA, gold_mem[widx], di, dq);
                end
            end else begin
                nerr = nerr + 1;
                if (nerr <= 10) $display("EXTRA output word at %0d", widx);
            end
            if (widx % 256 == 255) begin
                if (eq_tuser !== case_mem[widx/256][0]) begin
                    nerr = nerr + 1;
                    $display("TUSER mismatch frame %0d: got %0d want %0d",
                             widx/256, eq_tuser, case_mem[widx/256][0]);
                end
                if (eq_TLAST !== 1'b1) begin
                    nerr = nerr + 1;
                    $display("frame %0d: missing TLAST", widx/256);
                end
            end
            if (eq_TLAST) frame_cnt = frame_cnt + 1;
            widx = widx + 1;
        end
    end

    // ── 旁证：进均衡器的字数、stream_buf 补零次数、丢帧事件 ────────────────
    integer nwr = 0;
    integer npad = 0;
    reg [31:0] drop_prev = 0;
    always @(posedge sclk) begin
        if (s_rst_n && u_dut.hls_wr)      nwr  = nwr + 1;
        if (s_rst_n && u_dut.u_stream_buf.wr_pad) npad = npad + 1;
        if (s_rst_n && u_dut.u_lstf_eq.stat_drop_r != drop_prev) begin
            $display("DROP #%0d t=%0t frames_avail=%0d wr_slot=%0d rd_slot=%0d wr_word=%0d work_slot=%0d state=%0d",
                     u_dut.u_lstf_eq.stat_drop_r, $time,
                     u_dut.u_lstf_eq.frames_avail, u_dut.u_lstf_eq.wr_slot,
                     u_dut.u_lstf_eq.rd_slot, u_dut.u_lstf_eq.wr_word,
                     u_dut.u_lstf_eq.work_slot, u_dut.u_lstf_eq.state);
            drop_prev = u_dut.u_lstf_eq.stat_drop_r;
        end
    end

    // dout 这条（HLS）在仿真桩里应当一直安静
    always @(posedge sclk) begin
        if (s_rst_n && dout_TVALID)
            $display("unexpected dout_TVALID (stub should be quiet)");
    end

    // ── 结束/看门狗 ────────────────────────────────────────────────────────
    integer timeout = 0;
    initial begin
        wait (s_rst_n);
        while (frame_cnt < 9 && timeout < 1400000) begin
            @(posedge sclk);
            timeout = timeout + 1;
        end
        repeat (200) @(posedge sclk);
        $display("---------------------------------------------");
        $display("input beats  : %0d (expect 1152)", beat_total);
        $display("words written: %0d (expect 2304), pad words %0d", nwr, npad);
        $display("output words : %0d", widx);
        $display("frames       : %0d", frame_cnt);
        $display("max |err|    : %0d LSB", maxerr);
        $display("errors       : %0d", nerr);
        $display("stat_drop    : %0d", eq_stat_drop);
        $display("gate/theta   : last gate=%0d theta=%0d", eq_stat_gate, eq_stat_theta);
        if (nerr == 0 && widx == 2304 && frame_cnt == 9 && beat_total == 1152)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");
        $display("---------------------------------------------");
        $finish;
    end

endmodule
