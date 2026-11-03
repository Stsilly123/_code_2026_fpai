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

entity gap_head_W_HEAD_Vhub_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhub_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101010", 1 => "11110000", 2 => "11110101", 3 => "00011010", 
    4 => "11110011", 5 => "11111101", 6 => "00101000", 7 => "00111111", 
    8 => "00111101", 9 => "11101001", 10 => "00000011", 11 => "00011001", 
    12 => "11000000", 13 => "11100010", 14 => "00111100", 15 => "00001110", 
    16 => "11110001", 17 => "00111001", 18 => "00011110", 19 => "00010001", 
    20 => "11110101", 21 => "11100110", 22 => "11011101", 23 => "11100000", 
    24 => "11101000", 25 => "11111000", 26 => "01110011", 27 => "00101110", 
    28 => "11101101", 29 => "11000111", 30 => "11000110", 31 => "11110110", 
    32 => "00001101", 33 => "11100001", 34 => "00010111", 35 => "11011000", 
    36 => "01111111", 37 => "11011001", 38 => "00101101", 39 => "11101011", 
    40 => "11101111", 41 => "00000110", 42 => "00011111", 43 => "11011000", 
    44 => "01010111", 45 => "00010101", 46 => "11101101", 47 => "01000010", 
    48 => "11010001", 49 => "00100001", 50 => "11010001", 51 => "11110010", 
    52 => "00010011", 53 => "00110011", 54 => "00011111", 55 => "00101001", 
    56 => "11111010", 57 => "00010110", 58 => "01011000", 59 => "11101010", 
    60 => "00001111", 61 => "11100000", 62 => "11111000", 63 => "00110000", 
    64 => "00100001", 65 => "11110100", 66 => "11010101", 67 => "00000100", 
    68 => "01001000", 69 => "11110001", 70 => "00000111", 71 to 72=> "00001111", 
    73 => "00111010", 74 => "11100110", 75 => "11011011", 76 => "00001011", 
    77 => "11101100", 78 => "11011001", 79 => "11100110", 80 => "00101101", 
    81 => "11101100", 82 => "01011110", 83 => "11010011", 84 => "11101110", 
    85 => "00100111", 86 => "00101110", 87 => "00010101", 88 => "10111111", 
    89 => "10111101", 90 => "00001110", 91 => "00010001", 92 => "10111001", 
    93 => "11010100", 94 => "11100111", 95 => "11010011", 96 => "11111111", 
    97 => "11000000", 98 => "11110111", 99 => "00100010", 100 => "00001100", 
    101 => "00000010", 102 => "00010011", 103 => "00001111", 104 => "10100110", 
    105 => "00010001", 106 => "11111111", 107 => "11001001", 108 => "00000100", 
    109 => "11110111", 110 => "11111100", 111 => "11101011", 112 => "01001100", 
    113 => "10111010", 114 => "11001001", 115 => "11110111", 116 => "00010101", 
    117 => "01111111", 118 => "10000101", 119 => "11001000", 120 => "11011000", 
    121 => "00000000", 122 => "00001000", 123 => "11010111", 124 => "00110001", 
    125 => "10111011", 126 => "11111011", 127 => "00011011", 128 => "00011100", 
    129 => "11100011", 130 => "11001101", 131 => "11101100", 132 => "00001110", 
    133 => "11101101", 134 => "00001000", 135 => "00011000", 136 => "11011011", 
    137 => "00101111", 138 => "01111111", 139 => "00000111", 140 => "01001001", 
    141 => "00011100", 142 => "11011101", 143 => "00011111", 144 => "11010100", 
    145 => "11111011", 146 => "01000010", 147 => "00000101", 148 => "11110001", 
    149 => "00110101" );


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

entity gap_head_W_HEAD_Vhub is
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

architecture arch of gap_head_W_HEAD_Vhub is
    component gap_head_W_HEAD_Vhub_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhub_rom_U :  component gap_head_W_HEAD_Vhub_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


