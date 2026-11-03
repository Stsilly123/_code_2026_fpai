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

entity conv1d_stage_W_PJgpb_rom is 
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


architecture rtl of conv1d_stage_W_PJgpb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110100", 1 => "00011000", 2 => "00100111", 3 => "11111111", 
    4 => "00001001", 5 => "11011010", 6 => "10101100", 7 => "10110101", 
    8 => "00000011", 9 => "11001101", 10 => "11101100", 11 => "10011111", 
    12 => "11100100", 13 => "00101000", 14 => "11110011", 15 => "00011000", 
    16 => "11101011", 17 => "10110101", 18 => "01011110", 19 => "11100000", 
    20 => "11110110", 21 => "00000110", 22 => "00000000", 23 => "11101010", 
    24 => "11111011", 25 => "11101000", 26 => "00101110", 27 => "00110100", 
    28 => "01000101", 29 => "00110101", 30 => "00111011", 31 => "11111111", 
    32 => "11100011", 33 => "00000010", 34 => "01000001", 35 => "00111010", 
    36 => "00110010", 37 => "11110000", 38 => "11011011", 39 => "01011110", 
    40 => "11000111", 41 => "00010110", 42 => "11111000", 43 => "00010110", 
    44 => "11101000", 45 => "11110100", 46 => "01010111", 47 => "00100101", 
    48 => "11101011", 49 => "00110011", 50 => "00000110", 51 => "11111001", 
    52 => "11000011", 53 => "00011100", 54 => "00100001", 55 => "00111111", 
    56 => "11101101", 57 => "00110001", 58 => "01001001", 59 => "11101010", 
    60 => "11000100", 61 => "11111111", 62 => "01011000", 63 => "00110110", 
    64 to 65=> "11010010", 66 => "11111101", 67 => "00011100", 68 => "11100000", 
    69 => "11100011", 70 => "00011101", 71 => "00100000", 72 => "11100010", 
    73 => "11111100", 74 => "11100010", 75 => "11011010", 76 => "00000011", 
    77 => "00010100", 78 => "10010111", 79 => "11011000", 80 => "00101011", 
    81 => "00101110", 82 => "10000001", 83 => "00000000", 84 => "11110110", 
    85 => "11100001", 86 => "11101011", 87 => "11101010", 88 => "11100110", 
    89 => "11101000", 90 => "11010001", 91 => "11010110", 92 => "10111000", 
    93 => "00001101", 94 => "00001000", 95 => "11011011" );

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

entity conv1d_stage_W_PJgpb is
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

architecture arch of conv1d_stage_W_PJgpb is
    component conv1d_stage_W_PJgpb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgpb_rom_U :  component conv1d_stage_W_PJgpb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


