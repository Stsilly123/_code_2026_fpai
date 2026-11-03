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

entity gap_head_W_HEAD_Vg1b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg1b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100111", 1 => "00110110", 2 => "00110101", 3 => "01010110", 
    4 => "00010011", 5 => "11110001", 6 => "00000100", 7 => "10111101", 
    8 => "00111000", 9 => "00110110", 10 => "00001000", 11 => "01000011", 
    12 => "11100100", 13 => "00100011", 14 => "01010000", 15 => "11101011", 
    16 => "11011000", 17 => "11110101", 18 => "00000101", 19 => "01000101", 
    20 => "11110001", 21 => "00100101", 22 => "00111001", 23 => "00101100", 
    24 => "01000000", 25 => "11101011", 26 => "00011100", 27 => "11110001", 
    28 => "00001010", 29 => "00111010", 30 => "00010110", 31 => "00111011", 
    32 => "00111010", 33 => "11101001", 34 => "00101001", 35 => "11011001", 
    36 => "00011001", 37 => "11010100", 38 => "11010101", 39 => "11101010", 
    40 => "10010110", 41 => "11011111", 42 => "00010100", 43 => "00101010", 
    44 => "00011111", 45 => "11110111", 46 => "11101101", 47 => "11101100", 
    48 => "10110110", 49 => "00000101", 50 => "11101000", 51 => "00001101", 
    52 => "01010001", 53 => "11100010", 54 => "00110001", 55 => "11101010", 
    56 => "11101000", 57 => "00001000", 58 => "00101011", 59 => "00010110", 
    60 => "11110011", 61 => "00011011", 62 => "11110011", 63 => "00000100", 
    64 => "11000010", 65 => "00011101", 66 => "10111101", 67 => "11011100", 
    68 => "11001111", 69 => "11000000", 70 => "11111000", 71 => "00011011", 
    72 => "00011000", 73 => "00010100", 74 => "11101101", 75 => "11001110", 
    76 => "00100010", 77 => "11111110", 78 => "10000001", 79 => "00001011", 
    80 => "00001111", 81 => "11101100", 82 => "00010000", 83 => "11011100", 
    84 => "00000000", 85 => "00111011", 86 => "00100000", 87 => "11110001", 
    88 => "00010110", 89 => "00011110", 90 => "11011010", 91 => "11111101", 
    92 => "11111011", 93 => "11011010", 94 => "10100011", 95 => "11100111", 
    96 => "00000010", 97 => "10111010", 98 => "11001100", 99 => "01000111", 
    100 => "00000011", 101 => "10100101", 102 => "11010100", 103 => "10110011", 
    104 => "10111010", 105 => "10111110", 106 => "00000100", 107 to 108=> "10111100", 
    109 => "00010000", 110 => "01001001", 111 => "11001001", 112 => "00011111", 
    113 => "10100111", 114 => "00011010", 115 => "11110100", 116 => "00000000", 
    117 => "00101100", 118 => "00011110", 119 => "11010101", 120 => "00100001", 
    121 => "11111100", 122 => "00001010", 123 => "11000100", 124 => "00010001", 
    125 => "00111000", 126 => "00110111", 127 => "10110101", 128 => "00111000", 
    129 => "01010100", 130 => "11101110", 131 => "00010111", 132 => "11111010", 
    133 => "11011100", 134 => "11010111", 135 => "00011111", 136 => "11101101", 
    137 => "00101111", 138 => "00001111", 139 => "00110110", 140 => "11110111", 
    141 => "00010100", 142 => "00001001", 143 => "00000111", 144 => "11110001", 
    145 => "11001001", 146 => "00100010", 147 => "11111010", 148 => "11010110", 
    149 => "00100101" );


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

entity gap_head_W_HEAD_Vg1b is
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

architecture arch of gap_head_W_HEAD_Vg1b is
    component gap_head_W_HEAD_Vg1b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg1b_rom_U :  component gap_head_W_HEAD_Vg1b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


