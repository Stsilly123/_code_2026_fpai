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

entity conv1d_stage_W_PJfZ6_rom is 
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


architecture rtl of conv1d_stage_W_PJfZ6_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011100", 1 => "00011001", 2 => "00001110", 3 => "01001011", 
    4 => "00000000", 5 => "11101010", 6 => "11100101", 7 => "01000001", 
    8 => "11100010", 9 => "11110010", 10 => "00011001", 11 => "00101001", 
    12 => "01010001", 13 => "11011001", 14 => "11100011", 15 => "11010100", 
    16 => "00111111", 17 => "01000000", 18 => "11001101", 19 => "11111000", 
    20 => "10010100", 21 => "11101001", 22 => "11110100", 23 => "00011101", 
    24 => "00101110", 25 => "00000011", 26 => "00101010", 27 => "00101111", 
    28 => "11101110", 29 => "00110111", 30 => "11111010", 31 => "11100111", 
    32 => "00000101", 33 => "10101000", 34 => "01000011", 35 => "11000100", 
    36 => "00000010", 37 => "11110100", 38 => "11000010", 39 => "11010110", 
    40 => "10100100", 41 => "11100010", 42 => "11110110", 43 => "00101000", 
    44 => "10011101", 45 => "11100011", 46 => "11010111", 47 => "11101010", 
    48 => "11001111", 49 => "11000111", 50 => "00111110", 51 => "01010110", 
    52 => "10111110", 53 => "01111111", 54 => "00101001", 55 => "00001101", 
    56 => "00101000", 57 => "11001110", 58 => "11000111", 59 => "01010001", 
    60 => "11011000", 61 => "11101001", 62 => "10101010", 63 => "10111110", 
    64 => "11111100", 65 => "01010101", 66 => "00010000", 67 => "00100010", 
    68 => "11011101", 69 => "00101110", 70 => "11011000", 71 => "01111111", 
    72 => "00001110", 73 => "10110110", 74 => "00010010", 75 => "11100011", 
    76 => "00000111", 77 => "01000011", 78 => "00110101", 79 => "11100001", 
    80 => "00000111", 81 => "00100010", 82 => "11101011", 83 => "10001111", 
    84 => "00011111", 85 => "11111010", 86 => "11111001", 87 => "00000000", 
    88 => "11101110", 89 => "00110100", 90 => "11111001", 91 => "11111101", 
    92 => "10110111", 93 => "00011011", 94 => "00101110", 95 => "01000110" );

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

entity conv1d_stage_W_PJfZ6 is
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

architecture arch of conv1d_stage_W_PJfZ6 is
    component conv1d_stage_W_PJfZ6_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfZ6_rom_U :  component conv1d_stage_W_PJfZ6_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


