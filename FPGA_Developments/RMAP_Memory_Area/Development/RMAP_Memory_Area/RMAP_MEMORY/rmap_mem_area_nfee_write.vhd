library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_write is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_fee_rmap_write_in;
		avalon_mm_rmap_i    : in  t_avalon_mm_spacewire_write_in;
		fee_rmap_o          : out t_fee_rmap_write_out;
		avalon_mm_rmap_o    : out t_avalon_mm_spacewire_write_out;
		rmap_registers_wr_o : out t_rmap_memory_wr_area
	);
end entity rmap_mem_area_nfee_write;

architecture RTL of rmap_mem_area_nfee_write is

	signal s_data_acquired : std_logic;

begin

	p_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
		procedure p_nfee_reg_reset is
		begin

			-- Write Registers Reset/Default State

			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb4                                      <= '0';
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb3                                      <= '0';
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb2                                      <= '0';
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb1                                      <= '0';
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3                               <= x"00000027";
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2                               <= x"DB6DB4A2";
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1                               <= x"0000007D";
			-- DEB Critical Configuration Area : 
			rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0                               <= x"0007F1FC";
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_oper_mod.imm                                           <= '0';
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_oper_mod.oper_mod                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t7_in_mod.in_mod7                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t6_in_mod.in_mod6                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t5_in_mod.in_mod5                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t4_in_mod.in_mod4                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t3_in_mod.in_mod3                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t2_in_mod.in_mod2                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t1_in_mod.in_mod1                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_t0_in_mod.in_mod0                                      <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_w_siz_x.w_siz_x                                        <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_w_siz_y.w_siz_y                                        <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_idx_4.wdw_idx_4                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_len_4.wdw_len_4                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_idx_3.wdw_idx_3                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_len_3.wdw_len_3                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_idx_2.wdw_idx_2                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_len_2.wdw_len_2                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_idx_1.wdw_idx_1                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_wdw_len_1.wdw_len_1                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_lin_4.ovs_lin_4                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_lin_3.ovs_lin_3                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_lin_2.ovs_lin_2                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_lin_1.ovs_lin_1                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_pix_4.ovs_pix_4                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_pix_3.ovs_pix_3                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_pix_2.ovs_pix_2                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_ovs_pix_1.ovs_pix_1                                    <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_2_5s_n_cyc.d2_5s_n_cyc                                 <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_trg_src.sel_trg                                        <= '0';
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_frm_cnt.frm_cnt                                        <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_syn_frq.syn_nr                                         <= '0';
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_rst_wdg.rst_wdg                                        <= '0';
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_rst_cps.rst_cps                                        <= '0';
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly                                       <= (others => '0');
			-- DEB General Configuration Area : 
			rmap_registers_wr_o.deb_gcfg_tmod_conf.tmod_conf                                    <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.oper_mod                                      <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.window_list_table_edac_corrected_error_number <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.uncorrected_error_number                      <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.pll_status                                    <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb4_status                              <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb3_status                              <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb2_status                              <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb1_status                              <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.wdw_list_cnt_ovf                              <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.aeb_spi_status                                <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_status.wdg_status                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list8_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list7_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list6_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list5_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list4_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list3_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list2_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list1_cnt_ovf                         <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff8_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff7_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff6_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff5_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff4_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff3_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff2_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.out_buff1_ovf                                    <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.rmap4_ovf                                        <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.rmap3_ovf                                        <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.rmap2_ovf                                        <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.rmap1_ovf                                        <= '0';
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ovf.line_pixel_counters_overflow                     <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_spw_status.spw_status                                    <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in                                         <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ahk1.vio                                             <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ahk2.vcor                                            <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd                                            <= (others => '0');
			-- DEB Housekeeping Area : 
			rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp                                        <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.new_state                                 <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.set_state                                 <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.aeb_reset                                 <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_data_rd                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_wr                                <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_rd                                <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_control.dac_wr                                    <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config.watchdog_dis                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config.int_sync                                   <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp_cds_en                                <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp2_cal_en                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp1_cal_en                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key                                    <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_sw                           <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van3                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van2                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van1                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vclk                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vccd                               <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_vasp                         <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_pix_en                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_pix_en                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_adc_en                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_adc_en                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_reset                           <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_reset                           <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_adc                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_en_p5v0                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_en_p5v0                          <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.pt1000_cal_on_n                       <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.en_v_mux_n                            <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_pwdn_n                           <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_pwdn_n                           <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc_clk_en                            <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_ccdid                      <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_cols                       <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_rows                       <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp_cfg_addr                        <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_cfg_data                       <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_cfg_data                       <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_select                         <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_select                         <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.calibration_start                    <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_read_start                       <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_write_start                      <= '0';
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vog                                  <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vrd                                  <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_dac_config_2.dac_vod                                  <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vccd_on                              <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vclk_on                              <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van1_on                              <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van2_on                              <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van3_on                              <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vccd_off                             <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vclk_off                             <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van1_off                             <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van2_off                             <= (others => '0');
			-- AEB 1 Critical Configuration Area : 
			rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van3_off                             <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_bypas                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_clkenb                               <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_chop                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_stat                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_idlmod                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly2                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly1                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly0                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate1                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate0                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp3                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp2                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn3                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn2                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff7                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff6                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff5                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff4                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff3                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff2                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff1                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff0                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain15                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain14                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain13                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain12                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain11                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain10                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain9                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain8                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ref                                  <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_gain                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_temp                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_vcc                                  <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_offset                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_bypas                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_clkenb                               <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_chop                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_stat                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_idlmod                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly2                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly1                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly0                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate1                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate0                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp3                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp2                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn3                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn2                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn1                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn0                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff7                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff6                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff5                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff4                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff3                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff2                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff1                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff0                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain15                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain14                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain13                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain12                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain11                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain10                                <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain9                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain8                                 <= '1';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ref                                  <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_gain                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_temp                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_vcc                                  <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_offset                               <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio7                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio6                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio5                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio4                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio3                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio2                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio1                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio0                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe                                     <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.adc_clk_div                                <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_low_pos                            <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_high_pos                           <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_low_pos                          <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_high_pos                         <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.ft_loop_cnt                                <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_enabled                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_pixreadout                             <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_loop_cnt                               <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_enabled                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_pixreadout                             <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_loop_cnt                               <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_enabled                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_pixreadout                             <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_loop_cnt                               <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_enabled                                <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_pixreadout                             <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_loop_cnt                               <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.pix_loop_cnt                               <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_enabled                                 <= '0';
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_loop_cnt                                <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.int1_loop_cnt                              <= (others => '0');
			-- AEB 1 General Configuration Area : 
			rmap_registers_wr_o.aeb1_gcfg_seq_config.int2_loop_cnt                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.aeb_state                                    <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.vasp2_cfg_run                                <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.vasp1_cfg_run                                <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.dac_cfg_w_run                                <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd_run                               <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr_run                               <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd_run                               <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_error                                    <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_lu                                      <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_lu                                      <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd                                   <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd                                   <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr                                   <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_busy                                    <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_busy                                    <= '0';
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_aeb_status.frame_counter                                <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1                                   <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0                                   <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10                              <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0                               <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0                         <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp1_read_data                          <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp2_read_data                          <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_revision_id.fpga_ver                                    <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_revision_id.fpga_date                                   <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_revision_id.fpga_time                                   <= (others => '0');
			-- AEB 1 Housekeeping Area : 
			rmap_registers_wr_o.aeb1_hk_revision_id.fpga_svn                                    <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.new_state                                 <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.set_state                                 <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.aeb_reset                                 <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_data_rd                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_wr                                <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_rd                                <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_control.dac_wr                                    <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config.watchdog_dis                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config.int_sync                                   <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp_cds_en                                <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp2_cal_en                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp1_cal_en                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key                                    <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_sw                           <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van3                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van2                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van1                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vclk                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vccd                               <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_vasp                         <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_pix_en                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_pix_en                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_adc_en                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_adc_en                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_reset                           <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_reset                           <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_adc                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_en_p5v0                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_en_p5v0                          <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.pt1000_cal_on_n                       <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.en_v_mux_n                            <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_pwdn_n                           <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_pwdn_n                           <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc_clk_en                            <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_ccdid                      <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_cols                       <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_rows                       <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp_cfg_addr                        <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_cfg_data                       <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_cfg_data                       <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_select                         <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_select                         <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.calibration_start                    <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_read_start                       <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_write_start                      <= '0';
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vog                                  <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vrd                                  <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_dac_config_2.dac_vod                                  <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vccd_on                              <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vclk_on                              <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van1_on                              <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van2_on                              <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van3_on                              <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vccd_off                             <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vclk_off                             <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van1_off                             <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van2_off                             <= (others => '0');
			-- AEB 2 Critical Configuration Area : 
			rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van3_off                             <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_bypas                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_clkenb                               <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_chop                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_stat                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_idlmod                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly2                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly1                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly0                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate1                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate0                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp3                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp2                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn3                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn2                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff7                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff6                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff5                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff4                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff3                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff2                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff1                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff0                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain15                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain14                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain13                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain12                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain11                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain10                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain9                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain8                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ref                                  <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_gain                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_temp                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_vcc                                  <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_offset                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_bypas                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_clkenb                               <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_chop                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_stat                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_idlmod                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly2                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly1                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly0                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate1                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate0                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp3                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp2                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn3                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn2                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn1                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn0                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff7                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff6                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff5                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff4                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff3                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff2                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff1                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff0                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain15                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain14                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain13                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain12                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain11                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain10                                <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain9                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain8                                 <= '1';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ref                                  <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_gain                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_temp                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_vcc                                  <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_offset                               <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio7                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio6                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio5                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio4                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio3                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio2                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio1                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio0                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe                                     <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.adc_clk_div                                <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_low_pos                            <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_high_pos                           <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_low_pos                          <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_high_pos                         <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.ft_loop_cnt                                <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_enabled                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_pixreadout                             <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_loop_cnt                               <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_enabled                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_pixreadout                             <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_loop_cnt                               <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_enabled                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_pixreadout                             <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_loop_cnt                               <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_enabled                                <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_pixreadout                             <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_loop_cnt                               <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.pix_loop_cnt                               <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_enabled                                 <= '0';
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_loop_cnt                                <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.int1_loop_cnt                              <= (others => '0');
			-- AEB 2 General Configuration Area : 
			rmap_registers_wr_o.aeb2_gcfg_seq_config.int2_loop_cnt                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.aeb_state                                    <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.vasp2_cfg_run                                <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.vasp1_cfg_run                                <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.dac_cfg_w_run                                <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd_run                               <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr_run                               <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd_run                               <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_error                                    <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_lu                                      <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_lu                                      <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd                                   <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd                                   <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr                                   <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_busy                                    <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_busy                                    <= '0';
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_aeb_status.frame_counter                                <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1                                   <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0                                   <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10                              <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0                               <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0                         <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp1_read_data                          <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp2_read_data                          <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_revision_id.fpga_ver                                    <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_revision_id.fpga_date                                   <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_revision_id.fpga_time                                   <= (others => '0');
			-- AEB 2 Housekeeping Area : 
			rmap_registers_wr_o.aeb2_hk_revision_id.fpga_svn                                    <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.new_state                                 <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.set_state                                 <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.aeb_reset                                 <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_data_rd                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_wr                                <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_rd                                <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_control.dac_wr                                    <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config.watchdog_dis                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config.int_sync                                   <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp_cds_en                                <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp2_cal_en                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp1_cal_en                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key                                    <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_sw                           <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van3                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van2                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van1                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vclk                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vccd                               <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_vasp                         <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_pix_en                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_pix_en                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_adc_en                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_adc_en                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_reset                           <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_reset                           <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_adc                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_en_p5v0                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_en_p5v0                          <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.pt1000_cal_on_n                       <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.en_v_mux_n                            <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_pwdn_n                           <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_pwdn_n                           <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc_clk_en                            <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_ccdid                      <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_cols                       <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_rows                       <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp_cfg_addr                        <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_cfg_data                       <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_cfg_data                       <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_select                         <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_select                         <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.calibration_start                    <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_read_start                       <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_write_start                      <= '0';
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vog                                  <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vrd                                  <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_dac_config_2.dac_vod                                  <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vccd_on                              <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vclk_on                              <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van1_on                              <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van2_on                              <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van3_on                              <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vccd_off                             <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vclk_off                             <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van1_off                             <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van2_off                             <= (others => '0');
			-- AEB 3 Critical Configuration Area : 
			rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van3_off                             <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_bypas                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_clkenb                               <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_chop                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_stat                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_idlmod                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly2                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly1                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly0                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate1                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate0                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp3                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp2                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn3                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn2                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff7                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff6                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff5                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff4                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff3                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff2                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff1                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff0                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain15                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain14                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain13                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain12                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain11                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain10                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain9                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain8                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ref                                  <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_gain                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_temp                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_vcc                                  <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_offset                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_bypas                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_clkenb                               <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_chop                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_stat                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_idlmod                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly2                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly1                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly0                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate1                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate0                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp3                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp2                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn3                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn2                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn1                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn0                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff7                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff6                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff5                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff4                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff3                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff2                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff1                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff0                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain15                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain14                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain13                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain12                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain11                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain10                                <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain9                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain8                                 <= '1';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ref                                  <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_gain                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_temp                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_vcc                                  <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_offset                               <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio7                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio6                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio5                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio4                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio3                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio2                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio1                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio0                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe                                     <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.adc_clk_div                                <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_low_pos                            <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_high_pos                           <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_low_pos                          <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_high_pos                         <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.ft_loop_cnt                                <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_enabled                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_pixreadout                             <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_loop_cnt                               <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_enabled                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_pixreadout                             <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_loop_cnt                               <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_enabled                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_pixreadout                             <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_loop_cnt                               <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_enabled                                <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_pixreadout                             <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_loop_cnt                               <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.pix_loop_cnt                               <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_enabled                                 <= '0';
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_loop_cnt                                <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.int1_loop_cnt                              <= (others => '0');
			-- AEB 3 General Configuration Area : 
			rmap_registers_wr_o.aeb3_gcfg_seq_config.int2_loop_cnt                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.aeb_state                                    <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.vasp2_cfg_run                                <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.vasp1_cfg_run                                <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.dac_cfg_w_run                                <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd_run                               <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr_run                               <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd_run                               <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_error                                    <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_lu                                      <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_lu                                      <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd                                   <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd                                   <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr                                   <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_busy                                    <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_busy                                    <= '0';
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_aeb_status.frame_counter                                <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1                                   <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0                                   <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10                              <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0                               <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0                         <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp1_read_data                          <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp2_read_data                          <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_revision_id.fpga_ver                                    <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_revision_id.fpga_date                                   <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_revision_id.fpga_time                                   <= (others => '0');
			-- AEB 3 Housekeeping Area : 
			rmap_registers_wr_o.aeb3_hk_revision_id.fpga_svn                                    <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.new_state                                 <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.set_state                                 <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.aeb_reset                                 <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_data_rd                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_wr                                <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_rd                                <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_control.dac_wr                                    <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config.watchdog_dis                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config.int_sync                                   <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp_cds_en                                <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp2_cal_en                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp1_cal_en                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key                                    <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_sw                           <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van3                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van2                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van1                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vclk                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vccd                               <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_vasp                         <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_pix_en                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_pix_en                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_adc_en                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_adc_en                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_reset                           <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_reset                           <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_adc                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_en_p5v0                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_en_p5v0                          <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.pt1000_cal_on_n                       <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.en_v_mux_n                            <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_pwdn_n                           <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_pwdn_n                           <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc_clk_en                            <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_ccdid                      <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_cols                       <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_rows                       <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp_cfg_addr                        <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_cfg_data                       <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_cfg_data                       <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_select                         <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_select                         <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.calibration_start                    <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_read_start                       <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_write_start                      <= '0';
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vog                                  <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vrd                                  <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_dac_config_2.dac_vod                                  <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vccd_on                              <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vclk_on                              <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van1_on                              <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van2_on                              <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van3_on                              <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vccd_off                             <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vclk_off                             <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van1_off                             <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van2_off                             <= (others => '0');
			-- AEB 4 Critical Configuration Area : 
			rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van3_off                             <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_bypas                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_clkenb                               <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_chop                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_stat                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_idlmod                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly2                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly1                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly0                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate1                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate0                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp3                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp2                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn3                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn2                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff7                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff6                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff5                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff4                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff3                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff2                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff1                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff0                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain15                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain14                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain13                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain12                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain11                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain10                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain9                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain8                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ref                                  <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_gain                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_temp                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_vcc                                  <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_offset                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_bypas                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_clkenb                               <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_chop                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_stat                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_idlmod                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly2                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly1                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly0                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate1                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate0                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp3                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp2                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn3                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn2                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn1                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn0                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff7                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff6                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff5                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff4                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff3                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff2                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff1                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff0                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain15                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain14                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain13                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain12                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain11                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain10                                <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain9                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain8                                 <= '1';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ref                                  <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_gain                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_temp                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_vcc                                  <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_offset                               <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio7                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio6                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio5                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio4                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio3                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio2                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio1                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio0                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe                                     <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.adc_clk_div                                <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_low_pos                            <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_high_pos                           <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_low_pos                          <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_high_pos                         <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.ft_loop_cnt                                <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_enabled                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_pixreadout                             <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_loop_cnt                               <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_enabled                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_pixreadout                             <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_loop_cnt                               <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_enabled                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_pixreadout                             <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_loop_cnt                               <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_enabled                                <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_pixreadout                             <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_loop_cnt                               <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.pix_loop_cnt                               <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_enabled                                 <= '0';
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_loop_cnt                                <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.int1_loop_cnt                              <= (others => '0');
			-- AEB 4 General Configuration Area : 
			rmap_registers_wr_o.aeb4_gcfg_seq_config.int2_loop_cnt                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.aeb_state                                    <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.vasp2_cfg_run                                <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.vasp1_cfg_run                                <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.dac_cfg_w_run                                <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd_run                               <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr_run                               <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd_run                               <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_error                                    <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_lu                                      <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_lu                                      <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd                                   <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd                                   <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr                                   <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_busy                                    <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_busy                                    <= '0';
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_aeb_status.frame_counter                                <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1                                   <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0                                   <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10                              <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0                               <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0                         <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp1_read_data                          <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp2_read_data                          <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_revision_id.fpga_ver                                    <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_revision_id.fpga_date                                   <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_revision_id.fpga_time                                   <= (others => '0');
			-- AEB 4 Housekeeping Area : 
			rmap_registers_wr_o.aeb4_hk_revision_id.fpga_svn                                    <= (others => '0');

		end procedure p_nfee_reg_reset;

		procedure p_nfee_reg_trigger is
		begin

			-- Write Registers Triggers Reset
			null;

		end procedure p_nfee_reg_trigger;

		procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
		begin

			-- MemArea Write Data
			case (wr_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000003") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb1 <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb2 <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb3 <= fee_rmap_i.writedata(2);
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb4 <= fee_rmap_i.writedata(3);

				when (x"00000004") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000005") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000006") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000007") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000008") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000009") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000000A") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000000B") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000000C") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0000000D") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000000E") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000000F") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000010") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000011") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000012") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000013") =>
					-- DEB Critical Configuration Area : 
					rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000103") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_oper_mod.oper_mod <= fee_rmap_i.writedata(2 downto 0);
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_oper_mod.imm      <= fee_rmap_i.writedata(3);

				when (x"00000104") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t7_in_mod.in_mod7 <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000105") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t6_in_mod.in_mod6 <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000106") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t5_in_mod.in_mod5 <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000107") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t4_in_mod.in_mod4 <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000108") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t3_in_mod.in_mod3 <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000109") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t2_in_mod.in_mod2 <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010A") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t1_in_mod.in_mod1 <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010B") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_t0_in_mod.in_mod0 <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010E") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_w_siz_x.w_siz_x <= fee_rmap_i.writedata(6 downto 0);

				when (x"0000010F") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_w_siz_y.w_siz_y <= fee_rmap_i.writedata(6 downto 0);

				when (x"00000110") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_4.wdw_idx_4(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000111") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_4.wdw_idx_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000112") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_4.wdw_len_4(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000113") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_4.wdw_len_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000114") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_3.wdw_idx_3(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000115") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_3.wdw_idx_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000116") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_3.wdw_len_3(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000117") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_3.wdw_len_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000118") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_2.wdw_idx_2(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000119") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_2.wdw_idx_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011A") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_2.wdw_len_2(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011B") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_2.wdw_len_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011C") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_1.wdw_idx_1(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011D") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_idx_1.wdw_idx_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011E") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_1.wdw_len_1(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011F") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_wdw_len_1.wdw_len_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000120") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_lin_4.ovs_lin_4 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000121") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_lin_3.ovs_lin_3 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000122") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_lin_2.ovs_lin_2 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000123") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_lin_1.ovs_lin_1 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000124") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_pix_4.ovs_pix_4 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000125") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_pix_3.ovs_pix_3 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000126") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_pix_2.ovs_pix_2 <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000127") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_ovs_pix_1.ovs_pix_1 <= fee_rmap_i.writedata(4 downto 0);

				when (x"0000012B") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_2_5s_n_cyc.d2_5s_n_cyc <= fee_rmap_i.writedata;

				when (x"0000012F") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_trg_src.sel_trg <= fee_rmap_i.writedata(0);

				when (x"00000132") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_frm_cnt.frm_cnt(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000133") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_frm_cnt.frm_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000137") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_syn_frq.syn_nr <= fee_rmap_i.writedata(0);

				when (x"0000013A") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_rst_wdg.rst_wdg <= fee_rmap_i.writedata(0);

				when (x"0000013B") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_rst_cps.rst_cps <= fee_rmap_i.writedata(0);

				when (x"0000013D") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000013E") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000013F") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000142") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_tmod_conf.tmod_conf(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000143") =>
					-- DEB General Configuration Area : 
					rmap_registers_wr_o.deb_gcfg_tmod_conf.tmod_conf(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00001000") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.oper_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00001001") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.uncorrected_error_number                      <= fee_rmap_i.writedata(1 downto 0);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.window_list_table_edac_corrected_error_number <= fee_rmap_i.writedata(7 downto 2);

				when (x"00001002") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.pll_status <= fee_rmap_i.writedata;

				when (x"00001003") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.wdg_status       <= fee_rmap_i.writedata(0);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.aeb_spi_status   <= fee_rmap_i.writedata(1);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.wdw_list_cnt_ovf <= fee_rmap_i.writedata(3 downto 2);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb1_status <= fee_rmap_i.writedata(4);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb2_status <= fee_rmap_i.writedata(5);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb3_status <= fee_rmap_i.writedata(6);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb4_status <= fee_rmap_i.writedata(7);

				when (x"00001004") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list1_cnt_ovf <= fee_rmap_i.writedata(0);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list2_cnt_ovf <= fee_rmap_i.writedata(1);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list3_cnt_ovf <= fee_rmap_i.writedata(2);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list4_cnt_ovf <= fee_rmap_i.writedata(3);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list5_cnt_ovf <= fee_rmap_i.writedata(4);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list6_cnt_ovf <= fee_rmap_i.writedata(5);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list7_cnt_ovf <= fee_rmap_i.writedata(6);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list8_cnt_ovf <= fee_rmap_i.writedata(7);

				when (x"00001005") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff1_ovf <= fee_rmap_i.writedata(0);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff2_ovf <= fee_rmap_i.writedata(1);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff3_ovf <= fee_rmap_i.writedata(2);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff4_ovf <= fee_rmap_i.writedata(3);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff5_ovf <= fee_rmap_i.writedata(4);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff6_ovf <= fee_rmap_i.writedata(5);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff7_ovf <= fee_rmap_i.writedata(6);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.out_buff8_ovf <= fee_rmap_i.writedata(7);

				when (x"00001006") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.rmap1_ovf <= fee_rmap_i.writedata(0);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.rmap2_ovf <= fee_rmap_i.writedata(2);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.rmap3_ovf <= fee_rmap_i.writedata(4);
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.rmap4_ovf <= fee_rmap_i.writedata(6);

				when (x"00001007") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ovf.line_pixel_counters_overflow <= fee_rmap_i.writedata;

				when (x"00001008") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_spw_status.spw_status(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00001009") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_spw_status.spw_status(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000100A") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_spw_status.spw_status(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000100B") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_spw_status.spw_status(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000100C") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0000100D") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000100E") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk1.vio(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0000100F") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk1.vio(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00001010") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00001011") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00001012") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00001013") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00001016") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00001017") =>
					-- DEB Housekeeping Area : 
					rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010000") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.aeb_reset <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.set_state <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.new_state <= fee_rmap_i.writedata(6 downto 2);

				when (x"00010001") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.dac_wr      <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_rd  <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_wr  <= fee_rmap_i.writedata(2);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_data_rd <= fee_rmap_i.writedata(3);

				when (x"00010004") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config.int_sync     <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config.watchdog_dis <= fee_rmap_i.writedata(1);

				when (x"00010005") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp1_cal_en <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp2_cal_en <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp_cds_en  <= fee_rmap_i.writedata(2);

				when (x"00010008") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00010009") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001000A") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001000B") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001000C") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vccd     <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vclk     <= fee_rmap_i.writedata(2);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van1     <= fee_rmap_i.writedata(3);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van2     <= fee_rmap_i.writedata(4);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van3     <= fee_rmap_i.writedata(5);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_sw <= fee_rmap_i.writedata(7);

				when (x"0001000D") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_reset   <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_reset   <= fee_rmap_i.writedata(2);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_adc_en  <= fee_rmap_i.writedata(3);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_adc_en  <= fee_rmap_i.writedata(4);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_pix_en  <= fee_rmap_i.writedata(5);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_pix_en  <= fee_rmap_i.writedata(6);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_vasp <= fee_rmap_i.writedata(7);

				when (x"0001000E") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc_clk_en      <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_pwdn_n     <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_pwdn_n     <= fee_rmap_i.writedata(2);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.en_v_mux_n      <= fee_rmap_i.writedata(3);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.pt1000_cal_on_n <= fee_rmap_i.writedata(4);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_en_p5v0    <= fee_rmap_i.writedata(5);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_en_p5v0    <= fee_rmap_i.writedata(6);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_adc    <= fee_rmap_i.writedata(7);

				when (x"00010010") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_ccdid             <= fee_rmap_i.writedata(7 downto 6);

				when (x"00010011") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010012") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00010013") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010014") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp_cfg_addr <= fee_rmap_i.writedata;

				when (x"00010015") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_cfg_data <= fee_rmap_i.writedata;

				when (x"00010016") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_cfg_data <= fee_rmap_i.writedata;

				when (x"00010017") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_write_start   <= fee_rmap_i.writedata(0);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_read_start    <= fee_rmap_i.writedata(1);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.calibration_start <= fee_rmap_i.writedata(2);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_select      <= fee_rmap_i.writedata(3);
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_select      <= fee_rmap_i.writedata(4);

				when (x"00010018") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vog(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00010019") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vog(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001001A") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vrd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0001001B") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vrd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001001C") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_2.dac_vod(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0001001D") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_dac_config_2.dac_vod(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010024") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vccd_on <= fee_rmap_i.writedata;

				when (x"00010025") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vclk_on <= fee_rmap_i.writedata;

				when (x"00010026") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van1_on <= fee_rmap_i.writedata;

				when (x"00010027") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van2_on <= fee_rmap_i.writedata;

				when (x"00010028") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van3_on <= fee_rmap_i.writedata;

				when (x"00010029") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vccd_off <= fee_rmap_i.writedata;

				when (x"0001002A") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vclk_off <= fee_rmap_i.writedata;

				when (x"0001002B") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van1_off <= fee_rmap_i.writedata;

				when (x"0001002C") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van2_off <= fee_rmap_i.writedata;

				when (x"0001002D") =>
					-- AEB 1 Critical Configuration Area : 
					rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van3_off <= fee_rmap_i.writedata;

				when (x"00010100") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_stat   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_chop   <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_bypas  <= fee_rmap_i.writedata(7);

				when (x"00010101") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_idlmod <= fee_rmap_i.writedata(7);

				when (x"00010102") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp3 <= fee_rmap_i.writedata(7);

				when (x"00010103") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff7 <= fee_rmap_i.writedata(7);

				when (x"00010104") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain7 <= fee_rmap_i.writedata(7);

				when (x"00010105") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain15 <= fee_rmap_i.writedata(7);

				when (x"00010106") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_offset <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_temp   <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_gain   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ref    <= fee_rmap_i.writedata(5);

				when (x"00010107") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio7 <= fee_rmap_i.writedata(7);

				when (x"00010108") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio7 <= fee_rmap_i.writedata(7);

				when (x"0001010C") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_stat   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_chop   <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_bypas  <= fee_rmap_i.writedata(7);

				when (x"0001010D") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_idlmod <= fee_rmap_i.writedata(7);

				when (x"0001010E") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp3 <= fee_rmap_i.writedata(7);

				when (x"0001010F") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff7 <= fee_rmap_i.writedata(7);

				when (x"00010110") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain7 <= fee_rmap_i.writedata(7);

				when (x"00010111") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain15 <= fee_rmap_i.writedata(7);

				when (x"00010112") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_offset <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_temp   <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_gain   <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ref    <= fee_rmap_i.writedata(5);

				when (x"00010113") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio7 <= fee_rmap_i.writedata(7);

				when (x"00010114") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio7 <= fee_rmap_i.writedata(7);

				when (x"00010120") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(21 downto 16) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00010121") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00010122") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010123") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.adc_clk_div <= fee_rmap_i.writedata(6 downto 0);

				when (x"00010124") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00010125") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00010126") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00010127") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00010130") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00010131") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010132") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_enabled               <= fee_rmap_i.writedata(7);

				when (x"00010133") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010134") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_enabled               <= fee_rmap_i.writedata(7);

				when (x"00010135") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010136") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_enabled               <= fee_rmap_i.writedata(7);

				when (x"00010137") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010138") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_enabled               <= fee_rmap_i.writedata(7);

				when (x"00010139") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001013A") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0001013B") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001013C") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_enabled               <= fee_rmap_i.writedata(7);

				when (x"0001013D") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001013E") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0001013F") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00010140") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00010141") =>
					-- AEB 1 General Configuration Area : 
					rmap_registers_wr_o.aeb1_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011000") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.aeb_state <= fee_rmap_i.writedata(2 downto 0);

				when (x"00011001") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd_run <= fee_rmap_i.writedata(0);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr_run <= fee_rmap_i.writedata(1);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd_run <= fee_rmap_i.writedata(2);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.dac_cfg_w_run  <= fee_rmap_i.writedata(3);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.vasp1_cfg_run  <= fee_rmap_i.writedata(6);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.vasp2_cfg_run  <= fee_rmap_i.writedata(7);

				when (x"00011002") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_busy  <= fee_rmap_i.writedata(0);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_busy  <= fee_rmap_i.writedata(1);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr <= fee_rmap_i.writedata(2);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd <= fee_rmap_i.writedata(3);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd <= fee_rmap_i.writedata(4);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_lu    <= fee_rmap_i.writedata(5);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_lu    <= fee_rmap_i.writedata(6);
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.adc_error  <= fee_rmap_i.writedata(7);

				when (x"00011006") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.frame_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011007") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_aeb_status.frame_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011008") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011009") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001100A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001100B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001100C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001100D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001100E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001100F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011010") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011011") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011012") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011013") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011014") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011015") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011016") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011017") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011018") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011019") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001101A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001101B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001101C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001101D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001101E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001101F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011020") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011021") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011022") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011023") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011024") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011025") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011026") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011027") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011028") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011029") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001102A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001102B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001102C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001102D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001102E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001102F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011030") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011031") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011032") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011033") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011034") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011035") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011036") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011037") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011038") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011039") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001103A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001103B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001103C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001103D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001103E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001103F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011040") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011041") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011042") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011043") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011044") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011045") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011046") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011047") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011048") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011049") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001104A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001104B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001104C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001104D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001104E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001104F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011050") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011051") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011052") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011053") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011054") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011055") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011056") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011057") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011058") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011059") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001105A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001105B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011080") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011081") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011082") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011083") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011084") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011085") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011086") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011087") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011088") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011089") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001108A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001108B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001108C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001108D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001108E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001108F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011090") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011091") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011092") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011093") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011094") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011095") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00011096") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00011097") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00011098") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00011099") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001109A") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001109B") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0001109C") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0001109D") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0001109E") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0001109F") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000110A0") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp1_read_data <= fee_rmap_i.writedata;

				when (x"000110A1") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp2_read_data <= fee_rmap_i.writedata;

				when (x"000111F0") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_ver(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000111F1") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_ver(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000111F2") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_date(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000111F3") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_date(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000111F4") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_time(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000111F5") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_time(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000111F6") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_svn(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000111F7") =>
					-- AEB 1 Housekeeping Area : 
					rmap_registers_wr_o.aeb1_hk_revision_id.fpga_svn(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020000") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.aeb_reset <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.set_state <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.new_state <= fee_rmap_i.writedata(6 downto 2);

				when (x"00020001") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.dac_wr      <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_rd  <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_wr  <= fee_rmap_i.writedata(2);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_data_rd <= fee_rmap_i.writedata(3);

				when (x"00020004") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config.int_sync     <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config.watchdog_dis <= fee_rmap_i.writedata(1);

				when (x"00020005") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp1_cal_en <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp2_cal_en <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp_cds_en  <= fee_rmap_i.writedata(2);

				when (x"00020008") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(30 downto 23) <= fee_rmap_i.writedata;

				when (x"00020009") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(22 downto 15) <= fee_rmap_i.writedata;

				when (x"0002000A") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(14 downto 7) <= fee_rmap_i.writedata;

				when (x"0002000B") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(6 downto 0) <= fee_rmap_i.writedata(7 downto 1);

				when (x"0002000C") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vccd     <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vclk     <= fee_rmap_i.writedata(2);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van1     <= fee_rmap_i.writedata(3);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van2     <= fee_rmap_i.writedata(4);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van3     <= fee_rmap_i.writedata(5);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_sw <= fee_rmap_i.writedata(7);

				when (x"0002000D") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_reset   <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_reset   <= fee_rmap_i.writedata(2);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_adc_en  <= fee_rmap_i.writedata(3);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_adc_en  <= fee_rmap_i.writedata(4);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_pix_en  <= fee_rmap_i.writedata(5);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_pix_en  <= fee_rmap_i.writedata(6);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_vasp <= fee_rmap_i.writedata(7);

				when (x"0002000E") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc_clk_en      <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_pwdn_n     <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_pwdn_n     <= fee_rmap_i.writedata(2);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.en_v_mux_n      <= fee_rmap_i.writedata(3);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.pt1000_cal_on_n <= fee_rmap_i.writedata(4);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_en_p5v0    <= fee_rmap_i.writedata(5);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_en_p5v0    <= fee_rmap_i.writedata(6);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_adc    <= fee_rmap_i.writedata(7);

				when (x"00020010") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_ccdid             <= fee_rmap_i.writedata(7 downto 6);

				when (x"00020011") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020012") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00020013") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020014") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp_cfg_addr <= fee_rmap_i.writedata;

				when (x"00020015") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_cfg_data <= fee_rmap_i.writedata;

				when (x"00020016") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_cfg_data <= fee_rmap_i.writedata;

				when (x"00020017") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_write_start   <= fee_rmap_i.writedata(0);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_read_start    <= fee_rmap_i.writedata(1);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.calibration_start <= fee_rmap_i.writedata(2);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_select      <= fee_rmap_i.writedata(3);
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_select      <= fee_rmap_i.writedata(4);

				when (x"00020018") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vog(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00020019") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vog(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002001A") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vrd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0002001B") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vrd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002001C") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_2.dac_vod(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0002001D") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_dac_config_2.dac_vod(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020024") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vccd_on <= fee_rmap_i.writedata;

				when (x"00020025") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vclk_on <= fee_rmap_i.writedata;

				when (x"00020026") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van1_on <= fee_rmap_i.writedata;

				when (x"00020027") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van2_on <= fee_rmap_i.writedata;

				when (x"00020028") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van3_on <= fee_rmap_i.writedata;

				when (x"00020029") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vccd_off <= fee_rmap_i.writedata;

				when (x"0002002A") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vclk_off <= fee_rmap_i.writedata;

				when (x"0002002B") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van1_off <= fee_rmap_i.writedata;

				when (x"0002002C") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van2_off <= fee_rmap_i.writedata;

				when (x"0002002D") =>
					-- AEB 2 Critical Configuration Area : 
					rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van3_off <= fee_rmap_i.writedata;

				when (x"00020100") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_stat   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_chop   <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_bypas  <= fee_rmap_i.writedata(7);

				when (x"00020101") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_idlmod <= fee_rmap_i.writedata(7);

				when (x"00020102") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp3 <= fee_rmap_i.writedata(7);

				when (x"00020103") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff7 <= fee_rmap_i.writedata(7);

				when (x"00020104") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain7 <= fee_rmap_i.writedata(7);

				when (x"00020105") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain15 <= fee_rmap_i.writedata(7);

				when (x"00020106") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_offset <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_temp   <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_gain   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ref    <= fee_rmap_i.writedata(5);

				when (x"00020107") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio7 <= fee_rmap_i.writedata(7);

				when (x"00020108") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio7 <= fee_rmap_i.writedata(7);

				when (x"0002010C") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_stat   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_chop   <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_bypas  <= fee_rmap_i.writedata(7);

				when (x"0002010D") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_idlmod <= fee_rmap_i.writedata(7);

				when (x"0002010E") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp3 <= fee_rmap_i.writedata(7);

				when (x"0002010F") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff7 <= fee_rmap_i.writedata(7);

				when (x"00020110") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain7 <= fee_rmap_i.writedata(7);

				when (x"00020111") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain15 <= fee_rmap_i.writedata(7);

				when (x"00020112") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_offset <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_temp   <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_gain   <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ref    <= fee_rmap_i.writedata(5);

				when (x"00020113") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio7 <= fee_rmap_i.writedata(7);

				when (x"00020114") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio7 <= fee_rmap_i.writedata(7);

				when (x"00020120") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(21 downto 16) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00020121") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00020122") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020123") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.adc_clk_div <= fee_rmap_i.writedata(6 downto 0);

				when (x"00020124") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00020125") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00020126") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00020127") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00020130") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00020131") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020132") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_enabled               <= fee_rmap_i.writedata(7);

				when (x"00020133") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020134") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_enabled               <= fee_rmap_i.writedata(7);

				when (x"00020135") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020136") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_enabled               <= fee_rmap_i.writedata(7);

				when (x"00020137") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020138") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_enabled               <= fee_rmap_i.writedata(7);

				when (x"00020139") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002013A") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0002013B") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002013C") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_enabled               <= fee_rmap_i.writedata(7);

				when (x"0002013D") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002013E") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0002013F") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00020140") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00020141") =>
					-- AEB 2 General Configuration Area : 
					rmap_registers_wr_o.aeb2_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021000") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.aeb_state <= fee_rmap_i.writedata(2 downto 0);

				when (x"00021001") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd_run <= fee_rmap_i.writedata(0);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr_run <= fee_rmap_i.writedata(1);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd_run <= fee_rmap_i.writedata(2);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.dac_cfg_w_run  <= fee_rmap_i.writedata(3);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.vasp1_cfg_run  <= fee_rmap_i.writedata(6);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.vasp2_cfg_run  <= fee_rmap_i.writedata(7);

				when (x"00021002") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_busy  <= fee_rmap_i.writedata(0);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_busy  <= fee_rmap_i.writedata(1);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr <= fee_rmap_i.writedata(2);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd <= fee_rmap_i.writedata(3);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd <= fee_rmap_i.writedata(4);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_lu    <= fee_rmap_i.writedata(5);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_lu    <= fee_rmap_i.writedata(6);
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.adc_error  <= fee_rmap_i.writedata(7);

				when (x"00021006") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.frame_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021007") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_aeb_status.frame_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021008") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021009") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002100A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002100B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002100C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002100D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002100E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002100F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021010") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021011") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021012") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021013") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021014") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021015") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021016") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021017") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021018") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021019") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002101A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002101B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002101C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002101D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002101E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002101F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021020") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021021") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021022") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021023") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021024") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021025") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021026") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021027") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021028") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021029") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002102A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002102B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002102C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002102D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002102E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002102F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021030") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021031") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021032") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021033") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021034") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021035") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021036") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021037") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021038") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021039") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002103A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002103B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002103C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002103D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002103E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002103F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021040") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021041") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021042") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021043") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021044") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021045") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021046") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021047") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021048") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021049") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002104A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002104B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002104C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002104D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002104E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002104F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021050") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021051") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021052") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021053") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021054") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021055") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021056") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021057") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021058") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021059") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002105A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002105B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021080") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021081") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021082") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021083") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021084") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021085") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021086") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021087") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021088") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021089") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002108A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002108B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002108C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002108D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002108E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002108F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021090") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021091") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021092") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021093") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021094") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021095") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00021096") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00021097") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00021098") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00021099") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002109A") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002109B") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0002109C") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0002109D") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0002109E") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0002109F") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000210A0") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp1_read_data <= fee_rmap_i.writedata;

				when (x"000210A1") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp2_read_data <= fee_rmap_i.writedata;

				when (x"000211F0") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_ver(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000211F1") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_ver(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000211F2") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_date(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000211F3") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_date(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000211F4") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_time(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000211F5") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_time(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000211F6") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_svn(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000211F7") =>
					-- AEB 2 Housekeeping Area : 
					rmap_registers_wr_o.aeb2_hk_revision_id.fpga_svn(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040000") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.aeb_reset <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.set_state <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.new_state <= fee_rmap_i.writedata(6 downto 2);

				when (x"00040001") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.dac_wr      <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_rd  <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_wr  <= fee_rmap_i.writedata(2);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_data_rd <= fee_rmap_i.writedata(3);

				when (x"00040004") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config.int_sync     <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config.watchdog_dis <= fee_rmap_i.writedata(1);

				when (x"00040005") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp1_cal_en <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp2_cal_en <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp_cds_en  <= fee_rmap_i.writedata(2);

				when (x"00040008") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(30 downto 23) <= fee_rmap_i.writedata;

				when (x"00040009") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(22 downto 15) <= fee_rmap_i.writedata;

				when (x"0004000A") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(14 downto 7) <= fee_rmap_i.writedata;

				when (x"0004000B") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(6 downto 0) <= fee_rmap_i.writedata(7 downto 1);

				when (x"0004000C") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vccd     <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vclk     <= fee_rmap_i.writedata(2);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van1     <= fee_rmap_i.writedata(3);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van2     <= fee_rmap_i.writedata(4);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van3     <= fee_rmap_i.writedata(5);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_sw <= fee_rmap_i.writedata(7);

				when (x"0004000D") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_reset   <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_reset   <= fee_rmap_i.writedata(2);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_adc_en  <= fee_rmap_i.writedata(3);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_adc_en  <= fee_rmap_i.writedata(4);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_pix_en  <= fee_rmap_i.writedata(5);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_pix_en  <= fee_rmap_i.writedata(6);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_vasp <= fee_rmap_i.writedata(7);

				when (x"0004000E") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc_clk_en      <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_pwdn_n     <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_pwdn_n     <= fee_rmap_i.writedata(2);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.en_v_mux_n      <= fee_rmap_i.writedata(3);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.pt1000_cal_on_n <= fee_rmap_i.writedata(4);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_en_p5v0    <= fee_rmap_i.writedata(5);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_en_p5v0    <= fee_rmap_i.writedata(6);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_adc    <= fee_rmap_i.writedata(7);

				when (x"00040010") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_ccdid             <= fee_rmap_i.writedata(7 downto 6);

				when (x"00040011") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040012") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00040013") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040014") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp_cfg_addr <= fee_rmap_i.writedata;

				when (x"00040015") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_cfg_data <= fee_rmap_i.writedata;

				when (x"00040016") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_cfg_data <= fee_rmap_i.writedata;

				when (x"00040017") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_write_start   <= fee_rmap_i.writedata(0);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_read_start    <= fee_rmap_i.writedata(1);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.calibration_start <= fee_rmap_i.writedata(2);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_select      <= fee_rmap_i.writedata(3);
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_select      <= fee_rmap_i.writedata(4);

				when (x"00040018") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vog(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00040019") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vog(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004001A") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vrd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0004001B") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vrd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004001C") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_2.dac_vod(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0004001D") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_dac_config_2.dac_vod(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040024") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vccd_on <= fee_rmap_i.writedata;

				when (x"00040025") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vclk_on <= fee_rmap_i.writedata;

				when (x"00040026") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van1_on <= fee_rmap_i.writedata;

				when (x"00040027") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van2_on <= fee_rmap_i.writedata;

				when (x"00040028") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van3_on <= fee_rmap_i.writedata;

				when (x"00040029") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vccd_off <= fee_rmap_i.writedata;

				when (x"0004002A") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vclk_off <= fee_rmap_i.writedata;

				when (x"0004002B") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van1_off <= fee_rmap_i.writedata;

				when (x"0004002C") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van2_off <= fee_rmap_i.writedata;

				when (x"0004002D") =>
					-- AEB 3 Critical Configuration Area : 
					rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van3_off <= fee_rmap_i.writedata;

				when (x"00040100") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_stat   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_chop   <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_bypas  <= fee_rmap_i.writedata(7);

				when (x"00040101") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_idlmod <= fee_rmap_i.writedata(7);

				when (x"00040102") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp3 <= fee_rmap_i.writedata(7);

				when (x"00040103") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff7 <= fee_rmap_i.writedata(7);

				when (x"00040104") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain7 <= fee_rmap_i.writedata(7);

				when (x"00040105") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain15 <= fee_rmap_i.writedata(7);

				when (x"00040106") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_offset <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_temp   <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_gain   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ref    <= fee_rmap_i.writedata(5);

				when (x"00040107") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio7 <= fee_rmap_i.writedata(7);

				when (x"00040108") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio7 <= fee_rmap_i.writedata(7);

				when (x"0004010C") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_stat   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_chop   <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_bypas  <= fee_rmap_i.writedata(7);

				when (x"0004010D") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_idlmod <= fee_rmap_i.writedata(7);

				when (x"0004010E") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp3 <= fee_rmap_i.writedata(7);

				when (x"0004010F") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff7 <= fee_rmap_i.writedata(7);

				when (x"00040110") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain7 <= fee_rmap_i.writedata(7);

				when (x"00040111") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain15 <= fee_rmap_i.writedata(7);

				when (x"00040112") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_offset <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_temp   <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_gain   <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ref    <= fee_rmap_i.writedata(5);

				when (x"00040113") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio7 <= fee_rmap_i.writedata(7);

				when (x"00040114") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio7 <= fee_rmap_i.writedata(7);

				when (x"00040120") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(21 downto 16) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00040121") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00040122") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040123") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.adc_clk_div <= fee_rmap_i.writedata(6 downto 0);

				when (x"00040124") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00040125") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00040126") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00040127") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00040130") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00040131") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040132") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_enabled               <= fee_rmap_i.writedata(7);

				when (x"00040133") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040134") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_enabled               <= fee_rmap_i.writedata(7);

				when (x"00040135") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040136") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_enabled               <= fee_rmap_i.writedata(7);

				when (x"00040137") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040138") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_enabled               <= fee_rmap_i.writedata(7);

				when (x"00040139") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004013A") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0004013B") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004013C") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_enabled               <= fee_rmap_i.writedata(7);

				when (x"0004013D") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004013E") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0004013F") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00040140") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00040141") =>
					-- AEB 3 General Configuration Area : 
					rmap_registers_wr_o.aeb3_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041000") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.aeb_state <= fee_rmap_i.writedata(2 downto 0);

				when (x"00041001") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd_run <= fee_rmap_i.writedata(0);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr_run <= fee_rmap_i.writedata(1);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd_run <= fee_rmap_i.writedata(2);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.dac_cfg_w_run  <= fee_rmap_i.writedata(3);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.vasp1_cfg_run  <= fee_rmap_i.writedata(6);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.vasp2_cfg_run  <= fee_rmap_i.writedata(7);

				when (x"00041002") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_busy  <= fee_rmap_i.writedata(0);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_busy  <= fee_rmap_i.writedata(1);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr <= fee_rmap_i.writedata(2);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd <= fee_rmap_i.writedata(3);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd <= fee_rmap_i.writedata(4);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_lu    <= fee_rmap_i.writedata(5);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_lu    <= fee_rmap_i.writedata(6);
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.adc_error  <= fee_rmap_i.writedata(7);

				when (x"00041006") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.frame_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041007") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_aeb_status.frame_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041008") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041009") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004100A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004100B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004100C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004100D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004100E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004100F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041010") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041011") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041012") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041013") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041014") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041015") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041016") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041017") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041018") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041019") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004101A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004101B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004101C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004101D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004101E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004101F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041020") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041021") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041022") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041023") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041024") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041025") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041026") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041027") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041028") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041029") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004102A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004102B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004102C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004102D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004102E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004102F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041030") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041031") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041032") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041033") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041034") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041035") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041036") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041037") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041038") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041039") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004103A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004103B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004103C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004103D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004103E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004103F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041040") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041041") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041042") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041043") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041044") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041045") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041046") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041047") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041048") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041049") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004104A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004104B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004104C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004104D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004104E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004104F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041050") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041051") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041052") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041053") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041054") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041055") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041056") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041057") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041058") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041059") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004105A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004105B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041080") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041081") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041082") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041083") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041084") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041085") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041086") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041087") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041088") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041089") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004108A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004108B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004108C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004108D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004108E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004108F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041090") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041091") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041092") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041093") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041094") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041095") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00041096") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00041097") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00041098") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00041099") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004109A") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004109B") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0004109C") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0004109D") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0004109E") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0004109F") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000410A0") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp1_read_data <= fee_rmap_i.writedata;

				when (x"000410A1") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp2_read_data <= fee_rmap_i.writedata;

				when (x"000411F0") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_ver(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000411F1") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_ver(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000411F2") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_date(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000411F3") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_date(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000411F4") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_time(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000411F5") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_time(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000411F6") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_svn(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000411F7") =>
					-- AEB 3 Housekeeping Area : 
					rmap_registers_wr_o.aeb3_hk_revision_id.fpga_svn(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080000") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.aeb_reset <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.set_state <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.new_state <= fee_rmap_i.writedata(6 downto 2);

				when (x"00080001") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.dac_wr      <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_rd  <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_wr  <= fee_rmap_i.writedata(2);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_data_rd <= fee_rmap_i.writedata(3);

				when (x"00080004") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config.int_sync     <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config.watchdog_dis <= fee_rmap_i.writedata(1);

				when (x"00080005") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp1_cal_en <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp2_cal_en <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp_cds_en  <= fee_rmap_i.writedata(2);

				when (x"00080008") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(30 downto 23) <= fee_rmap_i.writedata;

				when (x"00080009") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(22 downto 15) <= fee_rmap_i.writedata;

				when (x"0008000A") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(14 downto 7) <= fee_rmap_i.writedata;

				when (x"0008000B") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(6 downto 0) <= fee_rmap_i.writedata(7 downto 1);

				when (x"0008000C") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vccd     <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vclk     <= fee_rmap_i.writedata(2);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van1     <= fee_rmap_i.writedata(3);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van2     <= fee_rmap_i.writedata(4);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van3     <= fee_rmap_i.writedata(5);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_sw <= fee_rmap_i.writedata(7);

				when (x"0008000D") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_reset   <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_reset   <= fee_rmap_i.writedata(2);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_adc_en  <= fee_rmap_i.writedata(3);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_adc_en  <= fee_rmap_i.writedata(4);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_pix_en  <= fee_rmap_i.writedata(5);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_pix_en  <= fee_rmap_i.writedata(6);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_vasp <= fee_rmap_i.writedata(7);

				when (x"0008000E") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc_clk_en      <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_pwdn_n     <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_pwdn_n     <= fee_rmap_i.writedata(2);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.en_v_mux_n      <= fee_rmap_i.writedata(3);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.pt1000_cal_on_n <= fee_rmap_i.writedata(4);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_en_p5v0    <= fee_rmap_i.writedata(5);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_en_p5v0    <= fee_rmap_i.writedata(6);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_adc    <= fee_rmap_i.writedata(7);

				when (x"00080010") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_ccdid             <= fee_rmap_i.writedata(7 downto 6);

				when (x"00080011") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080012") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00080013") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080014") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp_cfg_addr <= fee_rmap_i.writedata;

				when (x"00080015") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_cfg_data <= fee_rmap_i.writedata;

				when (x"00080016") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_cfg_data <= fee_rmap_i.writedata;

				when (x"00080017") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_write_start   <= fee_rmap_i.writedata(0);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_read_start    <= fee_rmap_i.writedata(1);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.calibration_start <= fee_rmap_i.writedata(2);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_select      <= fee_rmap_i.writedata(3);
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_select      <= fee_rmap_i.writedata(4);

				when (x"00080018") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vog(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"00080019") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vog(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008001A") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vrd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0008001B") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vrd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008001C") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_2.dac_vod(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);

				when (x"0008001D") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_dac_config_2.dac_vod(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080024") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vccd_on <= fee_rmap_i.writedata;

				when (x"00080025") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vclk_on <= fee_rmap_i.writedata;

				when (x"00080026") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van1_on <= fee_rmap_i.writedata;

				when (x"00080027") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van2_on <= fee_rmap_i.writedata;

				when (x"00080028") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van3_on <= fee_rmap_i.writedata;

				when (x"00080029") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vccd_off <= fee_rmap_i.writedata;

				when (x"0008002A") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vclk_off <= fee_rmap_i.writedata;

				when (x"0008002B") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van1_off <= fee_rmap_i.writedata;

				when (x"0008002C") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van2_off <= fee_rmap_i.writedata;

				when (x"0008002D") =>
					-- AEB 4 Critical Configuration Area : 
					rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van3_off <= fee_rmap_i.writedata;

				when (x"00080100") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_stat   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_chop   <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_bypas  <= fee_rmap_i.writedata(7);

				when (x"00080101") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_idlmod <= fee_rmap_i.writedata(7);

				when (x"00080102") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp3 <= fee_rmap_i.writedata(7);

				when (x"00080103") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff7 <= fee_rmap_i.writedata(7);

				when (x"00080104") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain7 <= fee_rmap_i.writedata(7);

				when (x"00080105") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain15 <= fee_rmap_i.writedata(7);

				when (x"00080106") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_offset <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_temp   <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_gain   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ref    <= fee_rmap_i.writedata(5);

				when (x"00080107") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio7 <= fee_rmap_i.writedata(7);

				when (x"00080108") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio7 <= fee_rmap_i.writedata(7);

				when (x"0008010C") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_stat   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_chop   <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_clkenb <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_bypas  <= fee_rmap_i.writedata(7);

				when (x"0008010D") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs0  <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs1  <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly0   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly1   <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly2   <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_idlmod <= fee_rmap_i.writedata(7);

				when (x"0008010E") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp0 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp1 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp2 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp3 <= fee_rmap_i.writedata(7);

				when (x"0008010F") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff7 <= fee_rmap_i.writedata(7);

				when (x"00080110") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain7 <= fee_rmap_i.writedata(7);

				when (x"00080111") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain8  <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain9  <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain10 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain11 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain12 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain13 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain14 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain15 <= fee_rmap_i.writedata(7);

				when (x"00080112") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_offset <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_vcc    <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_temp   <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_gain   <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ref    <= fee_rmap_i.writedata(5);

				when (x"00080113") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio7 <= fee_rmap_i.writedata(7);

				when (x"00080114") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio0 <= fee_rmap_i.writedata(0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio1 <= fee_rmap_i.writedata(1);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio2 <= fee_rmap_i.writedata(2);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio3 <= fee_rmap_i.writedata(3);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio4 <= fee_rmap_i.writedata(4);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio5 <= fee_rmap_i.writedata(5);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio6 <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio7 <= fee_rmap_i.writedata(7);

				when (x"00080120") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(21 downto 16) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00080121") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00080122") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080123") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.adc_clk_div <= fee_rmap_i.writedata(6 downto 0);

				when (x"00080124") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00080125") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00080126") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00080127") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00080130") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00080131") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080132") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_enabled               <= fee_rmap_i.writedata(7);

				when (x"00080133") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080134") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_enabled               <= fee_rmap_i.writedata(7);

				when (x"00080135") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080136") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_enabled               <= fee_rmap_i.writedata(7);

				when (x"00080137") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080138") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_pixreadout            <= fee_rmap_i.writedata(6);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_enabled               <= fee_rmap_i.writedata(7);

				when (x"00080139") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008013A") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0008013B") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008013C") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_enabled               <= fee_rmap_i.writedata(7);

				when (x"0008013D") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008013E") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"0008013F") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00080140") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00080141") =>
					-- AEB 4 General Configuration Area : 
					rmap_registers_wr_o.aeb4_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081000") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.aeb_state <= fee_rmap_i.writedata(2 downto 0);

				when (x"00081001") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd_run <= fee_rmap_i.writedata(0);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr_run <= fee_rmap_i.writedata(1);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd_run <= fee_rmap_i.writedata(2);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.dac_cfg_w_run  <= fee_rmap_i.writedata(3);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.vasp1_cfg_run  <= fee_rmap_i.writedata(6);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.vasp2_cfg_run  <= fee_rmap_i.writedata(7);

				when (x"00081002") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_busy  <= fee_rmap_i.writedata(0);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_busy  <= fee_rmap_i.writedata(1);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr <= fee_rmap_i.writedata(2);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd <= fee_rmap_i.writedata(3);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd <= fee_rmap_i.writedata(4);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_lu    <= fee_rmap_i.writedata(5);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_lu    <= fee_rmap_i.writedata(6);
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.adc_error  <= fee_rmap_i.writedata(7);

				when (x"00081006") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.frame_counter(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081007") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_aeb_status.frame_counter(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081008") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081009") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008100A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008100B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008100C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008100D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008100E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008100F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081010") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081011") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081012") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081013") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081014") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081015") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081016") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081017") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081018") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081019") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008101A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008101B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008101C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008101D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008101E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008101F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081020") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081021") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081022") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081023") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081024") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081025") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081026") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081027") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081028") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081029") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008102A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008102B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008102C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008102D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008102E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008102F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081030") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081031") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081032") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081033") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081034") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081035") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081036") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081037") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081038") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081039") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008103A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008103B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008103C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008103D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008103E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008103F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081040") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081041") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081042") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081043") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081044") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081045") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081046") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081047") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081048") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081049") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008104A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008104B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008104C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008104D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008104E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008104F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081050") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081051") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081052") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081053") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081054") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081055") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081056") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081057") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081058") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081059") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008105A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008105B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081080") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081081") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081082") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081083") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081084") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081085") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081086") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081087") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081088") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081089") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008108A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008108B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008108C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008108D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008108E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008108F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081090") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081091") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081092") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081093") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081094") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081095") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00081096") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00081097") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00081098") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00081099") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008109A") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008109B") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0008109C") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0008109D") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0008109E") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0008109F") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000810A0") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp1_read_data <= fee_rmap_i.writedata;

				when (x"000810A1") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp2_read_data <= fee_rmap_i.writedata;

				when (x"000811F0") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_ver(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000811F1") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_ver(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000811F2") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_date(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000811F3") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_date(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000811F4") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_time(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000811F5") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_time(7 downto 0) <= fee_rmap_i.writedata;

				when (x"000811F6") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_svn(15 downto 8) <= fee_rmap_i.writedata;

				when (x"000811F7") =>
					-- AEB 4 Housekeeping Area : 
					rmap_registers_wr_o.aeb4_hk_revision_id.fpga_svn(7 downto 0) <= fee_rmap_i.writedata;

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

				when (16#000#) =>
					-- DEB Critical Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#001#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#002#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#003#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_aeb_idx.vdig_aeb1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#004#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_3.pll_reg_word_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#005#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_2.pll_reg_word_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#006#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_1.pll_reg_word_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#007#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_ccfg_reg_dta_0.pll_reg_word_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#008#) =>
					-- DEB General Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_oper_mod.imm <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#009#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_oper_mod.oper_mod <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_t7_in_mod.in_mod7 <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_t6_in_mod.in_mod6 <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_t5_in_mod.in_mod5 <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#00A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_t4_in_mod.in_mod4 <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_t3_in_mod.in_mod3 <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_t2_in_mod.in_mod2 <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_t1_in_mod.in_mod1 <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#00B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_t0_in_mod.in_mod0 <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_w_siz_x.w_siz_x <= avalon_mm_rmap_i.writedata(14 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_w_siz_y.w_siz_y <= avalon_mm_rmap_i.writedata(22 downto 16);
					end if;

				when (16#00C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_4.wdw_idx_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_4.wdw_idx_4(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_4.wdw_len_4(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_4.wdw_len_4(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#00D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_3.wdw_idx_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_3.wdw_idx_3(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_3.wdw_len_3(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_3.wdw_len_3(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#00E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_2.wdw_idx_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_2.wdw_idx_2(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_2.wdw_len_2(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_2.wdw_len_2(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#00F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_1.wdw_idx_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_idx_1.wdw_idx_1(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_1.wdw_len_1(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_wdw_len_1.wdw_len_1(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#010#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_lin_4.ovs_lin_4 <= avalon_mm_rmap_i.writedata(4 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_lin_3.ovs_lin_3 <= avalon_mm_rmap_i.writedata(12 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_lin_2.ovs_lin_2 <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_lin_1.ovs_lin_1 <= avalon_mm_rmap_i.writedata(28 downto 24);
					end if;

				when (16#011#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_pix_4.ovs_pix_4 <= avalon_mm_rmap_i.writedata(4 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_pix_3.ovs_pix_3 <= avalon_mm_rmap_i.writedata(12 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_pix_2.ovs_pix_2 <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gcfg_ovs_pix_1.ovs_pix_1 <= avalon_mm_rmap_i.writedata(28 downto 24);
					end if;

				when (16#012#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_2_5s_n_cyc.d2_5s_n_cyc <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#013#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_trg_src.sel_trg <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#014#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_frm_cnt.frm_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_frm_cnt.frm_cnt(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#015#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_syn_frq.syn_nr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#016#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_rst_wdg.rst_wdg <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#017#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_rst_cps.rst_cps <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#018#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gcfg_25s_dly.d25s_dly(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;

				when (16#019#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gcfg_tmod_conf.tmod_conf(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gcfg_tmod_conf.tmod_conf(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- DEB Housekeeping Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.oper_mod <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.window_list_table_edac_corrected_error_number <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#01A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.uncorrected_error_number <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.pll_status <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#01B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb4_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#01C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb3_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#01D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb2_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#01E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb1_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#01F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.wdw_list_cnt_ovf <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;

				when (16#020#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.aeb_spi_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#021#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.wdg_status <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#022#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list8_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#023#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list7_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#024#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list6_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#025#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list5_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#026#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list4_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#027#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list3_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#028#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list2_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#029#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.row_active_list1_cnt_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff8_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff7_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff6_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff5_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff4_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff3_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#030#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff2_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#031#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.out_buff1_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#032#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.rmap4_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#033#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.rmap3_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#034#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.rmap2_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#035#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.rmap1_ovf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#036#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf.line_pixel_counters_overflow <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#037#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_spw_status.spw_status(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_spw_status.spw_status(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_spw_status.spw_status(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_spw_status.spw_status(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#038#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vio(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vio(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#039#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#03A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- AEB 1 Critical Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.new_state <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;

				when (16#03B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.set_state <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#03C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.aeb_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#03D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_data_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#03E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#03F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#040#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_control.dac_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#041#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config.watchdog_dis <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#042#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config.int_sync <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#043#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp_cds_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#044#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp2_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#045#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config.vasp1_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#046#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_key.key(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#047#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_sw <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#048#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#049#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_van1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vclk <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.sw_vccd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_vasp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#050#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#051#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#052#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp2_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#053#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.vasp1_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#054#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.override_adc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#055#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#056#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#057#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.pt1000_cal_on_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#058#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.en_v_mux_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#059#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc2_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#05A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc1_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#05B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_ait1.adc_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#05C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_ccdid <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#05D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp_cfg_addr <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_cfg_data <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#05E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_cfg_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#05F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp2_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#060#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.vasp1_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#061#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.calibration_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#062#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_read_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#063#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_vasp_i2c_control.i2c_write_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#064#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vog(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_1.dac_vrd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#065#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_2.dac_vod(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_dac_config_2.dac_vod(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vccd_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_vclk_on <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#066#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van1_on <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config1.time_van2_on <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van3_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vccd_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#067#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_vclk_off <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config2.time_van1_off <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van2_off <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_ccfg_pwr_config3.time_van3_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#068#) =>
					-- AEB 1 General Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#069#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#070#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#071#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#072#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#073#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#074#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#075#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#076#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#077#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#078#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#079#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#080#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#081#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#082#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#083#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#084#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#085#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#086#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#087#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#088#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#089#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#090#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#091#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#092#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#093#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#094#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#095#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#096#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#097#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#098#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#099#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc1_config.adc1_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0AF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0BF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0CF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0DF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_adc2_config.adc2_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0EA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.seq_oe(21 downto 16) <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;

				when (16#0EB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.adc_clk_div <= avalon_mm_rmap_i.writedata(6 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_low_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.cds_clk_high_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_low_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#0EC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.rphir_clk_high_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#0ED#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0EE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0EF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#0F0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#0F3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#0F6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#0F9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0FA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#0FB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- AEB 1 Housekeeping Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.aeb_state <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;

				when (16#0FC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.vasp2_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0FD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.vasp1_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0FE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.dac_cfg_w_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0FF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#100#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#101#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#102#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_error <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#103#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#104#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#105#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_dat_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#106#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#107#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#108#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc2_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#109#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.adc1_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#10A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.frame_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_aeb_status.frame_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#10B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#10C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_timestamp.timestamp_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#10D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#10E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#10F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#110#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#111#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#112#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#113#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#114#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#115#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#116#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#117#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#118#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#119#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#11F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#120#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#121#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#122#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#123#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#124#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#125#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#126#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#127#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#128#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp1_read_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_vasp_rd_config.vasp2_read_data <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_ver(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_ver(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#129#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_date(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_date(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_time(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_time(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#12A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_svn(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb1_hk_revision_id.fpga_svn(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- AEB 2 Critical Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.new_state <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;

				when (16#12B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.set_state <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#12C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.aeb_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#12D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_data_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#12E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#12F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#130#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_control.dac_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#131#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config.watchdog_dis <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#132#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config.int_sync <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#133#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp_cds_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#134#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp2_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#135#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config.vasp1_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#136#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_key.key(30 downto 24) <= avalon_mm_rmap_i.writedata(30 downto 24);
					end if;

				when (16#137#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_sw <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#138#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#139#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_van1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vclk <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.sw_vccd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_vasp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#140#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#141#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#142#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp2_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#143#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.vasp1_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#144#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.override_adc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#145#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#146#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#147#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.pt1000_cal_on_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#148#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.en_v_mux_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#149#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc2_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#14A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc1_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#14B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_ait1.adc_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#14C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_ccdid <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#14D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp_cfg_addr <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_cfg_data <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#14E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_cfg_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#14F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp2_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#150#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.vasp1_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#151#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.calibration_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#152#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_read_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#153#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_vasp_i2c_control.i2c_write_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#154#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vog(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_1.dac_vrd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#155#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_2.dac_vod(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_dac_config_2.dac_vod(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vccd_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_vclk_on <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#156#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van1_on <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config1.time_van2_on <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van3_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vccd_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#157#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_vclk_off <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config2.time_van1_off <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van2_off <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_ccfg_pwr_config3.time_van3_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#158#) =>
					-- AEB 2 General Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#159#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#15F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#160#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#161#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#162#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#163#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#164#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#165#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#166#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#167#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#168#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#169#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#170#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#171#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#172#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#173#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#174#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#175#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#176#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#177#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#178#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#179#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#180#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#181#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#182#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#183#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#184#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#185#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#186#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#187#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#188#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#189#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#190#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#191#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#192#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#193#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#194#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#195#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#196#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#197#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#198#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc1_config.adc1_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#199#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1AF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1BF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1CF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_adc2_config.adc2_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1DA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.seq_oe(21 downto 16) <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;

				when (16#1DB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.adc_clk_div <= avalon_mm_rmap_i.writedata(6 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_low_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.cds_clk_high_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_low_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1DC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.rphir_clk_high_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#1DD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1DE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1DF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#1E0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#1E3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#1E6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#1E9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1EA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#1EB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- AEB 2 Housekeeping Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.aeb_state <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;

				when (16#1EC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.vasp2_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1ED#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.vasp1_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1EE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.dac_cfg_w_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1EF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_error <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_dat_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc2_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1F9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.adc1_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1FA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.frame_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_aeb_status.frame_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#1FB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1FC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_timestamp.timestamp_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1FD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1FE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#1FF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#200#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#201#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#202#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#203#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#204#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#205#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#206#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#207#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#208#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#209#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#20F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#210#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#211#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#212#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#213#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#214#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#215#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#216#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#217#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#218#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp1_read_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_vasp_rd_config.vasp2_read_data <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_ver(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_ver(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#219#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_date(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_date(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_time(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_time(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#21A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_svn(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb2_hk_revision_id.fpga_svn(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- AEB 3 Critical Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.new_state <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;

				when (16#21B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.set_state <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#21C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.aeb_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#21D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_data_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#21E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#21F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#220#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_control.dac_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#221#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config.watchdog_dis <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#222#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config.int_sync <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#223#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp_cds_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#224#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp2_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#225#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config.vasp1_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#226#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_key.key(30 downto 24) <= avalon_mm_rmap_i.writedata(30 downto 24);
					end if;

				when (16#227#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_sw <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#228#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#229#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_van1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vclk <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.sw_vccd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_vasp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#230#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#231#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#232#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp2_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#233#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.vasp1_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#234#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.override_adc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#235#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#236#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#237#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.pt1000_cal_on_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#238#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.en_v_mux_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#239#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc2_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#23A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc1_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#23B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_ait1.adc_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#23C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_ccdid <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#23D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp_cfg_addr <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_cfg_data <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#23E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_cfg_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#23F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp2_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#240#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.vasp1_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#241#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.calibration_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#242#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_read_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#243#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_vasp_i2c_control.i2c_write_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#244#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vog(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_1.dac_vrd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#245#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_2.dac_vod(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_dac_config_2.dac_vod(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vccd_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_vclk_on <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#246#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van1_on <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config1.time_van2_on <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van3_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vccd_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#247#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_vclk_off <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config2.time_van1_off <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van2_off <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_ccfg_pwr_config3.time_van3_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#248#) =>
					-- AEB 3 General Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#249#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#250#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#251#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#252#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#253#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#254#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#255#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#256#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#257#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#258#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#259#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#260#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#261#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#262#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#263#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#264#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#265#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#266#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#267#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#268#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#269#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#270#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#271#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#272#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#273#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#274#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#275#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#276#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#277#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#278#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#279#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#280#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#281#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#282#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#283#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#284#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#285#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#286#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#287#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#288#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc1_config.adc1_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#289#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#290#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#291#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#292#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#293#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#294#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#295#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#296#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#297#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#298#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#299#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2A9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2AF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2B9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2BF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_adc2_config.adc2_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2CA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.seq_oe(21 downto 16) <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;

				when (16#2CB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.adc_clk_div <= avalon_mm_rmap_i.writedata(6 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_low_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.cds_clk_high_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_low_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2CC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.rphir_clk_high_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#2CD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2CE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2CF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#2D0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#2D3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#2D6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#2D9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2DA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#2DB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- AEB 3 Housekeeping Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.aeb_state <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;

				when (16#2DC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.vasp2_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2DD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.vasp1_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2DE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.dac_cfg_w_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2DF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_error <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_dat_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc2_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2E9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.adc1_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2EA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.frame_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_aeb_status.frame_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#2EB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2EC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_timestamp.timestamp_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2ED#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2EE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2EF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2F9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#2FF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#300#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#301#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#302#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#303#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#304#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#305#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#306#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#307#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#308#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp1_read_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_vasp_rd_config.vasp2_read_data <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_ver(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_ver(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#309#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_date(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_date(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_time(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_time(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#30A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_svn(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb3_hk_revision_id.fpga_svn(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					-- AEB 4 Critical Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.new_state <= avalon_mm_rmap_i.writedata(20 downto 16);
					end if;

				when (16#30B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.set_state <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#30C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.aeb_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#30D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_data_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#30E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#30F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#310#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_control.dac_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#311#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config.watchdog_dis <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#312#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config.int_sync <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#313#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp_cds_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#314#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp2_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#315#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config.vasp1_cal_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#316#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_key.key(30 downto 24) <= avalon_mm_rmap_i.writedata(30 downto 24);
					end if;

				when (16#317#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_sw <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#318#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#319#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_van1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vclk <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.sw_vccd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_vasp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#31F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_pix_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#320#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#321#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_adc_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#322#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp2_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#323#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.vasp1_reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#324#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.override_adc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#325#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#326#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#327#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.pt1000_cal_on_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#328#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.en_v_mux_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#329#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc2_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#32A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc1_pwdn_n <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#32B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_ait1.adc_clk_en <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#32C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_ccdid <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_cols(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_cols(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#32D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_rows(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_aeb_config_pattern.pattern_rows(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp_cfg_addr <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_cfg_data <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#32E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_cfg_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#32F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp2_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#330#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.vasp1_select <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#331#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.calibration_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#332#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_read_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#333#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_vasp_i2c_control.i2c_write_start <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#334#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vog(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_1.dac_vrd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#335#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_2.dac_vod(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_dac_config_2.dac_vod(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vccd_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_vclk_on <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#336#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van1_on <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config1.time_van2_on <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van3_on <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vccd_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#337#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_vclk_off <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config2.time_van1_off <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van2_off <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_ccfg_pwr_config3.time_van3_off <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#338#) =>
					-- AEB 4 General Configuration Area : 
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#339#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#33F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#340#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#341#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#342#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#343#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#344#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#345#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#346#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#347#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#348#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#349#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#34F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#350#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#351#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#352#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#353#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#354#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#355#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#356#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#357#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#358#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#359#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#35F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#360#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#361#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#362#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#363#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#364#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#365#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#366#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#367#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#368#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#369#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#36F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#370#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#371#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#372#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#373#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#374#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#375#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#376#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#377#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#378#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc1_config.adc1_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#379#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_bypas <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_clkenb <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_chop <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_stat <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_idlmod <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#37F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#380#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dly0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#381#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#382#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_sbcs0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#383#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#384#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_drate0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#385#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#386#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#387#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#388#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainp0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#389#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ainn0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#38F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#390#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#391#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#392#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#393#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#394#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_diff0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#395#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#396#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#397#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#398#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#399#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39A#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39B#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39C#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39D#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain15 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39E#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain14 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39F#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain13 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain12 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain11 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain10 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain9 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ain8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_gain <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_temp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_vcc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3A9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_offset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3AF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_cio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_adc2_config.adc2_dio0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3BA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.seq_oe(21 downto 16) <= avalon_mm_rmap_i.writedata(21 downto 16);
					end if;

				when (16#3BB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.adc_clk_div <= avalon_mm_rmap_i.writedata(6 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_low_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.cds_clk_high_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_low_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3BC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.rphir_clk_high_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.ft_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.ft_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#3BD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3BE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3BF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt0_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#3C0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#3C3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;

				when (16#3C6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_pixreadout <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.lt3_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.pix_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.pix_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#3C9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_enabled <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3CA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.pc_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.int1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.int1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
					end if;

				when (16#3CB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.int2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_gcfg_seq_config.int2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- AEB 4 Housekeeping Area : 
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.aeb_state <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;

				when (16#3CC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.vasp2_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3CD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.vasp1_cfg_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3CE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.dac_cfg_w_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3CF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd_run <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_error <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_lu <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_dat_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc2_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.adc1_busy <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3DA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.frame_counter(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_aeb_status.frame_counter(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#3DB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3DC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_timestamp.timestamp_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3DD#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_18(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3DE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_17(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3DF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_16(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_15(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_14(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_13(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_12(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_11(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_10(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_9(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_8(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_7(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3E9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_6(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3EA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_5(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3EB#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_4(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3EC#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3ED#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3EE#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3EF#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc_rd_data.adc_rd_data_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F0#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F1#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F2#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F3#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc1_rd_config.adc1_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F4#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_3(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F5#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_2(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F6#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F7#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_adc2_rd_config.adc2_rd_config_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F8#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp1_read_data <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_vasp_rd_config.vasp2_read_data <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_ver(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_ver(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F9#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_date(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_date(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_time(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_time(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3FA#) =>
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_svn(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.aeb4_hk_revision_id.fpga_svn(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_avs_writedata;

		variable v_fee_write_address : std_logic_vector(31 downto 0) := (others => '0');
		variable v_avs_write_address : t_avalon_mm_spacewire_address := 0;
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
	end process p_rmap_mem_area_nfee_write;

end architecture RTL;
