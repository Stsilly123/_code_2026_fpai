`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_expert_race : 现象 B（整条 193 维特征错乱）的竞态复现
//
// 上板真实节奏：expert 的输入不是 DMA 直灌，而是 stream_buf 写 FIFO 的那一路
// (hls_din/hls_wr)，写速被 HLS 的取数速率卡住（约 1 字 / 9.9 拍）。expert 每帧
// 处理要几千拍，所以输入环比处理快，nfull 长期贴着 8。
//
// 顶层 S_IDLE 消耗一帧时就把 nfull 减 1（槽位当场"释放"），但这一帧的样点还要在
// S_ZN 里读 ~1000 拍。环 8 槽：nfull=7 时写指针 W = C+7 = 上一个被消耗的槽
// （= 正在 S_ZN 读的 rd_slot）。只要下一帧输入帧边界落在 S_ZN 窗口里，新帧就
// 直接写进正在读的槽 —— zn 读到的是两帧样点的混合，整条向量就错，且每次错法固定。
//
// 本 TB：
//   * 每次"调用"= 8 份相同帧（相邻调用不同），和 PS 的 diag_expert_shift0 一致；
//   * 输入端持续供数（1 字 / GAP 拍），不等输出 —— 复现板上环被灌满的稳态；
//   * 逐帧收集输出，对 NCALL 份 golden 取最小失配：最小失配 > TOLMAX 即判错乱；
//   * 同时监视 "S_ZN 期间写进 rd_slot" 这个事件。
//
// 判据：EXPERT RACE TB: corrupt=0 collision=0
// -----------------------------------------------------------------------------
module tb_expert_race;
    parameter NCALL   = 32;     // golden 帧数（每次调用一份）
    parameter NCALLS  = 8;      // 喂多少次调用（可回头重复用 golden）
    // 板上供数节奏（stream_buf -> FIFO -> HLS 取数）：
    //   每次调用写 2048 字，FIFO 有 512 空位 ⇒ 前 512 字背靠背（2 拍/字），
    //   之后被 HLS 的 ~1 字/9.9 拍卡住 ⇒ 10 拍/字。
    //   expert 的写口因此是"一阵快、一阵慢"；快的那阵能跑赢 zn（4.15 拍/字）。
    parameter FASTW   = 512;    // 每次调用里背靠背的字数（1 字 / 拍）
    parameter SLOWDLY = 9;      // 慢段：1 字 / (1+SLOWDLY) 拍
    parameter DIRECTED = 1;     // 1: 定向把"调用开头快灌"对齐到 S_ZN 起点
    parameter DISTINCT = 1;     // 1: 相邻帧用不同 golden（任何混帧都会露馅）
                                // 0: 每次调用 8 份相同帧（完全照板上用法，但混进来的
                                //    往往是同一次调用的另一份拷贝，混了也看不出来）
    parameter MAXOUT  = 256;    // 最多收多少输出帧

    // 激励数组直接按 golden 文件大小开：32 份调用 x 8 帧 x 256 字。
    // （DIRECTED 里要喂"第 9 份调用"的帧，NFW 若按 NCALLS 算就会越界读成 x，
    //   x 参与比较时 `d > 2` / `d != 0` 全是 x→假，错乱帧会被误判成"接近某个 golden"。）
    localparam NFW    = NCALL * 8 * 256;
    localparam TOLMAX = 12;     // 与最优 golden 的失配上限（172..186 容差 +-2）

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
    reg [31:0] gold [0:NCALL*256-1];
    reg [31:0] got  [0:MAXOUT*256-1];

    integer nout_w;      // 已收字数
    integer nframe;      // 已收整帧数
    integer collisions;
    integer errs;
    integer i, j, k, g, f, best, dbest, d, nmis, idx, guard, xn;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    // ---- 输出收集：输出永远是 256 拍/帧、TLAST 收尾，顺序存即可 ----
    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
            if (nout_w < MAXOUT*256) got[nout_w] = m_tdata;
            nout_w = nout_w + 1;
            if (m_tlast) nframe = nframe + 1;
        end
    end

    // ---- 直接盯住根因：S_ZN 期间往正在读的槽写样点 ----
    // dut 内部状态编码：S_IDLE=0, S_ZN=1（见 expert_feat_rffi.v 的 localparam）
    wire        dvalid_r = dut.dvalid_r;
    wire        cap_now  = dut.cap_now;
    wire [4:0]  dstate   = dut.state;
    wire [2:0]  wr_frame = dut.wr_frame;
    wire [2:0]  rd_slot  = dut.rd_slot;
    wire [7:0]  in_cnt   = dut.in_cnt;

    always @(posedge clk) begin
        if (rst_n && dvalid_r && cap_now && (dstate == 5'd1) && (wr_frame == rd_slot)) begin
            if (collisions < 8)
                $display("  COLLISION @%0t: 槽 %0d 写 idx=%0d / zn 读 addr=%0d (zn_state=%0d)",
                         $time, rd_slot, in_cnt, dut.zn_src_addr, dut.u_zn.state);
            collisions = collisions + 1;
        end
    end

    // ---- 激励 ----
    integer prev_state;
    initial begin
        $readmemh("expert_in_rep.hex", raw);
        $readmemh("gold_rep.hex", gold);
        nout_w = 0; nframe = 0; collisions = 0; errs = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        if (DIRECTED) begin
            // 定向版：把"下一次调用开头那阵快灌"对齐到 S_ZN 起点
            //   1) 背靠背灌 9 帧（帧帧不同）→ 8 槽环灌满，正在处理的那帧之后
            //      还排着 8 帧，下一次消耗时 nfull 正好 8→7
            for (f = 0; f < 9; f = f + 1)
                for (i = 0; i < 256; i = i + 1) begin
                    @(negedge clk);
                    din = raw[f*2048 + i];
                    din_valid = 1'b1;
                    din_last  = (i == 255);
                end
            @(negedge clk); din_valid = 1'b0; din_last = 1'b0;

            //   2) 等到下一次 S_ZN 的起点（此刻 nfull 刚被消耗成 7）
            prev_state = dstate;
            guard = 0;
            while (!((dstate == 5'd1) && (prev_state == 5'd0)) && (guard < 500000)) begin
                prev_state = dstate;
                @(posedge clk);
                guard = guard + 1;
            end
            $display("  DIRECTED: S_ZN 起点 nfull=%0d rd_busy=%0d guard=%0d",
                     dut.nfull, dut.rd_busy, guard);

            //   3) 立刻背靠背再灌 1 帧 —— 这是板上"下一次调用开头快灌"对齐到
            //      S_ZN 的最坏情况：写侧 1 字/拍，zn 4.15 拍/字
            for (i = 0; i < 256; i = i + 1) begin
                @(negedge clk);
                din = raw[8*2048 + i];
                din_valid = 1'b1;
                din_last  = (i == 255);
            end
            @(negedge clk); din_valid = 1'b0; din_last = 1'b0;
        end else begin
            // 连续供数版：按板上"每次调用开头 512 字背靠背、其余被 HLS 限速"的节奏
            for (k = 0; k < NFW; k = k + 1) begin
                @(negedge clk);
                if (DISTINCT)
                    // 每一帧都换成不同 golden：混帧一定匹配不上任何 golden
                    din = raw[(((k / 256) % NCALL) * 2048) + (k % 256)];
                else
                    din = raw[(k % (NCALL*2048))];     // 板上用法：8 份相同帧
                din_valid = 1'b1;
                din_last  = ((k % 256) == 255);
                if (((k + 1) % 2048) < FASTW) begin
                    // 快段：背靠背，本字在下一拍被采，下一轮直接换字
                end else begin
                    @(negedge clk);                    // 本字被采
                    din_valid = 1'b0;
                    din_last  = 1'b0;
                    repeat (SLOWDLY) @(negedge clk);   // 被 HLS 取数限速的慢段
                end
            end
        end

        // 等输出排空：nfull 归零且 FSM 空闲，最多再等 2M 拍
        for (j = 0; j < 2000000; j = j + 1) begin
            @(posedge clk);
            if ((dut.nfull == 4'd0) && (dut.state == 5'd0) && (dut.out_active == 1'b0)) j = 2000000;
        end

        // ---- 判定：每个输出帧对 32 份 golden 取最小失配 ----
        $display("---- 输出 %0d 帧（输入 %0d 字，drops=%0d, in_frames=%0d）----",
                 nframe, NFW, stat_drop, stat_frames);
        $display("dbg got0 : %08h %08h %08h %08h | %08h %08h %08h %08h",
                 got[0], got[1], got[2], got[3], got[193], got[194], got[195], got[196]);
        for (g = 0; g < 4; g = g + 1)
            $display("dbg gold%0d: %08h %08h %08h %08h | %08h %08h %08h %08h",
                     g, gold[g*256], gold[g*256+1], gold[g*256+2], gold[g*256+3],
                     gold[g*256+193], gold[g*256+194], gold[g*256+195], gold[g*256+196]);
        // 每个错乱帧：逐字归类 1=与 gold[idx-1] 同、8=与 gold[8] 同、?=都不是
        for (f = 0; f < nframe && f < MAXOUT; f = f + 1) begin
            best = 9999; dbest = -1;
            for (g = 0; g < NCALL; g = g + 1) begin
                nmis = 0;
                for (i = 0; i < 256; i = i + 1) begin
                    d = got[f*256+i] - gold[g*256+i];
                    if (d < 0) d = -d;
                    if (i <= 127 || (i >= 172 && i <= 186)) begin
                        // x 必须算失配：x 与常数比较得 x，if(x) 当假，整帧 x 会被
                        // 误判成"落在容差内"（自己踩过一次）。
                        if ((d > 2) || (d < -2) || ((^d) === 1'bx)) nmis = nmis + 1;
                    end else if ((d != 0) || ((^d) === 1'bx)) nmis = nmis + 1;
                end
                if (nmis < best) begin best = nmis; dbest = g; end
            end
            if (best > TOLMAX) begin
                j = 0; xn = 0;
                for (i = 0; i < 256; i = i + 1) begin
                    if (got[f*256+i] === gold[1*256+i]) j = j + 1;
                    if ((^got[f*256+i]) === 1'bx)      xn = xn + 1;
                end
                $display("dbg frame %0d: %0d/256 equal gold1, %0d/256 are X, best=%0d(g%0d)",
                         f, j, xn, best, dbest);
            end
        end
        for (f = 0; f < nframe && f < MAXOUT; f = f + 1) begin
            best  = 9999;
            dbest = -1;
            for (g = 0; g < NCALL; g = g + 1) begin
                nmis = 0;
                for (i = 0; i < 256; i = i + 1) begin
                    d = got[f*256+i] - gold[g*256+i];
                    if (d < 0) d = -d;
                    // 0..127 是 FFT 对数幅度（golden 模型与 RTL 差 ±2 LSB），
                    // 172..186 走 CORDIC atan（±2 LSB）；其余逐位相同
                    if (i <= 127 || (i >= 172 && i <= 186)) begin
                        // x 必须算失配：x 与常数比较得 x，if(x) 当假，整帧 x 会被
                        // 误判成"落在容差内"（自己踩过一次）。
                        if ((d > 2) || (d < -2) || ((^d) === 1'bx)) nmis = nmis + 1;
                    end else if ((d != 0) || ((^d) === 1'bx)) nmis = nmis + 1;
                end
                if (nmis < best) begin best = nmis; dbest = g; end
            end
            if (best > TOLMAX) begin
                errs = errs + 1;
                if (errs <= 20)
                    $display("  frame %0d: CORRUPT  best golden=%0d mismatch=%0d (ctr=%0d)",
                             f, dbest, best, got[f*256+195] & 7);
            end
        end

        $display("EXPERT RACE TB: frames=%0d corrupt=%0d collision=%0d drops=%0d",
                 nframe, errs, collisions, stat_drop);
        if (errs != 0 || collisions != 0) $display("RESULT: FAIL");
        else                              $display("RESULT: PASS");
        $finish;
    end

    initial begin
        #200000000;
        $display("TIMEOUT: nout_w=%0d state=%0d collisions=%0d", nout_w, dut.state, collisions);
        $finish;
    end
endmodule
