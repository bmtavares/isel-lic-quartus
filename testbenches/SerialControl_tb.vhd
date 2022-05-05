library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SerialControl_tb is
end SerialControl_tb;

architecture behavioural of SerialControl_tb is

component SerialControl is
	port(
		clk, notSS, accept, pFlag, dFlag, RXerror : in STD_LOGIC;
		wr, init, DXval, busy : out STD_LOGIC
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal CLK_tb, notSS_tb, accept_tb, pFlag_tb, dFlag_tb, RXerror_tb, wr_tb, init_tb, DXval_tb, busy_tb : std_logic;

begin

--Unit Under Test
UUT: SerialControl
	port map(
		clk => CLK_tb, 
		notSS => notSS_tb,
		accept => accept_tb, 
		pFlag => pFlag_tb, 
		dFlag => dFlag_tb, 
		RXerror => RXerror_tb, 
		wr => wr_tb, 
		init => init_tb, 
		DXval => DXval_tb, 
		busy => busy_tb
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
	
	--
	notSS_tb <= '0';
	accept_tb <= '0';
	pFlag_tb <= '0';
	dFlag_tb <= '0';
	RXerror_tb <= '0';
	wait for CLKPeriod*20;
	--wr a 1
	notSS_tb <= '0';
	accept_tb <= '0';
	pFlag_tb <= '0';
	dFlag_tb <= '1';
	RXerror_tb <= '0';
	wait for CLKPeriod;
	--outputs a zero
	notSS_tb <= '0';
	accept_tb <= '0';
	pFlag_tb <= '1';
	dFlag_tb <= '0';
	RXerror_tb <= '0';
	wait for CLKPeriod;
	--dx val busy
	notSS_tb <= '0';
	accept_tb <= '0';
	pFlag_tb <= '0';
	dFlag_tb <= '0';
	RXerror_tb <= '0';
	wait for CLKPeriod;
	
	notSS_tb <= '0';
	accept_tb <= '1';
	pFlag_tb <= '0';
	dFlag_tb <= '0';
	RXerror_tb <= '0';
	wait for CLKPeriod;
	--busy a 1
	
	notSS_tb <= '1';
	accept_tb <= '0';
	pFlag_tb <= '0';
	dFlag_tb <= '0';
	RXerror_tb <= '0';
	wait for CLKPeriod;
	
	
	
	
	
	wait;
end process;
end;