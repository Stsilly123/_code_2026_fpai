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

entity gap_head_W_HEAD_VhOb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhOb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00101000", 1 => "00110101", 2 => "00010011", 3 => "00011000", 
    4 => "00000101", 5 => "11101100", 6 => "00000010", 7 => "11011000", 
    8 => "11111010", 9 => "00010001", 10 => "11101111", 11 => "00111100", 
    12 => "11111111", 13 => "00100111", 14 => "11001110", 15 => "11101010", 
    16 => "11010011", 17 => "01001011", 18 => "00001011", 19 => "00101101", 
    20 => "11110010", 21 => "00100101", 22 => "11111001", 23 => "11100110", 
    24 => "00001011", 25 => "00110100", 26 => "00000111", 27 => "11011001", 
    28 => "00010000", 29 => "00110001", 30 => "00001100", 31 => "00010111", 
    32 => "00101000", 33 => "00010001", 34 => "00010000", 35 => "00011101", 
    36 => "11101001", 37 => "11100100", 38 => "01111000", 39 => "10101100", 
    40 => "00111010", 41 => "11110111", 42 => "00000010", 43 => "00000000", 
    44 => "11100110", 45 => "00011010", 46 => "11101111", 47 => "11101000", 
    48 => "00001110", 49 => "10111001", 50 => "11001010", 51 => "00011011", 
    52 => "11011100", 53 => "00100010", 54 => "10111100", 55 => "00000111", 
    56 => "11111010", 57 => "01001000", 58 => "00000111", 59 => "10111111", 
    60 => "11110110", 61 => "11101111", 62 => "11100001", 63 => "11000001", 
    64 => "11101110", 65 => "11001111", 66 => "11100111", 67 to 68=> "00001110", 
    69 => "00101011", 70 => "00100010", 71 => "00011011", 72 => "00001001", 
    73 => "00101100", 74 => "11010110", 75 => "01111111", 76 => "00100000", 
    77 => "11101100", 78 => "00001101", 79 => "11001100", 80 => "00101100", 
    81 => "11010100", 82 => "00010101", 83 => "11100011", 84 => "01000011", 
    85 => "01010011", 86 => "00000110", 87 => "11111001", 88 => "00000111", 
    89 => "00000000", 90 => "11010000", 91 => "00001101", 92 => "00000011", 
    93 => "11100101", 94 => "00001100", 95 => "11010010", 96 => "11011010", 
    97 => "00000111", 98 => "00000101", 99 => "11100010", 100 => "00001011", 
    101 => "00011010", 102 => "00010111", 103 => "00010000", 104 => "10111110", 
    105 => "11110010", 106 => "11111101", 107 => "11101010", 108 => "01010100", 
    109 => "11110100", 110 => "00010100", 111 => "11100001", 112 => "00000011", 
    113 => "01100101", 114 => "11010100", 115 => "11101010", 116 => "11111101", 
    117 => "00001101", 118 => "00000110", 119 => "11000000", 120 => "00000100", 
    121 => "00001001", 122 => "11111101", 123 => "11111011", 124 => "00000111", 
    125 => "00000101", 126 => "11101010", 127 => "11001010", 128 => "11011010", 
    129 => "00111000", 130 => "11110110", 131 => "11101000", 132 => "00001101", 
    133 => "00100110", 134 => "11110101", 135 => "00010000", 136 => "11010000", 
    137 => "00001010", 138 => "11101010", 139 => "00101001", 140 => "11101110", 
    141 => "00010111", 142 => "00100000", 143 => "00101010", 144 => "00011011", 
    145 => "11110011", 146 => "11101000", 147 => "11110001", 148 => "00101011", 
    149 => "00010110" );


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

entity gap_head_W_HEAD_VhOb_x is
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

architecture arch of gap_head_W_HEAD_VhOb_x is
    component gap_head_W_HEAD_VhOb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhOb_x_rom_U :  component gap_head_W_HEAD_VhOb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


