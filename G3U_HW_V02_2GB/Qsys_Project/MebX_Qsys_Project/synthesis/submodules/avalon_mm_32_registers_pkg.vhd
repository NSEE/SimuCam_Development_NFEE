library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_32_registers_pkg is

	constant c_AVSTAP_DATA_SIZE_DWORDS : natural := 1024; -- Size of the AvsTap, in DWORDS (32b)

	type t_avstap_data is array (0 to (c_AVSTAP_DATA_SIZE_DWORDS - 1)) of std_logic_vector(31 downto 0);

	type t_avstap_data_reg is record
		avstap_data : t_avstap_data;
	end record t_avstap_data_reg;

	type t_avstap_control is record
		avstap_clear : std_logic;
	end record t_avstap_control;

	type t_avstap_write_registers is record
		avstap_control : t_avstap_control;
	end record t_avstap_write_registers;

	type t_avstap_read_registers is record
		avstap_data_reg : t_avstap_data_reg;
	end record t_avstap_read_registers;

end package avalon_mm_32_registers_pkg;

package body avalon_mm_32_registers_pkg is

end package body avalon_mm_32_registers_pkg;
