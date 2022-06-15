LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY KeyScan IS
	PORT (	
		clk,reset,Kscan	: IN STD_LOGIC;
		KEYPAD_LIN		: IN STD_LOGIC_VECTOR(3 downto 0);
		
		Kpress			: OUT STD_LOGIC;
		KEYPAD_COL		: OUT STD_LOGIC_VECTOR(2 downto 0);		
		K				: OUT STD_LOGIC_VECTOR(3 downto 0) := "0000"
	);
END KeyScan;

ARCHITECTURE accKeyScan OF KeyScan IS

	COMPONENT Counter_toT
		PORT (
		clk,clr,enable	: IN STD_LOGIC;

		out_D			: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	END COMPONENT;


	SIGNAL L0,L1,L2,L3	: STD_LOGIC;
	SIGNAL Y1, Y0		: STD_LOGIC;
	SIGNAL nCLK ,nKscan	: STD_LOGIC;
	SIGNAL out_d		: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL Q			: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL sig0,sig1	: STD_LOGIC;
	SIGNAL sigY0,sigY1	: STD_LOGIC := '0';

BEGIN
	usCounter_toT:Counter_toT
		PORT MAP(
		clk => nCLK,
		clr => '0',
		enable => Kscan,
		out_D => Q
		);	

	nCLK <= not clk ;
	nKscan <= not Kscan;
	L0 <= not KEYPAD_LIN(0) ;
	L1 <= not KEYPAD_LIN(1) ;
	L2 <= not KEYPAD_LIN(2) ;
	L3 <= not KEYPAD_LIN(3) ;

	--TODO: Não esquecer que os active lows são feitos dentro dos modulos

	--TODO: Refazer decoder
	--dec
	KEYPAD_COL(0) <= '0' when ( Q(0) = '0' and Q(1) = '0') else '1'; 
	KEYPAD_COL(1) <= '0' when ( Q(0) = '1' and Q(1) = '0') else '1';  
	KEYPAD_COL(2) <= '0' when ( Q(0) = '0' and Q(1) = '1') else '1'; 
	--end dec

	--TODO:Refazer priority enc
	--encoder
	Y0 <= L1 or L3;
	Y1 <= L2 or L3 ;
	--end encoder

	--TODO: Meter isto como GS do penc
	Kpress <= L0 or L1 or L2 or L3;

	sigY0 <= Y0 when rising_edge(nKscan) else sigY0;
	sigY1 <= Y1 when rising_edge(nKscan) else sigY1;

	K(0) <= sigY0;
	K(1) <= sigY1;
	K(2) <=  Q(0);
	K(3) <=  Q(1);

END accKeyScan;