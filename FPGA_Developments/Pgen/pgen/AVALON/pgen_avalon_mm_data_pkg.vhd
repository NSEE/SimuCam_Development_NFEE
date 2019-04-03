library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_avalon_mm_data_pkg is

	constant c_PGEN_AVALON_MM_DATA_ADDRESS_SIZE : natural := 10;
	constant c_PGEN_AVALON_MM_DATA_DATA_SIZE    : natural := 64;
	constant c_PGEN_AVALON_MM_DATA_SYMBOL_SIZE  : natural := 8;

	subtype t_pgen_avalon_mm_data_address is natural range 0 to ((2 ** c_PGEN_AVALON_MM_DATA_ADDRESS_SIZE) - 1);

	type t_pgen_avalon_mm_data_read_inputs is record
		address : std_logic_vector((c_PGEN_AVALON_MM_DATA_ADDRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_pgen_avalon_mm_data_read_inputs;

	type t_pgen_avalon_mm_data_read_outputs is record
		readdata    : std_logic_vector((c_PGEN_AVALON_MM_DATA_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_pgen_avalon_mm_data_read_outputs;

end package pgen_avalon_mm_data_pkg;

package body pgen_avalon_mm_data_pkg is
end package body pgen_avalon_mm_data_pkg;
