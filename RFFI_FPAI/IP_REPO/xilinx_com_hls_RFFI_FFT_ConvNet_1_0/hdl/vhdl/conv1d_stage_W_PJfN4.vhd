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

entity conv1d_stage_W_PJfN4_rom is 
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


architecture rtl of conv1d_stage_W_PJfN4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001101", 1 => "110001", 2 => "111110", 3 => "001011", 4 => "101111", 
    5 => "111100", 6 => "001001", 7 => "101101", 8 => "111010", 9 => "000111", 
    10 => "010100", 11 => "111000", 12 => "000101", 13 => "010010", 14 => "110110", 
    15 => "000011", 16 => "010000", 17 => "110100", 18 => "000001", 19 => "001110", 
    20 => "110010", 21 => "111111", 22 => "001100", 23 => "110000", 24 => "111101", 
    25 => "001010", 26 => "101110", 27 => "111011", 28 => "001000", 29 => "101100", 
    30 => "111001", 31 => "000110", 32 => "010011", 33 => "110111", 34 => "000100", 
    35 => "010001", 36 => "110101", 37 => "000010", 38 => "001111", 39 => "110011", 
    40 => "000000", 41 => "001101", 42 => "110001", 43 => "111110", 44 => "001011", 
    45 => "101111", 46 => "111100", 47 => "001001", 48 => "101101", 49 => "111010", 
    50 => "000111", 51 => "010100", 52 => "111000", 53 => "000101", 54 => "010010", 
    55 => "110110", 56 => "000011", 57 => "010000", 58 => "110100", 59 => "000001", 
    60 => "001110", 61 => "110010", 62 => "111111", 63 => "001100", 64 => "110000", 
    65 => "111101", 66 => "001010", 67 => "101110", 68 => "111011", 69 => "001000", 
    70 => "101100", 71 => "111001", 72 => "000110", 73 => "010011", 74 => "110111", 
    75 => "000100", 76 => "010001", 77 => "110101", 78 => "000010", 79 => "001111", 
    80 => "110011", 81 => "000000", 82 => "001101", 83 => "110001", 84 => "111110", 
    85 => "001011", 86 => "101111", 87 => "111100", 88 => "001001", 89 => "101101", 
    90 => "111010", 91 => "000111", 92 => "010100", 93 => "111000", 94 => "000101", 
    95 => "010010" );

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

entity conv1d_stage_W_PJfN4 is
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

architecture arch of conv1d_stage_W_PJfN4 is
    component conv1d_stage_W_PJfN4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfN4_rom_U :  component conv1d_stage_W_PJfN4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


