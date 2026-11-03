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

entity gap_head_W_HEAD_VgBb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgBb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001110", 1 => "111111", 2 => "110000", 3 => "001010", 4 => "111011", 
    5 => "101100", 6 => "000110", 7 => "110111", 8 => "010001", 9 => "000010", 
    10 => "110011", 11 => "001101", 12 => "111110", 13 => "101111", 14 => "001001", 
    15 => "111010", 16 => "010100", 17 => "000101", 18 => "110110", 19 => "010000", 
    20 => "000001", 21 => "110010", 22 => "001100", 23 => "111101", 24 => "101110", 
    25 => "001000", 26 => "111001", 27 => "010011", 28 => "000100", 29 => "110101", 
    30 => "001111", 31 => "000000", 32 => "110001", 33 => "001011", 34 => "111100", 
    35 => "101101", 36 => "000111", 37 => "111000", 38 => "010010", 39 => "000011", 
    40 => "110100", 41 => "001110", 42 => "111111", 43 => "110000", 44 => "001010", 
    45 => "111011", 46 => "101100", 47 => "000110", 48 => "110111", 49 => "010001", 
    50 => "000010", 51 => "110011", 52 => "001101", 53 => "111110", 54 => "101111", 
    55 => "001001", 56 => "111010", 57 => "010100", 58 => "000101", 59 => "110110", 
    60 => "010000", 61 => "000001", 62 => "110010", 63 => "001100", 64 => "111101", 
    65 => "101110", 66 => "001000", 67 => "111001", 68 => "010011", 69 => "000100", 
    70 => "110101", 71 => "001111", 72 => "000000", 73 => "110001", 74 => "001011", 
    75 => "111100", 76 => "101101", 77 => "000111", 78 => "111000", 79 => "010010", 
    80 => "000011", 81 => "110100", 82 => "001110", 83 => "111111", 84 => "110000", 
    85 => "001010", 86 => "111011", 87 => "101100", 88 => "000110", 89 => "110111", 
    90 => "010001", 91 => "000010", 92 => "110011", 93 => "001101", 94 => "111110", 
    95 => "101111", 96 => "001001", 97 => "111010", 98 => "010100", 99 => "000101", 
    100 => "110110", 101 => "010000", 102 => "000001", 103 => "110010", 104 => "001100", 
    105 => "111101", 106 => "101110", 107 => "001000", 108 => "111001", 109 => "010011", 
    110 => "000100", 111 => "110101", 112 => "001111", 113 => "000000", 114 => "110001", 
    115 => "001011", 116 => "111100", 117 => "101101", 118 => "000111", 119 => "111000", 
    120 => "010010", 121 => "000011", 122 => "110100", 123 => "001110", 124 => "111111", 
    125 => "110000", 126 => "001010", 127 => "111011", 128 => "101100", 129 => "000110", 
    130 => "110111", 131 => "010001", 132 => "000010", 133 => "110011", 134 => "001101", 
    135 => "111110", 136 => "101111", 137 => "001001", 138 => "111010", 139 => "010100", 
    140 => "000101", 141 => "110110", 142 => "010000", 143 => "000001", 144 => "110010", 
    145 => "001100", 146 => "111101", 147 => "101110", 148 => "001000", 149 => "111001" );

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

entity gap_head_W_HEAD_VgBb is
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

architecture arch of gap_head_W_HEAD_VgBb is
    component gap_head_W_HEAD_VgBb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgBb_rom_U :  component gap_head_W_HEAD_VgBb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


