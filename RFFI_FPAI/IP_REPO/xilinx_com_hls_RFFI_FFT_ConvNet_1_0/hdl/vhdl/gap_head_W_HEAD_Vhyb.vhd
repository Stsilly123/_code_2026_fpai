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

entity gap_head_W_HEAD_Vhyb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhyb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001011", 1 => "00110110", 2 => "11011010", 3 => "10100010", 
    4 => "11011100", 5 => "11010011", 6 => "00110000", 7 => "00100110", 
    8 => "11100011", 9 => "11100100", 10 => "10111100", 11 => "00001110", 
    12 => "00000110", 13 => "00100101", 14 => "01000100", 15 => "01100110", 
    16 => "00001001", 17 => "00100110", 18 => "00100100", 19 => "11111101", 
    20 => "01011110", 21 => "11111010", 22 => "11100111", 23 => "00001011", 
    24 => "00100100", 25 => "00010001", 26 => "00000000", 27 => "11000010", 
    28 => "11111001", 29 => "00101000", 30 => "00011010", 31 => "10101110", 
    32 => "11110110", 33 => "10111010", 34 to 35=> "10000001", 36 => "00100001", 
    37 => "00100000", 38 => "00000011", 39 => "11000110", 40 => "01001001", 
    41 => "10101001", 42 => "10101011", 43 => "01000001", 44 => "01000111", 
    45 => "11110110", 46 => "01001000", 47 => "11011011", 48 => "11110110", 
    49 => "11010010", 50 => "01000011", 51 => "00001000", 52 => "10010111", 
    53 => "00001010", 54 => "00111111", 55 => "00100111", 56 => "01010111", 
    57 => "11011000", 58 => "00010101", 59 => "00110101", 60 => "00110110", 
    61 => "11110110", 62 => "00010111", 63 => "11010011", 64 => "10011100", 
    65 => "10111011", 66 => "11111101", 67 => "11001011", 68 => "01111111", 
    69 => "11111011", 70 => "00100000", 71 => "00100110", 72 => "00000000", 
    73 => "11101001", 74 => "11101101", 75 => "11101100", 76 => "11001101", 
    77 => "11101101", 78 => "01010000", 79 => "11110000", 80 => "11000101", 
    81 => "00000110", 82 => "00100101", 83 => "11101110", 84 => "00111100", 
    85 => "11001101", 86 => "00000001", 87 => "00001010", 88 => "00001111", 
    89 => "11111100", 90 => "11101101", 91 => "00100000", 92 => "00000000", 
    93 => "11001000", 94 => "00100101", 95 => "10110011", 96 => "11011101", 
    97 => "11100111", 98 => "00010110", 99 => "00000101", 100 => "01100101", 
    101 => "00000001", 102 => "11110100", 103 => "10100100", 104 => "11100000", 
    105 => "00001111", 106 => "00001001", 107 => "00001110", 108 => "11011010", 
    109 => "11111010", 110 => "11110001", 111 => "01111111", 112 => "11111101", 
    113 => "11110001", 114 => "00111011", 115 => "00000100", 116 => "00000011", 
    117 => "11111011", 118 => "01100001", 119 => "01001010", 120 => "00001000", 
    121 => "10111111", 122 => "01001001", 123 => "10000001", 124 => "11011001", 
    125 => "01001110", 126 => "10110110", 127 => "00001000", 128 => "00100011", 
    129 => "00011110", 130 => "01000101", 131 => "00000000", 132 => "11011001", 
    133 => "00101010", 134 => "11001111", 135 => "00011101", 136 => "10111110", 
    137 => "10010110", 138 => "11011001", 139 => "00101110", 140 => "11000011", 
    141 => "11110011", 142 => "00000110", 143 => "00000011", 144 => "00010111", 
    145 => "11110000", 146 => "11001110", 147 => "00001010", 148 => "11010010", 
    149 => "00010001" );


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

entity gap_head_W_HEAD_Vhyb is
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

architecture arch of gap_head_W_HEAD_Vhyb is
    component gap_head_W_HEAD_Vhyb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhyb_rom_U :  component gap_head_W_HEAD_Vhyb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


