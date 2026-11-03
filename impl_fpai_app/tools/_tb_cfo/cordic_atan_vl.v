`timescale 1ns / 1ps
// Behavioral stand-in for the cordic_atan_vl VHDL wrapper (Arc_Tan, 16 in/16 out).
// Only used to re-run tb_ef_cfo without the Vivado CORDIC core library.
// Input packing matches the RTL: tdata = {Y(im)[31:16], X(re)[15:0]}.
// Output is Q13 radians (pi -> 25736) so that (out>>>1) is Q12 like the board.
module cordic_atan_vl (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        s_axis_cartesian_tvalid,
    input  wire [31:0] s_axis_cartesian_tdata,
    output reg         m_axis_dout_tvalid,
    output reg  [15:0] m_axis_dout_tdata
);
    localparam LAT = 10;
    localparam signed [31:0] PI_Q13 = 32'sd25736;

    reg        vld [0:LAT-1];
    reg [15:0] dat [0:LAT-1];

    reg signed [31:0] atab [0:15];
    initial begin
        atab[0]  = 32'sd6434;  atab[1]  = 32'sd3798;
        atab[2]  = 32'sd2007;  atab[3]  = 32'sd1019;
        atab[4]  = 32'sd511;   atab[5]  = 32'sd256;
        atab[6]  = 32'sd128;   atab[7]  = 32'sd64;
        atab[8]  = 32'sd32;    atab[9]  = 32'sd16;
        atab[10] = 32'sd8;     atab[11] = 32'sd4;
        atab[12] = 32'sd2;     atab[13] = 32'sd1;
        atab[14] = 32'sd0;     atab[15] = 32'sd0;
    end

    function [15:0] calc;
        input signed [15:0] xi;
        input signed [15:0] yi;
        integer k;
        reg signed [31:0] xv, yv, zv, xt;
        begin
            if (xi < 0) begin
                xv = -xi; yv = -yi;
                zv = (yi >= 0) ? PI_Q13 : -PI_Q13;
            end else begin
                xv = xi; yv = yi; zv = 0;
            end
            for (k = 0; k < 16; k = k + 1) begin
                if (yv > 0) begin
                    xt = xv + (yv >>> k);
                    yv = yv - (xv >>> k);
                    zv = zv + atab[k];
                end else begin
                    xt = xv - (yv >>> k);
                    yv = yv + (xv >>> k);
                    zv = zv - atab[k];
                end
                xv = xt;
            end
            calc = zv[15:0];
        end
    endfunction

    integer i;
    always @(posedge aclk) begin
        if (!aresetn) begin
            m_axis_dout_tvalid <= 1'b0;
            m_axis_dout_tdata  <= 16'd0;
            for (i = 0; i < LAT; i = i + 1) begin
                vld[i] <= 1'b0;
                dat[i] <= 16'd0;
            end
        end else begin
            vld[0] <= s_axis_cartesian_tvalid;
            dat[0] <= s_axis_cartesian_tvalid
                      ? calc($signed(s_axis_cartesian_tdata[15:0]),
                             $signed(s_axis_cartesian_tdata[31:16]))
                      : 16'd0;
            for (i = 1; i < LAT; i = i + 1) begin
                vld[i] <= vld[i-1];
                dat[i] <= dat[i-1];
            end
            m_axis_dout_tvalid <= vld[LAT-1];
            m_axis_dout_tdata  <= dat[LAT-1];
        end
    end
endmodule
