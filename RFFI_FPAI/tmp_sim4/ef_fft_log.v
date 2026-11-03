`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_fft_log : 256 点 FFT -> P=|Z|^2 -> log2 -> 前 128 bin 去均值
//
//   输入 zn（Q12，I/Q 各 16-bit），喂 xfft_256（16-bit in，25-bit out，
//   unscaled，bit-reversed 输出）。每个输出按 bitrev8 还原自然 bin，
//   只取 k=0..127：P=re^2+im^2，经共享 log2 服务得到 Q16，再
//   lm = (log2_q16 * ln2_Q15) >>> 20（Q12）。
//   P==0 用 LOG_EPS_FFT。最后 lm_mean = sum(lm)>>>7，输出 lm[k]-mean。
//
//   共享 log 口：req 单拍，busy 为低时发；ack 单拍后 log2_q16/pzero 有效。
// -----------------------------------------------------------------------------
module ef_fft_log (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    // zn 源（顶层 1 拍读延迟）
    output reg  [8:0]  src_addr,
    input  wire signed [15:0] src_i,
    input  wire signed [15:0] src_q,
    // 共享 log2 服务
    output reg         log_req,
    output reg  [63:0] log_p,
    input  wire        log_ack,
    input  wire        log_busy,
    input  wire signed [31:0] log2_q16,
    input  wire        log_pzero,
    // 结果写出（128 个，地址 0..127）
    output reg  [6:0]  res_addr,
    output reg  signed [31:0] res_data,
    output reg         res_we,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam S_IDLE  = 4'd0, S_CFG  = 4'd1, S_LOAD = 4'd2,
               S_OUT   = 4'd3, S_LREQ = 4'd4, S_LWAIT = 4'd5,
               S_L1    = 4'd8, S_L2   = 4'd9,
               S_MEAN  = 4'd6, S_EMIT = 4'd7;

    reg [3:0] state;
    reg       cfg_done;
    reg [8:0] rd_idx;       // 下一个要读的 zn 地址
    reg       rd_wait;      // 地址已发，下下拍 zn_rdata 有效
    // zn_ram 到 FFT 之间插一级寄存器：原来是 BRAM 输出寄存器 -> 3.5 ns 纯长线 ->
    // xfft 内部 FIFO 写寄存器（OOC 实测 -0.38 ns，4 个端点）。
    reg       rd_wait_q;    // rd_wait 延时一拍：这一拍 zn_rdata 是 RAM[X]
    reg [31:0] fft_dat;
    reg        fft_vld;
    reg [8:0] in_cnt;       // 已送进 FFT 的样本数
    reg [8:0] out_cnt;      // 已接收的 FFT 输出数
    reg [24:0] cap_re, cap_im;
    reg [6:0]  cur_k;

    reg [31:0] lm_ram [0:127];
    reg signed [63:0] lm_sum;
    reg signed [63:0] lm_mean;
    reg [6:0]  emit_idx;

    // FFT IP
    reg        s_cfg_tvalid;
    wire       s_cfg_tready;
    wire       s_dat_tready;
    reg        s_dat_tvalid;
    reg  [31:0] s_dat_tdata;
    reg        s_dat_tlast;
    reg        m_tready;
    wire [63:0] m_tdata;
    wire        m_tvalid;
    wire        m_tlast;
    wire ev0, ev1, ev2, ev3, ev4, ev5;

    xfft_256 u_fft (
        .aclk(clk),
        .aresetn(rst_n),
        .s_axis_config_tdata(8'h01),
        .s_axis_config_tvalid(s_cfg_tvalid),
        .s_axis_config_tready(s_cfg_tready),
        .s_axis_data_tdata(s_dat_tdata),
        .s_axis_data_tvalid(s_dat_tvalid),
        .s_axis_data_tready(s_dat_tready),
        .s_axis_data_tlast(s_dat_tlast),
        .m_axis_data_tdata(m_tdata),
        .m_axis_data_tvalid(m_tvalid),
        .m_axis_data_tready(m_tready),
        .m_axis_data_tlast(m_tlast),
        .event_frame_started(ev0),
        .event_tlast_unexpected(ev1),
        .event_tlast_missing(ev2),
        .event_status_channel_halt(ev3),
        .event_data_in_channel_halt(ev4),
        .event_data_out_channel_halt(ev5)
    );

    assign busy = (state != S_IDLE);

    function [7:0] bitrev8;
        input [7:0] x;
        integer k;
        begin
            for (k = 0; k < 8; k = k + 1)
                bitrev8[k] = x[7-k];
        end
    endfunction

    wire signed [24:0] re = m_tdata[24:0];
    wire signed [24:0] im = m_tdata[56:32];
    // 接收后 FFT 可以换下一组数据，P 必须用锁存的 re/im 算
    wire signed [49:0] cap_re2 = $signed(cap_re) * $signed(cap_re);
    wire signed [49:0] cap_im2 = $signed(cap_im) * $signed(cap_im);
    wire        [50:0] pval    = cap_re2 + cap_im2;
    wire        [63:0] p64     = {13'd0, pval};

    // 当前输出对应的自然 bin
    wire [7:0] nat_idx = bitrev8(out_cnt[7:0]);

    // log 后处理分三拍：ack 锁存 log2 -> 乘法寄存 -> 移位/写 RAM。
    // 乘法结果取 48 bit（log2_q16 最大约 2^22），32x16 常数乘，一个 DSP48 够。
    wire signed [47:0] lm_prod = $signed(log2_q16) * $signed(LN2_Q15[15:0]);
    wire signed [47:0] lm_sh   = lm_prod >>> 20;

    reg signed [31:0] log2_l;
    reg               pz_l;
    (* use_dsp48 = "yes" *) reg signed [47:0] lm_prod_r;
    wire signed [47:0] lm_prod_sh = lm_prod_r >>> 20;

    // 送数：数据已经从 zn_rdata 采到 fft_dat，fft_vld 和它同拍
    always @* begin
        s_dat_tdata = fft_dat;
        s_dat_tvalid = fft_vld;
        s_dat_tlast = (in_cnt == 9'd255);
    end

    // rd_wait -> rd_wait_q -> fft_dat/fft_vld（每样点 3 拍）
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_wait_q <= 1'b0;
            fft_dat   <= 32'd0;
            fft_vld   <= 1'b0;
        end else if ((state == S_IDLE) && start) begin
            rd_wait_q <= 1'b0;
            fft_vld   <= 1'b0;
        end else begin
            rd_wait_q <= rd_wait;
            if (rd_wait_q) begin
                fft_dat <= {src_q, src_i};
                fft_vld <= 1'b1;
            end else if (fft_vld && s_dat_tready) begin
                fft_vld <= 1'b0;
            end
        end
    end

    // 读地址 / 输入计数
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_idx <= 0;
            rd_wait <= 0;
            in_cnt <= 0;
            src_addr <= 0;
            s_cfg_tvalid <= 0;
            cfg_done <= 0;
            state <= S_IDLE;
            out_cnt <= 0;
            m_tready <= 0;
            log_req <= 0;
            log_p <= 0;
            lm_sum <= 0;
            lm_mean <= 0;
            log2_l <= 0; pz_l <= 0; lm_prod_r <= 0;
            emit_idx <= 0;
            res_addr <= 0;
            res_data <= 0;
            res_we <= 0;
            done <= 0;
        end else begin
            done <= 0;
            res_we <= 0;

            case (state)
            S_IDLE: begin
                if (start) begin
                    cfg_done <= 0;
                    s_cfg_tvalid <= 1;
                    in_cnt <= 0;
                    rd_idx <= 0;
                    rd_wait <= 0;
                    out_cnt <= 0;
                    lm_sum <= 0;
                    m_tready <= 0;
                    state <= S_CFG;
                end
            end

            S_CFG: begin
                if (s_cfg_tvalid && s_cfg_tready) begin
                    s_cfg_tvalid <= 0;
                    cfg_done <= 1;
                    // 发起第一个 zn 读
                    src_addr <= 9'd0;
                    rd_idx <= 9'd1;
                    rd_wait <= 1;
                    state <= S_LOAD;
                end
            end

            S_LOAD: begin
                if (rd_wait) rd_wait <= 0;
                // fft_vld/fft_dat 由上面的流水块产生，这里只做握手
                if (fft_vld && s_dat_tready) begin
                    if (in_cnt == 9'd255) begin
                        state <= S_OUT;
                        m_tready <= 1;
                    end else if (rd_idx < 9'd256) begin
                        src_addr <= rd_idx;
                        rd_idx <= rd_idx + 1'b1;
                        rd_wait <= 1;
                    end
                    in_cnt <= in_cnt + 1'b1;
                end
            end

            S_OUT: begin
                if (m_tvalid && m_tready) begin
                    cap_re <= re;
                    cap_im <= im;
                    m_tready <= 0;
                    if (nat_idx < 8'd128) begin
                        cur_k <= nat_idx[6:0];
                        state <= S_LREQ;
                    end else begin
                        // 后 128 bin 只消费，不发 log
                        if (out_cnt == 9'd255) begin
                            state <= S_MEAN;
                        end else begin
                            m_tready <= 1;
                        end
                    end
                    out_cnt <= out_cnt + 1'b1;
                end
            end

            S_LREQ: begin
                log_p <= p64;
                if (log_busy) begin
                    // 等共享服务空闲；req 不保持，避免重复接收
                    log_req <= 0;
                end else begin
                    log_req <= 1;
                    state <= S_LWAIT;
                end
            end

            S_LWAIT: begin
                log_req <= 0;
                if (log_ack) begin
                    log2_l <= log2_q16;
                    pz_l   <= log_pzero;
                    state  <= S_L1;
                end
            end

            S_L1: begin
                lm_prod_r <= $signed(log2_l) * $signed(LN2_Q15[15:0]);
                state     <= S_L2;
            end

            S_L2: begin
                if (pz_l) begin
                    lm_ram[cur_k] <= LOG_EPS_FFT[31:0];
                    lm_sum <= lm_sum + LOG_EPS_FFT;
                end else begin
                    lm_ram[cur_k] <= lm_prod_sh[31:0];
                    lm_sum       <= lm_sum + lm_prod_sh;
                end
                if (out_cnt == 9'd256) begin
                    m_tready <= 0;
                    state <= S_MEAN;
                end else begin
                    m_tready <= 1;
                    state <= S_OUT;
                end
            end

            S_MEAN: begin
                lm_mean <= lm_sum >>> 7;
                emit_idx <= 0;
                state <= S_EMIT;
            end

            S_EMIT: begin
                res_addr <= emit_idx;
                res_data <= lm_ram[emit_idx] - lm_mean[31:0];
                res_we <= 1;
                if (emit_idx == 7'd127) begin
                    done <= 1;
                    state <= S_IDLE;
                end else begin
                    emit_idx <= emit_idx + 1'b1;
                end
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
