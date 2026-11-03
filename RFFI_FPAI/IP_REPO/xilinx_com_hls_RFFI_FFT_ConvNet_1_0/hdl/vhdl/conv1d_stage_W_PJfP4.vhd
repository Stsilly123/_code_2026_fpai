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

entity conv1d_stage_W_PJfP4_rom is 
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


architecture rtl of conv1d_stage_W_PJfP4_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111110", 1 => "11100010", 2 => "00101010", 3 => "11010101", 
    4 => "10000011", 5 => "10111010", 6 => "00100110", 7 => "11011001", 
    8 => "00100110", 9 => "01111100", 10 => "11011000", 11 => "10110001", 
    12 => "11111110", 13 => "01010010", 14 => "11101010", 15 => "11100011", 
    16 => "00100110", 17 => "00011011", 18 => "11111101", 19 => "11110101", 
    20 => "11101110", 21 => "01100011", 22 => "11100001", 23 => "00001010", 
    24 => "11100110", 25 => "11011100", 26 => "11011010", 27 => "01001000", 
    28 => "00010000", 29 => "00011001", 30 => "00001111", 31 => "00100111", 
    32 => "11101000", 33 => "00101100", 34 => "00101101", 35 => "10101001", 
    36 => "11111001", 37 => "00011001", 38 => "00100000", 39 => "01000011", 
    40 => "00100100", 41 => "00001110", 42 => "01000111", 43 => "11110101", 
    44 => "00001000", 45 => "11101001", 46 => "11110001", 47 => "01000101", 
    48 => "11000011", 49 => "11111111", 50 => "10011011", 51 => "11000001", 
    52 => "11000100", 53 => "11011100", 54 => "11100011", 55 => "11010010", 
    56 => "00001100", 57 => "11111111", 58 => "00110000", 59 => "00101100", 
    60 => "00001001", 61 => "11010110", 62 => "10111001", 63 => "00010110", 
    64 => "11111111", 65 => "00100101", 66 => "00100111", 67 => "00001101", 
    68 => "00001111", 69 => "00000100", 70 => "00001110", 71 => "01100101", 
    72 => "11001011", 73 => "11001101", 74 => "00011010", 75 => "00010100", 
    76 => "00010001", 77 => "11001100", 78 => "11000010", 79 => "11010010", 
    80 => "11111100", 81 => "10000001", 82 => "10110110", 83 => "11110000", 
    84 => "00000100", 85 => "00100000", 86 => "11111111", 87 => "11110111", 
    88 => "00010011", 89 => "11001100", 90 => "00111011", 91 => "11100001", 
    92 => "11111011", 93 => "00000011", 94 => "11001000", 95 => "00001111" );

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

entity conv1d_stage_W_PJfP4 is
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

architecture arch of conv1d_stage_W_PJfP4 is
    component conv1d_stage_W_PJfP4_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfP4_rom_U :  component conv1d_stage_W_PJfP4_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


