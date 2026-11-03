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

entity conv1d_stage_W_PJgtb_rom is 
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


architecture rtl of conv1d_stage_W_PJgtb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10100010", 1 => "11011110", 2 => "11101110", 3 => "11111100", 
    4 => "00000100", 5 => "00110101", 6 => "00101110", 7 => "00011001", 
    8 => "00011111", 9 => "11011111", 10 => "00011111", 11 => "00101101", 
    12 => "00101001", 13 => "00001110", 14 => "01000010", 15 => "00000001", 
    16 => "11010010", 17 => "11011100", 18 => "11001011", 19 => "01001100", 
    20 => "00011011", 21 => "11010010", 22 => "00010111", 23 => "11011101", 
    24 => "11110111", 25 => "11001101", 26 => "11101001", 27 => "11110011", 
    28 => "11111000", 29 => "11011000", 30 => "00000101", 31 => "00010000", 
    32 => "01001100", 33 => "10000001", 34 => "10111100", 35 => "00001111", 
    36 => "11010011", 37 => "10101111", 38 => "11101110", 39 => "01001110", 
    40 => "11010011", 41 => "11110110", 42 => "11110011", 43 => "01000101", 
    44 => "00100000", 45 => "00111011", 46 => "10000001", 47 => "11011110", 
    48 => "11001011", 49 => "11001000", 50 => "01000100", 51 => "11100011", 
    52 => "00001011", 53 => "11110110", 54 => "11011111", 55 => "11101111", 
    56 => "00101111", 57 => "01111111", 58 => "11101000", 59 => "10000011", 
    60 => "11000001", 61 => "00001011", 62 => "00001100", 63 => "10100011", 
    64 => "00010111", 65 => "11100100", 66 => "11000111", 67 => "11010001", 
    68 => "01011100", 69 => "11111101", 70 => "11110101", 71 => "11010010", 
    72 => "00100011", 73 => "11001110", 74 => "00111111", 75 => "10110100", 
    76 => "00100110", 77 => "00101011", 78 => "10101110", 79 => "11100111", 
    80 => "11011100", 81 => "01011000", 82 => "00001111", 83 => "11110000", 
    84 => "00001000", 85 => "01001000", 86 => "00010001", 87 => "00111110", 
    88 => "11111001", 89 => "11111011", 90 => "11110100", 91 => "10111111", 
    92 => "11101000", 93 => "00001110", 94 => "00010111", 95 => "00000101" );

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

entity conv1d_stage_W_PJgtb is
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

architecture arch of conv1d_stage_W_PJgtb is
    component conv1d_stage_W_PJgtb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgtb_rom_U :  component conv1d_stage_W_PJgtb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


