-- ==============================================================
-- File generated on Sun Oct 18 16:53:16 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vhnb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhnb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110100", 1 => "11101011", 2 => "01101010", 3 => "11111010", 
    4 => "00111011", 5 => "11111111", 6 => "00001100", 7 => "11001111", 
    8 => "11110011", 9 => "10101100", 10 => "00111010", 11 => "11111001", 
    12 => "00110001", 13 => "11000011", 14 => "11011010", 15 => "01011100", 
    16 => "00010000", 17 => "11100000", 18 => "11100101", 19 => "11111100", 
    20 => "00010001", 21 => "11100111", 22 => "01010001", 23 => "11100111", 
    24 => "11010101", 25 => "10100110", 26 => "11011010", 27 => "00111010", 
    28 => "11110011", 29 => "00001000", 30 => "00110000", 31 => "11001110", 
    32 => "11011101", 33 => "11101001", 34 => "11011110", 35 => "01010111", 
    36 => "00001000", 37 => "11010000", 38 => "11101000", 39 => "11011101", 
    40 => "00011000", 41 => "00001001", 42 => "00111110", 43 => "11001000", 
    44 => "00100000", 45 => "11011101", 46 => "00000010", 47 => "11110000", 
    48 => "11010111", 49 => "10111000", 50 => "11111110", 51 => "00110101", 
    52 => "11100011", 53 => "01001111", 54 => "01000011", 55 => "01000001", 
    56 => "00111101", 57 => "10110111", 58 => "11101011", 59 => "11100100", 
    60 => "11110010", 61 => "00101010", 62 => "00001010", 63 => "00000000", 
    64 => "11111010", 65 => "01111111", 66 => "01000000", 67 => "00001100", 
    68 => "00100010", 69 => "11011101", 70 => "00000101", 71 => "11101001", 
    72 => "00000010", 73 => "11111001", 74 => "00101100", 75 => "00111110", 
    76 => "11001101", 77 => "00010001", 78 => "00111111", 79 => "11101001", 
    80 => "11100010", 81 => "00111010", 82 => "00110001", 83 => "01110011", 
    84 => "00001010", 85 => "00100000", 86 => "11101101", 87 => "00001111", 
    88 => "11100011", 89 => "11100100", 90 => "00001001", 91 => "11100000", 
    92 => "11111001", 93 => "11111101", 94 => "11011000", 95 => "11110000", 
    96 => "00111011", 97 => "11001111", 98 => "00111001", 99 => "11001111", 
    100 => "11011010", 101 => "11011111", 102 => "01001011", 103 => "01000010", 
    104 => "00010111", 105 => "11010011", 106 => "01010001", 107 => "11101010", 
    108 => "11001010", 109 => "10111001", 110 => "11111100", 111 => "01001001", 
    112 => "01001010", 113 => "11011100", 114 => "11101010", 115 => "00000100", 
    116 => "11110100", 117 => "11011001", 118 => "00101100", 119 => "00000010", 
    120 => "11101100", 121 => "11111100", 122 => "11000101", 123 => "11010001", 
    124 => "00111110", 125 => "11100110", 126 => "10101000", 127 => "11001010", 
    128 => "11100111", 129 => "11001101", 130 => "00000100", 131 => "11011010", 
    132 => "00001111", 133 => "11111111", 134 => "00100000", 135 => "00111010", 
    136 => "11011100", 137 => "00101111", 138 => "00000011", 139 => "11101001", 
    140 => "11111000", 141 => "00100011", 142 => "01001101", 143 => "00001011", 
    144 => "00111101", 145 => "00101011", 146 => "00110000", 147 => "00000100", 
    148 => "00001000", 149 => "01011100" );


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

entity gap_head_W_HEAD_Vhnb is
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

architecture arch of gap_head_W_HEAD_Vhnb is
    component gap_head_W_HEAD_Vhnb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhnb_rom_U :  component gap_head_W_HEAD_Vhnb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


