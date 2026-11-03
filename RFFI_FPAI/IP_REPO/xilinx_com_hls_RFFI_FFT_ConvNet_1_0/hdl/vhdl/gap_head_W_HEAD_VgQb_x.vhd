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

entity gap_head_W_HEAD_VgQb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VgQb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111011", 1 => "101100", 2 => "000110", 3 => "110111", 4 => "010001", 
    5 => "000010", 6 => "110011", 7 => "001101", 8 => "111110", 9 => "101111", 
    10 => "001001", 11 => "111010", 12 => "010100", 13 => "000101", 14 => "110110", 
    15 => "010000", 16 => "000001", 17 => "110010", 18 => "001100", 19 => "111101", 
    20 => "101110", 21 => "001000", 22 => "111001", 23 => "010011", 24 => "000100", 
    25 => "110101", 26 => "001111", 27 => "000000", 28 => "110001", 29 => "001011", 
    30 => "111100", 31 => "101101", 32 => "000111", 33 => "111000", 34 => "010010", 
    35 => "000011", 36 => "110100", 37 => "001110", 38 => "111111", 39 => "110000", 
    40 => "001010", 41 => "111011", 42 => "101100", 43 => "000110", 44 => "110111", 
    45 => "010001", 46 => "000010", 47 => "110011", 48 => "001101", 49 => "111110", 
    50 => "101111", 51 => "001001", 52 => "111010", 53 => "010100", 54 => "000101", 
    55 => "110110", 56 => "010000", 57 => "000001", 58 => "110010", 59 => "001100", 
    60 => "111101", 61 => "101110", 62 => "001000", 63 => "111001", 64 => "010011", 
    65 => "000100", 66 => "110101", 67 => "001111", 68 => "000000", 69 => "110001", 
    70 => "001011", 71 => "111100", 72 => "101101", 73 => "000111", 74 => "111000", 
    75 => "010010", 76 => "000011", 77 => "110100", 78 => "001110", 79 => "111111", 
    80 => "110000", 81 => "001010", 82 => "111011", 83 => "101100", 84 => "000110", 
    85 => "110111", 86 => "010001", 87 => "000010", 88 => "110011", 89 => "001101", 
    90 => "111110", 91 => "101111", 92 => "001001", 93 => "111010", 94 => "010100", 
    95 => "000101", 96 => "110110", 97 => "010000", 98 => "000001", 99 => "110010", 
    100 => "001100", 101 => "111101", 102 => "101110", 103 => "001000", 104 => "111001", 
    105 => "010011", 106 => "000100", 107 => "110101", 108 => "001111", 109 => "000000", 
    110 => "110001", 111 => "001011", 112 => "111100", 113 => "101101", 114 => "000111", 
    115 => "111000", 116 => "010010", 117 => "000011", 118 => "110100", 119 => "001110", 
    120 => "111111", 121 => "110000", 122 => "001010", 123 => "111011", 124 => "101100", 
    125 => "000110", 126 => "110111", 127 => "010001", 128 => "000010", 129 => "110011", 
    130 => "001101", 131 => "111110", 132 => "101111", 133 => "001001", 134 => "111010", 
    135 => "010100", 136 => "000101", 137 => "110110", 138 => "010000", 139 => "000001", 
    140 => "110010", 141 => "001100", 142 => "111101", 143 => "101110", 144 => "001000", 
    145 => "111001", 146 => "010011", 147 => "000100", 148 => "110101", 149 => "001111" );

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

entity gap_head_W_HEAD_VgQb_x is
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

architecture arch of gap_head_W_HEAD_VgQb_x is
    component gap_head_W_HEAD_VgQb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgQb_x_rom_U :  component gap_head_W_HEAD_VgQb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


