library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;

entity ftdi_protocol_lut_controller_ent is
	generic(
		g_DELAY_TIMEOUT_CLKDIV : natural range 0 to 65535 := 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
	);
	port(
		clk_i                            : in  std_logic;
		rst_i                            : in  std_logic;
		data_stop_i                      : in  std_logic;
		data_start_i                     : in  std_logic;
		contoller_hold_i                 : in  std_logic;
		contoller_release_i              : in  std_logic;
		trans_lut_transmission_timeout_i : in  std_logic_vector(15 downto 0);
		trans_lut_fee_number_i           : in  std_logic_vector(2 downto 0);
		trans_lut_ccd_number_i           : in  std_logic_vector(1 downto 0);
		trans_lut_ccd_side_i             : in  std_logic;
		trans_lut_height_i               : in  std_logic_vector(12 downto 0);
		trans_lut_width_i                : in  std_logic_vector(11 downto 0);
		trans_lut_exposure_number_i      : in  std_logic_vector(15 downto 0);
		trans_lut_payload_length_bytes_i : in  std_logic_vector(31 downto 0);
		trans_lut_transmit_i             : in  std_logic;
		trans_lut_abort_transmit_i       : in  std_logic;
		trans_lut_reset_controller_i     : in  std_logic;
		header_generator_busy_i          : in  std_logic;
		header_parser_busy_i             : in  std_logic;
		header_parser_data_i             : in  t_ftdi_prot_header_fields;
		header_parser_crc32_match_i      : in  std_logic;
		header_parser_eoh_error_i        : in  std_logic;
		payload_writer_busy_i            : in  std_logic;
		payload_reader_busy_i            : in  std_logic;
		payload_reader_crc32_match_i     : in  std_logic;
		payload_reader_eop_error_i       : in  std_logic;
		trans_lut_transmitted_o          : out std_logic;
		trans_lut_controller_busy_o      : out std_logic;
		err_tx_comm_err_state_o          : out std_logic;
		err_tx_comm_err_code_o           : out std_logic_vector(15 downto 0);
		err_lut_transmit_nack_err_o      : out std_logic;
		err_lut_reply_eoh_err_o          : out std_logic;
		err_lut_reply_header_crc_err_o   : out std_logic;
		err_lut_trans_max_tries_err_o    : out std_logic;
		err_lut_payload_nack_err_o       : out std_logic;
		err_lut_trans_timeout_err_o      : out std_logic;
		header_generator_start_o         : out std_logic;
		header_generator_reset_o         : out std_logic;
		header_generator_data_o          : out t_ftdi_prot_header_fields;
		header_parser_abort_o            : out std_logic;
		header_parser_start_o            : out std_logic;
		header_parser_reset_o            : out std_logic;
		payload_writer_abort_o           : out std_logic;
		payload_writer_start_o           : out std_logic;
		payload_writer_reset_o           : out std_logic;
		payload_writer_length_bytes_o    : out std_logic_vector(31 downto 0);
		payload_reader_abort_o           : out std_logic;
		payload_reader_start_o           : out std_logic;
		payload_reader_reset_o           : out std_logic;
		payload_reader_length_bytes_o    : out std_logic_vector(31 downto 0)
	);
end entity ftdi_protocol_lut_controller_ent;

architecture RTL of ftdi_protocol_lut_controller_ent is

	type t_ftdi_prot_lut_controller_fsm is (
		STOPPED,                        -- protocol controller stopped
		IDLE,                           -- protocol controller idle
		LUT_TRANS_START,                -- lut transmit start
		LUT_TRANS_SEND_TX_HEADER,       -- lut transmit transmit lut header
		LUT_TRANS_WAIT_TX_HEADER,       -- lut transmit wait lut header
		LUT_TRANS_RESET_TX_HEADER,      -- lut transmit reset lut header
		LUT_ACK_RECEIVE_RX_HEADER,      -- lut transmit receive header ack/nack
		LUT_ACK_WAIT_RX_HEADER,         -- lut transmit wait header ack/nack
		LUT_ACK_PARSE_RX_HEADER,        -- lut transmit parse header ack/nack
		LUT_TRANS_SEND_TX_PAYLOAD,      -- lut transmit transmit lut payload
		LUT_TRANS_WAIT_TX_PAYLOAD,      -- lut transmit wait lut payload
		LUT_TRANS_RESET_TX_PAYLOAD,     -- lut transmit reset lut payload
		LUT_ACK_RECEIVE_RX_PAYLOAD,     -- lut transmit receive payload ack/nack
		LUT_ACK_WAIT_RX_PAYLOAD,        -- lut transmit wait payload ack/nack
		LUT_ACK_PARSE_RX_PAYLOAD,       -- lut transmit parse payload ack/nack
		LUT_TRANS_FINISH,               -- lut transmit finish
		CONTROLLER_ON_HOLD              -- protocol controller is on hold
	);
	signal s_ftdi_prot_lut_controller_state : t_ftdi_prot_lut_controller_fsm;

	signal s_registered_transmission_data : t_ftdi_prot_header_fields;
	signal s_parsed_reply_header_data     : t_ftdi_prot_header_fields;

	signal s_transmission_tries : natural range 0 to 3;

	signal s_err_lut_transmit_nack_err    : std_logic;
	signal s_err_lut_reply_header_crc_err : std_logic;
	signal s_err_lut_reply_eoh_err        : std_logic;
	signal s_err_lut_trans_max_tries_err  : std_logic;
	signal s_err_lut_payload_nack_err     : std_logic;
	signal s_err_lut_trans_timeout_err    : std_logic;

	signal s_timeout_delay_clear    : std_logic;
	signal s_timeout_delay_trigger  : std_logic;
	signal s_timeout_delay_timer    : std_logic_vector(15 downto 0);
	signal s_timeout_delay_busy     : std_logic;
	signal s_timeout_delay_finished : std_logic;

	signal s_registered_abort : std_logic;

begin

	timeout_delay_block_ent_inst : entity work.delay_block_ent
		generic map(
			g_CLKDIV      => std_logic_vector(to_unsigned(g_DELAY_TIMEOUT_CLKDIV, 16)),
			g_TIMER_WIDTH => s_timeout_delay_timer'length
		)
		port map(
			clk_i            => clk_i,
			rst_i            => rst_i,
			clr_i            => s_timeout_delay_clear,
			delay_trigger_i  => s_timeout_delay_trigger,
			delay_timer_i    => s_timeout_delay_timer,
			delay_busy_o     => s_timeout_delay_busy,
			delay_finished_o => s_timeout_delay_finished
		);

	p_ftdi_protocol_controller : process(clk_i, rst_i) is
		variable v_ftdi_prot_lut_controller_state : t_ftdi_prot_lut_controller_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_prot_lut_controller_state <= STOPPED;
			v_ftdi_prot_lut_controller_state := STOPPED;
			-- internal signals reset
			s_registered_transmission_data   <= c_FTDI_PROT_HEADER_RESET;
			s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
			s_transmission_tries             <= 0;
			s_err_lut_transmit_nack_err      <= '0';
			s_err_lut_reply_eoh_err          <= '0';
			s_err_lut_reply_header_crc_err   <= '0';
			s_err_lut_trans_max_tries_err    <= '0';
			s_err_lut_payload_nack_err       <= '0';
			s_err_lut_trans_timeout_err      <= '0';
			s_timeout_delay_clear            <= '0';
			s_timeout_delay_trigger          <= '0';
			s_timeout_delay_timer            <= (others => '0');
			s_registered_abort               <= '0';
			-- outputs reset
			trans_lut_transmitted_o          <= '0';
			trans_lut_controller_busy_o      <= '0';
			header_generator_start_o         <= '0';
			header_generator_reset_o         <= '0';
			header_generator_data_o          <= c_FTDI_PROT_HEADER_RESET;
			header_parser_abort_o            <= '0';
			header_parser_start_o            <= '0';
			header_parser_reset_o            <= '0';
			payload_writer_abort_o           <= '0';
			payload_writer_start_o           <= '0';
			payload_writer_reset_o           <= '0';
			payload_writer_length_bytes_o    <= (others => '0');
			payload_reader_abort_o           <= '0';
			payload_reader_start_o           <= '0';
			payload_reader_reset_o           <= '0';
			payload_reader_length_bytes_o    <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_prot_lut_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- protocol controller stopped
					-- default state transition
					s_ftdi_prot_lut_controller_state <= STOPPED;
					v_ftdi_prot_lut_controller_state := STOPPED;
					-- default internal signal values
					s_registered_transmission_data   <= c_FTDI_PROT_HEADER_RESET;
					s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
					s_transmission_tries             <= 0;
					s_err_lut_transmit_nack_err      <= '0';
					s_err_lut_reply_eoh_err          <= '0';
					s_err_lut_reply_header_crc_err   <= '0';
					s_err_lut_trans_max_tries_err    <= '0';
					s_err_lut_payload_nack_err       <= '0';
					s_err_lut_trans_timeout_err      <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					s_timeout_delay_clear            <= '0';
					s_registered_abort               <= '0';
					-- conditional state transition
					-- check if a start command was issued
					if (data_start_i = '1') then
						s_ftdi_prot_lut_controller_state <= IDLE;
						v_ftdi_prot_lut_controller_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- protocol controller idle
					-- default state transition
					s_ftdi_prot_lut_controller_state <= IDLE;
					v_ftdi_prot_lut_controller_state := IDLE;
					-- default internal signal values
					s_registered_transmission_data   <= c_FTDI_PROT_HEADER_RESET;
					s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
					s_transmission_tries             <= 0;
					s_err_lut_transmit_nack_err      <= '0';
					s_err_lut_reply_eoh_err          <= '0';
					s_err_lut_reply_header_crc_err   <= '0';
					s_err_lut_trans_max_tries_err    <= '0';
					s_err_lut_payload_nack_err       <= '0';
					s_err_lut_trans_timeout_err      <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					s_timeout_delay_clear            <= '0';
					s_registered_abort               <= '0';
					-- conditional state transition
					-- check if a header generator start was issued
					if (trans_lut_transmit_i = '1') then
						s_ftdi_prot_lut_controller_state                          <= LUT_TRANS_START;
						v_ftdi_prot_lut_controller_state                          := LUT_TRANS_START;
						s_registered_transmission_data.package_id                 <= c_FTDI_PROT_PKG_ID_LUT_TRANSMISSION;
						s_registered_transmission_data.image_selection.fee_number <= trans_lut_fee_number_i;
						s_registered_transmission_data.image_selection.ccd_number <= trans_lut_ccd_number_i;
						s_registered_transmission_data.image_selection.ccd_side   <= trans_lut_ccd_side_i;
						s_registered_transmission_data.image_size.ccd_height      <= trans_lut_height_i;
						s_registered_transmission_data.image_size.ccd_width       <= trans_lut_width_i;
						s_registered_transmission_data.exposure_number            <= trans_lut_exposure_number_i;
						s_registered_transmission_data.payload_length             <= trans_lut_payload_length_bytes_i;
						-- check if a timeout was requested
						if (trans_lut_transmission_timeout_i /= std_logic_vector(to_unsigned(0, trans_lut_transmission_timeout_i'length))) then
							s_timeout_delay_trigger <= '1';
							s_timeout_delay_timer   <= trans_lut_transmission_timeout_i;
						end if;
					-- check if a controller hold was requested
					elsif (contoller_hold_i = '1') then
						-- a controller hold was requested, go to controller on hold
						s_ftdi_prot_lut_controller_state <= CONTROLLER_ON_HOLD;
						v_ftdi_prot_lut_controller_state := CONTROLLER_ON_HOLD;
					end if;

				-- state "LUT_TRANS_START"
				when LUT_TRANS_START =>
					-- lut transmit start
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_SEND_TX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_SEND_TX_HEADER;
					-- default internal signal values
					s_transmission_tries             <= 2;
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_TRANS_SEND_TX_HEADER"
				when LUT_TRANS_SEND_TX_HEADER =>
					-- lut transmit transmit lut header
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_WAIT_TX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_WAIT_TX_HEADER;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_TRANS_WAIT_TX_HEADER"
				when LUT_TRANS_WAIT_TX_HEADER =>
					-- lut transmit wait lut header
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_WAIT_TX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_WAIT_TX_HEADER;
					-- default internal signal values
					-- conditional state transition
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- check if the transmission of the lut header is finished
					if (header_generator_busy_i = '0') then
						s_ftdi_prot_lut_controller_state <= LUT_TRANS_RESET_TX_HEADER;
						v_ftdi_prot_lut_controller_state := LUT_TRANS_RESET_TX_HEADER;
					end if;

				-- state "LUT_TRANS_RESET_TX_HEADER"
				when LUT_TRANS_RESET_TX_HEADER =>
					-- lut transmit reset lut header
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_RECEIVE_RX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_ACK_RECEIVE_RX_HEADER;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_ACK_RECEIVE_RX_HEADER"
				when LUT_ACK_RECEIVE_RX_HEADER =>
					-- lut transmit receive header ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_WAIT_RX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_ACK_WAIT_RX_HEADER;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_ACK_WAIT_RX_HEADER"
				when LUT_ACK_WAIT_RX_HEADER =>
					-- lut transmit wait header ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_WAIT_RX_HEADER;
					v_ftdi_prot_lut_controller_state := LUT_ACK_WAIT_RX_HEADER;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- conditional state transition
					-- check if the receival of the lut ack/nack is finished
					if (header_parser_busy_i = '0') then
						s_ftdi_prot_lut_controller_state <= LUT_ACK_PARSE_RX_HEADER;
						v_ftdi_prot_lut_controller_state := LUT_ACK_PARSE_RX_HEADER;
					end if;

				-- state "LUT_ACK_PARSE_RX_HEADER"
				when LUT_ACK_PARSE_RX_HEADER =>
					-- lut transmit parse header ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
					-- default internal signal values
					s_transmission_tries             <= 2;
					s_err_lut_transmit_nack_err      <= '0';
					s_err_lut_reply_header_crc_err   <= '0';
					s_err_lut_reply_eoh_err          <= '0';
					s_err_lut_trans_max_tries_err    <= '0';
					s_timeout_delay_clear            <= '1';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- conditional state transition
					-- check if a complete header arrived and the CRC matched
					if ((header_parser_eoh_error_i = '0') and (header_parser_crc32_match_i = '1')) then
						-- CRC matched and End of Header error not ocurred, package is reliable
						-- check if the arriving package is a ACK or NACK
						if (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_ACK_OK) then
							-- ACK received
							s_ftdi_prot_lut_controller_state <= LUT_TRANS_SEND_TX_PAYLOAD;
							v_ftdi_prot_lut_controller_state := LUT_TRANS_SEND_TX_PAYLOAD;
							s_transmission_tries             <= 3;
							s_timeout_delay_clear            <= '0';
						elsif (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_NACK_ERROR) then
							-- NACK received
							-- check if the number of transmission tries ended
							if (s_transmission_tries = 0) then
								-- no more tries, go to finish
								s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
								v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
								s_err_lut_trans_max_tries_err    <= '1';
							else
								-- send another transmission
								s_ftdi_prot_lut_controller_state <= LUT_TRANS_SEND_TX_HEADER;
								v_ftdi_prot_lut_controller_state := LUT_TRANS_SEND_TX_HEADER;
								s_transmission_tries             <= s_transmission_tries - 1;
								s_timeout_delay_clear            <= '0';
							end if;
							s_err_lut_transmit_nack_err <= '1';
						else
							-- Unknown packet received
							-- send another transmission
							-- check if the number of requiest tries ended
							if (s_transmission_tries = 0) then
								-- no more tries, go to finish
								s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
								v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
							else
								-- send another transmission
								s_ftdi_prot_lut_controller_state <= LUT_TRANS_SEND_TX_HEADER;
								v_ftdi_prot_lut_controller_state := LUT_TRANS_SEND_TX_HEADER;
								s_transmission_tries             <= s_transmission_tries - 1;
								s_timeout_delay_clear            <= '0';
							end if;
						end if;
					else
						-- error with the received package
						-- send another transmission
						-- check if the number of transmission tries ended
						if (s_transmission_tries = 0) then
							-- no more tries, go to finish
							s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
							v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
							s_err_lut_trans_max_tries_err    <= '1';
						else
							-- send another transmission
							s_ftdi_prot_lut_controller_state <= LUT_TRANS_SEND_TX_HEADER;
							v_ftdi_prot_lut_controller_state := LUT_TRANS_SEND_TX_HEADER;
							s_transmission_tries             <= s_transmission_tries - 1;
							s_timeout_delay_clear            <= '0';
						end if;
						s_err_lut_reply_header_crc_err <= not (header_parser_crc32_match_i);
						s_err_lut_reply_eoh_err        <= header_parser_eoh_error_i;
					end if;

				-- state "LUT_TRANS_SEND_TX_PAYLOAD"
				when LUT_TRANS_SEND_TX_PAYLOAD =>
					-- lut transmit transmit lut payload
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_WAIT_TX_PAYLOAD;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_WAIT_TX_PAYLOAD;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_TRANS_WAIT_TX_PAYLOAD"
				when LUT_TRANS_WAIT_TX_PAYLOAD =>
					-- lut transmit wait lut payload
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_WAIT_TX_PAYLOAD;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_WAIT_TX_PAYLOAD;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- conditional state transition
					-- check if the receival of the reply payload is finished
					if (payload_writer_busy_i = '0') then
						s_ftdi_prot_lut_controller_state <= LUT_TRANS_RESET_TX_PAYLOAD;
						v_ftdi_prot_lut_controller_state := LUT_TRANS_RESET_TX_PAYLOAD;
					end if;

				-- state "LUT_TRANS_RESET_TX_PAYLOAD"
				when LUT_TRANS_RESET_TX_PAYLOAD =>
					-- lut transmit reset lut payload
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_RECEIVE_RX_PAYLOAD;
					v_ftdi_prot_lut_controller_state := LUT_ACK_RECEIVE_RX_PAYLOAD;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_ACK_RECEIVE_RX_PAYLOAD"
				when LUT_ACK_RECEIVE_RX_PAYLOAD =>
					-- lut transmit receive payload ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_WAIT_RX_PAYLOAD;
					v_ftdi_prot_lut_controller_state := LUT_ACK_WAIT_RX_PAYLOAD;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
				-- conditional state transition

				-- state "LUT_ACK_WAIT_RX_PAYLOAD"
				when LUT_ACK_WAIT_RX_PAYLOAD =>
					-- lut transmit wait payload ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_ACK_WAIT_RX_PAYLOAD;
					v_ftdi_prot_lut_controller_state := LUT_ACK_WAIT_RX_PAYLOAD;
					-- default internal signal values
					s_timeout_delay_clear            <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- conditional state transition
					-- check if the receival of the lut ack/nack is finished
					if (header_parser_busy_i = '0') then
						s_ftdi_prot_lut_controller_state <= LUT_ACK_PARSE_RX_PAYLOAD;
						v_ftdi_prot_lut_controller_state := LUT_ACK_PARSE_RX_PAYLOAD;
					end if;

				-- state "LUT_ACK_PARSE_RX_PAYLOAD"
				when LUT_ACK_PARSE_RX_PAYLOAD =>
					-- lut transmit parse payload ack/nack
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
					-- default internal signal values
					s_transmission_tries             <= 2;
					s_err_lut_transmit_nack_err      <= '0';
					s_err_lut_reply_header_crc_err   <= '0';
					s_err_lut_reply_eoh_err          <= '0';
					s_err_lut_trans_max_tries_err    <= '0';
					s_timeout_delay_clear            <= '1';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					-- conditional state transition
					-- check if a complete header arrived and the CRC matched
					if ((header_parser_eoh_error_i = '0') and (header_parser_crc32_match_i = '1')) then
						-- CRC matched and End of Header error not ocurred, package is reliable
						-- check if the arriving package is a ACK or NACK
						if (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_ACK_OK) then
							-- ACK received
							s_transmission_tries  <= 3;
							s_timeout_delay_clear <= '0';
						elsif (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_NACK_ERROR) then
							-- NACK received
							s_err_lut_payload_nack_err <= '1';
						else
							-- Unknown packet received
--							s_err_lut_payload_nack_err <= '1';
						end if;
					else
						-- error with the received package
						s_err_lut_reply_header_crc_err <= not (header_parser_crc32_match_i);
						s_err_lut_reply_eoh_err        <= header_parser_eoh_error_i;
					end if;

				-- state "LUT_TRANS_FINISH"
				when LUT_TRANS_FINISH =>
					-- lut transmit finish
					-- default state transition
					s_ftdi_prot_lut_controller_state <= LUT_TRANS_FINISH;
					v_ftdi_prot_lut_controller_state := LUT_TRANS_FINISH;
					-- default internal signal values
					s_transmission_tries             <= 0;
					s_timeout_delay_clear            <= '1';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					s_registered_abort               <= '0';
					-- conditional state transition
					-- check if a reset was requested
					if (trans_lut_reset_controller_i = '1') then
						s_ftdi_prot_lut_controller_state <= IDLE;
						v_ftdi_prot_lut_controller_state := IDLE;
						s_registered_transmission_data   <= c_FTDI_PROT_HEADER_RESET;
						s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
						s_transmission_tries             <= 0;
						s_err_lut_transmit_nack_err      <= '0';
						s_err_lut_reply_header_crc_err   <= '0';
						s_err_lut_reply_eoh_err          <= '0';
						s_err_lut_trans_max_tries_err    <= '0';
						s_err_lut_trans_timeout_err      <= '0';
						s_timeout_delay_clear            <= '0';
					end if;

				-- state "CONTROLLER_ON_HOLD"
				when CONTROLLER_ON_HOLD =>
					-- protocol controller is on hold
					-- default state transition
					s_ftdi_prot_lut_controller_state <= CONTROLLER_ON_HOLD;
					v_ftdi_prot_lut_controller_state := CONTROLLER_ON_HOLD;
					-- default internal signal values
					s_registered_transmission_data   <= c_FTDI_PROT_HEADER_RESET;
					s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
					s_transmission_tries             <= 0;
					s_err_lut_transmit_nack_err      <= '0';
					s_err_lut_reply_eoh_err          <= '0';
					s_err_lut_reply_header_crc_err   <= '0';
					s_err_lut_trans_max_tries_err    <= '0';
					s_err_lut_payload_nack_err       <= '0';
					s_err_lut_trans_timeout_err      <= '0';
					s_timeout_delay_trigger          <= '0';
					s_timeout_delay_timer            <= (others => '0');
					s_timeout_delay_clear            <= '0';
					s_registered_abort               <= '0';
					-- conditional state transition
					-- check if a controller release was issued
					if (contoller_release_i = '1') then
						-- release the controller, return to idle
						s_ftdi_prot_lut_controller_state <= IDLE;
						v_ftdi_prot_lut_controller_state := IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					s_ftdi_prot_lut_controller_state <= STOPPED;
					v_ftdi_prot_lut_controller_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_stop_i = '1') then
				s_ftdi_prot_lut_controller_state <= STOPPED;
				v_ftdi_prot_lut_controller_state := STOPPED;
				s_timeout_delay_clear            <= '1';
			end if;

			-- Default Outputs
			trans_lut_transmitted_o       <= '0';
			trans_lut_controller_busy_o   <= '0';
			header_generator_start_o      <= '0';
			header_generator_reset_o      <= '0';
			header_generator_data_o       <= c_FTDI_PROT_HEADER_RESET;
			header_parser_abort_o         <= '0';
			header_parser_start_o         <= '0';
			header_parser_reset_o         <= '0';
			payload_writer_abort_o        <= '0';
			payload_writer_start_o        <= '0';
			payload_writer_reset_o        <= '0';
			payload_writer_length_bytes_o <= (others => '0');
			payload_reader_abort_o        <= '0';
			payload_reader_start_o        <= '0';
			payload_reader_reset_o        <= '0';
			payload_reader_length_bytes_o <= (others => '0');

			-- Output generation FSM
			case (v_ftdi_prot_lut_controller_state) is

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

					-- state "LUT_TRANS_START"
				when LUT_TRANS_START =>
					-- lut transmit start
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_SEND_TX_HEADER"
				when LUT_TRANS_SEND_TX_HEADER =>
					-- lut transmit transmit lut header
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_generator_start_o    <= '1';
					header_generator_data_o     <= s_registered_transmission_data;
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_WAIT_TX_HEADER"
				when LUT_TRANS_WAIT_TX_HEADER =>
					-- lut transmit wait lut header
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_RESET_TX_HEADER"
				when LUT_TRANS_RESET_TX_HEADER =>
					-- lut transmit reset lut header
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_generator_reset_o    <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_ACK_RECEIVE_RX_HEADER"
				when LUT_ACK_RECEIVE_RX_HEADER =>
					-- lut transmit receive header ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					header_parser_start_o       <= '1';
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_ACK_WAIT_RX_HEADER"
				when LUT_ACK_WAIT_RX_HEADER =>
					-- lut transmit wait header ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_ACK_PARSE_RX_HEADER"
				when LUT_ACK_PARSE_RX_HEADER =>
					-- lut transmit parse header ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					header_parser_reset_o       <= '1';
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_SEND_TX_PAYLOAD"
				when LUT_TRANS_SEND_TX_PAYLOAD =>
					-- lut transmit transmit lut payload
					-- default output signals
					trans_lut_controller_busy_o   <= '1';
					header_parser_abort_o         <= s_registered_abort;
					payload_writer_abort_o        <= s_registered_abort;
					payload_writer_start_o        <= '1';
					payload_writer_length_bytes_o <= s_registered_transmission_data.payload_length;
				-- conditional output signals

				-- state "LUT_TRANS_WAIT_TX_PAYLOAD"
				when LUT_TRANS_WAIT_TX_PAYLOAD =>
					-- lut transmit wait lut payload
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_RESET_TX_PAYLOAD"
				when LUT_TRANS_RESET_TX_PAYLOAD =>
					-- lut transmit reset lut payload
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
					payload_writer_reset_o      <= '1';
				-- conditional output signals

				-- state "LUT_ACK_RECEIVE_RX_PAYLOAD"
				when LUT_ACK_RECEIVE_RX_PAYLOAD =>
					-- lut transmit receive payload ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					header_parser_start_o       <= '1';
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_ACK_WAIT_RX_PAYLOAD"
				when LUT_ACK_WAIT_RX_PAYLOAD =>
					-- lut transmit wait payload ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_ACK_PARSE_RX_PAYLOAD"
				when LUT_ACK_PARSE_RX_PAYLOAD =>
					-- lut transmit parse payload ack/nack
					-- default output signals
					trans_lut_controller_busy_o <= '1';
					header_parser_abort_o       <= s_registered_abort;
					header_parser_reset_o       <= '1';
					payload_writer_abort_o      <= s_registered_abort;
				-- conditional output signals

				-- state "LUT_TRANS_FINISH"
				when LUT_TRANS_FINISH =>
					-- lut transmit finish
					-- default output signals
					trans_lut_transmitted_o <= '1';
				-- conditional output signals

				-- state "CONTROLLER_ON_HOLD"
				when CONTROLLER_ON_HOLD =>
					-- protocol controller is on hold
					-- default output signals
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_protocol_controller;

	-- Signals Assignments --

	-- Error State Assignments
	err_tx_comm_err_state_o             <= (s_err_lut_transmit_nack_err) or (s_err_lut_reply_header_crc_err) or (s_err_lut_reply_eoh_err) or (s_err_lut_trans_max_tries_err) or (s_err_lut_payload_nack_err) or (s_err_lut_trans_timeout_err);
	-- Error Code Assignments
	err_tx_comm_err_code_o(0)           <= s_err_lut_transmit_nack_err;
	err_tx_comm_err_code_o(1)           <= s_err_lut_reply_header_crc_err;
	err_tx_comm_err_code_o(2)           <= s_err_lut_reply_eoh_err;
	err_tx_comm_err_code_o(3)           <= s_err_lut_trans_max_tries_err;
	err_tx_comm_err_code_o(4)           <= s_err_lut_payload_nack_err;
	err_tx_comm_err_code_o(5)           <= s_err_lut_trans_timeout_err;
	err_tx_comm_err_code_o(15 downto 6) <= (others => '0');
	-- Error Signals Assigments
	err_lut_transmit_nack_err_o         <= s_err_lut_transmit_nack_err;
	err_lut_reply_header_crc_err_o      <= s_err_lut_reply_header_crc_err;
	err_lut_reply_eoh_err_o             <= s_err_lut_reply_eoh_err;
	err_lut_trans_max_tries_err_o       <= s_err_lut_trans_max_tries_err;
	err_lut_payload_nack_err_o          <= s_err_lut_payload_nack_err;
	err_lut_trans_timeout_err_o         <= s_err_lut_trans_timeout_err;

end architecture RTL;
