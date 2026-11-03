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

entity gap_head_W_HEAD_V_1_rom is 
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


architecture rtl of gap_head_W_HEAD_V_1_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000010", 1 => "11100100", 2 => "01001001", 3 => "00000011", 
    4 => "00110100", 5 => "11001101", 6 => "11111001", 7 => "11100111", 
    8 => "11111111", 9 => "11010110", 10 => "11011110", 11 => "11101101", 
    12 => "11010101", 13 => "11010100", 14 => "00000100", 15 => "00000110", 
    16 => "11010111", 17 => "11101001", 18 => "10110110", 19 => "00000010", 
    20 => "11101101", 21 => "11101100", 22 => "00010100", 23 => "11100111", 
    24 => "11001100", 25 => "00001000", 26 => "11100111", 27 => "11111101", 
    28 => "00011011", 29 => "11100010", 30 => "00101100", 31 => "00010110", 
    32 => "11110011", 33 => "00001100", 34 => "11010110", 35 => "11001000", 
    36 => "00000110", 37 => "11101001", 38 => "10011010", 39 => "11111101", 
    40 => "00101001", 41 => "00000001", 42 => "01010011", 43 => "10110111", 
    44 => "11110000", 45 => "00001010", 46 => "11011010", 47 => "11100101", 
    48 => "00100010", 49 => "11011101", 50 => "11101001", 51 => "11111110", 
    52 => "00010100", 53 => "11100111", 54 => "00010000", 55 => "00001110", 
    56 => "00011001", 57 => "11111000", 58 => "00101011", 59 => "11011001", 
    60 => "00001111", 61 => "11111011", 62 => "00001110", 63 => "11011110", 
    64 => "11010010", 65 => "00011011", 66 => "00001011", 67 => "10101100", 
    68 => "00001011", 69 => "11110000", 70 => "01001010", 71 => "11100111", 
    72 => "01011001", 73 => "00010001", 74 => "00110101", 75 => "11010101", 
    76 => "11000100", 77 => "00010111", 78 => "11101010", 79 => "00001011", 
    80 => "01000010", 81 => "00011000", 82 => "01000001", 83 => "00110110", 
    84 => "11001110", 85 => "01111111", 86 => "00011101", 87 => "01111111", 
    88 => "11111001", 89 => "11001111", 90 => "11011010", 91 => "11110011", 
    92 => "00100100", 93 to 94=> "11101001", 95 => "11011100", 96 => "00101001", 
    97 => "11011111", 98 => "11101011", 99 => "11001010", 100 => "00101010", 
    101 => "00001001", 102 => "11101010", 103 => "11010111", 104 => "11001110", 
    105 => "10111000", 106 => "00001110", 107 => "11101100", 108 => "11111001", 
    109 => "11110110", 110 => "00111111", 111 => "11111110", 112 => "01000100", 
    113 => "00110011", 114 => "11100111", 115 => "11011110", 116 => "00011000", 
    117 => "00111001", 118 => "00111111", 119 => "00101110", 120 => "10001101", 
    121 => "11110111", 122 => "11100011", 123 => "11010010", 124 => "00011101", 
    125 => "00110011", 126 => "10011111", 127 => "10111100", 128 => "00000100", 
    129 => "11100100", 130 => "01110011", 131 => "00111011", 132 => "00101011", 
    133 => "00111111", 134 => "00001011", 135 => "00011100", 136 => "11111011", 
    137 => "00101010", 138 => "11011010", 139 => "11110010", 140 => "01100110", 
    141 => "00100111", 142 => "11011001", 143 => "00000001", 144 => "00000011", 
    145 => "00101011", 146 => "11101110", 147 => "00010101", 148 => "00001100", 
    149 => "00000110" );


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

entity gap_head_W_HEAD_V_1 is
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

architecture arch of gap_head_W_HEAD_V_1 is
    component gap_head_W_HEAD_V_1_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_1_rom_U :  component gap_head_W_HEAD_V_1_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


