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

entity gap_head_W_HEAD_Vhzb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhzb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000010", 1 => "00011101", 2 => "11000110", 3 => "00000101", 
    4 => "10011101", 5 => "01000010", 6 => "01011011", 7 => "10110110", 
    8 => "10101101", 9 => "00010001", 10 => "10101101", 11 => "11010000", 
    12 => "10011010", 13 => "00000100", 14 => "00110101", 15 => "11001001", 
    16 => "11100100", 17 => "11101100", 18 => "10110101", 19 => "00000100", 
    20 => "11110011", 21 => "11101011", 22 => "01101011", 23 => "01111111", 
    24 => "11100001", 25 => "11000000", 26 => "11011000", 27 => "00000011", 
    28 => "00001100", 29 => "11101100", 30 => "00111111", 31 => "10100111", 
    32 => "00001001", 33 => "00001010", 34 => "00101110", 35 => "11111101", 
    36 => "00011100", 37 => "01001000", 38 => "11001100", 39 => "10010100", 
    40 => "01011100", 41 => "10010010", 42 => "10110011", 43 => "11011100", 
    44 => "01111000", 45 => "00100010", 46 => "01010110", 47 => "11001111", 
    48 => "00111010", 49 => "10100101", 50 => "10111010", 51 => "01001100", 
    52 => "01111111", 53 => "00000010", 54 => "10110100", 55 => "10111011", 
    56 => "00010100", 57 => "00001011", 58 => "00001111", 59 => "00010011", 
    60 => "11001010", 61 => "00110001", 62 => "01101000", 63 => "00011010", 
    64 => "01001101", 65 => "11111100", 66 => "00011110", 67 => "00110000", 
    68 => "11111000", 69 => "00101100", 70 => "01111011", 71 => "11100101", 
    72 => "10111111", 73 => "00001000", 74 => "11100000", 75 => "00100000", 
    76 => "11001110", 77 => "11111110", 78 => "00101100", 79 => "00101000", 
    80 => "11011111", 81 => "11101101", 82 => "00110001", 83 => "10100110", 
    84 => "00110111", 85 => "10110101", 86 => "00000100", 87 => "11111011", 
    88 => "00001100", 89 => "00000111", 90 => "00010010", 91 => "00011011", 
    92 => "00000100", 93 => "00111011", 94 => "00001111", 95 => "11010000", 
    96 => "10111010", 97 => "01010111", 98 => "00000111", 99 => "11010100", 
    100 => "11110010", 101 => "01000100", 102 => "11110111", 103 => "10101111", 
    104 => "01111111", 105 => "11010000", 106 => "00100011", 107 => "01101010", 
    108 => "01010011", 109 => "11000100", 110 => "00001111", 111 => "11101100", 
    112 => "00100110", 113 => "00111000", 114 => "10011110", 115 => "11001110", 
    116 => "11010101", 117 => "00110001", 118 => "00101011", 119 => "01001110", 
    120 => "11111100", 121 => "00000001", 122 => "10010110", 123 => "10111011", 
    124 => "11001100", 125 => "00001010", 126 => "11101100", 127 => "01011100", 
    128 => "11101000", 129 => "11110001", 130 => "00000000", 131 => "01111111", 
    132 => "10000001", 133 => "00000010", 134 => "11001101", 135 => "11011000", 
    136 => "00101000", 137 => "11001100", 138 => "00011001", 139 => "00001111", 
    140 => "00101101", 141 => "11100001", 142 => "00101111", 143 => "10111111", 
    144 => "10101101", 145 => "11111011", 146 => "00110100", 147 => "00001001", 
    148 => "11001101", 149 => "10100011" );


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

entity gap_head_W_HEAD_Vhzb is
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

architecture arch of gap_head_W_HEAD_Vhzb is
    component gap_head_W_HEAD_Vhzb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhzb_rom_U :  component gap_head_W_HEAD_Vhzb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


