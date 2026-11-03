-- ==============================================================
-- File generated on Sun Oct 18 16:53:18 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vh0b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vh0b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110111", 1 => "11101011", 2 => "00101010", 3 => "01111111", 
    4 => "00001100", 5 => "00000011", 6 => "10101100", 7 => "10010011", 
    8 => "01001111", 9 => "00010010", 10 => "11001101", 11 => "11000101", 
    12 => "10110101", 13 => "01100100", 14 => "00001011", 15 => "01000111", 
    16 => "11001001", 17 => "11111010", 18 => "11011000", 19 => "00110001", 
    20 => "00111111", 21 => "00010000", 22 => "00101101", 23 => "00110010", 
    24 => "11000001", 25 => "00001101", 26 => "11000100", 27 => "11010110", 
    28 => "00010001", 29 => "10111100", 30 => "00111010", 31 => "11100101", 
    32 => "01101100", 33 => "11111010", 34 => "00000100", 35 => "01010001", 
    36 => "11111001", 37 => "01001011", 38 => "10000101", 39 to 40=> "00110000", 
    41 => "00000001", 42 => "01100100", 43 => "01111100", 44 => "10111010", 
    45 => "10111011", 46 => "11100001", 47 => "00011100", 48 => "00001101", 
    49 => "11111100", 50 => "11010101", 51 => "01111010", 52 => "11011010", 
    53 => "11010111", 54 => "01000111", 55 => "01010001", 56 => "00011111", 
    57 => "11010001", 58 => "11100011", 59 => "11000101", 60 => "01001010", 
    61 => "00111100", 62 => "11101111", 63 => "11001000", 64 => "00000010", 
    65 => "11101100", 66 => "00101100", 67 => "10001111", 68 => "11110111", 
    69 => "10110001", 70 => "00110000", 71 => "00001001", 72 => "00011001", 
    73 => "11100110", 74 => "11001111", 75 => "00101101", 76 => "10110001", 
    77 => "11000101", 78 => "01101111", 79 => "00011101", 80 => "11110010", 
    81 => "00011010", 82 => "11011101", 83 => "00010000", 84 => "11001001", 
    85 => "00000010", 86 => "11111110", 87 => "00001000", 88 => "01000110", 
    89 => "00001101", 90 => "11100001", 91 => "11011101", 92 => "00110011", 
    93 => "00000000", 94 => "11110100", 95 => "00011101", 96 => "11011110", 
    97 => "01001000", 98 => "00100100", 99 => "01110100", 100 => "01001110", 
    101 => "00101100", 102 => "00101010", 103 => "00001001", 104 => "00101110", 
    105 => "00000111", 106 => "00001001", 107 => "00111001", 108 => "11111011", 
    109 => "00010010", 110 => "00110000", 111 => "00101010", 112 => "11111000", 
    113 => "11000001", 114 => "01111110", 115 => "11100100", 116 => "00000111", 
    117 => "11011011", 118 => "00101010", 119 => "00111111", 120 => "10101000", 
    121 => "00100000", 122 => "11100110", 123 => "00101101", 124 => "11100110", 
    125 => "10111101", 126 => "00000011", 127 => "11110001", 128 => "11010010", 
    129 => "01011101", 130 => "00100111", 131 => "11100010", 132 => "00011010", 
    133 => "11100011", 134 => "11110101", 135 => "00010100", 136 => "11100000", 
    137 => "00001101", 138 => "11001101", 139 => "11101011", 140 => "11110011", 
    141 => "00100111", 142 => "01001000", 143 => "10101001", 144 => "11101010", 
    145 => "11100001", 146 => "10101000", 147 => "00001111", 148 => "01100010", 
    149 => "00110100" );


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

entity gap_head_W_HEAD_Vh0b is
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

architecture arch of gap_head_W_HEAD_Vh0b is
    component gap_head_W_HEAD_Vh0b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vh0b_rom_U :  component gap_head_W_HEAD_Vh0b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


