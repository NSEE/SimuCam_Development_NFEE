library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_bus_controller_pkg is

	constant SPWC_BUS_DATA_SIZE  : natural := 9;

	type spwc_bc_bus_data_type is record
		spacewire_flag : std_logic;
		spacewire_data : std_logic_vector(7 downto 0);
	end record spwc_bc_bus_data_type;

	type spwc_bc_control_inputs_type is record
		bc_enable       : std_logic;
		bc_write_enable : std_logic;
		bc_read_enable  : std_logic;
	end record spwc_bc_control_inputs_type;

	-- Write : escrita no bus
	-- Read  : leitura do bus

	type spwc_bc_write_bus_inputs_type is record
		dataused : std_logic;
	end record spwc_bc_write_bus_inputs_type;

	type spwc_bc_write_bus_outputs_type is record
		data      : std_logic_vector((SPWC_BUS_DATA_SIZE - 1) downto 0);
		datavalid : std_logic;
		enabled   : std_logic;
	end record spwc_bc_write_bus_outputs_type;

	type spwc_bc_read_bus_inputs_type is record
		data      : std_logic_vector((SPWC_BUS_DATA_SIZE - 1) downto 0);
		datavalid : std_logic;
	end record spwc_bc_read_bus_inputs_type;

	type spwc_bc_read_bus_outputs_type is record
		enabled  : std_logic;
		dataused : std_logic;
	end record spwc_bc_read_bus_outputs_type;

end package spwc_bus_controller_pkg;
