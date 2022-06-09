library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY KeyTransmitterControl IS
	PORT(
		clk,DAV,reset,fnsh : in STD_LOGIC;
		DAC,enable_counter,reset_counter,wr : out STD_LOGIC;
		st_tx : out STD_LOGIC := '1'
	);
END KeyTransmitterControl;

ARCHITECTURE behaviour OF KeyTransmitterControl IS

	type STATE_TYPE is (
		STATE_WAITING,
		STATE_GET_PRESS,
		STATE_ACK,
		STATE_KEY_TRANSMITING
		
		);
	
	SIGNAL CurrentState : STATE_TYPE := STATE_WAITING;
	SIGNAL NextState : STATE_TYPE := STATE_WAITING;

	BEGIN
	
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
																	NextState <= STATE_WAITING;
																else
																	NextState <= STATE_KEY_TRANSMITING;
																end if;
																
						
					end case;
		end process;

		wr <= '1' when CurrentState=STATE_GET_PRESS else '0';

		enable_counter <= '1' when CurrentState=STATE_KEY_TRANSMITING else '0';

	   reset_counter <= '1' when CurrentState=STATE_WAITING else '0';

		st_tx <= '0' when CurrentState=STATE_KEY_TRANSMITING  else '1';
		--st_tx <= '1';
		
		DAC <= '1' when CurrentState=STATE_ACK else '0';

END behaviour;