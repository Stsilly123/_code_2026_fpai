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

entity gap_head_W_HEAD_Vg4b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg4b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001010", 1 => "11101110", 2 => "11010110", 3 => "11011001", 
    4 => "00111011", 5 => "01001100", 6 => "11110000", 7 => "11000101", 
    8 => "00100011", 9 => "10100110", 10 => "11110110", 11 => "00100000", 
    12 => "00001001", 13 => "11011001", 14 => "10000001", 15 => "00001000", 
    16 => "00101100", 17 => "11111001", 18 => "10101101", 19 => "01000101", 
    20 => "00000110", 21 => "00010001", 22 => "10001101", 23 => "10010011", 
    24 => "00011110", 25 => "01010001", 26 => "10011010", 27 => "11010110", 
    28 => "00110100", 29 => "00100001", 30 => "10110111", 31 => "11100010", 
    32 => "11011101", 33 => "11110100", 34 => "00001101", 35 => "10011111", 
    36 => "00001100", 37 => "11110111", 38 => "11111010", 39 => "00010010", 
    40 => "00100101", 41 => "11010111", 42 => "00000011", 43 => "00000110", 
    44 => "00001101", 45 => "00011011", 46 => "11101100", 47 => "00111100", 
    48 => "11110000", 49 => "11111110", 50 => "00000110", 51 => "11101010", 
    52 => "00011101", 53 => "11110111", 54 => "11111111", 55 => "11011011", 
    56 => "00000010", 57 => "00111110", 58 => "00001110", 59 => "11111010", 
    60 => "00000000", 61 => "11101101", 62 => "11111100", 63 => "11000001", 
    64 => "11011000", 65 => "11111001", 66 => "11010011", 67 => "11111011", 
    68 => "00001000", 69 => "00000111", 70 => "11100011", 71 => "01001100", 
    72 => "11100010", 73 => "11111110", 74 => "00000010", 75 => "11101111", 
    76 => "00011100", 77 => "00100110", 78 => "00000100", 79 to 80=> "00000110", 
    81 => "00001001", 82 => "00010000", 83 => "10110111", 84 => "00101001", 
    85 => "00000011", 86 => "11111011", 87 => "00111111", 88 => "00010000", 
    89 => "01000100", 90 => "11111111", 91 => "00010000", 92 => "00010010", 
    93 => "11111011", 94 => "00010111", 95 => "00001100", 96 => "11100101", 
    97 => "11101011", 98 => "00000000", 99 => "01001111", 100 => "00100111", 
    101 => "11111101", 102 => "11111000", 103 => "00011011", 104 => "11101010", 
    105 => "11110111", 106 => "00010101", 107 => "00101011", 108 => "00111100", 
    109 => "00110110", 110 => "00001010", 111 => "00000111", 112 => "11100111", 
    113 => "11111011", 114 => "00111111", 115 => "11110111", 116 => "00000110", 
    117 => "00111001", 118 => "00010101", 119 => "11010111", 120 => "10011011", 
    121 => "00010100", 122 => "10101111", 123 => "01001101", 124 => "11111110", 
    125 => "10011110", 126 => "11101110", 127 => "11010000", 128 => "00100010", 
    129 => "00001000", 130 => "11111111", 131 => "11101111", 132 => "11110010", 
    133 => "00101011", 134 => "11001010", 135 => "11010100", 136 => "11101111", 
    137 => "00001100", 138 => "11111101", 139 => "00000011", 140 => "00011111", 
    141 => "00000100", 142 => "00000110", 143 => "00001010", 144 => "11010000", 
    145 => "11101011", 146 => "10101001", 147 => "00100101", 148 => "00000100", 
    149 => "00011011" );


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

entity gap_head_W_HEAD_Vg4b is
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

architecture arch of gap_head_W_HEAD_Vg4b is
    component gap_head_W_HEAD_Vg4b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg4b_rom_U :  component gap_head_W_HEAD_Vg4b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


