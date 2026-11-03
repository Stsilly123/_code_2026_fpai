-- ==============================================================
-- File generated on Sun Oct 18 16:53:14 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_V_5_rom is 
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


architecture rtl of gap_head_W_HEAD_V_5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000111", 1 => "00100111", 2 => "11001011", 3 => "00100010", 
    4 => "11110111", 5 => "11110100", 6 => "00010011", 7 => "11111110", 
    8 => "00000000", 9 => "00100110", 10 => "00100001", 11 => "00101101", 
    12 => "00001100", 13 => "11000100", 14 => "11011000", 15 => "11001100", 
    16 => "11101000", 17 => "00110111", 18 => "00001001", 19 => "00111011", 
    20 => "11110110", 21 => "00010110", 22 => "11001000", 23 => "11001100", 
    24 => "00011111", 25 => "11110110", 26 => "11111100", 27 => "00001011", 
    28 => "11010010", 29 => "00101111", 30 => "00000111", 31 => "00011101", 
    32 => "00001110", 33 => "00100111", 34 => "00010010", 35 => "11011101", 
    36 => "11110101", 37 => "00001000", 38 => "00001100", 39 => "11101001", 
    40 => "11100011", 41 to 42=> "00000101", 43 => "11010100", 44 => "11111010", 
    45 => "00000110", 46 => "11010111", 47 => "11110111", 48 => "00000000", 
    49 => "11100011", 50 => "11111111", 51 => "11110011", 52 => "00010001", 
    53 => "00010101", 54 => "11100110", 55 => "00100101", 56 => "11110111", 
    57 => "00100001", 58 => "10111001", 59 => "10101101", 60 => "11100011", 
    61 => "11110001", 62 to 63=> "11100011", 64 => "11110101", 65 => "10111001", 
    66 => "00000011", 67 => "00110011", 68 => "11111100", 69 => "11100110", 
    70 => "11111111", 71 => "11010101", 72 => "10111101", 73 => "11011011", 
    74 => "11111010", 75 => "11110110", 76 => "01100001", 77 => "00011011", 
    78 to 79=> "11110011", 80 => "00001111", 81 => "11100100", 82 => "11111000", 
    83 => "10101111", 84 => "00011010", 85 => "11000100", 86 => "00101111", 
    87 => "10110100", 88 => "11010001", 89 => "00000001", 90 => "11111110", 
    91 => "11010000", 92 => "00001111", 93 => "00011001", 94 => "00000111", 
    95 => "11010110", 96 => "11101100", 97 => "11111010", 98 => "11010001", 
    99 => "00011011", 100 => "11111101", 101 => "00011010", 102 => "11101010", 
    103 => "00000100", 104 => "00011000", 105 => "00100100", 106 => "11111001", 
    107 => "00011110", 108 => "00100101", 109 => "11011000", 110 => "00001110", 
    111 => "11110001", 112 => "11111001", 113 => "00000011", 114 => "11100010", 
    115 => "11010111", 116 => "01011000", 117 => "00010001", 118 => "00001011", 
    119 => "11000100", 120 => "00100000", 121 => "11110011", 122 => "00001001", 
    123 => "11011101", 124 => "00100111", 125 => "00101101", 126 => "00010111", 
    127 => "11000110", 128 => "11111101", 129 => "11110010", 130 => "00001110", 
    131 => "11101010", 132 => "00001100", 133 => "00001011", 134 => "11110100", 
    135 => "11100111", 136 => "11111010", 137 => "11111001", 138 => "11111111", 
    139 => "00010110", 140 => "11110001", 141 => "00010101", 142 => "11110011", 
    143 => "00000110", 144 => "11110000", 145 => "11100011", 146 => "00010100", 
    147 => "11100101", 148 => "00011010", 149 => "00100101" );


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

entity gap_head_W_HEAD_V_5 is
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

architecture arch of gap_head_W_HEAD_V_5 is
    component gap_head_W_HEAD_V_5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_5_rom_U :  component gap_head_W_HEAD_V_5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


