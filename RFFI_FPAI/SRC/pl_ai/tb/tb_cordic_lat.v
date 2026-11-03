`timescale 1ns / 1ps
// 单脉冲测 cordic_sqrt_vl / cordic_atan_vl 的拍延迟
module tb_cordic_lat;
    reg clk = 0, rst_n = 0;
    reg tv = 0;
    reg [31:0] td = 0;
    wire sv, av;
    wire [23:0] sd;
    wire [15:0] ad;

    integer cs, ca;

    cordic_sqrt_vl u_s (
        .aclk(clk), .aresetn(rst_n), .s_axis_cartesian_tvalid(tv),
        .s_axis_cartesian_tdata(td), .m_axis_dout_tvalid(sv),
        .m_axis_dout_tdata(sd));

    cordic_atan_vl u_a (
        .aclk(clk), .aresetn(rst_n), .s_axis_cartesian_tvalid(tv),
        .s_axis_cartesian_tdata(td), .m_axis_dout_tvalid(av),
        .m_axis_dout_tdata(ad));

    always #2.5 clk = ~clk;

    initial begin
        repeat (6) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        @(negedge clk);
        tv = 1; td = 32'd1000000;
        @(negedge clk);
        tv = 0; td = 0;

        cs = 0; ca = 0;
        while (!sv && cs < 100) begin @(negedge clk); cs = cs + 1; end
        $display("sqrt latency=%0d out=%05h", cs, sd[16:0]);

        // atan 单独再发一次（同一个 td 对 atan 是 {y,x}）
        repeat (4) @(negedge clk);
        @(negedge clk);
        tv = 1; td = {16'd300, 16'd400};
        @(negedge clk);
        tv = 0; td = 0;
        while (!av && ca < 100) begin @(negedge clk); ca = ca + 1; end
        $display("atan latency=%0d out=%04h (%0d)", ca, ad, $signed(ad));

        // atan(0,0) 和 atan(0,-x)
        repeat (4) @(negedge clk);
        @(negedge clk); tv = 1; td = 32'd0;
        @(negedge clk); tv = 0;
        ca = 0; while (!av && ca < 100) begin @(negedge clk); ca = ca + 1; end
        $display("atan(0,0) out=%04h (%0d)", ad, $signed(ad));
        repeat (4) @(negedge clk);
        @(negedge clk); tv = 1; td = {16'd0, 16'hFAAB};
        @(negedge clk); tv = 0;
        ca = 0; while (!av && ca < 100) begin @(negedge clk); ca = ca + 1; end
        $display("atan(0,-1365) out=%04h (%0d)", ad, $signed(ad));

        $finish;
    end
endmodule
