`timescale 1ns / 1ps
// 调试用：只喂第 0 帧（case 0），在各级边界打印内部寄存器
module tb_dbg_eq;
    reg clk = 0, rst_n = 0;
    always #2.5 clk = ~clk;

    reg  [31:0] din = 0;
    reg         din_valid = 0;
    wire [31:0] m_tdata;
    wire        m_tvalid;
    reg         m_tready = 1;
    wire [3:0]  m_tkeep;
    wire        m_tlast, m_tuser;
    wire [31:0] stat_drop;
    wire [22:0] stat_theta;
    wire        stat_gate, busy;

    lstf_eq u (
        .clk(clk), .rst_n(rst_n), .din(din), .din_valid(din_valid),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tkeep(m_tkeep), .m_tlast(m_tlast), .m_tuser(m_tuser),
        .stat_drop(stat_drop), .stat_theta(stat_theta),
        .stat_gate(stat_gate), .busy(busy)
    );

    reg [31:0] in_mem [0:2047];
    initial $readmemh("eq_in.hex", in_mem);

    integer w;
    initial begin
        rst_n = 0;
        repeat (10) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        for (w = 0; w < 256; w = w + 1) begin
            din <= in_mem[w];
            din_valid <= 1'b1;
            @(posedge clk);
        end
        din_valid <= 1'b0;
    end

    // 第一个块第一个 bin 的逐拍跟踪
    integer traced = 0;
    always @(posedge clk) begin
        if (rst_n && u.state == 5'd6 && u.db == 0 && u.dp == 0 &&
            u.cyc >= 18 && u.cyc <= 28 && traced < 40) begin
            $display("cyc=%0d acc=%0d,%0d xr=%0d,%0d al=%0d mul_a=%0d,%0d prd=%0d,%0d mem=%h iss=%0d issd=%0d",
                     u.cyc, u.acc_re, u.acc_im, u.xr, u.xi, u.a_l_re,
                     u.mul_ar, u.mul_ai, u.prd_re, u.prd_im, u.mem_b_q,
                     u.iss, u.iss_d);
            traced = traced + 1;
        end
    end

    // 每块 bin0 结束时打印累计值
    always @(posedge clk) begin
        if (rst_n && u.state == 5'd6 && u.cyc == 9'd28 && u.dp == 0)
            $display("block %0d: acc=%0d,%0d accbin0=%0d,%0d", u.db,
                     u.acc_re, u.acc_im, u.accbin_re[0], u.accbin_im[0]);
    end

    // 前两个块的前 20 拍操作数
    always @(posedge clk) begin
        if (rst_n && u.state == 5'd6 && u.db <= 1 && u.dp == 0 &&
            u.cyc <= 9'd20 && u.iss_d)
            $display("op db=%0d cyc=%0d A=%0d,%0d B=%0d,%0d", u.db, u.cyc,
                     u.cap_ar, u.cap_ai, u.cap_br, u.cap_bi);
        if (rst_n && u.state == 5'd6 && u.dp == 0 && u.db <= 2 && u.cyc == 9'd23)
            $display("dftsum db=%0d acc=%0d,%0d", u.db, u.acc_re, u.acc_im);
    end

    integer prev = -1;
    always @(posedge clk) begin
        if (rst_n) begin
            case (u.state)
            5'd7: if (prev != 7) begin
                $display("GATE  Et=%0d rr=%0d ri=%0d theta=%0d cos=%0d sin=%0d",
                         u.et_reg, u.rr, u.ri, u.theta_r, u.c_os, u.s_in);
                $display("      pb1=%0d,%0d X0=%0d,%0d sp=%0d",
                         u.pb_re[1], u.pb_im[1], u.accbin_re[0], u.accbin_im[0], u.sp_reg);
            end
            5'd10: if (prev != 10) begin
                $display("INTERP hmv=%0d eH=%0d Hraw0=%0d,%0d Hn0=%0d,%0d nH=%0d",
                         u.hmv, u.eH, u.hri[0], u.hrq[0], u.hn_re[0], u.hn_im[0], u.nh_r);
            end
            5'd11: if (prev != 11) begin
                $display("PW    H200=%0d,%0d", u.h20_re[0], u.h20_im[0]);
                $display("H20 = %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d",
                    u.h20_re[0],u.h20_im[0],u.h20_re[1],u.h20_im[1],u.h20_re[2],u.h20_im[2],
                    u.h20_re[3],u.h20_im[3],u.h20_re[4],u.h20_im[4],u.h20_re[5],u.h20_im[5],
                    u.h20_re[6],u.h20_im[6],u.h20_re[7],u.h20_im[7],u.h20_re[8],u.h20_im[8],
                    u.h20_re[9],u.h20_im[9]);
                $display("H20b= %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d",
                    u.h20_re[10],u.h20_im[10],u.h20_re[11],u.h20_im[11],u.h20_re[12],u.h20_im[12],
                    u.h20_re[13],u.h20_im[13],u.h20_re[14],u.h20_im[14],u.h20_re[15],u.h20_im[15],
                    u.h20_re[16],u.h20_im[16],u.h20_re[17],u.h20_im[17],u.h20_re[18],u.h20_im[18],
                    u.h20_re[19],u.h20_im[19]);
            end
            5'd12: if (prev != 12 && u.rk == 0) begin
                $display("REC   eps=%0d", u.eps_r);
            end
            5'd13: if (prev != 13) begin
                $display("IDFT  eps=%0d sumP=%0d P0=%0d W0=%0d,%0d r=%0d e=%0d",
                         u.eps_r, u.sump, u.pl[0], u.w_re[0], u.w_im[0], u.r_reg, u.e_r);
            end
            5'd14: if (prev != 14) begin
                $display("FIR   eH=%0d s_tap=%0d", u.eH, u.s_tap);
                $display("      taps0..4 = %0d,%0d %0d,%0d %0d,%0d %0d,%0d %0d,%0d",
                         u.taps_re[0], u.taps_im[0], u.taps_re[1], u.taps_im[1],
                         u.taps_re[2], u.taps_im[2], u.taps_re[3], u.taps_im[3],
                         u.taps_re[4], u.taps_im[4]);
            end
            default: ;
            endcase
            prev = u.state;
        end
    end

    initial begin
        repeat (60000) @(posedge clk);
        $finish;
    end
endmodule
