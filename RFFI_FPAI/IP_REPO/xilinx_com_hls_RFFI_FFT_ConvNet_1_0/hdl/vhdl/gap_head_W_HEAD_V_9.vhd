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

entity gap_head_W_HEAD_V_9_rom is 
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


architecture rtl of gap_head_W_HEAD_V_9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100001", 1 => "11110000", 2 => "11010001", 3 => "00100010", 
    4 => "11001101", 5 => "10000011", 6 => "10100111", 7 => "00001100", 
    8 => "00000100", 9 => "11110101", 10 => "10100001", 11 => "11100110", 
    12 => "11101011", 13 => "11010011", 14 => "00011111", 15 => "11111000", 
    16 to 17=> "00100011", 18 => "11101111", 19 => "11110111", 20 => "00011000", 
    21 => "00000110", 22 => "00010001", 23 => "00100011", 24 => "11000001", 
    25 => "10101010", 26 => "11101001", 27 => "11100001", 28 => "10101101", 
    29 => "10111100", 30 => "11011100", 31 => "11000110", 32 to 33=> "00001011", 
    34 => "00000010", 35 => "11101010", 36 => "00010111", 37 => "11100111", 
    38 => "11111101", 39 => "11110100", 40 => "00000101", 41 => "00000001", 
    42 => "11101110", 43 => "00001100", 44 => "00110101", 45 => "00100010", 
    46 => "01111001", 47 => "00011011", 48 => "00100100", 49 => "00101010", 
    50 => "11111110", 51 to 52=> "00101010", 53 => "01001001", 54 => "11111111", 
    55 => "00011111", 56 => "11011111", 57 => "00110010", 58 => "11100110", 
    59 => "00011110", 60 => "11100011", 61 => "11111010", 62 => "11111111", 
    63 => "00011100", 64 => "11011100", 65 => "01000011", 66 => "11111101", 
    67 => "00101011", 68 => "00010101", 69 => "11111110", 70 => "11011001", 
    71 => "00110001", 72 => "00100101", 73 => "00111011", 74 => "00110011", 
    75 => "00010101", 76 => "00110001", 77 => "00100101", 78 => "10110101", 
    79 => "00001110", 80 => "11111010", 81 => "00011110", 82 => "00011011", 
    83 => "00101010", 84 => "10111101", 85 => "11001111", 86 => "11100111", 
    87 => "00001111", 88 => "11010111", 89 => "11000001", 90 => "11110011", 
    91 => "00011001", 92 => "00000101", 93 => "00011111", 94 => "10111110", 
    95 => "11001110", 96 => "01000100", 97 => "00000110", 98 => "11111011", 
    99 => "00111011", 100 => "00101000", 101 => "11100001", 102 => "00000110", 
    103 => "11110001", 104 => "01100110", 105 => "11111000", 106 => "01001110", 
    107 => "11101100", 108 => "11010010", 109 => "10001011", 110 => "00011011", 
    111 => "00110101", 112 => "00101110", 113 => "11111010", 114 => "11111011", 
    115 => "00000011", 116 => "00011100", 117 => "00001011", 118 => "00001000", 
    119 => "00100110", 120 => "00101001", 121 => "10000001", 122 => "11110010", 
    123 => "00010101", 124 => "10000001", 125 => "11111101", 126 => "11100000", 
    127 => "01000001", 128 => "00011010", 129 => "00000110", 130 => "11010101", 
    131 => "00101001", 132 => "11100000", 133 => "11110101", 134 => "11010100", 
    135 => "11110110", 136 => "00110001", 137 => "11010100", 138 => "10110101", 
    139 => "00101000", 140 => "00101001", 141 => "11111011", 142 => "00110010", 
    143 => "01001001", 144 => "10110010", 145 => "00011100", 146 => "10100000", 
    147 => "11000111", 148 => "11100110", 149 => "00100110" );


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

entity gap_head_W_HEAD_V_9 is
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

architecture arch of gap_head_W_HEAD_V_9 is
    component gap_head_W_HEAD_V_9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_9_rom_U :  component gap_head_W_HEAD_V_9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


