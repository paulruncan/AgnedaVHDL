----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2024 10:06:38 PM
-- Design Name: 
-- Module Name: counterYears - Behavioral
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

entity counterYears is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(15 downto 0)
 );

end counterYears;

architecture Behavioral of counterYears is
signal s_dataOut: std_logic_vector(15 downto 0) := x"2000";
begin

process(clk, reset, resetTot)
begin
if resetTot = '1' then
    s_dataOut <= x"2000";
elsif enableComponent = '1' then
    if reset = '1' then
        s_dataOut <= x"2000";
    elsif rising_edge(clk) then
        if enable = '1' then
            s_dataOut<=s_dataOut+1;
            if(s_dataOut(3 downto 0) = b"1001") then
                if(s_dataOut(7 downto 4) = b"1001") then
                    s_dataOut(11 downto 8) <= s_dataOut(11 downto 8) +1;
                    s_dataOut(7 downto 4) <= x"0";
                else 
                    s_dataOut(7 downto 4) <= s_dataOut(7 downto 4) + 1;
                end if;
                s_dataOut(3 downto 0) <= x"0";
            end if;
            if(s_dataOut = x"2125") then
                s_dataOut <= x"2000";
            end if;
        end if;
    end if;
end if;
end process;
dataOut<=s_dataOut;


end Behavioral;
