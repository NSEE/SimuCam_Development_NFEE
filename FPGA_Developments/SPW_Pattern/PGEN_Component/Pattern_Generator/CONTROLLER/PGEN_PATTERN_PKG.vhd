library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_pattern_pkg is

	constant c_TICO_SIZE    : natural := 256;
	constant c_CCDID_SIZE   : natural := 4;
	constant c_CCDSIDE_SIZE : natural := 2;
	constant c_ROW_X_SIZE   : natural := 4560;
	constant c_COL_Y_SIZE   : natural := 4541;

	type t_pgen_pattern_algorithm_inputs is record
		tico    : natural range 0 to (c_TICO_SIZE - 1);
		ccdid   : natural range 0 to (c_CCDID_SIZE - 1);
		ccdside : natural range 0 to (c_CCDSIDE_SIZE - 1);
		x       : natural range 0 to (c_ROW_X_SIZE - 1);
		y       : natural range 0 to (c_COL_Y_SIZE - 1);
	end record t_pgen_pattern_algorithm_inputs;

	type t_pgen_pattern_algorithm_outputs is record
		tc      : std_logic_vector(2 downto 0);
		ccdid   : std_logic_vector(1 downto 0);
		ccdside : std_logic;
		rownb   : std_logic_vector(4 downto 0);
		colnb   : std_logic_vector(4 downto 0);
	end record t_pgen_pattern_algorithm_outputs;

	constant c_LEFT_CCD_NUMBER           : natural := 0;
	constant c_LEFT_CCD_START_POSITION_X : natural := 0;
	constant c_LEFT_CCD_START_POSITION_Y : natural := 0;
	constant c_LEFT_CCD_END_POSITION_X   : natural := 2279;
	constant c_LEFT_CCD_END_POSITION_Y   : natural := 4540;

	constant c_RIGHT_CCD_NUMBER           : natural := 1;
	constant c_RIGHT_CCD_START_POSITION_X : natural := 4559;
	constant c_RIGHT_CCD_START_POSITION_Y : natural := 0;
	constant c_RIGHT_CCD_END_POSITION_X   : natural := 2280;
	constant c_RIGHT_CCD_END_POSITION_Y   : natural := 4540;

end package pgen_pattern_pkg;
