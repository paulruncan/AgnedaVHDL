library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity Debouncer is
  Port (
     btn : in std_logic_vector(4 downto 0);
     clk : in std_logic;
     enable: out std_logic_vector(4 downto 0)
         );
end Debouncer;

architecture Behavioral of Debouncer is
signal cntOut : std_logic_vector(15 downto 0):=x"0000";
signal reg1Out,reg2Out,reg3Out: std_logic_vector(4 downto 0);
begin
process(clk)
begin
    if rising_edge(clk) then
        cntOut <= cntOut + 1;
    end if;    
end process;

process(clk)
begin
    if rising_edge(clk) then
        if cntOut = x"1FFF" then
            reg1Out <= btn;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        reg2Out<=reg1Out;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        reg3Out <= reg2Out;
    end if;
end process;

enable <= (not reg3Out) and reg2Out;
end Behavioral;