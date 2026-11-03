-- ==============================================================
-- File generated on Sun Oct 18 16:53:15 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VgUb_rom is 
    generic(
             DWIDTH     : integer := 8; 
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


architecture rtl of gap_head_W_HEAD_VgUb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100111", 1 => "11010001", 2 => "00010101", 3 => "00100000", 
    4 => "10010000", 5 => "10011110", 6 => "00000001", 7 => "00100000", 
    8 => "11100101", 9 => "00110001", 10 => "11011001", 11 => "11110000", 
    12 => "00100110", 13 => "11010010", 14 => "00001111", 15 => "11000100", 
    16 => "00000110", 17 => "00100101", 18 => "00010010", 19 => "00011000", 
    20 => "01111000", 21 => "00110101", 22 => "00100011", 23 => "00100110", 
    24 => "00011011", 25 => "11101110", 26 => "00000010", 27 => "00001000", 
    28 => "11110001", 29 => "00001110", 30 => "11101101", 31 => "11101010", 
    32 => "00010100", 33 => "00111011", 34 => "00000011", 35 => "01001001", 
    36 => "00011011", 37 => "11000001", 38 => "01010000", 39 => "11110111", 
    40 => "11110001", 41 => "11001010", 42 => "00111000", 43 => "11000100", 
    44 => "11100110", 45 => "00011011", 46 => "11111001", 47 => "00000001", 
    48 => "00000000", 49 => "11100111", 50 => "00001110", 51 => "00001100", 
    52 => "00001011", 53 => "01010101", 54 => "00010101", 55 => "00010100", 
    56 => "11110010", 57 => "11110000", 58 => "11111111", 59 => "11100100", 
    60 => "00001111", 61 => "00010100", 62 => "11001111", 63 => "10110001", 
    64 => "01111111", 65 => "00110111", 66 => "00100011", 67 => "00111011", 
    68 => "00011011", 69 => "00010110", 70 => "11101110", 71 => "00011011", 
    72 => "00001001", 73 => "00011001", 74 => "11100000", 75 => "00100110", 
    76 => "00110010", 77 => "00011010", 78 => "11010100", 79 => "11100110", 
    80 => "00100111", 81 => "00100010", 82 => "11011111", 83 => "11110110", 
    84 => "00110101", 85 => "00101110", 86 => "11011110", 87 => "10101011", 
    88 => "01011010", 89 => "11010010", 90 => "11001010", 91 => "11011010", 
    92 => "11101001", 93 => "11111011", 94 => "11001111", 95 => "10110001", 
    96 => "00001010", 97 => "11011100", 98 => "11011110", 99 => "00001011", 
    100 to 101=> "11000111", 102 => "00110000", 103 => "00110010", 104 => "01010101", 
    105 => "00001111", 106 => "00101101", 107 => "11101000", 108 => "11100011", 
    109 => "11000010", 110 => "10111101", 111 => "11100000", 112 => "00001100", 
    113 => "00010101", 114 => "11100111", 115 => "00000101", 116 => "00110101", 
    117 => "11100111", 118 => "10100110", 119 => "11110100", 120 => "00010011", 
    121 => "00001111", 122 => "11111010", 123 => "11111110", 124 => "10111110", 
    125 => "00011100", 126 => "00101111", 127 => "00100000", 128 => "00000100", 
    129 => "11001010", 130 => "10111100", 131 => "11110000", 132 => "11011100", 
    133 => "11111011", 134 => "00010000", 135 => "00000111", 136 => "00110001", 
    137 => "00100001", 138 => "11010111", 139 => "11010100", 140 => "11011111", 
    141 => "00010101", 142 => "00000000", 143 => "11111010", 144 => "11100101", 
    145 => "00001011", 146 => "11000100", 147 => "11111101", 148 => "00000010", 
    149 => "11100101" );


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

entity gap_head_W_HEAD_VgUb is
    generic (
        DataWidth : INTEGER := 8;
        AddressRange : INTEGER := 150;
        AddressWidth : INTEGER := 8);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of gap_head_W_HEAD_VgUb is
    component gap_head_W_HEAD_VgUb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgUb_rom_U :  component gap_head_W_HEAD_VgUb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


