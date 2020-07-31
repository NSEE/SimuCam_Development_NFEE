library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_data_controller_top is
	port(
		clk_i                                  : in  std_logic;
		rst_i                                  : in  std_logic;
		-- general inputs
		fee_sync_signal_i                      : in  std_logic;
		fee_current_timecode_i                 : in  std_logic_vector(7 downto 0);
		fee_clear_frame_i                      : in  std_logic;
		fee_left_buffer_activated_i            : in  std_logic;
		fee_right_buffer_activated_i           : in  std_logic;
		-- fee data controller control
		fee_machine_clear_i                    : in  std_logic;
		fee_machine_stop_i                     : in  std_logic;
		fee_machine_start_i                    : in  std_logic;
		fee_digitalise_en_i                    : in  std_logic;
		fee_readout_en_i                       : in  std_logic;
		fee_window_list_en_i                   : in  std_logic;
		-- fee left windowing buffer status
		fee_left_window_data_i                 : in  std_logic_vector(15 downto 0);
		fee_left_window_mask_i                 : in  std_logic;
		fee_left_window_data_valid_i           : in  std_logic;
		fee_left_window_mask_valid_i           : in  std_logic;
		fee_left_window_data_ready_i           : in  std_logic;
		fee_left_window_mask_ready_i           : in  std_logic;
		-- fee right windowing buffer status
		fee_right_window_data_i                : in  std_logic_vector(15 downto 0);
		fee_right_window_mask_i                : in  std_logic;
		fee_right_window_data_valid_i          : in  std_logic;
		fee_right_window_mask_valid_i          : in  std_logic;
		fee_right_window_data_ready_i          : in  std_logic;
		fee_right_window_mask_ready_i          : in  std_logic;
		-- fee housekeeping memory status
		fee_hk_mem_waitrequest_i               : in  std_logic;
		fee_hk_mem_data_i                      : in  std_logic_vector(7 downto 0);
		-- fee spw codec tx status
		fee_spw_tx_ready_i                     : in  std_logic;
		fee_spw_link_running_i                 : in  std_logic;
		-- data packet parameters
		data_pkt_ccd_x_size_i                  : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_y_size_i                  : in  std_logic_vector(15 downto 0);
		data_pkt_data_y_size_i                 : in  std_logic_vector(15 downto 0);
		data_pkt_overscan_y_size_i             : in  std_logic_vector(15 downto 0);
		data_pkt_packet_length_i               : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_i                    : in  std_logic_vector(4 downto 0);
		data_pkt_ccd_number_i                  : in  std_logic_vector(1 downto 0);
		data_pkt_ccd_v_start_i                 : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_v_end_i                   : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_img_v_end_i               : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_ovs_v_end_i               : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_h_start_i                 : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_h_end_i                   : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_img_en_i                  : in  std_logic;
		data_pkt_ccd_ovs_en_i                  : in  std_logic;
		data_pkt_protocol_id_i                 : in  std_logic_vector(7 downto 0);
		data_pkt_logical_addr_i                : in  std_logic_vector(7 downto 0);
		-- data delays parameters
		data_pkt_start_delay_i                 : in  std_logic_vector(31 downto 0);
		data_pkt_skip_delay_i                  : in  std_logic_vector(31 downto 0);
		data_pkt_line_delay_i                  : in  std_logic_vector(31 downto 0);
		data_pkt_adc_delay_i                   : in  std_logic_vector(31 downto 0);
		-- fee masking buffer control
		masking_buffer_overflow_i              : in  std_logic;
		-- pixels left circular buffer control
		pixels_left_cbuffer_address_offset_i   : in  std_logic_vector(63 downto 0);
		pixels_left_cbuffer_size_bytes_i       : in  std_logic_vector(23 downto 0);
		-- pixels left circular buffer avm slave status
		pixels_left_cbuffer_avm_readdata_i     : in  std_logic_vector(255 downto 0);
		pixels_left_cbuffer_avm_waitrequest_i  : in  std_logic;
		-- pixels right circular buffer control
		pixels_right_cbuffer_address_offset_i  : in  std_logic_vector(63 downto 0);
		pixels_right_cbuffer_size_bytes_i      : in  std_logic_vector(23 downto 0);
		-- pixels right circular buffer avm slave status
		pixels_right_cbuffer_avm_readdata_i    : in  std_logic_vector(255 downto 0);
		pixels_right_cbuffer_avm_waitrequest_i : in  std_logic;
		-- windowing parameters
		windowing_packet_order_list_i          : in  std_logic_vector(511 downto 0);
		windowing_last_left_packet_i           : in  std_logic_vector(9 downto 0);
		windowing_last_right_packet_i          : in  std_logic_vector(9 downto 0);
		-- error injection control
		spw_errinj_eep_received_i              : in  std_logic;
		spw_errinj_sequence_cnt_i              : in  std_logic_vector(15 downto 0);
		spw_errinj_n_repeat_i                  : in  std_logic_vector(15 downto 0);
		trans_errinj_tx_disabled_i             : in  std_logic;
		trans_errinj_missing_pkts_i            : in  std_logic;
		trans_errinj_missing_data_i            : in  std_logic;
		trans_errinj_frame_num_i               : in  std_logic_vector(1 downto 0);
		trans_errinj_sequence_cnt_i            : in  std_logic_vector(15 downto 0);
		trans_errinj_data_cnt_i                : in  std_logic_vector(15 downto 0);
		trans_errinj_n_repeat_i                : in  std_logic_vector(15 downto 0);
		-- fee machine status
		fee_machine_busy_o                     : out std_logic;
		-- fee frame status
		fee_frame_counter_o                    : out std_logic_vector(15 downto 0);
		fee_frame_number_o                     : out std_logic_vector(1 downto 0);
		-- fee left output buffer status
		fee_left_output_buffer_overflowed_o    : out std_logic;
		-- fee right output buffer status
		fee_right_output_buffer_overflowed_o   : out std_logic;
		-- fee left windowing buffer control
		fee_left_window_data_read_o            : out std_logic;
		fee_left_window_mask_read_o            : out std_logic;
		-- fee right windowing buffer control
		fee_right_window_data_read_o           : out std_logic;
		fee_right_window_mask_read_o           : out std_logic;
		-- pixels left circular buffer avm slave control
		pixels_left_cbuffer_avm_address_o      : out std_logic_vector(63 downto 0);
		pixels_left_cbuffer_avm_write_o        : out std_logic;
		pixels_left_cbuffer_avm_writedata_o    : out std_logic_vector(255 downto 0);
		pixels_left_cbuffer_avm_read_o         : out std_logic;
		-- pixels right circular buffer avm slave control
		pixels_right_cbuffer_avm_address_o     : out std_logic_vector(63 downto 0);
		pixels_right_cbuffer_avm_write_o       : out std_logic;
		pixels_right_cbuffer_avm_writedata_o   : out std_logic_vector(255 downto 0);
		pixels_right_cbuffer_avm_read_o        : out std_logic;
		-- fee housekeeping memory control
		fee_hk_mem_byte_address_o              : out std_logic_vector(31 downto 0);
		fee_hk_mem_read_o                      : out std_logic;
		-- fee spw codec tx control
		fee_spw_tx_write_o                     : out std_logic;
		fee_spw_tx_flag_o                      : out std_logic;
		fee_spw_tx_data_o                      : out std_logic_vector(7 downto 0)
	);
end entity fee_data_controller_top;

architecture RTL of fee_data_controller_top is

	-- general signals
	signal s_current_frame_number                   : std_logic_vector(1 downto 0);
	signal s_current_frame_counter                  : std_logic_vector(15 downto 0);
	-- fee data manager signals
	signal s_dataman_sync                           : std_logic;
	signal s_dataman_hk_only                        : std_logic;
	signal s_data_headerdata                        : t_fee_dpkt_headerdata;
	-- fee housekeeping data controller signals
	signal s_hkdataman_status                       : t_fee_dpkt_general_status;
	signal s_hkdataman_control                      : t_fee_dpkt_general_control;
	signal s_hkdata_send_buffer_control             : t_fee_dpkt_send_buffer_control;
	signal s_hkdata_send_buffer_status              : t_fee_dpkt_send_buffer_status;
	signal s_hkdata_send_double_buffer_empty        : std_logic;
	-- fee left image data controller signals
	signal s_left_imgdataman_status                 : t_fee_dpkt_general_status;
	signal s_left_imgdataman_control                : t_fee_dpkt_general_control;
	signal s_left_imgdata_send_buffer_control       : t_fee_dpkt_send_buffer_control;
	signal s_left_imgdata_send_buffer_status        : t_fee_dpkt_send_buffer_status;
	signal s_left_imgdata_send_double_buffer_empty  : std_logic;
	-- fee right image data controller signals
	signal s_right_imgdataman_status                : t_fee_dpkt_general_status;
	signal s_right_imgdataman_control               : t_fee_dpkt_general_control;
	signal s_right_imgdata_send_buffer_control      : t_fee_dpkt_send_buffer_control;
	signal s_right_imgdata_send_buffer_status       : t_fee_dpkt_send_buffer_status;
	signal s_right_imgdata_send_double_buffer_empty : std_logic;
	-- data transmitter signals
	signal s_data_transmitter_busy                  : std_logic;
	signal s_data_transmitter_finished              : std_logic;
	-- registered data packet parameters signals (for the entire read-out)
	signal s_registered_dpkt_params                 : t_fee_dpkt_registered_params;
	signal s_registered_left_buffer_activated       : std_logic;
	signal s_registered_right_buffer_activated      : std_logic;
	-- error injection spw signals
	signal s_errinj_spw_tx_write                    : std_logic;
	signal s_errinj_spw_tx_flag                     : std_logic;
	signal s_errinj_spw_tx_data                     : std_logic_vector(7 downto 0);
	signal s_errinj_spw_tx_ready                    : std_logic;
	-- spw write masking
	signal s_spw_tx_write                           : std_logic;
	signal s_spw_write_mask                         : std_logic;

begin

	-- fee data manager instantiation
	fee_data_manager_ent_inst : entity work.fee_data_manager_ent
		port map(
			clk_i                                    => clk_i,
			rst_i                                    => rst_i,
			fee_clear_signal_i                       => fee_machine_clear_i,
			fee_stop_signal_i                        => fee_machine_stop_i,
			fee_start_signal_i                       => fee_machine_start_i,
			fee_manager_sync_i                       => s_dataman_sync,
			fee_manager_hk_only_i                    => s_dataman_hk_only,
			fee_left_buffer_activated_i              => s_registered_left_buffer_activated,
			fee_right_buffer_activated_i             => s_registered_right_buffer_activated,
			hkdataman_manager_i                      => s_hkdataman_status,
			left_imgdataman_manager_i                => s_left_imgdataman_status,
			right_imgdataman_manager_i               => s_right_imgdataman_status,
			data_transmitter_finished_i              => s_data_transmitter_finished,
			hkdata_send_double_buffer_empty_i        => s_hkdata_send_double_buffer_empty,
			left_imgdata_send_double_buffer_empty_i  => s_left_imgdata_send_double_buffer_empty,
			right_imgdata_send_double_buffer_empty_i => s_right_imgdata_send_double_buffer_empty,
			fee_data_manager_busy_o                  => fee_machine_busy_o,
			hkdataman_manager_o                      => s_hkdataman_control,
			left_imgdataman_manager_o                => s_left_imgdataman_control,
			right_imgdataman_manager_o               => s_right_imgdataman_control
		);

	-- fee housekeeping data manager instantiation
	fee_hkdata_controller_top_inst : entity work.fee_hkdata_controller_top
		port map(
			clk_i                             => clk_i,
			rst_i                             => rst_i,
			hkdataman_start_i                 => s_hkdataman_control.start,
			hkdataman_reset_i                 => s_hkdataman_control.reset,
			fee_manager_hk_only_i             => s_dataman_hk_only,
			fee_current_frame_number_i        => s_current_frame_number,
			fee_current_frame_counter_i       => s_current_frame_counter,
			fee_machine_clear_i               => fee_machine_clear_i,
			fee_machine_stop_i                => fee_machine_stop_i,
			fee_machine_start_i               => fee_machine_start_i,
			fee_hk_mem_waitrequest_i          => fee_hk_mem_waitrequest_i,
			fee_hk_mem_data_i                 => fee_hk_mem_data_i,
			data_pkt_packet_length_i          => x"0400", -- 0x400 = 1024 Bytes
			data_pkt_fee_mode_i               => s_registered_dpkt_params.image.fee_mode,
			data_pkt_ccd_number_i             => s_registered_dpkt_params.image.ccd_number,
			data_pkt_ccd_side_i               => s_registered_dpkt_params.image.ccd_side_hk,
			data_pkt_protocol_id_i            => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i           => s_registered_dpkt_params.image.logical_addr,
			hkdata_send_buffer_control_i      => s_hkdata_send_buffer_control,
			hkdataman_finished_o              => s_hkdataman_status.finished,
			hkdata_headerdata_o               => open,
			fee_hk_mem_byte_address_o         => fee_hk_mem_byte_address_o,
			fee_hk_mem_read_o                 => fee_hk_mem_read_o,
			hkdata_send_buffer_status_o       => s_hkdata_send_buffer_status,
			hkdata_send_double_buffer_empty_o => s_hkdata_send_double_buffer_empty
		);

	-- fee left image data manager instantiation
	fee_left_imgdata_controller_top_inst : entity work.fee_imgdata_controller_top
		generic map(
			g_FEE_CCD_SIDE => c_COMM_NFEE_CCD_SIDE_E
		)
		port map(
			clk_i                              => clk_i,
			rst_i                              => rst_i,
			fee_current_timecode_i             => fee_current_timecode_i,
			dataman_sync_i                     => s_dataman_sync,
			imgdataman_start_i                 => s_left_imgdataman_control.start,
			imgdataman_reset_i                 => s_left_imgdataman_control.reset,
			fee_current_frame_number_i         => s_current_frame_number,
			fee_current_frame_counter_i        => s_current_frame_counter,
			fee_machine_clear_i                => fee_machine_clear_i,
			fee_machine_stop_i                 => fee_machine_stop_i,
			fee_machine_start_i                => fee_machine_start_i,
			fee_windowing_en_i                 => s_registered_dpkt_params.transmission.windowing_en,
			fee_pattern_en_i                   => s_registered_dpkt_params.transmission.pattern_en,
			fee_window_data_i                  => fee_left_window_data_i,
			fee_window_mask_i                  => fee_left_window_mask_i,
			fee_window_data_valid_i            => fee_left_window_data_valid_i,
			fee_window_mask_valid_i            => fee_left_window_mask_valid_i,
			fee_window_data_ready_i            => fee_left_window_data_ready_i,
			fee_window_mask_ready_i            => fee_left_window_mask_ready_i,
			data_pkt_ccd_x_size_i              => s_registered_dpkt_params.image.ccd_x_size,
			data_pkt_ccd_y_size_i              => s_registered_dpkt_params.image.ccd_y_size,
			data_pkt_data_y_size_i             => s_registered_dpkt_params.image.data_y_size,
			data_pkt_overscan_y_size_i         => s_registered_dpkt_params.image.overscan_y_size,
			data_pkt_packet_length_i           => s_registered_dpkt_params.image.packet_length,
			data_pkt_fee_mode_i                => s_registered_dpkt_params.image.fee_mode,
			data_pkt_ccd_number_i              => s_registered_dpkt_params.image.ccd_number,
			data_pkt_ccd_v_start_i             => s_registered_dpkt_params.image.ccd_v_start,
			data_pkt_ccd_v_end_i               => s_registered_dpkt_params.image.ccd_v_end,
			data_pkt_ccd_img_v_end_i           => s_registered_dpkt_params.image.ccd_img_v_end,
			data_pkt_ccd_ovs_v_end_i           => s_registered_dpkt_params.image.ccd_ovs_v_end,
			data_pkt_ccd_h_start_i             => s_registered_dpkt_params.image.ccd_h_start,
			data_pkt_ccd_h_end_i               => s_registered_dpkt_params.image.ccd_h_end,
			data_pkt_ccd_img_en_i              => s_registered_dpkt_params.image.ccd_img_en,
			data_pkt_ccd_ovs_en_i              => s_registered_dpkt_params.image.ccd_ovs_en,
			data_pkt_protocol_id_i             => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i            => s_registered_dpkt_params.image.logical_addr,
			data_pkt_start_delay_i             => s_registered_dpkt_params.image.start_delay,
			data_pkt_skip_delay_i              => s_registered_dpkt_params.image.skip_delay,
			data_pkt_line_delay_i              => s_registered_dpkt_params.image.line_delay,
			data_pkt_adc_delay_i               => s_registered_dpkt_params.image.adc_delay,
			masking_buffer_overflow_i          => s_registered_dpkt_params.transmission.overflow_en,
			pixels_cbuffer_address_offset_i    => s_registered_dpkt_params.pixels_left_cbuffer.address_offset,
			pixels_cbuffer_size_words_i        => s_registered_dpkt_params.pixels_left_cbuffer.size_words,
			pixels_cbuffer_avm_readdata_i      => pixels_left_cbuffer_avm_readdata_i,
			pixels_cbuffer_avm_waitrequest_i   => pixels_left_cbuffer_avm_waitrequest_i,
			imgdata_send_buffer_control_i      => s_left_imgdata_send_buffer_control,
			fee_output_buffer_overflowed_o     => fee_left_output_buffer_overflowed_o,
			imgdataman_finished_o              => s_left_imgdataman_status.finished,
			imgdata_headerdata_o               => open,
			fee_window_data_read_o             => fee_left_window_data_read_o,
			fee_window_mask_read_o             => fee_left_window_mask_read_o,
			pixels_cbuffer_avm_address_o       => pixels_left_cbuffer_avm_address_o,
			pixels_cbuffer_avm_write_o         => pixels_left_cbuffer_avm_write_o,
			pixels_cbuffer_avm_writedata_o     => pixels_left_cbuffer_avm_writedata_o,
			pixels_cbuffer_avm_read_o          => pixels_left_cbuffer_avm_read_o,
			imgdata_send_buffer_status_o       => s_left_imgdata_send_buffer_status,
			imgdata_send_double_buffer_empty_o => s_left_imgdata_send_double_buffer_empty
		);

	-- fee right image data manager instantiation
	fee_right_imgdata_controller_top_inst : entity work.fee_imgdata_controller_top
		generic map(
			g_FEE_CCD_SIDE => c_COMM_NFEE_CCD_SIDE_F
		)
		port map(
			clk_i                              => clk_i,
			rst_i                              => rst_i,
			fee_current_timecode_i             => fee_current_timecode_i,
			dataman_sync_i                     => s_dataman_sync,
			imgdataman_start_i                 => s_right_imgdataman_control.start,
			imgdataman_reset_i                 => s_right_imgdataman_control.reset,
			fee_current_frame_number_i         => s_current_frame_number,
			fee_current_frame_counter_i        => s_current_frame_counter,
			fee_machine_clear_i                => fee_machine_clear_i,
			fee_machine_stop_i                 => fee_machine_stop_i,
			fee_machine_start_i                => fee_machine_start_i,
			fee_windowing_en_i                 => s_registered_dpkt_params.transmission.windowing_en,
			fee_pattern_en_i                   => s_registered_dpkt_params.transmission.pattern_en,
			fee_window_data_i                  => fee_right_window_data_i,
			fee_window_mask_i                  => fee_right_window_mask_i,
			fee_window_data_valid_i            => fee_right_window_data_valid_i,
			fee_window_mask_valid_i            => fee_right_window_mask_valid_i,
			fee_window_data_ready_i            => fee_right_window_data_ready_i,
			fee_window_mask_ready_i            => fee_right_window_mask_ready_i,
			data_pkt_ccd_x_size_i              => s_registered_dpkt_params.image.ccd_x_size,
			data_pkt_ccd_y_size_i              => s_registered_dpkt_params.image.ccd_y_size,
			data_pkt_data_y_size_i             => s_registered_dpkt_params.image.data_y_size,
			data_pkt_overscan_y_size_i         => s_registered_dpkt_params.image.overscan_y_size,
			data_pkt_packet_length_i           => s_registered_dpkt_params.image.packet_length,
			data_pkt_fee_mode_i                => s_registered_dpkt_params.image.fee_mode,
			data_pkt_ccd_number_i              => s_registered_dpkt_params.image.ccd_number,
			data_pkt_ccd_v_start_i             => s_registered_dpkt_params.image.ccd_v_start,
			data_pkt_ccd_v_end_i               => s_registered_dpkt_params.image.ccd_v_end,
			data_pkt_ccd_img_v_end_i           => s_registered_dpkt_params.image.ccd_img_v_end,
			data_pkt_ccd_ovs_v_end_i           => s_registered_dpkt_params.image.ccd_ovs_v_end,
			data_pkt_ccd_h_start_i             => s_registered_dpkt_params.image.ccd_h_start,
			data_pkt_ccd_h_end_i               => s_registered_dpkt_params.image.ccd_h_end,
			data_pkt_ccd_img_en_i              => s_registered_dpkt_params.image.ccd_img_en,
			data_pkt_ccd_ovs_en_i              => s_registered_dpkt_params.image.ccd_ovs_en,
			data_pkt_protocol_id_i             => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i            => s_registered_dpkt_params.image.logical_addr,
			data_pkt_start_delay_i             => s_registered_dpkt_params.image.start_delay,
			data_pkt_skip_delay_i              => s_registered_dpkt_params.image.skip_delay,
			data_pkt_line_delay_i              => s_registered_dpkt_params.image.line_delay,
			data_pkt_adc_delay_i               => s_registered_dpkt_params.image.adc_delay,
			masking_buffer_overflow_i          => s_registered_dpkt_params.transmission.overflow_en,
			pixels_cbuffer_address_offset_i    => s_registered_dpkt_params.pixels_right_cbuffer.address_offset,
			pixels_cbuffer_size_words_i        => s_registered_dpkt_params.pixels_right_cbuffer.size_words,
			pixels_cbuffer_avm_readdata_i      => pixels_right_cbuffer_avm_readdata_i,
			pixels_cbuffer_avm_waitrequest_i   => pixels_right_cbuffer_avm_waitrequest_i,
			imgdata_send_buffer_control_i      => s_right_imgdata_send_buffer_control,
			fee_output_buffer_overflowed_o     => fee_right_output_buffer_overflowed_o,
			imgdataman_finished_o              => s_right_imgdataman_status.finished,
			imgdata_headerdata_o               => open,
			fee_window_data_read_o             => fee_right_window_data_read_o,
			fee_window_mask_read_o             => fee_right_window_mask_read_o,
			pixels_cbuffer_avm_address_o       => pixels_right_cbuffer_avm_address_o,
			pixels_cbuffer_avm_write_o         => pixels_right_cbuffer_avm_write_o,
			pixels_cbuffer_avm_writedata_o     => pixels_right_cbuffer_avm_writedata_o,
			pixels_cbuffer_avm_read_o          => pixels_right_cbuffer_avm_read_o,
			imgdata_send_buffer_status_o       => s_right_imgdata_send_buffer_status,
			imgdata_send_double_buffer_empty_o => s_right_imgdata_send_double_buffer_empty
		);

	-- data transmitter top instantiation
	comm_data_transmitter_top_inst : entity work.comm_data_transmitter_top
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			comm_stop_i                    => fee_machine_stop_i,
			comm_start_i                   => fee_machine_start_i,
			channel_sync_i                 => fee_sync_signal_i,
			send_buffer_cfg_length_i       => s_registered_dpkt_params.image.packet_length,
			send_buffer_hkdata_status_i    => s_hkdata_send_buffer_status,
			send_buffer_leftimg_status_i   => s_left_imgdata_send_buffer_status,
			send_buffer_rightimg_status_i  => s_right_imgdata_send_buffer_status,
			spw_tx_ready_i                 => s_errinj_spw_tx_ready,
			housekeep_only_i               => s_dataman_hk_only,
			windowing_enabled_i            => s_registered_dpkt_params.transmission.windowing_en,
			windowing_packet_order_list_i  => s_registered_dpkt_params.windowing.packet_order_list,
			windowing_last_left_packet_i   => s_registered_dpkt_params.windowing.last_left_packet,
			windowing_last_right_packet_i  => s_registered_dpkt_params.windowing.last_right_packet,
			send_buffer_hkdata_control_o   => s_hkdata_send_buffer_control,
			send_buffer_leftimg_control_o  => s_left_imgdata_send_buffer_control,
			send_buffer_rightimg_control_o => s_right_imgdata_send_buffer_control,
			spw_tx_flag_o                  => s_errinj_spw_tx_flag,
			spw_tx_data_o                  => s_errinj_spw_tx_data,
			spw_tx_write_o                 => s_errinj_spw_tx_write
		);

	-- error injection instantiation
	error_injection_ent_inst : entity work.error_injection_ent
		port map(
			clk_i                        => clk_i,
			rst_i                        => rst_i,
			spw_errinj_eep_received_i    => s_registered_dpkt_params.spw_errinj.eep_received,
			spw_errinj_sequence_cnt_i    => s_registered_dpkt_params.spw_errinj.sequence_cnt,
			spw_errinj_n_repeat_i        => s_registered_dpkt_params.spw_errinj.n_repeat,
			trans_errinj_tx_disabled_i   => s_registered_dpkt_params.trans_errinj.tx_disabled,
			trans_errinj_missing_pkts_i  => s_registered_dpkt_params.trans_errinj.missing_pkts,
			trans_errinj_missing_data_i  => s_registered_dpkt_params.trans_errinj.missing_data,
			trans_errinj_frame_num_i     => s_registered_dpkt_params.trans_errinj.frame_num,
			trans_errinj_sequence_cnt_i  => s_registered_dpkt_params.trans_errinj.sequence_cnt,
			trans_errinj_data_cnt_i      => s_registered_dpkt_params.trans_errinj.data_cnt,
			trans_errinj_n_repeat_i      => s_registered_dpkt_params.trans_errinj.n_repeat,
			header_errinj_enable_i       => '0',
			header_errinj_frame_num_i    => (others => '0'),
			header_errinj_sequence_cnt_i => (others => '0'),
			header_errinj_field_id_i     => (others => '0'),
			header_errinj_value_i        => (others => '0'),
			errinj_spw_tx_write_i        => s_errinj_spw_tx_write,
			errinj_spw_tx_flag_i         => s_errinj_spw_tx_flag,
			errinj_spw_tx_data_i         => s_errinj_spw_tx_data,
			fee_spw_tx_ready_i           => fee_spw_tx_ready_i,
			header_errinj_done_o         => open,
			errinj_spw_tx_ready_o        => s_errinj_spw_tx_ready,
			fee_spw_tx_write_o           => s_spw_tx_write,
			fee_spw_tx_flag_o            => fee_spw_tx_flag_o,
			fee_spw_tx_data_o            => fee_spw_tx_data_o
		);

	-- fee frame manager
	p_fee_frame_manager : process(clk_i, rst_i) is
		variable v_full_frame_cnt : std_logic_vector(17 downto 0) := (others => '1');
		variable v_stopped_flag   : std_logic                     := '1';
		variable v_frame_cleared  : std_logic                     := '1';
	begin
		if (rst_i = '1') then
			s_current_frame_counter <= (others => '0');
			s_current_frame_number  <= (others => '0');
			v_full_frame_cnt        := (others => '0');
			v_stopped_flag          := '1';
			v_frame_cleared         := '1';
		elsif rising_edge(clk_i) then

			--
			-- Definitions:
			--
			-- frame counter : full read-out cycle counter
			--   |  frame counter |
			--   |  15 downto  0  |
			--
			-- frame number : current frame inside a full read-out cycle
			--   |   frame number |
			--   |   1 downto  0  |
			--
			-- full frame counter:
			--   |  frame counter |   frame number |
			--   |  17 downto  2  |   1 downto  0  |
			--

			if (fee_sync_signal_i = '1') then
				v_full_frame_cnt(17 downto 2) := s_current_frame_counter;
				v_full_frame_cnt(1 downto 0)  := s_current_frame_number;
				-- sync signal received
				if (v_frame_cleared = '1') then
					v_frame_cleared := '0';
				else
					-- update counters
					if (v_full_frame_cnt = "111111111111111111") then
						v_full_frame_cnt := (others => '0');
					else
						v_full_frame_cnt := std_logic_vector(unsigned(v_full_frame_cnt) + 1);
					end if;
				end if;
				s_current_frame_counter       <= v_full_frame_cnt(17 downto 2);
				s_current_frame_number        <= v_full_frame_cnt(1 downto 0);
			end if;

			if (fee_clear_frame_i = '1') then
				s_current_frame_counter <= (others => '0');
				s_current_frame_number  <= (others => '0');
				v_full_frame_cnt        := (others => '0');
				v_frame_cleared         := '1';
			end if;

		end if;
	end process p_fee_frame_manager;

	-- data pkt configs register
	p_register_data_pkt_config : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_registered_dpkt_params.image.logical_addr                  <= x"50";
			s_registered_dpkt_params.image.protocol_id                   <= x"F0";
			s_registered_dpkt_params.image.ccd_x_size                    <= std_logic_vector(to_unsigned(2295, 16));
			s_registered_dpkt_params.image.ccd_y_size                    <= std_logic_vector(to_unsigned(4540, 16));
			s_registered_dpkt_params.image.data_y_size                   <= std_logic_vector(to_unsigned(4510, 16));
			s_registered_dpkt_params.image.overscan_y_size               <= std_logic_vector(to_unsigned(30, 16));
			s_registered_dpkt_params.image.packet_length                 <= std_logic_vector(to_unsigned(32768, 16));
			s_registered_dpkt_params.image.fee_mode                      <= std_logic_vector(to_unsigned(15, 4));
			s_registered_dpkt_params.image.ccd_number                    <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_side_hk                   <= c_COMM_NFEE_CCD_SIDE_E;
			s_registered_dpkt_params.image.ccd_v_start                   <= (others => '0');
			s_registered_dpkt_params.image.ccd_v_end                     <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_v_end                 <= (others => '0');
			s_registered_dpkt_params.image.ccd_ovs_v_end                 <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_start                   <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_end                     <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_en                    <= '0';
			s_registered_dpkt_params.image.ccd_img_en                    <= '0';
			s_registered_dpkt_params.image.ccd_ovs_en                    <= '0';
			s_registered_dpkt_params.image.start_delay                   <= (others => '0');
			s_registered_dpkt_params.image.skip_delay                    <= (others => '0');
			s_registered_dpkt_params.image.line_delay                    <= (others => '0');
			s_registered_dpkt_params.image.adc_delay                     <= (others => '0');
			s_registered_dpkt_params.transmission.windowing_en           <= '0';
			s_registered_dpkt_params.transmission.pattern_en             <= '1';
			s_registered_dpkt_params.transmission.overflow_en            <= '1';
			s_registered_dpkt_params.spw_errinj.eep_received             <= '0';
			s_registered_dpkt_params.spw_errinj.sequence_cnt             <= (others => '0');
			s_registered_dpkt_params.spw_errinj.n_repeat                 <= (others => '0');
			s_registered_dpkt_params.trans_errinj.tx_disabled            <= '0';
			s_registered_dpkt_params.trans_errinj.missing_pkts           <= '0';
			s_registered_dpkt_params.trans_errinj.missing_data           <= '0';
			s_registered_dpkt_params.trans_errinj.frame_num              <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.trans_errinj.sequence_cnt           <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.trans_errinj.data_cnt               <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.trans_errinj.n_repeat               <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.windowing.packet_order_list         <= (others => '0');
			s_registered_dpkt_params.windowing.last_left_packet          <= (others => '0');
			s_registered_dpkt_params.windowing.last_right_packet         <= (others => '0');
			s_registered_dpkt_params.pixels_left_cbuffer.address_offset  <= (others => '0');
			s_registered_dpkt_params.pixels_left_cbuffer.size_words      <= (others => '1');
			s_registered_dpkt_params.pixels_right_cbuffer.address_offset <= (others => '0');
			s_registered_dpkt_params.pixels_right_cbuffer.size_words     <= (others => '1');
			s_registered_left_buffer_activated                           <= '0';
			s_registered_right_buffer_activated                          <= '0';
		elsif rising_edge(clk_i) then
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- register ccd side activated
				s_registered_left_buffer_activated                                     <= fee_left_buffer_activated_i;
				s_registered_right_buffer_activated                                    <= fee_right_buffer_activated_i;
				-- register data pkt config
				s_registered_dpkt_params.image.logical_addr                            <= data_pkt_logical_addr_i;
				s_registered_dpkt_params.image.protocol_id                             <= data_pkt_protocol_id_i;
				s_registered_dpkt_params.image.ccd_x_size                              <= data_pkt_ccd_x_size_i;
				s_registered_dpkt_params.image.ccd_y_size                              <= data_pkt_ccd_y_size_i;
				s_registered_dpkt_params.image.data_y_size                             <= data_pkt_data_y_size_i;
				s_registered_dpkt_params.image.overscan_y_size                         <= data_pkt_overscan_y_size_i;
				s_registered_dpkt_params.image.packet_length                           <= data_pkt_packet_length_i;
				s_registered_dpkt_params.image.ccd_number                              <= data_pkt_ccd_number_i;
				s_registered_dpkt_params.image.ccd_v_start                             <= data_pkt_ccd_v_start_i;
				s_registered_dpkt_params.image.ccd_v_end                               <= data_pkt_ccd_v_end_i;
				s_registered_dpkt_params.image.ccd_img_v_end                           <= data_pkt_ccd_img_v_end_i;
				s_registered_dpkt_params.image.ccd_ovs_v_end                           <= data_pkt_ccd_ovs_v_end_i;
				s_registered_dpkt_params.image.ccd_h_start                             <= data_pkt_ccd_h_start_i;
				s_registered_dpkt_params.image.ccd_h_end                               <= data_pkt_ccd_h_end_i;
				s_registered_dpkt_params.image.ccd_img_en                              <= (data_pkt_ccd_img_en_i) and (fee_digitalise_en_i) and (fee_readout_en_i) and (fee_window_list_en_i);
				s_registered_dpkt_params.image.ccd_ovs_en                              <= (data_pkt_ccd_ovs_en_i) and (fee_digitalise_en_i) and (fee_readout_en_i);
				s_registered_dpkt_params.image.start_delay                             <= data_pkt_start_delay_i;
				s_registered_dpkt_params.image.skip_delay                              <= data_pkt_skip_delay_i;
				s_registered_dpkt_params.image.line_delay                              <= data_pkt_line_delay_i;
				s_registered_dpkt_params.image.adc_delay                               <= data_pkt_adc_delay_i;
				-- register housekeeping settings
				if (fee_left_buffer_activated_i = '1') and (fee_right_buffer_activated_i = '0') then
					-- only left buffer is activated
					s_registered_dpkt_params.image.ccd_side_hk <= c_COMM_NFEE_CCD_SIDE_E;
				elsif (fee_left_buffer_activated_i = '0') and (fee_right_buffer_activated_i = '1') then
					-- only right buffer is activated
					s_registered_dpkt_params.image.ccd_side_hk <= c_COMM_NFEE_CCD_SIDE_F;
				else
					-- both buffers activated or no buffer activated, hk will use the left buffer as reference
					s_registered_dpkt_params.image.ccd_side_hk <= c_COMM_NFEE_CCD_SIDE_E;
				end if;
				-- register masking settings
				s_registered_dpkt_params.transmission.overflow_en                      <= masking_buffer_overflow_i;
				case (data_pkt_fee_mode_i) is
					when c_DPKT_OFF_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_NONE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_ON_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_ON_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_FULLIMAGE_PATTERN_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_FULLIMAGE_PATTERN_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_WINDOWING_PATTERN_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_WINDOWING_PATTERN_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '1';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_STANDBY_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_STANDBY_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_FULLIMAGE_MODE_PATTERN_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_FULLIMAGE_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_FULLIMAGE_MODE_SSD_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_FULLIMAGE_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_WINDOWING_MODE_PATTERN_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_WINDOWING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '1';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_WINDOWING_MODE_SSDIMG_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_WINDOWING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '1';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_WINDOWING_MODE_SSDWIN_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_WINDOWING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '1';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_PERFORMANCE_TEST_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_PERFORMANCE_TEST_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '1';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
					when c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_PARALLEL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_PARALLEL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_PARALLEL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_PARALLEL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_SER_TRAP_PUMP_1_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_SERIAL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when c_DPKT_SER_TRAP_PUMP_2_MODE =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_SERIAL_TRAP_PUMPING_MODE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '1';
					when others =>
						s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_NONE;
						s_registered_dpkt_params.transmission.windowing_en <= '0';
						s_registered_dpkt_params.transmission.pattern_en   <= '0';
				end case;
				-- register error injection settings
				s_registered_dpkt_params.spw_errinj.eep_received                       <= spw_errinj_eep_received_i;
				s_registered_dpkt_params.spw_errinj.sequence_cnt                       <= spw_errinj_sequence_cnt_i;
				s_registered_dpkt_params.spw_errinj.n_repeat                           <= spw_errinj_n_repeat_i;
				s_registered_dpkt_params.trans_errinj.tx_disabled                      <= trans_errinj_tx_disabled_i;
				s_registered_dpkt_params.trans_errinj.missing_pkts                     <= trans_errinj_missing_pkts_i;
				s_registered_dpkt_params.trans_errinj.missing_data                     <= trans_errinj_missing_data_i;
				s_registered_dpkt_params.trans_errinj.frame_num                        <= trans_errinj_frame_num_i;
				s_registered_dpkt_params.trans_errinj.sequence_cnt                     <= trans_errinj_sequence_cnt_i;
				s_registered_dpkt_params.trans_errinj.data_cnt                         <= trans_errinj_data_cnt_i;
				s_registered_dpkt_params.trans_errinj.n_repeat                         <= trans_errinj_n_repeat_i;
				-- register windowing settings
				s_registered_dpkt_params.windowing.packet_order_list                   <= windowing_packet_order_list_i;
				s_registered_dpkt_params.windowing.last_left_packet                    <= windowing_last_left_packet_i;
				s_registered_dpkt_params.windowing.last_right_packet                   <= windowing_last_right_packet_i;
				-- register left circular buffer settings
				s_registered_dpkt_params.pixels_left_cbuffer.address_offset            <= pixels_left_cbuffer_address_offset_i;
				s_registered_dpkt_params.pixels_left_cbuffer.size_words(23 downto 19)  <= (others => '0');
				s_registered_dpkt_params.pixels_left_cbuffer.size_words(18 downto 0)   <= pixels_left_cbuffer_size_bytes_i(23 downto 5);
				-- register right circular buffer settings
				s_registered_dpkt_params.pixels_right_cbuffer.address_offset           <= pixels_right_cbuffer_address_offset_i;
				s_registered_dpkt_params.pixels_right_cbuffer.size_words(23 downto 19) <= (others => '0');
				s_registered_dpkt_params.pixels_right_cbuffer.size_words(18 downto 0)  <= pixels_right_cbuffer_size_bytes_i(23 downto 5);
			end if;
		end if;
	end process p_register_data_pkt_config;

	p_data_manager_sync_gen : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_dataman_sync    <= '0';
			s_dataman_hk_only <= '0';
			s_spw_write_mask  <= '0';
		elsif rising_edge(clk_i) then
			s_dataman_sync <= '0';
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- sync signal was received

				-- check if a side is activated
				if ((fee_left_buffer_activated_i = '1') or (fee_right_buffer_activated_i = '1')) then
					-- a side is activated
					case (data_pkt_fee_mode_i) is
						when c_DPKT_FULLIMAGE_PATTERN_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_WINDOWING_PATTERN_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_FULLIMAGE_MODE_PATTERN_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_FULLIMAGE_MODE_SSD_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_WINDOWING_MODE_PATTERN_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_WINDOWING_MODE_SSDIMG_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_WINDOWING_MODE_SSDWIN_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_PERFORMANCE_TEST_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_SER_TRAP_PUMP_1_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when c_DPKT_SER_TRAP_PUMP_2_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '0';
						when others =>
							s_dataman_sync    <= '0';
							s_dataman_hk_only <= '0';
					end case;
				else
					-- no side is activated
					case (data_pkt_fee_mode_i) is
						when c_DPKT_OFF_MODE =>
							s_dataman_sync    <= '0';
							s_dataman_hk_only <= '0';
						when c_DPKT_ON_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '1';
						when c_DPKT_STANDBY_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '1';
						when c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '1';
						when c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE =>
							s_dataman_sync    <= '1';
							s_dataman_hk_only <= '1';
						when others =>
							s_dataman_sync    <= '0';
							s_dataman_hk_only <= '0';
					end case;
				end if;

				-- check if the spw link is running
				if (fee_spw_link_running_i = '1') then
					-- the spw link is running, do not mask the codec write
					s_spw_write_mask <= '1';
				else
					-- the spw link is not running, do mask the codec write
					s_spw_write_mask <= '0';
				end if;

			end if;
		end if;
	end process p_data_manager_sync_gen;

	-- signals assingments

	-- outputs generation
	fee_frame_counter_o <= s_current_frame_counter;
	fee_frame_number_o  <= s_current_frame_number;
	fee_spw_tx_write_o  <= (s_spw_tx_write) and (s_spw_write_mask);

end architecture RTL;
