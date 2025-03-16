----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/26/2024 12:37:40 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
Port (
    clk : in std_logic;
    ok: in std_logic;
    reset: in std_logic;
    countDaysEn, countMonthsEn, countYearsEn,countOraAlarmaEn,countMinuteAlarmaEn, countOraEn, resetTot, countMinuteEn, countMinuteAutoEn, set : out std_logic
 );
end UC;

architecture Behavioral of UC is
type state_t is (insertDay, insertMonth, insertYear,insertOraAlarma, insertMinuteAlarma,insertOra, insertMinute, timeState, idleState);
signal state, nxstate: state_t;

begin
update_state:  process(clk,reset)
begin
    if reset = '1' then
        state<=idleState;
    elsif rising_edge(clk) then
        state<=nxstate;
    end if;
end process update_state;

transitions: process(state,ok)
begin
    countDaysEn<='0'; countMonthsEn<='0'; countYearsEn<='0'; resetTot <= '0'; countOraEn <='0'; countMinuteEn <= '0'; set <= '0'; countMinuteAutoEn <= '0'; countOraAlarmaEn <= '0';
    countMinuteAlarmaEn<='0';
    
    case state is
        when idleState => 
                            resetTot <= '1';
                            if ok = '1' then
                            nxstate <= insertDay;
                          else nxstate <= idleState;
                          end if;
        when insertDay => countDaysEn <= '1';
                          if ok = '1' then
                            nxstate <= insertMonth;
                          else nxstate <= insertDay;
                          end if;
        when insertMonth => countMonthsEn <= '1';
                            if ok = '1' then
                                nxstate <= insertYear;
                            else nxstate <= insertMonth;
                            end if;
        when insertYear => countYearsEn <= '1';
                           if ok = '1' then
                                nxstate <= insertOraAlarma;
                           else nxstate <= insertYear;
                           end if;
        
        when insertOraAlarma => countOraAlarmaEn <= '1';
                           if ok = '1' then
                                nxstate <= insertMinuteAlarma;
                           else nxstate <= insertOraAlarma;
                           end if;
                           
        when insertMinuteAlarma => countMinuteAlarmaEn <= '1';
                           if ok = '1' then
                                nxstate <= insertOra;
                           else nxstate <= insertMinuteAlarma;
                           end if;
        when insertOra => countOraEn <= '1';
                           if ok = '1' then
                                nxstate <= insertMinute;
                           else nxstate <= insertOra;
                           end if;
       when insertMinute => countMinuteEn <= '1';
                           if ok = '1' then
                                nxstate <= timeState;
                                countMinuteAutoEn <= '1';
                                set <= '1';
                           else nxstate <= insertMinute;
                           end if;
                           
        when timeState => countMinuteAutoEn <= '1';
                          if(ok = '1') then
                            nxstate <= idleState;
                          else
                            nxstate <= timeState;
                          end if;
        when others => null;
     end case;   
end process transitions;

end Behavioral;
