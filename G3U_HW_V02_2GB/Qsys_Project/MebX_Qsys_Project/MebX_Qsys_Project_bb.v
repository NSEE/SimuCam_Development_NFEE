
module MebX_Qsys_Project (
	button_export,
	clk50_clk,
	comm_a_conduit_end_spw_si_signal,
	comm_a_conduit_end_spw_di_signal,
	comm_a_conduit_end_spw_do_signal,
	comm_a_conduit_end_spw_so_signal,
	comm_b_conduit_end_spw_si_signal,
	comm_b_conduit_end_spw_di_signal,
	comm_b_conduit_end_spw_do_signal,
	comm_b_conduit_end_spw_so_signal,
	comm_c_conduit_end_spw_si_signal,
	comm_c_conduit_end_spw_di_signal,
	comm_c_conduit_end_spw_do_signal,
	comm_c_conduit_end_spw_so_signal,
	comm_d_conduit_end_spw_si_signal,
	comm_d_conduit_end_spw_di_signal,
	comm_d_conduit_end_spw_do_signal,
	comm_d_conduit_end_spw_so_signal,
	comm_e_conduit_end_spw_si_signal,
	comm_e_conduit_end_spw_di_signal,
	comm_e_conduit_end_spw_do_signal,
	comm_e_conduit_end_spw_so_signal,
	comm_f_conduit_end_spw_si_signal,
	comm_f_conduit_end_spw_di_signal,
	comm_f_conduit_end_spw_do_signal,
	comm_f_conduit_end_spw_so_signal,
	comm_g_conduit_end_spw_si_signal,
	comm_g_conduit_end_spw_di_signal,
	comm_g_conduit_end_spw_do_signal,
	comm_g_conduit_end_spw_so_signal,
	comm_h_conduit_end_spw_si_signal,
	comm_h_conduit_end_spw_di_signal,
	comm_h_conduit_end_spw_do_signal,
	comm_h_conduit_end_spw_so_signal,
	csense_adc_fo_export,
	csense_cs_n_export,
	csense_sck_export,
	csense_sdi_export,
	csense_sdo_export,
	dip_export,
	eth_rst_export,
	ext_export,
	led_de4_export,
	led_painel_export,
	m1_ddr2_i2c_scl_export,
	m1_ddr2_i2c_sda_export,
	m1_ddr2_memory_mem_a,
	m1_ddr2_memory_mem_ba,
	m1_ddr2_memory_mem_ck,
	m1_ddr2_memory_mem_ck_n,
	m1_ddr2_memory_mem_cke,
	m1_ddr2_memory_mem_cs_n,
	m1_ddr2_memory_mem_dm,
	m1_ddr2_memory_mem_ras_n,
	m1_ddr2_memory_mem_cas_n,
	m1_ddr2_memory_mem_we_n,
	m1_ddr2_memory_mem_dq,
	m1_ddr2_memory_mem_dqs,
	m1_ddr2_memory_mem_dqs_n,
	m1_ddr2_memory_mem_odt,
	m1_ddr2_memory_pll_ref_clk_clk,
	m1_ddr2_memory_status_local_init_done,
	m1_ddr2_memory_status_local_cal_success,
	m1_ddr2_memory_status_local_cal_fail,
	m1_ddr2_oct_rdn,
	m1_ddr2_oct_rup,
	m2_ddr2_i2c_scl_export,
	m2_ddr2_i2c_sda_export,
	m2_ddr2_memory_mem_a,
	m2_ddr2_memory_mem_ba,
	m2_ddr2_memory_mem_ck,
	m2_ddr2_memory_mem_ck_n,
	m2_ddr2_memory_mem_cke,
	m2_ddr2_memory_mem_cs_n,
	m2_ddr2_memory_mem_dm,
	m2_ddr2_memory_mem_ras_n,
	m2_ddr2_memory_mem_cas_n,
	m2_ddr2_memory_mem_we_n,
	m2_ddr2_memory_mem_dq,
	m2_ddr2_memory_mem_dqs,
	m2_ddr2_memory_mem_dqs_n,
	m2_ddr2_memory_mem_odt,
	m2_ddr2_memory_dll_sharing_dll_pll_locked,
	m2_ddr2_memory_dll_sharing_dll_delayctrl,
	m2_ddr2_memory_pll_sharing_pll_mem_clk,
	m2_ddr2_memory_pll_sharing_pll_write_clk,
	m2_ddr2_memory_pll_sharing_pll_locked,
	m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk,
	m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,
	m2_ddr2_memory_pll_sharing_pll_avl_clk,
	m2_ddr2_memory_pll_sharing_pll_config_clk,
	m2_ddr2_memory_status_local_init_done,
	m2_ddr2_memory_status_local_cal_success,
	m2_ddr2_memory_status_local_cal_fail,
	m2_ddr2_oct_rdn,
	m2_ddr2_oct_rup,
	rst_reset_n,
	rtcc_alarm_export,
	rtcc_cs_n_export,
	rtcc_sck_export,
	rtcc_sdi_export,
	rtcc_sdo_export,
	sd_clk_export,
	sd_cmd_export,
	sd_dat_export,
	sd_wp_n_export,
	sinc_in_export,
	sinc_out_export,
	ssdp_ssdp0,
	ssdp_ssdp1,
	temp_scl_export,
	temp_sda_export,
	timer_1ms_external_port_export,
	timer_1us_external_port_export,
	tristate_conduit_tcm_address_out,
	tristate_conduit_tcm_read_n_out,
	tristate_conduit_tcm_write_n_out,
	tristate_conduit_tcm_data_out,
	tristate_conduit_tcm_chipselect_n_out,
	tse_clk_clk,
	tse_led_crs,
	tse_led_link,
	tse_led_panel_link,
	tse_led_col,
	tse_led_an,
	tse_led_char_err,
	tse_led_disp_err,
	tse_mac_mac_misc_connection_xon_gen,
	tse_mac_mac_misc_connection_xoff_gen,
	tse_mac_mac_misc_connection_magic_wakeup,
	tse_mac_mac_misc_connection_magic_sleep_n,
	tse_mac_mac_misc_connection_ff_tx_crc_fwd,
	tse_mac_mac_misc_connection_ff_tx_septy,
	tse_mac_mac_misc_connection_tx_ff_uflow,
	tse_mac_mac_misc_connection_ff_tx_a_full,
	tse_mac_mac_misc_connection_ff_tx_a_empty,
	tse_mac_mac_misc_connection_rx_err_stat,
	tse_mac_mac_misc_connection_rx_frm_type,
	tse_mac_mac_misc_connection_ff_rx_dsav,
	tse_mac_mac_misc_connection_ff_rx_a_full,
	tse_mac_mac_misc_connection_ff_rx_a_empty,
	tse_mac_serdes_control_connection_export,
	tse_mdio_mdc,
	tse_mdio_mdio_in,
	tse_mdio_mdio_out,
	tse_mdio_mdio_oen,
	tse_serial_txp,
	tse_serial_rxp);	

	input	[3:0]	button_export;
	input		clk50_clk;
	input		comm_a_conduit_end_spw_si_signal;
	input		comm_a_conduit_end_spw_di_signal;
	output		comm_a_conduit_end_spw_do_signal;
	output		comm_a_conduit_end_spw_so_signal;
	input		comm_b_conduit_end_spw_si_signal;
	input		comm_b_conduit_end_spw_di_signal;
	output		comm_b_conduit_end_spw_do_signal;
	output		comm_b_conduit_end_spw_so_signal;
	input		comm_c_conduit_end_spw_si_signal;
	input		comm_c_conduit_end_spw_di_signal;
	output		comm_c_conduit_end_spw_do_signal;
	output		comm_c_conduit_end_spw_so_signal;
	input		comm_d_conduit_end_spw_si_signal;
	input		comm_d_conduit_end_spw_di_signal;
	output		comm_d_conduit_end_spw_do_signal;
	output		comm_d_conduit_end_spw_so_signal;
	input		comm_e_conduit_end_spw_si_signal;
	input		comm_e_conduit_end_spw_di_signal;
	output		comm_e_conduit_end_spw_do_signal;
	output		comm_e_conduit_end_spw_so_signal;
	input		comm_f_conduit_end_spw_si_signal;
	input		comm_f_conduit_end_spw_di_signal;
	output		comm_f_conduit_end_spw_do_signal;
	output		comm_f_conduit_end_spw_so_signal;
	input		comm_g_conduit_end_spw_si_signal;
	input		comm_g_conduit_end_spw_di_signal;
	output		comm_g_conduit_end_spw_do_signal;
	output		comm_g_conduit_end_spw_so_signal;
	input		comm_h_conduit_end_spw_si_signal;
	input		comm_h_conduit_end_spw_di_signal;
	output		comm_h_conduit_end_spw_do_signal;
	output		comm_h_conduit_end_spw_so_signal;
	output		csense_adc_fo_export;
	output	[1:0]	csense_cs_n_export;
	output		csense_sck_export;
	output		csense_sdi_export;
	input		csense_sdo_export;
	input	[7:0]	dip_export;
	output		eth_rst_export;
	input		ext_export;
	output	[7:0]	led_de4_export;
	output	[20:0]	led_painel_export;
	output		m1_ddr2_i2c_scl_export;
	inout		m1_ddr2_i2c_sda_export;
	output	[13:0]	m1_ddr2_memory_mem_a;
	output	[2:0]	m1_ddr2_memory_mem_ba;
	output	[1:0]	m1_ddr2_memory_mem_ck;
	output	[1:0]	m1_ddr2_memory_mem_ck_n;
	output	[1:0]	m1_ddr2_memory_mem_cke;
	output	[1:0]	m1_ddr2_memory_mem_cs_n;
	output	[7:0]	m1_ddr2_memory_mem_dm;
	output	[0:0]	m1_ddr2_memory_mem_ras_n;
	output	[0:0]	m1_ddr2_memory_mem_cas_n;
	output	[0:0]	m1_ddr2_memory_mem_we_n;
	inout	[63:0]	m1_ddr2_memory_mem_dq;
	inout	[7:0]	m1_ddr2_memory_mem_dqs;
	inout	[7:0]	m1_ddr2_memory_mem_dqs_n;
	output	[1:0]	m1_ddr2_memory_mem_odt;
	input		m1_ddr2_memory_pll_ref_clk_clk;
	output		m1_ddr2_memory_status_local_init_done;
	output		m1_ddr2_memory_status_local_cal_success;
	output		m1_ddr2_memory_status_local_cal_fail;
	input		m1_ddr2_oct_rdn;
	input		m1_ddr2_oct_rup;
	output		m2_ddr2_i2c_scl_export;
	inout		m2_ddr2_i2c_sda_export;
	output	[13:0]	m2_ddr2_memory_mem_a;
	output	[2:0]	m2_ddr2_memory_mem_ba;
	output	[1:0]	m2_ddr2_memory_mem_ck;
	output	[1:0]	m2_ddr2_memory_mem_ck_n;
	output	[1:0]	m2_ddr2_memory_mem_cke;
	output	[1:0]	m2_ddr2_memory_mem_cs_n;
	output	[7:0]	m2_ddr2_memory_mem_dm;
	output	[0:0]	m2_ddr2_memory_mem_ras_n;
	output	[0:0]	m2_ddr2_memory_mem_cas_n;
	output	[0:0]	m2_ddr2_memory_mem_we_n;
	inout	[63:0]	m2_ddr2_memory_mem_dq;
	inout	[7:0]	m2_ddr2_memory_mem_dqs;
	inout	[7:0]	m2_ddr2_memory_mem_dqs_n;
	output	[1:0]	m2_ddr2_memory_mem_odt;
	input		m2_ddr2_memory_dll_sharing_dll_pll_locked;
	output	[5:0]	m2_ddr2_memory_dll_sharing_dll_delayctrl;
	output		m2_ddr2_memory_pll_sharing_pll_mem_clk;
	output		m2_ddr2_memory_pll_sharing_pll_write_clk;
	output		m2_ddr2_memory_pll_sharing_pll_locked;
	output		m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk;
	output		m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk;
	output		m2_ddr2_memory_pll_sharing_pll_avl_clk;
	output		m2_ddr2_memory_pll_sharing_pll_config_clk;
	output		m2_ddr2_memory_status_local_init_done;
	output		m2_ddr2_memory_status_local_cal_success;
	output		m2_ddr2_memory_status_local_cal_fail;
	input		m2_ddr2_oct_rdn;
	input		m2_ddr2_oct_rup;
	input		rst_reset_n;
	input		rtcc_alarm_export;
	output		rtcc_cs_n_export;
	output		rtcc_sck_export;
	output		rtcc_sdi_export;
	input		rtcc_sdo_export;
	output		sd_clk_export;
	inout		sd_cmd_export;
	inout	[3:0]	sd_dat_export;
	input		sd_wp_n_export;
	input		sinc_in_export;
	output		sinc_out_export;
	output	[7:0]	ssdp_ssdp0;
	output	[7:0]	ssdp_ssdp1;
	output		temp_scl_export;
	inout		temp_sda_export;
	output		timer_1ms_external_port_export;
	output		timer_1us_external_port_export;
	output	[25:0]	tristate_conduit_tcm_address_out;
	output	[0:0]	tristate_conduit_tcm_read_n_out;
	output	[0:0]	tristate_conduit_tcm_write_n_out;
	inout	[15:0]	tristate_conduit_tcm_data_out;
	output	[0:0]	tristate_conduit_tcm_chipselect_n_out;
	input		tse_clk_clk;
	output		tse_led_crs;
	output		tse_led_link;
	output		tse_led_panel_link;
	output		tse_led_col;
	output		tse_led_an;
	output		tse_led_char_err;
	output		tse_led_disp_err;
	input		tse_mac_mac_misc_connection_xon_gen;
	input		tse_mac_mac_misc_connection_xoff_gen;
	output		tse_mac_mac_misc_connection_magic_wakeup;
	input		tse_mac_mac_misc_connection_magic_sleep_n;
	input		tse_mac_mac_misc_connection_ff_tx_crc_fwd;
	output		tse_mac_mac_misc_connection_ff_tx_septy;
	output		tse_mac_mac_misc_connection_tx_ff_uflow;
	output		tse_mac_mac_misc_connection_ff_tx_a_full;
	output		tse_mac_mac_misc_connection_ff_tx_a_empty;
	output	[17:0]	tse_mac_mac_misc_connection_rx_err_stat;
	output	[3:0]	tse_mac_mac_misc_connection_rx_frm_type;
	output		tse_mac_mac_misc_connection_ff_rx_dsav;
	output		tse_mac_mac_misc_connection_ff_rx_a_full;
	output		tse_mac_mac_misc_connection_ff_rx_a_empty;
	output		tse_mac_serdes_control_connection_export;
	output		tse_mdio_mdc;
	input		tse_mdio_mdio_in;
	output		tse_mdio_mdio_out;
	output		tse_mdio_mdio_oen;
	output		tse_serial_txp;
	input		tse_serial_rxp;
endmodule
