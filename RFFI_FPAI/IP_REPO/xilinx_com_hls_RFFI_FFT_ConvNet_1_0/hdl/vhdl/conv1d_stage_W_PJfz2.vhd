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

entity conv1d_stage_W_PJfz2_rom is 
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


architecture rtl of conv1d_stage_W_PJfz2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110011", 1 => "000000", 2 => "001101", 3 => "110001", 4 => "111110", 
    5 => "001011", 6 => "101111", 7 => "111100", 8 => "001001", 9 => "101101", 
    10 => "111010", 11 => "000111", 12 => "010100", 13 => "111000", 14 => "000101", 
    15 => "010010", 16 => "110110", 17 => "000011", 18 => "010000", 19 => "110100", 
    20 => "000001", 21 => "001110", 22 => "110010", 23 => "111111", 24 => "001100", 
    25 => "110000", 26 => "111101", 27 => "001010", 28 => "101110", 29 => "111011", 
    30 => "001000", 31 => "101100", 32 => "111001", 33 => "000110", 34 => "010011", 
    35 => "110111", 36 => "000100", 37 => "010001", 38 => "110101", 39 => "000010", 
    40 => "001111", 41 => "110011", 42 => "000000", 43 => "001101", 44 => "110001", 
    45 => "111110", 46 => "001011", 47 => "101111", 48 => "111100", 49 => "001001", 
    50 => "101101", 51 => "111010", 52 => "000111", 53 => "010100", 54 => "111000", 
    55 => "000101", 56 => "010010", 57 => "110110", 58 => "000011", 59 => "010000", 
    60 => "110100", 61 => "000001", 62 => "001110", 63 => "110010", 64 => "111111", 
    65 => "001100", 66 => "110000", 67 => "111101", 68 => "001010", 69 => "101110", 
    70 => "111011", 71 => "001000", 72 => "101100", 73 => "111001", 74 => "000110", 
    75 => "010011", 76 => "110111", 77 => "000100", 78 => "010001", 79 => "110101", 
    80 => "000010", 81 => "001111", 82 => "110011", 83 => "000000", 84 => "001101", 
    85 => "110001", 86 => "111110", 87 => "001011", 88 => "101111", 89 => "111100", 
    90 => "001001", 91 => "101101", 92 => "111010", 93 => "000111", 94 => "010100", 
    95 => "111000" );

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

entity conv1d_stage_W_PJfz2 is
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

architecture arch of conv1d_stage_W_PJfz2 is
    component conv1d_stage_W_PJfz2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfz2_rom_U :  component conv1d_stage_W_PJfz2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


