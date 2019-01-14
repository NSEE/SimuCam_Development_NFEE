package sync_avalon_mm_pkg is

	constant c_SYNC_AVALON_MM_ADRESS_SIZE : natural := 8;
	constant c_SYNC_AVALON_MM_DATA_SIZE   : natural := 32;
	constant c_SYNC_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_sync_avalon_mm_address is natural range 0 to ((2 ** c_SYNC_AVALON_MM_ADRESS_SIZE) - 1);

	type t_sync_avalon_mm_read_i is record
		address : std_logic_vector((c_SYNC_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_sync_avalon_mm_read_i;

	type t_sync_avalon_mm_read_o is record
		readdata    : std_logic_vector((c_SYNC_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_sync_avalon_mm_read_o;

	type t_sync_avalon_mm_write_i is record
		address   : std_logic_vector((c_SYNC_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_SYNC_AVALON_MM_DATA_SIZE - 1) downto 0);
	end record t_sync_avalon_mm_write_i;

	type t_sync_avalon_mm_write_o is record
		waitrequest : std_logic;
	end record t_sync_avalon_mm_write_o;

end package sync_avalon_mm_pkg;

package body sync_avalon_mm_pkg is

end package body sync_avalon_mm_pkg;
