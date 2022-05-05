LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity SerialReceiver_tb is
end SerialReceiver_tb;

architecture behaviour of SerialReceiver_tb is
    component SerialReceiver is
        port(
            clk, SCLK, SDX, notSS, accept : in std_logic;
            busy, DXval : out std_logic;
            D : out std_logic_vector(9 downto 0)
            );
    end component;

    constant MCLK_PERIOD : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb, SCLK_tb, SDX_tb, notSS_tb, accept_tb, busy_tb, DXval_tb : std_logic;
    signal D_tb : std_logic_vector(9 downto 0);

    begin
        UUT:SerialReceiver
            port map(
                clk => clk_tb,
                SCLK => SCLK_tb,
                SDX => SDX_tb,
                notSS => notSS_tb,
                accept => accept_tb,
                busy => busy_tb,
                DXval => DXval_tb,
                D => D_tb
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
		
			accept_tb <= '0';
			
			wait for MCLK_PERIOD * 5;
			
            -- 1 1 1111 1111 0
            -- 1 (TnL)
           
            notSS_tb <= '0';
            SCLK_tb <= '0';
            SDX_tb <= '1';
            wait for MCLK_PERIOD * 2;

            SCLK_tb <= '1';
            wait for MCLK_PERIOD;
			
            
            -- 2 (RT)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;


            -- 3 (D0)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 4 (D1)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 5 (D2)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 6 (D3)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 7 (O0)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 8 (O1)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 9 (O2)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 10 (O3)
            SCLK_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- Parity
            SCLK_tb <= '0';
            SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';


            notSS_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '0';
			
			wait for MCLK_PERIOD * 5;
			
			-- Done from Dispatcher
			accept_tb <= '1';
			
			wait for MCLK_PERIOD * 2;
			
			accept_tb <= '0';
			
			wait for MCLK_PERIOD * 30;
			
			-- 1 0 0010 1110 1
            -- 1 (TnL)
            notSS_tb <= '0';
            SCLK_tb <= '0';
            SDX_tb <= '1';
            wait for MCLK_PERIOD * 2;

            SCLK_tb <= '1';
            wait for MCLK_PERIOD;
			
            
            -- 2 (RT)
            SCLK_tb <= '0';
			SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;


            -- 3 (D0)
            SCLK_tb <= '0';
			SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 4 (D1)
            SCLK_tb <= '0';
			SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 5 (D2)
            SCLK_tb <= '0';
			SDX_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 6 (D3)
            SCLK_tb <= '0';
			SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 7 (O0)
            SCLK_tb <= '0';
			SDX_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 8 (O1)
            SCLK_tb <= '0';
			SDX_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 9 (O2)
            SCLK_tb <= '0';
			SDX_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- 10 (O3)
            SCLK_tb <= '0';
			SDX_tb <= '0';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';
            wait for MCLK_PERIOD;

            -- Parity
            SCLK_tb <= '0';
            SDX_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '1';


            notSS_tb <= '1';
            wait for MCLK_PERIOD;
            SCLK_tb <= '0';

            wait;
            end process;

end;