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

entity gap_head_W_HEAD_VgPb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VgPb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111111", 1 => "110000", 2 => "001010", 3 => "111011", 4 => "101100", 
    5 => "000110", 6 => "110111", 7 => "010001", 8 => "000010", 9 => "110011", 
    10 => "001101", 11 => "111110", 12 => "101111", 13 => "001001", 14 => "111010", 
    15 => "010100", 16 => "000101", 17 => "110110", 18 => "010000", 19 => "000001", 
    20 => "110010", 21 => "001100", 22 => "111101", 23 => "101110", 24 => "001000", 
    25 => "111001", 26 => "010011", 27 => "000100", 28 => "110101", 29 => "001111", 
    30 => "000000", 31 => "110001", 32 => "001011", 33 => "111100", 34 => "101101", 
    35 => "000111", 36 => "111000", 37 => "010010", 38 => "000011", 39 => "110100", 
    40 => "001110", 41 => "111111", 42 => "110000", 43 => "001010", 44 => "111011", 
    45 => "101100", 46 => "000110", 47 => "110111", 48 => "010001", 49 => "000010", 
    50 => "110011", 51 => "001101", 52 => "111110", 53 => "101111", 54 => "001001", 
    55 => "111010", 56 => "010100", 57 => "000101", 58 => "110110", 59 => "010000", 
    60 => "000001", 61 => "110010", 62 => "001100", 63 => "111101", 64 => "101110", 
    65 => "001000", 66 => "111001", 67 => "010011", 68 => "000100", 69 => "110101", 
    70 => "001111", 71 => "000000", 72 => "110001", 73 => "001011", 74 => "111100", 
    75 => "101101", 76 => "000111", 77 => "111000", 78 => "010010", 79 => "000011", 
    80 => "110100", 81 => "001110", 82 => "111111", 83 => "110000", 84 => "001010", 
    85 => "111011", 86 => "101100", 87 => "000110", 88 => "110111", 89 => "010001", 
    90 => "000010", 91 => "110011", 92 => "001101", 93 => "111110", 94 => "101111", 
    95 => "001001", 96 => "111010", 97 => "010100", 98 => "000101", 99 => "110110", 
    100 => "010000", 101 => "000001", 102 => "110010", 103 => "001100", 104 => "111101", 
    105 => "101110", 106 => "001000", 107 => "111001", 108 => "010011", 109 => "000100", 
    110 => "110101", 111 => "001111", 112 => "000000", 113 => "110001", 114 => "001011", 
    115 => "111100", 116 => "101101", 117 => "000111", 118 => "111000", 119 => "010010", 
    120 => "000011", 121 => "110100", 122 => "001110", 123 => "111111", 124 => "110000", 
    125 => "001010", 126 => "111011", 127 => "101100", 128 => "000110", 129 => "110111", 
    130 => "010001", 131 => "000010", 132 => "110011", 133 => "001101", 134 => "111110", 
    135 => "101111", 136 => "001001", 137 => "111010", 138 => "010100", 139 => "000101", 
    140 => "110110", 141 => "010000", 142 => "000001", 143 => "110010", 144 => "001100", 
    145 => "111101", 146 => "101110", 147 => "001000", 148 => "111001", 149 => "010011" );

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

entity gap_head_W_HEAD_VgPb_x is
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

architecture arch of gap_head_W_HEAD_VgPb_x is
    component gap_head_W_HEAD_VgPb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgPb_x_rom_U :  component gap_head_W_HEAD_VgPb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


