`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_dwt_feat : 单个通道 5 个带的能量 -> 5 个对数能量特征
//
//   mean = (e * rcp) >> 16                 （e 为 Q24 能量，rcp = 65536/长度）
//   feat = mean==0 ? LOG_EPS_WAVELET
//                 : ln_q12(mean, LOG24LN2_Q12) + 2*ln_rms_q12
//   即 (log2_q16(mean)*LN2_Q16)>>>20 - 68139 + 2*ln_rms
//
//   带顺序与黄金模型一致：cA4, cD4, cD3, cD2, cD1。
//
//   时序（200 MHz 关键路径）：能量寄存 -> 乘法寄存 -> 均值寄存，之后才请求
//   共享 log2。这样 u_dwt 的 64 bit 能量寄存器到乘法器之间、乘法器到 log2
//   输入之间各占一拍，避免多级 DSP 串在一拍里。
// -----------------------------------------------------------------------------
module ef_dwt_feat (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [63:0] e_ca4,
    input  wire [63:0] e_cd4,
    input  wire [63:0] e_cd3,
    input  wire [63:0] e_cd2,
    input  wire [63:0] e_cd1,
    input  wire signed [31:0] ln_rms_q12,
    input  wire        rms_zero,
    // 共享 log2
    output reg         log_req,
    output wire [63:0] log_p,
    input  wire        log_ack,
    input  wire        log_busy,
    input  wire signed [31:0] log2_q16,
    input  wire        log_pzero,
    // 结果
    output reg signed [31:0] f_ca4,
    output reg signed [31:0] f_cd4,
    output reg signed [31:0] f_cd3,
    output reg signed [31:0] f_cd2,
    output reg signed [31:0] f_cd1,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam signed [31:0] LOG24LN2_Q12 = 32'sd68139;   // round(24*ln2*4096)

    localparam S_IDLE  = 4'd0,
               S_LATCH = 4'd1,   // 锁存本带能量
               S_MUL   = 4'd2,   // 乘 rcp
               S_MEAN  = 4'd3,   // 右移取均值（寄存）
               S_CHK   = 4'd4,   // 判零 / 请求 log2
               S_REQ   = 4'd5,
               S_WAIT  = 4'd6,
               S_L1    = 4'd7,   // log 结果寄存（乘法单独一拍）
               S_L2    = 4'd8;   // 乘移位 + 加减，写特征

    reg [3:0] state;
    reg [2:0] bi;

    reg [63:0] e_r;
    reg [15:0] rcp_r;
    reg signed [59:0] eprod_r;
    reg [43:0] mean_r;
    reg        mean_zero_r;

    // 当前带
    wire [63:0] e_sel = (bi == 3'd0) ? e_ca4 :
                        (bi == 3'd1) ? e_cd4 :
                        (bi == 3'd2) ? e_cd3 :
                        (bi == 3'd3) ? e_cd2 : e_cd1;
    wire [15:0] rcp_sel = (bi <= 3'd1) ? RCP_DWT_22 :
                          (bi == 3'd2) ? RCP_DWT_38 :
                          (bi == 3'd3) ? RCP_DWT_69 : RCP_DWT_131;

    assign log_p = {{20{1'b0}}, mean_r};

    // ack 那一拍只锁存 log2；乘法、移位、加减各占一拍
    reg signed [31:0] log2_l;
    reg        pz_l;
    // 32x16 常数乘：结果宽度取 48 bit（log2_q16 最大约 2^22），
    // 64 bit 版本被综合成 14 级进位链的移位加法，200 MHz 过不去。
    (* use_dsp48 = "yes" *) reg signed [47:0] ln_prod_r;

    wire signed [47:0] ln_shw  = ln_prod_r >>> 20;
    wire signed [47:0] ln_val  = ln_shw - 48'sd68139
                               + $signed({{16{ln_rms_q12[31]}}, ln_rms_q12, 1'b0});

    assign busy = (state != S_IDLE);

    task set_feat;
        input [2:0] b;
        input signed [31:0] v;
        begin
            case (b)
                3'd0: f_ca4 <= v;
                3'd1: f_cd4 <= v;
                3'd2: f_cd3 <= v;
                3'd3: f_cd2 <= v;
                default: f_cd1 <= v;
            endcase
        end
    endtask

    task next_band;
        begin
            if (bi == 3'd4) begin
                done  <= 1'b1;
                state <= S_IDLE;
            end else begin
                bi    <= bi + 1'b1;
                state <= S_LATCH;
            end
        end
    endtask

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE;
            bi <= 0;
            log_req <= 0;
            e_r <= 0; rcp_r <= 0; eprod_r <= 0; mean_r <= 0; mean_zero_r <= 1'b1;
            log2_l <= 0; pz_l <= 0; ln_prod_r <= 0;
            f_ca4 <= 0; f_cd4 <= 0; f_cd3 <= 0; f_cd2 <= 0; f_cd1 <= 0;
            done <= 0;
        end else begin
            done <= 0;
            case (state)
            S_IDLE: begin
                if (start) begin
                    bi <= 0;
                    state <= S_LATCH;
                end
            end

            S_LATCH: begin
                e_r   <= e_sel;
                rcp_r <= rcp_sel;
                state <= S_MUL;
            end

            S_MUL: begin
                eprod_r <= $signed({1'b0, e_r[43:0]}) * $signed({1'b0, rcp_r});
                state   <= S_MEAN;
            end

            S_MEAN: begin
                mean_r      <= eprod_r[59:16];
                mean_zero_r <= (eprod_r[59:16] == 44'd0);
                state       <= S_CHK;
            end

            S_CHK: begin
                if (rms_zero || mean_zero_r) begin
                    set_feat(bi, LOG_EPS_WAVELET);
                    next_band;
                end else if (log_busy) begin
                    // 等共享服务空闲
                end else begin
                    log_req <= 1'b1;
                    state   <= S_REQ;
                end
            end

            S_REQ: begin
                log_req <= 1'b0;
                state   <= S_WAIT;
            end

            S_WAIT: begin
                if (log_ack) begin
                    log2_l <= log2_q16;
                    pz_l   <= log_pzero;
                    state  <= S_L1;
                end
            end

            S_L1: begin
                ln_prod_r <= $signed(log2_l) * 24'sd45426;   // LN2_Q16
                state     <= S_L2;
            end

            S_L2: begin
                if (pz_l)
                    set_feat(bi, LOG_EPS_WAVELET);
                else
                    set_feat(bi, ln_val[31:0]);
                next_band;
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
