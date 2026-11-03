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

entity conv1d_stage_W_PJgvb_rom is 
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


architecture rtl of conv1d_stage_W_PJgvb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111110", 1 => "00011100", 2 => "01001100", 3 => "00110111", 
    4 => "11110011", 5 => "00001100", 6 => "01000010", 7 => "00001100", 
    8 => "11101100", 9 => "11111001", 10 => "10101100", 11 => "11101101", 
    12 => "11100011", 13 => "11011011", 14 => "11101101", 15 => "00000110", 
    16 => "00011101", 17 => "11101111", 18 => "11101001", 19 => "00011111", 
    20 => "11001000", 21 => "00001111", 22 => "01010000", 23 => "11101001", 
    24 => "01000000", 25 => "11110101", 26 => "10101100", 27 => "11101011", 
    28 => "11101010", 29 => "11000010", 30 => "00011010", 31 => "00001101", 
    32 => "01001011", 33 => "00011001", 34 => "11110000", 35 => "00101101", 
    36 => "11011110", 37 => "10111110", 38 => "10110111", 39 => "01000110", 
    40 => "11101101", 41 => "11000011", 42 => "11011101", 43 => "11111000", 
    44 => "11100011", 45 => "00010011", 46 => "01011001", 47 => "10101001", 
    48 => "01000100", 49 => "10100111", 50 => "11100100", 51 => "01011010", 
    52 => "00010010", 53 => "10001010", 54 => "11100100", 55 => "11111100", 
    56 => "00010000", 57 => "11111101", 58 => "00010110", 59 => "11000110", 
    60 => "11101010", 61 => "00010100", 62 => "11011010", 63 => "10010011", 
    64 => "10101001", 65 => "10111001", 66 => "11001100", 67 => "11000010", 
    68 => "01001101", 69 => "11111110", 70 => "11110011", 71 => "00010101", 
    72 => "00000001", 73 => "00011001", 74 => "11110010", 75 => "00000110", 
    76 => "00010100", 77 => "00000101", 78 => "01111101", 79 => "01011101", 
    80 => "00101101", 81 => "00001010", 82 => "00011000", 83 => "00101110", 
    84 => "11010100", 85 => "00111101", 86 => "11001101", 87 => "00000000", 
    88 => "11101010", 89 => "00111101", 90 => "01000001", 91 => "01011000", 
    92 => "00110010", 93 => "01000000", 94 => "11100001", 95 => "00000000" );

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

entity conv1d_stage_W_PJgvb is
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

architecture arch of conv1d_stage_W_PJgvb is
    component conv1d_stage_W_PJgvb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgvb_rom_U :  component conv1d_stage_W_PJgvb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


