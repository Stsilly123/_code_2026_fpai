// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module lstf_eq(clk, rst_n, din, din_valid, m_tdata, m_tvalid, 
  m_tready, m_tkeep, m_tlast, m_tuser, stat_drop, stat_theta, stat_gate, busy);
  input clk;
  input rst_n;
  input [31:0]din;
  input din_valid;
  output [31:0]m_tdata;
  output m_tvalid;
  input m_tready;
  output [3:0]m_tkeep;
  output m_tlast;
  output m_tuser;
  output [31:0]stat_drop;
  output [22:0]stat_theta;
  output stat_gate;
  output busy;
endmodule
