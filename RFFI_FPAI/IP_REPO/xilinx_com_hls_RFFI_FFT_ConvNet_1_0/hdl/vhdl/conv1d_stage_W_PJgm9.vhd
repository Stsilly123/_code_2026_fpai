-- ==============================================================
-- File generated on Sun Oct 18 16:53:13 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJgm9_rom is 
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


architecture rtl of conv1d_stage_W_PJgm9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11011100", 1 => "00111011", 2 => "11100011", 3 => "00111000", 
    4 => "11111110", 5 => "00111001", 6 => "11001000", 7 => "00110000", 
    8 => "00100011", 9 => "00100101", 10 => "11011101", 11 => "00010110", 
    12 => "11000011", 13 => "11010010", 14 => "00001000", 15 => "11000010", 
    16 => "00011100", 17 => "01101111", 18 => "00110000", 19 => "00110111", 
    20 => "00101100", 21 => "11011101", 22 => "00010010", 23 => "00010000", 
    24 => "11111111", 25 => "00000000", 26 => "11010000", 27 to 28=> "11110001", 
    29 => "00010101", 30 => "00001010", 31 => "11000101", 32 => "00001110", 
    33 => "00111111", 34 => "00010011", 35 => "00101010", 36 => "01001110", 
    37 => "11010000", 38 => "00000111", 39 => "00000011", 40 => "11010110", 
    41 to 42=> "11011000", 43 => "00100111", 44 => "00101110", 45 => "00100100", 
    46 => "01110000", 47 => "10100011", 48 => "01000001", 49 => "11100101", 
    50 => "00000100", 51 => "01111111", 52 => "00010000", 53 => "00111010", 
    54 => "00010001", 55 => "00011000", 56 => "11110001", 57 => "00001001", 
    58 => "00001100", 59 => "00101001", 60 => "00100110", 61 => "00000001", 
    62 => "00101101", 63 => "00001101", 64 => "01001011", 65 => "00011001", 
    66 => "11011101", 67 => "10111111", 68 => "10111000", 69 => "10101110", 
    70 => "11010101", 71 => "11011011", 72 => "11110001", 73 => "00011010", 
    74 => "11011101", 75 => "11110101", 76 => "01010101", 77 => "11000000", 
    78 => "10011010", 79 => "11111000", 80 => "11101001", 81 => "10111010", 
    82 => "00001010", 83 => "11010110", 84 => "11101001", 85 => "11001101", 
    86 => "11010111", 87 => "11110000", 88 => "11110001", 89 => "11011010", 
    90 => "11100000", 91 => "00101110", 92 => "11010101", 93 => "11010010", 
    94 => "00000010", 95 => "11011111" );

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

entity conv1d_stage_W_PJgm9 is
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

architecture arch of conv1d_stage_W_PJgm9 is
    component conv1d_stage_W_PJgm9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgm9_rom_U :  component conv1d_stage_W_PJgm9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


