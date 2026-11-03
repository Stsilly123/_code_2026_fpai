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

entity conv1d_stage_W_PJf87_rom is 
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


architecture rtl of conv1d_stage_W_PJf87_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110111", 1 => "00001010", 2 => "00010111", 3 => "00000010", 
    4 => "00111001", 5 => "00111000", 6 => "11011010", 7 => "01000100", 
    8 => "00100000", 9 => "10101010", 10 => "00000110", 11 => "11011110", 
    12 => "10110011", 13 => "00011101", 14 => "01100010", 15 => "00100101", 
    16 => "11010100", 17 => "00111001", 18 => "00001010", 19 => "11000110", 
    20 => "00010010", 21 => "00000111", 22 => "10111001", 23 => "10111110", 
    24 => "00010110", 25 => "11110101", 26 => "00000010", 27 => "00101100", 
    28 => "10111111", 29 => "00011101", 30 => "00111111", 31 => "11110001", 
    32 => "00000111", 33 => "00000100", 34 => "10000111", 35 => "01000100", 
    36 => "00100101", 37 => "00000111", 38 => "00011010", 39 => "11100001", 
    40 => "01100010", 41 => "00000110", 42 => "11001100", 43 => "11001001", 
    44 => "00001111", 45 => "00001110", 46 => "00010110", 47 => "10101001", 
    48 => "11101110", 49 => "01001011", 50 => "11010011", 51 => "01101010", 
    52 => "00000011", 53 => "00001010", 54 => "11100100", 55 => "00001111", 
    56 => "10011101", 57 => "11111010", 58 => "11001101", 59 => "01001111", 
    60 => "00000110", 61 => "00101001", 62 => "11100101", 63 => "11010010", 
    64 => "11011011", 65 => "00001001", 66 => "11010010", 67 => "00000010", 
    68 => "10001100", 69 => "01111111", 70 => "11000011", 71 => "00011111", 
    72 => "10101000", 73 => "11001000", 74 => "00001001", 75 => "00100110", 
    76 => "10101110", 77 => "11111110", 78 => "00010100", 79 => "01100010", 
    80 => "10110110", 81 => "11010011", 82 => "00101011", 83 => "00001100", 
    84 => "00000100", 85 => "00110111", 86 => "00110000", 87 => "00101010", 
    88 => "00100101", 89 => "11101100", 90 => "00100101", 91 => "11000011", 
    92 => "10111111", 93 => "10010101", 94 => "11010111", 95 => "11100011" );

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

entity conv1d_stage_W_PJf87 is
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

architecture arch of conv1d_stage_W_PJf87 is
    component conv1d_stage_W_PJf87_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf87_rom_U :  component conv1d_stage_W_PJf87_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


