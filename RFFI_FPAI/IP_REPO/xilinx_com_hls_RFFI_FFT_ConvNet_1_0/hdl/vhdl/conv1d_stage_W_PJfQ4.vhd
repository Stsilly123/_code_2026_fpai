-- ==============================================================
-- File generated on Sun Oct 18 16:53:11 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJfQ4_rom is 
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


architecture rtl of conv1d_stage_W_PJfQ4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010101", 1 => "00001011", 2 => "11010111", 3 => "00100010", 
    4 => "11110110", 5 => "11011101", 6 => "00001011", 7 => "00111001", 
    8 => "11100110", 9 => "00101011", 10 => "11110101", 11 => "10100010", 
    12 => "00000011", 13 => "10111001", 14 => "00100100", 15 => "11110001", 
    16 => "11101111", 17 => "00111101", 18 => "11000100", 19 => "11101010", 
    20 => "01001101", 21 => "00000101", 22 => "00011000", 23 => "00100001", 
    24 => "00101111", 25 => "00101001", 26 => "00001110", 27 => "00000000", 
    28 => "00001101", 29 => "00000101", 30 => "00110100", 31 => "11110011", 
    32 => "11011110", 33 => "00000001", 34 => "00000011", 35 => "11100100", 
    36 => "11111011", 37 => "00101101", 38 => "00101011", 39 => "11101000", 
    40 => "10110110", 41 => "00100100", 42 => "00000110", 43 => "10111111", 
    44 => "00100101", 45 => "00000011", 46 => "11011101", 47 => "00100110", 
    48 => "10000001", 49 => "00000101", 50 => "00000010", 51 => "11111111", 
    52 => "10101111", 53 => "00000111", 54 => "10111111", 55 => "00100011", 
    56 => "01100101", 57 => "11111100", 58 => "00111110", 59 => "00101001", 
    60 => "01111111", 61 => "11111001", 62 => "11101100", 63 => "00100001", 
    64 => "11100001", 65 => "11011000", 66 => "00000001", 67 => "10111111", 
    68 => "00100110", 69 => "11111010", 70 => "00100110", 71 => "11011100", 
    72 => "00100111", 73 => "00110100", 74 => "10111011", 75 => "00100111", 
    76 => "00110001", 77 => "00100100", 78 => "11110010", 79 => "11000111", 
    80 => "00000101", 81 => "11011010", 82 => "00001000", 83 => "10110011", 
    84 => "11010010", 85 => "11100011", 86 => "00111110", 87 => "11111011", 
    88 => "01001101", 89 => "11111000", 90 => "11001000", 91 => "11001001", 
    92 => "00011111", 93 => "11100000", 94 => "00010101", 95 => "11111101" );

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

entity conv1d_stage_W_PJfQ4 is
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

architecture arch of conv1d_stage_W_PJfQ4 is
    component conv1d_stage_W_PJfQ4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfQ4_rom_U :  component conv1d_stage_W_PJfQ4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


