LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity ParityCheck is
port(
	clk,data,init : in std_logic;
	err : out std_logic
	);
end ParityCheck;


Architecture behaviour of ParityCheck is
SIGNAL temp_D : std_logic := '0';

BEGIN

	temp_D <= 	'0' when (init = '1')
					else temp_D xor data when (rising_edge(clk) and (init = '0'))
					else temp_D;
					
	err <= temp_D;

END behaviour;