LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY KeyScan IS
	PORT (	
		clk,reset	: IN STD_LOGIC;
		Kscan		: IN STD_LOGIC_VECTOR;
		KEYPAD_LIN	: IN STD_LOGIC_VECTOR(3 downto 0);
		
		Kpress		: OUT STD_LOGIC;
		KEYPAD_COL	: OUT STD_LOGIC_VECTOR(2 downto 0);		
		K			: OUT STD_LOGIC_VECTOR(3 downto 0) := "0000"
	);
END KeyScan;

ARCHITECTURE accKeyScan OF KeyScan IS

	COMPONENT Counter_toT
		PORT (
		clk,clr,enable	: IN STD_LOGIC;

		out_D			: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	END COMPONENT;

	COMPONENT Decoder
		PORT (	
		encoded	: IN STD_LOGIC_VECTOR(1 downto 0);
			
		decoded	: OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	END COMPONENT;

	COMPONENT PriorityEncoder
		PORT (	
		decoded	: IN STD_LOGIC_VECTOR(3 downto 0);
			
		Y	    : OUT STD_LOGIC_VECTOR(1 downto 0);
		GS      : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT RegisterBank
		PORT (
		clk,en  : IN STD_LOGIC;
		d_in    : IN STD_LOGIC_VECTOR(1 downto 0);
			
		q		: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	END COMPONENT;

	SIGNAL nCLK			: STD_LOGIC;
	SIGNAL sig_q,sig_Y,
		   sig_regOut	: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL sig_cols		: STD_LOGIC_VECTOR(2 downto 0);

BEGIN
	usCounter_toT:Counter_toT
		PORT MAP(
		clk => nCLK,
		clr => '0',
		enable => Kscan(0),
		out_D => sig_q
		);	

	uDecoder:Decoder
		PORT MAP(
		encoded => sig_q,
		decoded => sig_cols
		);

	uPriorityEnc:PriorityEncoder
		PORT MAP(
		decoded => KEYPAD_LIN,
		Y 		=> sig_Y,
		GS 		=> Kpress
		);

	uRegister:RegisterBank
		PORT MAP(
		clk  => Kscan(1),
		en	 => '1',
		d_in => sig_Y,
		q	 => sig_regOut
		);

	nCLK   <= not clk;
	
	KEYPAD_COL(0) <= sig_cols(0); 
	KEYPAD_COL(1) <= sig_cols(1);  
	KEYPAD_COL(2) <= sig_cols(2); 

	K(0) <=  sig_regOut(0);
	K(1) <=  sig_regOut(1);
	K(2) <=  sig_q(0);
	K(3) <=  sig_q(1);

END accKeyScan;