`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// expert_feat_rffi : 193 维专家特征提取顶层（纯 PL RTL）
//
//   输入：与 lstf_eq 同一个抽头 —— Signal_process 里的 hls_din[31:0]/hls_wr，
//         每帧 256 个字，{Q[31:16], I[15:0]}，I/Q 都是 16-bit 有符号原始样点。
//   输出：AXIS 32-bit，每帧 256 个字，word255 带 TLAST；8 帧 = 8192 B。
//
//   输入环形缓冲 8 帧（8 x 256 x 32 = 8192 B）。处理不过来时丢「新来的这一帧」
//   （整帧丢弃，不破坏已缓存帧），stat_drop 计数。
//
//   每帧顺序执行（共享一个 sqrt / 一个 atan / 一个 log2）：
//     ZN -> LNRMS -> FFT -> DWT_I -> DWTF_I -> DWT_Q -> DWTF_Q
//        -> HIST -> CUM -> CFO -> POW -> PACK
//
//   特征布局（与黄金模型 gen_expert_vectors.py 一致，Q12）：
//     0..127   FFT 对数幅度（去均值）
//     128..132 DWT I 通道 cA4,cD4,cD3,cD2,cD1
//     133..137 DWT Q 通道 cA4,cD4,cD3,cD2,cD1
//     138..153 幅度直方图 16 格（计数 x16）
//     154..165 相位直方图 12 格（计数 x16）
//     166..171 累积量模 c20,c40,c41,c42,c60,c63
//     172..177 累积量相角
//     178..186 CFO [ang20,mag20,ang1,mag1,b0,b1,b2,b3,bstd]
//     187..192 功率 [log_rms,std_az,mean_az3,mean_az4,mean_x,mean_q]
//     193..197 帧头 0x45584631, 1, frame_idx, 12, 0
//     198..255 0
// -----------------------------------------------------------------------------
module expert_feat_rffi (
    input  wire        clk,
    input  wire        rst_n,
    // 输入样点流
    input  wire [31:0] din,
    input  wire        din_valid,
    input  wire        din_last,
    // 特征 AXIS 输出
    output wire [31:0] m_tdata,
    output wire        m_tvalid,
    input  wire        m_tready,
    output wire        m_tlast,
    output wire [3:0]  m_tkeep,
    // 统计（给 PS 看）
    output reg  [31:0] stat_drop,
    output reg  [31:0] stat_frames,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam [31:0] FRAME_MAGIC = 32'h45584631;

    // 状态编码
    localparam [4:0] S_IDLE   = 5'd0,
                     S_ZN     = 5'd1,
                     S_LNRMS  = 5'd2,
                     S_FFT    = 5'd3,
                     S_DWT_I  = 5'd4,
                     S_DWTF_I = 5'd5,
                     S_DWT_Q  = 5'd6,
                     S_DWTF_Q = 5'd7,
                     S_HIST   = 5'd8,
                     S_CUM    = 5'd9,
                     S_CFO    = 5'd10,
                     S_POW    = 5'd11,
                     S_PACK   = 5'd12;

    // ------------------------------------------------------------------
    // 存储
    // ------------------------------------------------------------------
    reg  [31:0] frame_ram [0:2047];      // 8 帧 x 256 字原始样点
    reg  [31:0] zn_ram    [0:255];       // 当前帧归一化样点
    reg  [31:0] fft_ram   [0:127];       // FFT 对数幅度
    reg  [31:0] feat_ram  [0:511];       // 特征输出乒乓 2 x 256

    reg signed [23:0] sum_x_buf [0:7];
    reg signed [23:0] sum_q_buf [0:7];
    reg  [39:0]       sum_sq_buf[0:7];

    // ------------------------------------------------------------------
    // 状态寄存器
    // ------------------------------------------------------------------
    reg [4:0] state;
    reg       st;                // 0:发 start  1:等 done
    reg [2:0] ln_st;             // LNRMS 子状态（0..4）

    reg [7:0]  in_cnt;
    reg [2:0]  wr_frame;
    reg [2:0]  rd_ptr;
    reg [3:0]  nfull;
    reg        frame_ready [0:7];
    reg        cap_en;
    reg [2:0]  rd_slot;
    // 正在被 S_ZN 读的那一帧还占着 rd_slot（帧数据只到 S_ZN 结束才真正不再读）。
    // S_IDLE 消耗只把 nfull 减 1，槽位实际仍被占用，必须单独记一笔。
    reg        rd_busy;

    reg signed [23:0] sum_x_r, sum_q_r;
    reg  [39:0]       sum_sq_r;
    reg signed [23:0] sum_x_w, sum_q_w;
    reg  [39:0]       ssq_w;

    // 输入打拍 + 平方流水
    // din 是端口，直接用会让 "端口 -> DSP 乘法 -> 40 bit 加法树 -> RAM 写"
    // 全挤在一拍里（带 0.5 ns 输入延迟的 OOC 实测 -0.797 ns，70 个端点）。
    // 现在 din 先寄存，平方结果再寄存一拍，累加放到下一拍。
    // 控制逻辑整体后移一拍，语义不变。
    reg [31:0] din_r;
    reg        dvalid_r, dlast_r;
    reg [31:0] di2_r, dq2_r;
    reg        sq_vld, sq_first;   // 平方流水的 valid / 帧首字
    reg        wr_done_d;
    reg [2:0]  wr_frame_d;
    reg signed [23:0] sx_d, sq_d;  // 帧尾锁存的 I/Q 和，和延时后的写对齐

    reg signed [31:0] ln_rms;
    reg [63:0]        ln_p_r;

    // 输出侧
    reg [1:0]  feat_valid;
    reg        wr_bank;
    reg        ob;
    reg        out_active;
    reg        rd_bank;
    reg [8:0]  out_cnt;
    reg [8:0]  out_raddr;
    reg        out_valid;
    reg  [31:0] feat_rdata;
    reg [2:0]  out_idx;

    // PACK
    reg [7:0]  pk_idx;
    reg [31:0] pk_data;

    reg [31:0] zn_rdata;
    reg [31:0] raw_rdata;
    reg        dwt_sel_d;
    reg [23:0] dwt_src_data;

    integer j;

    // ------------------------------------------------------------------
    // 输入侧组合
    // ------------------------------------------------------------------
    // 用打拍后的 din_r，端口 -> 乘法器那段长路被切开
    wire signed [15:0] din_i = din_r[15:0];
    wire signed [15:0] din_q = din_r[31:16];

    wire signed [23:0] sx_next = sum_x_r + {{8{din_i[15]}}, din_i};
    wire signed [23:0] sq_next = sum_q_r + {{8{din_q[15]}}, din_q};
    wire [31:0] di2 = din_i * din_i;
    wire [31:0] dq2 = din_q * din_q;
    // 累加用的是上一拍寄存的平方（见 sq_vld/sq_first）
    wire [39:0] ssq_final = sum_sq_r + {8'd0, di2_r} + {8'd0, dq2_r};

    wire wr_word0 = dvalid_r && (in_cnt == 8'd0);
    wire wr_wordN = dvalid_r && (in_cnt == 8'd255);
    // 环里的真实占用 = 排队帧(nfull) + 本拍刚写完还没计进 nfull 的那帧(wr_done_d)
    // + 正在被 S_ZN 读的那帧(rd_busy)。少了最后一项，nfull=7 时写指针会绕回
    // 正在读的槽（W = C+7 = 上一槽），把两帧样点混进同一帧 —— 现象 B。
    wire [4:0] ring_occ = {1'b0, nfull} + {4'd0, wr_done_d} + {4'd0, rd_busy};
    wire cap_now  = wr_word0 ? (ring_occ < 5'd8) : cap_en;
    wire wr_done  = wr_wordN && cap_now;
    wire consume_now = (state == S_IDLE) && (nfull != 4'd0);

    wire [10:0] raw_waddr = {wr_frame, in_cnt};

    // ------------------------------------------------------------------
    // 子模块连线
    // ------------------------------------------------------------------
    wire [8:0]  zn_src_addr;
    wire        zn_sq_req;
    wire [31:0] zn_sq_in;
    wire        zn_sq_ack;
    wire        zn_done;
    wire        zn_rms_zero;
    wire [16:0] zn_rms;
    wire [7:0]  zn_waddr;
    wire [31:0] zn_wdata;
    wire        zn_we;

    wire [8:0]  fft_src_addr;
    wire        fft_log_req;
    wire [63:0] fft_log_p;
    wire        fft_log_ack;
    wire [6:0]  fft_res_addr;
    wire signed [31:0] fft_res_data;
    wire        fft_res_we;
    wire        fft_done;

    wire [8:0]  dwt_src_addr;
    wire        dwt_src_sel;
    wire [63:0] dwt_ca4, dwt_cd4, dwt_cd3, dwt_cd2, dwt_cd1;
    wire        dwt_done;
    reg  [31:0] dwt_i_f [0:4];
    reg  [31:0] dwt_q_f [0:4];

    wire        dwf_log_req;
    wire [63:0] dwf_log_p;
    wire        dwf_log_ack;
    wire signed [31:0] dwf_ca4, dwf_cd4, dwf_cd3, dwf_cd2, dwf_cd1;
    wire        dwf_done;

    wire [8:0]  hist_src_addr;
    wire        hist_sq_req;
    wire [31:0] hist_sq_in;
    wire        hist_sq_ack;
    wire        hist_at_req;
    wire [31:0] hist_at_in;
    wire        hist_at_ack;
    wire [4:0]  hist_rd_addr;
    wire [8:0]  hist_rd_data;
    wire [47:0] hist_acc1, hist_acc2, hist_acc3, hist_acc4;
    wire        hist_done;

    wire [8:0]  cum_src_addr;
    wire        cum_sq_req;
    wire [31:0] cum_sq_in;
    wire        cum_sq_ack;
    wire        cum_at_req;
    wire [31:0] cum_at_in;
    wire        cum_at_ack;
    wire signed [31:0] cum_mag0, cum_mag1, cum_mag2, cum_mag3, cum_mag4, cum_mag5;
    wire signed [31:0] cum_ang0, cum_ang1, cum_ang2, cum_ang3, cum_ang4, cum_ang5;
    wire        cum_done;

    wire [8:0]  cfo_src_addr;
    wire        cfo_sq_req;
    wire [31:0] cfo_sq_in;
    wire        cfo_sq_ack;
    wire        cfo_at_req;
    wire [31:0] cfo_at_in;
    wire        cfo_at_ack;
    wire signed [31:0] cfo_ang20, cfo_mag20, cfo_ang1, cfo_mag1;
    wire signed [31:0] cfo_b0, cfo_b1, cfo_b2, cfo_b3, cfo_bstd;
    wire        cfo_done;

    wire        pow_sq_req;
    wire [31:0] pow_sq_in;
    wire        pow_sq_ack;
    wire        pow_log_req;
    wire [63:0] pow_log_p;
    wire        pow_log_ack;
    wire signed [31:0] pow_log_rms, pow_std_az, pow_mean_az3, pow_mean_az4;
    wire signed [31:0] pow_mean_x, pow_mean_q;
    wire        pow_done;

    // 共享 sqrt / atan / log2
    reg         sq_req_m;
    reg  [31:0] sq_in_m;
    wire        sq_ack;
    wire [16:0] sq_out_m;

    reg         at_req_m;
    reg  [31:0] at_in_m;
    wire        at_ack;
    wire signed [15:0] at_out_m;

    reg         log_req_m;
    reg  [63:0] log_p_m;
    wire        log_ack;
    wire        log_busy;
    wire signed [31:0] log2q16;
    wire        log_pzero;

    wire        ln_req;
    wire        lnr_ack;

    // start 脉冲
    wire zn_start   = (state == S_ZN)     && !st;
    wire fft_start  = (state == S_FFT)    && !st;
    wire dwt_start  = ((state == S_DWT_I) || (state == S_DWT_Q))   && !st;
    wire dwf_start  = ((state == S_DWTF_I) || (state == S_DWTF_Q)) && !st;
    wire hist_start = (state == S_HIST)   && !st;
    wire cum_start  = (state == S_CUM)    && !st;
    wire cfo_start  = (state == S_CFO)    && !st;
    wire pow_start  = (state == S_POW)    && !st;
    wire pk_we      = (state == S_PACK)   && st;

    // ------------------------------------------------------------------
    // 共享资源仲裁（任一时刻只有一段在跑）
    // ------------------------------------------------------------------
    assign zn_sq_ack = sq_ack && (state == S_ZN);
    assign hist_sq_ack = sq_ack && (state == S_HIST);
    assign cum_sq_ack = sq_ack && (state == S_CUM);
    assign cfo_sq_ack = sq_ack && (state == S_CFO);
    assign pow_sq_ack = sq_ack && (state == S_POW);

    always @* begin
        sq_req_m = 1'b0;
        sq_in_m  = 32'd0;
        case (state)
        S_ZN:   begin sq_req_m = zn_sq_req;   sq_in_m = zn_sq_in;   end
        S_HIST: begin sq_req_m = hist_sq_req; sq_in_m = hist_sq_in; end
        S_CUM:  begin sq_req_m = cum_sq_req;  sq_in_m = cum_sq_in;  end
        S_CFO:  begin sq_req_m = cfo_sq_req;  sq_in_m = cfo_sq_in;  end
        S_POW:  begin sq_req_m = pow_sq_req;  sq_in_m = pow_sq_in;  end
        default: ;
        endcase
    end

    assign hist_at_ack = at_ack && (state == S_HIST);
    assign cum_at_ack = at_ack && (state == S_CUM);
    assign cfo_at_ack = at_ack && (state == S_CFO);

    always @* begin
        at_req_m = 1'b0;
        at_in_m  = 32'd0;
        case (state)
        S_HIST: begin at_req_m = hist_at_req; at_in_m = hist_at_in; end
        S_CUM:  begin at_req_m = cum_at_req;  at_in_m = cum_at_in;  end
        S_CFO:  begin at_req_m = cfo_at_req;  at_in_m = cfo_at_in;  end
        default: ;
        endcase
    end

    assign fft_log_ack = log_ack && (state == S_FFT);
    assign pow_log_ack = log_ack && (state == S_POW);
    assign dwf_log_ack = log_ack && ((state == S_DWTF_I) || (state == S_DWTF_Q));

    always @* begin
        log_req_m = 1'b0;
        log_p_m   = 64'd0;
        case (state)
        S_LNRMS:  begin log_req_m = ln_req;      log_p_m = ln_p_r;     end
        S_FFT:    begin log_req_m = fft_log_req; log_p_m = fft_log_p;  end
        S_POW:    begin log_req_m = pow_log_req; log_p_m = pow_log_p;  end
        S_DWTF_I: begin log_req_m = dwf_log_req; log_p_m = dwf_log_p;  end
        S_DWTF_Q: begin log_req_m = dwf_log_req; log_p_m = dwf_log_p;  end
        default: ;
        endcase
    end

    // LNRMS：p 先寄存一拍，再发 req，等 ack
    assign ln_req  = (state == S_LNRMS) && (ln_st == 2'd1);
    assign lnr_ack = log_ack && (state == S_LNRMS);

    // ack 后分三拍：锁存 log2 -> 乘法寄存 -> 移位/减常数写 ln_rms。
    // 64 bit 常数乘被综合成移位加法链，200 MHz 下单拍过不去。
    reg signed [31:0] lnr_log2;
    (* use_dsp48 = "yes" *) reg signed [47:0] lnr_prod_r;
    wire signed [47:0] lnr_sh = lnr_prod_r >>> 20;

    // ------------------------------------------------------------------
    // RAM 读写口
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (zn_we) zn_ram[zn_waddr] <= zn_wdata;
    end

    wire [7:0] zn_raddr_sel =
        (state == S_FFT)   ? fft_src_addr[7:0] :
        ((state == S_DWT_I) || (state == S_DWT_Q)) ? dwt_src_addr[7:0] :
        (state == S_HIST)  ? hist_src_addr[7:0] :
        (state == S_CUM)   ? cum_src_addr[7:0] :
        (state == S_CFO)   ? cfo_src_addr[7:0] : 8'd0;

    always @(posedge clk) zn_rdata <= zn_ram[zn_raddr_sel];

    wire signed [15:0] zn_i = zn_rdata[15:0];
    wire signed [15:0] zn_q = zn_rdata[31:16];

    // db4 的 src_sel 只表示“level0 读外部 RAM”，不是通道选择；
    // I/Q 由本模块按当前 pass 选，并与 zn_ram 的 1 拍读延迟对齐
    always @(posedge clk) dwt_sel_d <= (state == S_DWT_Q);
    always @* begin
        if (dwt_sel_d)
            dwt_src_data = {{8{zn_rdata[31]}}, zn_rdata[31:16]};
        else
            dwt_src_data = {{8{zn_rdata[15]}}, zn_rdata[15:0]};
    end

    // raw 读口（zn 用）
    wire [10:0] raw_raddr = (state == S_ZN) ? {rd_slot, zn_src_addr[7:0]} : 11'd0;
    always @(posedge clk) raw_rdata <= frame_ram[raw_raddr];

    // fft 结果写
    always @(posedge clk) begin
        if (fft_res_we) fft_ram[fft_res_addr] <= fft_res_data;
    end

    // 特征乒乓读写
    // 读口只在“推进下一字”的拍取数：被反压时保持 feat_rdata 不变，
    // 否则数据会在 out_cnt 停住时自己往前跑，反压一次丢一个字。
    wire out_fetch = out_active && (!out_valid ||
                                    (m_tready && (out_cnt != 9'd255)));
    always @(posedge clk) begin
        if (pk_we) feat_ram[{wr_bank, pk_idx}] <= pk_data;
        if (out_fetch) feat_rdata <= feat_ram[out_raddr];
    end

    // ------------------------------------------------------------------
    // 子模块例化
    // ------------------------------------------------------------------
    ef_zn u_zn (
        .clk(clk), .rst_n(rst_n), .start(zn_start),
        .sum_sq(ssq_w),
        .src_addr(zn_src_addr),
        .src_i(raw_rdata[15:0]), .src_q(raw_rdata[31:16]),
        .sq_req(zn_sq_req), .sq_in(zn_sq_in), .sq_ack(zn_sq_ack), .sq_out(sq_out_m),
        .wr_addr(zn_waddr), .wr_data(zn_wdata), .wr_en(zn_we),
        .rms_zero(zn_rms_zero), .rms_q10(zn_rms),
        .done(zn_done), .busy()
    );

    ef_fft_log u_fft (
        .clk(clk), .rst_n(rst_n), .start(fft_start),
        .src_addr(fft_src_addr), .src_i(zn_i), .src_q(zn_q),
        .log_req(fft_log_req), .log_p(fft_log_p), .log_ack(fft_log_ack),
        .log_busy(log_busy), .log2_q16(log2q16), .log_pzero(log_pzero),
        .res_addr(fft_res_addr), .res_data(fft_res_data), .res_we(fft_res_we),
        .done(fft_done), .busy()
    );

    ef_dwt_db4 u_dwt (
        .clk(clk), .rst_n(rst_n), .start(dwt_start),
        .src_addr(dwt_src_addr), .src_sel(dwt_src_sel), .src_data(dwt_src_data),
        .e_ca4(dwt_ca4), .e_cd4(dwt_cd4), .e_cd3(dwt_cd3),
        .e_cd2(dwt_cd2), .e_cd1(dwt_cd1),
        .done(dwt_done), .busy()
    );

    ef_dwt_feat u_dwtf (
        .clk(clk), .rst_n(rst_n), .start(dwf_start),
        .e_ca4(dwt_ca4), .e_cd4(dwt_cd4), .e_cd3(dwt_cd3),
        .e_cd2(dwt_cd2), .e_cd1(dwt_cd1),
        .ln_rms_q12(ln_rms), .rms_zero(zn_rms_zero),
        .log_req(dwf_log_req), .log_p(dwf_log_p), .log_ack(dwf_log_ack),
        .log_busy(log_busy), .log2_q16(log2q16), .log_pzero(log_pzero),
        .f_ca4(dwf_ca4), .f_cd4(dwf_cd4), .f_cd3(dwf_cd3),
        .f_cd2(dwf_cd2), .f_cd1(dwf_cd1),
        .done(dwf_done), .busy()
    );

    ef_hist u_hist (
        .clk(clk), .rst_n(rst_n), .start(hist_start),
        .src_addr(hist_src_addr), .src_i(zn_i), .src_q(zn_q),
        .sq_req(hist_sq_req), .sq_in(hist_sq_in), .sq_ack(hist_sq_ack), .sq_out(sq_out_m),
        .at_req(hist_at_req), .at_in(hist_at_in), .at_ack(hist_at_ack), .at_out(at_out_m),
        .rd_addr(hist_rd_addr), .rd_data(hist_rd_data),
        .acc1(hist_acc1), .acc2(hist_acc2), .acc3(hist_acc3), .acc4(hist_acc4),
        .done(hist_done), .busy()
    );

    ef_cumulant u_cum (
        .clk(clk), .rst_n(rst_n), .start(cum_start),
        .src_addr(cum_src_addr), .src_i(zn_i), .src_q(zn_q),
        .sq_req(cum_sq_req), .sq_in(cum_sq_in), .sq_ack(cum_sq_ack), .sq_out(sq_out_m),
        .at_req(cum_at_req), .at_in(cum_at_in), .at_ack(cum_at_ack), .at_out(at_out_m),
        .mag0(cum_mag0), .mag1(cum_mag1), .mag2(cum_mag2),
        .mag3(cum_mag3), .mag4(cum_mag4), .mag5(cum_mag5),
        .ang0(cum_ang0), .ang1(cum_ang1), .ang2(cum_ang2),
        .ang3(cum_ang3), .ang4(cum_ang4), .ang5(cum_ang5),
        .done(cum_done), .busy()
    );

    ef_cfo u_cfo (
        .clk(clk), .rst_n(rst_n), .start(cfo_start),
        .src_addr(cfo_src_addr), .src_i(zn_i), .src_q(zn_q),
        .sq_req(cfo_sq_req), .sq_in(cfo_sq_in), .sq_ack(cfo_sq_ack), .sq_out(sq_out_m),
        .at_req(cfo_at_req), .at_in(cfo_at_in), .at_ack(cfo_at_ack), .at_out(at_out_m),
        .ang20(cfo_ang20), .mag20(cfo_mag20), .ang1(cfo_ang1), .mag1(cfo_mag1),
        .b0(cfo_b0), .b1(cfo_b1), .b2(cfo_b2), .b3(cfo_b3), .bstd(cfo_bstd),
        .done(cfo_done), .busy()
    );

    ef_power u_pow (
        .clk(clk), .rst_n(rst_n), .start(pow_start),
        .sum_x(sum_x_w), .sum_q(sum_q_w),
        .acc1(hist_acc1), .acc2(hist_acc2), .acc3(hist_acc3), .acc4(hist_acc4),
        .rms_q10(zn_rms),
        .sq_req(pow_sq_req), .sq_in(pow_sq_in), .sq_ack(pow_sq_ack), .sq_out(sq_out_m),
        .log_req(pow_log_req), .log_p(pow_log_p), .log_ack(pow_log_ack),
        .log_busy(log_busy), .log2_q16(log2q16), .log_pzero(log_pzero),
        .log_rms(pow_log_rms), .std_az(pow_std_az),
        .mean_az3(pow_mean_az3), .mean_az4(pow_mean_az4),
        .mean_x(pow_mean_x), .mean_q(pow_mean_q),
        .done(pow_done), .busy()
    );

    ef_sqrt u_sqrt (
        .clk(clk), .rst_n(rst_n),
        .req(sq_req_m), .din(sq_in_m), .ack(sq_ack), .dout(sq_out_m)
    );

    // 直接用工程里的 cordic_0（Arc_Tan，16 进 16 出，参数见 xci）。
    // 名字必须和 IP 一致：BD 的 module reference 依赖扫描只认 Verilog 里
    // 按名字出现的 IP（xfft_256 / log2_lut_rom 同理），这样刷新后会把它
    // 的 xci 拉进 ps_ai_Signal_process_0_0 那次 OOC 综合。
    cordic_0 u_atan (
        .aclk(clk), .aresetn(rst_n),
        .s_axis_cartesian_tvalid(at_req_m),
        .s_axis_cartesian_tdata(at_in_m),
        .m_axis_dout_tvalid(at_ack),
        .m_axis_dout_tdata(at_out_m)
    );

    ef_log2lut u_log (
        .clk(clk), .rst_n(rst_n),
        .req(log_req_m), .p(log_p_m),
        .ack(log_ack), .pzero(log_pzero),
        .log2_q16(log2q16), .busy(log_busy)
    );

    // ------------------------------------------------------------------
    // 输入捕获 + 处理 FSM
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE; st <= 1'b0; ln_st <= 3'd0;
            in_cnt <= 0; wr_frame <= 0; rd_ptr <= 0; nfull <= 0;
            cap_en <= 0; rd_slot <= 0; rd_busy <= 1'b0;
            sum_x_r <= 0; sum_q_r <= 0; sum_sq_r <= 0;
            sum_x_w <= 0; sum_q_w <= 0; ssq_w <= 0;
            din_r <= 32'd0; dvalid_r <= 1'b0; dlast_r <= 1'b0;
            di2_r <= 32'd0; dq2_r <= 32'd0;
            sq_vld <= 1'b0; sq_first <= 1'b0;
            wr_done_d <= 1'b0; wr_frame_d <= 3'd0; sx_d <= 0; sq_d <= 0;
            ln_rms <= 0; ln_p_r <= 0;
            lnr_log2 <= 0; lnr_prod_r <= 0;
            stat_drop <= 0; stat_frames <= 0;
            pk_idx <= 0; feat_valid <= 2'b00; wr_bank <= 1'b0;
            out_idx <= 3'd0;
            for (j = 0; j < 8; j = j + 1) frame_ready[j] <= 1'b0;
            for (j = 0; j < 5; j = j + 1) begin
                dwt_i_f[j] <= 0;
                dwt_q_f[j] <= 0;
            end
        end else begin
            // ---------------- 输入打拍（第一级） ----------------
            din_r    <= din;
            dvalid_r <= din_valid;
            dlast_r  <= din_last;

            // ---------------- 平方流水（第二级） ----------------
            // 本拍把上一拍样点的平方寄存下来，累加放到下一拍做
            di2_r <= di2;
            dq2_r <= dq2;
            sq_vld   <= dvalid_r && cap_now;
            sq_first <= dvalid_r && cap_now && (in_cnt == 8'd0);

            if (sq_vld) begin
                if (sq_first) sum_sq_r <= {8'd0, di2_r} + {8'd0, dq2_r};
                else          sum_sq_r <= ssq_final;
            end

            // ---------------- 输入捕获（整体后移一拍） ----------------
            if (dvalid_r) begin
                if (cap_now) begin
                    frame_ram[raw_waddr] <= din_r;
                    if (in_cnt == 8'd0) begin
                        sum_x_r  <= {{8{din_i[15]}}, din_i};
                        sum_q_r  <= {{8{din_q[15]}}, din_q};
                    end else begin
                        sum_x_r  <= sx_next;
                        sum_q_r  <= sq_next;
                    end
                end
                if (in_cnt == 8'd0) cap_en <= (ring_occ < 5'd8);
                if (dlast_r && (in_cnt != 8'd255)) in_cnt <= 8'd0;
                else                               in_cnt <= in_cnt + 8'd1;
            end

            // 帧尾：I/Q 和和帧号在这里锁存，写 RAM 再晚一拍（等平方累加完）
            if (wr_done) begin
                sx_d       <= sx_next;
                sq_d       <= sq_next;
                wr_frame_d <= wr_frame;
                wr_frame   <= wr_frame + 3'd1;
                stat_frames <= stat_frames + 1'b1;
            end else if (dvalid_r && (in_cnt == 8'd255)) begin
                stat_frames <= stat_frames + 1'b1;
                stat_drop   <= stat_drop + 1'b1;
            end

            wr_done_d <= wr_done;

            if (wr_done_d) begin
                frame_ready[wr_frame_d] <= 1'b1;
                sum_x_buf[wr_frame_d]   <= sx_d;
                sum_q_buf[wr_frame_d]   <= sq_d;
                sum_sq_buf[wr_frame_d]  <= ssq_final;
            end

            if (consume_now) frame_ready[rd_ptr] <= 1'b0;
            nfull <= nfull + (wr_done_d ? 4'd1 : 4'd0) - (consume_now ? 4'd1 : 4'd0);

            // 输出引擎读完一整帧 -> 释放该 bank
            if (out_active && out_valid && m_tready && (out_cnt == 9'd255))
                feat_valid[rd_bank] <= 1'b0;

            // ---------------- 处理 FSM ----------------
            case (state)
            S_IDLE: begin
                if (nfull != 4'd0) begin
                    rd_slot <= rd_ptr;
                    rd_busy <= 1'b1;
                    rd_ptr  <= rd_ptr + 3'd1;
                    sum_x_w <= sum_x_buf[rd_ptr];
                    sum_q_w <= sum_q_buf[rd_ptr];
                    ssq_w   <= sum_sq_buf[rd_ptr];
                    state   <= S_ZN;
                    st      <= 1'b0;
                end
            end

            S_ZN: begin
                if (!st) st <= 1'b1;
                else if (zn_done) begin
                    state   <= S_LNRMS;
                    st      <= 1'b0;
                    ln_st   <= 2'd0;
                    // zn 已经读完 256 个样点，rd_slot 从这一拍起才真正空闲
                    rd_busy <= 1'b0;
                end
            end

            S_LNRMS: begin
                case (ln_st)
                3'd0: begin
                    if (zn_rms_zero) begin
                        ln_rms <= LOG_EPS_WAVELET;
                        state  <= S_FFT;
                        st     <= 1'b0;
                    end else if (!log_busy) begin
                        ln_p_r <= {47'd0, zn_rms};
                        ln_st  <= 3'd1;
                    end
                end
                3'd1: ln_st <= 3'd2;
                3'd2: begin
                    if (lnr_ack) begin
                        lnr_log2 <= log2q16;
                        ln_st    <= 3'd3;
                    end
                end
                3'd3: begin
                    lnr_prod_r <= $signed(lnr_log2) * $signed(18'sd45426);   // LN2_Q16
                    ln_st      <= 3'd4;
                end
                default: begin
                    ln_rms <= lnr_sh[31:0] - 32'sd28391;   // LOG10LN2_Q12
                    ln_st  <= 3'd0;
                    state  <= S_FFT;
                    st     <= 1'b0;
                end
                endcase
            end

            S_FFT: begin
                if (!st) st <= 1'b1;
                else if (fft_done) begin state <= S_DWT_I; st <= 1'b0; end
            end

            S_DWT_I: begin
                if (!st) st <= 1'b1;
                else if (dwt_done) begin state <= S_DWTF_I; st <= 1'b0; end
            end

            S_DWTF_I: begin
                if (!st) st <= 1'b1;
                else if (dwf_done) begin
                    dwt_i_f[0] <= dwf_ca4; dwt_i_f[1] <= dwf_cd4; dwt_i_f[2] <= dwf_cd3;
                    dwt_i_f[3] <= dwf_cd2; dwt_i_f[4] <= dwf_cd1;
                    state <= S_DWT_Q; st <= 1'b0;
                end
            end

            S_DWT_Q: begin
                if (!st) st <= 1'b1;
                else if (dwt_done) begin state <= S_DWTF_Q; st <= 1'b0; end
            end

            S_DWTF_Q: begin
                if (!st) st <= 1'b1;
                else if (dwf_done) begin
                    dwt_q_f[0] <= dwf_ca4; dwt_q_f[1] <= dwf_cd4; dwt_q_f[2] <= dwf_cd3;
                    dwt_q_f[3] <= dwf_cd2; dwt_q_f[4] <= dwf_cd1;
                    state <= S_HIST; st <= 1'b0;
                end
            end

            S_HIST: begin
                if (!st) st <= 1'b1;
                else if (hist_done) begin state <= S_CUM; st <= 1'b0; end
            end

            S_CUM: begin
                if (!st) st <= 1'b1;
                else if (cum_done) begin state <= S_CFO; st <= 1'b0; end
            end

            S_CFO: begin
                if (!st) st <= 1'b1;
                else if (cfo_done) begin state <= S_POW; st <= 1'b0; end
            end

            S_POW: begin
                if (!st) st <= 1'b1;
                else if (pow_done) begin state <= S_PACK; st <= 1'b0; end
            end

            S_PACK: begin
                if (!st) begin
                    if (!feat_valid[wr_bank]) begin
                        pk_idx <= 8'd0;
                        st     <= 1'b1;
                    end
                end else begin
                    if (pk_idx == 8'd255) begin
                        feat_valid[wr_bank] <= 1'b1;
                        wr_bank <= ~wr_bank;
                        out_idx <= out_idx + 3'd1;
                        state   <= S_IDLE;
                        st      <= 1'b0;
                    end else begin
                        pk_idx <= pk_idx + 8'd1;
                    end
                end
            end

            default: state <= S_IDLE;
            endcase
        end
    end

    // ------------------------------------------------------------------
    // 特征打包数据选择
    // ------------------------------------------------------------------
    assign hist_rd_addr = ((pk_idx >= 8'd138) && (pk_idx < 8'd166))
                          ? (pk_idx - 8'd138) : 5'd0;

    always @* begin
        pk_data = 32'd0;
        if (pk_idx < 8'd128)
            pk_data = fft_ram[pk_idx[6:0]];
        else if (pk_idx < 8'd133)
            pk_data = dwt_i_f[pk_idx - 8'd128];
        else if (pk_idx < 8'd138)
            pk_data = dwt_q_f[pk_idx - 8'd133];
        else if (pk_idx < 8'd166)
            pk_data = {19'd0, hist_rd_data, 4'd0};
        else if (pk_idx == 8'd166) pk_data = cum_mag0;
        else if (pk_idx == 8'd167) pk_data = cum_mag1;
        else if (pk_idx == 8'd168) pk_data = cum_mag2;
        else if (pk_idx == 8'd169) pk_data = cum_mag3;
        else if (pk_idx == 8'd170) pk_data = cum_mag4;
        else if (pk_idx == 8'd171) pk_data = cum_mag5;
        else if (pk_idx == 8'd172) pk_data = cum_ang0;
        else if (pk_idx == 8'd173) pk_data = cum_ang1;
        else if (pk_idx == 8'd174) pk_data = cum_ang2;
        else if (pk_idx == 8'd175) pk_data = cum_ang3;
        else if (pk_idx == 8'd176) pk_data = cum_ang4;
        else if (pk_idx == 8'd177) pk_data = cum_ang5;
        else if (pk_idx == 8'd178) pk_data = cfo_ang20;
        else if (pk_idx == 8'd179) pk_data = cfo_mag20;
        else if (pk_idx == 8'd180) pk_data = cfo_ang1;
        else if (pk_idx == 8'd181) pk_data = cfo_mag1;
        else if (pk_idx == 8'd182) pk_data = cfo_b0;
        else if (pk_idx == 8'd183) pk_data = cfo_b1;
        else if (pk_idx == 8'd184) pk_data = cfo_b2;
        else if (pk_idx == 8'd185) pk_data = cfo_b3;
        else if (pk_idx == 8'd186) pk_data = cfo_bstd;
        else if (pk_idx == 8'd187) pk_data = pow_log_rms;
        else if (pk_idx == 8'd188) pk_data = pow_std_az;
        else if (pk_idx == 8'd189) pk_data = pow_mean_az3;
        else if (pk_idx == 8'd190) pk_data = pow_mean_az4;
        else if (pk_idx == 8'd191) pk_data = pow_mean_x;
        else if (pk_idx == 8'd192) pk_data = pow_mean_q;
        else if (pk_idx == 8'd193) pk_data = FRAME_MAGIC;
        else if (pk_idx == 8'd194) pk_data = 32'd1;
        else if (pk_idx == 8'd195) pk_data = {29'd0, out_idx};
        else if (pk_idx == 8'd196) pk_data = 32'd12;
        else                       pk_data = 32'd0;
    end

    // ------------------------------------------------------------------
    // AXIS 输出引擎
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            ob <= 1'b0;
            out_active <= 1'b0;
            rd_bank <= 1'b0;
            out_cnt <= 9'd0;
            out_raddr <= 9'd0;
            out_valid <= 1'b0;
        end else begin
            if (!out_active) begin
                if (feat_valid[ob]) begin
                    out_active <= 1'b1;
                    rd_bank    <= ob;
                    ob         <= ~ob;
                    out_cnt    <= 9'd0;
                    out_raddr  <= {ob, 8'd0};
                    out_valid  <= 1'b0;
                end
            end else begin
                if (!out_valid) begin
                    // 数据 w0 已在本拍从地址 0 读出；预取下一字
                    out_valid <= 1'b1;
                    out_raddr <= {rd_bank, 8'd1};
                end else if (m_tready) begin
                    if (out_cnt == 9'd255) begin
                        out_valid  <= 1'b0;
                        out_active <= 1'b0;
                    end else begin
                        // 读口比 out_cnt 领先一拍：本拍地址是 cnt+1，
                        // 下一拍要呈现 cnt+2，这样数据与计数才对齐
                        out_cnt   <= out_cnt + 9'd1;
                        out_raddr <= {rd_bank, out_cnt[7:0] + 8'd2};
                    end
                end
            end
        end
    end

    assign m_tdata  = feat_rdata;
    assign m_tvalid = out_valid;
    assign m_tlast  = out_valid && (out_cnt == 9'd255);
    assign m_tkeep  = 4'hF;
    assign busy     = (state != S_IDLE) || out_active;

endmodule
