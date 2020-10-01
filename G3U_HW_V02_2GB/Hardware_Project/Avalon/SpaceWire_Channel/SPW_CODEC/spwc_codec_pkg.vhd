library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;

package spwc_codec_pkg is

	-- SpaceWire Light Codec Configuration Generics

	-- Codec System Clock Frequency = 200 MHz
	constant c_SPWC_SYSFREQ         : real                    := 200000000.0;
	-- Codec TX Clock Frequency = 0 MHz (default) (only needed when tx_impl = impl_fast)
	constant c_SPWC_TXCLKFREQ       : real                    := 0.0;
	-- Codec Receiver Implementation = generic implementation (default)
	constant c_SPWC_RXIMPL          : spw_implementation_type := impl_generic;
	-- Codec Receiver Chunk Size = 1 (default) (in case of impl_generic, rxchunk must be set to 1)
	constant c_SPWC_RXCHUNK         : integer range 1 to 4    := 1;
	-- Codec Transmitter Implementation = generic implementation (default)
	constant c_SPWC_TXIMPL          : spw_implementation_type := impl_generic;
	-- Codec Receiver FIFO Size, in bits = 11 bits, 2kByte (default)
	constant c_SPWC_RXFIFOSIZE_BITS : integer range 6 to 14   := 11;
	-- Codec Transmitter FIFO Size, in bits = 11 bits, 2kByte (default)
	constant c_SPWC_TXFIFOSIZE_BITS : integer range 6 to 14   := 11;

	-- SpaceWire Light Codec Interface Signals

	-- Codec Transmitter Frequency Scaling Factor = 1 (Transmitter Frequency = 100 MHz) 
	-- (Transmitter Frequency = System Frequency / (Scaling Factor + 1) when tximpl = impl_generic)
	constant c_SPWC_TXDIVCNT : std_logic_vector(7 downto 0) := x"01";

	-- Codec Link Control Signals
	type t_spwc_codec_link_command is record
		autostart : std_logic;
		linkstart : std_logic;
		linkdis   : std_logic;
		txdivcnt  : std_logic_vector(7 downto 0);
	end record t_spwc_codec_link_command;

	-- Codec Link Status Signals
	type t_spwc_codec_link_status is record
		started    : std_logic;
		connecting : std_logic;
		running    : std_logic;
	end record t_spwc_codec_link_status;

	-- Codec Receiver Data-Strobe Encoding Signals
	type t_spwc_codec_ds_encoding_rx is record
		spw_di : std_logic;
		spw_si : std_logic;
	end record t_spwc_codec_ds_encoding_rx;

	-- Codec Transmitter Data-Strobe Encoding Signals
	type t_spwc_codec_ds_encoding_tx is record
		spw_do : std_logic;
		spw_so : std_logic;
	end record t_spwc_codec_ds_encoding_tx;

	-- Codec Link Error Signals
	type t_spwc_codec_link_error is record
		errdisc : std_logic;
		errpar  : std_logic;
		erresc  : std_logic;
		errcred : std_logic;
	end record t_spwc_codec_link_error;

	-- Codec Receiver Timecode Signals
	type t_spwc_codec_timecode_rx is record
		tick_out : std_logic;
		ctrl_out : std_logic_vector(1 downto 0);
		time_out : std_logic_vector(5 downto 0);
	end record t_spwc_codec_timecode_rx;

	-- Codec Transmitter Timecode Signals
	type t_spwc_codec_timecode_tx is record
		tick_in : std_logic;
		ctrl_in : std_logic_vector(1 downto 0);
		time_in : std_logic_vector(5 downto 0);
	end record t_spwc_codec_timecode_tx;

	-- Codec Receiver Data Control Signals
	type t_spwc_codec_data_rx_command is record
		rxread : std_logic;
	end record t_spwc_codec_data_rx_command;

	-- Codec Receiver Data Status Signals
	type t_spwc_codec_data_rx_status is record
		rxvalid : std_logic;
		rxhalff : std_logic;
		rxflag  : std_logic;
		rxdata  : std_logic_vector(7 downto 0);
	end record t_spwc_codec_data_rx_status;

	-- Codec Transmitter Data Control Signals
	type t_spwc_codec_data_tx_command is record
		txwrite : std_logic;
		txflag  : std_logic;
		txdata  : std_logic_vector(7 downto 0);
	end record t_spwc_codec_data_tx_command;

	-- Codec Transmitter Data Status Signals
	type t_spwc_codec_data_tx_status is record
		txrdy   : std_logic;
		txhalff : std_logic;
	end record t_spwc_codec_data_tx_status;

	-- Codec Error Injection Command Signals
	type t_spwc_codec_err_inj_command is record
		errinj : std_logic;
		errsel : t_spw_err_sel;
	end record t_spwc_codec_err_inj_command;

	-- Codec Error Injection Status Signals
	type t_spwc_codec_err_inj_status is record
		errstat : t_spw_err_stat;
	end record t_spwc_codec_err_inj_status;

end package spwc_codec_pkg;
