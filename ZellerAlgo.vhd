----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 12:13:53 AM
-- Design Name: 
-- Module Name: ZellerAlgo - Behavioral
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

entity ZellerAlgo is
Port (
    day : in std_logic_vector(7 downto 0);
    month : in std_logic_vector(7 downto 0);
    year : in std_logic_vector(15 downto 0);
    letters : out std_logic_vector(15 downto 0)
 );
end ZellerAlgo;

architecture Behavioral of ZellerAlgo is
signal s_letters : std_logic_vector(15 downto 0);
begin
process(day, month, year)
variable v_day,v_month,v_year: integer := 0;
variable q,m,k,j,h: integer := 0;
begin
    v_day := conv_integer(day(3 downto 0)) + conv_integer(day(7 downto 4))*10;
    v_month := conv_integer(month(3 downto 0)) + conv_integer(month(7 downto 4))*10;
    v_year := conv_integer(year(3 downto 0)) + conv_integer(year(7 downto 4))*10 + conv_integer(year(11 downto 8))*100 + conv_integer(year(15 downto 12))*1000;
    if v_month = 1 then
        v_month := 13;
        v_year := v_year -1;
    end if;
    if v_month = 2 then
        v_month := 14;
        v_year := v_year -1;
    end if;
    q := v_day;
    m := v_month;
    k := v_year mod 100;
    j := v_year / 100;
    h := q + 13 * (m + 1) / 5 + k + k / 4 + j / 4 + 5 * j;
    h := h mod 7;
    case h is
        when 0 => s_letters <= b"1111_1100_0101_0100";
        when 1 => s_letters <= b"1111_1101_0010_0100";
        when 2 => s_letters <= b"1111_0001_0010_0011";
        when 3 => s_letters <= b"1111_0100_0101_0110";
        when 4 => s_letters <= b"1111_0100_0111_1000";
        when 5 => s_letters <= b"1111_1001_1010_0111";
        when 6 => s_letters <= b"1111_1011_0111_0011";
        when others => s_letters <= b"1111_1111_1111_1111";
    end case;
end process;
letters <= s_letters;
end Behavioral;
