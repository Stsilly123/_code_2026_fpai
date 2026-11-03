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

entity gap_head_W_HEAD_Vg0b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg0b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110100", 1 => "00011011", 2 => "00001000", 3 to 4=> "00110010", 
    5 => "00110011", 6 => "00001000", 7 => "11000101", 8 => "01000011", 
    9 => "11111011", 10 => "00010111", 11 => "01000111", 12 => "11000001", 
    13 => "11101111", 14 => "11101001", 15 => "00111011", 16 => "11001110", 
    17 => "00101110", 18 => "11100010", 19 => "00000000", 20 => "11101110", 
    21 => "11110001", 22 => "11101010", 23 => "11101011", 24 => "00010100", 
    25 => "10111100", 26 => "00000000", 27 => "00011110", 28 => "11010010", 
    29 => "00000011", 30 => "11000111", 31 => "00010011", 32 => "00001100", 
    33 => "11010111", 34 => "00011101", 35 => "00010100", 36 => "00011101", 
    37 => "00000001", 38 => "11011011", 39 => "00100000", 40 => "01011110", 
    41 => "11100011", 42 => "10110001", 43 => "11101110", 44 => "00010100", 
    45 => "00001010", 46 => "11010001", 47 => "10111110", 48 => "11010010", 
    49 => "00101010", 50 => "11001010", 51 => "01001010", 52 => "00011110", 
    53 => "11010011", 54 => "11110101", 55 => "10111001", 56 => "11101110", 
    57 => "00010100", 58 => "11011001", 59 => "00100111", 60 => "11010011", 
    61 => "00001001", 62 => "11011111", 63 => "00100011", 64 => "11010001", 
    65 => "00010011", 66 => "11100110", 67 => "00011010", 68 => "00110011", 
    69 => "00010011", 70 => "00001101", 71 => "11011110", 72 => "01001011", 
    73 => "00101010", 74 => "11011000", 75 => "00101100", 76 => "11111100", 
    77 => "11010011", 78 => "00011111", 79 => "00011110", 80 => "00000011", 
    81 => "11111110", 82 => "00101011", 83 => "00111101", 84 => "00000110", 
    85 => "01000011", 86 => "11110000", 87 => "11101100", 88 => "11100000", 
    89 => "10111100", 90 => "00110100", 91 => "00100000", 92 => "11101011", 
    93 => "00010110", 94 => "11011001", 95 => "00111100", 96 => "11001001", 
    97 => "11110111", 98 => "00101010", 99 => "01001100", 100 => "11111000", 
    101 => "11011000", 102 => "00011111", 103 => "00001100", 104 to 105=> "00001111", 
    106 => "11100001", 107 => "11101010", 108 => "11011010", 109 => "11111011", 
    110 => "11011011", 111 => "00100110", 112 => "00011001", 113 => "11100001", 
    114 => "00000110", 115 => "11011110", 116 => "11010100", 117 => "00100001", 
    118 => "11100001", 119 => "11101000", 120 => "00000110", 121 => "00110101", 
    122 => "11010111", 123 => "11110110", 124 => "00110100", 125 => "11011001", 
    126 => "00010001", 127 => "11010101", 128 => "00100111", 129 => "00101001", 
    130 => "11100000", 131 => "11011110", 132 => "00110011", 133 => "11101001", 
    134 => "00001101", 135 => "00000111", 136 => "01010011", 137 => "00001110", 
    138 => "00101110", 139 => "00010001", 140 => "00000010", 141 => "00001001", 
    142 => "00101000", 143 => "11100000", 144 => "11100100", 145 => "11110111", 
    146 => "01010000", 147 => "11111010", 148 => "00111111", 149 => "01101001" );


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

entity gap_head_W_HEAD_Vg0b is
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

architecture arch of gap_head_W_HEAD_Vg0b is
    component gap_head_W_HEAD_Vg0b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg0b_rom_U :  component gap_head_W_HEAD_Vg0b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


