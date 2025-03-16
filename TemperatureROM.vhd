----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/26/2024 01:45:54 AM
-- Design Name: 
-- Module Name: TemperatureROM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TemperatureROM is
Port (
 addr: in std_logic_vector(7 downto 0);
 data: out std_logic_vector(15 downto 0)
 );
end TemperatureROM;

architecture Behavioral of TemperatureROM is
type MEM is array(0 to 12) of std_logic_vector(15 downto 0);
signal RomMEM: MEM:=(x"FFFF", x"0001", x"0003", x"0010", x"0015", x"0018", x"0022", x"0026", x"0030", x"0027",x"0019",x"0013",x"0002");
signal monthValue : integer;
begin
monthValue <= conv_integer(addr(7 downto 4))*10+conv_integer(addr(3 downto 0));
data<= RomMEM(monthValue);
end Behavioral;
