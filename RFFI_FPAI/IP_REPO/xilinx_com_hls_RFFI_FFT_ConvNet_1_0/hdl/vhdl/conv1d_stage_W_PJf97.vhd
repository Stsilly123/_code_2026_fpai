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

entity conv1d_stage_W_PJf97_rom is 
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


architecture rtl of conv1d_stage_W_PJf97_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001000", 1 => "11111111", 2 => "10100000", 3 => "10110100", 
    4 => "01100101", 5 => "00110111", 6 => "11010011", 7 => "01111110", 
    8 => "11100100", 9 => "11101101", 10 => "00010100", 11 => "10000001", 
    12 => "10110100", 13 => "10011000", 14 => "11010001", 15 => "11100001", 
    16 => "10101011", 17 => "00101000", 18 => "00000000", 19 => "10000001", 
    20 => "00010110", 21 => "01111001", 22 => "10010100", 23 => "11000010", 
    24 => "11100111", 25 => "00011010", 26 => "00011111", 27 => "11011111", 
    28 => "01111111", 29 => "11001101", 30 => "00011010", 31 => "01110101", 
    32 => "11000100", 33 => "01010101", 34 => "00110110", 35 => "00000010", 
    36 => "00100110", 37 => "00001000", 38 => "10111000", 39 => "10000001", 
    40 => "01011101", 41 => "01001011", 42 => "01111111", 43 => "11110101", 
    44 => "11111111", 45 => "11111000", 46 => "11111100", 47 => "00101010", 
    48 => "11111100", 49 => "00101111", 50 => "00000110", 51 => "11011011", 
    52 => "10111000", 53 => "00001000", 54 => "01111111", 55 => "01110111", 
    56 => "10100011", 57 => "10000011", 58 => "11111011", 59 => "11010101", 
    60 => "00101010", 61 => "00101000", 62 => "11010111", 63 => "00011111", 
    64 => "10111000", 65 => "00100001", 66 => "01001011", 67 => "11110111", 
    68 => "00010101", 69 => "11010110", 70 => "11011101", 71 => "00101110", 
    72 => "11100111", 73 => "00000101", 74 => "00000111", 75 => "11111001", 
    76 => "10100011", 77 => "00100010", 78 => "11010101", 79 => "11100110", 
    80 => "00001010", 81 => "01010100", 82 => "11000010", 83 => "00001011", 
    84 => "00110100", 85 => "11101010", 86 => "10000001", 87 => "11101010", 
    88 => "00000001", 89 => "00010001", 90 => "00101100", 91 => "00100011", 
    92 => "00100111", 93 => "00100011", 94 => "10010101", 95 => "11111001" );

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

entity conv1d_stage_W_PJf97 is
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

architecture arch of conv1d_stage_W_PJf97 is
    component conv1d_stage_W_PJf97_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf97_rom_U :  component conv1d_stage_W_PJf97_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


