library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_data_avalon_mm_pkg is

	constant c_FTDI_DATA_AVALON_MM_ADRESS_SIZE : natural := 21;
	constant c_FTDI_DATA_AVALON_MM_DATA_SIZE   : natural := 256;
	constant c_FTDI_DATA_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_ftdi_data_avalon_mm_address is natural range 0 to ((2 ** c_FTDI_DATA_AVALON_MM_ADRESS_SIZE) - 1);

	type t_ftdi_rx_data_avalon_mm_read_in is record
		address : std_logic_vector((c_FTDI_DATA_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_ftdi_rx_data_avalon_mm_read_in;

	type t_ftdi_rx_data_avalon_mm_read_out is record
		readdata    : std_logic_vector((c_FTDI_DATA_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_ftdi_rx_data_avalon_mm_read_out;

	type t_ftdi_tx_data_avalon_mm_write_in is record
		address   : std_logic_vector((c_FTDI_DATA_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_FTDI_DATA_AVALON_MM_DATA_SIZE - 1) downto 0);
	end record t_ftdi_tx_data_avalon_mm_write_in;

	type t_ftdi_tx_data_avalon_mm_write_out is record
		waitrequest : std_logic;
	end record t_ftdi_tx_data_avalon_mm_write_out;

end package ftdi_data_avalon_mm_pkg;
