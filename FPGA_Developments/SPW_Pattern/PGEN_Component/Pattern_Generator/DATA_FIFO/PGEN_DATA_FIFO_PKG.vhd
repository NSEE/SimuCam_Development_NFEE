library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_data_fifo_pkg is

	constant DATA_FIFO_WIDTH  : natural := 64;
	constant DATA_FIFO_LENGTH : natural := 16;

	type pgen_data_fifo_data_type is record
		pattern_pixel_3 : std_logic_vector(15 downto 0);
		pattern_pixel_2 : std_logic_vector(15 downto 0);
		pattern_pixel_1 : std_logic_vector(15 downto 0);
		pattern_pixel_0 : std_logic_vector(15 downto 0);
	end record pgen_data_fifo_data_type;

	type pgen_data_fifo_inputs_type is record
		data  : std_logic_vector((DATA_FIFO_WIDTH - 1) downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
	end record pgen_data_fifo_inputs_type;

	type pgen_data_fifo_outputs_type is record
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((DATA_FIFO_WIDTH - 1) downto 0);
	end record pgen_data_fifo_outputs_type;

end package pgen_data_fifo_pkg;
