library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity freqDiv is
  Port (
    clk : in std_logic;
    clk_out : out std_logic
  
   );
end freqDiv;

architecture Behavioral of freqDiv is
signal counter : std_logic_vector(28 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            counter <= counter + 1;
            if(counter(28 downto 27) = b"11") then
                clk_out <= '1';
            else 
                clk_out <= '0';
            end if;
        end if;
    end process;

end Behavioral;
