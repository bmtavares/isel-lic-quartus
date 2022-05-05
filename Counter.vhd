LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

entity Counter is
port(
	clk,clr : in std_logic;
	out_D : out std_logic_vector(3 downto 0)
);
end Counter;


Architecture behaviour of Counter is
SIGNAL temp_D : unsigned (3 downto 0) := (others => '0');

BEGIN

	temp_D <= "0000" when (clr = '1') else
		temp_D + "1" when (rising_edge(clk)) else temp_D;
	out_D <= std_logic_vector(temp_D);

END behaviour;