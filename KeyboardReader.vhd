LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyboardReader is
port(
	clk, reset : in std_logic;
	KEYPAD_LIN, KEYPAD_COL : IN STD_LOGIC_vector(3 downto 0);
	TXd : out std_logic;
	TXclk : in std_logic
	);
end KeyboardReader;


Architecture accKeyboardReader of KeyboardReader is


COMPONENT KeyDecode
	PORT (
    clk, reset : in std_logic;
	KEYPAD_LIN, KEYPAD_COL : IN STD_LOGIC_vector(3 downto 0);
	kVal : out STD_LOGIC;
	kAck : in std_logic;
	K: out std_logic_vector(3 downto 0)
 
	);
END COMPONENT;


COMPONENT KeyTransmitter
	PORT (
    clk, reset : in std_logic;
	D : IN STD_LOGIC_vector(3 downto 0);
	DAC, TCd : out STD_LOGIC;
	DAV : in std_logic;
	TXclk : in std_logic
	);
END COMPONENT;




SIGNAL sig_DAV, sig_DAC : STD_LOGIC;
SIGNAL sig_D : std_logic_vector(3 downto 0);

BEGIN
uKeyDecode:KeyDecode
	PORT MAP(
		clk    =>clk,
		reset => reset,
		kAck => sig_DAC,
		KEYPAD_LIN => KEYPAD_LIN,
		KEYPAD_COL =>KEYPAD_COL,
		kVal =>sig_DAV,
		K =>sig_D
	);
	
uKeyTransmitter:KeyTransmitter
	PORT MAP(
		clk    =>clk,
		reset => reset,
		TXclk => TXclk,
		DAC => sig_DAC,
		DAV => sig_DAV,
		D=>sig_D
		
	);



END accKeyboardReader;