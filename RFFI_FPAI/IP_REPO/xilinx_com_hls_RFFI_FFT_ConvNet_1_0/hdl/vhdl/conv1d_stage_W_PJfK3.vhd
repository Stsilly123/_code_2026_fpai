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

entity conv1d_stage_W_PJfK3_rom is 
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


architecture rtl of conv1d_stage_W_PJfK3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110000", 1 => "111101", 2 => "001010", 3 => "101110", 4 => "111011", 
    5 => "001000", 6 => "101100", 7 => "111001", 8 => "000110", 9 => "010011", 
    10 => "110111", 11 => "000100", 12 => "010001", 13 => "110101", 14 => "000010", 
    15 => "001111", 16 => "110011", 17 => "000000", 18 => "001101", 19 => "110001", 
    20 => "111110", 21 => "001011", 22 => "101111", 23 => "111100", 24 => "001001", 
    25 => "101101", 26 => "111010", 27 => "000111", 28 => "010100", 29 => "111000", 
    30 => "000101", 31 => "010010", 32 => "110110", 33 => "000011", 34 => "010000", 
    35 => "110100", 36 => "000001", 37 => "001110", 38 => "110010", 39 => "111111", 
    40 => "001100", 41 => "110000", 42 => "111101", 43 => "001010", 44 => "101110", 
    45 => "111011", 46 => "001000", 47 => "101100", 48 => "111001", 49 => "000110", 
    50 => "010011", 51 => "110111", 52 => "000100", 53 => "010001", 54 => "110101", 
    55 => "000010", 56 => "001111", 57 => "110011", 58 => "000000", 59 => "001101", 
    60 => "110001", 61 => "111110", 62 => "001011", 63 => "101111", 64 => "111100", 
    65 => "001001", 66 => "101101", 67 => "111010", 68 => "000111", 69 => "010100", 
    70 => "111000", 71 => "000101", 72 => "010010", 73 => "110110", 74 => "000011", 
    75 => "010000", 76 => "110100", 77 => "000001", 78 => "001110", 79 => "110010", 
    80 => "111111", 81 => "001100", 82 => "110000", 83 => "111101", 84 => "001010", 
    85 => "101110", 86 => "111011", 87 => "001000", 88 => "101100", 89 => "111001", 
    90 => "000110", 91 => "010011", 92 => "110111", 93 => "000100", 94 => "010001", 
    95 => "110101" );

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

entity conv1d_stage_W_PJfK3 is
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

architecture arch of conv1d_stage_W_PJfK3 is
    component conv1d_stage_W_PJfK3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfK3_rom_U :  component conv1d_stage_W_PJfK3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


