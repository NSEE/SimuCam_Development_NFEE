library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_data_controller_pkg is

	type t_pgen_data_controller_write_control is record
		data_write : std_logic;
		data_erase : std_logic;
	end record t_pgen_data_controller_write_control;

	type t_pgen_data_controller_write_status is record
		empty : std_logic;
		full  : std_logic;
	end record t_pgen_data_controller_write_status;

	type t_pgen_data_controller_read_control is record
		data_fetch : std_logic;
	end record t_pgen_data_controller_read_control;

	type t_pgen_data_controller_read_status is record
		data_available : std_logic;
		full           : std_logic;
	end record t_pgen_data_controller_read_status;

end package pgen_data_controller_pkg;

package body pgen_data_controller_pkg is
end package body pgen_data_controller_pkg;
