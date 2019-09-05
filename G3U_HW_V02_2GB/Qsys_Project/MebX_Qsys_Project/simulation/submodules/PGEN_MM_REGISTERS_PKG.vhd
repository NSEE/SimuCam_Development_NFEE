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
	-- Initial Transmission State Register  (32 bits):
	--   31-11 : Reserved                   [-]
	--   10- 9 : Initial CCD ID             [R/W]
	--    8- 8 : Initial CCD Side           [R/W]
	--    7- 0 : Initial TimeCode           [R/W]

	constant PGEN_MM_REGISTERS_ADDRESS_OFFSET               : natural := 0;
	constant PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS   : natural := 0;
	constant PGEN_INITIAL_TRANSMISSION_STATE_MM_REG_ADDRESS : natural := 1;

	type pgen_generator_control_register_type is record
		START_BIT : std_logic;
		STOP_BIT  : std_logic;
		RESET_BIT : std_logic;
	end record pgen_generator_control_register_type;

	type pgen_generator_status_register_type is record
		RESETED_BIT : std_logic;
		STOPPED_BIT : std_logic;
	end record pgen_generator_status_register_type;

	type pgen_initial_transmission_state_register_type is record
		INITIAL_CCD_ID   : std_logic_vector(1 downto 0);
		INITIAL_CCD_SIDE : std_logic_vector(0 downto 0);
		INITIAL_TIMECODE : std_logic_vector(7 downto 0);
	end record pgen_initial_transmission_state_register_type;

	type pgen_mm_write_registers_type is record
		GENERATOR_CONTROL_REGISTER          : pgen_generator_control_register_type;
		INITIAL_TRANSMISSION_STATE_REGISTER : pgen_initial_transmission_state_register_type;
	end record pgen_mm_write_registers_type;

	type pgen_mm_read_registers_type is record
		GENERATOR_STATUS_REGISTER : pgen_generator_status_register_type;
	end record pgen_mm_read_registers_type;

end package pgen_mm_registers_pkg;
