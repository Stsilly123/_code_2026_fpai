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

entity conv1d_stage_W_PJgk9_rom is 
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


architecture rtl of conv1d_stage_W_PJgk9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100010", 1 => "11110010", 2 => "01001111", 3 => "01001000", 
    4 => "00001010", 5 => "00111010", 6 => "11001001", 7 => "11110111", 
    8 => "00011110", 9 => "01000010", 10 => "00110101", 11 => "01010101", 
    12 => "11010001", 13 => "11110011", 14 => "11011011", 15 => "11110000", 
    16 => "10110101", 17 => "00011011", 18 => "11011101", 19 => "10110110", 
    20 => "00001100", 21 => "00000000", 22 => "11101010", 23 => "00010101", 
    24 => "11111000", 25 => "00111110", 26 => "11111111", 27 => "00000101", 
    28 => "11101010", 29 => "11000101", 30 => "11100001", 31 => "00011100", 
    32 => "10111100", 33 => "00101001", 34 => "00000011", 35 => "00100010", 
    36 => "00101110", 37 => "11100001", 38 => "00111011", 39 => "10101111", 
    40 => "11111110", 41 => "10110101", 42 => "10011110", 43 => "11101010", 
    44 => "01000000", 45 => "10111100", 46 => "00010001", 47 => "01110000", 
    48 => "10111000", 49 => "00001001", 50 => "00100011", 51 => "11110100", 
    52 => "11100110", 53 => "00000001", 54 => "00011001", 55 => "11011001", 
    56 => "01101100", 57 => "01001011", 58 => "11010111", 59 => "11111100", 
    60 => "10110010", 61 => "00010011", 62 => "11011000", 63 => "11001001", 
    64 => "00000000", 65 => "00110001", 66 => "00111001", 67 => "00001010", 
    68 => "00010010", 69 => "11101011", 70 => "11111111", 71 => "11110001", 
    72 => "00110001", 73 => "00011100", 74 => "00011101", 75 => "11111111", 
    76 => "11001101", 77 => "00000001", 78 => "10111001", 79 => "00010100", 
    80 => "11101101", 81 => "00100001", 82 => "11001111", 83 => "00110000", 
    84 => "11001100", 85 => "11000000", 86 => "11110101", 87 => "11101111", 
    88 => "11011111", 89 => "01001110", 90 => "00001000", 91 => "00001110", 
    92 => "11101101", 93 => "11010010", 94 => "11101100", 95 => "11111101" );

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

entity conv1d_stage_W_PJgk9 is
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

architecture arch of conv1d_stage_W_PJgk9 is
    component conv1d_stage_W_PJgk9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgk9_rom_U :  component conv1d_stage_W_PJgk9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


