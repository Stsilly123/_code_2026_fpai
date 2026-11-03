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

entity gap_head_W_HEAD_Vg6b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg6b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10100000", 1 => "01100001", 2 => "11110000", 3 => "11101100", 
    4 => "11101111", 5 => "01010011", 6 => "01111111", 7 => "11101011", 
    8 => "11101010", 9 => "10001000", 10 => "10000001", 11 => "00100000", 
    12 => "10000001", 13 => "00011010", 14 => "00111000", 15 => "00011000", 
    16 => "11101010", 17 => "10101010", 18 => "11010100", 19 => "11100110", 
    20 => "00011001", 21 => "10111110", 22 => "11010110", 23 => "00000100", 
    24 => "00100010", 25 => "00100011", 26 => "00011000", 27 => "10011000", 
    28 => "00110001", 29 => "01010001", 30 => "00100101", 31 to 32=> "11111011", 
    33 => "00011110", 34 => "11101010", 35 => "00001100", 36 => "11001001", 
    37 => "01111111", 38 => "11110011", 39 => "00111001", 40 => "11001111", 
    41 => "10110001", 42 => "01000101", 43 => "01110001", 44 => "10010111", 
    45 => "10000001", 46 => "01001110", 47 => "00001000", 48 => "00101011", 
    49 => "11001000", 50 => "10010111", 51 => "11110110", 52 => "00011010", 
    53 => "00010010", 54 => "00110110", 55 => "01101110", 56 => "01000010", 
    57 => "00101101", 58 => "00001101", 59 => "00001110", 60 => "00011011", 
    61 => "00101010", 62 => "11111011", 63 => "00110001", 64 => "01010011", 
    65 => "11111010", 66 => "00001001", 67 => "10111101", 68 => "00011011", 
    69 => "00110011", 70 => "00111001", 71 => "00010111", 72 => "01111111", 
    73 => "11110000", 74 => "10101011", 75 => "00010100", 76 => "11011000", 
    77 => "11100101", 78 => "11110100", 79 => "11000110", 80 => "00000110", 
    81 => "11100011", 82 => "10001111", 83 => "01001001", 84 to 85=> "01000010", 
    86 => "01100001", 87 => "00101011", 88 => "00111101", 89 => "00011000", 
    90 => "00110111", 91 => "00100100", 92 => "10100111", 93 => "11110000", 
    94 => "11111111", 95 => "10110011", 96 => "11010111", 97 => "00110010", 
    98 => "00000110", 99 => "11011011", 100 => "01110010", 101 => "00100011", 
    102 => "00101001", 103 => "11110101", 104 => "11010001", 105 => "11001001", 
    106 => "00010110", 107 => "01111100", 108 => "00010100", 109 => "11011110", 
    110 => "11111011", 111 => "11000110", 112 => "11010010", 113 => "10110010", 
    114 => "00000001", 115 => "11100011", 116 => "00011010", 117 => "11001010", 
    118 => "01011010", 119 => "00111000", 120 => "00000011", 121 => "01000110", 
    122 => "10111111", 123 => "00011101", 124 => "10100101", 125 => "11001101", 
    126 => "11111110", 127 => "11111100", 128 => "10100100", 129 => "01011101", 
    130 => "00100111", 131 => "01001010", 132 => "11000000", 133 => "11101011", 
    134 => "00001011", 135 => "11000100", 136 => "11101111", 137 => "00100011", 
    138 => "11011110", 139 => "01001010", 140 => "11101110", 141 => "10000001", 
    142 => "00001111", 143 => "11001111", 144 => "11010011", 145 => "00011011", 
    146 => "11010101", 147 => "11110011", 148 => "00010001", 149 => "11100001" );


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

entity gap_head_W_HEAD_Vg6b is
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

architecture arch of gap_head_W_HEAD_Vg6b is
    component gap_head_W_HEAD_Vg6b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg6b_rom_U :  component gap_head_W_HEAD_Vg6b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


