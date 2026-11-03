-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sun Oct 25 09:01:47 2026
-- Host        : DESKTOP-0HEH89S running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/FPGA/FPGA/FPAI_PL/RFFI_FPAI/RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_Signal_process_0_0/ps_ai_Signal_process_0_0_stub.vhdl
-- Design      : ps_ai_Signal_process_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z030ffg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ps_ai_Signal_process_0_0 is
  Port ( 
    sclk : in STD_LOGIC;
    s_rst_n : in STD_LOGIC;
    s_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_tkeep : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_tvalid : in STD_LOGIC;
    s_tlast : in STD_LOGIC;
    s_tready : out STD_LOGIC;
    dout_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    dout_TVALID : out STD_LOGIC;
    dout_TREADY : in STD_LOGIC;
    dout_TKEEP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    dout_TLAST : out STD_LOGIC;
    eq_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    eq_TVALID : out STD_LOGIC;
    eq_TREADY : in STD_LOGIC;
    eq_TKEEP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    eq_TLAST : out STD_LOGIC;
    eq_tuser : out STD_LOGIC;
    eq_stat_drop : out STD_LOGIC_VECTOR ( 31 downto 0 );
    eq_stat_theta : out STD_LOGIC_VECTOR ( 22 downto 0 );
    eq_stat_gate : out STD_LOGIC;
    eq_busy : out STD_LOGIC;
    expert_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    expert_TVALID : out STD_LOGIC;
    expert_TREADY : in STD_LOGIC;
    expert_TKEEP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    expert_TLAST : out STD_LOGIC;
    expert_stat_drop : out STD_LOGIC_VECTOR ( 31 downto 0 );
    expert_stat_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    expert_busy : out STD_LOGIC
  );

end ps_ai_Signal_process_0_0;

architecture stub of ps_ai_Signal_process_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sclk,s_rst_n,s_tdata[63:0],s_tkeep[7:0],s_tvalid,s_tlast,s_tready,dout_TDATA[31:0],dout_TVALID,dout_TREADY,dout_TKEEP[3:0],dout_TLAST,eq_TDATA[31:0],eq_TVALID,eq_TREADY,eq_TKEEP[3:0],eq_TLAST,eq_tuser,eq_stat_drop[31:0],eq_stat_theta[22:0],eq_stat_gate,eq_busy,expert_TDATA[31:0],expert_TVALID,expert_TREADY,expert_TKEEP[3:0],expert_TLAST,expert_stat_drop[31:0],expert_stat_frames[31:0],expert_busy";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "Signal_process,Vivado 2018.3";
begin
end;
