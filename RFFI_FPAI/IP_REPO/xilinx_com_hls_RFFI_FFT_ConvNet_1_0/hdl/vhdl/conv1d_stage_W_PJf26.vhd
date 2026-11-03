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

entity conv1d_stage_W_PJf26_rom is 
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


architecture rtl of conv1d_stage_W_PJf26_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01101010", 1 => "00100101", 2 => "11100111", 3 => "00001101", 
    4 => "11111001", 5 => "00111101", 6 => "00001110", 7 => "10010110", 
    8 => "11110010", 9 => "01101101", 10 => "00111000", 11 => "11010101", 
    12 => "00001011", 13 => "11011011", 14 => "01010011", 15 => "00001001", 
    16 => "00011110", 17 => "11011011", 18 => "10111011", 19 => "11110011", 
    20 => "10101111", 21 => "10111000", 22 => "11011010", 23 => "00010011", 
    24 => "11011000", 25 => "00110011", 26 => "11011110", 27 => "11101001", 
    28 => "11011110", 29 => "11111101", 30 => "00100110", 31 => "11110000", 
    32 => "01110111", 33 => "00110100", 34 => "00010111", 35 => "00011100", 
    36 => "00100000", 37 => "11001110", 38 => "11010101", 39 => "11100110", 
    40 => "10000101", 41 => "11011010", 42 => "11011101", 43 => "11101110", 
    44 => "10101101", 45 => "11110110", 46 => "11100111", 47 => "11110110", 
    48 => "11010111", 49 => "00100011", 50 => "00011110", 51 => "00000101", 
    52 => "11011101", 53 => "00011111", 54 => "11111101", 55 => "01000001", 
    56 => "00100101", 57 => "11101000", 58 => "10111000", 59 => "00101001", 
    60 => "00100010", 61 => "00010100", 62 => "11010100", 63 => "00010100", 
    64 => "10110111", 65 => "00100010", 66 => "01001011", 67 => "11001011", 
    68 => "00111110", 69 => "01000000", 70 => "00101110", 71 => "11100001", 
    72 => "00001111", 73 => "11110001", 74 => "10111111", 75 => "00101110", 
    76 => "00011111", 77 => "00001110", 78 => "00011001", 79 => "00101100", 
    80 => "00000011", 81 => "11011001", 82 => "10101001", 83 => "00111000", 
    84 => "11111001", 85 => "10010111", 86 to 87=> "00011111", 88 => "00100101", 
    89 => "00100001", 90 => "00000100", 91 => "11101101", 92 => "00010010", 
    93 => "11111101", 94 => "00100111", 95 => "00001000" );

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

entity conv1d_stage_W_PJf26 is
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

architecture arch of conv1d_stage_W_PJf26 is
    component conv1d_stage_W_PJf26_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf26_rom_U :  component conv1d_stage_W_PJf26_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


