library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_mm_data_registers_pkg is

	-- Pattern Data Read Register                      (64 bits):
	--   63-48 : Pattern Pixel 3                       [R/-]
	--   47-32 : Pattern Pixel 2                       [R/-]
	--   31-16 : Pattern Pixel 1                       [R/-]
	--   15- 0 : Pattern Pixel 0                       [R/-]

	constant c_PGEN_MM_DATA_READ_REGISTERS_ADDRESS_OFFSET : natural := 16#00000000#;

	constant c_PGEN_PATTERN_DATA_REG_ADDRESS : natural := 16#00000000#;

	constant c_PGEN_PATTERN_DATA_LENGTH : natural := 16#3FFFFFF#;

	type t_pgen_mm_data_read_registers is record
		pattern_pixel_3 : std_logic_vector(15 downto 0);
		pattern_pixel_2 : std_logic_vector(15 downto 0);
		pattern_pixel_1 : std_logic_vector(15 downto 0);
		pattern_pixel_0 : std_logic_vector(15 downto 0);
	end record t_pgen_mm_data_read_registers;

end package pgen_mm_data_registers_pkg;

package body pgen_mm_data_registers_pkg is
end package body pgen_mm_data_registers_pkg;
