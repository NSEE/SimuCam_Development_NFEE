library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_imgdata_controller_top is
	generic(
		g_FEE_CCD_SIDE : std_logic := '0'
	);
	port(
		clk_i                              : in  std_logic;
		rst_i                              : in  std_logic;
		-- general inputs
		fee_current_timecode_i             : in  std_logic_vector(7 downto 0);
		-- fee imgdata controller control
		dataman_sync_i                     : in  std_logic;
		imgdataman_start_i                 : in  std_logic;
		imgdataman_reset_i                 : in  std_logic;
		fee_current_frame_number_i         : in  std_logic_vector(1 downto 0);
		fee_current_frame_counter_i        : in  std_logic_vector(15 downto 0);
		-- fee data controller control
		fee_machine_clear_i                : in  std_logic;
		fee_machine_stop_i                 : in  std_logic;
		fee_machine_start_i                : in  std_logic;
		fee_digitalise_en_i                : in  std_logic;
		fee_windowing_en_i                 : in  std_logic;
		fee_pattern_en_i                   : in  std_logic;
		-- fee windowing buffer status
		fee_window_data_i                  : in  std_logic_vector(15 downto 0);
		fee_window_mask_i                  : in  std_logic;
		fee_window_data_valid_i            : in  std_logic;
		fee_window_mask_valid_i            : in  std_logic;
		fee_window_data_ready_i            : in  std_logic;
		fee_window_mask_ready_i            : in  std_logic;
		-- data packet parameters
		data_pkt_ccd_x_size_i              : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_y_size_i              : in  std_logic_vector(15 downto 0);
		data_pkt_data_y_size_i             : in  std_logic_vector(15 downto 0);
		data_pkt_overscan_y_size_i         : in  std_logic_vector(15 downto 0);
		data_pkt_packet_length_i           : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_i                : in  std_logic_vector(3 downto 0);
		data_pkt_ccd_number_i              : in  std_logic_vector(1 downto 0);
		data_pkt_ccd_v_start_i             : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_v_end_i               : in  std_logic_vector(15 downto 0);
		data_pkt_protocol_id_i             : in  std_logic_vector(7 downto 0);
		data_pkt_logical_addr_i            : in  std_logic_vector(7 downto 0);
		-- data delays parameters
		data_pkt_start_delay_i             : in  std_logic_vector(31 downto 0);
		data_pkt_skip_delay_i              : in  std_logic_vector(31 downto 0);
		data_pkt_line_delay_i              : in  std_logic_vector(31 downto 0);
		data_pkt_adc_delay_i               : in  std_logic_vector(31 downto 0);
		-- fee masking buffer control
		masking_buffer_overflow_i          : in  std_logic;
		-- fee imgdata send buffer control
		imgdata_send_buffer_control_i      : in  t_fee_dpkt_send_buffer_control;
		-- fee output buffer status
		fee_output_buffer_overflowed_o     : out std_logic;
		-- fee imgdata controller status
		imgdataman_finished_o              : out std_logic;
		-- fee imgdata headerdata
		imgdata_headerdata_o               : out t_fee_dpkt_headerdata;
		-- fee windowing buffer control
		fee_window_data_read_o             : out std_logic;
		fee_window_mask_read_o             : out std_logic;
		-- fee imgdata send buffer status
		imgdata_send_buffer_status_o       : out t_fee_dpkt_send_buffer_status;
		imgdata_send_buffer_data_type_o    : out std_logic_vector(1 downto 0);
		imgdata_send_buffer_data_end_o     : out std_logic;
		imgdata_send_double_buffer_empty_o : out std_logic
	);
end entity fee_imgdata_controller_top;

architecture RTL of fee_imgdata_controller_top is

	-- general signals
	-- masking machine signals
	signal s_masking_machine_hold          : std_logic;
	signal s_masking_machine_finished      : std_logic;
	--	signal s_masking_buffer_clear               : std_logic;
	signal s_masking_buffer_rdreq          : std_logic;
	signal s_masking_buffer_almost_empty   : std_logic;
	signal s_masking_buffer_empty          : std_logic;
	signal s_masking_buffer_rddata         : std_logic_vector(9 downto 0);
	-- header data signals
	signal s_header_gen_headerdata         : t_fee_dpkt_headerdata;
	-- header generator signals
	signal s_header_gen_finished           : std_logic;
	signal s_header_gen_send               : std_logic;
	signal s_header_gen_reset              : std_logic;
	signal s_send_buffer_header_gen_wrdata : std_logic_vector(7 downto 0);
	signal s_send_buffer_header_gen_wrreq  : std_logic;
	-- data writer signals
	signal s_data_wr_busy                  : std_logic;
	signal s_data_wr_finished              : std_logic;
	signal s_data_wr_data_changed          : std_logic;
	signal s_data_wr_start                 : std_logic;
	signal s_data_wr_reset                 : std_logic;
	signal s_data_wr_length                : std_logic_vector(15 downto 0);
	signal s_send_buffer_data_wr_wrdata    : std_logic_vector(7 downto 0);
	signal s_send_buffer_data_wr_wrreq     : std_logic;
	-- send buffer signals
	signal s_send_buffer_fee_data_loaded   : std_logic;
	signal s_send_buffer_wrdata            : std_logic_vector(7 downto 0);
	signal s_send_buffer_wrreq             : std_logic;
	signal s_send_buffer_stat_full         : std_logic;
	signal s_send_buffer_wrready           : std_logic;
	signal s_send_double_buffer_wrable     : std_logic;
	signal s_send_buffer_data_type_wrdata  : std_logic_vector(1 downto 0);
	signal s_send_buffer_data_type_wrreq   : std_logic;
	signal s_send_buffer_data_end_wrdata   : std_logic;
	signal s_send_buffer_data_end_wrreq    : std_logic;

begin

	-- masking machine instantiation
	masking_machine_ent_inst : entity work.masking_machine_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			sync_signal_i                 => dataman_sync_i,
			fee_clear_signal_i            => fee_machine_clear_i,
			fee_stop_signal_i             => fee_machine_stop_i,
			fee_start_signal_i            => fee_machine_start_i,
			fee_digitalise_en_i           => fee_digitalise_en_i,
			fee_windowing_en_i            => fee_windowing_en_i,
			fee_pattern_en_i              => fee_pattern_en_i,
			masking_machine_hold_i        => s_masking_machine_hold,
			masking_buffer_overflow_i     => masking_buffer_overflow_i,
			fee_ccd_x_size_i              => data_pkt_ccd_x_size_i,
			fee_ccd_y_size_i              => data_pkt_ccd_y_size_i,
			fee_data_y_size_i             => data_pkt_data_y_size_i,
			fee_overscan_y_size_i         => data_pkt_overscan_y_size_i,
			fee_ccd_v_start_i             => data_pkt_ccd_v_start_i,
			fee_ccd_v_end_i               => data_pkt_ccd_v_end_i,
			fee_start_delay_i             => data_pkt_start_delay_i,
			fee_skip_delay_i              => data_pkt_skip_delay_i,
			fee_line_delay_i              => data_pkt_line_delay_i,
			fee_adc_delay_i               => data_pkt_adc_delay_i,
			current_timecode_i            => fee_current_timecode_i,
			current_ccd_i                 => data_pkt_ccd_number_i,
			current_side_i                => g_FEE_CCD_SIDE,
			window_data_i                 => fee_window_data_i,
			window_mask_i                 => fee_window_mask_i,
			window_data_valid_i           => fee_window_data_valid_i,
			window_mask_valid_i           => fee_window_mask_valid_i,
			window_data_ready_i           => fee_window_data_ready_i,
			window_mask_ready_i           => fee_window_mask_ready_i,
			masking_buffer_rdreq_i        => s_masking_buffer_rdreq,
			send_double_buffer_wrable_i   => s_send_double_buffer_wrable,
			masking_machine_finished_o    => s_masking_machine_finished,
			masking_buffer_overflowed_o   => fee_output_buffer_overflowed_o,
			window_data_read_o            => fee_window_data_read_o,
			window_mask_read_o            => fee_window_mask_read_o,
			masking_buffer_almost_empty_o => s_masking_buffer_almost_empty,
			masking_buffer_empty_o        => s_masking_buffer_empty,
			masking_buffer_rddata_o       => s_masking_buffer_rddata
		);

	-- image data manager instantiation
	fee_imgdata_manager_ent_inst : entity work.fee_imgdata_manager_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			fee_clear_signal_i            => fee_machine_clear_i,
			fee_stop_signal_i             => fee_machine_stop_i,
			fee_start_signal_i            => fee_machine_start_i,
			fee_digitalise_en_i           => fee_digitalise_en_i,
			current_frame_number_i        => fee_current_frame_number_i,
			current_frame_counter_i       => fee_current_frame_counter_i,
			fee_logical_addr_i            => data_pkt_logical_addr_i,
			fee_protocol_id_i             => data_pkt_protocol_id_i,
			fee_packet_length_i           => data_pkt_packet_length_i,
			fee_fee_mode_i                => data_pkt_fee_mode_i,
			fee_ccd_number_i              => data_pkt_ccd_number_i,
			fee_ccd_side_i                => g_FEE_CCD_SIDE,
			imgdata_manager_start_i       => imgdataman_start_i,
			imgdata_manager_reset_i       => imgdataman_reset_i,
			header_gen_i.finished         => s_header_gen_finished,
			data_wr_finished_i            => s_data_wr_finished,
			data_wr_data_changed_i        => s_data_wr_data_changed,
			masking_machine_hold_o        => s_masking_machine_hold,
			imgdata_manager_finished_o    => imgdataman_finished_o,
			headerdata_o                  => s_header_gen_headerdata,
			header_gen_o.start            => s_header_gen_send,
			header_gen_o.reset            => s_header_gen_reset,
			data_wr_start_o               => s_data_wr_start,
			data_wr_reset_o               => s_data_wr_reset,
			data_wr_length_o              => s_data_wr_length,
			send_buffer_fee_data_loaded_o => s_send_buffer_fee_data_loaded
		);

	-- data packet header generator instantiation
	data_packet_header_gen_ent_inst : entity work.data_packet_header_gen_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			header_gen_send_i              => s_header_gen_send,
			header_gen_reset_i             => s_header_gen_reset,
			headerdata_i                   => s_header_gen_headerdata,
			send_buffer_stat_almost_full_i => '0',
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			header_gen_finished_o          => s_header_gen_finished,
			send_buffer_wrdata_o           => s_send_buffer_header_gen_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_header_gen_wrreq,
			send_buffer_data_type_wrdata_o => s_send_buffer_data_type_wrdata,
			send_buffer_data_type_wrreq_o  => s_send_buffer_data_type_wrreq
		);

	-- data packet data writer instantiation
	data_packet_data_writer_ent_inst : entity work.data_packet_data_writer_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			data_wr_start_i                => s_data_wr_start,
			data_wr_reset_i                => s_data_wr_reset,
			data_wr_length_i               => s_data_wr_length,
			masking_buffer_almost_empty_i  => s_masking_buffer_almost_empty,
			masking_buffer_empty_i         => s_masking_buffer_empty,
			masking_buffer_rddata_i        => s_masking_buffer_rddata,
			send_buffer_stat_almost_full_i => '0',
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			data_wr_busy_o                 => s_data_wr_busy,
			data_wr_finished_o             => s_data_wr_finished,
			data_wr_data_changed_o         => s_data_wr_data_changed,
			masking_buffer_rdreq_o         => s_masking_buffer_rdreq,
			send_buffer_wrdata_o           => s_send_buffer_data_wr_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_data_wr_wrreq,
			send_buffer_data_end_wrdata_o  => s_send_buffer_data_end_wrdata,
			send_buffer_data_end_wrreq_o   => s_send_buffer_data_end_wrreq
		);

	-- send buffer instantiation
	send_buffer_ent_inst : entity work.send_buffer_ent
		generic map(
			g_1K_SEND_BUFFER_SIZE => '0' -- '0' : 32 KiB of send buffer / '1' : 1 KiB of send buffer
		)
		port map(
			clk_i                        => clk_i,
			rst_i                        => rst_i,
			fee_clear_signal_i           => fee_machine_clear_i,
			fee_stop_signal_i            => fee_machine_stop_i,
			fee_start_signal_i           => fee_machine_start_i,
			fee_data_loaded_i            => s_send_buffer_fee_data_loaded,
			buffer_cfg_length_i          => data_pkt_packet_length_i,
			buffer_wrdata_i              => s_send_buffer_wrdata,
			buffer_wrreq_i               => s_send_buffer_wrreq,
			buffer_rdreq_i               => imgdata_send_buffer_control_i.rdreq,
			buffer_change_i              => imgdata_send_buffer_control_i.change,
			data_type_wrdata_i           => s_send_buffer_data_type_wrdata,
			data_type_wrreq_i            => s_send_buffer_data_type_wrreq,
			data_end_wrdata_i            => s_send_buffer_data_end_wrdata,
			data_end_wrreq_i             => s_send_buffer_data_end_wrreq,
			buffer_stat_almost_empty_o   => open,
			buffer_stat_almost_full_o    => open,
			buffer_stat_empty_o          => imgdata_send_buffer_status_o.stat_empty,
			buffer_stat_extended_usedw_o => imgdata_send_buffer_status_o.stat_extended_usedw,
			buffer_stat_full_o           => s_send_buffer_stat_full,
			buffer_rddata_o              => imgdata_send_buffer_status_o.rddata,
			buffer_rdready_o             => imgdata_send_buffer_status_o.rdready,
			buffer_wrready_o             => s_send_buffer_wrready,
			data_type_rddata_o           => imgdata_send_buffer_data_type_o,
			data_end_rddata_o            => imgdata_send_buffer_data_end_o,
			double_buffer_empty_o        => imgdata_send_double_buffer_empty_o,
			double_buffer_wrable_o       => s_send_double_buffer_wrable
		);
	s_send_buffer_wrdata <= (s_send_buffer_header_gen_wrdata) or (s_send_buffer_data_wr_wrdata);
	s_send_buffer_wrreq  <= (s_send_buffer_header_gen_wrreq) or (s_send_buffer_data_wr_wrreq);

	-- signals assingments
	imgdata_headerdata_o <= s_header_gen_headerdata;

end architecture RTL;
