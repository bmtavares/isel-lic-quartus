LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

entity Counter_toT is
port(
	clk,clr,enable : in std_logic;
	out_D : out std_logic_vector(1 downto 0)
);
end Counter_toT;


Architecture behaviour of Counter_toT is
SIGNAL temp_D : unsigned (1 downto 0) := (others => '0');

BEGIN

	temp_D <= "00" when (clr = '1' or (temp_D(0) = '1' and temp_D(1) = '1') ) else
		temp_D + "1" when (rising_edge(clk) and  enable = '1') else temp_D;
	
	out_D <= std_logic_vector(temp_D);

END behaviour;