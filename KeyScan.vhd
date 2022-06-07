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

signal QA1, QA0, L0,L1,L2,L3 :  std_logic;
signal Y1, Y0, C0,C1,C2,C3 :  std_logic;
signal nCLK :  std_logic;
SIGNAL temp_C : unsigned (2 downto 0) := (others => '0');
signal sig0,sig1 : std_logic;
signal sigY0,sigY1 : std_logic;
BEGIN


nCLK <= not clk;
nKscan <= not Kscan;
L0 <= KEYPAD_LIN(0) ;
L1 <= KEYPAD_LIN(1) ;
L2 <= KEYPAD_LIN(2) ;
L3 <= KEYPAD_LIN(3) ;

 process (nCLK, reset,temp_C) is	
 begin  -- process
    if reset = '1' then                   -- asynchronous reset (active high)
      temp_C <= "000";
    elsif rising_edge(nCLK) then  -- rising clock edge
      temp_C(0) <= sig0;
      temp_C(1) <= sig1;
    end if;
  end process;
  
  sig0 <= (not temp_C(0) and not temp_C(1)) ;
  sig1 <= temp_C(0);
  
  QA0 <= temp_C(0); 
  QA1 <= temp_C(1); 
  
  
  C0 <= '1' when (QA0 = '0' and QA1 = '0') else '0';
  C1 <= '1' when (QA0 = '1' and QA1 = '0') else '0';
  C2 <= '1' when (QA0 = '0' and QA1 = '1') else '0';
  C3 <= '1' when (QA0 = '1' and QA1 = '1') else '0'; -- podemos eleminar
  
  KEYPAD_COL(0)  <= C0  ;
  KEYPAD_COL(1)  <= C1  ;
  KEYPAD_COL(2)  <= C2  ;
  KEYPAD_COL(3)  <= C3  ; -- podemos eleminar
  
--encoder
Y0 <= L1 or L3;
Y1 <= L2 or L3 ;
--end encoder


Kpress <= L0 or L1 or L2 or L3;
sigY0 <= Y0 when rising_edge(nKscan) else sigY0;
sigY1 <= Y1 when rising_edge(nKscan) else sigY1;

K(0) <= QA0;
K(1) <= QA1;
K(2) <=  sigY0;
K(3) <=  sigY1;



END accKeyScan;