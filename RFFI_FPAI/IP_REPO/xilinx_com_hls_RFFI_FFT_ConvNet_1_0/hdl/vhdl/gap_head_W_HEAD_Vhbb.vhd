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

entity gap_head_W_HEAD_Vhbb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhbb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000110", 1 => "00100111", 2 => "00100101", 3 => "01011110", 
    4 => "11110101", 5 => "00100101", 6 => "00101100", 7 => "11111101", 
    8 => "00111011", 9 => "01111100", 10 => "00111100", 11 => "00111010", 
    12 => "10000011", 13 => "00000101", 14 => "01001100", 15 => "00011100", 
    16 => "10101000", 17 => "11010011", 18 => "11000111", 19 => "11101100", 
    20 => "11111010", 21 => "00100100", 22 => "00101101", 23 => "11101110", 
    24 => "01011110", 25 => "00100010", 26 => "11100101", 27 => "00001101", 
    28 => "11111101", 29 => "00110101", 30 => "00110110", 31 => "01011011", 
    32 => "01011100", 33 => "11010100", 34 => "00010011", 35 => "11111110", 
    36 => "11011110", 37 => "00010000", 38 => "10000001", 39 => "00100001", 
    40 => "00101101", 41 => "11010101", 42 => "00010101", 43 => "00010111", 
    44 => "11001101", 45 => "10111110", 46 => "00100001", 47 => "00011111", 
    48 => "00000000", 49 => "11001011", 50 => "11111011", 51 => "00111110", 
    52 => "00001001", 53 => "10011010", 54 => "11010101", 55 => "00000011", 
    56 => "11100010", 57 => "11101000", 58 => "00011111", 59 => "10111100", 
    60 => "11001000", 61 => "11011001", 62 => "11010111", 63 => "11011001", 
    64 => "11010111", 65 => "00100011", 66 => "10101100", 67 => "01011011", 
    68 => "11010110", 69 => "00001110", 70 => "00100010", 71 => "11110000", 
    72 => "00011101", 73 => "10011111", 74 => "11000110", 75 => "11100111", 
    76 => "01000110", 77 => "10111101", 78 => "00101101", 79 => "11101010", 
    80 => "10011010", 81 => "11111000", 82 => "11110000", 83 => "10010100", 
    84 => "00010010", 85 => "01001010", 86 => "00000010", 87 => "10001010", 
    88 => "10101010", 89 => "11101100", 90 => "11001110", 91 => "00010111", 
    92 => "10110000", 93 => "00011001", 94 => "00100111", 95 => "00100011", 
    96 => "00001111", 97 => "11110001", 98 => "11110100", 99 => "11110011", 
    100 => "01110000", 101 => "00110100", 102 => "10000100", 103 => "10000001", 
    104 => "00111100", 105 => "00010111", 106 => "11110010", 107 => "11011011", 
    108 => "00011111", 109 => "11101001", 110 => "11000010", 111 => "11110011", 
    112 => "11011101", 113 => "00110000", 114 => "00101101", 115 => "00100100", 
    116 => "00011010", 117 => "11101010", 118 => "01000100", 119 => "00111000", 
    120 => "10110110", 121 => "00101001", 122 => "00010011", 123 => "10001100", 
    124 => "01001010", 125 => "11110111", 126 => "01010010", 127 => "00000000", 
    128 => "10101110", 129 => "00110101", 130 => "00111100", 131 => "10100100", 
    132 => "00001001", 133 => "11111111", 134 => "00111011", 135 => "00011001", 
    136 => "11010111", 137 => "00011111", 138 => "00101010", 139 => "00000111", 
    140 => "11100000", 141 => "11011011", 142 => "11010110", 143 => "11001110", 
    144 => "00100110", 145 => "11011111", 146 => "11110100", 147 => "11110010", 
    148 => "00011011", 149 => "11001001" );


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

entity gap_head_W_HEAD_Vhbb is
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

architecture arch of gap_head_W_HEAD_Vhbb is
    component gap_head_W_HEAD_Vhbb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhbb_rom_U :  component gap_head_W_HEAD_Vhbb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


