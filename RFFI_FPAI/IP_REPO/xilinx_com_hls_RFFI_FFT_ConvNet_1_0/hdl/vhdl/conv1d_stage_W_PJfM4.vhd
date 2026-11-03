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

entity conv1d_stage_W_PJfM4_rom is 
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


architecture rtl of conv1d_stage_W_PJfM4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "010001", 1 => "110101", 2 => "000010", 3 => "001111", 4 => "110011", 
    5 => "000000", 6 => "001101", 7 => "110001", 8 => "111110", 9 => "001011", 
    10 => "101111", 11 => "111100", 12 => "001001", 13 => "101101", 14 => "111010", 
    15 => "000111", 16 => "010100", 17 => "111000", 18 => "000101", 19 => "010010", 
    20 => "110110", 21 => "000011", 22 => "010000", 23 => "110100", 24 => "000001", 
    25 => "001110", 26 => "110010", 27 => "111111", 28 => "001100", 29 => "110000", 
    30 => "111101", 31 => "001010", 32 => "101110", 33 => "111011", 34 => "001000", 
    35 => "101100", 36 => "111001", 37 => "000110", 38 => "010011", 39 => "110111", 
    40 => "000100", 41 => "010001", 42 => "110101", 43 => "000010", 44 => "001111", 
    45 => "110011", 46 => "000000", 47 => "001101", 48 => "110001", 49 => "111110", 
    50 => "001011", 51 => "101111", 52 => "111100", 53 => "001001", 54 => "101101", 
    55 => "111010", 56 => "000111", 57 => "010100", 58 => "111000", 59 => "000101", 
    60 => "010010", 61 => "110110", 62 => "000011", 63 => "010000", 64 => "110100", 
    65 => "000001", 66 => "001110", 67 => "110010", 68 => "111111", 69 => "001100", 
    70 => "110000", 71 => "111101", 72 => "001010", 73 => "101110", 74 => "111011", 
    75 => "001000", 76 => "101100", 77 => "111001", 78 => "000110", 79 => "010011", 
    80 => "110111", 81 => "000100", 82 => "010001", 83 => "110101", 84 => "000010", 
    85 => "001111", 86 => "110011", 87 => "000000", 88 => "001101", 89 => "110001", 
    90 => "111110", 91 => "001011", 92 => "101111", 93 => "111100", 94 => "001001", 
    95 => "101101" );

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

entity conv1d_stage_W_PJfM4 is
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

architecture arch of conv1d_stage_W_PJfM4 is
    component conv1d_stage_W_PJfM4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfM4_rom_U :  component conv1d_stage_W_PJfM4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


