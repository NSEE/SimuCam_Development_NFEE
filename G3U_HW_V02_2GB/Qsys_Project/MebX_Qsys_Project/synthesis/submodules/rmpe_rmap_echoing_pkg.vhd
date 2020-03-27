library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rmpe_rmap_echoing_pkg is

	constant c_RMAP_FIFO_OVERFLOW_EN : std_logic := '0';
	
	constant c_RMAP_PACKAGE_ID_INCOMING : std_logic_vector(3 downto 0) := x"0";
	constant c_RMAP_PACKAGE_ID_OUTGOING : std_logic_vector(3 downto 0) := x"1";

	type t_rmpe_rmap_echoing_spw_fifo_control is record
		wrdata_flag : std_logic;
		wrdata_data : std_logic_vector(7 downto 0);
		wrreq       : std_logic;
	end record t_rmpe_rmap_echoing_spw_fifo_control;

	type t_rmpe_rmap_echoing_spw_fifo_status is record
		full : std_logic;
	end record t_rmpe_rmap_echoing_spw_fifo_status;

	type t_rmpe_rmap_echoing_rmap_fifo_control is record
		rdreq : std_logic;
	end record t_rmpe_rmap_echoing_rmap_fifo_control;

	type t_rmpe_rmap_echoing_rmap_fifo_status is record
		empty       : std_logic;
		rddata_flag : std_logic;
		rddata_data : std_logic_vector(7 downto 0);
	end record t_rmpe_rmap_echoing_rmap_fifo_status;

	type t_rmpe_rmap_echoing_spw_codec_control is record
		txwrite : std_logic;
		txflag  : std_logic;
		txdata  : std_logic_vector(7 downto 0);
	end record t_rmpe_rmap_echoing_spw_codec_control;

	type t_rmpe_rmap_echoing_spw_codec_status is record
		txrdy   : std_logic;
		txhalff : std_logic;
	end record t_rmpe_rmap_echoing_spw_codec_status;

end package rmpe_rmap_echoing_pkg;

package body rmpe_rmap_echoing_pkg is

end package body rmpe_rmap_echoing_pkg;
