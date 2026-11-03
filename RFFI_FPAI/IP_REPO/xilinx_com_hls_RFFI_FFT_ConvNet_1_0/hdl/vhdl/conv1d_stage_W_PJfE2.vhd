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

entity conv1d_stage_W_PJfE2_rom is 
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


architecture rtl of conv1d_stage_W_PJfE2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001000", 1 => "101100", 2 => "111001", 3 => "000110", 4 => "010011", 
    5 => "110111", 6 => "000100", 7 => "010001", 8 => "110101", 9 => "000010", 
    10 => "001111", 11 => "110011", 12 => "000000", 13 => "001101", 14 => "110001", 
    15 => "111110", 16 => "001011", 17 => "101111", 18 => "111100", 19 => "001001", 
    20 => "101101", 21 => "111010", 22 => "000111", 23 => "010100", 24 => "111000", 
    25 => "000101", 26 => "010010", 27 => "110110", 28 => "000011", 29 => "010000", 
    30 => "110100", 31 => "000001", 32 => "001110", 33 => "110010", 34 => "111111", 
    35 => "001100", 36 => "110000", 37 => "111101", 38 => "001010", 39 => "101110", 
    40 => "111011", 41 => "001000", 42 => "101100", 43 => "111001", 44 => "000110", 
    45 => "010011", 46 => "110111", 47 => "000100", 48 => "010001", 49 => "110101", 
    50 => "000010", 51 => "001111", 52 => "110011", 53 => "000000", 54 => "001101", 
    55 => "110001", 56 => "111110", 57 => "001011", 58 => "101111", 59 => "111100", 
    60 => "001001", 61 => "101101", 62 => "111010", 63 => "000111", 64 => "010100", 
    65 => "111000", 66 => "000101", 67 => "010010", 68 => "110110", 69 => "000011", 
    70 => "010000", 71 => "110100", 72 => "000001", 73 => "001110", 74 => "110010", 
    75 => "111111", 76 => "001100", 77 => "110000", 78 => "111101", 79 => "001010", 
    80 => "101110", 81 => "111011", 82 => "001000", 83 => "101100", 84 => "111001", 
    85 => "000110", 86 => "010011", 87 => "110111", 88 => "000100", 89 => "010001", 
    90 => "110101", 91 => "000010", 92 => "001111", 93 => "110011", 94 => "000000", 
    95 => "001101" );

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

entity conv1d_stage_W_PJfE2 is
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

architecture arch of conv1d_stage_W_PJfE2 is
    component conv1d_stage_W_PJfE2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfE2_rom_U :  component conv1d_stage_W_PJfE2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


