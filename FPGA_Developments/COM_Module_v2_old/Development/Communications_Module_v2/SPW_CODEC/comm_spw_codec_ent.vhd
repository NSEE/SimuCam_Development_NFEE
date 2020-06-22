library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_spw_codec_ent is
	port(
		-- basic inputs
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		-- registers input
		-- logic inputs
		spw_codec_spw_ds_rx_i      : in  t_spwl_ds_encoding;
		spw_codec_spw_control_rx_i : in  t_spwl_data_rx_control;
		spw_codec_spw_control_tx_i : in  t_spwl_data_tx_control;
		spw_codec_spw_payload_tx_i : in  t_spwl_data_payload;
		-- registers output
		-- logic outputs
		spw_codec_spw_ds_tx_o      : out t_spwl_ds_encoding;
		spw_codec_spw_status_rx_o  : out t_spwl_data_rx_status;
		spw_codec_spw_payload_rx_o : out t_spwl_data_payload;
		spw_codec_spw_status_tx_o  : out t_spwl_data_tx_status
	);
end entity comm_spw_codec_ent;

use work.comm_spw_codec_pkg.all;

architecture RTL of comm_spw_codec_ent is

	-- spw codec spacewire light signals
	signal s_spwl_link_config         : t_spwl_link_config;
	signal s_spwl_link_status         : t_spwl_link_status;
	signal s_spwl_link_error          : t_spwl_link_error;
	signal s_spwl_timecode_rx_status  : t_spwl_timecode_rx_status;
	signal s_spwl_timecode_rx_payload : t_spwl_timecode_payload;
	signal s_spwl_timecode_tx_control : t_spwl_timecode_tx_control;
	signal s_spwl_timecode_tx_payload : t_spwl_timecode_payload;

	-- spw codec internal loopback signals
	signal s_swil_control     : t_swil_control;
	signal s_swil_codec_ds_tx : t_spwl_ds_encoding;
	signal s_swil_codec_ds_rx : t_spwl_ds_encoding;
	signal s_swil_spw_ds_rx   : t_spwl_ds_encoding;
	signal s_swil_spw_ds_tx   : t_spwl_ds_encoding;

	-- spw codec external loopback signals
	signal s_swel_control          : t_swel_control;
	signal s_swel_codec_control_rx : t_spwl_data_rx_control;
	signal s_swel_codec_status_rx  : t_spwl_data_rx_status;
	signal s_swel_codec_payload_rx : t_spwl_data_payload;
	signal s_swel_codec_control_tx : t_spwl_data_tx_control;
	signal s_swel_codec_status_tx  : t_spwl_data_tx_status;
	signal s_swel_codec_payload_tx : t_spwl_data_payload;
	signal s_swel_spw_control_rx   : t_spwl_data_rx_control;
	signal s_swel_spw_status_rx    : t_spwl_data_rx_status;
	signal s_swel_spw_payload_rx   : t_spwl_data_payload;
	signal s_swel_spw_status_tx    : t_spwl_data_tx_status;
	signal s_swel_spw_control_tx   : t_spwl_data_tx_control;
	signal s_swel_spw_payload_tx   : t_spwl_data_payload;

begin

	-- spw codec registers
	comm_spw_codec_registers_ent_inst : entity work.comm_spw_codec_registers_ent
		port map(
			clk_i                      => clk_i,
			rst_i                      => rst_i,
			spwl_link_status_i         => s_spwl_link_status,
			spwl_link_error_i          => s_spwl_link_error,
			spwl_timecode_rx_status_i  => s_spwl_timecode_rx_status,
			spwl_timecode_rx_payload_i => s_spwl_timecode_rx_payload,
			spwl_link_config_o         => s_spwl_link_config,
			spwl_timecode_tx_control_o => s_spwl_timecode_tx_control,
			spwl_timecode_tx_payload_o => s_spwl_timecode_tx_payload,
			swil_control_o             => s_swil_control,
			swel_control_o             => s_swel_control
		);

	-- spw codec external loopback
	comm_spw_codec_extenal_loopback_ent_inst : entity work.comm_spw_codec_extenal_loopback_ent
		port map(
			clk_i              => clk_i,
			rst_i              => rst_i,
			control_i          => s_swel_control,
			codec_status_rx_i  => s_swel_codec_status_rx,
			codec_payload_rx_i => s_swel_codec_payload_rx,
			codec_status_tx_i  => s_swel_codec_status_tx,
			spw_control_rx_i   => s_swel_spw_control_rx,
			spw_control_tx_i   => s_swel_spw_control_tx,
			spw_payload_tx_i   => s_swel_spw_payload_tx,
			codec_control_rx_o => s_swel_codec_control_rx,
			codec_control_tx_o => s_swel_codec_control_tx,
			codec_payload_tx_o => s_swel_codec_payload_tx,
			spw_status_rx_o    => s_swel_spw_status_rx,
			spw_payload_rx_o   => s_swel_spw_payload_rx,
			spw_status_tx_o    => s_swel_spw_status_tx
		);

	-- spw codec spacewire light
	spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => c_SPWL_SYSFREQ,
			txclkfreq       => c_SPWL_TXCLKFREQ,
			rximpl          => c_SPWL_RXIMPL,
			rxchunk         => c_SPWL_RXCHUNK,
			tximpl          => c_SPWL_TXIMPL,
			rxfifosize_bits => c_SPWL_RXFIFOSIZE_BITS,
			txfifosize_bits => c_SPWL_TXFIFOSIZE_BITS
		)
		port map(
			clk        => clk_i,
			rxclk      => clk_i,
			txclk      => clk_i,
			rst        => rst_i,
			autostart  => s_spwl_link_config.autostart,
			linkstart  => s_spwl_link_config.linkstart,
			linkdis    => s_spwl_link_config.linkdis,
			txdivcnt   => s_spwl_link_config.txdivcnt,
			tick_in    => s_spwl_timecode_tx_control.tick_in,
			ctrl_in    => s_spwl_timecode_tx_payload.ctrl,
			time_in    => s_spwl_timecode_tx_payload.time,
			txwrite    => s_swel_codec_control_tx.txwrite,
			txflag     => s_swel_codec_payload_tx.flag,
			txdata     => s_swel_codec_payload_tx.data,
			txrdy      => s_swel_codec_status_tx.txrdy,
			txhalff    => s_swel_codec_status_tx.txhalff,
			tick_out   => s_spwl_timecode_rx_status.tick_out,
			ctrl_out   => s_spwl_timecode_rx_payload.ctrl,
			time_out   => s_spwl_timecode_rx_payload.time,
			rxvalid    => s_swel_codec_status_rx.rxvalid,
			rxhalff    => s_swel_codec_status_rx.rxhalff,
			rxflag     => s_swel_codec_payload_rx.flag,
			rxdata     => s_swel_codec_payload_rx.data,
			rxread     => s_swel_codec_control_rx.rxread,
			started    => s_spwl_link_status.started,
			connecting => s_spwl_link_status.connecting,
			running    => s_spwl_link_status.running,
			errdisc    => s_spwl_link_error.errdisc,
			errpar     => s_spwl_link_error.errpar,
			erresc     => s_spwl_link_error.erresc,
			errcred    => s_spwl_link_error.errcred,
			spw_di     => s_swil_codec_ds_rx.spw_d,
			spw_si     => s_swil_codec_ds_rx.spw_s,
			spw_do     => s_swil_codec_ds_tx.spw_d,
			spw_so     => s_swil_codec_ds_tx.spw_s
		);

	-- spw codec internal loopback
	comm_spw_codec_intenal_loopback_ent_inst : entity work.comm_spw_codec_intenal_loopback_ent
		port map(
			clk_i         => clk_i,
			rst_i         => rst_i,
			control_i     => s_swil_control,
			codec_ds_tx_i => s_swil_codec_ds_tx,
			spw_ds_rx_i   => s_swil_spw_ds_rx,
			codec_ds_rx_o => s_swil_codec_ds_rx,
			spw_ds_tx_o   => s_swil_spw_ds_tx
		);

end architecture RTL;
