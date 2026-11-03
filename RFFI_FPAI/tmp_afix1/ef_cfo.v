`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// ef_cfo : 9 维频偏特征
//
//   R1  = Σ_{t=1..255} z[t]·conj(z[t-1])          (Q12，每项 +2048 舍入)
//   R20 = Σ_{t=20..255} z[t]·conj(z[t-20])
//   BLK[k] = R20 在 u=t-20 满足 (u%64)<44 且 u/64=k 的四段内（每段 44 点）
//   mean = (R·rcp)>>16（rcp：236→278，255→257，44→1489）
//   特征：[ang20, mag20, ang1, mag1, b0, b1, b2, b3, bstd]
//   bstd = sqrt((4Σb² - (Σb)²)>>4)   （与 Python 口径一致）
//
//   两条 18x18 有符号乘法器分时复用：样点相关项、均值 scaling（拆高低 14 位）、
//   平方、块角方差。均值 scaling 拆成 hi/lo 两半，保证与 48 位精确乘法同结果。
//   CORDIC sqrt/atan 由顶层共享；atan 输入左移到 msb=13 以保精度。
// -----------------------------------------------------------------------------
module ef_cfo (
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
    // 9 维结果
    output reg signed [31:0] ang20, mag20, ang1, mag1,
    output reg signed [31:0] b0, b1, b2, b3,
    output reg signed [31:0] bstd,
    output reg         done,
    output wire        busy
);
    `include "expert_rom.vh"

    localparam S_IDLE   = 4'd0,
               S_WAIT   = 4'd1,
               S_SAMPLE = 4'd2,
               S_MEAN   = 4'd3,
               S_NORM   = 4'd4,
               S_SQR    = 4'd5,
               S_ISSUE  = 4'd6,
               S_COLL   = 4'd7,
               S_BSTD   = 4'd8,
               S_ISSUE2 = 4'd9,
               S_COLL2  = 4'd10,
               S_ASM    = 4'd11,
               S_DONE   = 4'd12,
               S_RD     = 4'd13;   // zn_ram 读出先寄存一拍

    reg [3:0] state;
    reg [4:0] cyc;
    reg [7:0] t;
    reg [3:0] iissue;
    reg [2:0] sqc, atc;

    // ---- 样点相关 ----
    reg signed [15:0] a, b, last_i, last_q;
    reg signed [15:0] si_r, sq_r;   // BRAM 读出先寄存，S_SAMPLE 只用寄存器版本
    reg signed [15:0] sri [0:19];
    reg signed [15:0] srq [0:19];
    // 12 个 48 bit 累积器改用 DSP48E1 的 ALU 内部反馈（P = P + C），
    // 模块定义在 ef_cumulant.v 末尾（dsp_acc48）。每个累积器原先 ≈60 个 LUT
    // （48 bit 进位链 + 保持选择）加一条回环布线；现在只剩 DSP 内部的 P 回环。
    // 加数仍是 p0/p1 的 48 bit 加/移位，和原来同一拍进累加，逐位等价。
    wire signed [47:0] R1r, R1i, R20r, R20i;
    wire signed [47:0] BLKr0, BLKr1, BLKr2, BLKr3;
    wire signed [47:0] BLKi0, BLKi1, BLKi2, BLKi3;
    // 块累加拆两级：DSP 输出 -> 48 bit 加/移位寄存 -> 累加器。
    // 原来 p0/p1 -> 加/移位 -> BLKr 分布式 RAM 写，实测 5.0 ns。
    reg signed [47:0] blkr_v, blki_v;
    reg               blk_en_d;
    reg [1:0]         bi_d;

    wire acc_clr = !rst_n || (state == S_IDLE && start);
    wire smp     = (state == S_SAMPLE);
    wire en_r1r   = smp && (cyc == 5'd2);
    wire en_r1i   = smp && (cyc == 5'd3);
    wire en_r20r  = smp && (cyc == 5'd4);
    wire en_r20i  = smp && (cyc == 5'd5);
    wire blk_wr   = smp && (cyc == 5'd5) && blk_en_d;   // 块实部
    wire blk_wi   = smp && (cyc == 5'd6) && blk_en_d;   // 块虚部
    wire en_blkr0 = blk_wr && (bi_d == 2'd0);
    wire en_blkr1 = blk_wr && (bi_d == 2'd1);
    wire en_blkr2 = blk_wr && (bi_d == 2'd2);
    wire en_blkr3 = blk_wr && (bi_d == 2'd3);
    wire en_blki0 = blk_wi && (bi_d == 2'd0);
    wire en_blki1 = blk_wi && (bi_d == 2'd1);
    wire en_blki2 = blk_wi && (bi_d == 2'd2);
    wire en_blki3 = blk_wi && (bi_d == 2'd3);

    // ---- 共用乘法器（18x18 有符号）----
    reg  signed [17:0] opa0, opb0, opa1, opb1;
    reg  signed [47:0] p0, p1;
    wire signed [35:0] mul0 = opa0 * opb0;
    wire signed [35:0] mul1 = opa1 * opb1;
    // 累加器的加数（48 bit 加/移位），R1r/R20r 与 blkr_v 共用同一份组合逻辑
    wire signed [47:0] sm_r = (p0 + p1 + 48'sd2048) >>> 12;
    wire signed [47:0] sm_i = (p1 - p0 + 48'sd2048) >>> 12;

    // ---- 均值 ----
    reg signed [31:0] mval [0:11];
    reg signed [47:0] qcur;
    reg signed [17:0] kcur;
    wire signed [17:0] qhi = qcur[31:14];
    wire signed [17:0] qlo = {4'd0, qcur[13:0]};

    // ---- 归一化 / 平方 / CORDIC ----
    reg signed [47:0] mre, mim, mabs, mabs2, rsc, imc, tr, ti;
    reg [5:0] mmsb, msh;
    reg signed [23:0] rsq [0:5];
    reg signed [23:0] imq [0:5];
    // 归一化分四级（每级每拍一项，寄存器组按“位置 0 = 当前项”轮转）：
    //   一级选源并寄存；二级 max(|re|,|im|)；三级 48 bit 优先级编码；四级变量移位 + atv。
    //   轮转只是寄存器间连线（不花 LUT），避免“按 cyc 索引读数组”退化成 LUTRAM
    //   读 + 地址译码 —— 200 MHz 下那条路由要 5 ns。
    //   6 项挤在一拍时：48 bit 优先级编码 x6 + 两个 48 bit 移位器 x6，
    //   OOC 实测 24 级逻辑（200 MHz 下 -3.6 ns）。
    reg signed [47:0] mre_r [0:5];
    reg signed [47:0] mim_r [0:5];
    reg signed [47:0] mabs_rot [0:5];
    reg [5:0]  msh_rot [0:5];
    reg [5:0]  mmsb_rot [0:5];
    reg [5:0]  sreg [0:5];
    reg [1:0]  aflag [0:5];     // 0 正常, 1 (0,0), 2 (im=0,re<0)->+pi
    reg [31:0] atv [0:5];
    reg signed [47:0] sqs [0:5];

    reg [16:0] magtmp [0:1];
    reg [16:0] bstr;
    reg signed [15:0] angtmp [0:5];

    // ---- 块角方差 ----
    reg signed [47:0] bsq01, bsq23;
    // vexpr 先落一拍再比较/移位：整版实测 bsq01 -> 40bit 加 -> DSP -> 比较 -> varv
    // 的同步复位端只有 -0.069 ns。拆开后每段都远小于 5 ns。
    reg signed [47:0] vexpr_q;
    // sb = bg0+bg1+bg2+bg3 拆两段预加并寄存：原来 4 个 angtmp 求和 + 进位链直接
    // 顶到乘法器 A 口（-0.067 ns），现在 cyc0/cyc1 各寄存一段，cyc2 只剩两级加法。
    reg signed [31:0] sb01, sb23;

    wire signed [47:0] vexpr = ((bsq01 + bsq23) <<< 2) - p0;
    reg  signed [31:0] varv;

    // atan 输入的“变址读”必须写成常量索引选择，不能用 atv[aidx]：
    // atv 是 6 深移位链，若用 3 bit 变址，Vivado 会把它推断成 SRL16E 并按 8 深
    // 翻转 tap（A = 7 - idx），元素 0/1 落到链外，读回的是上一帧的 p4/p5
    // —— 上板表现为 178/180 滞后一帧、182..185 用了 p0..p3。cf. ef_cumulant.atv_sel。
    wire [31:0] atv_sel =
        (iissue == 4'd2) ? atv[0] :
        (iissue == 4'd3) ? atv[1] :
        (iissue == 4'd4) ? atv[2] :
        (iissue == 4'd5) ? atv[3] :
        (iissue == 4'd6) ? atv[4] : atv[5];

    integer k, l;

    assign busy = (state != S_IDLE);

    // 块窗口：t∈[20+64k, 63+64k]
    wire [7:0] u = t - 8'd20;
    wire blk_en = (t >= 8'd20) && (u[5:0] < 6'd44);
    wire [1:0] bi = u[7:6];

    // atan 结果纠偏（收 ack 时就做掉，读回后不再重复 10 份比较/选择）
    function signed [15:0] corr_ang;
        input signed [15:0] raw;
        input [1:0] fl;
        begin
            corr_ang = (fl == 2'd1) ? 16'sd0 :
                       (fl == 2'd2) ? PI_Q12 :
                       (raw == -PI_Q12) ? PI_Q12 : raw;
        end
    endfunction

    wire signed [15:0] bg0 = angtmp[2];
    wire signed [15:0] bg1 = angtmp[3];
    wire signed [15:0] bg2 = angtmp[4];
    wire signed [15:0] bg3 = angtmp[5];

    // 均值选择
    always @* begin
        case (cyc)
        5'd0:  begin qcur = R20r;   kcur = 18'sd278;  end
        5'd1:  begin qcur = R20i;   kcur = 18'sd278;  end
        5'd2:  begin qcur = R1r;    kcur = 18'sd257;  end
        5'd3:  begin qcur = R1i;    kcur = 18'sd257;  end
        5'd4:  begin qcur = BLKr0; kcur = 18'sd1489; end
        5'd5:  begin qcur = BLKi0; kcur = 18'sd1489; end
        5'd6:  begin qcur = BLKr1; kcur = 18'sd1489; end
        5'd7:  begin qcur = BLKi1; kcur = 18'sd1489; end
        5'd8:  begin qcur = BLKr2; kcur = 18'sd1489; end
        5'd9:  begin qcur = BLKi2; kcur = 18'sd1489; end
        5'd10: begin qcur = BLKr3; kcur = 18'sd1489; end
        5'd11: begin qcur = BLKi3; kcur = 18'sd1489; end
        default: begin qcur = 0; kcur = 0; end
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE;
            cyc <= 0; t <= 0; iissue <= 0; sqc <= 0; atc <= 0;
            src_addr <= 0;
            sq_req <= 0; at_req <= 0; sq_in <= 0; at_in <= 0;
            done <= 0;
            a <= 0; b <= 0; last_i <= 0; last_q <= 0;
            si_r <= 0; sq_r <= 0;
            blkr_v <= 0; blki_v <= 0; blk_en_d <= 0; bi_d <= 0;
            for (k = 0; k < 20; k = k + 1) begin
                sri[k] <= 0; srq[k] <= 0;
            end
            opa0 <= 0; opb0 <= 0; opa1 <= 0; opb1 <= 0; p0 <= 0; p1 <= 0;
            vexpr_q <= 0; sb01 <= 0; sb23 <= 0;
            ang20 <= 0; mag20 <= 0; ang1 <= 0; mag1 <= 0;
            b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0; bstd <= 0;
        end else begin
            p0 <= mul0;
            p1 <= mul1;
            done <= 0;

            // 共享 CORDIC 回读
            if (sq_ack) begin
                if (sqc < 3'd2) magtmp[sqc] <= sq_out;
                else            bstr <= sq_out;
                sqc <= sqc + 1'b1;
            end
            if (at_ack) begin
                angtmp[atc] <= corr_ang(at_out >>> 1, aflag[atc]);
                atc <= atc + 1'b1;
            end

            case (state)
            S_IDLE: begin
                if (start) begin
                    src_addr <= 0;
                    t <= 0; cyc <= 0; iissue <= 0; sqc <= 0; atc <= 0;
                    for (k = 0; k < 20; k = k + 1) begin
                        sri[k] <= 0; srq[k] <= 0;
                    end
                    last_i <= 0; last_q <= 0;
                    state <= S_WAIT;
                end
            end

            S_WAIT: state <= S_RD;

            S_RD: begin
                si_r <= src_i;
                sq_r <= src_q;
                state <= S_SAMPLE;
            end

            // ---------------- 样点相关：6 拍/样点 ----------------
            S_SAMPLE: begin
                case (cyc)
                5'd0: begin
                    a <= si_r; b <= sq_r;
                    opa0 <= si_r;   opb0 <= last_i;
                    opa1 <= sq_r;   opb1 <= last_q;
                end
                5'd1: begin
                    opa0 <= a; opb0 <= last_q;
                    opa1 <= b; opb1 <= last_i;
                end
                5'd2: begin                       // R1 实部

                    opa0 <= a; opb0 <= sri[0];
                    opa1 <= b; opb1 <= srq[0];
                end
                5'd3: begin                       // R1 虚部

                    opa0 <= a; opb0 <= srq[0];
                    opa1 <= b; opb1 <= sri[0];
                end
                5'd4: begin                       // R20 实部
                    blkr_v   <= sm_r;
                    blk_en_d <= blk_en;
                    bi_d     <= bi;
                    if (t != 8'd255) src_addr <= {1'b0, t} + 9'd1;
                end
                5'd5: begin                       // R20 虚部；写块实部
                    blki_v <= sm_i;
                    blk_en_d <= blk_en;
                    bi_d     <= bi;
                end
                5'd6: begin                       // 写块虚部；推进样点
                    for (l = 0; l < 19; l = l + 1) begin
                        sri[l] <= sri[l+1];
                        srq[l] <= srq[l+1];
                    end
                    sri[19] <= a; srq[19] <= b;
                    last_i <= a; last_q <= b;
                    if (t == 8'd255) begin
                        state <= S_MEAN;
                        cyc <= 0;
                    end else begin
                        t <= t + 8'd1;
                        cyc <= 0;
                        state <= S_RD;
                    end
                end
                default: cyc <= 0;
                endcase
                if (cyc != 5'd6) cyc <= cyc + 1'b1;
            end

            // ---------------- 均值：12 个量 × (hi,lo) ----------------
            S_MEAN: begin
                if (cyc < 5'd12) begin
                    opa0 <= qhi; opb0 <= kcur;
                    opa1 <= qlo; opb1 <= kcur;
                end else begin
                    opa0 <= 0; opb0 <= 0; opa1 <= 0; opb1 <= 0;
                end
                if (cyc >= 5'd2)
                    mval[cyc-2] <= ((p0 <<< 14) + p1) >>> 16;
                if (cyc == 5'd13) begin
                    state <= S_NORM;
                    cyc <= 0;
                end else begin
                    cyc <= cyc + 1'b1;
                end
            end

            // ---------------- 归一化 + atan 输入 ----------------
            S_NORM: begin
                if (cyc < 5'd6) begin
                    // ---- S1：选源并寄存 ----
                    case (cyc[2:0])
                    3'd0: begin mre = mval[0];  mim = mval[1];  end
                    3'd1: begin mre = mval[2];  mim = mval[3];  end
                    3'd2: begin mre = mval[4];  mim = mval[5];  end
                    3'd3: begin mre = mval[6];  mim = mval[7];  end
                    3'd4: begin mre = mval[8];  mim = mval[9];  end
                    default: begin mre = mval[10]; mim = mval[11]; end
                    endcase
                    mre_r[cyc[2:0]]  <= mre;
                    mim_r[cyc[2:0]]  <= mim;
                end else if (cyc < 5'd12) begin
                    // ---- S2：max(|re|,|im|) ----
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
                end else if (cyc < 5'd18) begin
                    // ---- S3：48 bit 优先级编码 ----
                    mmsb = 6'd0;
                    for (l = 0; l < 48; l = l + 1)
                        if (mabs_rot[0][l]) mmsb = l;
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
                end else begin
                    // ---- S4：变量移位 + atan 输入 / 符号表 ----
                    rsc = mre_r[0] >>> msh_rot[0];
                    imc = mim_r[0] >>> msh_rot[0];
                    if (mmsb_rot[0] < 6'd13) begin
                        tr = rsc <<< (6'd13 - mmsb_rot[0]);
                        ti = imc <<< (6'd13 - mmsb_rot[0]);
                    end else begin
                        tr = rsc;
                        ti = imc;
                    end
                    rsq[0] <= rsq[1]; rsq[1] <= rsq[2]; rsq[2] <= rsq[3];
                    rsq[3] <= rsq[4]; rsq[4] <= rsq[5]; rsq[5] <= rsc[23:0];
                    imq[0] <= imq[1]; imq[1] <= imq[2]; imq[2] <= imq[3];
                    imq[3] <= imq[4]; imq[4] <= imq[5]; imq[5] <= imc[23:0];
                    atv[0] <= atv[1]; atv[1] <= atv[2]; atv[2] <= atv[3];
                    atv[3] <= atv[4]; atv[4] <= atv[5];
                    atv[5] <= {ti[15:0], tr[15:0]};
                    aflag[0] <= aflag[1]; aflag[1] <= aflag[2]; aflag[2] <= aflag[3];
                    aflag[3] <= aflag[4]; aflag[4] <= aflag[5];
                    aflag[5] <= (mre_r[0] == 0 && mim_r[0] == 0) ? 2'd1 :
                                (mim_r[0] == 0 && mre_r[0] < 0) ? 2'd2 : 2'd0;
                    sreg[0] <= sreg[1]; sreg[1] <= sreg[2]; sreg[2] <= sreg[3];
                    sreg[3] <= sreg[4]; sreg[4] <= sreg[5]; sreg[5] <= msh_rot[0];
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
                if (cyc == 5'd23) begin
                    state <= S_SQR;
                    cyc <= 0;
                end else begin
                    cyc <= cyc + 1'b1;
                end
            end

            // ---------------- 平方和（6 项）----------------
            S_SQR: begin
                if (cyc < 5'd6) begin
                    opa0 <= rsq[cyc][17:0]; opb0 <= rsq[cyc][17:0];
                    opa1 <= imq[cyc][17:0]; opb1 <= imq[cyc][17:0];
                end else begin
                    opa0 <= 0; opb0 <= 0; opa1 <= 0; opb1 <= 0;
                end
                if (cyc >= 5'd2) sqs[cyc-2] <= p0 + p1;
                if (cyc == 5'd7) begin
                    sqc <= 0; atc <= 0; iissue <= 0;
                    state <= S_ISSUE;
                    cyc <= 0;
                end else begin
                    cyc <= cyc + 1'b1;
                end
            end

            // ---------------- 发 CORDIC：2 sqrt + 6 atan ----------------
            S_ISSUE: begin
                if (iissue < 4'd8) begin
                    sq_req <= (iissue < 4'd2);
                    sq_in  <= (iissue == 4'd0) ? sqs[0][31:0] : sqs[1][31:0];
                    at_req <= (iissue >= 4'd2);
                    at_in  <= (iissue >= 4'd2) ? atv_sel : 32'd0;
                    iissue <= iissue + 1'b1;
                end else begin
                    sq_req <= 0; at_req <= 0;
                    state <= S_COLL;
                end
            end

            S_COLL: begin
                if (sqc == 3'd2 && atc == 3'd6)
                    state <= S_BSTD;
            end

            // ---------------- 块角方差 ----------------
            S_BSTD: begin
                case (cyc)
                5'd0: begin
                    opa0 <= bg0; opb0 <= bg0;
                    opa1 <= bg1; opb1 <= bg1;
                    sb01 <= bg0 + bg1;
                end
                5'd1: begin
                    opa0 <= bg2; opb0 <= bg2;
                    opa1 <= bg3; opb1 <= bg3;
                    sb23 <= bg2 + bg3;
                end
                5'd2: begin
                    bsq01 <= p0 + p1;
                    opa0 <= sb01 + sb23; opb0 <= sb01 + sb23;
                    opa1 <= 0;  opb1 <= 0;
                end
                5'd3: bsq23 <= p0 + p1;
                5'd4: vexpr_q <= vexpr;
                5'd5: begin
                    varv <= (vexpr_q < 0) ? 32'sd0 : (vexpr_q >>> 4);
                    state <= S_ISSUE2;
                    cyc <= 0;
                end
                default: cyc <= 0;
                endcase
                if (cyc != 5'd5) cyc <= cyc + 1'b1;
            end

            S_ISSUE2: begin
                sq_req <= 1'b1;
                sq_in  <= varv;
                state  <= S_COLL2;
            end

            S_COLL2: begin
                sq_req <= 1'b0;
                if (sqc == 3'd3) state <= S_ASM;
            end

            S_ASM: begin
                ang20 <= angtmp[0];
                ang1  <= angtmp[1];
                b0    <= angtmp[2];
                b1    <= angtmp[3];
                b2    <= angtmp[4];
                b3    <= angtmp[5];
                mag20 <= {15'd0, magtmp[0]} << sreg[0];
                mag1  <= {15'd0, magtmp[1]} << sreg[1];
                bstd  <= {15'd0, bstr};
                done  <= 1;
                state <= S_DONE;
            end

            S_DONE: begin
                if (!start) state <= S_IDLE;
            end

            default: state <= S_IDLE;
            endcase
        end
    end

    // ---- 12 个 48 bit 累积器：DSP48E1 的 ALU 内部反馈（模块见 ef_cumulant.v）----
    dsp_acc48 u_acc_r1r  (.clk(clk), .rst(acc_clr), .en(en_r1r),  .c(sm_r),    .p(R1r));
    dsp_acc48 u_acc_r1i  (.clk(clk), .rst(acc_clr), .en(en_r1i),  .c(sm_i),    .p(R1i));
    dsp_acc48 u_acc_r20r (.clk(clk), .rst(acc_clr), .en(en_r20r), .c(sm_r),    .p(R20r));
    dsp_acc48 u_acc_r20i (.clk(clk), .rst(acc_clr), .en(en_r20i), .c(sm_i),    .p(R20i));
    dsp_acc48 u_acc_blkr0(.clk(clk), .rst(acc_clr), .en(en_blkr0),.c(blkr_v),  .p(BLKr0));
    dsp_acc48 u_acc_blkr1(.clk(clk), .rst(acc_clr), .en(en_blkr1),.c(blkr_v),  .p(BLKr1));
    dsp_acc48 u_acc_blkr2(.clk(clk), .rst(acc_clr), .en(en_blkr2),.c(blkr_v),  .p(BLKr2));
    dsp_acc48 u_acc_blkr3(.clk(clk), .rst(acc_clr), .en(en_blkr3),.c(blkr_v),  .p(BLKr3));
    dsp_acc48 u_acc_blki0(.clk(clk), .rst(acc_clr), .en(en_blki0),.c(blki_v),  .p(BLKi0));
    dsp_acc48 u_acc_blki1(.clk(clk), .rst(acc_clr), .en(en_blki1),.c(blki_v),  .p(BLKi1));
    dsp_acc48 u_acc_blki2(.clk(clk), .rst(acc_clr), .en(en_blki2),.c(blki_v),  .p(BLKi2));
    dsp_acc48 u_acc_blki3(.clk(clk), .rst(acc_clr), .en(en_blki3),.c(blki_v),  .p(BLKi3));

endmodule
