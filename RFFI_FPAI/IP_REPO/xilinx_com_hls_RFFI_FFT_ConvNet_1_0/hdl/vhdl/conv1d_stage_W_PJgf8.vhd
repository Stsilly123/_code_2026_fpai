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

entity conv1d_stage_W_PJgf8_rom is 
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


architecture rtl of conv1d_stage_W_PJgf8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110101", 1 => "10010111", 2 => "00100000", 3 => "11101010", 
    4 => "11001011", 5 => "11101110", 6 => "00001110", 7 => "10110011", 
    8 => "00001101", 9 => "00010001", 10 => "10001010", 11 => "00001101", 
    12 => "11011111", 13 => "11011110", 14 => "11100011", 15 => "00010100", 
    16 => "00011010", 17 => "10110010", 18 => "01010001", 19 => "11101101", 
    20 => "10000011", 21 => "11111001", 22 => "00000011", 23 => "11100111", 
    24 => "01111111", 25 => "01011110", 26 => "00010101", 27 => "11100110", 
    28 => "00010000", 29 => "11010111", 30 => "11011010", 31 => "00000010", 
    32 => "01011111", 33 => "11111011", 34 => "10111000", 35 => "10010001", 
    36 => "00100101", 37 => "10000100", 38 => "10100011", 39 => "00000000", 
    40 => "01111111", 41 => "00101110", 42 => "11100001", 43 => "00000011", 
    44 => "11010111", 45 => "00011010", 46 => "00001110", 47 => "11101110", 
    48 => "10100110", 49 => "00111000", 50 => "10000101", 51 => "00110010", 
    52 => "00101100", 53 => "00010100", 54 => "00010001", 55 => "11101000", 
    56 => "01110001", 57 => "11101111", 58 => "00010111", 59 => "00010110", 
    60 => "00010111", 61 => "00110011", 62 => "10010101", 63 => "10100010", 
    64 => "11110001", 65 => "10010000", 66 => "00111100", 67 => "00011111", 
    68 => "10100110", 69 => "01000001", 70 => "00101110", 71 => "00000101", 
    72 => "10111110", 73 => "11100000", 74 => "00110111", 75 => "11110101", 
    76 => "00010111", 77 => "01011000", 78 => "00001101", 79 => "00111000", 
    80 => "00010011", 81 => "10100110", 82 => "00110111", 83 => "10110110", 
    84 => "00110001", 85 => "00100001", 86 => "10010010", 87 => "00001111", 
    88 => "11000000", 89 => "11011011", 90 => "00000010", 91 => "00100001", 
    92 => "11111010", 93 => "10000001", 94 => "10111011", 95 => "10111101" );

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

entity conv1d_stage_W_PJgf8 is
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

architecture arch of conv1d_stage_W_PJgf8 is
    component conv1d_stage_W_PJgf8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgf8_rom_U :  component conv1d_stage_W_PJgf8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


