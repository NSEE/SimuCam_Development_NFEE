library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_rmap_mem_area_nfee_pkg.all;
use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity nrme_rmap_mem_area_nfee_write_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_nrme_nfee_rmap_write_in;
		avalon_mm_rmap_i    : in  t_nrme_avalon_mm_rmap_nfee_write_in;
		fee_rmap_o          : out t_nrme_nfee_rmap_write_out;
		avalon_mm_rmap_o    : out t_nrme_avalon_mm_rmap_nfee_write_out;
		rmap_registers_wr_o : out t_rmap_memory_wr_area
	);
end entity nrme_rmap_mem_area_nfee_write_ent;

architecture RTL of nrme_rmap_mem_area_nfee_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_nrme_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
		procedure p_nfee_reg_reset is
		begin

			-- Write Registers Reset/Default State

			-- RMAP Area Config Register 0 : V Start Config Field
			rmap_registers_wr_o.reg_0_config.v_start                       <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 0 : V End Config Field
			rmap_registers_wr_o.reg_0_config.v_end                         <= std_logic_vector(to_unsigned(4539, 16));
			-- RMAP Area Config Register 1 : Charge Injection Width Config Field
			rmap_registers_wr_o.reg_1_config.charge_injection_width        <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
			rmap_registers_wr_o.reg_1_config.charge_injection_gap          <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
			rmap_registers_wr_o.reg_2_config.parallel_toi_period           <= x"465";
			-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
			rmap_registers_wr_o.reg_2_config.parallel_clk_overlap          <= x"0FA";
			-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
			rmap_registers_wr_o.reg_2_config.ccd_readout_order_1st_ccd     <= std_logic_vector(to_unsigned(0, 2));
			-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
			rmap_registers_wr_o.reg_2_config.ccd_readout_order_2nd_ccd     <= std_logic_vector(to_unsigned(1, 2));
			-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
			rmap_registers_wr_o.reg_2_config.ccd_readout_order_3rd_ccd     <= std_logic_vector(to_unsigned(2, 2));
			-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
			rmap_registers_wr_o.reg_2_config.ccd_readout_order_4th_ccd     <= std_logic_vector(to_unsigned(3, 2));
			-- RMAP Area Config Register 3 : N Final Dump Config Field
			rmap_registers_wr_o.reg_3_config.n_final_dump                  <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 3 : H End Config Field
			rmap_registers_wr_o.reg_3_config.h_end                         <= std_logic_vector(to_unsigned(2294, 12));
			-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
			rmap_registers_wr_o.reg_3_config.charge_injection_en           <= '0';
			-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
			rmap_registers_wr_o.reg_3_config.tri_level_clk_en              <= '0';
			-- RMAP Area Config Register 3 : Image Clock Direction Config Field
			rmap_registers_wr_o.reg_3_config.img_clk_dir                   <= '0';
			-- RMAP Area Config Register 3 : Register Clock Direction Config Field
			rmap_registers_wr_o.reg_3_config.reg_clk_dir                   <= '0';
			-- RMAP Area Config Register 4 : Data Packet Size Config Field
			rmap_registers_wr_o.reg_4_config.packet_size                   <= std_logic_vector(to_unsigned(32140, 16));
			-- RMAP Area Config Register 4 : Internal Sync Period Config Field
			rmap_registers_wr_o.reg_4_config.int_sync_period               <= std_logic_vector(to_unsigned(6250, 16));
			-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
			rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter    <= std_logic_vector(to_unsigned(250000, 20));
			-- RMAP Area Config Register 5 : Sync Source Selection Config Field
			rmap_registers_wr_o.reg_5_config.sync_sel                      <= '0';
			-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
			rmap_registers_wr_o.reg_5_config.sensor_sel                    <= std_logic_vector(to_unsigned(3, 2));
			-- RMAP Area Config Register 5 : Digitalise Enable Config Field
			rmap_registers_wr_o.reg_5_config.digitise_en                   <= '1';
			-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
			rmap_registers_wr_o.reg_5_config.dg_en                         <= '0';
			-- RMAP Area Config Register 5 : CCD Readout Enable Field
			rmap_registers_wr_o.reg_5_config.ccd_read_en                   <= '1';
			-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
			rmap_registers_wr_o.reg_5_config.reg_5_config_reserved         <= (others => '0');
			-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
			rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr             <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
			rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr        <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
			rmap_registers_wr_o.reg_8_config.ccd1_win_list_length          <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
			rmap_registers_wr_o.reg_8_config.ccd1_win_size_x               <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
			rmap_registers_wr_o.reg_8_config.ccd1_win_size_y               <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
			rmap_registers_wr_o.reg_8_config.reg_8_config_reserved         <= (others => '0');
			-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
			rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr             <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
			rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr       <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
			rmap_registers_wr_o.reg_11_config.ccd2_win_list_length         <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
			rmap_registers_wr_o.reg_11_config.ccd2_win_size_x              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
			rmap_registers_wr_o.reg_11_config.ccd2_win_size_y              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
			rmap_registers_wr_o.reg_11_config.reg_11_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
			rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr            <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
			rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr       <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
			rmap_registers_wr_o.reg_14_config.ccd3_win_list_length         <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
			rmap_registers_wr_o.reg_14_config.ccd3_win_size_x              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
			rmap_registers_wr_o.reg_14_config.ccd3_win_size_y              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
			rmap_registers_wr_o.reg_14_config.reg_14_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
			rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr            <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
			rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr       <= std_logic_vector(to_unsigned(0, 32));
			-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
			rmap_registers_wr_o.reg_17_config.ccd4_win_list_length         <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
			rmap_registers_wr_o.reg_17_config.ccd4_win_size_x              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
			rmap_registers_wr_o.reg_17_config.ccd4_win_size_y              <= std_logic_vector(to_unsigned(0, 6));
			-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
			rmap_registers_wr_o.reg_17_config.reg_17_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
			rmap_registers_wr_o.reg_18_config.ccd_vod_config               <= std_logic_vector(to_unsigned(3276, 12));
			-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
			rmap_registers_wr_o.reg_18_config.ccd1_vrd_config              <= std_logic_vector(to_unsigned(3685, 12));
			-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
			rmap_registers_wr_o.reg_18_config.ccd2_vrd_config0             <= std_logic_vector(to_unsigned(101, 8));
			-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
			rmap_registers_wr_o.reg_19_config.ccd2_vrd_config1             <= std_logic_vector(to_unsigned(14, 4));
			-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
			rmap_registers_wr_o.reg_19_config.ccd3_vrd_config              <= std_logic_vector(to_unsigned(3685, 12));
			-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
			rmap_registers_wr_o.reg_19_config.ccd4_vrd_config              <= std_logic_vector(to_unsigned(3685, 12));
			-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
			rmap_registers_wr_o.reg_19_config.ccd_vgd_config0              <= std_logic_vector(to_unsigned(12, 4));
			-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
			rmap_registers_wr_o.reg_20_config.ccd_vgd_config1              <= std_logic_vector(to_unsigned(204, 8));
			-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
			rmap_registers_wr_o.reg_20_config.ccd_vog_config               <= std_logic_vector(to_unsigned(410, 12));
			-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
			rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config             <= std_logic_vector(to_unsigned(3276, 12));
			-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
			rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config             <= std_logic_vector(to_unsigned(0, 12));
			-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
			rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0     <= std_logic_vector(to_unsigned(0, 12));
			-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
			rmap_registers_wr_o.reg_21_config.ccd_mode_config              <= std_logic_vector(to_unsigned(0, 4));
			-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
			rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_1     <= std_logic_vector(to_unsigned(0, 3));
			-- RMAP Area Config Register 21 : Clear Error Flag Config Field
			rmap_registers_wr_o.reg_21_config.clear_error_flag             <= '0';
			-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
			rmap_registers_wr_o.reg_22_config.reg_22_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
			rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
			rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
			rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
			rmap_registers_wr_o.reg_23_config.reg_23_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
			rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
			rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
			rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
			rmap_registers_wr_o.reg_24_config.reg_24_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
			rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
			rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet           <= std_logic_vector(to_unsigned(0, 10));
			-- RMAP Area Config Register 25 : Surface Inversion Counter Field
			rmap_registers_wr_o.reg_25_config.surface_inversion_counter    <= std_logic_vector(to_unsigned(100, 10));
			-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
			rmap_registers_wr_o.reg_25_config.reg_25_config_reserved       <= (others => '0');
			-- RMAP Area Config Register 26 : Readout Pause Counter Field
			rmap_registers_wr_o.reg_26_config.readout_pause_counter        <= std_logic_vector(to_unsigned(2000, 16));
			-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
			rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter <= std_logic_vector(to_unsigned(1000, 16));
			-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
			rmap_registers_wr_o.reg_0_hk.tou_sense_1                       <= x"FFFF";
			-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
			rmap_registers_wr_o.reg_0_hk.tou_sense_2                       <= x"FFFF";
			-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
			rmap_registers_wr_o.reg_1_hk.tou_sense_3                       <= x"FFFF";
			-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
			rmap_registers_wr_o.reg_1_hk.tou_sense_4                       <= x"FFFF";
			-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
			rmap_registers_wr_o.reg_2_hk.tou_sense_5                       <= x"FFFF";
			-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
			rmap_registers_wr_o.reg_2_hk.tou_sense_6                       <= x"FFFF";
			-- RMAP Area HK Register 3 : CCD 1 TS HK Field
			rmap_registers_wr_o.reg_3_hk.ccd1_ts                           <= x"FFFF";
			-- RMAP Area HK Register 3 : CCD 2 TS HK Field
			rmap_registers_wr_o.reg_3_hk.ccd2_ts                           <= x"FFFF";
			-- RMAP Area HK Register 4 : CCD 3 TS HK Field
			rmap_registers_wr_o.reg_4_hk.ccd3_ts                           <= x"FFFF";
			-- RMAP Area HK Register 4 : CCD 4 TS HK Field
			rmap_registers_wr_o.reg_4_hk.ccd4_ts                           <= x"FFFF";
			-- RMAP Area HK Register 5 : PRT 1 HK Field
			rmap_registers_wr_o.reg_5_hk.prt1                              <= x"FFFF";
			-- RMAP Area HK Register 5 : PRT 2 HK Field
			rmap_registers_wr_o.reg_5_hk.prt2                              <= x"FFFF";
			-- RMAP Area HK Register 6 : PRT 3 HK Field
			rmap_registers_wr_o.reg_6_hk.prt3                              <= x"FFFF";
			-- RMAP Area HK Register 6 : PRT 4 HK Field
			rmap_registers_wr_o.reg_6_hk.prt4                              <= x"FFFF";
			-- RMAP Area HK Register 7 : PRT 5 HK Field
			rmap_registers_wr_o.reg_7_hk.prt5                              <= x"FFFF";
			-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
			rmap_registers_wr_o.reg_7_hk.zero_diff_amp                     <= x"FFFF";
			-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
			rmap_registers_wr_o.reg_8_hk.ccd1_vod_mon                      <= x"FFFF";
			-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
			rmap_registers_wr_o.reg_8_hk.ccd1_vog_mon                      <= x"FFFF";
			-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
			rmap_registers_wr_o.reg_9_hk.ccd1_vrd_mon_e                    <= x"FFFF";
			-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
			rmap_registers_wr_o.reg_9_hk.ccd2_vod_mon                      <= x"FFFF";
			-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
			rmap_registers_wr_o.reg_10_hk.ccd2_vog_mon                     <= x"FFFF";
			-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
			rmap_registers_wr_o.reg_10_hk.ccd2_vrd_mon_e                   <= x"FFFF";
			-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
			rmap_registers_wr_o.reg_11_hk.ccd3_vod_mon                     <= x"FFFF";
			-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
			rmap_registers_wr_o.reg_11_hk.ccd3_vog_mon                     <= x"FFFF";
			-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
			rmap_registers_wr_o.reg_12_hk.ccd3_vrd_mon_e                   <= x"FFFF";
			-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
			rmap_registers_wr_o.reg_12_hk.ccd4_vod_mon                     <= x"FFFF";
			-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
			rmap_registers_wr_o.reg_13_hk.ccd4_vog_mon                     <= x"FFFF";
			-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
			rmap_registers_wr_o.reg_13_hk.ccd4_vrd_mon_e                   <= x"FFFF";
			-- RMAP Area HK Register 14 : V CCD HK Field
			rmap_registers_wr_o.reg_14_hk.vccd                             <= x"FFFF";
			-- RMAP Area HK Register 14 : VRClock Monitor HK Field
			rmap_registers_wr_o.reg_14_hk.vrclk_mon                        <= x"FFFF";
			-- RMAP Area HK Register 15 : VIClock HK Field
			rmap_registers_wr_o.reg_15_hk.viclk                            <= x"FFFF";
			-- RMAP Area HK Register 15 : VRClock Low HK Field
			rmap_registers_wr_o.reg_15_hk.vrclk_low                        <= x"FFFF";
			-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
			rmap_registers_wr_o.reg_16_hk.d5vb_pos_mon                     <= x"FFFF";
			-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
			rmap_registers_wr_o.reg_16_hk.d5vb_neg_mon                     <= x"FFFF";
			-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
			rmap_registers_wr_o.reg_17_hk.d3v3b_mon                        <= x"FFFF";
			-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
			rmap_registers_wr_o.reg_17_hk.d2v5a_mon                        <= x"FFFF";
			-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
			rmap_registers_wr_o.reg_18_hk.d3v3d_mon                        <= x"FFFF";
			-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
			rmap_registers_wr_o.reg_18_hk.d2v5d_mon                        <= x"FFFF";
			-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
			rmap_registers_wr_o.reg_19_hk.d1v5d_mon                        <= x"FFFF";
			-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
			rmap_registers_wr_o.reg_19_hk.d5vref_mon                       <= x"FFFF";
			-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
			rmap_registers_wr_o.reg_20_hk.vccd_pos_raw                     <= x"FFFF";
			-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
			rmap_registers_wr_o.reg_20_hk.vclk_pos_raw                     <= x"FFFF";
			-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
			rmap_registers_wr_o.reg_21_hk.van1_pos_raw                     <= x"FFFF";
			-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
			rmap_registers_wr_o.reg_21_hk.van3_neg_mon                     <= x"FFFF";
			-- RMAP Area HK Register 22 : Van Positive Raw HK Field
			rmap_registers_wr_o.reg_22_hk.van2_pos_raw                     <= x"FFFF";
			-- RMAP Area HK Register 22 : Vdig Raw HK Field
			rmap_registers_wr_o.reg_22_hk.vdig_raw                         <= x"FFFF";
			-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
			rmap_registers_wr_o.reg_23_hk.vdig_raw_2                       <= x"FFFF";
			-- RMAP Area HK Register 23 : VIClock Low HK Field
			rmap_registers_wr_o.reg_23_hk.viclk_low                        <= x"FFFF";
			-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
			rmap_registers_wr_o.reg_24_hk.ccd1_vrd_mon_f                   <= x"FFFF";
			-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
			rmap_registers_wr_o.reg_24_hk.ccd1_vdd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
			rmap_registers_wr_o.reg_25_hk.ccd1_vgd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
			rmap_registers_wr_o.reg_25_hk.ccd2_vrd_mon_f                   <= x"FFFF";
			-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
			rmap_registers_wr_o.reg_26_hk.ccd2_vdd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
			rmap_registers_wr_o.reg_26_hk.ccd2_vgd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
			rmap_registers_wr_o.reg_27_hk.ccd3_vrd_mon_f                   <= x"FFFF";
			-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
			rmap_registers_wr_o.reg_27_hk.ccd3_vdd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
			rmap_registers_wr_o.reg_28_hk.ccd3_vgd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
			rmap_registers_wr_o.reg_28_hk.ccd4_vrd_mon_f                   <= x"FFFF";
			-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
			rmap_registers_wr_o.reg_29_hk.ccd4_vdd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
			rmap_registers_wr_o.reg_29_hk.ccd4_vgd_mon                     <= x"FFFF";
			-- RMAP Area HK Register 30 : Ig High Monitor HK Field
			rmap_registers_wr_o.reg_30_hk.ig_hi_mon                        <= x"FFFF";
			-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
			rmap_registers_wr_o.reg_30_hk.ig_lo_mon                        <= x"FFFF";
			-- RMAP Area HK Register 31 : Tsense A HK Field
			rmap_registers_wr_o.reg_31_hk.tsense_a                         <= x"FFFF";
			-- RMAP Area HK Register 31 : Tsense B HK Field
			rmap_registers_wr_o.reg_31_hk.tsense_b                         <= x"FFFF";
			-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
			rmap_registers_wr_o.reg_32_hk.spw_status_spw_status_reserved   <= (others => '0');
			-- RMAP Area HK Register 32 : Register 32 HK Reserved
			rmap_registers_wr_o.reg_32_hk.reg_32_hk_reserved               <= (others => '0');
			-- RMAP Area HK Register 33 : Register 33 HK Reserved
			rmap_registers_wr_o.reg_33_hk.reg_33_hk_reserved               <= (others => '0');
			-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
			rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved <= (others => '0');
			-- RMAP Area HK Register 35 : FPGA Minor Version Field
			rmap_registers_wr_o.reg_35_hk.fpga_minor_version               <= (others => '0');
			-- RMAP Area HK Register 35 : FPGA Major Version Field
			rmap_registers_wr_o.reg_35_hk.fpga_major_version               <= (others => '0');
			-- RMAP Area HK Register 35 : Board ID Field
			rmap_registers_wr_o.reg_35_hk.board_id                         <= (others => '0');
			-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
			rmap_registers_wr_o.reg_35_hk.reg_35_hk_reserved               <= (others => '0');

		end procedure p_nfee_reg_reset;

		procedure p_nfee_reg_trigger is
		begin

			-- Write Registers Triggers Reset

			-- RMAP Area Config Register 21 : Clear Error Flag Config Field
			rmap_registers_wr_o.reg_21_config.clear_error_flag <= '0';

		end procedure p_nfee_reg_trigger;

		procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
		begin

			-- MemArea Write Data
			case (wr_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000000") =>
					-- RMAP Area Config Register 0 : V End Config Field
					rmap_registers_wr_o.reg_0_config.v_end(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000001") =>
					-- RMAP Area Config Register 0 : V End Config Field
					rmap_registers_wr_o.reg_0_config.v_end(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000002") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_registers_wr_o.reg_0_config.v_start(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000003") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_registers_wr_o.reg_0_config.v_start(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000004") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_gap(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000005") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_gap(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000006") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_width(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000007") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_width(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000008") =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_1st_ccd <= fee_rmap_i.writedata(1 downto 0);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_2nd_ccd <= fee_rmap_i.writedata(3 downto 2);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_3rd_ccd <= fee_rmap_i.writedata(5 downto 4);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_4th_ccd <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000009") =>
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(11 downto 4) <= fee_rmap_i.writedata;

				when (x"0000000A") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_registers_wr_o.reg_2_config.parallel_toi_period(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000000B") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_registers_wr_o.reg_2_config.parallel_toi_period(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000000C") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_registers_wr_o.reg_3_config.h_end(11 downto 8)  <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					rmap_registers_wr_o.reg_3_config.charge_injection_en <= fee_rmap_i.writedata(4);
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					rmap_registers_wr_o.reg_3_config.tri_level_clk_en    <= fee_rmap_i.writedata(5);
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					rmap_registers_wr_o.reg_3_config.img_clk_dir         <= fee_rmap_i.writedata(6);
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					rmap_registers_wr_o.reg_3_config.reg_clk_dir         <= fee_rmap_i.writedata(7);

				when (x"0000000D") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_registers_wr_o.reg_3_config.h_end(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000000E") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_registers_wr_o.reg_3_config.n_final_dump(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000000F") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_registers_wr_o.reg_3_config.n_final_dump(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000010") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_registers_wr_o.reg_4_config.int_sync_period(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000011") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_registers_wr_o.reg_4_config.int_sync_period(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000012") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_registers_wr_o.reg_4_config.packet_size(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000013") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_registers_wr_o.reg_4_config.packet_size(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000014") =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					rmap_registers_wr_o.reg_5_config.dg_en                 <= fee_rmap_i.writedata(0);
					-- RMAP Area Config Register 5 : CCD Readout Enable Field
					rmap_registers_wr_o.reg_5_config.ccd_read_en           <= fee_rmap_i.writedata(1);
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					rmap_registers_wr_o.reg_5_config.reg_5_config_reserved <= fee_rmap_i.writedata(7 downto 2);

				when (x"00000015") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(19 downto 16) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					rmap_registers_wr_o.reg_5_config.sync_sel                                 <= fee_rmap_i.writedata(4);
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					rmap_registers_wr_o.reg_5_config.sensor_sel                               <= fee_rmap_i.writedata(6 downto 5);
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					rmap_registers_wr_o.reg_5_config.digitise_en                              <= fee_rmap_i.writedata(7);

				when (x"00000016") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000017") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000018") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000019") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000001A") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000001B") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000001C") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0000001D") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000001E") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000001F") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000020") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_y(5 downto 2) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					rmap_registers_wr_o.reg_8_config.reg_8_config_reserved       <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000021") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_x             <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_y(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000022") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000023") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000024") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000025") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000026") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000027") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000028") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000029") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000002A") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000002B") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000002C") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_y(5 downto 2) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					rmap_registers_wr_o.reg_11_config.reg_11_config_reserved      <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000002D") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_x             <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_y(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"0000002E") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000002F") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000030") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000031") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000032") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000033") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000034") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000035") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000036") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000037") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000038") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_y(5 downto 2) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					rmap_registers_wr_o.reg_14_config.reg_14_config_reserved      <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000039") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_x             <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_y(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"0000003A") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000003B") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000003C") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0000003D") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000003E") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000003F") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000040") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000041") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000042") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000043") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000044") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_y(5 downto 2) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					rmap_registers_wr_o.reg_17_config.reg_17_config_reserved      <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000045") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_x             <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_y(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000046") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000047") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000048") =>
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd2_vrd_config0 <= fee_rmap_i.writedata;

				when (x"00000049") =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(11 downto 4) <= fee_rmap_i.writedata;

				when (x"0000004A") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd_vod_config(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000004B") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd_vod_config(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000004C") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd_vgd_config0              <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000004D") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000004E") =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(11 downto 4) <= fee_rmap_i.writedata;

				when (x"0000004F") =>
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd2_vrd_config1            <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000050") =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(11 downto 4) <= fee_rmap_i.writedata;

				when (x"00000051") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vog_config(11 downto 8)  <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000052") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vog_config(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000053") =>
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vgd_config1 <= fee_rmap_i.writedata;

				when (x"00000054") =>
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_mode_config          <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_1 <= fee_rmap_i.writedata(6 downto 4);
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					rmap_registers_wr_o.reg_21_config.clear_error_flag         <= fee_rmap_i.writedata(7);

				when (x"00000055") =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(11 downto 4) <= fee_rmap_i.writedata;

				when (x"00000056") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(11 downto 8)        <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000057") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000058") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000059") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000005A") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000005B") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000005C") =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(9 downto 4) <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					rmap_registers_wr_o.reg_23_config.reg_23_config_reserved         <= fee_rmap_i.writedata(7 downto 6);

				when (x"0000005D") =>
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(9 downto 6) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000005E") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(5 downto 0) <= fee_rmap_i.writedata(7 downto 2);

				when (x"0000005F") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000060") =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(9 downto 4) <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					rmap_registers_wr_o.reg_24_config.reg_24_config_reserved         <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000061") =>
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(9 downto 6) <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000062") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(5 downto 0) <= fee_rmap_i.writedata(7 downto 2);

				when (x"00000063") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000064") =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_registers_wr_o.reg_25_config.surface_inversion_counter(9 downto 4) <= fee_rmap_i.writedata(5 downto 0);
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					rmap_registers_wr_o.reg_25_config.reg_25_config_reserved                <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000065") =>
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(9 downto 6)        <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_registers_wr_o.reg_25_config.surface_inversion_counter(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000066") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(5 downto 0) <= fee_rmap_i.writedata(7 downto 2);

				when (x"00000067") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000068") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000069") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000006A") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_registers_wr_o.reg_26_config.readout_pause_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000006B") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_registers_wr_o.reg_26_config.readout_pause_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000700") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					rmap_registers_wr_o.reg_0_hk.tou_sense_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000701") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					rmap_registers_wr_o.reg_0_hk.tou_sense_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000702") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					rmap_registers_wr_o.reg_0_hk.tou_sense_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000703") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					rmap_registers_wr_o.reg_0_hk.tou_sense_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000704") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					rmap_registers_wr_o.reg_1_hk.tou_sense_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000705") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					rmap_registers_wr_o.reg_1_hk.tou_sense_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000706") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					rmap_registers_wr_o.reg_1_hk.tou_sense_4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000707") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					rmap_registers_wr_o.reg_1_hk.tou_sense_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000708") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					rmap_registers_wr_o.reg_2_hk.tou_sense_5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000709") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					rmap_registers_wr_o.reg_2_hk.tou_sense_5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000070A") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					rmap_registers_wr_o.reg_2_hk.tou_sense_6(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000070B") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					rmap_registers_wr_o.reg_2_hk.tou_sense_6(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000070C") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					rmap_registers_wr_o.reg_3_hk.ccd1_ts(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000070D") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					rmap_registers_wr_o.reg_3_hk.ccd1_ts(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000070E") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					rmap_registers_wr_o.reg_3_hk.ccd2_ts(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000070F") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					rmap_registers_wr_o.reg_3_hk.ccd2_ts(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000710") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					rmap_registers_wr_o.reg_4_hk.ccd3_ts(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000711") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					rmap_registers_wr_o.reg_4_hk.ccd3_ts(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000712") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					rmap_registers_wr_o.reg_4_hk.ccd4_ts(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000713") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					rmap_registers_wr_o.reg_4_hk.ccd4_ts(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000714") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					rmap_registers_wr_o.reg_5_hk.prt1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000715") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					rmap_registers_wr_o.reg_5_hk.prt1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000716") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					rmap_registers_wr_o.reg_5_hk.prt2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000717") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					rmap_registers_wr_o.reg_5_hk.prt2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000718") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					rmap_registers_wr_o.reg_6_hk.prt3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000719") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					rmap_registers_wr_o.reg_6_hk.prt3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000071A") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					rmap_registers_wr_o.reg_6_hk.prt4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000071B") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					rmap_registers_wr_o.reg_6_hk.prt4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000071C") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					rmap_registers_wr_o.reg_7_hk.prt5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000071D") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					rmap_registers_wr_o.reg_7_hk.prt5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000071E") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					rmap_registers_wr_o.reg_7_hk.zero_diff_amp(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000071F") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					rmap_registers_wr_o.reg_7_hk.zero_diff_amp(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000720") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					rmap_registers_wr_o.reg_8_hk.ccd1_vod_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000721") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					rmap_registers_wr_o.reg_8_hk.ccd1_vod_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000722") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					rmap_registers_wr_o.reg_8_hk.ccd1_vog_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000723") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					rmap_registers_wr_o.reg_8_hk.ccd1_vog_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000724") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_9_hk.ccd1_vrd_mon_e(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000725") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_9_hk.ccd1_vrd_mon_e(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000726") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					rmap_registers_wr_o.reg_9_hk.ccd2_vod_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000727") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					rmap_registers_wr_o.reg_9_hk.ccd2_vod_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000728") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					rmap_registers_wr_o.reg_10_hk.ccd2_vog_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000729") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					rmap_registers_wr_o.reg_10_hk.ccd2_vog_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000072A") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_10_hk.ccd2_vrd_mon_e(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000072B") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_10_hk.ccd2_vrd_mon_e(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000072C") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					rmap_registers_wr_o.reg_11_hk.ccd3_vod_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000072D") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					rmap_registers_wr_o.reg_11_hk.ccd3_vod_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000072E") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					rmap_registers_wr_o.reg_11_hk.ccd3_vog_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000072F") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					rmap_registers_wr_o.reg_11_hk.ccd3_vog_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000730") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_12_hk.ccd3_vrd_mon_e(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000731") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_12_hk.ccd3_vrd_mon_e(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000732") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					rmap_registers_wr_o.reg_12_hk.ccd4_vod_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000733") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					rmap_registers_wr_o.reg_12_hk.ccd4_vod_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000734") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					rmap_registers_wr_o.reg_13_hk.ccd4_vog_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000735") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					rmap_registers_wr_o.reg_13_hk.ccd4_vog_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000736") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_13_hk.ccd4_vrd_mon_e(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000737") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					rmap_registers_wr_o.reg_13_hk.ccd4_vrd_mon_e(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000738") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					rmap_registers_wr_o.reg_14_hk.vccd(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000739") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					rmap_registers_wr_o.reg_14_hk.vccd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000073A") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					rmap_registers_wr_o.reg_14_hk.vrclk_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000073B") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					rmap_registers_wr_o.reg_14_hk.vrclk_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000073C") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					rmap_registers_wr_o.reg_15_hk.viclk(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000073D") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					rmap_registers_wr_o.reg_15_hk.viclk(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000073E") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					rmap_registers_wr_o.reg_15_hk.vrclk_low(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000073F") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					rmap_registers_wr_o.reg_15_hk.vrclk_low(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000740") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					rmap_registers_wr_o.reg_16_hk.d5vb_pos_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000741") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					rmap_registers_wr_o.reg_16_hk.d5vb_pos_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000742") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					rmap_registers_wr_o.reg_16_hk.d5vb_neg_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000743") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					rmap_registers_wr_o.reg_16_hk.d5vb_neg_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000744") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					rmap_registers_wr_o.reg_17_hk.d3v3b_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000745") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					rmap_registers_wr_o.reg_17_hk.d3v3b_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000746") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					rmap_registers_wr_o.reg_17_hk.d2v5a_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000747") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					rmap_registers_wr_o.reg_17_hk.d2v5a_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000748") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					rmap_registers_wr_o.reg_18_hk.d3v3d_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000749") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					rmap_registers_wr_o.reg_18_hk.d3v3d_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000074A") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					rmap_registers_wr_o.reg_18_hk.d2v5d_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000074B") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					rmap_registers_wr_o.reg_18_hk.d2v5d_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000074C") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					rmap_registers_wr_o.reg_19_hk.d1v5d_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000074D") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					rmap_registers_wr_o.reg_19_hk.d1v5d_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000074E") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					rmap_registers_wr_o.reg_19_hk.d5vref_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000074F") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					rmap_registers_wr_o.reg_19_hk.d5vref_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000750") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					rmap_registers_wr_o.reg_20_hk.vccd_pos_raw(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000751") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					rmap_registers_wr_o.reg_20_hk.vccd_pos_raw(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000752") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					rmap_registers_wr_o.reg_20_hk.vclk_pos_raw(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000753") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					rmap_registers_wr_o.reg_20_hk.vclk_pos_raw(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000754") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					rmap_registers_wr_o.reg_21_hk.van1_pos_raw(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000755") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					rmap_registers_wr_o.reg_21_hk.van1_pos_raw(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000756") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					rmap_registers_wr_o.reg_21_hk.van3_neg_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000757") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					rmap_registers_wr_o.reg_21_hk.van3_neg_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000758") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					rmap_registers_wr_o.reg_22_hk.van2_pos_raw(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000759") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					rmap_registers_wr_o.reg_22_hk.van2_pos_raw(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000075A") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					rmap_registers_wr_o.reg_22_hk.vdig_raw(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000075B") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					rmap_registers_wr_o.reg_22_hk.vdig_raw(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000075C") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					rmap_registers_wr_o.reg_23_hk.vdig_raw_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000075D") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					rmap_registers_wr_o.reg_23_hk.vdig_raw_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000075E") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					rmap_registers_wr_o.reg_23_hk.viclk_low(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000075F") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					rmap_registers_wr_o.reg_23_hk.viclk_low(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000760") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_24_hk.ccd1_vrd_mon_f(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000761") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_24_hk.ccd1_vrd_mon_f(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000762") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_24_hk.ccd1_vdd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000763") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_24_hk.ccd1_vdd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000764") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_25_hk.ccd1_vgd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000765") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_25_hk.ccd1_vgd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000766") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_25_hk.ccd2_vrd_mon_f(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000767") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_25_hk.ccd2_vrd_mon_f(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000768") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_26_hk.ccd2_vdd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000769") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_26_hk.ccd2_vdd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000076A") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_26_hk.ccd2_vgd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000076B") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_26_hk.ccd2_vgd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000076C") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_27_hk.ccd3_vrd_mon_f(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000076D") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_27_hk.ccd3_vrd_mon_f(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000076E") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_27_hk.ccd3_vdd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000076F") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_27_hk.ccd3_vdd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000770") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_28_hk.ccd3_vgd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000771") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_28_hk.ccd3_vgd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000772") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_28_hk.ccd4_vrd_mon_f(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000773") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					rmap_registers_wr_o.reg_28_hk.ccd4_vrd_mon_f(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000774") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_29_hk.ccd4_vdd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000775") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					rmap_registers_wr_o.reg_29_hk.ccd4_vdd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000776") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_29_hk.ccd4_vgd_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000777") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					rmap_registers_wr_o.reg_29_hk.ccd4_vgd_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000778") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					rmap_registers_wr_o.reg_30_hk.ig_hi_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000779") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					rmap_registers_wr_o.reg_30_hk.ig_hi_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000077A") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					rmap_registers_wr_o.reg_30_hk.ig_lo_mon(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000077B") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					rmap_registers_wr_o.reg_30_hk.ig_lo_mon(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000077C") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					rmap_registers_wr_o.reg_31_hk.tsense_a(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000077D") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					rmap_registers_wr_o.reg_31_hk.tsense_a(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000077E") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					rmap_registers_wr_o.reg_31_hk.tsense_b(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000077F") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					rmap_registers_wr_o.reg_31_hk.tsense_b(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000780") =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					rmap_registers_wr_o.reg_32_hk.reg_32_hk_reserved             <= fee_rmap_i.writedata;
					-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
					rmap_registers_wr_o.reg_32_hk.spw_status_spw_status_reserved <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000786") =>
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					rmap_registers_wr_o.reg_33_hk.reg_33_hk_reserved(9 downto 2) <= fee_rmap_i.writedata;
					-- RMAP Area HK Register 33 : Operational Mode HK Field
					rmap_registers_wr_o.reg_33_hk.op_mode                        <= fee_rmap_i.writedata(5 downto 2);
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					rmap_registers_wr_o.reg_33_hk.reg_33_hk_reserved(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000788") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(26 downto 19) <= fee_rmap_i.writedata;

				when (x"00000789") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(18 downto 11) <= fee_rmap_i.writedata;

				when (x"0000078A") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(10 downto 3) <= fee_rmap_i.writedata;
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(2 downto 0)  <= fee_rmap_i.writedata(7 downto 5);

				when (x"0000078C") =>
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					rmap_registers_wr_o.reg_35_hk.reg_35_hk_reserved(10 downto 3) <= fee_rmap_i.writedata;

				when (x"0000078D") =>
					-- RMAP Area HK Register 35 : Board ID Field
					rmap_registers_wr_o.reg_35_hk.board_id(8 downto 4)           <= fee_rmap_i.writedata(4 downto 0);
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					rmap_registers_wr_o.reg_35_hk.reg_35_hk_reserved(2 downto 0) <= fee_rmap_i.writedata(7 downto 5);

				when (x"0000078E") =>
					-- RMAP Area HK Register 35 : FPGA Major Version Field
					rmap_registers_wr_o.reg_35_hk.fpga_major_version   <= fee_rmap_i.writedata(3 downto 0);
					-- RMAP Area HK Register 35 : Board ID Field
					rmap_registers_wr_o.reg_35_hk.board_id(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000078F") =>
					-- RMAP Area HK Register 35 : FPGA Minor Version Field
					rmap_registers_wr_o.reg_35_hk.fpga_minor_version <= fee_rmap_i.writedata;

				when others =>
					null;

			end case;

		end procedure p_nfee_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_nrme_avalon_mm_rmap_nfee_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- RMAP Area Config Register 0 : V Start Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_0_config.v_start(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_0_config.v_start(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 0 : V End Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_0_config.v_end(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_0_config.v_end(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#01#) =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_1_config.charge_injection_width(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_1_config.charge_injection_width(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_1_config.charge_injection_gap(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_1_config.charge_injection_gap(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#02#) =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_2_config.parallel_toi_period(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_2_config.parallel_toi_period(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#03#) =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_2_config.ccd_readout_order_1st_ccd <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_2_config.ccd_readout_order_2nd_ccd <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_2_config.ccd_readout_order_3rd_ccd <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_2_config.ccd_readout_order_4th_ccd <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#04#) =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.n_final_dump(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_3_config.n_final_dump(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 3 : H End Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_3_config.h_end(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_3_config.h_end(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#05#) =>
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.charge_injection_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06#) =>
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.tri_level_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07#) =>
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.img_clk_dir <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08#) =>
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.reg_clk_dir <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09#) =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_4_config.packet_size(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_4_config.packet_size(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_4_config.int_sync_period(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_4_config.int_sync_period(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#0A#) =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(19 downto 16) <= avalon_mm_rmap_i.writedata(19 downto 16);
					end if;

				when (16#0B#) =>
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.sync_sel <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C#) =>
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.sensor_sel <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;

				when (16#0D#) =>
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.digitise_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E#) =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.dg_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- RMAP Area Config Register 5 : CCD Readout Enable Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.ccd_read_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#10#) =>
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.reg_5_config_reserved <= avalon_mm_rmap_i.writedata(5 downto 0);
					end if;

				when (16#11#) =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#12#) =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#13#) =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_8_config.ccd1_win_size_x <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_8_config.ccd1_win_size_y <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#14#) =>
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_8_config.reg_8_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#15#) =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#16#) =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#17#) =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_11_config.ccd2_win_size_x <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_11_config.ccd2_win_size_y <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#18#) =>
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_11_config.reg_11_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#19#) =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1A#) =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1B#) =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_14_config.ccd3_win_size_x <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_14_config.ccd3_win_size_y <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#1C#) =>
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_14_config.reg_14_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#1D#) =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1E#) =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1F#) =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_17_config.ccd4_win_size_x <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_17_config.ccd4_win_size_y <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#20#) =>
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_17_config.reg_17_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_18_config.ccd_vod_config(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_18_config.ccd_vod_config(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#21#) =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_18_config.ccd2_vrd_config0 <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd2_vrd_config1 <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#22#) =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#23#) =>
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_19_config.ccd_vgd_config0 <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_20_config.ccd_vgd_config1 <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_20_config.ccd_vog_config(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_20_config.ccd_vog_config(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#24#) =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#25#) =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_21_config.ccd_mode_config <= avalon_mm_rmap_i.writedata(19 downto 16);
					end if;
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_1 <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#26#) =>
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_21_config.clear_error_flag <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27#) =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#28#) =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#29#) =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_23_config.reg_23_config_reserved <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;

				when (16#2A#) =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#2B#) =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_24_config.reg_24_config_reserved <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;

				when (16#2C#) =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#2D#) =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_25_config.surface_inversion_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_25_config.surface_inversion_counter(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_25_config.reg_25_config_reserved <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;

				when (16#2E#) =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_26_config.readout_pause_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_26_config.readout_pause_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F#) =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_0_hk.tou_sense_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_0_hk.tou_sense_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_0_hk.tou_sense_2(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_0_hk.tou_sense_2(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#30#) =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_1_hk.tou_sense_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_1_hk.tou_sense_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_1_hk.tou_sense_4(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_1_hk.tou_sense_4(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#31#) =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_2_hk.tou_sense_5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_2_hk.tou_sense_5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_2_hk.tou_sense_6(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_2_hk.tou_sense_6(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#32#) =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_hk.ccd1_ts(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_3_hk.ccd1_ts(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_3_hk.ccd2_ts(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_3_hk.ccd2_ts(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#33#) =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_4_hk.ccd3_ts(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_4_hk.ccd3_ts(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_4_hk.ccd4_ts(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_4_hk.ccd4_ts(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#34#) =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_hk.prt1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_5_hk.prt1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_5_hk.prt2(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_5_hk.prt2(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#35#) =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_6_hk.prt3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_6_hk.prt3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_6_hk.prt4(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_6_hk.prt4(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#36#) =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_7_hk.prt5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_7_hk.prt5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_7_hk.zero_diff_amp(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_7_hk.zero_diff_amp(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#37#) =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_8_hk.ccd1_vod_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_8_hk.ccd1_vod_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_8_hk.ccd1_vog_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_8_hk.ccd1_vog_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#38#) =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_9_hk.ccd1_vrd_mon_e(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_9_hk.ccd1_vrd_mon_e(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_9_hk.ccd2_vod_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_9_hk.ccd2_vod_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#39#) =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_10_hk.ccd2_vog_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_10_hk.ccd2_vog_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_10_hk.ccd2_vrd_mon_e(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_10_hk.ccd2_vrd_mon_e(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3A#) =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_11_hk.ccd3_vod_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_11_hk.ccd3_vod_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_11_hk.ccd3_vog_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_11_hk.ccd3_vog_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3B#) =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_12_hk.ccd3_vrd_mon_e(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_12_hk.ccd3_vrd_mon_e(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_12_hk.ccd4_vod_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_12_hk.ccd4_vod_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3C#) =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_13_hk.ccd4_vog_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_13_hk.ccd4_vog_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_13_hk.ccd4_vrd_mon_e(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_13_hk.ccd4_vrd_mon_e(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3D#) =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_14_hk.vccd(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_14_hk.vccd(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_14_hk.vrclk_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_14_hk.vrclk_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E#) =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_15_hk.viclk(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_15_hk.viclk(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_15_hk.vrclk_low(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_15_hk.vrclk_low(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F#) =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_16_hk.d5vb_pos_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_16_hk.d5vb_pos_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_16_hk.d5vb_neg_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_16_hk.d5vb_neg_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#40#) =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_17_hk.d3v3b_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_17_hk.d3v3b_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_17_hk.d2v5a_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_17_hk.d2v5a_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#41#) =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_18_hk.d3v3d_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_18_hk.d3v3d_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_18_hk.d2v5d_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_18_hk.d2v5d_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#42#) =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_19_hk.d1v5d_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_19_hk.d1v5d_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_19_hk.d5vref_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_19_hk.d5vref_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#43#) =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_20_hk.vccd_pos_raw(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_20_hk.vccd_pos_raw(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_20_hk.vclk_pos_raw(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_20_hk.vclk_pos_raw(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#44#) =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_21_hk.van1_pos_raw(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_21_hk.van1_pos_raw(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_21_hk.van3_neg_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_21_hk.van3_neg_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#45#) =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_22_hk.van2_pos_raw(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_22_hk.van2_pos_raw(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_22_hk.vdig_raw(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_22_hk.vdig_raw(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#46#) =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_23_hk.vdig_raw_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_23_hk.vdig_raw_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_23_hk.viclk_low(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_23_hk.viclk_low(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#47#) =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_24_hk.ccd1_vrd_mon_f(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_24_hk.ccd1_vrd_mon_f(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_24_hk.ccd1_vdd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_24_hk.ccd1_vdd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#48#) =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_25_hk.ccd1_vgd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_25_hk.ccd1_vgd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_25_hk.ccd2_vrd_mon_f(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_25_hk.ccd2_vrd_mon_f(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#49#) =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_26_hk.ccd2_vdd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_26_hk.ccd2_vdd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_26_hk.ccd2_vgd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_26_hk.ccd2_vgd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#4A#) =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_27_hk.ccd3_vrd_mon_f(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_27_hk.ccd3_vrd_mon_f(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_27_hk.ccd3_vdd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_27_hk.ccd3_vdd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#4B#) =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_28_hk.ccd3_vgd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_28_hk.ccd3_vgd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_28_hk.ccd4_vrd_mon_f(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_28_hk.ccd4_vrd_mon_f(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#4C#) =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_29_hk.ccd4_vdd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_29_hk.ccd4_vdd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_29_hk.ccd4_vgd_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_29_hk.ccd4_vgd_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#4D#) =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_30_hk.ig_hi_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_30_hk.ig_hi_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_30_hk.ig_lo_mon(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_30_hk.ig_lo_mon(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#4E#) =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_31_hk.tsense_a(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_31_hk.tsense_a(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- RMAP Area HK Register 31 : Tsense B HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_31_hk.tsense_b(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_31_hk.tsense_b(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;
					-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_32_hk.spw_status_spw_status_reserved <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;

				when (16#56#) =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_32_hk.reg_32_hk_reserved <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#57#) =>
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_33_hk.reg_33_hk_reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_33_hk.reg_33_hk_reserved(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- RMAP Area HK Register 33 : Operational Mode HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_33_hk.op_mode <= avalon_mm_rmap_i.writedata(19 downto 16);
					end if;

				when (16#5D#) =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_34_hk.error_flags_error_flags_reserved(26 downto 24) <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#5E#) =>
					-- RMAP Area HK Register 35 : FPGA Minor Version Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_35_hk.fpga_minor_version <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					-- RMAP Area HK Register 35 : FPGA Major Version Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_35_hk.fpga_major_version <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- RMAP Area HK Register 35 : Board ID Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.reg_35_hk.board_id(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.reg_35_hk.board_id(8) <= avalon_mm_rmap_i.writedata(24);
					end if;

				when (16#5F#) =>
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_35_hk.reg_35_hk_reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.reg_35_hk.reg_35_hk_reserved(10 downto 8) <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_avs_writedata;

		variable v_fee_write_address : std_logic_vector(31 downto 0)      := (others => '0');
		variable v_avs_write_address : t_nrme_avalon_mm_rmap_nfee_address := 0;
	begin
		if (rst_i = '1') then
			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			p_nfee_reg_reset;
			v_fee_write_address          := (others => '0');
			v_avs_write_address          := 0;
		elsif (rising_edge(clk_i)) then

			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			p_nfee_reg_trigger;
			s_data_acquired              <= '0';
			if (fee_rmap_i.write = '1') then
				v_fee_write_address    := fee_rmap_i.address;
				fee_rmap_o.waitrequest <= '0';
				s_data_acquired        <= '1';
				if (s_data_acquired = '0') then
					p_nfee_mem_wr(v_fee_write_address);
				end if;
			elsif (avalon_mm_rmap_i.write = '1') then
				v_avs_write_address          := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				s_data_acquired              <= '1';
				if (s_data_acquired = '0') then
					p_avs_writedata(v_avs_write_address);
				end if;
			end if;

		end if;
	end process p_nrme_rmap_mem_area_nfee_write;

end architecture RTL;
