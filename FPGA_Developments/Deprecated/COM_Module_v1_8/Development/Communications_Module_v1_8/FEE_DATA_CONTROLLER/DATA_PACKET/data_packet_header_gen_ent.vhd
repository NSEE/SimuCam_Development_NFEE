library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity data_packet_header_gen_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		-- general inputs
		fee_clear_signal_i             : in  std_logic;
		fee_stop_signal_i              : in  std_logic;
		fee_start_signal_i             : in  std_logic;
		-- others
		header_gen_send_i              : in  std_logic;
		header_gen_reset_i             : in  std_logic;
		headerdata_i                   : in  t_fee_dpkt_headerdata;
		send_buffer_stat_almost_full_i : in  std_logic;
		send_buffer_stat_full_i        : in  std_logic;
		send_buffer_wrready_i          : in  std_logic;
		header_gen_finished_o          : out std_logic;
		send_buffer_wrdata_o           : out std_logic_vector(7 downto 0);
		send_buffer_wrreq_o            : out std_logic;
		send_buffer_data_type_wrdata_o : out std_logic_vector(1 downto 0);
		send_buffer_data_type_wrreq_o  : out std_logic
	);
end entity data_packet_header_gen_ent;

architecture RTL of data_packet_header_gen_ent is

	type t_data_packet_header_fsm is (
		STOPPED,
		IDLE,
		WAITING_SEND_BUFFER_SPACE,
		FIELD_LOGICAL_ADDRESS,
		FIELD_PROTOCOL_IDENTIFIER,
		FIELD_LENGTH_MSB,
		FIELD_LENGTH_LSB,
		FIELD_TYPE_MSB,
		FIELD_TYPE_LSB,
		FIELD_FRAME_COUNTER_MSB,
		FIELD_FRAME_COUNTER_LSB,
		FIELD_SEQUENCE_COUNTER_MSB,
		FIELD_SEQUENCE_COUNTER_LSB,
		HEADER_UNIT_FINISH_OPERATION
	);
	signal s_header_gen_state      : t_data_packet_header_fsm; -- current state
	signal s_header_gen_next_state : t_data_packet_header_fsm;

	signal s_overflow_send_buffer : std_logic;

begin

	p_data_packet_header_gen_FSM_state : process(clk_i, rst_i)
		variable v_header_gen_state : t_data_packet_header_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_header_gen_state             <= STOPPED;
			v_header_gen_state             := STOPPED;
			s_header_gen_next_state        <= STOPPED;
			s_overflow_send_buffer         <= '0';
			-- Outputs Generation
			header_gen_finished_o          <= '0';
			send_buffer_wrdata_o           <= x"00";
			send_buffer_wrreq_o            <= '0';
			send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
			send_buffer_data_type_wrreq_o  <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_header_gen_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_header_gen_state             <= STOPPED;
					v_header_gen_state             := STOPPED;
					s_header_gen_next_state        <= STOPPED;
					s_overflow_send_buffer         <= '0';
					-- Outputs Generation
					header_gen_finished_o          <= '0';
					send_buffer_wrdata_o           <= x"00";
					send_buffer_wrreq_o            <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_header_gen_state      <= IDLE;
						v_header_gen_state      := IDLE;
						s_header_gen_next_state <= IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send a header
					-- default state transition
					s_header_gen_state      <= IDLE;
					v_header_gen_state      := IDLE;
					s_header_gen_next_state <= IDLE;
					s_overflow_send_buffer  <= '0';
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a data packet header was requested
					if (header_gen_send_i = '1') then
						-- data packet header was requested
						-- set next field as logical address
						s_header_gen_next_state <= FIELD_LOGICAL_ADDRESS;
						-- go to wating buffer space
						s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
						v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					end if;

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default state transition
					s_header_gen_state     <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state     := WAITING_SEND_BUFFER_SPACE;
					s_overflow_send_buffer <= '0';
					-- default internal signal values
					-- conditional state transition
					-- check if the send buffer is ready and is not full
					if ((send_buffer_wrready_i = '1') and (send_buffer_stat_full_i = '0')) then
						-- send buffer is ready and is not full
						s_overflow_send_buffer <= '0';
						-- go to next field
						s_header_gen_state     <= s_header_gen_next_state;
						v_header_gen_state     := s_header_gen_next_state;
					-- check if the send buffer overflow is enabled
					elsif (c_SEND_BUFFER_OVERFLOW_ENABLE = '1') then
						-- send buffer overflow is enabled
						s_overflow_send_buffer <= '1';
						-- go to next field
						s_header_gen_state     <= s_header_gen_next_state;
						v_header_gen_state     := s_header_gen_next_state;
					end if;

				-- state "FIELD_LOGICAL_ADDRESS"
				when FIELD_LOGICAL_ADDRESS =>
					-- logical address field, send logical address
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_PROTOCOL_IDENTIFIER;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_LENGTH_MSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_LENGTH_MSB"
				when FIELD_LENGTH_MSB =>
					-- length field msb, send length msb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_LENGTH_LSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_LENGTH_LSB"
				when FIELD_LENGTH_LSB =>
					-- length field lsb, send length lsb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_TYPE_MSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_TYPE_MSB"
				when FIELD_TYPE_MSB =>
					-- type field msb, send type msb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_TYPE_LSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_TYPE_LSB"
				when FIELD_TYPE_LSB =>
					-- type field lsb, send type lsb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_FRAME_COUNTER_MSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_FRAME_COUNTER_MSB"
				when FIELD_FRAME_COUNTER_MSB =>
					-- frame counter field msb, send frame counter msb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_FRAME_COUNTER_LSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_FRAME_COUNTER_LSB"
				when FIELD_FRAME_COUNTER_LSB =>
					-- frame counter field lsb, send frame counter lsb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_SEQUENCE_COUNTER_MSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_SEQUENCE_COUNTER_MSB"
				when FIELD_SEQUENCE_COUNTER_MSB =>
					-- sequence counter field msb, send sequence counter msb
					-- default state transition
					s_header_gen_state      <= WAITING_SEND_BUFFER_SPACE;
					v_header_gen_state      := WAITING_SEND_BUFFER_SPACE;
					s_header_gen_next_state <= FIELD_SEQUENCE_COUNTER_LSB;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "FIELD_SEQUENCE_COUNTER_LSB"
				when FIELD_SEQUENCE_COUNTER_LSB =>
					-- sequence counter field lsb, send sequence counter lsb
					-- default state transition
					s_header_gen_state      <= HEADER_UNIT_FINISH_OPERATION;
					v_header_gen_state      := HEADER_UNIT_FINISH_OPERATION;
					s_header_gen_next_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "HEADER_UNIT_FINISH_OPERATION"
				when HEADER_UNIT_FINISH_OPERATION =>
					-- finish header unit operation
					-- default state transition
					s_header_gen_state      <= HEADER_UNIT_FINISH_OPERATION;
					v_header_gen_state      := HEADER_UNIT_FINISH_OPERATION;
					s_header_gen_next_state <= IDLE;
					s_overflow_send_buffer  <= '0';
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a header generator reset was requested
					if (header_gen_reset_i = '1') then
						-- reply reset commanded, go back to idle
						s_header_gen_state      <= IDLE;
						v_header_gen_state      := IDLE;
						s_header_gen_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_header_gen_state      <= IDLE;
					v_header_gen_state      := IDLE;
					s_header_gen_next_state <= IDLE;

			end case;

			-- output generation

			case (v_header_gen_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the control unit signals it is ready to send a header
					-- reset outputs
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_wrdata_o           <= x"00";
					send_buffer_wrreq_o            <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
				-- conditional output signals

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- clear send buffer write signal
					send_buffer_wrdata_o           <= x"00";
					send_buffer_wrreq_o            <= '0';
				-- conditional output signals

				-- state "FIELD_LOGICAL_ADDRESS"
				when FIELD_LOGICAL_ADDRESS =>
					-- logical address field, send logical address
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.logical_address;
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.protocol_id;
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_LENGTH_MSB"
				when FIELD_LENGTH_MSB =>
					-- length field msb, send length msb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.length_field(15 downto 8);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_LENGTH_LSB"
				when FIELD_LENGTH_LSB =>
					-- length field lsb, send length lsb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.length_field(7 downto 0);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_TYPE_MSB"
				when FIELD_TYPE_MSB =>
					-- type field msb, send type msb
					-- default output signals
					header_gen_finished_o            <= '0';
					send_buffer_data_type_wrdata_o   <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o    <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o(7 downto 4) <= (others => '0');
					send_buffer_wrdata_o(3 downto 0) <= headerdata_i.type_field.mode;
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_TYPE_LSB"
				when FIELD_TYPE_LSB =>
					-- type field lsb, send type lsb
					-- default output signals
					header_gen_finished_o            <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o(7)          <= headerdata_i.type_field.last_packet;
					send_buffer_wrdata_o(6)          <= headerdata_i.type_field.ccd_side;
					send_buffer_wrdata_o(5 downto 4) <= headerdata_i.type_field.ccd_number;
					send_buffer_wrdata_o(3 downto 2) <= headerdata_i.type_field.frame_number;
					send_buffer_wrdata_o(1 downto 0) <= headerdata_i.type_field.packet_type;
					-- write the send buffer data
					send_buffer_data_type_wrdata_o   <= headerdata_i.type_field.packet_type;
					send_buffer_data_type_wrreq_o    <= '1';
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_FRAME_COUNTER_MSB"
				when FIELD_FRAME_COUNTER_MSB =>
					-- frame counter field msb, send frame counter msb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.frame_counter(15 downto 8);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_FRAME_COUNTER_LSB"
				when FIELD_FRAME_COUNTER_LSB =>
					-- frame counter field lsb, send frame counter lsb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.frame_counter(7 downto 0);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_SEQUENCE_COUNTER_MSB"
				when FIELD_SEQUENCE_COUNTER_MSB =>
					-- sequence counter field msb, send sequence counter msb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.sequence_counter(15 downto 8);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "FIELD_SEQUENCE_COUNTER_LSB"
				when FIELD_SEQUENCE_COUNTER_LSB =>
					-- sequence counter field lsb, send sequence counter lsb
					-- default output signals
					header_gen_finished_o          <= '0';
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
					-- fill spw data with field data
					send_buffer_wrdata_o           <= headerdata_i.sequence_counter(7 downto 0);
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "HEADER_UNIT_FINISH_OPERATION"
				when HEADER_UNIT_FINISH_OPERATION =>
					-- finish header unit operation
					-- default output signals
					-- indicate that the reply generation is finished
					header_gen_finished_o          <= '1';
					send_buffer_wrreq_o            <= '0';
					send_buffer_wrdata_o           <= x"00";
					send_buffer_data_type_wrdata_o <= c_INVALID_PACKET;
					send_buffer_data_type_wrreq_o  <= '0';
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_header_gen_state      <= STOPPED;
				v_header_gen_state      := STOPPED;
				s_header_gen_next_state <= STOPPED;
			end if;

		end if;
	end process p_data_packet_header_gen_FSM_state;

end architecture RTL;
