library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;

entity ftdi_protocol_top is
	port(
		clk_i                                : in  std_logic;
		rst_i                                : in  std_logic;
		ftdi_module_stop_i                   : in  std_logic; --                  -- Start Module Operation
		ftdi_module_start_i                  : in  std_logic; --                  -- Stop Module Operation
		req_half_ccd_request_timeout_i       : in  std_logic_vector(15 downto 0); -- Half-CCD Request Timeout
		req_half_ccd_fee_number_i            : in  std_logic_vector(2 downto 0); --- Half-CCD FEE Number
		req_half_ccd_ccd_number_i            : in  std_logic_vector(1 downto 0); --- Half-CCD CCD Number
		req_half_ccd_ccd_side_i              : in  std_logic; --                     Half-CCD CCD Side
		req_half_ccd_height_i                : in  std_logic_vector(12 downto 0); -- Half-CCD CCD Height
		req_half_ccd_width_i                 : in  std_logic_vector(11 downto 0); -- Half-CCD CCD Width
		req_half_ccd_exposure_number_i       : in  std_logic_vector(15 downto 0); -- Half-CCD Exposure Number
		req_half_ccd_request_i               : in  std_logic; --                  -- Request Half-CCD
		req_half_ccd_abort_request_i         : in  std_logic; --                  -- Abort Half-CCD Request
		req_half_ccd_reset_controller_i      : in  std_logic; --                  -- Reset Half-CCD Controller
		trans_lut_transmission_timeout_i     : in  std_logic_vector(15 downto 0); -- LUT Transmission Timeout
		trans_lut_fee_number_i               : in  std_logic_vector(2 downto 0); --- LUT FEE Number
		trans_lut_ccd_number_i               : in  std_logic_vector(1 downto 0); --- LUT CCD Number
		trans_lut_ccd_side_i                 : in  std_logic; --                  -- LUT CCD Side
		trans_lut_height_i                   : in  std_logic_vector(12 downto 0); -- LUT CCD Height
		trans_lut_width_i                    : in  std_logic_vector(11 downto 0); -- LUT CCD Width
		trans_lut_exposure_number_i          : in  std_logic_vector(15 downto 0); -- LUT Exposure Number
		trans_lut_payload_length_bytes_i     : in  std_logic_vector(31 downto 0); -- LUT Payload Length [Bytes]
		trans_lut_transmit_i                 : in  std_logic; --                  -- Trasnmit LUT
		trans_lut_abort_transmit_i           : in  std_logic; --                  -- Abort LUT Transmission
		trans_lut_reset_controller_i         : in  std_logic; --                  -- Reset LUT Controller
		lut_winparams_ccd1_wincfg_i          : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd2_wincfg_i          : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd3_wincfg_i          : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd4_wincfg_i          : in  t_ftdi_lut_winparams_ccdx_wincfg;
		tx_dc_data_fifo_wrempty_i            : in  std_logic;
		tx_dc_data_fifo_wrfull_i             : in  std_logic;
		tx_dc_data_fifo_wrusedw_i            : in  std_logic_vector(11 downto 0);
		rx_dc_data_fifo_rddata_data_i        : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i          : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i            : in  std_logic;
		rx_dc_data_fifo_rdfull_i             : in  std_logic;
		rx_dc_data_fifo_rdusedw_i            : in  std_logic_vector(11 downto 0);
		tx_dbuffer_stat_empty_i              : in  std_logic;
		tx_dbuffer_rddata_i                  : in  std_logic_vector(255 downto 0);
		tx_dbuffer_rdready_i                 : in  std_logic;
		rx_dbuffer_stat_full_i               : in  std_logic;
		rx_dbuffer_wrready_i                 : in  std_logic;
		rly_half_ccd_fee_number_o            : out std_logic_vector(2 downto 0); --- Half-CCD FEE Number
		rly_half_ccd_ccd_number_o            : out std_logic_vector(1 downto 0); --- Half-CCD CCD Number
		rly_half_ccd_ccd_side_o              : out std_logic; --                  -- Half-CCD CCD Side
		rly_half_ccd_height_o                : out std_logic_vector(12 downto 0); -- Half-CCD CCD Height
		rly_half_ccd_width_o                 : out std_logic_vector(11 downto 0); -- Half-CCD CCD Width
		rly_half_ccd_exposure_number_o       : out std_logic_vector(15 downto 0); -- Half-CCD Exposure Number
		rly_half_ccd_image_length_bytes_o    : out std_logic_vector(31 downto 0); -- Half-CCD Image Length [Bytes]
		rly_half_ccd_received_o              : out std_logic; --                  -- Half-CCD Received
		rly_half_ccd_controller_busy_o       : out std_logic; --                  -- Half-CCD Controller Busy
		rly_half_ccd_last_rx_buffer_o        : out std_logic; --                  -- Half-CCD Last Rx Buffer
		trans_lut_transmitted_o              : out std_logic; --                  -- LUT Transmitted
		trans_lut_controller_busy_o          : out std_logic; --                  -- LUT Controller Busy
		err_rx_comm_err_state_o              : out std_logic; --                  -- Rx Communication Error State
		err_rx_comm_err_code_o               : out std_logic_vector(15 downto 0); -- Rx Communication Error Code
		err_half_ccd_request_nack_err_o      : out std_logic; --                  -- Half-CCD Request Nack Error
		err_half_ccd_reply_header_crc_err_o  : out std_logic; --                  -- Half-CCD Reply Wrong Header CRC Error
		err_half_ccd_reply_eoh_err_o         : out std_logic; --                  -- Half-CCD Reply End of Header Error
		err_half_ccd_reply_payload_crc_err_o : out std_logic; --                  -- Half-CCD Reply Wrong Payload CRC Error
		err_half_ccd_reply_eop_err_o         : out std_logic; --                  -- Half-CCD Reply End of Payload Error
		err_half_ccd_req_max_tries_err_o     : out std_logic; --                  -- Half-CCD Request Maximum Tries Error
		err_half_ccd_reply_ccd_size_err_o    : out std_logic; --                  -- Half-CCD Request CCD Size Error
		err_half_ccd_req_timeout_err_o       : out std_logic; --                  -- Half-CCD Request Timeout Error
		err_tx_comm_err_state_o              : out std_logic; --                  -- Tx Communication Error State
		err_tx_comm_err_code_o               : out std_logic_vector(15 downto 0); -- Tx Communication Error Code
		err_lut_transmit_nack_err_o          : out std_logic; --                  -- LUT Transmit NACK Error
		err_lut_reply_eoh_err_o              : out std_logic; --                  -- LUT Reply End of Header Error
		err_lut_reply_header_crc_err_o       : out std_logic; --                  -- LUT Reply Wrong Payload CRC Error
		err_lut_trans_max_tries_err_o        : out std_logic; --                  -- LUT Transmission Maximum Tries Error
		err_lut_payload_nack_err_o           : out std_logic; --                  -- LUT Payload NACK Error
		err_lut_trans_timeout_err_o          : out std_logic; --                  -- LUT Transmission Timeout Error
		tx_dc_data_fifo_wrdata_data_o        : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o          : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o              : out std_logic;
		rx_dc_data_fifo_rdreq_o              : out std_logic;
		tx_dbuffer_rdreq_o                   : out std_logic;
		tx_dbuffer_change_o                  : out std_logic;
		rx_dbuffer_data_loaded_o             : out std_logic;
		rx_dbuffer_wrdata_o                  : out std_logic_vector(255 downto 0);
		rx_dbuffer_wrreq_o                   : out std_logic
	);
end entity ftdi_protocol_top;

architecture RTL of ftdi_protocol_top is

	-- Alias --

	-- Constants --

	-- Signals --

	-- FTDI Protocol Img Controller Signals
	signal s_imgc_controller_hold        : std_logic;
	signal s_imgc_controller_release     : std_logic;
	signal s_imgc_header_generator_start : std_logic;
	signal s_imgc_header_generator_reset : std_logic;
	signal s_imgc_header_generator_data  : t_ftdi_prot_header_fields;
	signal s_imgc_header_parser_abort    : std_logic;
	signal s_imgc_header_parser_start    : std_logic;
	signal s_imgc_header_parser_reset    : std_logic;

	-- FTDI Protocol LUT Controller Signals
	signal s_lutc_controller_hold        : std_logic;
	signal s_lutc_controller_release     : std_logic;
	signal s_lutc_header_generator_start : std_logic;
	signal s_lutc_header_generator_reset : std_logic;
	signal s_lutc_header_generator_data  : t_ftdi_prot_header_fields;
	signal s_lutc_header_parser_abort    : std_logic;
	signal s_lutc_header_parser_start    : std_logic;
	signal s_lutc_header_parser_reset    : std_logic;

	-- FTDI Tx Header Generator Signals
	signal s_header_generator_start : std_logic;
	signal s_header_generator_reset : std_logic;
	signal s_header_generator_data  : t_ftdi_prot_header_fields;
	signal s_header_generator_busy  : std_logic;

	-- FTDI Rx Header Parser Signals
	signal s_header_parser_abort       : std_logic;
	signal s_header_parser_start       : std_logic;
	signal s_header_parser_reset       : std_logic;
	signal s_header_parser_busy        : std_logic;
	signal s_header_parser_data        : t_ftdi_prot_header_fields;
	signal s_header_parser_crc32_match : std_logic;
	signal s_header_parser_eoh_error   : std_logic;

	-- FTDI Tx Payload Writer Signals
	signal s_payload_writer_abort        : std_logic;
	signal s_payload_writer_start        : std_logic;
	signal s_payload_writer_reset        : std_logic;
	signal s_payload_writer_length_bytes : std_logic_vector(31 downto 0);
	signal s_payload_writer_busy         : std_logic;

	-- FTDI Rx Payload Reader Signals
	signal s_payload_reader_abort        : std_logic;
	signal s_payload_reader_start        : std_logic;
	signal s_payload_reader_reset        : std_logic;
	signal s_payload_reader_length_bytes : std_logic_vector(31 downto 0);
	signal s_payload_reader_busy         : std_logic;
	signal s_payload_reader_crc32_match  : std_logic;
	signal s_payload_reader_eop_error    : std_logic;

	-- Header Tx DC Data FIFO Signals
	signal s_header_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_header_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_header_tx_dc_data_fifo_wrreq       : std_logic;

	-- Header Rx DC Data FIFO Signals
	signal s_header_rx_dc_data_fifo_rdreq : std_logic;

	-- Payload Tx DC Data FIFO Signals
	signal s_payload_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_payload_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_payload_tx_dc_data_fifo_wrreq       : std_logic;

	-- Payload Rx DC Data FIFO Signals
	signal s_payload_rx_dc_data_fifo_rdreq : std_logic;

begin

	-- FTDI Protocol Img Controller Instantiation
	ftdi_protocol_img_controller_ent_inst : entity work.ftdi_protocol_img_controller_ent
		generic map(
			g_DELAY_TIMEOUT_CLKDIV => 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
		)
		port map(
			clk_i                                => clk_i,
			rst_i                                => rst_i,
			data_stop_i                          => ftdi_module_stop_i,
			data_start_i                         => ftdi_module_start_i,
			contoller_hold_i                     => s_imgc_controller_hold,
			contoller_release_i                  => s_imgc_controller_release,
			req_half_ccd_request_timeout_i       => (others => '0'),
			req_half_ccd_fee_number_i            => req_half_ccd_fee_number_i,
			req_half_ccd_ccd_number_i            => req_half_ccd_ccd_number_i,
			req_half_ccd_ccd_side_i              => req_half_ccd_ccd_side_i,
			req_half_ccd_height_i                => req_half_ccd_height_i,
			req_half_ccd_width_i                 => req_half_ccd_width_i,
			req_half_ccd_exposure_number_i       => req_half_ccd_exposure_number_i,
			req_half_ccd_request_i               => req_half_ccd_request_i,
			req_half_ccd_abort_request_i         => req_half_ccd_abort_request_i,
			req_half_ccd_reset_controller_i      => req_half_ccd_reset_controller_i,
			header_generator_busy_i              => s_header_generator_busy,
			header_parser_busy_i                 => s_header_parser_busy,
			header_parser_data_i                 => s_header_parser_data,
			header_parser_crc32_match_i          => s_header_parser_crc32_match,
			header_parser_eoh_error_i            => s_header_parser_eoh_error,
			payload_writer_busy_i                => '0',
			payload_reader_busy_i                => s_payload_reader_busy,
			payload_reader_crc32_match_i         => s_payload_reader_crc32_match,
			payload_reader_eop_error_i           => s_payload_reader_eop_error,
			rly_half_ccd_fee_number_o            => rly_half_ccd_fee_number_o,
			rly_half_ccd_ccd_number_o            => rly_half_ccd_ccd_number_o,
			rly_half_ccd_ccd_side_o              => rly_half_ccd_ccd_side_o,
			rly_half_ccd_height_o                => rly_half_ccd_height_o,
			rly_half_ccd_width_o                 => rly_half_ccd_width_o,
			rly_half_ccd_exposure_number_o       => rly_half_ccd_exposure_number_o,
			rly_half_ccd_image_length_bytes_o    => rly_half_ccd_image_length_bytes_o,
			rly_half_ccd_received_o              => rly_half_ccd_received_o,
			rly_half_ccd_controller_busy_o       => rly_half_ccd_controller_busy_o,
			err_rx_comm_err_state_o              => err_rx_comm_err_state_o,
			err_rx_comm_err_code_o               => err_rx_comm_err_code_o,
			err_half_ccd_request_nack_err_o      => err_half_ccd_request_nack_err_o,
			err_half_ccd_reply_header_crc_err_o  => err_half_ccd_reply_header_crc_err_o,
			err_half_ccd_reply_eoh_err_o         => err_half_ccd_reply_eoh_err_o,
			err_half_ccd_reply_payload_crc_err_o => err_half_ccd_reply_payload_crc_err_o,
			err_half_ccd_reply_eop_err_o         => err_half_ccd_reply_eop_err_o,
			err_half_ccd_req_max_tries_err_o     => err_half_ccd_req_max_tries_err_o,
			err_half_ccd_reply_ccd_size_err_o    => err_half_ccd_reply_ccd_size_err_o,
			err_half_ccd_req_timeout_err_o       => err_half_ccd_req_timeout_err_o,
			header_generator_start_o             => s_imgc_header_generator_start,
			header_generator_reset_o             => s_imgc_header_generator_reset,
			header_generator_data_o              => s_imgc_header_generator_data,
			header_parser_abort_o                => s_imgc_header_parser_abort,
			header_parser_start_o                => s_imgc_header_parser_start,
			header_parser_reset_o                => s_imgc_header_parser_reset,
			payload_writer_abort_o               => open,
			payload_writer_start_o               => open,
			payload_writer_reset_o               => open,
			payload_writer_length_bytes_o        => open,
			payload_reader_abort_o               => s_payload_reader_abort,
			payload_reader_start_o               => s_payload_reader_start,
			payload_reader_reset_o               => s_payload_reader_reset,
			payload_reader_length_bytes_o        => s_payload_reader_length_bytes
		);
	s_imgc_controller_hold    <= trans_lut_transmit_i;
	s_imgc_controller_release <= trans_lut_reset_controller_i;

	-- FTDI Protocol LUT Controller Instantiation
	ftdi_protocol_lut_controller_ent_inst : entity work.ftdi_protocol_lut_controller_ent
		generic map(
			g_DELAY_TIMEOUT_CLKDIV => 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
		)
		port map(
			clk_i                            => clk_i,
			rst_i                            => rst_i,
			data_stop_i                      => ftdi_module_stop_i,
			data_start_i                     => ftdi_module_start_i,
			contoller_hold_i                 => s_lutc_controller_hold,
			contoller_release_i              => s_lutc_controller_release,
			trans_lut_transmission_timeout_i => (others => '0'),
			trans_lut_fee_number_i           => trans_lut_fee_number_i,
			trans_lut_ccd_number_i           => trans_lut_ccd_number_i,
			trans_lut_ccd_side_i             => trans_lut_ccd_side_i,
			trans_lut_height_i               => trans_lut_height_i,
			trans_lut_width_i                => trans_lut_width_i,
			trans_lut_exposure_number_i      => trans_lut_exposure_number_i,
			trans_lut_payload_length_bytes_i => trans_lut_payload_length_bytes_i,
			trans_lut_transmit_i             => trans_lut_transmit_i,
			trans_lut_abort_transmit_i       => trans_lut_abort_transmit_i,
			trans_lut_reset_controller_i     => trans_lut_reset_controller_i,
			header_generator_busy_i          => s_header_generator_busy,
			header_parser_busy_i             => s_header_parser_busy,
			header_parser_data_i             => s_header_parser_data,
			header_parser_crc32_match_i      => s_header_parser_crc32_match,
			header_parser_eoh_error_i        => s_header_parser_eoh_error,
			payload_writer_busy_i            => s_payload_writer_busy,
			payload_reader_busy_i            => '0',
			payload_reader_crc32_match_i     => '0',
			payload_reader_eop_error_i       => '0',
			trans_lut_transmitted_o          => trans_lut_transmitted_o,
			trans_lut_controller_busy_o      => trans_lut_controller_busy_o,
			err_tx_comm_err_state_o          => err_tx_comm_err_state_o,
			err_tx_comm_err_code_o           => err_tx_comm_err_code_o,
			err_lut_transmit_nack_err_o      => err_lut_transmit_nack_err_o,
			err_lut_reply_eoh_err_o          => err_lut_reply_eoh_err_o,
			err_lut_reply_header_crc_err_o   => err_lut_reply_header_crc_err_o,
			err_lut_trans_max_tries_err_o    => err_lut_trans_max_tries_err_o,
			err_lut_payload_nack_err_o       => err_lut_payload_nack_err_o,
			err_lut_trans_timeout_err_o      => err_lut_trans_timeout_err_o,
			header_generator_start_o         => s_lutc_header_generator_start,
			header_generator_reset_o         => s_lutc_header_generator_reset,
			header_generator_data_o          => s_lutc_header_generator_data,
			header_parser_abort_o            => s_lutc_header_parser_abort,
			header_parser_start_o            => s_lutc_header_parser_start,
			header_parser_reset_o            => s_lutc_header_parser_reset,
			payload_writer_abort_o           => s_payload_writer_abort,
			payload_writer_start_o           => s_payload_writer_start,
			payload_writer_reset_o           => s_payload_writer_reset,
			payload_writer_length_bytes_o    => s_payload_writer_length_bytes,
			payload_reader_abort_o           => open,
			payload_reader_start_o           => open,
			payload_reader_reset_o           => open,
			payload_reader_length_bytes_o    => open
		);
	s_lutc_controller_hold    <= req_half_ccd_request_i;
	s_lutc_controller_release <= req_half_ccd_reset_controller_i;

	-- FTDI Tx Protocol Header Generator Instantiation
	ftdi_tx_protocol_header_generator_ent_inst : entity work.ftdi_tx_protocol_header_generator_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			data_tx_stop_i                => ftdi_module_stop_i,
			data_tx_start_i               => ftdi_module_start_i,
			header_generator_start_i      => s_header_generator_start,
			header_generator_reset_i      => s_header_generator_reset,
			header_data_i                 => s_header_generator_data,
			tx_dc_data_fifo_wrempty_i     => tx_dc_data_fifo_wrempty_i,
			tx_dc_data_fifo_wrfull_i      => tx_dc_data_fifo_wrfull_i,
			tx_dc_data_fifo_wrusedw_i     => tx_dc_data_fifo_wrusedw_i,
			header_generator_busy_o       => s_header_generator_busy,
			tx_dc_data_fifo_wrdata_data_o => s_header_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_o   => s_header_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_o       => s_header_tx_dc_data_fifo_wrreq
		);

	-- FTDI Rx Protocol Header Parser Instantiation
	ftdi_rx_protocol_header_parser_ent_inst : entity work.ftdi_rx_protocol_header_parser_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			data_rx_stop_i                => ftdi_module_stop_i,
			data_rx_start_i               => ftdi_module_start_i,
			header_parser_abort_i         => '0',
			header_parser_start_i         => s_header_parser_start,
			header_parser_reset_i         => s_header_parser_reset,
			rx_dc_data_fifo_rddata_data_i => rx_dc_data_fifo_rddata_data_i,
			rx_dc_data_fifo_rddata_be_i   => rx_dc_data_fifo_rddata_be_i,
			rx_dc_data_fifo_rdempty_i     => rx_dc_data_fifo_rdempty_i,
			rx_dc_data_fifo_rdfull_i      => rx_dc_data_fifo_rdfull_i,
			rx_dc_data_fifo_rdusedw_i     => rx_dc_data_fifo_rdusedw_i,
			header_parser_busy_o          => s_header_parser_busy,
			header_data_o                 => s_header_parser_data,
			header_crc32_match_o          => s_header_parser_crc32_match,
			header_eoh_error_o            => s_header_parser_eoh_error,
			rx_dc_data_fifo_rdreq_o       => s_header_rx_dc_data_fifo_rdreq
		);

	-- FTDI Tx Protocol Payload Writer Instantiation
	ftdi_tx_protocol_payload_writer_ent_inst : entity work.ftdi_tx_protocol_payload_writer_ent
		generic map(
			g_DELAY_QQWORD_CLKDIV => 0  -- [100 MHz / 1 = 100 MHz = 10 ns]
		)
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			data_tx_stop_i                => ftdi_module_stop_i,
			data_tx_start_i               => ftdi_module_start_i,
			payload_writer_abort_i        => s_payload_writer_abort,
			payload_writer_start_i        => s_payload_writer_start,
			payload_writer_reset_i        => s_payload_writer_reset,
			payload_length_bytes_i        => s_payload_writer_length_bytes,
			payload_qqword_delay_i        => req_half_ccd_request_timeout_i,
			lut_winparams_ccd1_wincfg_i   => lut_winparams_ccd1_wincfg_i,
			lut_winparams_ccd2_wincfg_i   => lut_winparams_ccd2_wincfg_i,
			lut_winparams_ccd3_wincfg_i   => lut_winparams_ccd3_wincfg_i,
			lut_winparams_ccd4_wincfg_i   => lut_winparams_ccd4_wincfg_i,
			buffer_stat_empty_i           => tx_dbuffer_stat_empty_i,
			buffer_rddata_i               => tx_dbuffer_rddata_i,
			buffer_rdready_i              => tx_dbuffer_rdready_i,
			tx_dc_data_fifo_wrempty_i     => tx_dc_data_fifo_wrempty_i,
			tx_dc_data_fifo_wrfull_i      => tx_dc_data_fifo_wrfull_i,
			tx_dc_data_fifo_wrusedw_i     => tx_dc_data_fifo_wrusedw_i,
			payload_writer_busy_o         => s_payload_writer_busy,
			buffer_rdreq_o                => tx_dbuffer_rdreq_o,
			buffer_change_o               => tx_dbuffer_change_o,
			tx_dc_data_fifo_wrdata_data_o => s_payload_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_o   => s_payload_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_o       => s_payload_tx_dc_data_fifo_wrreq
		);

	-- FTDI Rx Protocol Payload Reader Instantiation
	ftdi_rx_protocol_payload_reader_ent_inst : entity work.ftdi_rx_protocol_payload_reader_ent
		generic map(
			g_DELAY_QQWORD_CLKDIV => 0  -- [100 MHz / 1 = 100 MHz = 10 ns]
		)
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			data_rx_stop_i                => ftdi_module_stop_i,
			data_rx_start_i               => ftdi_module_start_i,
			payload_reader_abort_i        => '0',
			payload_reader_start_i        => s_payload_reader_start,
			payload_reader_reset_i        => s_payload_reader_reset,
			payload_length_bytes_i        => s_payload_reader_length_bytes,
			payload_qqword_delay_i        => req_half_ccd_request_timeout_i,
			rx_dc_data_fifo_rddata_data_i => rx_dc_data_fifo_rddata_data_i,
			rx_dc_data_fifo_rddata_be_i   => rx_dc_data_fifo_rddata_be_i,
			rx_dc_data_fifo_rdempty_i     => rx_dc_data_fifo_rdempty_i,
			rx_dc_data_fifo_rdfull_i      => rx_dc_data_fifo_rdfull_i,
			rx_dc_data_fifo_rdusedw_i     => rx_dc_data_fifo_rdusedw_i,
			buffer_stat_full_i            => rx_dbuffer_stat_full_i,
			buffer_wrready_i              => rx_dbuffer_wrready_i,
			payload_reader_busy_o         => s_payload_reader_busy,
			payload_crc32_match_o         => s_payload_reader_crc32_match,
			payload_eop_error_o           => s_payload_reader_eop_error,
			payload_last_rx_buffer_o      => rly_half_ccd_last_rx_buffer_o,
			rx_dc_data_fifo_rdreq_o       => s_payload_rx_dc_data_fifo_rdreq,
			buffer_data_loaded_o          => rx_dbuffer_data_loaded_o,
			buffer_wrdata_o               => rx_dbuffer_wrdata_o,
			buffer_wrreq_o                => rx_dbuffer_wrreq_o
		);

	-- Signals Assignments --

	-- Tx DC Data FIFO Assignments
	tx_dc_data_fifo_wrdata_data_o <= (s_header_tx_dc_data_fifo_wrdata_data) or (s_payload_tx_dc_data_fifo_wrdata_data);
	tx_dc_data_fifo_wrdata_be_o   <= (s_header_tx_dc_data_fifo_wrdata_be) or (s_payload_tx_dc_data_fifo_wrdata_be);
	tx_dc_data_fifo_wrreq_o       <= (s_header_tx_dc_data_fifo_wrreq) or (s_payload_tx_dc_data_fifo_wrreq);

	-- Rx DC Data FIFO Assignments
	rx_dc_data_fifo_rdreq_o <= (s_header_rx_dc_data_fifo_rdreq) or (s_payload_rx_dc_data_fifo_rdreq);

	-- FTDI Tx Protocol Header Generator Assignments
	s_header_generator_start                           <= (s_imgc_header_generator_start) or (s_lutc_header_generator_start);
	s_header_generator_reset                           <= (s_imgc_header_generator_reset) or (s_lutc_header_generator_reset);
	s_header_generator_data.package_id                 <= (s_imgc_header_generator_data.package_id) or (s_lutc_header_generator_data.package_id);
	s_header_generator_data.image_selection.fee_number <= (s_imgc_header_generator_data.image_selection.fee_number) or (s_lutc_header_generator_data.image_selection.fee_number);
	s_header_generator_data.image_selection.ccd_number <= (s_imgc_header_generator_data.image_selection.ccd_number) or (s_lutc_header_generator_data.image_selection.ccd_number);
	s_header_generator_data.image_selection.ccd_side   <= (s_imgc_header_generator_data.image_selection.ccd_side) or (s_lutc_header_generator_data.image_selection.ccd_side);
	s_header_generator_data.image_size.ccd_height      <= (s_imgc_header_generator_data.image_size.ccd_height) or (s_lutc_header_generator_data.image_size.ccd_height);
	s_header_generator_data.image_size.ccd_width       <= (s_imgc_header_generator_data.image_size.ccd_width) or (s_lutc_header_generator_data.image_size.ccd_width);
	s_header_generator_data.exposure_number            <= (s_imgc_header_generator_data.exposure_number) or (s_lutc_header_generator_data.exposure_number);
	s_header_generator_data.payload_length             <= (s_imgc_header_generator_data.payload_length) or (s_lutc_header_generator_data.payload_length);

	-- FTDI Rx Protocol Header Parser Assignments
	s_header_parser_abort <= (s_imgc_header_parser_abort) or (s_lutc_header_parser_abort);
	s_header_parser_start <= (s_imgc_header_parser_start) or (s_lutc_header_parser_start);
	s_header_parser_reset <= (s_imgc_header_parser_reset) or (s_lutc_header_parser_reset);

end architecture RTL;
