LIBRARY IEEE;
use IEEE.std_logic_1164.all;

ENTITY KeyDecode IS
	PORT(
	clk, reset, kAck	: IN STD_LOGIC;
	KEYPAD_LIN 			: IN STD_LOGIC_VECTOR(3 downto 0);

	kVal 				: OUT STD_LOGIC;
	KEYPAD_COL 			: OUT STD_LOGIC_VECTOR(2 downto 0);
	K					: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END KeyDecode;


Architecture accKeyDecode of KeyDecode is

COMPONENT KeyControl
	PORT (
   	clk, kAck, kPress, reset	: IN STD_LOGIC;

	kVal, kScan					: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT KeyScan
	PORT (
	clk, reset, Kscan	: IN STD_LOGIC;
	KEYPAD_LIN 			: IN STD_LOGIC_VECTOR(3 downto 0);	

	Kpress 				: OUT STD_LOGIC;
	KEYPAD_COL 			: OUT STD_LOGIC_VECTOR(2 downto 0);
	K					: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END COMPONENT;


SIGNAL sig_Kpress, sig_kScan : STD_LOGIC;

BEGIN
	uKeyControl:KeyControl
		PORT MAP (
		clk		=> clk,
		reset	=> reset,
		kVal 	=> kVal,
		kAck 	=> kAck,
		kPress	=> sig_Kpress,
		kScan	=> sig_kScan
		);
		
		
	uKeyScan:KeyScan
		PORT MAP (
		clk			=> clk,
		reset 		=> reset,
		KEYPAD_LIN	=> KEYPAD_LIN, 
		KEYPAD_COL	=> KEYPAD_COL,
		kPress 		=> sig_Kpress,
		Kscan 		=> sig_kScan,
		K 			=> K
		);	

END accKeyDecode;