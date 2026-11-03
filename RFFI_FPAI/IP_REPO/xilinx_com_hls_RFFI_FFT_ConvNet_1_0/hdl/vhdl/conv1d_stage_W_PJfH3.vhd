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

entity conv1d_stage_W_PJfH3_rom is 
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


architecture rtl of conv1d_stage_W_PJfH3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111100", 1 => "001001", 2 => "101101", 3 => "111010", 4 => "000111", 
    5 => "010100", 6 => "111000", 7 => "000101", 8 => "010010", 9 => "110110", 
    10 => "000011", 11 => "010000", 12 => "110100", 13 => "000001", 14 => "001110", 
    15 => "110010", 16 => "111111", 17 => "001100", 18 => "110000", 19 => "111101", 
    20 => "001010", 21 => "101110", 22 => "111011", 23 => "001000", 24 => "101100", 
    25 => "111001", 26 => "000110", 27 => "010011", 28 => "110111", 29 => "000100", 
    30 => "010001", 31 => "110101", 32 => "000010", 33 => "001111", 34 => "110011", 
    35 => "000000", 36 => "001101", 37 => "110001", 38 => "111110", 39 => "001011", 
    40 => "101111", 41 => "111100", 42 => "001001", 43 => "101101", 44 => "111010", 
    45 => "000111", 46 => "010100", 47 => "111000", 48 => "000101", 49 => "010010", 
    50 => "110110", 51 => "000011", 52 => "010000", 53 => "110100", 54 => "000001", 
    55 => "001110", 56 => "110010", 57 => "111111", 58 => "001100", 59 => "110000", 
    60 => "111101", 61 => "001010", 62 => "101110", 63 => "111011", 64 => "001000", 
    65 => "101100", 66 => "111001", 67 => "000110", 68 => "010011", 69 => "110111", 
    70 => "000100", 71 => "010001", 72 => "110101", 73 => "000010", 74 => "001111", 
    75 => "110011", 76 => "000000", 77 => "001101", 78 => "110001", 79 => "111110", 
    80 => "001011", 81 => "101111", 82 => "111100", 83 => "001001", 84 => "101101", 
    85 => "111010", 86 => "000111", 87 => "010100", 88 => "111000", 89 => "000101", 
    90 => "010010", 91 => "110110", 92 => "000011", 93 => "010000", 94 => "110100", 
    95 => "000001" );

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

entity conv1d_stage_W_PJfH3 is
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

architecture arch of conv1d_stage_W_PJfH3 is
    component conv1d_stage_W_PJfH3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfH3_rom_U :  component conv1d_stage_W_PJfH3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


