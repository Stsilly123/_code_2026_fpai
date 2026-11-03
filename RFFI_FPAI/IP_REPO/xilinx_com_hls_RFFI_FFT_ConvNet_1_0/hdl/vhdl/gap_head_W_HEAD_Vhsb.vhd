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

entity gap_head_W_HEAD_Vhsb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhsb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110010", 1 => "11100000", 2 => "00011101", 3 => "11010010", 
    4 => "11010101", 5 => "11100001", 6 => "11111010", 7 => "11101101", 
    8 => "11111001", 9 => "00011001", 10 => "11011000", 11 => "00011110", 
    12 => "00100111", 13 => "11011000", 14 => "00100101", 15 => "00100100", 
    16 => "00101111", 17 => "11000001", 18 => "00000100", 19 => "11001110", 
    20 => "11111000", 21 => "00010010", 22 => "00010100", 23 => "00010111", 
    24 => "11111101", 25 => "11110100", 26 => "00100101", 27 => "11101110", 
    28 => "00000000", 29 => "11111110", 30 => "11110001", 31 => "00110011", 
    32 => "00010100", 33 => "11110000", 34 => "11000101", 35 => "00011000", 
    36 => "11101101", 37 => "11100011", 38 => "00010000", 39 => "00000011", 
    40 => "00010101", 41 => "11100101", 42 => "11100100", 43 => "11011101", 
    44 => "11101010", 45 => "00010001", 46 => "11101000", 47 => "11110111", 
    48 => "10110100", 49 => "11111011", 50 => "00101001", 51 => "11110100", 
    52 => "01000101", 53 => "11111111", 54 => "00110011", 55 => "11110000", 
    56 => "00001001", 57 => "00001100", 58 => "11110001", 59 => "11111101", 
    60 => "00100000", 61 => "00101101", 62 => "11010101", 63 => "00001100", 
    64 => "10111001", 65 => "00110010", 66 => "00110100", 67 => "11011000", 
    68 => "11110110", 69 => "00110000", 70 => "11101011", 71 => "11100001", 
    72 => "00001111", 73 => "11001000", 74 => "11111010", 75 => "11111111", 
    76 => "11110110", 77 => "00100000", 78 => "10110100", 79 => "00101101", 
    80 => "00001110", 81 => "00101000", 82 => "11110101", 83 => "00111101", 
    84 => "11010010", 85 => "01110000", 86 => "11101111", 87 => "00000000", 
    88 => "01100110", 89 => "00001111", 90 => "00101000", 91 => "00000111", 
    92 => "11111010", 93 => "00101000", 94 => "11101010", 95 => "01000010", 
    96 => "00100100", 97 => "11100000", 98 => "00000010", 99 => "11100011", 
    100 => "11101000", 101 => "10011011", 102 => "00001110", 103 => "11111001", 
    104 => "11101110", 105 => "11110010", 106 => "00011110", 107 => "10101100", 
    108 => "11011011", 109 => "11100011", 110 => "00000000", 111 => "00100000", 
    112 => "00000100", 113 => "00011110", 114 => "00101111", 115 => "11100000", 
    116 => "11101100", 117 => "11101101", 118 => "11110101", 119 => "00011011", 
    120 => "00100110", 121 => "11101011", 122 => "00011010", 123 => "11010101", 
    124 => "11000111", 125 => "00110101", 126 => "00010010", 127 => "10111001", 
    128 => "00101010", 129 => "00000001", 130 => "00001100", 131 => "00011001", 
    132 => "00010000", 133 => "00110001", 134 => "11101110", 135 => "00010111", 
    136 => "00001111", 137 => "01001011", 138 => "11110100", 139 => "11111011", 
    140 => "11010101", 141 => "00000100", 142 => "11010010", 143 => "11001101", 
    144 => "01011001", 145 => "00010010", 146 => "11010111", 147 => "11101101", 
    148 => "11100001", 149 => "11010101" );


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

entity gap_head_W_HEAD_Vhsb is
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

architecture arch of gap_head_W_HEAD_Vhsb is
    component gap_head_W_HEAD_Vhsb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhsb_rom_U :  component gap_head_W_HEAD_Vhsb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


