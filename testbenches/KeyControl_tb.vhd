LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyControl_tb is
end KeyControl_tb;

architecture behavioural of KeyControl_tb is

component KeyControl is
	PORT(
		clk,kAck,kPress,reset : in STD_LOGIC;
		kVal,kScan : out STD_LOGIC
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal s_D :STD_LOGIC_VECTOR(3 downto 0);
signal CLK_tb, s_kAck, s_kPress,s_kVal, s_kScan ,s_reset: STD_LOGIC;


begin
s_reset <= '0';
--Unit Under Test
UUT: KeyControl
	PORT MAP(
		clk    =>CLK_tb,		
		reset => s_reset,		
		kAck => s_kAck,		
		kPress => s_kPress,		
		kVal => s_kVal,		
		kScan => s_kScan	
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