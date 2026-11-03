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

entity conv1d_stage_W_PJgwb_rom is 
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


architecture rtl of conv1d_stage_W_PJgwb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010111", 1 => "01111010", 2 => "10010011", 3 => "11100011", 
    4 => "11101110", 5 => "00011100", 6 => "00000001", 7 => "11010001", 
    8 => "11010101", 9 => "00001011", 10 => "00001110", 11 => "10100001", 
    12 => "01000011", 13 => "00000110", 14 => "01000100", 15 => "00001111", 
    16 => "00011111", 17 => "10100001", 18 => "11111010", 19 => "00110011", 
    20 => "00011001", 21 => "00011010", 22 => "11100101", 23 => "00010001", 
    24 => "11110110", 25 => "00000001", 26 => "00111001", 27 => "11111010", 
    28 => "11011111", 29 => "00001001", 30 => "00000010", 31 => "11010111", 
    32 => "01010100", 33 => "00010000", 34 => "00011101", 35 => "11000011", 
    36 => "10100000", 37 => "00010110", 38 => "00100111", 39 => "11100100", 
    40 => "01010111", 41 => "11110111", 42 => "11100010", 43 => "11010100", 
    44 => "01001011", 45 => "11100101", 46 => "10010110", 47 => "10010000", 
    48 => "00011011", 49 => "00010000", 50 => "00010100", 51 => "00001101", 
    52 => "11110001", 53 => "00101001", 54 => "00011011", 55 => "11001011", 
    56 => "11110101", 57 => "11011100", 58 => "10100000", 59 => "00100110", 
    60 => "11100011", 61 => "11001100", 62 => "11100101", 63 => "00100101", 
    64 => "00110100", 65 => "11101001", 66 => "00001011", 67 => "10100011", 
    68 => "11110001", 69 => "11001001", 70 => "00010100", 71 => "11000110", 
    72 => "10111100", 73 => "00010011", 74 => "01010111", 75 => "11000101", 
    76 => "10010011", 77 => "00101001", 78 => "11101100", 79 => "11111111", 
    80 => "11110000", 81 => "00000100", 82 => "00000001", 83 => "11100010", 
    84 => "11110110", 85 => "10101101", 86 => "00000011", 87 => "10111001", 
    88 => "01000101", 89 => "11100011", 90 => "11111011", 91 => "11011010", 
    92 => "11111100", 93 => "00111111", 94 => "11001010", 95 => "11001000" );

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

entity conv1d_stage_W_PJgwb is
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

architecture arch of conv1d_stage_W_PJgwb is
    component conv1d_stage_W_PJgwb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgwb_rom_U :  component conv1d_stage_W_PJgwb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


