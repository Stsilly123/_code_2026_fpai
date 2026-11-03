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

entity gap_head_W_HEAD_VhIb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhIb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010111", 1 => "11001100", 2 => "00001110", 3 => "11101000", 
    4 => "11110000", 5 => "00011100", 6 => "00010111", 7 => "00000010", 
    8 => "11101000", 9 => "11010101", 10 => "11100000", 11 => "11001010", 
    12 => "11101100", 13 => "11101000", 14 => "00001010", 15 => "10111110", 
    16 => "00011110", 17 => "11101111", 18 => "11111010", 19 => "00011100", 
    20 => "11101110", 21 => "11100000", 22 => "11010001", 23 => "11001100", 
    24 => "00010010", 25 => "01000100", 26 => "11111100", 27 => "00001101", 
    28 => "00111101", 29 => "11101100", 30 => "00000110", 31 => "00010101", 
    32 => "11111010", 33 => "00101001", 34 => "00001110", 35 => "11111110", 
    36 => "00000010", 37 => "11101111", 38 => "11111001", 39 => "11010110", 
    40 => "11101110", 41 => "11100010", 42 => "11000111", 43 => "00000111", 
    44 => "11110111", 45 => "00001011", 46 => "11010100", 47 => "00010100", 
    48 => "00100110", 49 => "11001000", 50 => "00010010", 51 => "11110100", 
    52 => "01100110", 53 => "11111110", 54 => "01000101", 55 => "10111111", 
    56 => "00001010", 57 => "00101100", 58 => "00011000", 59 => "01000111", 
    60 => "00000110", 61 => "00110010", 62 => "11110000", 63 => "11100011", 
    64 => "00111111", 65 => "00100010", 66 => "01000001", 67 => "11010100", 
    68 => "11101001", 69 => "00100110", 70 => "00001001", 71 => "11111100", 
    72 => "11101111", 73 => "01001000", 74 => "11100100", 75 => "11101101", 
    76 => "11101001", 77 => "11100111", 78 => "10110000", 79 => "11001110", 
    80 => "00001010", 81 => "00010011", 82 => "11110000", 83 => "00000010", 
    84 => "11110000", 85 => "11111011", 86 => "00010111", 87 => "11111110", 
    88 => "00010011", 89 => "11101001", 90 => "11110010", 91 => "00101101", 
    92 => "11011011", 93 => "01011000", 94 => "11110010", 95 => "11100100", 
    96 => "00000110", 97 => "00011111", 98 => "11100101", 99 => "00000100", 
    100 => "00110011", 101 => "11100001", 102 => "01001100", 103 => "11010100", 
    104 => "11000101", 105 => "11100001", 106 => "11011000", 107 => "00101011", 
    108 => "10110010", 109 => "00010110", 110 => "11110101", 111 => "11110010", 
    112 => "00010000", 113 => "11110000", 114 => "00100100", 115 => "00011011", 
    116 => "01100001", 117 => "00011011", 118 => "01000000", 119 => "00100001", 
    120 => "11011001", 121 => "11110111", 122 => "11001101", 123 => "00111101", 
    124 => "11110010", 125 => "11011100", 126 => "00111101", 127 => "11011110", 
    128 => "00011011", 129 => "11110001", 130 => "00100100", 131 => "11111101", 
    132 => "11110101", 133 => "00001101", 134 => "00011001", 135 => "00001010", 
    136 => "00110100", 137 => "11110111", 138 => "11001101", 139 => "00010000", 
    140 => "00000111", 141 => "11010111", 142 => "00110111", 143 => "11011010", 
    144 => "00000010", 145 => "00011111", 146 => "11111001", 147 => "00010101", 
    148 => "11010111", 149 => "00111010" );


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

entity gap_head_W_HEAD_VhIb_x is
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

architecture arch of gap_head_W_HEAD_VhIb_x is
    component gap_head_W_HEAD_VhIb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhIb_x_rom_U :  component gap_head_W_HEAD_VhIb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


