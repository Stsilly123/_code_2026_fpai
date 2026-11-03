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

entity gap_head_W_HEAD_Vh2b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vh2b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10111100", 1 => "11101111", 2 => "00001010", 3 => "00000111", 
    4 => "11111111", 5 => "00011001", 6 => "10111010", 7 => "00011101", 
    8 => "00011001", 9 => "11000100", 10 => "00000000", 11 => "00100100", 
    12 => "11101000", 13 => "11110111", 14 => "00000110", 15 => "00100110", 
    16 => "11111111", 17 => "00010101", 18 => "00011011", 19 => "00010110", 
    20 => "00001100", 21 => "11011011", 22 => "11011000", 23 => "00000001", 
    24 => "00000100", 25 => "11011011", 26 => "11000101", 27 => "11011001", 
    28 => "11011000", 29 => "00010110", 30 => "00000000", 31 => "10111100", 
    32 => "11110100", 33 => "00000011", 34 => "00011101", 35 => "00010110", 
    36 => "00101011", 37 => "00011110", 38 => "11010101", 39 => "01111111", 
    40 => "00011000", 41 => "00001011", 42 => "00101110", 43 => "00010000", 
    44 => "00101000", 45 => "00101111", 46 => "01000100", 47 => "00001101", 
    48 => "10100111", 49 => "00110110", 50 => "11101101", 51 to 52=> "11011011", 
    53 => "11010011", 54 => "11101100", 55 => "00110010", 56 => "00000011", 
    57 => "11110001", 58 => "00010100", 59 => "11011110", 60 => "11110000", 
    61 => "11011011", 62 => "11010010", 63 => "00101010", 64 => "00000111", 
    65 => "00010101", 66 => "00100111", 67 => "00100000", 68 => "00011110", 
    69 => "11100101", 70 => "11100111", 71 => "10111010", 72 => "11011111", 
    73 => "10010101", 74 => "00001111", 75 => "11110100", 76 => "00111001", 
    77 => "11110100", 78 => "00010100", 79 => "11110110", 80 => "11100101", 
    81 => "00110111", 82 => "11101011", 83 => "00110010", 84 => "11010010", 
    85 => "11001010", 86 => "11111100", 87 => "00111001", 88 => "11011011", 
    89 => "00101100", 90 => "00011010", 91 => "00001111", 92 => "11110001", 
    93 => "11111001", 94 => "00000010", 95 => "10110111", 96 => "00000110", 
    97 => "11000011", 98 => "00000111", 99 => "01000011", 100 => "00001101", 
    101 => "01001101", 102 => "00111110", 103 => "11010001", 104 => "11101110", 
    105 => "00001000", 106 => "00000101", 107 => "00110110", 108 => "00011001", 
    109 => "11100000", 110 => "00001111", 111 => "00001000", 112 => "11110010", 
    113 => "00000001", 114 => "11110100", 115 => "00001111", 116 => "11100001", 
    117 => "11111011", 118 => "11111111", 119 => "00001111", 120 => "00001110", 
    121 => "11110011", 122 => "11101111", 123 => "11100011", 124 => "00111001", 
    125 => "11001000", 126 => "11011000", 127 => "00000111", 128 => "00100101", 
    129 => "11111000", 130 => "11011110", 131 => "11001110", 132 => "00010000", 
    133 => "11111010", 134 => "00110101", 135 => "11000110", 136 => "00001011", 
    137 => "11110011", 138 => "00000000", 139 => "11101001", 140 => "00111110", 
    141 => "11001011", 142 => "00010100", 143 => "00011101", 144 => "11110000", 
    145 => "11011001", 146 => "00000001", 147 => "11101000", 148 => "00001100", 
    149 => "00001010" );


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

entity gap_head_W_HEAD_Vh2b is
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

architecture arch of gap_head_W_HEAD_Vh2b is
    component gap_head_W_HEAD_Vh2b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vh2b_rom_U :  component gap_head_W_HEAD_Vh2b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


