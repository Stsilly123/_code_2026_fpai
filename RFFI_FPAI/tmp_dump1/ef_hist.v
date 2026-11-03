`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_hist : 256 样点的幅度/相位直方图 + az 矩
//
//   az  = sqrt(zi^2+zq^2)        （共享 cordic_sqrt，Q12）
//   ph  = atan2(zq,zi)>>1        （共享 cordic_atan，Q13 -> Q12）
//         (0,0) 强制 0；-pi 归一为 +pi（与 numpy atan2 口径一致）
//   幅度 bin = Σ(az >= E_i)，i=0..14       -> 0..15
//   相位 bin = Σ(ph >= P_i)，i=0..10       -> 0..11
//   同时累加 Σaz / Σaz² / Σaz³/4096 / Σ(az²/4096)²，供 ef_power。
//
//   源：输出 src_addr，顶层 RAM 1 拍读延迟返回 zi/zq；
//   每 2 拍吃一个样点（读延迟对齐），共 256 个。
//   CORDIC 由顶层共享，本模块只在 S_SAMPLE（start 后）驱动。
// -----------------------------------------------------------------------------
module ef_hist (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    output reg  [8:0]  src_addr,
    input  wire signed [15:0] src_i,
    input  wire signed [15:0] src_q,
    // 共享 sqrt
    output reg         sq_req,
    output reg  [31:0] sq_in,
    input  wire        sq_ack,
    input  wire [16:0] sq_out,
    // 共享 atan2
    output reg         at_req,
    output reg  [31:0] at_in,
    input  wire        at_ack,
    input  wire signed [15:0] at_out,
    // 结果：0..15 幅度，16..27 相位
    input  wire [4:0]  rd_addr,
    output reg  [8:0]  rd_data,
    output reg  [47:0] acc1,
    output reg  [47:0] acc2,
    output reg  [47:0] acc3,
    output reg  [47:0] acc4,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam S_IDLE = 2'd0, S_ISSUE = 2'd1, S_DRAIN = 2'd2,
               S_DONE = 2'd3;

    reg [1:0] state;
    reg       rd_pending;
    reg       data_vld;
    reg [8:0] iss;          // 下一个要发的读地址
    reg [8:0] in_cnt;       // 已送出的样点数
    reg [8:0] sqn, atn;     // 已收回的 sqrt/atan 数

    reg [8:0] cnt_amp [0:15];
    reg [8:0] cnt_ph  [0:11];
    // 0=正常, 1=(0,0), 2=(qz=0 且 zi<0)->+pi（与 numpy atan2 口径一致）
    reg [1:0] zflag [0:255];

    wire signed [15:0] zi = src_i;
    wire signed [15:0] zq = src_q;
    wire [31:0] m2sum = zi * zi + zq * zq;

    // ---- 幅度侧 ----
    wire [16:0] az = sq_out;

    function [3:0] amp_bin_of;
        input [16:0] a;
        begin
            amp_bin_of = {3'd0, (a >= HIST_AMP_E0)} + {3'd0, (a >= HIST_AMP_E1)} +
                         {3'd0, (a >= HIST_AMP_E2)} + {3'd0, (a >= HIST_AMP_E3)} +
                         {3'd0, (a >= HIST_AMP_E4)} + {3'd0, (a >= HIST_AMP_E5)} +
                         {3'd0, (a >= HIST_AMP_E6)} + {3'd0, (a >= HIST_AMP_E7)} +
                         {3'd0, (a >= HIST_AMP_E8)} + {3'd0, (a >= HIST_AMP_E9)} +
                         {3'd0, (a >= HIST_AMP_E10)} + {3'd0, (a >= HIST_AMP_E11)} +
                         {3'd0, (a >= HIST_AMP_E12)} + {3'd0, (a >= HIST_AMP_E13)} +
                         {3'd0, (a >= HIST_AMP_E14)};
        end
    endfunction

    function [3:0] ph_bin_of;
        input signed [15:0] p;
        begin
            ph_bin_of = {3'd0, (p >= HIST_PH_E0)} + {3'd0, (p >= HIST_PH_E1)} +
                        {3'd0, (p >= HIST_PH_E2)} + {3'd0, (p >= HIST_PH_E3)} +
                        {3'd0, (p >= HIST_PH_E4)} + {3'd0, (p >= HIST_PH_E5)} +
                        {3'd0, (p >= HIST_PH_E6)} + {3'd0, (p >= HIST_PH_E7)} +
                        {3'd0, (p >= HIST_PH_E8)} + {3'd0, (p >= HIST_PH_E9)} +
                        {3'd0, (p >= HIST_PH_E10)};
        end
    endfunction


    // 矩累加分两级流水：CORDIC 回读那一拍只寄存 az/az2（一级乘法），
    // 下一拍再做 az2q*az、az2q*az2q（第二级乘法），再下一拍才累加。
    // 原来 az -> az2 -> az2q -> az3t/az4t -> 48 bit 累加 全在一拍：
    // OOC 实测 11 级逻辑（200 MHz 下 -3.0 ns）。
    // 回读间隔是 2 拍，流水两级刚好不撞。
    reg [16:0] az_p1;
    reg [33:0] az2_p1, az2_p2;
    reg [36:0] az3_p2;
    reg [39:0] az4_p2;
    reg        v1, v2, v3, v2d, v3d;
    // 乘法操作数再寄存一级：az2_p1 是 DSP 输出，>>12 直接进下一级 DSP 的 A 口
    // （A->PCOUT 2.9 ns，串联的另一片 DSP 还要 PCIN 建立时间），200 MHz 只剩 0.16 ns。
    reg [19:0] az2q_p1;
    reg [16:0] az_p1_d;
    (* use_dsp48 = "yes" *) wire [36:0] az3_p2_n = az2q_p1 * az_p1_d;
    (* use_dsp48 = "yes" *) wire [39:0] az4_p2_n = az2q_p1 * az2q_p1;

    // 直方图更新再分两级（每级一拍）：
    //   幅度：az 回读 -> 寄存 az -> 15 个比较出 bin 并寄存 -> 计数值 +1
    //   相位：atan 回读 -> 寄存 (ph_raw, zflag[atn]) -> 归一化/比较出 bin 并寄存 -> 计数 +1
    //   原来 az/atan 回读那一拍里直接做“比较树 + bin -> 计数器 LUTRAM 读-改-写”，
    //   200 MHz 下 6.8 ns。多两级延迟，帧内只多 2x256 拍，预算完全够。
    reg [16:0] az_r;
    // 17x17 平方放在寄存后的 az_r 上：CORDIC 输出组合（rem_p -> 舍入/移位）
    // + 乘法挤在一拍是 12 级逻辑 3.7 ns。
    (* use_dsp48 = "yes" *) wire [33:0] az2_r = az_r * az_r;
    reg [3:0]  amp_bin_r;
    reg        v_amp, v_ampbin;
    reg signed [15:0] ph_raw_r;
    reg [1:0]  zc_r;
    reg [3:0]  ph_bin_r;
    reg        v_ph, v_phbin;
    reg [2:0]  drain_dly;

    // 样点先寄存一拍再发 CORDIC：zn_ram 的读地址由顶层按 state 选，
    // 原路径 state -> 地址 mux -> LUTRAM -> 乘法 -> DSP 输入寄存器在一拍里走完。
    reg signed [15:0] zi_r, zq_r;
    reg        v_issue;

    wire signed [15:0] ph_norm_r = (zc_r == 2'd1) ? 16'sd0 :
                                   (zc_r == 2'd2) ? PI_Q12 :
                                   (ph_raw_r == -PI_Q12) ? PI_Q12 : ph_raw_r;

    // ---- 相位侧 ----
    wire signed [15:0] ph_raw = at_out >>> 1;
    wire [1:0] zc = zflag[atn[7:0]];
    assign busy = (state != S_IDLE);

    integer j;
    always @* begin
        if (rd_addr < 5'd16)
            rd_data = cnt_amp[rd_addr[3:0]];
        else
            rd_data = cnt_ph[rd_addr[4:0] - 5'd16];
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE;
            src_addr <= 0;
            sq_req <= 0; at_req <= 0;
            sq_in <= 0; at_in <= 0;
            rd_pending <= 0; data_vld <= 0;
            iss <= 0; in_cnt <= 0; sqn <= 0; atn <= 0;
            acc1 <= 0; acc2 <= 0; acc3 <= 0; acc4 <= 0;
            az_p1 <= 0; az2_p1 <= 0; az2_p2 <= 0; az3_p2 <= 0; az4_p2 <= 0;
            v1 <= 0; v2 <= 0; v3 <= 0; v2d <= 0; v3d <= 0;
            az2q_p1 <= 0; az_p1_d <= 0;
            az_r <= 0; amp_bin_r <= 0; v_amp <= 0; v_ampbin <= 0;
            ph_raw_r <= 0; zc_r <= 0; ph_bin_r <= 0; v_ph <= 0; v_phbin <= 0;
            drain_dly <= 0;
            zi_r <= 0; zq_r <= 0; v_issue <= 0;
            done <= 0;
            for (j = 0; j < 16; j = j + 1) cnt_amp[j] <= 0;
            for (j = 0; j < 12; j = j + 1) cnt_ph[j] <= 0;
        end else begin
            done <= 0;

            case (state)
            S_IDLE: begin
                if (start) begin
                    src_addr <= 9'd0;
                    iss <= 9'd1;
                    rd_pending <= 1;
                    in_cnt <= 0;
                    sqn <= 0; atn <= 0;
                    drain_dly <= 0; v_issue <= 0;
                    acc1 <= 0; acc2 <= 0; acc3 <= 0; acc4 <= 0;
                    for (j = 0; j < 16; j = j + 1) cnt_amp[j] <= 0;
                    for (j = 0; j < 12; j = j + 1) cnt_ph[j] <= 0;
                    state <= S_ISSUE;
                end
            end

            S_ISSUE: begin
                sq_req <= 0; at_req <= 0;
                if (rd_pending) begin
                    data_vld <= 1;
                    rd_pending <= 0;
                end
                if (data_vld) begin
                    zi_r <= zi; zq_r <= zq;
                    data_vld <= 1'b0;
                    v_issue <= 1'b1;
                end
                if (v_issue) begin
                    sq_req <= 1; at_req <= 1;
                    sq_in <= zi_r * zi_r + zq_r * zq_r;
                    at_in <= {zq_r, zi_r};
                    zflag[in_cnt[7:0]] <= (zi_r == 0 && zq_r == 0) ? 2'd1 :
                                          (zq_r == 0 && zi_r < 0)    ? 2'd2 : 2'd0;
                    in_cnt <= in_cnt + 1'b1;
                    v_issue <= 1'b0;
                    if (in_cnt == 9'd255) begin
                        state <= S_DRAIN;
                    end else begin
                        src_addr <= iss;
                        iss <= iss + 1'b1;
                        rd_pending <= 1;
                    end
                end
            end

            S_DRAIN: begin
                sq_req <= 0; at_req <= 0;
                if (sqn == 9'd256 && atn == 9'd256) begin
                    // 直方图/矩还有 4 拍流水，等它落地再 done
                    if (drain_dly == 3'd5) begin
                        done <= 1;
                        state <= S_DONE;
                    end else begin
                        drain_dly <= drain_dly + 1'b1;
                    end
                end
            end

            S_DONE: begin
                if (!start) state <= S_IDLE;
            end

            default: state <= S_IDLE;
            endcase

            // CORDIC 回读（与状态并行）
            v1 <= sq_ack;
            v2 <= v1;
            v3 <= v2;
            v_amp    <= sq_ack;
            v_ampbin <= v_amp;
            v_ph     <= at_ack;
            v_phbin  <= v_ph;
            if (sq_ack) begin
                az_r   <= az;
                acc1   <= acc1 + az;
                az_p1  <= az;
                sqn    <= sqn + 1'b1;
            end
            if (v1) begin
                az2_p1 <= az2_r;
            end
            if (v_amp) begin
                amp_bin_r <= amp_bin_of(az_r);
            end
            if (v_ampbin) begin
                cnt_amp[amp_bin_r] <= cnt_amp[amp_bin_r] + 1'b1;
            end
            // 一级流水：寄存乘法操作数（az2q/az），乘法因此晚一拍
            if (v2) begin
                az2_p2  <= az2_p1;
                az2q_p1 <= az2_p1 >> 12;
                az_p1_d <= az_p1;
            end
            v2d <= v2; v3d <= v3;
            // 二级流水：az2q*az / az2q^2（操作数已寄存，落地后再收）
            if (v2d) begin
                az3_p2 <= az3_p2_n;
                az4_p2 <= az4_p2_n;
            end
            // 三级：累加（az2 用 v3，az3/az4 因多一级乘法顺延到 v3d）
            if (v3) begin
                acc2 <= acc2 + az2_p2;
            end
            if (v3d) begin
                acc3 <= acc3 + az3_p2;
                acc4 <= acc4 + az4_p2;
            end
            if (at_ack) begin
                ph_raw_r <= ph_raw;
                zc_r     <= zc;
                atn      <= atn + 1'b1;
            end
            if (v_ph) begin
                ph_bin_r <= ph_bin_of(ph_norm_r);
            end
            if (v_phbin) begin
                cnt_ph[ph_bin_r] <= cnt_ph[ph_bin_r] + 1'b1;
            end
        end
    end

endmodule
