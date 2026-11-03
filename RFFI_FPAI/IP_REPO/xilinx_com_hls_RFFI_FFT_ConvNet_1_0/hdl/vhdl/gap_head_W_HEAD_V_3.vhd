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

entity gap_head_W_HEAD_V_3_rom is 
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


architecture rtl of gap_head_W_HEAD_V_3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010011", 1 => "10110111", 2 => "10010101", 3 => "11000010", 
    4 => "00100000", 5 => "11101001", 6 => "10011011", 7 => "11111110", 
    8 => "11001000", 9 => "11101111", 10 => "11101000", 11 => "00010001", 
    12 => "00101000", 13 => "00001000", 14 => "10100100", 15 => "00001000", 
    16 => "11100101", 17 => "00101110", 18 => "00001110", 19 => "00010001", 
    20 => "00111100", 21 => "00011011", 22 => "10000100", 23 => "11100110", 
    24 => "00011110", 25 => "00001011", 26 => "10101010", 27 => "11010010", 
    28 => "00011000", 29 => "00110110", 30 => "11001110", 31 => "00000010", 
    32 => "11011010", 33 => "00101001", 34 => "11101000", 35 => "11011000", 
    36 => "01000011", 37 => "11001100", 38 => "00100110", 39 => "11001000", 
    40 => "11011010", 41 => "00110100", 42 => "00011111", 43 => "11101011", 
    44 => "11111100", 45 => "01000111", 46 => "11111011", 47 => "11101001", 
    48 => "00011110", 49 => "10100011", 50 => "00001111", 51 => "10011011", 
    52 => "00011011", 53 => "00000101", 54 => "00000111", 55 => "00100110", 
    56 => "00011111", 57 => "00000111", 58 => "11101111", 59 => "11110011", 
    60 => "00100100", 61 => "11111011", 62 => "11000001", 63 => "00001001", 
    64 => "01001101", 65 => "00100100", 66 => "00001100", 67 => "00011001", 
    68 => "00010101", 69 => "10111100", 70 => "00001111", 71 => "01100110", 
    72 => "11011101", 73 => "00010010", 74 => "11110010", 75 => "11010000", 
    76 => "00001010", 77 => "11101011", 78 => "11111100", 79 => "00001111", 
    80 => "00010010", 81 => "00011101", 82 => "11011001", 83 => "00011010", 
    84 => "11110010", 85 => "00010111", 86 => "11111000", 87 => "10110010", 
    88 => "01001101", 89 => "00110111", 90 => "11111111", 91 => "11010100", 
    92 => "00100110", 93 => "00010011", 94 => "11110010", 95 => "00111101", 
    96 => "11011000", 97 => "10010100", 98 => "00001110", 99 => "11010111", 
    100 => "11010011", 101 => "11110100", 102 => "00001101", 103 => "01000001", 
    104 => "00011011", 105 => "00001110", 106 => "10110100", 107 => "11001011", 
    108 => "00110001", 109 => "11001101", 110 => "00001011", 111 => "00101010", 
    112 => "11111111", 113 => "11100001", 114 => "11010110", 115 => "00010001", 
    116 => "00101101", 117 => "00110111", 118 => "00011001", 119 => "11011010", 
    120 => "00110010", 121 => "11001001", 122 => "00010111", 123 => "01111010", 
    124 => "10101110", 125 => "11101111", 126 => "11111010", 127 => "00110110", 
    128 => "00100011", 129 => "11011011", 130 => "10111111", 131 => "00011010", 
    132 => "00110010", 133 => "00000100", 134 => "10111100", 135 => "11000100", 
    136 => "01001101", 137 => "00010100", 138 => "11001001", 139 => "11011001", 
    140 => "00110010", 141 => "00010001", 142 => "00001011", 143 => "00001100", 
    144 => "00010001", 145 => "10111111", 146 => "10110010", 147 => "11101101", 
    148 => "00110110", 149 => "11111010" );


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

entity gap_head_W_HEAD_V_3 is
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

architecture arch of gap_head_W_HEAD_V_3 is
    component gap_head_W_HEAD_V_3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_3_rom_U :  component gap_head_W_HEAD_V_3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


