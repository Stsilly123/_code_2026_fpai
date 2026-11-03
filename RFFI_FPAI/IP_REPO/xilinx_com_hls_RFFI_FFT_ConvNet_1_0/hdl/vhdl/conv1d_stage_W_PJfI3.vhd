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

entity conv1d_stage_W_PJfI3_rom is 
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


architecture rtl of conv1d_stage_W_PJfI3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111000", 1 => "000101", 2 => "010010", 3 => "110110", 4 => "000011", 
    5 => "010000", 6 => "110100", 7 => "000001", 8 => "001110", 9 => "110010", 
    10 => "111111", 11 => "001100", 12 => "110000", 13 => "111101", 14 => "001010", 
    15 => "101110", 16 => "111011", 17 => "001000", 18 => "101100", 19 => "111001", 
    20 => "000110", 21 => "010011", 22 => "110111", 23 => "000100", 24 => "010001", 
    25 => "110101", 26 => "000010", 27 => "001111", 28 => "110011", 29 => "000000", 
    30 => "001101", 31 => "110001", 32 => "111110", 33 => "001011", 34 => "101111", 
    35 => "111100", 36 => "001001", 37 => "101101", 38 => "111010", 39 => "000111", 
    40 => "010100", 41 => "111000", 42 => "000101", 43 => "010010", 44 => "110110", 
    45 => "000011", 46 => "010000", 47 => "110100", 48 => "000001", 49 => "001110", 
    50 => "110010", 51 => "111111", 52 => "001100", 53 => "110000", 54 => "111101", 
    55 => "001010", 56 => "101110", 57 => "111011", 58 => "001000", 59 => "101100", 
    60 => "111001", 61 => "000110", 62 => "010011", 63 => "110111", 64 => "000100", 
    65 => "010001", 66 => "110101", 67 => "000010", 68 => "001111", 69 => "110011", 
    70 => "000000", 71 => "001101", 72 => "110001", 73 => "111110", 74 => "001011", 
    75 => "101111", 76 => "111100", 77 => "001001", 78 => "101101", 79 => "111010", 
    80 => "000111", 81 => "010100", 82 => "111000", 83 => "000101", 84 => "010010", 
    85 => "110110", 86 => "000011", 87 => "010000", 88 => "110100", 89 => "000001", 
    90 => "001110", 91 => "110010", 92 => "111111", 93 => "001100", 94 => "110000", 
    95 => "111101" );

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

entity conv1d_stage_W_PJfI3 is
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

architecture arch of conv1d_stage_W_PJfI3 is
    component conv1d_stage_W_PJfI3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfI3_rom_U :  component conv1d_stage_W_PJfI3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


