library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;

package spwc_codec_pkg is

	constant SPWC_SYSFREQ         : real                    := 200000000.0;
	constant SPWC_TXCLKFREQ       : real                    := 100000000.0;
	constant SPWC_RXIMPL          : spw_implementation_type := impl_generic;
	constant SPWC_RXCHUNK         : integer range 1 to 4    := 1;
	constant SPWC_TXIMPL          : spw_implementation_type := impl_generic;
	constant SPWC_RXFIFOSIZE_BITS : integer range 6 to 14   := 11;
	constant SPWC_TXFIFOSIZE_BITS : integer range 6 to 14   := 11;
	
	constant SPWC_TXDIVCNT : std_logic_vector(7 downto 0) := x"01";
	
	type spwc_codec_link_command_in_type is record
		autostart : std_logic;
		linkstart : std_logic;
		linkdis : std_logic;
	end record spwc_codec_link_command_in_type;
	
	type spwc_codec_link_status_out_type is record
		started : std_logic;
		connecting : std_logic;
		running : std_logic;
	end record spwc_codec_link_status_out_type;
	
	type spwc_codec_ds_encoding_rx_in_type is record
		spw_di : std_logic;
		spw_si : std_logic;
	end record spwc_codec_ds_encoding_rx_in_type;
	
	type spwc_codec_ds_encoding_tx_out_type is record
		spw_do : std_logic;
		spw_so : std_logic;
	end record spwc_codec_ds_encoding_tx_out_type;
	
	type spwc_codec_link_error_out_type is record
		errdisc : std_logic;
		errpar : std_logic;
		erresc : std_logic;
		errcred : std_logic;
	end record spwc_codec_link_error_out_type;
	
	type spwc_codec_timecode_rx_out_type is record
		tick_out : std_logic;
		ctrl_out : std_logic_vector(1 downto 0);
		time_out : std_logic_vector(5 downto 0);
	end record spwc_codec_timecode_rx_out_type;
	
	type spwc_codec_timecode_tx_in_type is record
		tick_in : std_logic;
		ctrl_in : std_logic_vector(1 downto 0);
		time_in : std_logic_vector(5 downto 0);
	end record spwc_codec_timecode_tx_in_type;
	
	type spwc_codec_data_rx_in_type is record
		rxread : std_logic;
	end record spwc_codec_data_rx_in_type;
	
	type spwc_codec_data_rx_out_type is record
		rxvalid : std_logic;
		rxhalff : std_logic;
		rxflag : std_logic;
		rxdata : std_logic_vector(7 downto 0);
	end record spwc_codec_data_rx_out_type;
	
	type spwc_codec_data_tx_in_type is record
		txwrite : std_logic;
		txflag : std_logic;
		txdata : std_logic_vector(7 downto 0);
	end record spwc_codec_data_tx_in_type;
	
	type spwc_codec_data_tx_out_type is record
		txrdy : std_logic;
		txhalff : std_logic;
	end record spwc_codec_data_tx_out_type;
		
end package spwc_codec_pkg;
