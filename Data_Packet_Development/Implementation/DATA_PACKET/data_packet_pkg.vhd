library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package data_packet_pkg is

	-- constants 

	constant c_DATA_PACKET_PROTOCOL : std_logic_vector(7 downto 0) := x"F1";

	-- general

	type t_data_packet_16b_field is array (0 to 1) of std_logic_vector(7 downto 0);

	type t_data_packet_headerdata is record
		logical_address  : std_logic_vector(7 downto 0);
		length_field     : t_data_packet_16b_field;
		type_field       : t_data_packet_16b_field;
		frame_counter    : t_data_packet_16b_field;
		sequence_counter : t_data_packet_16b_field;
	end record t_data_packet_headerdata;

	-- header unit

	type t_data_packet_header_control is record
		send_header  : std_logic;
		header_reset : std_logic;
	end record t_data_packet_header_control;

	type t_data_packet_header_flags is record
		header_finished : std_logic;
		header_busy     : std_logic;
	end record t_data_packet_header_flags;

	-- housekeeping unit

	type t_data_packet_housekeeping_control is record
		send_housekeeping  : std_logic;
		housekeeping_reset : std_logic;
	end record t_data_packet_housekeeping_control;

	type t_data_packet_housekeeping_flags is record
		housekeeping_finished : std_logic;
		housekeeping_error    : std_logic;
		housekeeping_busy     : std_logic;
	end record t_data_packet_housekeeping_flags;

	-- image unit

	type t_data_packet_image_control is record
		send_image  : std_logic;
		image_reset : std_logic;
	end record t_data_packet_image_control;

	type t_data_packet_image_flags is record
		image_finished : std_logic;
		image_error    : std_logic;
		image_busy     : std_logic;
	end record t_data_packet_image_flags;

	-- control unit

	type t_data_packet_control is record
		header_unit       : t_data_packet_header_control;
		housekeeping_unit : t_data_packet_housekeeping_control;
		image_unit        : t_data_packet_image_control;
	end record t_data_packet_control;

	type t_data_packet_flags is record
		header_unit       : t_data_packet_header_flags;
		housekeeping_unit : t_data_packet_housekeeping_flags;
		image_unit        : t_data_packet_image_flags;
	end record t_data_packet_flags;

	-- others

	-- spw

	constant c_EOP_VALUE : std_logic_vector(7 downto 0) := x"00";
	constant c_EEP_VALUE : std_logic_vector(7 downto 0) := x"01";

	type t_data_packet_spw_tx_control is record
		write : std_logic;
		flag  : std_logic;
		data  : std_logic_vector(7 downto 0);
	end record t_rmap_data_packet_tx_control;

	type t_data_packet_spw_tx_flag is record
		ready : std_logic;
		error : std_logic;
	end record t_data_packet_spw_tx_flag;

	type t_data_packet_spw_control is record
		transmitter : t_rmap_target_spw_tx_control;
	end record t_data_packet_spw_control;

	type t_data_packet_spw_flag is record
		transmitter : t_data_packet_spw_tx_flag;
	end record t_data_packet_spw_flag;

	-- housekeeping data

	type t_data_packet_hkdata is record
		temperature : std_logic_vector(7 downto 0);
		voltage     : std_logic_vector(7 downto 0);
		current     : std_logic_vector(7 downto 0);
	end record t_data_packet_hkdata;

	-- image data

	type t_data_packet_imgdata_rd_control is record
		read : std_logic;
	end record t_data_packet_imgdata_rd_control;

	type t_data_packet_imgdata_rd_flag is record
		valid : std_logic;
		data  : std_logic_vector(7 downto 0);
		error : std_logic;
	end record t_data_packet_imgdata_rd_flag;

	type t_data_packet_imgdata_control is record
		read : t_data_packet_imgdata_rd_control;
	end record t_data_packet_imgdata_control;

	type t_data_packet_imgdata_flag is record
		read : t_data_packet_imgdata_rd_flag;
	end record t_data_packet_imgdata_flag;

end package data_packet_pkg;

package body data_packet_pkg is

end package body data_packet_pkg;
