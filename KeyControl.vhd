library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity KeyControl is
	port(
	clk,kAck,kPress,reset : IN STD_LOGIC;

	kVal,kScan 			  : OUT STD_LOGIC
	);
end KeyControl;

architecture behaviour of KeyControl is
	type STATE_TYPE is (
		STATE_WAITING_KEY,
		STATE_KEY_READY,
		STATE_WAIT_ACK_RELEASE,
		STATE_WAIT_KEY_RELEASE
		);
	
	SIGNAL CurrentState : STATE_TYPE := STATE_WAITING_KEY;
	SIGNAL NextState : STATE_TYPE := STATE_WAITING_KEY;
	
	BEGIN
	CurrentState <= NextState when rising_edge(clk);

	GenerateNextState:
		process (CurrentState, kAck, kPress, reset)
			begin				
				case CurrentState is
					when STATE_WAITING_KEY	=>  if (kPress='1') then
														NextState <= STATE_KEY_READY;
													else
														NextState <= STATE_WAITING_KEY;
													end if;
													
					when STATE_KEY_READY		=>  if (reset='1') then
														NextState <= STATE_WAITING_KEY;
													elsif (kAck='1') then
														NextState <= STATE_WAIT_ACK_RELEASE;
													else
														NextState <= STATE_KEY_READY;
													end if;
													
					when STATE_WAIT_ACK_RELEASE	=>  if (reset='1') then
														NextState <= STATE_WAITING_KEY;
													elsif (kAck='0') then
														NextState <= STATE_WAIT_KEY_RELEASE;
													else
														NextState <= STATE_WAIT_ACK_RELEASE;
													end if;
													
					when STATE_WAIT_KEY_RELEASE	=>  if (reset='1' OR kPress='0') then
														NextState <= STATE_WAITING_KEY;
													else
														NextState <= STATE_WAIT_KEY_RELEASE;
													end if;

				end case;				
		end process;
				
	kScan <= '1' when CurrentState=STATE_WAITING_KEY else '0';
	kVal <= '1' when CurrentState=STATE_KEY_READY else '0';
	
end behaviour;