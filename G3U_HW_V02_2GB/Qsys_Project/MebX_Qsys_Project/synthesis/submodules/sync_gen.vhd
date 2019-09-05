--=============================================================================
--! @file sync_gen.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
use work.sync_gen_pkg.all;
use work.sync_common_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync generator (sync_gen)
--
--! @brief 
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Cassio Berni (ccberni@hotmail.com)
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--! 08\11\2018 CB Module optimization & revision\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for sync generator
--============================================================================
entity sync_gen is
	generic (
		g_SYNC_COUNTER_WIDTH : natural range 0 to c_SYNC_COUNTER_MAX_WIDTH := c_SYNC_COUNTER_WIDTH;
		g_SYNC_CYCLE_NUMBER_WIDTH : natural := c_SYNC_CYCLE_NUMBER_WIDTH;
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY
	);
	port (
		clk_i      : in  std_logic;
		reset_n_i  : in  std_logic;
		control_i  : in  t_sync_gen_control;
		config_i   : in  t_sync_gen_config;
		err_inj_i  : in  t_sync_gen_error_injection;
	
		status_o   : out t_sync_gen_status;
		sync_gen_o : out std_logic
	);
end entity sync_gen;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_gen is

	-- Machine states
	type t_sync_gen_state is (
		IDLE,
		R_BLANK,
		R_RELEASE,
		ONE_SHOT,
		E_BLANK,
		E_RELEASE
	);

	-- current state
	signal s_sync_gen_state			: t_sync_gen_state;
	-- main counter
	signal s_sync_cnt				: std_logic_vector((g_SYNC_COUNTER_WIDTH - 1) downto 0);
	-- actual blank value
	signal s_sync_blank				: std_logic_vector((g_SYNC_COUNTER_WIDTH - 1) downto 0);
	-- cycle counter
	signal s_sync_cycle_cnt			: natural range 0 to ((2 ** g_SYNC_CYCLE_NUMBER_WIDTH) - 1);
	-- registered config record
	signal s_registered_configs		: t_sync_gen_config;

--============================================================================
-- architecture begin
--============================================================================
begin
	--=============================================================================
	-- Begin of sync gen fsm
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, reset_n_i
	-- write:
	-- r/w: s_sync_gen_state
	p_sync_gen_fsm_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_sync_gen_state                  		<= IDLE;
			s_sync_cnt				              	<= (others => '0');
			s_sync_blank		              		<= (others => '0');
			s_sync_cycle_cnt		          		<= 0;
			s_registered_configs.master_blank_time	<= (others => '0');
			s_registered_configs.blank_time 		<= (others => '0');
			s_registered_configs.period 			<= (others => '0');
			s_registered_configs.one_shot_time		<= (others => '0');
			s_registered_configs.signal_polarity	<= not g_SYNC_DEFAULT_STBY_POLARITY;
			s_registered_configs.number_of_cycles	<= (others => '0');
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_sync_gen_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a start/one_shot/err_inj is received
					-- default state transition
					s_sync_gen_state                  		<= IDLE;
					-- default internal signal values
					s_sync_cnt			              		<= (others => '0');
					s_sync_blank		              		<= config_i.master_blank_time;
					s_sync_cycle_cnt		          		<= 0;
					s_registered_configs.master_blank_time	<= (others => '0');
					s_registered_configs.blank_time 		<= (others => '0');
					s_registered_configs.period 			<= (others => '0');
					s_registered_configs.one_shot_time		<= (others => '0');
					s_registered_configs.signal_polarity	<= not g_SYNC_DEFAULT_STBY_POLARITY;
					s_registered_configs.number_of_cycles	<= (others => '0');
					-- conditional state transition and internal signal values
					-- check if a start was received
					if (control_i.start = '1') then
						-- go to running blank state
						s_sync_gen_state      <= R_BLANK;
						-- update configurations
						s_registered_configs  <= config_i;
					-- check if a one_shot was received
					elsif (control_i.one_shot = '1') then
						-- go to one_shot state
						s_sync_gen_state      <= ONE_SHOT;
						-- update configurations
						s_registered_configs  <= config_i;
					-- check if a err_inj was received
					elsif (control_i.err_inj = '1') then
						-- go to error blank state
						s_sync_gen_state      <= E_BLANK;
						-- update configurations
						s_registered_configs  <= config_i;
					end if;

				-- state "R_BLANK"
				when R_BLANK =>
					-- blank pulse of the sync signal
					-- default state transition
					s_sync_gen_state      <= R_BLANK;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reset command was received
					if (control_i.reset = '1') then
						-- reset received, return to IDLE
						s_sync_gen_state <= IDLE;
					else
						-- check if the blank value was reached
						if (s_sync_cnt = s_sync_blank) then
							-- blank value reached, check cycle and update s_sync_blank
							if (unsigned(s_registered_configs.number_of_cycles) <= 1) then
								-- ok, only one cycle, s_sync_blank already contains MBT
								s_sync_cycle_cnt <= 0;
								s_sync_blank <= s_registered_configs.master_blank_time;
								-- goto to R_RELEASE state
								s_sync_gen_state <= R_RELEASE;
							else
								-- more than one cycle, check upper limit of cycle counter
								if (s_sync_cycle_cnt = (unsigned(s_registered_configs.number_of_cycles) - 1)) then
									-- upper limit reached
									-- reset cycle counter
									s_sync_cycle_cnt <= 0;
									-- return to master blank time
									s_sync_blank <= s_registered_configs.master_blank_time;
								else	
									-- keep cycle counting
									s_sync_cycle_cnt <= s_sync_cycle_cnt + 1;
									s_sync_blank <= s_registered_configs.blank_time;
								end if;								
							-- goto to R_RELEASE state
							s_sync_gen_state <= R_RELEASE;
							end if;							
						else
							-- keep counting
							s_sync_cnt <= std_logic_vector(unsigned(s_sync_cnt) + 1);
						end if;
					end if;

				-- state "R_RELEASE"
				when R_RELEASE =>
					-- release pulse of the sync signal 
					-- default state transition
					s_sync_gen_state      <= R_RELEASE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reset command was received
					if (control_i.reset = '1') then
						-- reset received, return to IDLE
						s_sync_gen_state <= IDLE;
					else
						-- check if the period was reached
						if (s_sync_cnt = std_logic_vector(unsigned(s_registered_configs.period) - 1)) then
							-- pulse period reached
							-- reset sync counter
							s_sync_cnt <= (others => '0');
							-- go to R_BLANK state
							s_sync_gen_state    <= R_BLANK;
						else
							-- keep counting
							s_sync_cnt <= std_logic_vector(unsigned(s_sync_cnt) + 1);
						end if;
					end if;

				-- state "ONE_SHOT"
				when ONE_SHOT =>
					-- one shot blank pulse of the sync signal 
					-- default state transition
					s_sync_gen_state      <= ONE_SHOT;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reset command was received
					if (control_i.reset = '1') then
						-- reset received, return to IDLE
						s_sync_gen_state <= IDLE;
					else
						-- check if the one shot time was reached
						if (s_sync_cnt = std_logic_vector(unsigned(s_registered_configs.one_shot_time) - 1)) then
							-- one_shot_time reached
							-- reset sync counter
							s_sync_cnt <= (others => '0');
							-- return to IDLE state
							s_sync_gen_state    <= IDLE;
						else
							-- keep counting
							s_sync_cnt <= std_logic_vector(unsigned(s_sync_cnt) + 1);
						end if;
					end if;

				-- state "E_BLANK"
				when E_BLANK =>
					-- error blank pulse of the sync signal
					-- default state transition
					s_sync_gen_state      <= E_BLANK;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reset command was received
					if (control_i.reset = '1') then
						-- reset received, return to IDLE
						s_sync_gen_state <= IDLE;
					else
						-- check if the blank value was reached
						if (s_sync_cnt = s_sync_blank) then
							-- blank value reached, check cycle and update s_sync_blank
							if (unsigned(s_registered_configs.number_of_cycles) <= 1) then
								-- ok, only one cycle, s_sync_blank already contains MBT
								s_sync_cycle_cnt <= 0;
								s_sync_blank <= s_registered_configs.master_blank_time;
								-- goto to E_RELEASE state
								s_sync_gen_state <= E_RELEASE;
							else
								-- more than one cycle, check upper limit of cycle counter
								if (s_sync_cycle_cnt = (unsigned(s_registered_configs.number_of_cycles) - 1)) then
									-- upper limit reached
									-- reset cycle counter
									s_sync_cycle_cnt <= 0;
									-- return to master blank time
									s_sync_blank <= s_registered_configs.master_blank_time;
								else	
									-- keep cycle counting
									s_sync_cycle_cnt <= s_sync_cycle_cnt + 1;
									s_sync_blank <= s_registered_configs.blank_time;
								end if;								
							-- goto to E_RELEASE state
							s_sync_gen_state <= E_RELEASE;
							end if;							
						else
							-- keep counting
							s_sync_cnt <= std_logic_vector(unsigned(s_sync_cnt) + 1);
						end if;
					end if;

				-- state "E_RELEASE"
				when E_RELEASE =>
					-- error release pulse of the sync signal 
					-- default state transition
					s_sync_gen_state      <= E_RELEASE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reset command was received
					if (control_i.reset = '1') then
						-- reset received, return to IDLE
						s_sync_gen_state <= IDLE;
					else
						-- check if the period was reached
						if (s_sync_cnt = std_logic_vector(unsigned(s_registered_configs.period) - 1)) then
							-- pulse period reached
							-- reset sync counter
							s_sync_cnt <= (others => '0');
							-- go to E_BLANK state
							s_sync_gen_state    <= E_BLANK;
						else
							-- keep counting
							s_sync_cnt <= std_logic_vector(unsigned(s_sync_cnt) + 1);
						end if;
					end if;

				-- not defined state
				when others =>
					s_sync_gen_state	<= IDLE;

			end case;
		end if;
	end process p_sync_gen_fsm_state;

	--=============================================================================
	-- Begin of sync gen fsm
	-- (output generation)
	--=============================================================================
	-- read: s_sync_gen_state, reset_n_i
	-- write:
	-- r/w:
	p_sync_gen_fsm_output : process(s_sync_gen_state, reset_n_i, s_registered_configs, s_sync_cycle_cnt)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
			sync_gen_o								<= not s_registered_configs.signal_polarity;
			status_o.state	 						<= (others => '0');
			status_o.cycle_number					<= (others => '0');
		else
			-- Ensure default status_o condition before case, to avoid latches
			status_o.state	 						<= (others => '0');
			status_o.cycle_number					<= (others => '0');
			
			case (s_sync_gen_state) is

				-- state "IDLE"
				when IDLE =>
					sync_gen_o						<= not s_registered_configs.signal_polarity;
					-- state: idle = 0
					status_o.state					<= (others => '0');
					status_o.cycle_number			<= (others => '0');

				-- state "R_BLANK"
				when R_BLANK =>
					sync_gen_o						<= s_registered_configs.signal_polarity;
					-- state: running = 1
					status_o.state 					<= (0 => '1', others => '0');
					status_o.cycle_number			<= std_logic_vector(to_unsigned(s_sync_cycle_cnt, g_SYNC_CYCLE_NUMBER_WIDTH));
				
				-- state "R_RELEASE"
				when R_RELEASE =>
					sync_gen_o						<= not s_registered_configs.signal_polarity;
					-- state: running = 1
					status_o.state	 				<= (0 => '1', others => '0');
					status_o.cycle_number			<= std_logic_vector(to_unsigned(s_sync_cycle_cnt, g_SYNC_CYCLE_NUMBER_WIDTH));

				-- state "ONE_SHOT"
				when ONE_SHOT =>
					sync_gen_o						<= s_registered_configs.signal_polarity;
					-- state: one shot = 2
					status_o.state					<= (1 => '1', others => '0');

				-- state "E_BLANK"
				when E_BLANK =>
					sync_gen_o						<= s_registered_configs.signal_polarity;
					-- state: error injection = 3
					status_o.state	 				<= (0|1 => '1', others => '0');
					status_o.cycle_number			<= std_logic_vector(to_unsigned(s_sync_cycle_cnt, g_SYNC_CYCLE_NUMBER_WIDTH));

				-- state "E_RELEASE"
				when E_RELEASE =>
					sync_gen_o						<= not s_registered_configs.signal_polarity;
					-- state: error injection = 3
					status_o.state					<= (0|1 => '1', others => '0');
					status_o.cycle_number			<= std_logic_vector(to_unsigned(s_sync_cycle_cnt, g_SYNC_CYCLE_NUMBER_WIDTH));

				-- not defined states
				when others =>
					null;

			end case;
		end if;
	end process p_sync_gen_fsm_output;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
