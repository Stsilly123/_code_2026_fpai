// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Oct 25 09:01:47 2026
// Host        : DESKTOP-0HEH89S running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/FPGA/FPGA/FPAI_PL/RFFI_FPAI/RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_Signal_process_0_0/ps_ai_Signal_process_0_0_stub.v
// Design      : ps_ai_Signal_process_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z030ffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "Signal_process,Vivado 2018.3" *)
module ps_ai_Signal_process_0_0(sclk, s_rst_n, s_tdata, s_tkeep, s_tvalid, s_tlast, 
  s_tready, dout_TDATA, dout_TVALID, dout_TREADY, dout_TKEEP, dout_TLAST, eq_TDATA, eq_TVALID, 
  eq_TREADY, eq_TKEEP, eq_TLAST, eq_tuser, eq_stat_drop, eq_stat_theta, eq_stat_gate, eq_busy, 
  expert_TDATA, expert_TVALID, expert_TREADY, expert_TKEEP, expert_TLAST, expert_stat_drop, 
  expert_stat_frames, expert_busy)
/* synthesis syn_black_box black_box_pad_pin="sclk,s_rst_n,s_tdata[63:0],s_tkeep[7:0],s_tvalid,s_tlast,s_tready,dout_TDATA[31:0],dout_TVALID,dout_TREADY,dout_TKEEP[3:0],dout_TLAST,eq_TDATA[31:0],eq_TVALID,eq_TREADY,eq_TKEEP[3:0],eq_TLAST,eq_tuser,eq_stat_drop[31:0],eq_stat_theta[22:0],eq_stat_gate,eq_busy,expert_TDATA[31:0],expert_TVALID,expert_TREADY,expert_TKEEP[3:0],expert_TLAST,expert_stat_drop[31:0],expert_stat_frames[31:0],expert_busy" */;
  input sclk;
  input s_rst_n;
  input [63:0]s_tdata;
  input [7:0]s_tkeep;
  input s_tvalid;
  input s_tlast;
  output s_tready;
  output [31:0]dout_TDATA;
  output dout_TVALID;
  input dout_TREADY;
  output [3:0]dout_TKEEP;
  output dout_TLAST;
  output [31:0]eq_TDATA;
  output eq_TVALID;
  input eq_TREADY;
  output [3:0]eq_TKEEP;
  output eq_TLAST;
  output eq_tuser;
  output [31:0]eq_stat_drop;
  output [22:0]eq_stat_theta;
  output eq_stat_gate;
  output eq_busy;
  output [31:0]expert_TDATA;
  output expert_TVALID;
  input expert_TREADY;
  output [3:0]expert_TKEEP;
  output expert_TLAST;
  output [31:0]expert_stat_drop;
  output [31:0]expert_stat_frames;
  output expert_busy;
endmodule
