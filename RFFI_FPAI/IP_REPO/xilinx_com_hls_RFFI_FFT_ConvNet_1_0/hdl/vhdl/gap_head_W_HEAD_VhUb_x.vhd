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

entity gap_head_W_HEAD_VhUb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhUb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010001", 1 => "00110000", 2 => "10000001", 3 => "01001011", 
    4 => "10000001", 5 => "10100010", 6 => "00110101", 7 => "01000111", 
    8 => "01010001", 9 => "11010110", 10 => "00011001", 11 => "00000000", 
    12 => "11101111", 13 => "10110010", 14 => "11101111", 15 => "00011010", 
    16 => "11111010", 17 => "10101101", 18 => "00101000", 19 => "00000011", 
    20 => "00111011", 21 => "00000100", 22 => "00111101", 23 => "00011001", 
    24 => "11000010", 25 => "01010100", 26 => "11100101", 27 => "00111111", 
    28 => "11111010", 29 => "11001011", 30 => "11010001", 31 => "00011000", 
    32 => "00000000", 33 => "11111110", 34 => "11111111", 35 => "10110001", 
    36 => "01000001", 37 => "11111110", 38 => "11101100", 39 => "00101100", 
    40 => "10111001", 41 to 42=> "10000001", 43 => "00000100", 44 => "11001101", 
    45 => "01001100", 46 => "01000110", 47 => "01000010", 48 => "10100000", 
    49 => "01001111", 50 => "11001101", 51 => "01011111", 52 => "10101111", 
    53 => "00001010", 54 => "00000010", 55 => "10111110", 56 => "11111011", 
    57 => "00000101", 58 => "00111101", 59 => "11111011", 60 => "00011101", 
    61 => "00001111", 62 => "00100010", 63 => "10101110", 64 => "00000110", 
    65 => "11011010", 66 => "00111101", 67 => "11101100", 68 => "11110011", 
    69 => "11010111", 70 => "00011111", 71 => "10111110", 72 => "00111001", 
    73 => "11001101", 74 => "11110100", 75 => "10100101", 76 => "01001100", 
    77 => "10100010", 78 => "10111000", 79 => "00111000", 80 => "10110000", 
    81 => "11011110", 82 => "00110000", 83 => "00000000", 84 => "00001010", 
    85 => "11011111", 86 => "00110111", 87 => "11110110", 88 => "01101111", 
    89 => "01001101", 90 => "00011101", 91 => "11001011", 92 => "00101000", 
    93 => "00001011", 94 => "11110101", 95 => "11101101", 96 => "01000001", 
    97 => "01110100", 98 => "11111011", 99 => "01011101", 100 => "11110000", 
    101 => "11110111", 102 => "00100011", 103 => "10111001", 104 => "11010011", 
    105 => "11000101", 106 => "00010000", 107 => "00101000", 108 => "00000110", 
    109 => "00010111", 110 => "00100111", 111 => "00001101", 112 => "00100010", 
    113 => "11100000", 114 => "11111111", 115 => "00100000", 116 => "00000101", 
    117 => "11011011", 118 => "11101000", 119 => "11110010", 120 => "10111111", 
    121 => "00101101", 122 => "11101010", 123 => "10010101", 124 => "11111100", 
    125 => "00001010", 126 => "11000000", 127 => "00001111", 128 => "01100010", 
    129 => "11111101", 130 => "00001010", 131 => "01100101", 132 => "10110011", 
    133 => "00010010", 134 => "00001100", 135 => "10011001", 136 => "00001000", 
    137 => "11111110", 138 => "00001111", 139 => "11011000", 140 => "11011010", 
    141 => "11111110", 142 => "00000100", 143 => "01001110", 144 => "00001101", 
    145 => "11011110", 146 => "01100111", 147 => "00101001", 148 => "00000000", 
    149 => "00001001" );


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

entity gap_head_W_HEAD_VhUb_x is
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

architecture arch of gap_head_W_HEAD_VhUb_x is
    component gap_head_W_HEAD_VhUb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhUb_x_rom_U :  component gap_head_W_HEAD_VhUb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


