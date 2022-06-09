LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY KeyScan IS
PORT(	
		KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
		KEYPAD_COL : OUT STD_LOGIC_vector(3 downto 0);		
		K: out std_logic_vector(3 downto 0);
		clk, reset : in std_logic;
		Kscan  : in std_logic;	
		Kpress : out std_logic
		);
END KeyScan;

ARCHITECTURE accKeyScan OF KeyScan IS

signal  L0,L1,L2,L3 :  std_logic;
signal Y1, Y0, C0,C1,C2,C3 :  std_logic;
signal nCLK ,nKscan:  std_logic;
SIGNAL temp_C : unsigned (2 downto 0) := (others => '0');
signal sig0,sig1 : std_logic;
signal sigY0,sigY1 : std_logic;

BEGIN

nCLK <= not clk;
nKscan <= not Kscan;
L0 <= not KEYPAD_LIN(0) ;
L1 <= not KEYPAD_LIN(1) ;
L2 <= not KEYPAD_LIN(2) ;
L3 <= not KEYPAD_LIN(3) ;

--sig0 <= (not temp_C(0) and not temp_C(1)) ;
--sig1 <= temp_C(0);
--temp_C(0) <= sig0 when (rising_edge(nCLK) and Kscan = '1') else temp_C(0);
--temp_C(1) <= sig1 when (rising_edge(nCLK) and Kscan = '1') else temp_C(1);


sig0 <= (not temp_C(0) and not temp_C(1)) when (rising_edge(nCLK) and Kscan = '1') else sig0;
sig1 <= temp_C(0) when (rising_edge(nCLK) and Kscan = '1') else sig1;

temp_C(0) <= sig0 ;
temp_C(1) <= sig1 ;
 
  
  C0 <= '1' when ( sig0 = '0' and sig1 = '0') else '0';
  C1 <= '1' when ( sig0 = '1' and sig1 = '0') else '0';
  C2 <= '1' when ( sig0 = '0' and sig1 = '1') else '0';
  
  C3 <= '1' when (sig0 = '1' and sig1 = '1') else '0'; -- podemos eleminar
  
  KEYPAD_COL(0)  <= not C0  ;
  KEYPAD_COL(1)  <= not C1  ;
  KEYPAD_COL(2)  <= not C2  ;
  KEYPAD_COL(3)  <= not C3  ; -- podemos eleminar
  
--encoder
Y0 <= L1 or L3;
Y1 <= L2 or L3 ;
--end encoder


Kpress <= L0 or L1 or L2 or L3;

sigY0 <= Y0 when rising_edge(nKscan) else sigY0;
sigY1 <= Y1 when rising_edge(nKscan) else sigY1;

K(0) <= sigY0;
K(1) <= sigY1;
K(2) <=  sig0;
K(3) <=  sig1;



END accKeyScan;