library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_controller_pkg is

	type pgen_controller_inputs_type is record
		fifo_data_used : std_logic;
	end record pgen_controller_inputs_type;

	type pgen_controller_outputs_type is record
		fifo_data_valid : std_logic;
	end record pgen_controller_outputs_type;

end package pgen_controller_pkg;
