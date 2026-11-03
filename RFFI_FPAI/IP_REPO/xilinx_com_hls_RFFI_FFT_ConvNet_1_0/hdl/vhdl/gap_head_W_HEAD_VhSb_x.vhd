-- ==============================================================
-- File generated on Sun Oct 18 16:53:17 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VhSb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhSb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000100", 1 => "01010000", 2 => "00001010", 3 => "11111011", 
    4 => "11010001", 5 => "01000111", 6 => "00110100", 7 => "11100100", 
    8 => "11111101", 9 => "11100110", 10 => "11100011", 11 => "01010011", 
    12 => "00001110", 13 => "01000001", 14 => "00011011", 15 => "00110000", 
    16 => "11000110", 17 => "11011000", 18 => "01000110", 19 => "11100011", 
    20 => "00001011", 21 => "01001001", 22 => "11101010", 23 => "00011110", 
    24 => "00011010", 25 => "11100010", 26 => "11110111", 27 => "11100100", 
    28 => "11111001", 29 => "11100100", 30 => "11001110", 31 => "00110001", 
    32 => "11111111", 33 => "11001101", 34 => "11110100", 35 => "01000100", 
    36 => "11011010", 37 => "00000000", 38 => "01001101", 39 => "01010101", 
    40 => "10000110", 41 => "11111111", 42 => "10111001", 43 => "01001011", 
    44 => "11000111", 45 => "00111010", 46 => "11110110", 47 => "10111011", 
    48 => "10100010", 49 => "01010011", 50 => "00010100", 51 => "10110110", 
    52 => "11101011", 53 => "11101000", 54 => "11011101", 55 => "11010000", 
    56 => "10110100", 57 => "00111101", 58 => "11101100", 59 => "00010010", 
    60 => "11001111", 61 => "00001100", 62 => "11001101", 63 => "11010111", 
    64 => "10010011", 65 => "00110111", 66 => "11101010", 67 => "00110101", 
    68 => "00100001", 69 => "00011101", 70 => "10110101", 71 => "11101110", 
    72 => "00001110", 73 => "11110101", 74 => "11111100", 75 => "11111011", 
    76 => "00100111", 77 => "11100100", 78 => "11011010", 79 => "00010111", 
    80 => "00111011", 81 => "11110111", 82 => "10001111", 83 => "00101110", 
    84 => "00000111", 85 => "00110000", 86 => "11111011", 87 => "00011111", 
    88 => "00000111", 89 => "00000101", 90 => "00100110", 91 => "00100111", 
    92 => "11101101", 93 => "00000011", 94 => "11111110", 95 => "01011100", 
    96 => "11011000", 97 => "11100010", 98 => "00100001", 99 => "01010001", 
    100 => "00011000", 101 => "11001001", 102 => "00100101", 103 => "00101100", 
    104 => "00001111", 105 => "10110011", 106 => "11101011", 107 => "11011001", 
    108 => "00101000", 109 => "01111000", 110 => "00001000", 111 => "00011101", 
    112 => "11001011", 113 => "10010110", 114 => "11000110", 115 => "11111011", 
    116 => "10111111", 117 => "11001100", 118 => "10111001", 119 => "00011100", 
    120 => "11111100", 121 => "01001000", 122 => "00001000", 123 => "11111001", 
    124 => "00010100", 125 => "00100111", 126 => "00100101", 127 => "11011101", 
    128 => "11110000", 129 => "00101101", 130 => "00100001", 131 => "11010001", 
    132 => "00000101", 133 => "00000011", 134 => "00110000", 135 => "11100110", 
    136 => "00010001", 137 => "00010111", 138 => "00010110", 139 => "00101111", 
    140 => "11001110", 141 => "11101011", 142 => "00001000", 143 => "00011100", 
    144 => "00001110", 145 => "11010011", 146 => "00000011", 147 => "00101011", 
    148 => "00101101", 149 => "11110101" );


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

entity gap_head_W_HEAD_VhSb_x is
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

architecture arch of gap_head_W_HEAD_VhSb_x is
    component gap_head_W_HEAD_VhSb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhSb_x_rom_U :  component gap_head_W_HEAD_VhSb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


