-- ==============================================================
-- File generated on Sun Oct 18 16:53:17 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VhPb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhPb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10000001", 1 => "00010010", 2 => "00001111", 3 => "00001010", 
    4 => "11100001", 5 => "00001110", 6 => "01001010", 7 => "00101001", 
    8 => "00111000", 9 => "11001100", 10 => "00011010", 11 => "00001011", 
    12 => "00111010", 13 => "00011011", 14 => "11100000", 15 => "00100101", 
    16 => "00000111", 17 => "00000000", 18 => "00110001", 19 => "11101010", 
    20 => "11001010", 21 => "01000011", 22 => "11110001", 23 => "00011011", 
    24 => "00010101", 25 => "11100000", 26 => "00101010", 27 => "00110101", 
    28 => "00000110", 29 => "00010010", 30 => "10111100", 31 => "11100011", 
    32 => "11011010", 33 => "11011100", 34 => "00110111", 35 => "00100001", 
    36 => "11101111", 37 => "11111011", 38 => "01101001", 39 => "00101111", 
    40 => "10000001", 41 => "11100100", 42 => "11100000", 43 => "01000010", 
    44 => "00001111", 45 => "11111110", 46 => "00111011", 47 => "00100001", 
    48 => "11000110", 49 => "11111110", 50 => "11010101", 51 => "11000100", 
    52 => "00011111", 53 => "11000110", 54 => "10101111", 55 => "11011101", 
    56 => "11010001", 57 => "11001001", 58 => "10111111", 59 => "01111111", 
    60 => "11101010", 61 => "10111011", 62 => "00011100", 63 => "11110110", 
    64 => "11101110", 65 => "00100101", 66 => "11100011", 67 => "11000111", 
    68 => "00011000", 69 => "00011010", 70 => "11011111", 71 => "11010111", 
    72 => "11110111", 73 => "00110110", 74 => "00101010", 75 => "00001100", 
    76 => "00010000", 77 => "00000100", 78 => "00011101", 79 => "00000011", 
    80 => "00101100", 81 => "00010110", 82 => "11010111", 83 => "00100000", 
    84 => "00100110", 85 => "01000111", 86 => "11010000", 87 => "11100111", 
    88 => "00000101", 89 => "00000011", 90 => "00100011", 91 => "11010101", 
    92 => "11010001", 93 => "11000000", 94 => "11101010", 95 to 96=> "00010100", 
    97 => "11100000", 98 => "00010110", 99 => "01001010", 100 => "00010100", 
    101 => "11110000", 102 => "01100000", 103 => "11101101", 104 => "11000100", 
    105 => "10100101", 106 => "00011100", 107 => "00001000", 108 => "00011001", 
    109 => "00011101", 110 => "11001100", 111 => "11111111", 112 => "00100001", 
    113 => "11111101", 114 => "00001110", 115 => "00011000", 116 => "10100000", 
    117 => "00010110", 118 to 119=> "11101101", 120 => "00011111", 121 => "00010010", 
    122 => "00001010", 123 => "11010001", 124 => "00011100", 125 => "00000111", 
    126 => "01001110", 127 => "00100010", 128 => "00100011", 129 => "11110111", 
    130 => "11001100", 131 => "10111101", 132 => "00011000", 133 => "00010111", 
    134 => "11110000", 135 => "11111001", 136 => "00111110", 137 => "11011010", 
    138 => "00110000", 139 => "11110100", 140 => "00100111", 141 => "11110011", 
    142 => "11011110", 143 => "00011100", 144 => "11000100", 145 => "00001000", 
    146 => "00110111", 147 => "00010001", 148 => "11110100", 149 => "11111001" );


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

entity gap_head_W_HEAD_VhPb_x is
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

architecture arch of gap_head_W_HEAD_VhPb_x is
    component gap_head_W_HEAD_VhPb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhPb_x_rom_U :  component gap_head_W_HEAD_VhPb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


