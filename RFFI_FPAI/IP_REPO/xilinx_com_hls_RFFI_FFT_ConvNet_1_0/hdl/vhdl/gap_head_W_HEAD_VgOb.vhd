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

entity gap_head_W_HEAD_VgOb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgOb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11001001", 1 => "00000110", 2 => "11010011", 3 => "00111111", 
    4 => "00100011", 5 => "00001001", 6 => "01001010", 7 => "11111101", 
    8 => "00001100", 9 => "10101111", 10 => "00010001", 11 => "00011100", 
    12 => "00010101", 13 => "01111010", 14 => "10000100", 15 => "00000100", 
    16 => "11010100", 17 => "11010111", 18 => "11011111", 19 => "11101100", 
    20 => "11010101", 21 => "11001111", 22 => "00000000", 23 => "00000010", 
    24 => "01100000", 25 => "11000101", 26 => "10111100", 27 => "00101100", 
    28 => "00110000", 29 => "01111111", 30 => "00101011", 31 => "00001011", 
    32 => "11101010", 33 => "00001111", 34 => "11101001", 35 => "11001000", 
    36 => "11010110", 37 => "11000111", 38 => "10011011", 39 => "11100100", 
    40 => "11000010", 41 => "00011110", 42 => "01011110", 43 => "01001100", 
    44 => "11001101", 45 => "11100001", 46 => "01011010", 47 => "00001000", 
    48 => "00101100", 49 => "11011111", 50 => "11111110", 51 => "00011001", 
    52 => "11110010", 53 => "11010111", 54 => "10100011", 55 => "00010110", 
    56 => "10110011", 57 => "10001101", 58 => "11101110", 59 => "00100100", 
    60 => "11000000", 61 => "11011011", 62 => "00110111", 63 => "11111011", 
    64 => "11100110", 65 => "01000101", 66 => "11011101", 67 => "11010100", 
    68 => "11001111", 69 => "11010101", 70 => "00101100", 71 => "00101101", 
    72 => "11111100", 73 => "01001000", 74 => "00100111", 75 => "11011111", 
    76 => "11110110", 77 => "11100111", 78 => "01010111", 79 => "01001001", 
    80 => "00101101", 81 => "00111110", 82 => "10111010", 83 => "01010011", 
    84 => "01010101", 85 => "01011111", 86 => "11000101", 87 => "11000000", 
    88 => "10100000", 89 => "01111111", 90 => "10110001", 91 => "11110111", 
    92 => "01000010", 93 => "00011001", 94 => "11111100", 95 => "01110101", 
    96 => "00011110", 97 => "00110110", 98 => "11111100", 99 => "10100010", 
    100 => "00010011", 101 => "10111111", 102 => "10101110", 103 => "11001111", 
    104 => "11101000", 105 => "10111110", 106 => "11101011", 107 => "10000001", 
    108 => "00010110", 109 => "01001000", 110 => "00010101", 111 => "10101111", 
    112 => "00011000", 113 => "11110101", 114 => "11011100", 115 => "01001000", 
    116 => "10100000", 117 => "00100011", 118 => "01100010", 119 => "01001110", 
    120 => "10111101", 121 => "00010010", 122 => "00010000", 123 => "01100100", 
    124 => "11101100", 125 => "11000010", 126 => "00010011", 127 => "01000001", 
    128 => "00100101", 129 => "00110111", 130 => "01001100", 131 => "10010010", 
    132 => "00010100", 133 => "00011011", 134 => "11010111", 135 => "11101011", 
    136 => "00110110", 137 => "10111111", 138 => "11010110", 139 => "00001111", 
    140 => "00000000", 141 => "00011110", 142 to 143=> "11111011", 144 => "00000100", 
    145 => "11011110", 146 => "11011100", 147 => "00010011", 148 => "11001101", 
    149 => "00000010" );


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

entity gap_head_W_HEAD_VgOb is
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

architecture arch of gap_head_W_HEAD_VgOb is
    component gap_head_W_HEAD_VgOb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgOb_rom_U :  component gap_head_W_HEAD_VgOb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


