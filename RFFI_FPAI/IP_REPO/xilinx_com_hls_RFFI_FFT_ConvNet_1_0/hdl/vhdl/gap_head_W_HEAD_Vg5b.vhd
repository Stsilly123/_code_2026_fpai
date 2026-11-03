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

entity gap_head_W_HEAD_Vg5b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg5b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101111", 1 => "11110111", 2 => "00001101", 3 => "10101110", 
    4 => "11100100", 5 => "00101101", 6 => "00111100", 7 => "00011001", 
    8 => "11001110", 9 => "11000001", 10 => "00111011", 11 => "11101111", 
    12 => "01000110", 13 => "10111010", 14 => "10011000", 15 => "11010110", 
    16 => "01010100", 17 => "00001101", 18 => "11001100", 19 => "00010110", 
    20 => "10100010", 21 => "11010000", 22 => "10011010", 23 => "11010001", 
    24 => "00100011", 25 to 26=> "10111010", 27 => "00100000", 28 => "00101111", 
    29 => "11111011", 30 => "00000001", 31 => "00100000", 32 => "11111100", 
    33 => "11111111", 34 => "00110011", 35 => "11100011", 36 => "00010000", 
    37 => "00011000", 38 => "11001100", 39 => "10101000", 40 => "00111110", 
    41 => "10101010", 42 => "10100100", 43 => "10111111", 44 => "01000110", 
    45 => "01001101", 46 => "11110101", 47 => "00010100", 48 => "10111111", 
    49 => "11001001", 50 => "00010010", 51 => "11100100", 52 => "00100110", 
    53 => "01000110", 54 => "11100011", 55 => "11101101", 56 => "11001010", 
    57 => "01000011", 58 => "01010100", 59 => "11010010", 60 => "11010101", 
    61 => "00010101", 62 => "11011111", 63 => "00001001", 64 => "11101001", 
    65 => "11110110", 66 => "01000001", 67 => "01011011", 68 => "11001000", 
    69 => "00010101", 70 => "10000011", 71 => "10111111", 72 => "11010010", 
    73 => "11011001", 74 => "00010101", 75 => "00101101", 76 => "11111111", 
    77 => "00011111", 78 => "00101110", 79 => "00010011", 80 => "11110111", 
    81 => "11100110", 82 => "00000100", 83 => "11101111", 84 => "00100111", 
    85 => "01000000", 86 => "11011111", 87 => "00110100", 88 => "00010000", 
    89 => "11001001", 90 => "00101101", 91 => "11111101", 92 => "11010001", 
    93 => "00110100", 94 => "01011010", 95 => "00011110", 96 => "00100110", 
    97 => "11111110", 98 => "00001000", 99 => "10111110", 100 => "11110011", 
    101 => "00001110", 102 => "00100010", 103 => "11110100", 104 => "00001111", 
    105 => "11101110", 106 => "00001110", 107 => "01010011", 108 => "00110010", 
    109 => "11101110", 110 => "11101111", 111 => "11111101", 112 => "00010111", 
    113 => "00111110", 114 => "00110110", 115 => "00010110", 116 => "10011111", 
    117 => "00101011", 118 => "11000110", 119 => "11000011", 120 => "00011101", 
    121 => "10110110", 122 => "11100001", 123 => "11111101", 124 => "01000001", 
    125 => "11001110", 126 => "00101110", 127 => "11101111", 128 => "00010011", 
    129 => "11000101", 130 => "00001011", 131 => "00010101", 132 => "11000110", 
    133 => "00101111", 134 => "11001011", 135 => "11100101", 136 => "11101000", 
    137 => "00001010", 138 => "00011101", 139 => "00000000", 140 => "11101001", 
    141 => "11000111", 142 => "00101010", 143 => "11101011", 144 => "01111111", 
    145 => "11101011", 146 => "01000011", 147 => "11110011", 148 => "11000011", 
    149 => "00101101" );


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

entity gap_head_W_HEAD_Vg5b is
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

architecture arch of gap_head_W_HEAD_Vg5b is
    component gap_head_W_HEAD_Vg5b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg5b_rom_U :  component gap_head_W_HEAD_Vg5b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


