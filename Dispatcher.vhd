library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dispatcher is
	port(
		dclk,Fsh,Dval, reset : in STD_LOGIC;
		Din : in STD_LOGIC_VECTOR(9 downto 0);
		wrt,wrl,done : out STD_LOGIC;
		Dout : out STD_LOGIC_VECTOR(8 downto 0)
	);
end Dispatcher;


architecture behaviour of Dispatcher is
	type STATE_TYPE is (
		STATE_START_UP,
		STATE_ACTIVATE_TICKET_DISPENSER,
		STATE_TICKET_DISPENSER_INTERLOCK,
		STATE_ACTIVATE_LCD,
		STATE_ACTIVATE_LCD_2,
		STATE_ACTIVATE_LCD_3,
		STATE_DONE_ACK
		);
	
	
	SIGNAL CurrentState : STATE_TYPE := STATE_START_UP;
	SIGNAL NextState : STATE_TYPE := STATE_START_UP;
	
	BEGIN
	CurrentState <= NextState when rising_edge(dclk);
	
	GenerateNextState:
		process (CurrentState, Fsh, Dval, Din, reset)
			begin				
				case CurrentState is
					when STATE_START_UP							=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			elsif (Dval='1' AND Din(0)='1') then
																				NextState <= STATE_ACTIVATE_TICKET_DISPENSER;
																			elsif (Dval='1' AND Din(0)='0') then
																				NextState <= STATE_ACTIVATE_LCD;
																			else
																				NextState <= STATE_START_UP;
																			end if;
																			
					when STATE_ACTIVATE_TICKET_DISPENSER	=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			elsif (Fsh='1') then
																				NextState <= STATE_TICKET_DISPENSER_INTERLOCK;
																			else
																				NextState <= STATE_ACTIVATE_TICKET_DISPENSER;
																			end if;
																					
					when STATE_TICKET_DISPENSER_INTERLOCK	=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			elsif (Fsh='0') then
																				NextState <= STATE_DONE_ACK;
																			else
																				NextState <= STATE_TICKET_DISPENSER_INTERLOCK;
																			end if;
																			
					when STATE_ACTIVATE_LCD						=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			else
																				NextState <= STATE_ACTIVATE_LCD_2;
																			end if;
															
					when STATE_ACTIVATE_LCD_2					=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			else
																				NextState <= STATE_ACTIVATE_LCD_3;
																			end if;
																					
					when STATE_ACTIVATE_LCD_3					=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			else
																				NextState <= STATE_DONE_ACK;
																			end if;
																							
					when STATE_DONE_ACK							=> if(reset='1') then
																				NextState <= STATE_START_UP;
																			elsif (Dval='0') then
																				NextState <= STATE_START_UP;
																			else
																				NextState <= STATE_DONE_ACK;
																			end if;
				end case;
		end process;
				
	wrt <= '1' when CurrentState=STATE_ACTIVATE_TICKET_DISPENSER else '0';

	wrl <= '1' when (CurrentState=STATE_ACTIVATE_LCD OR CurrentState=STATE_ACTIVATE_LCD_2 OR CurrentState=STATE_ACTIVATE_LCD_3) else '0';

	done <= '1' when CurrentState=STATE_DONE_ACK else '0';

	Dout <= Din(9 downto 1);

end behaviour;