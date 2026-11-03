`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_feat : expert_feat_rffi 端到端自测
//
//   连续灌 8 帧（2048 字，din_last 在第 256/512/... 字），
//   收 8 帧 AXIS 输出（每帧 256 字，word255=TLAST），
//   与 expert_gold.hex（8 x 256 打包字，含帧头）逐字比对。
//
//   运行目录需要：expert_in.hex、expert_gold.hex、log2_lut.hex、expert_rom.vh
//   另需 xfft_256.vhd、cordic_vl.vhd；log2_lut_rom 桩在 tb_log2_stub.v。
// -----------------------------------------------------------------------------

module tb_expert_feat;
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
    reg [31:0] got  [0:2047];

    integer nout;
    integer k, guard, errs, nbad, ntol, idx, d;
    integer t0, t1, tframe0;
    integer k_last;
    integer nframes_out;

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
            if (nout < 2048) got[nout] = m_tdata;
            nout = nout + 1;
            if (m_tlast) nframes_out = nframes_out + 1;
        end
    end

    initial begin
        $readmemh("expert_in.hex", raw);
        $readmemh("expert_gold.hex", gold);
        nout = 0;
        nframes_out = 0;
        errs = 0;
        t0 = 0; t1 = 0; tframe0 = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        // ---- 连续灌 8 帧 ----
        t0 = $time;
        for (k = 0; k < 2048; k = k + 1) begin
            @(negedge clk);
            din = raw[k];
            din_valid = 1'b1;
            din_last = ((k % 256) == 255);
        end
        @(negedge clk);
        din_valid = 0;
        din_last = 0;
        k_last = k;

        // ---- 等输出收满 ----
        guard = 0;
        while ((nout < 2048) && (guard < 3000000)) begin
            @(posedge clk);
            guard = guard + 1;
        end
        t1 = $time;

        $display("capture: nout=%0d frames=%0d drop=%0d in_frames=%0d busy=%0d",
                 nout, nframes_out, stat_drop, stat_frames, busy);
        $display("elapsed %.1f us (%.2f cycles/frame)",
                 (t1 - t0) / 1000.0, (t1 - t0) / 5.0 / 8.0);

        if (nout != 2048) begin
            $display("FAIL: only %0d output words (timeout)", nout);
            errs = errs + 1;
        end

        // ---- 逐字比对 ----
        //  172..186 是累积量相角与 CFO，走 CORDIC atan，与理想 atan 允许 ±2 LSB；
        //  其余全部要求逐位相同。
        nbad = 0;
        ntol = 0;
        for (k = 0; k < 2048; k = k + 1) begin
            idx = k % 256;
            d   = got[k] - gold[k];
            if ((idx >= 172) && (idx <= 186)) begin
                if ((d > 2) || (d < -2)) begin
                    if (nbad < 40)
                        $display("  DIFF word=%0d (frame %0d idx %0d): got=%08h exp=%08h d=%0d",
                                 k, k / 256, idx, got[k], gold[k], d);
                    nbad = nbad + 1;
                end else if (d != 0) begin
                    ntol = ntol + 1;
                end
            end else if (got[k] !== gold[k]) begin
                if (nbad < 40)
                    $display("  DIFF word=%0d (frame %0d idx %0d): got=%08h exp=%08h d=%0d",
                             k, k / 256, idx, got[k], gold[k], d);
                nbad = nbad + 1;
            end
        end
        $display("CORDIC atan 区间 (172..186): %0d 字在 ±2 LSB 内", ntol);
        if (nbad != 0) begin
            $display("MISMATCH: %0d / 2048 words", nbad);
            errs = errs + 1;
        end else begin
            $display("E2E OK: 8 frames x 256 words (atan 区间 ±2 LSB)");
        end

        // ---- 分块统计 ----
        for (k = 0; k < 8; k = k + 1) begin : blk
            integer b;
            b = 0;
            for (k_last = 0; k_last < 256; k_last = k_last + 1) begin
                d = got[k*256+k_last] - gold[k*256+k_last];
                if ((k_last >= 172) && (k_last <= 186)) begin
                    if ((d > 2) || (d < -2)) b = b + 1;
                end else if (got[k*256+k_last] !== gold[k*256+k_last]) b = b + 1;
            end
            $display("frame %0d: %0d/256 words out of tolerance", k, b);
        end

        $display("EXPERT E2E TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #20000000;
        $display("TIMEOUT: nout=%0d state=%0d drops=%0d in_frames=%0d",
                 nout, dut.state, stat_drop, stat_frames);
        $finish;
    end

    // 观察每帧处理时间
    reg [4:0] prev_state = 0;
    integer cyc = 0;
    always @(posedge clk) begin
        cyc = cyc + 1;
        if (dut.state == 5'd0 && prev_state == 5'd12) begin
            $display("  frame processed at cycle %0d", cyc);
        end
        prev_state = dut.state;
    end
endmodule
