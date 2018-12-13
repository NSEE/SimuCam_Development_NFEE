library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package comm_avalon_mm_pkg is

	constant COMM_AVALON_MM_ADRESS_SIZE : natural := 8;
	constant COMM_AVALON_MM_DATA_SIZE   : natural := 32;
	constant COMM_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype comm_avalon_mm_address_type is natural range 0 to ((2 ** COMM_AVALON_MM_ADRESS_SIZE) - 1);

	type comm_avalon_mm_read_inputs_type is record
		address : std_logic_vector((COMM_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record comm_avalon_mm_read_inputs_type;

	type comm_avalon_mm_read_outputs_type is record
		readdata    : std_logic_vector((COMM_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record comm_avalon_mm_read_outputs_type;

	type comm_avalon_mm_write_inputs_type is record
		address   : std_logic_vector((COMM_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((COMM_AVALON_MM_DATA_SIZE - 1) downto 0);
	end record comm_avalon_mm_write_inputs_type;

	type comm_avalon_mm_write_outputs_type is record
		waitrequest : std_logic;
	end record comm_avalon_mm_write_outputs_type;

end package comm_avalon_mm_pkg;
