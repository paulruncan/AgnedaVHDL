library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counterMinute is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(7 downto 0)
  );
end counterMinute;

architecture Behavioral of counterMinute is
signal s_dataOut: std_logic_vector(7 downto 0) := "00000000";
begin

process(clk, reset, resetTot)
begin
if resetTot = '1' then
    s_dataOut <= "00000000";
elsif enableComponent = '1' then
    if reset = '1' then
        s_dataOut <= "00000000";
    elsif rising_edge(clk) then
        if enable = '1' then
            s_dataOut<=s_dataOut+1;
            if(s_dataOut(3 downto 0) = b"1001") then
                s_dataOut(7 downto 4) <= s_dataOut(7 downto 4) + 1;
                s_dataOut(3 downto 0) <= x"0";
            end if;
            if(s_dataOut = b"01011001") then
                s_dataOut <= x"00";
            end if;
        end if;
    end if;
end if;    
end process;
dataOut<=s_dataOut;



end Behavioral;
