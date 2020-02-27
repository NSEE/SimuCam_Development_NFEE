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

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_RMAP_MIN_ADDR : natural range 0 to 4095 := 16#000#;
	constant c_AVALON_MM_RMAP_MAX_ADDR : natural range 0 to 4095 := 16#3FB#;

	-- Registers Types

	-- Dummy
	type t_dummy_rd_reg is record
		dummy : std_logic;              -- 
	end record t_dummy_rd_reg;

	-- DEB Critical Configuration Area
	type t_deb_ccfg_aeb_idx_wr_reg is record
		vdig_aeb4 : std_logic;          -- 
		vdig_aeb3 : std_logic;          -- 
		vdig_aeb2 : std_logic;          -- 
		vdig_aeb1 : std_logic;          -- 
	end record t_deb_ccfg_aeb_idx_wr_reg;

	-- DEB Critical Configuration Area
	type t_deb_ccfg_reg_dta_3_wr_reg is record
		pll_reg_word_3 : std_logic_vector(31 downto 0); -- 
	end record t_deb_ccfg_reg_dta_3_wr_reg;

	-- DEB Critical Configuration Area
	type t_deb_ccfg_reg_dta_2_wr_reg is record
		pll_reg_word_2 : std_logic_vector(31 downto 0); -- 
	end record t_deb_ccfg_reg_dta_2_wr_reg;

	-- DEB Critical Configuration Area
	type t_deb_ccfg_reg_dta_1_wr_reg is record
		pll_reg_word_1 : std_logic_vector(31 downto 0); -- 
	end record t_deb_ccfg_reg_dta_1_wr_reg;

	-- DEB Critical Configuration Area
	type t_deb_ccfg_reg_dta_0_wr_reg is record
		pll_reg_word_0 : std_logic_vector(31 downto 0); -- 
	end record t_deb_ccfg_reg_dta_0_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_oper_mod_wr_reg is record
		imm      : std_logic;           -- 
		oper_mod : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_oper_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t7_in_mod_wr_reg is record
		in_mod7 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t7_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t6_in_mod_wr_reg is record
		in_mod6 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t6_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t5_in_mod_wr_reg is record
		in_mod5 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t5_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t4_in_mod_wr_reg is record
		in_mod4 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t4_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t3_in_mod_wr_reg is record
		in_mod3 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t3_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t2_in_mod_wr_reg is record
		in_mod2 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t2_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t1_in_mod_wr_reg is record
		in_mod1 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t1_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_t0_in_mod_wr_reg is record
		in_mod0 : std_logic_vector(2 downto 0); -- 
	end record t_deb_gcfg_t0_in_mod_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_w_siz_x_wr_reg is record
		w_siz_x : std_logic_vector(6 downto 0); -- 
	end record t_deb_gcfg_w_siz_x_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_w_siz_y_wr_reg is record
		w_siz_y : std_logic_vector(6 downto 0); -- 
	end record t_deb_gcfg_w_siz_y_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_idx_4_wr_reg is record
		wdw_idx_4 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_idx_4_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_len_4_wr_reg is record
		wdw_len_4 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_len_4_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_idx_3_wr_reg is record
		wdw_idx_3 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_idx_3_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_len_3_wr_reg is record
		wdw_len_3 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_len_3_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_idx_2_wr_reg is record
		wdw_idx_2 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_idx_2_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_len_2_wr_reg is record
		wdw_len_2 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_len_2_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_idx_1_wr_reg is record
		wdw_idx_1 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_idx_1_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_wdw_len_1_wr_reg is record
		wdw_len_1 : std_logic_vector(9 downto 0); -- 
	end record t_deb_gcfg_wdw_len_1_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_lin_4_wr_reg is record
		ovs_lin_4 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_lin_4_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_lin_3_wr_reg is record
		ovs_lin_3 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_lin_3_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_lin_2_wr_reg is record
		ovs_lin_2 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_lin_2_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_lin_1_wr_reg is record
		ovs_lin_1 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_lin_1_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_pix_4_wr_reg is record
		ovs_pix_4 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_pix_4_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_pix_3_wr_reg is record
		ovs_pix_3 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_pix_3_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_pix_2_wr_reg is record
		ovs_pix_2 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_pix_2_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_ovs_pix_1_wr_reg is record
		ovs_pix_1 : std_logic_vector(4 downto 0); -- 
	end record t_deb_gcfg_ovs_pix_1_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_2_5s_n_cyc_wr_reg is record
		d2_5s_n_cyc : std_logic_vector(7 downto 0); -- 
	end record t_deb_gcfg_2_5s_n_cyc_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_trg_src_wr_reg is record
		sel_trg : std_logic;            -- 
	end record t_deb_gcfg_trg_src_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_frm_cnt_wr_reg is record
		frm_cnt : std_logic_vector(15 downto 0); -- 
	end record t_deb_gcfg_frm_cnt_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_syn_frq_wr_reg is record
		syn_nr : std_logic;             -- 
	end record t_deb_gcfg_syn_frq_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_rst_wdg_wr_reg is record
		rst_wdg : std_logic;            -- 
	end record t_deb_gcfg_rst_wdg_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_rst_cps_wr_reg is record
		rst_cps : std_logic;            -- 
	end record t_deb_gcfg_rst_cps_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_25s_dly_wr_reg is record
		d25s_dly : std_logic_vector(23 downto 0); -- 
	end record t_deb_gcfg_25s_dly_wr_reg;

	-- DEB General Configuration Area
	type t_deb_gcfg_tmod_conf_wr_reg is record
		tmod_conf : std_logic_vector(15 downto 0); -- 
	end record t_deb_gcfg_tmod_conf_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_deb_status_wr_reg is record
		oper_mod                                      : std_logic_vector(2 downto 0); -- 
		window_list_table_edac_corrected_error_number : std_logic_vector(5 downto 0); -- 
		uncorrected_error_number                      : std_logic_vector(1 downto 0); -- 
		pll_status                                    : std_logic_vector(7 downto 0); -- 
		vdig_aeb4_status                              : std_logic; -- 
		vdig_aeb3_status                              : std_logic; -- 
		vdig_aeb2_status                              : std_logic; -- 
		vdig_aeb1_status                              : std_logic; -- 
		wdw_list_cnt_ovf                              : std_logic_vector(1 downto 0); -- 
		aeb_spi_status                                : std_logic; -- 
		wdg_status                                    : std_logic; -- 
	end record t_deb_hk_deb_status_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_deb_ovf_wr_reg is record
		row_active_list8_cnt_ovf     : std_logic; -- 
		row_active_list7_cnt_ovf     : std_logic; -- 
		row_active_list6_cnt_ovf     : std_logic; -- 
		row_active_list5_cnt_ovf     : std_logic; -- 
		row_active_list4_cnt_ovf     : std_logic; -- 
		row_active_list3_cnt_ovf     : std_logic; -- 
		row_active_list2_cnt_ovf     : std_logic; -- 
		row_active_list1_cnt_ovf     : std_logic; -- 
		out_buff8_ovf                : std_logic; -- 
		out_buff7_ovf                : std_logic; -- 
		out_buff6_ovf                : std_logic; -- 
		out_buff5_ovf                : std_logic; -- 
		out_buff4_ovf                : std_logic; -- 
		out_buff3_ovf                : std_logic; -- 
		out_buff2_ovf                : std_logic; -- 
		out_buff1_ovf                : std_logic; -- 
		rmap4_ovf                    : std_logic; -- 
		rmap3_ovf                    : std_logic; -- 
		rmap2_ovf                    : std_logic; -- 
		rmap1_ovf                    : std_logic; -- 
		line_pixel_counters_overflow : std_logic_vector(7 downto 0); -- 
	end record t_deb_hk_deb_ovf_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_spw_status_wr_reg is record
		spw_status : std_logic_vector(31 downto 0); -- 
	end record t_deb_hk_spw_status_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_deb_ahk1_wr_reg is record
		vdig_in : std_logic_vector(11 downto 0); -- 
		vio     : std_logic_vector(11 downto 0); -- 
	end record t_deb_hk_deb_ahk1_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_deb_ahk2_wr_reg is record
		vcor : std_logic_vector(11 downto 0); -- 
		vlvd : std_logic_vector(11 downto 0); -- 
	end record t_deb_hk_deb_ahk2_wr_reg;

	-- DEB Housekeeping Area
	type t_deb_hk_deb_ahk3_wr_reg is record
		deb_temp : std_logic_vector(11 downto 0); -- 
	end record t_deb_hk_deb_ahk3_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_aeb_control_wr_reg is record
		new_state   : std_logic_vector(4 downto 0); -- 
		set_state   : std_logic;        -- 
		aeb_reset   : std_logic;        -- 
		adc_data_rd : std_logic;        -- 
		adc_cfg_wr  : std_logic;        -- 
		adc_cfg_rd  : std_logic;        -- 
		dac_wr      : std_logic;        -- 
	end record t_aeb1_ccfg_aeb_control_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_aeb_config_wr_reg is record
		watchdog_dis : std_logic;       -- 
		int_sync     : std_logic;       -- 
		vasp_cds_en  : std_logic;       -- 
		vasp2_cal_en : std_logic;       -- 
		vasp1_cal_en : std_logic;       -- 
	end record t_aeb1_ccfg_aeb_config_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_aeb_config_key_wr_reg is record
		key : std_logic_vector(31 downto 0); -- 
	end record t_aeb1_ccfg_aeb_config_key_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_aeb_config_ait1_wr_reg is record
		override_sw     : std_logic;    -- 
		sw_van3         : std_logic;    -- 
		sw_van2         : std_logic;    -- 
		sw_van1         : std_logic;    -- 
		sw_vclk         : std_logic;    -- 
		sw_vccd         : std_logic;    -- 
		override_vasp   : std_logic;    -- 
		vasp2_pix_en    : std_logic;    -- 
		vasp1_pix_en    : std_logic;    -- 
		vasp2_adc_en    : std_logic;    -- 
		vasp1_adc_en    : std_logic;    -- 
		vasp2_reset     : std_logic;    -- 
		vasp1_reset     : std_logic;    -- 
		override_adc    : std_logic;    -- 
		adc2_en_p5v0    : std_logic;    -- 
		adc1_en_p5v0    : std_logic;    -- 
		pt1000_cal_on_n : std_logic;    -- 
		en_v_mux_n      : std_logic;    -- 
		adc2_pwdn_n     : std_logic;    -- 
		adc1_pwdn_n     : std_logic;    -- 
		adc_clk_en      : std_logic;    -- 
	end record t_aeb1_ccfg_aeb_config_ait1_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_aeb_config_pattern_wr_reg is record
		pattern_ccdid : std_logic_vector(1 downto 0); -- 
		pattern_cols  : std_logic_vector(13 downto 0); -- 
		pattern_rows  : std_logic_vector(13 downto 0); -- 
	end record t_aeb1_ccfg_aeb_config_pattern_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_vasp_i2c_control_wr_reg is record
		vasp_cfg_addr     : std_logic_vector(7 downto 0); -- 
		vasp1_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_select      : std_logic;  -- 
		vasp1_select      : std_logic;  -- 
		calibration_start : std_logic;  -- 
		i2c_read_start    : std_logic;  -- 
		i2c_write_start   : std_logic;  -- 
	end record t_aeb1_ccfg_vasp_i2c_control_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_dac_config_1_wr_reg is record
		dac_vog : std_logic_vector(11 downto 0); -- 
		dac_vrd : std_logic_vector(11 downto 0); -- 
	end record t_aeb1_ccfg_dac_config_1_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_dac_config_2_wr_reg is record
		dac_vod : std_logic_vector(11 downto 0); -- 
	end record t_aeb1_ccfg_dac_config_2_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_pwr_config1_wr_reg is record
		time_vccd_on : std_logic_vector(7 downto 0); -- 
		time_vclk_on : std_logic_vector(7 downto 0); -- 
		time_van1_on : std_logic_vector(7 downto 0); -- 
		time_van2_on : std_logic_vector(7 downto 0); -- 
	end record t_aeb1_ccfg_pwr_config1_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_pwr_config2_wr_reg is record
		time_van3_on  : std_logic_vector(7 downto 0); -- 
		time_vccd_off : std_logic_vector(7 downto 0); -- 
		time_vclk_off : std_logic_vector(7 downto 0); -- 
		time_van1_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb1_ccfg_pwr_config2_wr_reg;

	-- AEB 1 Critical Configuration Area
	type t_aeb1_ccfg_pwr_config3_wr_reg is record
		time_van2_off : std_logic_vector(7 downto 0); -- 
		time_van3_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb1_ccfg_pwr_config3_wr_reg;

	-- AEB 1 General Configuration Area
	type t_aeb1_gcfg_adc1_config_wr_reg is record
		adc1_bypas  : std_logic;        -- 
		adc1_clkenb : std_logic;        -- 
		adc1_chop   : std_logic;        -- 
		adc1_stat   : std_logic;        -- 
		adc1_idlmod : std_logic;        -- 
		adc1_dly2   : std_logic;        -- 
		adc1_dly1   : std_logic;        -- 
		adc1_dly0   : std_logic;        -- 
		adc1_sbcs1  : std_logic;        -- 
		adc1_sbcs0  : std_logic;        -- 
		adc1_drate1 : std_logic;        -- 
		adc1_drate0 : std_logic;        -- 
		adc1_ainp3  : std_logic;        -- 
		adc1_ainp2  : std_logic;        -- 
		adc1_ainp1  : std_logic;        -- 
		adc1_ainp0  : std_logic;        -- 
		adc1_ainn3  : std_logic;        -- 
		adc1_ainn2  : std_logic;        -- 
		adc1_ainn1  : std_logic;        -- 
		adc1_ainn0  : std_logic;        -- 
		adc1_diff7  : std_logic;        -- 
		adc1_diff6  : std_logic;        -- 
		adc1_diff5  : std_logic;        -- 
		adc1_diff4  : std_logic;        -- 
		adc1_diff3  : std_logic;        -- 
		adc1_diff2  : std_logic;        -- 
		adc1_diff1  : std_logic;        -- 
		adc1_diff0  : std_logic;        -- 
		adc1_ain7   : std_logic;        -- 
		adc1_ain6   : std_logic;        -- 
		adc1_ain5   : std_logic;        -- 
		adc1_ain4   : std_logic;        -- 
		adc1_ain3   : std_logic;        -- 
		adc1_ain2   : std_logic;        -- 
		adc1_ain1   : std_logic;        -- 
		adc1_ain0   : std_logic;        -- 
		adc1_ain15  : std_logic;        -- 
		adc1_ain14  : std_logic;        -- 
		adc1_ain13  : std_logic;        -- 
		adc1_ain12  : std_logic;        -- 
		adc1_ain11  : std_logic;        -- 
		adc1_ain10  : std_logic;        -- 
		adc1_ain9   : std_logic;        -- 
		adc1_ain8   : std_logic;        -- 
		adc1_ref    : std_logic;        -- 
		adc1_gain   : std_logic;        -- 
		adc1_temp   : std_logic;        -- 
		adc1_vcc    : std_logic;        -- 
		adc1_offset : std_logic;        -- 
		adc1_cio7   : std_logic;        -- 
		adc1_cio6   : std_logic;        -- 
		adc1_cio5   : std_logic;        -- 
		adc1_cio4   : std_logic;        -- 
		adc1_cio3   : std_logic;        -- 
		adc1_cio2   : std_logic;        -- 
		adc1_cio1   : std_logic;        -- 
		adc1_cio0   : std_logic;        -- 
		adc1_dio7   : std_logic;        -- 
		adc1_dio6   : std_logic;        -- 
		adc1_dio5   : std_logic;        -- 
		adc1_dio4   : std_logic;        -- 
		adc1_dio3   : std_logic;        -- 
		adc1_dio2   : std_logic;        -- 
		adc1_dio1   : std_logic;        -- 
		adc1_dio0   : std_logic;        -- 
	end record t_aeb1_gcfg_adc1_config_wr_reg;

	-- AEB 1 General Configuration Area
	type t_aeb1_gcfg_adc2_config_wr_reg is record
		adc2_bypas  : std_logic;        -- 
		adc2_clkenb : std_logic;        -- 
		adc2_chop   : std_logic;        -- 
		adc2_stat   : std_logic;        -- 
		adc2_idlmod : std_logic;        -- 
		adc2_dly2   : std_logic;        -- 
		adc2_dly1   : std_logic;        -- 
		adc2_dly0   : std_logic;        -- 
		adc2_sbcs1  : std_logic;        -- 
		adc2_sbcs0  : std_logic;        -- 
		adc2_drate1 : std_logic;        -- 
		adc2_drate0 : std_logic;        -- 
		adc2_ainp3  : std_logic;        -- 
		adc2_ainp2  : std_logic;        -- 
		adc2_ainp1  : std_logic;        -- 
		adc2_ainp0  : std_logic;        -- 
		adc2_ainn3  : std_logic;        -- 
		adc2_ainn2  : std_logic;        -- 
		adc2_ainn1  : std_logic;        -- 
		adc2_ainn0  : std_logic;        -- 
		adc2_diff7  : std_logic;        -- 
		adc2_diff6  : std_logic;        -- 
		adc2_diff5  : std_logic;        -- 
		adc2_diff4  : std_logic;        -- 
		adc2_diff3  : std_logic;        -- 
		adc2_diff2  : std_logic;        -- 
		adc2_diff1  : std_logic;        -- 
		adc2_diff0  : std_logic;        -- 
		adc2_ain7   : std_logic;        -- 
		adc2_ain6   : std_logic;        -- 
		adc2_ain5   : std_logic;        -- 
		adc2_ain4   : std_logic;        -- 
		adc2_ain3   : std_logic;        -- 
		adc2_ain2   : std_logic;        -- 
		adc2_ain1   : std_logic;        -- 
		adc2_ain0   : std_logic;        -- 
		adc2_ain15  : std_logic;        -- 
		adc2_ain14  : std_logic;        -- 
		adc2_ain13  : std_logic;        -- 
		adc2_ain12  : std_logic;        -- 
		adc2_ain11  : std_logic;        -- 
		adc2_ain10  : std_logic;        -- 
		adc2_ain9   : std_logic;        -- 
		adc2_ain8   : std_logic;        -- 
		adc2_ref    : std_logic;        -- 
		adc2_gain   : std_logic;        -- 
		adc2_temp   : std_logic;        -- 
		adc2_vcc    : std_logic;        -- 
		adc2_offset : std_logic;        -- 
		adc2_cio7   : std_logic;        -- 
		adc2_cio6   : std_logic;        -- 
		adc2_cio5   : std_logic;        -- 
		adc2_cio4   : std_logic;        -- 
		adc2_cio3   : std_logic;        -- 
		adc2_cio2   : std_logic;        -- 
		adc2_cio1   : std_logic;        -- 
		adc2_cio0   : std_logic;        -- 
		adc2_dio7   : std_logic;        -- 
		adc2_dio6   : std_logic;        -- 
		adc2_dio5   : std_logic;        -- 
		adc2_dio4   : std_logic;        -- 
		adc2_dio3   : std_logic;        -- 
		adc2_dio2   : std_logic;        -- 
		adc2_dio1   : std_logic;        -- 
		adc2_dio0   : std_logic;        -- 
	end record t_aeb1_gcfg_adc2_config_wr_reg;

	-- AEB 1 General Configuration Area
	type t_aeb1_gcfg_seq_config_wr_reg is record
		seq_oe             : std_logic_vector(21 downto 0); -- 
		adc_clk_div        : std_logic_vector(6 downto 0); -- 
		cds_clk_low_pos    : std_logic_vector(7 downto 0); -- 
		cds_clk_high_pos   : std_logic_vector(7 downto 0); -- 
		rphir_clk_low_pos  : std_logic_vector(7 downto 0); -- 
		rphir_clk_high_pos : std_logic_vector(7 downto 0); -- 
		ft_loop_cnt        : std_logic_vector(13 downto 0); -- 
		lt0_enabled        : std_logic; -- 
		lt0_pixreadout     : std_logic; -- 
		lt0_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt1_enabled        : std_logic; -- 
		lt1_pixreadout     : std_logic; -- 
		lt1_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt2_enabled        : std_logic; -- 
		lt2_pixreadout     : std_logic; -- 
		lt2_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt3_enabled        : std_logic; -- 
		lt3_pixreadout     : std_logic; -- 
		lt3_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pix_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pc_enabled         : std_logic; -- 
		pc_loop_cnt        : std_logic_vector(13 downto 0); -- 
		int1_loop_cnt      : std_logic_vector(13 downto 0); -- 
		int2_loop_cnt      : std_logic_vector(13 downto 0); -- 
	end record t_aeb1_gcfg_seq_config_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_aeb_status_wr_reg is record
		aeb_state      : std_logic_vector(2 downto 0); -- 
		vasp2_cfg_run  : std_logic;     -- 
		vasp1_cfg_run  : std_logic;     -- 
		dac_cfg_w_run  : std_logic;     -- 
		adc_cfg_rd_run : std_logic;     -- 
		adc_cfg_wr_run : std_logic;     -- 
		adc_dat_rd_run : std_logic;     -- 
		adc_error      : std_logic;     -- 
		adc2_lu        : std_logic;     -- 
		adc1_lu        : std_logic;     -- 
		adc_dat_rd     : std_logic;     -- 
		adc_cfg_rd     : std_logic;     -- 
		adc_cfg_wr     : std_logic;     -- 
		adc2_busy      : std_logic;     -- 
		adc1_busy      : std_logic;     -- 
		frame_counter  : std_logic_vector(15 downto 0); -- 
	end record t_aeb1_hk_aeb_status_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_timestamp_wr_reg is record
		timestamp_1 : std_logic_vector(31 downto 0); -- 
		timestamp_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb1_hk_timestamp_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_adc_rd_data_wr_reg is record
		adc_rd_data_18 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_17 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_16 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_15 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_14 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_13 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_12 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_11 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_10 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_9  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_8  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_7  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_6  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_5  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_4  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_3  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_2  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_1  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_0  : std_logic_vector(31 downto 0); -- 
	end record t_aeb1_hk_adc_rd_data_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_adc1_rd_config_wr_reg is record
		adc1_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb1_hk_adc1_rd_config_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_adc2_rd_config_wr_reg is record
		adc2_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb1_hk_adc2_rd_config_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_vasp_rd_config_wr_reg is record
		vasp1_read_data : std_logic_vector(7 downto 0); -- 
		vasp2_read_data : std_logic_vector(7 downto 0); -- 
	end record t_aeb1_hk_vasp_rd_config_wr_reg;

	-- AEB 1 Housekeeping Area
	type t_aeb1_hk_revision_id_wr_reg is record
		fpga_ver  : std_logic_vector(15 downto 0); -- 
		fpga_date : std_logic_vector(15 downto 0); -- 
		fpga_time : std_logic_vector(15 downto 0); -- 
		fpga_svn  : std_logic_vector(15 downto 0); -- 
	end record t_aeb1_hk_revision_id_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_aeb_control_wr_reg is record
		new_state   : std_logic_vector(4 downto 0); -- 
		set_state   : std_logic;        -- 
		aeb_reset   : std_logic;        -- 
		adc_data_rd : std_logic;        -- 
		adc_cfg_wr  : std_logic;        -- 
		adc_cfg_rd  : std_logic;        -- 
		dac_wr      : std_logic;        -- 
	end record t_aeb2_ccfg_aeb_control_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_aeb_config_wr_reg is record
		watchdog_dis : std_logic;       -- 
		int_sync     : std_logic;       -- 
		vasp_cds_en  : std_logic;       -- 
		vasp2_cal_en : std_logic;       -- 
		vasp1_cal_en : std_logic;       -- 
	end record t_aeb2_ccfg_aeb_config_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_aeb_config_key_wr_reg is record
		key : std_logic_vector(30 downto 0); -- 
	end record t_aeb2_ccfg_aeb_config_key_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_aeb_config_ait1_wr_reg is record
		override_sw     : std_logic;    -- 
		sw_van3         : std_logic;    -- 
		sw_van2         : std_logic;    -- 
		sw_van1         : std_logic;    -- 
		sw_vclk         : std_logic;    -- 
		sw_vccd         : std_logic;    -- 
		override_vasp   : std_logic;    -- 
		vasp2_pix_en    : std_logic;    -- 
		vasp1_pix_en    : std_logic;    -- 
		vasp2_adc_en    : std_logic;    -- 
		vasp1_adc_en    : std_logic;    -- 
		vasp2_reset     : std_logic;    -- 
		vasp1_reset     : std_logic;    -- 
		override_adc    : std_logic;    -- 
		adc2_en_p5v0    : std_logic;    -- 
		adc1_en_p5v0    : std_logic;    -- 
		pt1000_cal_on_n : std_logic;    -- 
		en_v_mux_n      : std_logic;    -- 
		adc2_pwdn_n     : std_logic;    -- 
		adc1_pwdn_n     : std_logic;    -- 
		adc_clk_en      : std_logic;    -- 
	end record t_aeb2_ccfg_aeb_config_ait1_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_aeb_config_pattern_wr_reg is record
		pattern_ccdid : std_logic_vector(1 downto 0); -- 
		pattern_cols  : std_logic_vector(13 downto 0); -- 
		pattern_rows  : std_logic_vector(13 downto 0); -- 
	end record t_aeb2_ccfg_aeb_config_pattern_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_vasp_i2c_control_wr_reg is record
		vasp_cfg_addr     : std_logic_vector(7 downto 0); -- 
		vasp1_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_select      : std_logic;  -- 
		vasp1_select      : std_logic;  -- 
		calibration_start : std_logic;  -- 
		i2c_read_start    : std_logic;  -- 
		i2c_write_start   : std_logic;  -- 
	end record t_aeb2_ccfg_vasp_i2c_control_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_dac_config_1_wr_reg is record
		dac_vog : std_logic_vector(11 downto 0); -- 
		dac_vrd : std_logic_vector(11 downto 0); -- 
	end record t_aeb2_ccfg_dac_config_1_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_dac_config_2_wr_reg is record
		dac_vod : std_logic_vector(11 downto 0); -- 
	end record t_aeb2_ccfg_dac_config_2_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_pwr_config1_wr_reg is record
		time_vccd_on : std_logic_vector(7 downto 0); -- 
		time_vclk_on : std_logic_vector(7 downto 0); -- 
		time_van1_on : std_logic_vector(7 downto 0); -- 
		time_van2_on : std_logic_vector(7 downto 0); -- 
	end record t_aeb2_ccfg_pwr_config1_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_pwr_config2_wr_reg is record
		time_van3_on  : std_logic_vector(7 downto 0); -- 
		time_vccd_off : std_logic_vector(7 downto 0); -- 
		time_vclk_off : std_logic_vector(7 downto 0); -- 
		time_van1_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb2_ccfg_pwr_config2_wr_reg;

	-- AEB 2 Critical Configuration Area
	type t_aeb2_ccfg_pwr_config3_wr_reg is record
		time_van2_off : std_logic_vector(7 downto 0); -- 
		time_van3_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb2_ccfg_pwr_config3_wr_reg;

	-- AEB 2 General Configuration Area
	type t_aeb2_gcfg_adc1_config_wr_reg is record
		adc1_bypas  : std_logic;        -- 
		adc1_clkenb : std_logic;        -- 
		adc1_chop   : std_logic;        -- 
		adc1_stat   : std_logic;        -- 
		adc1_idlmod : std_logic;        -- 
		adc1_dly2   : std_logic;        -- 
		adc1_dly1   : std_logic;        -- 
		adc1_dly0   : std_logic;        -- 
		adc1_sbcs1  : std_logic;        -- 
		adc1_sbcs0  : std_logic;        -- 
		adc1_drate1 : std_logic;        -- 
		adc1_drate0 : std_logic;        -- 
		adc1_ainp3  : std_logic;        -- 
		adc1_ainp2  : std_logic;        -- 
		adc1_ainp1  : std_logic;        -- 
		adc1_ainp0  : std_logic;        -- 
		adc1_ainn3  : std_logic;        -- 
		adc1_ainn2  : std_logic;        -- 
		adc1_ainn1  : std_logic;        -- 
		adc1_ainn0  : std_logic;        -- 
		adc1_diff7  : std_logic;        -- 
		adc1_diff6  : std_logic;        -- 
		adc1_diff5  : std_logic;        -- 
		adc1_diff4  : std_logic;        -- 
		adc1_diff3  : std_logic;        -- 
		adc1_diff2  : std_logic;        -- 
		adc1_diff1  : std_logic;        -- 
		adc1_diff0  : std_logic;        -- 
		adc1_ain7   : std_logic;        -- 
		adc1_ain6   : std_logic;        -- 
		adc1_ain5   : std_logic;        -- 
		adc1_ain4   : std_logic;        -- 
		adc1_ain3   : std_logic;        -- 
		adc1_ain2   : std_logic;        -- 
		adc1_ain1   : std_logic;        -- 
		adc1_ain0   : std_logic;        -- 
		adc1_ain15  : std_logic;        -- 
		adc1_ain14  : std_logic;        -- 
		adc1_ain13  : std_logic;        -- 
		adc1_ain12  : std_logic;        -- 
		adc1_ain11  : std_logic;        -- 
		adc1_ain10  : std_logic;        -- 
		adc1_ain9   : std_logic;        -- 
		adc1_ain8   : std_logic;        -- 
		adc1_ref    : std_logic;        -- 
		adc1_gain   : std_logic;        -- 
		adc1_temp   : std_logic;        -- 
		adc1_vcc    : std_logic;        -- 
		adc1_offset : std_logic;        -- 
		adc1_cio7   : std_logic;        -- 
		adc1_cio6   : std_logic;        -- 
		adc1_cio5   : std_logic;        -- 
		adc1_cio4   : std_logic;        -- 
		adc1_cio3   : std_logic;        -- 
		adc1_cio2   : std_logic;        -- 
		adc1_cio1   : std_logic;        -- 
		adc1_cio0   : std_logic;        -- 
		adc1_dio7   : std_logic;        -- 
		adc1_dio6   : std_logic;        -- 
		adc1_dio5   : std_logic;        -- 
		adc1_dio4   : std_logic;        -- 
		adc1_dio3   : std_logic;        -- 
		adc1_dio2   : std_logic;        -- 
		adc1_dio1   : std_logic;        -- 
		adc1_dio0   : std_logic;        -- 
	end record t_aeb2_gcfg_adc1_config_wr_reg;

	-- AEB 2 General Configuration Area
	type t_aeb2_gcfg_adc2_config_wr_reg is record
		adc2_bypas  : std_logic;        -- 
		adc2_clkenb : std_logic;        -- 
		adc2_chop   : std_logic;        -- 
		adc2_stat   : std_logic;        -- 
		adc2_idlmod : std_logic;        -- 
		adc2_dly2   : std_logic;        -- 
		adc2_dly1   : std_logic;        -- 
		adc2_dly0   : std_logic;        -- 
		adc2_sbcs1  : std_logic;        -- 
		adc2_sbcs0  : std_logic;        -- 
		adc2_drate1 : std_logic;        -- 
		adc2_drate0 : std_logic;        -- 
		adc2_ainp3  : std_logic;        -- 
		adc2_ainp2  : std_logic;        -- 
		adc2_ainp1  : std_logic;        -- 
		adc2_ainp0  : std_logic;        -- 
		adc2_ainn3  : std_logic;        -- 
		adc2_ainn2  : std_logic;        -- 
		adc2_ainn1  : std_logic;        -- 
		adc2_ainn0  : std_logic;        -- 
		adc2_diff7  : std_logic;        -- 
		adc2_diff6  : std_logic;        -- 
		adc2_diff5  : std_logic;        -- 
		adc2_diff4  : std_logic;        -- 
		adc2_diff3  : std_logic;        -- 
		adc2_diff2  : std_logic;        -- 
		adc2_diff1  : std_logic;        -- 
		adc2_diff0  : std_logic;        -- 
		adc2_ain7   : std_logic;        -- 
		adc2_ain6   : std_logic;        -- 
		adc2_ain5   : std_logic;        -- 
		adc2_ain4   : std_logic;        -- 
		adc2_ain3   : std_logic;        -- 
		adc2_ain2   : std_logic;        -- 
		adc2_ain1   : std_logic;        -- 
		adc2_ain0   : std_logic;        -- 
		adc2_ain15  : std_logic;        -- 
		adc2_ain14  : std_logic;        -- 
		adc2_ain13  : std_logic;        -- 
		adc2_ain12  : std_logic;        -- 
		adc2_ain11  : std_logic;        -- 
		adc2_ain10  : std_logic;        -- 
		adc2_ain9   : std_logic;        -- 
		adc2_ain8   : std_logic;        -- 
		adc2_ref    : std_logic;        -- 
		adc2_gain   : std_logic;        -- 
		adc2_temp   : std_logic;        -- 
		adc2_vcc    : std_logic;        -- 
		adc2_offset : std_logic;        -- 
		adc2_cio7   : std_logic;        -- 
		adc2_cio6   : std_logic;        -- 
		adc2_cio5   : std_logic;        -- 
		adc2_cio4   : std_logic;        -- 
		adc2_cio3   : std_logic;        -- 
		adc2_cio2   : std_logic;        -- 
		adc2_cio1   : std_logic;        -- 
		adc2_cio0   : std_logic;        -- 
		adc2_dio7   : std_logic;        -- 
		adc2_dio6   : std_logic;        -- 
		adc2_dio5   : std_logic;        -- 
		adc2_dio4   : std_logic;        -- 
		adc2_dio3   : std_logic;        -- 
		adc2_dio2   : std_logic;        -- 
		adc2_dio1   : std_logic;        -- 
		adc2_dio0   : std_logic;        -- 
	end record t_aeb2_gcfg_adc2_config_wr_reg;

	-- AEB 2 General Configuration Area
	type t_aeb2_gcfg_seq_config_wr_reg is record
		seq_oe             : std_logic_vector(21 downto 0); -- 
		adc_clk_div        : std_logic_vector(6 downto 0); -- 
		cds_clk_low_pos    : std_logic_vector(7 downto 0); -- 
		cds_clk_high_pos   : std_logic_vector(7 downto 0); -- 
		rphir_clk_low_pos  : std_logic_vector(7 downto 0); -- 
		rphir_clk_high_pos : std_logic_vector(7 downto 0); -- 
		ft_loop_cnt        : std_logic_vector(13 downto 0); -- 
		lt0_enabled        : std_logic; -- 
		lt0_pixreadout     : std_logic; -- 
		lt0_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt1_enabled        : std_logic; -- 
		lt1_pixreadout     : std_logic; -- 
		lt1_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt2_enabled        : std_logic; -- 
		lt2_pixreadout     : std_logic; -- 
		lt2_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt3_enabled        : std_logic; -- 
		lt3_pixreadout     : std_logic; -- 
		lt3_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pix_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pc_enabled         : std_logic; -- 
		pc_loop_cnt        : std_logic_vector(13 downto 0); -- 
		int1_loop_cnt      : std_logic_vector(13 downto 0); -- 
		int2_loop_cnt      : std_logic_vector(13 downto 0); -- 
	end record t_aeb2_gcfg_seq_config_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_aeb_status_wr_reg is record
		aeb_state      : std_logic_vector(2 downto 0); -- 
		vasp2_cfg_run  : std_logic;     -- 
		vasp1_cfg_run  : std_logic;     -- 
		dac_cfg_w_run  : std_logic;     -- 
		adc_cfg_rd_run : std_logic;     -- 
		adc_cfg_wr_run : std_logic;     -- 
		adc_dat_rd_run : std_logic;     -- 
		adc_error      : std_logic;     -- 
		adc2_lu        : std_logic;     -- 
		adc1_lu        : std_logic;     -- 
		adc_dat_rd     : std_logic;     -- 
		adc_cfg_rd     : std_logic;     -- 
		adc_cfg_wr     : std_logic;     -- 
		adc2_busy      : std_logic;     -- 
		adc1_busy      : std_logic;     -- 
		frame_counter  : std_logic_vector(15 downto 0); -- 
	end record t_aeb2_hk_aeb_status_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_timestamp_wr_reg is record
		timestamp_1 : std_logic_vector(31 downto 0); -- 
		timestamp_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb2_hk_timestamp_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_adc_rd_data_wr_reg is record
		adc_rd_data_18 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_17 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_16 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_15 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_14 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_13 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_12 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_11 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_10 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_9  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_8  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_7  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_6  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_5  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_4  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_3  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_2  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_1  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_0  : std_logic_vector(31 downto 0); -- 
	end record t_aeb2_hk_adc_rd_data_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_adc1_rd_config_wr_reg is record
		adc1_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb2_hk_adc1_rd_config_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_adc2_rd_config_wr_reg is record
		adc2_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb2_hk_adc2_rd_config_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_vasp_rd_config_wr_reg is record
		vasp1_read_data : std_logic_vector(7 downto 0); -- 
		vasp2_read_data : std_logic_vector(7 downto 0); -- 
	end record t_aeb2_hk_vasp_rd_config_wr_reg;

	-- AEB 2 Housekeeping Area
	type t_aeb2_hk_revision_id_wr_reg is record
		fpga_ver  : std_logic_vector(15 downto 0); -- 
		fpga_date : std_logic_vector(15 downto 0); -- 
		fpga_time : std_logic_vector(15 downto 0); -- 
		fpga_svn  : std_logic_vector(15 downto 0); -- 
	end record t_aeb2_hk_revision_id_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_aeb_control_wr_reg is record
		new_state   : std_logic_vector(4 downto 0); -- 
		set_state   : std_logic;        -- 
		aeb_reset   : std_logic;        -- 
		adc_data_rd : std_logic;        -- 
		adc_cfg_wr  : std_logic;        -- 
		adc_cfg_rd  : std_logic;        -- 
		dac_wr      : std_logic;        -- 
	end record t_aeb3_ccfg_aeb_control_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_aeb_config_wr_reg is record
		watchdog_dis : std_logic;       -- 
		int_sync     : std_logic;       -- 
		vasp_cds_en  : std_logic;       -- 
		vasp2_cal_en : std_logic;       -- 
		vasp1_cal_en : std_logic;       -- 
	end record t_aeb3_ccfg_aeb_config_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_aeb_config_key_wr_reg is record
		key : std_logic_vector(30 downto 0); -- 
	end record t_aeb3_ccfg_aeb_config_key_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_aeb_config_ait1_wr_reg is record
		override_sw     : std_logic;    -- 
		sw_van3         : std_logic;    -- 
		sw_van2         : std_logic;    -- 
		sw_van1         : std_logic;    -- 
		sw_vclk         : std_logic;    -- 
		sw_vccd         : std_logic;    -- 
		override_vasp   : std_logic;    -- 
		vasp2_pix_en    : std_logic;    -- 
		vasp1_pix_en    : std_logic;    -- 
		vasp2_adc_en    : std_logic;    -- 
		vasp1_adc_en    : std_logic;    -- 
		vasp2_reset     : std_logic;    -- 
		vasp1_reset     : std_logic;    -- 
		override_adc    : std_logic;    -- 
		adc2_en_p5v0    : std_logic;    -- 
		adc1_en_p5v0    : std_logic;    -- 
		pt1000_cal_on_n : std_logic;    -- 
		en_v_mux_n      : std_logic;    -- 
		adc2_pwdn_n     : std_logic;    -- 
		adc1_pwdn_n     : std_logic;    -- 
		adc_clk_en      : std_logic;    -- 
	end record t_aeb3_ccfg_aeb_config_ait1_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_aeb_config_pattern_wr_reg is record
		pattern_ccdid : std_logic_vector(1 downto 0); -- 
		pattern_cols  : std_logic_vector(13 downto 0); -- 
		pattern_rows  : std_logic_vector(13 downto 0); -- 
	end record t_aeb3_ccfg_aeb_config_pattern_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_vasp_i2c_control_wr_reg is record
		vasp_cfg_addr     : std_logic_vector(7 downto 0); -- 
		vasp1_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_select      : std_logic;  -- 
		vasp1_select      : std_logic;  -- 
		calibration_start : std_logic;  -- 
		i2c_read_start    : std_logic;  -- 
		i2c_write_start   : std_logic;  -- 
	end record t_aeb3_ccfg_vasp_i2c_control_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_dac_config_1_wr_reg is record
		dac_vog : std_logic_vector(11 downto 0); -- 
		dac_vrd : std_logic_vector(11 downto 0); -- 
	end record t_aeb3_ccfg_dac_config_1_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_dac_config_2_wr_reg is record
		dac_vod : std_logic_vector(11 downto 0); -- 
	end record t_aeb3_ccfg_dac_config_2_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_pwr_config1_wr_reg is record
		time_vccd_on : std_logic_vector(7 downto 0); -- 
		time_vclk_on : std_logic_vector(7 downto 0); -- 
		time_van1_on : std_logic_vector(7 downto 0); -- 
		time_van2_on : std_logic_vector(7 downto 0); -- 
	end record t_aeb3_ccfg_pwr_config1_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_pwr_config2_wr_reg is record
		time_van3_on  : std_logic_vector(7 downto 0); -- 
		time_vccd_off : std_logic_vector(7 downto 0); -- 
		time_vclk_off : std_logic_vector(7 downto 0); -- 
		time_van1_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb3_ccfg_pwr_config2_wr_reg;

	-- AEB 3 Critical Configuration Area
	type t_aeb3_ccfg_pwr_config3_wr_reg is record
		time_van2_off : std_logic_vector(7 downto 0); -- 
		time_van3_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb3_ccfg_pwr_config3_wr_reg;

	-- AEB 3 General Configuration Area
	type t_aeb3_gcfg_adc1_config_wr_reg is record
		adc1_bypas  : std_logic;        -- 
		adc1_clkenb : std_logic;        -- 
		adc1_chop   : std_logic;        -- 
		adc1_stat   : std_logic;        -- 
		adc1_idlmod : std_logic;        -- 
		adc1_dly2   : std_logic;        -- 
		adc1_dly1   : std_logic;        -- 
		adc1_dly0   : std_logic;        -- 
		adc1_sbcs1  : std_logic;        -- 
		adc1_sbcs0  : std_logic;        -- 
		adc1_drate1 : std_logic;        -- 
		adc1_drate0 : std_logic;        -- 
		adc1_ainp3  : std_logic;        -- 
		adc1_ainp2  : std_logic;        -- 
		adc1_ainp1  : std_logic;        -- 
		adc1_ainp0  : std_logic;        -- 
		adc1_ainn3  : std_logic;        -- 
		adc1_ainn2  : std_logic;        -- 
		adc1_ainn1  : std_logic;        -- 
		adc1_ainn0  : std_logic;        -- 
		adc1_diff7  : std_logic;        -- 
		adc1_diff6  : std_logic;        -- 
		adc1_diff5  : std_logic;        -- 
		adc1_diff4  : std_logic;        -- 
		adc1_diff3  : std_logic;        -- 
		adc1_diff2  : std_logic;        -- 
		adc1_diff1  : std_logic;        -- 
		adc1_diff0  : std_logic;        -- 
		adc1_ain7   : std_logic;        -- 
		adc1_ain6   : std_logic;        -- 
		adc1_ain5   : std_logic;        -- 
		adc1_ain4   : std_logic;        -- 
		adc1_ain3   : std_logic;        -- 
		adc1_ain2   : std_logic;        -- 
		adc1_ain1   : std_logic;        -- 
		adc1_ain0   : std_logic;        -- 
		adc1_ain15  : std_logic;        -- 
		adc1_ain14  : std_logic;        -- 
		adc1_ain13  : std_logic;        -- 
		adc1_ain12  : std_logic;        -- 
		adc1_ain11  : std_logic;        -- 
		adc1_ain10  : std_logic;        -- 
		adc1_ain9   : std_logic;        -- 
		adc1_ain8   : std_logic;        -- 
		adc1_ref    : std_logic;        -- 
		adc1_gain   : std_logic;        -- 
		adc1_temp   : std_logic;        -- 
		adc1_vcc    : std_logic;        -- 
		adc1_offset : std_logic;        -- 
		adc1_cio7   : std_logic;        -- 
		adc1_cio6   : std_logic;        -- 
		adc1_cio5   : std_logic;        -- 
		adc1_cio4   : std_logic;        -- 
		adc1_cio3   : std_logic;        -- 
		adc1_cio2   : std_logic;        -- 
		adc1_cio1   : std_logic;        -- 
		adc1_cio0   : std_logic;        -- 
		adc1_dio7   : std_logic;        -- 
		adc1_dio6   : std_logic;        -- 
		adc1_dio5   : std_logic;        -- 
		adc1_dio4   : std_logic;        -- 
		adc1_dio3   : std_logic;        -- 
		adc1_dio2   : std_logic;        -- 
		adc1_dio1   : std_logic;        -- 
		adc1_dio0   : std_logic;        -- 
	end record t_aeb3_gcfg_adc1_config_wr_reg;

	-- AEB 3 General Configuration Area
	type t_aeb3_gcfg_adc2_config_wr_reg is record
		adc2_bypas  : std_logic;        -- 
		adc2_clkenb : std_logic;        -- 
		adc2_chop   : std_logic;        -- 
		adc2_stat   : std_logic;        -- 
		adc2_idlmod : std_logic;        -- 
		adc2_dly2   : std_logic;        -- 
		adc2_dly1   : std_logic;        -- 
		adc2_dly0   : std_logic;        -- 
		adc2_sbcs1  : std_logic;        -- 
		adc2_sbcs0  : std_logic;        -- 
		adc2_drate1 : std_logic;        -- 
		adc2_drate0 : std_logic;        -- 
		adc2_ainp3  : std_logic;        -- 
		adc2_ainp2  : std_logic;        -- 
		adc2_ainp1  : std_logic;        -- 
		adc2_ainp0  : std_logic;        -- 
		adc2_ainn3  : std_logic;        -- 
		adc2_ainn2  : std_logic;        -- 
		adc2_ainn1  : std_logic;        -- 
		adc2_ainn0  : std_logic;        -- 
		adc2_diff7  : std_logic;        -- 
		adc2_diff6  : std_logic;        -- 
		adc2_diff5  : std_logic;        -- 
		adc2_diff4  : std_logic;        -- 
		adc2_diff3  : std_logic;        -- 
		adc2_diff2  : std_logic;        -- 
		adc2_diff1  : std_logic;        -- 
		adc2_diff0  : std_logic;        -- 
		adc2_ain7   : std_logic;        -- 
		adc2_ain6   : std_logic;        -- 
		adc2_ain5   : std_logic;        -- 
		adc2_ain4   : std_logic;        -- 
		adc2_ain3   : std_logic;        -- 
		adc2_ain2   : std_logic;        -- 
		adc2_ain1   : std_logic;        -- 
		adc2_ain0   : std_logic;        -- 
		adc2_ain15  : std_logic;        -- 
		adc2_ain14  : std_logic;        -- 
		adc2_ain13  : std_logic;        -- 
		adc2_ain12  : std_logic;        -- 
		adc2_ain11  : std_logic;        -- 
		adc2_ain10  : std_logic;        -- 
		adc2_ain9   : std_logic;        -- 
		adc2_ain8   : std_logic;        -- 
		adc2_ref    : std_logic;        -- 
		adc2_gain   : std_logic;        -- 
		adc2_temp   : std_logic;        -- 
		adc2_vcc    : std_logic;        -- 
		adc2_offset : std_logic;        -- 
		adc2_cio7   : std_logic;        -- 
		adc2_cio6   : std_logic;        -- 
		adc2_cio5   : std_logic;        -- 
		adc2_cio4   : std_logic;        -- 
		adc2_cio3   : std_logic;        -- 
		adc2_cio2   : std_logic;        -- 
		adc2_cio1   : std_logic;        -- 
		adc2_cio0   : std_logic;        -- 
		adc2_dio7   : std_logic;        -- 
		adc2_dio6   : std_logic;        -- 
		adc2_dio5   : std_logic;        -- 
		adc2_dio4   : std_logic;        -- 
		adc2_dio3   : std_logic;        -- 
		adc2_dio2   : std_logic;        -- 
		adc2_dio1   : std_logic;        -- 
		adc2_dio0   : std_logic;        -- 
	end record t_aeb3_gcfg_adc2_config_wr_reg;

	-- AEB 3 General Configuration Area
	type t_aeb3_gcfg_seq_config_wr_reg is record
		seq_oe             : std_logic_vector(21 downto 0); -- 
		adc_clk_div        : std_logic_vector(6 downto 0); -- 
		cds_clk_low_pos    : std_logic_vector(7 downto 0); -- 
		cds_clk_high_pos   : std_logic_vector(7 downto 0); -- 
		rphir_clk_low_pos  : std_logic_vector(7 downto 0); -- 
		rphir_clk_high_pos : std_logic_vector(7 downto 0); -- 
		ft_loop_cnt        : std_logic_vector(13 downto 0); -- 
		lt0_enabled        : std_logic; -- 
		lt0_pixreadout     : std_logic; -- 
		lt0_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt1_enabled        : std_logic; -- 
		lt1_pixreadout     : std_logic; -- 
		lt1_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt2_enabled        : std_logic; -- 
		lt2_pixreadout     : std_logic; -- 
		lt2_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt3_enabled        : std_logic; -- 
		lt3_pixreadout     : std_logic; -- 
		lt3_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pix_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pc_enabled         : std_logic; -- 
		pc_loop_cnt        : std_logic_vector(13 downto 0); -- 
		int1_loop_cnt      : std_logic_vector(13 downto 0); -- 
		int2_loop_cnt      : std_logic_vector(13 downto 0); -- 
	end record t_aeb3_gcfg_seq_config_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_aeb_status_wr_reg is record
		aeb_state      : std_logic_vector(2 downto 0); -- 
		vasp2_cfg_run  : std_logic;     -- 
		vasp1_cfg_run  : std_logic;     -- 
		dac_cfg_w_run  : std_logic;     -- 
		adc_cfg_rd_run : std_logic;     -- 
		adc_cfg_wr_run : std_logic;     -- 
		adc_dat_rd_run : std_logic;     -- 
		adc_error      : std_logic;     -- 
		adc2_lu        : std_logic;     -- 
		adc1_lu        : std_logic;     -- 
		adc_dat_rd     : std_logic;     -- 
		adc_cfg_rd     : std_logic;     -- 
		adc_cfg_wr     : std_logic;     -- 
		adc2_busy      : std_logic;     -- 
		adc1_busy      : std_logic;     -- 
		frame_counter  : std_logic_vector(15 downto 0); -- 
	end record t_aeb3_hk_aeb_status_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_timestamp_wr_reg is record
		timestamp_1 : std_logic_vector(31 downto 0); -- 
		timestamp_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb3_hk_timestamp_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_adc_rd_data_wr_reg is record
		adc_rd_data_18 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_17 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_16 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_15 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_14 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_13 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_12 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_11 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_10 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_9  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_8  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_7  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_6  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_5  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_4  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_3  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_2  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_1  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_0  : std_logic_vector(31 downto 0); -- 
	end record t_aeb3_hk_adc_rd_data_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_adc1_rd_config_wr_reg is record
		adc1_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb3_hk_adc1_rd_config_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_adc2_rd_config_wr_reg is record
		adc2_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb3_hk_adc2_rd_config_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_vasp_rd_config_wr_reg is record
		vasp1_read_data : std_logic_vector(7 downto 0); -- 
		vasp2_read_data : std_logic_vector(7 downto 0); -- 
	end record t_aeb3_hk_vasp_rd_config_wr_reg;

	-- AEB 3 Housekeeping Area
	type t_aeb3_hk_revision_id_wr_reg is record
		fpga_ver  : std_logic_vector(15 downto 0); -- 
		fpga_date : std_logic_vector(15 downto 0); -- 
		fpga_time : std_logic_vector(15 downto 0); -- 
		fpga_svn  : std_logic_vector(15 downto 0); -- 
	end record t_aeb3_hk_revision_id_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_aeb_control_wr_reg is record
		new_state   : std_logic_vector(4 downto 0); -- 
		set_state   : std_logic;        -- 
		aeb_reset   : std_logic;        -- 
		adc_data_rd : std_logic;        -- 
		adc_cfg_wr  : std_logic;        -- 
		adc_cfg_rd  : std_logic;        -- 
		dac_wr      : std_logic;        -- 
	end record t_aeb4_ccfg_aeb_control_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_aeb_config_wr_reg is record
		watchdog_dis : std_logic;       -- 
		int_sync     : std_logic;       -- 
		vasp_cds_en  : std_logic;       -- 
		vasp2_cal_en : std_logic;       -- 
		vasp1_cal_en : std_logic;       -- 
	end record t_aeb4_ccfg_aeb_config_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_aeb_config_key_wr_reg is record
		key : std_logic_vector(30 downto 0); -- 
	end record t_aeb4_ccfg_aeb_config_key_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_aeb_config_ait1_wr_reg is record
		override_sw     : std_logic;    -- 
		sw_van3         : std_logic;    -- 
		sw_van2         : std_logic;    -- 
		sw_van1         : std_logic;    -- 
		sw_vclk         : std_logic;    -- 
		sw_vccd         : std_logic;    -- 
		override_vasp   : std_logic;    -- 
		vasp2_pix_en    : std_logic;    -- 
		vasp1_pix_en    : std_logic;    -- 
		vasp2_adc_en    : std_logic;    -- 
		vasp1_adc_en    : std_logic;    -- 
		vasp2_reset     : std_logic;    -- 
		vasp1_reset     : std_logic;    -- 
		override_adc    : std_logic;    -- 
		adc2_en_p5v0    : std_logic;    -- 
		adc1_en_p5v0    : std_logic;    -- 
		pt1000_cal_on_n : std_logic;    -- 
		en_v_mux_n      : std_logic;    -- 
		adc2_pwdn_n     : std_logic;    -- 
		adc1_pwdn_n     : std_logic;    -- 
		adc_clk_en      : std_logic;    -- 
	end record t_aeb4_ccfg_aeb_config_ait1_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_aeb_config_pattern_wr_reg is record
		pattern_ccdid : std_logic_vector(1 downto 0); -- 
		pattern_cols  : std_logic_vector(13 downto 0); -- 
		pattern_rows  : std_logic_vector(13 downto 0); -- 
	end record t_aeb4_ccfg_aeb_config_pattern_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_vasp_i2c_control_wr_reg is record
		vasp_cfg_addr     : std_logic_vector(7 downto 0); -- 
		vasp1_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_cfg_data    : std_logic_vector(7 downto 0); -- 
		vasp2_select      : std_logic;  -- 
		vasp1_select      : std_logic;  -- 
		calibration_start : std_logic;  -- 
		i2c_read_start    : std_logic;  -- 
		i2c_write_start   : std_logic;  -- 
	end record t_aeb4_ccfg_vasp_i2c_control_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_dac_config_1_wr_reg is record
		dac_vog : std_logic_vector(11 downto 0); -- 
		dac_vrd : std_logic_vector(11 downto 0); -- 
	end record t_aeb4_ccfg_dac_config_1_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_dac_config_2_wr_reg is record
		dac_vod : std_logic_vector(11 downto 0); -- 
	end record t_aeb4_ccfg_dac_config_2_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_pwr_config1_wr_reg is record
		time_vccd_on : std_logic_vector(7 downto 0); -- 
		time_vclk_on : std_logic_vector(7 downto 0); -- 
		time_van1_on : std_logic_vector(7 downto 0); -- 
		time_van2_on : std_logic_vector(7 downto 0); -- 
	end record t_aeb4_ccfg_pwr_config1_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_pwr_config2_wr_reg is record
		time_van3_on  : std_logic_vector(7 downto 0); -- 
		time_vccd_off : std_logic_vector(7 downto 0); -- 
		time_vclk_off : std_logic_vector(7 downto 0); -- 
		time_van1_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb4_ccfg_pwr_config2_wr_reg;

	-- AEB 4 Critical Configuration Area
	type t_aeb4_ccfg_pwr_config3_wr_reg is record
		time_van2_off : std_logic_vector(7 downto 0); -- 
		time_van3_off : std_logic_vector(7 downto 0); -- 
	end record t_aeb4_ccfg_pwr_config3_wr_reg;

	-- AEB 4 General Configuration Area
	type t_aeb4_gcfg_adc1_config_wr_reg is record
		adc1_bypas  : std_logic;        -- 
		adc1_clkenb : std_logic;        -- 
		adc1_chop   : std_logic;        -- 
		adc1_stat   : std_logic;        -- 
		adc1_idlmod : std_logic;        -- 
		adc1_dly2   : std_logic;        -- 
		adc1_dly1   : std_logic;        -- 
		adc1_dly0   : std_logic;        -- 
		adc1_sbcs1  : std_logic;        -- 
		adc1_sbcs0  : std_logic;        -- 
		adc1_drate1 : std_logic;        -- 
		adc1_drate0 : std_logic;        -- 
		adc1_ainp3  : std_logic;        -- 
		adc1_ainp2  : std_logic;        -- 
		adc1_ainp1  : std_logic;        -- 
		adc1_ainp0  : std_logic;        -- 
		adc1_ainn3  : std_logic;        -- 
		adc1_ainn2  : std_logic;        -- 
		adc1_ainn1  : std_logic;        -- 
		adc1_ainn0  : std_logic;        -- 
		adc1_diff7  : std_logic;        -- 
		adc1_diff6  : std_logic;        -- 
		adc1_diff5  : std_logic;        -- 
		adc1_diff4  : std_logic;        -- 
		adc1_diff3  : std_logic;        -- 
		adc1_diff2  : std_logic;        -- 
		adc1_diff1  : std_logic;        -- 
		adc1_diff0  : std_logic;        -- 
		adc1_ain7   : std_logic;        -- 
		adc1_ain6   : std_logic;        -- 
		adc1_ain5   : std_logic;        -- 
		adc1_ain4   : std_logic;        -- 
		adc1_ain3   : std_logic;        -- 
		adc1_ain2   : std_logic;        -- 
		adc1_ain1   : std_logic;        -- 
		adc1_ain0   : std_logic;        -- 
		adc1_ain15  : std_logic;        -- 
		adc1_ain14  : std_logic;        -- 
		adc1_ain13  : std_logic;        -- 
		adc1_ain12  : std_logic;        -- 
		adc1_ain11  : std_logic;        -- 
		adc1_ain10  : std_logic;        -- 
		adc1_ain9   : std_logic;        -- 
		adc1_ain8   : std_logic;        -- 
		adc1_ref    : std_logic;        -- 
		adc1_gain   : std_logic;        -- 
		adc1_temp   : std_logic;        -- 
		adc1_vcc    : std_logic;        -- 
		adc1_offset : std_logic;        -- 
		adc1_cio7   : std_logic;        -- 
		adc1_cio6   : std_logic;        -- 
		adc1_cio5   : std_logic;        -- 
		adc1_cio4   : std_logic;        -- 
		adc1_cio3   : std_logic;        -- 
		adc1_cio2   : std_logic;        -- 
		adc1_cio1   : std_logic;        -- 
		adc1_cio0   : std_logic;        -- 
		adc1_dio7   : std_logic;        -- 
		adc1_dio6   : std_logic;        -- 
		adc1_dio5   : std_logic;        -- 
		adc1_dio4   : std_logic;        -- 
		adc1_dio3   : std_logic;        -- 
		adc1_dio2   : std_logic;        -- 
		adc1_dio1   : std_logic;        -- 
		adc1_dio0   : std_logic;        -- 
	end record t_aeb4_gcfg_adc1_config_wr_reg;

	-- AEB 4 General Configuration Area
	type t_aeb4_gcfg_adc2_config_wr_reg is record
		adc2_bypas  : std_logic;        -- 
		adc2_clkenb : std_logic;        -- 
		adc2_chop   : std_logic;        -- 
		adc2_stat   : std_logic;        -- 
		adc2_idlmod : std_logic;        -- 
		adc2_dly2   : std_logic;        -- 
		adc2_dly1   : std_logic;        -- 
		adc2_dly0   : std_logic;        -- 
		adc2_sbcs1  : std_logic;        -- 
		adc2_sbcs0  : std_logic;        -- 
		adc2_drate1 : std_logic;        -- 
		adc2_drate0 : std_logic;        -- 
		adc2_ainp3  : std_logic;        -- 
		adc2_ainp2  : std_logic;        -- 
		adc2_ainp1  : std_logic;        -- 
		adc2_ainp0  : std_logic;        -- 
		adc2_ainn3  : std_logic;        -- 
		adc2_ainn2  : std_logic;        -- 
		adc2_ainn1  : std_logic;        -- 
		adc2_ainn0  : std_logic;        -- 
		adc2_diff7  : std_logic;        -- 
		adc2_diff6  : std_logic;        -- 
		adc2_diff5  : std_logic;        -- 
		adc2_diff4  : std_logic;        -- 
		adc2_diff3  : std_logic;        -- 
		adc2_diff2  : std_logic;        -- 
		adc2_diff1  : std_logic;        -- 
		adc2_diff0  : std_logic;        -- 
		adc2_ain7   : std_logic;        -- 
		adc2_ain6   : std_logic;        -- 
		adc2_ain5   : std_logic;        -- 
		adc2_ain4   : std_logic;        -- 
		adc2_ain3   : std_logic;        -- 
		adc2_ain2   : std_logic;        -- 
		adc2_ain1   : std_logic;        -- 
		adc2_ain0   : std_logic;        -- 
		adc2_ain15  : std_logic;        -- 
		adc2_ain14  : std_logic;        -- 
		adc2_ain13  : std_logic;        -- 
		adc2_ain12  : std_logic;        -- 
		adc2_ain11  : std_logic;        -- 
		adc2_ain10  : std_logic;        -- 
		adc2_ain9   : std_logic;        -- 
		adc2_ain8   : std_logic;        -- 
		adc2_ref    : std_logic;        -- 
		adc2_gain   : std_logic;        -- 
		adc2_temp   : std_logic;        -- 
		adc2_vcc    : std_logic;        -- 
		adc2_offset : std_logic;        -- 
		adc2_cio7   : std_logic;        -- 
		adc2_cio6   : std_logic;        -- 
		adc2_cio5   : std_logic;        -- 
		adc2_cio4   : std_logic;        -- 
		adc2_cio3   : std_logic;        -- 
		adc2_cio2   : std_logic;        -- 
		adc2_cio1   : std_logic;        -- 
		adc2_cio0   : std_logic;        -- 
		adc2_dio7   : std_logic;        -- 
		adc2_dio6   : std_logic;        -- 
		adc2_dio5   : std_logic;        -- 
		adc2_dio4   : std_logic;        -- 
		adc2_dio3   : std_logic;        -- 
		adc2_dio2   : std_logic;        -- 
		adc2_dio1   : std_logic;        -- 
		adc2_dio0   : std_logic;        -- 
	end record t_aeb4_gcfg_adc2_config_wr_reg;

	-- AEB 4 General Configuration Area
	type t_aeb4_gcfg_seq_config_wr_reg is record
		seq_oe             : std_logic_vector(21 downto 0); -- 
		adc_clk_div        : std_logic_vector(6 downto 0); -- 
		cds_clk_low_pos    : std_logic_vector(7 downto 0); -- 
		cds_clk_high_pos   : std_logic_vector(7 downto 0); -- 
		rphir_clk_low_pos  : std_logic_vector(7 downto 0); -- 
		rphir_clk_high_pos : std_logic_vector(7 downto 0); -- 
		ft_loop_cnt        : std_logic_vector(13 downto 0); -- 
		lt0_enabled        : std_logic; -- 
		lt0_pixreadout     : std_logic; -- 
		lt0_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt1_enabled        : std_logic; -- 
		lt1_pixreadout     : std_logic; -- 
		lt1_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt2_enabled        : std_logic; -- 
		lt2_pixreadout     : std_logic; -- 
		lt2_loop_cnt       : std_logic_vector(13 downto 0); -- 
		lt3_enabled        : std_logic; -- 
		lt3_pixreadout     : std_logic; -- 
		lt3_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pix_loop_cnt       : std_logic_vector(13 downto 0); -- 
		pc_enabled         : std_logic; -- 
		pc_loop_cnt        : std_logic_vector(13 downto 0); -- 
		int1_loop_cnt      : std_logic_vector(13 downto 0); -- 
		int2_loop_cnt      : std_logic_vector(13 downto 0); -- 
	end record t_aeb4_gcfg_seq_config_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_aeb_status_wr_reg is record
		aeb_state      : std_logic_vector(2 downto 0); -- 
		vasp2_cfg_run  : std_logic;     -- 
		vasp1_cfg_run  : std_logic;     -- 
		dac_cfg_w_run  : std_logic;     -- 
		adc_cfg_rd_run : std_logic;     -- 
		adc_cfg_wr_run : std_logic;     -- 
		adc_dat_rd_run : std_logic;     -- 
		adc_error      : std_logic;     -- 
		adc2_lu        : std_logic;     -- 
		adc1_lu        : std_logic;     -- 
		adc_dat_rd     : std_logic;     -- 
		adc_cfg_rd     : std_logic;     -- 
		adc_cfg_wr     : std_logic;     -- 
		adc2_busy      : std_logic;     -- 
		adc1_busy      : std_logic;     -- 
		frame_counter  : std_logic_vector(15 downto 0); -- 
	end record t_aeb4_hk_aeb_status_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_timestamp_wr_reg is record
		timestamp_1 : std_logic_vector(31 downto 0); -- 
		timestamp_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb4_hk_timestamp_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_adc_rd_data_wr_reg is record
		adc_rd_data_18 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_17 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_16 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_15 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_14 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_13 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_12 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_11 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_10 : std_logic_vector(31 downto 0); -- 
		adc_rd_data_9  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_8  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_7  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_6  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_5  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_4  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_3  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_2  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_1  : std_logic_vector(31 downto 0); -- 
		adc_rd_data_0  : std_logic_vector(31 downto 0); -- 
	end record t_aeb4_hk_adc_rd_data_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_adc1_rd_config_wr_reg is record
		adc1_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc1_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb4_hk_adc1_rd_config_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_adc2_rd_config_wr_reg is record
		adc2_rd_config_3 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_2 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_1 : std_logic_vector(31 downto 0); -- 
		adc2_rd_config_0 : std_logic_vector(31 downto 0); -- 
	end record t_aeb4_hk_adc2_rd_config_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_vasp_rd_config_wr_reg is record
		vasp1_read_data : std_logic_vector(7 downto 0); -- 
		vasp2_read_data : std_logic_vector(7 downto 0); -- 
	end record t_aeb4_hk_vasp_rd_config_wr_reg;

	-- AEB 4 Housekeeping Area
	type t_aeb4_hk_revision_id_wr_reg is record
		fpga_ver  : std_logic_vector(15 downto 0); -- 
		fpga_date : std_logic_vector(15 downto 0); -- 
		fpga_time : std_logic_vector(15 downto 0); -- 
		fpga_svn  : std_logic_vector(15 downto 0); -- 
	end record t_aeb4_hk_revision_id_wr_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_rmap_memory_wr_area is record
		deb_ccfg_aeb_idx             : t_deb_ccfg_aeb_idx_wr_reg; -- DEB Critical Configuration Area
		deb_ccfg_reg_dta_3           : t_deb_ccfg_reg_dta_3_wr_reg; -- DEB Critical Configuration Area
		deb_ccfg_reg_dta_2           : t_deb_ccfg_reg_dta_2_wr_reg; -- DEB Critical Configuration Area
		deb_ccfg_reg_dta_1           : t_deb_ccfg_reg_dta_1_wr_reg; -- DEB Critical Configuration Area
		deb_ccfg_reg_dta_0           : t_deb_ccfg_reg_dta_0_wr_reg; -- DEB Critical Configuration Area
		deb_gcfg_oper_mod            : t_deb_gcfg_oper_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t7_in_mod           : t_deb_gcfg_t7_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t6_in_mod           : t_deb_gcfg_t6_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t5_in_mod           : t_deb_gcfg_t5_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t4_in_mod           : t_deb_gcfg_t4_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t3_in_mod           : t_deb_gcfg_t3_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t2_in_mod           : t_deb_gcfg_t2_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t1_in_mod           : t_deb_gcfg_t1_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_t0_in_mod           : t_deb_gcfg_t0_in_mod_wr_reg; -- DEB General Configuration Area
		deb_gcfg_w_siz_x             : t_deb_gcfg_w_siz_x_wr_reg; -- DEB General Configuration Area
		deb_gcfg_w_siz_y             : t_deb_gcfg_w_siz_y_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_idx_4           : t_deb_gcfg_wdw_idx_4_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_len_4           : t_deb_gcfg_wdw_len_4_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_idx_3           : t_deb_gcfg_wdw_idx_3_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_len_3           : t_deb_gcfg_wdw_len_3_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_idx_2           : t_deb_gcfg_wdw_idx_2_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_len_2           : t_deb_gcfg_wdw_len_2_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_idx_1           : t_deb_gcfg_wdw_idx_1_wr_reg; -- DEB General Configuration Area
		deb_gcfg_wdw_len_1           : t_deb_gcfg_wdw_len_1_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_lin_4           : t_deb_gcfg_ovs_lin_4_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_lin_3           : t_deb_gcfg_ovs_lin_3_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_lin_2           : t_deb_gcfg_ovs_lin_2_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_lin_1           : t_deb_gcfg_ovs_lin_1_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_pix_4           : t_deb_gcfg_ovs_pix_4_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_pix_3           : t_deb_gcfg_ovs_pix_3_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_pix_2           : t_deb_gcfg_ovs_pix_2_wr_reg; -- DEB General Configuration Area
		deb_gcfg_ovs_pix_1           : t_deb_gcfg_ovs_pix_1_wr_reg; -- DEB General Configuration Area
		deb_gcfg_2_5s_n_cyc          : t_deb_gcfg_2_5s_n_cyc_wr_reg; -- DEB General Configuration Area
		deb_gcfg_trg_src             : t_deb_gcfg_trg_src_wr_reg; -- DEB General Configuration Area
		deb_gcfg_frm_cnt             : t_deb_gcfg_frm_cnt_wr_reg; -- DEB General Configuration Area
		deb_gcfg_syn_frq             : t_deb_gcfg_syn_frq_wr_reg; -- DEB General Configuration Area
		deb_gcfg_rst_wdg             : t_deb_gcfg_rst_wdg_wr_reg; -- DEB General Configuration Area
		deb_gcfg_rst_cps             : t_deb_gcfg_rst_cps_wr_reg; -- DEB General Configuration Area
		deb_gcfg_25s_dly             : t_deb_gcfg_25s_dly_wr_reg; -- DEB General Configuration Area
		deb_gcfg_tmod_conf           : t_deb_gcfg_tmod_conf_wr_reg; -- DEB General Configuration Area
		deb_hk_deb_status            : t_deb_hk_deb_status_wr_reg; -- DEB Housekeeping Area
		deb_hk_deb_ovf               : t_deb_hk_deb_ovf_wr_reg; -- DEB Housekeeping Area
		deb_hk_spw_status            : t_deb_hk_spw_status_wr_reg; -- DEB Housekeeping Area
		deb_hk_deb_ahk1              : t_deb_hk_deb_ahk1_wr_reg; -- DEB Housekeeping Area
		deb_hk_deb_ahk2              : t_deb_hk_deb_ahk2_wr_reg; -- DEB Housekeeping Area
		deb_hk_deb_ahk3              : t_deb_hk_deb_ahk3_wr_reg; -- DEB Housekeeping Area
		aeb1_ccfg_aeb_control        : t_aeb1_ccfg_aeb_control_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_aeb_config         : t_aeb1_ccfg_aeb_config_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_aeb_config_key     : t_aeb1_ccfg_aeb_config_key_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_aeb_config_ait1    : t_aeb1_ccfg_aeb_config_ait1_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_aeb_config_pattern : t_aeb1_ccfg_aeb_config_pattern_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_vasp_i2c_control   : t_aeb1_ccfg_vasp_i2c_control_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_dac_config_1       : t_aeb1_ccfg_dac_config_1_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_dac_config_2       : t_aeb1_ccfg_dac_config_2_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_pwr_config1        : t_aeb1_ccfg_pwr_config1_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_pwr_config2        : t_aeb1_ccfg_pwr_config2_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_ccfg_pwr_config3        : t_aeb1_ccfg_pwr_config3_wr_reg; -- AEB 1 Critical Configuration Area
		aeb1_gcfg_adc1_config        : t_aeb1_gcfg_adc1_config_wr_reg; -- AEB 1 General Configuration Area
		aeb1_gcfg_adc2_config        : t_aeb1_gcfg_adc2_config_wr_reg; -- AEB 1 General Configuration Area
		aeb1_gcfg_seq_config         : t_aeb1_gcfg_seq_config_wr_reg; -- AEB 1 General Configuration Area
		aeb1_hk_aeb_status           : t_aeb1_hk_aeb_status_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_timestamp            : t_aeb1_hk_timestamp_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_adc_rd_data          : t_aeb1_hk_adc_rd_data_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_adc1_rd_config       : t_aeb1_hk_adc1_rd_config_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_adc2_rd_config       : t_aeb1_hk_adc2_rd_config_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_vasp_rd_config       : t_aeb1_hk_vasp_rd_config_wr_reg; -- AEB 1 Housekeeping Area
		aeb1_hk_revision_id          : t_aeb1_hk_revision_id_wr_reg; -- AEB 1 Housekeeping Area
		aeb2_ccfg_aeb_control        : t_aeb2_ccfg_aeb_control_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_aeb_config         : t_aeb2_ccfg_aeb_config_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_aeb_config_key     : t_aeb2_ccfg_aeb_config_key_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_aeb_config_ait1    : t_aeb2_ccfg_aeb_config_ait1_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_aeb_config_pattern : t_aeb2_ccfg_aeb_config_pattern_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_vasp_i2c_control   : t_aeb2_ccfg_vasp_i2c_control_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_dac_config_1       : t_aeb2_ccfg_dac_config_1_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_dac_config_2       : t_aeb2_ccfg_dac_config_2_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_pwr_config1        : t_aeb2_ccfg_pwr_config1_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_pwr_config2        : t_aeb2_ccfg_pwr_config2_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_ccfg_pwr_config3        : t_aeb2_ccfg_pwr_config3_wr_reg; -- AEB 2 Critical Configuration Area
		aeb2_gcfg_adc1_config        : t_aeb2_gcfg_adc1_config_wr_reg; -- AEB 2 General Configuration Area
		aeb2_gcfg_adc2_config        : t_aeb2_gcfg_adc2_config_wr_reg; -- AEB 2 General Configuration Area
		aeb2_gcfg_seq_config         : t_aeb2_gcfg_seq_config_wr_reg; -- AEB 2 General Configuration Area
		aeb2_hk_aeb_status           : t_aeb2_hk_aeb_status_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_timestamp            : t_aeb2_hk_timestamp_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_adc_rd_data          : t_aeb2_hk_adc_rd_data_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_adc1_rd_config       : t_aeb2_hk_adc1_rd_config_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_adc2_rd_config       : t_aeb2_hk_adc2_rd_config_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_vasp_rd_config       : t_aeb2_hk_vasp_rd_config_wr_reg; -- AEB 2 Housekeeping Area
		aeb2_hk_revision_id          : t_aeb2_hk_revision_id_wr_reg; -- AEB 2 Housekeeping Area
		aeb3_ccfg_aeb_control        : t_aeb3_ccfg_aeb_control_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_aeb_config         : t_aeb3_ccfg_aeb_config_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_aeb_config_key     : t_aeb3_ccfg_aeb_config_key_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_aeb_config_ait1    : t_aeb3_ccfg_aeb_config_ait1_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_aeb_config_pattern : t_aeb3_ccfg_aeb_config_pattern_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_vasp_i2c_control   : t_aeb3_ccfg_vasp_i2c_control_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_dac_config_1       : t_aeb3_ccfg_dac_config_1_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_dac_config_2       : t_aeb3_ccfg_dac_config_2_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_pwr_config1        : t_aeb3_ccfg_pwr_config1_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_pwr_config2        : t_aeb3_ccfg_pwr_config2_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_ccfg_pwr_config3        : t_aeb3_ccfg_pwr_config3_wr_reg; -- AEB 3 Critical Configuration Area
		aeb3_gcfg_adc1_config        : t_aeb3_gcfg_adc1_config_wr_reg; -- AEB 3 General Configuration Area
		aeb3_gcfg_adc2_config        : t_aeb3_gcfg_adc2_config_wr_reg; -- AEB 3 General Configuration Area
		aeb3_gcfg_seq_config         : t_aeb3_gcfg_seq_config_wr_reg; -- AEB 3 General Configuration Area
		aeb3_hk_aeb_status           : t_aeb3_hk_aeb_status_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_timestamp            : t_aeb3_hk_timestamp_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_adc_rd_data          : t_aeb3_hk_adc_rd_data_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_adc1_rd_config       : t_aeb3_hk_adc1_rd_config_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_adc2_rd_config       : t_aeb3_hk_adc2_rd_config_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_vasp_rd_config       : t_aeb3_hk_vasp_rd_config_wr_reg; -- AEB 3 Housekeeping Area
		aeb3_hk_revision_id          : t_aeb3_hk_revision_id_wr_reg; -- AEB 3 Housekeeping Area
		aeb4_ccfg_aeb_control        : t_aeb4_ccfg_aeb_control_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_aeb_config         : t_aeb4_ccfg_aeb_config_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_aeb_config_key     : t_aeb4_ccfg_aeb_config_key_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_aeb_config_ait1    : t_aeb4_ccfg_aeb_config_ait1_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_aeb_config_pattern : t_aeb4_ccfg_aeb_config_pattern_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_vasp_i2c_control   : t_aeb4_ccfg_vasp_i2c_control_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_dac_config_1       : t_aeb4_ccfg_dac_config_1_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_dac_config_2       : t_aeb4_ccfg_dac_config_2_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_pwr_config1        : t_aeb4_ccfg_pwr_config1_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_pwr_config2        : t_aeb4_ccfg_pwr_config2_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_ccfg_pwr_config3        : t_aeb4_ccfg_pwr_config3_wr_reg; -- AEB 4 Critical Configuration Area
		aeb4_gcfg_adc1_config        : t_aeb4_gcfg_adc1_config_wr_reg; -- AEB 4 General Configuration Area
		aeb4_gcfg_adc2_config        : t_aeb4_gcfg_adc2_config_wr_reg; -- AEB 4 General Configuration Area
		aeb4_gcfg_seq_config         : t_aeb4_gcfg_seq_config_wr_reg; -- AEB 4 General Configuration Area
		aeb4_hk_aeb_status           : t_aeb4_hk_aeb_status_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_timestamp            : t_aeb4_hk_timestamp_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_adc_rd_data          : t_aeb4_hk_adc_rd_data_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_adc1_rd_config       : t_aeb4_hk_adc1_rd_config_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_adc2_rd_config       : t_aeb4_hk_adc2_rd_config_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_vasp_rd_config       : t_aeb4_hk_vasp_rd_config_wr_reg; -- AEB 4 Housekeeping Area
		aeb4_hk_revision_id          : t_aeb4_hk_revision_id_wr_reg; -- AEB 4 Housekeeping Area
	end record t_rmap_memory_wr_area;

	-- Avalon MM Read-Only Registers
	type t_rmap_memory_rd_area is record
		dummy : t_dummy_rd_reg;         -- Dummy
	end record t_rmap_memory_rd_area;

end package nrme_rmap_mem_area_nfee_pkg;

package body nrme_rmap_mem_area_nfee_pkg is
end package body nrme_rmap_mem_area_nfee_pkg;
