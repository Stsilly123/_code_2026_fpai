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

entity gap_head_W_HEAD_VgWb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgWb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101011", 1 => "00111111", 2 => "11001100", 3 => "10001111", 
    4 => "00100001", 5 => "00111110", 6 => "10110100", 7 => "11100001", 
    8 => "10000001", 9 => "11011111", 10 => "11011000", 11 => "11111000", 
    12 => "00110101", 13 => "11110100", 14 => "10100000", 15 => "00001000", 
    16 => "10110111", 17 => "11101100", 18 => "00001110", 19 => "11000110", 
    20 => "11001111", 21 => "00100000", 22 => "10111010", 23 => "11100111", 
    24 => "11100100", 25 => "11010001", 26 => "11100011", 27 => "11011001", 
    28 => "11111010", 29 => "11110100", 30 => "01010010", 31 => "11111011", 
    32 => "11000111", 33 => "00100000", 34 => "11111110", 35 => "00001001", 
    36 => "11101000", 37 => "00011100", 38 => "01000010", 39 => "00010010", 
    40 => "11001100", 41 => "11101100", 42 => "10001110", 43 => "11001100", 
    44 => "11100101", 45 => "00111011", 46 => "10010111", 47 => "10000001", 
    48 => "11100100", 49 => "00100101", 50 => "00010111", 51 => "10000010", 
    52 => "01010001", 53 => "00110100", 54 => "00101000", 55 => "00010101", 
    56 => "11100011", 57 => "00001101", 58 => "00010001", 59 => "00101010", 
    60 => "11000110", 61 => "00111001", 62 => "11110011", 63 => "11110111", 
    64 => "10100000", 65 => "00011011", 66 => "11101001", 67 => "00011010", 
    68 => "00001100", 69 => "11101010", 70 => "00101101", 71 => "11101001", 
    72 => "00111011", 73 => "01001010", 74 => "00111011", 75 => "00010101", 
    76 => "11011101", 77 => "00000110", 78 => "11110001", 79 => "00011001", 
    80 => "00100100", 81 => "00000111", 82 => "11010101", 83 => "01010011", 
    84 => "11101000", 85 => "01010110", 86 => "00110100", 87 => "00111010", 
    88 => "10111111", 89 => "11001101", 90 => "11110100", 91 => "00100010", 
    92 => "11011100", 93 => "00000001", 94 => "00010110", 95 => "01100101", 
    96 => "11100101", 97 => "00011000", 98 => "00010101", 99 => "10011001", 
    100 => "11111001", 101 => "11100001", 102 => "11100100", 103 => "11101111", 
    104 => "00101000", 105 to 106=> "11011000", 107 => "11111000", 108 => "11111100", 
    109 => "11010010", 110 => "11110001", 111 => "11111110", 112 => "11101101", 
    113 => "00011001", 114 => "10001101", 115 => "00011110", 116 => "11110001", 
    117 => "11100101", 118 => "11010011", 119 => "11100111", 120 => "00011101", 
    121 => "11010010", 122 => "11110010", 123 => "00100000", 124 => "00110011", 
    125 => "00010010", 126 => "11010101", 127 => "11000011", 128 => "11111110", 
    129 to 130=> "00110011", 131 => "01010110", 132 => "00010011", 133 => "01010010", 
    134 => "00001101", 135 => "11010010", 136 => "00001001", 137 => "00110101", 
    138 => "11011011", 139 => "00011111", 140 => "11111111", 141 => "11011010", 
    142 => "10111110", 143 => "01001010", 144 => "00010000", 145 => "11100010", 
    146 => "00001010", 147 => "10101111", 148 => "11101101", 149 => "00011010" );


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

entity gap_head_W_HEAD_VgWb is
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

architecture arch of gap_head_W_HEAD_VgWb is
    component gap_head_W_HEAD_VgWb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgWb_rom_U :  component gap_head_W_HEAD_VgWb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


