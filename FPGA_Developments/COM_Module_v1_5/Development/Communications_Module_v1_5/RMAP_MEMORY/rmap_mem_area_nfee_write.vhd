library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rmap_mem_area_nfee_write is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_write_i            : in  std_logic;
		rmap_writeaddr_i        : in  std_logic_vector(31 downto 0);
		rmap_writedata_i        : in  std_logic_vector(7 downto 0);
		rmap_memerror_o         : out std_logic;
		rmap_memready_o         : out std_logic;
		rmap_config_registers_o : out t_rmap_memory_config_area;
		rmap_hk_registers_o     : out t_rmap_memory_hk_area
	);
end entity rmap_mem_area_nfee_write;

architecture RTL of rmap_mem_area_nfee_write is

begin

	p_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
		procedure p_nfee_reg_reset is
		begin
			-- Config Area
			rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control                          <= '0';
			rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control                    <= '0';
			rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control                 <= '0';
			rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control               <= x"119E";
			rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control            <= x"8F7";
			rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count                        <= x"001F4";
			rmap_config_registers_o.spw_packet_1_config.digitise_control                              <= '0';
			rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control  <= "11";
			rmap_config_registers_o.spw_packet_1_configpacket_size_control                            <= x"11F8";
			rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1 <= x"00000000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1                        <= "00000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1                       <= "00000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1                  <= "0000";
			rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2 <= x"00000000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2                        <= "00000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2                       <= "00000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2                  <= "0000";
			rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3 <= x"00000000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3                        <= "00000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3                       <= "00000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3                  <= "0000";
			rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4 <= x"00000000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4                        <= "00000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4                       <= "00000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4                  <= "0000";
			rmap_config_registers_o.operation_mode_config.mode_selection_control                      <= x"1";
			rmap_config_registers_o.sync_config.sync_configuration                                    <= "00";
			rmap_config_registers_o.sync_config.self_trigger_control                                  <= '0';
			rmap_config_registers_o.frame_number.frame_number                                         <= "00";
			rmap_config_registers_o.current_mode.current_mode                                         <= "0000";
			-- HK Area
			rmap_hk_registers_o.hk_ccd1_vod_e                                                         <= x"7071";
			rmap_hk_registers_o.hk_ccd1_vod_f                                                         <= x"7273";
			rmap_hk_registers_o.hk_ccd1_vrd_mon                                                       <= x"7475";
			rmap_hk_registers_o.hk_ccd2_vod_e                                                         <= x"7677";
			rmap_hk_registers_o.hk_ccd2_vod_f                                                         <= x"7879";
			rmap_hk_registers_o.hk_ccd2_vrd_mon                                                       <= x"7A7B";
			rmap_hk_registers_o.hk_ccd3_vod_e                                                         <= x"7C7D";
			rmap_hk_registers_o.hk_ccd3_vod_f                                                         <= x"7E7F";
			rmap_hk_registers_o.hk_ccd3_vrd_mon                                                       <= x"8081";
			rmap_hk_registers_o.hk_ccd4_vod_e                                                         <= x"8283";
			rmap_hk_registers_o.hk_ccd4_vod_f                                                         <= x"8485";
			rmap_hk_registers_o.hk_ccd4_vrd_mon                                                       <= x"8687";
			rmap_hk_registers_o.hk_vccd                                                               <= x"8889";
			rmap_hk_registers_o.hk_vrclk                                                              <= x"8A8B";
			rmap_hk_registers_o.hk_viclk                                                              <= x"8C8D";
			rmap_hk_registers_o.hk_vrclk_low                                                          <= x"8E8F";
			rmap_hk_registers_o.hk_5vb_pos                                                            <= x"9091";
			rmap_hk_registers_o.hk_5vb_neg                                                            <= x"9293";
			rmap_hk_registers_o.hk_3_3vb_pos                                                          <= x"9495";
			rmap_hk_registers_o.hk_2_5va_pos                                                          <= x"9697";
			rmap_hk_registers_o.hk_3_3vd_pos                                                          <= x"9899";
			rmap_hk_registers_o.hk_2_5vd_pos                                                          <= x"9A9B";
			rmap_hk_registers_o.hk_1_5vd_pos                                                          <= x"9C9D";
			rmap_hk_registers_o.hk_5vref                                                              <= x"9E9F";
			rmap_hk_registers_o.hk_vccd_pos_raw                                                       <= x"A0A1";
			rmap_hk_registers_o.hk_vclk_pos_raw                                                       <= x"A2A3";
			rmap_hk_registers_o.hk_van1_pos_raw                                                       <= x"A4A5";
			rmap_hk_registers_o.hk_van3_neg_raw                                                       <= x"A6A7";
			rmap_hk_registers_o.hk_van2_pos_raw                                                       <= x"A8A9";
			rmap_hk_registers_o.hk_vdig_fpga_raw                                                      <= x"AAAB";
			rmap_hk_registers_o.hk_vdig_spw_raw                                                       <= x"ACAD";
			rmap_hk_registers_o.hk_viclk_low                                                          <= x"AEAF";
			rmap_hk_registers_o.hk_adc_temp_a_e                                                       <= x"B0B1";
			rmap_hk_registers_o.hk_adc_temp_a_f                                                       <= x"B2B3";
			rmap_hk_registers_o.hk_ccd1_temp                                                          <= x"B4B5";
			rmap_hk_registers_o.hk_ccd2_temp                                                          <= x"B6B7";
			rmap_hk_registers_o.hk_ccd3_temp                                                          <= x"B8B9";
			rmap_hk_registers_o.hk_ccd4_temp                                                          <= x"BABB";
			rmap_hk_registers_o.hk_wp605_spare                                                        <= x"BCBD";
			rmap_hk_registers_o.lowres_prt_a_0                                                        <= x"BEBF";
			rmap_hk_registers_o.lowres_prt_a_1                                                        <= x"C0C1";
			rmap_hk_registers_o.lowres_prt_a_2                                                        <= x"C2C3";
			rmap_hk_registers_o.lowres_prt_a_3                                                        <= x"C4C5";
			rmap_hk_registers_o.lowres_prt_a_4                                                        <= x"C6C7";
			rmap_hk_registers_o.lowres_prt_a_5                                                        <= x"C8C9";
			rmap_hk_registers_o.lowres_prt_a_6                                                        <= x"CACB";
			rmap_hk_registers_o.lowres_prt_a_7                                                        <= x"CCCD";
			rmap_hk_registers_o.lowres_prt_a_8                                                        <= x"CECF";
			rmap_hk_registers_o.lowres_prt_a_9                                                        <= x"D0D1";
			rmap_hk_registers_o.lowres_prt_a_10                                                       <= x"D2D3";
			rmap_hk_registers_o.lowres_prt_a_11                                                       <= x"D4D5";
			rmap_hk_registers_o.lowres_prt_a_12                                                       <= x"D6D7";
			rmap_hk_registers_o.lowres_prt_a_13                                                       <= x"D8D9";
			rmap_hk_registers_o.lowres_prt_a_14                                                       <= x"DADB";
			rmap_hk_registers_o.lowres_prt_a_15                                                       <= x"DCDD";
			rmap_hk_registers_o.sel_hires_prt0                                                        <= x"DEDF";
			rmap_hk_registers_o.sel_hires_prt1                                                        <= x"E0E1";
			rmap_hk_registers_o.sel_hires_prt2                                                        <= x"E2E3";
			rmap_hk_registers_o.sel_hires_prt3                                                        <= x"E4E5";
			rmap_hk_registers_o.sel_hires_prt4                                                        <= x"E6E7";
			rmap_hk_registers_o.sel_hires_prt5                                                        <= x"E8E9";
			rmap_hk_registers_o.sel_hires_prt6                                                        <= x"EAEB";
			rmap_hk_registers_o.sel_hires_prt7                                                        <= x"ECED";
			rmap_hk_registers_o.zero_hires_amp                                                        <= x"EEEF";
		end procedure p_nfee_reg_reset;

		procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
		begin
			-- NFEE Memory Write
			-- Case for access to all registers
			case (wr_addr_i) is

				-- Config Area
				when (x"00000000") =>
					rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control                        <= rmap_writedata_i(1);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control                  <= rmap_writedata_i(2);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control               <= rmap_writedata_i(3);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(3 downto 0) <= rmap_writedata_i(7 downto 4);
				when (x"00000001") =>
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"00000002") =>
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(15 downto 12)  <= rmap_writedata_i(3 downto 0);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control(3 downto 0) <= rmap_writedata_i(7 downto 4);
				when (x"00000003") =>
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"00000004") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000005") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000006") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(19 downto 16) <= rmap_writedata_i(3 downto 0);
				when (x"00000007") =>
					null;
				when (x"00000008") =>
					rmap_config_registers_o.spw_packet_1_config.digitise_control                             <= rmap_writedata_i(1);
					rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control <= rmap_writedata_i(3 downto 2);
					rmap_config_registers_o.spw_packet_1_config.packet_size_control(3 downto 0)              <= rmap_writedata_i(7 downto 4);
				when (x"00000009") =>
					rmap_config_registers_o.spw_packet_1_config.packet_size_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"0000000A") =>
					rmap_config_registers_o.spw_packet_1_configpacket_size_control(15 downto 12) <= rmap_writedata_i(3 downto 0);
				when (x"0000000B") =>
					null;
				when (x"0000000C") =>
					null;
				when (x"0000000D") =>
					null;
				when (x"0000000E") =>
					null;
				when (x"0000000F") =>
					null;
				when (x"00000010") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000011") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000012") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000013") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"00000014") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"00000015") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"00000016") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000017") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000018") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000019") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"0000001A") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"0000001B") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"0000001C") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"0000001D") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"0000001E") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000001F") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000020") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000021") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000022") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000023") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"00000024") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"00000025") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"00000026") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000027") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000028") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000029") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"0000002A") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"0000002B") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"0000002C") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"0000002D") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"0000002E") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000002F") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000038") =>
					rmap_config_registers_o.operation_mode_config.mode_selection_control <= rmap_writedata_i(7 downto 4);
				when (x"00000039") =>
					null;
				when (x"0000003A") =>
					null;
				when (x"0000003B") =>
					null;
				when (x"0000003C") =>
					rmap_config_registers_o.sync_config.sync_configuration   <= rmap_writedata_i(1 downto 0);
					rmap_config_registers_o.sync_config.self_trigger_control <= rmap_writedata_i(2);
				when (x"0000003D") =>
					null;
				when (x"0000003E") =>
					null;
				when (x"0000003F") =>
					null;
				when (x"00000040") =>
					null;
				when (x"00000041") =>
					null;
				when (x"00000042") =>
					null;
				when (x"00000043") =>
					null;
				when (x"00000044") =>
					null;
				when (x"00000045") =>
					null;
				when (x"00000046") =>
					null;
				when (x"00000047") =>
					null;
				when (x"00000048") =>
					rmap_config_registers_o.frame_number.frame_number <= rmap_writedata_i(1 downto 0);
				when (x"00000049") =>
					null;
				when (x"0000004A") =>
					null;
				when (x"0000004B") =>
					null;
				when (x"0000004C") =>
					rmap_config_registers_o.current_mode.current_mode <= rmap_writedata_i(3 downto 0);
				when (x"0000004D") =>
					null;
				when (x"0000004E") =>
					null;
				when (x"0000004F") =>
					null;
				-- HK Area
				when (x"00000700") =>
					rmap_hk_registers_o.hk_ccd1_vod_e(7 downto 0) <= rmap_writedata_i;
				when (x"00000701") =>
					rmap_hk_registers_o.hk_ccd1_vod_e(15 downto 8) <= rmap_writedata_i;
				when (x"00000702") =>
					rmap_hk_registers_o.hk_ccd1_vod_f(7 downto 0) <= rmap_writedata_i;
				when (x"00000703") =>
					rmap_hk_registers_o.hk_ccd1_vod_f(15 downto 8) <= rmap_writedata_i;
				when (x"00000704") =>
					rmap_hk_registers_o.hk_ccd1_vrd_mon(7 downto 0) <= rmap_writedata_i;
				when (x"00000705") =>
					rmap_hk_registers_o.hk_ccd1_vrd_mon(15 downto 8) <= rmap_writedata_i;
				when (x"00000706") =>
					rmap_hk_registers_o.hk_ccd2_vod_e(7 downto 0) <= rmap_writedata_i;
				when (x"00000707") =>
					rmap_hk_registers_o.hk_ccd2_vod_e(15 downto 8) <= rmap_writedata_i;
				when (x"00000708") =>
					rmap_hk_registers_o.hk_ccd2_vod_f(7 downto 0) <= rmap_writedata_i;
				when (x"00000709") =>
					rmap_hk_registers_o.hk_ccd2_vod_f(15 downto 8) <= rmap_writedata_i;
				when (x"0000070A") =>
					rmap_hk_registers_o.hk_ccd2_vrd_mon(7 downto 0) <= rmap_writedata_i;
				when (x"0000070B") =>
					rmap_hk_registers_o.hk_ccd2_vrd_mon(15 downto 8) <= rmap_writedata_i;
				when (x"0000070C") =>
					rmap_hk_registers_o.hk_ccd3_vod_e(7 downto 0) <= rmap_writedata_i;
				when (x"0000070D") =>
					rmap_hk_registers_o.hk_ccd3_vod_e(15 downto 8) <= rmap_writedata_i;
				when (x"0000070E") =>
					rmap_hk_registers_o.hk_ccd3_vod_f(7 downto 0) <= rmap_writedata_i;
				when (x"0000070F") =>
					rmap_hk_registers_o.hk_ccd3_vod_f(15 downto 8) <= rmap_writedata_i;
				when (x"00000710") =>
					rmap_hk_registers_o.hk_ccd3_vrd_mon(7 downto 0) <= rmap_writedata_i;
				when (x"00000711") =>
					rmap_hk_registers_o.hk_ccd3_vrd_mon(15 downto 8) <= rmap_writedata_i;
				when (x"00000712") =>
					rmap_hk_registers_o.hk_ccd4_vod_e(7 downto 0) <= rmap_writedata_i;
				when (x"00000713") =>
					rmap_hk_registers_o.hk_ccd4_vod_e(15 downto 8) <= rmap_writedata_i;
				when (x"00000714") =>
					rmap_hk_registers_o.hk_ccd4_vod_f(7 downto 0) <= rmap_writedata_i;
				when (x"00000715") =>
					rmap_hk_registers_o.hk_ccd4_vod_f(15 downto 8) <= rmap_writedata_i;
				when (x"00000716") =>
					rmap_hk_registers_o.hk_ccd4_vrd_mon(7 downto 0) <= rmap_writedata_i;
				when (x"00000717") =>
					rmap_hk_registers_o.hk_ccd4_vrd_mon(15 downto 8) <= rmap_writedata_i;
				when (x"00000718") =>
					rmap_hk_registers_o.hk_vccd(7 downto 0) <= rmap_writedata_i;
				when (x"00000719") =>
					rmap_hk_registers_o.hk_vccd(15 downto 8) <= rmap_writedata_i;
				when (x"0000071A") =>
					rmap_hk_registers_o.hk_vrclk(7 downto 0) <= rmap_writedata_i;
				when (x"0000071B") =>
					rmap_hk_registers_o.hk_vrclk(15 downto 8) <= rmap_writedata_i;
				when (x"0000071C") =>
					rmap_hk_registers_o.hk_viclk(7 downto 0) <= rmap_writedata_i;
				when (x"0000071D") =>
					rmap_hk_registers_o.hk_viclk(15 downto 8) <= rmap_writedata_i;
				when (x"0000071E") =>
					rmap_hk_registers_o.hk_vrclk_low(7 downto 0) <= rmap_writedata_i;
				when (x"0000071F") =>
					rmap_hk_registers_o.hk_vrclk_low(15 downto 8) <= rmap_writedata_i;
				when (x"00000720") =>
					rmap_hk_registers_o.hk_5vb_pos(7 downto 0) <= rmap_writedata_i;
				when (x"00000721") =>
					rmap_hk_registers_o.hk_5vb_pos(15 downto 8) <= rmap_writedata_i;
				when (x"00000722") =>
					rmap_hk_registers_o.hk_5vb_neg(7 downto 0) <= rmap_writedata_i;
				when (x"00000723") =>
					rmap_hk_registers_o.hk_5vb_neg(15 downto 8) <= rmap_writedata_i;
				when (x"00000724") =>
					rmap_hk_registers_o.hk_3_3vb_pos(7 downto 0) <= rmap_writedata_i;
				when (x"00000725") =>
					rmap_hk_registers_o.hk_3_3vb_pos(15 downto 8) <= rmap_writedata_i;
				when (x"00000726") =>
					rmap_hk_registers_o.hk_2_5va_pos(7 downto 0) <= rmap_writedata_i;
				when (x"00000727") =>
					rmap_hk_registers_o.hk_2_5va_pos(15 downto 8) <= rmap_writedata_i;
				when (x"00000728") =>
					rmap_hk_registers_o.hk_3_3vd_pos(7 downto 0) <= rmap_writedata_i;
				when (x"00000729") =>
					rmap_hk_registers_o.hk_3_3vd_pos(15 downto 8) <= rmap_writedata_i;
				when (x"0000072A") =>
					rmap_hk_registers_o.hk_2_5vd_pos(7 downto 0) <= rmap_writedata_i;
				when (x"0000072B") =>
					rmap_hk_registers_o.hk_2_5vd_pos(15 downto 8) <= rmap_writedata_i;
				when (x"0000072C") =>
					rmap_hk_registers_o.hk_1_5vd_pos(7 downto 0) <= rmap_writedata_i;
				when (x"0000072D") =>
					rmap_hk_registers_o.hk_1_5vd_pos(15 downto 8) <= rmap_writedata_i;
				when (x"0000072E") =>
					rmap_hk_registers_o.hk_5vref(7 downto 0) <= rmap_writedata_i;
				when (x"0000072F") =>
					rmap_hk_registers_o.hk_5vref(15 downto 8) <= rmap_writedata_i;
				when (x"00000730") =>
					rmap_hk_registers_o.hk_vccd_pos_raw(7 downto 0) <= rmap_writedata_i;
				when (x"00000731") =>
					rmap_hk_registers_o.hk_vccd_pos_raw(15 downto 8) <= rmap_writedata_i;
				when (x"00000732") =>
					rmap_hk_registers_o.hk_vclk_pos_raw(7 downto 0) <= rmap_writedata_i;
				when (x"00000733") =>
					rmap_hk_registers_o.hk_vclk_pos_raw(15 downto 8) <= rmap_writedata_i;
				when (x"00000734") =>
					rmap_hk_registers_o.hk_van1_pos_raw(7 downto 0) <= rmap_writedata_i;
				when (x"00000735") =>
					rmap_hk_registers_o.hk_van1_pos_raw(15 downto 8) <= rmap_writedata_i;
				when (x"00000736") =>
					rmap_hk_registers_o.hk_van3_neg_raw(7 downto 0) <= rmap_writedata_i;
				when (x"00000737") =>
					rmap_hk_registers_o.hk_van3_neg_raw(15 downto 8) <= rmap_writedata_i;
				when (x"00000738") =>
					rmap_hk_registers_o.hk_van2_pos_raw(7 downto 0) <= rmap_writedata_i;
				when (x"00000739") =>
					rmap_hk_registers_o.hk_van2_pos_raw(15 downto 8) <= rmap_writedata_i;
				when (x"0000073A") =>
					rmap_hk_registers_o.hk_vdig_fpga_raw(7 downto 0) <= rmap_writedata_i;
				when (x"0000073B") =>
					rmap_hk_registers_o.hk_vdig_fpga_raw(15 downto 8) <= rmap_writedata_i;
				when (x"0000073C") =>
					rmap_hk_registers_o.hk_vdig_spw_raw(7 downto 0) <= rmap_writedata_i;
				when (x"0000073D") =>
					rmap_hk_registers_o.hk_vdig_spw_raw(15 downto 8) <= rmap_writedata_i;
				when (x"0000073E") =>
					rmap_hk_registers_o.hk_viclk_low(7 downto 0) <= rmap_writedata_i;
				when (x"0000073F") =>
					rmap_hk_registers_o.hk_viclk_low(15 downto 8) <= rmap_writedata_i;
				when (x"00000740") =>
					rmap_hk_registers_o.hk_adc_temp_a_e(7 downto 0) <= rmap_writedata_i;
				when (x"00000741") =>
					rmap_hk_registers_o.hk_adc_temp_a_e(15 downto 8) <= rmap_writedata_i;
				when (x"00000742") =>
					rmap_hk_registers_o.hk_adc_temp_a_f(7 downto 0) <= rmap_writedata_i;
				when (x"00000743") =>
					rmap_hk_registers_o.hk_adc_temp_a_f(15 downto 8) <= rmap_writedata_i;
				when (x"00000744") =>
					rmap_hk_registers_o.hk_ccd1_temp(7 downto 0) <= rmap_writedata_i;
				when (x"00000745") =>
					rmap_hk_registers_o.hk_ccd1_temp(15 downto 8) <= rmap_writedata_i;
				when (x"00000746") =>
					rmap_hk_registers_o.hk_ccd2_temp(7 downto 0) <= rmap_writedata_i;
				when (x"00000747") =>
					rmap_hk_registers_o.hk_ccd2_temp(15 downto 8) <= rmap_writedata_i;
				when (x"00000748") =>
					rmap_hk_registers_o.hk_ccd3_temp(7 downto 0) <= rmap_writedata_i;
				when (x"00000749") =>
					rmap_hk_registers_o.hk_ccd3_temp(15 downto 8) <= rmap_writedata_i;
				when (x"0000074A") =>
					rmap_hk_registers_o.hk_ccd4_temp(7 downto 0) <= rmap_writedata_i;
				when (x"0000074B") =>
					rmap_hk_registers_o.hk_ccd4_temp(15 downto 8) <= rmap_writedata_i;
				when (x"0000074C") =>
					rmap_hk_registers_o.hk_wp605_spare(7 downto 0) <= rmap_writedata_i;
				when (x"0000074D") =>
					rmap_hk_registers_o.hk_wp605_spare(15 downto 8) <= rmap_writedata_i;
				when (x"0000074E") =>
					rmap_hk_registers_o.lowres_prt_a_0(7 downto 0) <= rmap_writedata_i;
				when (x"0000074F") =>
					rmap_hk_registers_o.lowres_prt_a_0(15 downto 8) <= rmap_writedata_i;
				when (x"00000750") =>
					rmap_hk_registers_o.lowres_prt_a_1(7 downto 0) <= rmap_writedata_i;
				when (x"00000751") =>
					rmap_hk_registers_o.lowres_prt_a_1(15 downto 8) <= rmap_writedata_i;
				when (x"00000752") =>
					rmap_hk_registers_o.lowres_prt_a_2(7 downto 0) <= rmap_writedata_i;
				when (x"00000753") =>
					rmap_hk_registers_o.lowres_prt_a_2(15 downto 8) <= rmap_writedata_i;
				when (x"00000754") =>
					rmap_hk_registers_o.lowres_prt_a_3(7 downto 0) <= rmap_writedata_i;
				when (x"00000755") =>
					rmap_hk_registers_o.lowres_prt_a_3(15 downto 8) <= rmap_writedata_i;
				when (x"00000756") =>
					rmap_hk_registers_o.lowres_prt_a_4(7 downto 0) <= rmap_writedata_i;
				when (x"00000757") =>
					rmap_hk_registers_o.lowres_prt_a_4(15 downto 8) <= rmap_writedata_i;
				when (x"00000758") =>
					rmap_hk_registers_o.lowres_prt_a_5(7 downto 0) <= rmap_writedata_i;
				when (x"00000759") =>
					rmap_hk_registers_o.lowres_prt_a_5(15 downto 8) <= rmap_writedata_i;
				when (x"0000075A") =>
					rmap_hk_registers_o.lowres_prt_a_6(7 downto 0) <= rmap_writedata_i;
				when (x"0000075B") =>
					rmap_hk_registers_o.lowres_prt_a_6(15 downto 8) <= rmap_writedata_i;
				when (x"0000075C") =>
					rmap_hk_registers_o.lowres_prt_a_7(7 downto 0) <= rmap_writedata_i;
				when (x"0000075D") =>
					rmap_hk_registers_o.lowres_prt_a_7(15 downto 8) <= rmap_writedata_i;
				when (x"0000075E") =>
					rmap_hk_registers_o.lowres_prt_a_8(7 downto 0) <= rmap_writedata_i;
				when (x"0000075F") =>
					rmap_hk_registers_o.lowres_prt_a_8(15 downto 8) <= rmap_writedata_i;
				when (x"00000760") =>
					rmap_hk_registers_o.lowres_prt_a_9(7 downto 0) <= rmap_writedata_i;
				when (x"00000761") =>
					rmap_hk_registers_o.lowres_prt_a_9(15 downto 8) <= rmap_writedata_i;
				when (x"00000762") =>
					rmap_hk_registers_o.lowres_prt_a_10(7 downto 0) <= rmap_writedata_i;
				when (x"00000763") =>
					rmap_hk_registers_o.lowres_prt_a_10(15 downto 8) <= rmap_writedata_i;
				when (x"00000764") =>
					rmap_hk_registers_o.lowres_prt_a_11(7 downto 0) <= rmap_writedata_i;
				when (x"00000765") =>
					rmap_hk_registers_o.lowres_prt_a_11(15 downto 8) <= rmap_writedata_i;
				when (x"00000766") =>
					rmap_hk_registers_o.lowres_prt_a_12(7 downto 0) <= rmap_writedata_i;
				when (x"00000767") =>
					rmap_hk_registers_o.lowres_prt_a_12(15 downto 8) <= rmap_writedata_i;
				when (x"00000768") =>
					rmap_hk_registers_o.lowres_prt_a_13(7 downto 0) <= rmap_writedata_i;
				when (x"00000769") =>
					rmap_hk_registers_o.lowres_prt_a_13(15 downto 8) <= rmap_writedata_i;
				when (x"0000076A") =>
					rmap_hk_registers_o.lowres_prt_a_14(7 downto 0) <= rmap_writedata_i;
				when (x"0000076B") =>
					rmap_hk_registers_o.lowres_prt_a_14(15 downto 8) <= rmap_writedata_i;
				when (x"0000076C") =>
					rmap_hk_registers_o.lowres_prt_a_15(7 downto 0) <= rmap_writedata_i;
				when (x"0000076D") =>
					rmap_hk_registers_o.lowres_prt_a_15(15 downto 8) <= rmap_writedata_i;
				when (x"0000076E") =>
					rmap_hk_registers_o.sel_hires_prt0(7 downto 0) <= rmap_writedata_i;
				when (x"0000076F") =>
					rmap_hk_registers_o.sel_hires_prt0(15 downto 8) <= rmap_writedata_i;
				when (x"00000770") =>
					rmap_hk_registers_o.sel_hires_prt1(7 downto 0) <= rmap_writedata_i;
				when (x"00000771") =>
					rmap_hk_registers_o.sel_hires_prt1(15 downto 8) <= rmap_writedata_i;
				when (x"00000772") =>
					rmap_hk_registers_o.sel_hires_prt2(7 downto 0) <= rmap_writedata_i;
				when (x"00000773") =>
					rmap_hk_registers_o.sel_hires_prt2(15 downto 8) <= rmap_writedata_i;
				when (x"00000774") =>
					rmap_hk_registers_o.sel_hires_prt3(7 downto 0) <= rmap_writedata_i;
				when (x"00000775") =>
					rmap_hk_registers_o.sel_hires_prt3(15 downto 8) <= rmap_writedata_i;
				when (x"00000776") =>
					rmap_hk_registers_o.sel_hires_prt4(7 downto 0) <= rmap_writedata_i;
				when (x"00000777") =>
					rmap_hk_registers_o.sel_hires_prt4(15 downto 8) <= rmap_writedata_i;
				when (x"00000778") =>
					rmap_hk_registers_o.sel_hires_prt5(7 downto 0) <= rmap_writedata_i;
				when (x"00000779") =>
					rmap_hk_registers_o.sel_hires_prt5(15 downto 8) <= rmap_writedata_i;
				when (x"0000077A") =>
					rmap_hk_registers_o.sel_hires_prt6(7 downto 0) <= rmap_writedata_i;
				when (x"0000077B") =>
					rmap_hk_registers_o.sel_hires_prt6(15 downto 8) <= rmap_writedata_i;
				when (x"0000077C") =>
					rmap_hk_registers_o.sel_hires_prt7(7 downto 0) <= rmap_writedata_i;
				when (x"0000077D") =>
					rmap_hk_registers_o.sel_hires_prt7(15 downto 8) <= rmap_writedata_i;
				when (x"0000077E") =>
					rmap_hk_registers_o.zero_hires_amp(7 downto 0) <= rmap_writedata_i;
				when (x"0000077F") =>
					rmap_hk_registers_o.zero_hires_amp(15 downto 8) <= rmap_writedata_i;

				-- Others
				when others =>
					null;
			end case;

		end procedure p_nfee_mem_wr;
	begin
		if (rst_i = '1') then
			rmap_memerror_o <= '0';
			rmap_memready_o <= '0';
			p_nfee_reg_reset;
		elsif rising_edge(clk_i) then

			-- standard signals value
			rmap_memerror_o <= '0';
			rmap_memready_o <= '1';
			-- check if a write request was issued
			if (rmap_write_i = '1') then
				rmap_memready_o <= '1';
				p_nfee_mem_wr(rmap_writeaddr_i);
			end if;

		end if;
	end process p_rmap_mem_area_nfee_write;

end architecture RTL;

