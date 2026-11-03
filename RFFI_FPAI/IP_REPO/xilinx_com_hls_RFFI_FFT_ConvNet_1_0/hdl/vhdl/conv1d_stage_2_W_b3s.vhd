-- ==============================================================
-- File generated on Thu Oct 15 12:17:25 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_2_W_b3s_rom is 
    generic(
             DWIDTH     : integer := 6; 
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


architecture rtl of conv1d_stage_2_W_b3s_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111100", 1 => "111011", 2 => "111010", 3 => "111001", 4 => "111000", 
    5 => "110111", 6 => "110110", 7 => "110101", 8 => "110100", 9 => "110011", 
    10 => "110010", 11 => "110001", 12 => "110000", 13 => "101111", 14 => "101110", 
    15 => "101101", 16 => "101100", 17 => "010100", 18 => "010011", 19 => "010010", 
    20 => "010001", 21 => "010000", 22 => "001111", 23 => "001110", 24 => "001101", 
    25 => "001100", 26 => "001011", 27 => "001010", 28 => "001001", 29 => "001000", 
    30 => "000111", 31 => "000110", 32 => "000101", 33 => "000100", 34 => "000011", 
    35 => "000010", 36 => "000001", 37 => "000000", 38 => "111111", 39 => "111110", 
    40 => "111101", 41 => "111100", 42 => "111011", 43 => "111010", 44 => "111001", 
    45 => "111000", 46 => "110111", 47 => "110110" );

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

entity conv1d_stage_2_W_b3s is
    generic (
        DataWidth : INTEGER := 6;
        AddressRange : INTEGER := 48;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_2_W_b3s is
    component conv1d_stage_2_W_b3s_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_b3s_rom_U :  component conv1d_stage_2_W_b3s_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


