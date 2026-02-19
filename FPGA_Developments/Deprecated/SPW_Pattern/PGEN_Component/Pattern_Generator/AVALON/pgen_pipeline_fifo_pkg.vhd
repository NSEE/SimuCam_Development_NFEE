library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;

package pgen_pipeline_fifo_pkg is

	constant c_PIPELINE_AVALON_ADDRESS_SIZE : natural := c_PGEN_AVALON_BURST_ADRESS_SIZE;
	constant c_PIPELINE_AVALON_DATA_SIZE    : natural := c_PGEN_AVALON_BURST_DATA_SIZE;
	constant c_PIPELINE_AVALON_SYMBOL_SIZE  : natural := c_PGEN_AVALON_BURST_SYMBOL_SIZE;
	constant c_PIPELINE_AVALON_BURST_SIZE   : natural := c_PGEN_AVALON_BURST_BURST_SIZE;

	constant c_PIPELINE_FIFO_WIDTH  : natural := (c_PIPELINE_AVALON_ADDRESS_SIZE) + (c_PIPELINE_AVALON_DATA_SIZE / c_PIPELINE_AVALON_SYMBOL_SIZE) + (c_PIPELINE_AVALON_BURST_SIZE);
	constant c_PIPELINE_FIFO_LENGTH : natural := c_PGEN_AVALON_BURST_PIPELINE_SIZE;

	type t_pipeline_fifo_data is record
		address    : std_logic_vector((c_PIPELINE_AVALON_ADDRESS_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_PIPELINE_AVALON_DATA_SIZE / c_PIPELINE_AVALON_SYMBOL_SIZE) - 1) downto 0);
		burstcount : std_logic_vector((c_PIPELINE_AVALON_BURST_SIZE - 1) downto 0);
	end record t_pipeline_fifo_data;

	type t_pipeline_fifo_inputs is record
		data  : std_logic_vector((c_PIPELINE_FIFO_WIDTH - 1) downto 0);
		rdreq : std_logic;
		wrreq : std_logic;
	end record t_pipeline_fifo_inputs;

	type t_pipeline_fifo_outputs is record
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((c_PIPELINE_FIFO_WIDTH - 1) downto 0);
	end record t_pipeline_fifo_outputs;

end package pgen_pipeline_fifo_pkg;
