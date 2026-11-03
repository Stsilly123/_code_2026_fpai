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

entity conv1d_stage_W_PJgg8_rom is 
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


architecture rtl of conv1d_stage_W_PJgg8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100010", 1 => "11110100", 2 => "11101100", 3 => "11110101", 
    4 => "11110011", 5 => "01010011", 6 => "00001001", 7 => "00001110", 
    8 => "11110101", 9 => "11110000", 10 => "01010100", 11 => "11001100", 
    12 => "10101011", 13 => "11110100", 14 => "11100110", 15 => "00100001", 
    16 => "11110100", 17 => "10101111", 18 => "00001110", 19 => "11010010", 
    20 => "11000110", 21 => "00000001", 22 => "00011010", 23 => "10111100", 
    24 => "00001000", 25 => "11101001", 26 => "10011001", 27 => "11111011", 
    28 => "00001100", 29 => "00000111", 30 => "11011000", 31 => "11111001", 
    32 => "11110011", 33 => "11010001", 34 => "10010001", 35 => "01001100", 
    36 => "11111001", 37 => "11111010", 38 => "00001000", 39 => "00100110", 
    40 => "11111101", 41 => "00010110", 42 => "11100100", 43 => "11111110", 
    44 => "11000101", 45 => "00101100", 46 => "11100101", 47 => "00000111", 
    48 => "00001001", 49 => "00100000", 50 => "11001001", 51 => "00000010", 
    52 => "00111000", 53 => "00010111", 54 => "11010011", 55 => "11011110", 
    56 => "10100110", 57 => "00010101", 58 => "11110100", 59 => "10101001", 
    60 => "00100010", 61 => "00001011", 62 => "00011110", 63 => "01001110", 
    64 => "11010011", 65 => "11001101", 66 => "00011101", 67 => "00010011", 
    68 => "11101111", 69 => "11111001", 70 => "00001011", 71 => "11100100", 
    72 => "11111111", 73 => "11111100", 74 => "10011101", 75 => "00100010", 
    76 => "10000001", 77 => "11010011", 78 => "10100001", 79 => "10000001", 
    80 => "11110011", 81 => "00001010", 82 => "11111101", 83 => "00011110", 
    84 => "00000101", 85 => "00111001", 86 => "00010110", 87 => "10111101", 
    88 => "11011110", 89 => "01011101", 90 => "11100101", 91 => "00111010", 
    92 => "11001011", 93 => "11111010", 94 => "11110000", 95 => "00000100" );

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

entity conv1d_stage_W_PJgg8 is
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

architecture arch of conv1d_stage_W_PJgg8 is
    component conv1d_stage_W_PJgg8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgg8_rom_U :  component conv1d_stage_W_PJgg8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


