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

// IP VLNV: xilinx.com:hls:RFFI_FFT_ConvNet:1.0
// IP Revision: 610121950

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
RFFI_FFT_ConvNet_0 your_instance_name (
  .tok_V_ce0(tok_V_ce0),                  // output wire tok_V_ce0
  .tok_V_we0(tok_V_we0),                  // output wire tok_V_we0
  .logits_V_ce0(logits_V_ce0),            // output wire logits_V_ce0
  .logits_V_we0(logits_V_we0),            // output wire logits_V_we0
  .ap_clk(ap_clk),                        // input wire ap_clk
  .ap_rst(ap_rst),                        // input wire ap_rst
  .ap_start(ap_start),                    // input wire ap_start
  .ap_done(ap_done),                      // output wire ap_done
  .ap_idle(ap_idle),                      // output wire ap_idle
  .ap_ready(ap_ready),                    // output wire ap_ready
  .din_V_V_dout(din_V_V_dout),            // input wire [32 : 0] din_V_V_dout
  .din_V_V_empty_n(din_V_V_empty_n),      // input wire din_V_V_empty_n
  .din_V_V_read(din_V_V_read),            // output wire din_V_V_read
  .tok_V_address0(tok_V_address0),        // output wire [11 : 0] tok_V_address0
  .tok_V_d0(tok_V_d0),                    // output wire [7 : 0] tok_V_d0
  .tok_V_address1(tok_V_address1),        // output wire [11 : 0] tok_V_address1
  .tok_V_ce1(tok_V_ce1),                  // output wire [0 : 0] tok_V_ce1
  .tok_V_we1(tok_V_we1),                  // output wire [0 : 0] tok_V_we1
  .tok_V_d1(tok_V_d1),                    // output wire [7 : 0] tok_V_d1
  .logits_V_address0(logits_V_address0),  // output wire [10 : 0] logits_V_address0
  .logits_V_d0(logits_V_d0)              // output wire [15 : 0] logits_V_d0
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file RFFI_FFT_ConvNet_0.v when simulating
// the core, RFFI_FFT_ConvNet_0. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

