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

entity gap_head_W_HEAD_VgNb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgNb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000011", 1 to 2=> "11110010", 3 => "11011001", 4 => "10111111", 
    5 => "01000110", 6 => "00000110", 7 => "00011011", 8 => "00000010", 
    9 => "10100111", 10 => "11001000", 11 => "11011111", 12 => "11101010", 
    13 => "11101110", 14 => "11111100", 15 => "00000101", 16 => "11110011", 
    17 => "11111100", 18 => "11111000", 19 => "11011010", 20 => "11100000", 
    21 => "11110001", 22 => "00000000", 23 => "01001001", 24 => "00000010", 
    25 => "11111001", 26 => "11111000", 27 => "00000011", 28 => "11110110", 
    29 => "00001010", 30 => "11110101", 31 => "11001001", 32 => "11011110", 
    33 => "00110110", 34 => "11000000", 35 => "00001010", 36 => "11001110", 
    37 => "00110111", 38 => "10100011", 39 => "00011001", 40 => "11010001", 
    41 => "11011101", 42 => "00011100", 43 => "11001100", 44 => "11011011", 
    45 => "11111000", 46 => "00000000", 47 => "11101000", 48 => "01001111", 
    49 => "00110000", 50 => "00001001", 51 => "11101111", 52 => "11101011", 
    53 => "01111011", 54 => "01101000", 55 => "01101010", 56 => "01010101", 
    57 => "00101110", 58 => "11101101", 59 => "11101001", 60 => "00111010", 
    61 => "01011011", 62 => "11111111", 63 => "11111101", 64 => "11111001", 
    65 => "11111010", 66 => "01111100", 67 => "01000000", 68 => "11100001", 
    69 => "01000010", 70 => "11001001", 71 => "00010001", 72 => "11001111", 
    73 => "00000101", 74 => "11111000", 75 => "11101001", 76 => "11100110", 
    77 => "11110111", 78 => "01110000", 79 => "11111000", 80 => "11011101", 
    81 => "11111110", 82 => "11110010", 83 => "11000001", 84 => "01010001", 
    85 => "11011010", 86 to 87=> "00101011", 88 => "00111101", 89 => "11011111", 
    90 to 91=> "11110011", 92 => "00000100", 93 => "00011001", 94 => "01001110", 
    95 => "00010110", 96 => "00100100", 97 => "00111111", 98 => "00110001", 
    99 => "11001010", 100 => "11110010", 101 => "00000110", 102 => "00111010", 
    103 => "01010010", 104 => "00111011", 105 => "11001111", 106 => "00101110", 
    107 => "01001001", 108 => "00100111", 109 => "01000111", 110 => "00011001", 
    111 => "00111001", 112 => "11110111", 113 => "11110001", 114 => "10110100", 
    115 => "00000011", 116 => "00001100", 117 => "11110100", 118 => "11000000", 
    119 => "11101111", 120 => "11101001", 121 => "11010100", 122 => "00000110", 
    123 => "00001001", 124 => "11000000", 125 => "00010000", 126 => "11001111", 
    127 => "00111101", 128 => "11011011", 129 => "11010001", 130 => "11101011", 
    131 => "11111010", 132 => "10110100", 133 => "00001001", 134 => "11101100", 
    135 => "00010110", 136 => "10111110", 137 to 138=> "00000001", 139 => "11010110", 
    140 => "00011001", 141 => "00111001", 142 => "01101010", 143 => "11100001", 
    144 => "00011001", 145 => "00100010", 146 => "11001000", 147 => "00101000", 
    148 => "10111001", 149 => "10100100" );


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

entity gap_head_W_HEAD_VgNb is
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

architecture arch of gap_head_W_HEAD_VgNb is
    component gap_head_W_HEAD_VgNb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgNb_rom_U :  component gap_head_W_HEAD_VgNb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


