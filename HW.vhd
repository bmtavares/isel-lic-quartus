LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity HW is
	port (
	clk, Sensor : IN STD_LOGIC;
	LCD_RS, LCD_EN : OUT STD_LOGIC;
	HEX0,HEX1,HEX2,HEX3,HEX4, HEX5 : OUT STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	LCD_DATA : OUT STD_LOGIC_VECTOR(7 downto 0);
	pinsDebug : OUT STD_LOGIC_VECTOR(7 downto 0) := "00000000"
	);
end HW;

Architecture accHW of HW is
	-- Components
	COMPONENT IOS
		PORT (
		clk, SCLK, SDX, notSS, Fsh : in std_logic;
		busy : out std_logic;
		wrt,wrl : out STD_LOGIC;
		Dout : out STD_LOGIC_VECTOR(8 downto 0)
		);
	END COMPONENT;

	COMPONENT UsbPort
		PORT (
		inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT TDispenser
	port(
		Prt, RT: in std_logic;
		Fn : out std_logic;	
		DId, OId : in STD_LOGIC_VECTOR(3 downto 0)	;
		HEX0,HEX1,HEX2,HEX3,HEX4, HEX5 : out STD_LOGIC_VECTOR(7 downto 0) := "11111111";
		Sensor : in std_logic
		);
	end COMPONENT;

	-- Signals
	signal Swrt, Swrl, Sfn : STD_LOGIC;
	signal SinputPort, SoutputPort : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal SDout : STD_LOGIC_VECTOR(8 downto 0);

	BEGIN
		uUsbPort:UsbPort PORT MAP(
			inputPort 	=> SinputPort,
			outputPort 	=> SoutputPort
			);	


		uIOS:IOS PORT MAP(
			clk 	=> clk,
			SCLK 	=> SoutputPort(1),
			SDX 	=> SoutputPort(0),
			notSS => SoutputPort(2),
			Fsh 	=> Sfn,
			busy 	=> SinputPort(3),
			wrt 	=> Swrt,
			wrl 	=> Swrl,     
			Dout 	=> SDout
			);


		uTDispenser:TDispenser PORT MAP(
			Prt 	 => Swrt,
			RT  	 => SDout(0),
			Fn		 => Sfn,
			DId(0) => SDout(4),
			DId(1) => SDout(3),
			DId(2) => SDout(2),
			DId(3) => SDout(1),

			OId(0) => SDout(8),
			OId(1) => SDout(7),
			OId(2) => SDout(6),
			OId(3) => SDout(5),
			HEX0 	 => HEX0,
			HEX1 	 => HEX1,
			HEX2 	 => HEX2,
			HEX3 	 => HEX3,
			HEX4 	 => HEX4, 
			HEX5 	 => HEX5,
			Sensor => Sensor
			);


		--pinsDebug(0) <= Swrt;
		--pinsDebug(1) <= SinputPort(3);


		-- Assignments for LCD
		LCD_EN 	<= Swrl;
		LCD_RS 	<= SDout(0);
		LCD_DATA <= SDout(8 downto 1);

END accHW;