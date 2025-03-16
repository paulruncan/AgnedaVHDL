----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 12:01:08 AM
-- Design Name: 
-- Module Name: SSDInterfaceDay - Behavioral
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

entity SSDInterfaceDay is
Port (
    clk: in std_logic;
    digit: in std_logic_vector(15 downto 0);
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
     );
end SSDInterfaceDay;

architecture Behavioral of SSDInterfaceDay is

signal cntOut: std_logic_vector(15 downto 0):=x"0000";
signal muxCat: std_logic_vector(3 downto 0);
signal muxAn: std_logic_vector(3 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            cntOut<= cntOut+1;
        end if;
    end process;
    
    process(cntOut(15 downto 14),digit(15 downto 0))
    begin
        case cntOut(15 downto 14) is
            when "00" => muxCat <= digit(3 downto 0);
            when "01" => muxCat <= digit(7 downto 4);
            when "10" => muxCat <= digit(11 downto 8);
            when "11" => muxCat <= digit(15 downto 12);
            --when "100" => muxCat <= digit(19 downto 16);
            --when "101" => muxCat <= digit(23 downto 20);
            --when "110" => muxCat <= digit(27 downto 24);
            --when "111" => muxCat <= digit(31 downto 28);
            when others => muxCat <= digit(3 downto 0);
         end case;
    end process;
    
    process(cntOut(15 downto 14))
    begin
        case cntOut(15 downto 14) is
            when "00" => muxAn <= "1110";
            when "01" => muxAn <= "1101";
            when "10" => muxAn <= "1011";
            when "11" => muxAn <= "0111";
            --when "100" => muxAn <= "11101111";
            --when "101" => muxAn <= "11011111";
            --when "110" => muxAn <= "10111111";
            --when "111" => muxAn <= "01111111";
            --when others => muxAn <= "01111111";
        end case;
    end process;
    an<=muxAn;
    
    with muxCat SELect
   cat<= "1000111" when "0001",   --L
         "1100011" when "0010",   --U
         "0101011" when "0011",   --N
         "0001001" when "0100",   --M
         "0001000" when "0101",   --A
         "0101111" when "0110",   --R
         "1111001" when "0111",   --I
         "0000110" when "1000",   --E
         "1110001" when "1001",   --J
         "0100011" when "1010",   --O
         "1000001" when "1011",   --V
         "0010010" when "1100",   --S
         "0100001" when "1101",   --D
         --"0000110" when "1110",   --E
         --"0001110" when "1111",   --F
         "1111111" when others;   --0



end Behavioral;
