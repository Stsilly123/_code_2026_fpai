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

entity gap_head_W_HEAD_VgMb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgMb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110001", 1 => "10110110", 2 => "10100010", 3 => "00001101", 
    4 => "11011010", 5 => "10010001", 6 => "01001101", 7 => "01100011", 
    8 => "00011010", 9 => "10000100", 10 => "11101000", 11 => "00100011", 
    12 => "00010000", 13 => "10000001", 14 => "11100101", 15 => "11111001", 
    16 => "01100101", 17 => "01011100", 18 => "11111001", 19 => "11110010", 
    20 => "00110000", 21 => "01000001", 22 => "11001111", 23 => "10011111", 
    24 => "11100001", 25 => "00011111", 26 => "11011000", 27 => "11101010", 
    28 => "00011010", 29 => "10010100", 30 => "11110000", 31 => "00010100", 
    32 => "10101001", 33 => "11000000", 34 => "00000001", 35 => "10100011", 
    36 => "11110101", 37 => "11101100", 38 => "11100011", 39 => "00010100", 
    40 => "11001110", 41 => "11101111", 42 => "10111000", 43 => "10100110", 
    44 => "11110000", 45 => "01001110", 46 => "01011111", 47 => "00111100", 
    48 => "00101011", 49 => "10110100", 50 => "00001100", 51 => "11001101", 
    52 => "11101101", 53 => "00010011", 54 => "10101110", 55 => "11100000", 
    56 => "11011101", 57 => "00000100", 58 => "11101011", 59 => "01000111", 
    60 => "11110011", 61 => "10111100", 62 => "11011010", 63 => "11010001", 
    64 => "11101100", 65 => "01010100", 66 => "00011101", 67 => "01110111", 
    68 => "01010110", 69 => "11011000", 70 => "00001011", 71 => "11110011", 
    72 => "01011011", 73 => "01000010", 74 => "01000110", 75 => "10011011", 
    76 => "01111111", 77 => "00000001", 78 => "11010011", 79 => "11010010", 
    80 => "11110110", 81 => "00011100", 82 => "10101011", 83 => "01010110", 
    84 => "11001001", 85 => "01010000", 86 => "11000001", 87 => "00111101", 
    88 => "11001111", 89 => "10100010", 90 => "00001101", 91 => "10111110", 
    92 => "00000111", 93 => "01000111", 94 => "01111111", 95 => "11101100", 
    96 => "00111100", 97 => "10110111", 98 to 99=> "00011001", 100 => "01011001", 
    101 => "00101010", 102 => "00110101", 103 => "10110010", 104 => "00101101", 
    105 => "10010101", 106 => "00000001", 107 => "00001000", 108 => "11100011", 
    109 => "11010111", 110 => "11010001", 111 => "01010111", 112 => "11000100", 
    113 => "11101001", 114 => "10111010", 115 => "00110110", 116 => "01010111", 
    117 => "11001111", 118 => "01011100", 119 => "01000110", 120 => "11111110", 
    121 => "00010100", 122 => "11111111", 123 => "10101001", 124 => "11011001", 
    125 => "00101011", 126 => "00011011", 127 => "00000000", 128 => "11111001", 
    129 => "10000010", 130 => "01101110", 131 => "10111101", 132 => "00000010", 
    133 => "00011111", 134 => "00111010", 135 => "11000001", 136 => "01101011", 
    137 => "10000001", 138 => "11100111", 139 => "11011001", 140 => "01101110", 
    141 => "11100011", 142 => "11111000", 143 => "01011001", 144 => "00011100", 
    145 => "00101111", 146 => "11111111", 147 => "10100101", 148 => "11111011", 
    149 => "10110010" );


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

entity gap_head_W_HEAD_VgMb is
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

architecture arch of gap_head_W_HEAD_VgMb is
    component gap_head_W_HEAD_VgMb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgMb_rom_U :  component gap_head_W_HEAD_VgMb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


