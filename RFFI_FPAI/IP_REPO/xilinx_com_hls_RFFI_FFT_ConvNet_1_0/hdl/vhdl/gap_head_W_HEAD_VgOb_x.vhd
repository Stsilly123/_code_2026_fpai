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

entity gap_head_W_HEAD_VgOb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VgOb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000011", 1 => "110100", 2 => "001110", 3 => "111111", 4 => "110000", 
    5 => "001010", 6 => "111011", 7 => "101100", 8 => "000110", 9 => "110111", 
    10 => "010001", 11 => "000010", 12 => "110011", 13 => "001101", 14 => "111110", 
    15 => "101111", 16 => "001001", 17 => "111010", 18 => "010100", 19 => "000101", 
    20 => "110110", 21 => "010000", 22 => "000001", 23 => "110010", 24 => "001100", 
    25 => "111101", 26 => "101110", 27 => "001000", 28 => "111001", 29 => "010011", 
    30 => "000100", 31 => "110101", 32 => "001111", 33 => "000000", 34 => "110001", 
    35 => "001011", 36 => "111100", 37 => "101101", 38 => "000111", 39 => "111000", 
    40 => "010010", 41 => "000011", 42 => "110100", 43 => "001110", 44 => "111111", 
    45 => "110000", 46 => "001010", 47 => "111011", 48 => "101100", 49 => "000110", 
    50 => "110111", 51 => "010001", 52 => "000010", 53 => "110011", 54 => "001101", 
    55 => "111110", 56 => "101111", 57 => "001001", 58 => "111010", 59 => "010100", 
    60 => "000101", 61 => "110110", 62 => "010000", 63 => "000001", 64 => "110010", 
    65 => "001100", 66 => "111101", 67 => "101110", 68 => "001000", 69 => "111001", 
    70 => "010011", 71 => "000100", 72 => "110101", 73 => "001111", 74 => "000000", 
    75 => "110001", 76 => "001011", 77 => "111100", 78 => "101101", 79 => "000111", 
    80 => "111000", 81 => "010010", 82 => "000011", 83 => "110100", 84 => "001110", 
    85 => "111111", 86 => "110000", 87 => "001010", 88 => "111011", 89 => "101100", 
    90 => "000110", 91 => "110111", 92 => "010001", 93 => "000010", 94 => "110011", 
    95 => "001101", 96 => "111110", 97 => "101111", 98 => "001001", 99 => "111010", 
    100 => "010100", 101 => "000101", 102 => "110110", 103 => "010000", 104 => "000001", 
    105 => "110010", 106 => "001100", 107 => "111101", 108 => "101110", 109 => "001000", 
    110 => "111001", 111 => "010011", 112 => "000100", 113 => "110101", 114 => "001111", 
    115 => "000000", 116 => "110001", 117 => "001011", 118 => "111100", 119 => "101101", 
    120 => "000111", 121 => "111000", 122 => "010010", 123 => "000011", 124 => "110100", 
    125 => "001110", 126 => "111111", 127 => "110000", 128 => "001010", 129 => "111011", 
    130 => "101100", 131 => "000110", 132 => "110111", 133 => "010001", 134 => "000010", 
    135 => "110011", 136 => "001101", 137 => "111110", 138 => "101111", 139 => "001001", 
    140 => "111010", 141 => "010100", 142 => "000101", 143 => "110110", 144 => "010000", 
    145 => "000001", 146 => "110010", 147 => "001100", 148 => "111101", 149 => "101110" );

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

entity gap_head_W_HEAD_VgOb_x is
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

architecture arch of gap_head_W_HEAD_VgOb_x is
    component gap_head_W_HEAD_VgOb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgOb_x_rom_U :  component gap_head_W_HEAD_VgOb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


