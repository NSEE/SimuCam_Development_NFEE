-- TODO Atualizar valores das contantes
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tran_bus_sc_fifo_pkg is

	constant TRAN_BUS_SC_FIFO_WIDTH     : natural := 9;
	constant TRAN_RX_BUS_SC_FIFO_LENGTH : natural := 1024;
	constant TRAN_TX_BUS_SC_FIFO_LENGTH : natural := 1024;

	type tran_bus_sc_fifo_data_type is record
		spacewire_flag : std_logic;
		spacewire_data : std_logic_vector(7 downto 0);
	end record tran_bus_sc_fifo_data_type;

	-- RX : bus  --> fifo (SpW --> Simucam);
	-- TX : fifo --> bus  (Simucam --> SpW);

	type tran_write_inputs_bus_sc_fifo_type is record
		data  : std_logic_vector((TRAN_BUS_SC_FIFO_WIDTH - 1) downto 0);
		sclr  : std_logic;
		wrreq : std_logic;
	end record tran_write_inputs_bus_sc_fifo_type;

	type tran_write_outputs_bus_sc_fifo_type is record
		full : std_logic;
	end record tran_write_outputs_bus_sc_fifo_type;

	type tran_read_inputs_bus_sc_fifo_type is record
		sclr  : std_logic;
		rdreq : std_logic;
	end record tran_read_inputs_bus_sc_fifo_type;

	type tran_read_outputs_bus_sc_fifo_type is record
		empty : std_logic;
		q     : std_logic_vector((TRAN_BUS_SC_FIFO_WIDTH - 1) downto 0);
	end record tran_read_outputs_bus_sc_fifo_type;

	type tran_fifo_intputs_bus_sc_fifo_type is record
		write : tran_write_inputs_bus_sc_fifo_type;
		read  : tran_read_inputs_bus_sc_fifo_type;
	end record tran_fifo_intputs_bus_sc_fifo_type;

	type tran_fifo_outputs_bus_sc_fifo_type is record
		write : tran_write_outputs_bus_sc_fifo_type;
		read  : tran_read_outputs_bus_sc_fifo_type;
	end record tran_fifo_outputs_bus_sc_fifo_type;

end package tran_bus_sc_fifo_pkg;
