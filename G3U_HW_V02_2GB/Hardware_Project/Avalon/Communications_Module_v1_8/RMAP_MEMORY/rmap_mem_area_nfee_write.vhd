library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_write is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		fee_frame_number_i      : in  std_logic_vector(1 downto 0);
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
		rmap_registers_wr_o     : out t_rmap_memory_wr_area
	);
end entity rmap_mem_area_nfee_write;

architecture RTL of rmap_mem_area_nfee_write is

begin

	p_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
		procedure p_nfee_reg_reset is
		begin

			-- Write Registers Reset/Default State

			-- RMAP Area Config Register 0 : V Start Config Field
			rmap_registers_wr_o.reg_0_config.v_start                       <= std_logic_vector(to_unsigned(0, 16));
			-- RMAP Area Config Register 0 : V End Config Field
			rmap_registers_wr_o.reg_0_config.v_end                         <= std_logic_vector(to_unsigned(4540, 16));
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
					rmap_registers_wr_o.reg_0_config.v_end(15 downto 8) <= rmap_writedata_i;

				when (x"00000001") =>
					-- RMAP Area Config Register 0 : V End Config Field
					rmap_registers_wr_o.reg_0_config.v_end(7 downto 0) <= rmap_writedata_i;

				when (x"00000002") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_registers_wr_o.reg_0_config.v_start(15 downto 8) <= rmap_writedata_i;

				when (x"00000003") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_registers_wr_o.reg_0_config.v_start(7 downto 0) <= rmap_writedata_i;

				when (x"00000004") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_gap(15 downto 8) <= rmap_writedata_i;

				when (x"00000005") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_gap(7 downto 0) <= rmap_writedata_i;

				when (x"00000006") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_width(15 downto 8) <= rmap_writedata_i;

				when (x"00000007") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_registers_wr_o.reg_1_config.charge_injection_width(7 downto 0) <= rmap_writedata_i;

				when (x"00000008") =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_1st_ccd <= rmap_writedata_i(1 downto 0);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_2nd_ccd <= rmap_writedata_i(3 downto 2);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_3rd_ccd <= rmap_writedata_i(5 downto 4);
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					rmap_registers_wr_o.reg_2_config.ccd_readout_order_4th_ccd <= rmap_writedata_i(7 downto 6);

				when (x"00000009") =>
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(11 downto 4) <= rmap_writedata_i;

				when (x"0000000A") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_registers_wr_o.reg_2_config.parallel_toi_period(11 downto 8) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_registers_wr_o.reg_2_config.parallel_clk_overlap(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"0000000B") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_registers_wr_o.reg_2_config.parallel_toi_period(7 downto 0) <= rmap_writedata_i;

				when (x"0000000C") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_registers_wr_o.reg_3_config.h_end(11 downto 8)  <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					rmap_registers_wr_o.reg_3_config.charge_injection_en <= rmap_writedata_i(4);
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					rmap_registers_wr_o.reg_3_config.tri_level_clk_en    <= rmap_writedata_i(5);
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					rmap_registers_wr_o.reg_3_config.img_clk_dir         <= rmap_writedata_i(6);
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					rmap_registers_wr_o.reg_3_config.reg_clk_dir         <= rmap_writedata_i(7);

				when (x"0000000D") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_registers_wr_o.reg_3_config.h_end(7 downto 0) <= rmap_writedata_i;

				when (x"0000000E") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_registers_wr_o.reg_3_config.n_final_dump(15 downto 8) <= rmap_writedata_i;

				when (x"0000000F") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_registers_wr_o.reg_3_config.n_final_dump(7 downto 0) <= rmap_writedata_i;

				when (x"00000010") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_registers_wr_o.reg_4_config.int_sync_period(15 downto 8) <= rmap_writedata_i;

				when (x"00000011") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_registers_wr_o.reg_4_config.int_sync_period(7 downto 0) <= rmap_writedata_i;

				when (x"00000012") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_registers_wr_o.reg_4_config.packet_size(15 downto 8) <= rmap_writedata_i;

				when (x"00000013") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_registers_wr_o.reg_4_config.packet_size(7 downto 0) <= rmap_writedata_i;

				when (x"00000014") =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					rmap_registers_wr_o.reg_5_config.dg_en                 <= rmap_writedata_i(0);
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					rmap_registers_wr_o.reg_5_config.reg_5_config_reserved <= rmap_writedata_i(7 downto 1);

				when (x"00000015") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(19 downto 16) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					rmap_registers_wr_o.reg_5_config.sync_sel                                 <= rmap_writedata_i(4);
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					rmap_registers_wr_o.reg_5_config.sensor_sel                               <= rmap_writedata_i(6 downto 5);
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					rmap_registers_wr_o.reg_5_config.digitise_en                              <= rmap_writedata_i(7);

				when (x"00000016") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(15 downto 8) <= rmap_writedata_i;

				when (x"00000017") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_registers_wr_o.reg_5_config.trap_pumping_dwell_counter(7 downto 0) <= rmap_writedata_i;

				when (x"00000018") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000019") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"0000001A") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"0000001B") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_registers_wr_o.reg_6_config.ccd1_win_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"0000001C") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"0000001D") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"0000001E") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"0000001F") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000020") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_y(5 downto 2) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					rmap_registers_wr_o.reg_8_config.reg_8_config_reserved       <= rmap_writedata_i(7 downto 4);

				when (x"00000021") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_x             <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_size_y(1 downto 0) <= rmap_writedata_i(7 downto 6);

				when (x"00000022") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(15 downto 8) <= rmap_writedata_i;

				when (x"00000023") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_registers_wr_o.reg_8_config.ccd1_win_list_length(7 downto 0) <= rmap_writedata_i;

				when (x"00000024") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000025") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"00000026") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"00000027") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_registers_wr_o.reg_9_config.ccd2_win_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000028") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000029") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"0000002A") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"0000002B") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"0000002C") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_y(5 downto 2) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					rmap_registers_wr_o.reg_11_config.reg_11_config_reserved      <= rmap_writedata_i(7 downto 4);

				when (x"0000002D") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_x             <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_size_y(1 downto 0) <= rmap_writedata_i(7 downto 6);

				when (x"0000002E") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(15 downto 8) <= rmap_writedata_i;

				when (x"0000002F") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_registers_wr_o.reg_11_config.ccd2_win_list_length(7 downto 0) <= rmap_writedata_i;

				when (x"00000030") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000031") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"00000032") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"00000033") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_registers_wr_o.reg_12_config.ccd3_win_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000034") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000035") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"00000036") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"00000037") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000038") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_y(5 downto 2) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					rmap_registers_wr_o.reg_14_config.reg_14_config_reserved      <= rmap_writedata_i(7 downto 4);

				when (x"00000039") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_x             <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_size_y(1 downto 0) <= rmap_writedata_i(7 downto 6);

				when (x"0000003A") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(15 downto 8) <= rmap_writedata_i;

				when (x"0000003B") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_registers_wr_o.reg_14_config.ccd3_win_list_length(7 downto 0) <= rmap_writedata_i;

				when (x"0000003C") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"0000003D") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"0000003E") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"0000003F") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_registers_wr_o.reg_15_config.ccd4_win_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000040") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24) <= rmap_writedata_i;

				when (x"00000041") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16) <= rmap_writedata_i;

				when (x"00000042") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8) <= rmap_writedata_i;

				when (x"00000043") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_registers_wr_o.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0) <= rmap_writedata_i;

				when (x"00000044") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_y(5 downto 2) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					rmap_registers_wr_o.reg_17_config.reg_17_config_reserved      <= rmap_writedata_i(7 downto 4);

				when (x"00000045") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_x             <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_size_y(1 downto 0) <= rmap_writedata_i(7 downto 6);

				when (x"00000046") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(15 downto 8) <= rmap_writedata_i;

				when (x"00000047") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_registers_wr_o.reg_17_config.ccd4_win_list_length(7 downto 0) <= rmap_writedata_i;

				when (x"00000048") =>
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd2_vrd_config0 <= rmap_writedata_i;

				when (x"00000049") =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(11 downto 4) <= rmap_writedata_i;

				when (x"0000004A") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd_vod_config(11 downto 8) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd1_vrd_config(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"0000004B") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_registers_wr_o.reg_18_config.ccd_vod_config(7 downto 0) <= rmap_writedata_i;

				when (x"0000004C") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(11 downto 8) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd_vgd_config0              <= rmap_writedata_i(7 downto 4);

				when (x"0000004D") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd4_vrd_config(7 downto 0) <= rmap_writedata_i;

				when (x"0000004E") =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(11 downto 4) <= rmap_writedata_i;

				when (x"0000004F") =>
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd2_vrd_config1            <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_registers_wr_o.reg_19_config.ccd3_vrd_config(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"00000050") =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(11 downto 4) <= rmap_writedata_i;

				when (x"00000051") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vog_config(11 downto 8)  <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_ig_hi_config(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"00000052") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vog_config(7 downto 0) <= rmap_writedata_i;

				when (x"00000053") =>
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					rmap_registers_wr_o.reg_20_config.ccd_vgd_config1 <= rmap_writedata_i;

				when (x"00000054") =>
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_mode_config          <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_1 <= rmap_writedata_i(6 downto 4);
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					rmap_registers_wr_o.reg_21_config.clear_error_flag         <= rmap_writedata_i(7);

				when (x"00000055") =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(11 downto 4) <= rmap_writedata_i;

				when (x"00000056") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(11 downto 8)        <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_registers_wr_o.reg_21_config.reg_21_config_reserved_0(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"00000057") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_registers_wr_o.reg_21_config.ccd_ig_lo_config(7 downto 0) <= rmap_writedata_i;

				when (x"00000058") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(31 downto 24) <= rmap_writedata_i;

				when (x"00000059") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(23 downto 16) <= rmap_writedata_i;

				when (x"0000005A") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(15 downto 8) <= rmap_writedata_i;

				when (x"0000005B") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_registers_wr_o.reg_22_config.reg_22_config_reserved(7 downto 0) <= rmap_writedata_i;

				when (x"0000005C") =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(9 downto 4) <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					rmap_registers_wr_o.reg_23_config.reg_23_config_reserved         <= rmap_writedata_i(7 downto 6);

				when (x"0000005D") =>
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(9 downto 6) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd2_last_e_packet(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"0000005E") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(9 downto 8) <= rmap_writedata_i(1 downto 0);
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_f_packet(5 downto 0) <= rmap_writedata_i(7 downto 2);

				when (x"0000005F") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_registers_wr_o.reg_23_config.ccd1_last_e_packet(7 downto 0) <= rmap_writedata_i;

				when (x"00000060") =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(9 downto 4) <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					rmap_registers_wr_o.reg_24_config.reg_24_config_reserved         <= rmap_writedata_i(7 downto 6);

				when (x"00000061") =>
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(9 downto 6) <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_f_packet(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"00000062") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(9 downto 8) <= rmap_writedata_i(1 downto 0);
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_registers_wr_o.reg_24_config.ccd3_last_e_packet(5 downto 0) <= rmap_writedata_i(7 downto 2);

				when (x"00000063") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_registers_wr_o.reg_24_config.ccd2_last_f_packet(7 downto 0) <= rmap_writedata_i;

				when (x"00000064") =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_registers_wr_o.reg_25_config.surface_inversion_counter(9 downto 4) <= rmap_writedata_i(5 downto 0);
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					rmap_registers_wr_o.reg_25_config.reg_25_config_reserved                <= rmap_writedata_i(7 downto 6);

				when (x"00000065") =>
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(9 downto 6)        <= rmap_writedata_i(3 downto 0);
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_registers_wr_o.reg_25_config.surface_inversion_counter(3 downto 0) <= rmap_writedata_i(7 downto 4);

				when (x"00000066") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(9 downto 8) <= rmap_writedata_i(1 downto 0);
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_f_packet(5 downto 0) <= rmap_writedata_i(7 downto 2);

				when (x"00000067") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_registers_wr_o.reg_25_config.ccd4_last_e_packet(7 downto 0) <= rmap_writedata_i;

				when (x"00000068") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(15 downto 8) <= rmap_writedata_i;

				when (x"00000069") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_registers_wr_o.reg_26_config.trap_pumping_shuffle_counter(7 downto 0) <= rmap_writedata_i;

				when (x"0000006A") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_registers_wr_o.reg_26_config.readout_pause_counter(15 downto 8) <= rmap_writedata_i;

				when (x"0000006B") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_registers_wr_o.reg_26_config.readout_pause_counter(7 downto 0) <= rmap_writedata_i;

				when others =>
					null;

			end case;

		end procedure p_nfee_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#80#) =>
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

				when (16#81#) =>
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

				when (16#82#) =>
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

				when (16#83#) =>
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

				when (16#84#) =>
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

				when (16#85#) =>
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.charge_injection_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#86#) =>
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.tri_level_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#87#) =>
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.img_clk_dir <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#88#) =>
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_3_config.reg_clk_dir <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#89#) =>
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

				when (16#8A#) =>
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

				when (16#8B#) =>
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.sync_sel <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#8C#) =>
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.sensor_sel <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;

				when (16#8D#) =>
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.digitise_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#8E#) =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.dg_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#8F#) =>
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_5_config.reg_5_config_reserved <= avalon_mm_rmap_i.writedata(6 downto 0);
					end if;

				when (16#90#) =>
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

				when (16#91#) =>
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

				when (16#92#) =>
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

				when (16#93#) =>
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_8_config.reg_8_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#94#) =>
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

				when (16#95#) =>
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

				when (16#96#) =>
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

				when (16#97#) =>
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_11_config.reg_11_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#98#) =>
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

				when (16#99#) =>
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

				when (16#9A#) =>
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

				when (16#9B#) =>
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_14_config.reg_14_config_reserved <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#9C#) =>
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

				when (16#9D#) =>
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

				when (16#9E#) =>
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

				when (16#9F#) =>
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

				when (16#A0#) =>
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

				when (16#A1#) =>
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

				when (16#A2#) =>
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

				when (16#A3#) =>
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

				when (16#A4#) =>
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

				when (16#A5#) =>
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_21_config.clear_error_flag <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#A6#) =>
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

				when (16#A7#) =>
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

				when (16#A8#) =>
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

				when (16#A9#) =>
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

				when (16#AA#) =>
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

				when (16#AB#) =>
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

				when (16#AC#) =>
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

				when (16#AD#) =>
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

				when (16#AE#) =>
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

				when (16#AF#) =>
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

				when (16#B0#) =>
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

				when (16#B1#) =>
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

				when (16#B2#) =>
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

				when (16#B3#) =>
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

				when (16#B4#) =>
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

				when (16#B5#) =>
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

				when (16#B6#) =>
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

				when (16#B7#) =>
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

				when (16#B8#) =>
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

				when (16#B9#) =>
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

				when (16#BA#) =>
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

				when (16#BB#) =>
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

				when (16#BC#) =>
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

				when (16#BD#) =>
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

				when (16#BE#) =>
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

				when (16#BF#) =>
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

				when (16#C0#) =>
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

				when (16#C1#) =>
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

				when (16#C2#) =>
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

				when (16#C3#) =>
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

				when (16#C4#) =>
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

				when (16#C5#) =>
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

				when (16#C6#) =>
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

				when (16#C7#) =>
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

				when (16#C8#) =>
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

				when (16#C9#) =>
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

				when (16#CA#) =>
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

				when (16#CB#) =>
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

				when (16#CC#) =>
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

				when (16#CD#) =>
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

				when (16#D5#) =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.reg_32_hk.reg_32_hk_reserved <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#D6#) =>
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

				when (16#DC#) =>
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

				when (16#DD#) =>
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

				when (16#DE#) =>
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

		variable v_write_address     : t_avalon_mm_spacewire_address := 0;
		variable v_write_timeout_cnt : natural range 0 to 15         := 15;
		variable v_write_executed    : std_logic                     := '0';
	begin
		if (rst_i = '1') then
			rmap_memerror_o              <= '0';
			rmap_memready_o              <= '0';
			p_nfee_reg_reset;
			-- p_avalon_mm_rmap_write
			avalon_mm_rmap_o.waitrequest <= '1';
			v_write_address              := 0;
			v_write_timeout_cnt          := 15;
			v_write_executed             := '0';
		elsif rising_edge(clk_i) then

			--			-- fee frame number value assignment
			--			rmap_registers_wr_o.frame_number.frame_number <= fee_frame_number_i;

			-- standard signals value
			rmap_memerror_o <= '0';
			rmap_memready_o <= '1';
			-- check if a write request was issued
			if (rmap_write_i = '1') then
				rmap_memready_o <= '1';
				p_nfee_mem_wr(rmap_writeaddr_i);
			end if;

			-- p_avalon_mm_rmap_write

			avalon_mm_rmap_o.waitrequest <= '1';
			if (v_write_executed = '0') then
				if (avalon_mm_rmap_i.write = '1') then
					v_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
					-- check if the write address is in the rmap area range
					--					if ((v_write_address >= 16#A0#) and (v_write_address <= 16#BF#)) then
					--						-- read address is in the rmap housekeeping area range
					--						-- no need to protect hk registers, write register
					--						avalon_mm_rmap_o.waitrequest <= '0';
					--						p_avs_hk_writedata(v_write_address);
					--						v_write_timeout_cnt          := 15;
					--						v_write_executed             := '1';
					--					elsif ((v_write_address >= 16#40#) and (v_write_address <= 16#51#)) then
					if ((v_write_address >= c_AVALON_MM_RMAP_MIN_ADDR) and (v_write_address <= c_AVALON_MM_RMAP_MAX_ADDR)) then
						-- write address is in the rmap area range 
						-- check if a rmap write or a rmap read is ocurring
						if ((rmap_write_authorized_i = '0') or (rmap_read_authorized_i = '0')) then
							-- rmap write or a rmap read not ocurring, write register
							avalon_mm_rmap_o.waitrequest <= '0';
							p_avs_writedata(v_write_address);
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
								p_avs_writedata(v_write_address);
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
	end process p_rmap_mem_area_nfee_write;

end architecture RTL;
