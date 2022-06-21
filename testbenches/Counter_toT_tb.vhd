LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY Counter_toT_tb IS
END Counter_toT_tb;

ARCHITECTURE behavior OF Counter_toT_tb IS 

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT Counter_toT is
	port(
        clk,clr,enable : in std_logic;
        out_D : out std_logic_vector(1 downto 0)
	);
end COMPONENT;

constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

--Inputs
SIGNAL clk_tb, clr_tb, en_tb : STD_LOGIC;

--Outputs
SIGNAL out_tb : STD_LOGIC_VECTOR(1 downto 0);

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: Counter_toT PORT MAP(
	clk => clk_tb,
	clr => clr_tb,
	enable => en_tb,
	out_D => out_tb
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

		assert out_tb = "00"
		report "Counter can't count without enable.";

		en_tb  <= '1';

		for I in 0 to 3 loop
			wait for MCLK_PERIOD;

			if (I = 1) then
				assert out_tb = "10"
				report "Counter should be 2 by now.";
			end if;

            if (I = 3) then
				assert out_tb = "01"
				report "Counter should be 1 by now.";
			end if;
		end loop;

		wait for MCLK_PERIOD;

		assert out_tb = "10"
		report "Counter should be 2 by now.";

		clr_tb <= '1';

		wait for 10 ps;

		assert out_tb = "00"
		report "Counter should be 0 by now.";

		wait;
END PROCESS;

END;
