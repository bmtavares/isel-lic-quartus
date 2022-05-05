LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity IOS is
port(
	clk, SCLK, SDX, notSS, Fsh : in std_logic;
	busy : out std_logic;
	wrt,wrl : out STD_LOGIC;
	Dout : out STD_LOGIC_VECTOR(8 downto 0)	
	);
end IOS;


Architecture accIOS of IOS is


COMPONENT SerialReceiver
	PORT (
   clk, SCLK, SDX, notSS, accept : in std_logic;
   busy, DXval : out std_logic;
	D : out std_logic_vector(9 downto 0)
	);
END COMPONENT;


COMPONENT Dispatcher
	port(
		clk,Fsh,Dval : in STD_LOGIC;
		Din : in STD_LOGIC_VECTOR(9 downto 0);
		wrt,wrl,done : out STD_LOGIC;
		Dout : out STD_LOGIC_VECTOR(8 downto 0)
	);
END COMPONENT;

SIGNAL sig_DXval, sig_done_accept : STD_LOGIC;
SIGNAL sig_D : STD_LOGIC_VECTOR(9 downto 0);

BEGIN


uSerialReceiver:SerialReceiver PORT MAP(
	DXval => sig_DXval,
	D => sig_D,
	notSS => notSS,
	busy => busy,
	accept => sig_done_accept,
	SCLK =>SCLK,
	SDX => SDX,
	clk => clk
	);
	
	
uDispatcher:Dispatcher PORT MAP(
	Dout =>  Dout,
	clk  =>   clk,
	Fsh  =>   Fsh,
	Dval => sig_DXval,
	Din	 =>   sig_D,
	wrt  =>   wrt,
	wrl  =>   wrl,
	done =>  sig_done_accept 
	
	);	


END accIOS;