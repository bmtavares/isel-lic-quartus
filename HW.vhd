LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity HW is
port(
clk : in std_logic;
HEX0,HEX1,HEX2,HEX3,HEX4, HEX5 : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
pinsDebug : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Sensor : in std_logic
	);
end HW;

Architecture accHW of HW is


COMPONENT IOS
	PORT (
	clk, SCLK, SDX, notSS, Fsh : in std_logic;
	busy : out std_logic;
	wrt,wrl : out STD_LOGIC;
	Dout : out STD_LOGIC_VECTOR(8 downto 0)
	
	);
END COMPONENT;

COMPONENT UsbPort  
	PORT
	(
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



signal Swrt , Swrl ,Sfn : std_logic;
signal SDout :  STD_LOGIC_VECTOR(8 downto 0);
signal SinputPort:    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		SoutputPort :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal teste : STD_LOGIC_VECTOR(7 downto 0) := "11101010";

BEGIN

uUsbPort:UsbPort PORT MAP(
inputPort => SinputPort,
outputPort => SoutputPort
	
	);	

uIOS:IOS PORT MAP(
clk => clk         ,
SCLK => SoutputPort(1)       ,
SDX => SoutputPort(0)          ,
notSS => SoutputPort(2)     ,
Fsh =>   Sfn          ,
busy =>    SinputPort(3)        ,
wrt =>   Swrt    ,
wrl =>     Swrl,     
Dout => SDout
	
	);
	
uTDispenser:TDispenser PORT MAP(
Prt =>   Swrt ,
RT  =>  SDout(0)  ,
Fn 	=>  Sfn,
--DId =>   SDout(4 downto 1) ,
DId(0) => SDout(4),
DId(1) => SDout(3),
DId(2) => SDout(2),
DId(3) => SDout(1),

--OId =>   SDout(8 downto 5) ,
OId(0) => SDout(8),
OId(1) => SDout(7),
OId(2) => SDout(6),
OId(3) => SDout(5),
HEX0 => HEX0 ,
HEX1 => HEX1 ,
HEX2 => HEX2 ,
HEX3 => HEX3 ,
HEX4 => HEX4 , 
HEX5 => HEX5 ,
Sensor =>Sensor
	);
	
pinsDebug(0) <= Swrt;
pinsDebug(1) <= SinputPort(3);

END accHW;