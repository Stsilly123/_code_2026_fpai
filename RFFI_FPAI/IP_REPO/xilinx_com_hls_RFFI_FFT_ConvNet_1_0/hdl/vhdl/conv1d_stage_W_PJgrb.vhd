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

entity conv1d_stage_W_PJgrb_rom is 
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


architecture rtl of conv1d_stage_W_PJgrb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101100", 1 => "01101011", 2 => "10110111", 3 => "11111110", 
    4 => "11101000", 5 => "11010101", 6 => "00010110", 7 => "11001001", 
    8 => "00001110", 9 => "10110101", 10 => "01011110", 11 => "01000111", 
    12 => "00100111", 13 => "11010101", 14 => "01011110", 15 => "00000001", 
    16 => "00001101", 17 => "00010011", 18 => "00011011", 19 => "11110011", 
    20 => "00101110", 21 => "11111100", 22 => "11100100", 23 => "00110100", 
    24 => "00100100", 25 => "00011001", 26 => "00100001", 27 => "11100110", 
    28 => "11001111", 29 => "01111111", 30 => "00001100", 31 => "00010011", 
    32 => "01001100", 33 => "00110000", 34 => "11011110", 35 => "11001011", 
    36 => "11000100", 37 => "00001100", 38 => "11010101", 39 => "10101010", 
    40 => "01001110", 41 => "00010101", 42 => "01001011", 43 => "00000010", 
    44 => "11011100", 45 => "11100100", 46 => "00000111", 47 => "01000010", 
    48 => "00000000", 49 => "11000011", 50 => "01001010", 51 => "00011000", 
    52 => "10111000", 53 => "11110001", 54 => "00101010", 55 => "11011010", 
    56 => "01010100", 57 => "01101101", 58 => "00000110", 59 => "01001111", 
    60 => "11100101", 61 => "00000111", 62 => "11110110", 63 => "00011010", 
    64 => "01010011", 65 => "01001100", 66 => "00011101", 67 => "00111010", 
    68 => "10101110", 69 => "11100011", 70 => "00000000", 71 => "11110110", 
    72 => "01111111", 73 => "11110001", 74 => "11101110", 75 => "11100010", 
    76 => "00010011", 77 => "11101111", 78 => "00100011", 79 => "11011101", 
    80 => "00010010", 81 => "00100101", 82 => "00010011", 83 => "11101110", 
    84 => "11111100", 85 => "00100010", 86 => "11110110", 87 => "00000110", 
    88 => "10111001", 89 => "01010110", 90 => "00010101", 91 => "00001011", 
    92 => "11011000", 93 => "01100010", 94 => "00110010", 95 => "11110110" );

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

entity conv1d_stage_W_PJgrb is
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

architecture arch of conv1d_stage_W_PJgrb is
    component conv1d_stage_W_PJgrb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgrb_rom_U :  component conv1d_stage_W_PJgrb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


