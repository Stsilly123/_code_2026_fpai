`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_cumulant : 6 个复累积量的模/相（12 维）
//
//   每样点：z2=z*z, z4=z2*z2, z6=z4*z2, m2=(zi^2+zq^2)>>12,
//           m2z=m2*z, m4=m2^2>>12, m6=m4*m2>>12（cmul 均 Q12，+2048 舍入）
//   13 拍/样点；两条 32x32 乘法器分时复用（帧尾的 c 量也走这两条）。
//   帧尾：c20/c40/c41/c42/c60/c63，模 = sqrt((re>>s)^2+(im>>s)^2)<<s，
//          相 = atan2(im,re)（c42/c63 为实数量：0 或 +pi）。
//   CORDIC sqrt/atan 由顶层共享。
//
//   乘法器时序：第 T 拍写操作数 -> T+1 操作数有效 -> T+2 乘积可用。
// -----------------------------------------------------------------------------
module ef_cumulant (
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
    // 结果 12 维：先 6 个模，再 6 个相
    output reg signed [31:0] mag0, mag1, mag2, mag3, mag4, mag5,
    output reg signed [31:0] ang0, ang1, ang2, ang3, ang4, ang5,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam S_IDLE = 3'd0, S_WAIT = 3'd1, S_SAMPLE = 3'd2,
               S_FINAL = 3'd3, S_SQR = 3'd4, S_ISSUE = 3'd5,
               S_COLL = 3'd6, S_DONE = 3'd7, S_ASM = 4'd8,
               S_RD = 4'd9;   // zn_ram 读出先寄存一拍

    reg [3:0]  state;
    reg [4:0]  cyc;
    reg [8:0]  sp;
    reg [5:0]  fst;
    reg [2:0]  bio, iissue;
    reg [2:0]  sqc, atc;

    reg signed [15:0] ar, br;
    // BRAM 直接进 DSP A 口（clk-to-out 1.8 ns + 4 级 mux）过的时机太紧，
    // 先把样点寄存一拍，S_SAMPLE 只用寄存器版本。
    reg signed [15:0] si_r, sq_r;
    reg signed [19:0] m2;
    reg signed [19:0] z2r_r;
    reg signed [20:0] z2i_r;
    reg signed [29:0] z4r_r, z4i_r;

    // 11 个 48 bit 累积器改用 DSP48E1 的 ALU 内部反馈（P = P + C），见文件末尾
    // dsp_acc48。每个累积器原先是 48 bit 进位链 + 保持选择 ≈ 60 个 LUT，而且
    // 反馈线要绕回起点；放进 DSP 后这部分 LUT 和回环布线都省掉，逐位等价
    // （模 2^48，同步清零，start 时刻清一次）。
    wire signed [47:0] Sz2r, Sz2i, Sz4r, Sz4i, Sz6r, Sz6i;
    wire signed [47:0] Sm2zr, Sm2zi, Sm2, Sm4, Sm6;

    wire acc_clr = !rst_n || (state == S_IDLE && start);
    wire en_sz2r  = (state == S_SAMPLE) && (cyc == 5'd3);
    wire en_sm2   = (state == S_SAMPLE) && (cyc == 5'd3);
    wire en_sz2i  = (state == S_SAMPLE) && (cyc == 5'd4);
    wire en_sz4r  = (state == S_SAMPLE) && (cyc == 5'd6);
    wire en_sz4i  = (state == S_SAMPLE) && (cyc == 5'd7);
    wire en_sm2zr = (state == S_SAMPLE) && (cyc == 5'd8);
    wire en_sm2zi = (state == S_SAMPLE) && (cyc == 5'd8);
    wire en_sz6r  = (state == S_SAMPLE) && (cyc == 5'd9);
    wire en_sz6i  = (state == S_SAMPLE) && (cyc == 5'd10);
    wire en_sm4   = (state == S_SAMPLE) && (cyc == 5'd11);
    wire en_sm6   = (state == S_SAMPLE) && (cyc == 5'd13);

    // 共享乘法器
    reg signed [31:0] opa0, opb0, opa1, opb1;
    reg signed [63:0] p0, p1;
    wire signed [63:0] mul0 = opa0 * opb0;
    wire signed [63:0] mul1 = opa1 * opb1;

    // 帧尾 c 量
    reg signed [47:0] c20r, c20i, c21, c4r, c4i, m2zr, m2zi, c6r, c6i;
    reg signed [47:0] c20sqr, c20sqi, c20abs2, c21sq;
    reg signed [47:0] c40r, c40i, c41r, c41i;
    reg signed [47:0] c20x4r, c20x4i, c20c4r, c20c4i;
    reg signed [47:0] c42, c60r, c60i, c63, c21x3;
    reg        f42neg, f63neg;
    // c63 的两项常数乘先寄存，减法/符号判断各占一拍：
    // 原来 p0/p1(DSP 输出) -> *9/*6 -> 48 bit 减法 -> 比较 全在一拍，21 级逻辑。
    reg signed [47:0] c63d9, c63d6;
    // 累积项先寄存一拍再累加：p0/p1 是 DSP 输出，(±、+2048、>>12、48 bit 累加)
    // 挤在同一拍是 14 级进位链（路由后只剩 0.1 ns）。寄存后只剩 48 bit 加法一级。
    reg signed [47:0] m2zr_t, m2zi_t, s6r_t, s6i_t, m4_t, m6_t;

    // 模/相装配
    reg signed [23:0] rsreg [0:5];
    reg signed [23:0] imreg [0:5];
    reg [5:0]  sreg [0:5];
    reg signed [31:0] sqv [0:5];
    reg signed [31:0] atv [0:5];
    // 归一化/装配分四级（每级每拍处理一个累积量，寄存器组按“位置 0 = 当前项”轮转）：
    //   S1 选源并寄存；S2 取模 max(|re|,|im|)；S3 48 bit 优先级编码；S4 变量移位 + 填
    //   rsreg/imreg/atv/azero/sreg。
    //   轮转只是寄存器之间的连线（不花 LUT），所以四个阶段都不用“按 fst 索引读数组”
    //   —— 那样会退化成 LUTRAM 读 + 地址译码，200 MHz 下路由就吃掉 5 ns。
    //   四级各 6 拍，末尾再轮转回原顺序：xxx[i] 仍是第 i 个累积量。
    reg signed [47:0] mre_r [0:5];
    reg signed [47:0] mim_r [0:5];
    reg signed [47:0] mabs_rot [0:5];
    reg [5:0]  msh_rot [0:5];
    reg [5:0]  mmsb_rot [0:5];
    reg        azero [0:5];
    reg [16:0] magtmp [0:5];
    reg signed [15:0] angtmp [0:3];

    integer li, lj;
    reg signed [47:0] mre, mim, mabs, mabs2, rsc, imc, tr, ti;
    reg [5:0] mmsb, msh;

    assign busy = (state != S_IDLE);

    wire signed [47:0] cum_re0 = c20r, cum_im0 = c20i;
    wire signed [47:0] cum_re1 = c40r, cum_im1 = c40i;
    wire signed [47:0] cum_re2 = c41r, cum_im2 = c41i;
    wire signed [47:0] cum_re3 = c42,  cum_im3 = 48'sd0;
    wire signed [47:0] cum_re4 = c60r, cum_im4 = c60i;
    wire signed [47:0] cum_re5 = c63,  cum_im5 = 48'sd0;

    wire signed [31:0] atv_sel =
        (iissue == 3'd0) ? atv[0] :
        (iissue == 3'd1) ? atv[1] :
        (iissue == 3'd2) ? atv[2] : atv[4];
    wire at_issue = (iissue != 3'd3) && (iissue != 3'd5) && (iissue < 3'd6);

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE;
            src_addr <= 0; cyc <= 0; sp <= 0; fst <= 0; bio <= 0; iissue <= 0;
            sqc <= 0; atc <= 0;
            sq_req <= 0; at_req <= 0; sq_in <= 0; at_in <= 0;
            done <= 0;
            ar <= 0; br <= 0; si_r <= 0; sq_r <= 0; m2 <= 0; z2r_r <= 0; z2i_r <= 0;
            z4r_r <= 0; z4i_r <= 0;
            opa0 <= 0; opb0 <= 0; opa1 <= 0; opb1 <= 0; p0 <= 0; p1 <= 0;
            mag0 <= 0; mag1 <= 0; mag2 <= 0; mag3 <= 0; mag4 <= 0; mag5 <= 0;
            ang0 <= 0; ang1 <= 0; ang2 <= 0; ang3 <= 0; ang4 <= 0; ang5 <= 0;
            c20r <= 0; c20i <= 0; c21 <= 0; c4r <= 0; c4i <= 0;
            m2zr <= 0; m2zi <= 0; c6r <= 0; c6i <= 0;
            c20sqr <= 0; c20sqi <= 0; c20abs2 <= 0; c21sq <= 0;
            c40r <= 0; c40i <= 0; c41r <= 0; c41i <= 0;
            c20x4r <= 0; c20x4i <= 0; c20c4r <= 0; c20c4i <= 0;
            c42 <= 0; c60r <= 0; c60i <= 0; c63 <= 0; c21x3 <= 0;
            f42neg <= 0; f63neg <= 0;
            c63d9 <= 0; c63d6 <= 0;
            m2zr_t <= 0; m2zi_t <= 0; s6r_t <= 0; s6i_t <= 0;
            m4_t <= 0; m6_t <= 0;
        end else begin
            p0 <= mul0;
            p1 <= mul1;
            done <= 0;

            // ---- CORDIC 回读（与 FSM 并行；sqc/atc 只在这里和 start 时写）----
            if (sq_ack) begin
                magtmp[sqc] <= sq_out;
                sqc <= sqc + 1'b1;
            end
            if (at_ack) begin
                angtmp[atc] <= at_out >>> 1;
                atc <= atc + 1'b1;
            end

            case (state)
            S_IDLE: begin
                if (start) begin
                    src_addr <= 0;
                    sp <= 0; cyc <= 0;
                    sqc <= 0; atc <= 0;
                    state <= S_WAIT;
                end
            end

            S_WAIT: begin
                cyc <= 0;
                state <= S_RD;
            end

            S_RD: begin
                si_r <= src_i;
                sq_r <= src_q;
                state <= S_SAMPLE;
            end

            S_SAMPLE: begin
                if (cyc != 5'd13) cyc <= cyc + 1'b1;
                case (cyc)
                5'd0: begin
                    ar <= si_r; br <= sq_r;
                    opa0 <= si_r; opb0 <= si_r;
                    opa1 <= sq_r; opb1 <= sq_r;
                end
                5'd1: begin
                    opa0 <= ar; opb0 <= br;
                    opa1 <= 0;  opb1 <= 0;
                end
                5'd2: begin
                    z2r_r <= (p0 - p1 + 64'sd2048) >>> 12;
                    m2    <= (p0 + p1) >>> 12;
                end
                5'd3: begin
                    z2i_r <= (2 * p0 + 64'sd2048) >>> 12;
                    opa0 <= z2r_r; opb0 <= z2r_r;
                    opa1 <= (2 * p0 + 64'sd2048) >>> 12;
                    opb1 <= (2 * p0 + 64'sd2048) >>> 12;
                end
                5'd4: begin
                    opa0 <= z2r_r; opb0 <= z2i_r;
                    opa1 <= 0;     opb1 <= 0;
                end
                5'd5: begin
                    z4r_r <= (p0 - p1 + 64'sd2048) >>> 12;
                    opa0 <= m2; opb0 <= ar;
                    opa1 <= m2; opb1 <= br;
                end
                5'd6: begin
                    z4i_r <= (2 * p0 + 64'sd2048) >>> 12;
                    opa0 <= z4r_r; opb0 <= z2r_r;
                    opa1 <= (2 * p0 + 64'sd2048) >>> 12; opb1 <= z2i_r;
                end
                5'd7: begin
                    m2zr_t <= (p0 + 64'sd2048) >>> 12;
                    m2zi_t <= (p1 + 64'sd2048) >>> 12;
                    opa0 <= z4r_r; opb0 <= z2i_r;
                    opa1 <= z4i_r; opb1 <= z2r_r;
                end
                5'd8: begin
                    s6r_t <= (p0 - p1 + 64'sd2048) >>> 12;
                    opa0 <= m2; opb0 <= m2;
                    opa1 <= 0;  opb1 <= 0;
                end
                5'd9: begin
                    s6i_t <= (p0 + p1 + 64'sd2048) >>> 12;
                    opa0 <= 0; opb0 <= 0;
                    opa1 <= 0; opb1 <= 0;
                end
                5'd10: begin
                    m4_t <= p0 >>> 12;
                    opa0 <= (p0 >>> 12); opb0 <= m2;
                    opa1 <= 0; opb1 <= 0;
                end
                5'd11: begin
                    if (sp != 9'd255) src_addr <= sp + 1'b1;
                end
                5'd12: begin
                    m6_t <= p0 >>> 12;
                end
                5'd13: begin
                    if (sp == 9'd255) begin
                        state <= S_FINAL;
                        fst <= 0;
                    end else begin
                        sp <= sp + 1'b1;
                        cyc <= 0;
                        state <= S_RD;
                    end
                end
                default: cyc <= 0;
                endcase
            end

            // ---------------- 帧尾 ----------------
            S_FINAL: begin
                fst <= fst + 1'b1;
                case (fst)
                6'd0: begin
                    c20r  <= Sz2r >>> 8; c20i  <= Sz2i >>> 8;
                    c21   <= Sm2  >>> 8;
                    c4r   <= Sz4r >>> 8; c4i   <= Sz4i >>> 8;
                    m2zr  <= Sm2zr >>> 8; m2zi <= Sm2zi >>> 8;
                    c6r   <= Sz6r >>> 8; c6i   <= Sz6i >>> 8;
                end
                6'd1: begin
                    opa0 <= c20r; opb0 <= c20r;
                    opa1 <= c20i; opb1 <= c20i;
                end
                6'd2: begin                       // c20 交叉项
                    opa0 <= c20r; opb0 <= c20i;
                    opa1 <= c20i; opb1 <= c20r;
                end
                6'd3: begin                       // 收 c20 对角
                    c20sqr  <= (p0 - p1 + 64'sd2048) >>> 12;
                    c20abs2 <= (p0 + p1 + 64'sd2048) >>> 12;
                    opa0 <= c21; opb0 <= c20r;
                    opa1 <= c21; opb1 <= c20i;
                end
                6'd4: begin                       // 收 c20 交叉 -> c20sq 虚、c40
                    c20sqi <= (2 * p0 + 64'sd2048) >>> 12;
                    c40r <= c4r - 3 * c20sqr;
                    c40i <= c4i - 3 * ((2 * p0 + 64'sd2048) >>> 12);
                    opa0 <= c21; opb0 <= c21;
                    opa1 <= 0;   opb1 <= 0;
                end
                6'd5: begin                       // 收 c21*c20 -> c41
                    c41r <= m2zr - 3 * ((p0 + 64'sd2048) >>> 12);
                    c41i <= m2zi - 3 * ((p1 + 64'sd2048) >>> 12);
                    opa0 <= c20r; opb0 <= c20sqr;
                    opa1 <= c20i; opb1 <= c20sqi;
                end
                6'd6: begin                       // 收 c21^2 -> c21sq、c42
                    c21sq <= (p0 + 64'sd2048) >>> 12;
                    c42   <= (Sm4 >>> 8) - c20abs2 - 2 * ((p0 + 64'sd2048) >>> 12);
                    opa0 <= c20r; opb0 <= c20sqi;
                    opa1 <= c20i; opb1 <= c20sqr;
                end
                6'd7: begin                       // c20^3 实部
                    c20x4r <= (p0 - p1 + 64'sd2048) >>> 12;
                    opa0 <= c20r; opb0 <= c4r;
                    opa1 <= c20i; opb1 <= c4i;
                end
                6'd8: begin                       // c20^3 虚部
                    c20x4i <= (p0 + p1 + 64'sd2048) >>> 12;
                    opa0 <= c20r; opb0 <= c4i;
                    opa1 <= c20i; opb1 <= c4r;
                end
                6'd9: begin                       // c20*c4 实部；同时发 c21x3、c42*c21
                    c20c4r <= (p0 - p1 + 64'sd2048) >>> 12;
                    opa0 <= c21sq; opb0 <= c21;
                    opa1 <= c42;   opb1 <= c21;
                end
                6'd10: begin                      // c20*c4 虚部
                    c20c4i <= (p0 + p1 + 64'sd2048) >>> 12;
                    opa0 <= 0; opb0 <= 0;
                    opa1 <= 0; opb1 <= 0;
                end
                6'd11: begin                      // 收 c21x3(p0)、c42*c21(p1) -> c60/c63
                    c60r <= c6r - 15 * c20c4r + 30 * c20x4r;
                    c60i <= c6i - 15 * c20c4i + 30 * c20x4i;
                    c63d9 <= 9 * ((p1 + 64'sd2048) >>> 12);
                    c63d6 <= 6 * ((p0 + 64'sd2048) >>> 12);
                    f42neg <= (c42 < 0);
                    fst <= 12;
                end
                // ---- S1：选源并寄存（每拍一个累积量）----
                6'd12, 6'd13, 6'd14, 6'd15, 6'd16, 6'd17: begin
                    case (fst - 6'd12)
                    3'd0: begin mre = cum_re0; mim = cum_im0; end
                    3'd1: begin mre = cum_re1; mim = cum_im1; end
                    3'd2: begin mre = cum_re2; mim = cum_im2; end
                    3'd3: begin mre = cum_re3; mim = cum_im3; end
                    3'd4: begin mre = cum_re4; mim = cum_im4; end
                    default: begin mre = cum_re5; mim = cum_im5; end
                    endcase
                    if (fst == 6'd12) c63    <= (Sm6 >>> 8) - c63d9 - c63d6;
                    if (fst == 6'd13) f63neg <= c63[47];
                    mre_r[fst - 6'd12] <= mre;
                    mim_r[fst - 6'd12] <= mim;
                end

                // ---- S2：max(|re|,|im|)（轮转读位置 0）----
                6'd18, 6'd19, 6'd20, 6'd21, 6'd22, 6'd23: begin
                    mabs  = (mre_r[0] < 0) ? -mre_r[0] : mre_r[0];
                    mabs2 = (mim_r[0] < 0) ? -mim_r[0] : mim_r[0];
                    if (mabs2 > mabs) mabs = mabs2;
                    mabs_rot[0] <= mabs_rot[1]; mabs_rot[1] <= mabs_rot[2];
                    mabs_rot[2] <= mabs_rot[3]; mabs_rot[3] <= mabs_rot[4];
                    mabs_rot[4] <= mabs_rot[5]; mabs_rot[5] <= mabs;
                    mre_r[0] <= mre_r[1]; mre_r[1] <= mre_r[2];
                    mre_r[2] <= mre_r[3]; mre_r[3] <= mre_r[4];
                    mre_r[4] <= mre_r[5]; mre_r[5] <= mre_r[0];
                    mim_r[0] <= mim_r[1]; mim_r[1] <= mim_r[2];
                    mim_r[2] <= mim_r[3]; mim_r[3] <= mim_r[4];
                    mim_r[4] <= mim_r[5]; mim_r[5] <= mim_r[0];
                end

                // ---- S3：48 bit 优先级编码 + 右移量（每拍只算一个）----
                6'd24, 6'd25, 6'd26, 6'd27, 6'd28, 6'd29: begin
                    mmsb = 6'd0;
                    for (lj = 0; lj < 48; lj = lj + 1)
                        if (mabs_rot[0][lj]) mmsb = lj;
                    msh = (mmsb >= 6'd14) ? (mmsb - 6'd13) : 6'd0;
                    msh_rot[0]  <= msh_rot[1];  msh_rot[1]  <= msh_rot[2];
                    msh_rot[2]  <= msh_rot[3];  msh_rot[3]  <= msh_rot[4];
                    msh_rot[4]  <= msh_rot[5];  msh_rot[5]  <= msh;
                    mmsb_rot[0] <= mmsb_rot[1]; mmsb_rot[1] <= mmsb_rot[2];
                    mmsb_rot[2] <= mmsb_rot[3]; mmsb_rot[3] <= mmsb_rot[4];
                    mmsb_rot[4] <= mmsb_rot[5]; mmsb_rot[5] <= mmsb;
                    mabs_rot[0] <= mabs_rot[1]; mabs_rot[1] <= mabs_rot[2];
                    mabs_rot[2] <= mabs_rot[3]; mabs_rot[3] <= mabs_rot[4];
                    mabs_rot[4] <= mabs_rot[5]; mabs_rot[5] <= 48'sd0;
                end

                // ---- S4：变量移位 + CORDIC 输入装配（轮转回原顺序）----
                6'd30, 6'd31, 6'd32, 6'd33, 6'd34, 6'd35: begin
                    rsc = mre_r[0] >>> msh_rot[0];
                    imc = mim_r[0] >>> msh_rot[0];
                    if (mmsb_rot[0] < 6'd13) begin
                        tr = rsc <<< (6'd13 - mmsb_rot[0]);
                        ti = imc <<< (6'd13 - mmsb_rot[0]);
                    end else begin
                        tr = rsc;
                        ti = imc;
                    end
                    rsreg[0] <= rsreg[1]; rsreg[1] <= rsreg[2];
                    rsreg[2] <= rsreg[3]; rsreg[3] <= rsreg[4];
                    rsreg[4] <= rsreg[5]; rsreg[5] <= rsc[23:0];
                    imreg[0] <= imreg[1]; imreg[1] <= imreg[2];
                    imreg[2] <= imreg[3]; imreg[3] <= imreg[4];
                    imreg[4] <= imreg[5]; imreg[5] <= imc[23:0];
                    sreg[0] <= sreg[1]; sreg[1] <= sreg[2];
                    sreg[2] <= sreg[3]; sreg[3] <= sreg[4];
                    sreg[4] <= sreg[5]; sreg[5] <= msh_rot[0];
                    atv[0] <= atv[1]; atv[1] <= atv[2]; atv[2] <= atv[3];
                    atv[3] <= atv[4]; atv[4] <= atv[5];
                    atv[5] <= {ti[15:0], tr[15:0]};
                    azero[0] <= azero[1]; azero[1] <= azero[2];
                    azero[2] <= azero[3]; azero[3] <= azero[4];
                    azero[4] <= azero[5];
                    azero[5] <= (rsc == 0 && imc == 0);
                    msh_rot[0] <= msh_rot[1]; msh_rot[1] <= msh_rot[2];
                    msh_rot[2] <= msh_rot[3]; msh_rot[3] <= msh_rot[4];
                    msh_rot[4] <= msh_rot[5]; msh_rot[5] <= 6'd0;
                    mmsb_rot[0] <= mmsb_rot[1]; mmsb_rot[1] <= mmsb_rot[2];
                    mmsb_rot[2] <= mmsb_rot[3]; mmsb_rot[3] <= mmsb_rot[4];
                    mmsb_rot[4] <= mmsb_rot[5]; mmsb_rot[5] <= 6'd0;
                    mre_r[0] <= mre_r[1]; mre_r[1] <= mre_r[2];
                    mre_r[2] <= mre_r[3]; mre_r[3] <= mre_r[4];
                    mre_r[4] <= mre_r[5]; mre_r[5] <= mre_r[0];
                    mim_r[0] <= mim_r[1]; mim_r[1] <= mim_r[2];
                    mim_r[2] <= mim_r[3]; mim_r[3] <= mim_r[4];
                    mim_r[4] <= mim_r[5]; mim_r[5] <= mim_r[0];
                end

                // ---- 启动平方和 ----
                6'd36: begin
                    opa0 <= rsreg[0]; opb0 <= rsreg[0];
                    opa1 <= imreg[0]; opb1 <= imreg[0];
                    bio <= 0;
                    state <= S_SQR;
                end
                default: fst <= 0;
                endcase
            end

            // 逐个收 rs^2+im^2：当前拍 p 是两步前操作数的乘积
            S_SQR: begin
                case (bio)
                3'd0: begin
                    opa0 <= rsreg[1]; opb0 <= rsreg[1];
                    opa1 <= imreg[1]; opb1 <= imreg[1];
                    bio <= 1;
                end
                3'd1: begin
                    sqv[0] <= p0 + p1;
                    opa0 <= rsreg[2]; opb0 <= rsreg[2];
                    opa1 <= imreg[2]; opb1 <= imreg[2];
                    bio <= 2;
                end
                3'd2: begin
                    sqv[1] <= p0 + p1;
                    opa0 <= rsreg[3]; opb0 <= rsreg[3];
                    opa1 <= imreg[3]; opb1 <= imreg[3];
                    bio <= 3;
                end
                3'd3: begin
                    sqv[2] <= p0 + p1;
                    opa0 <= rsreg[4]; opb0 <= rsreg[4];
                    opa1 <= imreg[4]; opb1 <= imreg[4];
                    bio <= 4;
                end
                3'd4: begin
                    sqv[3] <= p0 + p1;
                    opa0 <= rsreg[5]; opb0 <= rsreg[5];
                    opa1 <= imreg[5]; opb1 <= imreg[5];
                    bio <= 5;
                end
                3'd5: begin
                    sqv[4] <= p0 + p1;
                    bio <= 6;
                end
                3'd6: begin
                    sqv[5] <= p0 + p1;
                    bio <= 7;
                end
                default: begin
                    sqc <= 0; atc <= 0; iissue <= 0;
                    state <= S_ISSUE;
                end
                endcase
            end

            S_ISSUE: begin
                if (iissue < 3'd6) begin
                    sq_req <= 1; sq_in <= sqv[iissue];
                    at_req <= at_issue;
                    at_in  <= at_issue ? atv_sel : 32'd0;
                    iissue <= iissue + 1'b1;
                end else begin
                    sq_req <= 0; at_req <= 0;
                    state <= S_COLL;
                end
            end

            S_COLL: begin
                if (sqc == 3'd6 && atc == 3'd4)
                    state <= S_ASM;      // 等一拍，保证最后一个 magtmp/angtmp 已写入
            end

            S_ASM: begin
                mag0 <= {15'd0, magtmp[0]} << sreg[0];
                mag1 <= {15'd0, magtmp[1]} << sreg[1];
                mag2 <= {15'd0, magtmp[2]} << sreg[2];
                mag3 <= {15'd0, magtmp[3]} << sreg[3];
                mag4 <= {15'd0, magtmp[4]} << sreg[4];
                mag5 <= {15'd0, magtmp[5]} << sreg[5];
                ang0 <= azero[0] ? 16'sd0 :
                        (angtmp[0] == -PI_Q12) ? PI_Q12 : angtmp[0];
                ang1 <= azero[1] ? 16'sd0 :
                        (angtmp[1] == -PI_Q12) ? PI_Q12 : angtmp[1];
                ang2 <= azero[2] ? 16'sd0 :
                        (angtmp[2] == -PI_Q12) ? PI_Q12 : angtmp[2];
                ang3 <= f42neg ? PI_Q12 : 32'sd0;
                ang4 <= azero[4] ? 16'sd0 :
                        (angtmp[3] == -PI_Q12) ? PI_Q12 : angtmp[3];
                ang5 <= f63neg ? PI_Q12 : 32'sd0;
                done <= 1;
                state <= S_DONE;
            end

            S_DONE: begin
                if (!start) state <= S_IDLE;
            end
            default: state <= S_IDLE;
            endcase
        end
    end

    // ---- 11 个 48 bit 累积器：DSP48E1 的 ALU 内部反馈 ----
    // 加数是已寄存的值（z2r_r / m2zr_t ...），C 口只走一段短线；
    // 累加、保持（CEP）、清零（RSTP）全在 DSP 内部，逐位等价。
    dsp_acc48 u_acc_sz2r  (.clk(clk), .rst(acc_clr), .en(en_sz2r),  .c({{28{z2r_r[19]}}, z2r_r}), .p(Sz2r));
    dsp_acc48 u_acc_sm2   (.clk(clk), .rst(acc_clr), .en(en_sm2),   .c({{28{m2[19]}},   m2}),     .p(Sm2));
    dsp_acc48 u_acc_sz2i  (.clk(clk), .rst(acc_clr), .en(en_sz2i),  .c({{27{z2i_r[20]}}, z2i_r}), .p(Sz2i));
    dsp_acc48 u_acc_sz4r  (.clk(clk), .rst(acc_clr), .en(en_sz4r),  .c({{18{z4r_r[29]}}, z4r_r}), .p(Sz4r));
    dsp_acc48 u_acc_sz4i  (.clk(clk), .rst(acc_clr), .en(en_sz4i),  .c({{18{z4i_r[29]}}, z4i_r}), .p(Sz4i));
    dsp_acc48 u_acc_sm2zr (.clk(clk), .rst(acc_clr), .en(en_sm2zr), .c(m2zr_t), .p(Sm2zr));
    dsp_acc48 u_acc_sm2zi (.clk(clk), .rst(acc_clr), .en(en_sm2zi), .c(m2zi_t), .p(Sm2zi));
    dsp_acc48 u_acc_sz6r  (.clk(clk), .rst(acc_clr), .en(en_sz6r),  .c(s6r_t),  .p(Sz6r));
    dsp_acc48 u_acc_sz6i  (.clk(clk), .rst(acc_clr), .en(en_sz6i),  .c(s6i_t),  .p(Sz6i));
    dsp_acc48 u_acc_sm4   (.clk(clk), .rst(acc_clr), .en(en_sm4),   .c(m4_t),   .p(Sm4));
    dsp_acc48 u_acc_sm6   (.clk(clk), .rst(acc_clr), .en(en_sm6),   .c(m6_t),   .p(Sm6));

endmodule

// -----------------------------------------------------------------------------
// dsp_acc48：48 bit 同步累加器
//   p <= rst ? 0 : (en ? p + c : p)
// 用 DSP48E1 的 ALU 做 P = P + C（OPMODE：Z=P、Y=C、X=0），
// 进位链、保持选择、P 回环都在 DSP 内部，不占 LUT 和布线。
// 与 "reg signed [47:0] p; always @(posedge clk) ..." 逐位等价（模 2^48）。
// rst 是同步复位（DSP 的 RSTP），优先级高于 en（CEP）。
// -----------------------------------------------------------------------------
module dsp_acc48 (
    input  wire               clk,
    input  wire               rst,
    input  wire               en,
    input  wire signed [47:0] c,
    output wire signed [47:0] p
);
    DSP48E1 #(
        .ACASCREG(0), .ADREG(0), .ALUMODEREG(0), .AREG(0),
        .BCASCREG(0), .BREG(0), .CARRYINREG(0), .CARRYINSELREG(0),
        .CREG(0), .DREG(0), .INMODEREG(0), .MREG(0), .OPMODEREG(0),
        .PREG(1), .USE_DPORT("FALSE"), .USE_MULT("NONE"),
        .USE_SIMD("ONE48"), .AUTORESET_PATDET("NO_RESET"),
        .MASK(48'h3FFFFFFFFFFF), .PATTERN(48'h0),
        .SEL_MASK("MASK"), .SEL_PATTERN("PATTERN"),
        .USE_PATTERN_DETECT("NO_PATDET")
    ) u_dsp (
        .CLK(clk), .CEP(en), .RSTP(rst),
        .OPMODE(7'b0101100),      // Z=P, Y=C, X=0 -> ALU = P + C
        .ALUMODE(4'b0000),
        .A(30'd0), .B(18'd0), .C(c), .D(25'd0),
        .CARRYIN(1'b0), .CARRYINSEL(3'd0),
        .CEA1(1'b0), .CEA2(1'b0), .CEAD(1'b0), .CEALUMODE(1'b0),
        .CEB1(1'b0), .CEB2(1'b0), .CEC(1'b0), .CECARRYIN(1'b0),
        .CECTRL(1'b0), .CED(1'b0), .CEINMODE(1'b0), .CEM(1'b0),
        .RSTA(1'b0), .RSTB(1'b0), .RSTC(1'b0), .RSTD(1'b0), .RSTM(1'b0),
        .RSTALUMODE(1'b0), .RSTINMODE(1'b0), .RSTALLCARRYIN(1'b0), .RSTCTRL(1'b0),
        .INMODE(5'd0), .ACIN(30'd0), .BCIN(18'd0), .PCIN(48'd0),
        .CARRYCASCIN(1'b0), .MULTSIGNIN(1'b0),
        .P(p), .PCOUT(), .CARRYOUT(),
        .ACOUT(), .BCOUT(), .CARRYCASCOUT(), .MULTSIGNOUT(),
        .OVERFLOW(), .UNDERFLOW(), .PATTERNBDETECT(), .PATTERNDETECT()
    );
endmodule
