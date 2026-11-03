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

entity gap_head_W_HEAD_Vhvb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhvb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11011001", 1 => "00110100", 2 => "10101010", 3 => "11111000", 
    4 => "00111111", 5 => "10111000", 6 => "11001011", 7 => "10111110", 
    8 => "11101110", 9 => "10100101", 10 => "00011101", 11 => "01100000", 
    12 => "11111101", 13 => "10111001", 14 => "10011101", 15 => "00000011", 
    16 => "00111000", 17 => "11100100", 18 => "11101010", 19 => "11010000", 
    20 => "00000010", 21 => "00101000", 22 => "00000001", 23 => "11000100", 
    24 => "00000110", 25 => "00100101", 26 => "10110111", 27 => "11111100", 
    28 => "00101001", 29 => "00001011", 30 => "11110000", 31 => "00110011", 
    32 => "00100001", 33 => "00011001", 34 => "10111110", 35 => "11111011", 
    36 => "00010000", 37 => "11100100", 38 => "11010000", 39 => "00111011", 
    40 => "11001111", 41 => "00001101", 42 => "11010110", 43 => "11000110", 
    44 => "11110100", 45 => "01000101", 46 => "00101100", 47 => "00100010", 
    48 => "00100011", 49 => "00100000", 50 => "11011011", 51 => "00100100", 
    52 => "11101111", 53 => "11101010", 54 => "11001111", 55 => "11011000", 
    56 => "11101001", 57 => "00111011", 58 => "11111010", 59 => "00110111", 
    60 => "11011011", 61 => "00000101", 62 => "11010011", 63 => "11010111", 
    64 => "11111011", 65 => "00111111", 66 => "11010111", 67 => "00011101", 
    68 => "11101100", 69 => "11011101", 70 => "00100110", 71 => "01101010", 
    72 => "00011101", 73 => "00101101", 74 => "00000001", 75 => "00110010", 
    76 => "11000111", 77 => "11111001", 78 => "00010001", 79 => "11111100", 
    80 => "00010111", 81 => "11010101", 82 => "11101100", 83 => "00100100", 
    84 => "11110101", 85 => "01001010", 86 => "11101111", 87 => "00100100", 
    88 => "00001111", 89 => "11110011", 90 => "11111000", 91 => "11111100", 
    92 => "00001101", 93 => "11101101", 94 => "00000101", 95 => "00001000", 
    96 => "11110010", 97 => "00110000", 98 => "00011110", 99 => "11000001", 
    100 => "11011101", 101 => "00000111", 102 => "00100011", 103 => "00111001", 
    104 => "00000011", 105 => "11101010", 106 => "00000010", 107 => "11110110", 
    108 => "00100010", 109 => "01000101", 110 => "11110111", 111 => "00010110", 
    112 => "11010110", 113 => "10111011", 114 => "11110110", 115 => "00011000", 
    116 => "11101100", 117 => "11100101", 118 => "00111100", 119 => "11011001", 
    120 => "01000111", 121 => "11100011", 122 => "11000001", 123 => "00011010", 
    124 => "00001001", 125 => "11011011", 126 => "11101010", 127 => "11010100", 
    128 => "00000011", 129 => "10101100", 130 => "11000111", 131 => "11001111", 
    132 => "00110001", 133 => "00011000", 134 => "00011011", 135 => "11001110", 
    136 => "00110111", 137 => "00010110", 138 => "00001000", 139 => "11110011", 
    140 => "00001100", 141 => "00001010", 142 => "00001000", 143 => "11101001", 
    144 => "11111111", 145 => "11110001", 146 => "00100111", 147 => "00011100", 
    148 => "01010010", 149 => "11111101" );


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

entity gap_head_W_HEAD_Vhvb is
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

architecture arch of gap_head_W_HEAD_Vhvb is
    component gap_head_W_HEAD_Vhvb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhvb_rom_U :  component gap_head_W_HEAD_Vhvb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


