-- ==============================================================
-- File generated on Thu Oct 15 12:17:30 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VgEb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgEb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000010", 1 => "110011", 2 => "001101", 3 => "111110", 4 => "101111", 
    5 => "001001", 6 => "111010", 7 => "010100", 8 => "000101", 9 => "110110", 
    10 => "010000", 11 => "000001", 12 => "110010", 13 => "001100", 14 => "111101", 
    15 => "101110", 16 => "001000", 17 => "111001", 18 => "010011", 19 => "000100", 
    20 => "110101", 21 => "001111", 22 => "000000", 23 => "110001", 24 => "001011", 
    25 => "111100", 26 => "101101", 27 => "000111", 28 => "111000", 29 => "010010", 
    30 => "000011", 31 => "110100", 32 => "001110", 33 => "111111", 34 => "110000", 
    35 => "001010", 36 => "111011", 37 => "101100", 38 => "000110", 39 => "110111", 
    40 => "010001", 41 => "000010", 42 => "110011", 43 => "001101", 44 => "111110", 
    45 => "101111", 46 => "001001", 47 => "111010", 48 => "010100", 49 => "000101", 
    50 => "110110", 51 => "010000", 52 => "000001", 53 => "110010", 54 => "001100", 
    55 => "111101", 56 => "101110", 57 => "001000", 58 => "111001", 59 => "010011", 
    60 => "000100", 61 => "110101", 62 => "001111", 63 => "000000", 64 => "110001", 
    65 => "001011", 66 => "111100", 67 => "101101", 68 => "000111", 69 => "111000", 
    70 => "010010", 71 => "000011", 72 => "110100", 73 => "001110", 74 => "111111", 
    75 => "110000", 76 => "001010", 77 => "111011", 78 => "101100", 79 => "000110", 
    80 => "110111", 81 => "010001", 82 => "000010", 83 => "110011", 84 => "001101", 
    85 => "111110", 86 => "101111", 87 => "001001", 88 => "111010", 89 => "010100", 
    90 => "000101", 91 => "110110", 92 => "010000", 93 => "000001", 94 => "110010", 
    95 => "001100", 96 => "111101", 97 => "101110", 98 => "001000", 99 => "111001", 
    100 => "010011", 101 => "000100", 102 => "110101", 103 => "001111", 104 => "000000", 
    105 => "110001", 106 => "001011", 107 => "111100", 108 => "101101", 109 => "000111", 
    110 => "111000", 111 => "010010", 112 => "000011", 113 => "110100", 114 => "001110", 
    115 => "111111", 116 => "110000", 117 => "001010", 118 => "111011", 119 => "101100", 
    120 => "000110", 121 => "110111", 122 => "010001", 123 => "000010", 124 => "110011", 
    125 => "001101", 126 => "111110", 127 => "101111", 128 => "001001", 129 => "111010", 
    130 => "010100", 131 => "000101", 132 => "110110", 133 => "010000", 134 => "000001", 
    135 => "110010", 136 => "001100", 137 => "111101", 138 => "101110", 139 => "001000", 
    140 => "111001", 141 => "010011", 142 => "000100", 143 => "110101", 144 => "001111", 
    145 => "000000", 146 => "110001", 147 => "001011", 148 => "111100", 149 => "101101" );

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

entity gap_head_W_HEAD_VgEb is
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

architecture arch of gap_head_W_HEAD_VgEb is
    component gap_head_W_HEAD_VgEb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgEb_rom_U :  component gap_head_W_HEAD_VgEb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


