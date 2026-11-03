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

entity conv1d_stage_W_PJgh9_rom is 
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


architecture rtl of conv1d_stage_W_PJgh9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000111", 1 => "00010100", 2 => "00110111", 3 => "11010101", 
    4 => "11101011", 5 => "00010111", 6 => "00111011", 7 => "11011010", 
    8 => "00001010", 9 => "10000001", 10 => "00011110", 11 => "01001111", 
    12 => "11100101", 13 => "01001000", 14 => "11110110", 15 => "00101001", 
    16 => "00010000", 17 => "11010010", 18 => "00000001", 19 => "00100100", 
    20 => "00111001", 21 => "11010001", 22 => "00100011", 23 => "11111110", 
    24 => "11111011", 25 => "11110001", 26 => "01010100", 27 => "11111000", 
    28 => "00010010", 29 => "00100001", 30 => "00010100", 31 => "10111101", 
    32 => "11010010", 33 => "00010011", 34 => "01111111", 35 => "00000010", 
    36 => "00110101", 37 => "01001101", 38 => "00111111", 39 => "00010111", 
    40 => "00101110", 41 => "11010100", 42 => "00100001", 43 => "00100011", 
    44 => "11001011", 45 => "01101000", 46 => "11010111", 47 => "11101100", 
    48 => "00110100", 49 => "00011100", 50 => "11000101", 51 => "00010011", 
    52 => "11011110", 53 => "00001010", 54 => "10110100", 55 => "00011001", 
    56 => "10011111", 57 => "11001011", 58 => "00000101", 59 => "10111010", 
    60 => "01100000", 61 => "00011100", 62 => "10100000", 63 => "00101010", 
    64 => "11101010", 65 => "10101100", 66 => "11110111", 67 => "00000011", 
    68 => "01101000", 69 => "00001001", 70 => "11110101", 71 => "11110000", 
    72 => "00100010", 73 => "00010110", 74 => "11000011", 75 => "01000010", 
    76 => "00000001", 77 => "00100111", 78 => "01100110", 79 => "11110100", 
    80 => "11100101", 81 => "11111011", 82 => "11011101", 83 => "00010010", 
    84 => "11110110", 85 => "10111110", 86 => "00110101", 87 => "11100101", 
    88 => "00100000", 89 => "11000001", 90 => "11100110", 91 => "01110101", 
    92 => "00101100", 93 => "11110101", 94 => "00110101", 95 => "00010111" );

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

entity conv1d_stage_W_PJgh9 is
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

architecture arch of conv1d_stage_W_PJgh9 is
    component conv1d_stage_W_PJgh9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgh9_rom_U :  component conv1d_stage_W_PJgh9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


