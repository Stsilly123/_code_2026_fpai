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

entity conv1d_stage_W_PJfD2_rom is 
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


architecture rtl of conv1d_stage_W_PJfD2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001100", 1 => "110000", 2 => "111101", 3 => "001010", 4 => "101110", 
    5 => "111011", 6 => "001000", 7 => "101100", 8 => "111001", 9 => "000110", 
    10 => "010011", 11 => "110111", 12 => "000100", 13 => "010001", 14 => "110101", 
    15 => "000010", 16 => "001111", 17 => "110011", 18 => "000000", 19 => "001101", 
    20 => "110001", 21 => "111110", 22 => "001011", 23 => "101111", 24 => "111100", 
    25 => "001001", 26 => "101101", 27 => "111010", 28 => "000111", 29 => "010100", 
    30 => "111000", 31 => "000101", 32 => "010010", 33 => "110110", 34 => "000011", 
    35 => "010000", 36 => "110100", 37 => "000001", 38 => "001110", 39 => "110010", 
    40 => "111111", 41 => "001100", 42 => "110000", 43 => "111101", 44 => "001010", 
    45 => "101110", 46 => "111011", 47 => "001000", 48 => "101100", 49 => "111001", 
    50 => "000110", 51 => "010011", 52 => "110111", 53 => "000100", 54 => "010001", 
    55 => "110101", 56 => "000010", 57 => "001111", 58 => "110011", 59 => "000000", 
    60 => "001101", 61 => "110001", 62 => "111110", 63 => "001011", 64 => "101111", 
    65 => "111100", 66 => "001001", 67 => "101101", 68 => "111010", 69 => "000111", 
    70 => "010100", 71 => "111000", 72 => "000101", 73 => "010010", 74 => "110110", 
    75 => "000011", 76 => "010000", 77 => "110100", 78 => "000001", 79 => "001110", 
    80 => "110010", 81 => "111111", 82 => "001100", 83 => "110000", 84 => "111101", 
    85 => "001010", 86 => "101110", 87 => "111011", 88 => "001000", 89 => "101100", 
    90 => "111001", 91 => "000110", 92 => "010011", 93 => "110111", 94 => "000100", 
    95 => "010001" );

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

entity conv1d_stage_W_PJfD2 is
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

architecture arch of conv1d_stage_W_PJfD2 is
    component conv1d_stage_W_PJfD2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfD2_rom_U :  component conv1d_stage_W_PJfD2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


