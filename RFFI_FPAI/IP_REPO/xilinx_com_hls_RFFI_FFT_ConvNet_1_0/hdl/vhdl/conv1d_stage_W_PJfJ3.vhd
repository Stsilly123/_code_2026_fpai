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

entity conv1d_stage_W_PJfJ3_rom is 
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


architecture rtl of conv1d_stage_W_PJfJ3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110100", 1 => "000001", 2 => "001110", 3 => "110010", 4 => "111111", 
    5 => "001100", 6 => "110000", 7 => "111101", 8 => "001010", 9 => "101110", 
    10 => "111011", 11 => "001000", 12 => "101100", 13 => "111001", 14 => "000110", 
    15 => "010011", 16 => "110111", 17 => "000100", 18 => "010001", 19 => "110101", 
    20 => "000010", 21 => "001111", 22 => "110011", 23 => "000000", 24 => "001101", 
    25 => "110001", 26 => "111110", 27 => "001011", 28 => "101111", 29 => "111100", 
    30 => "001001", 31 => "101101", 32 => "111010", 33 => "000111", 34 => "010100", 
    35 => "111000", 36 => "000101", 37 => "010010", 38 => "110110", 39 => "000011", 
    40 => "010000", 41 => "110100", 42 => "000001", 43 => "001110", 44 => "110010", 
    45 => "111111", 46 => "001100", 47 => "110000", 48 => "111101", 49 => "001010", 
    50 => "101110", 51 => "111011", 52 => "001000", 53 => "101100", 54 => "111001", 
    55 => "000110", 56 => "010011", 57 => "110111", 58 => "000100", 59 => "010001", 
    60 => "110101", 61 => "000010", 62 => "001111", 63 => "110011", 64 => "000000", 
    65 => "001101", 66 => "110001", 67 => "111110", 68 => "001011", 69 => "101111", 
    70 => "111100", 71 => "001001", 72 => "101101", 73 => "111010", 74 => "000111", 
    75 => "010100", 76 => "111000", 77 => "000101", 78 => "010010", 79 => "110110", 
    80 => "000011", 81 => "010000", 82 => "110100", 83 => "000001", 84 => "001110", 
    85 => "110010", 86 => "111111", 87 => "001100", 88 => "110000", 89 => "111101", 
    90 => "001010", 91 => "101110", 92 => "111011", 93 => "001000", 94 => "101100", 
    95 => "111001" );

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

entity conv1d_stage_W_PJfJ3 is
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

architecture arch of conv1d_stage_W_PJfJ3 is
    component conv1d_stage_W_PJfJ3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfJ3_rom_U :  component conv1d_stage_W_PJfJ3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


