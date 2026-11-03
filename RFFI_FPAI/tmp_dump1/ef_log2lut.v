`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_log2lut : 64-bit 正整数 -> log2(p) Q16
//
//   e   = 63 - clz64(p)
//   m   = p << (63-e)                 // Q63，[1,2)
//   idx = m[62:53]                    // 1024 项尾数 LUT
//   low = m[52:32]                    // 21 bit 线性插值
//   log2 = (e<<16) + lut[idx] + (slope[idx]*low >>> 21)
//
//   一次一个请求：req 拉高一拍且 busy=0 时接收；ack 一拍，log2_q16 有效。
//   p==0 时 pzero=1（log2 输出 0），由调用者换成各自的口径常数。
//
//   200 MHz 流水（接收后 7 拍 ack）：
//     T1 锁 p        T2 算 clz/e      T3 移位得 m（同时给 ROM 地址）
//     T4,T5 ROM 两拍  T5 插值乘       T6 乘积分量寄存   T7 加/ack
//   这样 clz 和 64 bit 移位不在同一拍，乘法（DSP 组合 2.6 ns）和后面的
//   32 bit 加法各占一拍，不再串在同一拍里。
// -----------------------------------------------------------------------------
module ef_log2lut (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        req,
    input  wire [63:0] p,
    output reg         ack,
    output reg         pzero,
    output reg signed [31:0] log2_q16,
    output wire        busy
);

    reg [63:0] p_r;
    reg [5:0]  e_r, e_d;
    reg [63:0] m_r;
    reg [5:0]  v;          // v[0]=p 有效 ... v[4]=乘积分量寄存 ... v[5]=加法/ack
    reg [5:0]  pz_sr;      // 与 v 同深度的 p==0 标志

    // 乘积分量寄存（T6）。sl_prod 是 DSP 组合乘法输出，直接进 32 bit 加法
    // 会串成 4.95 ns 一条路径；在这里断开后只剩 6 级 CARRY4。
    reg signed [31:0] frac_r;
    reg signed [17:0] lut_r;
    reg [5:0]         e_dd;

    // clz64（组合，作用在已寄存的 p_r 上）
    reg  [6:0] clz;
    integer j;
    always @(*) begin
        clz = 7'd64;
        for (j = 0; j < 64; j = j + 1)
            if (p_r[j])
                clz = 7'd63 - j[6:0];
    end

    wire [5:0]  e_now   = 6'd63 - clz[5:0];
    wire [63:0] m_now   = (p_r == 64'd0) ? 64'd0 : (p_r << (6'd63 - e_r));
    wire [9:0]  idx_now = m_r[62:53];
    wire [20:0] low_now = m_r[52:32];

    wire [35:0] douta;
    log2_lut_rom u_rom (
        .clka  (clk),
        .ena   (1'b1),
        .addra (idx_now),
        .douta (douta)
    );

    wire signed [17:0] lut_q16   = douta[17:0];
    wire signed [17:0] slope_q16 = douta[35:18];
    wire signed [38:0] sl_prod   = slope_q16 * $signed({1'b0, low_now});
    wire signed [38:0] frac      = sl_prod >>> 21;

    wire accept = req & ~busy;

    assign busy = |v;

    always @(posedge clk) begin
        if (!rst_n) begin
            p_r      <= 64'd0;
            e_r      <= 6'd0;
            e_d      <= 6'd0;
            m_r      <= 64'd0;
            v        <= 6'd0;
            pz_sr    <= 6'd0;
            frac_r   <= 32'sd0;
            lut_r    <= 18'sd0;
            e_dd     <= 6'd0;
            ack      <= 1'b0;
            pzero    <= 1'b0;
            log2_q16 <= 32'sd0;
        end else begin
            ack <= 1'b0;
            v   <= {v[4:0], accept};
            pz_sr <= {pz_sr[4:0], (accept && (p == 64'd0))};

            if (accept) begin
                p_r <= p;
            end

            if (v[0]) begin
                e_r <= e_now;
            end

            if (v[1]) begin
                m_r <= m_now;
                e_d <= e_r;
            end

            if (v[4]) begin
                frac_r <= frac[31:0];
                lut_r  <= lut_q16;
                e_dd   <= e_d;
            end

            if (v[5]) begin
                ack      <= 1'b1;
                pzero    <= pz_sr[5];
                log2_q16 <= pz_sr[5] ? 32'sd0 :
                            ($signed({26'd0, e_dd}) << 16) +
                            {{14{lut_r[17]}}, lut_r} + frac_r;
            end
        end
    end

endmodule
