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

entity conv1d_stage_W_PJgqb_rom is 
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


architecture rtl of conv1d_stage_W_PJgqb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001101", 1 => "00000110", 2 => "00111011", 3 => "00101100", 
    4 => "00100100", 5 => "00101110", 6 => "11110000", 7 => "11000100", 
    8 => "00010111", 9 => "00110011", 10 => "00001010", 11 => "11111000", 
    12 => "00001010", 13 => "00000010", 14 => "00100101", 15 => "11110000", 
    16 => "00101001", 17 => "01111100", 18 => "00011111", 19 => "00000001", 
    20 => "10100111", 21 => "10000001", 22 => "00111000", 23 => "00000101", 
    24 => "00001111", 25 => "00111101", 26 => "01001000", 27 => "01010111", 
    28 => "11110001", 29 => "00011000", 30 => "00001100", 31 => "10011111", 
    32 => "11001100", 33 => "11010000", 34 => "11011011", 35 => "11000110", 
    36 => "00000101", 37 => "11110100", 38 => "00110000", 39 => "00010010", 
    40 => "00011100", 41 => "11011110", 42 => "11110100", 43 => "10101110", 
    44 => "00000010", 45 => "01001110", 46 => "00011010", 47 => "00110101", 
    48 => "11011110", 49 => "11101010", 50 => "01000111", 51 => "00101010", 
    52 => "11111001", 53 => "11100101", 54 => "11110000", 55 => "00010001", 
    56 => "11110100", 57 => "11110000", 58 => "00011001", 59 => "11000000", 
    60 => "00110101", 61 => "00000010", 62 => "01001011", 63 => "00001101", 
    64 => "00011000", 65 => "00000100", 66 => "00001000", 67 => "00000010", 
    68 => "11100001", 69 => "11100101", 70 => "11111011", 71 => "00100111", 
    72 => "00011101", 73 => "11111101", 74 => "11010111", 75 => "11101000", 
    76 => "11110111", 77 => "01000010", 78 => "11111111", 79 => "11101110", 
    80 => "00010011", 81 => "00100110", 82 => "11111010", 83 => "00011001", 
    84 => "11111000", 85 => "11111010", 86 => "01000100", 87 => "00101111", 
    88 => "00000111", 89 => "01001100", 90 => "00100000", 91 => "11111011", 
    92 => "01000000", 93 => "10110111", 94 => "00100000", 95 => "00110100" );

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

entity conv1d_stage_W_PJgqb is
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

architecture arch of conv1d_stage_W_PJgqb is
    component conv1d_stage_W_PJgqb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgqb_rom_U :  component conv1d_stage_W_PJgqb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


