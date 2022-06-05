LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

entity CounterEnable is
port(
	clk,clr,en : in std_logic;
	cnt : out std_logic_vector(2 downto 0)
);
end CounterEnable;


Architecture behaviour of CounterEnable is
SIGNAL temp_D : unsigned (2 downto 0) := (others => '0');

BEGIN

	temp_D <= "000" when (clr = '1') else
		temp_D + "1" when ((en = '1') AND (rising_edge(clk))) else temp_D;
	cnt <= std_logic_vector(temp_D);

END behaviour;