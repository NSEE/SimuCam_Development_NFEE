library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package altera_sc_fifo_pkg is

	type altera_sc_fifo_inputs_type is record
		data  : std_logic_vector((DATA_FIFO_WIDTH - 1) downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
	end record altera_sc_fifo_inputs_type;

	type altera_sc_fifo_outputs_type is record
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((DATA_FIFO_WIDTH - 1) downto 0);
	end record altera_sc_fifo_outputs_type;

end package altera_sc_fifo_pkg;
