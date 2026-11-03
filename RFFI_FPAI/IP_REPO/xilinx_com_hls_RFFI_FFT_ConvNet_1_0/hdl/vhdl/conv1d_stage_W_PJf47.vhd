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

entity conv1d_stage_W_PJf47_rom is 
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


architecture rtl of conv1d_stage_W_PJf47_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100110", 1 => "00011001", 2 => "00000100", 3 => "00111101", 
    4 => "11100011", 5 => "00101010", 6 => "10110010", 7 => "01001101", 
    8 => "11000000", 9 => "00001000", 10 => "00010011", 11 => "00100000", 
    12 => "11100011", 13 => "11100100", 14 => "00011010", 15 => "11110010", 
    16 => "11110000", 17 => "10111010", 18 => "11110001", 19 => "00000010", 
    20 => "00101010", 21 => "00100010", 22 => "11111111", 23 => "11100010", 
    24 => "11111010", 25 => "11110101", 26 => "11110011", 27 => "00110011", 
    28 => "11001111", 29 => "00001011", 30 => "00001110", 31 => "01000011", 
    32 => "11110000", 33 => "01000110", 34 => "00101011", 35 => "00100011", 
    36 => "00110101", 37 => "10111100", 38 => "00111101", 39 => "11110101", 
    40 => "00001111", 41 => "00001110", 42 => "11110110", 43 => "11101010", 
    44 => "00001000", 45 => "00001101", 46 => "11001101", 47 => "11111001", 
    48 => "10111100", 49 => "11111100", 50 => "11100101", 51 => "10101100", 
    52 => "01101011", 53 => "11101101", 54 => "11101100", 55 to 56=> "00011011", 
    57 => "00000000", 58 to 59=> "00011111", 60 => "10101011", 61 => "00100101", 
    62 => "00001000", 63 => "00000010", 64 => "11010111", 65 => "11000110", 
    66 => "11010111", 67 => "00101011", 68 => "10100110", 69 => "01000101", 
    70 => "00001010", 71 => "11011000", 72 => "00111110", 73 => "00010100", 
    74 => "11010110", 75 => "11111010", 76 => "00001010", 77 => "11100000", 
    78 => "11101001", 79 => "00100111", 80 => "11110100", 81 => "01011010", 
    82 => "00001101", 83 => "00000101", 84 => "00101010", 85 => "11111011", 
    86 => "11111100", 87 => "11100011", 88 => "11001111", 89 => "00101011", 
    90 => "11101100", 91 => "11000110", 92 => "00010000", 93 => "11100000", 
    94 => "00010000", 95 => "01000010" );

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

entity conv1d_stage_W_PJf47 is
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

architecture arch of conv1d_stage_W_PJf47 is
    component conv1d_stage_W_PJf47_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf47_rom_U :  component conv1d_stage_W_PJf47_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


