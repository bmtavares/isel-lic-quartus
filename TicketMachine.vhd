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
	SIGNAL Swrt,Swrl,Sfn,
		   sig_txD,sig_txClk,s_dbug	: STD_LOGIC;
	SIGNAL sig_mReset				: STD_LOGIC := '1';
	SIGNAL DEBUG 					: STD_LOGIC_VECTOR(5 downto 0);
	SIGNAL usb_reg,
		   SinputPort,SoutputPort 	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL SDout 					: STD_LOGIC_VECTOR(8 downto 0);

	BEGIN
		uUsbPort:UsbPort
			PORT MAP (
			inputPort 	=> SinputPort,
			outputPort 	=> SoutputPort
			);	

		uIOS:IOS
			PORT MAP (
			clk 	=> clk,
			SCLK 	=> usb_reg(2),
			SDX 	=> usb_reg(1),
			notSS   => usb_reg(3),
			Fsh 	=> Sfn,
			busy 	=> SinputPort(6),
			wrt 	=> Swrt,
			wrl 	=> Swrl,     
			Dout 	=> SDout,
			reset 	=> sig_mReset,
			DEBUG 	=> DEBUG
			);

		uTDispenser:TDispenser
			PORT MAP (
			Prt 	=> Swrt,
			RT  	=> SDout(0),
			Fn		=> Sfn,
			DId(0) 	=> SDout(1),
			DId(1) 	=> SDout(2),
			DId(2) 	=> SDout(3),
			DId(3) 	=> SDout(4),
			OId(0) 	=> SDout(5),
			OId(1) 	=> SDout(6),
			OId(2) 	=> SDout(7),
			OId(3) 	=> SDout(8),
			HEX1 	=> HEX1,
			HEX3 	=> HEX3,
			HEX5 	=> HEX5,
			Sensor	=> Sensor
			);

		uKeyboard:KeyboardReader
			PORT MAP (
			clk 		=> clk,
			reset 		=> sig_mReset,
			KEYPAD_LIN	=> KEYPAD_LIN,
			KEYPAD_COL	=> KEYPAD_COL,
			TXd 		=> SinputPort(5),
			TXclk 		=> usb_reg(4)
			);

		--Used to synchronize USB port output to system clk
		usb_reg(0) <= SoutputPort(0) when rising_edge(CLK) else usb_reg(0);
		usb_reg(1) <= SoutputPort(1) when rising_edge(CLK) else usb_reg(1);
		usb_reg(2) <= SoutputPort(2) when rising_edge(CLK) else usb_reg(2);
		usb_reg(3) <= SoutputPort(3) when rising_edge(CLK) else usb_reg(3);
		usb_reg(4) <= SoutputPort(4) when rising_edge(CLK) else usb_reg(4);
		usb_reg(5) <= SoutputPort(5) when rising_edge(CLK) else usb_reg(5);
		usb_reg(6) <= SoutputPort(6) when rising_edge(CLK) else usb_reg(6);
		usb_reg(7) <= SoutputPort(7) when rising_edge(CLK) else usb_reg(7);

		-- Reset button
		sig_mReset <= '0';
		
		-- Assignments for LCD
		LCD_EN 	<= Swrl;
		LCD_RS 	<= SDout(0);
		LCD_DATA(0) <= SDout(1);
		LCD_DATA(1) <= SDout(2);
		LCD_DATA(2) <= SDout(3);
		LCD_DATA(3) <= SDout(4);
		LCD_DATA(4) <= SDout(5);
		LCD_DATA(5) <= SDout(6);
		LCD_DATA(6) <= SDout(7);
		LCD_DATA(7) <= SDout(8);

		-- coin aceptor
		SinputPort(0) <= Coin(0);
		SinputPort(1) <= Coin(1);
		SinputPort(2) <= Coin(2);
		SinputPort(3) <= HasCoin;

		-- Maintenence Key
		SinputPort(7) <= SWITCH1;

		-- LEDs
		LEDR(0) <= Sensor;
		LEDR(1) <= SWITCH1;
		-- LEDR(2) <= ;
		LEDR(3) <= HasCoin;
		LEDR(4) <= usb_reg(5); --Accept
		LEDR(5) <= Coin(0);
		LEDR(6) <= Coin(1);
		LEDR(7) <= Coin(2);
		LEDR(8) <= usb_reg(6); --Collect
		LEDR(9) <= usb_reg(7); --Eject

END behaviour;