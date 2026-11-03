-- ==============================================================
-- File generated on Sun Oct 18 16:53:16 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vhdb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhdb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010000", 1 => "00000000", 2 => "11100011", 3 => "01100110", 
    4 => "00011100", 5 => "11000001", 6 => "11010010", 7 => "00000001", 
    8 => "01101010", 9 => "10110111", 10 => "01000101", 11 => "01111101", 
    12 => "11101110", 13 => "10010000", 14 => "11010011", 15 => "00100010", 
    16 => "00001001", 17 => "00110100", 18 => "11110000", 19 => "11001110", 
    20 => "00110011", 21 => "01001011", 22 => "00001010", 23 => "11000011", 
    24 => "00011110", 25 => "00010101", 26 => "11110000", 27 => "00100001", 
    28 => "00001110", 29 => "00110011", 30 => "00011000", 31 => "01000100", 
    32 => "11100000", 33 => "00001010", 34 => "00011001", 35 => "11011010", 
    36 => "00001100", 37 => "00001111", 38 => "10110000", 39 => "11111110", 
    40 => "10111000", 41 => "00001101", 42 => "00100000", 43 => "10100100", 
    44 => "10110111", 45 => "11011011", 46 => "00101100", 47 => "11111111", 
    48 => "00011100", 49 => "11110101", 50 => "11101111", 51 => "11111101", 
    52 => "11010111", 53 => "00011010", 54 => "00000110", 55 => "11000000", 
    56 => "11010101", 57 => "01010100", 58 => "10011100", 59 => "00101011", 
    60 => "00011101", 61 => "11111001", 62 => "11001100", 63 => "00010110", 
    64 => "00110011", 65 => "00010000", 66 => "10111111", 67 => "10110101", 
    68 => "00001001", 69 => "11110111", 70 => "00110110", 71 => "00001000", 
    72 => "01011110", 73 => "00000010", 74 => "11110001", 75 => "11011010", 
    76 => "01100100", 77 => "11101100", 78 => "00001110", 79 => "00011111", 
    80 => "00000101", 81 => "11010011", 82 => "00100011", 83 => "00001011", 
    84 => "11111111", 85 => "11010011", 86 => "00010110", 87 => "11110101", 
    88 => "00111000", 89 => "11110110", 90 => "11101001", 91 => "11110101", 
    92 => "00001101", 93 => "00000010", 94 => "11101011", 95 => "11000010", 
    96 => "00011100", 97 => "01000010", 98 => "00101001", 99 => "01110000", 
    100 => "11100110", 101 => "00000111", 102 => "11011000", 103 => "00100011", 
    104 => "11010011", 105 => "11001101", 106 => "00001011", 107 => "00111100", 
    108 => "11010001", 109 => "11000010", 110 => "11110100", 111 => "11100010", 
    112 => "00000011", 113 => "11100101", 114 => "11101100", 115 => "11001110", 
    116 => "11101000", 117 => "11011011", 118 => "00000111", 119 => "11011000", 
    120 => "11111011", 121 => "11101111", 122 => "10101010", 123 => "00101111", 
    124 => "00100111", 125 => "11011010", 126 => "11101110", 127 => "11111010", 
    128 => "11101000", 129 => "10100000", 130 => "10101011", 131 => "11101111", 
    132 => "00110000", 133 => "11110101", 134 => "00100101", 135 => "11101100", 
    136 => "00011001", 137 => "11101010", 138 => "00001011", 139 => "11110111", 
    140 => "10111001", 141 => "00000011", 142 => "10100111", 143 => "01010110", 
    144 => "11011111", 145 => "00011000", 146 => "00101101", 147 => "11011001", 
    148 => "01011100", 149 => "01100110" );


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

entity gap_head_W_HEAD_Vhdb is
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

architecture arch of gap_head_W_HEAD_Vhdb is
    component gap_head_W_HEAD_Vhdb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhdb_rom_U :  component gap_head_W_HEAD_Vhdb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


