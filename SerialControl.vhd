library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SerialControl is
	port(
		clk,notSS,accept,pFlag,dFlag,RXerror : in STD_LOGIC;
		wr,init,DXval,busy : out STD_LOGIC
	);
end SerialControl;


architecture behaviour of SerialControl is
	type STATE_TYPE is (
		STATE_READY,
		STATE_READING_DX,
		STATE_READING_PARITY,
		STATE_SENDING,
		STATE_WAITING_ACK
		);
	
	
	SIGNAL CurrentState : STATE_TYPE := STATE_READY;
	SIGNAL NextState : STATE_TYPE := STATE_READY;
	
	BEGIN
	CurrentState <= NextState when rising_edge(clk);
	
	GenerateNextState:
		process (CurrentState, notSS, dFlag, pFlag, accept, RXerror)
			begin				
				case CurrentState is
					when STATE_READY				=> if (notSS='0') then
																NextState <= STATE_READING_DX;
															else
																NextState <= STATE_READY;
															end if;
					when STATE_READING_DX		=> if (notSS='1') then
																NextState <= STATE_READY;
															elsif (dFlag='1') then
																NextState <= STATE_READING_PARITY;
															else
																NextState <= STATE_READING_DX;
															end if;
					--when STATE_READING_PARITY	=> if (notSS='1' OR RXerror='1' OR pFlag='0') then
					--											NextState <= STATE_READY;
					--										elsif (pFlag='1' AND RXerror='0') then
					--											NextState <= STATE_SENDING;
					--										else
					--											NextState <= STATE_READING_PARITY;
					--										end if;
					when STATE_READING_PARITY	=> if (pFlag='0') then
																NextState <= STATE_READING_PARITY;
															elsif (RXerror='1') then
																NextState <= STATE_READY;
															else
																NextState <= STATE_SENDING;
															end if;
					when STATE_SENDING			=> if (accept='1') then
																NextState <= STATE_WAITING_ACK;
															else
																NextState <= STATE_SENDING;
															end if;
					when STATE_WAITING_ACK		=> if (accept='0') then
																NextState <= STATE_READY;
															else
																NextState <= STATE_WAITING_ACK;
															end if;
				end case;				
		end process;
				
	init <= '1' when CurrentState=STATE_READY else '0';
	wr <= '1' when CurrentState=STATE_READING_DX else '0';
	DXval <= '1' when CurrentState=STATE_SENDING else '0';
	busy <= '1' when (CurrentState=STATE_SENDING OR CurrentState=STATE_WAITING_ACK) else '0';
	--busy <= '1';

end behaviour;