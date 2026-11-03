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

entity gap_head_W_HEAD_VhJb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhJb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000000", 1 => "11100000", 2 => "00100010", 3 => "11101101", 
    4 => "01010001", 5 => "10100111", 6 => "11111110", 7 => "01101000", 
    8 => "00101000", 9 => "00110011", 10 => "11001101", 11 => "11011101", 
    12 => "01000100", 13 => "01011110", 14 => "01010100", 15 => "11111100", 
    16 => "01000100", 17 => "10101011", 18 => "00011101", 19 => "00000001", 
    20 => "00110100", 21 => "10110010", 22 => "00000100", 23 => "00111101", 
    24 => "00010100", 25 => "11111001", 26 => "00000010", 27 => "11101010", 
    28 => "00001100", 29 => "11000101", 30 => "11101101", 31 => "11001101", 
    32 => "00100010", 33 => "11111110", 34 => "11100110", 35 => "11110100", 
    36 => "11010011", 37 => "11101010", 38 => "11011110", 39 => "00010101", 
    40 => "11111010", 41 => "00100110", 42 => "11010001", 43 => "00001100", 
    44 => "11101010", 45 => "00100100", 46 => "01101110", 47 => "00011011", 
    48 => "11001011", 49 => "00011010", 50 => "00001111", 51 => "00111010", 
    52 => "11011101", 53 => "00001000", 54 => "11111100", 55 => "11011101", 
    56 => "00010010", 57 => "11001100", 58 => "00100111", 59 => "00010111", 
    60 => "11111110", 61 => "11110100", 62 => "11010100", 63 => "01000011", 
    64 => "00011000", 65 => "00001110", 66 => "11100001", 67 => "01110000", 
    68 => "00001110", 69 => "11110101", 70 => "11000100", 71 => "01000010", 
    72 => "00110101", 73 => "00000101", 74 => "11101100", 75 => "11100100", 
    76 => "11111001", 77 => "00001001", 78 => "11001000", 79 => "11110100", 
    80 => "11001001", 81 => "00000100", 82 => "11000000", 83 => "00010011", 
    84 => "11001011", 85 => "00100010", 86 => "11010101", 87 => "10111000", 
    88 => "01000011", 89 to 90=> "00011011", 91 => "11010001", 92 => "00010101", 
    93 => "00011110", 94 => "11111000", 95 => "00100110", 96 => "00111000", 
    97 => "11010101", 98 => "11100111", 99 => "11011110", 100 => "00101000", 
    101 => "10110100", 102 => "00010001", 103 => "11111010", 104 => "11101111", 
    105 => "11100111", 106 => "00011010", 107 => "11010011", 108 => "11101010", 
    109 => "00000010", 110 => "00001101", 111 => "11111010", 112 => "11101110", 
    113 => "00000011", 114 => "00100111", 115 => "00110111", 116 => "00110100", 
    117 => "11010110", 118 => "11101011", 119 => "01001000", 120 => "01001010", 
    121 => "11001011", 122 => "01111111", 123 => "01010000", 124 => "11111101", 
    125 => "01010011", 126 => "00010110", 127 => "01001011", 128 => "00010011", 
    129 => "00110000", 130 => "01000110", 131 => "00010100", 132 => "11101100", 
    133 => "11100011", 134 => "00000000", 135 => "00110110", 136 => "00001001", 
    137 => "10100110", 138 => "11110111", 139 => "11111111", 140 => "10111100", 
    141 => "00000000", 142 => "00001001", 143 => "11100101", 144 => "00010110", 
    145 => "00010001", 146 => "00000000", 147 => "11100001", 148 => "11101100", 
    149 => "11110000" );


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

entity gap_head_W_HEAD_VhJb_x is
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

architecture arch of gap_head_W_HEAD_VhJb_x is
    component gap_head_W_HEAD_VhJb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhJb_x_rom_U :  component gap_head_W_HEAD_VhJb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


