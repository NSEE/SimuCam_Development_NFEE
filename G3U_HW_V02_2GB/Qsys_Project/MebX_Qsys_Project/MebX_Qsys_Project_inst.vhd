	component MebX_Qsys_Project is
		port (
			clk50_clk                                            : in    std_logic                      := 'X';             -- clk
			m1_ddr2_memory_mem_a                                 : out   std_logic_vector(13 downto 0);                     -- mem_a
			m1_ddr2_memory_mem_ba                                : out   std_logic_vector(2 downto 0);                      -- mem_ba
			m1_ddr2_memory_mem_ck                                : out   std_logic_vector(1 downto 0);                      -- mem_ck
			m1_ddr2_memory_mem_ck_n                              : out   std_logic_vector(1 downto 0);                      -- mem_ck_n
			m1_ddr2_memory_mem_cke                               : out   std_logic_vector(1 downto 0);                      -- mem_cke
			m1_ddr2_memory_mem_cs_n                              : out   std_logic_vector(1 downto 0);                      -- mem_cs_n
			m1_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                      -- mem_dm
			m1_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                      -- mem_ras_n
			m1_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                      -- mem_cas_n
			m1_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                      -- mem_we_n
			m1_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0)  := (others => 'X'); -- mem_dq
			m1_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs
			m1_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs_n
			m1_ddr2_memory_mem_odt                               : out   std_logic_vector(1 downto 0);                      -- mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                       : in    std_logic                      := 'X';             -- clk
			m1_ddr2_memory_status_local_init_done                : out   std_logic;                                         -- local_init_done
			m1_ddr2_memory_status_local_cal_success              : out   std_logic;                                         -- local_cal_success
			m1_ddr2_memory_status_local_cal_fail                 : out   std_logic;                                         -- local_cal_fail
			m1_ddr2_oct_rdn                                      : in    std_logic                      := 'X';             -- rdn
			m1_ddr2_oct_rup                                      : in    std_logic                      := 'X';             -- rup
			m2_ddr2_memory_mem_a                                 : out   std_logic_vector(13 downto 0);                     -- mem_a
			m2_ddr2_memory_mem_ba                                : out   std_logic_vector(2 downto 0);                      -- mem_ba
			m2_ddr2_memory_mem_ck                                : out   std_logic_vector(1 downto 0);                      -- mem_ck
			m2_ddr2_memory_mem_ck_n                              : out   std_logic_vector(1 downto 0);                      -- mem_ck_n
			m2_ddr2_memory_mem_cke                               : out   std_logic_vector(1 downto 0);                      -- mem_cke
			m2_ddr2_memory_mem_cs_n                              : out   std_logic_vector(1 downto 0);                      -- mem_cs_n
			m2_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                      -- mem_dm
			m2_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                      -- mem_ras_n
			m2_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                      -- mem_cas_n
			m2_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                      -- mem_we_n
			m2_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0)  := (others => 'X'); -- mem_dq
			m2_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs
			m2_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs_n
			m2_ddr2_memory_mem_odt                               : out   std_logic_vector(1 downto 0);                      -- mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked            : in    std_logic                      := 'X';             -- dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl             : out   std_logic_vector(5 downto 0);                      -- dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk               : out   std_logic;                                         -- pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk             : out   std_logic;                                         -- pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                : out   std_logic;                                         -- pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk : out   std_logic;                                         -- pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk          : out   std_logic;                                         -- pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk               : out   std_logic;                                         -- pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk            : out   std_logic;                                         -- pll_config_clk
			m2_ddr2_memory_status_local_init_done                : out   std_logic;                                         -- local_init_done
			m2_ddr2_memory_status_local_cal_success              : out   std_logic;                                         -- local_cal_success
			m2_ddr2_memory_status_local_cal_fail                 : out   std_logic;                                         -- local_cal_fail
			m2_ddr2_oct_rdn                                      : in    std_logic                      := 'X';             -- rdn
			m2_ddr2_oct_rup                                      : in    std_logic                      := 'X';             -- rup
			rst_reset_n                                          : in    std_logic                      := 'X';             -- reset_n
			spwc_a_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal                   : in    std_logic                      := 'X';             -- spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal                   : in    std_logic                      := 'X';             -- spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal                : out   std_logic;                                         -- spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal              : out   std_logic;                                         -- spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal                : in    std_logic                      := 'X';             -- spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal               : out   std_logic;                                         -- spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal               : out   std_logic;                                         -- spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal             : out   std_logic;                                         -- spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal              : in    std_logic                      := 'X';             -- spw_lvds_n_strobe_in_signal
			spwr_drivers_isolator_en_drivers_isolator_en_signal  : out   std_logic;                                         -- drivers_isolator_en_signal
			spwr_router_control_router_config_en_signal          : in    std_logic                      := 'X';             -- router_config_en_signal
			spwr_router_control_router_path_0_select_signal      : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- router_path_0_select_signal
			spwr_router_control_router_path_1_select_signal      : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- router_path_1_select_signal
			m1_ddr2_memory_avl_waitrequest_n                     : out   std_logic;                                         -- waitrequest_n
			m1_ddr2_memory_avl_beginbursttransfer                : in    std_logic                      := 'X';             -- beginbursttransfer
			m1_ddr2_memory_avl_address                           : in    std_logic_vector(25 downto 0)  := (others => 'X'); -- address
			m1_ddr2_memory_avl_readdatavalid                     : out   std_logic;                                         -- readdatavalid
			m1_ddr2_memory_avl_readdata                          : out   std_logic_vector(255 downto 0);                    -- readdata
			m1_ddr2_memory_avl_writedata                         : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			m1_ddr2_memory_avl_byteenable                        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			m1_ddr2_memory_avl_read                              : in    std_logic                      := 'X';             -- read
			m1_ddr2_memory_avl_write                             : in    std_logic                      := 'X';             -- write
			m1_ddr2_memory_avl_burstcount                        : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- burstcount
			m2_ddr2_memory_avl_waitrequest_n                     : out   std_logic;                                         -- waitrequest_n
			m2_ddr2_memory_avl_beginbursttransfer                : in    std_logic                      := 'X';             -- beginbursttransfer
			m2_ddr2_memory_avl_address                           : in    std_logic_vector(25 downto 0)  := (others => 'X'); -- address
			m2_ddr2_memory_avl_readdatavalid                     : out   std_logic;                                         -- readdatavalid
			m2_ddr2_memory_avl_readdata                          : out   std_logic_vector(255 downto 0);                    -- readdata
			m2_ddr2_memory_avl_writedata                         : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			m2_ddr2_memory_avl_byteenable                        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			m2_ddr2_memory_avl_read                              : in    std_logic                      := 'X';             -- read
			m2_ddr2_memory_avl_write                             : in    std_logic                      := 'X';             -- write
			m2_ddr2_memory_avl_burstcount                        : in    std_logic_vector(7 downto 0)   := (others => 'X')  -- burstcount
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			clk50_clk                                            => CONNECTED_TO_clk50_clk,                                            --                      clk50.clk
			m1_ddr2_memory_mem_a                                 => CONNECTED_TO_m1_ddr2_memory_mem_a,                                 --             m1_ddr2_memory.mem_a
			m1_ddr2_memory_mem_ba                                => CONNECTED_TO_m1_ddr2_memory_mem_ba,                                --                           .mem_ba
			m1_ddr2_memory_mem_ck                                => CONNECTED_TO_m1_ddr2_memory_mem_ck,                                --                           .mem_ck
			m1_ddr2_memory_mem_ck_n                              => CONNECTED_TO_m1_ddr2_memory_mem_ck_n,                              --                           .mem_ck_n
			m1_ddr2_memory_mem_cke                               => CONNECTED_TO_m1_ddr2_memory_mem_cke,                               --                           .mem_cke
			m1_ddr2_memory_mem_cs_n                              => CONNECTED_TO_m1_ddr2_memory_mem_cs_n,                              --                           .mem_cs_n
			m1_ddr2_memory_mem_dm                                => CONNECTED_TO_m1_ddr2_memory_mem_dm,                                --                           .mem_dm
			m1_ddr2_memory_mem_ras_n                             => CONNECTED_TO_m1_ddr2_memory_mem_ras_n,                             --                           .mem_ras_n
			m1_ddr2_memory_mem_cas_n                             => CONNECTED_TO_m1_ddr2_memory_mem_cas_n,                             --                           .mem_cas_n
			m1_ddr2_memory_mem_we_n                              => CONNECTED_TO_m1_ddr2_memory_mem_we_n,                              --                           .mem_we_n
			m1_ddr2_memory_mem_dq                                => CONNECTED_TO_m1_ddr2_memory_mem_dq,                                --                           .mem_dq
			m1_ddr2_memory_mem_dqs                               => CONNECTED_TO_m1_ddr2_memory_mem_dqs,                               --                           .mem_dqs
			m1_ddr2_memory_mem_dqs_n                             => CONNECTED_TO_m1_ddr2_memory_mem_dqs_n,                             --                           .mem_dqs_n
			m1_ddr2_memory_mem_odt                               => CONNECTED_TO_m1_ddr2_memory_mem_odt,                               --                           .mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                       => CONNECTED_TO_m1_ddr2_memory_pll_ref_clk_clk,                       -- m1_ddr2_memory_pll_ref_clk.clk
			m1_ddr2_memory_status_local_init_done                => CONNECTED_TO_m1_ddr2_memory_status_local_init_done,                --      m1_ddr2_memory_status.local_init_done
			m1_ddr2_memory_status_local_cal_success              => CONNECTED_TO_m1_ddr2_memory_status_local_cal_success,              --                           .local_cal_success
			m1_ddr2_memory_status_local_cal_fail                 => CONNECTED_TO_m1_ddr2_memory_status_local_cal_fail,                 --                           .local_cal_fail
			m1_ddr2_oct_rdn                                      => CONNECTED_TO_m1_ddr2_oct_rdn,                                      --                m1_ddr2_oct.rdn
			m1_ddr2_oct_rup                                      => CONNECTED_TO_m1_ddr2_oct_rup,                                      --                           .rup
			m2_ddr2_memory_mem_a                                 => CONNECTED_TO_m2_ddr2_memory_mem_a,                                 --             m2_ddr2_memory.mem_a
			m2_ddr2_memory_mem_ba                                => CONNECTED_TO_m2_ddr2_memory_mem_ba,                                --                           .mem_ba
			m2_ddr2_memory_mem_ck                                => CONNECTED_TO_m2_ddr2_memory_mem_ck,                                --                           .mem_ck
			m2_ddr2_memory_mem_ck_n                              => CONNECTED_TO_m2_ddr2_memory_mem_ck_n,                              --                           .mem_ck_n
			m2_ddr2_memory_mem_cke                               => CONNECTED_TO_m2_ddr2_memory_mem_cke,                               --                           .mem_cke
			m2_ddr2_memory_mem_cs_n                              => CONNECTED_TO_m2_ddr2_memory_mem_cs_n,                              --                           .mem_cs_n
			m2_ddr2_memory_mem_dm                                => CONNECTED_TO_m2_ddr2_memory_mem_dm,                                --                           .mem_dm
			m2_ddr2_memory_mem_ras_n                             => CONNECTED_TO_m2_ddr2_memory_mem_ras_n,                             --                           .mem_ras_n
			m2_ddr2_memory_mem_cas_n                             => CONNECTED_TO_m2_ddr2_memory_mem_cas_n,                             --                           .mem_cas_n
			m2_ddr2_memory_mem_we_n                              => CONNECTED_TO_m2_ddr2_memory_mem_we_n,                              --                           .mem_we_n
			m2_ddr2_memory_mem_dq                                => CONNECTED_TO_m2_ddr2_memory_mem_dq,                                --                           .mem_dq
			m2_ddr2_memory_mem_dqs                               => CONNECTED_TO_m2_ddr2_memory_mem_dqs,                               --                           .mem_dqs
			m2_ddr2_memory_mem_dqs_n                             => CONNECTED_TO_m2_ddr2_memory_mem_dqs_n,                             --                           .mem_dqs_n
			m2_ddr2_memory_mem_odt                               => CONNECTED_TO_m2_ddr2_memory_mem_odt,                               --                           .mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked            => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_pll_locked,            -- m2_ddr2_memory_dll_sharing.dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl             => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_delayctrl,             --                           .dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk               => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_mem_clk,               -- m2_ddr2_memory_pll_sharing.pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk             => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk,             --                           .pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_locked,                --                           .pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk, --                           .pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk          => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,          --                           .pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk               => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_avl_clk,               --                           .pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk            => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_config_clk,            --                           .pll_config_clk
			m2_ddr2_memory_status_local_init_done                => CONNECTED_TO_m2_ddr2_memory_status_local_init_done,                --      m2_ddr2_memory_status.local_init_done
			m2_ddr2_memory_status_local_cal_success              => CONNECTED_TO_m2_ddr2_memory_status_local_cal_success,              --                           .local_cal_success
			m2_ddr2_memory_status_local_cal_fail                 => CONNECTED_TO_m2_ddr2_memory_status_local_cal_fail,                 --                           .local_cal_fail
			m2_ddr2_oct_rdn                                      => CONNECTED_TO_m2_ddr2_oct_rdn,                                      --                m2_ddr2_oct.rdn
			m2_ddr2_oct_rup                                      => CONNECTED_TO_m2_ddr2_oct_rup,                                      --                           .rup
			rst_reset_n                                          => CONNECTED_TO_rst_reset_n,                                          --                        rst.reset_n
			spwc_a_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_a_enable_spw_rx_enable_signal,                   --              spwc_a_enable.spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_a_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_a_leds_spw_red_status_led_signal,                --                spwc_a_leds.spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_a_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_in_signal,                --                spwc_a_lvds.spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_b_enable_spw_rx_enable_signal,                   --              spwc_b_enable.spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_b_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_b_leds_spw_red_status_led_signal,                --                spwc_b_leds.spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_b_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_in_signal,                --                spwc_b_lvds.spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_c_enable_spw_rx_enable_signal,                   --              spwc_c_enable.spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_c_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_c_leds_spw_red_status_led_signal,                --                spwc_c_leds.spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_c_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_in_signal,                --                spwc_c_lvds.spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_d_enable_spw_rx_enable_signal,                   --              spwc_d_enable.spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_d_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_d_leds_spw_red_status_led_signal,                --                spwc_d_leds.spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_d_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_in_signal,                --                spwc_d_lvds.spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_e_enable_spw_rx_enable_signal,                   --              spwc_e_enable.spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_e_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_e_leds_spw_red_status_led_signal,                --                spwc_e_leds.spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_e_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_in_signal,                --                spwc_e_lvds.spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_f_enable_spw_rx_enable_signal,                   --              spwc_f_enable.spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_f_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_f_leds_spw_red_status_led_signal,                --                spwc_f_leds.spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_f_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_in_signal,                --                spwc_f_lvds.spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_g_enable_spw_rx_enable_signal,                   --              spwc_g_enable.spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_g_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_g_leds_spw_red_status_led_signal,                --                spwc_g_leds.spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_g_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_in_signal,                --                spwc_g_lvds.spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal                   => CONNECTED_TO_spwc_h_enable_spw_rx_enable_signal,                   --              spwc_h_enable.spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal                   => CONNECTED_TO_spwc_h_enable_spw_tx_enable_signal,                   --                           .spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal                => CONNECTED_TO_spwc_h_leds_spw_red_status_led_signal,                --                spwc_h_leds.spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal              => CONNECTED_TO_spwc_h_leds_spw_green_status_led_signal,              --                           .spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal                => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_in_signal,                --                spwc_h_lvds.spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal                => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_in_signal,                --                           .spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal               => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_out_signal,               --                           .spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal               => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_out_signal,               --                           .spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal             => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_out_signal,             --                           .spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal             => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_out_signal,             --                           .spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal              => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_in_signal,              --                           .spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal              => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_in_signal,              --                           .spw_lvds_n_strobe_in_signal
			spwr_drivers_isolator_en_drivers_isolator_en_signal  => CONNECTED_TO_spwr_drivers_isolator_en_drivers_isolator_en_signal,  --   spwr_drivers_isolator_en.drivers_isolator_en_signal
			spwr_router_control_router_config_en_signal          => CONNECTED_TO_spwr_router_control_router_config_en_signal,          --        spwr_router_control.router_config_en_signal
			spwr_router_control_router_path_0_select_signal      => CONNECTED_TO_spwr_router_control_router_path_0_select_signal,      --                           .router_path_0_select_signal
			spwr_router_control_router_path_1_select_signal      => CONNECTED_TO_spwr_router_control_router_path_1_select_signal,      --                           .router_path_1_select_signal
			m1_ddr2_memory_avl_waitrequest_n                     => CONNECTED_TO_m1_ddr2_memory_avl_waitrequest_n,                     --         m1_ddr2_memory_avl.waitrequest_n
			m1_ddr2_memory_avl_beginbursttransfer                => CONNECTED_TO_m1_ddr2_memory_avl_beginbursttransfer,                --                           .beginbursttransfer
			m1_ddr2_memory_avl_address                           => CONNECTED_TO_m1_ddr2_memory_avl_address,                           --                           .address
			m1_ddr2_memory_avl_readdatavalid                     => CONNECTED_TO_m1_ddr2_memory_avl_readdatavalid,                     --                           .readdatavalid
			m1_ddr2_memory_avl_readdata                          => CONNECTED_TO_m1_ddr2_memory_avl_readdata,                          --                           .readdata
			m1_ddr2_memory_avl_writedata                         => CONNECTED_TO_m1_ddr2_memory_avl_writedata,                         --                           .writedata
			m1_ddr2_memory_avl_byteenable                        => CONNECTED_TO_m1_ddr2_memory_avl_byteenable,                        --                           .byteenable
			m1_ddr2_memory_avl_read                              => CONNECTED_TO_m1_ddr2_memory_avl_read,                              --                           .read
			m1_ddr2_memory_avl_write                             => CONNECTED_TO_m1_ddr2_memory_avl_write,                             --                           .write
			m1_ddr2_memory_avl_burstcount                        => CONNECTED_TO_m1_ddr2_memory_avl_burstcount,                        --                           .burstcount
			m2_ddr2_memory_avl_waitrequest_n                     => CONNECTED_TO_m2_ddr2_memory_avl_waitrequest_n,                     --         m2_ddr2_memory_avl.waitrequest_n
			m2_ddr2_memory_avl_beginbursttransfer                => CONNECTED_TO_m2_ddr2_memory_avl_beginbursttransfer,                --                           .beginbursttransfer
			m2_ddr2_memory_avl_address                           => CONNECTED_TO_m2_ddr2_memory_avl_address,                           --                           .address
			m2_ddr2_memory_avl_readdatavalid                     => CONNECTED_TO_m2_ddr2_memory_avl_readdatavalid,                     --                           .readdatavalid
			m2_ddr2_memory_avl_readdata                          => CONNECTED_TO_m2_ddr2_memory_avl_readdata,                          --                           .readdata
			m2_ddr2_memory_avl_writedata                         => CONNECTED_TO_m2_ddr2_memory_avl_writedata,                         --                           .writedata
			m2_ddr2_memory_avl_byteenable                        => CONNECTED_TO_m2_ddr2_memory_avl_byteenable,                        --                           .byteenable
			m2_ddr2_memory_avl_read                              => CONNECTED_TO_m2_ddr2_memory_avl_read,                              --                           .read
			m2_ddr2_memory_avl_write                             => CONNECTED_TO_m2_ddr2_memory_avl_write,                             --                           .write
			m2_ddr2_memory_avl_burstcount                        => CONNECTED_TO_m2_ddr2_memory_avl_burstcount                         --                           .burstcount
		);

