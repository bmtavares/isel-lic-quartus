LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY Decoder IS
	PORT (	
	encoded	: IN STD_LOGIC_VECTOR(1 downto 0);
		
	decoded	: OUT STD_LOGIC_VECTOR(2 downto 0)
	);
END Decoder;

ARCHITECTURE behaviour OF Decoder IS

    SIGNAL d : STD_LOGIC_VECTOR(2 downto 0) := "111";

    BEGIN

        d(0) <= NOT(encoded(0)) AND NOT(encoded(1));
        d(1) <= encoded(0) AND NOT(encoded(1));
        d(2) <= NOT(encoded(0)) AND encoded(1);

        -- Active low
        decoded(0) <= NOT(d(0));
        decoded(1) <= NOT(d(1));
        decoded(2) <= NOT(d(2));

END behaviour;