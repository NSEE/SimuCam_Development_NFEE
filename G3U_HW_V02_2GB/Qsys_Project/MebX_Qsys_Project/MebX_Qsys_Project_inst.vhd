	component MebX_Qsys_Project is
		port (
			button_export                                               : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk50_clk                                                   : in    std_logic                     := 'X';             -- clk
			comm_1_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_1_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			comm_2_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_2_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			comm_3_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_3_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			comm_4_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_4_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			comm_5_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_5_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			comm_6_measurements_measurements_signal                     : out   std_logic_vector(7 downto 0);                     -- measurements_signal
			comm_6_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			csense_adc_fo_export                                        : out   std_logic;                                        -- export
			csense_cs_n_export                                          : out   std_logic_vector(1 downto 0);                     -- export
			csense_sck_export                                           : out   std_logic;                                        -- export
			csense_sdi_export                                           : out   std_logic;                                        -- export
			csense_sdo_export                                           : in    std_logic                     := 'X';             -- export
			ctrl_io_lvds_export                                         : out   std_logic_vector(3 downto 0);                     -- export
			dip_export                                                  : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			ext_export                                                  : in    std_logic                     := 'X';             -- export
			ftdi_clk_clk                                                : in    std_logic                     := 'X';             -- clk
			led_de4_export                                              : out   std_logic_vector(7 downto 0);                     -- export
			led_painel_export                                           : out   std_logic_vector(20 downto 0);                    -- export
			m1_ddr2_i2c_scl_export                                      : out   std_logic;                                        -- export
			m1_ddr2_i2c_sda_export                                      : inout std_logic                     := 'X';             -- export
			m1_ddr2_memory_mem_a                                        : out   std_logic_vector(13 downto 0);                    -- mem_a
			m1_ddr2_memory_mem_ba                                       : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m1_ddr2_memory_mem_ck                                       : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m1_ddr2_memory_mem_ck_n                                     : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m1_ddr2_memory_mem_cke                                      : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m1_ddr2_memory_mem_cs_n                                     : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m1_ddr2_memory_mem_dm                                       : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m1_ddr2_memory_mem_ras_n                                    : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m1_ddr2_memory_mem_cas_n                                    : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m1_ddr2_memory_mem_we_n                                     : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m1_ddr2_memory_mem_dq                                       : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m1_ddr2_memory_mem_dqs                                      : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m1_ddr2_memory_mem_dqs_n                                    : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m1_ddr2_memory_mem_odt                                      : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                              : in    std_logic                     := 'X';             -- clk
			m1_ddr2_memory_status_local_init_done                       : out   std_logic;                                        -- local_init_done
			m1_ddr2_memory_status_local_cal_success                     : out   std_logic;                                        -- local_cal_success
			m1_ddr2_memory_status_local_cal_fail                        : out   std_logic;                                        -- local_cal_fail
			m1_ddr2_oct_rdn                                             : in    std_logic                     := 'X';             -- rdn
			m1_ddr2_oct_rup                                             : in    std_logic                     := 'X';             -- rup
			m2_ddr2_i2c_scl_export                                      : out   std_logic;                                        -- export
			m2_ddr2_i2c_sda_export                                      : inout std_logic                     := 'X';             -- export
			m2_ddr2_memory_mem_a                                        : out   std_logic_vector(13 downto 0);                    -- mem_a
			m2_ddr2_memory_mem_ba                                       : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m2_ddr2_memory_mem_ck                                       : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m2_ddr2_memory_mem_ck_n                                     : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m2_ddr2_memory_mem_cke                                      : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m2_ddr2_memory_mem_cs_n                                     : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m2_ddr2_memory_mem_dm                                       : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m2_ddr2_memory_mem_ras_n                                    : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m2_ddr2_memory_mem_cas_n                                    : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m2_ddr2_memory_mem_we_n                                     : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m2_ddr2_memory_mem_dq                                       : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m2_ddr2_memory_mem_dqs                                      : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m2_ddr2_memory_mem_dqs_n                                    : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m2_ddr2_memory_mem_odt                                      : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked                   : in    std_logic                     := 'X';             -- dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl                    : out   std_logic_vector(5 downto 0);                     -- dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk                      : out   std_logic;                                        -- pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk                    : out   std_logic;                                        -- pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                       : out   std_logic;                                        -- pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk        : out   std_logic;                                        -- pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk                 : out   std_logic;                                        -- pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk                      : out   std_logic;                                        -- pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk                   : out   std_logic;                                        -- pll_config_clk
			m2_ddr2_memory_status_local_init_done                       : out   std_logic;                                        -- local_init_done
			m2_ddr2_memory_status_local_cal_success                     : out   std_logic;                                        -- local_cal_success
			m2_ddr2_memory_status_local_cal_fail                        : out   std_logic;                                        -- local_cal_fail
			m2_ddr2_oct_rdn                                             : in    std_logic                     := 'X';             -- rdn
			m2_ddr2_oct_rup                                             : in    std_logic                     := 'X';             -- rup
			pio_ftdi_umft601a_module_reset_export                       : out   std_logic;                                        -- export
			pio_iso_logic_signal_enable_export                          : out   std_logic;                                        -- export
			rs232_uart_rxd                                              : in    std_logic                     := 'X';             -- rxd
			rs232_uart_txd                                              : out   std_logic;                                        -- txd
			rst_reset_n                                                 : in    std_logic                     := 'X';             -- reset_n
			rst_controller_conduit_reset_input_t_reset_input_signal     : in    std_logic                     := 'X';             -- t_reset_input_signal
			rst_controller_conduit_simucam_reset_t_simucam_reset_signal : out   std_logic;                                        -- t_simucam_reset_signal
			scom_0_sync_sync_signal                                     : in    std_logic                     := 'X';             -- sync_signal
			sd_card_wp_n_io_export                                      : in    std_logic                     := 'X';             -- export
			spwc_a_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal                          : in    std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal                          : in    std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal                       : out   std_logic;                                        -- spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal                     : out   std_logic;                                        -- spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal                      : out   std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal                      : out   std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			sync_filtered_sig_filtered_sig_signal                       : out   std_logic;                                        -- filtered_sig_signal
			sync_in_conduit                                             : in    std_logic                     := 'X';             -- conduit
			sync_in_en_conduit                                          : in    std_logic                     := 'X';             -- conduit
			sync_out_conduit                                            : out   std_logic;                                        -- conduit
			sync_out_en_conduit                                         : in    std_logic                     := 'X';             -- conduit
			sync_spw1_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw2_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw3_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw4_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw5_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw6_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw7_conduit                                           : out   std_logic;                                        -- conduit
			sync_spw8_conduit                                           : out   std_logic;                                        -- conduit
			sync_unfiltered_sig_unfiltered_sig_signal                   : in    std_logic                     := 'X';             -- unfiltered_sig_signal
			temp_scl_export                                             : out   std_logic;                                        -- export
			temp_sda_export                                             : inout std_logic                     := 'X';             -- export
			timer_1ms_external_port_export                              : out   std_logic;                                        -- export
			timer_1us_external_port_export                              : out   std_logic;                                        -- export
			tristate_conduit_tcm_address_out                            : out   std_logic_vector(25 downto 0);                    -- tcm_address_out
			tristate_conduit_tcm_read_n_out                             : out   std_logic_vector(0 downto 0);                     -- tcm_read_n_out
			tristate_conduit_tcm_write_n_out                            : out   std_logic_vector(0 downto 0);                     -- tcm_write_n_out
			tristate_conduit_tcm_data_out                               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                       : out   std_logic_vector(0 downto 0);                     -- tcm_chipselect_n_out
			umft601a_pins_umft_clock_signal                             : in    std_logic                     := 'X';             -- umft_clock_signal
			umft601a_pins_umft_txe_n_signal                             : in    std_logic                     := 'X';             -- umft_txe_n_signal
			umft601a_pins_umft_rxf_n_signal                             : in    std_logic                     := 'X';             -- umft_rxf_n_signal
			umft601a_pins_umft_data_signal                              : inout std_logic_vector(31 downto 0) := (others => 'X'); -- umft_data_signal
			umft601a_pins_umft_be_signal                                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- umft_be_signal
			umft601a_pins_umft_wakeup_n_signal                          : inout std_logic                     := 'X';             -- umft_wakeup_n_signal
			umft601a_pins_umft_gpio_bus_signal                          : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- umft_gpio_bus_signal
			umft601a_pins_umft_reset_n_signal                           : out   std_logic;                                        -- umft_reset_n_signal
			umft601a_pins_umft_wr_n_signal                              : out   std_logic;                                        -- umft_wr_n_signal
			umft601a_pins_umft_rd_n_signal                              : out   std_logic;                                        -- umft_rd_n_signal
			umft601a_pins_umft_oe_n_signal                              : out   std_logic;                                        -- umft_oe_n_signal
			umft601a_pins_umft_siwu_n_signal                            : out   std_logic;                                        -- umft_siwu_n_signal
			rmap_echoing_echo_rst_sink_reset                            : in    std_logic                     := 'X';             -- reset
			pio_rmap_echoing_module_reset_external_connection_export    : out   std_logic                                         -- export
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			button_export                                               => CONNECTED_TO_button_export,                                               --                                            button.export
			clk50_clk                                                   => CONNECTED_TO_clk50_clk,                                                   --                                             clk50.clk
			comm_1_measurements_measurements_signal                     => CONNECTED_TO_comm_1_measurements_measurements_signal,                     --                               comm_1_measurements.measurements_signal
			comm_1_sync_sync_signal                                     => CONNECTED_TO_comm_1_sync_sync_signal,                                     --                                       comm_1_sync.sync_signal
			comm_2_measurements_measurements_signal                     => CONNECTED_TO_comm_2_measurements_measurements_signal,                     --                               comm_2_measurements.measurements_signal
			comm_2_sync_sync_signal                                     => CONNECTED_TO_comm_2_sync_sync_signal,                                     --                                       comm_2_sync.sync_signal
			comm_3_measurements_measurements_signal                     => CONNECTED_TO_comm_3_measurements_measurements_signal,                     --                               comm_3_measurements.measurements_signal
			comm_3_sync_sync_signal                                     => CONNECTED_TO_comm_3_sync_sync_signal,                                     --                                       comm_3_sync.sync_signal
			comm_4_measurements_measurements_signal                     => CONNECTED_TO_comm_4_measurements_measurements_signal,                     --                               comm_4_measurements.measurements_signal
			comm_4_sync_sync_signal                                     => CONNECTED_TO_comm_4_sync_sync_signal,                                     --                                       comm_4_sync.sync_signal
			comm_5_measurements_measurements_signal                     => CONNECTED_TO_comm_5_measurements_measurements_signal,                     --                               comm_5_measurements.measurements_signal
			comm_5_sync_sync_signal                                     => CONNECTED_TO_comm_5_sync_sync_signal,                                     --                                       comm_5_sync.sync_signal
			comm_6_measurements_measurements_signal                     => CONNECTED_TO_comm_6_measurements_measurements_signal,                     --                               comm_6_measurements.measurements_signal
			comm_6_sync_sync_signal                                     => CONNECTED_TO_comm_6_sync_sync_signal,                                     --                                       comm_6_sync.sync_signal
			csense_adc_fo_export                                        => CONNECTED_TO_csense_adc_fo_export,                                        --                                     csense_adc_fo.export
			csense_cs_n_export                                          => CONNECTED_TO_csense_cs_n_export,                                          --                                       csense_cs_n.export
			csense_sck_export                                           => CONNECTED_TO_csense_sck_export,                                           --                                        csense_sck.export
			csense_sdi_export                                           => CONNECTED_TO_csense_sdi_export,                                           --                                        csense_sdi.export
			csense_sdo_export                                           => CONNECTED_TO_csense_sdo_export,                                           --                                        csense_sdo.export
			ctrl_io_lvds_export                                         => CONNECTED_TO_ctrl_io_lvds_export,                                         --                                      ctrl_io_lvds.export
			dip_export                                                  => CONNECTED_TO_dip_export,                                                  --                                               dip.export
			ext_export                                                  => CONNECTED_TO_ext_export,                                                  --                                               ext.export
			ftdi_clk_clk                                                => CONNECTED_TO_ftdi_clk_clk,                                                --                                          ftdi_clk.clk
			led_de4_export                                              => CONNECTED_TO_led_de4_export,                                              --                                           led_de4.export
			led_painel_export                                           => CONNECTED_TO_led_painel_export,                                           --                                        led_painel.export
			m1_ddr2_i2c_scl_export                                      => CONNECTED_TO_m1_ddr2_i2c_scl_export,                                      --                                   m1_ddr2_i2c_scl.export
			m1_ddr2_i2c_sda_export                                      => CONNECTED_TO_m1_ddr2_i2c_sda_export,                                      --                                   m1_ddr2_i2c_sda.export
			m1_ddr2_memory_mem_a                                        => CONNECTED_TO_m1_ddr2_memory_mem_a,                                        --                                    m1_ddr2_memory.mem_a
			m1_ddr2_memory_mem_ba                                       => CONNECTED_TO_m1_ddr2_memory_mem_ba,                                       --                                                  .mem_ba
			m1_ddr2_memory_mem_ck                                       => CONNECTED_TO_m1_ddr2_memory_mem_ck,                                       --                                                  .mem_ck
			m1_ddr2_memory_mem_ck_n                                     => CONNECTED_TO_m1_ddr2_memory_mem_ck_n,                                     --                                                  .mem_ck_n
			m1_ddr2_memory_mem_cke                                      => CONNECTED_TO_m1_ddr2_memory_mem_cke,                                      --                                                  .mem_cke
			m1_ddr2_memory_mem_cs_n                                     => CONNECTED_TO_m1_ddr2_memory_mem_cs_n,                                     --                                                  .mem_cs_n
			m1_ddr2_memory_mem_dm                                       => CONNECTED_TO_m1_ddr2_memory_mem_dm,                                       --                                                  .mem_dm
			m1_ddr2_memory_mem_ras_n                                    => CONNECTED_TO_m1_ddr2_memory_mem_ras_n,                                    --                                                  .mem_ras_n
			m1_ddr2_memory_mem_cas_n                                    => CONNECTED_TO_m1_ddr2_memory_mem_cas_n,                                    --                                                  .mem_cas_n
			m1_ddr2_memory_mem_we_n                                     => CONNECTED_TO_m1_ddr2_memory_mem_we_n,                                     --                                                  .mem_we_n
			m1_ddr2_memory_mem_dq                                       => CONNECTED_TO_m1_ddr2_memory_mem_dq,                                       --                                                  .mem_dq
			m1_ddr2_memory_mem_dqs                                      => CONNECTED_TO_m1_ddr2_memory_mem_dqs,                                      --                                                  .mem_dqs
			m1_ddr2_memory_mem_dqs_n                                    => CONNECTED_TO_m1_ddr2_memory_mem_dqs_n,                                    --                                                  .mem_dqs_n
			m1_ddr2_memory_mem_odt                                      => CONNECTED_TO_m1_ddr2_memory_mem_odt,                                      --                                                  .mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                              => CONNECTED_TO_m1_ddr2_memory_pll_ref_clk_clk,                              --                        m1_ddr2_memory_pll_ref_clk.clk
			m1_ddr2_memory_status_local_init_done                       => CONNECTED_TO_m1_ddr2_memory_status_local_init_done,                       --                             m1_ddr2_memory_status.local_init_done
			m1_ddr2_memory_status_local_cal_success                     => CONNECTED_TO_m1_ddr2_memory_status_local_cal_success,                     --                                                  .local_cal_success
			m1_ddr2_memory_status_local_cal_fail                        => CONNECTED_TO_m1_ddr2_memory_status_local_cal_fail,                        --                                                  .local_cal_fail
			m1_ddr2_oct_rdn                                             => CONNECTED_TO_m1_ddr2_oct_rdn,                                             --                                       m1_ddr2_oct.rdn
			m1_ddr2_oct_rup                                             => CONNECTED_TO_m1_ddr2_oct_rup,                                             --                                                  .rup
			m2_ddr2_i2c_scl_export                                      => CONNECTED_TO_m2_ddr2_i2c_scl_export,                                      --                                   m2_ddr2_i2c_scl.export
			m2_ddr2_i2c_sda_export                                      => CONNECTED_TO_m2_ddr2_i2c_sda_export,                                      --                                   m2_ddr2_i2c_sda.export
			m2_ddr2_memory_mem_a                                        => CONNECTED_TO_m2_ddr2_memory_mem_a,                                        --                                    m2_ddr2_memory.mem_a
			m2_ddr2_memory_mem_ba                                       => CONNECTED_TO_m2_ddr2_memory_mem_ba,                                       --                                                  .mem_ba
			m2_ddr2_memory_mem_ck                                       => CONNECTED_TO_m2_ddr2_memory_mem_ck,                                       --                                                  .mem_ck
			m2_ddr2_memory_mem_ck_n                                     => CONNECTED_TO_m2_ddr2_memory_mem_ck_n,                                     --                                                  .mem_ck_n
			m2_ddr2_memory_mem_cke                                      => CONNECTED_TO_m2_ddr2_memory_mem_cke,                                      --                                                  .mem_cke
			m2_ddr2_memory_mem_cs_n                                     => CONNECTED_TO_m2_ddr2_memory_mem_cs_n,                                     --                                                  .mem_cs_n
			m2_ddr2_memory_mem_dm                                       => CONNECTED_TO_m2_ddr2_memory_mem_dm,                                       --                                                  .mem_dm
			m2_ddr2_memory_mem_ras_n                                    => CONNECTED_TO_m2_ddr2_memory_mem_ras_n,                                    --                                                  .mem_ras_n
			m2_ddr2_memory_mem_cas_n                                    => CONNECTED_TO_m2_ddr2_memory_mem_cas_n,                                    --                                                  .mem_cas_n
			m2_ddr2_memory_mem_we_n                                     => CONNECTED_TO_m2_ddr2_memory_mem_we_n,                                     --                                                  .mem_we_n
			m2_ddr2_memory_mem_dq                                       => CONNECTED_TO_m2_ddr2_memory_mem_dq,                                       --                                                  .mem_dq
			m2_ddr2_memory_mem_dqs                                      => CONNECTED_TO_m2_ddr2_memory_mem_dqs,                                      --                                                  .mem_dqs
			m2_ddr2_memory_mem_dqs_n                                    => CONNECTED_TO_m2_ddr2_memory_mem_dqs_n,                                    --                                                  .mem_dqs_n
			m2_ddr2_memory_mem_odt                                      => CONNECTED_TO_m2_ddr2_memory_mem_odt,                                      --                                                  .mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked                   => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_pll_locked,                   --                        m2_ddr2_memory_dll_sharing.dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl                    => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_delayctrl,                    --                                                  .dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk                      => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_mem_clk,                      --                        m2_ddr2_memory_pll_sharing.pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk                    => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk,                    --                                                  .pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                       => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_locked,                       --                                                  .pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk        => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk,        --                                                  .pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk                 => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,                 --                                                  .pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk                      => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_avl_clk,                      --                                                  .pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk                   => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_config_clk,                   --                                                  .pll_config_clk
			m2_ddr2_memory_status_local_init_done                       => CONNECTED_TO_m2_ddr2_memory_status_local_init_done,                       --                             m2_ddr2_memory_status.local_init_done
			m2_ddr2_memory_status_local_cal_success                     => CONNECTED_TO_m2_ddr2_memory_status_local_cal_success,                     --                                                  .local_cal_success
			m2_ddr2_memory_status_local_cal_fail                        => CONNECTED_TO_m2_ddr2_memory_status_local_cal_fail,                        --                                                  .local_cal_fail
			m2_ddr2_oct_rdn                                             => CONNECTED_TO_m2_ddr2_oct_rdn,                                             --                                       m2_ddr2_oct.rdn
			m2_ddr2_oct_rup                                             => CONNECTED_TO_m2_ddr2_oct_rup,                                             --                                                  .rup
			pio_ftdi_umft601a_module_reset_export                       => CONNECTED_TO_pio_ftdi_umft601a_module_reset_export,                       --                    pio_ftdi_umft601a_module_reset.export
			pio_iso_logic_signal_enable_export                          => CONNECTED_TO_pio_iso_logic_signal_enable_export,                          --                       pio_iso_logic_signal_enable.export
			rs232_uart_rxd                                              => CONNECTED_TO_rs232_uart_rxd,                                              --                                        rs232_uart.rxd
			rs232_uart_txd                                              => CONNECTED_TO_rs232_uart_txd,                                              --                                                  .txd
			rst_reset_n                                                 => CONNECTED_TO_rst_reset_n,                                                 --                                               rst.reset_n
			rst_controller_conduit_reset_input_t_reset_input_signal     => CONNECTED_TO_rst_controller_conduit_reset_input_t_reset_input_signal,     --                rst_controller_conduit_reset_input.t_reset_input_signal
			rst_controller_conduit_simucam_reset_t_simucam_reset_signal => CONNECTED_TO_rst_controller_conduit_simucam_reset_t_simucam_reset_signal, --              rst_controller_conduit_simucam_reset.t_simucam_reset_signal
			scom_0_sync_sync_signal                                     => CONNECTED_TO_scom_0_sync_sync_signal,                                     --                                       scom_0_sync.sync_signal
			sd_card_wp_n_io_export                                      => CONNECTED_TO_sd_card_wp_n_io_export,                                      --                                   sd_card_wp_n_io.export
			spwc_a_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_a_enable_spw_rx_enable_signal,                          --                                     spwc_a_enable.spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_a_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_a_leds_spw_red_status_led_signal,                       --                                       spwc_a_leds.spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_a_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_a_lvds.spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_b_enable_spw_rx_enable_signal,                          --                                     spwc_b_enable.spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_b_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_b_leds_spw_red_status_led_signal,                       --                                       spwc_b_leds.spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_b_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_b_lvds.spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_c_enable_spw_rx_enable_signal,                          --                                     spwc_c_enable.spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_c_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_c_leds_spw_red_status_led_signal,                       --                                       spwc_c_leds.spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_c_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_c_lvds.spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_d_enable_spw_rx_enable_signal,                          --                                     spwc_d_enable.spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_d_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_d_leds_spw_red_status_led_signal,                       --                                       spwc_d_leds.spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_d_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_d_lvds.spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_e_enable_spw_rx_enable_signal,                          --                                     spwc_e_enable.spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_e_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_e_leds_spw_red_status_led_signal,                       --                                       spwc_e_leds.spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_e_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_e_lvds.spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_f_enable_spw_rx_enable_signal,                          --                                     spwc_f_enable.spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_f_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_f_leds_spw_red_status_led_signal,                       --                                       spwc_f_leds.spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_f_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_f_lvds.spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_g_enable_spw_rx_enable_signal,                          --                                     spwc_g_enable.spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_g_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_g_leds_spw_red_status_led_signal,                       --                                       spwc_g_leds.spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_g_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_g_lvds.spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal                          => CONNECTED_TO_spwc_h_enable_spw_rx_enable_signal,                          --                                     spwc_h_enable.spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal                          => CONNECTED_TO_spwc_h_enable_spw_tx_enable_signal,                          --                                                  .spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal                       => CONNECTED_TO_spwc_h_leds_spw_red_status_led_signal,                       --                                       spwc_h_leds.spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal                     => CONNECTED_TO_spwc_h_leds_spw_green_status_led_signal,                     --                                                  .spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal                       => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_in_signal,                       --                                       spwc_h_lvds.spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal                       => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_in_signal,                       --                                                  .spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal                      => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_out_signal,                      --                                                  .spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal                      => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_out_signal,                      --                                                  .spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal                    => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_out_signal,                    --                                                  .spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal                    => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_out_signal,                    --                                                  .spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal                     => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_in_signal,                     --                                                  .spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal                     => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_in_signal,                     --                                                  .spw_lvds_n_strobe_in_signal
			sync_filtered_sig_filtered_sig_signal                       => CONNECTED_TO_sync_filtered_sig_filtered_sig_signal,                       --                                 sync_filtered_sig.filtered_sig_signal
			sync_in_conduit                                             => CONNECTED_TO_sync_in_conduit,                                             --                                           sync_in.conduit
			sync_in_en_conduit                                          => CONNECTED_TO_sync_in_en_conduit,                                          --                                        sync_in_en.conduit
			sync_out_conduit                                            => CONNECTED_TO_sync_out_conduit,                                            --                                          sync_out.conduit
			sync_out_en_conduit                                         => CONNECTED_TO_sync_out_en_conduit,                                         --                                       sync_out_en.conduit
			sync_spw1_conduit                                           => CONNECTED_TO_sync_spw1_conduit,                                           --                                         sync_spw1.conduit
			sync_spw2_conduit                                           => CONNECTED_TO_sync_spw2_conduit,                                           --                                         sync_spw2.conduit
			sync_spw3_conduit                                           => CONNECTED_TO_sync_spw3_conduit,                                           --                                         sync_spw3.conduit
			sync_spw4_conduit                                           => CONNECTED_TO_sync_spw4_conduit,                                           --                                         sync_spw4.conduit
			sync_spw5_conduit                                           => CONNECTED_TO_sync_spw5_conduit,                                           --                                         sync_spw5.conduit
			sync_spw6_conduit                                           => CONNECTED_TO_sync_spw6_conduit,                                           --                                         sync_spw6.conduit
			sync_spw7_conduit                                           => CONNECTED_TO_sync_spw7_conduit,                                           --                                         sync_spw7.conduit
			sync_spw8_conduit                                           => CONNECTED_TO_sync_spw8_conduit,                                           --                                         sync_spw8.conduit
			sync_unfiltered_sig_unfiltered_sig_signal                   => CONNECTED_TO_sync_unfiltered_sig_unfiltered_sig_signal,                   --                               sync_unfiltered_sig.unfiltered_sig_signal
			temp_scl_export                                             => CONNECTED_TO_temp_scl_export,                                             --                                          temp_scl.export
			temp_sda_export                                             => CONNECTED_TO_temp_sda_export,                                             --                                          temp_sda.export
			timer_1ms_external_port_export                              => CONNECTED_TO_timer_1ms_external_port_export,                              --                           timer_1ms_external_port.export
			timer_1us_external_port_export                              => CONNECTED_TO_timer_1us_external_port_export,                              --                           timer_1us_external_port.export
			tristate_conduit_tcm_address_out                            => CONNECTED_TO_tristate_conduit_tcm_address_out,                            --                                  tristate_conduit.tcm_address_out
			tristate_conduit_tcm_read_n_out                             => CONNECTED_TO_tristate_conduit_tcm_read_n_out,                             --                                                  .tcm_read_n_out
			tristate_conduit_tcm_write_n_out                            => CONNECTED_TO_tristate_conduit_tcm_write_n_out,                            --                                                  .tcm_write_n_out
			tristate_conduit_tcm_data_out                               => CONNECTED_TO_tristate_conduit_tcm_data_out,                               --                                                  .tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                       => CONNECTED_TO_tristate_conduit_tcm_chipselect_n_out,                       --                                                  .tcm_chipselect_n_out
			umft601a_pins_umft_clock_signal                             => CONNECTED_TO_umft601a_pins_umft_clock_signal,                             --                                     umft601a_pins.umft_clock_signal
			umft601a_pins_umft_txe_n_signal                             => CONNECTED_TO_umft601a_pins_umft_txe_n_signal,                             --                                                  .umft_txe_n_signal
			umft601a_pins_umft_rxf_n_signal                             => CONNECTED_TO_umft601a_pins_umft_rxf_n_signal,                             --                                                  .umft_rxf_n_signal
			umft601a_pins_umft_data_signal                              => CONNECTED_TO_umft601a_pins_umft_data_signal,                              --                                                  .umft_data_signal
			umft601a_pins_umft_be_signal                                => CONNECTED_TO_umft601a_pins_umft_be_signal,                                --                                                  .umft_be_signal
			umft601a_pins_umft_wakeup_n_signal                          => CONNECTED_TO_umft601a_pins_umft_wakeup_n_signal,                          --                                                  .umft_wakeup_n_signal
			umft601a_pins_umft_gpio_bus_signal                          => CONNECTED_TO_umft601a_pins_umft_gpio_bus_signal,                          --                                                  .umft_gpio_bus_signal
			umft601a_pins_umft_reset_n_signal                           => CONNECTED_TO_umft601a_pins_umft_reset_n_signal,                           --                                                  .umft_reset_n_signal
			umft601a_pins_umft_wr_n_signal                              => CONNECTED_TO_umft601a_pins_umft_wr_n_signal,                              --                                                  .umft_wr_n_signal
			umft601a_pins_umft_rd_n_signal                              => CONNECTED_TO_umft601a_pins_umft_rd_n_signal,                              --                                                  .umft_rd_n_signal
			umft601a_pins_umft_oe_n_signal                              => CONNECTED_TO_umft601a_pins_umft_oe_n_signal,                              --                                                  .umft_oe_n_signal
			umft601a_pins_umft_siwu_n_signal                            => CONNECTED_TO_umft601a_pins_umft_siwu_n_signal,                            --                                                  .umft_siwu_n_signal
			rmap_echoing_echo_rst_sink_reset                            => CONNECTED_TO_rmap_echoing_echo_rst_sink_reset,                            --                        rmap_echoing_echo_rst_sink.reset
			pio_rmap_echoing_module_reset_external_connection_export    => CONNECTED_TO_pio_rmap_echoing_module_reset_external_connection_export     -- pio_rmap_echoing_module_reset_external_connection.export
		);

