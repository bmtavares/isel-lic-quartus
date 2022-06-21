LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyTransmitter_tb is
end KeyTransmitter_tb;

architecture behavioural of KeyTransmitter_tb is

component KeyTransmitter is
	PORT(
		clk,DAV,txClk,reset : in STD_LOGIC;
		D : in STD_LOGIC_VECTOR(3 downto 0);
		DAC,txD : out STD_LOGIC
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal s_D :STD_LOGIC_VECTOR(3 downto 0);
signal CLK_tb, s_txClk, s_DAV,s_DAC, s_txD ,s_reset: STD_LOGIC;


begin
s_reset <= '0';
--Unit Under Test
UUT: KeyTransmitter
	PORT MAP(
		clk    =>CLK_tb,
		txD => s_txD,
		DAC => s_DAC,
		
		reset => s_reset,
		txClk => s_txClk,	
		DAV => s_DAV	,	
		D => s_D
	);
				
CLK_gen : process
begin
	CLK_tb <= '0';
	wait for CLKPeriod/2;
	CLK_tb <= '1';
	wait for CLKPeriod/2;
end process;

stimulus : process
begin
	--reset
	s_D <= "0110";
	s_DAV <= '1';
	wait for CLKPeriod;
	
	s_txClk <= '1';
	wait for CLKPeriod;
	s_DAV <= '0';
	s_txClk <= '0';
	wait for CLKPeriod;
	s_txClk <= '1';
	wait for CLKPeriod;
	s_txClk <= '0';
	wait for CLKPeriod;
	s_txClk <= '1';
	wait for CLKPeriod;
	-- envio ok de 0110
	
	
	-- nova mensagem
	

	
	wait;
end process;
end;