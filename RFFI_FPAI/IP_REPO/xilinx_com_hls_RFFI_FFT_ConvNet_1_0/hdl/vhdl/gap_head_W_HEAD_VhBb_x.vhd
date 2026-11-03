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

entity gap_head_W_HEAD_VhBb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhBb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01100100", 1 => "00100010", 2 => "00011000", 3 => "11011000", 
    4 => "01110101", 5 => "11101101", 6 => "10011001", 7 => "11100010", 
    8 => "10110110", 9 => "00010001", 10 => "00100110", 11 => "10110110", 
    12 => "00111010", 13 => "01011100", 14 => "11000110", 15 => "11000101", 
    16 => "00101000", 17 => "11000011", 18 => "00000101", 19 => "00011010", 
    20 => "01010011", 21 => "11001110", 22 => "11000010", 23 => "00000010", 
    24 => "00110110", 25 => "00101001", 26 => "11011101", 27 => "00001010", 
    28 => "00010000", 29 => "01001010", 30 => "11110010", 31 => "00101101", 
    32 => "11111101", 33 => "00011000", 34 => "00010100", 35 => "00100101", 
    36 => "11111110", 37 => "11010111", 38 => "00001011", 39 => "11111100", 
    40 => "00110000", 41 => "00100011", 42 => "10110110", 43 => "01111111", 
    44 => "11010000", 45 => "11000000", 46 => "00001101", 47 => "00001010", 
    48 => "00100101", 49 => "11111110", 50 => "11011111", 51 => "00011001", 
    52 => "00011000", 53 => "11000000", 54 => "11011111", 55 => "10111101", 
    56 => "10110001", 57 => "00011100", 58 => "11100110", 59 => "11000111", 
    60 => "00100000", 61 => "00011010", 62 => "11100011", 63 => "11110101", 
    64 => "01101111", 65 => "00000101", 66 => "00000000", 67 => "11111100", 
    68 => "11110010", 69 => "00011110", 70 => "00001011", 71 => "00110001", 
    72 => "11101001", 73 => "10010010", 74 => "11100000", 75 => "00001111", 
    76 => "11000111", 77 => "00011110", 78 => "11000000", 79 => "00011101", 
    80 => "11000101", 81 => "00010100", 82 => "11011111", 83 => "00100000", 
    84 => "00101001", 85 => "10100111", 86 => "10100110", 87 => "11110001", 
    88 => "10001100", 89 => "01000010", 90 => "00001101", 91 => "00111000", 
    92 => "01011100", 93 => "00010010", 94 => "11101010", 95 => "00111101", 
    96 => "11011100", 97 => "11100100", 98 => "11000001", 99 => "11011111", 
    100 => "01000000", 101 => "00000001", 102 => "00011001", 103 => "00100010", 
    104 => "01000101", 105 => "00110011", 106 => "11101001", 107 => "00001011", 
    108 => "10010001", 109 => "01000110", 110 => "11101100", 111 => "10111101", 
    112 => "11010100", 113 => "10100011", 114 => "00011110", 115 => "00001101", 
    116 => "00001011", 117 => "11111011", 118 => "11100010", 119 => "01010011", 
    120 => "00010111", 121 => "00111101", 122 => "11010000", 123 => "01111001", 
    124 => "01100111", 125 => "10111010", 126 => "01000011", 127 => "00110011", 
    128 => "11111000", 129 => "01100101", 130 => "01010100", 131 => "11100010", 
    132 => "00110000", 133 => "00011101", 134 => "00010110", 135 => "00001011", 
    136 => "11110001", 137 => "11101110", 138 => "11101000", 139 => "00100110", 
    140 => "11100110", 141 => "11110111", 142 => "00111001", 143 => "10111100", 
    144 => "00011010", 145 => "11111111", 146 => "10101001", 147 => "00110100", 
    148 => "00110010", 149 => "01101010" );


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

entity gap_head_W_HEAD_VhBb_x is
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

architecture arch of gap_head_W_HEAD_VhBb_x is
    component gap_head_W_HEAD_VhBb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhBb_x_rom_U :  component gap_head_W_HEAD_VhBb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


