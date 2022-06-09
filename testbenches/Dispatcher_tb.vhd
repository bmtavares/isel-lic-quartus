LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Dispatcher_tb is
end Dispatcher_tb;

architecture behaviour of Dispatcher_tb is
    component Dispatcher is
        port(
            dclk,Fsh,Dval : in STD_LOGIC;
            Din : in STD_LOGIC_VECTOR(9 downto 0);
            wrt,wrl,done : out STD_LOGIC;
            Dout : out STD_LOGIC_VECTOR(8 downto 0)
            );
    end component;

	COMPONENT CLKDIV is
		GENERIC (div : NATURAL);
		PORT (
			clk_in : IN STD_LOGIC;
			clk_out : OUT STD_LOGIC
		);
	END COMPONENT;

    constant MCLK_PERIOD : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb, Fsh_tb, Dval_tb, wrt_tb, wrl_tb, done_tb,sig_clkDivided : std_logic;
    signal Dout_tb : std_logic_vector(8 downto 0);
    signal Din_tb : std_logic_vector(9 downto 0);

    begin
	
	
        UUT:Dispatcher
            port map(
                dclk => sig_clkDivided,
                Fsh => Fsh_tb,
                Dval => Dval_tb,
                Din => Din_tb,
                wrt => wrt_tb,
                wrl => wrl_tb,
                done => done_tb,
                Dout => Dout_tb
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
            Fsh_tb <= '0';
            Dval_tb <= '0';
            Din_tb <= "0000000000";
				
			wait for MCLK_PERIOD * 5;

            -- Data for Ticket Dispenser 1
            Din_tb <= "1111111111";
            -- After an SCLK cycle, Dval from Serial Receiver is up
            wait for MCLK_PERIOD;
            Dval_tb <= '1';
			
            wait for MCLK_PERIOD * 12;
            -- Set finish from Ticket Dispenser for done
            Fsh_tb <= '1';
            Dval_tb <= '0';
            wait for MCLK_PERIOD * 2;

            -- Reset finish
            Fsh_tb <= '0';

            wait for MCLK_PERIOD * 10;

            -- Data for Ticket Dispenser 2
            Din_tb <= "0111010001";
            -- After an SCLK cycle, Dval from Serial Receiver is up
            wait for MCLK_PERIOD;
            Dval_tb <= '1';
			
            wait for MCLK_PERIOD * 12;
            -- Set finish from Ticket Dispenser for done
            Fsh_tb <= '1';
            Dval_tb <= '0';
            wait for MCLK_PERIOD * 2;

            -- Reset finish
            Fsh_tb <= '0';

            wait for MCLK_PERIOD * 10;

            -- Data for LCD
            Din_tb <= "0110100110";
            -- After an SCLK cycle, Dval from Serial Receiver is up
            wait for MCLK_PERIOD;
            Dval_tb <= '1';
			
            wait for MCLK_PERIOD * 12;

            Dval_tb <= '0';
            
			
			-----------___________________________________--------------
			
			
			
			
			
			
            wait;
            end process;

end;