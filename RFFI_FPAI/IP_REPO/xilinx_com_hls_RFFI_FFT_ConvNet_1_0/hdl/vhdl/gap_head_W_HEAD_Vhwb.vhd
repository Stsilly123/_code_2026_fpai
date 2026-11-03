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

entity gap_head_W_HEAD_Vhwb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhwb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11011000", 1 => "00111001", 2 => "11100010", 3 => "11111110", 
    4 => "00011000", 5 => "00000111", 6 => "00111001", 7 => "11101011", 
    8 => "11111011", 9 => "10111001", 10 => "11010011", 11 => "11110101", 
    12 => "11010110", 13 => "00001101", 14 => "11110101", 15 => "00001110", 
    16 => "00110101", 17 => "11001101", 18 => "11111000", 19 => "11100011", 
    20 => "11111010", 21 => "11111110", 22 => "11001000", 23 => "11111110", 
    24 => "11110001", 25 => "00101011", 26 => "11110000", 27 => "11101111", 
    28 => "00100100", 29 => "11010100", 30 => "01010101", 31 => "11100011", 
    32 => "00111011", 33 => "11111010", 34 => "11101010", 35 => "00001100", 
    36 => "00011011", 37 => "00000101", 38 => "11010111", 39 => "00111000", 
    40 => "11001110", 41 => "11100000", 42 => "11101101", 43 => "01001101", 
    44 => "01000101", 45 => "00001011", 46 => "00001100", 47 => "00011101", 
    48 => "00000000", 49 => "01011000", 50 => "11110000", 51 => "00011100", 
    52 => "00100111", 53 => "00000110", 54 => "11101110", 55 => "00110010", 
    56 => "00101110", 57 => "00001110", 58 => "01010011", 59 => "00101110", 
    60 => "11101111", 61 => "11111111", 62 => "11110011", 63 => "00011010", 
    64 => "00001000", 65 => "00111000", 66 => "11111001", 67 => "00010001", 
    68 => "00001110", 69 => "11111001", 70 => "00011101", 71 => "00101001", 
    72 => "00000110", 73 => "01010000", 74 => "00001111", 75 => "00100001", 
    76 => "11100000", 77 => "00000000", 78 => "11001101", 79 => "11101000", 
    80 => "00100111", 81 => "11100111", 82 => "00001100", 83 => "00011001", 
    84 => "11101110", 85 => "00000110", 86 => "00001111", 87 => "00011101", 
    88 => "11110011", 89 => "11111110", 90 => "00100001", 91 => "00111110", 
    92 => "11010000", 93 => "00001000", 94 => "11110001", 95 => "00000111", 
    96 => "11100110", 97 => "11101101", 98 => "11100100", 99 => "11100110", 
    100 => "01000000", 101 => "11100000", 102 => "00101101", 103 => "11100111", 
    104 => "11101111", 105 => "00010010", 106 => "00000011", 107 => "00001010", 
    108 => "00101101", 109 => "00011101", 110 => "11101001", 111 => "00000101", 
    112 => "00010000", 113 => "11010010", 114 => "01000001", 115 => "11110100", 
    116 => "11011100", 117 => "11111101", 118 => "00111110", 119 => "00010000", 
    120 => "00110001", 121 => "11011100", 122 => "00001011", 123 => "11011000", 
    124 => "00000110", 125 => "11101001", 126 => "00101101", 127 => "11110111", 
    128 => "11000101", 129 => "00010100", 130 => "00001001", 131 => "00001010", 
    132 => "11100111", 133 => "00010101", 134 => "00010000", 135 => "11101011", 
    136 => "10010110", 137 => "11110001", 138 => "00001111", 139 => "00100100", 
    140 => "00000101", 141 => "11100010", 142 => "11111100", 143 => "11101000", 
    144 => "11001100", 145 => "11101001", 146 => "00100011", 147 => "00000110", 
    148 => "11100100", 149 => "11110111" );


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

entity gap_head_W_HEAD_Vhwb is
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

architecture arch of gap_head_W_HEAD_Vhwb is
    component gap_head_W_HEAD_Vhwb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhwb_rom_U :  component gap_head_W_HEAD_Vhwb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


