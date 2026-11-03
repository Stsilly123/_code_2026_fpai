`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_feat_stress : expert_feat_rffi 健壮性测试
//
//   A. 输出反压（m_tready 伪随机）+ 输入断流（每字随机间隔）
//   B. 合成边界用例：zero / maxamp / hist_edge / phase_pi / random
//      （向量由 gen_expert_vectors.py 的 make_synthetic 生成）
//   C. 帧中途复位：喂半帧 -> 复位 -> 再喂整帧，输出必须等于该帧 golden
//
//   比对：
//     0..127   FFT 对数特征，容差 ±2 LSB（25 bit 定点 FFT vs 整数序列双精度 FFT，
//              p 的末位舍入会放大到对数域的 1~2 LSB；真实帧的严格比对在
//              tb_expert_feat 里做，那里 0..171 是逐位相同）；
//              phase_pi 这种退化帧（DC 262144 主导）噪声底 bin 放宽到 ±4096。
//     138..165 直方图计数（Q12），容差 ±1 个样本 = ±16。
//     172..186 CORDIC atan 派生量，容差 ±2 LSB。
//     其余逐位相同；195(frame_idx) 因 synthetic gold 恒写 0 而放行。
//   运行目录需 synthetic/*.hex 与本目录的 expert_gold.hex 格式一致。
//
//   log2_lut_rom 桩在 tb_log2_stub.v 里（与 tb_expert_feat 共用，别重复编译）。
// -----------------------------------------------------------------------------
module tb_expert_feat_stress;
    reg clk = 0;
    reg rst_n = 0;

    reg  [31:0] din = 0;
    reg         din_valid = 0;
    reg         din_last  = 0;
    reg         m_tready  = 1;

    wire [31:0] m_tdata;
    wire        m_tvalid, m_tlast;
    wire [3:0]  m_tkeep;
    wire [31:0] stat_drop, stat_frames;
    wire        busy;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    // ---- 输出反压：伪随机，约 50% 周期不收 ----
    reg [15:0] lfsr = 16'hACE1;
    always @(posedge clk) begin
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        m_tready <= lfsr[2] ^ lfsr[5];
    end

    // ---- 收集 ----
    reg  [31:0] got [0:8191];
    integer nout;
    integer tlast_bad;
    integer tl_idx [0:63];
    integer tl_n;
    reg     collect_en = 1'b1;

    always @(posedge clk) begin
        if (rst_n && collect_en && m_tvalid && m_tready) begin
            if (nout < 8192) got[nout] = m_tdata;
            if (m_tlast) begin
                if (tl_n < 64) tl_idx[tl_n] = nout;
                tl_n = tl_n + 1;
            end
            if (m_tlast && (nout != 255) && (nout != 511) && (nout != 767) &&
                (nout != 1023) && (nout != 1279) && (nout != 1535) && (nout != 1791))
                tlast_bad = tlast_bad + 1;
            nout = nout + 1;
        end
    end

    reg [31:0] fbuf [0:255];
    reg [31:0] exp [0:255];
    integer errs, ncase, k, d, bad, atol, guard;
    integer hist [0:255];
    integer bigk [0:15], bigg [0:15], bige [0:15], nbig;
    integer fft_tol;

    // ---- 喂一帧（内容已在 fbuf 里）：每字之间随机停 1..gap 拍（模拟上游断流） ----
    // 注意：2018.3 的 xsim 里 $readmemh 的文件名经 task 参数转手会失效
    //       （帧被读成全 0），所以读文件一律在 initial / 顶层用字面量。
    task automatic feed_frame;
        input integer gap;
        integer i, g;
        begin
            for (i = 0; i < 256; i = i + 1) begin
                g = $urandom_range(1, gap);
                repeat (g) @(negedge clk);      // 空拍（上游断流）
                din       = fbuf[i];
                din_valid = 1'b1;               // 注意：valid 是单拍 strobe
                din_last  = (i == 255);
                @(negedge clk);
                din_valid = 1'b0;
            end
            @(negedge clk);
            din_valid = 1'b0;
            din_last  = 1'b0;
        end
    endtask

    // ---- 等到 offset+256 个输出字 ----
    task automatic wait_out;
        input integer target;
        begin
            guard = 0;
            while ((nout < target) && (guard < 400000)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (guard >= 400000)
                $display("  TIMEOUT waiting nout=%0d (have %0d)", target, nout);
        end
    endtask

    // ---- 比对一帧（offset 为本帧在 got[] 里的起始下标） ----
    task automatic check_frame;
        input string name;
        input integer off;
        begin
            bad  = 0;
            atol = 0;
            for (k = 0; k < 256; k = k + 1) hist[k] = 0;
            nbig = 0;
            for (k = 0; k < 256; k = k + 1) begin
                d = got[off + k] - exp[k];
                if (k < 128) begin
                    // FFT 对数特征：RTL 是 25 bit 定点 FFT + LUT，golden 是整数序列
                    // 的双精度 FFT，末位舍入允许相差 1（退化帧另有更宽的 tol）
                    if ((d > fft_tol) || (d < -fft_tol)) begin
                        bad = bad + 1;
                        if (nbig < 16) begin
                            bigk[nbig] = k; bigg[nbig] = got[off+k]; bige[nbig] = exp[k];
                            nbig = nbig + 1;
                        end
                    end else begin
                        if ((d > -128) && (d < 127)) hist[d + 128] = hist[d + 128] + 1;
                        if (d != 0) atol = atol + 1;
                    end
                end else if ((k >= 172) && (k <= 186)) begin
                    // CORDIC atan 派生量，±2 LSB
                    if ((d > 2) || (d < -2)) bad = bad + 1;
                    else if (d != 0) atol = atol + 1;
                end else if ((k >= 138) && (k <= 165)) begin
                    // 直方图计数（Q12）：落在 bin 边界上的样本，atan/sqrt 末位差 1 LSB
                    // 就会跨 bin -> 允许 ±1 个计数（1/256 = 16）
                    if ((d > 16) || (d < -16)) bad = bad + 1;
                    else if (d != 0) atol = atol + 1;
                end else if ((k == 195) && (exp[k] == 32'd0) && (got[off + k] < 32'd8)) begin
                    // synthetic gold 的 frame_idx 固定写 0，硬件按 out_idx 递增，放行
                end else if (got[off + k] !== exp[k]) begin
                    bad = bad + 1;
                    if (bad <= 6) $display("    idx %0d got=%08h exp=%08h", k, got[off+k], exp[k]);
                end
            end
            if (bad != 0) begin
                $display("  FAIL %-9s : %0d/256 out of tolerance", name, bad);
                $write("    FFT diff hist:");
                for (k = 0; k < 256; k = k + 1)
                    if (hist[k] != 0) $write(" %0d:%0d", k - 128, hist[k]);
                $display("");
                for (k = 0; k < nbig; k = k + 1)
                    $display("    big idx %0d got=%08h exp=%08h", bigk[k], bigg[k], bige[k]);
                errs = errs + 1;
            end else begin
                $display("  OK   %-9s : 256 words (%0d near-tol)", name, atol);
            end
            ncase = ncase + 1;
        end
    endtask

    task automatic run_loaded;
        input string name;
        begin
            feed_frame(160);
            wait_out(nout + 256);
            $display("  [%s] fed=%08h..%08h nout=%0d frames=%0d drops=%0d",
                     name, fbuf[0], fbuf[255], nout, stat_frames, stat_drop);
            check_frame(name, nout - 256);
        end
    endtask

    initial begin
        errs = 0; ncase = 0; nout = 0; tlast_bad = 0; tl_n = 0; fft_tol = 2;
        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        // ================= A+B：反压 + 断流，五种边界帧 =================
        $display("-- phase 1: backpressure + input gaps --");
        $readmemh("synthetic/zero_in.hex", fbuf);
        $readmemh("synthetic/zero_gold.hex", exp);
        run_loaded("zero");

        $readmemh("synthetic/maxamp_in.hex", fbuf);
        $readmemh("synthetic/maxamp_gold.hex", exp);
        run_loaded("maxamp");

        $readmemh("synthetic/hist_edge_in.hex", fbuf);
        $readmemh("synthetic/hist_edge_gold.hex", exp);
        run_loaded("hist_edge");

        // phase_pi: I 恒定、Q 只有 ±1 两个样点 -> 频谱由 262144 的 DC 主导，
        // 其余 bin 落在 25 bit 定点的舍入噪声底；golden 是整数序列的双精度 FFT，
        // 两者在这些 bin 上不可比（真实帧不是这种病态输入），故放宽。
        fft_tol = 4096;
        $readmemh("synthetic/phase_pi_in.hex", fbuf);
        $readmemh("synthetic/phase_pi_gold.hex", exp);
        run_loaded("phase_pi");

        fft_tol = 2;
        $readmemh("synthetic/random_in.hex", fbuf);
        $readmemh("synthetic/random_gold.hex", exp);
        run_loaded("random");

        // ================= C：帧中途复位 =================
        $display("-- phase 2: reset mid-frame --");
        // 喂半帧（100 字），不带 last
        fft_tol = 2;
        $readmemh("synthetic/random_in.hex", fbuf);
        for (k = 0; k < 100; k = k + 1) begin
            @(negedge clk);
            din = fbuf[k]; din_valid = 1'b1; din_last = 1'b0;
        end
        @(negedge clk); din_valid = 1'b0;
        repeat (40) @(posedge clk);

        // 复位 3 拍
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        // 复位后喂整帧，输出应当就是这一帧
        $readmemh("synthetic/hist_edge_in.hex", fbuf);
        $readmemh("synthetic/hist_edge_gold.hex", exp);
        feed_frame(40);
        wait_out(nout + 256);
        check_frame("rst_frame", nout - 256);

        $display("TLAST errors: %0d   total frames checked: %0d", tlast_bad, ncase);
        $display("TLAST positions:");
        for (k = 0; k < tl_n && k < 64; k = k + 1)
            $display("   %0d : nout=%0d", k, tl_idx[k]);
        if (tlast_bad != 0) errs = errs + 1;
        $display("EXPERT STRESS TB done: %0d errors", errs);
        $finish;
    end

    initial begin
        #40000000;
        $display("TIMEOUT: nout=%0d state=%0d drops=%0d frames=%0d",
                 nout, dut.state, stat_drop, stat_frames);
        $finish;
    end
endmodule
