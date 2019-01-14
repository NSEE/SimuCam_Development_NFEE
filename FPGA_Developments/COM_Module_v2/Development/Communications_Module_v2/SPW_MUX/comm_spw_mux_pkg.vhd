use work.comm_spw_codec_pkg.all;

package comm_spw_mux_pkg is

	----------------------------------------------------
	-- SpW Mux Block
	----------------------------------------------------

	-- Rx Demux Channel Quantity
	constant c_RX_DEMUX_CHANNELS : natural := 2;

	-- Tx Mux Channel Quantity
	constant c_TX_MUX_CHANNELS : natural := 3;

	----------------------------------------------------
	-- Configuration Registers
	----------------------------------------------------

	----------------------------------------------------
	-- Rx Demux
	----------------------------------------------------

	-- Rx Demux Channels Control Signals
	type t_swdc_control is record
		enable : std_logic;
		master : std_logic;
	end record t_swdc_control;

	-- Rx Demux Channels Status Signals
	type t_swdc_status is record
		overflow : std_logic;
	end record t_swdc_status;

	-- Rx Demux Control Signals
	type t_swrd_control is array (0 to (c_RX_DEMUX_CHANNELS - 1)) of t_swdc_control;

	-- Rx Demux Status Signals
	type t_swrd_status is array (0 to (c_RX_DEMUX_CHANNELS - 1)) of t_swdc_status;

	-- Rx Demux SpW Control Signals
	type t_swrd_spw_control is array (0 to (c_RX_DEMUX_CHANNELS - 1)) of t_spwl_data_rx_control;

	-- Rx Demux SpW Status Signals
	type t_swrd_spw_status is array (0 to (c_RX_DEMUX_CHANNELS - 1)) of t_spwl_data_rx_status;

	-- Rx Demux SpW Payload Signals
	type t_swrd_spw_payload is array (0 to (c_RX_DEMUX_CHANNELS - 1)) of t_spwl_data_payload;

	----------------------------------------------------
	-- Tx Mux
	----------------------------------------------------

	-- Tx Mux Channels Control Signals
	type t_swmc_control is record
		enable : std_logic;
	end record t_swmc_control;

	-- Tx Mux Channels Status Signals
	type t_swmc_status is record
		queued : std_logic;
	end record t_swmc_status;

	-- Tx Mux Control Signals
	type t_swtm_control is array (0 to (c_TX_MUX_CHANNELS - 1)) of t_swmc_control;

	-- Tx Mux Status Signals
	type t_swtm_status is array (0 to (c_TX_MUX_CHANNELS - 1)) of t_swmc_status;

	-- Tx Mux SpW Control Signals
	type t_swtm_spw_control is array (0 to (c_TX_MUX_CHANNELS - 1)) of t_spwl_data_tx_control;

	-- Tx Mux SpW Status Signals
	type t_swtm_spw_status is array (0 to (c_TX_MUX_CHANNELS - 1)) of t_spwl_data_tx_status;

	-- Tx Mux SpW Payload Signals
	type t_swtm_spw_payload is array (0 to (c_TX_MUX_CHANNELS - 1)) of t_spwl_data_payload;

end package comm_spw_mux_pkg;

package body comm_spw_mux_pkg is

end package body comm_spw_mux_pkg;
