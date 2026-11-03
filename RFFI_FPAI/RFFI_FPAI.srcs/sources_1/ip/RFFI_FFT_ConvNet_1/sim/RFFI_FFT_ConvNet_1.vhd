-- (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:hls:RFFI_FFT_ConvNet:1.0
-- IP Revision: 610121950

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RFFI_FFT_ConvNet_1 IS
  PORT (
    tok_V_ce0 : OUT STD_LOGIC;
    tok_V_we0 : OUT STD_LOGIC;
    logits_V_ce0 : OUT STD_LOGIC;
    logits_V_we0 : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    din_V_V_dout : IN STD_LOGIC_VECTOR(32 DOWNTO 0);
    din_V_V_empty_n : IN STD_LOGIC;
    din_V_V_read : OUT STD_LOGIC;
    tok_V_address0 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    tok_V_d0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    tok_V_address1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    tok_V_ce1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    tok_V_we1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    tok_V_d1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    logits_V_address0 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    logits_V_d0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END RFFI_FFT_ConvNet_1;

ARCHITECTURE RFFI_FFT_ConvNet_1_arch OF RFFI_FFT_ConvNet_1 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF RFFI_FFT_ConvNet_1_arch: ARCHITECTURE IS "yes";
  COMPONENT RFFI_FFT_ConvNet IS
    PORT (
      tok_V_ce0 : OUT STD_LOGIC;
      tok_V_we0 : OUT STD_LOGIC;
      logits_V_ce0 : OUT STD_LOGIC;
      logits_V_we0 : OUT STD_LOGIC;
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      ap_start : IN STD_LOGIC;
      ap_done : OUT STD_LOGIC;
      ap_idle : OUT STD_LOGIC;
      ap_ready : OUT STD_LOGIC;
      din_V_V_dout : IN STD_LOGIC_VECTOR(32 DOWNTO 0);
      din_V_V_empty_n : IN STD_LOGIC;
      din_V_V_read : OUT STD_LOGIC;
      tok_V_address0 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      tok_V_d0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      tok_V_address1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      tok_V_ce1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      tok_V_we1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      tok_V_d1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      logits_V_address0 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
      logits_V_d0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT RFFI_FFT_ConvNet;
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF RFFI_FFT_ConvNet_1_arch: ARCHITECTURE IS "HLS";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF logits_V_d0: SIGNAL IS "XIL_INTERFACENAME logits_V_d0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF logits_V_d0: SIGNAL IS "xilinx.com:signal:data:1.0 logits_V_d0 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF logits_V_address0: SIGNAL IS "XIL_INTERFACENAME logits_V_address0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 11} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF logits_V_address0: SIGNAL IS "xilinx.com:signal:data:1.0 logits_V_address0 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_d1: SIGNAL IS "XIL_INTERFACENAME tok_V_d1, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 8} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_d1: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_d1 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_we1: SIGNAL IS "XIL_INTERFACENAME tok_V_we1, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_we1: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_we1 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_ce1: SIGNAL IS "XIL_INTERFACENAME tok_V_ce1, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_ce1: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_ce1 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_address1: SIGNAL IS "XIL_INTERFACENAME tok_V_address1, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 12} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_address1: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_address1 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_d0: SIGNAL IS "XIL_INTERFACENAME tok_V_d0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 8} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_d0: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_d0 DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tok_V_address0: SIGNAL IS "XIL_INTERFACENAME tok_V_address0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 12} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF tok_V_address0: SIGNAL IS "xilinx.com:signal:data:1.0 tok_V_address0 DATA";
  ATTRIBUTE X_INTERFACE_INFO OF din_V_V_read: SIGNAL IS "xilinx.com:interface:acc_fifo_read:1.0 din_V_V RD_EN";
  ATTRIBUTE X_INTERFACE_INFO OF din_V_V_empty_n: SIGNAL IS "xilinx.com:interface:acc_fifo_read:1.0 din_V_V EMPTY_N";
  ATTRIBUTE X_INTERFACE_PARAMETER OF din_V_V_dout: SIGNAL IS "XIL_INTERFACENAME din_V_V, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {RD_DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 33} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} EMPTY_N {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} ma" & 
"ximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} RD_EN {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} form" & 
"at long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF din_V_V_dout: SIGNAL IS "xilinx.com:interface:acc_fifo_read:1.0 din_V_V RD_DATA";
  ATTRIBUTE X_INTERFACE_INFO OF ap_ready: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl ready";
  ATTRIBUTE X_INTERFACE_INFO OF ap_idle: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl idle";
  ATTRIBUTE X_INTERFACE_INFO OF ap_done: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl done";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ap_start: SIGNAL IS "XIL_INTERFACENAME ap_ctrl, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {start {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} done {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum " & 
"{}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} idle {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long" & 
" minimum {} maximum {}} value 0}}} ready {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}";
  ATTRIBUTE X_INTERFACE_INFO OF ap_start: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl start";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ap_rst: SIGNAL IS "XIL_INTERFACENAME ap_rst, POLARITY ACTIVE_HIGH, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {RST {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ap_rst: SIGNAL IS "xilinx.com:signal:reset:1.0 ap_rst RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF ap_clk: SIGNAL IS "XIL_INTERFACENAME ap_clk, ASSOCIATED_RESET ap_rst, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {CLK {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF ap_clk: SIGNAL IS "xilinx.com:signal:clock:1.0 ap_clk CLK";
BEGIN
  U0 : RFFI_FFT_ConvNet
    PORT MAP (
      tok_V_ce0 => tok_V_ce0,
      tok_V_we0 => tok_V_we0,
      logits_V_ce0 => logits_V_ce0,
      logits_V_we0 => logits_V_we0,
      ap_clk => ap_clk,
      ap_rst => ap_rst,
      ap_start => ap_start,
      ap_done => ap_done,
      ap_idle => ap_idle,
      ap_ready => ap_ready,
      din_V_V_dout => din_V_V_dout,
      din_V_V_empty_n => din_V_V_empty_n,
      din_V_V_read => din_V_V_read,
      tok_V_address0 => tok_V_address0,
      tok_V_d0 => tok_V_d0,
      tok_V_address1 => tok_V_address1,
      tok_V_ce1 => tok_V_ce1,
      tok_V_we1 => tok_V_we1,
      tok_V_d1 => tok_V_d1,
      logits_V_address0 => logits_V_address0,
      logits_V_d0 => logits_V_d0
    );
END RFFI_FFT_ConvNet_1_arch;
