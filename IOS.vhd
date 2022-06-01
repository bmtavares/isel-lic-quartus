LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity IOS is
port(
	clk, SCLK, SDX, notSS, Fsh, reset : in std_logic;
	busy : out std_logic;
	wrt,wrl : out STD_LOGIC;
	Dout : out STD_LOGIC_VECTOR(8 downto 0)	
	);
end IOS;


Architecture accIOS of IOS is


COMPONENT SerialReceiver
	PORT (
   clk, SCLK, SDX, notSS, accept, reset : in std_logic;
   busy, DXval : out std_logic;
	D : out std_logic_vector(9 downto 0)
	);
END COMPONENT;


COMPONENT Dispatcher
	port(
		dclk,Fsh,Dval, reset : in STD_LOGIC;
		Din : in STD_LOGIC_VECTOR(9 downto 0);
		wrt,wrl,done : out STD_LOGIC;
		Dout : out STD_LOGIC_VECTOR(8 downto 0)
	);
END COMPONENT;


COMPONENT clkDIV
	GENERIC (div : NATURAL);
	PORT (
		clk_in : IN STD_LOGIC;
		clk_out : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL sig_DXval, sig_done_accept, sig_clkDivided : STD_LOGIC;
SIGNAL sig_D : STD_LOGIC_VECTOR(9 downto 0);

BEGIN

uClkDIV:clkDIV
	GENERIC MAP ( div => 2600000 )
	PORT MAP (
		clk_in 	=> clk,
		clk_out	=> sig_clkDivided
	);

uSerialReceiver:SerialReceiver
	PORT MAP(
		DXval  => sig_DXval,
		D 		 => sig_D,
		notSS  => notSS,
		busy 	 => busy,
		accept => sig_done_accept,
		SCLK 	 => SCLK,
		SDX 	 => SDX,
		clk 	 => clk,
		reset  => reset
	);
	
	
uDispatcher:Dispatcher
	PORT MAP(
		Dout 	=> Dout,
		dclk  => sig_clkDivided,
		Fsh  	=> Fsh,
		Dval 	=> sig_DXval,
		Din	=> sig_D,
		wrt  	=> wrt,
		wrl  	=> wrl,
		done 	=> sig_done_accept,
		reset => reset
	);	


END accIOS;