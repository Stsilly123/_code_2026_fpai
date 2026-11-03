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

entity conv1d_stage_W_PJfR4_rom is 
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


architecture rtl of conv1d_stage_W_PJfR4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01001000", 1 => "11111001", 2 => "11101100", 3 => "00110010", 
    4 => "00101111", 5 => "11110101", 6 => "11001000", 7 => "11010101", 
    8 => "11111011", 9 => "00010111", 10 => "01011010", 11 => "00110101", 
    12 => "11011100", 13 => "00111011", 14 => "00101010", 15 => "00010011", 
    16 => "00001011", 17 => "00110111", 18 => "00111011", 19 => "00011001", 
    20 => "11110111", 21 => "00111101", 22 => "00010011", 23 => "11100110", 
    24 => "00100111", 25 => "11101010", 26 => "00110110", 27 => "11111010", 
    28 => "00111000", 29 => "11011110", 30 => "00011001", 31 => "00110001", 
    32 => "10110111", 33 => "00011010", 34 => "11110110", 35 => "01000101", 
    36 => "11111010", 37 => "11101010", 38 => "00000011", 39 => "11001111", 
    40 => "00100001", 41 => "00010101", 42 => "11110111", 43 => "00001110", 
    44 => "11110100", 45 => "00011100", 46 => "01000000", 47 => "11011000", 
    48 => "11111001", 49 => "11111101", 50 => "11100111", 51 => "00101001", 
    52 => "00101101", 53 => "00101111", 54 => "01010111", 55 => "00101101", 
    56 => "11111001", 57 => "10101011", 58 => "01000111", 59 => "00011000", 
    60 => "11011001", 61 => "10011001", 62 => "01110100", 63 => "10110110", 
    64 => "11000001", 65 => "11100011", 66 => "11111011", 67 => "11100110", 
    68 => "00110011", 69 => "11111011", 70 => "11111100", 71 => "11111011", 
    72 => "00001011", 73 => "00100111", 74 => "01010101", 75 => "00011111", 
    76 => "00001000", 77 => "11011110", 78 => "10000010", 79 => "00110010", 
    80 => "11010001", 81 => "10001101", 82 => "00101001", 83 => "00100100", 
    84 => "00000101", 85 => "00010001", 86 => "00111000", 87 => "00010101", 
    88 => "11011001", 89 => "11111001", 90 => "11101100", 91 => "11100010", 
    92 => "11110101", 93 => "00110001", 94 => "11101011", 95 => "01111111" );

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

entity conv1d_stage_W_PJfR4 is
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

architecture arch of conv1d_stage_W_PJfR4 is
    component conv1d_stage_W_PJfR4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfR4_rom_U :  component conv1d_stage_W_PJfR4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


