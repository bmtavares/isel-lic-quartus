----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:50:55 05/18/2020 
-- Design Name: 
-- Module Name:    KeyboardReaderWrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KeyboardReaderWrapper is
    Port (
         CLK 	: IN  std_logic;
			RESET : IN std_logic;
         KLINS : IN  std_logic_vector(3 downto 0);
         ACK 	: IN  std_logic;
         KCOLS : OUT  std_logic_vector(2 downto 0);
         D 		: OUT  std_logic_vector(3 downto 0);
         DVAL 	: OUT  std_logic
        );
end KeyboardReaderWrapper;

architecture Behavioral of KeyboardReaderWrapper is

    COMPONENT KeyDecode
	PORT (
    clk, reset : in std_logic;
	KEYPAD_LIN : IN STD_LOGIC_vector(3 downto 0);	
	KEYPAD_COL : OUT STD_LOGIC_vector(2 downto 0); 
	kVal : out STD_LOGIC;
	kAck : in std_logic;
	K: out std_logic_vector(3 downto 0)
 
	);
	END COMPONENT;


	-- COMPONENT key_decode
	-- PORT(
	-- 	CLK : IN std_logic;
	-- 	RESET : IN std_logic;
	-- 	KLINS : IN std_logic_vector(3 downto 0);
	-- 	KACK : IN std_logic;          
	-- 	KCOLS : OUT std_logic_vector(2 downto 0);
	-- 	K : OUT std_logic_vector(3 downto 0);
	-- 	KVAL : OUT std_logic
	-- 	);
	-- END COMPONENT;
	
begin

	Inst_key_decode: KeyDecode PORT MAP(
		CLK => CLK,
		RESET => RESET,
		KEYPAD_LIN => KLINS,
		KACK => ACK,
		KEYPAD_COL => KCOLS,
		K => D,
		KVAL => DVAL
	);

end Behavioral;

