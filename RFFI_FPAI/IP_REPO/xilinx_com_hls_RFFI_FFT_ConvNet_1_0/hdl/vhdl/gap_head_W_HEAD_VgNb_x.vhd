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

entity gap_head_W_HEAD_VgNb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VgNb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000111", 1 => "111000", 2 => "010010", 3 => "000011", 4 => "110100", 
    5 => "001110", 6 => "111111", 7 => "110000", 8 => "001010", 9 => "111011", 
    10 => "101100", 11 => "000110", 12 => "110111", 13 => "010001", 14 => "000010", 
    15 => "110011", 16 => "001101", 17 => "111110", 18 => "101111", 19 => "001001", 
    20 => "111010", 21 => "010100", 22 => "000101", 23 => "110110", 24 => "010000", 
    25 => "000001", 26 => "110010", 27 => "001100", 28 => "111101", 29 => "101110", 
    30 => "001000", 31 => "111001", 32 => "010011", 33 => "000100", 34 => "110101", 
    35 => "001111", 36 => "000000", 37 => "110001", 38 => "001011", 39 => "111100", 
    40 => "101101", 41 => "000111", 42 => "111000", 43 => "010010", 44 => "000011", 
    45 => "110100", 46 => "001110", 47 => "111111", 48 => "110000", 49 => "001010", 
    50 => "111011", 51 => "101100", 52 => "000110", 53 => "110111", 54 => "010001", 
    55 => "000010", 56 => "110011", 57 => "001101", 58 => "111110", 59 => "101111", 
    60 => "001001", 61 => "111010", 62 => "010100", 63 => "000101", 64 => "110110", 
    65 => "010000", 66 => "000001", 67 => "110010", 68 => "001100", 69 => "111101", 
    70 => "101110", 71 => "001000", 72 => "111001", 73 => "010011", 74 => "000100", 
    75 => "110101", 76 => "001111", 77 => "000000", 78 => "110001", 79 => "001011", 
    80 => "111100", 81 => "101101", 82 => "000111", 83 => "111000", 84 => "010010", 
    85 => "000011", 86 => "110100", 87 => "001110", 88 => "111111", 89 => "110000", 
    90 => "001010", 91 => "111011", 92 => "101100", 93 => "000110", 94 => "110111", 
    95 => "010001", 96 => "000010", 97 => "110011", 98 => "001101", 99 => "111110", 
    100 => "101111", 101 => "001001", 102 => "111010", 103 => "010100", 104 => "000101", 
    105 => "110110", 106 => "010000", 107 => "000001", 108 => "110010", 109 => "001100", 
    110 => "111101", 111 => "101110", 112 => "001000", 113 => "111001", 114 => "010011", 
    115 => "000100", 116 => "110101", 117 => "001111", 118 => "000000", 119 => "110001", 
    120 => "001011", 121 => "111100", 122 => "101101", 123 => "000111", 124 => "111000", 
    125 => "010010", 126 => "000011", 127 => "110100", 128 => "001110", 129 => "111111", 
    130 => "110000", 131 => "001010", 132 => "111011", 133 => "101100", 134 => "000110", 
    135 => "110111", 136 => "010001", 137 => "000010", 138 => "110011", 139 => "001101", 
    140 => "111110", 141 => "101111", 142 => "001001", 143 => "111010", 144 => "010100", 
    145 => "000101", 146 => "110110", 147 => "010000", 148 => "000001", 149 => "110010" );

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

entity gap_head_W_HEAD_VgNb_x is
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

architecture arch of gap_head_W_HEAD_VgNb_x is
    component gap_head_W_HEAD_VgNb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgNb_x_rom_U :  component gap_head_W_HEAD_VgNb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


