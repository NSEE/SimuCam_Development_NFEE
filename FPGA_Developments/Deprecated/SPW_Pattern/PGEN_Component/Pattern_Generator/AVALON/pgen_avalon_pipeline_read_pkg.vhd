library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;

package pgen_avalon_pipeline_read_pkg is

	constant c_PGEN_AVALON_PIPELINE_DEPTH            : natural := 16;
	constant c_PGEN_AVALON_PIPELINE_ADRESS_WIDTH     : natural := c_PGEN_AVALON_BURST_ADRESS_WIDTH;
	constant c_PGEN_AVALON_PIPELINE_BURSTCOUNT_WIDTH : natural := c_PGEN_AVALON_BURST_BURST_SIZE;
	constant c_PGEN_AVALON_PIPELINE_BYTEENABLE_WIDTH : natural := (c_PGEN_AVALON_BURST_DATA_WIDTH / c_PGEN_AVALON_BURST_SYMBOL_WIDTH);

	type t_pgen_avalon_pipeline_control is record
		avalon_read_busy        : std_logic;
		avalon_read_fetch       : std_logic;
		avalon_read_waitrequest : std_logic;
	end record t_pgen_avalon_pipeline_control;

	type t_pgen_avalon_pipeline_read_inputs is record
		address    : std_logic_vector((c_PGEN_AVALON_PIPELINE_ADRESS_WIDTH - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector((c_PGEN_AVALON_PIPELINE_BYTEENABLE_WIDTH - 1) downto 0);
		burstcount : std_logic_vector((c_PGEN_AVALON_PIPELINE_BURSTCOUNT_WIDTH - 1) downto 0);
	end record t_pgen_avalon_pipeline_read_inputs;

	type t_pgen_avalon_pipeline_status is record
		pipeline_full  : std_logic;
		pipeline_empty : std_logic;
	end record t_pgen_avalon_pipeline_status;

	type t_pgen_avalon_pipeline_read_outputs is record
		waitrequest : std_logic;
	end record t_pgen_avalon_pipeline_read_outputs;

	type t_pgen_avalon_pipeline_read_pipelined is record
		address    : std_logic_vector((c_PGEN_AVALON_PIPELINE_ADRESS_WIDTH - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector((c_PGEN_AVALON_PIPELINE_BYTEENABLE_WIDTH - 1) downto 0);
		burstcount : std_logic_vector((c_PGEN_AVALON_PIPELINE_BURSTCOUNT_WIDTH - 1) downto 0);
	end record t_pgen_avalon_pipeline_read_pipe;

end package pgen_avalon_pipeline_read_pkg;

package body pgen_avalon_pipeline_read_pkg is

end package body pgen_avalon_pipeline_read_pkg;
