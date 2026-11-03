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

entity conv1d_stage_W_PJfU5_rom is 
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


architecture rtl of conv1d_stage_W_PJfU5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000011", 1 => "10110010", 2 => "11101010", 3 => "11011100", 
    4 => "00001001", 5 => "00011101", 6 => "11001110", 7 => "00011001", 
    8 => "11111101", 9 => "10111010", 10 => "11111011", 11 => "11001110", 
    12 => "00000110", 13 => "00001011", 14 => "01100100", 15 => "11011001", 
    16 => "00100000", 17 => "10110110", 18 => "01011010", 19 => "10100110", 
    20 => "11011110", 21 => "00110010", 22 => "11101111", 23 to 24=> "11101010", 
    25 => "11100010", 26 => "10101110", 27 => "11101010", 28 => "11010111", 
    29 => "11010001", 30 => "11001100", 31 => "11110001", 32 => "10000001", 
    33 => "11000110", 34 => "01010010", 35 => "10110001", 36 => "01001011", 
    37 => "00111101", 38 => "00010111", 39 => "00000010", 40 => "11000110", 
    41 => "10000001", 42 => "11111110", 43 => "00010000", 44 => "00000100", 
    45 => "01011010", 46 => "10110001", 47 => "11011010", 48 => "00011100", 
    49 => "00111100", 50 => "10000001", 51 => "00101100", 52 => "00000011", 
    53 => "11110100", 54 => "10011011", 55 => "00001001", 56 => "11000100", 
    57 => "01010101", 58 => "00110111", 59 => "11100000", 60 => "11111111", 
    61 => "11000001", 62 => "00010110", 63 => "11011000", 64 => "11111010", 
    65 => "11011110", 66 => "00111100", 67 => "01111111", 68 => "11100111", 
    69 => "11011010", 70 => "11100010", 71 => "11111100", 72 => "11011100", 
    73 => "11111110", 74 => "11011010", 75 => "11101011", 76 => "11110011", 
    77 => "10111110", 78 => "00001111", 79 => "01001000", 80 => "11111001", 
    81 => "11011101", 82 => "11100010", 83 => "00001010", 84 => "00100001", 
    85 => "11110011", 86 => "11111110", 87 => "00101010", 88 => "11111011", 
    89 => "01010100", 90 => "11010010", 91 => "00010000", 92 => "00110010", 
    93 => "00111101", 94 => "00000111", 95 => "01000010" );

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

entity conv1d_stage_W_PJfU5 is
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

architecture arch of conv1d_stage_W_PJfU5 is
    component conv1d_stage_W_PJfU5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfU5_rom_U :  component conv1d_stage_W_PJfU5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


