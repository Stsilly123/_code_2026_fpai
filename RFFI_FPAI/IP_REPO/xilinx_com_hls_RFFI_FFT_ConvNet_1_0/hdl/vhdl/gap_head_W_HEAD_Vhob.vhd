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

entity gap_head_W_HEAD_Vhob_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhob_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011001", 1 => "11111111", 2 => "11000000", 3 => "11001011", 
    4 => "00110100", 5 => "11111101", 6 => "10110011", 7 => "01000110", 
    8 => "11100111", 9 => "11010001", 10 => "00000111", 11 => "11010010", 
    12 => "00110110", 13 => "00011110", 14 => "11011010", 15 => "00110000", 
    16 => "01010111", 17 => "11011010", 18 => "00101110", 19 => "01001110", 
    20 => "01000111", 21 => "11101111", 22 => "10101110", 23 => "11001010", 
    24 => "11101001", 25 => "00111000", 26 => "11101001", 27 => "00010010", 
    28 => "00010001", 29 => "11001001", 30 => "00100111", 31 => "10100100", 
    32 => "00010000", 33 => "00101101", 34 => "00110001", 35 => "11011110", 
    36 => "11111011", 37 => "11101101", 38 => "01101010", 39 => "00000111", 
    40 => "00001000", 41 => "00010010", 42 => "00000010", 43 => "00101101", 
    44 => "00110001", 45 => "11011101", 46 => "00001010", 47 => "01001110", 
    48 => "00000010", 49 => "11100101", 50 => "00001110", 51 => "00001010", 
    52 => "00000000", 53 => "00001111", 54 => "00100101", 55 => "00101100", 
    56 => "00111001", 57 => "10011010", 58 => "00011010", 59 => "11011101", 
    60 => "00000111", 61 => "11111001", 62 => "11110110", 63 => "11110000", 
    64 => "01000101", 65 => "11011001", 66 => "11111110", 67 => "00101011", 
    68 => "11010110", 69 => "11101001", 70 => "00100000", 71 => "00111010", 
    72 => "11001110", 73 => "11000111", 74 => "11100010", 75 => "00011101", 
    76 => "00011001", 77 => "11110001", 78 => "00000000", 79 => "00000010", 
    80 => "11001001", 81 => "11100100", 82 => "00100010", 83 => "11000001", 
    84 => "11100010", 85 => "11011100", 86 => "00011110", 87 => "11001010", 
    88 => "00010001", 89 => "00101111", 90 => "00010100", 91 => "11011101", 
    92 => "11100101", 93 => "11111110", 94 => "11011011", 95 => "11011010", 
    96 => "11101111", 97 => "11011111", 98 => "00000111", 99 => "11101111", 
    100 => "00000100", 101 => "11110000", 102 => "00111100", 103 => "11111110", 
    104 => "00001000", 105 => "00101110", 106 => "00000001", 107 => "11110011", 
    108 => "01100000", 109 => "11000101", 110 => "11010101", 111 => "00010001", 
    112 => "00001111", 113 => "00100001", 114 => "01110100", 115 => "00000010", 
    116 => "00100000", 117 => "11100110", 118 => "01000010", 119 => "11000011", 
    120 => "11101100", 121 => "11011111", 122 => "00110101", 123 => "00101110", 
    124 => "00101000", 125 => "00000001", 126 => "00111100", 127 => "00001000", 
    128 => "11011010", 129 => "00100001", 130 => "11111011", 131 => "00111010", 
    132 => "00000000", 133 => "00001010", 134 => "00000001", 135 => "10010010", 
    136 => "10101001", 137 => "01000101", 138 => "00100110", 139 => "11011101", 
    140 => "00010011", 141 => "11110101", 142 => "00000001", 143 => "00111111", 
    144 => "11011010", 145 => "11011101", 146 => "00110111", 147 => "11100011", 
    148 => "00011101", 149 => "00001111" );


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

entity gap_head_W_HEAD_Vhob is
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

architecture arch of gap_head_W_HEAD_Vhob is
    component gap_head_W_HEAD_Vhob_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhob_rom_U :  component gap_head_W_HEAD_Vhob_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


