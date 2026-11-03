`timescale 1ns / 1ps
// 探测 cordic_sqrt / cordic_0 的延迟、输出格式，并对 256 个 zn 样本
// 与 Python sqrt_nearest / atan2_q12 对拍。
// 向量：cordic_m2.hex cordic_i.hex cordic_q.hex cordic_sq.hex cordic_ph.hex
module tb_cordic_probe;
    reg clk = 0;
    reg rst_n = 0;

    reg  [31:0] s_tdata = 0;
    reg         s_tvalid = 0;
    wire        s_tvalid_out;
    wire [23:0] s_tdata_out;

    reg  [31:0] a_tdata = 0;
    reg         a_tvalid = 0;
    wire        a_tvalid_out;
    wire [15:0] a_tdata_out;

    reg [31:0] m2mem [0:255];
    reg [15:0] imem  [0:255];
    reg [15:0] qmem  [0:255];
    reg [16:0] sqexp [0:255];
    reg [15:0] phexp [0:255];

    integer cnt, scnt, acnt, cyc, errs, first_s, first_a;
    integer fsq, fat;
    reg seen_s, seen_a;

    cordic_sqrt_vl u_sqrt (
        .aclk(clk), .aresetn(rst_n),
        .s_axis_cartesian_tvalid(s_tvalid),
        .s_axis_cartesian_tdata(s_tdata),
        .m_axis_dout_tvalid(s_tvalid_out),
        .m_axis_dout_tdata(s_tdata_out)
    );

    cordic_atan_vl u_atan (
        .aclk(clk), .aresetn(rst_n),
        .s_axis_cartesian_tvalid(a_tvalid),
        .s_axis_cartesian_tdata(a_tdata),
        .m_axis_dout_tvalid(a_tvalid_out),
        .m_axis_dout_tdata(a_tdata_out)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            scnt <= 0;
            acnt <= 0;
            cyc <= 0;
            seen_s <= 0;
            seen_a <= 0;
            first_s <= 0;
            first_a <= 0;
            s_tvalid <= 0;
            a_tvalid <= 0;
            s_tdata <= 0;
            a_tdata <= 0;
        end else begin
            cyc <= cyc + 1;
            s_tvalid <= (cnt < 256);
            a_tvalid <= (cnt < 256);
            if (cnt < 256) begin
                s_tdata <= m2mem[cnt];
                a_tdata <= {qmem[cnt], imem[cnt]};
                cnt <= cnt + 1;
            end
            if (s_tvalid_out) begin
                if (!seen_s) begin
                    seen_s <= 1;
                    first_s <= cyc;
                end
                $fdisplay(fsq, "%05h", s_tdata_out[16:0]);
                if (s_tdata_out[16:0] !== sqexp[scnt]) begin
                    if (errs < 10)
                        $display("SQFail i=%0d got=%0d exp=%0d (tdata=%06h)",
                                 scnt, s_tdata_out[16:0], sqexp[scnt], s_tdata_out);
                    errs = errs + 1;
                end
                scnt <= scnt + 1;
            end
            if (a_tvalid_out) begin
                if (!seen_a) begin
                    seen_a <= 1;
                    first_a <= cyc;
                end
                $fdisplay(fat, "%04h", a_tdata_out);
                if (($signed(a_tdata_out) >>> 1) !== $signed(phexp[acnt])) begin
                    if (errs < 20)
                        $display("PHFail i=%0d got=%0d(q13 %0d) exp=%0d (tdata=%04h)",
                                 acnt, $signed(a_tdata_out) >>> 1,
                                 $signed(a_tdata_out), $signed(phexp[acnt]), a_tdata_out);
                    errs = errs + 1;
                end
                acnt <= acnt + 1;
            end
        end
    end

    initial begin
        $readmemh("cordic_m2.hex", m2mem);
        $readmemh("cordic_i.hex", imem);
        $readmemh("cordic_q.hex", qmem);
        $readmemh("cordic_sq.hex", sqexp);
        $readmemh("cordic_ph.hex", phexp);
        fsq = $fopen("cordic_sq_out.hex", "w");
        fat = $fopen("cordic_at_out.hex", "w");
        errs = 0;
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (6) @(posedge clk);
        // 等 256 个输出都回来
        while (scnt < 256 || acnt < 256) @(posedge clk);
        repeat (4) @(posedge clk);
        $display("CORDIC probe: sqrt latency=%0d atan latency=%0d scnt=%0d acnt=%0d errs=%0d",
                 first_s, first_a, scnt, acnt, errs);
        $display("first sqrt got=%06h  first atan raw=%04h", s_tdata_out, a_tdata_out);
        $fclose(fsq);
        $fclose(fat);
        $finish;
    end

    initial begin
        #200000;
        $display("CORDIC TIMEOUT scnt=%0d acnt=%0d cnt=%0d", scnt, acnt, cnt);
        $finish;
    end
endmodule
