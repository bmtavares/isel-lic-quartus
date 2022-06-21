LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY PriorityEncoder IS
	PORT (	
	decoded	: IN STD_LOGIC_VECTOR(3 downto 0);
		
	Y	    : OUT STD_LOGIC_VECTOR(1 downto 0);
    GS      : OUT STD_LOGIC
	);
END PriorityEncoder;

ARCHITECTURE behaviour OF PriorityEncoder IS

    SIGNAL s : STD_LOGIC_VECTOR(3 downto 0) := "1111";

    BEGIN

        -- Active low
        s(0) <= NOT(decoded(0));
        s(1) <= NOT(decoded(1));
        s(2) <= NOT(decoded(2));
        s(3) <= NOT(decoded(3));

        Y <= "00" when s = "0001" else
             "01" when s = "0010" else
             "10" when s = "0100" else
             "11" when s = "1000" else
             "XX";

        -- Global select
        GS <= s(0) OR s(1) OR s(2) OR s(3);

END behaviour;