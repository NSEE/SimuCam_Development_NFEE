library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_protocol_pkg is

	constant c_FTDI_PROT_HEADER_SIZE : natural := 8;

	constant c_FTDI_PROT_START_OF_PACKAGE : std_logic_vector(31 downto 0) := x"55555555";
	constant c_FTDI_PROT_END_OF_HEADER    : std_logic_vector(31 downto 0) := x"33333333";
	constant c_FTDI_PROT_START_OF_PAYLOAD : std_logic_vector(31 downto 0) := x"99999999";
	constant c_FTDI_PROT_END_OF_PAYLOAD   : std_logic_vector(31 downto 0) := x"77777777";

	constant c_FTDI_PROT_PKG_ID_HALF_CCD_REQUEST : std_logic_vector(31 downto 0) := x"01010101";
	constant c_FTDI_PROT_PKG_ID_HALF_CCD_REPLY   : std_logic_vector(31 downto 0) := x"02020202";
	constant c_FTDI_PROT_PKG_ID_LUT_TRANSMISSION : std_logic_vector(31 downto 0) := x"03030303";
	constant c_FTDI_PROT_PKG_ID_NACK_ERROR       : std_logic_vector(31 downto 0) := x"10101010";
	constant c_FTDI_PROT_PKG_ID_ACK_OK           : std_logic_vector(31 downto 0) := x"20202020";
	constant c_FTDI_PROT_PKG_ID_WRONG_IMG_SIZE   : std_logic_vector(31 downto 0) := x"30303030";

	constant c_FTDI_PROT_PACKAGE_ID_SIZE : natural := 32;

	constant c_FTDI_PROT_IMG_SEL_FEE_NUMBER_MAX : natural   := 5; -- range: 0 to 5
	constant c_FTDI_PROT_IMG_SEL_CCD_NUMBER_MAX : natural   := 3; -- range: 0 to 3
	constant c_FTDI_PROT_IMG_SEL_CCD_SIDE_LEFT  : std_logic := '0';
	constant c_FTDI_PROT_IMG_SEL_CCD_SIDE_RIGHT : std_logic := '1';

	constant c_FTDI_PROT_IMG_SEL_FEE_NUMBER_SIZE : natural := 3;
	constant c_FTDI_PROT_IMG_SEL_CCD_NUMBER_SIZE : natural := 2;

	constant c_FTDI_PROT_IMG_SIZE_CCD_HEIGHT_MAX : positive := 4540; -- range: 1 to 4540
	constant c_FTDI_PROT_IMG_SIZE_CCD_WIDTH_MAX  : positive := 2295; -- range: 1 to 2295

	constant c_FTDI_PROT_IMG_SIZE_CCD_HEIGHT_SIZE : natural := 13;
	constant c_FTDI_PROT_IMG_SIZE_CCD_WIDTH_SIZE  : natural := 12;

	constant c_FTDI_PROT_EXPOSURE_NUMBER_MAX : natural := 65535; -- range: 0 to 65535

	constant c_FTDI_PROT_EXPOSURE_NUMBER_SIZE : natural := 16;
	constant c_FTDI_PROT_PAYLOAD_LENGTH_SIZE  : natural := 32;

	constant c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET : natural := 256;
	constant c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET : natural := 320;
	constant c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET : natural := 384;
	constant c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET : natural := 448;

	constant c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_PRT_OFFSET       : natural := 0;
	constant c_FTDI_LUT_WINPARAMS_CCDx_PKT_ORDER_LIST_PRT_OFFSET : natural := 4;
	constant c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_LENGTH_OFFSET    : natural := 8;
	constant c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_X_OFFSET        : natural := 12;
	constant c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_Y_OFFSET        : natural := 16;
	constant c_FTDI_LUT_WINPARAMS_CCDx_LAST_E_PKT_OFFSET         : natural := 20;
	constant c_FTDI_LUT_WINPARAMS_CCDx_LAST_F_PKT_OFFSET         : natural := 24;

	type t_ftdi_prot_header_img_sel is record
		fee_number : std_logic_vector((c_FTDI_PROT_IMG_SEL_FEE_NUMBER_SIZE - 1) downto 0);
		ccd_number : std_logic_vector((c_FTDI_PROT_IMG_SEL_CCD_NUMBER_SIZE - 1) downto 0);
		ccd_side   : std_logic;
	end record t_ftdi_prot_header_img_sel;

	type t_ftdi_prot_header_img_size is record
		ccd_height : std_logic_vector((c_FTDI_PROT_IMG_SIZE_CCD_HEIGHT_SIZE - 1) downto 0);
		ccd_width  : std_logic_vector((c_FTDI_PROT_IMG_SIZE_CCD_WIDTH_SIZE - 1) downto 0);
	end record t_ftdi_prot_header_img_size;

	type t_ftdi_prot_header_fields is record
		package_id      : std_logic_vector((c_FTDI_PROT_PACKAGE_ID_SIZE - 1) downto 0);
		image_selection : t_ftdi_prot_header_img_sel;
		image_size      : t_ftdi_prot_header_img_size;
		exposure_number : std_logic_vector((c_FTDI_PROT_EXPOSURE_NUMBER_SIZE - 1) downto 0);
		payload_length  : std_logic_vector((c_FTDI_PROT_PAYLOAD_LENGTH_SIZE - 1) downto 0);
	end record t_ftdi_prot_header_fields;

	type t_ftdi_prot_halfccd_req_config is record
		image_selection : t_ftdi_prot_header_img_sel;
		image_size      : t_ftdi_prot_header_img_size;
		exposure_number : std_logic_vector((c_FTDI_PROT_EXPOSURE_NUMBER_SIZE - 1) downto 0);
		payload_length  : std_logic_vector((c_FTDI_PROT_PAYLOAD_LENGTH_SIZE - 1) downto 0);
	end record t_ftdi_prot_halfccd_req_config;

	constant c_FTDI_PROT_HEADER_IMG_SEL_RESET : t_ftdi_prot_header_img_sel := (
		fee_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SEL_FEE_NUMBER_SIZE)),
		ccd_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SEL_CCD_NUMBER_SIZE)),
		ccd_side   => '0'
	);

	constant c_FTDI_PROT_HEADER_IMG_SIZE_RESET : t_ftdi_prot_header_img_size := (
		ccd_height => std_logic_vector(to_unsigned(1, c_FTDI_PROT_IMG_SIZE_CCD_HEIGHT_SIZE)),
		ccd_width  => std_logic_vector(to_unsigned(1, c_FTDI_PROT_IMG_SIZE_CCD_WIDTH_SIZE))
	);

	constant c_FTDI_PROT_HEADER_RESET : t_ftdi_prot_header_fields := (
		package_id      => x"00000000",
		image_selection => c_FTDI_PROT_HEADER_IMG_SEL_RESET,
		image_size      => c_FTDI_PROT_HEADER_IMG_SIZE_RESET,
		exposure_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_EXPOSURE_NUMBER_SIZE)),
		payload_length  => std_logic_vector(to_unsigned(0, c_FTDI_PROT_PAYLOAD_LENGTH_SIZE))
	);

	constant c_FTDI_PROT_HEADER_IMG_SEL_ACK_NACK : t_ftdi_prot_header_img_sel := (
		fee_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SEL_FEE_NUMBER_SIZE)),
		ccd_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SEL_CCD_NUMBER_SIZE)),
		ccd_side   => '0'
	);

	constant c_FTDI_PROT_HEADER_IMG_SIZE_ACK_NACK : t_ftdi_prot_header_img_size := (
		ccd_height => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SIZE_CCD_HEIGHT_SIZE)),
		ccd_width  => std_logic_vector(to_unsigned(0, c_FTDI_PROT_IMG_SIZE_CCD_WIDTH_SIZE))
	);

	constant c_FTDI_PROT_HEADER_ACK_OK : t_ftdi_prot_header_fields := (
		package_id      => c_FTDI_PROT_PKG_ID_ACK_OK,
		image_selection => c_FTDI_PROT_HEADER_IMG_SEL_ACK_NACK,
		image_size      => c_FTDI_PROT_HEADER_IMG_SIZE_ACK_NACK,
		exposure_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_EXPOSURE_NUMBER_SIZE)),
		payload_length  => std_logic_vector(to_unsigned(0, c_FTDI_PROT_PAYLOAD_LENGTH_SIZE))
	);

	constant c_FTDI_PROT_HEADER_NACK_ERROR : t_ftdi_prot_header_fields := (
		package_id      => c_FTDI_PROT_PKG_ID_NACK_ERROR,
		image_selection => c_FTDI_PROT_HEADER_IMG_SEL_ACK_NACK,
		image_size      => c_FTDI_PROT_HEADER_IMG_SIZE_ACK_NACK,
		exposure_number => std_logic_vector(to_unsigned(0, c_FTDI_PROT_EXPOSURE_NUMBER_SIZE)),
		payload_length  => std_logic_vector(to_unsigned(0, c_FTDI_PROT_PAYLOAD_LENGTH_SIZE))
	);

	type t_ftdi_lut_winparams_ccdx_wincfg is record
		ccdx_window_list_pointer       : std_logic_vector(31 downto 0);
		ccdx_packet_order_list_pointer : std_logic_vector(31 downto 0);
		ccdx_window_list_length        : std_logic_vector(31 downto 0);
		ccdx_windows_size_x            : std_logic_vector(31 downto 0);
		ccdx_windows_size_y            : std_logic_vector(31 downto 0);
		ccdx_last_e_packet             : std_logic_vector(31 downto 0);
		ccdx_last_f_packet             : std_logic_vector(31 downto 0);
	end record t_ftdi_lut_winparams_ccdx_wincfg;

end package ftdi_protocol_pkg;

package body ftdi_protocol_pkg is

end package body ftdi_protocol_pkg;
