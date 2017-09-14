	component MebX_Qsys_Project is
		port (
			button_export                                        : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk50_clk                                            : in    std_logic                     := 'X';             -- clk
			csense_adc_fo_export                                 : out   std_logic;                                        -- export
			csense_cs_n_export                                   : out   std_logic_vector(1 downto 0);                     -- export
			csense_sck_export                                    : out   std_logic;                                        -- export
			csense_sdi_export                                    : out   std_logic;                                        -- export
			csense_sdo_export                                    : in    std_logic                     := 'X';             -- export
			dip_export                                           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			eth_rst_export                                       : out   std_logic;                                        -- export
			ext_export                                           : in    std_logic                     := 'X';             -- export
			led_de4_export                                       : out   std_logic_vector(7 downto 0);                     -- export
			led_painel_export                                    : out   std_logic_vector(12 downto 0);                    -- export
			m1_ddr2_i2c_scl_export                               : out   std_logic;                                        -- export
			m1_ddr2_i2c_sda_export                               : inout std_logic                     := 'X';             -- export
			m1_ddr2_memory_mem_a                                 : out   std_logic_vector(13 downto 0);                    -- mem_a
			m1_ddr2_memory_mem_ba                                : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m1_ddr2_memory_mem_ck                                : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m1_ddr2_memory_mem_ck_n                              : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m1_ddr2_memory_mem_cke                               : out   std_logic_vector(0 downto 0);                     -- mem_cke
			m1_ddr2_memory_mem_cs_n                              : out   std_logic_vector(0 downto 0);                     -- mem_cs_n
			m1_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m1_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m1_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m1_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m1_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m1_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m1_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m1_ddr2_memory_mem_odt                               : out   std_logic_vector(0 downto 0);                     -- mem_odt
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
			m2_ddr2_memory_mem_cke                               : out   std_logic_vector(0 downto 0);                     -- mem_cke
			m2_ddr2_memory_mem_cs_n                              : out   std_logic_vector(0 downto 0);                     -- mem_cs_n
			m2_ddr2_memory_mem_dm                                : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m2_ddr2_memory_mem_ras_n                             : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m2_ddr2_memory_mem_cas_n                             : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m2_ddr2_memory_mem_we_n                              : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m2_ddr2_memory_mem_dq                                : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m2_ddr2_memory_mem_dqs                               : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m2_ddr2_memory_mem_dqs_n                             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m2_ddr2_memory_mem_odt                               : out   std_logic_vector(0 downto 0);                     -- mem_odt
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
			rst_reset_n                                          : in    std_logic                     := 'X';             -- reset_n
			sd_clk_export                                        : out   std_logic;                                        -- export
			sd_cmd_export                                        : inout std_logic                     := 'X';             -- export
			sd_dat_export                                        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			sd_wp_n_export                                       : in    std_logic                     := 'X';             -- export
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
			tse_clk_clk                                          : in    std_logic                     := 'X';             -- clk
			tse_led_crs                                          : out   std_logic;                                        -- crs
			tse_led_link                                         : out   std_logic;                                        -- link
			tse_led_panel_link                                   : out   std_logic;                                        -- panel_link
			tse_led_col                                          : out   std_logic;                                        -- col
			tse_led_an                                           : out   std_logic;                                        -- an
			tse_led_char_err                                     : out   std_logic;                                        -- char_err
			tse_led_disp_err                                     : out   std_logic;                                        -- disp_err
			tse_mac_mac_misc_connection_xon_gen                  : in    std_logic                     := 'X';             -- xon_gen
			tse_mac_mac_misc_connection_xoff_gen                 : in    std_logic                     := 'X';             -- xoff_gen
			tse_mac_mac_misc_connection_magic_wakeup             : out   std_logic;                                        -- magic_wakeup
			tse_mac_mac_misc_connection_magic_sleep_n            : in    std_logic                     := 'X';             -- magic_sleep_n
			tse_mac_mac_misc_connection_ff_tx_crc_fwd            : in    std_logic                     := 'X';             -- ff_tx_crc_fwd
			tse_mac_mac_misc_connection_ff_tx_septy              : out   std_logic;                                        -- ff_tx_septy
			tse_mac_mac_misc_connection_tx_ff_uflow              : out   std_logic;                                        -- tx_ff_uflow
			tse_mac_mac_misc_connection_ff_tx_a_full             : out   std_logic;                                        -- ff_tx_a_full
			tse_mac_mac_misc_connection_ff_tx_a_empty            : out   std_logic;                                        -- ff_tx_a_empty
			tse_mac_mac_misc_connection_rx_err_stat              : out   std_logic_vector(17 downto 0);                    -- rx_err_stat
			tse_mac_mac_misc_connection_rx_frm_type              : out   std_logic_vector(3 downto 0);                     -- rx_frm_type
			tse_mac_mac_misc_connection_ff_rx_dsav               : out   std_logic;                                        -- ff_rx_dsav
			tse_mac_mac_misc_connection_ff_rx_a_full             : out   std_logic;                                        -- ff_rx_a_full
			tse_mac_mac_misc_connection_ff_rx_a_empty            : out   std_logic;                                        -- ff_rx_a_empty
			tse_mac_serdes_control_connection_export             : out   std_logic;                                        -- export
			tse_mdio_mdc                                         : out   std_logic;                                        -- mdc
			tse_mdio_mdio_in                                     : in    std_logic                     := 'X';             -- mdio_in
			tse_mdio_mdio_out                                    : out   std_logic;                                        -- mdio_out
			tse_mdio_mdio_oen                                    : out   std_logic;                                        -- mdio_oen
			tse_serial_txp                                       : out   std_logic;                                        -- txp
			tse_serial_rxp                                       : in    std_logic                     := 'X';             -- rxp
			ftdi_ftdi_data_signal                                : inout std_logic_vector(31 downto 0) := (others => 'X'); -- ftdi_data_signal
			ftdi_ftdi_be_signal                                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- ftdi_be_signal
			ftdi_ftdi_reset_n_signal                             : out   std_logic;                                        -- ftdi_reset_n_signal
			ftdi_ftdi_wakeup_n_signal                            : inout std_logic                     := 'X';             -- ftdi_wakeup_n_signal
			ftdi_ftdi_clock_signal                               : in    std_logic                     := 'X';             -- ftdi_clock_signal
			ftdi_ftdi_rxf_n_signal                               : in    std_logic                     := 'X';             -- ftdi_rxf_n_signal
			ftdi_ftdi_txe_n_signal                               : in    std_logic                     := 'X';             -- ftdi_txe_n_signal
			ftdi_ftdi_gpio_signal                                : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- ftdi_gpio_signal
			ftdi_ftdi_wr_n_signal                                : out   std_logic;                                        -- ftdi_wr_n_signal
			ftdi_ftdi_rd_n_signal                                : out   std_logic;                                        -- ftdi_rd_n_signal
			ftdi_ftdi_oe_n_signal                                : out   std_logic;                                        -- ftdi_oe_n_signal
			ftdi_ftdi_siwu_n_signal                              : out   std_logic                                         -- ftdi_siwu_n_signal
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			button_export                                        => CONNECTED_TO_button_export,                                        --                            button.export
			clk50_clk                                            => CONNECTED_TO_clk50_clk,                                            --                             clk50.clk
			csense_adc_fo_export                                 => CONNECTED_TO_csense_adc_fo_export,                                 --                     csense_adc_fo.export
			csense_cs_n_export                                   => CONNECTED_TO_csense_cs_n_export,                                   --                       csense_cs_n.export
			csense_sck_export                                    => CONNECTED_TO_csense_sck_export,                                    --                        csense_sck.export
			csense_sdi_export                                    => CONNECTED_TO_csense_sdi_export,                                    --                        csense_sdi.export
			csense_sdo_export                                    => CONNECTED_TO_csense_sdo_export,                                    --                        csense_sdo.export
			dip_export                                           => CONNECTED_TO_dip_export,                                           --                               dip.export
			eth_rst_export                                       => CONNECTED_TO_eth_rst_export,                                       --                           eth_rst.export
			ext_export                                           => CONNECTED_TO_ext_export,                                           --                               ext.export
			led_de4_export                                       => CONNECTED_TO_led_de4_export,                                       --                           led_de4.export
			led_painel_export                                    => CONNECTED_TO_led_painel_export,                                    --                        led_painel.export
			m1_ddr2_i2c_scl_export                               => CONNECTED_TO_m1_ddr2_i2c_scl_export,                               --                   m1_ddr2_i2c_scl.export
			m1_ddr2_i2c_sda_export                               => CONNECTED_TO_m1_ddr2_i2c_sda_export,                               --                   m1_ddr2_i2c_sda.export
			m1_ddr2_memory_mem_a                                 => CONNECTED_TO_m1_ddr2_memory_mem_a,                                 --                    m1_ddr2_memory.mem_a
			m1_ddr2_memory_mem_ba                                => CONNECTED_TO_m1_ddr2_memory_mem_ba,                                --                                  .mem_ba
			m1_ddr2_memory_mem_ck                                => CONNECTED_TO_m1_ddr2_memory_mem_ck,                                --                                  .mem_ck
			m1_ddr2_memory_mem_ck_n                              => CONNECTED_TO_m1_ddr2_memory_mem_ck_n,                              --                                  .mem_ck_n
			m1_ddr2_memory_mem_cke                               => CONNECTED_TO_m1_ddr2_memory_mem_cke,                               --                                  .mem_cke
			m1_ddr2_memory_mem_cs_n                              => CONNECTED_TO_m1_ddr2_memory_mem_cs_n,                              --                                  .mem_cs_n
			m1_ddr2_memory_mem_dm                                => CONNECTED_TO_m1_ddr2_memory_mem_dm,                                --                                  .mem_dm
			m1_ddr2_memory_mem_ras_n                             => CONNECTED_TO_m1_ddr2_memory_mem_ras_n,                             --                                  .mem_ras_n
			m1_ddr2_memory_mem_cas_n                             => CONNECTED_TO_m1_ddr2_memory_mem_cas_n,                             --                                  .mem_cas_n
			m1_ddr2_memory_mem_we_n                              => CONNECTED_TO_m1_ddr2_memory_mem_we_n,                              --                                  .mem_we_n
			m1_ddr2_memory_mem_dq                                => CONNECTED_TO_m1_ddr2_memory_mem_dq,                                --                                  .mem_dq
			m1_ddr2_memory_mem_dqs                               => CONNECTED_TO_m1_ddr2_memory_mem_dqs,                               --                                  .mem_dqs
			m1_ddr2_memory_mem_dqs_n                             => CONNECTED_TO_m1_ddr2_memory_mem_dqs_n,                             --                                  .mem_dqs_n
			m1_ddr2_memory_mem_odt                               => CONNECTED_TO_m1_ddr2_memory_mem_odt,                               --                                  .mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                       => CONNECTED_TO_m1_ddr2_memory_pll_ref_clk_clk,                       --        m1_ddr2_memory_pll_ref_clk.clk
			m1_ddr2_memory_status_local_init_done                => CONNECTED_TO_m1_ddr2_memory_status_local_init_done,                --             m1_ddr2_memory_status.local_init_done
			m1_ddr2_memory_status_local_cal_success              => CONNECTED_TO_m1_ddr2_memory_status_local_cal_success,              --                                  .local_cal_success
			m1_ddr2_memory_status_local_cal_fail                 => CONNECTED_TO_m1_ddr2_memory_status_local_cal_fail,                 --                                  .local_cal_fail
			m1_ddr2_oct_rdn                                      => CONNECTED_TO_m1_ddr2_oct_rdn,                                      --                       m1_ddr2_oct.rdn
			m1_ddr2_oct_rup                                      => CONNECTED_TO_m1_ddr2_oct_rup,                                      --                                  .rup
			m2_ddr2_i2c_scl_export                               => CONNECTED_TO_m2_ddr2_i2c_scl_export,                               --                   m2_ddr2_i2c_scl.export
			m2_ddr2_i2c_sda_export                               => CONNECTED_TO_m2_ddr2_i2c_sda_export,                               --                   m2_ddr2_i2c_sda.export
			m2_ddr2_memory_mem_a                                 => CONNECTED_TO_m2_ddr2_memory_mem_a,                                 --                    m2_ddr2_memory.mem_a
			m2_ddr2_memory_mem_ba                                => CONNECTED_TO_m2_ddr2_memory_mem_ba,                                --                                  .mem_ba
			m2_ddr2_memory_mem_ck                                => CONNECTED_TO_m2_ddr2_memory_mem_ck,                                --                                  .mem_ck
			m2_ddr2_memory_mem_ck_n                              => CONNECTED_TO_m2_ddr2_memory_mem_ck_n,                              --                                  .mem_ck_n
			m2_ddr2_memory_mem_cke                               => CONNECTED_TO_m2_ddr2_memory_mem_cke,                               --                                  .mem_cke
			m2_ddr2_memory_mem_cs_n                              => CONNECTED_TO_m2_ddr2_memory_mem_cs_n,                              --                                  .mem_cs_n
			m2_ddr2_memory_mem_dm                                => CONNECTED_TO_m2_ddr2_memory_mem_dm,                                --                                  .mem_dm
			m2_ddr2_memory_mem_ras_n                             => CONNECTED_TO_m2_ddr2_memory_mem_ras_n,                             --                                  .mem_ras_n
			m2_ddr2_memory_mem_cas_n                             => CONNECTED_TO_m2_ddr2_memory_mem_cas_n,                             --                                  .mem_cas_n
			m2_ddr2_memory_mem_we_n                              => CONNECTED_TO_m2_ddr2_memory_mem_we_n,                              --                                  .mem_we_n
			m2_ddr2_memory_mem_dq                                => CONNECTED_TO_m2_ddr2_memory_mem_dq,                                --                                  .mem_dq
			m2_ddr2_memory_mem_dqs                               => CONNECTED_TO_m2_ddr2_memory_mem_dqs,                               --                                  .mem_dqs
			m2_ddr2_memory_mem_dqs_n                             => CONNECTED_TO_m2_ddr2_memory_mem_dqs_n,                             --                                  .mem_dqs_n
			m2_ddr2_memory_mem_odt                               => CONNECTED_TO_m2_ddr2_memory_mem_odt,                               --                                  .mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked            => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_pll_locked,            --        m2_ddr2_memory_dll_sharing.dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl             => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_delayctrl,             --                                  .dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk               => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_mem_clk,               --        m2_ddr2_memory_pll_sharing.pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk             => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk,             --                                  .pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_locked,                --                                  .pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk, --                                  .pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk          => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,          --                                  .pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk               => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_avl_clk,               --                                  .pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk            => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_config_clk,            --                                  .pll_config_clk
			m2_ddr2_memory_status_local_init_done                => CONNECTED_TO_m2_ddr2_memory_status_local_init_done,                --             m2_ddr2_memory_status.local_init_done
			m2_ddr2_memory_status_local_cal_success              => CONNECTED_TO_m2_ddr2_memory_status_local_cal_success,              --                                  .local_cal_success
			m2_ddr2_memory_status_local_cal_fail                 => CONNECTED_TO_m2_ddr2_memory_status_local_cal_fail,                 --                                  .local_cal_fail
			m2_ddr2_oct_rdn                                      => CONNECTED_TO_m2_ddr2_oct_rdn,                                      --                       m2_ddr2_oct.rdn
			m2_ddr2_oct_rup                                      => CONNECTED_TO_m2_ddr2_oct_rup,                                      --                                  .rup
			rst_reset_n                                          => CONNECTED_TO_rst_reset_n,                                          --                               rst.reset_n
			sd_clk_export                                        => CONNECTED_TO_sd_clk_export,                                        --                            sd_clk.export
			sd_cmd_export                                        => CONNECTED_TO_sd_cmd_export,                                        --                            sd_cmd.export
			sd_dat_export                                        => CONNECTED_TO_sd_dat_export,                                        --                            sd_dat.export
			sd_wp_n_export                                       => CONNECTED_TO_sd_wp_n_export,                                       --                           sd_wp_n.export
			ssdp_ssdp0                                           => CONNECTED_TO_ssdp_ssdp0,                                           --                              ssdp.ssdp0
			ssdp_ssdp1                                           => CONNECTED_TO_ssdp_ssdp1,                                           --                                  .ssdp1
			temp_scl_export                                      => CONNECTED_TO_temp_scl_export,                                      --                          temp_scl.export
			temp_sda_export                                      => CONNECTED_TO_temp_sda_export,                                      --                          temp_sda.export
			timer_1ms_external_port_export                       => CONNECTED_TO_timer_1ms_external_port_export,                       --           timer_1ms_external_port.export
			timer_1us_external_port_export                       => CONNECTED_TO_timer_1us_external_port_export,                       --           timer_1us_external_port.export
			tristate_conduit_tcm_address_out                     => CONNECTED_TO_tristate_conduit_tcm_address_out,                     --                  tristate_conduit.tcm_address_out
			tristate_conduit_tcm_read_n_out                      => CONNECTED_TO_tristate_conduit_tcm_read_n_out,                      --                                  .tcm_read_n_out
			tristate_conduit_tcm_write_n_out                     => CONNECTED_TO_tristate_conduit_tcm_write_n_out,                     --                                  .tcm_write_n_out
			tristate_conduit_tcm_data_out                        => CONNECTED_TO_tristate_conduit_tcm_data_out,                        --                                  .tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                => CONNECTED_TO_tristate_conduit_tcm_chipselect_n_out,                --                                  .tcm_chipselect_n_out
			tse_clk_clk                                          => CONNECTED_TO_tse_clk_clk,                                          --                           tse_clk.clk
			tse_led_crs                                          => CONNECTED_TO_tse_led_crs,                                          --                           tse_led.crs
			tse_led_link                                         => CONNECTED_TO_tse_led_link,                                         --                                  .link
			tse_led_panel_link                                   => CONNECTED_TO_tse_led_panel_link,                                   --                                  .panel_link
			tse_led_col                                          => CONNECTED_TO_tse_led_col,                                          --                                  .col
			tse_led_an                                           => CONNECTED_TO_tse_led_an,                                           --                                  .an
			tse_led_char_err                                     => CONNECTED_TO_tse_led_char_err,                                     --                                  .char_err
			tse_led_disp_err                                     => CONNECTED_TO_tse_led_disp_err,                                     --                                  .disp_err
			tse_mac_mac_misc_connection_xon_gen                  => CONNECTED_TO_tse_mac_mac_misc_connection_xon_gen,                  --       tse_mac_mac_misc_connection.xon_gen
			tse_mac_mac_misc_connection_xoff_gen                 => CONNECTED_TO_tse_mac_mac_misc_connection_xoff_gen,                 --                                  .xoff_gen
			tse_mac_mac_misc_connection_magic_wakeup             => CONNECTED_TO_tse_mac_mac_misc_connection_magic_wakeup,             --                                  .magic_wakeup
			tse_mac_mac_misc_connection_magic_sleep_n            => CONNECTED_TO_tse_mac_mac_misc_connection_magic_sleep_n,            --                                  .magic_sleep_n
			tse_mac_mac_misc_connection_ff_tx_crc_fwd            => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_crc_fwd,            --                                  .ff_tx_crc_fwd
			tse_mac_mac_misc_connection_ff_tx_septy              => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_septy,              --                                  .ff_tx_septy
			tse_mac_mac_misc_connection_tx_ff_uflow              => CONNECTED_TO_tse_mac_mac_misc_connection_tx_ff_uflow,              --                                  .tx_ff_uflow
			tse_mac_mac_misc_connection_ff_tx_a_full             => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_a_full,             --                                  .ff_tx_a_full
			tse_mac_mac_misc_connection_ff_tx_a_empty            => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_a_empty,            --                                  .ff_tx_a_empty
			tse_mac_mac_misc_connection_rx_err_stat              => CONNECTED_TO_tse_mac_mac_misc_connection_rx_err_stat,              --                                  .rx_err_stat
			tse_mac_mac_misc_connection_rx_frm_type              => CONNECTED_TO_tse_mac_mac_misc_connection_rx_frm_type,              --                                  .rx_frm_type
			tse_mac_mac_misc_connection_ff_rx_dsav               => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_dsav,               --                                  .ff_rx_dsav
			tse_mac_mac_misc_connection_ff_rx_a_full             => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_a_full,             --                                  .ff_rx_a_full
			tse_mac_mac_misc_connection_ff_rx_a_empty            => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_a_empty,            --                                  .ff_rx_a_empty
			tse_mac_serdes_control_connection_export             => CONNECTED_TO_tse_mac_serdes_control_connection_export,             -- tse_mac_serdes_control_connection.export
			tse_mdio_mdc                                         => CONNECTED_TO_tse_mdio_mdc,                                         --                          tse_mdio.mdc
			tse_mdio_mdio_in                                     => CONNECTED_TO_tse_mdio_mdio_in,                                     --                                  .mdio_in
			tse_mdio_mdio_out                                    => CONNECTED_TO_tse_mdio_mdio_out,                                    --                                  .mdio_out
			tse_mdio_mdio_oen                                    => CONNECTED_TO_tse_mdio_mdio_oen,                                    --                                  .mdio_oen
			tse_serial_txp                                       => CONNECTED_TO_tse_serial_txp,                                       --                        tse_serial.txp
			tse_serial_rxp                                       => CONNECTED_TO_tse_serial_rxp,                                       --                                  .rxp
			ftdi_ftdi_data_signal                                => CONNECTED_TO_ftdi_ftdi_data_signal,                                --                              ftdi.ftdi_data_signal
			ftdi_ftdi_be_signal                                  => CONNECTED_TO_ftdi_ftdi_be_signal,                                  --                                  .ftdi_be_signal
			ftdi_ftdi_reset_n_signal                             => CONNECTED_TO_ftdi_ftdi_reset_n_signal,                             --                                  .ftdi_reset_n_signal
			ftdi_ftdi_wakeup_n_signal                            => CONNECTED_TO_ftdi_ftdi_wakeup_n_signal,                            --                                  .ftdi_wakeup_n_signal
			ftdi_ftdi_clock_signal                               => CONNECTED_TO_ftdi_ftdi_clock_signal,                               --                                  .ftdi_clock_signal
			ftdi_ftdi_rxf_n_signal                               => CONNECTED_TO_ftdi_ftdi_rxf_n_signal,                               --                                  .ftdi_rxf_n_signal
			ftdi_ftdi_txe_n_signal                               => CONNECTED_TO_ftdi_ftdi_txe_n_signal,                               --                                  .ftdi_txe_n_signal
			ftdi_ftdi_gpio_signal                                => CONNECTED_TO_ftdi_ftdi_gpio_signal,                                --                                  .ftdi_gpio_signal
			ftdi_ftdi_wr_n_signal                                => CONNECTED_TO_ftdi_ftdi_wr_n_signal,                                --                                  .ftdi_wr_n_signal
			ftdi_ftdi_rd_n_signal                                => CONNECTED_TO_ftdi_ftdi_rd_n_signal,                                --                                  .ftdi_rd_n_signal
			ftdi_ftdi_oe_n_signal                                => CONNECTED_TO_ftdi_ftdi_oe_n_signal,                                --                                  .ftdi_oe_n_signal
			ftdi_ftdi_siwu_n_signal                              => CONNECTED_TO_ftdi_ftdi_siwu_n_signal                               --                                  .ftdi_siwu_n_signal
		);

