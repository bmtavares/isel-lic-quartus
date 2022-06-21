LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SerialReceiver IS
PORT(
   clk, SCLK, SDX, notSS, accept, reset : in std_logic;
   busy, DXval : out std_logic;
   D : out std_logic_vector(9 downto 0)
);

END SerialReceiver;


ARCHITECTURE behaviour OF SerialReceiver IS

COMPONENT SerialControl
	PORT (
		clk,notSS,accept,pFlag,dFlag,RXerror, reset : in STD_LOGIC;
		wr,init,DXval,busy : out STD_LOGIC
	);
END COMPONENT;

COMPONENT ShiftRegister
	PORT (
		Sin, CLK, enable : in std_logic;
		D : out std_logic_vector(9 downto 0)
	);
END COMPONENT;
	
COMPONENT ParityCheck
	PORT (
		clk,data,init : in std_logic;
		err : out std_logic
	);
END COMPONENT;
	
COMPONENT Counter
	PORT (
		clk,clr : in std_logic;
		out_D : out std_logic_vector(3 downto 0)
	);
END COMPONENT;

SIGNAL sig_pFlag, sig_dFlag, sig_RXerror, sig_wr, sig_init, sig_DXval, sig_busy : STD_LOGIC;
SIGNAL sig_out_D : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL sig_D : STD_LOGIC_VECTOR(9 downto 0);

BEGIN
    uSerialControl:SerialControl PORT MAP(
		clk     => clk,
		notSS   => notSS,
		accept  => accept,
		pFlag   => sig_pFlag,
		dFlag   => sig_dFlag,
		RXerror => sig_RXerror,
		wr 	  => sig_wr,
		init 	  => sig_init,
		DXval   => sig_DXval,
		busy 	  => sig_busy,
		reset   => reset
	);

	uShiftRegister:ShiftRegister PORT MAP(
		Sin => SDX,
		CLK => SCLK,
		enable => sig_wr,
		D => sig_D
	);

	uParityCheck:ParityCheck PORT MAP(
		clk => SCLK,
		data => SDX,
		init => sig_init,
		err => sig_RXerror
	);
	
	uCounter:Counter PORT MAP(
		clk => SCLK,
		clr => sig_init,
		out_D => sig_out_D
	);
	
	sig_dFlag <= '1' when (sig_out_D = "1010" and SCLK = '0')  else '0';
	
	sig_pFlag <= '1' when (sig_out_D = "1011" and SCLK = '0') else '0';
	
	D <= sig_D;
	
	busy <= sig_busy;
	
	DXval <= sig_DXval;
	
END behaviour;