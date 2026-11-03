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

entity gap_head_W_HEAD_Vg9b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg9b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010001", 1 => "01001001", 2 => "00110111", 3 => "00000100", 
    4 => "10011111", 5 => "11111011", 6 => "01110110", 7 => "11001110", 
    8 => "11100110", 9 => "00001010", 10 => "00100011", 11 => "11111010", 
    12 => "00010000", 13 => "11000111", 14 => "11000011", 15 => "11010100", 
    16 => "11110111", 17 => "01001011", 18 => "11100101", 19 => "11010111", 
    20 => "10000110", 21 => "00110111", 22 => "00000001", 23 => "00000111", 
    24 => "11110101", 25 => "10011000", 26 => "11001011", 27 => "01000100", 
    28 => "00110001", 29 => "00001110", 30 => "11001110", 31 => "10110101", 
    32 => "00000001", 33 => "11001000", 34 => "00101010", 35 => "00110101", 
    36 => "11011110", 37 => "11101000", 38 => "00110010", 39 => "01101111", 
    40 => "11111010", 41 => "11101111", 42 => "00001100", 43 => "11011000", 
    44 => "10000001", 45 => "11001001", 46 => "11110111", 47 => "11111110", 
    48 => "01111000", 49 => "00100101", 50 => "00001111", 51 => "11010100", 
    52 => "11101111", 53 => "00001110", 54 => "00101100", 55 => "11111000", 
    56 => "00011010", 57 => "00001000", 58 => "10000001", 59 => "11111110", 
    60 => "01111111", 61 => "00100100", 62 => "00000110", 63 => "00011100", 
    64 => "10011100", 65 => "00010100", 66 => "01110001", 67 => "11111101", 
    68 => "00100110", 69 => "11111101", 70 => "10110101", 71 => "00110101", 
    72 => "00010001", 73 => "01001111", 74 => "10101001", 75 => "01100001", 
    76 => "00111011", 77 => "00100101", 78 => "11011110", 79 => "00000100", 
    80 => "00000111", 81 => "11101000", 82 => "10111111", 83 => "00001010", 
    84 => "01011110", 85 => "11000001", 86 => "01000111", 87 => "11111111", 
    88 => "00100010", 89 => "10101000", 90 => "11101101", 91 => "00100010", 
    92 => "11101010", 93 => "00001110", 94 => "10111010", 95 => "01111111", 
    96 => "00101101", 97 => "00011010", 98 => "00010000", 99 => "11000001", 
    100 => "01110110", 101 => "11001111", 102 => "01001001", 103 => "11100001", 
    104 => "01001100", 105 => "11110110", 106 => "00100011", 107 to 108=> "11010000", 
    109 => "11011000", 110 => "00010001", 111 => "00000111", 112 => "11010011", 
    113 => "00011111", 114 => "00010111", 115 => "11010100", 116 => "11100011", 
    117 => "11001000", 118 => "11001100", 119 => "11101010", 120 => "11110000", 
    121 => "00000110", 122 => "11001001", 123 => "10110000", 124 => "11111101", 
    125 => "00001000", 126 => "01110001", 127 => "00000011", 128 => "10110100", 
    129 => "11010001", 130 => "11101001", 131 => "10110001", 132 => "11001010", 
    133 => "11111101", 134 => "01111111", 135 => "00010000", 136 => "00011101", 
    137 => "00101101", 138 => "00100010", 139 => "11100101", 140 => "01111011", 
    141 => "11010110", 142 => "00000000", 143 => "01101001", 144 => "10101101", 
    145 => "00111001", 146 => "01111111", 147 => "00000100", 148 => "10000001", 
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

entity gap_head_W_HEAD_Vg9b is
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

architecture arch of gap_head_W_HEAD_Vg9b is
    component gap_head_W_HEAD_Vg9b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg9b_rom_U :  component gap_head_W_HEAD_Vg9b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


