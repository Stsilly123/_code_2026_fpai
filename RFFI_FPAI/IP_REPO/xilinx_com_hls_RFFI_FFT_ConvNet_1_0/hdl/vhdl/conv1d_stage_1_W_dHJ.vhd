-- ==============================================================
-- File generated on Sun Oct 18 16:53:07 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_1_W_dHJ_rom is 
    generic(
             DWIDTH     : integer := 7; 
             AWIDTH     : integer := 6; 
             MEM_SIZE    : integer := 48
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_1_W_dHJ_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "0000010", 1 => "1111100", 2 => "0101100", 3 => "1011100", 
    4 => "1110010", 5 => "1101011", 6 => "1111011", 7 => "0010100", 
    8 => "0010011", 9 => "0011000", 10 => "0000000", 11 => "1111001", 
    12 => "0001001", 13 => "0010111", 14 => "1110100", 15 => "1111100", 
    16 => "0010011", 17 => "0000010", 18 => "0010111", 19 => "0001100", 
    20 => "0000001", 21 => "0001100", 22 => "0001001", 23 to 24=> "0011101", 
    25 => "1101111", 26 => "0010000", 27 => "0100010", 28 => "1111001", 
    29 => "1101101", 30 => "0010001", 31 => "0000101", 32 => "1110110", 
    33 => "0001000", 34 => "1111000", 35 => "0000101", 36 => "0101101", 
    37 => "0001001", 38 => "0100010", 39 => "0001011", 40 => "1111011", 
    41 => "0010100", 42 => "0010110", 43 => "1110110", 44 => "1111000", 
    45 => "0011001", 46 => "0000010", 47 => "1110010" );

attribute syn_rom_style : string;
attribute syn_rom_style of mem : signal is "select_rom";
attribute ROM_STYLE : string;
attribute ROM_STYLE of mem : signal is "distributed";

begin 


memory_access_guard_0: process (addr0) 
begin
      addr0_tmp <= addr0;
--synthesis translate_off
      if (CONV_INTEGER(addr0) > mem_size-1) then
           addr0_tmp <= (others => '0');
      else 
           addr0_tmp <= addr0;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem(CONV_INTEGER(addr0_tmp)); 
        end if;
    end if;
end process;

end rtl;

Library IEEE;
use IEEE.std_logic_1164.all;

entity conv1d_stage_1_W_dHJ is
    generic (
        DataWidth : INTEGER := 7;
        AddressRange : INTEGER := 48;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_1_W_dHJ is
    component conv1d_stage_1_W_dHJ_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_dHJ_rom_U :  component conv1d_stage_1_W_dHJ_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


