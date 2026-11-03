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

entity conv1d_stage_W_PJgzb_rom is 
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


architecture rtl of conv1d_stage_W_PJgzb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010110", 1 => "11101100", 2 => "11100111", 3 => "11100110", 
    4 => "00011111", 5 => "00101100", 6 => "11000101", 7 => "11111100", 
    8 => "00010000", 9 => "11000011", 10 => "00101111", 11 => "11010001", 
    12 => "11000011", 13 => "11101110", 14 => "11010010", 15 => "00100101", 
    16 => "11111110", 17 => "00111000", 18 => "11010010", 19 => "00000011", 
    20 => "01001010", 21 => "00111101", 22 => "11011101", 23 => "01110010", 
    24 => "11100011", 25 => "11001001", 26 => "00011000", 27 => "11101110", 
    28 => "11101000", 29 => "11111100", 30 => "00010111", 31 => "11010111", 
    32 => "11010001", 33 => "00010100", 34 => "00000010", 35 => "00011110", 
    36 => "11100000", 37 => "00101000", 38 => "11111100", 39 => "11000111", 
    40 => "11101010", 41 => "00001001", 42 => "01001001", 43 => "00011100", 
    44 => "00101001", 45 => "11111110", 46 => "10101011", 47 => "00100110", 
    48 => "11110010", 49 => "11010101", 50 => "11011111", 51 => "01000100", 
    52 => "11001101", 53 => "11010010", 54 => "10010010", 55 => "01111111", 
    56 => "01011101", 57 => "11101010", 58 => "01000001", 59 => "10000001", 
    60 => "01110110", 61 => "11101111", 62 => "00010101", 63 => "00101011", 
    64 => "00010101", 65 => "01001111", 66 => "00111000", 67 => "11001111", 
    68 => "11110010", 69 => "00001101", 70 => "11110001", 71 => "11101100", 
    72 => "00100101", 73 => "00011111", 74 => "11111100", 75 => "11101110", 
    76 => "11111000", 77 => "01010100", 78 => "00010000", 79 => "11100101", 
    80 => "00001110", 81 => "00110100", 82 => "00001100", 83 => "11100000", 
    84 => "00001101", 85 => "11000000", 86 => "00000110", 87 => "00110100", 
    88 => "10000001", 89 => "00010011", 90 => "11100101", 91 => "00101111", 
    92 => "11110000", 93 => "11101000", 94 => "11111011", 95 => "10101000" );

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

entity conv1d_stage_W_PJgzb is
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

architecture arch of conv1d_stage_W_PJgzb is
    component conv1d_stage_W_PJgzb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgzb_rom_U :  component conv1d_stage_W_PJgzb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


