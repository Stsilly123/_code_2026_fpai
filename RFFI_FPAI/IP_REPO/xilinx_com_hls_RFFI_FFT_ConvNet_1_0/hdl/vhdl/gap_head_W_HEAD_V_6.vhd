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

entity gap_head_W_HEAD_V_6_rom is 
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


architecture rtl of gap_head_W_HEAD_V_6_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00101111", 1 => "00110001", 2 => "01010100", 3 => "00100110", 
    4 => "11010101", 5 => "11011011", 6 => "01010000", 7 => "00000110", 
    8 => "00010111", 9 => "01000101", 10 => "10100110", 11 => "11101000", 
    12 => "11101111", 13 => "01001110", 14 => "00111000", 15 => "11000001", 
    16 => "00011001", 17 => "11011101", 18 => "00000000", 19 => "00000101", 
    20 => "11011110", 21 => "11101110", 22 => "00101110", 23 => "00100111", 
    24 => "11101011", 25 => "11010111", 26 => "00111100", 27 => "11100101", 
    28 => "11010010", 29 => "11101100", 30 => "11111010", 31 => "00100000", 
    32 => "00010001", 33 => "11010000", 34 => "00110100", 35 => "00100101", 
    36 => "11001010", 37 => "00010010", 38 => "11110100", 39 => "11001011", 
    40 => "00110001", 41 => "11110111", 42 => "11100001", 43 => "00110010", 
    44 => "11011111", 45 => "11001000", 46 => "00100100", 47 => "00010011", 
    48 => "11111010", 49 => "00001010", 50 => "00100000", 51 => "00100110", 
    52 => "11111010", 53 => "11101110", 54 => "11010101", 55 => "11011000", 
    56 => "10101000", 57 => "01010110", 58 => "00011011", 59 => "00011101", 
    60 => "11011110", 61 => "11101110", 62 => "00011010", 63 => "00011100", 
    64 => "10000010", 65 => "00110010", 66 => "00001010", 67 => "11011001", 
    68 => "11011110", 69 => "00000011", 70 => "11001111", 71 => "10011011", 
    72 => "01000100", 73 => "00001111", 74 => "00100000", 75 => "00010111", 
    76 => "00101010", 77 => "00010010", 78 => "10111110", 79 => "11011010", 
    80 => "00010010", 81 => "00000110", 82 => "00010001", 83 => "00100110", 
    84 => "00010011", 85 => "11110110", 86 => "11110010", 87 => "01100000", 
    88 => "10110000", 89 => "11011101", 90 => "11110010", 91 => "00000101", 
    92 => "11110000", 93 => "00001000", 94 => "00000110", 95 => "11011000", 
    96 => "00100001", 97 => "00010001", 98 => "11101010", 99 => "11110001", 
    100 => "00111000", 101 => "11001011", 102 => "11010010", 103 => "10111110", 
    104 => "11101101", 105 => "00001000", 106 => "00011011", 107 => "11010110", 
    108 => "11000010", 109 => "00111011", 110 => "01111111", 111 => "11000011", 
    112 => "00001101", 113 => "00000111", 114 => "00101001", 115 => "00011000", 
    116 => "11000101", 117 => "11111011", 118 => "11000111", 119 => "00110011", 
    120 => "00001101", 121 => "00001001", 122 => "11111010", 123 => "10101111", 
    124 => "11101110", 125 => "00000110", 126 => "01011000", 127 => "00000001", 
    128 => "00010011", 129 => "01001101", 130 => "01011110", 131 => "11111000", 
    132 => "11010001", 133 => "00001100", 134 => "11011000", 135 => "00110110", 
    136 => "00011011", 137 => "11001011", 138 => "11011110", 139 => "00110010", 
    140 => "00100100", 141 => "11101011", 142 => "00110011", 143 => "00010101", 
    144 => "01000110", 145 => "00101110", 146 => "10110100", 147 => "00011111", 
    148 => "11010000", 149 => "00001110" );


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

entity gap_head_W_HEAD_V_6 is
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

architecture arch of gap_head_W_HEAD_V_6 is
    component gap_head_W_HEAD_V_6_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_6_rom_U :  component gap_head_W_HEAD_V_6_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


