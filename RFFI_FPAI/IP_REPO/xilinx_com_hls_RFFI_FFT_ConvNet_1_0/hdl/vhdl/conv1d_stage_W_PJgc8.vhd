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

entity conv1d_stage_W_PJgc8_rom is 
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


architecture rtl of conv1d_stage_W_PJgc8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000110", 1 => "00011111", 2 => "00101010", 3 => "11100101", 
    4 => "00000000", 5 => "11011111", 6 => "01011100", 7 => "11110000", 
    8 => "11100100", 9 => "00110111", 10 => "10010001", 11 => "00111100", 
    12 => "01110010", 13 => "00010110", 14 => "11110001", 15 => "00001110", 
    16 => "11100001", 17 => "00011011", 18 => "10100101", 19 => "01001101", 
    20 => "11100011", 21 => "10100001", 22 => "11001001", 23 => "00111111", 
    24 => "11101110", 25 => "11001111", 26 => "01001111", 27 => "11111101", 
    28 => "00001001", 29 => "11010010", 30 => "11110111", 31 => "11100001", 
    32 => "01011100", 33 => "11000011", 34 => "10110011", 35 => "00001010", 
    36 => "11111111", 37 => "01001010", 38 => "11110011", 39 => "11000100", 
    40 => "00000111", 41 => "00000011", 42 => "01010010", 43 => "10011111", 
    44 => "10100001", 45 => "00111101", 46 => "00001100", 47 => "00001000", 
    48 => "01101101", 49 => "00000110", 50 => "01000011", 51 => "11111011", 
    52 => "11011010", 53 => "11000111", 54 => "00000111", 55 => "00001110", 
    56 => "00110011", 57 => "10100110", 58 => "11010001", 59 => "10100111", 
    60 => "11001010", 61 => "00001101", 62 => "11001100", 63 => "00110110", 
    64 => "00000110", 65 => "00110001", 66 => "00011101", 67 => "00010001", 
    68 => "11001100", 69 => "11010011", 70 => "11101101", 71 => "11111110", 
    72 => "11111000", 73 => "11110111", 74 => "00010110", 75 => "01010101", 
    76 => "00110111", 77 => "11000011", 78 => "00010000", 79 => "11011010", 
    80 => "00011010", 81 => "01100001", 82 => "11110101", 83 => "10001011", 
    84 => "00101011", 85 => "10100011", 86 => "00000110", 87 => "10111000", 
    88 => "00111111", 89 => "10000111", 90 => "00001000", 91 => "01000100", 
    92 => "00111010", 93 => "11001110", 94 => "01111111", 95 => "10110101" );

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

entity conv1d_stage_W_PJgc8 is
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

architecture arch of conv1d_stage_W_PJgc8 is
    component conv1d_stage_W_PJgc8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgc8_rom_U :  component conv1d_stage_W_PJgc8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


