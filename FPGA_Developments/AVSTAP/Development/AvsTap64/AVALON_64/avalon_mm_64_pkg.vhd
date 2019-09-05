library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_64_pkg is

	constant c_AVALON_MM_64_ADRESS_SIZE : natural := 11;
	constant c_AVALON_MM_64_DATA_SIZE   : natural := 64;
	constant c_AVALON_MM_64_SYMBOL_SIZE : natural := 8;

	subtype t_avalon_mm_64_address is natural range 0 to ((2 ** c_AVALON_MM_64_ADRESS_SIZE) - 1);

	type t_avalon_mm_64_write_in is record
		address   : std_logic_vector((c_AVALON_MM_64_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_AVALON_MM_64_DATA_SIZE - 1) downto 0);
	end record t_avalon_mm_64_write_in;

	type t_avalon_mm_64_write_out is record
		waitrequest : std_logic;
	end record t_avalon_mm_64_write_out;

end package avalon_mm_64_pkg;
