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

entity gap_head_W_HEAD_VgGb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgGb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10101000", 1 => "00000000", 2 => "00000001", 3 => "11011110", 
    4 => "00010101", 5 => "11111101", 6 => "00011011", 7 => "00110111", 
    8 => "11101100", 9 => "00101111", 10 => "00010011", 11 => "11111111", 
    12 => "00000110", 13 => "00001111", 14 => "00011001", 15 => "00001101", 
    16 => "11100110", 17 => "11010101", 18 => "00000011", 19 => "11100101", 
    20 => "11101110", 21 => "10010101", 22 => "00001101", 23 => "11111000", 
    24 => "00110010", 25 => "11110000", 26 => "01001101", 27 => "00010000", 
    28 => "11110010", 29 => "00101011", 30 => "11101100", 31 => "11100101", 
    32 => "11101011", 33 => "00100011", 34 => "11011101", 35 => "00111000", 
    36 => "00100110", 37 to 38=> "00010010", 39 => "10101111", 40 => "00101000", 
    41 => "11111100", 42 => "00010000", 43 => "00000001", 44 => "10110001", 
    45 => "00000110", 46 => "00011011", 47 => "00001001", 48 => "00100100", 
    49 => "11101001", 50 => "11110000", 51 => "11111100", 52 to 53=> "11111110", 
    54 => "01011000", 55 => "00110001", 56 => "00011011", 57 => "11001010", 
    58 => "00001100", 59 => "00000101", 60 => "00101001", 61 => "00001100", 
    62 => "11111100", 63 => "11111001", 64 => "00111000", 65 => "00000001", 
    66 => "00001111", 67 => "11010101", 68 => "11111000", 69 => "11111001", 
    70 => "00111011", 71 => "11100001", 72 => "11111110", 73 => "11011000", 
    74 => "00001001", 75 => "11010001", 76 => "00000001", 77 => "11011110", 
    78 => "00011111", 79 => "11000100", 80 => "00000100", 81 => "00000110", 
    82 => "11100110", 83 => "11111110", 84 => "00110011", 85 => "00000010", 
    86 => "00100110", 87 => "00000111", 88 => "00110110", 89 => "11111111", 
    90 => "11110011", 91 => "11111001", 92 => "00001111", 93 => "11100100", 
    94 => "00001101", 95 => "11111010", 96 => "00110100", 97 => "11001001", 
    98 => "00001111", 99 => "11000100", 100 => "00100101", 101 => "00000010", 
    102 => "11111111", 103 => "00111010", 104 => "11101001", 105 => "11111011", 
    106 => "00011010", 107 => "11000011", 108 => "11000001", 109 => "11010101", 
    110 => "00001111", 111 => "10111000", 112 => "00010011", 113 => "00011010", 
    114 => "10000001", 115 => "01000001", 116 => "01011110", 117 => "00011010", 
    118 => "10000001", 119 => "00011001", 120 => "00011010", 121 => "11101000", 
    122 => "11110101", 123 => "00011011", 124 => "01000110", 125 to 126=> "11100100", 
    127 => "00010110", 128 => "00111011", 129 => "00110001", 130 => "00001011", 
    131 => "00011101", 132 => "00010111", 133 => "00011001", 134 => "11001000", 
    135 => "00101011", 136 => "00001001", 137 => "00011101", 138 => "11110110", 
    139 => "00011110", 140 => "11110100", 141 => "00000111", 142 => "11101100", 
    143 => "11100000", 144 to 145=> "00001100", 146 => "11011100", 147 => "11110011", 
    148 => "00010000", 149 => "00110110" );


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

entity gap_head_W_HEAD_VgGb is
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

architecture arch of gap_head_W_HEAD_VgGb is
    component gap_head_W_HEAD_VgGb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgGb_rom_U :  component gap_head_W_HEAD_VgGb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


