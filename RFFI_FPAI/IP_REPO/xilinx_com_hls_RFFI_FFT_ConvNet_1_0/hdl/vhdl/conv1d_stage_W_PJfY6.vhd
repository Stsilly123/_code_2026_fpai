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

entity conv1d_stage_W_PJfY6_rom is 
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


architecture rtl of conv1d_stage_W_PJfY6_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11001111", 1 => "11101110", 2 => "00001100", 3 => "00101011", 
    4 => "00000101", 5 => "00011100", 6 => "11111010", 7 => "01000101", 
    8 => "00011110", 9 => "01000000", 10 => "01101010", 11 => "01011100", 
    12 => "11100011", 13 => "00101011", 14 => "10111010", 15 => "11001100", 
    16 => "00011101", 17 => "10111010", 18 => "00011110", 19 => "00000100", 
    20 => "00001110", 21 => "00100101", 22 => "00001011", 23 => "11000011", 
    24 => "00001011", 25 => "00110100", 26 => "11101100", 27 => "00001100", 
    28 => "00101111", 29 => "11110111", 30 => "11111100", 31 => "10110011", 
    32 => "11111000", 33 => "11111011", 34 => "00001010", 35 => "10100000", 
    36 => "10010100", 37 => "11111110", 38 => "11000011", 39 => "10100000", 
    40 => "11111010", 41 => "00000001", 42 => "11100101", 43 => "11101011", 
    44 => "00011011", 45 => "00010101", 46 => "00001111", 47 => "11101100", 
    48 => "00011111", 49 => "00000011", 50 => "11111001", 51 => "11001011", 
    52 => "00010111", 53 => "11110010", 54 => "00011010", 55 => "00100111", 
    56 => "11000000", 57 => "00000110", 58 => "11010100", 59 => "00000101", 
    60 => "00011000", 61 => "11110100", 62 => "11000001", 63 => "10110100", 
    64 => "00001011", 65 => "00000100", 66 => "10110100", 67 => "01101011", 
    68 => "00000011", 69 => "01011011", 70 => "00100101", 71 => "00100000", 
    72 => "11110001", 73 => "00010000", 74 => "00010001", 75 => "11001100", 
    76 => "00101110", 77 => "11011010", 78 => "01111111", 79 => "00001101", 
    80 => "00011100", 81 => "11111010", 82 => "11001000", 83 => "00011101", 
    84 => "11101100", 85 => "11000010", 86 => "11001000", 87 => "11011110", 
    88 => "00000111", 89 => "00110100", 90 => "11101011", 91 => "01111111", 
    92 => "11101011", 93 => "00110100", 94 => "00001110", 95 => "10111111" );

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

entity conv1d_stage_W_PJfY6 is
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

architecture arch of conv1d_stage_W_PJfY6 is
    component conv1d_stage_W_PJfY6_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfY6_rom_U :  component conv1d_stage_W_PJfY6_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


