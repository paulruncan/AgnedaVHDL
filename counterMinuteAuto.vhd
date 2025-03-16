library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counterMinuteAuto is
Port (
    clk: in std_logic;
    dataIn : std_logic_vector(15 downto 0);
    enableComponent: in std_logic;
    set : in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(15 downto 0)
  );
end counterMinuteAuto;

architecture Behavioral of counterMinuteAuto is
signal s_dataOut: std_logic_vector(15 downto 0) := x"0000";
begin

process(clk, reset, resetTot, set)
begin
if resetTot = '1' then
    s_dataOut <= x"0000";
elsif enableComponent = '1' then
    if reset = '1' then
        s_dataOut <= x"0000";
    elsif(set = '1') then
        s_dataOut <= dataIn;
    elsif rising_edge(clk) then
        s_dataOut<=s_dataOut+1;
        if(s_dataOut(3 downto 0) = b"1001") then
            s_dataOut(7 downto 4) <= s_dataOut(7 downto 4) + 1;
            s_dataOut(3 downto 0) <= x"0";
        end if;
        if(s_dataOut(7 downto 0) = b"01011001") then
            s_dataOut(7 downto 0) <= x"00";
            s_dataOut(11 downto 8) <= s_dataOut(11 downto 8) + 1;
            if(s_dataOut(11 downto 8) = b"1001") then
                s_dataOut(11 downto 8) <= x"0";
                if(s_dataOut(15 downto 8) = x"23") then
                    s_dataOut(15 downto 8) <= x"00";
                else
                    s_dataOut(15 downto 12) <= s_dataOut(15 downto 12) + 1;
                end if;
            end if;
        end if;
    end if;
end if;    
end process;
dataOut<=s_dataOut;



end Behavioral;
