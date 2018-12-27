library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_rst_controller_registers_pkg is

	--  Reset Controller Register                      (32 bits):
	--    31- 1 : Reserved                               [-/-]
	--     0- 0 : Reset control bit                      [R/W]

	constant c_RST_CONTROLLER_AVALON_MM_REG_OFFSET : natural := 0;
	constant c_RST_CONTROLLER_MM_REG_ADDRESS       : natural := 0;

	type t_rst_controller_register is record
		reset : std_logic;
	end record t_rst_controller_register;

	type t_rst_controller_write_registers is record
		reset_controller : t_rst_controller_register;
	end record t_rst_controller_write_registers;

end package avalon_mm_rst_controller_registers_pkg;

package body avalon_mm_rst_controller_registers_pkg is

end package body avalon_mm_rst_controller_registers_pkg;
