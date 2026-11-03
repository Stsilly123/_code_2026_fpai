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

entity gap_head_W_HEAD_VgYb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgYb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110111", 1 => "00101000", 2 => "11101110", 3 => "00110100", 
    4 => "11111011", 5 => "00111100", 6 => "00011110", 7 => "11000110", 
    8 => "01001010", 9 => "11101000", 10 => "00010101", 11 => "01000011", 
    12 => "00000001", 13 => "11010000", 14 => "11101000", 15 => "11011101", 
    16 => "10111101", 17 => "11110001", 18 => "11101000", 19 => "11001010", 
    20 => "00101011", 21 => "00011101", 22 => "11010110", 23 => "11101110", 
    24 => "00100110", 25 => "00101100", 26 => "10000001", 27 => "11110000", 
    28 => "00100000", 29 => "00011100", 30 => "00100010", 31 => "11111111", 
    32 => "00001000", 33 => "00101010", 34 => "11100110", 35 => "01011111", 
    36 => "00011010", 37 => "00000100", 38 => "11001010", 39 => "00111111", 
    40 => "10101111", 41 => "10001000", 42 => "01101101", 43 => "00000101", 
    44 => "11111011", 45 => "01010010", 46 => "11011100", 47 => "11100010", 
    48 => "11001110", 49 => "11010111", 50 => "00010000", 51 => "11011011", 
    52 => "10010111", 53 => "00001010", 54 => "00011010", 55 => "00100001", 
    56 => "11100101", 57 => "11010101", 58 => "00100010", 59 => "00000100", 
    60 => "00001110", 61 => "00011110", 62 => "11100000", 63 => "00000001", 
    64 => "00010010", 65 => "00011000", 66 => "00101001", 67 => "00100011", 
    68 => "00000001", 69 => "10000001", 70 => "11010001", 71 => "00010110", 
    72 => "11111100", 73 => "01000101", 74 => "11110100", 75 => "00101101", 
    76 => "00101100", 77 => "11110111", 78 => "11011000", 79 => "11111000", 
    80 => "00010010", 81 => "00011100", 82 => "00011111", 83 => "11111001", 
    84 => "00101000", 85 => "11101110", 86 => "00000010", 87 => "00100101", 
    88 => "00101100", 89 => "00110011", 90 => "11100110", 91 => "00011101", 
    92 => "11111000", 93 => "11101101", 94 => "11111010", 95 => "11000010", 
    96 => "11111111", 97 => "10111001", 98 => "11101101", 99 => "00111110", 
    100 => "01010011", 101 => "10111010", 102 => "00011011", 103 => "11000111", 
    104 => "11101101", 105 => "11000000", 106 => "11111000", 107 => "11110100", 
    108 => "00000000", 109 => "11001101", 110 => "11000110", 111 => "00000110", 
    112 => "11111011", 113 => "11000001", 114 => "00101100", 115 => "11101001", 
    116 => "00111001", 117 => "11110011", 118 => "00110111", 119 => "00010000", 
    120 => "11101111", 121 => "11110100", 122 => "00001001", 123 => "11110101", 
    124 => "00011101", 125 => "11011011", 126 => "11101011", 127 => "11101010", 
    128 => "11111111", 129 => "11110111", 130 => "00110111", 131 => "10111101", 
    132 => "11100110", 133 => "00001001", 134 => "00101001", 135 => "11101011", 
    136 => "00001110", 137 => "00100000", 138 => "11110000", 139 => "00000110", 
    140 => "01010000", 141 => "11011010", 142 => "11101111", 143 => "00000000", 
    144 => "00001001", 145 => "11011111", 146 => "11111011", 147 => "00000001", 
    148 => "00001011", 149 => "11100111" );


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

entity gap_head_W_HEAD_VgYb is
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

architecture arch of gap_head_W_HEAD_VgYb is
    component gap_head_W_HEAD_VgYb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgYb_rom_U :  component gap_head_W_HEAD_VgYb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


