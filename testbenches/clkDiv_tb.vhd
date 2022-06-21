LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity clkDIV_tb is
end clkDIV_tb;

architecture behaviour of clkDIV_tb is
    COMPONENT clkDIV
	GENERIC (div : NATURAL);
	PORT (
		clk_in : IN STD_LOGIC;
		clk_out : OUT STD_LOGIC
	);
END COMPONENT;

    constant MCLK_PERIOD : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb, sig_clkDivided : std_logic;

    begin
	
		uut:clkDIV
		GENERIC MAP ( div => 26 )
		PORT MAP (
			clk_in 	=> clk_tb,
			clk_out	=> sig_clkDivided
		);


        clk_gen:process
        begin
            clk_tb <= '0';
            wait for MCLK_HALF_PERIOD;
            clk_tb <= '1';
            wait for MCLK_HALF_PERIOD;
        end process;

        stimulus:process
        begin
            wait;
        end process;

end;