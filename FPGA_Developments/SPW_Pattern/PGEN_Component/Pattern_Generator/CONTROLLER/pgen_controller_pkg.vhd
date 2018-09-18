library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_controller_pkg is

	type t_pgen_controller_inputs is record
		fifo_data_used : std_logic;
	end record t_pgen_controller_inputs;

	type t_pgen_controller_outputs is record
		fifo_data_valid : std_logic;
	end record t_pgen_controller_outputs;

end package pgen_controller_pkg;
