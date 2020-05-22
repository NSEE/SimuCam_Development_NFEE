library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package nrme_rmap_mem_area_nfee_pkg is

	constant c_NRME_NFEE_RMAP_ADRESS_SIZE : natural := 32;
	constant c_NRME_NFEE_RMAP_DATA_SIZE   : natural := 8;
	constant c_NRME_NFEE_RMAP_SYMBOL_SIZE : natural := 8;

	type t_nrme_nfee_rmap_read_in is record
		address : std_logic_vector((c_NRME_NFEE_RMAP_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_nrme_nfee_rmap_read_in;

	type t_nrme_nfee_rmap_read_out is record
		readdata    : std_logic_vector((c_NRME_NFEE_RMAP_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_nrme_nfee_rmap_read_out;

	type t_nrme_nfee_rmap_write_in is record
		address   : std_logic_vector((c_NRME_NFEE_RMAP_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_NRME_NFEE_RMAP_DATA_SIZE - 1) downto 0);
	end record t_nrme_nfee_rmap_write_in;

	type t_nrme_nfee_rmap_write_out is record
		waitrequest : std_logic;
	end record t_nrme_nfee_rmap_write_out;

	constant c_NRME_NFEE_RMAP_READ_IN_RST : t_nrme_nfee_rmap_read_in := (
		address => (others => '0'),
		read    => '0'
	);

	constant c_NRME_NFEE_RMAP_READ_OUT_RST : t_nrme_nfee_rmap_read_out := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_NRME_NFEE_RMAP_WRITE_IN_RST : t_nrme_nfee_rmap_write_in := (
		address   => (others => '0'),
		write     => '0',
		writedata => (others => '0')
	);

	constant c_NRME_NFEE_RMAP_WRITE_OUT_RST : t_nrme_nfee_rmap_write_out := (
		waitrequest => '1'
	);

	constant c_NRME_NFEE_RMAP_WIN_OFFSET_BIT : natural := 23;

	-- Address Constants

	-- Allowed Addresses
	constant c_NRME_AVALON_MM_NFEE_RMAP_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_NRME_AVALON_MM_NFEE_RMAP_MAX_ADDR : natural range 0 to 255 := 16#5F#;

	-- Registers Types

	-- RMAP Area HK Register 32
	type t_reg_32_hk_rd_reg is record
		spw_status_timecode_from_spw      : std_logic_vector(7 downto 0); -- SpW Status : Timecode From SpaceWire HK Field
		spw_status_rmap_target_status     : std_logic_vector(7 downto 0); -- SpW Status : RMAP Target Status HK Field
		spw_status_rmap_target_indicate   : std_logic; -- SpW Status : RMAP Target Indicate HK Field
		spw_status_stat_link_escape_error : std_logic; -- SpW Status : Status Link Escape Error HK Field
		spw_status_stat_link_credit_error : std_logic; -- SpW Status : Status Link Credit Error HK Field
		spw_status_stat_link_parity_error : std_logic; -- SpW Status : Status Link Parity Error HK Field
		spw_status_stat_link_disconnect   : std_logic; -- SpW Status : Status Link Disconnect HK Field
		spw_status_stat_link_running      : std_logic; -- SpW Status : Status Link Running HK Field
	end record t_reg_32_hk_rd_reg;

	-- RMAP Area HK Register 33
	type t_reg_33_hk_rd_reg is record
		frame_counter : std_logic_vector(15 downto 0); -- Frame Counter HK Field
		frame_number  : std_logic_vector(1 downto 0); -- Frame Number HK Field
	end record t_reg_33_hk_rd_reg;

	-- RMAP Area HK Register 34
	type t_reg_34_hk_rd_reg is record
		error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate : std_logic; -- Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
		error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate : std_logic; -- Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
		error_flags_e_side_pixel_external_sram_buffer_is_full                         : std_logic; -- Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
		error_flags_f_side_pixel_external_sram_buffer_is_full                         : std_logic; -- Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
		error_flags_invalid_ccd_mode                                                  : std_logic; -- Error Flags : Invalid CCD Mode
	end record t_reg_34_hk_rd_reg;

	-- RMAP Area Config Register 0
	type t_reg_0_config_wr_reg is record
		v_start : std_logic_vector(15 downto 0); -- V Start Config Field
		v_end   : std_logic_vector(15 downto 0); -- V End Config Field
	end record t_reg_0_config_wr_reg;

	-- RMAP Area Config Register 1
	type t_reg_1_config_wr_reg is record
		charge_injection_width : std_logic_vector(15 downto 0); -- Charge Injection Width Config Field
		charge_injection_gap   : std_logic_vector(15 downto 0); -- Charge Injection Gap Config Field
	end record t_reg_1_config_wr_reg;

	-- RMAP Area Config Register 2
	type t_reg_2_config_wr_reg is record
		parallel_toi_period       : std_logic_vector(11 downto 0); -- Parallel Toi Period Config Field
		parallel_clk_overlap      : std_logic_vector(11 downto 0); -- Parallel Clock Overlap Config Field
		ccd_readout_order_1st_ccd : std_logic_vector(1 downto 0); -- CCD Readout Order Config Field (1st CCD)
		ccd_readout_order_2nd_ccd : std_logic_vector(1 downto 0); -- CCD Readout Order Config Field (2nd CCD)
		ccd_readout_order_3rd_ccd : std_logic_vector(1 downto 0); -- CCD Readout Order Config Field (3rd CCD)
		ccd_readout_order_4th_ccd : std_logic_vector(1 downto 0); -- CCD Readout Order Config Field (4th CCD)
	end record t_reg_2_config_wr_reg;

	-- RMAP Area Config Register 3
	type t_reg_3_config_wr_reg is record
		n_final_dump        : std_logic_vector(15 downto 0); -- N Final Dump Config Field
		h_end               : std_logic_vector(11 downto 0); -- H End Config Field
		charge_injection_en : std_logic; -- Charge Injection Enable Config Field
		tri_level_clk_en    : std_logic; -- Tri Level Clock Enable Config Field
		img_clk_dir         : std_logic; -- Image Clock Direction Config Field
		reg_clk_dir         : std_logic; -- Register Clock Direction Config Field
	end record t_reg_3_config_wr_reg;

	-- RMAP Area Config Register 4
	type t_reg_4_config_wr_reg is record
		packet_size     : std_logic_vector(15 downto 0); -- Data Packet Size Config Field
		int_sync_period : std_logic_vector(15 downto 0); -- Internal Sync Period Config Field
	end record t_reg_4_config_wr_reg;

	-- RMAP Area Config Register 5
	type t_reg_5_config_wr_reg is record
		trap_pumping_dwell_counter : std_logic_vector(19 downto 0); -- Trap Pumping Dwell Counter Field
		sync_sel                   : std_logic; -- Sync Source Selection Config Field
		sensor_sel                 : std_logic_vector(1 downto 0); -- CCD Port Data Sensor Selection Config Field
		digitise_en                : std_logic; -- Digitalise Enable Config Field
		dg_en                      : std_logic; -- DG (Drain Gate) Enable Field
		ccd_read_en                : std_logic; -- CCD Readout Enable Field
		reg_5_config_reserved      : std_logic_vector(5 downto 0); -- Register 5 Configuration Reserved
	end record t_reg_5_config_wr_reg;

	-- RMAP Area Config Register 6
	type t_reg_6_config_wr_reg is record
		ccd1_win_list_ptr : std_logic_vector(31 downto 0); -- CCD 1 Window List Pointer Config Field
	end record t_reg_6_config_wr_reg;

	-- RMAP Area Config Register 7
	type t_reg_7_config_wr_reg is record
		ccd1_pktorder_list_ptr : std_logic_vector(31 downto 0); -- CCD 1 Packet Order List Pointer Config Field
	end record t_reg_7_config_wr_reg;

	-- RMAP Area Config Register 8
	type t_reg_8_config_wr_reg is record
		ccd1_win_list_length  : std_logic_vector(15 downto 0); -- CCD 1 Window List Length Config Field
		ccd1_win_size_x       : std_logic_vector(5 downto 0); -- CCD 1 Window Size X Config Field
		ccd1_win_size_y       : std_logic_vector(5 downto 0); -- CCD 1 Window Size Y Config Field
		reg_8_config_reserved : std_logic_vector(3 downto 0); -- Register 8 Configuration Reserved
	end record t_reg_8_config_wr_reg;

	-- RMAP Area Config Register 9
	type t_reg_9_config_wr_reg is record
		ccd2_win_list_ptr : std_logic_vector(31 downto 0); -- CCD 2 Window List Pointer Config Field
	end record t_reg_9_config_wr_reg;

	-- RMAP Area Config Register 10
	type t_reg_10_config_wr_reg is record
		ccd2_pktorder_list_ptr : std_logic_vector(31 downto 0); -- CCD 2 Packet Order List Pointer Config Field
	end record t_reg_10_config_wr_reg;

	-- RMAP Area Config Register 11
	type t_reg_11_config_wr_reg is record
		ccd2_win_list_length   : std_logic_vector(15 downto 0); -- CCD 2 Window List Length Config Field
		ccd2_win_size_x        : std_logic_vector(5 downto 0); -- CCD 2 Window Size X Config Field
		ccd2_win_size_y        : std_logic_vector(5 downto 0); -- CCD 2 Window Size Y Config Field
		reg_11_config_reserved : std_logic_vector(3 downto 0); -- Register 11 Configuration Reserved
	end record t_reg_11_config_wr_reg;

	-- RMAP Area Config Register 12
	type t_reg_12_config_wr_reg is record
		ccd3_win_list_ptr : std_logic_vector(31 downto 0); -- CCD 3 Window List Pointer Config Field
	end record t_reg_12_config_wr_reg;

	-- RMAP Area Config Register 13
	type t_reg_13_config_wr_reg is record
		ccd3_pktorder_list_ptr : std_logic_vector(31 downto 0); -- CCD 3 Packet Order List Pointer Config Field
	end record t_reg_13_config_wr_reg;

	-- RMAP Area Config Register 14
	type t_reg_14_config_wr_reg is record
		ccd3_win_list_length   : std_logic_vector(15 downto 0); -- CCD 3 Window List Length Config Field
		ccd3_win_size_x        : std_logic_vector(5 downto 0); -- CCD 3 Window Size X Config Field
		ccd3_win_size_y        : std_logic_vector(5 downto 0); -- CCD 3 Window Size Y Config Field
		reg_14_config_reserved : std_logic_vector(3 downto 0); -- Register 14 Configuration Reserved
	end record t_reg_14_config_wr_reg;

	-- RMAP Area Config Register 15
	type t_reg_15_config_wr_reg is record
		ccd4_win_list_ptr : std_logic_vector(31 downto 0); -- CCD 4 Window List Pointer Config Field
	end record t_reg_15_config_wr_reg;

	-- RMAP Area Config Register 16
	type t_reg_16_config_wr_reg is record
		ccd4_pktorder_list_ptr : std_logic_vector(31 downto 0); -- CCD 4 Packet Order List Pointer Config Field
	end record t_reg_16_config_wr_reg;

	-- RMAP Area Config Register 17
	type t_reg_17_config_wr_reg is record
		ccd4_win_list_length   : std_logic_vector(15 downto 0); -- CCD 4 Window List Length Config Field
		ccd4_win_size_x        : std_logic_vector(5 downto 0); -- CCD 4 Window Size X Config Field
		ccd4_win_size_y        : std_logic_vector(5 downto 0); -- CCD 4 Window Size Y Config Field
		reg_17_config_reserved : std_logic_vector(3 downto 0); -- Register 17 Configuration Reserved
	end record t_reg_17_config_wr_reg;

	-- RMAP Area Config Register 18
	type t_reg_18_config_wr_reg is record
		ccd_vod_config   : std_logic_vector(11 downto 0); -- CCD Vod Configuration Config Field
		ccd1_vrd_config  : std_logic_vector(11 downto 0); -- CCD 1 Vrd Configuration Config Field
		ccd2_vrd_config0 : std_logic_vector(7 downto 0); -- CCD 2 Vrd Configuration Config Field
	end record t_reg_18_config_wr_reg;

	-- RMAP Area Config Register 19
	type t_reg_19_config_wr_reg is record
		ccd2_vrd_config1 : std_logic_vector(3 downto 0); -- CCD 2 Vrd Configuration Config Field
		ccd3_vrd_config  : std_logic_vector(11 downto 0); -- CCD 3 Vrd Configuration Config Field
		ccd4_vrd_config  : std_logic_vector(11 downto 0); -- CCD 4 Vrd Configuration Config Field
		ccd_vgd_config0  : std_logic_vector(3 downto 0); -- CCD Vgd Configuration Config Field
	end record t_reg_19_config_wr_reg;

	-- RMAP Area Config Register 20
	type t_reg_20_config_wr_reg is record
		ccd_vgd_config1  : std_logic_vector(7 downto 0); -- CCD Vgd Configuration Config Field
		ccd_vog_config   : std_logic_vector(11 downto 0); -- CCD Vog Configurion Config Field
		ccd_ig_hi_config : std_logic_vector(11 downto 0); -- CCD Ig High Configuration Config Field
	end record t_reg_20_config_wr_reg;

	-- RMAP Area Config Register 21
	type t_reg_21_config_wr_reg is record
		ccd_ig_lo_config         : std_logic_vector(11 downto 0); -- CCD Ig Low Configuration Config Field
		reg_21_config_reserved_0 : std_logic_vector(11 downto 0); -- Register 21 Configuration Reserved
		ccd_mode_config          : std_logic_vector(3 downto 0); -- CCD Mode Configuration Config Field
		reg_21_config_reserved_1 : std_logic_vector(2 downto 0); -- Register 21 Configuration Reserved
		clear_error_flag         : std_logic; -- Clear Error Flag Config Field
	end record t_reg_21_config_wr_reg;

	-- RMAP Area Config Register 22
	type t_reg_22_config_wr_reg is record
		reg_22_config_reserved : std_logic_vector(31 downto 0); -- Register 22 Configuration Reserved
	end record t_reg_22_config_wr_reg;

	-- RMAP Area Config Register 23
	type t_reg_23_config_wr_reg is record
		ccd1_last_e_packet     : std_logic_vector(9 downto 0); -- CCD 1 Last E Packet Field
		ccd1_last_f_packet     : std_logic_vector(9 downto 0); -- CCD 1 Last F Packet Field
		ccd2_last_e_packet     : std_logic_vector(9 downto 0); -- CCD 2 Last E Packet Field
		reg_23_config_reserved : std_logic_vector(1 downto 0); -- Register 23 Configuration Reserved
	end record t_reg_23_config_wr_reg;

	-- RMAP Area Config Register 24
	type t_reg_24_config_wr_reg is record
		ccd2_last_f_packet     : std_logic_vector(9 downto 0); -- CCD 2 Last F Packet Field
		ccd3_last_e_packet     : std_logic_vector(9 downto 0); -- CCD 3 Last E Packet Field
		ccd3_last_f_packet     : std_logic_vector(9 downto 0); -- CCD 3 Last F Packet Field
		reg_24_config_reserved : std_logic_vector(1 downto 0); -- Register 24 Configuration Reserved
	end record t_reg_24_config_wr_reg;

	-- RMAP Area Config Register 25
	type t_reg_25_config_wr_reg is record
		ccd4_last_e_packet        : std_logic_vector(9 downto 0); -- CCD 4 Last E Packet Field
		ccd4_last_f_packet        : std_logic_vector(9 downto 0); -- CCD 4 Last F Packet Field
		surface_inversion_counter : std_logic_vector(9 downto 0); -- Surface Inversion Counter Field
		reg_25_config_reserved    : std_logic_vector(1 downto 0); -- Register 25 Configuration Reserved
	end record t_reg_25_config_wr_reg;

	-- RMAP Area Config Register 26
	type t_reg_26_config_wr_reg is record
		readout_pause_counter        : std_logic_vector(15 downto 0); -- Readout Pause Counter Field
		trap_pumping_shuffle_counter : std_logic_vector(15 downto 0); -- Trap Pumping Shuffle Counter Field
	end record t_reg_26_config_wr_reg;

	-- RMAP Area HK Register 0
	type t_reg_0_hk_wr_reg is record
		tou_sense_1 : std_logic_vector(15 downto 0); -- TOU Sense 1 HK Field
		tou_sense_2 : std_logic_vector(15 downto 0); -- TOU Sense 2 HK Field
	end record t_reg_0_hk_wr_reg;

	-- RMAP Area HK Register 1
	type t_reg_1_hk_wr_reg is record
		tou_sense_3 : std_logic_vector(15 downto 0); -- TOU Sense 3 HK Field
		tou_sense_4 : std_logic_vector(15 downto 0); -- TOU Sense 4 HK Field
	end record t_reg_1_hk_wr_reg;

	-- RMAP Area HK Register 2
	type t_reg_2_hk_wr_reg is record
		tou_sense_5 : std_logic_vector(15 downto 0); -- TOU Sense 5 HK Field
		tou_sense_6 : std_logic_vector(15 downto 0); -- TOU Sense 6 HK Field
	end record t_reg_2_hk_wr_reg;

	-- RMAP Area HK Register 3
	type t_reg_3_hk_wr_reg is record
		ccd1_ts : std_logic_vector(15 downto 0); -- CCD 1 TS HK Field
		ccd2_ts : std_logic_vector(15 downto 0); -- CCD 2 TS HK Field
	end record t_reg_3_hk_wr_reg;

	-- RMAP Area HK Register 4
	type t_reg_4_hk_wr_reg is record
		ccd3_ts : std_logic_vector(15 downto 0); -- CCD 3 TS HK Field
		ccd4_ts : std_logic_vector(15 downto 0); -- CCD 4 TS HK Field
	end record t_reg_4_hk_wr_reg;

	-- RMAP Area HK Register 5
	type t_reg_5_hk_wr_reg is record
		prt1 : std_logic_vector(15 downto 0); -- PRT 1 HK Field
		prt2 : std_logic_vector(15 downto 0); -- PRT 2 HK Field
	end record t_reg_5_hk_wr_reg;

	-- RMAP Area HK Register 6
	type t_reg_6_hk_wr_reg is record
		prt3 : std_logic_vector(15 downto 0); -- PRT 3 HK Field
		prt4 : std_logic_vector(15 downto 0); -- PRT 4 HK Field
	end record t_reg_6_hk_wr_reg;

	-- RMAP Area HK Register 7
	type t_reg_7_hk_wr_reg is record
		prt5          : std_logic_vector(15 downto 0); -- PRT 5 HK Field
		zero_diff_amp : std_logic_vector(15 downto 0); -- Zero Diff Amplifier HK Field
	end record t_reg_7_hk_wr_reg;

	-- RMAP Area HK Register 8
	type t_reg_8_hk_wr_reg is record
		ccd1_vod_mon : std_logic_vector(15 downto 0); -- CCD 1 Vod Monitor HK Field
		ccd1_vog_mon : std_logic_vector(15 downto 0); -- CCD 1 Vog Monitor HK Field
	end record t_reg_8_hk_wr_reg;

	-- RMAP Area HK Register 9
	type t_reg_9_hk_wr_reg is record
		ccd1_vrd_mon_e : std_logic_vector(15 downto 0); -- CCD 1 Vrd Monitor E HK Field
		ccd2_vod_mon   : std_logic_vector(15 downto 0); -- CCD 2 Vod Monitor HK Field
	end record t_reg_9_hk_wr_reg;

	-- RMAP Area HK Register 10
	type t_reg_10_hk_wr_reg is record
		ccd2_vog_mon   : std_logic_vector(15 downto 0); -- CCD 2 Vog Monitor HK Field
		ccd2_vrd_mon_e : std_logic_vector(15 downto 0); -- CCD 2 Vrd Monitor E HK Field
	end record t_reg_10_hk_wr_reg;

	-- RMAP Area HK Register 11
	type t_reg_11_hk_wr_reg is record
		ccd3_vod_mon : std_logic_vector(15 downto 0); -- CCD 3 Vod Monitor HK Field
		ccd3_vog_mon : std_logic_vector(15 downto 0); -- CCD 3 Vog Monitor HK Field
	end record t_reg_11_hk_wr_reg;

	-- RMAP Area HK Register 12
	type t_reg_12_hk_wr_reg is record
		ccd3_vrd_mon_e : std_logic_vector(15 downto 0); -- CCD 3 Vrd Monitor E HK Field
		ccd4_vod_mon   : std_logic_vector(15 downto 0); -- CCD 4 Vod Monitor HK Field
	end record t_reg_12_hk_wr_reg;

	-- RMAP Area HK Register 13
	type t_reg_13_hk_wr_reg is record
		ccd4_vog_mon   : std_logic_vector(15 downto 0); -- CCD 4 Vog Monitor HK Field
		ccd4_vrd_mon_e : std_logic_vector(15 downto 0); -- CCD 4 Vrd Monitor E HK Field
	end record t_reg_13_hk_wr_reg;

	-- RMAP Area HK Register 14
	type t_reg_14_hk_wr_reg is record
		vccd      : std_logic_vector(15 downto 0); -- V CCD HK Field
		vrclk_mon : std_logic_vector(15 downto 0); -- VRClock Monitor HK Field
	end record t_reg_14_hk_wr_reg;

	-- RMAP Area HK Register 15
	type t_reg_15_hk_wr_reg is record
		viclk     : std_logic_vector(15 downto 0); -- VIClock HK Field
		vrclk_low : std_logic_vector(15 downto 0); -- VRClock Low HK Field
	end record t_reg_15_hk_wr_reg;

	-- RMAP Area HK Register 16
	type t_reg_16_hk_wr_reg is record
		d5vb_pos_mon : std_logic_vector(15 downto 0); -- 5Vb Positive Monitor HK Field
		d5vb_neg_mon : std_logic_vector(15 downto 0); -- 5Vb Negative Monitor HK Field
	end record t_reg_16_hk_wr_reg;

	-- RMAP Area HK Register 17
	type t_reg_17_hk_wr_reg is record
		d3v3b_mon : std_logic_vector(15 downto 0); -- 3V3b Monitor HK Field
		d2v5a_mon : std_logic_vector(15 downto 0); -- 2V5a Monitor HK Field
	end record t_reg_17_hk_wr_reg;

	-- RMAP Area HK Register 18
	type t_reg_18_hk_wr_reg is record
		d3v3d_mon : std_logic_vector(15 downto 0); -- 3V3d Monitor HK Field
		d2v5d_mon : std_logic_vector(15 downto 0); -- 2V5d Monitor HK Field
	end record t_reg_18_hk_wr_reg;

	-- RMAP Area HK Register 19
	type t_reg_19_hk_wr_reg is record
		d1v5d_mon  : std_logic_vector(15 downto 0); -- 1V5d Monitor HK Field
		d5vref_mon : std_logic_vector(15 downto 0); -- 5Vref Monitor HK Field
	end record t_reg_19_hk_wr_reg;

	-- RMAP Area HK Register 20
	type t_reg_20_hk_wr_reg is record
		vccd_pos_raw : std_logic_vector(15 downto 0); -- Vccd Positive Raw HK Field
		vclk_pos_raw : std_logic_vector(15 downto 0); -- Vclk Positive Raw HK Field
	end record t_reg_20_hk_wr_reg;

	-- RMAP Area HK Register 21
	type t_reg_21_hk_wr_reg is record
		van1_pos_raw : std_logic_vector(15 downto 0); -- Van 1 Positive Raw HK Field
		van3_neg_mon : std_logic_vector(15 downto 0); -- Van 3 Negative Monitor HK Field
	end record t_reg_21_hk_wr_reg;

	-- RMAP Area HK Register 22
	type t_reg_22_hk_wr_reg is record
		van2_pos_raw : std_logic_vector(15 downto 0); -- Van Positive Raw HK Field
		vdig_raw     : std_logic_vector(15 downto 0); -- Vdig Raw HK Field
	end record t_reg_22_hk_wr_reg;

	-- RMAP Area HK Register 23
	type t_reg_23_hk_wr_reg is record
		vdig_raw_2 : std_logic_vector(15 downto 0); -- Vdig Raw 2 HK Field
		viclk_low  : std_logic_vector(15 downto 0); -- VIClock Low HK Field
	end record t_reg_23_hk_wr_reg;

	-- RMAP Area HK Register 24
	type t_reg_24_hk_wr_reg is record
		ccd1_vrd_mon_f : std_logic_vector(15 downto 0); -- CCD 1 Vrd Monitor F HK Field
		ccd1_vdd_mon   : std_logic_vector(15 downto 0); -- CCD 1 Vdd Monitor HK Field
	end record t_reg_24_hk_wr_reg;

	-- RMAP Area HK Register 25
	type t_reg_25_hk_wr_reg is record
		ccd1_vgd_mon   : std_logic_vector(15 downto 0); -- CCD 1 Vgd Monitor HK Field
		ccd2_vrd_mon_f : std_logic_vector(15 downto 0); -- CCD 2 Vrd Monitor F HK Field
	end record t_reg_25_hk_wr_reg;

	-- RMAP Area HK Register 26
	type t_reg_26_hk_wr_reg is record
		ccd2_vdd_mon : std_logic_vector(15 downto 0); -- CCD 2 Vdd Monitor HK Field
		ccd2_vgd_mon : std_logic_vector(15 downto 0); -- CCD 2 Vgd Monitor HK Field
	end record t_reg_26_hk_wr_reg;

	-- RMAP Area HK Register 27
	type t_reg_27_hk_wr_reg is record
		ccd3_vrd_mon_f : std_logic_vector(15 downto 0); -- CCD 3 Vrd Monitor F HK Field
		ccd3_vdd_mon   : std_logic_vector(15 downto 0); -- CCD 3 Vdd Monitor HK Field
	end record t_reg_27_hk_wr_reg;

	-- RMAP Area HK Register 28
	type t_reg_28_hk_wr_reg is record
		ccd3_vgd_mon   : std_logic_vector(15 downto 0); -- CCD 3 Vgd Monitor HK Field
		ccd4_vrd_mon_f : std_logic_vector(15 downto 0); -- CCD 4 Vrd Monitor F HK Field
	end record t_reg_28_hk_wr_reg;

	-- RMAP Area HK Register 29
	type t_reg_29_hk_wr_reg is record
		ccd4_vdd_mon : std_logic_vector(15 downto 0); -- CCD 4 Vdd Monitor HK Field
		ccd4_vgd_mon : std_logic_vector(15 downto 0); -- CCD 4 Vgd Monitor HK Field
	end record t_reg_29_hk_wr_reg;

	-- RMAP Area HK Register 30
	type t_reg_30_hk_wr_reg is record
		ig_hi_mon : std_logic_vector(15 downto 0); -- Ig High Monitor HK Field
		ig_lo_mon : std_logic_vector(15 downto 0); -- Ig Low Monitor HK Field
	end record t_reg_30_hk_wr_reg;

	-- RMAP Area HK Register 31
	type t_reg_31_hk_wr_reg is record
		tsense_a : std_logic_vector(15 downto 0); -- Tsense A HK Field
		tsense_b : std_logic_vector(15 downto 0); -- Tsense B HK Field
	end record t_reg_31_hk_wr_reg;

	-- RMAP Area HK Register 32
	type t_reg_32_hk_wr_reg is record
		spw_status_spw_status_reserved : std_logic_vector(1 downto 0); -- SpW Status : SpaceWire Status Reserved
		reg_32_hk_reserved             : std_logic_vector(7 downto 0); -- Register 32 HK Reserved
	end record t_reg_32_hk_wr_reg;

	-- RMAP Area HK Register 33
	type t_reg_33_hk_wr_reg is record
		reg_33_hk_reserved : std_logic_vector(9 downto 0); -- Register 33 HK Reserved
		op_mode            : std_logic_vector(3 downto 0); -- Operational Mode HK Field
	end record t_reg_33_hk_wr_reg;

	-- RMAP Area HK Register 34
	type t_reg_34_hk_wr_reg is record
		error_flags_error_flags_reserved : std_logic_vector(26 downto 0); -- Error Flags : Error Flags Reserved
	end record t_reg_34_hk_wr_reg;

	-- RMAP Area HK Register 35
	type t_reg_35_hk_wr_reg is record
		fpga_minor_version : std_logic_vector(7 downto 0); -- FPGA Minor Version Field
		fpga_major_version : std_logic_vector(3 downto 0); -- FPGA Major Version Field
		board_id           : std_logic_vector(8 downto 0); -- Board ID Field
		reg_35_hk_reserved : std_logic_vector(10 downto 0); -- Register 35 HK Reserved HK Field
	end record t_reg_35_hk_wr_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_rmap_memory_wr_area is record
		reg_0_config  : t_reg_0_config_wr_reg; -- RMAP Area Config Register 0
		reg_1_config  : t_reg_1_config_wr_reg; -- RMAP Area Config Register 1
		reg_2_config  : t_reg_2_config_wr_reg; -- RMAP Area Config Register 2
		reg_3_config  : t_reg_3_config_wr_reg; -- RMAP Area Config Register 3
		reg_4_config  : t_reg_4_config_wr_reg; -- RMAP Area Config Register 4
		reg_5_config  : t_reg_5_config_wr_reg; -- RMAP Area Config Register 5
		reg_6_config  : t_reg_6_config_wr_reg; -- RMAP Area Config Register 6
		reg_7_config  : t_reg_7_config_wr_reg; -- RMAP Area Config Register 7
		reg_8_config  : t_reg_8_config_wr_reg; -- RMAP Area Config Register 8
		reg_9_config  : t_reg_9_config_wr_reg; -- RMAP Area Config Register 9
		reg_10_config : t_reg_10_config_wr_reg; -- RMAP Area Config Register 10
		reg_11_config : t_reg_11_config_wr_reg; -- RMAP Area Config Register 11
		reg_12_config : t_reg_12_config_wr_reg; -- RMAP Area Config Register 12
		reg_13_config : t_reg_13_config_wr_reg; -- RMAP Area Config Register 13
		reg_14_config : t_reg_14_config_wr_reg; -- RMAP Area Config Register 14
		reg_15_config : t_reg_15_config_wr_reg; -- RMAP Area Config Register 15
		reg_16_config : t_reg_16_config_wr_reg; -- RMAP Area Config Register 16
		reg_17_config : t_reg_17_config_wr_reg; -- RMAP Area Config Register 17
		reg_18_config : t_reg_18_config_wr_reg; -- RMAP Area Config Register 18
		reg_19_config : t_reg_19_config_wr_reg; -- RMAP Area Config Register 19
		reg_20_config : t_reg_20_config_wr_reg; -- RMAP Area Config Register 20
		reg_21_config : t_reg_21_config_wr_reg; -- RMAP Area Config Register 21
		reg_22_config : t_reg_22_config_wr_reg; -- RMAP Area Config Register 22
		reg_23_config : t_reg_23_config_wr_reg; -- RMAP Area Config Register 23
		reg_24_config : t_reg_24_config_wr_reg; -- RMAP Area Config Register 24
		reg_25_config : t_reg_25_config_wr_reg; -- RMAP Area Config Register 25
		reg_26_config : t_reg_26_config_wr_reg; -- RMAP Area Config Register 26
		reg_0_hk      : t_reg_0_hk_wr_reg; -- RMAP Area HK Register 0
		reg_1_hk      : t_reg_1_hk_wr_reg; -- RMAP Area HK Register 1
		reg_2_hk      : t_reg_2_hk_wr_reg; -- RMAP Area HK Register 2
		reg_3_hk      : t_reg_3_hk_wr_reg; -- RMAP Area HK Register 3
		reg_4_hk      : t_reg_4_hk_wr_reg; -- RMAP Area HK Register 4
		reg_5_hk      : t_reg_5_hk_wr_reg; -- RMAP Area HK Register 5
		reg_6_hk      : t_reg_6_hk_wr_reg; -- RMAP Area HK Register 6
		reg_7_hk      : t_reg_7_hk_wr_reg; -- RMAP Area HK Register 7
		reg_8_hk      : t_reg_8_hk_wr_reg; -- RMAP Area HK Register 8
		reg_9_hk      : t_reg_9_hk_wr_reg; -- RMAP Area HK Register 9
		reg_10_hk     : t_reg_10_hk_wr_reg; -- RMAP Area HK Register 10
		reg_11_hk     : t_reg_11_hk_wr_reg; -- RMAP Area HK Register 11
		reg_12_hk     : t_reg_12_hk_wr_reg; -- RMAP Area HK Register 12
		reg_13_hk     : t_reg_13_hk_wr_reg; -- RMAP Area HK Register 13
		reg_14_hk     : t_reg_14_hk_wr_reg; -- RMAP Area HK Register 14
		reg_15_hk     : t_reg_15_hk_wr_reg; -- RMAP Area HK Register 15
		reg_16_hk     : t_reg_16_hk_wr_reg; -- RMAP Area HK Register 16
		reg_17_hk     : t_reg_17_hk_wr_reg; -- RMAP Area HK Register 17
		reg_18_hk     : t_reg_18_hk_wr_reg; -- RMAP Area HK Register 18
		reg_19_hk     : t_reg_19_hk_wr_reg; -- RMAP Area HK Register 19
		reg_20_hk     : t_reg_20_hk_wr_reg; -- RMAP Area HK Register 20
		reg_21_hk     : t_reg_21_hk_wr_reg; -- RMAP Area HK Register 21
		reg_22_hk     : t_reg_22_hk_wr_reg; -- RMAP Area HK Register 22
		reg_23_hk     : t_reg_23_hk_wr_reg; -- RMAP Area HK Register 23
		reg_24_hk     : t_reg_24_hk_wr_reg; -- RMAP Area HK Register 24
		reg_25_hk     : t_reg_25_hk_wr_reg; -- RMAP Area HK Register 25
		reg_26_hk     : t_reg_26_hk_wr_reg; -- RMAP Area HK Register 26
		reg_27_hk     : t_reg_27_hk_wr_reg; -- RMAP Area HK Register 27
		reg_28_hk     : t_reg_28_hk_wr_reg; -- RMAP Area HK Register 28
		reg_29_hk     : t_reg_29_hk_wr_reg; -- RMAP Area HK Register 29
		reg_30_hk     : t_reg_30_hk_wr_reg; -- RMAP Area HK Register 30
		reg_31_hk     : t_reg_31_hk_wr_reg; -- RMAP Area HK Register 31
		reg_32_hk     : t_reg_32_hk_wr_reg; -- RMAP Area HK Register 32
		reg_33_hk     : t_reg_33_hk_wr_reg; -- RMAP Area HK Register 33
		reg_34_hk     : t_reg_34_hk_wr_reg; -- RMAP Area HK Register 34
		reg_35_hk     : t_reg_35_hk_wr_reg; -- RMAP Area HK Register 35
	end record t_rmap_memory_wr_area;

	-- Avalon MM Read-Only Registers
	type t_rmap_memory_rd_area is record
		reg_32_hk : t_reg_32_hk_rd_reg; -- RMAP Area HK Register 32
		reg_33_hk : t_reg_33_hk_rd_reg; -- RMAP Area HK Register 33
		reg_34_hk : t_reg_34_hk_rd_reg; -- RMAP Area HK Register 34
	end record t_rmap_memory_rd_area;

end package nrme_rmap_mem_area_nfee_pkg;

package body nrme_rmap_mem_area_nfee_pkg is
end package body nrme_rmap_mem_area_nfee_pkg;
