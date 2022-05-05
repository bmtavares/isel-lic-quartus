LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY Counter_tb IS
END Counter_tb;

ARCHITECTURE behavior OF Counter_tb IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT Counter IS
 Port( 
 clr,	clk			: in std_logic;
out_D			: out  std_logic_vector(3 downto 0)
		 );
END COMPONENT;

constant CLKPeriod : time := 10 ns;
--Inputs
SIGNAL clr, clk :  std_logic := '0';
--Outputs
signal out_D : std_logic_vector(3 downto 0) := "0000";

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: Counter PORT MAP(
	clr => clr,
	clk => clk,
	out_D => out_D
	
);


CLK_gen : process
begin
	clk <= '0';
	wait for CLKPeriod/2;
	clk <= '1';
	wait for CLKPeriod/2;
end process;



tb : PROCESS
BEGIN

	clr <= '0';	
	wait for CLKPeriod;		
	clr <= '0';
	wait for CLKPeriod;
	clr <= '0';
	wait for CLKPeriod;
	clr <= '0';
	wait for CLKPeriod;
	clr <= '0';
	wait for CLKPeriod; -- erperado 5 	
	clr <= '1';
	wait for CLKPeriod;
	wait;

END PROCESS;

END;
