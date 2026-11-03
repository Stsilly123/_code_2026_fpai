-- ==============================================================
-- File generated on Sun Oct 18 16:53:12 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJf77_rom is 
    generic(
             DWIDTH     : integer := 8; 
             AWIDTH     : integer := 7; 
             MEM_SIZE    : integer := 96
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_W_PJf77_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01001110", 1 => "10100101", 2 => "11100111", 3 => "00011011", 
    4 => "00001000", 5 => "00001011", 6 => "11111001", 7 => "00010100", 
    8 => "11010010", 9 => "01011011", 10 => "00011100", 11 => "10110010", 
    12 => "10000110", 13 => "10110111", 14 => "00100001", 15 => "00001100", 
    16 => "11000011", 17 => "01111101", 18 => "11011111", 19 => "00001101", 
    20 => "01101110", 21 => "01001111", 22 => "11111100", 23 => "11101010", 
    24 => "11001111", 25 => "00100001", 26 => "11000111", 27 => "00010000", 
    28 => "10110110", 29 => "00011110", 30 => "00000111", 31 => "00011000", 
    32 => "11010001", 33 => "11011110", 34 => "01010001", 35 => "11111100", 
    36 => "00010001", 37 => "00000010", 38 => "11110100", 39 => "00011111", 
    40 => "01101001", 41 => "00000101", 42 => "11110100", 43 => "11111011", 
    44 => "11110111", 45 => "11010000", 46 => "11110101", 47 => "00110001", 
    48 => "00011010", 49 => "11011000", 50 => "11010110", 51 => "11010001", 
    52 => "11111010", 53 => "11110011", 54 => "00100001", 55 => "00110011", 
    56 => "00101110", 57 => "00010010", 58 => "11000101", 59 => "00110101", 
    60 => "00110001", 61 => "11011010", 62 => "01010010", 63 => "01111111", 
    64 => "00010111", 65 => "00000101", 66 => "10111110", 67 => "11100011", 
    68 => "00101100", 69 => "00100100", 70 => "00101011", 71 => "11100010", 
    72 => "11101100", 73 => "10010010", 74 => "01111111", 75 => "00000010", 
    76 => "01010111", 77 => "00010000", 78 => "11100001", 79 => "00110001", 
    80 => "00000000", 81 => "11110001", 82 => "00110111", 83 => "00010101", 
    84 => "11100001", 85 => "01101001", 86 => "01001001", 87 => "00001000", 
    88 => "01010011", 89 => "11100101", 90 => "10010001", 91 => "00001110", 
    92 => "11001101", 93 => "00100000", 94 => "11100100", 95 => "11111100" );

attribute syn_rom_style : string;
attribute syn_rom_style of mem : signal is "select_rom";
attribute ROM_STYLE : string;
attribute ROM_STYLE of mem : signal is "distributed";

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

entity conv1d_stage_W_PJf77 is
    generic (
        DataWidth : INTEGER := 8;
        AddressRange : INTEGER := 96;
        AddressWidth : INTEGER := 7);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_W_PJf77 is
    component conv1d_stage_W_PJf77_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf77_rom_U :  component conv1d_stage_W_PJf77_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


