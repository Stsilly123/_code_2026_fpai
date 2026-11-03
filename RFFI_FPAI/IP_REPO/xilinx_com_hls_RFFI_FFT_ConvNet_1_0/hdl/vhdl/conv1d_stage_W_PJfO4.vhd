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

entity conv1d_stage_W_PJfO4_rom is 
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


architecture rtl of conv1d_stage_W_PJfO4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001001", 1 => "101101", 2 => "111010", 3 => "000111", 4 => "010100", 
    5 => "111000", 6 => "000101", 7 => "010010", 8 => "110110", 9 => "000011", 
    10 => "010000", 11 => "110100", 12 => "000001", 13 => "001110", 14 => "110010", 
    15 => "111111", 16 => "001100", 17 => "110000", 18 => "111101", 19 => "001010", 
    20 => "101110", 21 => "111011", 22 => "001000", 23 => "101100", 24 => "111001", 
    25 => "000110", 26 => "010011", 27 => "110111", 28 => "000100", 29 => "010001", 
    30 => "110101", 31 => "000010", 32 => "001111", 33 => "110011", 34 => "000000", 
    35 => "001101", 36 => "110001", 37 => "111110", 38 => "001011", 39 => "101111", 
    40 => "111100", 41 => "001001", 42 => "101101", 43 => "111010", 44 => "000111", 
    45 => "010100", 46 => "111000", 47 => "000101", 48 => "010010", 49 => "110110", 
    50 => "000011", 51 => "010000", 52 => "110100", 53 => "000001", 54 => "001110", 
    55 => "110010", 56 => "111111", 57 => "001100", 58 => "110000", 59 => "111101", 
    60 => "001010", 61 => "101110", 62 => "111011", 63 => "001000", 64 => "101100", 
    65 => "111001", 66 => "000110", 67 => "010011", 68 => "110111", 69 => "000100", 
    70 => "010001", 71 => "110101", 72 => "000010", 73 => "001111", 74 => "110011", 
    75 => "000000", 76 => "001101", 77 => "110001", 78 => "111110", 79 => "001011", 
    80 => "101111", 81 => "111100", 82 => "001001", 83 => "101101", 84 => "111010", 
    85 => "000111", 86 => "010100", 87 => "111000", 88 => "000101", 89 => "010010", 
    90 => "110110", 91 => "000011", 92 => "010000", 93 => "110100", 94 => "000001", 
    95 => "001110" );

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

entity conv1d_stage_W_PJfO4 is
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

architecture arch of conv1d_stage_W_PJfO4 is
    component conv1d_stage_W_PJfO4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfO4_rom_U :  component conv1d_stage_W_PJfO4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


