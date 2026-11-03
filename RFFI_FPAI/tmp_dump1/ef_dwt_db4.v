`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_dwt_db4 : 4 级 db4（symmetric），单通道；输入 zn Q12，输出 5 个带的能量和
//
//   源：level0 读顶层 zn_ram（src_sel=1）；level1..3 读内部 cA ping-pong。
//   每个输出 t：cA[t] = sum lo[k]*x_ext(2t+1-k)，cD 同理；Q14 系数，
//   Q26 累加 -> (acc+8192)>>>14 -> Q12，饱和到 18 bit（golden 同口径）。
//   能量：cD^2（level3 再加 cA4^2）累加到 64 bit，Q24。
//
//   外部读口约定：本模块给出 src_addr（相对该级源数组的下标），
//   src_data 在下一拍有效（BRAM 1 拍读延迟）。
// -----------------------------------------------------------------------------
module ef_dwt_db4 (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         start,
    // 外部源（level0，zn_ram；顶层按 ch 选择 I/Q 并符号扩展）
    output wire [8:0]   src_addr,
    output wire         src_sel,
    input  wire signed [23:0] src_data,
    // 结果
    output reg  [63:0]  e_ca4,
    output reg  [63:0]  e_cd4,
    output reg  [63:0]  e_cd3,
    output reg  [63:0]  e_cd2,
    output reg  [63:0]  e_cd1,
    output reg          done,
    output wire         busy
);
    `include "expert_rom.vh"

    localparam S_IDLE = 3'd0, S_ALIGN = 3'd1, S_FETCH = 3'd2,
               S_MAC  = 3'd3, S_MAC2  = 3'd4, S_FIN   = 3'd5,
               S_ESUM = 3'd6, S_EADD  = 3'd7;

    reg [2:0]  state;
    reg [1:0]  level;
    reg [9:0]  N, L;
    reg [8:0]  t;
    reg signed [10:0] fetch_n;
    reg [3:0]  got, need;
    reg [2:0]  cyc;
    reg        src_bank, dst_bank;

    reg signed [23:0] win [0:7];
    reg signed [23:0] ca_q;
    reg signed [23:0] bank0 [0:131];
    reg signed [23:0] bank1 [0:131];

    reg signed [43:0] accA, accB;
    // 乘法结果先寄存（DSP 输出寄存器），下一拍再做 4->1 加法树 + 累加，
    // 否则 win -> mux -> 4 个 DSP -> 42 bit 加法树 -> 44 bit 累加 全在一拍里，
    // OOC 综合实测 9.4 ns（200 MHz 下 -4.4 ns）。
    reg signed [39:0] p0_r, p1_r, p2_r, p3_r;
    reg               is_hi_r;
    reg signed [23:0] ca_s, cd_s;
    reg [47:0] sq_ca, sq_cd;

    assign busy = (state != S_IDLE);

    // level0 读外部 zn，其余读内部 cA
    wire raw_mode = (level == 2'd0);
    wire signed [23:0] shift_data = raw_mode ? src_data : ca_q;

    // 内部 cA 读（同步读，1 拍）；level0 的地址超出 bank 深度，夹到 0
    wire [7:0] bank_raddr = (src_addr < 9'd132) ? src_addr[7:0] : 8'd0;
    always @(posedge clk)
        ca_q <= src_bank ? bank1[bank_raddr] : bank0[bank_raddr];

    function [8:0] ext_idx;
        input signed [10:0] n;
        input [9:0] nn;
        begin
            if (n < 0)
                ext_idx = -n - 1;
            else if (n >= nn)
                ext_idx = 2 * nn - n - 1;
            else
                ext_idx = n;
        end
    endfunction

    // 地址组合输出：fetch_n 变化后下一拍 RAM 采样，再下一拍数据有效
    assign src_addr = ext_idx(fetch_n, N);
    assign src_sel  = raw_mode;

    function signed [23:0] sat18;
        input signed [63:0] v;
        begin
            if (v > 64'sd131071)
                sat18 = 24'sd131071;
            else if (v < -64'sd131072)
                sat18 = -24'sd131072;
            else
                sat18 = v[23:0];
        end
    endfunction

    // 4 个 MAC 的操作数（按 cyc 选）
    reg signed [23:0] w0, w1, w2, w3;
    reg signed [15:0] c0, c1, c2, c3;
    reg               is_hi;
    always @* begin
        case (cyc)
            2'd0: begin w0 = win[7]; w1 = win[6]; w2 = win[5]; w3 = win[4];
                         c0 = DB4_LO0; c1 = DB4_LO1; c2 = DB4_LO2; c3 = DB4_LO3;
                         is_hi = 1'b0; end
            2'd1: begin w0 = win[3]; w1 = win[2]; w2 = win[1]; w3 = win[0];
                         c0 = DB4_LO4; c1 = DB4_LO5; c2 = DB4_LO6; c3 = DB4_LO7;
                         is_hi = 1'b0; end
            2'd2: begin w0 = win[7]; w1 = win[6]; w2 = win[5]; w3 = win[4];
                         c0 = DB4_HI0; c1 = DB4_HI1; c2 = DB4_HI2; c3 = DB4_HI3;
                         is_hi = 1'b1; end
            default: begin w0 = win[3]; w1 = win[2]; w2 = win[1]; w3 = win[0];
                         c0 = DB4_HI4; c1 = DB4_HI5; c2 = DB4_HI6; c3 = DB4_HI7;
                         is_hi = 1'b1; end
        endcase
    end

    // 操作数先寄存一拍再进 DSP。cyc 的扇出是 115，cyc -> 4:1 mux -> DSP A 口
    // 1.5 ns（其中路由 1.26 ns）叠上 DSP 内部 2.7 ns，路由后只剩 0.12 ns。
    // 寄存后 mux 只驱动 FF（会被打包进 DSP 输入寄存器），乘法推迟一拍，
    // 所以 S_MAC 多跑一拍、is_hi_r 改用寄存后的 is_hi_o 对齐。
    reg signed [23:0] w0_r, w1_r, w2_r, w3_r;
    reg signed [15:0] c0_r, c1_r, c2_r, c3_r;
    reg               is_hi_o;
    wire signed [39:0] prod0 = w0_r * c0_r;
    wire signed [39:0] prod1 = w1_r * c1_r;
    wire signed [39:0] prod2 = w2_r * c2_r;
    wire signed [39:0] prod3 = w3_r * c3_r;
    // 上一拍寄存的 4 个乘积 -> 44 bit 加法树（DSP 之后单独一级）
    wire signed [43:0] psum = {{4{p0_r[39]}}, p0_r} + {{4{p1_r[39]}}, p1_r} +
                               {{4{p2_r[39]}}, p2_r} + {{4{p3_r[39]}}, p3_r};

    wire signed [43:0] ca_raw = accA + 44'sd8192;
    wire signed [43:0] cd_raw = accB + 44'sd8192;
    wire signed [23:0] ca_val = sat18({{34{ca_raw[43]}}, ca_raw[43:14]});
    wire signed [23:0] cd_val = sat18({{34{cd_raw[43]}}, cd_raw[43:14]});

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE; level <= 0; N <= 10'd256; L <= 10'd131; t <= 0;
            fetch_n <= -11'sd6; got <= 0; need <= 0; cyc <= 0;
            src_bank <= 0; dst_bank <= 0;
            accA <= 0; accB <= 0; ca_s <= 0; cd_s <= 0; sq_ca <= 0; sq_cd <= 0;
            p0_r <= 0; p1_r <= 0; p2_r <= 0; p3_r <= 0; is_hi_r <= 1'b0;
            w0_r <= 0; w1_r <= 0; w2_r <= 0; w3_r <= 0;
            c0_r <= 0; c1_r <= 0; c2_r <= 0; c3_r <= 0; is_hi_o <= 1'b0;
            e_ca4 <= 0; e_cd4 <= 0; e_cd3 <= 0; e_cd2 <= 0; e_cd1 <= 0;
            done <= 0;
            for (i = 0; i < 8; i = i + 1) win[i] <= 0;
        end else begin
            done <= 1'b0;

            case (state)
            S_IDLE: begin
                if (start) begin
                    level <= 0; N <= 10'd256; L <= 10'd131; t <= 0;
                    src_bank <= 0; dst_bank <= 0;
                    e_ca4 <= 0; e_cd4 <= 0; e_cd3 <= 0; e_cd2 <= 0; e_cd1 <= 0;
                    got <= 0; need <= 4'd8; fetch_n <= -11'sd6;
                    state <= S_ALIGN;
                end
            end

            // 空拍：src_addr 是 fetch_n 的组合输出，本拍 RAM 采样，
            // 下一拍（FETCH）数据有效。
            S_ALIGN: begin
                // 空拍：本拍地址被 RAM 采样，同时前移给下一拍
                fetch_n <= fetch_n + 1'b1;
                state   <= S_FETCH;
            end

            // 每拍移位一个样本；fetch_n 同步前移，地址在组合端立即更新。
            S_FETCH: begin
`ifdef DWT_DBG
                if (level == 2'd0 && t == 0 && got < 8)
                    $display("DWTDBG fetch got=%0d data=%0d next_addr=%0d",
                             got, shift_data, src_addr);
`endif
                for (i = 0; i < 7; i = i + 1)
                    win[i] <= win[i+1];
                win[7] <= shift_data;
                got <= got + 1'b1;
                if (got + 1'b1 == need) begin
                    // 最后一个样本：地址停在“下一个未读”，留给下一次输出
                    accA <= 0; accB <= 0; cyc <= 0;
                    p0_r <= 0; p1_r <= 0; p2_r <= 0; p3_r <= 0; is_hi_r <= 1'b0;
                    // 操作数清零：S_MAC 第一拍算出的乘积是 0，留给流水填充拍累加
                    w0_r <= 0; w1_r <= 0; w2_r <= 0; w3_r <= 0;
                    c0_r <= 0; c1_r <= 0; c2_r <= 0; c3_r <= 0; is_hi_o <= 1'b0;
                    state <= S_MAC;
                end else begin
                    // 地址领先数据一拍（下一拍 RAM 采样）
                    fetch_n <= fetch_n + 1'b1;
                end
            end

            // 两级软流水：本拍把上一拍的乘积做加法树并累加，同时发出本拍的乘法。
            // 每个输出 4 个 MAC -> 5 拍（多出的 1 拍是流水排空）。
            S_MAC: begin
                if (is_hi_r)
                    accB <= accB + psum;
                else
                    accA <= accA + psum;
                w0_r <= w0; w1_r <= w1; w2_r <= w2; w3_r <= w3;
                c0_r <= c0; c1_r <= c1; c2_r <= c2; c3_r <= c3;
                is_hi_o <= is_hi;
                p0_r <= prod0; p1_r <= prod1; p2_r <= prod2; p3_r <= prod3;
                is_hi_r <= is_hi_o;
                // cyc 0..3 发 4 组操作数，cyc 4 只等最后一组的乘积落地
                if (cyc == 3'd4) begin
                    cyc   <= 0;
                    state <= S_MAC2;
                end else begin
                    cyc   <= cyc + 1'b1;
                    state <= S_MAC;
                end
            end

            S_MAC2: begin
                if (is_hi_r)
                    accB <= accB + psum;
                else
                    accA <= accA + psum;
                state <= S_FIN;
            end

            S_FIN: begin
                ca_s <= ca_val;
                cd_s <= cd_val;
                if (dst_bank)
                    bank1[t] <= ca_val;
                else
                    bank0[t] <= ca_val;
                state <= S_ESUM;
            end

            S_ESUM: begin
                sq_ca <= ca_s * ca_s;
                sq_cd <= cd_s * cd_s;
                state <= S_EADD;
            end

            S_EADD: begin
`ifdef DWT_DBG
                if (level == 2'd0 && t == L - 1)
                    $display("DWTDBG ca[0..7] = %0d %0d %0d %0d %0d %0d %0d %0d",
                             bank0[0], bank0[1], bank0[2], bank0[3],
                             bank0[4], bank0[5], bank0[6], bank0[7]);
`endif
                case (level)
                    2'd0: e_cd1 <= e_cd1 + {16'd0, sq_cd};
                    2'd1: e_cd2 <= e_cd2 + {16'd0, sq_cd};
                    2'd2: e_cd3 <= e_cd3 + {16'd0, sq_cd};
                    default: begin
                        e_cd4 <= e_cd4 + {16'd0, sq_cd};
                        e_ca4 <= e_ca4 + {16'd0, sq_ca};
                    end
                endcase

                if (t == L - 1) begin
                    if (level == 2'd3) begin
                        done  <= 1'b1;
                        state <= S_IDLE;
                    end else begin
                        level   <= level + 1'b1;
                        N       <= L;
                        L       <= (L + 10'd7) >> 1;
                        t       <= 0;
                        src_bank <= dst_bank;
                        dst_bank <= ~dst_bank;
                        got     <= 0;
                        need    <= 4'd8;
                        fetch_n <= -11'sd6;
                        state   <= S_ALIGN;
                    end
                end else begin
                    t     <= t + 1'b1;
                    got   <= 0;
                    need  <= 4'd2;
                    // 地址领先：下一个待移位的样本已由计算期间的连续读取得
                    fetch_n <= fetch_n + 1'b1;
                    state <= S_FETCH;
                end
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
