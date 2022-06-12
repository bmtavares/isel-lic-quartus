--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:41:03 05/18/2020
-- Design Name:   
-- Module Name:   KeyboardReader_tb.vhd
-- Project Name:
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: KeyboardReaderWrapper
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY keyboardReaderWrapper_tb IS
END keyboardReaderWrapper_tb;
 
ARCHITECTURE behavior OF keyboardReaderWrapper_tb IS 
 
	impure function random(min, max : integer) return integer is
		variable v : real;
		variable seeda, seedb : integer := 5;
	begin
		uniform(seeda, seedb, v);
		return integer( round(v * real(max - min + 1) + real(min) - 0.5) );
	end function;

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT KeyboardReaderWrapper
		PORT(
			CLK 	: IN  std_logic;
			RESET : IN std_logic;
			KLINS : IN  std_logic_vector(3 downto 0);
			ACK 	: IN  std_logic;
			KCOLS : OUT  std_logic_vector(2 downto 0);
			D 		: OUT  std_logic_vector(3 downto 0);
			DVAL 	: OUT  std_logic
		);
	END COMPONENT;


	--Inputs
	signal CLK 	 : std_logic := '0';
	signal RESET : std_logic := '0';
	signal KLINS : std_logic_vector(3 downto 0) := (others => '1');
	signal ACK 	 : std_logic := '0';

		--Outputs
	signal KCOLS : std_logic_vector(2 downto 0);
	signal D 	 : std_logic_vector(3 downto 0);
	signal DVAL  : std_logic;

	-- Time unit definition
	constant Time_unit : time := 1ns;

	-- Clock period definitions
	constant CLK_period : time := 10 * Time_unit;
	constant RESET_DURATION : time := 100 * Time_unit;
	
	-- Key generation timing values
	constant Base_key_rotation_period : time := (CLK_period * 40);
	constant Base_key_down_time : time := (CLK_period * 10);

	-- Controls the random value interval
	-- values will be in the range [base_value - variation * base_value, base_value + variation * base_value]
	constant Key_rotation_period_variation : real := 0.1;
	constant Base_key_down_time_variation : real := 0.1;
	
	-- Minimum delays between DVAL and ACK transitions
	constant Dval_rising_to_ack_rising_delay : time := (CLK_period * 10);
	constant Dval_falling_to_ack_falling_delay : time := (CLK_period * 10);
	
	-- Keyboard types (do not change)
	TYPE key IS ('U', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '#');
	TYPE key_vector is array(integer range <>) of key;
	TYPE keyboard_matrix_type is array(0 to 2) of key_vector(0 to 3);

	-- converts key to the expected binary value (std_logic_vector) (do not change)
	function keyboard_mapping (input : key) return std_logic_vector is
		variable keycode : std_logic_vector(3 downto 0);
	begin
		case (input) is
			when '1' =>
				keycode := "0000";
			when '2' =>
				keycode := "0100";
			when '3' =>
				keycode := "1000";
			when '4' =>
				keycode := "0001";
			when '5' =>
				keycode := "0101";
			when '6' =>
				keycode := "1001";
			when '7' =>
				keycode := "0010";
			when '8' =>
				keycode := "0110";
			when '9' =>
				keycode := "1010";
			when '0' =>
				keycode := "0111";
			when '*' =>
				keycode := "0011";
			when '#' =>
				keycode := "1011";
			when others =>
				keycode := "XXXX";
		end case;
		return keycode;
	end keyboard_mapping;

	-- Keyboard layout (do not change)
	signal keyboard_layout_by_columns : keyboard_matrix_type := ("147*", "2580", "369#"); 
	
	-- Signals needed for the simulation (do not change)
	signal current_key, last_key_pressed : key;
	signal keys_in_column : key_vector(0 to 3) := (others => 'U');
	signal rows_value : std_logic_vector(3 downto 0);
	signal do_check : std_logic := '0';

	-- Key presses to be simulated (choose the order and amount wanted)
	signal keys : key_vector(0 to 11) := "0123456789*#";

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: KeyboardReaderWrapper PORT MAP (
			CLK => CLK,
			RESET => RESET,
			KLINS => KLINS,
			ACK => ACK,
			KCOLS => KCOLS,
			D => D,
			DVAL => DVAL
		);

-- initial checks process
	checks_process: process
	begin
		assert RESET_DURATION > (CLK_period * 2)
		report "The duration of the reset signal (RESET_DURATION) should be larger than twice the clock period (CLK_period)" 
		severity FAILURE;
		
		assert Base_key_down_time > CLK_period
		report "The duration of a key press (KEY_down_time) should be larger than clock period (CLK_period)" 
		severity FAILURE;
		
		assert Base_key_down_time < Base_key_rotation_period
		report "The duration of a key press (KEY_down_time) should be smaller than the simulation time for automatically switching to the next key (KEY_rotation_period)" 
		severity FAILURE;
		
		wait;
	end process;

	-- Clock process definitions
	CLK_process: process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;


	-- Key generation process
	Key_generation_process: process
		variable random_key_rotation, random_key_down : integer;
		variable random_key_rotation_min, random_key_rotation_max : integer;
		variable random_key_down_min, random_key_down_max : integer;
	begin
		random_key_rotation_min := integer (round( -real((Base_key_rotation_period / Time_unit)) * Key_rotation_period_variation));
		random_key_rotation_max := integer (round( real((Base_key_rotation_period / Time_unit)) * Key_rotation_period_variation));
		random_key_down_min := integer (round( -real(Base_key_down_time / Time_unit) * Base_key_down_time_variation));
		random_key_down_max := integer (round( real(Base_key_down_time / Time_unit) * Base_key_down_time_variation));
	   wait for RESET_DURATION + Base_key_rotation_period/2;
		current_key <= 'U';
		for i in keys'range loop
			random_key_rotation := random(random_key_rotation_min, random_key_rotation_max);
			random_key_down := random(random_key_down_min, random_key_down_max);
		   current_key <= 'U';
			wait for (Base_key_rotation_period + random_key_rotation * Time_unit ) - (Base_key_down_time + random_key_down * Time_unit);
			current_key <= keys(i);
			wait for (Base_key_down_time + random_key_down * Time_unit);
		end loop;
		wait;
	end process;
	
	-- Column keys selection process
	Column_keys: process(KCOLS)
	begin
		case (KCOLS) is
			when "110" =>
				keys_in_column <= keyboard_layout_by_columns(0);
			when "101" =>
				keys_in_column <= keyboard_layout_by_columns(1);
			when "011" =>
				keys_in_column <= keyboard_layout_by_columns(2);
			when others =>
				keys_in_column <= (others => 'U');
		end case;
	end process;
	
	-- Row input generation process
	Row_input_calculation: process(keys_in_column, current_key)
		variable tmp_row_value : std_logic_vector(3 downto 0) := (others => '1');
	begin
		tmp_row_value := (others => '1');
		if (current_key /= 'U') then
			for j in keys_in_column'range loop
				if keys_in_column(j) = current_key then
					tmp_row_value(j) := '0';
					exit;
				end if;
			end loop;
		end if;
		rows_value <= tmp_row_value;
	end process;
	
	KLINS <= rows_value;
	
	-- generate reset signal
	reset_proc: process
	begin		
		-- hold reset state for RESET_DURATION.
		RESET <= '1';
		wait for RESET_DURATION;	
		RESET <= '0';
		wait;
	end process;


	-------------------------------- Validation	-----------------------------------------
	
	-- Save last pressed key for validation purposes
	Save_key_process: process(current_key, ACK)
	begin
		if (current_key'event and current_key /= 'U') then
		   assert last_key_pressed = 'U'
			report "The last key was not acknowledged... (current time" & time'image(now) & ")"
			severity warning;
			last_key_pressed <= current_key;
		elsif (ACK'event and ACK = '1') then
			last_key_pressed <= 'U';
		end if;
	end process;
	
	-- determine when a new check should be done on the outputs
	Keycode_check_process: process(DVAL)
	begin
		if (rising_edge(DVAL)) then
			do_check <= '1';
		elsif (falling_edge(DVAL)) then
			do_check <= '0';
		end if;
	end process;

	-- check output values and generate ACK
	ack_gen_check_process: process
		variable idle_time : Time := CLK_period * 2;
		variable previous_do_check : std_logic := '0';
	begin
		loop
			wait for idle_time;
			if (do_check = '1' and previous_do_check = '0') then
				previous_do_check := do_check;
				assert D = keyboard_mapping(last_key_pressed)
				report "The ouput code does not match the expected key code of the pressed key... (current time" & time'image(now) & ")"
				severity FAILURE;
				wait for Dval_rising_to_ack_rising_delay;
				ACK <= '1';
				loop
					wait for idle_time;
					if (DVAL = '0') then
						wait for Dval_falling_to_ack_falling_delay;
						ACK <= '0';
						previous_do_check := '0';
						exit;
					end if;
				end loop;
			end if;
		end loop;
	end process;

END;
