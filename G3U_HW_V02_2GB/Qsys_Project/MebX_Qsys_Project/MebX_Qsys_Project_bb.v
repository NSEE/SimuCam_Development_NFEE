
module MebX_Qsys_Project (
	button_export,
	clk50_clk,
	comm_a_measurements_conduit_end_measurements_channel_signal,
	comm_a_sync_end_sync_channel_signal,
	comm_b_measurements_conduit_end_measurements_channel_signal,
	comm_b_sync_end_sync_channel_signal,
	comm_c_measurements_conduit_end_measurements_channel_signal,
	comm_c_sync_end_sync_channel_signal,
	comm_d_measurements_conduit_end_measurements_channel_signal,
	comm_d_sync_end_sync_channel_signal,
	comm_e_measurements_conduit_end_measurements_channel_signal,
	comm_e_sync_end_sync_channel_signal,
	comm_f_measurements_conduit_end_measurements_channel_signal,
	comm_f_sync_end_sync_channel_signal,
	csense_adc_fo_export,
	csense_cs_n_export,
	csense_sck_export,
	csense_sdi_export,
	csense_sdo_export,
	ctrl_io_lvds_export,
	dip_export,
	ext_export,
	ftdi_clk_clk,
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
	rs232_uart_rxd,
	rs232_uart_txd,
	rst_reset_n,
	rst_controller_conduit_reset_input_t_reset_input_signal,
	rst_controller_conduit_simucam_reset_t_simucam_reset_signal,
	rtcc_alarm_export,
	rtcc_cs_n_export,
	rtcc_sck_export,
	rtcc_sdi_export,
	rtcc_sdo_export,
	sd_card_ip_b_SD_cmd,
	sd_card_ip_b_SD_dat,
	sd_card_ip_b_SD_dat3,
	sd_card_ip_o_SD_clock,
	sd_card_wp_n_io_export,
	spwc_a_leds_spw_red_status_led_signal,
	spwc_a_leds_spw_green_status_led_signal,
	spwc_a_lvds_spw_data_in_signal,
	spwc_a_lvds_spw_data_out_signal,
	spwc_a_lvds_spw_strobe_out_signal,
	spwc_a_lvds_spw_strobe_in_signal,
	spwc_b_leds_spw_red_status_led_signal,
	spwc_b_leds_spw_green_status_led_signal,
	spwc_b_lvds_spw_data_in_signal,
	spwc_b_lvds_spw_data_out_signal,
	spwc_b_lvds_spw_strobe_out_signal,
	spwc_b_lvds_spw_strobe_in_signal,
	spwc_c_leds_spw_red_status_led_signal,
	spwc_c_leds_spw_green_status_led_signal,
	spwc_c_lvds_spw_data_in_signal,
	spwc_c_lvds_spw_data_out_signal,
	spwc_c_lvds_spw_strobe_out_signal,
	spwc_c_lvds_spw_strobe_in_signal,
	spwc_d_leds_spw_red_status_led_signal,
	spwc_d_leds_spw_green_status_led_signal,
	spwc_d_lvds_spw_data_in_signal,
	spwc_d_lvds_spw_data_out_signal,
	spwc_d_lvds_spw_strobe_out_signal,
	spwc_d_lvds_spw_strobe_in_signal,
	spwc_e_leds_spw_red_status_led_signal,
	spwc_e_leds_spw_green_status_led_signal,
	spwc_e_lvds_spw_data_in_signal,
	spwc_e_lvds_spw_data_out_signal,
	spwc_e_lvds_spw_strobe_out_signal,
	spwc_e_lvds_spw_strobe_in_signal,
	spwc_f_leds_spw_red_status_led_signal,
	spwc_f_leds_spw_green_status_led_signal,
	spwc_f_lvds_spw_data_in_signal,
	spwc_f_lvds_spw_data_out_signal,
	spwc_f_lvds_spw_strobe_out_signal,
	spwc_f_lvds_spw_strobe_in_signal,
	spwc_g_leds_spw_red_status_led_signal,
	spwc_g_leds_spw_green_status_led_signal,
	spwc_g_lvds_spw_data_in_signal,
	spwc_g_lvds_spw_data_out_signal,
	spwc_g_lvds_spw_strobe_out_signal,
	spwc_g_lvds_spw_strobe_in_signal,
	spwc_h_leds_spw_red_status_led_signal,
	spwc_h_leds_spw_green_status_led_signal,
	spwc_h_lvds_spw_data_in_signal,
	spwc_h_lvds_spw_data_out_signal,
	spwc_h_lvds_spw_strobe_out_signal,
	spwc_h_lvds_spw_strobe_in_signal,
	ssdp_ssdp0,
	ssdp_ssdp1,
	sync_in_conduit,
	sync_out_conduit,
	sync_spw1_conduit,
	sync_spw2_conduit,
	sync_spw3_conduit,
	sync_spw4_conduit,
	sync_spw5_conduit,
	sync_spw6_conduit,
	sync_spw7_conduit,
	sync_spw8_conduit,
	temp_scl_export,
	temp_sda_export,
	timer_1ms_external_port_export,
	timer_1us_external_port_export,
	tristate_conduit_tcm_address_out,
	tristate_conduit_tcm_read_n_out,
	tristate_conduit_tcm_write_n_out,
	tristate_conduit_tcm_data_out,
	tristate_conduit_tcm_chipselect_n_out,
	umft601a_pins_umft_data_signal,
	umft601a_pins_umft_reset_n_signal,
	umft601a_pins_umft_rxf_n_signal,
	umft601a_pins_umft_clock_signal,
	umft601a_pins_umft_wakeup_n_signal,
	umft601a_pins_umft_be_signal,
	umft601a_pins_umft_txe_n_signal,
	umft601a_pins_umft_gpio_bus_signal,
	umft601a_pins_umft_wr_n_signal,
	umft601a_pins_umft_rd_n_signal,
	umft601a_pins_umft_oe_n_signal,
	umft601a_pins_umft_siwu_n_signal);	

	input	[3:0]	button_export;
	input		clk50_clk;
	output	[7:0]	comm_a_measurements_conduit_end_measurements_channel_signal;
	input		comm_a_sync_end_sync_channel_signal;
	output	[7:0]	comm_b_measurements_conduit_end_measurements_channel_signal;
	input		comm_b_sync_end_sync_channel_signal;
	output	[7:0]	comm_c_measurements_conduit_end_measurements_channel_signal;
	input		comm_c_sync_end_sync_channel_signal;
	output	[7:0]	comm_d_measurements_conduit_end_measurements_channel_signal;
	input		comm_d_sync_end_sync_channel_signal;
	output	[7:0]	comm_e_measurements_conduit_end_measurements_channel_signal;
	input		comm_e_sync_end_sync_channel_signal;
	output	[7:0]	comm_f_measurements_conduit_end_measurements_channel_signal;
	input		comm_f_sync_end_sync_channel_signal;
	output		csense_adc_fo_export;
	output	[1:0]	csense_cs_n_export;
	output		csense_sck_export;
	output		csense_sdi_export;
	input		csense_sdo_export;
	output	[3:0]	ctrl_io_lvds_export;
	input	[7:0]	dip_export;
	input		ext_export;
	input		ftdi_clk_clk;
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
	input		rs232_uart_rxd;
	output		rs232_uart_txd;
	input		rst_reset_n;
	input		rst_controller_conduit_reset_input_t_reset_input_signal;
	output		rst_controller_conduit_simucam_reset_t_simucam_reset_signal;
	input		rtcc_alarm_export;
	output		rtcc_cs_n_export;
	output		rtcc_sck_export;
	output		rtcc_sdi_export;
	input		rtcc_sdo_export;
	inout		sd_card_ip_b_SD_cmd;
	inout		sd_card_ip_b_SD_dat;
	inout		sd_card_ip_b_SD_dat3;
	output		sd_card_ip_o_SD_clock;
	input		sd_card_wp_n_io_export;
	output		spwc_a_leds_spw_red_status_led_signal;
	output		spwc_a_leds_spw_green_status_led_signal;
	input		spwc_a_lvds_spw_data_in_signal;
	output		spwc_a_lvds_spw_data_out_signal;
	output		spwc_a_lvds_spw_strobe_out_signal;
	input		spwc_a_lvds_spw_strobe_in_signal;
	output		spwc_b_leds_spw_red_status_led_signal;
	output		spwc_b_leds_spw_green_status_led_signal;
	input		spwc_b_lvds_spw_data_in_signal;
	output		spwc_b_lvds_spw_data_out_signal;
	output		spwc_b_lvds_spw_strobe_out_signal;
	input		spwc_b_lvds_spw_strobe_in_signal;
	output		spwc_c_leds_spw_red_status_led_signal;
	output		spwc_c_leds_spw_green_status_led_signal;
	input		spwc_c_lvds_spw_data_in_signal;
	output		spwc_c_lvds_spw_data_out_signal;
	output		spwc_c_lvds_spw_strobe_out_signal;
	input		spwc_c_lvds_spw_strobe_in_signal;
	output		spwc_d_leds_spw_red_status_led_signal;
	output		spwc_d_leds_spw_green_status_led_signal;
	input		spwc_d_lvds_spw_data_in_signal;
	output		spwc_d_lvds_spw_data_out_signal;
	output		spwc_d_lvds_spw_strobe_out_signal;
	input		spwc_d_lvds_spw_strobe_in_signal;
	output		spwc_e_leds_spw_red_status_led_signal;
	output		spwc_e_leds_spw_green_status_led_signal;
	input		spwc_e_lvds_spw_data_in_signal;
	output		spwc_e_lvds_spw_data_out_signal;
	output		spwc_e_lvds_spw_strobe_out_signal;
	input		spwc_e_lvds_spw_strobe_in_signal;
	output		spwc_f_leds_spw_red_status_led_signal;
	output		spwc_f_leds_spw_green_status_led_signal;
	input		spwc_f_lvds_spw_data_in_signal;
	output		spwc_f_lvds_spw_data_out_signal;
	output		spwc_f_lvds_spw_strobe_out_signal;
	input		spwc_f_lvds_spw_strobe_in_signal;
	output		spwc_g_leds_spw_red_status_led_signal;
	output		spwc_g_leds_spw_green_status_led_signal;
	input		spwc_g_lvds_spw_data_in_signal;
	output		spwc_g_lvds_spw_data_out_signal;
	output		spwc_g_lvds_spw_strobe_out_signal;
	input		spwc_g_lvds_spw_strobe_in_signal;
	output		spwc_h_leds_spw_red_status_led_signal;
	output		spwc_h_leds_spw_green_status_led_signal;
	input		spwc_h_lvds_spw_data_in_signal;
	output		spwc_h_lvds_spw_data_out_signal;
	output		spwc_h_lvds_spw_strobe_out_signal;
	input		spwc_h_lvds_spw_strobe_in_signal;
	output	[7:0]	ssdp_ssdp0;
	output	[7:0]	ssdp_ssdp1;
	input		sync_in_conduit;
	output		sync_out_conduit;
	output		sync_spw1_conduit;
	output		sync_spw2_conduit;
	output		sync_spw3_conduit;
	output		sync_spw4_conduit;
	output		sync_spw5_conduit;
	output		sync_spw6_conduit;
	output		sync_spw7_conduit;
	output		sync_spw8_conduit;
	output		temp_scl_export;
	inout		temp_sda_export;
	output		timer_1ms_external_port_export;
	output		timer_1us_external_port_export;
	output	[25:0]	tristate_conduit_tcm_address_out;
	output	[0:0]	tristate_conduit_tcm_read_n_out;
	output	[0:0]	tristate_conduit_tcm_write_n_out;
	inout	[15:0]	tristate_conduit_tcm_data_out;
	output	[0:0]	tristate_conduit_tcm_chipselect_n_out;
	inout	[31:0]	umft601a_pins_umft_data_signal;
	output		umft601a_pins_umft_reset_n_signal;
	input		umft601a_pins_umft_rxf_n_signal;
	input		umft601a_pins_umft_clock_signal;
	inout		umft601a_pins_umft_wakeup_n_signal;
	inout	[3:0]	umft601a_pins_umft_be_signal;
	input		umft601a_pins_umft_txe_n_signal;
	inout	[1:0]	umft601a_pins_umft_gpio_bus_signal;
	output		umft601a_pins_umft_wr_n_signal;
	output		umft601a_pins_umft_rd_n_signal;
	output		umft601a_pins_umft_oe_n_signal;
	output		umft601a_pins_umft_siwu_n_signal;
endmodule
