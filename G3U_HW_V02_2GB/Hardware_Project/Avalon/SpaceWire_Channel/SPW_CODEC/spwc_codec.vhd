library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;

entity spwc_codec_ent is
	port(
		clk_200_i                   : in  std_logic;
		rst_i                       : in  std_logic;
		spw_codec_link_command_i    : in  t_spwc_codec_link_command;
		spw_codec_ds_encoding_rx_i  : in  t_spwc_codec_ds_encoding_rx;
		spw_codec_timecode_tx_i     : in  t_spwc_codec_timecode_tx;
		spw_codec_data_rx_command_i : in  t_spwc_codec_data_rx_command;
		spw_codec_data_tx_command_i : in  t_spwc_codec_data_tx_command;
		spw_codec_link_status_o     : out t_spwc_codec_link_status;
		spw_codec_ds_encoding_tx_o  : out t_spwc_codec_ds_encoding_tx;
		spw_codec_link_error_o      : out t_spwc_codec_link_error;
		spw_codec_timecode_rx_o     : out t_spwc_codec_timecode_rx;
		spw_codec_data_rx_status_o  : out t_spwc_codec_data_rx_status;
		spw_codec_data_tx_status_o  : out t_spwc_codec_data_tx_status
	);
end entity spwc_codec_ent;

architecture rtl of spwc_codec_ent is

begin

	-- SpaceWire Light Codec Component 
	spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => c_SPWC_SYSFREQ,
			txclkfreq       => c_SPWC_TXCLKFREQ,
			rximpl          => c_SPWC_RXIMPL,
			rxchunk         => c_SPWC_RXCHUNK,
			tximpl          => c_SPWC_TXIMPL,
			rxfifosize_bits => c_SPWC_RXFIFOSIZE_BITS,
			txfifosize_bits => c_SPWC_TXFIFOSIZE_BITS
		)
		port map(
			clk        => clk_200_i,
			rxclk      => clk_200_i,
			txclk      => clk_200_i,
			rst        => rst_i,
			autostart  => spw_codec_link_command_i.autostart,
			linkstart  => spw_codec_link_command_i.linkstart,
			linkdis    => spw_codec_link_command_i.linkdis,
			--			txdivcnt   => c_SPWC_TXDIVCNT,
			txdivcnt   => spw_codec_link_command_i.txdivcnt,
			tick_in    => spw_codec_timecode_tx_i.tick_in,
			ctrl_in    => spw_codec_timecode_tx_i.ctrl_in,
			time_in    => spw_codec_timecode_tx_i.time_in,
			txwrite    => spw_codec_data_tx_command_i.txwrite,
			txflag     => spw_codec_data_tx_command_i.txflag,
			txdata     => spw_codec_data_tx_command_i.txdata,
			txrdy      => spw_codec_data_tx_status_o.txrdy,
			txhalff    => spw_codec_data_tx_status_o.txhalff,
			tick_out   => spw_codec_timecode_rx_o.tick_out,
			ctrl_out   => spw_codec_timecode_rx_o.ctrl_out,
			time_out   => spw_codec_timecode_rx_o.time_out,
			rxvalid    => spw_codec_data_rx_status_o.rxvalid,
			rxhalff    => spw_codec_data_rx_status_o.rxhalff,
			rxflag     => spw_codec_data_rx_status_o.rxflag,
			rxdata     => spw_codec_data_rx_status_o.rxdata,
			rxread     => spw_codec_data_rx_command_i.rxread,
			started    => spw_codec_link_status_o.started,
			connecting => spw_codec_link_status_o.connecting,
			running    => spw_codec_link_status_o.running,
			errdisc    => spw_codec_link_error_o.errdisc,
			errpar     => spw_codec_link_error_o.errpar,
			erresc     => spw_codec_link_error_o.erresc,
			errcred    => spw_codec_link_error_o.errcred,
			spw_di     => spw_codec_ds_encoding_rx_i.spw_di,
			spw_si     => spw_codec_ds_encoding_rx_i.spw_si,
			spw_do     => spw_codec_ds_encoding_tx_o.spw_do,
			spw_so     => spw_codec_ds_encoding_tx_o.spw_so
		);

end architecture rtl;

