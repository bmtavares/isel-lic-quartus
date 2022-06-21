LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY RegisterBank IS
	PORT (
    clk     : IN STD_LOGIC;
    en      : IN STD_LOGIC := '1';
	d_in    : IN STD_LOGIC_VECTOR(1 downto 0);
		
	q	    : OUT STD_LOGIC_VECTOR(1 downto 0)
	);
END RegisterBank;

ARCHITECTURE behaviour OF RegisterBank IS

    SIGNAL d, sig_q : STD_LOGIC_VECTOR(1 downto 0);

    BEGIN
        sig_q(0) <= d_in(0) when (rising_edge(clk) AND en = '1') else sig_q(0);
        sig_q(1) <= d_in(1) when (rising_edge(clk) AND en = '1') else sig_q(1);

        q(0) <= sig_q(0);
        q(1) <= sig_q(1);

END behaviour;