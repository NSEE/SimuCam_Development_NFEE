--=============================================================================
--! @file sync_syncgen_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
use work.SYNC_MODULE_PKG.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: SYNC Module Sync Generator (sync_syncgen_ent)
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
--! sync_module_pkg
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for SYNC Module Sync Generator
--============================================================================

entity sync_syncgen_ent is
	generic(
		g_SYNC_COUNTER_WIDTH : natural range 0 to c_SYNC_COUNTER_MAX_WIDTH := c_SYNC_COUNTER_WIDTH;
		g_SYNC_POLARITY      : std_logic                                   := '1'
	);
	port(
		-- Global input signals
		--! Local clock used by the SYNC Module
		clk_i         : in  std_logic;  --! Local sync clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		control_i     : in  t_sync_syncgen_control;
		configs_i     : in  t_sync_syncgen_configs;
		-- global output signals

		flags_o       : out t_sync_syncgen_flags;
		error_o       : out t_sync_syncgen_error;
		sync_output_o : out std_logic_vector(1 downto 0)
		-- data bus(es)
	);
end entity sync_syncgen_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of sync_syncgen_ent is

	-- SYMBOLIC ENCODED state machine: s_sync_syncgen_STATE
	-- ===========================================================
	type t_sync_syncgen_state is (
		IDLE,
		POLARITY_0,
		POLARITY_1,
		STOPPED
	);
	signal s_sync_syncgen_state      : t_sync_syncgen_state; -- current state
	signal s_sync_syncgen_last_state : t_sync_syncgen_state;

	signal s_sync_free_counter   : std_logic_vector((g_SYNC_COUNTER_WIDTH - 1) downto 0);
	signal s_sync_toogle_counter : std_logic_vector((g_SYNC_COUNTER_WIDTH - 1) downto 0);

	signal s_pulse_number_counter : natural range 0 to ((2 ** c_SYNC_PULSE_NUMBER_WIDTH) - 1);

	signal s_registered_configs : t_sync_syncgen_configs;

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, reset_n_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of SYNC Module SyncGen Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_sync_syncgen_state
	p_sync_syncgen_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_sync_syncgen_state              <= IDLE;
			s_sync_syncgen_last_state         <= IDLE;
			s_sync_free_counter               <= (others => '0');
			s_sync_toogle_counter             <= (others => '1');
			s_pulse_number_counter            <= 0;
			s_registered_configs.pulse_period <= (others => '0');
			s_registered_configs.pulse_number <= (others => '0');
			s_registered_configs.master_width <= (others => '0');
			s_registered_configs.pulse_width  <= (others => '0');
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_sync_syncgen_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a start is received
					-- default state transition
					s_sync_syncgen_state              <= IDLE;
					s_sync_syncgen_last_state         <= IDLE;
					-- default internal signal values
					s_sync_free_counter               <= (others => '0');
					s_sync_toogle_counter             <= (others => '1');
					s_pulse_number_counter            <= 0;
					s_registered_configs.pulse_period <= (others => '0');
					s_registered_configs.pulse_number <= (others => '0');
					s_registered_configs.master_width <= (others => '0');
					s_registered_configs.pulse_width  <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if a start sync was received
					if (control_i.start = '1') then
						-- go to first polarity
						s_sync_syncgen_state  <= POLARITY_0;
						-- register configurations
						s_registered_configs  <= configs_i;
						-- set the toogle value (master pulse)
						s_sync_toogle_counter <= std_logic_vector(unsigned(s_registered_configs.master_width) - 1);
					end if;

				-- state "POLARITY_0"
				when POLARITY_0 =>
					-- initial polarity (pol_0) of the sync signal
					-- default state transition
					s_sync_syncgen_state      <= POLARITY_0;
					s_sync_syncgen_last_state <= POLARITY_0;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a stop command was received
					if (control_i.stop = '1') then
						-- stop received, go to STOPPED
						s_sync_syncgen_state <= STOPPED;
					else
						-- keep running
						s_sync_free_counter <= std_logic_vector(unsigned(s_sync_free_counter) + 1);
						-- check if the toogle value was reached
						if (s_sync_free_counter = s_sync_toogle_counter) then
							-- toogle value reached, go to next polarity
							s_sync_syncgen_state <= POLARITY_1;
						end if;

					end if;

				-- state "POLARITY_1"
				when POLARITY_1 =>
					-- final polarity (pol_1) of the sync signal 
					-- default state transition
					s_sync_syncgen_state      <= POLARITY_1;
					s_sync_syncgen_last_state <= POLARITY_1;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a stop command was received
					if (control_i.stop = '1') then
						-- stop received, go to STOPPED
						s_sync_syncgen_state <= STOPPED;
					else
						-- keep running
						s_sync_free_counter <= std_logic_vector(unsigned(s_sync_free_counter) + 1);
						-- check if the pulse period was reached
						if (s_sync_free_counter = std_logic_vector(unsigned(s_registered_configs.pulse_period) - 1)) then
							-- pulse period reached, go to first polarity
							s_sync_syncgen_state <= POLARITY_0;
							-- reset sync counter
							s_sync_free_counter  <= (others => '0');
							-- check if the pulse number can be incremented
							if (s_pulse_number_counter = (unsigned(s_registered_configs.pulse_number) - 1)) then
								-- pulse number can be incremented
								s_pulse_number_counter <= s_pulse_number_counter + 1;
								-- set the toogle value (normal pulse)
								s_sync_toogle_counter  <= std_logic_vector(unsigned(s_registered_configs.pulse_width) - 1);
							else
								-- pulse number need to be reseted
								s_pulse_number_counter <= 0;
								-- set the toogle value (master pulse)
								s_sync_toogle_counter  <= std_logic_vector(unsigned(s_registered_configs.master_width) - 1);
							end if;
						end if;
					end if;

				-- state "STOPPED"
				when STOPPED =>
					-- keep the sync stopped
					-- default state transition
					s_sync_syncgen_state <= STOPPED;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a start command or reset command was received
					if (control_i.start = '1') then
						-- start received, return to the last polarity
						s_sync_syncgen_state <= s_sync_syncgen_last_state;
					elsif (control_i.reset = '1') then
						-- reset received, go to idle
						s_sync_syncgen_state      <= IDLE;
						s_sync_syncgen_last_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_sync_syncgen_state      <= IDLE;
					s_sync_syncgen_last_state <= IDLE;

			end case;
		end if;
	end process p_sync_syncgen_FSM_state;

	--=============================================================================
	-- Begin of SYNC Module SyncGen Finite State Machine
	-- (output generation)
	--=============================================================================
	-- read: s_sync_syncgen_state, reset_n_i
	-- write:
	-- r/w:
	p_sync_syncgen_FSM_output : process(s_sync_syncgen_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
			-- output generation when s_sync_syncgen_state changes
			sync_output_o(1) <= '0';
			sync_output_o(0) <= g_SYNC_POLARITY;
			flags_o.running  <= '0';
			flags_o.stopped  <= '0';
		else
			case (s_sync_syncgen_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a start is received
					-- default output signals
					sync_output_o(1) <= '0';
					sync_output_o(0) <= g_SYNC_POLARITY;
					flags_o.running  <= '0';
					flags_o.stopped  <= '0';
				-- conditional output signals

				-- state "POLARITY_0"
				when POLARITY_0 =>
					-- initial polarity (pol_0) of the sync signal
					-- default output signals
					sync_output_o(1) <= '0';
					sync_output_o(0) <= g_SYNC_POLARITY;
					flags_o.running  <= '1';
					flags_o.stopped  <= '0';
					-- conditional output signals
					-- check if the sync signal is in the master pulse
					if (s_pulse_number_counter = 0) then
						-- flag the master pulse
						sync_output_o(1) <= '1';
					end if;

				-- state "POLARITY_1"
				when POLARITY_1 =>
					-- final polarity (pol_1) of the sync signal 
					-- default output signals
					sync_output_o(1) <= '0';
					sync_output_o(0) <= not (g_SYNC_POLARITY);
					flags_o.running  <= '1';
					flags_o.stopped  <= '0';
					-- conditional output signals
					-- check if the sync signal is in the master pulse
					if (s_pulse_number_counter = 0) then
						-- flag the master pulse
						sync_output_o(1) <= '1';
					end if;

				-- state "STOPPED"
				when STOPPED =>
					-- keep the sync stopped
					-- default output signals
					flags_o.running <= '1';
					flags_o.stopped <= '1';
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_sync_syncgen_FSM_output;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
