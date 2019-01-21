library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity avalon_mm_spacewire_write_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_write_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_write_out;
		spacewire_write_registers_o : out t_windowing_write_registers;
		rmap_config_registers_o     : out t_rmap_memory_config_area;
		rmap_hk_registers_o         : out t_rmap_memory_hk_area
	);
end entity avalon_mm_spacewire_write_ent;

architecture rtl of avalon_mm_spacewire_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_spacewire_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			-- comm registers
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_disconnect              <= '0';
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_start                   <= '0';
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_autostart               <= '0';
			spacewire_write_registers_o.spw_timecode_reg.timecode_clear                               <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear            <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_stop             <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_start            <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_masking_en               <= '1';
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr                <= x"51";
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key                         <= x"D1";
			spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_x_size                  <= x"0000";
			spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_y_size                  <= x"0000";
			spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_data_y_size                 <= x"0000";
			spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_overscan_y_size             <= x"0000";
			spacewire_write_registers_o.data_packet_config_3_reg.data_pkt_packet_length               <= x"0000";
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_fee_mode                    <= x"00";
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_ccd_number                  <= x"00";
			spacewire_write_registers_o.data_packet_pixel_delay_1_reg.data_pkt_line_delay             <= x"0000";
			spacewire_write_registers_o.data_packet_pixel_delay_2_reg.data_pkt_column_delay           <= x"0000";
			spacewire_write_registers_o.data_packet_pixel_delay_3_reg.data_pkt_adc_delay              <= x"0000";
			spacewire_write_registers_o.comm_irq_control_reg.comm_rmap_write_command_en               <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_right_buffer_empty_en               <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_left_buffer_empty_en                <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en                       <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear   <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear         <= '0';
			-- rmap config registers
			rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control                          <= '0';
			rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control                    <= '0';
			rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control                 <= '0';
			rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control               <= x"119E";
			rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control            <= x"8F7";
			rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count                        <= x"001F4";
			rmap_config_registers_o.spw_packet_1_config.digitise_control                              <= '0';
			rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control  <= "11";
			rmap_config_registers_o.spw_packet_1_config.packet_size_control                           <= x"11F8";
			rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1 <= x"00000000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1                        <= "000000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1                       <= "000000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1                  <= x"0000";
			rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2 <= x"00000000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2                        <= "000000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2                       <= "000000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2                  <= x"0000";
			rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3 <= x"00000000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3                        <= "000000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3                       <= "000000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3                  <= x"0000";
			rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4 <= x"00000000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4                        <= "000000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4                       <= "000000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4                  <= x"0000";
			rmap_config_registers_o.operation_mode_config.mode_selection_control                      <= x"1";
			rmap_config_registers_o.sync_config.sync_configuration                                    <= "00";
			rmap_config_registers_o.sync_config.self_trigger_control                                  <= '0';
			rmap_config_registers_o.frame_number.frame_number                                         <= "00";
			rmap_config_registers_o.current_mode.current_mode                                         <= "0000";
			-- rmap hk registers
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			spacewire_write_registers_o.spw_timecode_reg.timecode_clear                             <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear          <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear       <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				-- comm registers
				when (x"00") =>
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_disconnect <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_start      <= avalon_mm_spacewire_i.writedata(1);
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_autostart  <= avalon_mm_spacewire_i.writedata(2);
				when (x"01") =>
					spacewire_write_registers_o.spw_timecode_reg.timecode_clear <= avalon_mm_spacewire_i.writedata(8);
				when (x"02") =>
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_stop  <= avalon_mm_spacewire_i.writedata(1);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_start <= avalon_mm_spacewire_i.writedata(2);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_masking_en    <= avalon_mm_spacewire_i.writedata(3);
				when (x"03") =>
					null;
				when (x"04") =>
					spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avalon_mm_spacewire_i.writedata(7 downto 0);
					spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key          <= avalon_mm_spacewire_i.writedata(15 downto 8);
				when (x"05") =>
					null;
				when (x"06") =>
					null;
				when (x"07") =>
					null;
				when (x"08") =>
					spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_x_size <= avalon_mm_spacewire_i.writedata(15 downto 0);
					spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_y_size <= avalon_mm_spacewire_i.writedata(31 downto 6);
				when (x"09") =>
					spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_data_y_size     <= avalon_mm_spacewire_i.writedata(15 downto 0);
					spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_overscan_y_size <= avalon_mm_spacewire_i.writedata(31 downto 6);
				when (x"0A") =>
					spacewire_write_registers_o.data_packet_config_3_reg.data_pkt_packet_length <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (x"0B") =>
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_fee_mode   <= avalon_mm_spacewire_i.writedata(7 downto 0);
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_ccd_number <= avalon_mm_spacewire_i.writedata(15 downto 8);
				when (x"0C") =>
					null;
				when (x"0D") =>
					null;
				when (x"0E") =>
					spacewire_write_registers_o.data_packet_pixel_delay_1_reg.data_pkt_line_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (x"0F") =>
					spacewire_write_registers_o.data_packet_pixel_delay_2_reg.data_pkt_column_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (x"10") =>
					spacewire_write_registers_o.data_packet_pixel_delay_3_reg.data_pkt_adc_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (x"11") =>
					spacewire_write_registers_o.comm_irq_control_reg.comm_rmap_write_command_en <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.comm_irq_control_reg.comm_right_buffer_empty_en <= avalon_mm_spacewire_i.writedata(8);
					spacewire_write_registers_o.comm_irq_control_reg.comm_left_buffer_empty_en  <= avalon_mm_spacewire_i.writedata(9);
					spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en         <= avalon_mm_spacewire_i.writedata(6);
				when (x"12") =>
					null;
				when (x"13") =>
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear       <= avalon_mm_spacewire_i.writedata(8);

				-- rmap config registers
				when (x"40") =>
					rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control               <= avalon_mm_spacewire_i.writedata(1);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control         <= avalon_mm_spacewire_i.writedata(2);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control      <= avalon_mm_spacewire_i.writedata(3);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control    <= avalon_mm_spacewire_i.writedata(19 downto 4);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control <= avalon_mm_spacewire_i.writedata(31 downto 20);
				when (x"41") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count <= avalon_mm_spacewire_i.writedata(19 downto 0);
				when (x"42") =>
					rmap_config_registers_o.spw_packet_1_config.digitise_control                             <= avalon_mm_spacewire_i.writedata(1);
					rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control <= avalon_mm_spacewire_i.writedata(3 downto 2);
					rmap_config_registers_o.spw_packet_1_config.packet_size_control                          <= avalon_mm_spacewire_i.writedata(19 downto 4);
				when (x"43") =>
					null;
				when (x"44") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1 <= avalon_mm_spacewire_i.writedata(31 downto 0);
				when (x"45") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1       <= avalon_mm_spacewire_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1      <= avalon_mm_spacewire_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"46") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2 <= avalon_mm_spacewire_i.writedata(31 downto 0);
				when (x"47") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2       <= avalon_mm_spacewire_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2      <= avalon_mm_spacewire_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"48") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3 <= avalon_mm_spacewire_i.writedata(31 downto 0);
				when (x"49") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3       <= avalon_mm_spacewire_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3      <= avalon_mm_spacewire_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"4A") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4 <= avalon_mm_spacewire_i.writedata(31 downto 0);
				when (x"4B") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4       <= avalon_mm_spacewire_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4      <= avalon_mm_spacewire_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"4C") =>
					rmap_config_registers_o.operation_mode_config.mode_selection_control <= avalon_mm_spacewire_i.writedata(7 downto 4);
				when (x"4D") =>
					rmap_config_registers_o.sync_config.sync_configuration   <= avalon_mm_spacewire_i.writedata(1 downto 0);
					rmap_config_registers_o.sync_config.self_trigger_control <= avalon_mm_spacewire_i.writedata(2);
				when (x"4E") =>
					null;
				when (x"4F") =>
					null;
				when (x"50") =>
					rmap_config_registers_o.frame_number.frame_number <= avalon_mm_spacewire_i.writedata(1 downto 0);
				when (x"51") =>
					rmap_config_registers_o.current_mode.current_mode <= avalon_mm_spacewire_i.writedata(3 downto 0);

				-- rmap hk registers
				when (x"A0") =>
					rmap_hk_registers_o.hk_ccd1_vod_e <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd1_vod_f <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A1") =>
					rmap_hk_registers_o.hk_ccd1_vrd_mon <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_vod_e   <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A2") =>
					rmap_hk_registers_o.hk_ccd2_vod_f   <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_vrd_mon <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A3") =>
					rmap_hk_registers_o.hk_ccd3_vod_e <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd3_vod_f <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A4") =>
					rmap_hk_registers_o.hk_ccd3_vrd_mon <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_vod_e   <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A5") =>
					rmap_hk_registers_o.hk_ccd4_vod_f   <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_vrd_mon <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A6") =>
					rmap_hk_registers_o.hk_vccd  <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vrclk <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A7") =>
					rmap_hk_registers_o.hk_viclk     <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vrclk_low <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A8") =>
					rmap_hk_registers_o.hk_5vb_pos <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_5vb_neg <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"A9") =>
					rmap_hk_registers_o.hk_3_3vb_pos <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_2_5va_pos <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AA") =>
					rmap_hk_registers_o.hk_3_3vd_pos <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_2_5vd_pos <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AB") =>
					rmap_hk_registers_o.hk_1_5vd_pos <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_5vref     <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AC") =>
					rmap_hk_registers_o.hk_vccd_pos_raw <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vclk_pos_raw <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AD") =>
					rmap_hk_registers_o.hk_van1_pos_raw <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_van3_neg_raw <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AE") =>
					rmap_hk_registers_o.hk_van2_pos_raw  <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vdig_fpga_raw <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"AF") =>
					rmap_hk_registers_o.hk_vdig_spw_raw <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_viclk_low    <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B0") =>
					rmap_hk_registers_o.hk_adc_temp_a_e <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_adc_temp_a_f <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B1") =>
					rmap_hk_registers_o.hk_ccd1_temp <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_temp <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B2") =>
					rmap_hk_registers_o.hk_ccd3_temp <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_temp <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B3") =>
					rmap_hk_registers_o.hk_wp605_spare <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_0 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B4") =>
					rmap_hk_registers_o.lowres_prt_a_1 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_2 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B5") =>
					rmap_hk_registers_o.lowres_prt_a_3 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_4 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B6") =>
					rmap_hk_registers_o.lowres_prt_a_5 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_6 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B7") =>
					rmap_hk_registers_o.lowres_prt_a_7 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_8 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B8") =>
					rmap_hk_registers_o.lowres_prt_a_9  <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_10 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"B9") =>
					rmap_hk_registers_o.lowres_prt_a_11 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_12 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BA") =>
					rmap_hk_registers_o.lowres_prt_a_13 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_14 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BB") =>
					rmap_hk_registers_o.lowres_prt_a_15 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt0  <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BC") =>
					rmap_hk_registers_o.sel_hires_prt1 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt2 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BD") =>
					rmap_hk_registers_o.sel_hires_prt3 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt4 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BE") =>
					rmap_hk_registers_o.sel_hires_prt5 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt6 <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (x"BF") =>
					rmap_hk_registers_o.sel_hires_prt7 <= avalon_mm_spacewire_i.writedata(15 downto 0);
					rmap_hk_registers_o.zero_hires_amp <= avalon_mm_spacewire_i.writedata(31 downto 16);

				when others =>
					null;
			end case;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.waitrequest <= '1';
			s_data_acquired                   <= '0';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_spacewire_i.write = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_write_address                   := to_integer(unsigned(avalon_mm_spacewire_i.address));
				s_data_acquired                   <= '1';
				if (s_data_acquired = '1') then
					p_writedata(v_write_address);
					s_data_acquired <= '0';
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_write;

end architecture rtl;
