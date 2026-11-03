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

entity gap_head_W_HEAD_Vg8b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg8b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110011", 1 => "11011110", 2 => "00100011", 3 => "11100011", 
    4 => "00000101", 5 => "00010010", 6 => "11001010", 7 => "11101000", 
    8 => "11101001", 9 => "10100111", 10 => "00000010", 11 => "00100010", 
    12 => "11000100", 13 => "00101010", 14 => "11011011", 15 => "00010111", 
    16 => "00001000", 17 => "10110110", 18 => "11101111", 19 => "11100111", 
    20 => "11101101", 21 => "11101000", 22 => "11110010", 23 => "00010001", 
    24 => "00011000", 25 => "00000101", 26 => "00001101", 27 => "00100011", 
    28 => "11111110", 29 => "11111010", 30 => "00001000", 31 => "01001010", 
    32 => "11100110", 33 => "11101110", 34 => "11100110", 35 => "11100100", 
    36 => "11011000", 37 => "00010111", 38 => "00010001", 39 => "00000100", 
    40 => "11101100", 41 => "00101011", 42 => "11110100", 43 => "00000010", 
    44 => "00010100", 45 => "00000110", 46 => "11101000", 47 => "11111111", 
    48 => "00011101", 49 => "01000001", 50 => "11101011", 51 => "11111011", 
    52 => "10001011", 53 => "00010000", 54 => "00100100", 55 => "00001101", 
    56 => "11110010", 57 => "00110110", 58 => "00100101", 59 => "00001110", 
    60 => "11110011", 61 => "11111111", 62 => "11100111", 63 => "11101001", 
    64 => "11101111", 65 => "00010111", 66 => "00011111", 67 => "11100011", 
    68 => "11101101", 69 => "00100110", 70 => "11001011", 71 => "11110001", 
    72 => "00000000", 73 => "00011011", 74 => "01011011", 75 => "00100111", 
    76 => "11011101", 77 => "11011011", 78 => "11101111", 79 => "00010001", 
    80 => "00011101", 81 => "00100100", 82 => "11110101", 83 => "01000101", 
    84 => "00001010", 85 => "00100111", 86 => "11101110", 87 => "01100000", 
    88 => "00000001", 89 => "00001010", 90 => "00010110", 91 => "11110010", 
    92 => "11111100", 93 => "11001011", 94 => "01000010", 95 => "00101011", 
    96 => "00100110", 97 => "00001010", 98 => "11101111", 99 => "11011110", 
    100 => "11010000", 101 => "11100100", 102 => "11010000", 103 => "00100001", 
    104 => "00011100", 105 => "11000111", 106 => "00110110", 107 => "00000100", 
    108 => "00001001", 109 => "00100001", 110 => "11110100", 111 => "11001101", 
    112 => "00000110", 113 => "00000000", 114 => "10110101", 115 => "00101000", 
    116 => "11010001", 117 => "11110111", 118 => "11111001", 119 => "11110110", 
    120 => "10011100", 121 => "11101000", 122 => "11100101", 123 => "00101100", 
    124 => "01010111", 125 => "11010001", 126 => "11100111", 127 => "11101001", 
    128 => "11110001", 129 => "00011001", 130 => "11011010", 131 => "00101100", 
    132 => "00010111", 133 => "11100011", 134 => "11100100", 135 => "11111110", 
    136 => "11101010", 137 => "01100011", 138 => "00011011", 139 => "11101101", 
    140 => "00011100", 141 => "11110101", 142 => "11101100", 143 => "11111001", 
    144 => "00110010", 145 => "00000001", 146 => "00010100", 147 => "11101000", 
    148 => "00010001", 149 => "00101011" );


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

entity gap_head_W_HEAD_Vg8b is
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

architecture arch of gap_head_W_HEAD_Vg8b is
    component gap_head_W_HEAD_Vg8b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg8b_rom_U :  component gap_head_W_HEAD_Vg8b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


