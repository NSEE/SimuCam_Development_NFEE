library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_burst_registers_pkg is

	-- Generator Burst Register                 (64 bits):
	--   63-48 : Pattern Pixel 3                [R]
	--   47-32 : Pattern Pixel 2                [R]
	--   31-16 : Pattern Pixel 1                [R]
	--   15- 0 : Pattern Pixel 0                [R]

	constant PGEN_BURST_REGISTERS_ADDRESS_OFFSET : natural := 16#0000000#;
	constant PGEN_GENERATOR_BURST_REG_ADDRESS    : natural := 16#0000000#;
	constant PGEN_BURST_ADDRESS_LENGTH           : natural := 16#3FFFFFF#;

	type pgen_generator_burst_register_type is record
		PATTERN_PIXEL_3 : std_logic_vector(15 downto 0);
		PATTERN_PIXEL_2 : std_logic_vector(15 downto 0);
		PATTERN_PIXEL_1 : std_logic_vector(15 downto 0);
		PATTERN_PIXEL_0 : std_logic_vector(15 downto 0);
	end record pgen_generator_burst_register_type;

	type pgen_burst_read_registers_type is record
		GENERATOR_BURST_REGISTER : pgen_generator_burst_register_type;
	end record pgen_burst_read_registers_type;

end package pgen_burst_registers_pkg;
