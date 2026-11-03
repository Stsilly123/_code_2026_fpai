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

entity gap_head_W_HEAD_Vg7b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg7b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110110", 1 => "00100000", 2 => "10101101", 3 => "11001001", 
    4 => "00101101", 5 => "00101100", 6 => "00101010", 7 => "11100100", 
    8 => "11110101", 9 => "11011101", 10 => "00000100", 11 => "00011011", 
    12 => "00000100", 13 => "00000011", 14 => "11100011", 15 => "11001110", 
    16 => "00011100", 17 => "01111111", 18 => "00100100", 19 => "00000000", 
    20 => "11101000", 21 => "00000000", 22 => "10110101", 23 => "11100011", 
    24 => "00010011", 25 => "11110001", 26 => "11110011", 27 => "11101001", 
    28 => "00000011", 29 => "00001111", 30 => "11111110", 31 => "11110001", 
    32 => "11010100", 33 => "00011000", 34 => "11100000", 35 => "11010101", 
    36 => "11101111", 37 => "11111010", 38 => "11001010", 39 => "01001111", 
    40 => "00000011", 41 => "00110101", 42 => "11011101", 43 => "00001111", 
    44 => "00011111", 45 => "00100100", 46 => "00001011", 47 => "11011100", 
    48 => "11110011", 49 => "00101001", 50 => "11011010", 51 => "00000101", 
    52 => "10110000", 53 => "11001111", 54 => "10110000", 55 => "10111000", 
    56 => "00110110", 57 => "00101011", 58 => "10111100", 59 => "01001110", 
    60 => "11011110", 61 => "11100110", 62 => "10110010", 63 => "00111000", 
    64 => "00010101", 65 => "11101000", 66 => "00001011", 67 => "11101000", 
    68 => "00110000", 69 => "11011011", 70 => "01000101", 71 => "11110111", 
    72 => "00010111", 73 => "00111110", 74 => "00000100", 75 => "00111001", 
    76 => "00011010", 77 => "11101110", 78 => "00111001", 79 => "11101101", 
    80 => "00101011", 81 => "11100011", 82 => "00001010", 83 => "01100001", 
    84 => "00001011", 85 => "10010101", 86 => "00000101", 87 => "00000001", 
    88 => "00111000", 89 => "01011010", 90 => "00011100", 91 => "00101010", 
    92 => "11000111", 93 => "00001111", 94 => "11111100", 95 => "10101001", 
    96 => "11000100", 97 => "00110000", 98 => "11101011", 99 => "11010010", 
    100 => "00011101", 101 => "11111010", 102 => "00100001", 103 => "00011111", 
    104 => "11010001", 105 => "00011010", 106 => "11010000", 107 => "01001110", 
    108 => "00000000", 109 => "00001001", 110 => "10100011", 111 => "11100100", 
    112 => "11101000", 113 => "10111010", 114 => "00101100", 115 => "11011011", 
    116 => "11111001", 117 => "11001000", 118 => "00101110", 119 => "00101001", 
    120 => "01000010", 121 => "00100000", 122 => "11110101", 123 => "11101101", 
    124 => "00011000", 125 => "00010000", 126 => "11100111", 127 => "11010011", 
    128 => "01111111", 129 => "00010000", 130 => "00000011", 131 => "11010011", 
    132 => "00101000", 133 => "00011100", 134 => "00111100", 135 => "10111110", 
    136 => "01101100", 137 => "11001000", 138 => "11011100", 139 => "00001011", 
    140 => "11100111", 141 => "11011001", 142 => "11011010", 143 => "11011001", 
    144 => "10111010", 145 => "11101111", 146 => "01010001", 147 => "00010110", 
    148 => "00001011", 149 => "01001010" );


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

entity gap_head_W_HEAD_Vg7b is
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

architecture arch of gap_head_W_HEAD_Vg7b is
    component gap_head_W_HEAD_Vg7b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg7b_rom_U :  component gap_head_W_HEAD_Vg7b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


