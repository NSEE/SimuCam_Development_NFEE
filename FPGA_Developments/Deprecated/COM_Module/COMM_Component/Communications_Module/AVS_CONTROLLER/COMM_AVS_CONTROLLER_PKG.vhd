library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avs_controller_pkg.all;

package comm_avs_controller_pkg is

	-- RX : fifo --> avs  (SpW --> Simucam)
	type comm_avsdc_rx_avs_inputs_type is record
		TRAN : tran_avsdc_rx_avs_inputs_type;
	end record comm_avsdc_rx_avs_inputs_type;

	-- RX : fifo --> avs  (SpW --> Simucam)
	type comm_avsdc_rx_avs_outputs_type is record
		TRAN : tran_avsdc_rx_avs_outputs_type;
	end record comm_avsdc_rx_avs_outputs_type;

	-- TX : avs  --> fifo (Simucam --> SpW)
	type comm_avsdc_tx_avs_inputs_type is record
		TRAN : tran_avsdc_tx_avs_inputs_type;
	end record comm_avsdc_tx_avs_inputs_type;

	-- TX : avs  --> fifo (Simucam --> SpW)
	type comm_avsdc_tx_avs_outputs_type is record
		TRAN : tran_avsdc_tx_avs_outputs_type;
	end record comm_avsdc_tx_avs_outputs_type;

	type comm_avsdc_avs_inputs_type is record
		RX : comm_avsdc_rx_avs_inputs_type;
		TX : comm_avsdc_tx_avs_inputs_type;
	end record comm_avsdc_avs_inputs_type;
	
	type comm_avsdc_avs_outputs_type is record
		RX : comm_avsdc_rx_avs_outputs_type;
		TX : comm_avsdc_tx_avs_outputs_type;
	end record comm_avsdc_avs_outputs_type;

end package comm_avs_controller_pkg;
