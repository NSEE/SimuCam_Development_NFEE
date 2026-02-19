library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_bus_controller_pkg.all;
use work.tran_bus_controller_pkg.all;

package comm_bus_controller_pkg is

	-- Write : escrita no bus
	-- Read  : leitura do bus

	type comm_tx_bc_bus_inputs_type is record
		SPWC_OUT : spwc_bc_read_bus_outputs_type;
		TRAN_OUT : tran_bc_write_bus_outputs_type;
	end record comm_tx_bc_bus_inputs_type;	
	
	type comm_tx_bc_bus_outputs_type is record
		SPWC_IN : spwc_bc_read_bus_inputs_type;
		TRAN_IN : tran_bc_write_bus_inputs_type;
	end record comm_tx_bc_bus_outputs_type;

	type comm_rx_bc_bus_inputs_type is record
		SPWC_OUT : spwc_bc_write_bus_outputs_type;
		TRAN_OUT : tran_bc_read_bus_outputs_type;
	end record comm_rx_bc_bus_inputs_type;	
	
	type comm_rx_bc_bus_outputs_type is record
		SPWC_IN : spwc_bc_write_bus_inputs_type;
		TRAN_IN : tran_bc_read_bus_inputs_type;
	end record comm_rx_bc_bus_outputs_type;

end package comm_bus_controller_pkg;
