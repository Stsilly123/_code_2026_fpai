`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_power : 功率/统计 6 个特征
//
//   log_rms  = rms==0 ? LOG_EPS_WAVELET
//                    : ln_q12(rms) - LOG10LN2_Q12
//              ln_q12(p) = (log2_q16(p) * LN2_Q16) >>> 20
//   mean1    = acc1 >> 8                    (Q12)
//   mean2    = acc2 >> 8                    (Q24)
//   var_az   = max(0, mean2 - mean1^2)      (Q24)
//   std_az   = sqrt_nearest(var_az)         (Q12, 共享 cordic_sqrt)
//   mean_az3 = acc3 >> 20
//   mean_az4 = acc4 >> 20
//   mean_x   = |sum_x >>> 8| << 2
//   mean_q   = |sum_q >>> 8| << 2
//
//   acc1..acc4 来自 ef_hist；sum_x/sum_q 来自顶层对原始样点的累加；
//   rms 来自 ef_zn（已经是 Q10）。
// -----------------------------------------------------------------------------
module ef_power (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire signed [23:0] sum_x,
    input  wire signed [23:0] sum_q,
    input  wire [47:0] acc1,
    input  wire [47:0] acc2,
    input  wire [47:0] acc3,
    input  wire [47:0] acc4,
    input  wire [16:0] rms_q10,
    // 共享 sqrt
    output reg         sq_req,
    output reg  [31:0] sq_in,
    input  wire        sq_ack,
    input  wire [16:0] sq_out,
    // 共享 log2
    output reg         log_req,
    output reg  [63:0] log_p,
    input  wire        log_ack,
    input  wire        log_busy,
    input  wire signed [31:0] log2_q16,
    input  wire        log_pzero,
    // 结果（Q12）
    output reg signed [31:0] log_rms,
    output reg signed [31:0] std_az,
    output reg signed [31:0] mean_az3,
    output reg signed [31:0] mean_az4,
    output reg signed [31:0] mean_x,
    output reg signed [31:0] mean_q,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam S_IDLE   = 3'd0,
               S_LSTART = 3'd1,
               S_WAIT   = 3'd2,
               S_L1     = 3'd5,   // log 结果寄存（乘法单独一拍）
               S_L2     = 3'd6,   // 乘移位 + 减常数
               S_ASM    = 3'd3,
               S_DONE   = 3'd4;

    reg [2:0] state;
    reg       need_log;      // rms != 0 -> 要发 log 请求
    reg       sqd, lgd;
    reg [16:0] sqv;
    reg signed [31:0] lgv;

    // ---- 组合计算 ----
    wire [15:0] mean1 = acc1[23:8];              // <= 65535
    wire [32:0] mean2 = acc2[40:8];              // <= 2^32
    wire [31:0] mean1sq = mean1 * mean1;
    wire signed [33:0] vard = $signed({1'b0, mean2}) - $signed({1'b0, mean1sq});
    wire [31:0] var_az = vard[33] ? 32'd0 : vard[31:0];

    wire signed [31:0] sx8 = $signed(sum_x) >>> 8;
    wire signed [31:0] sq8 = $signed(sum_q) >>> 8;
    wire signed [31:0] sxab = sx8[31] ? -sx8 : sx8;
    wire signed [31:0] sqab = sq8[31] ? -sq8 : sq8;

    // ack 那一拍只锁存 log2；乘法、移位/减常数各占一拍
    reg signed [31:0] log2_l;
    (* use_dsp48 = "yes" *) reg signed [47:0] ln_prod_r;

    wire signed [47:0] ln_rms  = (ln_prod_r >>> 20) - 48'sd28391;  // LOG10LN2_Q12

    assign busy = (state != S_IDLE);

    always @(posedge clk) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            need_log <= 0;
            sqd <= 0; lgd <= 0;
            sqv <= 0; lgv <= 0;
            log2_l <= 0; ln_prod_r <= 0;
            sq_req <= 0; sq_in <= 0;
            log_req <= 0; log_p <= 0;
            log_rms <= 0; std_az <= 0;
            mean_az3 <= 0; mean_az4 <= 0; mean_x <= 0; mean_q <= 0;
            done <= 0;
        end else begin
            done <= 0;

            case (state)
            S_IDLE: begin
                if (start) begin
                    need_log <= (rms_q10 != 17'd0);
                    lgd <= (rms_q10 == 17'd0);
                    lgv <= LOG_EPS_WAVELET;
                    sqd <= 0;
                    mean_az3 <= $signed({4'd0, acc3[47:20]});   // <= 2^28
                    mean_az4 <= $signed({4'd0, acc4[47:20]});
                    mean_x   <= sxab <<< 2;
                    mean_q   <= sqab <<< 2;
                    state <= S_LSTART;
                end
            end

            // 共享 log 服务空闲后才同时发两个请求
            S_LSTART: begin
                if (!need_log || !log_busy) begin
                    sq_req <= 1'b1;
                    sq_in  <= var_az;
                    if (need_log) begin
                        log_req <= 1'b1;
                        log_p   <= {47'd0, rms_q10};
                    end
                    state <= S_WAIT;
                end
            end

            S_WAIT: begin
                sq_req <= 0;
                log_req <= 0;
                if (sq_ack) begin
                    sqd <= 1'b1;
                    sqv <= sq_out;
                end
                if (log_ack) begin
                    log2_l <= log2_q16;
                    state  <= S_L1;
                end
                if (!log_ack && (sqd || sq_ack) && lgd)
                    state <= S_ASM;
            end

            S_L1: begin
                if (sq_ack) begin sqd <= 1'b1; sqv <= sq_out; end
                ln_prod_r <= $signed(log2_l) * 24'sd45426;   // LN2_Q16
                state     <= S_L2;
            end

            S_L2: begin
                if (sq_ack) begin sqd <= 1'b1; sqv <= sq_out; end
                lgv     <= ln_rms[31:0];
                lgd     <= 1'b1;
                if (sqd || sq_ack)
                    state <= S_ASM;
            end

            S_ASM: begin
                std_az  <= {15'd0, sqv};
                log_rms <= lgv;
                done    <= 1'b1;
                state   <= S_DONE;
            end

            S_DONE: begin
                if (!start) state <= S_IDLE;
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
