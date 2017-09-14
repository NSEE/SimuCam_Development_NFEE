library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_bus_controller_pkg is

	constant SPWC_BUS_DATA_SIZE  : natural := 9;
	constant SPWC_FIFO_DATA_SIZE : natural := 9;

	type spwc_bc_control_inputs_type is record
		bc_enable       : std_logic;
		bc_write_enable : std_logic;
		bc_read_enable  : std_logic;
	end record spwc_bc_control_inputs_type;

	--bc_write : bus -> fifo
	type spwc_bc_write_bus_inputs_type is record
		data      : std_logic_vector((SPWC_BUS_DATA_SIZE - 1) downto 0);
		datavalid : std_logic;
	end record spwc_bc_write_bus_inputs_type;

	type spwc_bc_write_bus_outputs_type is record
		enabled  : std_logic;
		dataused : std_logic;
	end record spwc_bc_write_bus_outputs_type;

	type spwc_bc_write_fifo_inputs_type is record
		full : std_logic;
	end record spwc_bc_write_fifo_inputs_type;

	type spwc_bc_write_fifo_outputs_type is record
		aclr  : std_logic;
		data  : std_logic_vector((SPWC_FIFO_DATA_SIZE - 1) downto 0);
		write : std_logic;
	end record spwc_bc_write_fifo_outputs_type;

	--bc_read : fifo -> bus
	type spwc_bc_read_fifo_inputs_type is record
		data  : std_logic_vector((SPWC_FIFO_DATA_SIZE - 1) downto 0);
		empty : std_logic;
	end record spwc_bc_read_fifo_inputs_type;

	type spwc_bc_read_fifo_outputs_type is record
		aclr : std_logic;
		read : std_logic;
	end record spwc_bc_read_fifo_outputs_type;

	type spwc_bc_read_bus_inputs_type is record
		dataused : std_logic;
	end record spwc_bc_read_bus_inputs_type;

	type spwc_bc_read_bus_outputs_type is record
		data      : std_logic_vector((SPWC_BUS_DATA_SIZE - 1) downto 0);
		datavalid : std_logic;
		enabled   : std_logic;
	end record spwc_bc_read_bus_outputs_type;

end package spwc_bus_controller_pkg;
