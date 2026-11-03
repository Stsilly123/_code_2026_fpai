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

entity gap_head_W_HEAD_V_4_rom is 
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


architecture rtl of gap_head_W_HEAD_V_4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100111", 1 => "00001100", 2 => "10111010", 3 => "11001110", 
    4 => "00111011", 5 => "11101011", 6 => "00010100", 7 => "00001111", 
    8 => "11110000", 9 => "11000111", 10 => "00010111", 11 => "00101110", 
    12 => "01001011", 13 => "10011010", 14 => "11010001", 15 => "00000100", 
    16 => "01111111", 17 => "00000100", 18 => "00001011", 19 => "00100111", 
    20 => "00010101", 21 => "11100000", 22 => "11101100", 23 => "10101111", 
    24 => "11111110", 25 => "01111111", 26 => "11111111", 27 => "00010010", 
    28 => "11010010", 29 => "11101001", 30 => "10100000", 31 => "01111111", 
    32 => "11111111", 33 => "11101110", 34 => "11100100", 35 => "00001000", 
    36 => "11110010", 37 => "00000011", 38 => "00101001", 39 => "11010100", 
    40 => "01000011", 41 => "11100010", 42 => "11111011", 43 => "10101101", 
    44 => "10110110", 45 => "11011100", 46 => "11101110", 47 => "01110100", 
    48 => "00011110", 49 => "11011000", 50 => "00001110", 51 => "00101000", 
    52 => "00110101", 53 => "01101110", 54 => "01100010", 55 => "01011101", 
    56 => "00010110", 57 => "01110000", 58 => "11111010", 59 => "11011010", 
    60 => "00110000", 61 => "00001000", 62 => "11001001", 63 => "11010111", 
    64 => "00000101", 65 => "11100010", 66 => "00001100", 67 => "01001010", 
    68 => "00100100", 69 => "11011000", 70 => "00100111", 71 => "11100000", 
    72 => "00010001", 73 => "10110001", 74 => "11010000", 75 => "11111011", 
    76 => "00101100", 77 => "00011111", 78 => "00100100", 79 => "10101100", 
    80 => "10111010", 81 => "11100111", 82 => "00110001", 83 => "10110010", 
    84 => "00110110", 85 => "11011100", 86 => "00001010", 87 => "11101101", 
    88 => "11100001", 89 => "10100010", 90 => "00001001", 91 => "11010111", 
    92 => "00101010", 93 => "11111111", 94 => "01000101", 95 => "11000011", 
    96 => "00001100", 97 => "00100000", 98 => "00001100", 99 => "11001101", 
    100 => "11111001", 101 => "01101010", 102 => "01111111", 103 => "00010000", 
    104 => "11100010", 105 => "01000101", 106 => "00011000", 107 => "01001101", 
    108 => "00000111", 109 => "11110100", 110 => "01000101", 111 => "00010011", 
    112 => "11000101", 113 => "11111011", 114 => "11100000", 115 => "11111000", 
    116 => "01101010", 117 => "11010000", 118 => "10111010", 119 => "11010010", 
    120 => "01110000", 121 => "11111011", 122 => "11101000", 123 => "11010101", 
    124 => "11100101", 125 => "11101111", 126 => "11101001", 127 => "11001110", 
    128 => "11001101", 129 => "11001100", 130 => "00101011", 131 => "00001010", 
    132 => "11110101", 133 => "00010111", 134 => "00011011", 135 => "00000010", 
    136 => "10111110", 137 => "11100110", 138 => "00011010", 139 => "00011001", 
    140 => "11010010", 141 => "00110101", 142 => "01001000", 143 => "00110100", 
    144 => "01100101", 145 => "01000000", 146 => "11110000", 147 => "11111000", 
    148 => "11101100", 149 => "11001100" );


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

entity gap_head_W_HEAD_V_4 is
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

architecture arch of gap_head_W_HEAD_V_4 is
    component gap_head_W_HEAD_V_4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_4_rom_U :  component gap_head_W_HEAD_V_4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


