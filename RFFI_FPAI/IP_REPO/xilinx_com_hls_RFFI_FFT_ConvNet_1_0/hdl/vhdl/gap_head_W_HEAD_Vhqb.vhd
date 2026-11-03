-- ==============================================================
-- File generated on Sun Oct 18 16:53:16 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vhqb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhqb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000101", 1 => "11101100", 2 => "00110110", 3 => "00111111", 
    4 => "11110011", 5 => "11011100", 6 => "11110010", 7 => "11111100", 
    8 => "00011010", 9 => "11101111", 10 => "00110011", 11 => "01010101", 
    12 => "11100100", 13 => "00010011", 14 => "00100111", 15 => "11010011", 
    16 => "11000100", 17 => "11111111", 18 => "11100101", 19 => "10111111", 
    20 => "00000010", 21 => "11100101", 22 => "00001001", 23 => "00110100", 
    24 => "00010111", 25 => "00011010", 26 => "00010001", 27 => "00100100", 
    28 => "00010001", 29 => "00001111", 30 => "11111100", 31 => "01010101", 
    32 => "00011111", 33 => "11110111", 34 => "11110101", 35 => "01000010", 
    36 => "11100110", 37 => "00100110", 38 => "00010000", 39 => "11000000", 
    40 => "11111100", 41 => "00011111", 42 => "00001110", 43 => "01000001", 
    44 => "10110101", 45 => "00010001", 46 => "11111101", 47 => "00011110", 
    48 => "00001110", 49 => "00000011", 50 => "11111001", 51 => "11111010", 
    52 => "10010001", 53 => "01000100", 54 => "01000010", 55 => "10110001", 
    56 => "11011111", 57 => "01011010", 58 => "11001001", 59 => "11000111", 
    60 => "00110000", 61 => "11100101", 62 => "11011110", 63 => "11110100", 
    64 => "00110011", 65 => "11101010", 66 => "01001111", 67 => "00000010", 
    68 => "11110011", 69 => "00000001", 70 => "11000110", 71 => "00000001", 
    72 => "11001010", 73 => "11101111", 74 => "11111101", 75 => "00000011", 
    76 => "01000100", 77 => "11111111", 78 => "11111010", 79 => "11100101", 
    80 => "11100010", 81 => "00010110", 82 => "11100111", 83 => "10100000", 
    84 => "11110010", 85 => "10111111", 86 => "11000011", 87 => "11111001", 
    88 => "01110111", 89 => "00101001", 90 => "11100111", 91 => "00011000", 
    92 => "00110100", 93 => "11100100", 94 => "00111001", 95 => "00000111", 
    96 => "00111101", 97 => "00010111", 98 => "11110101", 99 => "00101000", 
    100 => "00101110", 101 to 102=> "11100100", 103 => "00011011", 104 => "11101010", 
    105 => "00010101", 106 => "00111010", 107 => "00100001", 108 => "11110110", 
    109 => "11001010", 110 => "00011101", 111 => "11111110", 112 => "00000011", 
    113 => "11111100", 114 => "11001010", 115 => "11100010", 116 => "01001010", 
    117 => "11101010", 118 => "11111010", 119 => "00000100", 120 => "00101111", 
    121 => "11110011", 122 => "00010011", 123 => "00100001", 124 => "01000000", 
    125 => "11000110", 126 => "11101001", 127 => "00010000", 128 => "11010001", 
    129 => "00011101", 130 => "11100110", 131 => "00010110", 132 => "00000010", 
    133 => "11110101", 134 => "11001101", 135 => "00001000", 136 => "00010000", 
    137 => "00100101", 138 => "00010011", 139 => "00001101", 140 => "11010011", 
    141 => "00000010", 142 => "10111110", 143 => "11110101", 144 => "00101110", 
    145 => "11010100", 146 => "00100011", 147 => "10111101", 148 => "00101111", 
    149 => "01000010" );


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

entity gap_head_W_HEAD_Vhqb is
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

architecture arch of gap_head_W_HEAD_Vhqb is
    component gap_head_W_HEAD_Vhqb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhqb_rom_U :  component gap_head_W_HEAD_Vhqb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


