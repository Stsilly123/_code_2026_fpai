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

entity gap_head_W_HEAD_VgDb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgDb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000110", 1 => "110111", 2 => "010001", 3 => "000010", 4 => "110011", 
    5 => "001101", 6 => "111110", 7 => "101111", 8 => "001001", 9 => "111010", 
    10 => "010100", 11 => "000101", 12 => "110110", 13 => "010000", 14 => "000001", 
    15 => "110010", 16 => "001100", 17 => "111101", 18 => "101110", 19 => "001000", 
    20 => "111001", 21 => "010011", 22 => "000100", 23 => "110101", 24 => "001111", 
    25 => "000000", 26 => "110001", 27 => "001011", 28 => "111100", 29 => "101101", 
    30 => "000111", 31 => "111000", 32 => "010010", 33 => "000011", 34 => "110100", 
    35 => "001110", 36 => "111111", 37 => "110000", 38 => "001010", 39 => "111011", 
    40 => "101100", 41 => "000110", 42 => "110111", 43 => "010001", 44 => "000010", 
    45 => "110011", 46 => "001101", 47 => "111110", 48 => "101111", 49 => "001001", 
    50 => "111010", 51 => "010100", 52 => "000101", 53 => "110110", 54 => "010000", 
    55 => "000001", 56 => "110010", 57 => "001100", 58 => "111101", 59 => "101110", 
    60 => "001000", 61 => "111001", 62 => "010011", 63 => "000100", 64 => "110101", 
    65 => "001111", 66 => "000000", 67 => "110001", 68 => "001011", 69 => "111100", 
    70 => "101101", 71 => "000111", 72 => "111000", 73 => "010010", 74 => "000011", 
    75 => "110100", 76 => "001110", 77 => "111111", 78 => "110000", 79 => "001010", 
    80 => "111011", 81 => "101100", 82 => "000110", 83 => "110111", 84 => "010001", 
    85 => "000010", 86 => "110011", 87 => "001101", 88 => "111110", 89 => "101111", 
    90 => "001001", 91 => "111010", 92 => "010100", 93 => "000101", 94 => "110110", 
    95 => "010000", 96 => "000001", 97 => "110010", 98 => "001100", 99 => "111101", 
    100 => "101110", 101 => "001000", 102 => "111001", 103 => "010011", 104 => "000100", 
    105 => "110101", 106 => "001111", 107 => "000000", 108 => "110001", 109 => "001011", 
    110 => "111100", 111 => "101101", 112 => "000111", 113 => "111000", 114 => "010010", 
    115 => "000011", 116 => "110100", 117 => "001110", 118 => "111111", 119 => "110000", 
    120 => "001010", 121 => "111011", 122 => "101100", 123 => "000110", 124 => "110111", 
    125 => "010001", 126 => "000010", 127 => "110011", 128 => "001101", 129 => "111110", 
    130 => "101111", 131 => "001001", 132 => "111010", 133 => "010100", 134 => "000101", 
    135 => "110110", 136 => "010000", 137 => "000001", 138 => "110010", 139 => "001100", 
    140 => "111101", 141 => "101110", 142 => "001000", 143 => "111001", 144 => "010011", 
    145 => "000100", 146 => "110101", 147 => "001111", 148 => "000000", 149 => "110001" );

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

entity gap_head_W_HEAD_VgDb is
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

architecture arch of gap_head_W_HEAD_VgDb is
    component gap_head_W_HEAD_VgDb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgDb_rom_U :  component gap_head_W_HEAD_VgDb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


