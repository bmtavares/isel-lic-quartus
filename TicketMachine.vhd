LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity TicketMachine is
	port (
	clk,Sensor,
	SWITCH1,HasCoin	: IN STD_LOGIC;
	KEY 			: IN STD_LOGIC_VECTOR(1 downto 0);
	Coin			: IN STD_LOGIC_VECTOR(2 downto 0);
	KEYPAD_LIN		: IN STD_LOGIC_VECTOR(3 downto 0);	

	LCD_RS, LCD_EN 	: OUT STD_LOGIC;
	KEYPAD_COL 		: OUT STD_LOGIC_VECTOR(2 downto 0);
	LCD_DATA 		: OUT STD_LOGIC_VECTOR(7 downto 0);
	HEX1,HEX3,HEX5	: OUT STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	LEDR			: OUT STD_LOGIC_VECTOR(9 downto 0) := "0000000000"
	);
end TicketMachine;

Architecture behaviour of TicketMachine is
	-- Components
	COMPONENT IOS
		PORT (
		clk,SCLK,SDX,
		notSS,Fsh,reset	: IN STD_LOGIC;

		busy, wrt, wrl	: OUT STD_LOGIC;
		DEBUG			: OUT STD_LOGIC_VECTOR(5 downto 0);
		Dout			: OUT STD_LOGIC_VECTOR(8 downto 0)
		);
	END COMPONENT;

	COMPONENT UsbPort
		PORT (
		inputPort	: IN STD_LOGIC_VECTOR(7 downto 0);

		outputPort	: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;

	COMPONENT TDispenser
		PORT (
		Prt,RT,Sensor	: IN STD_LOGIC;
		DId,OId 		: IN STD_LOGIC_VECTOR(3 downto 0);

		Fn 				: OUT STD_LOGIC;
		HEX1,HEX3,HEX5	: OUT STD_LOGIC_VECTOR(7 downto 0) := "11111111"
		);
	END COMPONENT;
	
	COMPONENT KeyboardReader
		PORT (
		clk,reset,TXclk	: IN STD_LOGIC;
		KEYPAD_LIN 		: IN STD_LOGIC_VECTOR(3 downto 0);

		TXd,DBUG 		: OUT STD_LOGIC;
		KEYPAD_COL 		: OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	END COMPONENT;

	-- Signals
	SIGNAL sig_wrt,sig_wrl,sig_fn	: STD_LOGIC;
	SIGNAL sig_masterReset			: STD_LOGIC := '1';
	SIGNAL DEBUG 					: STD_LOGIC_VECTOR(5 downto 0);
	SIGNAL outputPort_sync,sig_inputPort,
		   sig_outputPort 			: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL sig_dOut 				: STD_LOGIC_VECTOR(8 downto 0);

	BEGIN
		uUsbPort:UsbPort
			PORT MAP (
			inputPort 	=> sig_inputPort,
			outputPort 	=> sig_outputPort
			);	

		uIOS:IOS
			PORT MAP (
			clk 	=> clk,
			SCLK 	=> outputPort_sync(2),
			SDX 	=> outputPort_sync(1),
			notSS   => outputPort_sync(3),
			Fsh 	=> sig_fn,
			busy 	=> sig_inputPort(6),
			wrt 	=> sig_wrt,
			wrl 	=> sig_wrl,     
			Dout 	=> sig_dOut,
			reset 	=> sig_masterReset,
			DEBUG 	=> DEBUG
			);

		uTDispenser:TDispenser
			PORT MAP (
			Prt 	=> sig_wrt,
			RT  	=> sig_dOut(0),
			Fn		=> sig_fn,
			DId(0) 	=> sig_dOut(1),
			DId(1) 	=> sig_dOut(2),
			DId(2) 	=> sig_dOut(3),
			DId(3) 	=> sig_dOut(4),
			OId(0) 	=> sig_dOut(5),
			OId(1) 	=> sig_dOut(6),
			OId(2) 	=> sig_dOut(7),
			OId(3) 	=> sig_dOut(8),
			HEX1 	=> HEX1,
			HEX3 	=> HEX3,
			HEX5 	=> HEX5,
			Sensor	=> Sensor
			);

		uKeyboard:KeyboardReader
			PORT MAP (
			clk 		=> clk,
			reset 		=> sig_masterReset,
			KEYPAD_LIN	=> KEYPAD_LIN,
			KEYPAD_COL	=> KEYPAD_COL,
			TXd 		=> sig_inputPort(5),
			TXclk 		=> outputPort_sync(4)
			);

		--Used to synchronize USB port output to system clk
		outputPort_sync(0) <= sig_outputPort(0) when rising_edge(CLK) else outputPort_sync(0);
		outputPort_sync(1) <= sig_outputPort(1) when rising_edge(CLK) else outputPort_sync(1);
		outputPort_sync(2) <= sig_outputPort(2) when rising_edge(CLK) else outputPort_sync(2);
		outputPort_sync(3) <= sig_outputPort(3) when rising_edge(CLK) else outputPort_sync(3);
		outputPort_sync(4) <= sig_outputPort(4) when rising_edge(CLK) else outputPort_sync(4);
		outputPort_sync(5) <= sig_outputPort(5) when rising_edge(CLK) else outputPort_sync(5);
		outputPort_sync(6) <= sig_outputPort(6) when rising_edge(CLK) else outputPort_sync(6);
		outputPort_sync(7) <= sig_outputPort(7) when rising_edge(CLK) else outputPort_sync(7);

		-- Reset button
		sig_masterReset <= '0';
		
		-- Assignments for LCD
		LCD_EN 	<= sig_wrl;
		LCD_RS 	<= sig_dOut(0);
		LCD_DATA(0) <= sig_dOut(1);
		LCD_DATA(1) <= sig_dOut(2);
		LCD_DATA(2) <= sig_dOut(3);
		LCD_DATA(3) <= sig_dOut(4);
		LCD_DATA(4) <= sig_dOut(5);
		LCD_DATA(5) <= sig_dOut(6);
		LCD_DATA(6) <= sig_dOut(7);
		LCD_DATA(7) <= sig_dOut(8);

		-- coin aceptor
		sig_inputPort(0) <= Coin(0);
		sig_inputPort(1) <= Coin(1);
		sig_inputPort(2) <= Coin(2);
		sig_inputPort(3) <= HasCoin;

		-- Maintenence Key
		sig_inputPort(7) <= SWITCH1;

		-- LEDs
		LEDR(0) <= Sensor;
		LEDR(1) <= SWITCH1;
		-- LEDR(2) <= ;
		LEDR(3) <= HasCoin;
		LEDR(4) <= outputPort_sync(5); --Accept
		LEDR(5) <= Coin(0);
		LEDR(6) <= Coin(1);
		LEDR(7) <= Coin(2);
		LEDR(8) <= outputPort_sync(6); --Collect
		LEDR(9) <= outputPort_sync(7); --Eject

END behaviour;