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

entity gap_head_W_HEAD_Vhjb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhjb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010000", 1 => "00000000", 2 => "00001011", 3 => "00001101", 
    4 => "01001000", 5 => "11111011", 6 => "11001101", 7 => "11110001", 
    8 => "11011000", 9 => "11100001", 10 => "00001111", 11 => "00100100", 
    12 => "01000001", 13 => "11101001", 14 => "11001110", 15 => "00001101", 
    16 => "00010000", 17 => "11000001", 18 => "00010110", 19 => "00000000", 
    20 => "00110101", 21 => "11100101", 22 => "00001000", 23 => "11011001", 
    24 => "00010001", 25 => "00101100", 26 => "11010011", 27 => "11011110", 
    28 => "00101011", 29 => "00111100", 30 => "00101101", 31 => "11101010", 
    32 => "00101001", 33 => "11110111", 34 => "11111110", 35 => "01010001", 
    36 => "00101100", 37 => "11100000", 38 => "00000011", 39 => "11010001", 
    40 => "00001101", 41 => "11010110", 42 => "00111110", 43 => "01001100", 
    44 => "11110001", 45 => "00011001", 46 => "00001101", 47 => "00100011", 
    48 => "11000110", 49 => "11011110", 50 => "00011100", 51 => "00001110", 
    52 => "00000100", 53 => "00111111", 54 => "11101000", 55 => "11111100", 
    56 => "11001001", 57 => "11010110", 58 => "01001011", 59 => "11111001", 
    60 => "11111000", 61 => "11110000", 62 => "11101000", 63 => "11101010", 
    64 => "00101001", 65 => "01001100", 66 => "11001100", 67 => "11100111", 
    68 => "00001000", 69 => "10111111", 70 => "01000001", 71 => "00100001", 
    72 => "00111100", 73 => "11111100", 74 => "00000110", 75 => "00000111", 
    76 => "11010100", 77 => "00011001", 78 => "11110010", 79 => "11100001", 
    80 => "11111000", 81 => "00010111", 82 => "00011010", 83 => "00100110", 
    84 => "00000000", 85 => "00110111", 86 => "11100011", 87 => "00001000", 
    88 => "11110100", 89 => "00110110", 90 => "11010010", 91 => "00001000", 
    92 => "00110101", 93 => "11101000", 94 => "11111010", 95 => "11011101", 
    96 => "00000110", 97 => "10111100", 98 => "11111001", 99 => "11000011", 
    100 => "11101111", 101 => "00000101", 102 => "00100011", 103 => "11011001", 
    104 => "11001111", 105 => "00100001", 106 => "00001001", 107 => "11101110", 
    108 => "11010111", 109 => "11100100", 110 => "00101111", 111 => "11101011", 
    112 => "00001101", 113 => "11110100", 114 => "11111011", 115 => "00010011", 
    116 => "11101101", 117 => "11111010", 118 => "00011111", 119 => "00000111", 
    120 => "01000100", 121 => "00000101", 122 => "11111011", 123 => "11011100", 
    124 => "00101010", 125 => "11011101", 126 => "11100011", 127 => "11100000", 
    128 => "11100101", 129 => "11100110", 130 => "00010101", 131 => "00000000", 
    132 => "11110010", 133 => "00100001", 134 => "11111101", 135 => "11111011", 
    136 => "11100011", 137 => "11000010", 138 => "11100101", 139 => "00100010", 
    140 => "11101111", 141 => "00000111", 142 => "11011010", 143 => "00100101", 
    144 => "00010101", 145 => "11101000", 146 => "11111010", 147 => "11100001", 
    148 => "00011101", 149 => "00110011" );


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

entity gap_head_W_HEAD_Vhjb is
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

architecture arch of gap_head_W_HEAD_Vhjb is
    component gap_head_W_HEAD_Vhjb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhjb_rom_U :  component gap_head_W_HEAD_Vhjb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


