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

entity gap_head_W_HEAD_VhTb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhTb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100001", 1 => "00011011", 2 => "10100100", 3 => "11110010", 
    4 => "11101001", 5 => "10000001", 6 => "00001110", 7 => "00101110", 
    8 => "11011111", 9 => "10010110", 10 => "11010110", 11 => "11001011", 
    12 => "00000110", 13 => "11100101", 14 => "00101000", 15 => "11010011", 
    16 => "11111010", 17 => "00110101", 18 => "00011000", 19 => "11111101", 
    20 => "11110111", 21 => "00000101", 22 => "11001011", 23 => "11101001", 
    24 => "11011111", 25 => "00000100", 26 => "00010100", 27 => "11101110", 
    28 => "11111111", 29 => "11100000", 30 => "11110000", 31 => "01101100", 
    32 => "00010100", 33 => "00100001", 34 => "10111011", 35 => "11010011", 
    36 => "01001010", 37 => "00110010", 38 => "11010010", 39 => "01100001", 
    40 => "11010101", 41 => "11101110", 42 => "11001111", 43 => "01101010", 
    44 => "11010100", 45 => "00000011", 46 => "01001011", 47 => "00101001", 
    48 => "11001011", 49 => "01111111", 50 => "11000000", 51 => "11011100", 
    52 => "00110101", 53 => "00000101", 54 => "11001011", 55 => "00010011", 
    56 => "10101100", 57 => "01111111", 58 => "00001000", 59 => "01100011", 
    60 => "11001110", 61 => "11001010", 62 => "11011110", 63 => "11100111", 
    64 => "00000110", 65 => "10111101", 66 => "11100111", 67 => "00011101", 
    68 => "00100000", 69 => "11111001", 70 => "11011000", 71 => "10101010", 
    72 => "01000001", 73 => "11011000", 74 => "00100000", 75 => "11101000", 
    76 => "10011111", 77 => "11100000", 78 => "11010000", 79 => "11001101", 
    80 => "01111111", 81 => "00000001", 82 => "11110101", 83 => "01110011", 
    84 => "11011110", 85 => "01010011", 86 => "11101010", 87 => "01100110", 
    88 => "10110000", 89 => "10001000", 90 => "00011000", 91 => "01100010", 
    92 => "11000000", 93 => "10111111", 94 => "11101000", 95 => "10111000", 
    96 => "11001110", 97 => "01110001", 98 => "11100100", 99 => "11101100", 
    100 => "01100010", 101 => "00001010", 102 => "01001110", 103 => "10111011", 
    104 => "11100011", 105 => "01000001", 106 => "11011001", 107 => "11111010", 
    108 => "01001011", 109 => "00100000", 110 => "11000011", 111 => "11101100", 
    112 => "01000011", 113 => "10100010", 114 => "00001101", 115 => "01111111", 
    116 => "11011111", 117 => "00010010", 118 => "10110011", 119 => "01111111", 
    120 => "00110001", 121 => "11010100", 122 => "00011010", 123 => "10101000", 
    124 => "11010000", 125 => "11001000", 126 => "00010011", 127 => "01000010", 
    128 => "00100010", 129 => "11111100", 130 => "00101101", 131 => "10110000", 
    132 => "00100011", 133 => "00110111", 134 => "11111001", 135 => "10000001", 
    136 => "01111100", 137 => "00011001", 138 => "00010001", 139 => "00101111", 
    140 => "01011001", 141 => "11011111", 142 => "11000001", 143 => "00111110", 
    144 => "00110100", 145 => "10110111", 146 => "00000101", 147 => "00001010", 
    148 => "11111011", 149 => "00110101" );


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

entity gap_head_W_HEAD_VhTb_x is
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

architecture arch of gap_head_W_HEAD_VhTb_x is
    component gap_head_W_HEAD_VhTb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhTb_x_rom_U :  component gap_head_W_HEAD_VhTb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


