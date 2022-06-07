library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY KeyTransmitter IS
	PORT(
		clk,DAV,txClk,reset : in STD_LOGIC;
		D : in STD_LOGIC_VECTOR(3 downto 0);
		DAC,txD : out STD_LOGIC
	);
END KeyTransmitter;

ARCHITECTURE behaviour OF KeyTransmitter IS
	COMPONENT CounterEnable
		PORT (
			clk,clr,en : in std_logic;
			cnt : out std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT KeyTransmitterControl
		PORT (
			clk,DAV,reset,fnsh : in STD_LOGIC;
			DAC,st_tx,enable_counter,reset_counter,wr : out STD_LOGIC
		);
	END COMPONENT;



	SIGNAL sig_reset_counter, sig_txD, sig_st_tx, sig_enable, sig_fnsh, sig_wr : STD_LOGIC;
	SIGNAL sig_out_D : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	SIGNAL temp_D : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

	BEGIN
		uCounter:CounterEnable PORT MAP(
			clk => txClk,
			clr => sig_reset_counter,
			en => sig_enable,
			cnt => sig_out_D
		);
		
		uStateMachine:KeyTransmitterControl PORT MAP(
			clk => clk,
			DAV => DAV,
			reset => reset,
			fnsh => sig_fnsh,
			
			DAC => DAC,
			st_tx => sig_st_tx,
			enable_counter => sig_enable,
			reset_counter => sig_reset_counter,
			wr => sig_wr
		);

		temp_D(0) <= D(0) when (rising_edge(clk) and sig_wr = '1') else temp_D(0);
		temp_D(1) <= D(1) when (rising_edge(clk) and sig_wr = '1') else temp_D(1);
		temp_D(2) <= D(2) when (rising_edge(clk) and sig_wr = '1') else temp_D(2);
		temp_D(3) <= D(3) when (rising_edge(clk) and sig_wr = '1') else temp_D(3);
	
		pMux:
		process (sig_out_D, temp_D, sig_txD)
			begin				
				case sig_out_D is
					when "000" =>  sig_txD <= '0';
					when "001" =>  sig_txD <= '1';
					when "010" =>  sig_txD <= temp_D(0);
					when "011" =>	sig_txD <= temp_D(1);
					when "100" =>  sig_txD <= temp_D(2);
					when "101" =>  sig_txD <= temp_D(3);
					when "110" =>  sig_txD <= '0';
					when others => sig_txD <= sig_txD;
				end case;				
		end process;

		sig_fnsh <= '1' when sig_out_D = "110" else '0';

	txD <= sig_txD OR sig_st_tx;
	

END behaviour;