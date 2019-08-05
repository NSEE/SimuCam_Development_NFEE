library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_data_fifo_pkg is

	constant c_FTDI_DATA_WIDTH  : natural := 32;
	constant c_FTDI_BE_WIDTH    : natural := 4;
	constant c_FTDI_FIFO_WIDTH  : natural := c_FTDI_DATA_WIDTH + c_FTDI_BE_WIDTH;
	constant c_FTDI_FIFO_LENGTH : natural := 512;
	constant c_FTDI_USED_WIDTH  : natural := 9;

	type t_ftdi_data_fifo_rd_control is record
		rdreq : std_logic;
	end record t_ftdi_data_fifo_rd_control;

	type t_ftdi_data_fifo_rd_status is record
		rdempty : std_logic;
		rdfull  : std_logic;
		rdusedw : std_logic_vector((c_FTDI_USED_WIDTH - 1) downto 0);
	end record t_ftdi_data_fifo_rd_status;

	type t_ftdi_data_fifo_wr_control is record
		wrreq : std_logic;
	end record t_ftdi_data_fifo_wr_control;

	type t_ftdi_data_fifo_wr_status is record
		wrempty : std_logic;
		wrfull  : std_logic;
		wrusedw : std_logic_vector((c_FTDI_USED_WIDTH - 1) downto 0);
	end record t_ftdi_data_fifo_wr_status;

	type t_ftdi_data_fifo_data is record
		data : std_logic_vector((c_FTDI_DATA_WIDTH - 1) downto 0);
		be   : std_logic_vector((c_FTDI_BE_WIDTH - 1) downto 0);
	end record t_ftdi_data_fifo_data;

end package ftdi_data_fifo_pkg;

package body ftdi_data_fifo_pkg is

end package body ftdi_data_fifo_pkg;
