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

entity gap_head_W_HEAD_Vhcb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhcb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11011011", 1 => "11110110", 2 => "11100101", 3 => "11111000", 
    4 => "00111110", 5 => "01000010", 6 => "00001010", 7 => "11101111", 
    8 => "00010110", 9 => "11000110", 10 => "00110110", 11 => "00001100", 
    12 => "11101000", 13 => "00011011", 14 => "11011011", 15 => "00010110", 
    16 => "00011100", 17 => "00010000", 18 => "11110110", 19 => "11010011", 
    20 => "11011011", 21 => "11100011", 22 => "00011010", 23 => "11100101", 
    24 => "11011001", 25 => "00100111", 26 => "00010100", 27 => "11100010", 
    28 => "00110001", 29 => "11010110", 30 => "00001101", 31 => "11011111", 
    32 => "11101100", 33 => "00000011", 34 => "00000000", 35 => "11011111", 
    36 => "00111111", 37 => "11110001", 38 => "11000001", 39 => "00001011", 
    40 => "00010000", 41 => "00010110", 42 => "11011011", 43 => "00011100", 
    44 => "00110011", 45 => "00101110", 46 => "00010111", 47 => "00001111", 
    48 => "00010001", 49 => "00000110", 50 => "11010000", 51 => "00100000", 
    52 => "10110000", 53 => "10101001", 54 => "11101100", 55 => "11001111", 
    56 => "00101001", 57 => "10110110", 58 => "00001110", 59 => "11100111", 
    60 => "00100111", 61 => "00000000", 62 => "00100000", 63 => "00010101", 
    64 => "00011001", 65 => "11100011", 66 => "00001110", 67 => "11100010", 
    68 => "11101000", 69 => "11100101", 70 => "00010100", 71 => "00010001", 
    72 => "10110011", 73 => "11001010", 74 => "00001101", 75 => "11010110", 
    76 => "11011100", 77 => "11011000", 78 => "00001100", 79 => "00101101", 
    80 => "00010110", 81 => "11010111", 82 => "00011111", 83 => "00110110", 
    84 => "11110000", 85 => "11001101", 86 => "00010110", 87 => "01001010", 
    88 => "11011110", 89 => "00111001", 90 => "00110110", 91 => "00010000", 
    92 => "00011011", 93 => "00001101", 94 => "00011010", 95 => "00000010", 
    96 => "11111100", 97 => "11100011", 98 => "00101011", 99 => "00011010", 
    100 => "11011000", 101 => "00010111", 102 => "00000000", 103 => "00111000", 
    104 => "11110001", 105 => "11001111", 106 => "11011100", 107 => "11101101", 
    108 => "11110011", 109 => "00110101", 110 => "11101001", 111 => "00000001", 
    112 => "11110000", 113 => "11010000", 114 => "00010001", 115 => "11110100", 
    116 => "11011100", 117 => "00001110", 118 => "00001111", 119 => "00001001", 
    120 => "11010111", 121 => "00101110", 122 => "11100101", 123 => "00101111", 
    124 => "01100011", 125 => "11011101", 126 => "11100100", 127 => "00000100", 
    128 => "00111001", 129 => "11111010", 130 => "00010010", 131 => "11100100", 
    132 => "00011101", 133 => "11100101", 134 => "00011010", 135 => "00000011", 
    136 => "11110011", 137 => "00001011", 138 => "00011100", 139 => "00010001", 
    140 => "00011111", 141 => "00011110", 142 => "00110111", 143 => "11001110", 
    144 => "00010010", 145 => "11101100", 146 => "00100101", 147 => "00100001", 
    148 => "01000101", 149 => "00001001" );


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

entity gap_head_W_HEAD_Vhcb is
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

architecture arch of gap_head_W_HEAD_Vhcb is
    component gap_head_W_HEAD_Vhcb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhcb_rom_U :  component gap_head_W_HEAD_Vhcb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


