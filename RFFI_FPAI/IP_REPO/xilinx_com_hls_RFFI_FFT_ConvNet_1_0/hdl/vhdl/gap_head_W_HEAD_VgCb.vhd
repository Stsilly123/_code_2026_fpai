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

entity gap_head_W_HEAD_VgCb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgCb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001010", 1 => "111011", 2 => "101100", 3 => "000110", 4 => "110111", 
    5 => "010001", 6 => "000010", 7 => "110011", 8 => "001101", 9 => "111110", 
    10 => "101111", 11 => "001001", 12 => "111010", 13 => "010100", 14 => "000101", 
    15 => "110110", 16 => "010000", 17 => "000001", 18 => "110010", 19 => "001100", 
    20 => "111101", 21 => "101110", 22 => "001000", 23 => "111001", 24 => "010011", 
    25 => "000100", 26 => "110101", 27 => "001111", 28 => "000000", 29 => "110001", 
    30 => "001011", 31 => "111100", 32 => "101101", 33 => "000111", 34 => "111000", 
    35 => "010010", 36 => "000011", 37 => "110100", 38 => "001110", 39 => "111111", 
    40 => "110000", 41 => "001010", 42 => "111011", 43 => "101100", 44 => "000110", 
    45 => "110111", 46 => "010001", 47 => "000010", 48 => "110011", 49 => "001101", 
    50 => "111110", 51 => "101111", 52 => "001001", 53 => "111010", 54 => "010100", 
    55 => "000101", 56 => "110110", 57 => "010000", 58 => "000001", 59 => "110010", 
    60 => "001100", 61 => "111101", 62 => "101110", 63 => "001000", 64 => "111001", 
    65 => "010011", 66 => "000100", 67 => "110101", 68 => "001111", 69 => "000000", 
    70 => "110001", 71 => "001011", 72 => "111100", 73 => "101101", 74 => "000111", 
    75 => "111000", 76 => "010010", 77 => "000011", 78 => "110100", 79 => "001110", 
    80 => "111111", 81 => "110000", 82 => "001010", 83 => "111011", 84 => "101100", 
    85 => "000110", 86 => "110111", 87 => "010001", 88 => "000010", 89 => "110011", 
    90 => "001101", 91 => "111110", 92 => "101111", 93 => "001001", 94 => "111010", 
    95 => "010100", 96 => "000101", 97 => "110110", 98 => "010000", 99 => "000001", 
    100 => "110010", 101 => "001100", 102 => "111101", 103 => "101110", 104 => "001000", 
    105 => "111001", 106 => "010011", 107 => "000100", 108 => "110101", 109 => "001111", 
    110 => "000000", 111 => "110001", 112 => "001011", 113 => "111100", 114 => "101101", 
    115 => "000111", 116 => "111000", 117 => "010010", 118 => "000011", 119 => "110100", 
    120 => "001110", 121 => "111111", 122 => "110000", 123 => "001010", 124 => "111011", 
    125 => "101100", 126 => "000110", 127 => "110111", 128 => "010001", 129 => "000010", 
    130 => "110011", 131 => "001101", 132 => "111110", 133 => "101111", 134 => "001001", 
    135 => "111010", 136 => "010100", 137 => "000101", 138 => "110110", 139 => "010000", 
    140 => "000001", 141 => "110010", 142 => "001100", 143 => "111101", 144 => "101110", 
    145 => "001000", 146 => "111001", 147 => "010011", 148 => "000100", 149 => "110101" );

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

entity gap_head_W_HEAD_VgCb is
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

architecture arch of gap_head_W_HEAD_VgCb is
    component gap_head_W_HEAD_VgCb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgCb_rom_U :  component gap_head_W_HEAD_VgCb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


