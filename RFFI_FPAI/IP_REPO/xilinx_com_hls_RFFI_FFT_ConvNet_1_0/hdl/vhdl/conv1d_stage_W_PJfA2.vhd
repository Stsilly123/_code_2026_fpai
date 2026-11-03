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

entity conv1d_stage_W_PJfA2_rom is 
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


architecture rtl of conv1d_stage_W_PJfA2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "101111", 1 => "111100", 2 => "001001", 3 => "101101", 4 => "111010", 
    5 => "000111", 6 => "010100", 7 => "111000", 8 => "000101", 9 => "010010", 
    10 => "110110", 11 => "000011", 12 => "010000", 13 => "110100", 14 => "000001", 
    15 => "001110", 16 => "110010", 17 => "111111", 18 => "001100", 19 => "110000", 
    20 => "111101", 21 => "001010", 22 => "101110", 23 => "111011", 24 => "001000", 
    25 => "101100", 26 => "111001", 27 => "000110", 28 => "010011", 29 => "110111", 
    30 => "000100", 31 => "010001", 32 => "110101", 33 => "000010", 34 => "001111", 
    35 => "110011", 36 => "000000", 37 => "001101", 38 => "110001", 39 => "111110", 
    40 => "001011", 41 => "101111", 42 => "111100", 43 => "001001", 44 => "101101", 
    45 => "111010", 46 => "000111", 47 => "010100", 48 => "111000", 49 => "000101", 
    50 => "010010", 51 => "110110", 52 => "000011", 53 => "010000", 54 => "110100", 
    55 => "000001", 56 => "001110", 57 => "110010", 58 => "111111", 59 => "001100", 
    60 => "110000", 61 => "111101", 62 => "001010", 63 => "101110", 64 => "111011", 
    65 => "001000", 66 => "101100", 67 => "111001", 68 => "000110", 69 => "010011", 
    70 => "110111", 71 => "000100", 72 => "010001", 73 => "110101", 74 => "000010", 
    75 => "001111", 76 => "110011", 77 => "000000", 78 => "001101", 79 => "110001", 
    80 => "111110", 81 => "001011", 82 => "101111", 83 => "111100", 84 => "001001", 
    85 => "101101", 86 => "111010", 87 => "000111", 88 => "010100", 89 => "111000", 
    90 => "000101", 91 => "010010", 92 => "110110", 93 => "000011", 94 => "010000", 
    95 => "110100" );

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

entity conv1d_stage_W_PJfA2 is
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

architecture arch of conv1d_stage_W_PJfA2 is
    component conv1d_stage_W_PJfA2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfA2_rom_U :  component conv1d_stage_W_PJfA2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


