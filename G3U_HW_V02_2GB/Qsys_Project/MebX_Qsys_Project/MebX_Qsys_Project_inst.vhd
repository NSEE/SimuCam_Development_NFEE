	component MebX_Qsys_Project is
		port (
			button_export                                        : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk50_clk                                            : in    std_logic                     := 'X';             -- clk
			comm_a_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_a_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_a_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_a_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_b_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_b_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_b_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_b_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_c_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_c_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_c_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_c_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_d_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_d_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_d_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_d_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_e_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_e_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_e_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_e_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_f_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_f_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_f_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_f_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_g_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_g_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_g_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_g_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			comm_h_conduit_end_spw_si_signal                     : in    std_logic                     := 'X';             -- spw_si_signal
			comm_h_conduit_end_spw_di_signal                     : in    std_logic                     := 'X';             -- spw_di_signal
			comm_h_conduit_end_spw_do_signal                     : out   std_logic;                                        -- spw_do_signal
			comm_h_conduit_end_spw_so_signal                     : out   std_logic;                                        -- spw_so_signal
			csense_adc_fo_export                                 : out   std_logic;                                        -- export
			csense_cs_n_export                                   : out   std_logic_vector(1 downto 0);                     -- export
			csense_sck_export                                    : out   std_logic;                                        -- export
			csense_sdi_export                                    : out   std_logic;                                        -- export
			csense_sdo_export                                    : in    std_logic                     := 'X';             -- export
			ctrl_io_lvds_export                                  : out   std_logic_vector(3 downto 0);                     -- export
			dip_export                                           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			ext_export                                           : in    std_logic                     := 'X';             -- export
			led_de4_export                                       : out   std_logic_vector(7 downto 0);                     -- export
			led_painel_export                                    : out   std_logic_vector(20 downto 0);                    -- export
			m1_ddr2_i2c_scl_export                               : out   std_logic;                                        -- export
			m1_ddr2_i2c_sda_export                               : inout std_logic                     := 'X';             -- export
			m1_ddr2_memory_mem_a                                 : out   std_logic_vector(13 downto 0);                    -- mem_a
			m1_ddr2_memory_mem_ba                                : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m1_ddr2_memory_mem_ck                                : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m1_ddr2_memory_mem_ck_n                              : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m1_ddr2_memory_mem_cke                               : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m1_ddr2_memory_mem_cs_n                              : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m1_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m1_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m1_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m1_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m1_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m1_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m1_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m1_ddr2_memory_mem_odt                               : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                       : in    std_logic                     := 'X';             -- clk
			m1_ddr2_memory_status_local_init_done                : out   std_logic;                                        -- local_init_done
			m1_ddr2_memory_status_local_cal_success              : out   std_logic;                                        -- local_cal_success
			m1_ddr2_memory_status_local_cal_fail                 : out   std_logic;                                        -- local_cal_fail
			m1_ddr2_oct_rdn                                      : in    std_logic                     := 'X';             -- rdn
			m1_ddr2_oct_rup                                      : in    std_logic                     := 'X';             -- rup
			m2_ddr2_i2c_scl_export                               : out   std_logic;                                        -- export
			m2_ddr2_i2c_sda_export                               : inout std_logic                     := 'X';             -- export
			m2_ddr2_memory_mem_a                                 : out   std_logic_vector(13 downto 0);                    -- mem_a
			m2_ddr2_memory_mem_ba                                : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m2_ddr2_memory_mem_ck                                : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m2_ddr2_memory_mem_ck_n                              : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m2_ddr2_memory_mem_cke                               : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m2_ddr2_memory_mem_cs_n                              : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m2_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m2_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m2_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m2_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m2_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m2_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m2_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m2_ddr2_memory_mem_odt                               : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked            : in    std_logic                     := 'X';             -- dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl             : out   std_logic_vector(5 downto 0);                     -- dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk               : out   std_logic;                                        -- pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk             : out   std_logic;                                        -- pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                : out   std_logic;                                        -- pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk : out   std_logic;                                        -- pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk          : out   std_logic;                                        -- pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk               : out   std_logic;                                        -- pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk            : out   std_logic;                                        -- pll_config_clk
			m2_ddr2_memory_status_local_init_done                : out   std_logic;                                        -- local_init_done
			m2_ddr2_memory_status_local_cal_success              : out   std_logic;                                        -- local_cal_success
			m2_ddr2_memory_status_local_cal_fail                 : out   std_logic;                                        -- local_cal_fail
			m2_ddr2_oct_rdn                                      : in    std_logic                     := 'X';             -- rdn
			m2_ddr2_oct_rup                                      : in    std_logic                     := 'X';             -- rup
			rs232_uart_rxd                                       : in    std_logic                     := 'X';             -- rxd
			rs232_uart_txd                                       : out   std_logic;                                        -- txd
			rst_reset_n                                          : in    std_logic                     := 'X';             -- reset_n
			rtcc_alarm_export                                    : in    std_logic                     := 'X';             -- export
			rtcc_cs_n_export                                     : out   std_logic;                                        -- export
			rtcc_sck_export                                      : out   std_logic;                                        -- export
			rtcc_sdi_export                                      : out   std_logic;                                        -- export
			rtcc_sdo_export                                      : in    std_logic                     := 'X';             -- export
			sd_card_ip_b_SD_cmd                                  : inout std_logic                     := 'X';             -- b_SD_cmd
			sd_card_ip_b_SD_dat                                  : inout std_logic                     := 'X';             -- b_SD_dat
			sd_card_ip_b_SD_dat3                                 : inout std_logic                     := 'X';             -- b_SD_dat3
			sd_card_ip_o_SD_clock                                : out   std_logic;                                        -- o_SD_clock
			sd_card_wp_n_io_export                               : in    std_logic                     := 'X';             -- export
			ssdp_ssdp0                                           : out   std_logic_vector(7 downto 0);                     -- ssdp0
			ssdp_ssdp1                                           : out   std_logic_vector(7 downto 0);                     -- ssdp1
			temp_scl_export                                      : out   std_logic;                                        -- export
			temp_sda_export                                      : inout std_logic                     := 'X';             -- export
			timer_1ms_external_port_export                       : out   std_logic;                                        -- export
			timer_1us_external_port_export                       : out   std_logic;                                        -- export
			tristate_conduit_tcm_address_out                     : out   std_logic_vector(25 downto 0);                    -- tcm_address_out
			tristate_conduit_tcm_read_n_out                      : out   std_logic_vector(0 downto 0);                     -- tcm_read_n_out
			tristate_conduit_tcm_write_n_out                     : out   std_logic_vector(0 downto 0);                     -- tcm_write_n_out
			tristate_conduit_tcm_data_out                        : inout std_logic_vector(15 downto 0) := (others => 'X'); -- tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                : out   std_logic_vector(0 downto 0);                     -- tcm_chipselect_n_out
			sync_in_conduit                                      : in    std_logic                     := 'X';             -- conduit
			sync_spwa_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwb_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwc_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwd_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwe_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwf_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwg_conduit                                    : out   std_logic;                                        -- conduit
			sync_spwh_conduit                                    : out   std_logic;                                        -- conduit
			sync_out_conduit                                     : out   std_logic                                         -- conduit
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			button_export                                        => CONNECTED_TO_button_export,                                        --                     button.export
			clk50_clk                                            => CONNECTED_TO_clk50_clk,                                            --                      clk50.clk
			comm_a_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_a_conduit_end_spw_si_signal,                     --         comm_a_conduit_end.spw_si_signal
			comm_a_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_a_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_a_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_a_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_a_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_a_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_b_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_b_conduit_end_spw_si_signal,                     --         comm_b_conduit_end.spw_si_signal
			comm_b_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_b_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_b_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_b_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_b_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_b_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_c_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_c_conduit_end_spw_si_signal,                     --         comm_c_conduit_end.spw_si_signal
			comm_c_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_c_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_c_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_c_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_c_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_c_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_d_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_d_conduit_end_spw_si_signal,                     --         comm_d_conduit_end.spw_si_signal
			comm_d_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_d_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_d_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_d_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_d_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_d_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_e_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_e_conduit_end_spw_si_signal,                     --         comm_e_conduit_end.spw_si_signal
			comm_e_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_e_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_e_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_e_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_e_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_e_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_f_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_f_conduit_end_spw_si_signal,                     --         comm_f_conduit_end.spw_si_signal
			comm_f_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_f_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_f_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_f_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_f_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_f_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_g_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_g_conduit_end_spw_si_signal,                     --         comm_g_conduit_end.spw_si_signal
			comm_g_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_g_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_g_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_g_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_g_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_g_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			comm_h_conduit_end_spw_si_signal                     => CONNECTED_TO_comm_h_conduit_end_spw_si_signal,                     --         comm_h_conduit_end.spw_si_signal
			comm_h_conduit_end_spw_di_signal                     => CONNECTED_TO_comm_h_conduit_end_spw_di_signal,                     --                           .spw_di_signal
			comm_h_conduit_end_spw_do_signal                     => CONNECTED_TO_comm_h_conduit_end_spw_do_signal,                     --                           .spw_do_signal
			comm_h_conduit_end_spw_so_signal                     => CONNECTED_TO_comm_h_conduit_end_spw_so_signal,                     --                           .spw_so_signal
			csense_adc_fo_export                                 => CONNECTED_TO_csense_adc_fo_export,                                 --              csense_adc_fo.export
			csense_cs_n_export                                   => CONNECTED_TO_csense_cs_n_export,                                   --                csense_cs_n.export
			csense_sck_export                                    => CONNECTED_TO_csense_sck_export,                                    --                 csense_sck.export
			csense_sdi_export                                    => CONNECTED_TO_csense_sdi_export,                                    --                 csense_sdi.export
			csense_sdo_export                                    => CONNECTED_TO_csense_sdo_export,                                    --                 csense_sdo.export
			ctrl_io_lvds_export                                  => CONNECTED_TO_ctrl_io_lvds_export,                                  --               ctrl_io_lvds.export
			dip_export                                           => CONNECTED_TO_dip_export,                                           --                        dip.export
			ext_export                                           => CONNECTED_TO_ext_export,                                           --                        ext.export
			led_de4_export                                       => CONNECTED_TO_led_de4_export,                                       --                    led_de4.export
			led_painel_export                                    => CONNECTED_TO_led_painel_export,                                    --                 led_painel.export
			m1_ddr2_i2c_scl_export                               => CONNECTED_TO_m1_ddr2_i2c_scl_export,                               --            m1_ddr2_i2c_scl.export
			m1_ddr2_i2c_sda_export                               => CONNECTED_TO_m1_ddr2_i2c_sda_export,                               --            m1_ddr2_i2c_sda.export
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
			m2_ddr2_i2c_scl_export                               => CONNECTED_TO_m2_ddr2_i2c_scl_export,                               --            m2_ddr2_i2c_scl.export
			m2_ddr2_i2c_sda_export                               => CONNECTED_TO_m2_ddr2_i2c_sda_export,                               --            m2_ddr2_i2c_sda.export
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
			rs232_uart_rxd                                       => CONNECTED_TO_rs232_uart_rxd,                                       --                 rs232_uart.rxd
			rs232_uart_txd                                       => CONNECTED_TO_rs232_uart_txd,                                       --                           .txd
			rst_reset_n                                          => CONNECTED_TO_rst_reset_n,                                          --                        rst.reset_n
			rtcc_alarm_export                                    => CONNECTED_TO_rtcc_alarm_export,                                    --                 rtcc_alarm.export
			rtcc_cs_n_export                                     => CONNECTED_TO_rtcc_cs_n_export,                                     --                  rtcc_cs_n.export
			rtcc_sck_export                                      => CONNECTED_TO_rtcc_sck_export,                                      --                   rtcc_sck.export
			rtcc_sdi_export                                      => CONNECTED_TO_rtcc_sdi_export,                                      --                   rtcc_sdi.export
			rtcc_sdo_export                                      => CONNECTED_TO_rtcc_sdo_export,                                      --                   rtcc_sdo.export
			sd_card_ip_b_SD_cmd                                  => CONNECTED_TO_sd_card_ip_b_SD_cmd,                                  --                 sd_card_ip.b_SD_cmd
			sd_card_ip_b_SD_dat                                  => CONNECTED_TO_sd_card_ip_b_SD_dat,                                  --                           .b_SD_dat
			sd_card_ip_b_SD_dat3                                 => CONNECTED_TO_sd_card_ip_b_SD_dat3,                                 --                           .b_SD_dat3
			sd_card_ip_o_SD_clock                                => CONNECTED_TO_sd_card_ip_o_SD_clock,                                --                           .o_SD_clock
			sd_card_wp_n_io_export                               => CONNECTED_TO_sd_card_wp_n_io_export,                               --            sd_card_wp_n_io.export
			ssdp_ssdp0                                           => CONNECTED_TO_ssdp_ssdp0,                                           --                       ssdp.ssdp0
			ssdp_ssdp1                                           => CONNECTED_TO_ssdp_ssdp1,                                           --                           .ssdp1
			temp_scl_export                                      => CONNECTED_TO_temp_scl_export,                                      --                   temp_scl.export
			temp_sda_export                                      => CONNECTED_TO_temp_sda_export,                                      --                   temp_sda.export
			timer_1ms_external_port_export                       => CONNECTED_TO_timer_1ms_external_port_export,                       --    timer_1ms_external_port.export
			timer_1us_external_port_export                       => CONNECTED_TO_timer_1us_external_port_export,                       --    timer_1us_external_port.export
			tristate_conduit_tcm_address_out                     => CONNECTED_TO_tristate_conduit_tcm_address_out,                     --           tristate_conduit.tcm_address_out
			tristate_conduit_tcm_read_n_out                      => CONNECTED_TO_tristate_conduit_tcm_read_n_out,                      --                           .tcm_read_n_out
			tristate_conduit_tcm_write_n_out                     => CONNECTED_TO_tristate_conduit_tcm_write_n_out,                     --                           .tcm_write_n_out
			tristate_conduit_tcm_data_out                        => CONNECTED_TO_tristate_conduit_tcm_data_out,                        --                           .tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                => CONNECTED_TO_tristate_conduit_tcm_chipselect_n_out,                --                           .tcm_chipselect_n_out
			sync_in_conduit                                      => CONNECTED_TO_sync_in_conduit,                                      --                    sync_in.conduit
			sync_spwa_conduit                                    => CONNECTED_TO_sync_spwa_conduit,                                    --                  sync_spwa.conduit
			sync_spwb_conduit                                    => CONNECTED_TO_sync_spwb_conduit,                                    --                  sync_spwb.conduit
			sync_spwc_conduit                                    => CONNECTED_TO_sync_spwc_conduit,                                    --                  sync_spwc.conduit
			sync_spwd_conduit                                    => CONNECTED_TO_sync_spwd_conduit,                                    --                  sync_spwd.conduit
			sync_spwe_conduit                                    => CONNECTED_TO_sync_spwe_conduit,                                    --                  sync_spwe.conduit
			sync_spwf_conduit                                    => CONNECTED_TO_sync_spwf_conduit,                                    --                  sync_spwf.conduit
			sync_spwg_conduit                                    => CONNECTED_TO_sync_spwg_conduit,                                    --                  sync_spwg.conduit
			sync_spwh_conduit                                    => CONNECTED_TO_sync_spwh_conduit,                                    --                  sync_spwh.conduit
			sync_out_conduit                                     => CONNECTED_TO_sync_out_conduit                                      --                   sync_out.conduit
		);

