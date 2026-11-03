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

entity gap_head_W_HEAD_VhGb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhGb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110101", 1 => "00001100", 2 => "00011110", 3 => "10101011", 
    4 => "01111000", 5 => "10111111", 6 => "00011110", 7 => "00011101", 
    8 => "10101100", 9 => "00101110", 10 => "00100100", 11 => "11110111", 
    12 => "11110100", 13 => "11111010", 14 => "00101110", 15 => "00011100", 
    16 => "00111010", 17 => "10111000", 18 => "11110011", 19 => "00001001", 
    20 => "00111110", 21 => "10010101", 22 => "00001000", 23 => "00010100", 
    24 => "00111000", 25 to 26=> "11110110", 27 => "00001010", 28 => "11110011", 
    29 => "01010000", 30 => "11111010", 31 => "11111111", 32 => "11110111", 
    33 => "11111101", 34 => "11011111", 35 => "11110011", 36 => "11100111", 
    37 => "11111101", 38 => "11110000", 39 => "00111110", 40 => "01001101", 
    41 => "00101011", 42 => "01011000", 43 => "11100110", 44 => "11110000", 
    45 => "11001110", 46 => "01001111", 47 => "00010011", 48 => "00100111", 
    49 => "01000001", 50 => "00011010", 51 => "11101111", 52 => "11101000", 
    53 => "11101100", 54 => "11101101", 55 => "11111001", 56 => "00010111", 
    57 => "00000101", 58 => "00010100", 59 => "11011100", 60 => "00000111", 
    61 => "11011011", 62 => "11100111", 63 => "00001111", 64 => "00000101", 
    65 => "00101000", 66 => "10100000", 67 => "00000011", 68 => "11110111", 
    69 => "00100001", 70 => "00101100", 71 => "11101101", 72 => "00101101", 
    73 => "10000001", 74 => "11101100", 75 => "11101110", 76 => "11001111", 
    77 => "00010011", 78 => "00011000", 79 => "11100110", 80 => "11100111", 
    81 => "11100001", 82 => "00100011", 83 => "11000000", 84 => "00101101", 
    85 => "00000010", 86 => "00011011", 87 => "00011100", 88 => "00101100", 
    89 to 90=> "00001100", 91 => "10111110", 92 => "00010100", 93 => "11011001", 
    94 => "11100101", 95 => "11000010", 96 => "11111000", 97 => "00001010", 
    98 => "11101111", 99 => "10101011", 100 => "00000101", 101 => "11111000", 
    102 => "10101101", 103 => "00101010", 104 => "00001001", 105 => "01000100", 
    106 => "00011010", 107 => "11110110", 108 => "00100101", 109 => "11100101", 
    110 => "00011110", 111 => "11000111", 112 => "11010001", 113 => "00111011", 
    114 => "00011011", 115 => "11100100", 116 => "11101101", 117 => "11011010", 
    118 => "11101111", 119 => "00100110", 120 => "00001000", 121 to 122=> "00001010", 
    123 => "00111001", 124 => "01000111", 125 => "00100111", 126 => "11011001", 
    127 => "00011111", 128 => "11110100", 129 => "00000000", 130 => "00100000", 
    131 => "01000110", 132 => "00011111", 133 => "11100100", 134 => "00001011", 
    135 => "00000010", 136 to 137=> "11111001", 138 => "00100011", 139 => "11111011", 
    140 => "11100100", 141 => "11110111", 142 => "11000101", 143 => "11001000", 
    144 => "11101010", 145 => "00100001", 146 => "01000110", 147 => "00010001", 
    148 => "00111011", 149 => "00010001" );


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

entity gap_head_W_HEAD_VhGb_x is
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

architecture arch of gap_head_W_HEAD_VhGb_x is
    component gap_head_W_HEAD_VhGb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhGb_x_rom_U :  component gap_head_W_HEAD_VhGb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


