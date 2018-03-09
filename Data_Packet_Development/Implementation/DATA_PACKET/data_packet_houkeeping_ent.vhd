library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_packet_pkg.all;

entity data_packet_houkeeping_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local data packet clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		control_i     : in  t_data_packet_housekeeping_control;
		hkdata_i      : in  t_data_packet_hkdata;
		spw_flag_i    : in  t_data_packet_spw_tx_flag;
		-- global output signals
		flags_o       : out t_data_packet_housekeeping_flags;
		spw_control_o : out t_data_packet_spw_tx_control
		-- data bus(es)
	);
end entity data_packet_houkeeping_ent;

architecture RTL of data_packet_houkeeping_ent is

	-- SYMBOLIC ENCODED state machine: s_DATA_PACKET_HOUSEKEEPING_STATE
	-- ================================================================
	type t_data_packet_housekeeping_state is (
		IDLE,
		WAITING_BUFFER_SPACE,
		FIELD_HKDATA_TEMPERATURE,
		FIELD_HKDATA_VOLTAGE,
		FIELD_HKDATA_CURRENT,
		FIELD_EOP,
		HK_ERROR,
		HOUSEKEEPING_UNIT_FINISH_OPERATION
	);
	signal s_data_packet_housekeeping_state      : t_data_packet_housekeeping_state; -- current state
	signal s_data_packet_housekeeping_next_state : t_data_packet_housekeeping_state;

	signal s_byte_counter : natural range 0 to 1;

	signal s_hk_error : std_logic;

begin

	p_data_packet_housekeeping_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_data_packet_housekeeping_state      <= IDLE;
			s_data_packet_housekeeping_next_state <= IDLE;
			s_byte_counter                        <= 0;
			s_hk_error                            <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_packet_housekeeping_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send housekeeping data
					-- default state transition
					s_data_packet_housekeeping_state      <= IDLE;
					s_data_packet_housekeeping_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                        <= 0;
					s_hk_error                            <= '0';
					-- conditional state transition and internal signal values
					-- check if the control unit is ready to send housekeeping data
					if (control_i.send_housekeeping = '1') then
						-- control unit ready to send housekeeping data
						-- go to wating buffer space
						s_data_packet_housekeeping_state      <= WAITING_BUFFER_SPACE;
						s_data_packet_housekeeping_next_state <= FIELD_HKDATA_TEMPERATURE;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					s_data_packet_housekeeping_state <= WAITING_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if tx buffer can receive data
					if (spw_flag_i.ready = '1') then
						-- tx buffer can receive data
						-- go to next field
						s_data_packet_housekeeping_state <= s_data_packet_housekeeping_next_state;
					end if;

				-- state "FIELD_HKDATA_TEMPERATURE"
				when FIELD_HKDATA_TEMPERATURE =>
					-- hk temperature field, send hk temperature to the target
					-- default state transition
					s_data_packet_housekeeping_state      <= WAITING_BUFFER_SPACE;
					s_data_packet_housekeeping_next_state <= FIELD_HKDATA_VOLTAGE;
					-- default internal signal values
					s_byte_counter                        <= 0;
					-- conditional state transition and internal signal values
					-- check if a hk error ocurred
					if (s_hk_error = '1') then
						-- hk error ocurred, go to hk error
						s_data_packet_housekeeping_next_state <= HK_ERROR;
					end if;

				-- state "FIELD_HKDATA_VOLTAGE"
				when FIELD_HKDATA_VOLTAGE =>
					-- hk voltage field, send hk voltage to the target
					-- default state transition
					s_data_packet_housekeeping_state      <= WAITING_BUFFER_SPACE;
					s_data_packet_housekeeping_next_state <= FIELD_HKDATA_CURRENT;
					-- default internal signal values
					s_byte_counter                        <= 0;
					-- conditional state transition and internal signal values
					-- check if a hk error ocurred
					if (s_hk_error = '1') then
						-- hk error ocurred, go to hk error
						s_data_packet_housekeeping_next_state <= HK_ERROR;
					end if;

				-- state "FIELD_HKDATA_CURRENT"
				when FIELD_HKDATA_CURRENT =>
					-- hk current field, send hk current to the target
					-- default state transition
					s_data_packet_housekeeping_state      <= WAITING_BUFFER_SPACE;
					s_data_packet_housekeeping_next_state <= FIELD_EOP;
					-- default internal signal values
					s_byte_counter                        <= 0;
					-- conditional state transition and internal signal values
					-- check if a hk error ocurred
					if (s_hk_error = '1') then
						-- hk error ocurred, go to hk error
						s_data_packet_housekeeping_next_state <= HK_ERROR;
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default state transition
					s_data_packet_housekeeping_state      <= HOUSEKEEPING_UNIT_FINISH_OPERATION;
					s_data_packet_housekeeping_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                        <= 0;
				-- conditional state transition and internal signal values

				-- state "HK_ERROR"
				when HK_ERROR =>
					-- hk error ocurred, send eep to the target
					-- default state transition
					s_data_packet_housekeeping_state      <= HOUSEKEEPING_UNIT_FINISH_OPERATION;
					s_data_packet_housekeeping_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                        <= 0;
				-- conditional state transition and internal signal values

				-- state "HOUSEKEEPING_UNIT_FINISH_OPERATION"
				when HOUSEKEEPING_UNIT_FINISH_OPERATION =>
					-- finish housekeeping unit operation
					-- default state transition
					s_data_packet_housekeeping_state      <= HOUSEKEEPING_UNIT_FINISH_OPERATION;
					s_data_packet_housekeeping_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                        <= 0;
					-- conditional state transition and internal signal values
					-- check if control unit commanded a housekeeping reset
					if (control_i.housekeeping_reset = '1') then
						-- housekeeping reset commanded, go back to idle
						s_data_packet_housekeeping_state      <= IDLE;
						s_data_packet_housekeeping_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_packet_housekeeping_state      <= IDLE;
					s_data_packet_housekeeping_next_state <= IDLE;

			end case;
		end if;
	end process p_data_packet_housekeeping_FSM_state;

	p_data_packet_housekeeping_FSM_output : process(s_data_packet_housekeeping_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
			flags_o.housekeeping_busy     <= '0';
			flags_o.housekeeping_finished <= '0';
			flags_o.housekeeping_error    <= '0';
			spw_control_o.data            <= x"00";
			spw_control_o.flag            <= '0';
			spw_control_o.write           <= '0';
		-- output generation when s_data_packet_housekeeping_state changes
		else
			case (s_data_packet_housekeeping_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send housekeeping data
					-- default output signals
					flags_o.housekeeping_busy     <= '0';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					spw_control_o.data            <= x"00";
					spw_control_o.flag            <= '0';
					spw_control_o.write           <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- clear spw tx write signal
					spw_control_o.write           <= '0';
				-- conditional output signals

				-- state "FIELD_HKDATA_TEMPERATURE"
				when FIELD_HKDATA_TEMPERATURE =>
					-- hk temperature field, send hk temperature to the target
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag            <= '0';
					-- fill spw data with field data
					spw_control_o.data            <= hkdata_i.temperature;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "FIELD_HKDATA_VOLTAGE"
				when FIELD_HKDATA_VOLTAGE =>
					-- hk voltage field, send hk voltage to the target
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag            <= '0';
					-- fill spw data with field data
					spw_control_o.data            <= hkdata_i.voltage;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "FIELD_HKDATA_CURRENT"
				when FIELD_HKDATA_CURRENT =>
					-- hk current field, send hk current to the target
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag            <= '0';
					-- fill spw data with field data
					spw_control_o.data            <= hkdata_i.current;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "FIELD_EOP"
				-- TODO
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag            <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_control_o.data            <= c_EOP_VALUE;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "HK_ERROR"
				when HK_ERROR =>
					-- he error ocurred, send eep to the target
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag            <= '1';
					-- fill spw data with the eep identifier (0x01)
					spw_control_o.data            <= c_EEP_VALUE;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "HOUSEKEEPING_UNIT_FINISH_OPERATION"
				when HOUSEKEEPING_UNIT_FINISH_OPERATION =>
					-- finish housekeeping unit operation
					-- default output signals
					flags_o.housekeeping_busy     <= '1';
					flags_o.housekeeping_finished <= '0';
					flags_o.housekeeping_error    <= '0';
					spw_control_o.write           <= '0';
					spw_control_o.flag            <= '0';
					spw_control_o.data            <= x"00";
					-- conditional output signals
					-- check if an hk error ocurred
					if (s_hk_error = '1') then
						-- indicate that a hk error ocurred
						flags_o.housekeeping_error <= '1';
					else
						-- indicate that the housekeeping unit operation is finished
						flags_o.housekeeping_finished <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_housekeeping_FSM_output;

end architecture RTL;
