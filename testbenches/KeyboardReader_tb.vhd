LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyboardReader_tb is
end KeyboardReader_tb;

architecture behavioural of KeyboardReader_tb is

component KeyboardReader is
port(
	clk, reset : in std_logic;
	
			KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
		KEYPAD_COL : OUT STD_LOGIC_vector(3 downto 0);
	TXd ,DBUG: out std_logic;
	TXclk : in std_logic
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal s_KEYPAD_LIN, s_KEYPAD_COL :STD_LOGIC_VECTOR(3 downto 0);
signal CLK_tb, s_TXd, s_TXclk, s_reset : STD_LOGIC;


begin
s_reset <= '0';
--Unit Under Test
UUT: KeyboardReader
	PORT MAP(
		clk    =>CLK_tb,		
		reset => s_reset,		
			KEYPAD_LIN => s_KEYPAD_LIN,
			KEYPAD_COL => s_KEYPAD_COL,
			TXd => s_TXd,
			TXclk => s_TXclk
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
	
	s_TXclk <= '0';
	
	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	wait for CLKPeriod;
	s_KEYPAD_LIN <= "0100";
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
		wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
		wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
		wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '1';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	s_TXclk <= '0';
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;	
	wait for CLKPeriod;

	
		
		
	
	-- nova mensagem
	

	
	wait;
end process;
end;