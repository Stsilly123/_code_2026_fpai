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

entity gap_head_W_HEAD_V_8_rom is 
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


architecture rtl of gap_head_W_HEAD_V_8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10111011", 1 => "00101000", 2 => "00000100", 3 => "10111101", 
    4 => "11110110", 5 => "00011100", 6 => "00011101", 7 => "11111000", 
    8 => "11101110", 9 => "00101100", 10 => "01001110", 11 => "11001101", 
    12 => "01001111", 13 => "00011111", 14 => "11100011", 15 => "10110101", 
    16 => "10101111", 17 => "00010011", 18 => "00010010", 19 => "11011000", 
    20 => "00100000", 21 => "11111010", 22 => "00010110", 23 => "00001111", 
    24 => "00100111", 25 => "00000111", 26 => "11101111", 27 => "00010100", 
    28 => "01000001", 29 => "01010101", 30 => "00010001", 31 => "10110101", 
    32 => "10000001", 33 => "00101001", 34 => "11100110", 35 => "10101111", 
    36 => "10110011", 37 => "11110001", 38 => "01001111", 39 => "11110011", 
    40 => "10011110", 41 => "11100001", 42 => "11101001", 43 => "00101001", 
    44 => "11010111", 45 => "11011000", 46 => "00101010", 47 => "10001110", 
    48 => "00101000", 49 => "10011010", 50 => "11101110", 51 => "10010110", 
    52 => "10011110", 53 => "00100100", 54 => "00000010", 55 => "10000001", 
    56 => "00100001", 57 => "10111001", 58 => "10001100", 59 => "11001100", 
    60 => "00011011", 61 => "00110001", 62 => "00110010", 63 => "11100001", 
    64 => "00100001", 65 => "11001101", 66 => "01001111", 67 => "00010111", 
    68 => "11111111", 69 => "00101011", 70 => "11111000", 71 => "01011111", 
    72 => "00001110", 73 => "11011011", 74 => "11111011", 75 => "11101000", 
    76 => "00010011", 77 => "00110101", 78 => "00111101", 79 => "00011111", 
    80 => "11010100", 81 => "11011111", 82 => "11000000", 83 => "11110001", 
    84 => "01011010", 85 => "11000010", 86 => "00100011", 87 => "00010100", 
    88 => "01000101", 89 => "00101100", 90 => "11010010", 91 => "00001001", 
    92 => "00000000", 93 => "11001111", 94 => "00001101", 95 => "11011010", 
    96 => "00011110", 97 => "11011010", 98 => "11110111", 99 => "00010110", 
    100 => "00101010", 101 => "11001101", 102 => "10101111", 103 => "00110001", 
    104 => "11011101", 105 => "10000001", 106 => "00010110", 107 => "01010101", 
    108 => "10000001", 109 => "01000010", 110 => "11000111", 111 => "00000011", 
    112 => "11101000", 113 => "11110010", 114 => "10110010", 115 => "11110111", 
    116 => "01000010", 117 => "11101000", 118 => "01110000", 119 => "11111011", 
    120 => "11010010", 121 => "01011000", 122 => "11110011", 123 => "11111110", 
    124 => "01010000", 125 => "00111111", 126 => "11110011", 127 => "00000000", 
    128 => "01111001", 129 => "00011101", 130 => "00001100", 131 => "11110100", 
    132 => "11110011", 133 => "00010000", 134 => "11111100", 135 => "11111111", 
    136 => "00010101", 137 => "00011101", 138 => "00100110", 139 to 140=> "11111110", 
    141 => "11111010", 142 => "11101110", 143 => "11000110", 144 => "11110011", 
    145 => "00011011", 146 => "11011111", 147 => "01011000", 148 => "00010000", 
    149 => "00011100" );


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

entity gap_head_W_HEAD_V_8 is
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

architecture arch of gap_head_W_HEAD_V_8 is
    component gap_head_W_HEAD_V_8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_8_rom_U :  component gap_head_W_HEAD_V_8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


