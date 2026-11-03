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

entity gap_head_W_HEAD_VhMb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhMb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10100110", 1 => "11111110", 2 => "11111111", 3 => "11010100", 
    4 => "00000001", 5 => "00000111", 6 => "00011101", 7 => "01010010", 
    8 => "11001111", 9 => "10110001", 10 => "01001011", 11 => "11101110", 
    12 => "00111110", 13 => "11000101", 14 to 15=> "00010010", 16 => "11101010", 
    17 => "00110011", 18 => "11111010", 19 => "00101101", 20 => "11110011", 
    21 => "00001111", 22 => "11101000", 23 => "00000000", 24 => "00100101", 
    25 => "10101001", 26 => "11101111", 27 => "00110100", 28 => "11111101", 
    29 => "00011011", 30 => "11000111", 31 => "00100010", 32 => "10110110", 
    33 => "11000111", 34 => "11011111", 35 => "10111010", 36 => "11101111", 
    37 => "00001000", 38 => "00010011", 39 => "01001001", 40 => "10111010", 
    41 => "00001001", 42 => "11100100", 43 => "11110010", 44 => "11001111", 
    45 => "11101110", 46 => "11100111", 47 => "11100001", 48 => "10000001", 
    49 => "00101011", 50 => "00011001", 51 => "10111011", 52 => "00011110", 
    53 => "11100101", 54 => "01110000", 55 => "00100001", 56 => "00010110", 
    57 => "11011110", 58 => "11101101", 59 => "11101111", 60 to 61=> "00010010", 
    62 => "11111000", 63 => "11011110", 64 => "00000100", 65 => "10100110", 
    66 => "00110000", 67 => "11101111", 68 => "00010000", 69 => "00000000", 
    70 => "11001100", 71 => "10011010", 72 => "11110011", 73 => "11011000", 
    74 => "10011110", 75 => "11100001", 76 => "00100100", 77 => "00010001", 
    78 => "11101011", 79 => "00011111", 80 => "00000001", 81 => "00110001", 
    82 => "10000001", 83 => "00101111", 84 => "11100100", 85 => "01101001", 
    86 => "11000111", 87 => "10101110", 88 => "00011100", 89 => "11100001", 
    90 => "00100101", 91 => "11100101", 92 to 93=> "00001001", 94 => "11100011", 
    95 => "00011011", 96 => "00110010", 97 => "00010010", 98 => "00001001", 
    99 => "00100000", 100 => "00011101", 101 => "00010110", 102 => "00111010", 
    103 => "11110001", 104 => "00100111", 105 => "11001110", 106 => "00010001", 
    107 => "00100010", 108 => "11101001", 109 => "11111000", 110 => "00110000", 
    111 => "00100011", 112 => "11010111", 113 => "00100101", 114 => "11001100", 
    115 => "00001000", 116 => "11100101", 117 => "00100111", 118 => "11010100", 
    119 => "11111110", 120 => "11010110", 121 => "00011110", 122 => "00000111", 
    123 => "00100100", 124 => "00101011", 125 => "00011011", 126 => "11001110", 
    127 => "11111000", 128 => "00110111", 129 => "00001000", 130 => "11011111", 
    131 => "11100001", 132 => "00100111", 133 => "11111111", 134 => "00110110", 
    135 => "11110011", 136 => "01001100", 137 => "00000101", 138 => "11110011", 
    139 => "11111101", 140 => "10000001", 141 => "00101011", 142 => "00111010", 
    143 => "00100010", 144 => "11101111", 145 => "00000001", 146 => "01100001", 
    147 => "11001111", 148 => "11100011", 149 => "01010000" );


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

entity gap_head_W_HEAD_VhMb_x is
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

architecture arch of gap_head_W_HEAD_VhMb_x is
    component gap_head_W_HEAD_VhMb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhMb_x_rom_U :  component gap_head_W_HEAD_VhMb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


