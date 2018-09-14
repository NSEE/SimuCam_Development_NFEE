library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_burst_registers_pkg is

	-- Generator Burst Register                      (64 bits):
	--   63-48 : Pattern Pixel 3                       [R/-]
	--   47-32 : Pattern Pixel 2                       [R/-]
	--   31-16 : Pattern Pixel 1                       [R/-]
	--   15- 0 : Pattern Pixel 0                       [R/-]

	constant c_PGEN_BURST_REGISTERS_ADDRESS_OFFSET : natural := 16#0000000#;
	constant c_PGEN_GENERATOR_BURST_REG_ADDRESS    : natural := 16#0000000#;

	constant c_PGEN_BURST_ADDRESS_LENGTH : natural := 16#3FFFFFF#;

	type t_pgen_generator_burst_register is record
		pattern_pixel_3 : std_logic_vector(15 downto 0);
		pattern_pixel_2 : std_logic_vector(15 downto 0);
		pattern_pixel_1 : std_logic_vector(15 downto 0);
		pattern_pixel_0 : std_logic_vector(15 downto 0);
	end record t_pgen_generator_burst_register;

	type t_pgen_burst_read_registers is record
		generator_burst_register : t_pgen_generator_burst_register;
	end record t_pgen_burst_read_registers;

end package pgen_burst_registers_pkg;
