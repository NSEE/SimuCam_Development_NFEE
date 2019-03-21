library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_pattern_generator_pkg is

	type t_pgen_pattern_generator_read_data is record
		pattern_pixel_3 : std_logic_vector(15 downto 0);
		pattern_pixel_2 : std_logic_vector(15 downto 0);
		pattern_pixel_1 : std_logic_vector(15 downto 0);
		pattern_pixel_0 : std_logic_vector(15 downto 0);
	end record t_pgen_pattern_generator_read_data;

	type t_pgen_pattern_generator_write_data is record
		pattern_pixel   : std_logic_vector(15 downto 0);
	end record t_pgen_pattern_generator_write_data;

	type t_pgen_pattern_generator_control is record
		start : std_logic;
		stop  : std_logic;
		reset : std_logic;
	end record t_pgen_pattern_generator_control;

	type t_pgen_pattern_generator_status is record
		stopped  : std_logic;
		resetted : std_logic;
	end record t_pgen_pattern_generator_status;

	type t_pgen_pattern_generator_config is record
		ccd_side         : std_logic;
		ccd_number       : std_logic_vector(1 downto 0);
		timecode         : std_logic_vector(7 downto 0);
		rows_quantity    : std_logic_vector(15 downto 0);
		columns_quantity : std_logic_vector(15 downto 0);
	end record t_pgen_pattern_generator_config;

end package pgen_pattern_generator_pkg;

package body pgen_pattern_generator_pkg is
end package body pgen_pattern_generator_pkg;
