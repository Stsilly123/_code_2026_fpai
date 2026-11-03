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

entity conv1d_stage_W_PJf16_rom is 
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


architecture rtl of conv1d_stage_W_PJf16_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101100", 1 => "01000110", 2 => "11111100", 3 => "10000001", 
    4 => "01000100", 5 => "01000000", 6 => "01111111", 7 => "11111001", 
    8 => "11010100", 9 => "11011110", 10 => "11111100", 11 => "00100011", 
    12 => "10100111", 13 => "00010101", 14 => "11101000", 15 => "00110110", 
    16 => "11111010", 17 => "00010101", 18 => "11010100", 19 => "11001011", 
    20 => "11100111", 21 => "11101100", 22 => "11111011", 23 => "11011010", 
    24 => "01000101", 25 => "11011100", 26 => "11000011", 27 => "00100001", 
    28 => "10100101", 29 => "11100001", 30 => "11110111", 31 => "01000001", 
    32 => "01010101", 33 => "00000110", 34 => "11111001", 35 => "11000010", 
    36 => "01100010", 37 => "11100011", 38 => "11101001", 39 => "00111000", 
    40 => "11110111", 41 => "11100101", 42 => "00011100", 43 => "11010000", 
    44 => "00101101", 45 => "11010100", 46 => "01000000", 47 => "11100011", 
    48 => "11110100", 49 => "11101111", 50 => "00101111", 51 => "00000111", 
    52 => "00110111", 53 => "00101101", 54 => "01010111", 55 => "11001110", 
    56 => "11100000", 57 => "11011111", 58 => "10110010", 59 => "00101111", 
    60 => "11011111", 61 => "00101111", 62 => "00000000", 63 => "00010010", 
    64 => "10111011", 65 => "11111101", 66 => "11110011", 67 => "01001000", 
    68 => "10110001", 69 => "00100100", 70 => "10111001", 71 => "11010100", 
    72 => "11101010", 73 => "00001010", 74 => "00110001", 75 => "00001110", 
    76 => "11011010", 77 => "11100011", 78 => "10101010", 79 => "00001010", 
    80 => "11100010", 81 => "00111111", 82 => "00010001", 83 => "01101000", 
    84 => "00010110", 85 => "00000001", 86 => "01000000", 87 => "00100110", 
    88 => "01011001", 89 => "11001100", 90 => "00110000", 91 => "11111000", 
    92 => "11100011", 93 => "10111010", 94 => "11010111", 95 => "11110001" );

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

entity conv1d_stage_W_PJf16 is
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

architecture arch of conv1d_stage_W_PJf16 is
    component conv1d_stage_W_PJf16_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf16_rom_U :  component conv1d_stage_W_PJf16_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


