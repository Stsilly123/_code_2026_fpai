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

entity gap_head_W_HEAD_VhCb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhCb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101100", 1 => "01001010", 2 => "00000010", 3 => "00000111", 
    4 => "11011000", 5 => "11001011", 6 => "01000101", 7 => "11110111", 
    8 => "00001000", 9 => "00111101", 10 => "11011011", 11 => "11100100", 
    12 => "00001000", 13 => "11101001", 14 => "00100010", 15 => "11101001", 
    16 => "10111100", 17 => "11111000", 18 => "00011000", 19 => "00100010", 
    20 => "00101000", 21 => "11010111", 22 => "00001100", 23 => "11101111", 
    24 => "00010110", 25 => "00011010", 26 => "00101100", 27 => "11111010", 
    28 => "10000001", 29 => "00111111", 30 => "10000110", 31 => "00010000", 
    32 => "11100000", 33 => "00011101", 34 => "11110111", 35 => "11011110", 
    36 => "11111010", 37 => "00000110", 38 => "01000000", 39 => "11101111", 
    40 => "11010100", 41 => "00011001", 42 => "11011111", 43 => "11001101", 
    44 => "00000011", 45 => "11111010", 46 => "11000010", 47 => "11100001", 
    48 => "11101011", 49 => "11001110", 50 => "00010000", 51 => "11110001", 
    52 => "11011000", 53 => "00101111", 54 => "00111010", 55 => "00101110", 
    56 => "00010100", 57 => "10110110", 58 => "11011000", 59 => "01001001", 
    60 => "00011111", 61 => "00000100", 62 => "00001010", 63 => "11011101", 
    64 => "00011111", 65 => "10101000", 66 => "00100001", 67 => "00101011", 
    68 => "00010101", 69 => "11011011", 70 => "10100010", 71 => "11000010", 
    72 => "11001011", 73 => "00110110", 74 => "11101001", 75 => "00011001", 
    76 => "00001000", 77 => "11100111", 78 => "11011110", 79 => "11111100", 
    80 => "00011101", 81 => "00000001", 82 => "00101010", 83 => "00100010", 
    84 => "00101010", 85 => "00000001", 86 => "00011100", 87 => "11011101", 
    88 => "11101101", 89 => "00001101", 90 => "01001010", 91 => "00000111", 
    92 => "10000001", 93 => "00001000", 94 => "11100010", 95 => "11100111", 
    96 => "11101001", 97 => "11110111", 98 => "00001101", 99 => "11101111", 
    100 => "00110011", 101 => "11000000", 102 => "00001110", 103 => "00100011", 
    104 => "00000100", 105 => "00010101", 106 => "11100101", 107 => "11000111", 
    108 => "11110100", 109 => "11010110", 110 => "11111000", 111 => "00011000", 
    112 => "00011101", 113 => "11111100", 114 => "11111000", 115 => "00001101", 
    116 => "00110011", 117 => "00101100", 118 => "00011000", 119 => "10101000", 
    120 => "11010101", 121 => "00000001", 122 => "00010100", 123 => "11111110", 
    124 => "11000111", 125 => "00010110", 126 => "11100101", 127 => "11011011", 
    128 => "00011110", 129 => "00011001", 130 => "00001010", 131 => "00100010", 
    132 => "11100101", 133 => "11110011", 134 => "11111011", 135 => "11111100", 
    136 => "01000101", 137 => "00011100", 138 => "00000010", 139 => "00100010", 
    140 => "00011110", 141 => "00010110", 142 => "00000110", 143 => "00000001", 
    144 => "11101000", 145 => "11100111", 146 => "11100010", 147 => "11101111", 
    148 => "11111011", 149 => "11111110" );


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

entity gap_head_W_HEAD_VhCb_x is
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

architecture arch of gap_head_W_HEAD_VhCb_x is
    component gap_head_W_HEAD_VhCb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhCb_x_rom_U :  component gap_head_W_HEAD_VhCb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


