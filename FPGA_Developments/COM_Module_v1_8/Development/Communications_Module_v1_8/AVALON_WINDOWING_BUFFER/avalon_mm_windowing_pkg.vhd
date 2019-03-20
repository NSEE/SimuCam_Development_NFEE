library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_windowing_pkg is

	constant c_AVALON_MM_WINDOWING_ADRESS_SIZE     : natural := 10;
	constant c_AVALON_MM_WINDOWING_DATA_SIZE       : natural := 64;
	constant c_AVALON_MM_WINDOWING_SYMBOL_SIZE     : natural := 8;
	constant c_AVALON_MM_WINDOWING_BURSTCOUNT_SIZE : natural := 8; -- Max burst = 2**c_AVALON_MM_WINDOWING_BURSTCOUNT_SIZE = 256

	subtype t_avalon_mm_windowing_address is natural range 0 to ((2 ** c_AVALON_MM_WINDOWING_ADRESS_SIZE) - 1);
	subtype t_avalon_mm_windowing_burstcount is natural range 0 to ((2 ** c_AVALON_MM_WINDOWING_BURSTCOUNT_SIZE) - 1);

	type t_avalon_mm_windowing_write_in is record
		address    : std_logic_vector((c_AVALON_MM_WINDOWING_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_AVALON_MM_WINDOWING_DATA_SIZE - 1) downto 0);
		burstcount : std_logic_vector((c_AVALON_MM_WINDOWING_BURSTCOUNT_SIZE - 1) downto 0);
	end record t_avalon_mm_windowing_write_in;

	type t_avalon_mm_windowing_write_out is record
		waitrequest : std_logic;
	end record t_avalon_mm_windowing_write_out;

end package avalon_mm_windowing_pkg;
