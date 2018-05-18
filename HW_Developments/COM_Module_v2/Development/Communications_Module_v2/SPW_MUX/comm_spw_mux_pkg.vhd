package comm_spw_mux_pkg is

	----------------------------------------------------
	-- SpW Mux Block
	----------------------------------------------------

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
		idle : std_logic;
	end record t_swdc_status;

	-- Rx Demux Control Signals
	type t_swrd_control is record
		channel_0 : t_swdc_control;
		channel_1 : t_swdc_control;
	end record t_swrd_control;

	-- Rx Demux Status Signals
	type t_swrd_status is record
		channel_0 : t_swdc_status;
		channel_1 : t_swdc_status;
	end record t_swrd_status;

	----------------------------------------------------
	-- Tx Mux
	----------------------------------------------------

	-- Tx Mux Channels Control Signals
	type t_swmc_control is record
		enable : std_logic;
		master : std_logic;
	end record t_swmc_control;

	-- Tx Mux Channels Status Signals
	type t_swmc_status is record
		idle : std_logic;
	end record t_swmc_status;

	-- Tx Mux Control Signals
	type t_swtm_control is record
		channel_0 : t_swmc_control;
		channel_1 : t_swmc_control;
		channel_2 : t_swmc_control;
	end record t_swtm_control;

	-- Tx Mux Status Signals
	type t_swtm_status is record
		channel_0 : t_swmc_status;
		channel_1 : t_swmc_status;
		channel_2 : t_swmc_status;
	end record t_swtm_status;

	----------------------------------------------------
	-- SpW Codec
	----------------------------------------------------

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

end package comm_spw_mux_pkg;

package body comm_spw_mux_pkg is

end package body comm_spw_mux_pkg;
