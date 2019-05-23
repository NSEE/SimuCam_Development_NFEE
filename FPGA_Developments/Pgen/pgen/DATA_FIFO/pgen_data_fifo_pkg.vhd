library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_data_fifo_pkg is

	constant c_DATA_FIFO_OUT_WIDTH : natural := 64;
	constant c_DATA_FIFO_IN_WIDTH  : natural := 16;

	type t_pgen_data_fifo_wr_inputs is record
		data  : std_logic_vector((c_DATA_FIFO_IN_WIDTH - 1) downto 0);
		clr   : std_logic;
		wrreq : std_logic;
	end record t_pgen_data_fifo_wr_inputs;

	type t_pgen_data_fifo_wr_outputs is record
		wrfull : std_logic;
	end record t_pgen_data_fifo_wr_outputs;

	type t_pgen_data_fifo_rd_inputs is record
		rdreq : std_logic;
		clr   : std_logic;
	end record t_pgen_data_fifo_rd_inputs;

	type t_pgen_data_fifo_rd_outputs is record
		rdempty : std_logic;
		q       : std_logic_vector((c_DATA_FIFO_OUT_WIDTH - 1) downto 0);
	end record t_pgen_data_fifo_rd_outputs;

end package pgen_data_fifo_pkg;

package body pgen_data_fifo_pkg is
end package body pgen_data_fifo_pkg;
