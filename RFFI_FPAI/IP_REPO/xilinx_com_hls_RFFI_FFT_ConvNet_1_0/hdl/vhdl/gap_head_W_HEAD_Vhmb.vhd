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

entity gap_head_W_HEAD_Vhmb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhmb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110010", 1 => "11001100", 2 => "00100000", 3 => "00010010", 
    4 => "11001100", 5 => "11000101", 6 => "11110011", 7 => "11100100", 
    8 => "00011001", 9 => "00001001", 10 => "01000011", 11 => "11110100", 
    12 => "00011100", 13 => "10101100", 14 => "11001000", 15 => "00011010", 
    16 => "00110000", 17 => "00100101", 18 => "11011111", 19 => "11101011", 
    20 => "11100010", 21 => "10100011", 22 => "00111010", 23 => "11100011", 
    24 => "00001011", 25 => "11100001", 26 => "11000101", 27 => "00001110", 
    28 => "11111101", 29 => "00010010", 30 => "00000000", 31 => "00110100", 
    32 => "00100111", 33 => "01001100", 34 => "11100110", 35 => "00010000", 
    36 => "00011110", 37 => "11100101", 38 => "10110100", 39 => "11010011", 
    40 => "01001000", 41 => "11000011", 42 => "01111010", 43 => "10100100", 
    44 => "00011100", 45 => "00101111", 46 => "11110010", 47 => "00011011", 
    48 => "00100000", 49 => "10110110", 50 => "11010011", 51 => "00101010", 
    52 => "11001001", 53 => "00011010", 54 => "00011111", 55 => "01010001", 
    56 => "11110001", 57 => "11000100", 58 => "11111001", 59 => "11010111", 
    60 => "00010001", 61 => "00100011", 62 => "11110001", 63 => "00010001", 
    64 => "00111110", 65 => "11110000", 66 => "00110010", 67 => "00011011", 
    68 => "00000111", 69 => "00001000", 70 => "11010010", 71 => "11100101", 
    72 => "11001000", 73 => "10111101", 74 => "01000011", 75 => "11100000", 
    76 => "11111000", 77 => "11111011", 78 => "00101110", 79 => "00011000", 
    80 => "00110001", 81 => "00000111", 82 => "00111010", 83 => "00101011", 
    84 => "00101111", 85 => "11111000", 86 => "00010010", 87 => "00010001", 
    88 => "11111110", 89 => "10110111", 90 => "00100111", 91 => "00000101", 
    92 => "00010011", 93 => "11110001", 94 => "11110011", 95 => "11001101", 
    96 => "00001010", 97 => "11100010", 98 => "11111101", 99 => "00011010", 
    100 => "10100100", 101 => "11111101", 102 to 103=> "11111100", 104 => "11101000", 
    105 to 106=> "11111000", 107 => "11101011", 108 => "11100101", 109 => "11001100", 
    110 => "11011011", 111 => "00001110", 112 => "00010100", 113 => "11111111", 
    114 => "00100101", 115 => "00001011", 116 => "00010100", 117 => "11110010", 
    118 => "00001111", 119 => "11010000", 120 to 121=> "00000110", 122 => "11011110", 
    123 => "11100111", 124 => "11111010", 125 => "11001111", 126 => "11001001", 
    127 => "11010001", 128 => "01001111", 129 => "10100000", 130 => "11111110", 
    131 => "10110101", 132 => "00010111", 133 => "11100000", 134 => "11111010", 
    135 => "00010001", 136 => "11110110", 137 => "01011110", 138 => "00011000", 
    139 => "11011110", 140 => "00010111", 141 => "00000011", 142 => "11010101", 
    143 => "11100010", 144 => "01111111", 145 => "00000000", 146 => "11001001", 
    147 => "00001100", 148 => "11110000", 149 => "10101100" );


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

entity gap_head_W_HEAD_Vhmb is
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

architecture arch of gap_head_W_HEAD_Vhmb is
    component gap_head_W_HEAD_Vhmb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhmb_rom_U :  component gap_head_W_HEAD_Vhmb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


