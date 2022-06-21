LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY CounterEnable_tb IS
END CounterEnable_tb;

ARCHITECTURE behavior OF CounterEnable_tb IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT CounterEnable is
	port(
		clk,clr,en : in std_logic;
		cnt : out std_logic_vector(2 downto 0)
	);
end COMPONENT;

constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

--Inputs
SIGNAL clk_tb, clr_tb, en_tb : STD_LOGIC;

--Outputs
SIGNAL cnt_tb : STD_LOGIC_VECTOR(2 downto 0);

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: CounterEnable PORT MAP(
	clk => clk_tb,
	clr => clr_tb,
	en => en_tb,
	cnt => cnt_tb
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
		clr_tb <= '0';
		en_tb  <= '0';

		wait for MCLK_PERIOD * 2;

		assert cnt_tb = "000"
		report "Counter can't count without enable.";

		en_tb  <= '1';

		for I in 0 to 8 loop
			wait for MCLK_PERIOD;

			if (I = 6) then
				assert cnt_tb = "111"
				report "Counter should be 7 by now.";
			end if;
		end loop;

		wait for MCLK_PERIOD;

		assert cnt_tb = "010"
		report "Counter should be 3 by now.";

		clr_tb <= '1';

		wait for 10 ps;

		assert cnt_tb = "000"
		report "Counter should be 0 by now.";

		wait;
END PROCESS;

END;
