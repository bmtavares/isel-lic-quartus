LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY TxDOutputMux IS
	PORT (
    selector: IN STD_LOGIC_VECTOR(2 downto 0);
    d_in    : IN STD_LOGIC_VECTOR(3 downto 0);
		
	result  : OUT STD_LOGIC
	);
END TxDOutputMux;

ARCHITECTURE behaviour OF TxDOutputMux IS

    SIGNAL sig_r : STD_LOGIC := '1';

    BEGIN
        pMux:
        process (selector, d_in, sig_r)
            begin
                case selector is
                    when "000" =>  sig_r <= '0';
                    when "001" =>  sig_r <= '1';
                    when "010" =>  sig_r <= d_in(0);
                    when "011" =>  sig_r <= d_in(1);
                    when "100" =>  sig_r <= d_in(2);
                    when "101" =>  sig_r <= d_in(3);
                    when "110" =>  sig_r <= '0';
                    when others => sig_r <= sig_r;
                end case;
        end process;

    result <= sig_r;
    
END behaviour;