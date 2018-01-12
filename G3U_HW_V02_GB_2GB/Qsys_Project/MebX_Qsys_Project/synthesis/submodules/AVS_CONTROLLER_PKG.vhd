library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tran_avs_controller_pkg is

	constant TRAN_AVS_DATA_SIZE : natural := 36;

	type tran_avsdc_data_type is record
		spacewire_flag_3 : std_logic;
		spacewire_data_3 : std_logic_vector(7 downto 0);
		spacewire_flag_2 : std_logic;
		spacewire_data_2 : std_logic_vector(7 downto 0);
		spacewire_flag_1 : std_logic;
		spacewire_data_1 : std_logic_vector(7 downto 0);
		spacewire_flag_0 : std_logic;
		spacewire_data_0 : std_logic_vector(7 downto 0);
	end record tran_avsdc_data_type;

	-- RX : fifo --> avs  (SpW --> Simucam)

	type tran_avsdc_rx_avs_inputs_type is record
		dataused : std_logic;
	end record tran_avsdc_rx_avs_inputs_type;

	type tran_avsdc_rx_avs_outputs_type is record
		datavalid : std_logic;
	end record tran_avsdc_rx_avs_outputs_type;

	-- TX : avs  --> fifo (Simucam --> SpW)

	type tran_avsdc_tx_avs_inputs_type is record
		write : std_logic;
	end record tran_avsdc_tx_avs_inputs_type;

	type tran_avsdc_tx_avs_outputs_type is record
		full : std_logic;
	end record tran_avsdc_tx_avs_outputs_type;

end package tran_avs_controller_pkg;
