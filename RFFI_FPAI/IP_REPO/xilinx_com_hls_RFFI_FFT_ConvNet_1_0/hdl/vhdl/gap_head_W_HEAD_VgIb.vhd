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

entity gap_head_W_HEAD_VgIb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgIb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100110", 1 => "00110110", 2 => "11110100", 3 => "11111111", 
    4 => "00011110", 5 => "11110100", 6 => "10101001", 7 => "01000101", 
    8 => "00011001", 9 => "00100100", 10 => "11101110", 11 => "00001000", 
    12 => "11001001", 13 => "00000011", 14 => "01001001", 15 => "00011000", 
    16 => "11101111", 17 => "00000001", 18 => "00101000", 19 => "00100101", 
    20 => "11001011", 21 => "00000011", 22 => "00000010", 23 => "11100001", 
    24 => "00000010", 25 => "00100001", 26 => "00111001", 27 => "10000001", 
    28 => "11010100", 29 => "11111110", 30 => "00010010", 31 => "11000100", 
    32 => "00000010", 33 => "00001000", 34 => "11101010", 35 => "11111101", 
    36 => "00000011", 37 => "01010110", 38 => "11001000", 39 => "00111110", 
    40 => "00101011", 41 => "00010110", 42 => "00101111", 43 => "00100011", 
    44 => "10110101", 45 => "11100110", 46 => "11111010", 47 => "00101100", 
    48 => "11100101", 49 => "01101100", 50 => "00001101", 51 => "11010010", 
    52 => "11100011", 53 => "11100101", 54 => "01111111", 55 => "01000101", 
    56 => "01011101", 57 => "11000101", 58 => "00011110", 59 => "11110101", 
    60 => "00110110", 61 => "00000101", 62 => "00000100", 63 => "00000110", 
    64 => "10110000", 65 => "11110011", 66 => "00001011", 67 => "11111000", 
    68 => "10111110", 69 => "00100011", 70 => "00001110", 71 => "11000101", 
    72 => "00110000", 73 => "11101011", 74 => "00001111", 75 => "11010011", 
    76 => "00111001", 77 => "11101011", 78 => "11110110", 79 => "11010111", 
    80 => "00000110", 81 => "11101011", 82 => "11001000", 83 => "00000111", 
    84 => "11001000", 85 => "00001000", 86 => "01111111", 87 => "01011011", 
    88 => "10011011", 89 => "11010110", 90 => "11100100", 91 => "01000000", 
    92 => "11001100", 93 => "00000111", 94 => "00001000", 95 => "11001100", 
    96 => "00011000", 97 => "11111111", 98 => "00000111", 99 => "00010010", 
    100 => "00110101", 101 => "01011011", 102 => "10101010", 103 => "11100100", 
    104 => "00011100", 105 => "01010010", 106 => "11110010", 107 => "11000111", 
    108 => "10100100", 109 => "00101010", 110 => "01011000", 111 => "11100000", 
    112 => "11000100", 113 => "00001000", 114 => "10111000", 115 => "00101100", 
    116 => "01110110", 117 => "11101011", 118 => "11001101", 119 => "11110101", 
    120 => "00011000", 121 => "11110010", 122 => "00001000", 123 => "11000000", 
    124 => "00101111", 125 => "00000100", 126 => "00100111", 127 => "11111101", 
    128 => "00101000", 129 => "00001000", 130 => "11000011", 131 => "11111011", 
    132 => "11001000", 133 => "00010101", 134 => "11111010", 135 => "11011001", 
    136 => "11100010", 137 => "11010101", 138 => "11100101", 139 => "11110001", 
    140 => "00001010", 141 => "11100010", 142 => "11001000", 143 => "00000110", 
    144 => "11101001", 145 => "11110100", 146 => "10111000", 147 => "11110100", 
    148 => "10111110", 149 => "10111011" );


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

entity gap_head_W_HEAD_VgIb is
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

architecture arch of gap_head_W_HEAD_VgIb is
    component gap_head_W_HEAD_VgIb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgIb_rom_U :  component gap_head_W_HEAD_VgIb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


