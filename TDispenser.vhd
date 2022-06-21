LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity TDispenser is
port(
	Prt, RT: in std_logic;	
	Sensor : in std_logic;
	Fn : out std_logic;	
	DId, OId : in STD_LOGIC_VECTOR(3 downto 0)	;
	HEX1,HEX3,HEX5 : out STD_LOGIC_VECTOR(7 downto 0) := "11111111"
	);
end TDispenser;


Architecture accTDispenser of TDispenser is


COMPONENT decoderHex
PORT (A: in std_logic_vector(3 downto 0);		
		clear : in std_logic;
		HEX0 : out std_logic_vector(7 downto 0) 
		);
END COMPONENT;

signal M_DId, M_OId  :  std_logic_vector(3 downto 0);
signal M_RT, M_F, M_clear :  std_logic;


BEGIN


Fn <= Sensor;
M_DId <= DId;
M_OId <= OId;
M_RT <= RT ;
HEX1(7)<= NOT(M_RT) when Prt = '1' else '1';

M_clear <= NOT(Prt);

H0:decoderHex PORT MAP(
	A => M_DId ,
	clear => M_clear ,
	HEX0 => HEX5
	);
	 
H2:decoderHex PORT MAP(
	A => M_OId ,
	clear => M_clear ,
	HEX0 => HEX3
	);




END accTDispenser;