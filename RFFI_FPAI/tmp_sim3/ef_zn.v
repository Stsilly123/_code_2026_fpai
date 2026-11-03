`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_zn : 每帧归一化，生成 zn（Q12，16-bit 饱和）
//
//   mean_sq = (Σ(x²+q²)) >> 8            (Q20)
//   rms     = sqrt_nearest(mean_sq)      (Q10, 共享 CORDIC sqrt)
//   inv     = rms == 0 ? 0 : (1<<30)/rms (32 拍恢复除法，floor)
//   zn      = sat16((x*inv + 2^17) >>> 18)
//
//   x*inv 用 18x18 乘法器拆 hi/lo 精确实现：inv = inv_hi*2^14 + inv_lo。
//   每样点 4 拍（I/Q 各 2 个乘积），读出 raw_ram（1 拍延迟），写 zn_ram。
// -----------------------------------------------------------------------------
module ef_zn (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         start,
    input  wire signed [39:0] sum_sq,   // Σ(x²+q²)，Q24
    // raw 源（顶层 RAM，1 拍读延迟）
    output reg  [8:0]   src_addr,
    input  wire signed [15:0] src_i,
    input  wire signed [15:0] src_q,
    // 共享 sqrt
    output reg          sq_req,
    output reg  [31:0]  sq_in,
    input  wire         sq_ack,
    input  wire [16:0]  sq_out,
    // zn 写出
    output reg  [7:0]   wr_addr,
    output reg  [31:0]  wr_data,
    output reg          wr_en,
    // 结果
    output reg          rms_zero,
    output reg  [16:0]  rms_q10,
    output reg          done,
    output wire         busy
);
    localparam S_IDLE  = 4'd0,
               S_SQ    = 4'd1,
               S_SWAIT = 4'd2,
               S_DIV   = 4'd3,
               S_RUN   = 4'd4,
               S_DONE  = 4'd5;

    reg [3:0]  state;
    reg [2:0]  cyc;
    reg [7:0]  idx;

    // 除法
    reg [5:0]  div_i;
    reg [31:0] div_num, div_rem, div_q;
    reg [31:0] rms32;
    reg [30:0] inv;

    // 乘法器
    reg  signed [17:0] opa0, opb0, opa1, opb1;
    reg  signed [47:0] p0, p1;
    wire signed [35:0] mul0 = opa0 * opb0;
    wire signed [35:0] mul1 = opa1 * opb1;

    reg signed [15:0] xs, qs;
    reg signed [15:0] zni, znq;
    reg signed [47:0] ivlo, ivhi;

    assign busy = (state != S_IDLE);

    function signed [15:0] sat16;
        input signed [47:0] v;
        begin
            sat16 = (v > 48'sd32767)  ? 16'sd32767 :
                    (v < -48'sd32768) ? -16'sd32768 : v[15:0];
        end
    endfunction

    // 乘积还原：x*inv = x*inv_lo + (x*inv_hi << 14)
    wire signed [47:0] zexpr_i = (p0 + (p1 <<< 14) + 48'sd131072) >>> 18;
    wire signed [47:0] zexpr_q = (p0 + (p1 <<< 14) + 48'sd131072) >>> 18;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE;
            cyc <= 0; idx <= 0; div_i <= 0;
            src_addr <= 0; sq_req <= 0; sq_in <= 0;
            wr_addr <= 0; wr_data <= 0; wr_en <= 0;
            rms_zero <= 0; rms_q10 <= 0; done <= 0;
            opa0 <= 0; opb0 <= 0; opa1 <= 0; opb1 <= 0; p0 <= 0; p1 <= 0;
            xs <= 0; qs <= 0; zni <= 0; znq <= 0;
            rms32 <= 0; inv <= 0;
            div_num <= 0; div_rem <= 0; div_q <= 0;
            ivlo <= 0; ivhi <= 0;
        end else begin
            p0 <= mul0;
            p1 <= mul1;
            done <= 0;
            wr_en <= 0;

            if (sq_ack) begin
                rms_q10  <= sq_out;
                rms_zero <= (sq_out == 17'd0);
                rms32    <= {15'd0, sq_out[16:0]};
            end

            case (state)
            S_IDLE: begin
                if (start) begin
                    src_addr <= 0;
                    idx <= 0; cyc <= 0;
                    state <= S_SQ;
                end
            end

            S_SQ: begin
                sq_req <= 1'b1;
                sq_in  <= sum_sq[39:8];       // mean_sq，Q20（< 2^32）
                state  <= S_SWAIT;
            end

            S_SWAIT: begin
                sq_req <= 1'b0;
                if (sq_ack) begin
                    if (sq_out == 17'd0) begin
                        // rms=0 -> inv=0，zn 全 0
                        inv  <= 31'd0;
                        ivlo <= 0;
                        ivhi <= 0;
                        cyc  <= 0;
                        state <= S_RUN;
                    end else begin
                        div_num <= 32'd1 << 30;
                        div_rem <= 0;
                        div_q   <= 0;
                        div_i   <= 0;
                        state   <= S_DIV;
                    end
                end
            end

            // 32 拍恢复除法：q = (1<<30)/rms
            // 注意：不能用 div_num != 0 做循环条件——被除数是 1<<30（单比特），
            // 左移 2 次就变成 0，会提前结束、商恒为 0。必须固定做满 32 次。
            S_DIV: begin
                if (div_i != 6'd32) begin
                    if ({div_rem[30:0], div_num[31]} >= rms32) begin
                        div_rem <= {div_rem[30:0], div_num[31]} - rms32;
                        div_q   <= {div_q[30:0], 1'b1};
                    end else begin
                        div_rem <= {div_rem[30:0], div_num[31]};
                        div_q   <= {div_q[30:0], 1'b0};
                    end
                    div_num <= div_num << 1;
                    div_i   <= div_i + 1'b1;
                end else begin
                    inv  <= div_q[30:0];
                    ivlo <= {4'd0, div_q[13:0]};
                    ivhi <= $signed({1'b0, div_q[30:14]});
                    cyc  <= 0;
                    state <= S_RUN;
                end
            end

            // 每样点 4 拍
            S_RUN: begin
                case (cyc)
                3'd0: begin
                    xs <= src_i; qs <= src_q;
                    opa0 <= src_i;  opb0 <= ivlo[17:0];
                    opa1 <= src_i;  opb1 <= ivhi[17:0];
                    if (idx != 8'd255) src_addr <= {1'b0, idx} + 9'd1;
                end
                3'd1: begin
                    opa0 <= qs; opb0 <= ivlo[17:0];
                    opa1 <= qs; opb1 <= ivhi[17:0];
                end
                3'd2: begin
                    zni <= sat16(zexpr_i);
                end
                3'd3: begin
                    znq <= sat16(zexpr_q);
                    wr_addr <= idx;
                    wr_data <= {sat16(zexpr_q), zni};
                    wr_en   <= 1'b1;
                    if (idx == 8'd255) begin
                        state <= S_DONE;
                        done  <= 1'b1;
                    end else begin
                        idx <= idx + 8'd1;
                        cyc <= 0;
                        state <= S_RUN;
                    end
                end
                default: cyc <= 0;
                endcase
                if (cyc != 3'd3) cyc <= cyc + 1'b1;
            end

            S_DONE: begin
                if (!start) state <= S_IDLE;
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
