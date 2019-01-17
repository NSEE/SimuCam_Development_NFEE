library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;

entity rmap_mem_area_nfee_read is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_read_i             : in  std_logic;
		rmap_readaddr_i         : in  std_logic_vector(31 downto 0);
		rmap_config_registers_i : in  t_rmap_memory_config_area;
		rmap_hk_registers_i     : in  t_rmap_memory_hk_area;
		rmap_memerror_o         : out std_logic;
		rmap_datavalid_o        : out std_logic;
		rmap_readdata_o         : out std_logic_vector(7 downto 0)
	);
end entity rmap_mem_area_nfee_read;

architecture RTL of rmap_mem_area_nfee_read is

begin

	p_rmap_mem_area_nfee_read : process(clk_i, rst_i) is
		procedure p_nfee_mem_rd(rd_addr_i : std_logic_vector) is
		begin
			-- NFEE Memory Read
			-- Case for access to all registers
			case (rd_addr_i) is

				-- Config Area
				when (x"00000000") =>
					rmap_readdata_o(0)          <= '0';
					rmap_readdata_o(1)          <= rmap_config_registers_i.ccd_seq_1_config.tri_level_clock_control;
					rmap_readdata_o(2)          <= rmap_config_registers_i.ccd_seq_1_config.image_clock_direction_control;
					rmap_readdata_o(3)          <= rmap_config_registers_i.ccd_seq_1_config.register_clock_direction_control;
					rmap_readdata_o(7 downto 4) <= rmap_config_registers_i.ccd_seq_1_config.image_clock_transfer_count_control(3 downto 0);
				when (x"00000001") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.ccd_seq_1_config.image_clock_transfer_count_control(11 downto 4);
				when (x"00000002") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.ccd_seq_1_config.image_clock_transfer_count_control(15 downto 12);
					rmap_readdata_o(7 downto 4) <= rmap_config_registers_i.ccd_seq_1_config.register_clock_transfer_count_control(3 downto 0);
				when (x"00000003") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.ccd_seq_1_config.register_clock_transfer_count_control(11 downto 4);
				when (x"00000004") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.ccd_seq_2_config.slow_read_out_pause_count(7 downto 0);
				when (x"00000005") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.ccd_seq_2_config.slow_read_out_pause_count(15 downto 8);
				when (x"00000006") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.ccd_seq_2_config.slow_read_out_pause_count(19 downto 16);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"00000007") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000008") =>
					rmap_readdata_o(0)          <= '0';
					rmap_readdata_o(1)          <= rmap_config_registers_i.spw_packet_1_config.digitise_control;
					rmap_readdata_o(3 downto 2) <= rmap_config_registers_i.spw_packet_1_config.ccd_port_data_transmission_selection_control;
					rmap_readdata_o(7 downto 4) <= rmap_config_registers_i.spw_packet_1_config.packet_size_control(3 downto 0);
				when (x"00000009") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.spw_packet_1_config.packet_size_control(11 downto 4);
				when (x"0000000A") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.spw_packet_1_configpacket_size_control(15 downto 12);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"0000000B") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000000C") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000000D") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000000E") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000000F") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000010") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(7 downto 0);
				when (x"00000011") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(15 downto 8);
				when (x"00000012") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(23 downto 16);
				when (x"00000013") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(31 downto 24);
				when (x"00000014") =>
					rmap_readdata_o(5 downto 0) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_width_ccd1;
					rmap_readdata_o(7 downto 6) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_height_ccd1(1 downto 0);
				when (x"00000015") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_height_ccd1(5 downto 2);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"00000016") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_list_length_ccd1(7 downto 0);
				when (x"00000017") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_1_windowing_2_config.window_list_length_ccd1(15 downto 8);
				when (x"00000018") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(7 downto 0);
				when (x"00000019") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(15 downto 8);
				when (x"0000001A") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(23 downto 16);
				when (x"0000001B") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(31 downto 24);
				when (x"0000001C") =>
					rmap_readdata_o(5 downto 0) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_width_ccd2;
					rmap_readdata_o(7 downto 6) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_height_ccd2(1 downto 0);
				when (x"0000001D") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_height_ccd2(5 downto 2);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"0000001E") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_list_length_ccd2(7 downto 0);
				when (x"0000001F") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_2_windowing_2_config.window_list_length_ccd2(15 downto 8);
				when (x"00000020") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(7 downto 0);
				when (x"00000021") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(15 downto 8);
				when (x"00000022") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(23 downto 16);
				when (x"00000023") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(31 downto 24);
				when (x"00000024") =>
					rmap_readdata_o(5 downto 0) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_width_ccd3;
					rmap_readdata_o(7 downto 6) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_height_ccd3(1 downto 0);
				when (x"00000025") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_height_ccd3(5 downto 2);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"00000026") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_list_length_ccd3(7 downto 0);
				when (x"00000027") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_3_windowing_2_config.window_list_length_ccd3(15 downto 8);
				when (x"00000028") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(7 downto 0);
				when (x"00000029") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(15 downto 8);
				when (x"0000002A") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(23 downto 16);
				when (x"0000002B") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(31 downto 24);
				when (x"0000002C") =>
					rmap_readdata_o(5 downto 0) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_width_ccd4;
					rmap_readdata_o(7 downto 6) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_height_ccd4(1 downto 0);
				when (x"0000002D") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_height_ccd4(5 downto 2);
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"0000002E") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_list_length_ccd4(7 downto 0);
				when (x"0000002F") =>
					rmap_readdata_o(7 downto 0) <= rmap_config_registers_i.CCD_4_windowing_2_config.window_list_length_ccd4(15 downto 8);
				when (x"00000038") =>
					rmap_readdata_o(3 downto 0) <= (others => '0');
					rmap_readdata_o(7 downto 4) <= rmap_config_registers_i.operation_mode_config.mode_selection_control;
				when (x"00000039") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000003A") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000003B") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000003C") =>
					rmap_readdata_o(1 downto 0) <= rmap_config_registers_i.sync_config.sync_configuration;
					rmap_readdata_o(2)          <= rmap_config_registers_i.sync_config.self_trigger_control;
					rmap_readdata_o(7 downto 3) <= (others => '0');
				when (x"0000003D") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000003E") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000003F") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000040") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000041") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000042") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000043") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000044") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000045") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000046") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000047") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"00000048") =>
					rmap_readdata_o(1 downto 0) <= rmap_config_registers_i.frame_number.frame_number;
					rmap_readdata_o(7 downto 2) <= (others => '0');
				when (x"00000049") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000004A") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000004B") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000004C") =>
					rmap_readdata_o(3 downto 0) <= rmap_config_registers_i.current_mode.current_mode;
					rmap_readdata_o(7 downto 4) <= (others => '0');
				when (x"0000004D") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000004E") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');
				when (x"0000004F") =>
					rmap_readdata_o(7 downto 0) <= (others => '0');

				-- HK area
				when (x"00000700") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vod_e(7 downto 0);
				when (x"00000701") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vod_e(15 downto 8);
				when (x"00000702") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vod_f(7 downto 0);
				when (x"00000703") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vod_f(15 downto 8);
				when (x"00000704") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vrd_mon(7 downto 0);
				when (x"00000705") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_vrd_mon(15 downto 8);
				when (x"00000706") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vod_e(7 downto 0);
				when (x"00000707") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vod_e(15 downto 8);
				when (x"00000708") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vod_f(7 downto 0);
				when (x"00000709") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vod_f(15 downto 8);
				when (x"0000070A") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vrd_mon(7 downto 0);
				when (x"0000070B") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_vrd_mon(15 downto 8);
				when (x"0000070C") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vod_e(7 downto 0);
				when (x"0000070D") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vod_e(15 downto 8);
				when (x"0000070E") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vod_f(7 downto 0);
				when (x"0000070F") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vod_f(15 downto 8);
				when (x"00000710") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vrd_mon(7 downto 0);
				when (x"00000711") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_vrd_mon(15 downto 8);
				when (x"00000712") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vod_e(7 downto 0);
				when (x"00000713") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vod_e(15 downto 8);
				when (x"00000714") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vod_f(7 downto 0);
				when (x"00000715") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vod_f(15 downto 8);
				when (x"00000716") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vrd_mon(7 downto 0);
				when (x"00000717") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_vrd_mon(15 downto 8);
				when (x"00000718") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vccd(7 downto 0);
				when (x"00000719") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vccd(15 downto 8);
				when (x"0000071A") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vrclk(7 downto 0);
				when (x"0000071B") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vrclk(15 downto 8);
				when (x"0000071C") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_viclk(7 downto 0);
				when (x"0000071D") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_viclk(15 downto 8);
				when (x"0000071E") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vrclk_low(7 downto 0);
				when (x"0000071F") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vrclk_low(15 downto 8);
				when (x"00000720") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vb_pos(7 downto 0);
				when (x"00000721") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vb_pos(15 downto 8);
				when (x"00000722") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vb_neg(7 downto 0);
				when (x"00000723") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vb_neg(15 downto 8);
				when (x"00000724") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_3_3vb_pos(7 downto 0);
				when (x"00000725") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_3_3vb_pos(15 downto 8);
				when (x"00000726") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_2_5va_pos(7 downto 0);
				when (x"00000727") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_2_5va_pos(15 downto 8);
				when (x"00000728") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_3_3vd_pos(7 downto 0);
				when (x"00000729") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_3_3vd_pos(15 downto 8);
				when (x"0000072A") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_2_5vd_pos(7 downto 0);
				when (x"0000072B") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_2_5vd_pos(15 downto 8);
				when (x"0000072C") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_1_5vd_pos(7 downto 0);
				when (x"0000072D") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_1_5vd_pos(15 downto 8);
				when (x"0000072E") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vref(7 downto 0);
				when (x"0000072F") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_5vref(15 downto 8);
				when (x"00000730") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vccd_pos_raw(7 downto 0);
				when (x"00000731") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vccd_pos_raw(15 downto 8);
				when (x"00000732") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vclk_pos_raw(7 downto 0);
				when (x"00000733") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vclk_pos_raw(15 downto 8);
				when (x"00000734") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van1_pos_raw(7 downto 0);
				when (x"00000735") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van1_pos_raw(15 downto 8);
				when (x"00000736") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van3_neg_raw(7 downto 0);
				when (x"00000737") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van3_neg_raw(15 downto 8);
				when (x"00000738") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van2_pos_raw(7 downto 0);
				when (x"00000739") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_van2_pos_raw(15 downto 8);
				when (x"0000073A") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vdig_fpga_raw(7 downto 0);
				when (x"0000073B") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vdig_fpga_raw(15 downto 8);
				when (x"0000073C") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vdig_spw_raw(7 downto 0);
				when (x"0000073D") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_vdig_spw_raw(15 downto 8);
				when (x"0000073E") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_viclk_low(7 downto 0);
				when (x"0000073F") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_viclk_low(15 downto 8);
				when (x"00000740") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_adc_temp_a_e(7 downto 0);
				when (x"00000741") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_adc_temp_a_e(15 downto 8);
				when (x"00000742") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_adc_temp_a_f(7 downto 0);
				when (x"00000743") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_adc_temp_a_f(15 downto 8);
				when (x"00000744") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_temp(7 downto 0);
				when (x"00000745") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd1_temp(15 downto 8);
				when (x"00000746") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_temp(7 downto 0);
				when (x"00000747") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd2_temp(15 downto 8);
				when (x"00000748") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_temp(7 downto 0);
				when (x"00000749") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd3_temp(15 downto 8);
				when (x"0000074A") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_temp(7 downto 0);
				when (x"0000074B") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_ccd4_temp(15 downto 8);
				when (x"0000074C") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_wp605_spare(7 downto 0);
				when (x"0000074D") =>
					rmap_readdata_o <= rmap_hk_registers_i.hk_wp605_spare(15 downto 8);
				when (x"0000074E") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_0(7 downto 0);
				when (x"0000074F") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_0(15 downto 8);
				when (x"00000750") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_1(7 downto 0);
				when (x"00000751") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_1(15 downto 8);
				when (x"00000752") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_2(7 downto 0);
				when (x"00000753") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_2(15 downto 8);
				when (x"00000754") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_3(7 downto 0);
				when (x"00000755") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_3(15 downto 8);
				when (x"00000756") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_4(7 downto 0);
				when (x"00000757") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_4(15 downto 8);
				when (x"00000758") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_5(7 downto 0);
				when (x"00000759") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_5(15 downto 8);
				when (x"0000075A") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_6(7 downto 0);
				when (x"0000075B") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_6(15 downto 8);
				when (x"0000075C") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_7(7 downto 0);
				when (x"0000075D") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_7(15 downto 8);
				when (x"0000075E") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_8(7 downto 0);
				when (x"0000075F") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_8(15 downto 8);
				when (x"00000760") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_9(7 downto 0);
				when (x"00000761") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_9(15 downto 8);
				when (x"00000762") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_10(7 downto 0);
				when (x"00000763") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_10(15 downto 8);
				when (x"00000764") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_11(7 downto 0);
				when (x"00000765") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_11(15 downto 8);
				when (x"00000766") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_12(7 downto 0);
				when (x"00000767") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_12(15 downto 8);
				when (x"00000768") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_13(7 downto 0);
				when (x"00000769") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_13(15 downto 8);
				when (x"0000076A") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_14(7 downto 0);
				when (x"0000076B") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_14(15 downto 8);
				when (x"0000076C") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_15(7 downto 0);
				when (x"0000076D") =>
					rmap_readdata_o <= rmap_hk_registers_i.lowres_prt_a_15(15 downto 8);
				when (x"0000076E") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt0(7 downto 0);
				when (x"0000076F") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt0(15 downto 8);
				when (x"00000770") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt1(7 downto 0);
				when (x"00000771") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt1(15 downto 8);
				when (x"00000772") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt2(7 downto 0);
				when (x"00000773") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt2(15 downto 8);
				when (x"00000774") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt3(7 downto 0);
				when (x"00000775") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt3(15 downto 8);
				when (x"00000776") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt4(7 downto 0);
				when (x"00000777") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt4(15 downto 8);
				when (x"00000778") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt5(7 downto 0);
				when (x"00000779") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt5(15 downto 8);
				when (x"0000077A") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt6(7 downto 0);
				when (x"0000077B") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt6(15 downto 8);
				when (x"0000077C") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt7(7 downto 0);
				when (x"0000077D") =>
					rmap_readdata_o <= rmap_hk_registers_i.sel_hires_prt7(15 downto 8);
				when (x"0000077E") =>
					rmap_readdata_o <= rmap_hk_registers_i.zero_hires_amp(7 downto 0);
				when (x"0000077F") =>
					rmap_readdata_o <= rmap_hk_registers_i.zero_hires_amp(15 downto 8);

				-- others
				when others =>
					rmap_readdata_o <= (others => '0');
			end case;

		end procedure p_nfee_mem_rd;
	begin
		if (rst_i = '1') then
			rmap_memerror_o  <= '0';
			rmap_datavalid_o <= '0';
			rmap_readdata_o  <= (others => '0');
		elsif rising_edge(clk_i) then

			-- standard signals value
			rmap_memerror_o  <= '0';
			rmap_datavalid_o <= '0';
			rmap_readdata_o  <= (others => '0');
			-- check if a read request was issued
			if (rmap_read_i = '1') then
				rmap_datavalid_o <= '1';
				p_nfee_mem_rd(rmap_readaddr_i);
			end if;

		end if;
	end process p_rmap_mem_area_nfee_read;

end architecture RTL;
