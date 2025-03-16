----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/26/2024 04:49:54 PM
-- Design Name: 
-- Module Name: AlarmTrigger - Behavioral
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


entity AlarmTrigger is
Port (
    alarmTime : in std_logic_vector(15 downto 0);
    actualTime: in std_logic_vector(15 downto 0);
    turnOffButton: in std_logic;
    alarmLed: out std_logic
 );
end AlarmTrigger;

architecture Behavioral of AlarmTrigger is
signal s_alarm : std_logic := '0';
begin
process(actualTime,turnOffButton)
begin
    if (actualTime = alarmTime and actualTime>x"0000") then
        s_alarm <= '1';
    elsif turnOffButton = '1' then
        s_alarm <= '0';
    end if;
end process;
alarmLed<=s_alarm;
end Behavioral;
