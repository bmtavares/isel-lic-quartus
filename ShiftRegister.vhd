LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY ShiftRegister IS
PORT(
    Sin, CLK, enable : in std_logic;
    D : out std_logic_vector(9 downto 0)
);

END ShiftRegister;


ARCHITECTURE behaviour OF ShiftRegister IS
SIGNAL temp_D : std_logic_vector(9 downto 0) := (others => '0');
BEGIN

	temp_D(0) <= temp_D(1) when (rising_edge(CLK) and enable = '1') else temp_D(0);
	temp_D(1) <= temp_D(2) when (rising_edge(CLK) and enable = '1') else temp_D(1);
	temp_D(2) <= temp_D(3) when (rising_edge(CLK) and enable = '1') else temp_D(2);
	temp_D(3) <= temp_D(4) when (rising_edge(CLK) and enable = '1') else temp_D(3);
	temp_D(4) <= temp_D(5) when (rising_edge(CLK) and enable = '1') else temp_D(4);
	temp_D(5) <= temp_D(6) when (rising_edge(CLK) and enable = '1') else temp_D(5);
	temp_D(6) <= temp_D(7) when (rising_edge(CLK) and enable = '1') else temp_D(6);
	temp_D(7) <= temp_D(8) when (rising_edge(CLK) and enable = '1') else temp_D(7);
	temp_D(8) <= temp_D(9) when (rising_edge(CLK) and enable = '1') else temp_D(8);
	temp_D(9) <= Sin when (rising_edge(CLK) and enable = '1') else temp_D(9);
	D <= temp_D;

 END behaviour;