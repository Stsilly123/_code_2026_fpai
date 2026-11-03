-- ==============================================================
-- File generated on Thu Oct 15 12:17:28 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJfL3_rom is 
    generic(
             DWIDTH     : integer := 6; 
             AWIDTH     : integer := 7; 
             MEM_SIZE    : integer := 96
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_W_PJfL3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "101100", 1 => "111001", 2 => "000110", 3 => "010011", 4 => "110111", 
    5 => "000100", 6 => "010001", 7 => "110101", 8 => "000010", 9 => "001111", 
    10 => "110011", 11 => "000000", 12 => "001101", 13 => "110001", 14 => "111110", 
    15 => "001011", 16 => "101111", 17 => "111100", 18 => "001001", 19 => "101101", 
    20 => "111010", 21 => "000111", 22 => "010100", 23 => "111000", 24 => "000101", 
    25 => "010010", 26 => "110110", 27 => "000011", 28 => "010000", 29 => "110100", 
    30 => "000001", 31 => "001110", 32 => "110010", 33 => "111111", 34 => "001100", 
    35 => "110000", 36 => "111101", 37 => "001010", 38 => "101110", 39 => "111011", 
    40 => "001000", 41 => "101100", 42 => "111001", 43 => "000110", 44 => "010011", 
    45 => "110111", 46 => "000100", 47 => "010001", 48 => "110101", 49 => "000010", 
    50 => "001111", 51 => "110011", 52 => "000000", 53 => "001101", 54 => "110001", 
    55 => "111110", 56 => "001011", 57 => "101111", 58 => "111100", 59 => "001001", 
    60 => "101101", 61 => "111010", 62 => "000111", 63 => "010100", 64 => "111000", 
    65 => "000101", 66 => "010010", 67 => "110110", 68 => "000011", 69 => "010000", 
    70 => "110100", 71 => "000001", 72 => "001110", 73 => "110010", 74 => "111111", 
    75 => "001100", 76 => "110000", 77 => "111101", 78 => "001010", 79 => "101110", 
    80 => "111011", 81 => "001000", 82 => "101100", 83 => "111001", 84 => "000110", 
    85 => "010011", 86 => "110111", 87 => "000100", 88 => "010001", 89 => "110101", 
    90 => "000010", 91 => "001111", 92 => "110011", 93 => "000000", 94 => "001101", 
    95 => "110001" );

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

entity conv1d_stage_W_PJfL3 is
    generic (
        DataWidth : INTEGER := 6;
        AddressRange : INTEGER := 96;
        AddressWidth : INTEGER := 7);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_W_PJfL3 is
    component conv1d_stage_W_PJfL3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfL3_rom_U :  component conv1d_stage_W_PJfL3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


