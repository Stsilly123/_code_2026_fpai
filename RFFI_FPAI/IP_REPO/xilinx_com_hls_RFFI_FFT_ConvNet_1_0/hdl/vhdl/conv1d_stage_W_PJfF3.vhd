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

entity conv1d_stage_W_PJfF3_rom is 
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


architecture rtl of conv1d_stage_W_PJfF3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000100", 1 => "010001", 2 => "110101", 3 => "000010", 4 => "001111", 
    5 => "110011", 6 => "000000", 7 => "001101", 8 => "110001", 9 => "111110", 
    10 => "001011", 11 => "101111", 12 => "111100", 13 => "001001", 14 => "101101", 
    15 => "111010", 16 => "000111", 17 => "010100", 18 => "111000", 19 => "000101", 
    20 => "010010", 21 => "110110", 22 => "000011", 23 => "010000", 24 => "110100", 
    25 => "000001", 26 => "001110", 27 => "110010", 28 => "111111", 29 => "001100", 
    30 => "110000", 31 => "111101", 32 => "001010", 33 => "101110", 34 => "111011", 
    35 => "001000", 36 => "101100", 37 => "111001", 38 => "000110", 39 => "010011", 
    40 => "110111", 41 => "000100", 42 => "010001", 43 => "110101", 44 => "000010", 
    45 => "001111", 46 => "110011", 47 => "000000", 48 => "001101", 49 => "110001", 
    50 => "111110", 51 => "001011", 52 => "101111", 53 => "111100", 54 => "001001", 
    55 => "101101", 56 => "111010", 57 => "000111", 58 => "010100", 59 => "111000", 
    60 => "000101", 61 => "010010", 62 => "110110", 63 => "000011", 64 => "010000", 
    65 => "110100", 66 => "000001", 67 => "001110", 68 => "110010", 69 => "111111", 
    70 => "001100", 71 => "110000", 72 => "111101", 73 => "001010", 74 => "101110", 
    75 => "111011", 76 => "001000", 77 => "101100", 78 => "111001", 79 => "000110", 
    80 => "010011", 81 => "110111", 82 => "000100", 83 => "010001", 84 => "110101", 
    85 => "000010", 86 => "001111", 87 => "110011", 88 => "000000", 89 => "001101", 
    90 => "110001", 91 => "111110", 92 => "001011", 93 => "101111", 94 => "111100", 
    95 => "001001" );

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

entity conv1d_stage_W_PJfF3 is
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

architecture arch of conv1d_stage_W_PJfF3 is
    component conv1d_stage_W_PJfF3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfF3_rom_U :  component conv1d_stage_W_PJfF3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


