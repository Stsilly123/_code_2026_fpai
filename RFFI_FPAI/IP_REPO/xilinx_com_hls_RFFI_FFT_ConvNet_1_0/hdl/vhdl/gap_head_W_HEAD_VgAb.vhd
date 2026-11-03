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

entity gap_head_W_HEAD_VgAb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgAb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "010010", 1 => "000011", 2 => "110100", 3 => "001110", 4 => "111111", 
    5 => "110000", 6 => "001010", 7 => "111011", 8 => "101100", 9 => "000110", 
    10 => "110111", 11 => "010001", 12 => "000010", 13 => "110011", 14 => "001101", 
    15 => "111110", 16 => "101111", 17 => "001001", 18 => "111010", 19 => "010100", 
    20 => "000101", 21 => "110110", 22 => "010000", 23 => "000001", 24 => "110010", 
    25 => "001100", 26 => "111101", 27 => "101110", 28 => "001000", 29 => "111001", 
    30 => "010011", 31 => "000100", 32 => "110101", 33 => "001111", 34 => "000000", 
    35 => "110001", 36 => "001011", 37 => "111100", 38 => "101101", 39 => "000111", 
    40 => "111000", 41 => "010010", 42 => "000011", 43 => "110100", 44 => "001110", 
    45 => "111111", 46 => "110000", 47 => "001010", 48 => "111011", 49 => "101100", 
    50 => "000110", 51 => "110111", 52 => "010001", 53 => "000010", 54 => "110011", 
    55 => "001101", 56 => "111110", 57 => "101111", 58 => "001001", 59 => "111010", 
    60 => "010100", 61 => "000101", 62 => "110110", 63 => "010000", 64 => "000001", 
    65 => "110010", 66 => "001100", 67 => "111101", 68 => "101110", 69 => "001000", 
    70 => "111001", 71 => "010011", 72 => "000100", 73 => "110101", 74 => "001111", 
    75 => "000000", 76 => "110001", 77 => "001011", 78 => "111100", 79 => "101101", 
    80 => "000111", 81 => "111000", 82 => "010010", 83 => "000011", 84 => "110100", 
    85 => "001110", 86 => "111111", 87 => "110000", 88 => "001010", 89 => "111011", 
    90 => "101100", 91 => "000110", 92 => "110111", 93 => "010001", 94 => "000010", 
    95 => "110011", 96 => "001101", 97 => "111110", 98 => "101111", 99 => "001001", 
    100 => "111010", 101 => "010100", 102 => "000101", 103 => "110110", 104 => "010000", 
    105 => "000001", 106 => "110010", 107 => "001100", 108 => "111101", 109 => "101110", 
    110 => "001000", 111 => "111001", 112 => "010011", 113 => "000100", 114 => "110101", 
    115 => "001111", 116 => "000000", 117 => "110001", 118 => "001011", 119 => "111100", 
    120 => "101101", 121 => "000111", 122 => "111000", 123 => "010010", 124 => "000011", 
    125 => "110100", 126 => "001110", 127 => "111111", 128 => "110000", 129 => "001010", 
    130 => "111011", 131 => "101100", 132 => "000110", 133 => "110111", 134 => "010001", 
    135 => "000010", 136 => "110011", 137 => "001101", 138 => "111110", 139 => "101111", 
    140 => "001001", 141 => "111010", 142 => "010100", 143 => "000101", 144 => "110110", 
    145 => "010000", 146 => "000001", 147 => "110010", 148 => "001100", 149 => "111101" );

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

entity gap_head_W_HEAD_VgAb is
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

architecture arch of gap_head_W_HEAD_VgAb is
    component gap_head_W_HEAD_VgAb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgAb_rom_U :  component gap_head_W_HEAD_VgAb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


