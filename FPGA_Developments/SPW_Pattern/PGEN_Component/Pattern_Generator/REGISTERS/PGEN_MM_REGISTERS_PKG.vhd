library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_mm_registers_pkg is

	-- Generator Control and Status Register (32 bits):
	--   31- 5 : Reserved                   [-]
	--    4- 4 : Start control bit          [R/W]
	--    3- 3 : Stop control bit           [R/W]
	--    2- 2 : Reset control bit          [R/W]
	--    1- 1 : Reseted status bit         [R]
	--    0- 0 : Stopped status bit         [R]
	-- Pattern Size Register                 (32 bits):
	--   31-16 : Lines Quantity             [R/W]
	--   15- 0 : Columns Quantity           [R/W]
	-- Pattern Parameters Register           (32 bits):
	--   31-11 : Reserved                   [-]
	--   10-10 : CCD Side                   [R/W]
	--    9- 8 : CCD Number                 [R/W]
	--    7- 0 : TimeCode                   [R/W]

	constant PGEN_MM_REGISTERS_ADDRESS_OFFSET             : natural := 0;
	constant PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS : natural := 0;
	constant PGEN_PATTERN_SIZE_MM_REG_ADDRESS             : natural := 1;
	constant PGEN_PATTERN_PARAMETERS_MM_REG_ADDRESS       : natural := 2;

	type pgen_generator_control_register_type is record
		START_BIT : std_logic;
		STOP_BIT  : std_logic;
		RESET_BIT : std_logic;
	end record pgen_generator_control_register_type;

	type pgen_generator_status_register_type is record
		RESETED_BIT : std_logic;
		STOPPED_BIT : std_logic;
	end record pgen_generator_status_register_type;

	type pgen_pattern_size_register_type is record
		LINES_QUANTITY   : std_logic_vector(15 downto 0);
		COLUMNS_QUANTITY : std_logic_vector(15 downto 0);
	end record pgen_pattern_size_register_type;

	type pgen_pattern_parameters_register_type is record
		CCD_SIDE   : std_logic;
		CCD_NUMBER : std_logic_vector(1 downto 0);
		TIMECODE   : std_logic_vector(7 downto 0);
	end record pgen_pattern_parameters_register_type;

	type pgen_mm_write_registers_type is record
		GENERATOR_CONTROL_REGISTER : pgen_generator_control_register_type;
		PATTERN_SIZE               : pgen_pattern_size_register_type;
		PATTERN_PARAMETERS         : pgen_pattern_parameters_register_type;
	end record pgen_mm_write_registers_type;

	type pgen_mm_read_registers_type is record
		GENERATOR_STATUS_REGISTER : pgen_generator_status_register_type;
	end record pgen_mm_read_registers_type;

end package pgen_mm_registers_pkg;
