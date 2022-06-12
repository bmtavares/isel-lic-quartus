LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY KeyScan IS
PORT(	
		KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
		KEYPAD_COL : OUT STD_LOGIC_vector(2 downto 0);		
		K: out std_logic_vector(3 downto 0);
		clk, reset : in std_logic;
		Kscan  : in std_logic;	
		Kpress : out std_logic
		);
END KeyScan;

ARCHITECTURE accKeyScan OF KeyScan IS

signal  L0,L1,L2,L3 :  std_logic;
signal Y1, Y0:  std_logic;
signal nCLK ,nKscan:  std_logic;
SIGNAL out_d : STD_LOGIC_vector (2 downto 0) ;
SIGNAL Q : STD_LOGIC_vector (1 downto 0) ;
signal sig0,sig1 : std_logic;
signal sigY0,sigY1 : std_logic;

	COMPONENT Counter_toT
		PORT (
	clk,clr,enable : in std_logic;
	out_D : out std_logic_vector(1 downto 0)
		);
	END COMPONENT;




BEGIN

usCounter_toT:Counter_toT PORT MAP(
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





--dec
KEYPAD_COL(0) <= '0' when ( Q(0) = '0' and Q(1) = '0') else '1'; 
KEYPAD_COL(1) <= '0' when ( Q(0) = '1' and Q(1) = '0') else '1';  
KEYPAD_COL(2) <= '0' when ( Q(0) = '0' and Q(1) = '1') else '1'; 


                    
--encoder
Y0 <= L1 or L3;
Y1 <= L2 or L3 ;
--end encoder


Kpress <= L0 or L1 or L2 or L3;

sigY0 <= Y0 when rising_edge(nKscan) else sigY0;
sigY1 <= Y1 when rising_edge(nKscan) else sigY1;

K(0) <= sigY0;
K(1) <= sigY1;
K(2) <=  Q(0);
K(3) <=  Q(1);



END accKeyScan;