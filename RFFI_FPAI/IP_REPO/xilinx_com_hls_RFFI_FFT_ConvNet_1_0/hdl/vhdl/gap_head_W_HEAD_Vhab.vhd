-- ==============================================================
-- File generated on Sun Oct 18 16:53:15 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vhab_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhab_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000110", 1 => "00000000", 2 => "00101000", 3 => "01011101", 
    4 => "11111101", 5 => "00110111", 6 => "01101100", 7 => "00000110", 
    8 => "00110000", 9 => "00101010", 10 => "10111010", 11 => "00110011", 
    12 => "11000101", 13 => "00101100", 14 => "00111110", 15 => "00101010", 
    16 => "11101111", 17 => "00110101", 18 => "11100110", 19 => "00011111", 
    20 => "11111101", 21 => "11101110", 22 => "00011000", 23 => "00110100", 
    24 => "00111110", 25 => "11111010", 26 => "00100011", 27 => "11110000", 
    28 => "11110001", 29 => "01011100", 30 => "11010000", 31 => "00001111", 
    32 => "01000111", 33 => "00001111", 34 => "00101111", 35 => "00000110", 
    36 => "11001101", 37 => "11010100", 38 => "00010010", 39 => "11111110", 
    40 => "11111000", 41 => "11110011", 42 => "00111000", 43 => "00000110", 
    44 => "11000000", 45 => "11110001", 46 => "01010110", 47 => "00101111", 
    48 => "00011010", 49 => "11111001", 50 => "11011101", 51 => "00111010", 
    52 => "00110010", 53 => "01011001", 54 => "00000011", 55 => "00010010", 
    56 => "00000010", 57 => "11000110", 58 => "11010111", 59 => "11011001", 
    60 => "10111100", 61 => "11111101", 62 => "11100100", 63 => "11011111", 
    64 => "11101100", 65 => "00010000", 66 => "11011011", 67 => "01110000", 
    68 => "11111011", 69 => "01001010", 70 => "11101110", 71 => "11101000", 
    72 => "11111100", 73 => "00000001", 74 => "11100101", 75 => "11110010", 
    76 => "00010110", 77 => "11010000", 78 => "00000010", 79 => "11100110", 
    80 => "00001110", 81 => "11011010", 82 => "11111100", 83 => "11001101", 
    84 => "01100110", 85 => "00101111", 86 => "01001011", 87 => "11011111", 
    88 => "00011100", 89 => "11010001", 90 => "00011111", 91 => "01000011", 
    92 => "11011110", 93 => "00101011", 94 => "11100001", 95 => "01001010", 
    96 => "00000100", 97 => "11110000", 98 => "00100100", 99 => "00011000", 
    100 => "00000000", 101 => "11001000", 102 => "11101010", 103 => "00011010", 
    104 => "00110001", 105 => "11011010", 106 => "00001010", 107 => "10100010", 
    108 => "00000101", 109 => "00001110", 110 => "10110111", 111 => "01000110", 
    112 => "11111001", 113 => "00101101", 114 => "11001010", 115 => "11111001", 
    116 => "00101000", 117 => "11011000", 118 => "11101011", 119 => "00110110", 
    120 => "11100110", 121 => "00100000", 122 => "00010001", 123 => "00101111", 
    124 => "10111101", 125 => "00010000", 126 => "11010010", 127 => "00001010", 
    128 => "11011011", 129 => "00101110", 130 => "00101100", 131 => "00000101", 
    132 => "11001100", 133 => "00000010", 134 => "00011000", 135 => "11101111", 
    136 => "11100101", 137 => "01000000", 138 => "00000101", 139 => "00010110", 
    140 => "11100011", 141 => "00011011", 142 => "11100001", 143 => "00000001", 
    144 => "00111011", 145 => "11110100", 146 => "11101001", 147 => "00100100", 
    148 => "10111100", 149 => "10100101" );


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

entity gap_head_W_HEAD_Vhab is
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

architecture arch of gap_head_W_HEAD_Vhab is
    component gap_head_W_HEAD_Vhab_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhab_rom_U :  component gap_head_W_HEAD_Vhab_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


