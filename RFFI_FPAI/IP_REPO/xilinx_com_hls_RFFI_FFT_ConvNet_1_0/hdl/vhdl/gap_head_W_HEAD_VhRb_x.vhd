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

entity gap_head_W_HEAD_VhRb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhRb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110011", 1 => "00011001", 2 => "00110110", 3 => "11110001", 
    4 => "11111100", 5 => "01011101", 6 => "00001010", 7 => "11101001", 
    8 => "11000111", 9 => "00100100", 10 => "11110111", 11 => "11101110", 
    12 => "00111110", 13 => "11100110", 14 => "11100100", 15 => "00100011", 
    16 => "11010101", 17 => "10101001", 18 => "00101110", 19 => "11011010", 
    20 => "10111110", 21 => "11100111", 22 => "00101000", 23 => "00000011", 
    24 => "01010000", 25 => "11111110", 26 => "00010101", 27 => "00011100", 
    28 => "11110010", 29 => "01011001", 30 => "11110000", 31 => "11001110", 
    32 => "00110101", 33 => "11110000", 34 => "00000100", 35 => "01010100", 
    36 => "00010011", 37 => "00011100", 38 => "01000010", 39 => "00011001", 
    40 => "00001100", 41 => "10111100", 42 => "10111111", 43 => "11101110", 
    44 => "00011001", 45 => "00011000", 46 => "10110010", 47 => "11001001", 
    48 => "11101000", 49 => "00000111", 50 => "00011000", 51 => "00010100", 
    52 => "00011101", 53 => "11110101", 54 => "00110001", 55 => "11101011", 
    56 => "00000000", 57 => "10100110", 58 => "00011100", 59 => "00111011", 
    60 => "11011111", 61 => "00011000", 62 => "00001111", 63 => "11110100", 
    64 => "00000110", 65 => "00001101", 66 => "11011001", 67 => "00010001", 
    68 => "00001110", 69 => "11111111", 70 => "11100100", 71 => "11100001", 
    72 => "00001000", 73 => "00011100", 74 => "00001110", 75 => "01001011", 
    76 => "11000011", 77 => "00011101", 78 => "00010001", 79 => "11111011", 
    80 => "11111111", 81 => "00001011", 82 => "00000001", 83 => "00100010", 
    84 => "00101110", 85 => "00110001", 86 => "11111011", 87 => "11001100", 
    88 => "10111010", 89 => "11111110", 90 => "11101000", 91 => "00001001", 
    92 => "00001000", 93 => "11100101", 94 => "11101010", 95 => "11100010", 
    96 => "00000000", 97 => "11111100", 98 => "11110100", 99 => "11000100", 
    100 => "11100100", 101 => "00011001", 102 => "00110000", 103 => "11010101", 
    104 => "00001000", 105 => "00010001", 106 => "00001100", 107 => "00101011", 
    108 => "00010010", 109 => "11111000", 110 => "10111010", 111 => "11100100", 
    112 => "00000111", 113 => "00110001", 114 => "00010101", 115 => "00011000", 
    116 => "11011011", 117 => "00000100", 118 => "11101100", 119 => "11010111", 
    120 => "00101000", 121 => "00000010", 122 => "00011000", 123 => "11011010", 
    124 => "00010111", 125 => "00011110", 126 => "11110110", 127 => "11100011", 
    128 => "11100101", 129 => "00000100", 130 => "11111111", 131 => "11111010", 
    132 => "11010111", 133 => "11100111", 134 => "00010100", 135 => "00110010", 
    136 => "00000100", 137 => "00010101", 138 => "00011100", 139 => "00010001", 
    140 => "11101101", 141 => "00000011", 142 => "11100111", 143 => "11101010", 
    144 => "10111111", 145 => "11111011", 146 => "00001111", 147 => "11101100", 
    148 => "11001110", 149 => "11010010" );


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

entity gap_head_W_HEAD_VhRb_x is
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

architecture arch of gap_head_W_HEAD_VhRb_x is
    component gap_head_W_HEAD_VhRb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhRb_x_rom_U :  component gap_head_W_HEAD_VhRb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


