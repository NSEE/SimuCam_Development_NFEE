library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_write is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_write_i            : in  std_logic;
		rmap_writeaddr_i        : in  std_logic_vector(31 downto 0);
		rmap_writedata_i        : in  std_logic_vector(7 downto 0);
		avalon_mm_rmap_i        : in  t_avalon_mm_spacewire_write_in;
		rmap_write_authorized_i : in  std_logic;
		rmap_write_finished_i   : in  std_logic;
		rmap_read_authorized_i  : in  std_logic;
		rmap_read_finished_i    : in  std_logic;
		rmap_memerror_o         : out std_logic;
		rmap_memready_o         : out std_logic;
		avalon_mm_rmap_o        : out t_avalon_mm_spacewire_write_out;
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
			rmap_config_registers_o.spw_packet_1_config.packet_size_control                           <= x"11F8";
			rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1 <= x"00000000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1                        <= "00000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1                       <= "00000";
			rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1                  <= x"0000";
			rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2 <= x"00000000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2                        <= "00000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2                       <= "00000";
			rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2                  <= x"0000";
			rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3 <= x"00000000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3                        <= "00000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3                       <= "00000";
			rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3                  <= x"0000";
			rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4 <= x"00000000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4                        <= "00000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4                       <= "00000";
			rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4                  <= x"0000";
			rmap_config_registers_o.operation_mode_config.mode_selection_control                      <= x"1";
			rmap_config_registers_o.sync_config.sync_configuration                                    <= "00";
			rmap_config_registers_o.sync_config.self_trigger_control                                  <= '0';
			rmap_config_registers_o.frame_number.frame_number                                         <= "00";
			rmap_config_registers_o.current_mode.current_mode                                         <= "0000";
			-- HK Area
			rmap_hk_registers_o.hk_ccd1_vod_e                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd1_vod_f                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd1_vrd_mon                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_ccd2_vod_e                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd2_vod_f                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd2_vrd_mon                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_ccd3_vod_e                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd3_vod_f                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd3_vrd_mon                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_ccd4_vod_e                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd4_vod_f                                                         <= x"FFFF";
			rmap_hk_registers_o.hk_ccd4_vrd_mon                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_vccd                                                               <= x"FFFF";
			rmap_hk_registers_o.hk_vrclk                                                              <= x"FFFF";
			rmap_hk_registers_o.hk_viclk                                                              <= x"FFFF";
			rmap_hk_registers_o.hk_vrclk_low                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_5vb_pos                                                            <= x"FFFF";
			rmap_hk_registers_o.hk_5vb_neg                                                            <= x"FFFF";
			rmap_hk_registers_o.hk_3_3vb_pos                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_2_5va_pos                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_3_3vd_pos                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_2_5vd_pos                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_1_5vd_pos                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_5vref                                                              <= x"FFFF";
			rmap_hk_registers_o.hk_vccd_pos_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_vclk_pos_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_van1_pos_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_van3_neg_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_van2_pos_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_vdig_fpga_raw                                                      <= x"FFFF";
			rmap_hk_registers_o.hk_vdig_spw_raw                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_viclk_low                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_adc_temp_a_e                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_adc_temp_a_f                                                       <= x"FFFF";
			rmap_hk_registers_o.hk_ccd1_temp                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_ccd2_temp                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_ccd3_temp                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_ccd4_temp                                                          <= x"FFFF";
			rmap_hk_registers_o.hk_wp605_spare                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_0                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_1                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_2                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_3                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_4                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_5                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_6                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_7                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_8                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_9                                                        <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_10                                                       <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_11                                                       <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_12                                                       <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_13                                                       <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_14                                                       <= x"FFFF";
			rmap_hk_registers_o.lowres_prt_a_15                                                       <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt0                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt1                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt2                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt3                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt4                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt5                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt6                                                        <= x"FFFF";
			rmap_hk_registers_o.sel_hires_prt7                                                        <= x"FFFF";
			rmap_hk_registers_o.zero_hires_amp                                                        <= x"FFFF";
		end procedure p_nfee_reg_reset;

		procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
		begin
			-- NFEE Memory Write
			-- Case for access to all registers
			case (wr_addr_i(31 downto 0)) is

				-- Config Area
				when (x"00000003") =>
					rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control                        <= rmap_writedata_i(1);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control                  <= rmap_writedata_i(2);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control               <= rmap_writedata_i(3);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(3 downto 0) <= rmap_writedata_i(7 downto 4);
				when (x"00000002") =>
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"00000001") =>
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control(15 downto 12)  <= rmap_writedata_i(3 downto 0);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control(3 downto 0) <= rmap_writedata_i(7 downto 4);
				when (x"00000000") =>
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"00000007") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000006") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000005") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count(19 downto 16) <= rmap_writedata_i(3 downto 0);
				when (x"00000004") =>
					null;
				when (x"0000000B") =>
					rmap_config_registers_o.spw_packet_1_config.digitise_control                             <= rmap_writedata_i(1);
					rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control <= rmap_writedata_i(3 downto 2);
					rmap_config_registers_o.spw_packet_1_config.packet_size_control(3 downto 0)              <= rmap_writedata_i(7 downto 4);
				when (x"0000000A") =>
					rmap_config_registers_o.spw_packet_1_config.packet_size_control(11 downto 4) <= rmap_writedata_i(7 downto 0);
				when (x"00000009") =>
					rmap_config_registers_o.spw_packet_1_configpacket_size_control(15 downto 12) <= rmap_writedata_i(3 downto 0);
				when (x"00000008") =>
					null;
				when (x"0000000F") =>
					null;
				when (x"0000000E") =>
					null;
				when (x"0000000D") =>
					null;
				when (x"0000000C") =>
					null;
				when (x"00000013") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000012") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000011") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000010") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"00000017") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"00000016") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"00000015") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000014") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"0000001B") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000001A") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000019") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000018") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"0000001F") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"0000001E") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"0000001D") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000001C") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000023") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000022") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000021") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000020") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"00000027") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"00000026") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"00000025") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"00000024") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"0000002B") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000002A") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"00000029") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(23 downto 16) <= rmap_writedata_i(7 downto 0);
				when (x"00000028") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4(31 downto 24) <= rmap_writedata_i(7 downto 0);
				when (x"0000002F") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4              <= rmap_writedata_i(5 downto 0);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4(1 downto 0) <= rmap_writedata_i(7 downto 6);
				when (x"0000002E") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4(5 downto 2) <= rmap_writedata_i(3 downto 0);
				when (x"0000002D") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4(7 downto 0) <= rmap_writedata_i(7 downto 0);
				when (x"0000002C") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4(15 downto 8) <= rmap_writedata_i(7 downto 0);
				when (x"0000003B") =>
					rmap_config_registers_o.operation_mode_config.mode_selection_control <= rmap_writedata_i(7 downto 4);
				when (x"0000003A") =>
					null;
				when (x"00000039") =>
					null;
				when (x"00000038") =>
					null;
				when (x"0000003F") =>
					rmap_config_registers_o.sync_config.sync_configuration   <= rmap_writedata_i(1 downto 0);
					rmap_config_registers_o.sync_config.self_trigger_control <= rmap_writedata_i(2);
				when (x"0000003E") =>
					null;
				when (x"0000003D") =>
					null;
				when (x"0000003C") =>
					null;
				when (x"00000043") =>
					null;
				when (x"00000042") =>
					null;
				when (x"00000041") =>
					null;
				when (x"00000040") =>
					null;
				when (x"00000047") =>
					null;
				when (x"00000046") =>
					null;
				when (x"00000045") =>
					null;
				when (x"00000044") =>
					null;
				when (x"0000004B") =>
					rmap_config_registers_o.frame_number.frame_number <= rmap_writedata_i(1 downto 0);
				when (x"0000004A") =>
					null;
				when (x"00000049") =>
					null;
				when (x"00000048") =>
					null;
				when (x"0000004F") =>
					rmap_config_registers_o.current_mode.current_mode <= rmap_writedata_i(3 downto 0);
				when (x"0000004E") =>
					null;
				when (x"0000004D") =>
					null;
				when (x"0000004C") =>
					null;

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

	p_avalon_mm_rmap_write : process(clk_i, rst_i) is
		procedure p_avs_config_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				-- rmap config registers
				when (x"40") =>
					rmap_config_registers_o.ccd_seq_1_config.tri_level_clock_control               <= avalon_mm_rmap_i.writedata(1);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_direction_control         <= avalon_mm_rmap_i.writedata(2);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_direction_control      <= avalon_mm_rmap_i.writedata(3);
					rmap_config_registers_o.ccd_seq_1_config.image_clock_transfer_count_control    <= avalon_mm_rmap_i.writedata(19 downto 4);
					rmap_config_registers_o.ccd_seq_1_config.register_clock_transfer_count_control <= avalon_mm_rmap_i.writedata(31 downto 20);
				when (x"41") =>
					rmap_config_registers_o.ccd_seq_2_config.slow_read_out_pause_count <= avalon_mm_rmap_i.writedata(19 downto 0);
				when (x"42") =>
					rmap_config_registers_o.spw_packet_1_config.digitise_control                             <= avalon_mm_rmap_i.writedata(1);
					rmap_config_registers_o.spw_packet_1_config.ccd_port_data_transmission_selection_control <= avalon_mm_rmap_i.writedata(3 downto 2);
					rmap_config_registers_o.spw_packet_1_config.packet_size_control                          <= avalon_mm_rmap_i.writedata(19 downto 4);
				when (x"43") =>
					null;
				when (x"44") =>
					rmap_config_registers_o.CCD_1_windowing_1_config.window_list_pointer_initial_address_ccd1 <= avalon_mm_rmap_i.writedata(31 downto 0);
				when (x"45") =>
					rmap_config_registers_o.CCD_1_windowing_2_config.window_width_ccd1       <= avalon_mm_rmap_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_height_ccd1      <= avalon_mm_rmap_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_1_windowing_2_config.window_list_length_ccd1 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"46") =>
					rmap_config_registers_o.CCD_2_windowing_1_config.window_list_pointer_initial_address_ccd2 <= avalon_mm_rmap_i.writedata(31 downto 0);
				when (x"47") =>
					rmap_config_registers_o.CCD_2_windowing_2_config.window_width_ccd2       <= avalon_mm_rmap_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_height_ccd2      <= avalon_mm_rmap_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_2_windowing_2_config.window_list_length_ccd2 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"48") =>
					rmap_config_registers_o.CCD_3_windowing_1_config.window_list_pointer_initial_address_ccd3 <= avalon_mm_rmap_i.writedata(31 downto 0);
				when (x"49") =>
					rmap_config_registers_o.CCD_3_windowing_2_config.window_width_ccd3       <= avalon_mm_rmap_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_height_ccd3      <= avalon_mm_rmap_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_3_windowing_2_config.window_list_length_ccd3 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"4A") =>
					rmap_config_registers_o.CCD_4_windowing_1_config.window_list_pointer_initial_address_ccd4 <= avalon_mm_rmap_i.writedata(31 downto 0);
				when (x"4B") =>
					rmap_config_registers_o.CCD_4_windowing_2_config.window_width_ccd4       <= avalon_mm_rmap_i.writedata(5 downto 0);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_height_ccd4      <= avalon_mm_rmap_i.writedata(11 downto 6);
					rmap_config_registers_o.CCD_4_windowing_2_config.window_list_length_ccd4 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"4C") =>
					rmap_config_registers_o.operation_mode_config.mode_selection_control <= avalon_mm_rmap_i.writedata(7 downto 4);
				when (x"4D") =>
					rmap_config_registers_o.sync_config.sync_configuration   <= avalon_mm_rmap_i.writedata(1 downto 0);
					rmap_config_registers_o.sync_config.self_trigger_control <= avalon_mm_rmap_i.writedata(2);
				when (x"4E") =>
					null;
				when (x"4F") =>
					null;
				when (x"50") =>
					rmap_config_registers_o.frame_number.frame_number <= avalon_mm_rmap_i.writedata(1 downto 0);
				when (x"51") =>
					rmap_config_registers_o.current_mode.current_mode <= avalon_mm_rmap_i.writedata(3 downto 0);

				when others =>
					null;
			end case;
		end procedure p_avs_config_writedata;

		procedure p_avs_hk_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				-- rmap hk registers
				when (x"A0") =>
					rmap_hk_registers_o.hk_ccd1_vod_e <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd1_vod_f <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A1") =>
					rmap_hk_registers_o.hk_ccd1_vrd_mon <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_vod_e   <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A2") =>
					rmap_hk_registers_o.hk_ccd2_vod_f   <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_vrd_mon <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A3") =>
					rmap_hk_registers_o.hk_ccd3_vod_e <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd3_vod_f <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A4") =>
					rmap_hk_registers_o.hk_ccd3_vrd_mon <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_vod_e   <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A5") =>
					rmap_hk_registers_o.hk_ccd4_vod_f   <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_vrd_mon <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A6") =>
					rmap_hk_registers_o.hk_vccd  <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vrclk <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A7") =>
					rmap_hk_registers_o.hk_viclk     <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vrclk_low <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A8") =>
					rmap_hk_registers_o.hk_5vb_pos <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_5vb_neg <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"A9") =>
					rmap_hk_registers_o.hk_3_3vb_pos <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_2_5va_pos <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AA") =>
					rmap_hk_registers_o.hk_3_3vd_pos <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_2_5vd_pos <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AB") =>
					rmap_hk_registers_o.hk_1_5vd_pos <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_5vref     <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AC") =>
					rmap_hk_registers_o.hk_vccd_pos_raw <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vclk_pos_raw <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AD") =>
					rmap_hk_registers_o.hk_van1_pos_raw <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_van3_neg_raw <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AE") =>
					rmap_hk_registers_o.hk_van2_pos_raw  <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_vdig_fpga_raw <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"AF") =>
					rmap_hk_registers_o.hk_vdig_spw_raw <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_viclk_low    <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B0") =>
					rmap_hk_registers_o.hk_adc_temp_a_e <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_adc_temp_a_f <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B1") =>
					rmap_hk_registers_o.hk_ccd1_temp <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd2_temp <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B2") =>
					rmap_hk_registers_o.hk_ccd3_temp <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.hk_ccd4_temp <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B3") =>
					rmap_hk_registers_o.hk_wp605_spare <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_0 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B4") =>
					rmap_hk_registers_o.lowres_prt_a_1 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_2 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B5") =>
					rmap_hk_registers_o.lowres_prt_a_3 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_4 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B6") =>
					rmap_hk_registers_o.lowres_prt_a_5 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_6 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B7") =>
					rmap_hk_registers_o.lowres_prt_a_7 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_8 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B8") =>
					rmap_hk_registers_o.lowres_prt_a_9  <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_10 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"B9") =>
					rmap_hk_registers_o.lowres_prt_a_11 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_12 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BA") =>
					rmap_hk_registers_o.lowres_prt_a_13 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.lowres_prt_a_14 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BB") =>
					rmap_hk_registers_o.lowres_prt_a_15 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt0  <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BC") =>
					rmap_hk_registers_o.sel_hires_prt1 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt2 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BD") =>
					rmap_hk_registers_o.sel_hires_prt3 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt4 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BE") =>
					rmap_hk_registers_o.sel_hires_prt5 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.sel_hires_prt6 <= avalon_mm_rmap_i.writedata(31 downto 16);
				when (x"BF") =>
					rmap_hk_registers_o.sel_hires_prt7 <= avalon_mm_rmap_i.writedata(15 downto 0);
					rmap_hk_registers_o.zero_hires_amp <= avalon_mm_rmap_i.writedata(31 downto 16);

				when others =>
					null;
			end case;
		end procedure p_avs_hk_writedata;

		variable v_write_address     : t_avalon_mm_spacewire_address := 0;
		variable v_write_timeout_cnt : natural range 0 to 15         := 15;
		variable v_write_executed    : std_logic                     := '0';
	begin
		if (rst_i = '1') then
			avalon_mm_rmap_o.waitrequest <= '1';
			v_write_address              := 0;
			v_write_timeout_cnt          := 15;
			v_write_executed             := '0';
		elsif (rising_edge(clk_i)) then
			avalon_mm_rmap_o.waitrequest <= '1';
			if (v_write_executed = 0) then
				if (avalon_mm_rmap_i.write = '1') then
					v_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
					-- check if the write address is in the rmap area range
					if ((v_write_address >= to_integer(unsigned(x"A0"))) and (v_write_address <= to_integer(unsigned(x"BF")))) then
						-- read address is in the rmap housekeeping area range
						-- no need to protect hk registers, write register
						avalon_mm_rmap_o.waitrequest <= '0';
						p_avs_hk_writedata(v_write_address);
						v_write_timeout_cnt          := 15;
						v_write_executed             := '1';
					elsif ((v_read_address >= to_integer(unsigned(x"40"))) and (v_read_address <= to_integer(unsigned(x"51")))) then
						-- write address is in the rmap area range 
						-- check if a rmap write or a rmap read is ocurring
						if ((rmap_write_authorized_i = '0') or (rmap_read_authorized_i = '0')) then
							-- rmap write or a rmap read not ocurring, write register
							avalon_mm_rmap_o.waitrequest <= '0';
							p_avs_config_writedata(v_write_address);
							v_write_timeout_cnt          := 15;
							v_write_executed             := '1';
						else
							-- rmap write or rmap read ocurring, wait to write register
							avalon_mm_rmap_o.waitrequest <= '1';
							v_write_timeout_cnt          := v_write_timeout_cnt - 1;
							-- check if the write or read finished or a timeout ocurred
							if (((rmap_write_finished_i = '1') and (rmap_write_authorized_i = '1')) or ((rmap_read_finished_i = '1') and (rmap_read_authorized_i = '1')) or (v_write_timeout_cnt = 0)) then
								-- write or read finished or timeout ocurred, write register	
								avalon_mm_rmap_o.waitrequest <= '0';
								p_avs_config_writedata(v_write_address);
								v_write_timeout_cnt          := 15;
								v_write_executed             := '1';
							end if;
						end if;
					end if;
				end if;
			else
				v_write_executed := '0';
			end if;
		end if;
	end process p_avalon_mm_rmap_write;

end architecture RTL;
