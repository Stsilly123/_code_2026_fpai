// 仿真用 testbench（**不加入工程**，只用于离线验证 stream_buf 的帧切片逻辑）
//
// 上游建模：合法的 AXIS 主机——总线在**握手后的下一拍就把下一个 beat 摆上去**
//   （tvalid 保持），所以 beat 被接收后、模块输出高字那一拍，总线上已经是
//   **下一个** beat 的数据。这正是"高字取实时 tdata"那个 bug 的触发条件。
//
// 每个 beat 的数据按 16bit 字段独立编号，避免任何拼接位宽导致的静默截断：
//   beat b = { word(2b+1), word(2b) }
//   word(n) = {Q = A000+n, I = 0B00+n}    （非零、帧内互不相同）
// 解包后第 n 个字（n 从 0 起）必须**逐位**等于 word(n)，期望值由记分板算出。
//
// 用例：
//   clean 128beat/帧 × 8   -> 256 字/帧，无补零，8 帧 2048 字
//   short 100beat/帧 × 8   -> 每帧补 56 个 0（帧尾），8 帧 2048 字
//   long  160beat/帧 × 4   -> 每上游帧拆成 2 个输出帧（256 + 64 数据 +192 补零）
//   以上 three + 周期性拉 din_full 的版本，验证背压下不丢字/不重字
//
// 跑法（Vivado 自带 xsim，不会打开工程）：
//   xvlog stream_buf.v tb_stream_buf.v && xelab tb_stream_buf -s tbs && xsim tbs -runall
// 注：两个文件都不带 timescale，纯周期级仿真，只看拍数。
module tb_stream_buf;

localparam WPF = 256;

reg         clk = 0;
reg         rst_n = 0;
reg  [63:0] tdata = 64'd0;
reg  [7:0]  tkeep = 8'hFF;
reg         tvalid = 1'b0;
reg         tlast = 1'b0;
wire        tready;
wire [32:0] dout;
wire        dvld;
reg         din_full = 0;

integer beat;         // 当前摆在总线上的 beat 序号
integer up_beats;     // 上游每帧多少 beat
integer up_frames;    // 本次测试多少个上游帧
integer total_beats;  // 总共发多少 beat
integer case_id;      // 0 = clean, 1 = short, 2 = long
reg     stream_en;
reg     full_en;      // 周期性拉 din_full
integer full_cnt;

always #5 clk = ~clk;

stream_buf #(.WORDS_PER_FRAME(WPF)) dut (
    .sclk       (clk),
    .s_rst_n    (rst_n),
    .s_tlast    (tlast),
    .s_tvalid   (tvalid),
    .s_tready   (tready),
    .s_tdata    (tdata),
    .s_tkeep    (tkeep),
    .din_full   (din_full),
    .data_o     (dout),
    .data_valid (dvld)
);

// 输入/输出字模型：word(n) = {Q = A000+n, I = 0B00+n}（16bit 字段各算各的）
function [31:0] wordf;
    input integer n;
    begin
        wordf = {16'hA000 + n, 16'h0B00 + n};
    end
endfunction

// 期望输出：把上游字流按 256 字切帧后的第 n 个字
//   上游每帧 up_words = 2*up_beats 个字，会被切成 pf = ceil(up_words/256) 个输出帧；
//   第 uf 个上游帧、其第 j 个输出帧里，真实数据从输入字 up_words*uf + 256*j 起，
//   最多 256 个字，不足的部分补 0（上游 tlast 之前就结束了）。
function [31:0] exp_word;
    input integer n;
    integer f, k, pf, uf, j, base;
    begin
        f  = n / WPF;
        k  = n % WPF;
        pf = ((2*up_beats) + WPF - 1) / WPF;
        uf = f / pf;
        j  = f % pf;
        base = (2*up_beats) * uf + WPF * j;
        if (k < ((2*up_beats) - WPF*j))
            exp_word = wordf(base + k);
        else
            exp_word = 32'd0;
    end
endfunction

function exp_last;
    input integer n;
    begin
        exp_last = ((n % WPF) == (WPF - 1));
    end
endfunction

// ── 上游：寄存驱动，握手完成才换 beat，下一拍立刻摆下一个 beat ──────────────
always @(posedge clk) begin
    if (!rst_n) begin
        beat   <= 0;
        tvalid <= 1'b0;
        tlast  <= 1'b0;
        tdata  <= 64'd0;
    end
    else if (tvalid && tready) begin
        if ((beat + 1) >= total_beats) begin
            tvalid <= 1'b0;                      // 发完，撤 valid
        end
        else begin
            tvalid <= 1'b1;
            tdata  <= {wordf(2*(beat+1) + 1), wordf(2*(beat+1))};
            tlast  <= (((beat + 1) % up_beats) == (up_beats - 1));
        end
        beat <= beat + 1;
    end
    else if (stream_en && !tvalid && (beat < total_beats)) begin
        tvalid <= 1'b1;                          // 启动：把 beat=0 摆上去
        tdata  <= {wordf(2*beat + 1), wordf(2*beat)};
        tlast  <= ((beat % up_beats) == (up_beats - 1));
    end
end

// ── 周期性背压（用例 4/5）────────────────────────────────────────────────
always @(posedge clk) begin
    if (!rst_n) begin
        full_cnt <= 0;
        din_full <= 1'b0;
    end
    else if (full_en) begin
        full_cnt <= full_cnt + 1;
        din_full <= ((full_cnt % 7) !== 0);      // 6/7 的拍 FIFO 是满的
    end
    else begin
        full_cnt <= 0;
        din_full <= 1'b0;
    end
end

// ── 下游记分板 ──────────────────────────────────────────────────────────
integer nw;        // 收到的总字数
integer errs;
integer zeros;
reg [31:0] e;

always @(posedge clk) begin
    if (rst_n && dvld) begin
        e = exp_word(nw);
        if (dout[31:0] !== e) begin
            if (errs < 12)
                $display("   !! word %0d: got Q=%04h I=%04h, exp Q=%04h I=%04h",
                         nw, dout[31:16], dout[15:0], e[31:16], e[15:0]);
            errs = errs + 1;
        end
        if (dout[32] !== exp_last(nw)) begin
            if (errs < 12)
                $display("   !! word %0d: last=%b, exp %b", nw, dout[32], exp_last(nw));
            errs = errs + 1;
        end
        if (dout[31:0] === 32'd0) zeros = zeros + 1;
        nw = nw + 1;
    end
end

// ── 流程 ────────────────────────────────────────────────────────────────
task do_reset;
    begin
        rst_n = 1'b0; stream_en = 1'b0; full_en = 1'b0;
        tvalid = 1'b0; tlast = 1'b0; tdata = 64'd0;
        beat = 0;
        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    end
endtask

task run_case(input [127:0] name, input integer up_b, input integer frames,
              input integer cid, input integer use_full);
    integer pf, exp_total, guard;
    begin
        do_reset;
        up_beats    = up_b;
        up_frames   = frames;
        total_beats = up_b * frames;
        case_id     = cid;
        full_en     = use_full;
        beat = 0; nw = 0; errs = 0; zeros = 0;
        pf        = ((2*up_b) + WPF - 1) / WPF;
        exp_total = frames * pf * WPF;

        stream_en = 1'b1;
        @(posedge clk);

        while (tvalid) @(posedge clk);           // 等上游发完
        guard = 0;
        while ((nw < exp_total) && (guard < 200000)) begin
            @(posedge clk); guard = guard + 1;
        end
        repeat (60) @(posedge clk);              // 再等一段，看不该来的字有没有来
        stream_en = 1'b0;

        if (nw !== exp_total) begin
            $display("   !! total words = %0d, exp %0d", nw, exp_total);
            errs = errs + 1;
        end
        $display("[%0s] up %0d beat/frame x %0d frame, full=%0d -> %0d words, %0d frames, %0d zeros, %0d errs",
                 name, up_b, frames, use_full, nw, nw/WPF, zeros, errs);
    end
endtask

initial begin
    $display("================ tb_stream_buf ================");

    // 1) clean：128 beat/帧 = 256 字/帧，tlast 正好落在第 256 字 -> 不该有补零
    run_case("clean 128b/f", 128, 8, 0, 0);

    // 2) short：100 beat/帧 = 200 字/帧 -> 每帧帧尾补 56 个 0，不吃下一帧的头
    run_case("short 100b/f", 100, 8, 1, 0);

    // 3) long：160 beat/帧 = 320 字/帧 -> 第 256 字强制切帧，多出的 64 字进下一帧
    run_case("long  160b/f", 160, 4, 2, 0);

    // 4) 5) 背压版本：FIFO 6/7 的拍是满的，字数与内容必须一模一样
    run_case("clean+full", 128, 2, 0, 1);
    run_case("short+full", 100, 2, 1, 1);

    $display("================ done, errs = %0d ================", errs);
    $finish;
end

endmodule
