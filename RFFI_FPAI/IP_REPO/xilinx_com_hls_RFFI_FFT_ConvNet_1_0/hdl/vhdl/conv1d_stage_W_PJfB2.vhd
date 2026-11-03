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

entity conv1d_stage_W_PJfB2_rom is 
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


architecture rtl of conv1d_stage_W_PJfB2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "010100", 1 => "111000", 2 => "000101", 3 => "010010", 4 => "110110", 
    5 => "000011", 6 => "010000", 7 => "110100", 8 => "000001", 9 => "001110", 
    10 => "110010", 11 => "111111", 12 => "001100", 13 => "110000", 14 => "111101", 
    15 => "001010", 16 => "101110", 17 => "111011", 18 => "001000", 19 => "101100", 
    20 => "111001", 21 => "000110", 22 => "010011", 23 => "110111", 24 => "000100", 
    25 => "010001", 26 => "110101", 27 => "000010", 28 => "001111", 29 => "110011", 
    30 => "000000", 31 => "001101", 32 => "110001", 33 => "111110", 34 => "001011", 
    35 => "101111", 36 => "111100", 37 => "001001", 38 => "101101", 39 => "111010", 
    40 => "000111", 41 => "010100", 42 => "111000", 43 => "000101", 44 => "010010", 
    45 => "110110", 46 => "000011", 47 => "010000", 48 => "110100", 49 => "000001", 
    50 => "001110", 51 => "110010", 52 => "111111", 53 => "001100", 54 => "110000", 
    55 => "111101", 56 => "001010", 57 => "101110", 58 => "111011", 59 => "001000", 
    60 => "101100", 61 => "111001", 62 => "000110", 63 => "010011", 64 => "110111", 
    65 => "000100", 66 => "010001", 67 => "110101", 68 => "000010", 69 => "001111", 
    70 => "110011", 71 => "000000", 72 => "001101", 73 => "110001", 74 => "111110", 
    75 => "001011", 76 => "101111", 77 => "111100", 78 => "001001", 79 => "101101", 
    80 => "111010", 81 => "000111", 82 => "010100", 83 => "111000", 84 => "000101", 
    85 => "010010", 86 => "110110", 87 => "000011", 88 => "010000", 89 => "110100", 
    90 => "000001", 91 => "001110", 92 => "110010", 93 => "111111", 94 => "001100", 
    95 => "110000" );

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

entity conv1d_stage_W_PJfB2 is
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

architecture arch of conv1d_stage_W_PJfB2 is
    component conv1d_stage_W_PJfB2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfB2_rom_U :  component conv1d_stage_W_PJfB2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


