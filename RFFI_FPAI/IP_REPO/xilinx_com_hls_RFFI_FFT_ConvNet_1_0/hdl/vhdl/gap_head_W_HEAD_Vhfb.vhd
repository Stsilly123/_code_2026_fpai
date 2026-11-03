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

entity gap_head_W_HEAD_Vhfb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhfb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100011", 1 => "00000100", 2 => "11001000", 3 => "10000011", 
    4 => "01010101", 5 => "11011110", 6 => "00010101", 7 => "00100101", 
    8 => "11011010", 9 => "11101000", 10 => "00101111", 11 => "00010011", 
    12 => "11111101", 13 => "11100101", 14 => "01010101", 15 => "11111100", 
    16 => "00110101", 17 => "00001011", 18 => "11000100", 19 => "00000110", 
    20 => "11110011", 21 => "11111001", 22 => "10101110", 23 => "10111000", 
    24 => "11000101", 25 => "11000010", 26 => "00010111", 27 => "00000100", 
    28 => "00011101", 29 => "00111110", 30 => "00100111", 31 => "11111110", 
    32 => "10011100", 33 => "11010110", 34 => "10110001", 35 => "10111001", 
    36 => "00010011", 37 => "10101110", 38 => "11101100", 39 => "00011111", 
    40 => "11100011", 41 => "11101011", 42 => "11011001", 43 => "00100110", 
    44 => "00000001", 45 => "00100001", 46 => "01100001", 47 => "11101001", 
    48 => "10110010", 49 to 50=> "00100000", 51 => "10000001", 52 => "00101101", 
    53 => "00100001", 54 => "11000101", 55 => "00001111", 56 => "11110110", 
    57 => "11111100", 58 => "00100100", 59 => "00001110", 60 => "11010101", 
    61 => "00100011", 62 => "11111100", 63 => "00000010", 64 => "11001101", 
    65 => "01000000", 66 => "11101110", 67 => "00101000", 68 => "11100010", 
    69 => "00000110", 70 => "10110111", 71 => "01000000", 72 => "00111110", 
    73 => "00100010", 74 => "00000001", 75 => "10010100", 76 => "11111110", 
    77 => "00001111", 78 => "01000001", 79 => "10100110", 80 => "11110111", 
    81 => "11110000", 82 => "00001000", 83 => "00010101", 84 => "11111001", 
    85 => "01100011", 86 => "11010100", 87 => "01000100", 88 => "00000110", 
    89 => "10011010", 90 => "11010010", 91 => "11010011", 92 => "11011000", 
    93 => "11100001", 94 => "00001000", 95 => "11011101", 96 => "00001011", 
    97 => "10111110", 98 => "01001101", 99 => "11110111", 100 => "00110000", 
    101 => "10101111", 102 => "11110011", 103 => "00111000", 104 => "00001110", 
    105 => "11100000", 106 => "00001111", 107 => "10110110", 108 => "11001101", 
    109 => "00010111", 110 => "00000011", 111 => "01000000", 112 => "11111010", 
    113 => "10001111", 114 => "11101001", 115 => "00010110", 116 => "11011010", 
    117 => "00011001", 118 => "00100101", 119 => "00011100", 120 => "11100000", 
    121 => "11010001", 122 => "11101000", 123 => "11110111", 124 => "00101001", 
    125 => "00011010", 126 => "11101000", 127 => "00011110", 128 => "00101101", 
    129 => "11111111", 130 => "11111000", 131 => "10011100", 132 => "00000111", 
    133 => "00001001", 134 => "11010010", 135 => "11001101", 136 => "00000001", 
    137 => "11100101", 138 => "11111100", 139 => "11110100", 140 => "00100101", 
    141 => "00001101", 142 => "01001101", 143 => "10111000", 144 => "00110010", 
    145 => "00110111", 146 => "01000000", 147 => "00010011", 148 => "00101110", 
    149 => "00110001" );


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

entity gap_head_W_HEAD_Vhfb is
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

architecture arch of gap_head_W_HEAD_Vhfb is
    component gap_head_W_HEAD_Vhfb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhfb_rom_U :  component gap_head_W_HEAD_Vhfb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


