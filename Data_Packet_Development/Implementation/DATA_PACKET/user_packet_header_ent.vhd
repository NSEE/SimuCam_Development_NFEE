library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_packet_pkg.all;

entity user_packet_header_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local data packet clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		control_i     : in  t_data_packet_header_control;
		headerdata_i  : in  t_data_packet_headerdata;
		spw_flag_i    : in  t_data_packet_spw_tx_flag;
		-- global output signals
		flags_o       : out t_data_packet_header_flags;
		spw_control_o : out t_data_packet_spw_tx_control
		-- data bus(es)
	);
end entity user_packet_header_ent;

architecture RTL of user_packet_header_ent is

	-- SYMBOLIC ENCODED state machine: s_DATA_PACKET_HEADER_STATE
	-- ==========================================================
	type t_data_packet_header_state is (
		IDLE,
		WAITING_BUFFER_SPACE,
		FIELD_LOGICAL_ADDRESS,
		FIELD_PROTOCOL_IDENTIFIER,
		FIELD_LENGTH,
		FIELD_TYPE,
		FIELD_FRAME_COUNTER,
		FIELD_SEQUENCE_COUNTER,
		HEADER_UNIT_FINISH_OPERATION
	);
	signal s_data_packet_header_state      : t_data_packet_header_state; -- current state
	signal s_data_packet_header_next_state : t_data_packet_header_state;

begin

	p_data_packet_header_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_data_packet_header_state      <= IDLE;
			s_data_packet_header_next_state <= IDLE;
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_packet_header_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send a header
					-- default state transition
					s_data_packet_header_state      <= IDLE;
					s_data_packet_header_next_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_LOGICAL_ADDRESS"
				when FIELD_LOGICAL_ADDRESS =>
					-- logical address field, send logical address to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier to initiator
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_LENGTH"
				when FIELD_LENGTH =>
					-- length field, send length to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_TYPE"
				when FIELD_TYPE =>
					-- type field, send type to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_FRAME_COUNTER"
				when FIELD_FRAME_COUNTER =>
					-- frame counter field, send frame counter to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "FIELD_SEQUENCE_COUNTER"
				when FIELD_SEQUENCE_COUNTER =>
					-- sequence counter field, send sequence counter to the target
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- state "HEADER_UNIT_FINISH_OPERATION"
				when HEADER_UNIT_FINISH_OPERATION =>
					-- finish header unit operation
					-- default state transition
					-- default internal signal values
					-- conditional state transition and internal signal values

					-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_packet_header_state      <= IDLE;
					s_data_packet_header_next_state <= IDLE;

			end case;
		end if;
	end process p_data_packet_header_FSM_state;

	p_data_packet_header_FSM_output : process(s_data_packet_header_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then

		-- output generation when s_data_packet_header_state changes
		else
			case (s_data_packet_header_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send a header
					-- default output signals
					-- conditional output signals

					-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					-- conditional output signals

					-- state "FIELD_LOGICAL_ADDRESS"
				when FIELD_LOGICAL_ADDRESS =>
					-- logical address field, send logical address to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier to initiator
					-- default output signals
					-- conditional output signals

					-- state "FIELD_LENGTH"
				when FIELD_LENGTH =>
					-- length field, send length to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_TYPE"
				when FIELD_TYPE =>
					-- type field, send type to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_FRAME_COUNTER"
				when FIELD_FRAME_COUNTER =>
					-- frame counter field, send frame counter to the target
					-- default output signals
					-- conditional output signals

					-- state "FIELD_SEQUENCE_COUNTER"
				when FIELD_SEQUENCE_COUNTER =>
					-- sequence counter field, send sequence counter to the target
					-- default output signals
					-- conditional output signals

					-- state "HEADER_UNIT_FINISH_OPERATION"
				when HEADER_UNIT_FINISH_OPERATION =>
					-- finish header unit operation
					-- default output signals
					-- conditional output signals

					-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_packet_header_FSM_output;

end architecture RTL;
