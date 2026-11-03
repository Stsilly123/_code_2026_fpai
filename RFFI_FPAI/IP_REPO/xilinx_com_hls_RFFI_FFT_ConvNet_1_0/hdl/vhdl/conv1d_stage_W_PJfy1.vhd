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

entity conv1d_stage_W_PJfy1_rom is 
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


architecture rtl of conv1d_stage_W_PJfy1_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110111", 1 => "000100", 2 => "010001", 3 => "110101", 4 => "000010", 
    5 => "001111", 6 => "110011", 7 => "000000", 8 => "001101", 9 => "110001", 
    10 => "111110", 11 => "001011", 12 => "101111", 13 => "111100", 14 => "001001", 
    15 => "101101", 16 => "111010", 17 => "000111", 18 => "010100", 19 => "111000", 
    20 => "000101", 21 => "010010", 22 => "110110", 23 => "000011", 24 => "010000", 
    25 => "110100", 26 => "000001", 27 => "001110", 28 => "110010", 29 => "111111", 
    30 => "001100", 31 => "110000", 32 => "111101", 33 => "001010", 34 => "101110", 
    35 => "111011", 36 => "001000", 37 => "101100", 38 => "111001", 39 => "000110", 
    40 => "010011", 41 => "110111", 42 => "000100", 43 => "010001", 44 => "110101", 
    45 => "000010", 46 => "001111", 47 => "110011", 48 => "000000", 49 => "001101", 
    50 => "110001", 51 => "111110", 52 => "001011", 53 => "101111", 54 => "111100", 
    55 => "001001", 56 => "101101", 57 => "111010", 58 => "000111", 59 => "010100", 
    60 => "111000", 61 => "000101", 62 => "010010", 63 => "110110", 64 => "000011", 
    65 => "010000", 66 => "110100", 67 => "000001", 68 => "001110", 69 => "110010", 
    70 => "111111", 71 => "001100", 72 => "110000", 73 => "111101", 74 => "001010", 
    75 => "101110", 76 => "111011", 77 => "001000", 78 => "101100", 79 => "111001", 
    80 => "000110", 81 => "010011", 82 => "110111", 83 => "000100", 84 => "010001", 
    85 => "110101", 86 => "000010", 87 => "001111", 88 => "110011", 89 => "000000", 
    90 => "001101", 91 => "110001", 92 => "111110", 93 => "001011", 94 => "101111", 
    95 => "111100" );

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

entity conv1d_stage_W_PJfy1 is
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

architecture arch of conv1d_stage_W_PJfy1 is
    component conv1d_stage_W_PJfy1_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfy1_rom_U :  component conv1d_stage_W_PJfy1_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


