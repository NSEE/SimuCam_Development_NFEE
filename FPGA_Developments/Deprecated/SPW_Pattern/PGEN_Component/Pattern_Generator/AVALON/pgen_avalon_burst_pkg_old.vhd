library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pgen_avalon_burst_pkg is

	constant c_PGEN_AVALON_BURST_ADRESS_SIZE   : natural := 26;
	constant c_PGEN_AVALON_BURST_DATA_SIZE     : natural := 64;
	constant c_PGEN_AVALON_BURST_SYMBOL_SIZE   : natural := 8;
	constant c_PGEN_AVALON_BURST_BURST_SIZE    : natural := 8; -- Maximum burst length is 2^BURST_SIZE - 1;
	constant c_PGEN_AVALON_BURST_PIPELINE_SIZE : natural := 16;

	subtype t_pgen_avalon_burst_address is natural range 0 to ((2 ** c_PGEN_AVALON_BURST_ADRESS_SIZE) - 1);
	subtype t_pgen_burst_counter is natural range 0 to ((2 ** c_PGEN_AVALON_BURST_BURST_SIZE) - 1);
	subtype t_pgen_bytes_enabled is std_logic_vector(((c_PGEN_AVALON_BURST_DATA_SIZE / c_PGEN_AVALON_BURST_SYMBOL_SIZE) - 1) downto 0);

	type t_pgen_avalon_burst_read_inputs is record
		address    : std_logic_vector((c_PGEN_AVALON_BURST_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_PGEN_AVALON_BURST_DATA_SIZE / c_PGEN_AVALON_BURST_SYMBOL_SIZE) - 1) downto 0);
		burstcount : std_logic_vector((c_PGEN_AVALON_BURST_BURST_SIZE - 1) downto 0);
	end record t_pgen_avalon_burst_read_inputs;

	type t_pgen_avalon_burst_read_outputs is record
		readdata      : std_logic_vector((c_PGEN_AVALON_BURST_DATA_SIZE - 1) downto 0);
		waitrequest   : std_logic;
		readdatavalid : std_logic;
	end record t_pgen_avalon_burst_read_outputs;

end package pgen_avalon_burst_pkg;
