library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_rx_protocol_header_parser_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_rx_stop_i                : in  std_logic;
		data_rx_start_i               : in  std_logic;
		header_parser_abort_i         : in  std_logic;
		header_parser_start_i         : in  std_logic;
		header_parser_reset_i         : in  std_logic;
		rx_dc_data_fifo_rddata_data_i : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i   : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i     : in  std_logic;
		rx_dc_data_fifo_rdfull_i      : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		header_parser_busy_o          : out std_logic;
		header_data_o                 : out t_ftdi_prot_header_fields;
		header_crc32_match_o          : out std_logic;
		header_eoh_error_o            : out std_logic;
		rx_dc_data_fifo_rdreq_o       : out std_logic
	);
end entity ftdi_rx_protocol_header_parser_ent;

-- (Rx: FTDI => FPGA)

architecture RTL of ftdi_rx_protocol_header_parser_ent is

	signal s_registered_header_data : t_ftdi_prot_header_fields;
	signal s_header_crc32           : std_logic_vector(31 downto 0);
	signal s_header_crc32_match     : std_logic;
	signal s_header_eoh_error       : std_logic;

	type t_ftdi_tx_prot_header_parser_fsm is (
		STOPPED,                        -- header parser stopped
		IDLE,                           -- header parser idle
		WAITING_RX_DATA_SOP,            -- wait until the rx fifo have data
		HEADER_RX_START_OF_PACKAGE,     -- parse a start of package from the rx fifo (discard all data until a sop) (discard all data until a sop)
		WAITING_RX_DATA,                -- wait until the rx fifo have enough data for a full header (minus start of package)
		FETCH_RX_DATA,                  -- fetch a rx fifo data
		HEADER_RX_PACKAGE_ID,           -- fetch and parse the package id to the rx fifo
		HEADER_RX_IMAGE_SELECTION,      -- fetch and parse the image selection to the rx fifo
		HEADER_RX_IMAGE_SIZE,           -- fetch and parse the image size to the rx fifo
		HEADER_RX_EXPOSURE_NUMBER,      -- fetch and parse the exposure number to the rx fifo
		HEADER_RX_PAYLOAD_LENGTH,       -- fetch and parse the payload length to the rx fifo
		HEADER_RX_HEADER_CRC,           -- fetch and parse the header crc to the rx fifo
		HEADER_RX_END_OF_HEADER,        -- fetch and parse a end of header to the rx fifo
		HEADER_RX_ABORT,                -- abort a header receival (consume all data in the rx fifo)
		FINISH_HEADER_RX                -- finish the header receival
	);
	signal s_ftdi_tx_prot_header_parser_state : t_ftdi_tx_prot_header_parser_fsm;

begin

	p_ftdi_tx_prot_header_parser : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_header_parser_state : t_ftdi_tx_prot_header_parser_fsm := STOPPED;
		variable v_header_dword                     : std_logic_vector(31 downto 0)    := (others => '0');
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_header_parser_state <= STOPPED;
			v_ftdi_tx_prot_header_parser_state := STOPPED;
			-- internal signals reset
			s_header_crc32_match               <= '0';
			s_header_eoh_error                 <= '0';
			-- outputs reset
			header_parser_busy_o               <= '0';
			s_registered_header_data           <= c_FTDI_PROT_HEADER_RESET;
			header_data_o                      <= c_FTDI_PROT_HEADER_RESET;
			s_header_crc32                     <= (others => '0');
			header_crc32_match_o               <= '0';
			header_eoh_error_o                 <= '0';
			rx_dc_data_fifo_rdreq_o            <= '0';
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_header_parser_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- header parser stopped
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= STOPPED;
					v_ftdi_tx_prot_header_parser_state := STOPPED;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if a start command was issued
					if (data_rx_start_i = '1') then
						s_ftdi_tx_prot_header_parser_state <= IDLE;
						v_ftdi_tx_prot_header_parser_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- header parser idle
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= IDLE;
					v_ftdi_tx_prot_header_parser_state := IDLE;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if a header generator start was issued
					if (header_parser_start_i = '1') then
						s_ftdi_tx_prot_header_parser_state <= WAITING_RX_DATA_SOP;
						v_ftdi_tx_prot_header_parser_state := WAITING_RX_DATA_SOP;
					end if;

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_header_parser_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if the rx dc data fifo is not empty 
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_header_parser_state <= HEADER_RX_START_OF_PACKAGE;
						v_ftdi_tx_prot_header_parser_state := HEADER_RX_START_OF_PACKAGE;
					end if;

				-- state "HEADER_RX_START_OF_PACKAGE"
				when HEADER_RX_START_OF_PACKAGE =>
					-- parse a start of package from the rx fifo (discard all data until a sop)
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_header_parser_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if a start of package was detected
					if (rx_dc_data_fifo_rddata_data_i = c_FTDI_PROT_START_OF_PACKAGE) then
						s_ftdi_tx_prot_header_parser_state <= WAITING_RX_DATA;
						v_ftdi_tx_prot_header_parser_state := WAITING_RX_DATA;
					end if;

				-- state "WAITING_RX_DATA"
				when WAITING_RX_DATA =>
					-- wait until the rx fifo have enough data for a full header (minus start of package)
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= WAITING_RX_DATA;
					v_ftdi_tx_prot_header_parser_state := WAITING_RX_DATA;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if there is enough data in the rx dc data fifo for a full header (minus the sop) (7 dwords)
					if ((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= (c_FTDI_PROT_HEADER_SIZE - 1))) then
						s_ftdi_tx_prot_header_parser_state <= FETCH_RX_DATA;
						v_ftdi_tx_prot_header_parser_state := FETCH_RX_DATA;
					end if;

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch a rx fifo data
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_PACKAGE_ID;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_PACKAGE_ID;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
				-- conditional state transition

				-- state "HEADER_RX_PACKAGE_ID"
				when HEADER_RX_PACKAGE_ID =>
					-- fetch and parse the package id to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_IMAGE_SELECTION;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_IMAGE_SELECTION;
				-- default internal signal values
				-- conditional state transition

				-- state "HEADER_RX_IMAGE_SELECTION"
				when HEADER_RX_IMAGE_SELECTION =>
					-- fetch and parse the image selection to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_IMAGE_SIZE;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_IMAGE_SIZE;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
				-- conditional state transition

				-- state "HEADER_RX_IMAGE_SIZE"
				when HEADER_RX_IMAGE_SIZE =>
					-- fetch and parse the image size to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_EXPOSURE_NUMBER;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_EXPOSURE_NUMBER;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
				-- conditional state transition

				-- state "HEADER_RX_EXPOSURE_NUMBER"
				when HEADER_RX_EXPOSURE_NUMBER =>
					-- fetch and parse the exposure number to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_PAYLOAD_LENGTH;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_PAYLOAD_LENGTH;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
				-- conditional state transition

				-- state "HEADER_RX_PAYLOAD_LENGTH"
				when HEADER_RX_PAYLOAD_LENGTH =>
					-- fetch and parse the payload length to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_HEADER_CRC;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_HEADER_CRC;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
				-- conditional state transition

				-- state "HEADER_RX_HEADER_CRC"
				when HEADER_RX_HEADER_CRC =>
					-- fetch and parse the header crc to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_END_OF_HEADER;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_END_OF_HEADER;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if the received header crc32 match the calculated crc32
					if (rx_dc_data_fifo_rddata_data_i = f_ftdi_protocol_finish_crc32(s_header_crc32)) then
						s_header_crc32_match <= '1';
					end if;

				-- state "HEADER_RX_END_OF_HEADER"
				when HEADER_RX_END_OF_HEADER =>
					-- fetch and parse a end of header to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= FINISH_HEADER_RX;
					v_ftdi_tx_prot_header_parser_state := FINISH_HEADER_RX;
					-- default internal signal values
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if a header end of header was not received
					if (rx_dc_data_fifo_rddata_data_i /= c_FTDI_PROT_END_OF_HEADER) then
						s_header_eoh_error <= '1';
					end if;

				-- state "HEADER_RX_ABORT"
				when HEADER_RX_ABORT =>
					-- abort a header receival (consume all data in the rx fifo)
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= HEADER_RX_ABORT;
					v_ftdi_tx_prot_header_parser_state := HEADER_RX_ABORT;
					-- default internal signal values
					s_header_crc32_match               <= '0';
					s_header_eoh_error                 <= '0';
					-- conditional state transition
					-- check if the rx fifo is empty
					if (rx_dc_data_fifo_rdempty_i = '1') then
						-- rx fifo is empty, go to finish
						s_ftdi_tx_prot_header_parser_state <= FINISH_HEADER_RX;
						v_ftdi_tx_prot_header_parser_state := FINISH_HEADER_RX;
					end if;

				-- state "FINISH_HEADER_RX"
				when FINISH_HEADER_RX =>
					-- finish the header receival
					-- default state transition
					s_ftdi_tx_prot_header_parser_state <= FINISH_HEADER_RX;
					v_ftdi_tx_prot_header_parser_state := FINISH_HEADER_RX;
					-- default internal signal values
					-- conditional state transition
					-- check if a header parser reset was issued
					if (header_parser_reset_i = '1') then
						s_ftdi_tx_prot_header_parser_state <= IDLE;
						v_ftdi_tx_prot_header_parser_state := IDLE;
						s_header_crc32_match               <= '0';
						s_header_eoh_error                 <= '0';
					end if;

			end case;

			-- check if a stop command was received
			if (data_rx_stop_i = '1') then
				s_ftdi_tx_prot_header_parser_state <= STOPPED;
				v_ftdi_tx_prot_header_parser_state := STOPPED;
			-- check if an abort was received and the header is not stopped or in idle or in abort or finished
			elsif ((header_parser_abort_i = '1') and ((s_ftdi_tx_prot_header_parser_state /= STOPPED) and (s_ftdi_tx_prot_header_parser_state /= IDLE) and (s_ftdi_tx_prot_header_parser_state /= HEADER_RX_ABORT) and (s_ftdi_tx_prot_header_parser_state /= FINISH_HEADER_RX))) then
				s_ftdi_tx_prot_header_parser_state <= HEADER_RX_ABORT;
				v_ftdi_tx_prot_header_parser_state := HEADER_RX_ABORT;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_header_parser_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- header parser stopped
					-- default output signals
					header_parser_busy_o     <= '0';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= (others => '0');
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- header parser idle
					-- default output signals
					header_parser_busy_o     <= '0';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= (others => '0');
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
				-- conditional output signals

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default output signals
					header_parser_busy_o     <= '1';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= (others => '0');
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
				-- conditional output signals

				-- state "HEADER_RX_START_OF_PACKAGE"
				when HEADER_RX_START_OF_PACKAGE =>
					-- parse a start of package from the rx fifo (discard all data until a sop)
					-- default output signals
					header_parser_busy_o     <= '1';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= (others => '0');
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '1';
				-- conditional output signals

				-- state "WAITING_RX_DATA"
				when WAITING_RX_DATA =>
					-- wait until the rx fifo have enough data for a full header (minus start of package)
					-- default output signals
					header_parser_busy_o     <= '1';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= (others => '0');
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
				-- conditional output signals

				-- state "FETCH_RX_DATA"
				when FETCH_RX_DATA =>
					-- fetch a rx fifo data
					-- default output signals
					header_parser_busy_o     <= '1';
					s_registered_header_data <= c_FTDI_PROT_HEADER_RESET;
					header_data_o            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32           <= c_FTDI_PROT_CRC32_START;
					header_crc32_match_o     <= '0';
					header_eoh_error_o       <= '0';
					rx_dc_data_fifo_rdreq_o  <= '1';
				-- conditional output signals

				-- state "HEADER_RX_PACKAGE_ID"
				when HEADER_RX_PACKAGE_ID =>
					-- fetch and parse the package id to the rx fifo
					-- default output signals
					header_parser_busy_o                <= '1';
					s_registered_header_data.package_id <= rx_dc_data_fifo_rddata_data_i;
					header_data_o                       <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32                      <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, rx_dc_data_fifo_rddata_data_i);
					header_crc32_match_o                <= '0';
					header_eoh_error_o                  <= '0';
					rx_dc_data_fifo_rdreq_o             <= '1';
				-- conditional output signals

				-- state "HEADER_RX_IMAGE_SELECTION"
				when HEADER_RX_IMAGE_SELECTION =>
					-- fetch and parse the image selection to the rx fifo
					-- default output signals
					header_parser_busy_o                                <= '1';
					s_registered_header_data.image_selection.fee_number <= rx_dc_data_fifo_rddata_data_i(18 downto 16);
					s_registered_header_data.image_selection.ccd_number <= rx_dc_data_fifo_rddata_data_i(9 downto 8);
					s_registered_header_data.image_selection.ccd_side   <= rx_dc_data_fifo_rddata_data_i(0);
					header_data_o                                       <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32                                      <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, rx_dc_data_fifo_rddata_data_i);
					header_crc32_match_o                                <= '0';
					header_eoh_error_o                                  <= '0';
					rx_dc_data_fifo_rdreq_o                             <= '1';
				-- conditional output signals

				-- state "HEADER_RX_IMAGE_SIZE"
				when HEADER_RX_IMAGE_SIZE =>
					-- fetch and parse the image size to the rx fifo
					-- default output signals
					header_parser_busy_o                           <= '1';
					s_registered_header_data.image_size.ccd_height <= rx_dc_data_fifo_rddata_data_i(28 downto 16);
					s_registered_header_data.image_size.ccd_width  <= rx_dc_data_fifo_rddata_data_i(11 downto 0);
					header_data_o                                  <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32                                 <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, rx_dc_data_fifo_rddata_data_i);
					header_crc32_match_o                           <= '0';
					header_eoh_error_o                             <= '0';
					rx_dc_data_fifo_rdreq_o                        <= '1';
				-- conditional output signals

				-- state "HEADER_RX_EXPOSURE_NUMBER"
				when HEADER_RX_EXPOSURE_NUMBER =>
					-- fetch and parse the exposure number to the rx fifo
					-- default output signals
					header_parser_busy_o                     <= '1';
					s_registered_header_data.exposure_number <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
					header_data_o                            <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32                           <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, rx_dc_data_fifo_rddata_data_i);
					header_crc32_match_o                     <= '0';
					header_eoh_error_o                       <= '0';
					rx_dc_data_fifo_rdreq_o                  <= '1';
				-- conditional output signals

				-- state "HEADER_RX_PAYLOAD_LENGTH"
				when HEADER_RX_PAYLOAD_LENGTH =>
					-- fetch and parse the payload length to the rx fifo
					-- default output signals
					header_parser_busy_o                    <= '1';
					s_registered_header_data.payload_length <= rx_dc_data_fifo_rddata_data_i;
					header_data_o                           <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32                          <= f_ftdi_protocol_calculate_crc32_dword(s_header_crc32, rx_dc_data_fifo_rddata_data_i);
					header_crc32_match_o                    <= '0';
					header_eoh_error_o                      <= '0';
					rx_dc_data_fifo_rdreq_o                 <= '0';
				-- conditional output signals

				-- state "HEADER_RX_HEADER_CRC"
				when HEADER_RX_HEADER_CRC =>
					-- fetch and parse the header crc to the rx fifo
					-- default output signals
					header_parser_busy_o    <= '1';
					header_data_o           <= c_FTDI_PROT_HEADER_RESET;
					header_crc32_match_o    <= '0';
					header_eoh_error_o      <= '0';
					rx_dc_data_fifo_rdreq_o <= '1';
				-- conditional output signals

				-- state "HEADER_RX_END_OF_HEADER"
				when HEADER_RX_END_OF_HEADER =>
					-- fetch and parse a end of header to the rx fifo
					-- default output signals
					header_parser_busy_o    <= '1';
					header_data_o           <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32          <= (others => '0');
					header_crc32_match_o    <= '0';
					header_eoh_error_o      <= '0';
					rx_dc_data_fifo_rdreq_o <= '1';
				-- conditional output signals

				-- state "HEADER_RX_ABORT"
				when HEADER_RX_ABORT =>
					-- abort a header receival (consume all data in the rx fifo)
					-- default output signals
					header_parser_busy_o    <= '1';
					header_data_o           <= c_FTDI_PROT_HEADER_RESET;
					s_header_crc32          <= (others => '0');
					header_crc32_match_o    <= '0';
					header_eoh_error_o      <= '0';
					rx_dc_data_fifo_rdreq_o <= '1';
				-- conditional output signals

				-- state "FINISH_HEADER_RX"
				when FINISH_HEADER_RX =>
					-- finish the header receival
					-- default output signals
					header_parser_busy_o    <= '0';
					header_data_o           <= s_registered_header_data;
					s_header_crc32          <= (others => '0');
					header_crc32_match_o    <= s_header_crc32_match;
					header_eoh_error_o      <= s_header_eoh_error;
					rx_dc_data_fifo_rdreq_o <= '0';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_prot_header_parser;

end architecture RTL;
