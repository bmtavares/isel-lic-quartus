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
	COMPONENT Counter
		PORT (
			clk,clr : in std_logic;
			out_D : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	type STATE_TYPE is (
		STATE_WAITING,
		STATE_GET_PRESS,
		STATE_ACK,
		STATE_KEY_TRANSMITING,
		STATE_FINISH_TRANSMIT
		);
	
	SIGNAL CurrentState : STATE_TYPE := STATE_WAITING;
	SIGNAL NextState : STATE_TYPE := STATE_WAITING;

	SIGNAL reset_counter, sig_txD, st_tx, enable_counter, wr, fnsh : STD_LOGIC;
	SIGNAL sig_out_D : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	SIGNAL temp_D : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

	BEGIN
		uCounter:Counter PORT MAP(
			clk => txClk,
			clr => reset_counter,
			out_D => sig_out_D
		);

		temp_D(0) <= D(0) when (rising_edge(clk) and wr = '1') else temp_D(0);
		temp_D(1) <= D(1) when (rising_edge(clk) and wr = '1') else temp_D(1);
		temp_D(2) <= D(2) when (rising_edge(clk) and wr = '1') else temp_D(2);
		temp_D(3) <= D(3) when (rising_edge(clk) and wr = '1') else temp_D(3);
	
		CurrentState <= NextState when rising_edge(clk);

		pControlStateMachine:
			process (CurrentState, reset, DAV, fnsh)
				begin
					case CurrentState is
						when STATE_WAITING 			=> if (DAV='1') then
																	NextState <= STATE_GET_PRESS;
																else
																	NextState <= STATE_WAITING;
																end if;
																
						when STATE_GET_PRESS 		=> if (reset='1') then
																	NextState <= STATE_WAITING;
																else
																	NextState <= STATE_ACK;
																end if;
																
						when STATE_ACK 				=> if (reset='1') then
																	NextState <= STATE_WAITING;
																elsif (DAV='0') then
																	NextState <= STATE_KEY_TRANSMITING;
																else
																	NextState <= STATE_ACK;
																end if;
																
						when STATE_KEY_TRANSMITING	=> if (reset='1') then
																	NextState <= STATE_WAITING;
																elsif (fnsh='1') then
																	NextState <= STATE_FINISH_TRANSMIT;
																else
																	NextState <= STATE_KEY_TRANSMITING;
																end if;
																
						when STATE_FINISH_TRANSMIT	=> NextState <= STATE_WAITING;
					end case;
		end process;

		pMux:
		process (sig_out_D, temp_D)
			begin				
				case sig_out_D is
					when "0000"	=>  sig_txD <= '0';
					when "0001"	=>  sig_txD <=	'1';
					when "0010"	=>  sig_txD <= temp_D(0);
					when "0011" =>	 sig_txD <= temp_D(1);
					when "0100" =>  sig_txD <=	temp_D(2);
					when "0101" =>  sig_txD <=	temp_D(3);
					when "0110" =>  sig_txD <=	'0';
				end case;				
		end process;

		wr <= '1' when CurrentState=STATE_GET_PRESS else '0';

		enable_counter <= '1' when CurrentState=STATE_KEY_TRANSMITING else '0';

	   reset_counter <= '1' when CurrentState=STATE_WAITING else '0';

		st_tx <= '1' when (CurrentState=STATE_WAITING or CurrentState=STATE_GET_PRESS or CurrentState=STATE_ACK) else '0';

		fnsh <= '1' when sig_out_D = "0110" else '0';

		DAC <= '1' when CurrentState=STATE_ACK else '0';

		txD <= sig_txD OR st_tx;

END behaviour;