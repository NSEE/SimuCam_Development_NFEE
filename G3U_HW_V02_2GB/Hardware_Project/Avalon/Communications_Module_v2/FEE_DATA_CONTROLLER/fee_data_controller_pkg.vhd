library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fee_data_controller_pkg is

	-- send buffer overflow enable ccontants
	constant c_SEND_BUFFER_OVERFLOW_ENABLE  : std_logic := '0'; -- '0': send buffer does not overflow / '1': send buffer overflow
	constant c_MASKING_FIFO_OVERFLOW_ENABLE : std_logic := '0'; -- '0': masking fifo does not overflow / '1': masking fifo overflow 

	-- data packet mode constants
	constant c_DPKT_OFF_MODE                       : std_logic_vector(4 downto 0) := "00000"; -- d0 : N-FEE Off Mode
	constant c_DPKT_ON_MODE                        : std_logic_vector(4 downto 0) := "00001"; -- d1 : N-FEE On Mode
	constant c_DPKT_FULLIMAGE_PATTERN_MODE         : std_logic_vector(4 downto 0) := "00010"; -- d2 : N-FEE Full-Image Pattern Mode
	constant c_DPKT_WINDOWING_PATTERN_MODE         : std_logic_vector(4 downto 0) := "00011"; -- d3 : N-FEE Windowing Pattern Mode
	constant c_DPKT_STANDBY_MODE                   : std_logic_vector(4 downto 0) := "00100"; -- d4 : N-FEE Standby Mode
	constant c_DPKT_FULLIMAGE_MODE_PATTERN_MODE    : std_logic_vector(4 downto 0) := "00101"; -- d5 : N-FEE Full-Image Mode / Pattern Mode
	constant c_DPKT_FULLIMAGE_MODE_SSD_MODE        : std_logic_vector(4 downto 0) := "00110"; -- d6 : N-FEE Full-Image Mode / SSD Mode
	constant c_DPKT_WINDOWING_MODE_PATTERN_MODE    : std_logic_vector(4 downto 0) := "00111"; -- d7 : N-FEE Windowing Mode / Pattern Mode
	constant c_DPKT_WINDOWING_MODE_SSDIMG_MODE     : std_logic_vector(4 downto 0) := "01000"; -- d8 : N-FEE Windowing Mode / SSD Image Mode
	constant c_DPKT_WINDOWING_MODE_SSDWIN_MODE     : std_logic_vector(4 downto 0) := "01001"; -- d9 : N-FEE Windowing Mode / SSD Window Mode
	constant c_DPKT_PERFORMANCE_TEST_MODE          : std_logic_vector(4 downto 0) := "01010"; -- d10: N-FEE Performance Test Mode
	constant c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE : std_logic_vector(4 downto 0) := "01011"; -- d11: N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode
	constant c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE : std_logic_vector(4 downto 0) := "01100"; -- d12: N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode
	constant c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE : std_logic_vector(4 downto 0) := "01101"; -- d13: N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode
	constant c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE : std_logic_vector(4 downto 0) := "01110"; -- d14: N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode
	constant c_DPKT_SER_TRAP_PUMP_1_MODE           : std_logic_vector(4 downto 0) := "01111"; -- d15: N-FEE Serial Trap Pumping 1 Mode
	constant c_DPKT_SER_TRAP_PUMP_2_MODE           : std_logic_vector(4 downto 0) := "10000"; -- d16: N-FEE Serial Trap Pumping 2 Mode

	-- fee mode id constants
	constant c_FEE_ID_NONE                       : std_logic_vector(3 downto 0) := "1111";
	constant c_FEE_ID_ON_MODE                    : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(0, 4)); -- Mode ID 0
	constant c_FEE_ID_FULLIMAGE_PATTERN_MODE     : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(1, 4)); -- Mode ID 1
	constant c_FEE_ID_WINDOWING_PATTERN_MODE     : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(2, 4)); -- Mode ID 2
	constant c_FEE_ID_STANDBY_MODE               : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(4, 4)); -- Mode ID 4
	constant c_FEE_ID_FULLIMAGE_MODE             : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(5, 4)); -- Mode ID 5
	constant c_FEE_ID_WINDOWING_MODE             : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(6, 4)); -- Mode ID 6
	constant c_FEE_ID_PERFORMANCE_TEST_MODE      : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(7, 4)); -- Mode ID 7
	constant c_FEE_ID_PARALLEL_TRAP_PUMPING_MODE : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(9, 4)); -- Mode ID 9
	constant c_FEE_ID_SERIAL_TRAP_PUMPING_MODE   : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(11, 4)); -- Mode ID 11

	-- fee data packet header data --
	-- data packet header size [bytes]
	constant c_DATA_PKT_HEADER_SIZE    : natural                       := 10;
	-- hk packet data size [bytes]
	constant c_HK_PKT_DATA_SIZE        : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(144, 16));
	-- type field, mode bits
	constant c_FULL_IMAGE_MODE         : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(0, 3));
	constant c_FULL_IMAGE_PATTERN_MODE : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(1, 3));
	constant c_WINDOWING_MODE          : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(2, 3));
	constant c_WINDOWING_PATTERN_MODE  : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(3, 3));
	constant c_PARTIAL_READ_OUT_MODE   : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(4, 3));
	-- type field, packet type bits
	constant c_DATA_PACKET             : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(0, 2));
	constant c_OVERSCAN_DATA           : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(1, 2));
	constant c_HOUSEKEEPING_PACKET     : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(2, 2));
	constant c_INVALID_PACKET          : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(3, 2));

	-- ccd side constants
	constant c_CCD_LEFT_SIDE  : std_logic := '0';
	constant c_CCD_RIGHT_SIDE : std_logic := '1';

	-- packet order constants
	constant c_PKTORDER_LEFT_PACKET  : std_logic := '1';
	constant c_PKTORDER_RIGHT_PACKET : std_logic := '0';

	-- fee data packet headerdata type field record
	type t_fee_dpkt_headerdata_type_field is record
		mode         : std_logic_vector(3 downto 0);
		last_packet  : std_logic;
		ccd_side     : std_logic;
		ccd_number   : std_logic_vector(1 downto 0);
		frame_number : std_logic_vector(1 downto 0);
		packet_type  : std_logic_vector(1 downto 0);
	end record t_fee_dpkt_headerdata_type_field;

	-- fee data packet headerdata record
	type t_fee_dpkt_headerdata is record
		logical_address  : std_logic_vector(7 downto 0);
		protocol_id      : std_logic_vector(7 downto 0);
		length_field     : std_logic_vector(15 downto 0);
		type_field       : t_fee_dpkt_headerdata_type_field;
		frame_counter    : std_logic_vector(15 downto 0);
		sequence_counter : std_logic_vector(15 downto 0);
	end record t_fee_dpkt_headerdata;

	-- fee data packet general control record
	type t_fee_dpkt_general_control is record
		start : std_logic;
		reset : std_logic;
	end record t_fee_dpkt_general_control;

	-- fee data packet general status record
	type t_fee_dpkt_general_status is record
		finished : std_logic;
	end record t_fee_dpkt_general_status;

	-- fee data packet image parameters record
	type t_fee_dpkt_image_params is record
		logical_addr    : std_logic_vector(7 downto 0);
		protocol_id     : std_logic_vector(7 downto 0);
		ccd_x_size      : std_logic_vector(15 downto 0);
		ccd_y_size      : std_logic_vector(15 downto 0);
		data_y_size     : std_logic_vector(15 downto 0);
		overscan_y_size : std_logic_vector(15 downto 0);
		packet_length   : std_logic_vector(15 downto 0);
		fee_mode        : std_logic_vector(3 downto 0);
		ccd_number      : std_logic_vector(1 downto 0);
		ccd_v_start     : std_logic_vector(15 downto 0);
		ccd_v_end       : std_logic_vector(15 downto 0);
		start_delay     : std_logic_vector(31 downto 0);
		line_delay      : std_logic_vector(31 downto 0);
		skip_delay      : std_logic_vector(31 downto 0);
		adc_delay       : std_logic_vector(31 downto 0);
	end record t_fee_dpkt_image_params;

	-- fee data packet send buffer control record
	type t_fee_dpkt_send_buffer_control is record
		rdreq  : std_logic;
		change : std_logic;
	end record t_fee_dpkt_send_buffer_control;

	-- fee data packet send buffer status record
	type t_fee_dpkt_send_buffer_status is record
		stat_empty          : std_logic;
		stat_extended_usedw : std_logic_vector(15 downto 0);
		rddata              : std_logic_vector(7 downto 0);
		rdready             : std_logic;
	end record t_fee_dpkt_send_buffer_status;

	-- fee data packet transmission parameters record
	type t_fee_dpkt_transmission_params is record
		digitalise_en : std_logic;
		windowing_en  : std_logic;
		pattern_en    : std_logic;
	end record t_fee_dpkt_transmission_params;

	-- fee data packet error injection parameters record
	type t_fee_dpkt_errinj_params is record
		tx_disabled  : std_logic;
		missing_pkts : std_logic;
		missing_data : std_logic;
		frame_num    : std_logic_vector(1 downto 0);
		sequence_cnt : std_logic_vector(15 downto 0);
		data_cnt     : std_logic_vector(15 downto 0);
		n_repeat     : std_logic_vector(15 downto 0);
	end record t_fee_dpkt_errinj_params;

	-- fee windowing parameters record
	type t_fee_windowing_params is record
		packet_order_list : std_logic_vector(511 downto 0);
		last_left_packet  : std_logic_vector(9 downto 0);
		last_right_packet : std_logic_vector(9 downto 0);
	end record t_fee_windowing_params;

	-- fee data packet registered parameters record
	type t_fee_dpkt_registered_params is record
		image           : t_fee_dpkt_image_params;
		transmission    : t_fee_dpkt_transmission_params;
		error_injection : t_fee_dpkt_errinj_params;
		windowing       : t_fee_windowing_params;
	end record t_fee_dpkt_registered_params;

end package fee_data_controller_pkg;

package body fee_data_controller_pkg is

end package body fee_data_controller_pkg;
