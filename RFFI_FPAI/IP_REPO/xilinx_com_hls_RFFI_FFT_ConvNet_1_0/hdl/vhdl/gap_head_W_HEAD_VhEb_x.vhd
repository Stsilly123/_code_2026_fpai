-- ==============================================================
-- File generated on Sun Oct 18 16:53:17 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VhEb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhEb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01001000", 1 => "00000110", 2 => "11100011", 3 => "10101100", 
    4 => "11110001", 5 => "01010010", 6 => "11010101", 7 => "11101011", 
    8 => "11101101", 9 => "00101111", 10 => "00011111", 11 => "00011001", 
    12 => "00100010", 13 => "00001110", 14 => "00010110", 15 => "00011001", 
    16 => "10111001", 17 => "00011000", 18 => "11110011", 19 => "11001100", 
    20 => "00001010", 21 => "00101101", 22 => "00000111", 23 => "11111011", 
    24 => "00001110", 25 => "11000100", 26 => "00010110", 27 => "11101111", 
    28 => "11101110", 29 => "00101101", 30 => "00100110", 31 => "00100000", 
    32 => "10111011", 33 to 34=> "11101101", 35 => "11010000", 36 => "00001000", 
    37 => "00000010", 38 => "00101110", 39 => "11111000", 40 => "00110101", 
    41 => "00000010", 42 => "10101111", 43 => "00010011", 44 => "11110101", 
    45 => "00000100", 46 => "11111011", 47 => "10010111", 48 => "11101000", 
    49 => "11101111", 50 => "00100010", 51 => "10101010", 52 => "00001001", 
    53 => "11010010", 54 => "11111110", 55 => "11111001", 56 => "11110100", 
    57 => "00000001", 58 => "11110010", 59 => "11101001", 60 => "11110100", 
    61 => "00100100", 62 to 63=> "00100001", 64 => "11011010", 65 => "11111110", 
    66 => "11110011", 67 => "11101010", 68 => "00100000", 69 => "11110101", 
    70 => "11110010", 71 => "00000100", 72 => "11111101", 73 => "11100101", 
    74 => "00000101", 75 => "11010010", 76 => "00000000", 77 => "00000011", 
    78 => "00101110", 79 => "00011111", 80 => "11000010", 81 => "00101010", 
    82 => "00001100", 83 => "01010000", 84 => "00000001", 85 => "00000111", 
    86 => "11110000", 87 => "00010011", 88 => "11000011", 89 => "00100110", 
    90 => "11101100", 91 => "00001010", 92 => "11101001", 93 => "10111111", 
    94 => "00011011", 95 => "00111011", 96 => "11110111", 97 => "11111100", 
    98 => "00011100", 99 => "00011110", 100 => "11110001", 101 => "00010100", 
    102 => "10101110", 103 => "11101101", 104 => "00100101", 105 => "11111001", 
    106 => "11100011", 107 => "11100001", 108 => "00001100", 109 => "11001101", 
    110 => "11010010", 111 => "00100011", 112 => "11101000", 113 => "11101101", 
    114 => "11111101", 115 => "00000010", 116 => "11101010", 117 => "00000111", 
    118 => "11111101", 119 => "00101011", 120 => "11100110", 121 => "11110101", 
    122 => "00000111", 123 to 124=> "11111000", 125 => "00001101", 126 => "11101001", 
    127 => "00000101", 128 => "11111110", 129 => "00101010", 130 => "00001011", 
    131 => "11100101", 132 => "00011010", 133 => "11110010", 134 => "11111111", 
    135 => "11110111", 136 => "11010110", 137 => "01110110", 138 => "00000101", 
    139 => "00000010", 140 => "00001100", 141 => "11100101", 142 => "00011110", 
    143 => "00010010", 144 => "00110100", 145 => "11101110", 146 => "00000010", 
    147 => "11110111", 148 => "11011111", 149 => "11101010" );


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

entity gap_head_W_HEAD_VhEb_x is
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

architecture arch of gap_head_W_HEAD_VhEb_x is
    component gap_head_W_HEAD_VhEb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhEb_x_rom_U :  component gap_head_W_HEAD_VhEb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


