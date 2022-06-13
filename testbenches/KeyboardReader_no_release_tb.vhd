LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY KeyboardReader_tb IS
END KeyboardReader_tb;

ARCHITECTURE behavior OF KeyboardReader_tb IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT KeyboardReader is
	port (
	clk, reset : in std_logic;
	KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
	KEYPAD_COL : OUT STD_LOGIC_vector(2 downto 0);
	TXd, DBUG: out std_logic;
	TXclk : in std_logic
	);
end COMPONENT;

constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

--Inputs
SIGNAL clk_tb, reset_tb, TXclk_tb : STD_LOGIC;
SIGNAL KEYPAD_LIN_tb : STD_LOGIC_vector(3 downto 0);

--Outputs
SIGNAL TXd_tb, DBUG_tb : STD_LOGIC;
SIGNAL KEYPAD_COL_tb : STD_LOGIC_vector(2 downto 0);

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: KeyboardReader PORT MAP(
	clk => clk_tb,
	reset => reset_tb,
	KEYPAD_LIN => KEYPAD_LIN_tb,
	KEYPAD_COL => KEYPAD_COL_tb,
	TXd => TXd_tb,
	DBUG => DBUG_tb,
	TXclk => TXclk_tb
	);


CLK_gen : process
begin
	clk_tb <= '0';
	wait for MCLK_HALF_PERIOD;
	clk_tb <= '1';
	wait for MCLK_HALF_PERIOD;
end process;


tb : PROCESS
BEGIN
	KEYPAD_LIN_tb <= "1111";
    reset_tb <= '0';
	TXclk_tb <= '0';

    wait for MCLK_PERIOD * 3;

	KEYPAD_LIN_tb <= "1110";

	wait for MCLK_PERIOD * 7;

	-- Waiting for control software
	assert TXd_tb = '0'
	report "TXd is not 0 before start.";

	for I in 0 to 6 loop
		TXclk_tb <= '1';
		wait for MCLK_PERIOD * 3;

		if (I = 0) then
			-- Start bit
			assert TXd_tb = '1'
			report "Start bit was wrong.";
		elsif (I = 5) then
			-- Stop bit
			assert TXd_tb = '0'
			report "Stop bit was wrong.";
		elsif (I = 6) then
			-- Return to wait
			assert TXd_tb = '1'
			report "TXd did not return to 1 after stop.";
		end if;

		TXclk_tb <= '0';
		wait for MCLK_PERIOD * 3;
	end loop;

	wait for MCLK_PERIOD * 10;

	wait;

END PROCESS;

END;
