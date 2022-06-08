LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyTransmitterControl_tb is
end KeyTransmitterControl_tb;

architecture behavioural of KeyTransmitterControl_tb is

component KeyTransmitterControl is
	PORT(
		clk,DAV,reset,fnsh : in STD_LOGIC;
		DAC,st_tx,enable_counter,reset_counter,wr : out STD_LOGIC
	);
end component;

--UUT signals
constant CLKPeriod : time := 10 ns;

signal CLK_tb,s_DAV,s_DAC,s_sttxD,s_reset,s_fnsh,s_enableC,s_resetC,s_wr: STD_LOGIC;


begin
--Unit Under Test
UUT: KeyTransmitterControl
	PORT MAP(
        clk=>CLK_tb,
        DAV=>s_DAV,
        reset=>s_reset,
        fnsh=>s_fnsh,

		DAC=>s_DAC,
        st_tx=>s_sttxD,
        enable_counter=>s_enableC,
        reset_counter=>s_resetC,
        wr=>s_wr
	);
				
CLK_gen : process
begin
	CLK_tb <= '0';
	wait for CLKPeriod/2;
	CLK_tb <= '1';
	wait for CLKPeriod/2;
end process;

stimulus : process
begin
    s_reset <= '0';
    s_fnsh <= '0';
    s_DAV <= '0';

    wait for CLKPeriod;
    s_DAV <= '1';
	wait for CLKPeriod;
    s_DAV <= '0';
    wait for CLKPeriod;
    s_DAV <= '1';

    s_finsh <= '1';
    wait for CLKPeriod;
    s_reset <= '1';

    wait for CLKPeriod * 3;

    s_DAV <= '0';

    wait for CLKPeriod;

    s_reset <= '0';
    s_fnsh <= '0';

    wait for CLKPeriod;

    s_DAV <= '1';
	
	wait for CLKPeriod;

    --do nothing on state 3

    wait for CLKPeriod*2;
	
    s_DAV <= '0';

	wait for CLKPeriod;

    --wait for counter to reach 6 
	wait for CLKPeriod * 4;

	s_fnsh <= '1';

	wait for CLKPeriod;
	
    s_fnsh <= '0';
	wait;
end process;
end;