library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_pattern_pkg is

	constant TiCo_SIZE    : natural := 256;
	constant CCDID_SIZE   : natural := 4;
	constant CCDSIDE_SIZE : natural := 2;
	constant ROW_X_SIZE   : natural := 4560;
	constant COL_Y_SIZE   : natural := 4541;

	type pgen_pattern_algorithm_inputs_type is record
		TiCo    : natural range 0 to (TiCo_SIZE - 1);
		CCDID   : natural range 0 to (CCDID_SIZE - 1);
		CCDSIDE : natural range 0 to (CCDSIDE_SIZE - 1);
		X       : natural range 0 to (ROW_X_SIZE - 1);
		Y       : natural range 0 to (COL_Y_SIZE - 1);
	end record pgen_pattern_algorithm_inputs_type;

	type pgen_pattern_algorithm_outputs_type is record
		TC      : std_logic_vector(2 downto 0);
		CCDID   : std_logic_vector(1 downto 0);
		CCDSIDE : std_logic;
		ROWNB   : std_logic_vector(4 downto 0);
		COLNB   : std_logic_vector(4 downto 0);
	end record pgen_pattern_algorithm_outputs_type;

	constant LEFT_CCD_NUMBER           : natural := 0;
	constant LEFT_CCD_START_POSITION_X : natural := 0;
	constant LEFT_CCD_START_POSITION_Y : natural := 0;
	constant LEFT_CCD_END_POSITION_X   : natural := 2279;
	constant LEFT_CCD_END_POSITION_Y   : natural := 4540;

	constant RIGHT_CCD_NUMBER           : natural := 1;
	constant RIGHT_CCD_START_POSITION_X : natural := 4559;
	constant RIGHT_CCD_START_POSITION_Y : natural := 0;
	constant RIGHT_CCD_END_POSITION_X   : natural := 2280;
	constant RIGHT_CCD_END_POSITION_Y   : natural := 4540;

end package pgen_pattern_pkg;
