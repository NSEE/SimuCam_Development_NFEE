library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_spacewire_pkg is

	constant c_AVALON_MM_SPACEWIRE_ADRESS_SIZE : natural := 8;
	constant c_AVALON_MM_SPACEWIRE_DATA_SIZE   : natural := 32;
	constant c_AVALON_MM_SPACEWIRE_SYMBOL_SIZE : natural := 8;

	subtype t_avalon_mm_spacewire_address is natural range 0 to ((2 ** c_AVALON_MM_SPACEWIRE_ADRESS_SIZE) - 1);

	type t_avalon_mm_spacewire_read_in is record
		address    : std_logic_vector((c_AVALON_MM_SPACEWIRE_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_AVALON_MM_SPACEWIRE_DATA_SIZE / c_AVALON_MM_SPACEWIRE_SYMBOL_SIZE) - 1) downto 0);
	end record t_avalon_mm_spacewire_read_in;

	type t_avalon_mm_spacewire_read_out is record
		readdata    : std_logic_vector((c_AVALON_MM_SPACEWIRE_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_avalon_mm_spacewire_read_out;

	type t_avalon_mm_spacewire_write_in is record
		address    : std_logic_vector((c_AVALON_MM_SPACEWIRE_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_AVALON_MM_SPACEWIRE_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_AVALON_MM_SPACEWIRE_DATA_SIZE / c_AVALON_MM_SPACEWIRE_SYMBOL_SIZE) - 1) downto 0);
	end record t_avalon_mm_spacewire_write_in;

	type t_avalon_mm_spacewire_write_out is record
		waitrequest : std_logic;
	end record t_avalon_mm_spacewire_write_out;

	constant c_AVALON_MM_SPACEWIRE_READ_IN_RST : t_avalon_mm_spacewire_read_in := (
		address    => (others => '0'),
		read       => '0',
		byteenable => (others => '0')
	);

	constant c_AVALON_MM_SPACEWIRE_READ_OUT_RST : t_avalon_mm_spacewire_read_out := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_AVALON_MM_SPACEWIRE_WRITE_IN_RST : t_avalon_mm_spacewire_write_in := (
		address    => (others => '0'),
		write      => '0',
		writedata  => (others => '0'),
		byteenable => (others => '0')
	);

	constant c_AVALON_MM_SPACEWIRE_WRITE_OUT_RST : t_avalon_mm_spacewire_write_out := (
		waitrequest => '1'
	);
	
end package avalon_mm_spacewire_pkg;
