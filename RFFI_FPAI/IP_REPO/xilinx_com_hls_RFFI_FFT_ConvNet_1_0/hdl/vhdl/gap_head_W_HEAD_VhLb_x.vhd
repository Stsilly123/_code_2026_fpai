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

entity gap_head_W_HEAD_VhLb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhLb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100001", 1 => "01111101", 2 => "11110111", 3 => "11011101", 
    4 => "11100110", 5 => "11111010", 6 => "01000011", 7 => "00011101", 
    8 => "00001010", 9 => "01011011", 10 => "00000110", 11 => "11010101", 
    12 => "11101101", 13 => "01000101", 14 => "00100110", 15 => "11001011", 
    16 => "11100111", 17 => "00011101", 18 => "11011111", 19 => "00100111", 
    20 => "00000101", 21 => "10111110", 22 => "11100110", 23 => "00110100", 
    24 => "00001011", 25 => "11111001", 26 => "00000110", 27 => "11101000", 
    28 => "11011110", 29 => "00001000", 30 => "10110000", 31 => "11101000", 
    32 => "11011110", 33 => "11010011", 34 => "00111000", 35 => "11100001", 
    36 => "11111011", 37 => "00000111", 38 => "01000010", 39 => "00000010", 
    40 => "00011011", 41 => "11011111", 42 => "01010001", 43 => "00111101", 
    44 => "10101010", 45 => "11010110", 46 => "01000111", 47 => "11111011", 
    48 => "00100111", 49 => "11011111", 50 => "11111001", 51 => "10111111", 
    52 => "11111001", 53 => "11100111", 54 => "01000001", 55 => "01010101", 
    56 => "11100100", 57 => "11111100", 58 => "00000010", 59 => "00000000", 
    60 => "01100011", 61 => "00010110", 62 => "11101101", 63 => "11111011", 
    64 => "00010111", 65 => "11010001", 66 => "11111111", 67 => "11010010", 
    68 => "00010001", 69 => "10101011", 70 => "11011001", 71 => "11100101", 
    72 => "00001000", 73 => "00100011", 74 => "10000001", 75 => "00010010", 
    76 => "00101001", 77 => "11011101", 78 => "11100110", 79 => "11100001", 
    80 => "11100011", 81 => "00100001", 82 => "00001100", 83 => "00000111", 
    84 => "01111111", 85 => "00011011", 86 => "11111111", 87 => "00001010", 
    88 => "01011001", 89 => "00010100", 90 => "00010110", 91 => "11011100", 
    92 to 93=> "11011110", 94 => "00001000", 95 => "11011011", 96 => "00001010", 
    97 => "11111010", 98 => "11111110", 99 => "00010001", 100 => "01111111", 
    101 => "00000010", 102 => "11101110", 103 => "11110110", 104 => "11101000", 
    105 => "11110001", 106 => "11111011", 107 => "11100101", 108 => "11100100", 
    109 => "00000110", 110 => "01001100", 111 => "11100011", 112 => "10101111", 
    113 => "00101001", 114 => "00100001", 115 => "11110000", 116 => "11110011", 
    117 => "00011000", 118 => "11011110", 119 => "00001111", 120 => "11010100", 
    121 => "00001110", 122 => "00110000", 123 => "01000100", 124 => "11000100", 
    125 => "11010101", 126 => "00100101", 127 => "01000000", 128 => "00100110", 
    129 => "01111111", 130 => "00101101", 131 => "00010111", 132 => "11010111", 
    133 => "11100111", 134 => "00010010", 135 => "00011000", 136 => "00010110", 
    137 => "11100110", 138 => "11010000", 139 => "01000101", 140 => "00001011", 
    141 => "00010010", 142 => "01100100", 143 => "11011100", 144 => "11111110", 
    145 => "00001100", 146 => "11011111", 147 => "00000011", 148 => "11011001", 
    149 => "11100111" );


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

entity gap_head_W_HEAD_VhLb_x is
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

architecture arch of gap_head_W_HEAD_VhLb_x is
    component gap_head_W_HEAD_VhLb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhLb_x_rom_U :  component gap_head_W_HEAD_VhLb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


