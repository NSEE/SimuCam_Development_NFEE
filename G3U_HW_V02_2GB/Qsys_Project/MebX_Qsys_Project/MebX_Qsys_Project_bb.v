
module MebX_Qsys_Project (
	clk50_clk,
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
	spwc_a_enable_spw_rx_enable_signal,
	spwc_a_enable_spw_tx_enable_signal,
	spwc_a_leds_spw_red_status_led_signal,
	spwc_a_leds_spw_green_status_led_signal,
	spwc_a_lvds_spw_lvds_p_data_in_signal,
	spwc_a_lvds_spw_lvds_n_data_in_signal,
	spwc_a_lvds_spw_lvds_p_data_out_signal,
	spwc_a_lvds_spw_lvds_n_data_out_signal,
	spwc_a_lvds_spw_lvds_p_strobe_out_signal,
	spwc_a_lvds_spw_lvds_n_strobe_out_signal,
	spwc_a_lvds_spw_lvds_p_strobe_in_signal,
	spwc_a_lvds_spw_lvds_n_strobe_in_signal,
	spwc_b_enable_spw_rx_enable_signal,
	spwc_b_enable_spw_tx_enable_signal,
	spwc_b_leds_spw_red_status_led_signal,
	spwc_b_leds_spw_green_status_led_signal,
	spwc_b_lvds_spw_lvds_p_data_in_signal,
	spwc_b_lvds_spw_lvds_n_data_in_signal,
	spwc_b_lvds_spw_lvds_p_data_out_signal,
	spwc_b_lvds_spw_lvds_n_data_out_signal,
	spwc_b_lvds_spw_lvds_p_strobe_out_signal,
	spwc_b_lvds_spw_lvds_n_strobe_out_signal,
	spwc_b_lvds_spw_lvds_p_strobe_in_signal,
	spwc_b_lvds_spw_lvds_n_strobe_in_signal,
	spwc_c_enable_spw_rx_enable_signal,
	spwc_c_enable_spw_tx_enable_signal,
	spwc_c_leds_spw_red_status_led_signal,
	spwc_c_leds_spw_green_status_led_signal,
	spwc_c_lvds_spw_lvds_p_data_in_signal,
	spwc_c_lvds_spw_lvds_n_data_in_signal,
	spwc_c_lvds_spw_lvds_p_data_out_signal,
	spwc_c_lvds_spw_lvds_n_data_out_signal,
	spwc_c_lvds_spw_lvds_p_strobe_out_signal,
	spwc_c_lvds_spw_lvds_n_strobe_out_signal,
	spwc_c_lvds_spw_lvds_p_strobe_in_signal,
	spwc_c_lvds_spw_lvds_n_strobe_in_signal,
	spwc_d_enable_spw_rx_enable_signal,
	spwc_d_enable_spw_tx_enable_signal,
	spwc_d_leds_spw_red_status_led_signal,
	spwc_d_leds_spw_green_status_led_signal,
	spwc_d_lvds_spw_lvds_p_data_in_signal,
	spwc_d_lvds_spw_lvds_n_data_in_signal,
	spwc_d_lvds_spw_lvds_p_data_out_signal,
	spwc_d_lvds_spw_lvds_n_data_out_signal,
	spwc_d_lvds_spw_lvds_p_strobe_out_signal,
	spwc_d_lvds_spw_lvds_n_strobe_out_signal,
	spwc_d_lvds_spw_lvds_p_strobe_in_signal,
	spwc_d_lvds_spw_lvds_n_strobe_in_signal,
	spwc_e_enable_spw_rx_enable_signal,
	spwc_e_enable_spw_tx_enable_signal,
	spwc_e_leds_spw_red_status_led_signal,
	spwc_e_leds_spw_green_status_led_signal,
	spwc_e_lvds_spw_lvds_p_data_in_signal,
	spwc_e_lvds_spw_lvds_n_data_in_signal,
	spwc_e_lvds_spw_lvds_p_data_out_signal,
	spwc_e_lvds_spw_lvds_n_data_out_signal,
	spwc_e_lvds_spw_lvds_p_strobe_out_signal,
	spwc_e_lvds_spw_lvds_n_strobe_out_signal,
	spwc_e_lvds_spw_lvds_p_strobe_in_signal,
	spwc_e_lvds_spw_lvds_n_strobe_in_signal,
	spwc_f_enable_spw_rx_enable_signal,
	spwc_f_enable_spw_tx_enable_signal,
	spwc_f_leds_spw_red_status_led_signal,
	spwc_f_leds_spw_green_status_led_signal,
	spwc_f_lvds_spw_lvds_p_data_in_signal,
	spwc_f_lvds_spw_lvds_n_data_in_signal,
	spwc_f_lvds_spw_lvds_p_data_out_signal,
	spwc_f_lvds_spw_lvds_n_data_out_signal,
	spwc_f_lvds_spw_lvds_p_strobe_out_signal,
	spwc_f_lvds_spw_lvds_n_strobe_out_signal,
	spwc_f_lvds_spw_lvds_p_strobe_in_signal,
	spwc_f_lvds_spw_lvds_n_strobe_in_signal,
	spwc_g_enable_spw_rx_enable_signal,
	spwc_g_enable_spw_tx_enable_signal,
	spwc_g_leds_spw_red_status_led_signal,
	spwc_g_leds_spw_green_status_led_signal,
	spwc_g_lvds_spw_lvds_p_data_in_signal,
	spwc_g_lvds_spw_lvds_n_data_in_signal,
	spwc_g_lvds_spw_lvds_p_data_out_signal,
	spwc_g_lvds_spw_lvds_n_data_out_signal,
	spwc_g_lvds_spw_lvds_p_strobe_out_signal,
	spwc_g_lvds_spw_lvds_n_strobe_out_signal,
	spwc_g_lvds_spw_lvds_p_strobe_in_signal,
	spwc_g_lvds_spw_lvds_n_strobe_in_signal,
	spwc_h_enable_spw_rx_enable_signal,
	spwc_h_enable_spw_tx_enable_signal,
	spwc_h_leds_spw_red_status_led_signal,
	spwc_h_leds_spw_green_status_led_signal,
	spwc_h_lvds_spw_lvds_p_data_in_signal,
	spwc_h_lvds_spw_lvds_n_data_in_signal,
	spwc_h_lvds_spw_lvds_p_data_out_signal,
	spwc_h_lvds_spw_lvds_n_data_out_signal,
	spwc_h_lvds_spw_lvds_p_strobe_out_signal,
	spwc_h_lvds_spw_lvds_n_strobe_out_signal,
	spwc_h_lvds_spw_lvds_p_strobe_in_signal,
	spwc_h_lvds_spw_lvds_n_strobe_in_signal,
	spwr_drivers_isolator_en_drivers_isolator_en_signal,
	spwr_router_control_router_config_en_signal,
	spwr_router_control_router_path_0_select_signal,
	spwr_router_control_router_path_1_select_signal,
	m1_ddr2_memory_avl_waitrequest_n,
	m1_ddr2_memory_avl_beginbursttransfer,
	m1_ddr2_memory_avl_address,
	m1_ddr2_memory_avl_readdatavalid,
	m1_ddr2_memory_avl_readdata,
	m1_ddr2_memory_avl_writedata,
	m1_ddr2_memory_avl_byteenable,
	m1_ddr2_memory_avl_read,
	m1_ddr2_memory_avl_write,
	m1_ddr2_memory_avl_burstcount,
	m2_ddr2_memory_avl_waitrequest_n,
	m2_ddr2_memory_avl_beginbursttransfer,
	m2_ddr2_memory_avl_address,
	m2_ddr2_memory_avl_readdatavalid,
	m2_ddr2_memory_avl_readdata,
	m2_ddr2_memory_avl_writedata,
	m2_ddr2_memory_avl_byteenable,
	m2_ddr2_memory_avl_read,
	m2_ddr2_memory_avl_write,
	m2_ddr2_memory_avl_burstcount);	

	input		clk50_clk;
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
	input		spwc_a_enable_spw_rx_enable_signal;
	input		spwc_a_enable_spw_tx_enable_signal;
	output		spwc_a_leds_spw_red_status_led_signal;
	output		spwc_a_leds_spw_green_status_led_signal;
	input		spwc_a_lvds_spw_lvds_p_data_in_signal;
	input		spwc_a_lvds_spw_lvds_n_data_in_signal;
	output		spwc_a_lvds_spw_lvds_p_data_out_signal;
	output		spwc_a_lvds_spw_lvds_n_data_out_signal;
	output		spwc_a_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_a_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_a_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_a_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_b_enable_spw_rx_enable_signal;
	input		spwc_b_enable_spw_tx_enable_signal;
	output		spwc_b_leds_spw_red_status_led_signal;
	output		spwc_b_leds_spw_green_status_led_signal;
	input		spwc_b_lvds_spw_lvds_p_data_in_signal;
	input		spwc_b_lvds_spw_lvds_n_data_in_signal;
	output		spwc_b_lvds_spw_lvds_p_data_out_signal;
	output		spwc_b_lvds_spw_lvds_n_data_out_signal;
	output		spwc_b_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_b_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_b_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_b_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_c_enable_spw_rx_enable_signal;
	input		spwc_c_enable_spw_tx_enable_signal;
	output		spwc_c_leds_spw_red_status_led_signal;
	output		spwc_c_leds_spw_green_status_led_signal;
	input		spwc_c_lvds_spw_lvds_p_data_in_signal;
	input		spwc_c_lvds_spw_lvds_n_data_in_signal;
	output		spwc_c_lvds_spw_lvds_p_data_out_signal;
	output		spwc_c_lvds_spw_lvds_n_data_out_signal;
	output		spwc_c_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_c_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_c_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_c_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_d_enable_spw_rx_enable_signal;
	input		spwc_d_enable_spw_tx_enable_signal;
	output		spwc_d_leds_spw_red_status_led_signal;
	output		spwc_d_leds_spw_green_status_led_signal;
	input		spwc_d_lvds_spw_lvds_p_data_in_signal;
	input		spwc_d_lvds_spw_lvds_n_data_in_signal;
	output		spwc_d_lvds_spw_lvds_p_data_out_signal;
	output		spwc_d_lvds_spw_lvds_n_data_out_signal;
	output		spwc_d_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_d_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_d_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_d_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_e_enable_spw_rx_enable_signal;
	input		spwc_e_enable_spw_tx_enable_signal;
	output		spwc_e_leds_spw_red_status_led_signal;
	output		spwc_e_leds_spw_green_status_led_signal;
	input		spwc_e_lvds_spw_lvds_p_data_in_signal;
	input		spwc_e_lvds_spw_lvds_n_data_in_signal;
	output		spwc_e_lvds_spw_lvds_p_data_out_signal;
	output		spwc_e_lvds_spw_lvds_n_data_out_signal;
	output		spwc_e_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_e_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_e_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_e_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_f_enable_spw_rx_enable_signal;
	input		spwc_f_enable_spw_tx_enable_signal;
	output		spwc_f_leds_spw_red_status_led_signal;
	output		spwc_f_leds_spw_green_status_led_signal;
	input		spwc_f_lvds_spw_lvds_p_data_in_signal;
	input		spwc_f_lvds_spw_lvds_n_data_in_signal;
	output		spwc_f_lvds_spw_lvds_p_data_out_signal;
	output		spwc_f_lvds_spw_lvds_n_data_out_signal;
	output		spwc_f_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_f_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_f_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_f_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_g_enable_spw_rx_enable_signal;
	input		spwc_g_enable_spw_tx_enable_signal;
	output		spwc_g_leds_spw_red_status_led_signal;
	output		spwc_g_leds_spw_green_status_led_signal;
	input		spwc_g_lvds_spw_lvds_p_data_in_signal;
	input		spwc_g_lvds_spw_lvds_n_data_in_signal;
	output		spwc_g_lvds_spw_lvds_p_data_out_signal;
	output		spwc_g_lvds_spw_lvds_n_data_out_signal;
	output		spwc_g_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_g_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_g_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_g_lvds_spw_lvds_n_strobe_in_signal;
	input		spwc_h_enable_spw_rx_enable_signal;
	input		spwc_h_enable_spw_tx_enable_signal;
	output		spwc_h_leds_spw_red_status_led_signal;
	output		spwc_h_leds_spw_green_status_led_signal;
	input		spwc_h_lvds_spw_lvds_p_data_in_signal;
	input		spwc_h_lvds_spw_lvds_n_data_in_signal;
	output		spwc_h_lvds_spw_lvds_p_data_out_signal;
	output		spwc_h_lvds_spw_lvds_n_data_out_signal;
	output		spwc_h_lvds_spw_lvds_p_strobe_out_signal;
	output		spwc_h_lvds_spw_lvds_n_strobe_out_signal;
	input		spwc_h_lvds_spw_lvds_p_strobe_in_signal;
	input		spwc_h_lvds_spw_lvds_n_strobe_in_signal;
	output		spwr_drivers_isolator_en_drivers_isolator_en_signal;
	input		spwr_router_control_router_config_en_signal;
	input	[1:0]	spwr_router_control_router_path_0_select_signal;
	input	[1:0]	spwr_router_control_router_path_1_select_signal;
	output		m1_ddr2_memory_avl_waitrequest_n;
	input		m1_ddr2_memory_avl_beginbursttransfer;
	input	[25:0]	m1_ddr2_memory_avl_address;
	output		m1_ddr2_memory_avl_readdatavalid;
	output	[255:0]	m1_ddr2_memory_avl_readdata;
	input	[255:0]	m1_ddr2_memory_avl_writedata;
	input	[31:0]	m1_ddr2_memory_avl_byteenable;
	input		m1_ddr2_memory_avl_read;
	input		m1_ddr2_memory_avl_write;
	input	[7:0]	m1_ddr2_memory_avl_burstcount;
	output		m2_ddr2_memory_avl_waitrequest_n;
	input		m2_ddr2_memory_avl_beginbursttransfer;
	input	[25:0]	m2_ddr2_memory_avl_address;
	output		m2_ddr2_memory_avl_readdatavalid;
	output	[255:0]	m2_ddr2_memory_avl_readdata;
	input	[255:0]	m2_ddr2_memory_avl_writedata;
	input	[31:0]	m2_ddr2_memory_avl_byteenable;
	input		m2_ddr2_memory_avl_read;
	input		m2_ddr2_memory_avl_write;
	input	[7:0]	m2_ddr2_memory_avl_burstcount;
endmodule
