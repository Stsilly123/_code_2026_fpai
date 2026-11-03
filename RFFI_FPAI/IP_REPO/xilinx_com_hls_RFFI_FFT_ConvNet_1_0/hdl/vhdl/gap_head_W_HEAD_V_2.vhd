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

entity gap_head_W_HEAD_V_2_rom is 
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


architecture rtl of gap_head_W_HEAD_V_2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001110", 1 => "11011111", 2 => "11010101", 3 => "11110010", 
    4 => "10011101", 5 => "11001001", 6 => "11100111", 7 => "01001100", 
    8 => "11111010", 9 => "00101110", 10 => "00000001", 11 => "11100010", 
    12 => "10100110", 13 => "11110111", 14 => "00101101", 15 => "00010111", 
    16 => "10111001", 17 => "11110101", 18 => "11010010", 19 => "00101001", 
    20 => "01010101", 21 => "11000101", 22 => "11000100", 23 => "11110001", 
    24 => "00101010", 25 => "11000010", 26 => "11100100", 27 => "00000011", 
    28 => "11100101", 29 => "00001011", 30 => "00000010", 31 => "11111111", 
    32 => "11100110", 33 => "00011100", 34 => "11010111", 35 => "10101100", 
    36 => "00100000", 37 => "11110110", 38 => "11010110", 39 => "00010101", 
    40 => "11101101", 41 => "01011010", 42 => "11110011", 43 => "11000100", 
    44 => "11101000", 45 => "00001010", 46 => "11110010", 47 => "00010000", 
    48 => "00000101", 49 => "01000111", 50 => "00100000", 51 => "00000000", 
    52 => "10111010", 53 => "00111101", 54 => "00111000", 55 => "01000100", 
    56 => "01100101", 57 => "00011010", 58 => "00110001", 59 => "11101011", 
    60 => "01000000", 61 => "00101110", 62 => "01011100", 63 => "00100011", 
    64 => "11011001", 65 => "11100000", 66 => "01111001", 67 => "11110100", 
    68 => "00111100", 69 => "00110010", 70 => "00100001", 71 => "00011010", 
    72 => "01010001", 73 => "00110010", 74 => "00011000", 75 => "11000011", 
    76 => "00010001", 77 => "10110100", 78 => "11111110", 79 => "11110000", 
    80 => "00000011", 81 => "00001001", 82 => "11010001", 83 => "00011101", 
    84 => "11101000", 85 => "11110100", 86 => "01100000", 87 => "00001001", 
    88 => "11111010", 89 => "00001110", 90 => "11100010", 91 => "11100100", 
    92 => "11100011", 93 => "11111010", 94 => "11110010", 95 => "01011110", 
    96 => "00100011", 97 => "00001001", 98 => "11010011", 99 => "11111110", 
    100 => "11001010", 101 => "00001010", 102 => "10010010", 103 => "00111111", 
    104 => "11010001", 105 => "00110001", 106 => "11101110", 107 => "11111011", 
    108 => "00000010", 109 => "00100110", 110 => "00011011", 111 => "11111100", 
    112 => "11111101", 113 => "01001101", 114 => "11001101", 115 => "00110011", 
    116 => "01000100", 117 => "00010001", 118 => "11101010", 119 => "11100000", 
    120 => "10000001", 121 => "00110100", 122 => "11110111", 123 => "00111110", 
    124 => "11110001", 125 => "11000100", 126 => "11000010", 127 => "00100010", 
    128 => "01001011", 129 => "11100100", 130 => "10111010", 131 => "00100111", 
    132 => "00010011", 133 => "11010110", 134 => "00000010", 135 => "11101111", 
    136 => "00010011", 137 => "11111110", 138 => "00010011", 139 => "11010111", 
    140 => "11101010", 141 => "11101110", 142 => "00001101", 143 => "11110011", 
    144 => "11111100", 145 => "00000111", 146 => "00101000", 147 => "00011010", 
    148 => "11101010", 149 => "00000101" );


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

entity gap_head_W_HEAD_V_2 is
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

architecture arch of gap_head_W_HEAD_V_2 is
    component gap_head_W_HEAD_V_2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_2_rom_U :  component gap_head_W_HEAD_V_2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


