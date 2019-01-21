library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity avalon_mm_spacewire_read_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_read_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_read_out;
		spacewire_write_registers_i : in  t_windowing_write_registers;
		spacewire_read_registers_i  : in  t_windowing_read_registers;
		rmap_config_registers_i     : in  t_rmap_memory_config_area;
		rmap_hk_registers_i         : in  t_rmap_memory_hk_area
	);
end entity avalon_mm_spacewire_read_ent;

architecture rtl of avalon_mm_spacewire_read_ent is

	signal s_timecode_rx_received_flag : std_logic;

begin

	p_avalon_mm_spacewire_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			s_timecode_rx_received_flag <= '0';
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			if (spacewire_write_registers_i.timecode_rx_flags.rx_received_clear = '1') then
				s_timecode_rx_received_flag <= '0';
			end if;
			if (spacewire_read_registers_i.timecode_rx.rx_received = '1') then
				s_timecode_rx_received_flag <= '1';
			end if;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				-- comm registers
				when (x"00") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_disconnect;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_start;
					avalon_mm_spacewire_o.readdata(2)           <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_autostart;
					avalon_mm_spacewire_o.readdata(7 downto 3)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_link_running;
					avalon_mm_spacewire_o.readdata(9)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_link_connecting;
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_link_started;
					avalon_mm_spacewire_o.readdata(15 downto 1) <= (others => '0');
					avalon_mm_spacewire_o.readdata(6)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_err_disconnect;
					avalon_mm_spacewire_o.readdata(7)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_err_parity;
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_err_escape;
					avalon_mm_spacewire_o.readdata(9)           <= spacewire_read_registers_i.spw_link_config_status_reg_read_only.spw_err_credit;
					avalon_mm_spacewire_o.readdata(31 downto 0) <= (others => '0');
				when (x"01") =>
					avalon_mm_spacewire_o.readdata(5 downto 0)  <= spacewire_read_registers_i.spw_timecode_reg_read_only.timecode_time;
					avalon_mm_spacewire_o.readdata(7 downto 6)  <= spacewire_read_registers_i.spw_timecode_reg_read_only.timecode_control;
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_write_registers_i.spw_timecode_reg.timecode_clear;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');
				when (x"02") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_clear;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_stop;
					avalon_mm_spacewire_o.readdata(2)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_start;
					avalon_mm_spacewire_o.readdata(3)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_masking_en;
					avalon_mm_spacewire_o.readdata(31 downto 4) <= (others => '0');
				when (x"03") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.fee_windowing_buffers_status_reg.windowing_right_buffer_empty;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_read_registers_i.fee_windowing_buffers_status_reg.windowing_left_buffer_empty;
					avalon_mm_spacewire_o.readdata(31 downto 3) <= (others => '0');
				when (x"04") =>
					avalon_mm_spacewire_o.readdata(7 downto 0)  <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_logical_addr;
					avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_key;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"05") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_command_received;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_requested;
					avalon_mm_spacewire_o.readdata(2)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					avalon_mm_spacewire_o.readdata(3)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_requested;
					avalon_mm_spacewire_o.readdata(4)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					avalon_mm_spacewire_o.readdata(5)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					avalon_mm_spacewire_o.readdata(6)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					avalon_mm_spacewire_o.readdata(15 downto 7) <= (others => '0');
					avalon_mm_spacewire_o.readdata(6)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_early_eop;
					avalon_mm_spacewire_o.readdata(7)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_eep;
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_header_CRC;
					avalon_mm_spacewire_o.readdata(9)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_too_much_data;
					avalon_mm_spacewire_o.readdata(2)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					avalon_mm_spacewire_o.readdata(31 downto 3) <= (others => '0');
				when (x"06") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= spacewire_read_registers_i.rmap_last_write_addr_reg.rmap_last_write_addr;
				when (x"07") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= spacewire_read_registers_i.rmap_last_read_addr_reg.rmap_last_read_addr;
				when (x"08") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_config_1_reg.data_pkt_ccd_x_size;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= spacewire_write_registers_i.data_packet_config_1_reg.data_pkt_ccd_y_size;
				when (x"09") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_config_2_reg.data_pkt_data_y_size;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= spacewire_write_registers_i.data_packet_config_2_reg.data_pkt_overscan_y_size;
				when (x"0A") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_config_3_reg.data_pkt_packet_length;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"0B") =>
					avalon_mm_spacewire_o.readdata(7 downto 0)  <= spacewire_write_registers_i.data_packet_config_4_reg.data_pkt_fee_mode;
					avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_config_4_reg.data_pkt_ccd_number;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"0C") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_read_registers_i.data_packet_header_1_reg.data_pkt_header_length;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= spacewire_read_registers_i.data_packet_header_1_reg.data_pkt_header_type;
				when (x"0D") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_read_registers_i.data_packet_header_2_reg.data_pkt_header_frame_counter;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= spacewire_read_registers_i.data_packet_header_2_reg.data_pkt_header_sequence_counter;
				when (x"0E") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_1_reg.data_pkt_line_delay;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"0F") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_2_reg.data_pkt_column_delay;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"10") =>
					avalon_mm_spacewire_o.readdata(15 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_3_reg.data_pkt_adc_delay;
					avalon_mm_spacewire_o.readdata(31 downto 6) <= (others => '0');
				when (x"11") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.comm_irq_control_reg.comm_rmap_write_command_en;
					avalon_mm_spacewire_o.readdata(7 downto 1)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_write_registers_i.comm_irq_control_reg.comm_right_buffer_empty_en;
					avalon_mm_spacewire_o.readdata(9)           <= spacewire_write_registers_i.comm_irq_control_reg.comm_left_buffer_empty_en;
					avalon_mm_spacewire_o.readdata(15 downto 0) <= (others => '0');
					avalon_mm_spacewire_o.readdata(6)           <= spacewire_write_registers_i.comm_irq_control_reg.comm_global_irq_en;
					avalon_mm_spacewire_o.readdata(31 downto 7) <= (others => '0');
				when (x"12") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.comm_irq_flags_reg.comm_rmap_write_command_flag;
					avalon_mm_spacewire_o.readdata(7 downto 1)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_read_registers_i.comm_irq_flags_reg.comm_buffer_empty_flag;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');
				when (x"13") =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear;
					avalon_mm_spacewire_o.readdata(7 downto 1)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_write_registers_i.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');

				-- rmap config registers
				when (x"40") =>
					avalon_mm_spacewire_o.readdata(0)            <= '0';
					avalon_mm_spacewire_o.readdata(1)            <= rmap_config_registers_i.ccd_seq_1_config.tri_level_clock_control;
					avalon_mm_spacewire_o.readdata(2)            <= rmap_config_registers_i.ccd_seq_1_config.image_clock_direction_control;
					avalon_mm_spacewire_o.readdata(3)            <= rmap_config_registers_i.ccd_seq_1_config.register_clock_direction_control;
					avalon_mm_spacewire_o.readdata(19 downto 4)  <= rmap_config_registers_i.ccd_seq_1_config.image_clock_transfer_count_control;
					avalon_mm_spacewire_o.readdata(31 downto 20) <= rmap_config_registers_i.ccd_seq_1_config.register_clock_transfer_count_control;
				when (x"41") =>
					avalon_mm_spacewire_o.readdata(19 downto 0)  <= rmap_config_registers_i.ccd_seq_2_config.slow_read_out_pause_count;
					avalon_mm_spacewire_o.readdata(31 downto 20) <= (others => '0');
				when (x"42") =>
					avalon_mm_spacewire_o.readdata(0)            <= '0';
					avalon_mm_spacewire_o.readdata(1)            <= rmap_config_registers_i.spw_packet_1_config.digitise_control;
					avalon_mm_spacewire_o.readdata(3 downto 2)   <= rmap_config_registers_i.spw_packet_1_config.ccd_port_data_transmission_selection_control;
					avalon_mm_spacewire_o.readdata(19 downto 4)  <= rmap_config_registers_i.spw_packet_1_config.packet_size_control;
					avalon_mm_spacewire_o.readdata(31 downto 20) <= (others => '0');
				when (x"43") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= (others => '0');
				when (x"44") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= rmap_config_registers_i.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1;
				when (x"45") =>
					avalon_mm_spacewire_o.readdata(5 downto 0)   <= rmap_config_registers_i.CCD_1_windowing_2_config.window_width_ccd1;
					avalon_mm_spacewire_o.readdata(11 downto 6)  <= rmap_config_registers_i.CCD_1_windowing_2_config.window_height_ccd1;
					avalon_mm_spacewire_o.readdata(15 downto 12) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_list_length_ccd1;
				when (x"46") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= rmap_config_registers_i.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2;
				when (x"47") =>
					avalon_mm_spacewire_o.readdata(5 downto 0)   <= rmap_config_registers_i.CCD_2_windowing_2_config.window_width_ccd2;
					avalon_mm_spacewire_o.readdata(11 downto 6)  <= rmap_config_registers_i.CCD_2_windowing_2_config.window_height_ccd2;
					avalon_mm_spacewire_o.readdata(15 downto 12) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_list_length_ccd2;
				when (x"48") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= rmap_config_registers_i.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3;
				when (x"49") =>
					avalon_mm_spacewire_o.readdata(5 downto 0)   <= rmap_config_registers_i.CCD_3_windowing_2_config.window_width_ccd3;
					avalon_mm_spacewire_o.readdata(11 downto 6)  <= rmap_config_registers_i.CCD_3_windowing_2_config.window_height_ccd3;
					avalon_mm_spacewire_o.readdata(15 downto 12) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_list_length_ccd3;
				when (x"4A") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= rmap_config_registers_i.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4;
				when (x"4B") =>
					avalon_mm_spacewire_o.readdata(5 downto 0)   <= rmap_config_registers_i.CCD_4_windowing_2_config.window_width_ccd4;
					avalon_mm_spacewire_o.readdata(11 downto 6)  <= rmap_config_registers_i.CCD_4_windowing_2_config.window_height_ccd4;
					avalon_mm_spacewire_o.readdata(15 downto 12) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_list_length_ccd4;
				when (x"4C") =>
					avs_readdata_o(3 downto 0)                  <= (others => '0');
					avalon_mm_spacewire_o.readdata(7 downto 4)  <= rmap_config_registers_i.operation_mode_config.mode_selection_control;
					avalon_mm_spacewire_o.readdata(31 downto 8) <= (others => '0');
				when (x"4D") =>
					avalon_mm_spacewire_o.readdata(1 downto 0)  <= rmap_config_registers_i.sync_config.sync_configuration;
					avalon_mm_spacewire_o.readdata(2)           <= rmap_config_registers_i.sync_config.self_trigger_control;
					avalon_mm_spacewire_o.readdata(31 downto 3) <= (others => '0');
				when (x"4E") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= (others => '0');
				when (x"4F") =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= (others => '0');
				when (x"50") =>
					avalon_mm_spacewire_o.readdata(1 downto 0)  <= rmap_config_registers_i.frame_number.frame_number;
					avalon_mm_spacewire_o.readdata(31 downto 2) <= (others => '0');
				when (x"51") =>
					avalon_mm_spacewire_o.readdata(3 downto 0)  <= rmap_config_registers_i.current_mode.current_mode;
					avalon_mm_spacewire_o.readdata(31 downto 4) <= (others => '0');

				-- rmap hk registers
				when (x"A0") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd1_vod_e;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd1_vod_f;
				when (x"A1") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd1_vrd_mon;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd2_vod_e;
				when (x"A2") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd2_vod_f;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd2_vrd_mon;
				when (x"A3") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd3_vod_e;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd3_vod_f;
				when (x"A4") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd3_vrd_mon;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd4_vod_e;
				when (x"A5") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd4_vod_f;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd4_vrd_mon;
				when (x"A6") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_vccd;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_vrclk;
				when (x"A7") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_viclk;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_vrclk_low;
				when (x"A8") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_5vb_pos;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_5vb_neg;
				when (x"A9") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_3_3vb_pos;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_2_5va_pos;
				when (x"AA") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_3_3vd_pos;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_2_5vd_pos;
				when (x"AB") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_1_5vd_pos;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_5vref;
				when (x"AC") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_vccd_pos_raw;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_vclk_pos_raw;
				when (x"AD") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_van1_pos_raw;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_van3_neg_raw;
				when (x"AE") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_van2_pos_raw;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_vdig_fpga_raw;
				when (x"AF") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_vdig_spw_raw;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_viclk_low;
				when (x"B0") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_adc_temp_a_e;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_adc_temp_a_f;
				when (x"B1") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd1_temp;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd2_temp;
				when (x"B2") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_ccd3_temp;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.hk_ccd4_temp;
				when (x"B3") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.hk_wp605_spare;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_0;
				when (x"B4") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_1;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_2;
				when (x"B5") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_3;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_4;
				when (x"B6") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_5;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_6;
				when (x"B7") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_7;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_8;
				when (x"B8") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_9;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_10;
				when (x"B9") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_11;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_12;
				when (x"BA") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_13;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.lowres_prt_a_14;
				when (x"BB") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.lowres_prt_a_15;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.sel_hires_prt0;
				when (x"BC") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.sel_hires_prt1;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.sel_hires_prt2;
				when (x"BD") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.sel_hires_prt3;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.sel_hires_prt4;
				when (x"BE") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.sel_hires_prt5;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.sel_hires_prt6;
				when (x"BF") =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= rmap_hk_registers_i.sel_hires_prt7;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= rmap_hk_registers_i.zero_hires_amp;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');
			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_spacewire_i.read = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_spacewire_read;

end architecture rtl;
