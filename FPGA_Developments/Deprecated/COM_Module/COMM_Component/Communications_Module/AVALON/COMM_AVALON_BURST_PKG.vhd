library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package comm_avalon_burst_pkg is

--	constant COMM_AVALON_BURST_ADRESS_SIZE   : natural := 8;
	constant COMM_AVALON_BURST_ADRESS_SIZE   : natural := 26;
	constant COMM_AVALON_BURST_DATA_SIZE     : natural := 64;
	constant COMM_AVALON_BURST_SYMBOL_SIZE   : natural := 8;
	constant COMM_AVALON_BURST_BURST_SIZE    : natural := 8; -- Maximum burst length is 2^BURST_SIZE - 1;
	constant COMM_AVALON_BURST_PIPELINE_SIZE : natural := 16;

	subtype comm_avalon_burst_address_type is natural range 0 to ((2 ** COMM_AVALON_BURST_ADRESS_SIZE) - 1);
	subtype comm_burst_counter_type is natural range 0 to ((2 ** COMM_AVALON_BURST_BURST_SIZE) - 1);
	subtype comm_bytes_enabled_type is std_logic_vector(((COMM_AVALON_BURST_DATA_SIZE / COMM_AVALON_BURST_SYMBOL_SIZE) - 1) downto 0);

	type comm_avalon_burst_read_inputs_type is record
		address    : std_logic_vector((COMM_AVALON_BURST_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((COMM_AVALON_BURST_DATA_SIZE / COMM_AVALON_BURST_SYMBOL_SIZE) - 1) downto 0);
		burstcount : std_logic_vector((COMM_AVALON_BURST_BURST_SIZE - 1) downto 0);
	end record comm_avalon_burst_read_inputs_type;

	type comm_avalon_burst_read_outputs_type is record
		readdata      : std_logic_vector((COMM_AVALON_BURST_DATA_SIZE - 1) downto 0);
		waitrequest   : std_logic;
		readdatavalid : std_logic;
	end record comm_avalon_burst_read_outputs_type;

	type comm_avalon_burst_write_inputs_type is record
		address    : std_logic_vector((COMM_AVALON_BURST_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((COMM_AVALON_BURST_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((COMM_AVALON_BURST_DATA_SIZE / COMM_AVALON_BURST_SYMBOL_SIZE) - 1) downto 0);
		burstcount : std_logic_vector((COMM_AVALON_BURST_BURST_SIZE - 1) downto 0);
	end record comm_avalon_burst_write_inputs_type;

	type comm_avalon_burst_write_outputs_type is record
		waitrequest : std_logic;
	end record comm_avalon_burst_write_outputs_type;

end package comm_avalon_burst_pkg;
