library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package srme_tb_avs_pkg is

	constant c_NRME_TB_AVS_AVALON_MM_ADRESS_SIZE : natural := 64;
	constant c_NRME_TB_AVS_AVALON_MM_DATA_SIZE   : natural := 8;
	constant c_NRME_TB_AVS_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_srme_tb_avs_avalon_mm_address is unsigned((c_NRME_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);

	type t_srme_tb_avs_avalon_mm_read_in is record
		address    : std_logic_vector((c_NRME_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_NRME_TB_AVS_AVALON_MM_DATA_SIZE / c_NRME_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_srme_tb_avs_avalon_mm_read_in;

	type t_srme_tb_avs_avalon_mm_read_out is record
		readdata    : std_logic_vector((c_NRME_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_srme_tb_avs_avalon_mm_read_out;

	type t_srme_tb_avs_avalon_mm_write_in is record
		address    : std_logic_vector((c_NRME_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_NRME_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_NRME_TB_AVS_AVALON_MM_DATA_SIZE / c_NRME_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_srme_tb_avs_avalon_mm_write_in;

	type t_srme_tb_avs_avalon_mm_write_out is record
		waitrequest : std_logic;
	end record t_srme_tb_avs_avalon_mm_write_out;

end package srme_tb_avs_pkg;
