// (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:Signal_process:1.0
// IP Revision: 1

(* X_CORE_INFO = "Signal_process,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "ps_ai_Signal_process_0_0,Signal_process,{}" *)
(* CORE_GENERATION_INFO = "ps_ai_Signal_process_0_0,Signal_process,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=Signal_process,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module ps_ai_Signal_process_0_0 (
  sclk,
  s_rst_n,
  s_tdata,
  s_tkeep,
  s_tvalid,
  s_tlast,
  s_tready,
  dout_TDATA,
  dout_TVALID,
  dout_TREADY,
  dout_TKEEP,
  dout_TLAST,
  eq_TDATA,
  eq_TVALID,
  eq_TREADY,
  eq_TKEEP,
  eq_TLAST,
  eq_tuser,
  eq_stat_drop,
  eq_stat_theta,
  eq_stat_gate,
  eq_busy,
  expert_TDATA,
  expert_TVALID,
  expert_TREADY,
  expert_TKEEP,
  expert_TLAST,
  expert_stat_drop,
  expert_stat_frames,
  expert_busy
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sclk, ASSOCIATED_BUSIF s:dout:eq:expert, ASSOCIATED_RESET s_rst_n, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0, CLK_DOMAIN exdes_hp_axi_aclk" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sclk CLK" *)
input wire sclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_rst_n RST" *)
input wire s_rst_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TDATA" *)
input wire [63 : 0] s_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TKEEP" *)
input wire [7 : 0] s_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TVALID" *)
input wire s_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TLAST" *)
input wire s_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0, HAS_TREADY 1, CLK_DOMAIN exdes_hp_axi_aclk, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s TREADY" *)
output wire s_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TDATA" *)
output wire [31 : 0] dout_TDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TVALID" *)
output wire dout_TVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TREADY" *)
input wire dout_TREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TKEEP" *)
output wire [3 : 0] dout_TKEEP;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dout, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0, HAS_TREADY 1, CLK_DOMAIN exdes_hp_axi_aclk, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dout TLAST" *)
output wire dout_TLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TDATA" *)
output wire [31 : 0] eq_TDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TVALID" *)
output wire eq_TVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TREADY" *)
input wire eq_TREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TKEEP" *)
output wire [3 : 0] eq_TKEEP;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME eq, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0, HAS_TREADY 1, CLK_DOMAIN exdes_hp_axi_aclk, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 eq TLAST" *)
output wire eq_TLAST;
output wire eq_tuser;
output wire [31 : 0] eq_stat_drop;
output wire [22 : 0] eq_stat_theta;
output wire eq_stat_gate;
output wire eq_busy;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TDATA" *)
output wire [31 : 0] expert_TDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TVALID" *)
output wire expert_TVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TREADY" *)
input wire expert_TREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TKEEP" *)
output wire [3 : 0] expert_TKEEP;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME expert, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TKEEP 1, HAS_TSTRB 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.000, INSERT_VIP 0, HAS_TREADY 1, CLK_DOMAIN exdes_hp_axi_aclk, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 expert TLAST" *)
output wire expert_TLAST;
output wire [31 : 0] expert_stat_drop;
output wire [31 : 0] expert_stat_frames;
output wire expert_busy;

  Signal_process inst (
    .sclk(sclk),
    .s_rst_n(s_rst_n),
    .s_tdata(s_tdata),
    .s_tkeep(s_tkeep),
    .s_tvalid(s_tvalid),
    .s_tlast(s_tlast),
    .s_tready(s_tready),
    .dout_TDATA(dout_TDATA),
    .dout_TVALID(dout_TVALID),
    .dout_TREADY(dout_TREADY),
    .dout_TKEEP(dout_TKEEP),
    .dout_TLAST(dout_TLAST),
    .eq_TDATA(eq_TDATA),
    .eq_TVALID(eq_TVALID),
    .eq_TREADY(eq_TREADY),
    .eq_TKEEP(eq_TKEEP),
    .eq_TLAST(eq_TLAST),
    .eq_tuser(eq_tuser),
    .eq_stat_drop(eq_stat_drop),
    .eq_stat_theta(eq_stat_theta),
    .eq_stat_gate(eq_stat_gate),
    .eq_busy(eq_busy),
    .expert_TDATA(expert_TDATA),
    .expert_TVALID(expert_TVALID),
    .expert_TREADY(expert_TREADY),
    .expert_TKEEP(expert_TKEEP),
    .expert_TLAST(expert_TLAST),
    .expert_stat_drop(expert_stat_drop),
    .expert_stat_frames(expert_stat_frames),
    .expert_busy(expert_busy)
  );
endmodule
