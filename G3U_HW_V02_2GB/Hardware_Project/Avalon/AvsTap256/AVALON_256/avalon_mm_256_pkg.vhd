library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_256_pkg is

	constant c_AVALON_MM_256_ADRESS_SIZE : natural := 9;
	constant c_AVALON_MM_256_DATA_SIZE   : natural := 256;
	constant c_AVALON_MM_256_SYMBOL_SIZE : natural := 8;

	subtype t_avalon_mm_256_address is natural range 0 to ((2 ** c_AVALON_MM_256_ADRESS_SIZE) - 1);

	type t_avalon_mm_256_write_in is record
		address   : std_logic_vector((c_AVALON_MM_256_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_AVALON_MM_256_DATA_SIZE - 1) downto 0);
	end record t_avalon_mm_256_write_in;

	type t_avalon_mm_256_write_out is record
		waitrequest : std_logic;
	end record t_avalon_mm_256_write_out;

end package avalon_mm_256_pkg;
