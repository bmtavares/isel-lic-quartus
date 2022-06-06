LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;

ENTITY KeyScan IS
PORT(	
		KEYPAD_LIN, KEYPAD_COL : IN STD_LOGIC_vector(3 downto 0);			
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
C0 <= KEYPAD_COL(0) ;
C1 <= KEYPAD_COL(1) ;
C2 <= KEYPAD_COL(2) ;
C3 <= KEYPAD_COL(3) ;

L0 <= KEYPAD_LIN(0) ;
L1 <= KEYPAD_LIN(1) ;
L2 <= KEYPAD_LIN(2) ;
L3 <= KEYPAD_LIN(3) ;

 process (clk, reset,temp_C) is	
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
  
  
  
  
  
  
process (QA0,QA1,L0,L1,L2,L3) is
begin
--Decoder linhas
 if (QA0 ='0' and QA1 = '0') then
 L0 <= '1';
 elsif (QA0 ='1' and QA1 = '0') then
 L1 <= '1';
 elsif (QA0 ='0' and QA1 = '1') then
 L2 <= '1';
 else
 L3 <= '1';
 end if;  
 --END Decoder linhas 
end process;
--encoder
Y0 <= C1 or C2;
Y1 <= C1 or C3;
--end encoder


Kpress <= C0 or C1 or C2 or C3;
sigY0 <= Y0 when rising_edge(Kscan) else sigY0;
sigY1 <= Y1 when rising_edge(Kscan) else sigY1;

K(0) <= QA0;
K(1) <= QA1;
K(2) <=  sigY0;
K(3) <=  sigY1;



END accKeyScan;