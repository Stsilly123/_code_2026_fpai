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

entity conv1d_stage_W_PJfS5_rom is 
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


architecture rtl of conv1d_stage_W_PJfS5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000100", 1 => "11111001", 2 => "00000110", 3 => "11110000", 
    4 => "11110011", 5 => "00100110", 6 => "11110011", 7 => "11100000", 
    8 => "00100011", 9 => "11100110", 10 => "11101110", 11 => "00111011", 
    12 => "00011001", 13 => "11011111", 14 => "11011011", 15 => "00100110", 
    16 => "00110110", 17 => "11000000", 18 => "11010010", 19 => "00011000", 
    20 => "00010010", 21 => "11100000", 22 => "11111010", 23 => "11100100", 
    24 => "00000100", 25 => "00111011", 26 => "11011110", 27 => "00000111", 
    28 => "11011101", 29 => "00101101", 30 => "11101001", 31 => "00011011", 
    32 => "01010001", 33 => "11011111", 34 => "00000001", 35 => "11111000", 
    36 => "11000011", 37 => "00100110", 38 => "00010101", 39 => "11000001", 
    40 => "11101101", 41 => "00010010", 42 => "00001000", 43 => "11001111", 
    44 => "01001010", 45 => "11001110", 46 => "11100000", 47 => "11011000", 
    48 => "01100111", 49 => "11111100", 50 => "00110100", 51 => "00000100", 
    52 => "00011000", 53 => "11111100", 54 => "11101010", 55 => "11011011", 
    56 => "11100110", 57 => "11110000", 58 => "00100000", 59 => "11011110", 
    60 => "00001011", 61 => "00011010", 62 => "11111101", 63 => "11111010", 
    64 => "11111001", 65 => "00010101", 66 => "11111000", 67 => "11001011", 
    68 => "00100111", 69 => "11101000", 70 => "11110110", 71 => "11111001", 
    72 => "11100010", 73 => "00010011", 74 => "00011001", 75 => "11111010", 
    76 to 77=> "00001010", 78 => "11100000", 79 => "11111011", 80 => "00000110", 
    81 => "00111100", 82 => "00010111", 83 => "11100101", 84 => "00110101", 
    85 => "00101001", 86 => "00001000", 87 => "11111100", 88 => "00101001", 
    89 => "00001001", 90 => "11111011", 91 => "00100010", 92 => "00000001", 
    93 => "11111100", 94 => "00011001", 95 => "11000100" );

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

entity conv1d_stage_W_PJfS5 is
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

architecture arch of conv1d_stage_W_PJfS5 is
    component conv1d_stage_W_PJfS5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfS5_rom_U :  component conv1d_stage_W_PJfS5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


