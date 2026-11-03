-- ==============================================================
-- File generated on Thu Oct 15 12:17:29 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vgm9_rom is 
    generic(
             DWIDTH     : integer := 6; 
             AWIDTH     : integer := 8; 
             MEM_SIZE    : integer := 150
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of gap_head_W_HEAD_Vgm9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111000", 1 => "010010", 2 => "000011", 3 => "110100", 4 => "001110", 
    5 => "111111", 6 => "110000", 7 => "001010", 8 => "111011", 9 => "101100", 
    10 => "000110", 11 => "110111", 12 => "010001", 13 => "000010", 14 => "110011", 
    15 => "001101", 16 => "111110", 17 => "101111", 18 => "001001", 19 => "111010", 
    20 => "010100", 21 => "000101", 22 => "110110", 23 => "010000", 24 => "000001", 
    25 => "110010", 26 => "001100", 27 => "111101", 28 => "101110", 29 => "001000", 
    30 => "111001", 31 => "010011", 32 => "000100", 33 => "110101", 34 => "001111", 
    35 => "000000", 36 => "110001", 37 => "001011", 38 => "111100", 39 => "101101", 
    40 => "000111", 41 => "111000", 42 => "010010", 43 => "000011", 44 => "110100", 
    45 => "001110", 46 => "111111", 47 => "110000", 48 => "001010", 49 => "111011", 
    50 => "101100", 51 => "000110", 52 => "110111", 53 => "010001", 54 => "000010", 
    55 => "110011", 56 => "001101", 57 => "111110", 58 => "101111", 59 => "001001", 
    60 => "111010", 61 => "010100", 62 => "000101", 63 => "110110", 64 => "010000", 
    65 => "000001", 66 => "110010", 67 => "001100", 68 => "111101", 69 => "101110", 
    70 => "001000", 71 => "111001", 72 => "010011", 73 => "000100", 74 => "110101", 
    75 => "001111", 76 => "000000", 77 => "110001", 78 => "001011", 79 => "111100", 
    80 => "101101", 81 => "000111", 82 => "111000", 83 => "010010", 84 => "000011", 
    85 => "110100", 86 => "001110", 87 => "111111", 88 => "110000", 89 => "001010", 
    90 => "111011", 91 => "101100", 92 => "000110", 93 => "110111", 94 => "010001", 
    95 => "000010", 96 => "110011", 97 => "001101", 98 => "111110", 99 => "101111", 
    100 => "001001", 101 => "111010", 102 => "010100", 103 => "000101", 104 => "110110", 
    105 => "010000", 106 => "000001", 107 => "110010", 108 => "001100", 109 => "111101", 
    110 => "101110", 111 => "001000", 112 => "111001", 113 => "010011", 114 => "000100", 
    115 => "110101", 116 => "001111", 117 => "000000", 118 => "110001", 119 => "001011", 
    120 => "111100", 121 => "101101", 122 => "000111", 123 => "111000", 124 => "010010", 
    125 => "000011", 126 => "110100", 127 => "001110", 128 => "111111", 129 => "110000", 
    130 => "001010", 131 => "111011", 132 => "101100", 133 => "000110", 134 => "110111", 
    135 => "010001", 136 => "000010", 137 => "110011", 138 => "001101", 139 => "111110", 
    140 => "101111", 141 => "001001", 142 => "111010", 143 => "010100", 144 => "000101", 
    145 => "110110", 146 => "010000", 147 => "000001", 148 => "110010", 149 => "001100" );

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

entity gap_head_W_HEAD_Vgm9 is
    generic (
        DataWidth : INTEGER := 6;
        AddressRange : INTEGER := 150;
        AddressWidth : INTEGER := 8);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of gap_head_W_HEAD_Vgm9 is
    component gap_head_W_HEAD_Vgm9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vgm9_rom_U :  component gap_head_W_HEAD_Vgm9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


