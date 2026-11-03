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

entity conv1d_stage_W_PJf57_rom is 
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


architecture rtl of conv1d_stage_W_PJf57_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100111", 1 => "00100010", 2 => "11100001", 3 => "11011010", 
    4 => "11110110", 5 => "11101101", 6 => "01010000", 7 => "00001100", 
    8 => "00110110", 9 => "00001101", 10 => "11001111", 11 => "00001010", 
    12 => "01111010", 13 => "00010110", 14 => "01001001", 15 => "11100011", 
    16 => "00100110", 17 => "00000101", 18 => "01000001", 19 => "00101010", 
    20 => "00111100", 21 => "11000000", 22 => "11111111", 23 => "00000010", 
    24 => "00011111", 25 => "00000011", 26 => "00001110", 27 => "00000000", 
    28 => "00000010", 29 => "11010100", 30 => "10000001", 31 => "11101110", 
    32 => "11100111", 33 => "00001101", 34 => "00011001", 35 => "00100010", 
    36 => "00101101", 37 => "00100101", 38 => "11001111", 39 => "11001101", 
    40 => "00100000", 41 => "01011010", 42 => "00010110", 43 => "11110111", 
    44 => "10000001", 45 => "00010011", 46 => "00111101", 47 => "00010001", 
    48 => "00000000", 49 => "11001100", 50 => "10111010", 51 => "11101000", 
    52 => "00110011", 53 => "11101010", 54 => "11001000", 55 => "10101101", 
    56 => "10011101", 57 => "10101111", 58 => "11010011", 59 => "00010110", 
    60 => "11111000", 61 => "11101110", 62 => "11100000", 63 => "11111010", 
    64 => "10111110", 65 => "01000001", 66 => "00101100", 67 => "10111100", 
    68 => "00110101", 69 => "11111110", 70 => "00001000", 71 => "11110111", 
    72 => "01000010", 73 => "11101101", 74 => "01100101", 75 => "00001011", 
    76 => "11111110", 77 => "00110010", 78 => "01100111", 79 => "00101010", 
    80 => "11100010", 81 => "01001111", 82 => "00100010", 83 => "00000011", 
    84 => "11110101", 85 => "00111111", 86 => "01010011", 87 => "00001110", 
    88 => "00000101", 89 => "11111100", 90 => "11101110", 91 => "11001111", 
    92 => "11111101", 93 => "11111010", 94 => "11010100", 95 => "11000110" );

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

entity conv1d_stage_W_PJf57 is
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

architecture arch of conv1d_stage_W_PJf57 is
    component conv1d_stage_W_PJf57_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf57_rom_U :  component conv1d_stage_W_PJf57_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


