-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
--
-- Rodrigo Fran�a - rodrigo.franca@maua.br 
-- Plat�o Simucam 3.0
--
-- Dez/2018
--
--------------------------------------------------------------------------------
-- Descricao
--
-- Funcionalidade
--
-- NOTE
--
--  DDR2
--  When switch : 1.Run Analysis & Synthesis 2.Run Tcl 3.Full Compile
--------------------------------------------------------------------------------

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity MebX_TopLevel is
	port(
		-- Clock Ports
		i_de4_osc_50_bank2       : in    std_logic;
		i_de4_osc_50_bank3       : in    std_logic;
		i_de4_osc_50_bank4       : in    std_logic;
		-- Reset Ports
		i_de4_cpu_reset_n        : in    std_logic;
		i_painel_reset_n         : in    std_logic;
		-- Button Ports
		i_de4_button             : in    std_logic_vector(3 downto 0);
		i_de4_sw                 : in    std_logic_vector(7 downto 0);
		-- LED Ports
		o_de4_led                : out   std_logic_vector(7 downto 0);
		o_painel_led_chA_green   : out   std_logic;
		o_painel_led_chA_red     : out   std_logic;
		o_painel_led_chB_green   : out   std_logic;
		o_painel_led_chB_red     : out   std_logic;
		o_painel_led_chC_green   : out   std_logic;
		o_painel_led_chC_red     : out   std_logic;
		o_painel_led_chD_green   : out   std_logic;
		o_painel_led_chD_red     : out   std_logic;
		o_painel_led_chE_green   : out   std_logic;
		o_painel_led_chE_red     : out   std_logic;
		o_painel_led_chF_green   : out   std_logic;
		o_painel_led_chF_red     : out   std_logic;
		o_painel_led_chG_green   : out   std_logic;
		o_painel_led_chG_red     : out   std_logic;
		o_painel_led_chH_green   : out   std_logic;
		o_painel_led_chH_red     : out   std_logic;
		o_painel_led_power       : out   std_logic;
		o_painel_led_st1         : out   std_logic;
		o_painel_led_st2         : out   std_logic;
		o_painel_led_st3         : out   std_logic;
		o_painel_led_st4         : out   std_logic;
		-- Seven Segment Display Ports
		o_de4_hex1               : out   std_logic_vector(7 downto 0);
		o_de4_hex0               : out   std_logic_vector(7 downto 0);
		-- Fan Ports
		o_de4_fan_ctrl           : out   std_logic;
		-- SD Card Ports
		i_de4_sd_card_wp_n       : in    std_logic;
		b_de4_sd_card_cmd        : inout std_logic;
		b_de4_sd_card_dat        : inout std_logic;
		b_de4_sd_card_dat3       : inout std_logic;
		o_de4_sd_card_clock      : out   std_logic;
		-- DDR2 M2 Memory Ports
		o_de4_m2_ddr2_addr       : out   std_logic_vector(13 downto 0);
		o_de4_m2_ddr2_ba         : out   std_logic_vector(2 downto 0);
		b_de4_m2_ddr2_clk        : inout std_logic_vector(1 downto 0);
		b_de4_m2_ddr2_clk_n      : inout std_logic_vector(1 downto 0);
		o_de4_m2_ddr2_cke        : out   std_logic_vector(1 downto 0);
		o_de4_m2_ddr2_cs_n       : out   std_logic_vector(1 downto 0);
		o_de4_m2_ddr2_dm         : out   std_logic_vector(7 downto 0);
		o_de4_m2_ddr2_ras_n      : out   std_logic_vector(0 downto 0);
		o_de4_m2_ddr2_cas_n      : out   std_logic_vector(0 downto 0);
		o_de4_m2_ddr2_we_n       : out   std_logic_vector(0 downto 0);
		b_de4_m2_ddr2_dq         : inout std_logic_vector(63 downto 0);
		b_de4_m2_ddr2_dqs        : inout std_logic_vector(7 downto 0);
		b_de4_m2_ddr2_dqsn       : inout std_logic_vector(7 downto 0);
		o_de4_m2_ddr2_odt        : out   std_logic_vector(1 downto 0);
		i_de4_m2_ddr2_oct_rdn    : in    std_logic;
		i_de4_m2_ddr2_oct_rup    : in    std_logic;
		o_de4_m2_ddr2_scl        : out   std_logic;
		b_de4_m2_ddr2_sda        : inout std_logic;
		o_de4_m2_ddr2_sa         : out   std_logic_vector(1 downto 0);
		-- DDR2 M1 Memory Ports
		o_de4_m1_ddr2_addr       : out   std_logic_vector(13 downto 0);
		o_de4_m1_ddr2_ba         : out   std_logic_vector(2 downto 0);
		b_de4_m1_ddr2_clk        : inout std_logic_vector(1 downto 0);
		b_de4_m1_ddr2_clk_n      : inout std_logic_vector(1 downto 0);
		o_de4_m1_ddr2_cke        : out   std_logic_vector(1 downto 0);
		o_de4_m1_ddr2_cs_n       : out   std_logic_vector(1 downto 0);
		o_de4_m1_ddr2_dm         : out   std_logic_vector(7 downto 0);
		o_de4_m1_ddr2_ras_n      : out   std_logic_vector(0 downto 0);
		o_de4_m1_ddr2_cas_n      : out   std_logic_vector(0 downto 0);
		o_de4_m1_ddr2_we_n       : out   std_logic_vector(0 downto 0);
		b_de4_m1_ddr2_dq         : inout std_logic_vector(63 downto 0);
		b_de4_m1_ddr2_dqs        : inout std_logic_vector(7 downto 0);
		b_de4_m1_ddr2_dqsn       : inout std_logic_vector(7 downto 0);
		o_de4_m1_ddr2_odt        : out   std_logic_vector(1 downto 0);
		i_de4_m1_ddr2_oct_rdn    : in    std_logic;
		i_de4_m1_ddr2_oct_rup    : in    std_logic;
		o_de4_m1_ddr2_scl        : out   std_logic;
		b_de4_m1_ddr2_sda        : inout std_logic;
		o_de4_m1_ddr2_sa         : out   std_logic_vector(1 downto 0);
		-- Memory Access Ports
		o_de4_fsm_a              : out   std_logic_vector(25 downto 0);
		b_de4_fsm_d              : inout std_logic_vector(15 downto 0);
		-- Flash Control Ports
		o_de4_flash_adv_n        : out   std_logic;
		o_de4_flash_ce_n         : out   std_logic_vector(0 downto 0);
		o_de4_flash_clk          : out   std_logic;
		o_de4_flash_oe_n         : out   std_logic_vector(0 downto 0);
		o_de4_flash_reset_n      : out   std_logic;
		i_de4_flash_ryby_n       : in    std_logic;
		o_de4_flash_we_n         : out   std_logic_vector(0 downto 0);
		-- Sinais de controle - placa isoladora - habilitacao dos transmissores SpW e Sinc_out
		o_iso_en_drivers         : out   std_logic;
		-- Sinais externos LVDS HSMC-B
		-- Sinais de controle - placa drivers_lvds
		o_hsmb_buffer_pwdn_n     : out   std_logic;
		o_hsmb_buffer_pem1       : out   std_logic;
		o_hsmb_buffer_pem0       : out   std_logic;
		-- SpaceWire A Ports
		i_hsmb_lvds_rx_spwa_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwa_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwa_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwa_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire B Ports
		i_hsmb_lvds_rx_spwb_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwb_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwb_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwb_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire C Ports
		i_hsmb_lvds_rx_spwc_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwc_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwc_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwc_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire D Ports
		i_hsmb_lvds_rx_spwd_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwd_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwd_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwd_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire E Ports
		i_hsmb_lvds_rx_spwe_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwe_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwe_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwe_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire F Ports
		i_hsmb_lvds_rx_spwf_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwf_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwf_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwf_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire G Ports
		i_hsmb_lvds_rx_spwg_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwg_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwg_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwg_so_p : out   std_logic_vector(0 downto 0);
		-- SpaceWire H Ports
		i_hsmb_lvds_rx_spwh_di_p : in    std_logic_vector(0 downto 0);
		i_hsmb_lvds_rx_spwh_si_p : in    std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwh_do_p : out   std_logic_vector(0 downto 0);
		o_hsmb_lvds_tx_spwh_so_p : out   std_logic_vector(0 downto 0);
		-- Temperature Ports 
		i_de4_temp_int_n         : in    std_logic;
		o_de4_temp_smclk         : out   std_logic;
		b_de4_temp_smdat         : inout std_logic;
		-- Current Sense Ports
		o_de4_csense_adc_fo      : out   std_logic;
		o_de4_csense_cs_n        : out   std_logic_vector(1 downto 0);
		o_de4_csense_sck         : out   std_logic;
		o_de4_csense_sdi         : out   std_logic;
		i_de4_csense_sdo         : in    std_logic;
		-- Real Time Clock Ports
		i_painel_rtcc_alarm      : in    std_logic;
		o_painel_rtcc_cs_n       : out   std_logic;
		o_painel_rtcc_sck        : out   std_logic;
		o_painel_rtcc_sdi        : out   std_logic;
		i_painel_rtcc_sdo        : in    std_logic;
		-- Synchronization Ports
		i_painel_sync_in         : in    std_logic;
		o_painel_sync_out        : out   std_logic;
		-- Just test with single ended i/o´s - remove in production version
		i_de4_sync_in_tst        : in    std_logic;
		o_de4_sync_out_tst       : out   std_logic;
		-- RS232 UART Ports
		i_de4_rs232_uart_rxd     : in    std_logic;
		o_de4_rs232_uart_txd     : out   std_logic
	);
end entity;

architecture bhv of MebX_TopLevel is

	-----------------------------------------
	-- Clock e reset
	-----------------------------------------
	signal clk125, clk100, clk80 : std_logic;

	signal forceIntRst_n : std_logic := '0';

	attribute KEEP : boolean;
	attribute KEEP of clk100 : signal is true;
	attribute KEEP of clk80 : signal is true;

	-----------------------------------------
	-- LEDs
	-----------------------------------------
	signal leds_b : std_logic_vector(7 downto 0);
	signal leds_p : std_logic_vector(20 downto 0);

	-----------------------------------------
	-- Ctrl io lvds
	-----------------------------------------
	signal ctrl_io_lvds : std_logic_vector(3 downto 0);

	-----------------------------------------
	-- RST CPU
	-----------------------------------------
	signal rst : std_logic;

	signal pll_locked : std_logic;

	-----------------------------------------
	-- Signals
	-----------------------------------------
	signal spw_a_si : std_logic_vector(0 downto 0);
	signal spw_a_so : std_logic_vector(0 downto 0);
	signal spw_a_di : std_logic_vector(0 downto 0);
	signal spw_a_do : std_logic_vector(0 downto 0);
	signal spw_b_si : std_logic_vector(0 downto 0);
	signal spw_b_so : std_logic_vector(0 downto 0);
	signal spw_b_di : std_logic_vector(0 downto 0);
	signal spw_b_do : std_logic_vector(0 downto 0);
	signal spw_c_si : std_logic_vector(0 downto 0);
	signal spw_c_so : std_logic_vector(0 downto 0);
	signal spw_c_di : std_logic_vector(0 downto 0);
	signal spw_c_do : std_logic_vector(0 downto 0);
	signal spw_d_si : std_logic_vector(0 downto 0);
	signal spw_d_so : std_logic_vector(0 downto 0);
	signal spw_d_di : std_logic_vector(0 downto 0);
	signal spw_d_do : std_logic_vector(0 downto 0);
	signal spw_e_si : std_logic_vector(0 downto 0);
	signal spw_e_so : std_logic_vector(0 downto 0);
	signal spw_e_di : std_logic_vector(0 downto 0);
	signal spw_e_do : std_logic_vector(0 downto 0);
	signal spw_f_si : std_logic_vector(0 downto 0);
	signal spw_f_so : std_logic_vector(0 downto 0);
	signal spw_f_di : std_logic_vector(0 downto 0);
	signal spw_f_do : std_logic_vector(0 downto 0);
	signal spw_g_si : std_logic_vector(0 downto 0);
	signal spw_g_so : std_logic_vector(0 downto 0);
	signal spw_g_di : std_logic_vector(0 downto 0);
	signal spw_g_do : std_logic_vector(0 downto 0);
	signal spw_h_si : std_logic_vector(0 downto 0);
	signal spw_h_so : std_logic_vector(0 downto 0);
	signal spw_h_di : std_logic_vector(0 downto 0);
	signal spw_h_do : std_logic_vector(0 downto 0);

	-----------------------------------------
	-- Sync - test
	-----------------------------------------
	signal s_sync_out : std_logic := '0';
	signal s_sync_in  : std_logic := '0';

	-----------------------------------------
	-- Component
	-----------------------------------------

	component MebX_Qsys_Project is
		port(
			rst_reset_n                           : in    std_logic;
			m2_ddr2_memory_mem_a                  : out   std_logic_vector(13 downto 0);
			m2_ddr2_memory_mem_ba                 : out   std_logic_vector(2 downto 0);
			m2_ddr2_memory_mem_ck                 : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_ck_n               : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_cke                : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_cs_n               : out   std_logic_vector(1 downto 0);
			m2_ddr2_memory_mem_dm                 : out   std_logic_vector(7 downto 0);
			m2_ddr2_memory_mem_ras_n              : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_cas_n              : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_we_n               : out   std_logic_vector(0 downto 0);
			m2_ddr2_memory_mem_dq                 : inout std_logic_vector(63 downto 0) := (others => 'X');
			m2_ddr2_memory_mem_dqs                : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m2_ddr2_memory_mem_dqs_n              : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m2_ddr2_memory_mem_odt                : out   std_logic_vector(1 downto 0);
			m2_ddr2_oct_rdn                       : in    std_logic                     := 'X';
			m2_ddr2_oct_rup                       : in    std_logic                     := 'X';
			m1_ddr2_memory_pll_ref_clk_clk        : in    std_logic                     := 'X'; -- clk
			m1_ddr2_memory_mem_a                  : out   std_logic_vector(13 downto 0);
			m1_ddr2_memory_mem_ba                 : out   std_logic_vector(2 downto 0);
			m1_ddr2_memory_mem_ck                 : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_ck_n               : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_cke                : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_cs_n               : out   std_logic_vector(1 downto 0);
			m1_ddr2_memory_mem_dm                 : out   std_logic_vector(7 downto 0);
			m1_ddr2_memory_mem_ras_n              : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_cas_n              : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_we_n               : out   std_logic_vector(0 downto 0);
			m1_ddr2_memory_mem_dq                 : inout std_logic_vector(63 downto 0) := (others => 'X');
			m1_ddr2_memory_mem_dqs                : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m1_ddr2_memory_mem_dqs_n              : inout std_logic_vector(7 downto 0)  := (others => 'X');
			m1_ddr2_memory_mem_odt                : out   std_logic_vector(1 downto 0);
			m1_ddr2_oct_rdn                       : in    std_logic                     := 'X';
			m1_ddr2_oct_rup                       : in    std_logic                     := 'X';
			clk50_clk                             : in    std_logic                     := 'X';
			tristate_conduit_tcm_address_out      : out   std_logic_vector(25 downto 0);
			tristate_conduit_tcm_read_n_out       : out   std_logic_vector(0 downto 0);
			tristate_conduit_tcm_write_n_out      : out   std_logic_vector(0 downto 0);
			tristate_conduit_tcm_data_out         : inout std_logic_vector(15 downto 0);
			tristate_conduit_tcm_chipselect_n_out : out   std_logic_vector(0 downto 0);
			button_export                         : in    std_logic_vector(3 downto 0);
			dip_export                            : in    std_logic_vector(7 downto 0);
			led_de4_export                        : out   std_logic_vector(7 downto 0);
			led_painel_export                     : out   std_logic_vector(20 downto 0);
			ssdp_ssdp1                            : out   std_logic_vector(7 downto 0);
			ssdp_ssdp0                            : out   std_logic_vector(7 downto 0);
			ctrl_io_lvds_export                   : out   std_logic_vector(3 downto 0);
			m1_ddr2_i2c_scl_export                : out   std_logic;
			m1_ddr2_i2c_sda_export                : inout std_logic;
			m2_ddr2_i2c_scl_export                : out   std_logic;
			m2_ddr2_i2c_sda_export                : inout std_logic;
			comm_a_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_a_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_a_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_a_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_b_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_b_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_b_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_b_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_c_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_c_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_c_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_c_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_d_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_d_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_d_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_d_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_e_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_e_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_e_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_e_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_f_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_f_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_f_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_f_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_g_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_g_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_g_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_g_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			comm_h_conduit_end_data_in_signal     : in    std_logic                     := 'X';             -- data_in_signal
			comm_h_conduit_end_data_out_signal    : out   std_logic;                                        -- data_out_signal
			comm_h_conduit_end_strobe_in_signal   : in    std_logic                     := 'X';             -- strobe_in_signal
			comm_h_conduit_end_strobe_out_signal  : out   std_logic;                                        -- strobe_out_signal
			temp_scl_export                       : out   std_logic;
			temp_sda_export                       : inout std_logic;
			csense_adc_fo_export                  : out   std_logic;
			csense_cs_n_export                    : out   std_logic_vector(1 downto 0);
			csense_sck_export                     : out   std_logic;
			csense_sdi_export                     : out   std_logic;
			csense_sdo_export                     : in    std_logic;
			rtcc_alarm_export                     : in    std_logic                     := 'X'; -- export
			rtcc_cs_n_export                      : out   std_logic; -- export
			rtcc_sck_export                       : out   std_logic; -- export
			rtcc_sdi_export                       : out   std_logic; -- export
			rtcc_sdo_export                       : in    std_logic                     := 'X'; -- export
			sync_in_conduit                       : in    std_logic                     := 'X';
			sync_out_conduit                      : out   std_logic;
			sync_spwa_conduit                     : out   std_logic;
			sync_spwb_conduit                     : out   std_logic;
			sync_spwc_conduit                     : out   std_logic;
			sync_spwd_conduit                     : out   std_logic;
			sync_spwe_conduit                     : out   std_logic;
			sync_spwf_conduit                     : out   std_logic;
			sync_spwg_conduit                     : out   std_logic;
			sync_spwh_conduit                     : out   std_logic;
			sd_card_wp_n_io_export                : in    std_logic                     := 'X'; -- export
			sd_card_ip_b_SD_cmd                   : inout std_logic                     := 'X'; -- b_SD_cmd
			sd_card_ip_b_SD_dat                   : inout std_logic                     := 'X'; -- b_SD_dat
			sd_card_ip_b_SD_dat3                  : inout std_logic                     := 'X'; -- b_SD_dat3
			sd_card_ip_o_SD_clock                 : out   std_logic; -- o_SD_clock
			rs232_uart_rxd                        : in    std_logic                     := 'X'; -- rxd
			rs232_uart_txd                        : out   std_logic -- txd
		);
	end component MebX_Qsys_Project;

	------------------------------------------------------------
begin

	--==========--
	-- AVALON
	--==========--
	SOPC_INST : MebX_Qsys_Project
		port map(
			clk50_clk                             => i_de4_osc_50_bank4,
			rst_reset_n                           => rst,
			led_de4_export                        => leds_b,
			led_painel_export                     => leds_p,
			ssdp_ssdp1                            => o_de4_hex1,
			ssdp_ssdp0                            => o_de4_hex0,
			dip_export                            => i_de4_sw,
			button_export                         => i_de4_button,
			ctrl_io_lvds_export                   => ctrl_io_lvds,
			tristate_conduit_tcm_address_out      => o_de4_fsm_a(25 downto 0),
			tristate_conduit_tcm_data_out         => b_de4_fsm_d,
			tristate_conduit_tcm_chipselect_n_out => o_de4_flash_ce_n,
			tristate_conduit_tcm_read_n_out       => o_de4_flash_oe_n,
			tristate_conduit_tcm_write_n_out      => o_de4_flash_we_n,
			m1_ddr2_memory_pll_ref_clk_clk        => i_de4_osc_50_bank3,
			m1_ddr2_memory_mem_a                  => o_de4_m1_ddr2_addr,
			m1_ddr2_memory_mem_ba                 => o_de4_m1_ddr2_ba,
			m1_ddr2_memory_mem_ck                 => b_de4_m1_ddr2_clk,
			m1_ddr2_memory_mem_ck_n               => b_de4_m1_ddr2_clk_n,
			m1_ddr2_memory_mem_cke                => o_de4_m1_ddr2_cke,
			m1_ddr2_memory_mem_cs_n               => o_de4_m1_ddr2_cs_n,
			m1_ddr2_memory_mem_dm                 => o_de4_m1_ddr2_dm,
			m1_ddr2_memory_mem_ras_n              => o_de4_m1_ddr2_ras_n,
			m1_ddr2_memory_mem_cas_n              => o_de4_m1_ddr2_cas_n,
			m1_ddr2_memory_mem_we_n               => o_de4_m1_ddr2_we_n,
			m1_ddr2_memory_mem_dq                 => b_de4_m1_ddr2_dq,
			m1_ddr2_memory_mem_dqs                => b_de4_m1_ddr2_dqs,
			m1_ddr2_memory_mem_dqs_n              => b_de4_m1_ddr2_dqsn,
			m1_ddr2_memory_mem_odt                => o_de4_m1_ddr2_odt,
			m1_ddr2_oct_rdn                       => i_de4_m1_ddr2_oct_rdn,
			m1_ddr2_oct_rup                       => i_de4_m1_ddr2_oct_rup,
			m1_ddr2_i2c_scl_export                => o_de4_m1_ddr2_scl,
			m1_ddr2_i2c_sda_export                => b_de4_m1_ddr2_sda,
			m2_ddr2_memory_mem_a                  => o_de4_m2_ddr2_addr,
			m2_ddr2_memory_mem_ba                 => o_de4_m2_ddr2_ba,
			m2_ddr2_memory_mem_ck                 => b_de4_m2_ddr2_clk,
			m2_ddr2_memory_mem_ck_n               => b_de4_m2_ddr2_clk_n,
			m2_ddr2_memory_mem_cke                => o_de4_m2_ddr2_cke,
			m2_ddr2_memory_mem_cs_n               => o_de4_m2_ddr2_cs_n,
			m2_ddr2_memory_mem_dm                 => o_de4_m2_ddr2_dm,
			m2_ddr2_memory_mem_ras_n              => o_de4_m2_ddr2_ras_n,
			m2_ddr2_memory_mem_cas_n              => o_de4_m2_ddr2_cas_n,
			m2_ddr2_memory_mem_we_n               => o_de4_m2_ddr2_we_n,
			m2_ddr2_memory_mem_dq                 => b_de4_m2_ddr2_dq,
			m2_ddr2_memory_mem_dqs                => b_de4_m2_ddr2_dqs,
			m2_ddr2_memory_mem_dqs_n              => b_de4_m2_ddr2_dqsn,
			m2_ddr2_memory_mem_odt                => o_de4_m2_ddr2_odt,
			m2_ddr2_oct_rdn                       => i_de4_m2_ddr2_oct_rdn,
			m2_ddr2_oct_rup                       => i_de4_m2_ddr2_oct_rup,
			m2_ddr2_i2c_scl_export                => o_de4_m2_ddr2_scl,
			m2_ddr2_i2c_sda_export                => b_de4_m2_ddr2_sda,
			comm_a_conduit_end_data_in_signal     => spw_a_di(0),
			comm_a_conduit_end_data_out_signal    => spw_a_do(0),
			comm_a_conduit_end_strobe_in_signal   => spw_a_si(0),
			comm_a_conduit_end_strobe_out_signal  => spw_a_so(0),
			comm_b_conduit_end_data_in_signal     => spw_b_di(0),
			comm_b_conduit_end_data_out_signal    => spw_b_do(0),
			comm_b_conduit_end_strobe_in_signal   => spw_b_si(0),
			comm_b_conduit_end_strobe_out_signal  => spw_b_so(0),
			comm_c_conduit_end_data_in_signal     => spw_c_di(0),
			comm_c_conduit_end_data_out_signal    => spw_c_do(0),
			comm_c_conduit_end_strobe_in_signal   => spw_c_si(0),
			comm_c_conduit_end_strobe_out_signal  => spw_c_so(0),
			comm_d_conduit_end_data_in_signal     => spw_d_di(0),
			comm_d_conduit_end_data_out_signal    => spw_d_do(0),
			comm_d_conduit_end_strobe_in_signal   => spw_d_si(0),
			comm_d_conduit_end_strobe_out_signal  => spw_d_so(0),
			comm_e_conduit_end_data_in_signal     => spw_e_di(0),
			comm_e_conduit_end_data_out_signal    => spw_e_do(0),
			comm_e_conduit_end_strobe_in_signal   => spw_e_si(0),
			comm_e_conduit_end_strobe_out_signal  => spw_e_so(0),
			comm_f_conduit_end_data_in_signal     => spw_f_di(0),
			comm_f_conduit_end_data_out_signal    => spw_f_do(0),
			comm_f_conduit_end_strobe_in_signal   => spw_f_si(0),
			comm_f_conduit_end_strobe_out_signal  => spw_f_so(0),
			comm_g_conduit_end_data_in_signal     => spw_g_di(0),
			comm_g_conduit_end_data_out_signal    => spw_g_do(0),
			comm_g_conduit_end_strobe_in_signal   => spw_g_si(0),
			comm_g_conduit_end_strobe_out_signal  => spw_g_so(0),
			comm_h_conduit_end_data_in_signal     => spw_h_di(0),
			comm_h_conduit_end_data_out_signal    => spw_h_do(0),
			comm_h_conduit_end_strobe_in_signal   => spw_h_si(0),
			comm_h_conduit_end_strobe_out_signal  => spw_h_so(0),
			temp_scl_export                       => o_de4_temp_smclk,
			temp_sda_export                       => b_de4_temp_smdat,
			csense_adc_fo_export                  => o_de4_csense_adc_fo,
			csense_cs_n_export                    => o_de4_csense_cs_n,
			csense_sck_export                     => o_de4_csense_sck,
			csense_sdi_export                     => o_de4_csense_sdi,
			csense_sdo_export                     => i_de4_csense_sdo,
			rtcc_alarm_export                     => i_painel_rtcc_alarm,
			rtcc_cs_n_export                      => o_painel_rtcc_cs_n,
			rtcc_sck_export                       => o_painel_rtcc_sck,
			rtcc_sdi_export                       => o_painel_rtcc_sdi,
			rtcc_sdo_export                       => i_painel_rtcc_sdo,
			sync_in_conduit                       => s_sync_in, --i_painel_sync_in,
			sync_out_conduit                      => s_sync_out, --o_painel_sync_out,
			sync_spwa_conduit                     => open,
			sync_spwb_conduit                     => open,
			sync_spwc_conduit                     => open,
			sync_spwd_conduit                     => open,
			sync_spwe_conduit                     => open,
			sync_spwf_conduit                     => open,
			sync_spwg_conduit                     => open,
			sync_spwh_conduit                     => open,
			sd_card_wp_n_io_export                => i_de4_sd_card_wp_n, -- sd_card_wp_n_io.export
			sd_card_ip_b_SD_cmd                   => b_de4_sd_card_cmd, -- sd_card_ip.b_SD_cmd
			sd_card_ip_b_SD_dat                   => b_de4_sd_card_dat, --           .b_SD_dat
			sd_card_ip_b_SD_dat3                  => b_de4_sd_card_dat3, --           .b_SD_dat3
			sd_card_ip_o_SD_clock                 => o_de4_sd_card_clock, --           .o_SD_clock

			rs232_uart_rxd                        => i_de4_rs232_uart_rxd, -- rs232_uart.rxd
			rs232_uart_txd                        => o_de4_rs232_uart_txd --           .txd

		);

	--==========--
	-- rst
	--==========--

	rst <= i_de4_cpu_reset_n AND i_painel_reset_n;

	--==========--
	-- I/Os
	--==========--    
	-- Routing sync i/o´s - test
	o_painel_sync_out  <= s_sync_out;
	o_de4_sync_out_tst <= s_sync_out;
	-- Observe that i_painel_sync_in is at high level state when there is no excitation input
	-- For test purposes, don´t use isolator board.
	s_sync_in          <= i_painel_sync_in and i_de4_sync_in_tst;

	-- Ativa ventoinha
	o_de4_fan_ctrl <= '1';

	-- LEDs assumem estado diferente no rst.

	o_de4_led(0) <= ('1') when (rst = '0') else (leds_b(0));
	o_de4_led(1) <= ('1') when (rst = '0') else (leds_b(1));
	o_de4_led(2) <= ('1') when (rst = '0') else (leds_b(2));
	o_de4_led(3) <= ('1') when (rst = '0') else (leds_b(3));
	o_de4_led(4) <= ('1') when (rst = '0') else (leds_b(4));
	o_de4_led(5) <= ('1') when (rst = '0') else (leds_b(5));
	o_de4_led(6) <= ('1') when (rst = '0') else (leds_b(6));
	o_de4_led(7) <= ('1') when (rst = '0') else (leds_b(7));

	o_painel_led_chA_green <= ('1') when (rst = '0') else (leds_p(0));
	o_painel_led_chA_red   <= ('1') when (rst = '0') else (leds_p(1));
	o_painel_led_chB_green <= ('1') when (rst = '0') else (leds_p(2));
	o_painel_led_chB_red   <= ('1') when (rst = '0') else (leds_p(3));
	o_painel_led_chC_green <= ('1') when (rst = '0') else (leds_p(4));
	o_painel_led_chC_red   <= ('1') when (rst = '0') else (leds_p(5));
	o_painel_led_chD_green <= ('1') when (rst = '0') else (leds_p(6));
	o_painel_led_chD_red   <= ('1') when (rst = '0') else (leds_p(7));
	o_painel_led_chE_green <= ('1') when (rst = '0') else (leds_p(8));
	o_painel_led_chE_red   <= ('1') when (rst = '0') else (leds_p(9));
	o_painel_led_chF_green <= ('1') when (rst = '0') else (leds_p(10));
	o_painel_led_chF_red   <= ('1') when (rst = '0') else (leds_p(11));
	o_painel_led_chG_green <= ('1') when (rst = '0') else (leds_p(12));
	o_painel_led_chG_red   <= ('1') when (rst = '0') else (leds_p(13));
	o_painel_led_chH_green <= ('1') when (rst = '0') else (leds_p(14));
	o_painel_led_chH_red   <= ('1') when (rst = '0') else (leds_p(15));
	o_painel_led_power     <= ('1') when (rst = '0') else (leds_p(16));
	o_painel_led_st1       <= ('1') when (rst = '0') else (leds_p(17));
	o_painel_led_st2       <= ('1') when (rst = '0') else (leds_p(18));
	o_painel_led_st3       <= ('1') when (rst = '0') else (leds_p(19));
	o_painel_led_st4       <= ('1') when (rst = '0') else (leds_p(20));

	--==========--
	-- Flash
	--==========--

	o_de4_flash_reset_n <= rst;
	o_de4_flash_clk     <= '0';
	o_de4_flash_adv_n   <= '0';

	--==========--
	-- LVDS Drivers control
	--==========--

	-- Comando foi passado para modulo ctrl_io_lvds, via Qsys/Nios
	--	o_hsmb_buffer_pwdn_n	<= '1';
	--	o_hsmb_buffer_pem0	<= '0';
	--	o_hsmb_buffer_pem1	<= '0';
	--	o_iso_en_drivers		<= '0';

	o_iso_en_drivers     <= ctrl_io_lvds(3);
	o_hsmb_buffer_pwdn_n <= ctrl_io_lvds(2);
	o_hsmb_buffer_pem1   <= ctrl_io_lvds(1);
	o_hsmb_buffer_pem0   <= ctrl_io_lvds(0);

	--==========--
	-- LVDS
	--==========--

	--SpW A
	TX_DO_A : TX_LVDS
		port map(
			tx_in  => spw_a_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwa_do_p(0 downto 0)
		);
	TX_DI_A : RX_LVDS
		port map(
			rx_out => spw_a_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwa_di_p(0 downto 0)
		);
	TX_SO_A : TX_LVDS
		port map(
			tx_in  => spw_a_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwa_so_p(0 downto 0)
		);
	TX_SI_A : RX_LVDS
		port map(
			rx_out => spw_a_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwa_si_p(0 downto 0)
		);

	--SpW B
	TX_DO_B : TX_LVDS
		port map(
			tx_in  => spw_b_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwb_do_p(0 downto 0)
		);
	TX_DI_B : RX_LVDS
		port map(
			rx_out => spw_b_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwb_di_p(0 downto 0)
		);
	TX_SO_B : TX_LVDS
		port map(
			tx_in  => spw_b_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwb_so_p(0 downto 0)
		);
	TX_SI_B : RX_LVDS
		port map(
			rx_out => spw_b_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwb_si_p(0 downto 0)
		);

	--SpW C
	TX_DO_C : TX_LVDS
		port map(
			tx_in  => spw_c_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwc_do_p(0 downto 0)
		);
	TX_DI_C : RX_LVDS
		port map(
			rx_out => spw_c_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwc_di_p(0 downto 0)
		);
	TX_SO_C : TX_LVDS
		port map(
			tx_in  => spw_c_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwc_so_p(0 downto 0)
		);
	TX_SI_C : RX_LVDS
		port map(
			rx_out => spw_c_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwc_si_p(0 downto 0)
		);

	--SpW D
	TX_DO_D : TX_LVDS
		port map(
			tx_in  => spw_d_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwd_do_p(0 downto 0)
		);
	TX_DI_D : RX_LVDS
		port map(
			rx_out => spw_d_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwd_di_p(0 downto 0)
		);
	TX_SO_D : TX_LVDS
		port map(
			tx_in  => spw_d_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwd_so_p(0 downto 0)
		);
	TX_SI_D : RX_LVDS
		port map(
			rx_out => spw_d_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwd_si_p(0 downto 0)
		);

	--SpW E
	TX_DO_E : TX_LVDS
		port map(
			tx_in  => spw_e_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwe_do_p(0 downto 0)
		);
	TX_DI_E : RX_LVDS
		port map(
			rx_out => spw_e_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwe_di_p(0 downto 0)
		);
	TX_SO_E : TX_LVDS
		port map(
			tx_in  => spw_e_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwe_so_p(0 downto 0)
		);
	TX_SI_E : RX_LVDS
		port map(
			rx_out => spw_e_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwe_si_p(0 downto 0)
		);

	--SpW F
	TX_DO_F : TX_LVDS
		port map(
			tx_in  => spw_f_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwf_do_p(0 downto 0)
		);
	TX_DI_F : RX_LVDS
		port map(
			rx_out => spw_f_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwf_di_p(0 downto 0)
		);
	TX_SO_F : TX_LVDS
		port map(
			tx_in  => spw_f_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwf_so_p(0 downto 0)
		);
	TX_SI_F : RX_LVDS
		port map(
			rx_out => spw_f_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwf_si_p(0 downto 0)
		);

	--SpW G
	TX_DO_G : TX_LVDS
		port map(
			tx_in  => spw_g_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwg_do_p(0 downto 0)
		);
	TX_DI_G : RX_LVDS
		port map(
			rx_out => spw_g_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwg_di_p(0 downto 0)
		);
	TX_SO_G : TX_LVDS
		port map(
			tx_in  => spw_g_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwg_so_p(0 downto 0)
		);
	TX_SI_G : RX_LVDS
		port map(
			rx_out => spw_g_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwg_si_p(0 downto 0)
		);

	--SpW H
	TX_DO_H : TX_LVDS
		port map(
			tx_in  => spw_h_do(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwh_do_p(0 downto 0)
		);
	TX_DI_H : RX_LVDS
		port map(
			rx_out => spw_h_di(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwh_di_p(0 downto 0)
		);
	TX_SO_H : TX_LVDS
		port map(
			tx_in  => spw_h_so(0 downto 0),
			tx_out => o_hsmb_lvds_tx_spwh_so_p(0 downto 0)
		);
	TX_SI_H : RX_LVDS
		port map(
			rx_out => spw_h_si(0 downto 0),
			rx_in  => i_hsmb_lvds_rx_spwh_si_p(0 downto 0)
		);

end bhv;
