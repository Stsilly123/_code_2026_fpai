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

entity gap_head_W_HEAD_VgRb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgRb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010001", 1 => "11010110", 2 => "11010011", 3 => "11110101", 
    4 => "00100111", 5 => "10111101", 6 => "11010110", 7 => "00111010", 
    8 => "11101100", 9 => "00011101", 10 => "00001000", 11 => "00100100", 
    12 => "11000011", 13 => "01001110", 14 => "01000101", 15 => "11100101", 
    16 => "00000100", 17 => "11110110", 18 => "00100101", 19 => "00000110", 
    20 => "00001100", 21 => "00000010", 22 => "00001110", 23 => "00100110", 
    24 => "11110000", 25 => "00011001", 26 => "00101101", 27 => "11111110", 
    28 => "11111101", 29 => "11100110", 30 => "00101111", 31 => "00110000", 
    32 => "00010101", 33 => "00111111", 34 => "11110101", 35 => "11011010", 
    36 => "00000000", 37 => "11000010", 38 => "11001010", 39 => "00101110", 
    40 => "11011011", 41 => "01101101", 42 => "00001010", 43 => "11111110", 
    44 => "11000110", 45 => "00111001", 46 => "00111111", 47 => "00001101", 
    48 => "11100111", 49 => "01011001", 50 => "11011010", 51 => "00010010", 
    52 => "11111010", 53 => "11001101", 54 => "10010110", 55 => "11110001", 
    56 => "11101001", 57 => "00010110", 58 => "00100001", 59 => "00011100", 
    60 => "11111111", 61 => "11110101", 62 => "11010010", 63 => "11011000", 
    64 => "11110110", 65 => "00111010", 66 => "11100011", 67 => "11110001", 
    68 to 69=> "11111110", 70 => "00110101", 71 => "11111111", 72 => "00100001", 
    73 => "00010010", 74 => "00111110", 75 => "10011001", 76 => "00000101", 
    77 => "11000110", 78 => "11100111", 79 => "11011001", 80 => "00100111", 
    81 => "11111011", 82 => "10110100", 83 => "00101100", 84 => "11010100", 
    85 => "00101100", 86 => "00010111", 87 => "00110000", 88 => "00011010", 
    89 => "11111000", 90 => "11100100", 91 => "11010000", 92 => "11110010", 
    93 => "11110111", 94 to 95=> "11111011", 96 => "11100110", 97 => "00100000", 
    98 => "11101101", 99 => "11101111", 100 => "11010010", 101 => "00001000", 
    102 => "11111100", 103 => "01100000", 104 => "11001100", 105 => "11110101", 
    106 => "11100011", 107 => "11000110", 108 => "00001011", 109 => "01000100", 
    110 => "00101010", 111 => "10101111", 112 => "11001011", 113 => "11001010", 
    114 => "11011011", 115 => "00101011", 116 => "11101011", 117 => "11011010", 
    118 => "10101011", 119 => "00100001", 120 => "11010011", 121 => "00011000", 
    122 => "00001111", 123 => "01000100", 124 => "00111001", 125 => "00001110", 
    126 => "00010000", 127 => "00100111", 128 => "00110001", 129 => "11111101", 
    130 => "11100000", 131 => "00000010", 132 => "01000001", 133 => "11110100", 
    134 => "00001110", 135 => "11010110", 136 => "00011010", 137 => "11100101", 
    138 => "11010011", 139 => "11100101", 140 => "11101101", 141 => "00001110", 
    142 => "00001111", 143 => "11000100", 144 => "00011001", 145 => "11111010", 
    146 => "00110011", 147 => "00011000", 148 => "01110110", 149 => "00010000" );


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

entity gap_head_W_HEAD_VgRb is
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

architecture arch of gap_head_W_HEAD_VgRb is
    component gap_head_W_HEAD_VgRb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgRb_rom_U :  component gap_head_W_HEAD_VgRb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


