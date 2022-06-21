library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY KeyTransmitter IS
	PORT(
		clk,DAV,txClk,reset : in STD_LOGIC;
		D : in STD_LOGIC_VECTOR(3 downto 0);
		DAC,txD : out STD_LOGIC
	);
END KeyTransmitter;

ARCHITECTURE behaviour OF KeyTransmitter IS
	COMPONENT CounterEnable
		PORT (
			clk,clr,en : in std_logic;
			cnt : out std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT KeyTransmitterControl
		PORT (
			clk,DAV,reset,fnsh : in STD_LOGIC;
			DAC,st_tx,enable_counter,reset_counter,wr : out STD_LOGIC
		);
	END COMPONENT;

	COMPONENT RegisterBank
		PORT (
		clk,en  : IN STD_LOGIC;
		d_in    : IN STD_LOGIC_VECTOR(1 downto 0);
			
		q	    : OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	END COMPONENT;

	COMPONENT TxDOutputMux
		PORT (
		selector: IN STD_LOGIC_VECTOR(2 downto 0);
		d_in    : IN STD_LOGIC_VECTOR(3 downto 0);
			
		result  : OUT STD_LOGIC
		);
	END COMPONENT;


	SIGNAL sig_reset_counter, sig_txD, sig_st_tx, sig_enable, sig_fnsh, sig_wr : STD_LOGIC;
	SIGNAL sig_out_D : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	SIGNAL temp_D : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

	BEGIN
		uCounter:CounterEnable PORT MAP(
			clk => txClk,
			clr => sig_reset_counter,
			en => sig_enable,
			cnt => sig_out_D
		);
		
		uStateMachine:KeyTransmitterControl PORT MAP(
			clk => clk,
			DAV => DAV,
			reset => reset,
			fnsh => sig_fnsh,
			
			DAC => DAC,
			st_tx => sig_st_tx,
			enable_counter => sig_enable,
			reset_counter => sig_reset_counter,
			wr => sig_wr
		);

		uRegBank1:RegisterBank
			PORT MAP (
			clk		=> clk,
			en		=> sig_wr,
			d_in(0) => D(0),
			d_in(1) => D(1),
			q(0)    => temp_D(0),
			q(1)    => temp_D(1)
			);

		uRegBank2:RegisterBank
			PORT MAP (
			clk		=> clk,
			en		=> sig_wr,
			d_in(0) => D(2),
			d_in(1) => D(3),
			q(0)    => temp_D(2),
			q(1)    => temp_D(3)
			);

		uMux:TxDOutputMux
			PORT MAP (
			selector => sig_out_D,
			d_in     => temp_D,
			result   => sig_txD
			);
		
		sig_fnsh <= '1' when sig_out_D = "111" else '0';

		txD <= sig_txD OR sig_st_tx;
	

END behaviour;