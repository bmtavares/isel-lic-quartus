LIBRARY IEEE;
use IEEE.std_logic_1164.all;

ENTITY KeyboardReader IS
	PORT (
	clk, reset, TXclk	: IN  STD_LOGIC;
	KEYPAD_LIN 			: IN  STD_LOGIC_VECTOR(3 downto 0);	
	TXd, DBUG			: OUT STD_LOGIC;
	KEYPAD_COL 			: OUT STD_LOGIC_VECTOR(2 downto 0)
	);
END KeyboardReader;

Architecture accKeyboardReader of KeyboardReader is

	COMPONENT KeyDecode
		PORT (
		clk, reset, kAck	: IN  STD_LOGIC;
		KEYPAD_LIN 			: IN  STD_LOGIC_VECTOR(3 downto 0);	
		kVal 				: OUT STD_LOGIC;
		KEYPAD_COL 			: OUT STD_LOGIC_VECTOR(2 downto 0);
		K					: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;

	COMPONENT KeyTransmitter
		PORT (
		clk, reset : in std_logic;
		D : IN STD_LOGIC_vector(3 downto 0);
		DAC : out STD_LOGIC;
		DAV : in std_logic;
		TXclk : in std_logic;
		txD:out STD_LOGIC
		);
	END COMPONENT;

	SIGNAL sig_DAC, sig_kVal 	: STD_LOGIC;
	SIGNAL sig_D 				: STD_LOGIC_VECTOR(3 downto 0);

	BEGIN
		uKeyDecode:KeyDecode
			PORT MAP (
			clk  		=> clk,
			reset 		=> reset,
			KEYPAD_LIN	=> KEYPAD_LIN,
			KEYPAD_COL	=> KEYPAD_COL,
			kVal 		=> sig_kVal,
			kAck 		=> sig_DAC,
			K 			=> sig_D
			);

		DBUG <= sig_kVal;

		uKeyTransmitter:KeyTransmitter
			PORT MAP(
			clk		=> clk,
			reset	=> reset,
			TXclk	=> TXclk,
			DAV		=> sig_kVal,
			DAC		=> sig_DAC,
			D		=> sig_D,
			txD		=> TXd
			);
			
END accKeyboardReader;