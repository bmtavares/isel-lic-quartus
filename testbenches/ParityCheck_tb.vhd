LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity ParityCheck_tb is
end ParityCheck_tb;

architecture behaviour of ParityCheck_tb is
    component ParityCheck is
        port(
            clk,data,init : in std_logic;
            err : out std_logic
            );
    end component;

    constant MCLK_PERIOD : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb, data_tb, init_tb, err_tb : std_logic;

    begin
        UUT:ParityCheck
            port map(
                clk => clk_tb,
                data => data_tb,
                init => init_tb,
                err => err_tb
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
            init_tb <= '1';
            wait for MCLK_PERIOD;
            init_tb <= '0';

            -- Test for "11111111111"

            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            
            init_tb <= '1';
            wait for MCLK_PERIOD*10;
            init_tb <= '0';

            -- Test for "00000000000"

            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            
            init_tb <= '1';
            wait for MCLK_PERIOD*10;
            init_tb <= '0';

            -- Test for "10101010101"

            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;

            init_tb <= '1';
            wait for MCLK_PERIOD*10;
            init_tb <= '0';

            -- Test for "01010101010"

            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;
            data_tb <= '1';
            wait for MCLK_PERIOD;
            data_tb <= '0';
            wait for MCLK_PERIOD;

            -- end test
            init_tb <= '1';

            wait;

            end process;

end;