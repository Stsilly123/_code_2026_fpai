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

entity gap_head_W_HEAD_V_0_rom is 
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


architecture rtl of gap_head_W_HEAD_V_0_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000001", 1 => "11000000", 2 => "11100000", 3 => "00001111", 
    4 => "11100010", 5 => "11001101", 6 => "11110100", 7 => "11000011", 
    8 => "00010010", 9 => "11111001", 10 => "01100000", 11 => "10100100", 
    12 => "00000111", 13 => "11110110", 14 => "11001000", 15 => "11101011", 
    16 => "00001000", 17 => "11111001", 18 => "10111110", 19 => "00011111", 
    20 => "11011000", 21 => "11110110", 22 => "11100010", 23 => "11100001", 
    24 => "10110110", 25 => "11010001", 26 => "10110101", 27 => "00100101", 
    28 => "00000011", 29 => "10011011", 30 => "01011010", 31 => "11101111", 
    32 => "00110110", 33 => "00001001", 34 => "00100101", 35 => "01000011", 
    36 => "00001010", 37 => "11100001", 38 => "11001111", 39 => "00110110", 
    40 => "01100100", 41 => "11100101", 42 => "00010010", 43 => "00111110", 
    44 => "00000010", 45 => "00010010", 46 => "00000111", 47 => "00111110", 
    48 => "11101001", 49 => "00100111", 50 => "11100001", 51 => "00110101", 
    52 => "00011000", 53 => "11011100", 54 => "10110111", 55 => "01011110", 
    56 => "11100100", 57 => "11101011", 58 => "11010100", 59 => "10110001", 
    60 => "11001110", 61 => "00001111", 62 => "01001001", 63 => "11011101", 
    64 => "00001001", 65 => "00100100", 66 => "01010110", 67 => "11110011", 
    68 => "00000010", 69 => "00000100", 70 => "00100011", 71 => "11100101", 
    72 => "11010110", 73 => "00001001", 74 => "00001000", 75 => "01000011", 
    76 => "00101011", 77 => "00010111", 78 => "11100000", 79 => "11101110", 
    80 => "11011110", 81 => "01111111", 82 => "00010100", 83 => "00010010", 
    84 => "10110011", 85 => "00101111", 86 => "11001011", 87 => "11101011", 
    88 => "10111011", 89 => "01010000", 90 => "11010010", 91 => "00000000", 
    92 => "11111101", 93 to 94=> "11100010", 95 => "00001011", 96 => "00010110", 
    97 => "00010001", 98 => "11100101", 99 => "00110110", 100 => "11100101", 
    101 => "11101111", 102 => "00000111", 103 => "11000011", 104 => "00001110", 
    105 => "01010000", 106 => "01001001", 107 => "11001010", 108 => "00011110", 
    109 => "00001010", 110 => "11010101", 111 => "11101110", 112 => "11111111", 
    113 => "00000000", 114 => "01001111", 115 => "01000010", 116 => "10111101", 
    117 => "00001110", 118 => "01111001", 119 => "00010111", 120 => "11100010", 
    121 => "00001101", 122 => "11011010", 123 => "11111000", 124 => "00110101", 
    125 => "10101100", 126 => "00100010", 127 => "11110111", 128 => "00111000", 
    129 => "00000111", 130 => "10100011", 131 => "10011011", 132 => "00111101", 
    133 => "11101100", 134 => "11100101", 135 => "11011010", 136 => "00001111", 
    137 => "00010110", 138 => "00001011", 139 => "10110011", 140 => "01000010", 
    141 => "11011100", 142 => "01100011", 143 => "11010111", 144 => "11110011", 
    145 => "11101000", 146 => "00100100", 147 => "11011110", 148 => "00101001", 
    149 => "00001101" );


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

entity gap_head_W_HEAD_V_0 is
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

architecture arch of gap_head_W_HEAD_V_0 is
    component gap_head_W_HEAD_V_0_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_0_rom_U :  component gap_head_W_HEAD_V_0_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


