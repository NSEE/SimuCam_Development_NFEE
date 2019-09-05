library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_config_avalon_mm_registers_pkg is

	--	t_comm_spw_link_config_status_rd_reg

	type t_ftdi_general_control_wr_reg is record
		clear       : std_logic;
		stop        : std_logic;
		start       : std_logic;
	end record t_ftdi_general_control_wr_reg;

	type t_ftdi_dbuffer_status_rd_reg is record
		empty : std_logic;
		full  : std_logic;
	end record t_ftdi_dbuffer_status_rd_reg;

	type t_ftdi_config_write_registers is record
		general_control_reg : t_ftdi_general_control_wr_reg;
	end record t_ftdi_config_write_registers;

	type t_ftdi_config_read_registers is record
		tx_dbuffer_status_reg : t_ftdi_dbuffer_status_rd_reg;
		rx_dbuffer_status_reg : t_ftdi_dbuffer_status_rd_reg;
	end record t_ftdi_config_read_registers;

end package ftdi_config_avalon_mm_registers_pkg;

package body ftdi_config_avalon_mm_registers_pkg is

end package body ftdi_config_avalon_mm_registers_pkg;
