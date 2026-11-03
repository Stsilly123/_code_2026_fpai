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

entity gap_head_W_HEAD_VgTb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgTb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111001", 1 => "00000011", 2 => "01001101", 3 => "11011100", 
    4 => "11010100", 5 => "10011010", 6 => "01001110", 7 => "00110111", 
    8 => "11100101", 9 => "00111100", 10 => "11001100", 11 => "10000001", 
    12 => "00000010", 13 => "01001011", 14 => "00110011", 15 => "11110011", 
    16 => "11001010", 17 => "11000101", 18 => "01111111", 19 => "00010101", 
    20 => "01111000", 21 => "11110010", 22 => "00000101", 23 => "00110110", 
    24 => "11001101", 25 => "11110111", 26 => "00101001", 27 => "01000111", 
    28 => "11100101", 29 => "11001111", 30 => "00011001", 31 => "01000010", 
    32 => "11001001", 33 => "00111110", 34 => "11100010", 35 => "00110100", 
    36 => "00100111", 37 => "11001001", 38 => "01011110", 39 => "11011110", 
    40 => "10110111", 41 => "00000100", 42 => "00001011", 43 => "11100001", 
    44 => "01011111", 45 => "11111110", 46 => "10010010", 47 => "10110100", 
    48 => "10111111", 49 => "11100001", 50 => "00111100", 51 => "10111100", 
    52 => "00011001", 53 => "00001010", 54 => "11010100", 55 => "00101110", 
    56 => "11101111", 57 => "11011011", 58 => "01101011", 59 => "00101011", 
    60 => "11110100", 61 => "00010000", 62 => "00111010", 63 => "01111111", 
    64 => "11000011", 65 => "00100110", 66 => "01000010", 67 => "00101000", 
    68 => "10111000", 69 => "00100010", 70 => "10111010", 71 => "11001111", 
    72 => "11101110", 73 => "11101001", 74 => "00100010", 75 => "10100111", 
    76 => "11001001", 77 => "10111010", 78 => "11100000", 79 => "11101010", 
    80 => "11110101", 81 => "10111000", 82 => "01101101", 83 => "11010010", 
    84 => "00110010", 85 => "10110100", 86 => "00011001", 87 => "11010101", 
    88 => "00011111", 89 => "11011000", 90 => "00000011", 91 => "10101000", 
    92 => "11100101", 93 => "00010010", 94 => "10111100", 95 => "00010100", 
    96 => "11001000", 97 => "11110011", 98 => "11101011", 99 => "10101011", 
    100 => "10101001", 101 => "10000001", 102 => "01011110", 103 => "01011101", 
    104 => "11101010", 105 => "11000100", 106 => "10000001", 107 => "11000001", 
    108 => "00110010", 109 => "00100011", 110 => "00010011", 111 => "00000101", 
    112 => "01111111", 113 => "00001001", 114 => "10100111", 115 => "00100101", 
    116 => "00011100", 117 => "00100010", 118 => "11111010", 119 => "11100101", 
    120 => "00000001", 121 => "11111111", 122 => "00101111", 123 => "11010001", 
    124 => "10110110", 125 => "01111111", 126 => "11110111", 127 => "00010100", 
    128 => "00101111", 129 => "11110010", 130 => "01000101", 131 => "00101010", 
    132 => "11011011", 133 => "00100011", 134 => "11010010", 135 => "00000100", 
    136 => "11101100", 137 => "11101000", 138 => "01000000", 139 => "10101101", 
    140 => "01111011", 141 => "00011010", 142 => "01000010", 143 => "11100100", 
    144 => "01011110", 145 => "00011000", 146 => "01000101", 147 => "01111111", 
    148 => "11100011", 149 => "10010110" );


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

entity gap_head_W_HEAD_VgTb is
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

architecture arch of gap_head_W_HEAD_VgTb is
    component gap_head_W_HEAD_VgTb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgTb_rom_U :  component gap_head_W_HEAD_VgTb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


