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

entity conv1d_stage_W_PJfC2_rom is 
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


architecture rtl of conv1d_stage_W_PJfC2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "010000", 1 => "110100", 2 => "000001", 3 => "001110", 4 => "110010", 
    5 => "111111", 6 => "001100", 7 => "110000", 8 => "111101", 9 => "001010", 
    10 => "101110", 11 => "111011", 12 => "001000", 13 => "101100", 14 => "111001", 
    15 => "000110", 16 => "010011", 17 => "110111", 18 => "000100", 19 => "010001", 
    20 => "110101", 21 => "000010", 22 => "001111", 23 => "110011", 24 => "000000", 
    25 => "001101", 26 => "110001", 27 => "111110", 28 => "001011", 29 => "101111", 
    30 => "111100", 31 => "001001", 32 => "101101", 33 => "111010", 34 => "000111", 
    35 => "010100", 36 => "111000", 37 => "000101", 38 => "010010", 39 => "110110", 
    40 => "000011", 41 => "010000", 42 => "110100", 43 => "000001", 44 => "001110", 
    45 => "110010", 46 => "111111", 47 => "001100", 48 => "110000", 49 => "111101", 
    50 => "001010", 51 => "101110", 52 => "111011", 53 => "001000", 54 => "101100", 
    55 => "111001", 56 => "000110", 57 => "010011", 58 => "110111", 59 => "000100", 
    60 => "010001", 61 => "110101", 62 => "000010", 63 => "001111", 64 => "110011", 
    65 => "000000", 66 => "001101", 67 => "110001", 68 => "111110", 69 => "001011", 
    70 => "101111", 71 => "111100", 72 => "001001", 73 => "101101", 74 => "111010", 
    75 => "000111", 76 => "010100", 77 => "111000", 78 => "000101", 79 => "010010", 
    80 => "110110", 81 => "000011", 82 => "010000", 83 => "110100", 84 => "000001", 
    85 => "001110", 86 => "110010", 87 => "111111", 88 => "001100", 89 => "110000", 
    90 => "111101", 91 => "001010", 92 => "101110", 93 => "111011", 94 => "001000", 
    95 => "101100" );

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

entity conv1d_stage_W_PJfC2 is
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

architecture arch of conv1d_stage_W_PJfC2 is
    component conv1d_stage_W_PJfC2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfC2_rom_U :  component conv1d_stage_W_PJfC2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


