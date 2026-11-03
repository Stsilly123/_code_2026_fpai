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

entity gap_head_W_HEAD_VhYb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhYb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110000", 1 => "11111010", 2 => "00000100", 3 => "11000110", 
    4 => "11101001", 5 => "00011000", 6 => "00110101", 7 => "00100010", 
    8 => "11110010", 9 => "01001100", 10 => "01000101", 11 => "11011111", 
    12 => "11110111", 13 => "00011010", 14 => "00011001", 15 => "11000100", 
    16 => "00011011", 17 => "11010100", 18 => "11100100", 19 => "11100111", 
    20 => "00100101", 21 => "11110001", 22 => "00011001", 23 => "11011101", 
    24 => "00010010", 25 => "11111110", 26 => "00011001", 27 => "00001011", 
    28 => "00100011", 29 => "01000101", 30 => "01100100", 31 => "10011001", 
    32 => "11111001", 33 => "00100001", 34 => "00011010", 35 => "11111011", 
    36 => "00001101", 37 => "00001110", 38 => "11010011", 39 => "11010111", 
    40 => "11011011", 41 => "00100001", 42 => "00000100", 43 => "11001110", 
    44 => "11011101", 45 => "10111010", 46 => "00111111", 47 => "11110110", 
    48 => "01010101", 49 => "11000011", 50 => "00111101", 51 => "11111101", 
    52 => "01001101", 53 => "11111010", 54 => "00011101", 55 => "00111001", 
    56 => "00010011", 57 => "11110101", 58 => "00000100", 59 => "11101111", 
    60 => "01001011", 61 => "00100100", 62 => "01111111", 63 => "00010111", 
    64 => "11010110", 65 => "11101111", 66 => "00010010", 67 => "10101111", 
    68 => "00010010", 69 => "10101111", 70 => "00000110", 71 => "00111010", 
    72 => "11001010", 73 => "11110110", 74 => "11011101", 75 => "11100010", 
    76 => "00010110", 77 => "00011000", 78 => "11101111", 79 => "11011011", 
    80 => "11110011", 81 => "11000111", 82 => "11001000", 83 => "11110001", 
    84 => "00011101", 85 => "10000111", 86 => "01000000", 87 => "11111110", 
    88 => "11000011", 89 => "00010001", 90 => "10110110", 91 => "10100000", 
    92 => "11111101", 93 => "11110001", 94 => "11101000", 95 => "11110110", 
    96 => "00001110", 97 => "11111001", 98 => "11101011", 99 => "00011110", 
    100 => "00000100", 101 => "11011111", 102 => "11110100", 103 => "00100110", 
    104 => "11011101", 105 => "11110111", 106 => "00001010", 107 => "11011110", 
    108 => "00101111", 109 => "11001101", 110 => "00110010", 111 => "10011000", 
    112 => "11100001", 113 => "11101111", 114 => "01010001", 115 => "11101110", 
    116 => "00101110", 117 => "00011000", 118 => "11000111", 119 => "00010111", 
    120 => "10101100", 121 => "11011011", 122 => "11111001", 123 => "00000100", 
    124 => "01000001", 125 => "00000011", 126 => "01101110", 127 => "01001011", 
    128 => "10100110", 129 => "11100001", 130 => "01000010", 131 => "00010110", 
    132 => "00000101", 133 => "10111101", 134 => "11110101", 135 => "01000000", 
    136 => "10010111", 137 => "11101000", 138 => "11011110", 139 => "00010110", 
    140 => "11111101", 141 => "11110101", 142 => "01000000", 143 => "11010101", 
    144 => "11011111", 145 => "00110100", 146 => "11100111", 147 => "00010010", 
    148 => "01001011", 149 => "01000011" );


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

entity gap_head_W_HEAD_VhYb_x is
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

architecture arch of gap_head_W_HEAD_VhYb_x is
    component gap_head_W_HEAD_VhYb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhYb_x_rom_U :  component gap_head_W_HEAD_VhYb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


