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

entity conv1d_stage_W_PJge8_rom is 
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


architecture rtl of conv1d_stage_W_PJge8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10011010", 1 => "01110001", 2 => "11100000", 3 => "11110010", 
    4 => "11000110", 5 => "10100011", 6 => "00001110", 7 => "00011010", 
    8 => "00101100", 9 => "00011001", 10 => "11101101", 11 => "11001001", 
    12 => "01001101", 13 => "00010100", 14 => "10101000", 15 => "11001100", 
    16 => "11011111", 17 => "00101000", 18 => "00100010", 19 => "11110110", 
    20 => "00001111", 21 => "00111101", 22 => "00001000", 23 => "01111111", 
    24 => "11111011", 25 => "11010100", 26 => "00100110", 27 => "01000010", 
    28 => "00101001", 29 => "00010100", 30 => "00000111", 31 => "11100111", 
    32 => "11010010", 33 => "10101110", 34 => "00001001", 35 => "00011011", 
    36 => "11010001", 37 => "00000011", 38 => "00100011", 39 => "01010000", 
    40 => "11110010", 41 => "11011010", 42 => "10010010", 43 => "01010011", 
    44 => "00010110", 45 => "01001010", 46 => "00001110", 47 => "10101111", 
    48 => "01001100", 49 => "00100001", 50 => "11010110", 51 => "00001110", 
    52 => "00001111", 53 => "11101010", 54 => "00101010", 55 => "11001101", 
    56 => "11010001", 57 => "10110000", 58 => "00011000", 59 => "11011100", 
    60 => "00010000", 61 => "11111011", 62 => "11110010", 63 => "11000110", 
    64 => "11101101", 65 => "00100110", 66 => "11101111", 67 => "00101001", 
    68 => "11001100", 69 => "00010001", 70 => "00000100", 71 => "00110111", 
    72 => "00010010", 73 => "11101011", 74 => "11000010", 75 => "11110100", 
    76 => "11010110", 77 => "00101001", 78 => "00011000", 79 => "00101010", 
    80 => "11110101", 81 => "11100001", 82 => "00101000", 83 => "11001010", 
    84 => "11110110", 85 => "00011110", 86 => "11110000", 87 => "11111001", 
    88 => "11010010", 89 => "00111100", 90 => "01000010", 91 => "00000111", 
    92 => "00011101", 93 => "00001101", 94 => "00010100", 95 => "01000100" );

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

entity conv1d_stage_W_PJge8 is
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

architecture arch of conv1d_stage_W_PJge8 is
    component conv1d_stage_W_PJge8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJge8_rom_U :  component conv1d_stage_W_PJge8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


