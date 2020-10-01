-- spwc_spacewire_channel_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.spwc_codec_pkg.all;
use work.spwc_errinj_pkg.all;
use work.spwc_leds_controller_pkg.all;

entity spwc_spacewire_channel_top is
	generic(
		g_SPWC_TESTBENCH_MODE : std_logic := '0'
	);
	port(
		reset_i                        : in  std_logic                    := '0'; --          --                    reset_sink.reset
		clk_100_i                      : in  std_logic                    := '0'; --          --             clock_sink_100mhz.clk
		clk_200_i                      : in  std_logic                    := '0'; --          --             clock_sink_200mhz.clk
		spw_lvds_p_data_in_i           : in  std_logic                    := '0'; --          --    conduit_end_spacewire_lvds.spw_lvds_p_data_in_signal
		spw_lvds_n_data_in_i           : in  std_logic                    := '0'; --          --                              .spw_lvds_n_data_in_signal		
		spw_lvds_p_strobe_in_i         : in  std_logic                    := '0'; --          --                              .spw_lvds_p_strobe_in_signal
		spw_lvds_n_strobe_in_i         : in  std_logic                    := '0'; --          --                              .spw_lvds_n_strobe_in_signal		
		spw_lvds_p_data_out_o          : out std_logic; --                                    --                              .spw_lvds_p_data_out_signal
		spw_lvds_n_data_out_o          : out std_logic; --                                    --                              .spw_lvds_n_data_out_signal		
		spw_lvds_p_strobe_out_o        : out std_logic; --                                    --                              .spw_lvds_p_strobe_out_signal
		spw_lvds_n_strobe_out_o        : out std_logic; --                                    --                              .spw_lvds_n_strobe_out_signal		
		spw_rx_enable_i                : in  std_logic                    := '0'; --          --  conduit_end_spacewire_enable.spw_rx_enable_signal
		spw_tx_enable_i                : in  std_logic                    := '0'; --          --                              .spw_tx_enable_signal
		spw_red_status_led_o           : out std_logic; --                                    --    conduit_end_spacewire_leds.spw_red_status_led_signal
		spw_green_status_led_o         : out std_logic; --                                    --                              .spw_green_status_led_signal
		spw_link_command_autostart_i   : in  std_logic                    := '0'; --          -- conduit_end_spacewire_channel.spw_link_command_autostart_signal
		spw_link_command_linkstart_i   : in  std_logic                    := '0'; --          --                              .spw_link_command_linkstart_signal
		spw_link_command_linkdis_i     : in  std_logic                    := '0'; --          --                              .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                              .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_i      : in  std_logic                    := '0'; --          --                              .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_i      : in  std_logic_vector(1 downto 0) := (others => '0'); --                              .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_i      : in  std_logic_vector(5 downto 0) := (others => '0'); --                              .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_i   : in  std_logic                    := '0'; --          --                              .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_i  : in  std_logic                    := '0'; --          --                              .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_i   : in  std_logic                    := '0'; --          --                              .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                              .spw_data_tx_command_txdata_signal
		spw_errinj_ctrl_start_errinj_i : in  std_logic                    := '0'; --          --                              .spw_errinj_ctrl_start_errinj_signal
		spw_errinj_ctrl_reset_errinj_i : in  std_logic                    := '0'; --          --                              .spw_errinj_ctrl_reset_errinj_signal
		spw_errinj_ctrl_errinj_code_i  : in  std_logic_vector(3 downto 0) := (others => '0'); --                              .spw_errinj_ctrl_errinj_code_signal
		spw_link_status_started_o      : out std_logic; --                                    --                              .spw_link_status_started_signal
		spw_link_status_connecting_o   : out std_logic; --                                    --                              .spw_link_status_connecting_signal
		spw_link_status_running_o      : out std_logic; --                                    --                              .spw_link_status_running_signal
		spw_link_error_errdisc_o       : out std_logic; --                                    --                              .spw_link_error_errdisc_signal
		spw_link_error_errpar_o        : out std_logic; --                                    --                              .spw_link_error_errpar_signal
		spw_link_error_erresc_o        : out std_logic; --                                    --                              .spw_link_error_erresc_signal
		spw_link_error_errcred_o       : out std_logic; --                                    --                              .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_o     : out std_logic; --                                    --                              .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_o     : out std_logic_vector(1 downto 0); --                 --                              .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_o     : out std_logic_vector(5 downto 0); --                 --                              .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_o   : out std_logic; --                                    --                              .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_o   : out std_logic; --                                    --                              .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_o    : out std_logic; --                                    --                              .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_o    : out std_logic_vector(7 downto 0); --                 --                              .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_o     : out std_logic; --                                    --                              .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_o   : out std_logic; --                                    --                              .spw_data_tx_status_txhalff_signal
		spw_errinj_ctrl_errinj_busy_o  : out std_logic; --                                    --                              .spw_errinj_ctrl_errinj_busy_signal
		spw_errinj_ctrl_errinj_ready_o : out std_logic ---                                    --                              .spw_errinj_ctrl_errinj_ready_signal
	);
end entity spwc_spacewire_channel_top;

architecture rtl of spwc_spacewire_channel_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock is clk_100_i;
	alias a_spw_clock is clk_200_i;
	alias a_reset is reset_i;

	-- Constants --

	-- Signals --

	-- SpaceWire Codec Clock Synchronization Signals (200 MHz)
	signal s_spw_codec_link_command_spw    : t_spwc_codec_link_command;
	signal s_spw_codec_link_status_spw     : t_spwc_codec_link_status;
	signal s_spw_codec_link_error_spw      : t_spwc_codec_link_error;
	signal s_spw_codec_timecode_rx_spw     : t_spwc_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_spw  : t_spwc_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_spw  : t_spwc_codec_data_tx_status;
	signal s_spw_codec_err_inj_status_spw  : t_spwc_codec_err_inj_status;
	signal s_spw_codec_timecode_tx_spw     : t_spwc_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_spw : t_spwc_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_spw : t_spwc_codec_data_tx_command;
	signal s_spw_codec_err_inj_command_spw : t_spwc_codec_err_inj_command;

	-- Spacewire Error Injection Controller Signals
	signal s_spw_errinj_controller_control : t_spwc_errinj_controller_control;
	signal s_spw_errinj_controller_status  : t_spwc_errinj_controller_status;

	-- SpaceWire Codec Data-Strobe Signals
	signal s_spw_codec_ds_encoding_rx : t_spwc_codec_ds_encoding_rx;
	signal s_spw_codec_ds_encoding_tx : t_spwc_codec_ds_encoding_tx;

	-- SpaceWire LVDS Data-Strobe Signals
	signal s_spw_logical_data_in    : std_logic;
	signal s_spw_logical_strobe_in  : std_logic;
	signal s_spw_logical_data_out   : std_logic;
	signal s_spw_logical_strobe_out : std_logic;

	-- SpaceWire Leds Controller Signals
	signal s_spw_leds_control : t_spwc_spw_leds_control;

begin

	-- Entities Instantiation --

	-- SpaceWire Codec Clock Domain Synchronization Instantiation
	spwc_clk_synchronization_top_inst : entity work.spwc_clk_synchronization_top
		port map(
			clk_avs_i                                  => a_avs_clock,
			clk_spw_i                                  => a_spw_clock,
			rst_i                                      => a_reset,
			spw_codec_link_command_avs_i.autostart     => spw_link_command_autostart_i,
			spw_codec_link_command_avs_i.linkstart     => spw_link_command_linkstart_i,
			spw_codec_link_command_avs_i.linkdis       => spw_link_command_linkdis_i,
			spw_codec_link_command_avs_i.txdivcnt      => spw_link_command_txdivcnt_i,
			spw_codec_timecode_tx_avs_i.tick_in        => spw_timecode_tx_tick_in_i,
			spw_codec_timecode_tx_avs_i.ctrl_in        => spw_timecode_tx_ctrl_in_i,
			spw_codec_timecode_tx_avs_i.time_in        => spw_timecode_tx_time_in_i,
			spw_codec_data_rx_command_avs_i.rxread     => spw_data_rx_command_rxread_i,
			spw_codec_data_tx_command_avs_i.txwrite    => spw_data_tx_command_txwrite_i,
			spw_codec_data_tx_command_avs_i.txflag     => spw_data_tx_command_txflag_i,
			spw_codec_data_tx_command_avs_i.txdata     => spw_data_tx_command_txdata_i,
			spw_errinj_ctrl_control_avs_i.start_errinj => spw_errinj_ctrl_start_errinj_i,
			spw_errinj_ctrl_control_avs_i.reset_errinj => spw_errinj_ctrl_reset_errinj_i,
			spw_errinj_ctrl_control_avs_i.errinj_code  => spw_errinj_ctrl_errinj_code_i,
			spw_codec_link_status_spw_i                => s_spw_codec_link_status_spw,
			spw_codec_link_error_spw_i                 => s_spw_codec_link_error_spw,
			spw_codec_timecode_rx_spw_i                => s_spw_codec_timecode_rx_spw,
			spw_codec_data_rx_status_spw_i             => s_spw_codec_data_rx_status_spw,
			spw_codec_data_tx_status_spw_i             => s_spw_codec_data_tx_status_spw,
			spw_errinj_ctrl_status_spw_i               => s_spw_errinj_controller_status,
			spw_codec_link_status_avs_o.started        => spw_link_status_started_o,
			spw_codec_link_status_avs_o.connecting     => spw_link_status_connecting_o,
			spw_codec_link_status_avs_o.running        => spw_link_status_running_o,
			spw_codec_link_error_avs_o.errdisc         => spw_link_error_errdisc_o,
			spw_codec_link_error_avs_o.errpar          => spw_link_error_errpar_o,
			spw_codec_link_error_avs_o.erresc          => spw_link_error_erresc_o,
			spw_codec_link_error_avs_o.errcred         => spw_link_error_errcred_o,
			spw_codec_timecode_rx_avs_o.tick_out       => spw_timecode_rx_tick_out_o,
			spw_codec_timecode_rx_avs_o.ctrl_out       => spw_timecode_rx_ctrl_out_o,
			spw_codec_timecode_rx_avs_o.time_out       => spw_timecode_rx_time_out_o,
			spw_codec_data_rx_status_avs_o.rxvalid     => spw_data_rx_status_rxvalid_o,
			spw_codec_data_rx_status_avs_o.rxhalff     => spw_data_rx_status_rxhalff_o,
			spw_codec_data_rx_status_avs_o.rxflag      => spw_data_rx_status_rxflag_o,
			spw_codec_data_rx_status_avs_o.rxdata      => spw_data_rx_status_rxdata_o,
			spw_codec_data_tx_status_avs_o.txrdy       => spw_data_tx_status_txrdy_o,
			spw_codec_data_tx_status_avs_o.txhalff     => spw_data_tx_status_txhalff_o,
			spw_errinj_ctrl_status_avs_o.errinj_busy   => spw_errinj_ctrl_errinj_busy_o,
			spw_errinj_ctrl_status_avs_o.errinj_ready  => spw_errinj_ctrl_errinj_ready_o,
			spw_codec_link_command_spw_o               => s_spw_codec_link_command_spw,
			spw_codec_timecode_tx_spw_o                => s_spw_codec_timecode_tx_spw,
			spw_codec_data_rx_command_spw_o            => s_spw_codec_data_rx_command_spw,
			spw_codec_data_tx_command_spw_o            => s_spw_codec_data_tx_command_spw,
			spw_errinj_ctrl_control_spw_o              => s_spw_errinj_controller_control
		);

	-- SpaceWire Error Injection Controller Instantiation
	spwc_errinj_controller_ent_inst : entity work.spwc_errinj_controller_ent
		port map(
			clk_i                       => a_spw_clock,
			rst_i                       => a_reset,
			errinj_controller_control_i => s_spw_errinj_controller_control,
			spw_codec_link_status_i     => s_spw_codec_link_status_spw,
			spw_codec_err_inj_status_i  => s_spw_codec_err_inj_status_spw,
			errinj_controller_status_o  => s_spw_errinj_controller_status,
			spw_codec_err_inj_command_o => s_spw_codec_err_inj_command_spw
		);

	-- SpaceWire Codec Instantiation 
	spwc_codec_ent_inst : entity work.spwc_codec_ent
		port map(
			clk_spw_i                   => a_spw_clock,
			rst_i                       => a_reset,
			spw_codec_link_command_i    => s_spw_codec_link_command_spw,
			spw_codec_ds_encoding_rx_i  => s_spw_codec_ds_encoding_rx,
			spw_codec_timecode_tx_i     => s_spw_codec_timecode_tx_spw,
			spw_codec_data_rx_command_i => s_spw_codec_data_rx_command_spw,
			spw_codec_data_tx_command_i => s_spw_codec_data_tx_command_spw,
			spw_codec_err_inj_command_i => s_spw_codec_err_inj_command_spw,
			spw_codec_link_status_o     => s_spw_codec_link_status_spw,
			spw_codec_ds_encoding_tx_o  => s_spw_codec_ds_encoding_tx,
			spw_codec_link_error_o      => s_spw_codec_link_error_spw,
			spw_codec_timecode_rx_o     => s_spw_codec_timecode_rx_spw,
			spw_codec_data_rx_status_o  => s_spw_codec_data_rx_status_spw,
			spw_codec_data_tx_status_o  => s_spw_codec_data_tx_status_spw,
			spw_codec_err_inj_status_o  => s_spw_codec_err_inj_status_spw
		);

	-- SpaceWire Data-Strobe Testbench Generate
	g_spwc_ds_testbench : if (g_SPWC_TESTBENCH_MODE = '1') generate

		s_spw_logical_data_in   <= spw_lvds_p_data_in_i;
		s_spw_logical_strobe_in <= spw_lvds_p_strobe_in_i;
		spw_lvds_p_data_out_o   <= s_spw_logical_data_out;
		spw_lvds_p_strobe_out_o <= s_spw_logical_strobe_out;
		spw_lvds_n_data_out_o   <= '0';
		spw_lvds_n_strobe_out_o <= '0';

	end generate g_spwc_ds_testbench;

	-- SpaceWire Data-Strobe ALTIOBUF Generate
	g_spwc_ds_altiobuff : if (g_SPWC_TESTBENCH_MODE = '0') generate

		-- SpaceWire Data-Strobe Rx Diferential Inputs ALTIOBUF Instantiation
		spwc_spw_rx_altiobuf_inst : entity work.spwc_spw_rx_altiobuf
			port map(
				datain(0)   => spw_lvds_p_data_in_i,
				datain(1)   => spw_lvds_p_strobe_in_i,
				datain_b(0) => spw_lvds_n_data_in_i,
				datain_b(1) => spw_lvds_n_strobe_in_i,
				dataout(0)  => s_spw_logical_data_in,
				dataout(1)  => s_spw_logical_strobe_in
			);

		-- SpaceWire Data-Strobe Tx Diferential Outputs ALTIOBUF Instantiation
		spwc_spw_tx_altiobuf_inst : entity work.spwc_spw_tx_altiobuf
			port map(
				datain(0)    => s_spw_logical_data_out,
				datain(1)    => s_spw_logical_strobe_out,
				dataout(0)   => spw_lvds_p_data_out_o,
				dataout(1)   => spw_lvds_p_strobe_out_o,
				dataout_b(0) => spw_lvds_n_data_out_o,
				dataout_b(1) => spw_lvds_n_strobe_out_o
			);

	end generate g_spwc_ds_altiobuff;

	-- SpaceWire LEDs Controller Instantiation
	spwc_leds_controller_ent_inst : entity work.spwc_leds_controller_ent
		port map(
			clk_i                                         => a_spw_clock,
			rst_i                                         => a_reset,
			leds_channel_status_i.link_status_running     => s_spw_codec_link_status_spw.running,
			leds_channel_status_i.data_rx_command_rxread  => s_spw_codec_data_rx_command_spw.rxread,
			leds_channel_status_i.data_tx_command_txwrite => s_spw_codec_data_tx_command_spw.txwrite,
			leds_control_o                                => s_spw_leds_control
		);

	-- SpaceWire LEDs Outputs ALTIOBUF Instantiation
	spwc_leds_out_altiobuf_inst : entity work.spwc_leds_out_altiobuf
		port map(
			datain(1)  => s_spw_leds_control.red_status_led,
			datain(0)  => s_spw_leds_control.green_status_led,
			dataout(1) => spw_red_status_led_o,
			dataout(0) => spw_green_status_led_o
		);

	-- Signals Assignments --

	-- Spacewire Data-Strobe Input Signals Assignments
	s_spw_codec_ds_encoding_rx.spw_di <= ('0') when (a_reset = '1')
	                                     else (s_spw_logical_data_in) when (spw_rx_enable_i = '1')
	                                     else ('0');
	s_spw_codec_ds_encoding_rx.spw_si <= ('0') when (a_reset = '1')
	                                     else (s_spw_logical_strobe_in) when (spw_rx_enable_i = '1')
	                                     else ('0');

	-- Spacewire Data-Strobe Output Signals Assignments
	s_spw_logical_data_out   <= ('0') when (a_reset = '1')
	                            else (s_spw_codec_ds_encoding_tx.spw_do) when (spw_tx_enable_i = '1')
	                            else ('0');
	s_spw_logical_strobe_out <= ('0') when (a_reset = '1')
	                            else (s_spw_codec_ds_encoding_tx.spw_so) when (spw_tx_enable_i = '1')
	                            else ('0');

end architecture rtl;                   -- of spwc_spacewire_channel_top
