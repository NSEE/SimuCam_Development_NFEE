library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_mm_control_registers_pkg is

	-- Generator Control and Status Register         (32 bits):
	--   31- 5 : Reserved                              [-/-]
	--    4- 4 : Start control bit                     [R/W]
	--    3- 3 : Stop control bit                      [R/W]
	--    2- 2 : Reset control bit                     [R/W]
	--    1- 1 : Reseted status bit                    [R/-]
	--    0- 0 : Stopped status bit                    [R/-]
	-- Pattern Size Register                         (32 bits):
	--   31-16 : Rows Quantity value                   [R/W]
	--   15- 0 : Columns Quantity value                [R/W]
	-- Pattern Parameters Register                   (32 bits):
	--   31-11 : Reserved                              [-/-]
	--   10-10 : CCD Side value                        [R/W]
	--    9- 8 : CCD Number value                      [R/W]
	--    7- 0 : TimeCode value                        [R/W]

	constant c_PGEN_MM_REGISTERS_ADDRESS_OFFSET : natural := 16#0000#;

	constant c_PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS : natural := 16#0000#;
	constant c_PGEN_PATTERN_SIZE_MM_REG_ADDRESS             : natural := 16#0001#;
	constant c_PGEN_PATTERN_PARAMETERS_MM_REG_ADDRESS       : natural := 16#0002#;

	type t_pgen_generator_control_register is record
		start_bit : std_logic;
		stop_bit  : std_logic;
		reset_bit : std_logic;
	end record t_pgen_generator_control_register;

	type t_pgen_generator_status_register is record
		reseted_bit : std_logic;
		stopped_bit : std_logic;
	end record t_pgen_generator_status_register;

	type t_pgen_pattern_size_register is record
		rows_quantity    : std_logic_vector(15 downto 0);
		columns_quantity : std_logic_vector(15 downto 0);
	end record t_pgen_pattern_size_register;

	type t_pgen_pattern_parameters_register is record
		ccd_side   : std_logic;
		ccd_number : std_logic_vector(1 downto 0);
		timecode   : std_logic_vector(7 downto 0);
	end record t_pgen_pattern_parameters_register;

	type t_pgen_mm_control_write_registers is record
		generator_control           : t_pgen_generator_control_register;
		pattern_size                : t_pgen_pattern_size_register;
		pattern_parameters          : t_pgen_pattern_parameters_register;
	end record t_pgen_mm_control_write_registers;

	type t_pgen_mm_control_read_registers is record
		generator_status            : t_pgen_generator_status_register;
	end record t_pgen_mm_control_read_registers;

end package pgen_mm_control_registers_pkg;

package body pgen_mm_control_registers_pkg is
end package body pgen_mm_control_registers_pkg;
