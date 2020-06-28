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
use work.spwc_leds_controller_pkg.all;

entity spwc_spacewire_channel_top is
	port(
		reset_i                       : in  std_logic                    := '0'; --          --                    reset_sink.reset
		clk_100_i                     : in  std_logic                    := '0'; --          --             clock_sink_100mhz.clk
		clk_200_i                     : in  std_logic                    := '0'; --          --             clock_sink_200mhz.clk
		spw_data_in_i                 : in  std_logic                    := '0'; --          --    conduit_end_spacewire_lvds.spw_data_in_signal
		spw_strobe_in_i               : in  std_logic                    := '0'; --          --                              .spw_strobe_in_signal
		spw_data_out_o                : out std_logic; --                                    --                              .spw_data_out_signal
		spw_strobe_out_o              : out std_logic; --                                    --                              .spw_strobe_out_signal
		spw_red_status_led_o          : out std_logic; --                                    --    conduit_end_spacewire_leds.spw_red_status_led_signal
		spw_green_status_led_o        : out std_logic; --                                    --                              .spw_green_status_led_signal
		spw_link_command_autostart_i  : in  std_logic                    := '0'; --          -- conduit_end_spacewire_channel.spw_link_command_autostart_signal
		spw_link_command_linkstart_i  : in  std_logic                    := '0'; --          --                              .spw_link_command_linkstart_signal
		spw_link_command_linkdis_i    : in  std_logic                    := '0'; --          --                              .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                              .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_i     : in  std_logic                    := '0'; --          --                              .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                              .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                              .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_i  : in  std_logic                    := '0'; --          --                              .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_i : in  std_logic                    := '0'; --          --                              .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_i  : in  std_logic                    := '0'; --          --                              .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                              .spw_data_tx_command_txdata_signal
		spw_link_status_started_o     : out std_logic; --                                    --                              .spw_link_status_started_signal
		spw_link_status_connecting_o  : out std_logic; --                                    --                              .spw_link_status_connecting_signal
		spw_link_status_running_o     : out std_logic; --                                    --                              .spw_link_status_running_signal
		spw_link_error_errdisc_o      : out std_logic; --                                    --                              .spw_link_error_errdisc_signal
		spw_link_error_errpar_o       : out std_logic; --                                    --                              .spw_link_error_errpar_signal
		spw_link_error_erresc_o       : out std_logic; --                                    --                              .spw_link_error_erresc_signal
		spw_link_error_errcred_o      : out std_logic; --                                    --                              .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_o    : out std_logic; --                                    --                              .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_o    : out std_logic_vector(1 downto 0); --                 --                              .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_o    : out std_logic_vector(5 downto 0); --                 --                              .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_o  : out std_logic; --                                    --                              .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_o  : out std_logic; --                                    --                              .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_o   : out std_logic; --                                    --                              .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_o   : out std_logic_vector(7 downto 0); --                 --                              .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_o    : out std_logic; --                                    --                              .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_o  : out std_logic ---                                    --                              .spw_data_tx_status_txhalff_signal
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

	-- SpaceWirew Codec Clock Synchronization Signals (200 MHz)
	signal s_spw_codec_link_command_clk200    : t_spwc_codec_link_command;
	signal s_spw_codec_link_status_clk200     : t_spwc_codec_link_status;
	signal s_spw_codec_link_error_clk200      : t_spwc_codec_link_error;
	signal s_spw_codec_timecode_rx_clk200     : t_spwc_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_clk200  : t_spwc_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_clk200  : t_spwc_codec_data_tx_status;
	signal s_spw_codec_timecode_tx_clk200     : t_spwc_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_clk200 : t_spwc_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_clk200 : t_spwc_codec_data_tx_command;

begin

	-- Entities Instantiation --

	-- SpaceWire Codec Clock Domain Synchronization Instantiation
	spwc_clk_synchronization_ent_inst : entity work.spwc_clk_synchronization_ent
		port map(
			clk_100_i                                  => a_avs_clock,
			clk_200_i                                  => a_spw_clock,
			rst_i                                      => a_reset,
			spw_codec_link_command_clk100_i.autostart  => spw_link_command_autostart_i,
			spw_codec_link_command_clk100_i.linkstart  => spw_link_command_linkstart_i,
			spw_codec_link_command_clk100_i.linkdis    => spw_link_command_linkdis_i,
			spw_codec_link_command_clk100_i.txdivcnt   => spw_link_command_txdivcnt_i,
			spw_codec_timecode_tx_clk100_i.tick_in     => spw_timecode_tx_tick_in_i,
			spw_codec_timecode_tx_clk100_i.ctrl_in     => spw_timecode_tx_ctrl_in_i,
			spw_codec_timecode_tx_clk100_i.time_in     => spw_timecode_tx_time_in_i,
			spw_codec_data_rx_command_clk100_i.rxread  => spw_data_rx_command_rxread_i,
			spw_codec_data_tx_command_clk100_i.txwrite => spw_data_tx_command_txwrite_i,
			spw_codec_data_tx_command_clk100_i.txflag  => spw_data_tx_command_txflag_i,
			spw_codec_data_tx_command_clk100_i.txdata  => spw_data_tx_command_txdata_i,
			spw_codec_link_status_clk200_i             => s_spw_codec_link_status_clk200,
			spw_codec_link_error_clk200_i              => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_clk200_i             => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_clk200_i          => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_clk200_i          => s_spw_codec_data_tx_status_clk200,
			spw_codec_link_status_clk100_o.started     => spw_link_status_started_o,
			spw_codec_link_status_clk100_o.connecting  => spw_link_status_connecting_o,
			spw_codec_link_status_clk100_o.running     => spw_link_status_running_o,
			spw_codec_link_error_clk100_o.errdisc      => spw_link_error_errdisc_o,
			spw_codec_link_error_clk100_o.errpar       => spw_link_error_errpar_o,
			spw_codec_link_error_clk100_o.erresc       => spw_link_error_erresc_o,
			spw_codec_link_error_clk100_o.errcred      => spw_link_error_errcred_o,
			spw_codec_timecode_rx_clk100_o.tick_out    => spw_timecode_rx_tick_out_o,
			spw_codec_timecode_rx_clk100_o.ctrl_out    => spw_timecode_rx_ctrl_out_o,
			spw_codec_timecode_rx_clk100_o.time_out    => spw_timecode_rx_time_out_o,
			spw_codec_data_rx_status_clk100_o.rxvalid  => spw_data_rx_status_rxvalid_o,
			spw_codec_data_rx_status_clk100_o.rxhalff  => spw_data_rx_status_rxhalff_o,
			spw_codec_data_rx_status_clk100_o.rxflag   => spw_data_rx_status_rxflag_o,
			spw_codec_data_rx_status_clk100_o.rxdata   => spw_data_rx_status_rxdata_o,
			spw_codec_data_tx_status_clk100_o.txrdy    => spw_data_tx_status_txrdy_o,
			spw_codec_data_tx_status_clk100_o.txhalff  => spw_data_tx_status_txhalff_o,
			spw_codec_link_command_clk200_o            => s_spw_codec_link_command_clk200,
			spw_codec_timecode_tx_clk200_o             => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_clk200_o         => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_clk200_o         => s_spw_codec_data_tx_command_clk200
		);

	-- SpaceWire Codec Instantiation 
	spwc_codec_ent_inst : entity work.spwc_codec_ent
		port map(
			clk_200_i                         => a_spw_clock,
			rst_i                             => a_reset,
			spw_codec_link_command_i          => s_spw_codec_link_command_clk200,
			spw_codec_ds_encoding_rx_i.spw_di => spw_data_in_i,
			spw_codec_ds_encoding_rx_i.spw_si => spw_strobe_in_i,
			spw_codec_timecode_tx_i           => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_i       => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_i       => s_spw_codec_data_tx_command_clk200,
			spw_codec_link_status_o           => s_spw_codec_link_status_clk200,
			spw_codec_ds_encoding_tx_o.spw_do => spw_data_out_o,
			spw_codec_ds_encoding_tx_o.spw_so => spw_strobe_out_o,
			spw_codec_link_error_o            => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_o           => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_o        => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_o        => s_spw_codec_data_tx_status_clk200
		);

	-- SpaceWire LEDs Controller Instantiation
	spwc_spw_leds_controller_ent_inst : entity work.spwc_spw_leds_controller_ent
		port map(
			clk_i                                         => a_spw_clock,
			rst_i                                         => a_reset,
			leds_channel_status_i.link_status_running     => s_spw_codec_link_status_clk200.running,
			leds_channel_status_i.data_rx_command_rxread  => s_spw_codec_data_rx_command_clk200.rxread,
			leds_channel_status_i.data_tx_command_txwrite => s_spw_codec_data_tx_command_clk200.txwrite,
			leds_control_o.red_status_led                 => spw_red_status_led_o,
			leds_control_o.green_status_led               => spw_green_status_led_o
		);

		-- Signals Assignments --

end architecture rtl;                   -- of spwc_spacewire_channel_top
