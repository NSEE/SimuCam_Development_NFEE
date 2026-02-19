library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;

entity spwc_codec_ent is
	port(
		clk_200                       : in  std_logic;
		rst                           : in  std_logic;
		spwc_codec_link_command_in    : in  spwc_codec_link_command_in_type;
		spwc_codec_link_status_out    : out spwc_codec_link_status_out_type;
		spwc_codec_ds_encoding_rx_in  : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_out : out spwc_codec_ds_encoding_tx_out_type;
		spwc_codec_link_error_out     : out spwc_codec_link_error_out_type;
		spwc_codec_timecode_rx_out    : out spwc_codec_timecode_rx_out_type;
		spwc_codec_timecode_tx_in     : in  spwc_codec_timecode_tx_in_type;
		spwc_codec_data_rx_in         : in  spwc_codec_data_rx_in_type;
		spwc_codec_data_rx_out        : out spwc_codec_data_rx_out_type;
		spwc_codec_data_tx_in         : in  spwc_codec_data_tx_in_type;
		spwc_codec_data_tx_out        : out spwc_codec_data_tx_out_type
	);
end entity spwc_codec_ent;

architecture spwc_codec_arc of spwc_codec_ent is

begin

	-- SpaceWire Light Codec Component 
	spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => SPWC_SYSFREQ,
			txclkfreq       => SPWC_TXCLKFREQ,
			rximpl          => SPWC_RXIMPL,
			rxchunk         => SPWC_RXCHUNK,
			tximpl          => SPWC_TXIMPL,
			rxfifosize_bits => SPWC_RXFIFOSIZE_BITS,
			txfifosize_bits => SPWC_TXFIFOSIZE_BITS
		)
		port map(
			clk        => clk_200,
			rxclk      => clk_200,
			txclk      => clk_200,
			rst        => rst,
			autostart  => spwc_codec_link_command_in.autostart,
			linkstart  => spwc_codec_link_command_in.linkstart,
			linkdis    => spwc_codec_link_command_in.linkdis,
			--txdivcnt   => SPWC_TXDIVCNT,
			txdivcnt   => spwc_codec_link_command_in.txdivcnt,
			tick_in    => spwc_codec_timecode_tx_in.tick_in,
			ctrl_in    => spwc_codec_timecode_tx_in.ctrl_in,
			time_in    => spwc_codec_timecode_tx_in.time_in,
			txwrite    => spwc_codec_data_tx_in.txwrite,
			txflag     => spwc_codec_data_tx_in.txflag,
			txdata     => spwc_codec_data_tx_in.txdata,
			txrdy      => spwc_codec_data_tx_out.txrdy,
			txhalff    => spwc_codec_data_tx_out.txhalff,
			tick_out   => spwc_codec_timecode_rx_out.tick_out,
			ctrl_out   => spwc_codec_timecode_rx_out.ctrl_out,
			time_out   => spwc_codec_timecode_rx_out.time_out,
			rxvalid    => spwc_codec_data_rx_out.rxvalid,
			rxhalff    => spwc_codec_data_rx_out.rxhalff,
			rxflag     => spwc_codec_data_rx_out.rxflag,
			rxdata     => spwc_codec_data_rx_out.rxdata,
			rxread     => spwc_codec_data_rx_in.rxread,
			started    => spwc_codec_link_status_out.started,
			connecting => spwc_codec_link_status_out.connecting,
			running    => spwc_codec_link_status_out.running,
			errdisc    => spwc_codec_link_error_out.errdisc,
			errpar     => spwc_codec_link_error_out.errpar,
			erresc     => spwc_codec_link_error_out.erresc,
			errcred    => spwc_codec_link_error_out.errcred,
			spw_di     => spwc_codec_ds_encoding_rx_in.spw_di,
			spw_si     => spwc_codec_ds_encoding_rx_in.spw_si,
			spw_do     => spwc_codec_ds_encoding_tx_out.spw_do,
			spw_so     => spwc_codec_ds_encoding_tx_out.spw_so
		);

end architecture spwc_codec_arc;

