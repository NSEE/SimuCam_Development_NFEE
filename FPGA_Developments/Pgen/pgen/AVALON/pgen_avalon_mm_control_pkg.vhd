library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_avalon_mm_control_pkg is

	constant c_PGEN_AVALON_MM_CONTROL_ADDRESS_SIZE : natural := 8;
	constant c_PGEN_AVALON_MM_CONTROL_DATA_SIZE   : natural := 32;
	constant c_PGEN_AVALON_MM_CONTROL_SYMBOL_SIZE : natural := 8;

	subtype t_pgen_avalon_mm_control_address is natural range 0 to ((2 ** c_PGEN_AVALON_MM_CONTROL_ADDRESS_SIZE) - 1);

	type t_pgen_avalon_mm_control_read_inputs is record
		address : std_logic_vector((c_PGEN_AVALON_MM_CONTROL_ADDRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_pgen_avalon_mm_control_read_inputs;

	type t_pgen_avalon_mm_control_read_outputs is record
		readdata    : std_logic_vector((c_PGEN_AVALON_MM_CONTROL_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_pgen_avalon_mm_control_read_outputs;

	type t_pgen_avalon_mm_control_write_inputs is record
		address   : std_logic_vector((c_PGEN_AVALON_MM_CONTROL_ADDRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_PGEN_AVALON_MM_CONTROL_DATA_SIZE - 1) downto 0);
	end record t_pgen_avalon_mm_control_write_inputs;

	type t_pgen_avalon_mm_control_write_outputs is record
		waitrequest : std_logic;
	end record t_pgen_avalon_mm_control_write_outputs;

end package pgen_avalon_mm_control_pkg;
