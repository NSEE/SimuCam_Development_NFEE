library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_burst_registers_pkg is

	-- Generator Burst Register                 (64 bits):
	--   63-57 : Reserved                       [-]
	--   56-56 : SpaceWire Flag 1 for Pattern 1 [R]
	--   55-48 : SpaceWire Data 1 for Pattern 1 [R]
	--   47-41 : Reserved                       [-]
	--   40-40 : SpaceWire Flag 0 for Pattern 1 [R]
	--   39-32 : SpaceWire Data 0 for Pattern 1 [R]
	--   31-25 : Reserved                       [-]
	--   24-24 : SpaceWire Flag 1 for Pattern 0 [R]
	--   23-16 : SpaceWire Data 1 for Pattern 0 [R]
	--   15- 9 : Reserved                       [-]
	--    8- 8 : SpaceWire Flag 0 for Pattern 0 [R]
	--    7- 0 : SpaceWire Data 0 for Pattern 0 [R]

	constant PGEN_BURST_REGISTERS_ADDRESS_OFFSET : natural := 0;
	constant PGEN_GENERATOR_BURST_REG_ADDRESS    : natural := 0;

	type pgen_generator_burst_register_type is record
		PATTERN_1_SPW_FLAG_1 : std_logic;
		PATTERN_1_SPW_DATA_1 : std_logic_vector(7 downto 0);
		PATTERN_1_SPW_FLAG_0 : std_logic;
		PATTERN_1_SPW_DATA_0 : std_logic_vector(7 downto 0);
		PATTERN_0_SPW_FLAG_1 : std_logic;
		PATTERN_0_SPW_DATA_1 : std_logic_vector(7 downto 0);
		PATTERN_0_SPW_FLAG_0 : std_logic;
		PATTERN_0_SPW_DATA_0 : std_logic_vector(7 downto 0);
	end record pgen_generator_burst_register_type;

	type pgen_burst_read_registers_type is record
		GENERATOR_BURST_REGISTER : pgen_generator_burst_register_type;
	end record pgen_burst_read_registers_type;

end package pgen_burst_registers_pkg;
