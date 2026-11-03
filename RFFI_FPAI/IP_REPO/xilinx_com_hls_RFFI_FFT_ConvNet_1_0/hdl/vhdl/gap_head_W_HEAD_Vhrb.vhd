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

entity gap_head_W_HEAD_Vhrb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhrb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100001", 1 => "10000001", 2 => "10111000", 3 => "11011010", 
    4 => "01111101", 5 => "00110001", 6 => "10101010", 7 => "00100001", 
    8 => "00110100", 9 => "00001000", 10 => "11100110", 11 => "00010000", 
    12 => "11001101", 13 => "00100011", 14 => "00100101", 15 => "00011111", 
    16 => "11101011", 17 => "11101111", 18 => "11111000", 19 => "10111100", 
    20 => "00001110", 21 => "11101000", 22 => "11010011", 23 => "00001110", 
    24 => "00100001", 25 => "00001111", 26 => "11100101", 27 => "00101000", 
    28 => "11111010", 29 => "00100111", 30 => "11011110", 31 => "11100101", 
    32 => "11011100", 33 => "00011010", 34 => "11111000", 35 => "11111010", 
    36 => "00111011", 37 => "00100011", 38 => "11011010", 39 => "01101111", 
    40 => "11111101", 41 => "11101111", 42 => "11000110", 43 => "10110111", 
    44 => "00010001", 45 => "01001010", 46 => "00001100", 47 => "00000000", 
    48 => "00100000", 49 => "01101001", 50 => "11010111", 51 => "11110110", 
    52 => "11111001", 53 => "11011010", 54 => "11010110", 55 => "11000100", 
    56 => "00000000", 57 => "00110110", 58 => "00001101", 59 => "01100001", 
    60 => "11110111", 61 => "11100101", 62 => "00011000", 63 => "01001010", 
    64 => "01000001", 65 => "00001110", 66 => "11001001", 67 => "00110000", 
    68 => "00000111", 69 => "00001011", 70 => "01001110", 71 => "00011101", 
    72 => "00110111", 73 => "01101000", 74 => "11100110", 75 => "11011101", 
    76 => "11010101", 77 => "11011111", 78 => "00101101", 79 => "00010100", 
    80 => "10011101", 81 => "11111100", 82 => "01000011", 83 => "10110001", 
    84 => "11110100", 85 => "11010011", 86 => "11100011", 87 => "00010111", 
    88 => "10110011", 89 => "11001111", 90 => "11110001", 91 => "00010010", 
    92 => "00101110", 93 => "11110010", 94 => "00100000", 95 => "00111110", 
    96 => "11100001", 97 => "00111000", 98 => "00011010", 99 => "00010001", 
    100 => "00101101", 101 => "00100001", 102 => "11111101", 103 => "11101011", 
    104 => "00100010", 105 => "11110110", 106 => "11100111", 107 => "00101110", 
    108 => "00011010", 109 => "11111001", 110 => "11001101", 111 => "00001101", 
    112 => "11101101", 113 => "11110101", 114 => "10111110", 115 => "00010101", 
    116 => "11110101", 117 => "00110100", 118 => "10110011", 119 => "00110001", 
    120 => "11100101", 121 => "11000010", 122 => "11110111", 123 => "01011100", 
    124 => "00001000", 125 => "11001110", 126 => "11110100", 127 => "01111111", 
    128 => "11011001", 129 => "11100010", 130 => "11111110", 131 => "11100100", 
    132 => "11111110", 133 => "10111001", 134 => "00010000", 135 => "11100100", 
    136 => "00010001", 137 => "10111111", 138 => "01001010", 139 => "10000001", 
    140 => "01111100", 141 => "11101011", 142 => "11100011", 143 => "11110011", 
    144 => "11001100", 145 => "00010101", 146 => "00001100", 147 => "00001111", 
    148 => "01000011", 149 => "10011011" );


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

entity gap_head_W_HEAD_Vhrb is
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

architecture arch of gap_head_W_HEAD_Vhrb is
    component gap_head_W_HEAD_Vhrb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhrb_rom_U :  component gap_head_W_HEAD_Vhrb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


