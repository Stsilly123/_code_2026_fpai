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

entity conv1d_stage_W_PJfT5_rom is 
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


architecture rtl of conv1d_stage_W_PJfT5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01001111", 1 => "00101110", 2 => "01111111", 3 => "11001010", 
    4 => "00001101", 5 => "11100011", 6 => "11100100", 7 => "10111000", 
    8 => "00000001", 9 => "11001010", 10 => "00010001", 11 => "00010101", 
    12 => "00010111", 13 => "10111111", 14 => "11010000", 15 => "01111111", 
    16 => "00010101", 17 => "11001010", 18 => "11100100", 19 => "00110111", 
    20 => "10000110", 21 => "11110010", 22 => "00100101", 23 => "01011010", 
    24 => "11011001", 25 => "11110101", 26 => "10110111", 27 => "10000001", 
    28 => "00110111", 29 => "11011111", 30 => "00111000", 31 => "11010111", 
    32 => "01000101", 33 => "11100111", 34 => "00101001", 35 => "00000011", 
    36 => "11001000", 37 => "00000110", 38 => "10111010", 39 => "11101000", 
    40 => "11001111", 41 => "00101000", 42 => "00111100", 43 => "00100010", 
    44 => "00010010", 45 => "11000111", 46 => "10111100", 47 => "01100010", 
    48 => "01000001", 49 => "11110001", 50 => "00000010", 51 => "10100010", 
    52 => "11011001", 53 => "00001110", 54 => "00100111", 55 => "11000000", 
    56 => "11000101", 57 => "01100100", 58 => "11000101", 59 => "00100101", 
    60 => "01000101", 61 => "11110001", 62 => "11010111", 63 => "11011100", 
    64 => "01111111", 65 => "10111010", 66 => "11111000", 67 => "11111101", 
    68 => "00100111", 69 => "11100001", 70 => "01001011", 71 => "11001110", 
    72 => "00010100", 73 => "11010100", 74 => "00110100", 75 => "01000000", 
    76 => "00101000", 77 => "11101011", 78 => "11101101", 79 => "01100000", 
    80 => "11110100", 81 => "10100001", 82 => "11110101", 83 => "00000010", 
    84 => "11111010", 85 => "11001111", 86 => "11101000", 87 => "01111111", 
    88 => "01010101", 89 => "00100000", 90 => "10000001", 91 => "00110101", 
    92 => "00101010", 93 => "01100010", 94 => "11111001", 95 => "10101111" );

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

entity conv1d_stage_W_PJfT5 is
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

architecture arch of conv1d_stage_W_PJfT5 is
    component conv1d_stage_W_PJfT5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfT5_rom_U :  component conv1d_stage_W_PJfT5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


