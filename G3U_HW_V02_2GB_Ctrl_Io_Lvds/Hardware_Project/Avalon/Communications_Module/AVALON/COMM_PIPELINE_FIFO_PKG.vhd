library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avalon_burst_pkg.all;

package comm_pipeline_fifo_pkg is

	--constant PIPELINE_AVALON_ADDRESS_SIZE : natural := COMM_AVALON_BURST_ADRESS_SIZE;
	constant PIPELINE_AVALON_ADDRESS_SIZE : natural := 8;
	constant PIPELINE_AVALON_DATA_SIZE    : natural := COMM_AVALON_BURST_DATA_SIZE;
	constant PIPELINE_AVALON_SYMBOL_SIZE  : natural := COMM_AVALON_BURST_SYMBOL_SIZE;
	constant PIPELINE_AVALON_BURST_SIZE   : natural := COMM_AVALON_BURST_BURST_SIZE;
	constant PIPELINE_AVALON_PIPELINE_SIZE   : natural := COMM_AVALON_BURST_PIPELINE_SIZE;

	constant PIPELINE_FIFO_WIDTH  : natural := (PIPELINE_AVALON_ADDRESS_SIZE) + (PIPELINE_AVALON_DATA_SIZE / PIPELINE_AVALON_SYMBOL_SIZE) + (PIPELINE_AVALON_BURST_SIZE);
	constant PIPELINE_FIFO_LENGTH : natural := PIPELINE_AVALON_PIPELINE_SIZE;

	type pipeline_fifo_data_type is record
		address    : std_logic_vector((PIPELINE_AVALON_ADDRESS_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((PIPELINE_AVALON_DATA_SIZE / PIPELINE_AVALON_SYMBOL_SIZE) - 1) downto 0);
		burstcount : std_logic_vector((PIPELINE_AVALON_BURST_SIZE - 1) downto 0);
	end record pipeline_fifo_data_type;

	type pipeline_fifo_inputs_type is record
		data  : std_logic_vector((PIPELINE_FIFO_WIDTH - 1) downto 0);
		rdreq : std_logic;
		wrreq : std_logic;
	end record pipeline_fifo_inputs_type;

	type pipeline_fifo_outputs_type is record
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((PIPELINE_FIFO_WIDTH - 1) downto 0);
	end record pipeline_fifo_outputs_type;

end package comm_pipeline_fifo_pkg;
