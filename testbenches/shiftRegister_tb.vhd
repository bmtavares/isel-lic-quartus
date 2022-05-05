LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity ShiftRegister_tb is
end ShiftRegister_tb;

architecture behavioural of ShiftRegister_tb is

component ShiftRegister is
	port(Sin, CLK, enable: in STD_LOGIC;
		  D : out STD_LOGIC_VECTOR(9 downto 0));
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal Sin_tb, CLK_tb, enable_tb : std_logic;
signal D_tb : std_logic_vector(9 downto 0);

begin

--Unit Under Test
UUT: ShiftRegister
	port map(
		Sin => Sin_tb, 
		CLK => CLK_tb, 
		enable => enable_tb, 
		D => D_tb);
				
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
	Sin_tb <= '0';
	enable_tb <= '0';
	wait for CLKPeriod;
	
	Sin_tb <= '1';
	wait for CLKPeriod*2;
	
	Sin_tb <= '0';
	enable_tb <= '1';
	wait for CLKPeriod*4;

	Sin_tb <= '1';
	enable_tb <= '1';
	wait for CLKPeriod*4;

	Sin_tb <= '1';
	enable_tb <= '0';
	wait for CLKPeriod*4;
	
	Sin_tb <= '1';
	enable_tb <= '1';
	wait for CLKPeriod*4;

	Sin_tb <= '0';
	enable_tb <= '1';
	wait for CLKPeriod*4;

	Sin_tb <= '0';
	enable_tb <= '0';
	wait for CLKPeriod*4;
	
	wait;
end process;
end;