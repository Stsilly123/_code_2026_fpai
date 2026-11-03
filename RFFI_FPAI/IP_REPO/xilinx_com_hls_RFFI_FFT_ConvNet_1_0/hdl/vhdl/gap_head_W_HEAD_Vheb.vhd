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

entity gap_head_W_HEAD_Vheb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vheb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010111", 1 => "11110011", 2 => "11101010", 3 => "11100011", 
    4 => "11101101", 5 => "01011110", 6 => "11101111", 7 => "00111001", 
    8 => "11011111", 9 => "11011011", 10 => "11001001", 11 => "10011111", 
    12 => "00011111", 13 => "00111100", 14 => "00011110", 15 => "11010010", 
    16 => "00100111", 17 => "00010011", 18 => "00101101", 19 => "00000011", 
    20 => "10101010", 21 => "11100110", 22 => "11111010", 23 => "00011101", 
    24 => "10110011", 25 => "00001010", 26 => "01010001", 27 => "11110100", 
    28 => "00000011", 29 => "10101000", 30 => "11111100", 31 => "10010011", 
    32 => "11100011", 33 => "00111100", 34 => "00100110", 35 => "00000100", 
    36 => "11101100", 37 => "01000100", 38 => "01000000", 39 => "01000011", 
    40 => "11111011", 41 => "00111111", 42 => "10111111", 43 => "00001010", 
    44 => "11110000", 45 => "11111100", 46 => "00001000", 47 => "11111101", 
    48 => "01111001", 49 => "00111101", 50 => "11011101", 51 => "11100101", 
    52 => "00010001", 53 => "11011111", 54 => "11010001", 55 => "11001001", 
    56 => "00010110", 57 => "01000011", 58 => "11101101", 59 => "11011100", 
    60 => "11111001", 61 => "11110101", 62 => "00000101", 63 => "00100111", 
    64 => "00011100", 65 => "11110011", 66 => "00100110", 67 => "11111111", 
    68 => "11101000", 69 => "00001001", 70 => "11100110", 71 => "00001010", 
    72 => "11011011", 73 => "11011111", 74 => "00010011", 75 => "00001100", 
    76 => "00001110", 77 => "00100100", 78 => "00000000", 79 => "11100101", 
    80 => "11110001", 81 => "11110011", 82 => "00000100", 83 => "00000111", 
    84 => "11000100", 85 => "10111010", 86 => "00111111", 87 => "00011111", 
    88 => "11010001", 89 => "00011001", 90 => "11101101", 91 => "11111001", 
    92 => "00011111", 93 => "11101011", 94 => "00000010", 95 => "11000011", 
    96 => "00100101", 97 => "01010000", 98 => "11111001", 99 => "11001010", 
    100 => "11100010", 101 => "00010111", 102 => "01101100", 103 => "11101101", 
    104 => "11011000", 105 => "11010011", 106 => "00001101", 107 => "00101110", 
    108 => "01101000", 109 => "11111010", 110 => "00100010", 111 => "11010111", 
    112 => "00001001", 113 => "00001000", 114 => "11110101", 115 => "00000011", 
    116 => "01000110", 117 => "11100110", 118 => "11010001", 119 => "11110011", 
    120 => "00100011", 121 => "11101111", 122 => "00101111", 123 => "00011100", 
    124 => "11011101", 125 => "00110011", 126 => "00010100", 127 => "00100111", 
    128 => "11101100", 129 => "00100011", 130 => "00000001", 131 => "00011001", 
    132 => "11001010", 133 => "11111010", 134 => "00011101", 135 => "11101101", 
    136 => "11010111", 137 => "01100010", 138 => "00001011", 139 => "11110101", 
    140 => "01001010", 141 => "00000100", 142 => "00101111", 143 => "00110000", 
    144 => "11001101", 145 => "00010110", 146 => "11110101", 147 => "00000011", 
    148 => "10111010", 149 => "11011000" );


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

entity gap_head_W_HEAD_Vheb is
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

architecture arch of gap_head_W_HEAD_Vheb is
    component gap_head_W_HEAD_Vheb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vheb_rom_U :  component gap_head_W_HEAD_Vheb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


