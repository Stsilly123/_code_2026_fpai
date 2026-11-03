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

entity conv1d_stage_W_PJgb8_rom is 
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


architecture rtl of conv1d_stage_W_PJgb8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10011100", 1 => "00000110", 2 => "11000000", 3 => "00101100", 
    4 => "11111000", 5 => "11101111", 6 => "00010100", 7 => "01111111", 
    8 => "11101111", 9 => "00010110", 10 => "01011010", 11 => "00110111", 
    12 => "01001001", 13 => "00110011", 14 => "10011100", 15 => "11101011", 
    16 => "11110010", 17 => "00011100", 18 => "11100011", 19 => "00100000", 
    20 => "11111011", 21 => "01101011", 22 => "00101000", 23 => "00011100", 
    24 => "11010010", 25 => "10100110", 26 => "11111000", 27 => "01000001", 
    28 => "01011101", 29 => "11000011", 30 => "00000000", 31 => "00001110", 
    32 => "01000101", 33 => "11111100", 34 => "00011001", 35 => "00110111", 
    36 => "11110010", 37 => "00100001", 38 to 39=> "11010010", 40 => "10110011", 
    41 => "00001111", 42 => "00010000", 43 => "00001101", 44 => "00111110", 
    45 => "11110000", 46 => "11111001", 47 => "01000101", 48 => "11110101", 
    49 => "11011111", 50 => "00001001", 51 => "00010001", 52 => "11001110", 
    53 => "10111000", 54 => "10010101", 55 => "11001100", 56 to 57=> "00001000", 
    58 => "00110100", 59 => "01000000", 60 => "00100110", 61 => "11101101", 
    62 => "00001111", 63 => "11110100", 64 => "00000010", 65 => "11101011", 
    66 => "00010100", 67 => "11011111", 68 => "11110110", 69 => "10111010", 
    70 => "11100010", 71 => "00101001", 72 => "00000000", 73 => "11011010", 
    74 => "00100010", 75 => "11101000", 76 => "00000111", 77 => "10010111", 
    78 => "11111010", 79 => "11011010", 80 => "00011110", 81 => "11110001", 
    82 => "00011011", 83 => "11110000", 84 => "11011001", 85 => "00111000", 
    86 => "11100001", 87 => "11110100", 88 => "00111011", 89 => "11111111", 
    90 => "11101010", 91 => "00001001", 92 => "10111001", 93 => "11111100", 
    94 => "00000011", 95 => "11100000" );

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

entity conv1d_stage_W_PJgb8 is
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

architecture arch of conv1d_stage_W_PJgb8 is
    component conv1d_stage_W_PJgb8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgb8_rom_U :  component conv1d_stage_W_PJgb8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


