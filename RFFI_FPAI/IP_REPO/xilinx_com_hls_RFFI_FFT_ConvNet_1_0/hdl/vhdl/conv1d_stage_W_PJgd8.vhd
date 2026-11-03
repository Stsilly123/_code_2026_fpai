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

entity conv1d_stage_W_PJgd8_rom is 
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


architecture rtl of conv1d_stage_W_PJgd8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010001", 1 => "11010011", 2 => "00111011", 3 => "11001110", 
    4 => "00101001", 5 => "11110100", 6 => "00010100", 7 => "00011101", 
    8 => "00000000", 9 => "00001100", 10 => "00111000", 11 => "00010000", 
    12 => "11101101", 13 => "00110111", 14 => "01010100", 15 => "00011010", 
    16 => "11010000", 17 => "11101001", 18 => "00111000", 19 => "11000101", 
    20 => "11111011", 21 => "11000010", 22 => "11000110", 23 => "00010111", 
    24 => "11100111", 25 => "10101111", 26 => "00101110", 27 => "11011111", 
    28 => "00000101", 29 => "00000111", 30 => "00001100", 31 => "00101000", 
    32 => "11111111", 33 => "11100110", 34 => "11111010", 35 => "00001100", 
    36 => "00000011", 37 => "11111100", 38 => "00001110", 39 => "11011111", 
    40 => "01010111", 41 => "11011001", 42 => "11111110", 43 => "11011000", 
    44 => "11011011", 45 => "11101111", 46 => "00011100", 47 => "10111000", 
    48 => "00000011", 49 => "11111110", 50 => "11011101", 51 => "11111110", 
    52 => "01000010", 53 => "11110100", 54 => "00000011", 55 => "11101001", 
    56 => "11000000", 57 => "00101100", 58 => "00110110", 59 => "00001100", 
    60 => "11011100", 61 => "00100000", 62 => "10011111", 63 => "00110000", 
    64 => "00001000", 65 => "01111111", 66 => "11110011", 67 => "11000111", 
    68 => "00010011", 69 => "00000001", 70 => "11100110", 71 => "00100000", 
    72 => "11011101", 73 => "00000101", 74 => "00011110", 75 => "11101001", 
    76 => "00011111", 77 => "11100100", 78 => "01100001", 79 => "00100110", 
    80 => "00010000", 81 => "10101101", 82 => "00001001", 83 => "11100010", 
    84 => "11111100", 85 => "11101111", 86 => "11101011", 87 => "11111100", 
    88 => "00111100", 89 => "11100100", 90 => "11111100", 91 => "11110001", 
    92 => "00010110", 93 => "11110010", 94 => "11011011", 95 => "01010100" );

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

entity conv1d_stage_W_PJgd8 is
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

architecture arch of conv1d_stage_W_PJgd8 is
    component conv1d_stage_W_PJgd8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgd8_rom_U :  component conv1d_stage_W_PJgd8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


