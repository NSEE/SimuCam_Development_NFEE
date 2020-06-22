library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;

package comm_spw_codec_pkg is

	----------------------------------------------------
	-- SpW Codec Block
	----------------------------------------------------

	----------------------------------------------------
	-- Configuration Registers
	----------------------------------------------------

	----------------------------------------------------
	-- Internal Loopback
	----------------------------------------------------

	-- Internal Loopback Control Signals
	type t_swil_control is record
		enable : std_logic;
	end record t_swil_control;

	----------------------------------------------------
	-- External Loopback
	----------------------------------------------------

	-- External Loopback Control Signals
	type t_swel_control is record
		enable : std_logic;
	end record t_swel_control;

	----------------------------------------------------
	-- SpaceWire Light Codec
	----------------------------------------------------

	-- SpaceWire Light Codec Configuration Generics

	-- Codec System Clock Frequency = 200 MHz
	constant c_SPWL_SYSFREQ         : real                    := 200000000.0;
	-- Codec TX Clock Frequency = 0 MHz (default) (only needed when tx_impl = impl_fast)
	constant c_SPWL_TXCLKFREQ       : real                    := 0.0;
	-- Codec Receiver Implementation = generic implementation (default)
	constant c_SPWL_RXIMPL          : spw_implementation_type := impl_generic;
	-- Codec Receiver Chunk Size = 1 (default) (in case of impl_generic, rxchunk must be set to 1)
	constant c_SPWL_RXCHUNK         : integer range 1 to 4    := 1;
	-- Codec Transmitter Implementation = generic implementation (default)
	constant c_SPWL_TXIMPL          : spw_implementation_type := impl_generic;
	-- Codec Receiver FIFO Size, in bits = 6 bits, 64Byte
	constant c_SPWL_RXFIFOSIZE_BITS : integer range 6 to 14   := 6;
	-- Codec Transmitter FIFO Size, in bits = 2 bits, 4Byte
	constant c_SPWL_TXFIFOSIZE_BITS : integer range 2 to 14   := 2;

	-- SpaceWire Light Codec Interface Signals

	-- Codec Transmitter Frequency Scaling Factor = 1 (Transmitter Frequency = 100 MHz) 
	-- (Transmitter Frequency = System Frequency / (Scaling Factor + 1) when tximpl = impl_generic)
	constant c_SPWL_TXDIVCNT : std_logic_vector(7 downto 0) := x"01";

	-- Codec Link Control Signals
	type t_spwl_link_config is record
		autostart : std_logic;
		linkstart : std_logic;
		linkdis   : std_logic;
		txdivcnt  : std_logic_vector(7 downto 0);
	end record t_spwl_link_config;

	-- Codec Link Status Signals
	type t_spwl_link_status is record
		started    : std_logic;
		connecting : std_logic;
		running    : std_logic;
	end record t_spwl_link_status;

	-- Codec Data-Strobe Encoding Signals
	type t_spwl_ds_encoding is record
		spw_d : std_logic;
		spw_s : std_logic;
	end record t_spwl_ds_encoding;

	-- Codec Link Error Signals
	type t_spwl_link_error is record
		errdisc : std_logic;
		errpar  : std_logic;
		erresc  : std_logic;
		errcred : std_logic;
	end record t_spwl_link_error;

	-- Codec Receiver Timecode Status Signals
	type t_spwl_timecode_rx_status is record
		tick_out : std_logic;
	end record t_spwl_timecode_rx_status;

	-- Codec Transmitter Timecode Control Signals
	type t_spwl_timecode_tx_control is record
		tick_in : std_logic;
	end record t_spwl_timecode_tx_control;

	-- Codec Timecode Payload Signals
	type t_spwl_timecode_payload is record
		ctrl : std_logic_vector(1 downto 0);
		time : std_logic_vector(5 downto 0);
	end record t_spwl_timecode_payload;

	-- Codec Receiver Data Control Signals
	type t_spwl_data_rx_control is record
		rxread : std_logic;
	end record t_spwl_data_rx_control;

	-- Codec Receiver Data Status Signals
	type t_spwl_data_rx_status is record
		rxvalid : std_logic;
		rxhalff : std_logic;
	end record t_spwl_data_rx_status;

	-- Codec Transmitter Data Control Signals
	type t_spwl_data_tx_control is record
		txwrite : std_logic;
	end record t_spwl_data_tx_control;

	-- Codec Transmitter Data Status Signals
	type t_spwl_data_tx_status is record
		txrdy   : std_logic;
		txhalff : std_logic;
	end record t_spwl_data_tx_status;

	-- Codec Data Payload Signals
	type t_spwl_data_payload is record
		flag : std_logic;
		data : std_logic_vector(7 downto 0);
	end record t_spwl_data_payload;

end package comm_spw_codec_pkg;

package body comm_spw_codec_pkg is

end package body comm_spw_codec_pkg;
