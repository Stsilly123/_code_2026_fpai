-- ==============================================================
-- File generated on Thu Oct 15 12:17:27 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJfG3_rom is 
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


architecture rtl of conv1d_stage_W_PJfG3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000000", 1 => "001101", 2 => "110001", 3 => "111110", 4 => "001011", 
    5 => "101111", 6 => "111100", 7 => "001001", 8 => "101101", 9 => "111010", 
    10 => "000111", 11 => "010100", 12 => "111000", 13 => "000101", 14 => "010010", 
    15 => "110110", 16 => "000011", 17 => "010000", 18 => "110100", 19 => "000001", 
    20 => "001110", 21 => "110010", 22 => "111111", 23 => "001100", 24 => "110000", 
    25 => "111101", 26 => "001010", 27 => "101110", 28 => "111011", 29 => "001000", 
    30 => "101100", 31 => "111001", 32 => "000110", 33 => "010011", 34 => "110111", 
    35 => "000100", 36 => "010001", 37 => "110101", 38 => "000010", 39 => "001111", 
    40 => "110011", 41 => "000000", 42 => "001101", 43 => "110001", 44 => "111110", 
    45 => "001011", 46 => "101111", 47 => "111100", 48 => "001001", 49 => "101101", 
    50 => "111010", 51 => "000111", 52 => "010100", 53 => "111000", 54 => "000101", 
    55 => "010010", 56 => "110110", 57 => "000011", 58 => "010000", 59 => "110100", 
    60 => "000001", 61 => "001110", 62 => "110010", 63 => "111111", 64 => "001100", 
    65 => "110000", 66 => "111101", 67 => "001010", 68 => "101110", 69 => "111011", 
    70 => "001000", 71 => "101100", 72 => "111001", 73 => "000110", 74 => "010011", 
    75 => "110111", 76 => "000100", 77 => "010001", 78 => "110101", 79 => "000010", 
    80 => "001111", 81 => "110011", 82 => "000000", 83 => "001101", 84 => "110001", 
    85 => "111110", 86 => "001011", 87 => "101111", 88 => "111100", 89 => "001001", 
    90 => "101101", 91 => "111010", 92 => "000111", 93 => "010100", 94 => "111000", 
    95 => "000101" );

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

entity conv1d_stage_W_PJfG3 is
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

architecture arch of conv1d_stage_W_PJfG3 is
    component conv1d_stage_W_PJfG3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfG3_rom_U :  component conv1d_stage_W_PJfG3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


