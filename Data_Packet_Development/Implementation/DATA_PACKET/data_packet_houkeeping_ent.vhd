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

begin

	p_data_packet_housekeeping_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_data_packet_housekeeping_state      <= IDLE;
			s_data_packet_housekeeping_next_state <= IDLE;
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
				-- conditional state transition and internal signal values

				-- state "WAITING_BUFFER_SPACE"
					-- TODO
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_HKDATA_TEMPERATURE"
					-- TODO
				when FIELD_HKDATA_TEMPERATURE =>
					-- hk temperature field, send hk temperature to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_HKDATA_VOLTAGE"
					-- TODO
				when FIELD_HKDATA_VOLTAGE =>
					-- hk voltage field, send hk voltage to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_HKDATA_CURRENT"
					-- TODO
				when FIELD_HKDATA_CURRENT =>
					-- hk current field, send hk current to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_EOP"
					-- TODO
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "HK_ERROR"
					-- TODO
				when HK_ERROR =>
					-- hk error ocurred, send eep to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "HOUSEKEEPING_UNIT_FINISH_OPERATION"
					-- TODO
				when HOUSEKEEPING_UNIT_FINISH_OPERATION =>
					-- finish housekeeping unit operation
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

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

		-- output generation when s_data_packet_housekeeping_state changes
		else
			case (s_data_packet_housekeeping_state) is

				-- state "IDLE"
					-- TODO
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send housekeeping data
					-- default output signals
					-- conditional output signals

					-- state "WAITING_BUFFER_SPACE"
					-- TODO
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					-- conditional output signals

					-- state "FIELD_HKDATA_TEMPERATURE"
					-- TODO
				when FIELD_HKDATA_TEMPERATURE =>
					-- hk temperature field, send hk temperature to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_HKDATA_VOLTAGE"
					-- TODO
				when FIELD_HKDATA_VOLTAGE =>
					-- hk voltage field, send hk voltage to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_HKDATA_CURRENT"
					-- TODO
				when FIELD_HKDATA_CURRENT =>
					-- hk current field, send hk current to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_EOP"
					-- TODO
				when FIELD_EOP =>
					-- eop field, send eop to the target
					-- default output signals
					-- conditional output signals

					-- state "HK_ERROR"
					-- TODO
				when HK_ERROR =>
					-- he error ocurred, send eep to the target
					-- default output signals
					-- conditional output signals

					-- state "HOUSEKEEPING_UNIT_FINISH_OPERATION"
					-- TODO
				when HOUSEKEEPING_UNIT_FINISH_OPERATION =>
					-- finish housekeeping unit operation
					-- default output signals
					-- conditional output signals

					-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_housekeeping_FSM_output;

end architecture RTL;
