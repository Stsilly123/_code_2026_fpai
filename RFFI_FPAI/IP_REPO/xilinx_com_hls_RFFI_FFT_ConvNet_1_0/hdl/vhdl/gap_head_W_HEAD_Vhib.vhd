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

entity gap_head_W_HEAD_Vhib_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhib_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111011", 1 => "11010001", 2 => "00011010", 3 => "11011011", 
    4 => "11011110", 5 => "00011001", 6 => "00000111", 7 => "00001101", 
    8 => "11101011", 9 => "11010000", 10 => "11110000", 11 => "00001010", 
    12 => "00100000", 13 => "10101000", 14 => "01011101", 15 => "11100101", 
    16 => "01000000", 17 => "00001011", 18 => "11111001", 19 => "11001000", 
    20 => "00010010", 21 => "00001110", 22 => "01001111", 23 => "00000000", 
    24 => "11110100", 25 => "01000110", 26 => "00101111", 27 => "11110001", 
    28 => "11110010", 29 => "11100011", 30 => "11100000", 31 => "11110111", 
    32 => "11011110", 33 => "00111001", 34 => "11001111", 35 to 36=> "00010011", 
    37 => "11101111", 38 => "00101000", 39 => "01000101", 40 => "11110000", 
    41 => "11111101", 42 => "00101010", 43 => "10011001", 44 => "00101001", 
    45 => "00101101", 46 => "11010101", 47 => "00001010", 48 => "00000000", 
    49 => "01000011", 50 => "00110011", 51 => "00100000", 52 => "11111010", 
    53 => "01000001", 54 => "01110110", 55 => "11111001", 56 => "00111100", 
    57 => "01010011", 58 => "00010110", 59 => "00001111", 60 => "00011100", 
    61 => "00101100", 62 => "11101101", 63 => "00000010", 64 => "00111011", 
    65 => "00100000", 66 => "00011000", 67 => "11100110", 68 => "00001100", 
    69 => "01010111", 70 => "11111000", 71 => "00001100", 72 => "11000100", 
    73 => "00000011", 74 => "11110000", 75 => "00001110", 76 to 77=> "01001001", 
    78 => "11011110", 79 => "11101110", 80 => "00001000", 81 => "00101111", 
    82 => "00100011", 83 => "11001000", 84 => "10011100", 85 => "00110011", 
    86 => "00011101", 87 => "00100111", 88 => "11111000", 89 => "00001100", 
    90 => "11100010", 91 => "00101110", 92 => "11011110", 93 => "11101010", 
    94 => "10111111", 95 => "10000011", 96 => "00001010", 97 => "01001100", 
    98 => "00001100", 99 => "00001010", 100 => "10111110", 101 => "00010000", 
    102 => "00010010", 103 => "00001100", 104 => "11111011", 105 => "00000100", 
    106 => "01000000", 107 => "00011101", 108 => "11110011", 109 => "00001111", 
    110 => "11010111", 111 => "11000011", 112 => "10111111", 113 => "00010001", 
    114 => "11111100", 115 => "11011010", 116 => "01010111", 117 => "00010101", 
    118 => "10100001", 119 => "11100101", 120 => "00000001", 121 => "00010100", 
    122 => "10111101", 123 => "11010111", 124 => "11011011", 125 => "00000100", 
    126 => "00001111", 127 => "11001101", 128 => "11111110", 129 => "11000111", 
    130 => "10111011", 131 => "11111101", 132 => "11010111", 133 => "11100111", 
    134 => "00101000", 135 => "00100001", 136 => "00001001", 137 => "01011010", 
    138 => "00000110", 139 => "11100110", 140 => "11001011", 141 => "11110010", 
    142 => "11010101", 143 => "00001100", 144 => "11100001", 145 => "00110010", 
    146 => "10100010", 147 => "11110110", 148 => "11110000", 149 => "11100001" );


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

entity gap_head_W_HEAD_Vhib is
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

architecture arch of gap_head_W_HEAD_Vhib is
    component gap_head_W_HEAD_Vhib_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhib_rom_U :  component gap_head_W_HEAD_Vhib_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


