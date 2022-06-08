LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyDecodel_tb is
end KeyDecodel_tb;

architecture behavioural of KeyDecodel_tb is

component KeyDecode is
port(
	clk, reset : in std_logic;
	KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
	KEYPAD_COL : OUT STD_LOGIC_vector(3 downto 0);
	kVal : out STD_LOGIC;
	kAck : in std_logic;
	K: out std_logic_vector(3 downto 0)
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal s_KEYPAD_LIN, s_KEYPAD_COL, s_K :STD_LOGIC_VECTOR(3 downto 0);
signal CLK_tb, s_kVal,s_kAck, s_reset : STD_LOGIC;


begin
s_reset <= '0';
--Unit Under Test
UUT: KeyDecode
	PORT MAP(
		clk    =>CLK_tb,		
		reset => s_reset,		
		KEYPAD_LIN => s_KEYPAD_LIN,		
		KEYPAD_COL => s_KEYPAD_COL,		
		kVal => s_kVal,		
		kAck => s_kAck,
		K =>s_K
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
	s_kAck <= '0';
	
	s_KEYPAD_LIN <= "0100";
	
	wait for CLKPeriod;
	
	wait for CLKPeriod;

	wait for CLKPeriod;

	wait for CLKPeriod;
	s_kAck <= '1';
	wait for CLKPeriod;
	
	wait for CLKPeriod;
	
	wait for CLKPeriod;
	s_kAck <= '1';
	wait for CLKPeriod;
s_kAck <= '0';

		wait for CLKPeriod;
	
	wait for CLKPeriod;	
	wait for CLKPeriod;
	
	wait for CLKPeriod;
	
	-- nova mensagem
	

	
	wait;
end process;
end;