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

entity gap_head_W_HEAD_VgLb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgLb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011000", 1 => "00000101", 2 => "00010110", 3 => "00001010", 
    4 => "10110110", 5 => "11001011", 6 => "11101001", 7 => "00001111", 
    8 => "11111001", 9 => "01100001", 10 => "11000000", 11 => "00010000", 
    12 => "00001011", 13 => "00011010", 14 => "00110111", 15 => "11010000", 
    16 => "11111001", 17 => "11000100", 18 => "00010010", 19 => "00100010", 
    20 => "11010110", 21 => "11011110", 22 => "00111101", 23 => "01000100", 
    24 => "00110001", 25 => "11011001", 26 => "00100010", 27 => "11010101", 
    28 => "11101111", 29 => "00001101", 30 => "00000001", 31 => "00101101", 
    32 => "00101011", 33 => "00111000", 34 => "11111001", 35 => "00100101", 
    36 => "11101010", 37 => "00001101", 38 => "00011010", 39 => "01000001", 
    40 => "00010000", 41 => "10111101", 42 => "11010101", 43 => "11110100", 
    44 => "11100100", 45 => "00010001", 46 => "00111011", 47 => "11111001", 
    48 => "00011001", 49 => "00010000", 50 => "00000000", 51 => "00001111", 
    52 => "00001001", 53 => "00000110", 54 => "11010011", 55 => "11101010", 
    56 => "11011111", 57 => "00010001", 58 => "11010000", 59 => "00001001", 
    60 => "11111111", 61 => "00110011", 62 => "00000000", 63 => "11101100", 
    64 => "11110000", 65 => "00000111", 66 => "00011000", 67 => "11110000", 
    68 => "00000001", 69 => "00000000", 70 => "11111001", 71 => "00000001", 
    72 => "00110101", 73 => "11100100", 74 => "11110111", 75 => "00101001", 
    76 => "11010001", 77 => "00001100", 78 => "11010100", 79 => "11111011", 
    80 => "00000000", 81 => "11101001", 82 => "11010101", 83 => "00100011", 
    84 => "00001110", 85 => "00001011", 86 => "00101001", 87 => "00000110", 
    88 => "00000101", 89 => "11100110", 90 => "11011101", 91 => "11010111", 
    92 => "00100010", 93 => "11100100", 94 => "11111010", 95 => "10111111", 
    96 => "00100001", 97 => "01111111", 98 => "11011100", 99 => "11110110", 
    100 => "11100100", 101 => "11011011", 102 => "11100110", 103 => "11100001", 
    104 => "11001101", 105 => "11110111", 106 => "00101101", 107 => "11100001", 
    108 => "00010000", 109 => "11100100", 110 => "00100011", 111 => "11001010", 
    112 => "11110001", 113 => "00011011", 114 => "00100000", 115 => "00010111", 
    116 => "11000001", 117 => "11100000", 118 => "00000101", 119 => "00100001", 
    120 => "11111010", 121 => "11111100", 122 => "00101010", 123 => "00011010", 
    124 => "10010000", 125 => "01001011", 126 => "00010010", 127 => "00100110", 
    128 => "11110110", 129 => "11110000", 130 => "11111111", 131 => "00001111", 
    132 => "11100101", 133 => "11011001", 134 => "00010001", 135 => "00010111", 
    136 => "00101111", 137 => "00101110", 138 => "11101110", 139 => "11111110", 
    140 => "00100011", 141 => "00010011", 142 => "11111001", 143 => "10111110", 
    144 => "00100011", 145 => "00011011", 146 => "11110000", 147 => "11010111", 
    148 => "11101110", 149 => "10000001" );


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

entity gap_head_W_HEAD_VgLb is
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

architecture arch of gap_head_W_HEAD_VgLb is
    component gap_head_W_HEAD_VgLb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgLb_rom_U :  component gap_head_W_HEAD_VgLb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


