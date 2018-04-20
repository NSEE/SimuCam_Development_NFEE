library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_avalon_mm_pkg is

	constant PGEN_AVALON_MM_ADRESS_SIZE : natural := 8;
	constant PGEN_AVALON_MM_DATA_SIZE   : natural := 32;
	constant PGEN_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype pgen_avalon_mm_address_type is natural range 0 to ((2 ** PGEN_AVALON_MM_ADRESS_SIZE) - 1);

	type pgen_avalon_mm_read_inputs_type is record
		address : std_logic_vector((PGEN_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record pgen_avalon_mm_read_inputs_type;

	type pgen_avalon_mm_read_outputs_type is record
		readdata    : std_logic_vector((PGEN_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record pgen_avalon_mm_read_outputs_type;

	type pgen_avalon_mm_write_inputs_type is record
		address   : std_logic_vector((PGEN_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((PGEN_AVALON_MM_DATA_SIZE - 1) downto 0);
	end record pgen_avalon_mm_write_inputs_type;

	type pgen_avalon_mm_write_outputs_type is record
		waitrequest : std_logic;
	end record pgen_avalon_mm_write_outputs_type;

end package pgen_avalon_mm_pkg;
