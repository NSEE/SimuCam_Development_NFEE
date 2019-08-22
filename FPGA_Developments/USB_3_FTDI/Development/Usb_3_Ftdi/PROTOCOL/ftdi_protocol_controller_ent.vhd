library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;

entity ftdi_protocol_controller_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_stop_i                   : in  std_logic;
		data_start_i                  : in  std_logic;
		half_ccd_request_start_i      : in  std_logic;
		header_generator_busy_i       : in  std_logic;
		header_parser_busy_i          : in  std_logic;
		header_parser_data_i          : in  t_ftdi_prot_header_fields;
		header_parser_crc32_match_i   : in  std_logic;
		header_parser_eoh_error_i     : in  std_logic;
		payload_writer_busy_i         : in  std_logic;
		payload_reader_busy_i         : in  std_logic;
		payload_reader_crc32_match_i  : in  std_logic;
		payload_reader_eop_error_i    : in  std_logic;
		header_generator_start_o      : out std_logic;
		header_generator_reset_o      : out std_logic;
		header_parser_start_o         : out std_logic;
		header_parser_reset_o         : out std_logic;
		payload_writer_start_o        : out std_logic;
		payload_writer_reset_o        : out std_logic;
		payload_writer_length_bytes_o : out std_logic_vector(31 downto 0);
		payload_reader_start_o        : out std_logic;
		payload_reader_reset_o        : out std_logic;
		payload_reader_length_bytes_o : out std_logic_vector(31 downto 0)
	);
end entity ftdi_protocol_controller_ent;

architecture RTL of ftdi_protocol_controller_ent is

	type t_ftdi_prot_controller_fsm is (
		STOPPED,                        -- protocol controller stopped
		IDLE,                           -- protocol controller idle
		HFCCD_REQUEST_START,            -- half-ccd request start
		HFCCD_REQUEST_TX_HEADER,        -- half-ccd request transmit request header
		HFCCD_ACK_NACK_RX_HEADER,       -- half-ccd request receive request ack/nack
		HFCCD_REQUEST_RX_HEADER,        -- half-ccd request receive reply header
		HFCCD_ACK_NACK_TX_HEADER,       -- half-ccd request transmit reply ack/nack 
		HFCCD_REQUEST_RX_PAYLOAD,       -- half-ccd request receive reply payload
		HFCCD_ACK_NACK_TX_PAYLOAD,      -- half-ccd request transmit payload ack/nack
		HFCCD_REQUEST_FINISH,           -- half-ccd request finish
		WAIT_TX_HEADER_END,             -- wait until a header transmission is finished
		WAIT_RX_HEADER_END,             -- wait until a header receival is finished
		WAIT_TX_PAYLOAD_END,            -- wait until a payload transmission is finished
		WAIT_RX_PAYLOAD_END             -- wait until a payload receival is finished
	);
	signal s_ftdi_prot_controller_state : t_ftdi_prot_controller_fsm;

	signal s_ftdi_prot_controller_next_state : t_ftdi_prot_controller_fsm;

begin

	p_ftdi_protocol_controller : process(clk_i, rst_i) is
		variable v_ftdi_prot_controller_state : t_ftdi_prot_controller_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_prot_controller_state      <= STOPPED;
			v_ftdi_prot_controller_state      := STOPPED;
			s_ftdi_prot_controller_next_state <= STOPPED;
		-- internal signals reset
		-- outputs reset
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_prot_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- protocol controller stopped
					-- default state transition
					s_ftdi_prot_controller_state <= STOPPED;
					v_ftdi_prot_controller_state := STOPPED;
					-- default internal signal values
					-- conditional state transition
					-- check if a start command was issued
					if (data_start_i = '1') then
						s_ftdi_prot_controller_state <= IDLE;
						v_ftdi_prot_controller_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- protocol controller idle
					-- default state transition
					s_ftdi_prot_controller_state <= IDLE;
					v_ftdi_prot_controller_state := IDLE;
					-- default internal signal values
					-- conditional state transition
					-- check if a header generator start was issued
					if (half_ccd_request_start_i = '1') then
						s_ftdi_prot_controller_state <= HFCCD_REQUEST_START;
						v_ftdi_prot_controller_state := HFCCD_REQUEST_START;
					end if;

				-- state "HFCCD_REQUEST_START"
				when HFCCD_REQUEST_START =>
					-- half-ccd request start
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_REQUEST_TX_HEADER;
					v_ftdi_prot_controller_state := HFCCD_REQUEST_TX_HEADER;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_REQUEST_TX_HEADER"
				when HFCCD_REQUEST_TX_HEADER =>
					-- half-ccd request transmit request header
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_ACK_NACK_RX_HEADER;
					v_ftdi_prot_controller_state := HFCCD_ACK_NACK_RX_HEADER;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_ACK_NACK_RX_HEADER"
				when HFCCD_ACK_NACK_RX_HEADER =>
					-- half-ccd request receive request ack/nack
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_REQUEST_RX_HEADER;
					v_ftdi_prot_controller_state := HFCCD_REQUEST_RX_HEADER;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_REQUEST_RX_HEADER"
				when HFCCD_REQUEST_RX_HEADER =>
					-- half-ccd request receive reply header
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_ACK_NACK_TX_HEADER;
					v_ftdi_prot_controller_state := HFCCD_ACK_NACK_TX_HEADER;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_ACK_NACK_TX_HEADER"
				when HFCCD_ACK_NACK_TX_HEADER =>
					-- half-ccd request transmit reply ack/nack
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_REQUEST_RX_PAYLOAD;
					v_ftdi_prot_controller_state := HFCCD_REQUEST_RX_PAYLOAD;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_REQUEST_RX_PAYLOAD"
				when HFCCD_REQUEST_RX_PAYLOAD =>
					-- half-ccd request receive reply payload
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_ACK_NACK_TX_PAYLOAD;
					v_ftdi_prot_controller_state := HFCCD_ACK_NACK_TX_PAYLOAD;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_ACK_NACK_TX_PAYLOAD"
				when HFCCD_ACK_NACK_TX_PAYLOAD =>
					-- half-ccd request transmit payload ack/nack
					-- default state transition
					s_ftdi_prot_controller_state <= HFCCD_REQUEST_FINISH;
					v_ftdi_prot_controller_state := HFCCD_REQUEST_FINISH;
				-- default internal signal values
				-- conditional state transition

				-- state "HFCCD_REQUEST_FINISH"
				when HFCCD_REQUEST_FINISH =>
					-- half-ccd request finish
					-- default state transition
					s_ftdi_prot_controller_state <= IDLE;
					v_ftdi_prot_controller_state := IDLE;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_TX_HEADER_END"
				when WAIT_TX_HEADER_END =>
					-- wait until a header transmission is finished
					-- default state transition
					s_ftdi_prot_controller_state <= WAIT_TX_HEADER_END;
					v_ftdi_prot_controller_state := WAIT_TX_HEADER_END;
					-- default internal signal values
					-- conditional state transition
					-- check if the header transmission is finished
					if (header_generator_busy_i = '0') then
						s_ftdi_prot_controller_state <= s_ftdi_prot_controller_next_state;
						v_ftdi_prot_controller_state := s_ftdi_prot_controller_next_state;
					end if;

				-- state "WAIT_RX_HEADER_END"
				when WAIT_RX_HEADER_END =>
					-- wait until a header receival is finished
					-- default state transition
					s_ftdi_prot_controller_state <= WAIT_RX_HEADER_END;
					v_ftdi_prot_controller_state := WAIT_RX_HEADER_END;
					-- default internal signal values
					-- conditional state transition
					-- check if the header transmission is finished
					if (header_parser_busy_i = '0') then
						s_ftdi_prot_controller_state <= s_ftdi_prot_controller_next_state;
						v_ftdi_prot_controller_state := s_ftdi_prot_controller_next_state;
					end if;

				-- state "WAIT_TX_PAYLOAD_END"
				when WAIT_TX_PAYLOAD_END =>
					-- wait until a payload transmission is finished
					-- default state transition
					s_ftdi_prot_controller_state <= WAIT_TX_PAYLOAD_END;
					v_ftdi_prot_controller_state := WAIT_TX_PAYLOAD_END;
					-- default internal signal values
					-- conditional state transition
					-- check if the header transmission is finished
					if (payload_writer_busy_i = '0') then
						s_ftdi_prot_controller_state <= s_ftdi_prot_controller_next_state;
						v_ftdi_prot_controller_state := s_ftdi_prot_controller_next_state;
					end if;

				-- state "WAIT_RX_PAYLOAD_END"
				when WAIT_RX_PAYLOAD_END =>
					-- wait until a payload receival is finished
					-- default state transition
					s_ftdi_prot_controller_state <= WAIT_RX_PAYLOAD_END;
					v_ftdi_prot_controller_state := WAIT_RX_PAYLOAD_END;
					-- default internal signal values
					-- conditional state transition
					-- check if the header transmission is finished
					if (payload_reader_busy_i = '0') then
						s_ftdi_prot_controller_state <= s_ftdi_prot_controller_next_state;
						v_ftdi_prot_controller_state := s_ftdi_prot_controller_next_state;
					end if;

			end case;

			-- check if a stop command was received
			if (data_stop_i = '1') then
				s_ftdi_prot_controller_state <= STOPPED;
				v_ftdi_prot_controller_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_prot_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- protocol controller stopped
					-- default output signals
					-- conditional output signals

					-- state "IDLE"
				when IDLE =>
					-- protocol controller idle
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_REQUEST_START"
				when HFCCD_REQUEST_START =>
					-- half-ccd request start
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_REQUEST_TX_HEADER"
				when HFCCD_REQUEST_TX_HEADER =>
					-- half-ccd request transmit request header
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_ACK_NACK_RX_HEADER"
				when HFCCD_ACK_NACK_RX_HEADER =>
					-- half-ccd request receive request ack/nack
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_REQUEST_RX_HEADER"
				when HFCCD_REQUEST_RX_HEADER =>
					-- half-ccd request receive reply header
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_ACK_NACK_TX_HEADER"
				when HFCCD_ACK_NACK_TX_HEADER =>
					-- half-ccd request transmit reply ack/nack
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_REQUEST_RX_PAYLOAD"
				when HFCCD_REQUEST_RX_PAYLOAD =>
					-- half-ccd request receive reply payload
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_ACK_NACK_TX_PAYLOAD"
				when HFCCD_ACK_NACK_TX_PAYLOAD =>
					-- half-ccd request transmit payload ack/nack
					-- default output signals
					-- conditional output signals

					-- state "HFCCD_REQUEST_FINISH"
				when HFCCD_REQUEST_FINISH =>
					-- half-ccd request finish
					-- default output signals
					-- conditional output signals

					-- state "WAIT_TX_HEADER_END"
				when WAIT_TX_HEADER_END =>
					-- wait until a header transmission is finished
					-- default output signals
					-- conditional output signals

					-- state "WAIT_RX_HEADER_END"
				when WAIT_RX_HEADER_END =>
					-- wait until a header receival is finished
					-- default output signals
					-- conditional output signals

					-- state "WAIT_TX_PAYLOAD_END"
				when WAIT_TX_PAYLOAD_END =>
					-- wait until a payload transmission is finished
					-- default output signals
					-- conditional output signals

					-- state "WAIT_RX_PAYLOAD_END"
				when WAIT_RX_PAYLOAD_END =>
					-- wait until a payload receival is finished
					-- default output signals
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_protocol_controller;

end architecture RTL;
