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

entity conv1d_stage_W_PJga8_rom is 
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


architecture rtl of conv1d_stage_W_PJga8_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000101", 1 => "10101111", 2 => "11011100", 3 => "11101111", 
    4 => "11111111", 5 => "00011110", 6 => "11100011", 7 => "00010010", 
    8 => "00011110", 9 => "11000111", 10 => "00000001", 11 => "00110000", 
    12 => "11110010", 13 => "10111111", 14 => "11100101", 15 => "11010001", 
    16 => "11101010", 17 => "00010111", 18 => "10101000", 19 => "00011100", 
    20 => "00010110", 21 => "00000001", 22 => "00100001", 23 => "10110100", 
    24 => "10001110", 25 => "11111101", 26 => "00010001", 27 => "00100010", 
    28 => "00001001", 29 => "11101101", 30 => "00111111", 31 => "00111100", 
    32 => "11101101", 33 => "00010000", 34 => "00010001", 35 => "11101010", 
    36 to 37=> "00100110", 38 => "01011111", 39 => "01000011", 40 => "11110000", 
    41 => "01000001", 42 => "00101110", 43 => "00000100", 44 => "00110111", 
    45 => "11001001", 46 => "00010011", 47 => "01000001", 48 => "00111100", 
    49 => "11100100", 50 => "11110101", 51 => "11110110", 52 => "00110010", 
    53 => "11111100", 54 => "00010100", 55 => "00001100", 56 => "11001011", 
    57 => "01000011", 58 => "11000011", 59 => "00010000", 60 => "01000110", 
    61 => "11000111", 62 => "00101101", 63 => "11011100", 64 => "01111001", 
    65 => "11110001", 66 => "11101001", 67 => "11001111", 68 => "00101101", 
    69 => "11101010", 70 => "00001001", 71 => "01000011", 72 => "11000101", 
    73 => "00010111", 74 => "00101101", 75 => "00000011", 76 => "00010111", 
    77 => "00010010", 78 => "00111001", 79 => "01011011", 80 => "00110000", 
    81 => "00110001", 82 => "00011111", 83 => "00110101", 84 => "11101011", 
    85 => "01001100", 86 => "00001010", 87 => "11110101", 88 => "11001101", 
    89 => "01110011", 90 => "00011111", 91 => "11001011", 92 => "00011111", 
    93 => "00000101", 94 => "00000001", 95 => "11111111" );

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

entity conv1d_stage_W_PJga8 is
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

architecture arch of conv1d_stage_W_PJga8 is
    component conv1d_stage_W_PJga8_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJga8_rom_U :  component conv1d_stage_W_PJga8_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


