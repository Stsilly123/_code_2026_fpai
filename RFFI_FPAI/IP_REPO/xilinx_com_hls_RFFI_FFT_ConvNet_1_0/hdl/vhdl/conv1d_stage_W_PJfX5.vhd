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

entity conv1d_stage_W_PJfX5_rom is 
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


architecture rtl of conv1d_stage_W_PJfX5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01011110", 1 => "00101001", 2 => "11011000", 3 => "00011100", 
    4 => "11011100", 5 => "11100010", 6 => "11100101", 7 => "00111011", 
    8 => "00000111", 9 => "11111110", 10 => "10101100", 11 => "11100110", 
    12 => "00011100", 13 => "10111101", 14 => "00011011", 15 => "11011100", 
    16 => "11100001", 17 => "00110110", 18 => "10000001", 19 => "00100011", 
    20 => "10111110", 21 => "00010111", 22 => "00010010", 23 => "00111111", 
    24 => "11011011", 25 => "11101010", 26 => "00101111", 27 => "11101110", 
    28 => "10001011", 29 => "01000010", 30 => "00010001", 31 => "01001011", 
    32 => "00010110", 33 => "11111100", 34 => "11111111", 35 => "00010011", 
    36 => "11011110", 37 => "11011101", 38 => "01000000", 39 => "11101111", 
    40 => "00110000", 41 => "10100011", 42 => "00001110", 43 => "01010000", 
    44 => "00111000", 45 => "11011100", 46 => "00110111", 47 => "00100011", 
    48 => "01001101", 49 => "00001111", 50 => "00111101", 51 => "10101101", 
    52 => "11111110", 53 => "00010001", 54 => "00010000", 55 => "10111101", 
    56 => "11001101", 57 => "11110011", 58 => "00110111", 59 => "11101011", 
    60 => "11100000", 61 => "00110100", 62 => "01111111", 63 => "00100000", 
    64 => "11001101", 65 => "11001001", 66 => "11110010", 67 => "11111110", 
    68 => "01101100", 69 => "11001000", 70 => "00001100", 71 => "00011010", 
    72 => "01011101", 73 => "11111010", 74 => "11010110", 75 => "00100110", 
    76 => "11010111", 77 => "11010101", 78 => "11101001", 79 => "00000100", 
    80 => "11110010", 81 => "11100011", 82 => "00100011", 83 => "11100000", 
    84 => "00000100", 85 => "00001000", 86 => "00110011", 87 => "11110011", 
    88 => "11111000", 89 => "11100010", 90 => "00000001", 91 => "00000010", 
    92 => "11010111", 93 => "11100101", 94 => "00001000", 95 => "00111001" );

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

entity conv1d_stage_W_PJfX5 is
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

architecture arch of conv1d_stage_W_PJfX5 is
    component conv1d_stage_W_PJfX5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfX5_rom_U :  component conv1d_stage_W_PJfX5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


