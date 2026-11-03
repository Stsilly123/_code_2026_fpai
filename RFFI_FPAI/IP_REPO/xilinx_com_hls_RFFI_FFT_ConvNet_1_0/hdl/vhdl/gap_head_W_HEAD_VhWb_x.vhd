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

entity gap_head_W_HEAD_VhWb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhWb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110001", 1 => "00101101", 2 => "11101111", 3 => "11011001", 
    4 => "00011111", 5 => "01001001", 6 => "00000111", 7 => "11010111", 
    8 => "10101110", 9 => "00010011", 10 => "01001110", 11 => "10111010", 
    12 => "00001011", 13 => "01000000", 14 => "11110010", 15 => "11110110", 
    16 => "11000011", 17 => "11110001", 18 => "00101010", 19 => "00010010", 
    20 => "00111110", 21 => "11011111", 22 => "11101110", 23 => "01010110", 
    24 => "11101000", 25 => "11001010", 26 => "11010010", 27 => "00100111", 
    28 => "00100100", 29 => "11011011", 30 => "00010111", 31 => "11010110", 
    32 => "11101011", 33 => "00100010", 34 => "00001100", 35 => "00010001", 
    36 => "11010000", 37 => "00110000", 38 => "01000111", 39 => "00000010", 
    40 => "11100001", 41 => "00001100", 42 => "11000010", 43 => "01000000", 
    44 => "11101110", 45 => "00100011", 46 => "00010101", 47 => "10101110", 
    48 => "11011101", 49 => "11000110", 50 => "11101000", 51 => "11000001", 
    52 => "01001111", 53 => "01001001", 54 => "00010000", 55 => "00000101", 
    56 => "00010010", 57 => "00001001", 58 => "11010000", 59 => "11110000", 
    60 => "00000000", 61 => "00011101", 62 => "00100000", 63 => "10110000", 
    64 => "01000110", 65 => "11101000", 66 => "00101001", 67 => "11111110", 
    68 => "01011000", 69 => "10010111", 70 => "00001110", 71 => "11101101", 
    72 => "11010110", 73 => "00110000", 74 => "00000100", 75 => "11101010", 
    76 => "10111011", 77 => "11101010", 78 => "00011110", 79 => "11111101", 
    80 => "00101000", 81 => "00011011", 82 => "10111101", 83 => "00101011", 
    84 => "00001000", 85 => "00100010", 86 => "00010010", 87 => "11000010", 
    88 => "01111111", 89 => "00000011", 90 => "00001010", 91 => "11101010", 
    92 => "00001010", 93 => "11100100", 94 to 95=> "00001101", 96 => "10101110", 
    97 => "00011010", 98 => "00000110", 99 => "11101100", 100 => "00001011", 
    101 => "00011011", 102 => "01001110", 103 => "00110100", 104 => "11111111", 
    105 => "00000110", 106 => "11010111", 107 => "01011110", 108 => "00011111", 
    109 => "10001110", 110 => "00101011", 111 => "00010011", 112 => "11101010", 
    113 => "11111001", 114 => "11011001", 115 => "11010010", 116 => "11101010", 
    117 => "11011011", 118 => "00001001", 119 => "00010100", 120 => "00000011", 
    121 => "00000000", 122 => "00001101", 123 => "00110101", 124 => "01011100", 
    125 => "00011101", 126 => "10101110", 127 => "11111011", 128 => "11001010", 
    129 => "00011110", 130 => "00010111", 131 => "01101111", 132 => "00001100", 
    133 => "00001000", 134 => "00010000", 135 => "11100010", 136 => "00010011", 
    137 => "00001001", 138 => "11110011", 139 => "00100001", 140 => "10111111", 
    141 => "00011011", 142 => "01001010", 143 => "11100100", 144 => "11010111", 
    145 => "11000011", 146 => "01011101", 147 => "11010001", 148 => "01000101", 
    149 => "01100010" );


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

entity gap_head_W_HEAD_VhWb_x is
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

architecture arch of gap_head_W_HEAD_VhWb_x is
    component gap_head_W_HEAD_VhWb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhWb_x_rom_U :  component gap_head_W_HEAD_VhWb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


