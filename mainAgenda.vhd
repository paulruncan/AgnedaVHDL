----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2024 08:41:48 PM
-- Design Name: 
-- Module Name: mainAgenda - Behavioral
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

entity mainAgenda is
Port (
    clk : in std_logic;
    btnC : in std_logic;
    btnL : in std_logic;
    btnR : in std_logic;
    btnU : in std_logic;
    btnD : in std_logic;
    sw : in std_logic_vector(15 downto 0);
    led: out std_logic_vector(15 downto 0);
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
 );
end mainAgenda;

architecture Behavioral of mainAgenda is

component Debouncer is
  Port (
     btn : in std_logic_vector(4 downto 0);
     clk : in std_logic;
     enable: out std_logic_vector(4 downto 0)
         );
end component;


component SSDInterfaceDay is
Port (
    clk: in std_logic;
    digit: in std_logic_vector(15 downto 0);
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
     );
end component;
component SSDInterface is
Port (
    clk: in std_logic;
    digit: in std_logic_vector(15 downto 0);
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
     );
end component;


component ZellerAlgo is
Port (
    day : in std_logic_vector(7 downto 0);
    month : in std_logic_vector(7 downto 0);
    year : in std_logic_vector(15 downto 0);
    letters : out std_logic_vector(15 downto 0)
 );
end component;
component counterDays is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(7 downto 0)
 );
end component;

component counterMonths is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(7 downto 0)
 );
end component;


component counterYears is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(15 downto 0)
 );

end component;

component UC is
Port (
    clk : in std_logic;
    ok: in std_logic;
    reset: in std_logic;
    countDaysEn, countMonthsEn, countYearsEn, countOraAlarmaEn, countMinuteAlarmaEn, countOraEn, resetTot, countMinuteEn, countMinuteAutoEn, set  : out std_logic
 );
end component;


component counterOra is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(7 downto 0)
  );
end component;

component counterMinute is
Port (
    clk: in std_logic;
    enable: in std_logic;
    enableComponent: in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(7 downto 0)
  );
end component;

component counterMinuteAuto is
Port (
    clk: in std_logic;
    dataIn : std_logic_vector(15 downto 0);
    enableComponent: in std_logic;
    set : in std_logic;
    reset, resetTot: in std_logic;
    dataOut: out std_logic_vector(15 downto 0)
  );
end component;

component freqDiv is
  Port (
    clk : in std_logic;
    clk_out : out std_logic
  
   );
end component;

component TemperatureROM is
Port (
 addr: in std_logic_vector(7 downto 0);
 data: out std_logic_vector(15 downto 0)
 );
end component;


component AlarmTrigger is
Port (
    alarmTime : in std_logic_vector(15 downto 0);
    actualTime: in std_logic_vector(15 downto 0);
    turnOffButton: in std_logic;
    alarmLed: out std_logic
 );
end component;
signal debouncedButtons: std_logic_vector(4 downto 0);
signal counterDaysOut: std_logic_vector(7 downto 0);
signal counterMonthsOut: std_logic_vector(7 downto 0);
signal counterOraOut: std_logic_vector(7 downto 0) := x"00";
signal counterOraAlarmaOut: std_logic_vector(7 downto 0) := x"00";
signal counterMinuteOut: std_logic_vector(7 downto 0) := x"00";
signal counterMinuteAlarmaOut: std_logic_vector(7 downto 0) := x"00";
signal outTimp: std_logic_vector(15 downto 0) := x"0000";
signal counterYearsOut: std_logic_vector(15 downto 0);
signal digits : std_logic_vector(15 downto 0) := (others => '0');
signal enableCounterDays,enableCounterMonths,enableCounterYears, enableCounterOra, enableCounterMinute,enableCounterOraAlarma, enableCounterMinuteAlarma, enableCounterMinuteAuto, set: std_logic;
signal totalReset : std_logic;
signal temperatureROMOut: std_logic_vector(15 downto 0);
signal dataIn : std_logic_vector(15 downto 0) := x"0000";
signal clkDiv : std_logic := '0';
signal s_alarmTime: std_logic_vector(15 downto 0) := x"0000";
signal s_actualTime: std_logic_vector(15 downto 0) := x"0000";
signal s_letters: std_logic_vector(15 downto 0) := x"0000";
signal s_an_normal, s_an_day : std_logic_vector(3 downto 0);
signal s_cat_normal, s_cat_day : std_logic_vector(6 downto 0);
signal s_whichSSD : std_logic := '0';
begin
Debouncer1: Debouncer port map (btn(0) => btnC, btn(1) => btnU, btn(2) => btnL, btn(3) => btnR, btn(4) => btnD, clk => clk, enable => debouncedButtons);
UC1: UC port map (clk => clk, ok => debouncedButtons(0), reset => debouncedButtons(3), countDaysEn => enableCounterDays, countMonthsEn=>enableCounterMonths, countYearsEn=> enableCounterYears, resetTot => totalReset, countOraEn => enableCounterOra, countMinuteEn => enableCounterMinute, countMinuteAutoEn => enableCounterMinuteAuto, set => set,
countOraAlarmaEn => enableCounterOraAlarma, countMinuteAlarmaEn => enableCounterMinuteAlarma);
CounterDays1: counterDays port map(clk => clk, enable => debouncedButtons(2),enableComponent=>enableCounterDays ,reset => debouncedButtons(1), dataOut => counterDaysOut, resetTot => totalReset);
CounterMonths1: counterMonths port map(clk => clk, enable => debouncedButtons(2),enableComponent=>enableCounterMonths , reset => debouncedButtons(1), dataOut => counterMonthsOut, resetTot => totalReset);
CounterYears1: counterYears port map(clk => clk, enable => debouncedButtons(2),enableComponent=>enableCounterYears , reset => debouncedButtons(1), dataOut => counterYearsOut, resetTot => totalReset);
CounterOra1: counterOra port map(clk=>clk, enable => debouncedButtons(2), enableComponent => enableCounterOra, reset => debouncedButtons(1), dataOut => counterOraOut, resetTot => totalReset);
CounterMinute1: counterMinute port map(clk=>clk, enable => debouncedButtons(2), enableComponent => enableCounterMinute, reset => debouncedButtons(1), dataOut => counterMinuteOut, resetTot => totalReset);
CounterMinuteAuto1: counterMinuteAuto port map(clk => clkDiv, dataIn => dataIn, enableComponent => enableCounterMinuteAuto, set => set, reset => debouncedButtons(1), resetTot => totalReset, dataOut => outTimp);
CounterOraAlarma1: counterOra port map(clk => clk, enable => debouncedButtons(2), enableComponent => enableCounterOraAlarma, reset => debouncedButtons(1), dataOut => counterOraAlarmaOut, resetTot => totalReset);
CounterMinuteAlarma1: counterMinute port map(clk => clk, enable => debouncedButtons(2), enableComponent => enableCounterMinuteAlarma, reset => debouncedButtons(1), dataOut => counterMinuteAlarmaOut, resetTot => totalReset);
freqDiv1 : freqDiv port map(clk => clk, clk_out => clkDiv);
dataIn <= counterOraOut & counterMinuteOut;
s_alarmTime <= counterOraAlarmaOut & counterMinuteAlarmaOut;
s_actualTime <= outTimp;
ZellerAlgo1: ZellerAlgo port map (day => counterDaysOut, month=>counterMonthsOut, year=>counterYearsOut, letters => s_letters);
TemperatureROM1: TemperatureROM port map(addr => counterMonthsOut, data => temperatureROMOut);
AlarmTrigger1: AlarmTrigger port map(alarmTime => s_alarmTime, actualTime => s_actualTime, turnOffButton => debouncedButtons(4), alarmLed=>led(0)); 
SSDInterface1: SSDInterface port map(clk => clk, digit => digits, cat=>s_cat_normal, an=>s_an_normal );
SSDInterfaceDay1: SSDInterfaceDay port map (clk => clk, digit => s_letters, cat=>s_cat_day, an=>s_an_day);
an <= s_an_normal when s_whichSSD = '0' else s_an_day;
cat <= s_cat_normal when s_whichSSD = '0' else s_cat_day;
process(sw(2 downto 0))
begin
    case sw(2 downto 0) is
        when "000" => 
            s_whichSSD <= '0';
            digits <= x"FF" & counterDaysOut;
        when "001" =>
            s_whichSSD <= '0';
            digits <= x"FF" & counterMonthsOut;
        when "010" => 
            s_whichSSD <= '0';
            digits <= counterYearsOut;
        when "011" => 
            s_whichSSD <= '0';
            digits <= temperatureROMOut;
        when "100" => 
            s_whichSSD <= '0';
            digits <= counterOraOut & counterMinuteOut;
        when "101" => 
            s_whichSSD <= '0';
            digits <= outTimp;
        when "110" => 
            s_whichSSD <= '0';
            digits <= counterOraAlarmaOut & counterMinuteAlarmaOut;
        when "111" => 
            s_whichSSD <= '1';
            digits <= s_letters;
        when others => digits <= x"FFFF";
    end case;
end process;
end Behavioral;
