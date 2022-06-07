LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyDecode is
port(
	clk, reset : in std_logic;
		KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
		KEYPAD_COL : OUT STD_LOGIC_vector(3 downto 0);
	kVal : out STD_LOGIC;
	kAck : in std_logic;
	K: out std_logic_vector(3 downto 0)
	);
end KeyDecode;


Architecture accKeyDecode of KeyDecode is


COMPONENT KeyControl
	PORT (
   		clk,kAck,kPress,reset : in STD_LOGIC;
		kVal,kScan : out STD_LOGIC
	);
END COMPONENT;


COMPONENT KeyScan
	port(
		KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
		KEYPAD_COL : OUT STD_LOGIC_vector(3 downto 0);		
		Kscan  : in std_logic;	
		K: out std_logic_vector(3 downto 0);
		clk, reset : in std_logic;
		Kpress : out std_logic
	);
END COMPONENT;




SIGNAL sig_Kpress, sig_kScan : STD_LOGIC;


BEGIN



uKeyControl:KeyControl
	PORT MAP(
		clk    =>clk,
		reset => reset,
		kVal => kVal,
		kAck => kAck,
		kPress => sig_Kpress,
		kScan => sig_kScan
		
	);
	
	
uKeyScan:KeyScan
	PORT MAP(
		clk    =>clk,
		reset => reset,
		KEYPAD_LIN => KEYPAD_LIN, 
		KEYPAD_COL => KEYPAD_COL,
		kPress => sig_Kpress,
		Kscan => sig_kScan,
		K => K
	);	


END accKeyDecode;