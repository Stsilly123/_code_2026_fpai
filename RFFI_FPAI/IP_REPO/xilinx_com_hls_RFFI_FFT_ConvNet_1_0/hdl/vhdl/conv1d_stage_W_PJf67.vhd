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

entity conv1d_stage_W_PJf67_rom is 
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


architecture rtl of conv1d_stage_W_PJf67_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010001", 1 => "11110000", 2 => "11001101", 3 => "11101000", 
    4 => "11110110", 5 => "10000001", 6 => "00000101", 7 => "01001001", 
    8 => "11110100", 9 => "10111111", 10 => "10110011", 11 => "01001000", 
    12 => "11111101", 13 => "00001110", 14 => "00001100", 15 => "11111011", 
    16 => "11101000", 17 => "10110001", 18 => "00001000", 19 => "11110110", 
    20 => "00100110", 21 => "00010001", 22 => "00001001", 23 => "11011111", 
    24 => "00011101", 25 => "11111010", 26 => "01000000", 27 => "00100100", 
    28 => "11111011", 29 => "11101101", 30 => "10111011", 31 => "10110101", 
    32 => "11000111", 33 => "00100111", 34 => "11000000", 35 => "11110010", 
    36 => "00011001", 37 => "11110100", 38 => "11110001", 39 => "01000101", 
    40 => "11001010", 41 => "11010001", 42 => "11111101", 43 => "11111100", 
    44 => "10111101", 45 => "00000011", 46 => "00010101", 47 => "00010011", 
    48 => "00010111", 49 => "00101111", 50 => "01010101", 51 => "11001000", 
    52 => "00111110", 53 => "11001111", 54 => "00000011", 55 => "00100000", 
    56 => "00000111", 57 => "11110001", 58 => "00001010", 59 => "01101001", 
    60 => "00001010", 61 => "11100110", 62 => "11111101", 63 => "00110010", 
    64 => "00111001", 65 => "01000101", 66 => "11101111", 67 => "01001010", 
    68 => "00110101", 69 => "11001001", 70 => "00000001", 71 => "00100110", 
    72 => "11011100", 73 => "01010011", 74 => "11100100", 75 => "11111010", 
    76 => "00010110", 77 => "11111011", 78 => "11011000", 79 => "11101111", 
    80 => "11100010", 81 => "11000111", 82 => "00001110", 83 => "11101011", 
    84 => "00111101", 85 => "00100000", 86 => "11110111", 87 => "00000100", 
    88 => "11011111", 89 => "11111110", 90 => "00010111", 91 => "00000001", 
    92 => "01000011", 93 => "11011001", 94 => "00111111", 95 => "11011010" );

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

entity conv1d_stage_W_PJf67 is
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

architecture arch of conv1d_stage_W_PJf67 is
    component conv1d_stage_W_PJf67_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf67_rom_U :  component conv1d_stage_W_PJf67_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


