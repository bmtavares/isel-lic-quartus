LIBRARY IEEE;
use IEEE.std_logic_1164.all;

ENTITY KeyboardReader IS
	PORT (
	clk,reset,TXclk	: IN  STD_LOGIC;
	KEYPAD_LIN 		: IN  STD_LOGIC_VECTOR(3 downto 0);

	TXd				: OUT STD_LOGIC;
	KEYPAD_COL 		: OUT STD_LOGIC_VECTOR(2 downto 0)
	);
END KeyboardReader;

Architecture accKeyboardReader of KeyboardReader is

	COMPONENT KeyDecode
		PORT (
		clk,reset,kAck	: IN  STD_LOGIC;
		KEYPAD_LIN 		: IN  STD_LOGIC_VECTOR(3 downto 0);

		kVal 			: OUT STD_LOGIC;
		KEYPAD_COL 		: OUT STD_LOGIC_VECTOR(2 downto 0);
		K				: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;

	COMPONENT KeyTransmitter
		PORT (
		clk,reset,
		DAV,TXclk	: IN STD_LOGIC;
		D 			: IN STD_LOGIC_VECTOR(3 downto 0);

		DAC, txD	: OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT clkDIV
		GENERIC (div : NATURAL);
		PORT (
			clk_in : IN STD_LOGIC;
			clk_out : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL sig_DAC,sig_kVal,sig_clkDivided	: STD_LOGIC;
	SIGNAL sig_D 			: STD_LOGIC_VECTOR(3 downto 0);

	BEGIN

		uClkDIV:clkDIV
		GENERIC MAP ( div => 500 )
		PORT MAP (
			clk_in 	=> clk,
			clk_out	=> sig_clkDivided
		);

		uKeyDecode:KeyDecode
			PORT MAP (
			clk  		=> sig_clkDivided,
			reset 		=> reset,
			KEYPAD_LIN	=> KEYPAD_LIN,
			KEYPAD_COL	=> KEYPAD_COL,
			kVal 		=> sig_kVal,
			kAck 		=> sig_DAC,
			K 			=> sig_D
			);

		uKeyTransmitter:KeyTransmitter
			PORT MAP (
			clk		=> sig_clkDivided,
			reset	=> reset,
			TXclk	=> TXclk,
			DAV		=> sig_kVal,
			DAC		=> sig_DAC,
			D		=> sig_D,
			txD		=> TXd
			);
			
END accKeyboardReader;