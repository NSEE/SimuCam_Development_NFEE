library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cbuf_tb_avs_pkg is

	constant c_CBUF_TB_AVS_AVALON_MM_ADRESS_SIZE : natural := 64;
	constant c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE   : natural := 16;
	constant c_CBUF_TB_AVS_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_cbuf_tb_avs_avalon_mm_address is unsigned((c_CBUF_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);

	type t_cbuf_tb_avs_avalon_mm_read_in is record
		address    : std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE / c_CBUF_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_cbuf_tb_avs_avalon_mm_read_in;

	type t_cbuf_tb_avs_avalon_mm_read_out is record
		readdata    : std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_cbuf_tb_avs_avalon_mm_read_out;

	type t_cbuf_tb_avs_avalon_mm_write_in is record
		address    : std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE / c_CBUF_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_cbuf_tb_avs_avalon_mm_write_in;

	type t_cbuf_tb_avs_avalon_mm_write_out is record
		waitrequest : std_logic;
	end record t_cbuf_tb_avs_avalon_mm_write_out;

	----

	type t_cbuf_tb_avs_memory_area is array (0 to 15) of std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
	constant c_CBUF_TB_AVS_MEMORY_RST : std_logic_vector((c_CBUF_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0) := (others => '1');

end package cbuf_tb_avs_pkg;
