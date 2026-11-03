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

entity gap_head_W_HEAD_Vhkb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhkb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110000", 1 => "11100011", 2 => "10000111", 3 => "11000010", 
    4 => "10011000", 5 => "00010111", 6 => "00110111", 7 => "11101111", 
    8 => "11110010", 9 => "00000101", 10 => "11000011", 11 => "00001001", 
    12 => "11111011", 13 => "11100100", 14 => "11101110", 15 => "11111001", 
    16 => "00100001", 17 => "00110101", 18 => "11110011", 19 => "01000110", 
    20 => "00010000", 21 => "00010100", 22 => "10011010", 23 => "11001000", 
    24 => "11101010", 25 => "00000100", 26 => "01001010", 27 => "00001001", 
    28 => "11111000", 29 => "10110110", 30 => "11111100", 31 => "11100100", 
    32 => "11001101", 33 => "11101011", 34 => "00000100", 35 => "10111110", 
    36 => "00000101", 37 => "00110001", 38 => "01001011", 39 => "00001100", 
    40 => "00100010", 41 => "10111010", 42 => "11100011", 43 => "10001111", 
    44 => "11100110", 45 => "00001110", 46 => "10000001", 47 => "11011100", 
    48 => "01010001", 49 => "00110011", 50 => "11001111", 51 => "10111001", 
    52 => "00010000", 53 => "11000110", 54 => "00010011", 55 => "11110010", 
    56 => "00100111", 57 => "00010100", 58 => "00000111", 59 => "00010011", 
    60 => "00010111", 61 => "00100100", 62 => "00010110", 63 => "11111101", 
    64 => "11100000", 65 => "11011111", 66 => "00010111", 67 => "10110011", 
    68 => "11110100", 69 => "00111111", 70 => "00110001", 71 => "00000000", 
    72 => "00110011", 73 => "00011011", 74 => "00100000", 75 => "10101111", 
    76 => "01010110", 77 => "11001010", 78 => "00001001", 79 to 80=> "00001000", 
    81 => "11110110", 82 => "00001000", 83 => "11110110", 84 => "00110001", 
    85 => "00000000", 86 => "00101110", 87 => "00110000", 88 => "01100110", 
    89 => "11010011", 90 => "00000010", 91 => "10000001", 92 => "00110100", 
    93 => "11100100", 94 => "00001000", 95 => "11111000", 96 => "11011001", 
    97 => "00100011", 98 => "11100110", 99 => "00111111", 100 => "10111000", 
    101 => "10111101", 102 => "00000110", 103 => "11000110", 104 => "00001011", 
    105 => "11011000", 106 => "11101011", 107 => "11110010", 108 => "01000011", 
    109 => "11110000", 110 => "00010010", 111 => "00000101", 112 => "00001001", 
    113 => "00011000", 114 => "11001000", 115 => "00001001", 116 => "00110010", 
    117 => "11111001", 118 => "11111100", 119 => "11010111", 120 => "11111100", 
    121 => "11110011", 122 => "00100010", 123 => "11111111", 124 => "11011001", 
    125 => "01100100", 126 => "01000100", 127 => "10110010", 128 => "00111101", 
    129 => "11100011", 130 => "00001011", 131 => "00100100", 132 => "11110101", 
    133 => "11011010", 134 => "11010001", 135 => "11010000", 136 => "11110000", 
    137 => "01011111", 138 => "00010111", 139 => "11011001", 140 => "01000101", 
    141 => "00001100", 142 => "00001000", 143 => "00000011", 144 => "11111110", 
    145 => "00101000", 146 => "00111000", 147 => "00000010", 148 => "11001001", 
    149 => "10101000" );


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

entity gap_head_W_HEAD_Vhkb is
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

architecture arch of gap_head_W_HEAD_Vhkb is
    component gap_head_W_HEAD_Vhkb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhkb_rom_U :  component gap_head_W_HEAD_Vhkb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


