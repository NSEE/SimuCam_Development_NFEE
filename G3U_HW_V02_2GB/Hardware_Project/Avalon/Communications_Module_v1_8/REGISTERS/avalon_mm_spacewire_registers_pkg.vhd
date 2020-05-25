library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_spacewire_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_SPACEWIRE_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_SPACEWIRE_MAX_ADDR : natural range 0 to 255 := 16#78#;

	-- Registers Types

	-- Comm Device Address Register
	type t_comm_comm_dev_addr_wr_reg is record
		comm_dev_base_addr : std_logic_vector(31 downto 0); -- Comm Device Base Address
	end record t_comm_comm_dev_addr_wr_reg;

	-- Comm IRQ Control Register
	type t_comm_comm_irq_control_wr_reg is record
		comm_global_irq_en : std_logic; -- Comm Global IRQ Enable
	end record t_comm_comm_irq_control_wr_reg;

	-- SpaceWire Device Address Register
	type t_comm_spw_dev_addr_wr_reg is record
		spw_dev_base_addr : std_logic_vector(31 downto 0); -- SpaceWire Device Base Address
	end record t_comm_spw_dev_addr_wr_reg;

	-- SpaceWire Link Config Register
	type t_comm_spw_link_config_wr_reg is record
		spw_lnkcfg_disconnect : std_logic; -- SpaceWire Link Config Disconnect
		spw_lnkcfg_linkstart  : std_logic; -- SpaceWire Link Config Linkstart
		spw_lnkcfg_autostart  : std_logic; -- SpaceWire Link Config Autostart
		spw_lnkcfg_txdivcnt   : std_logic_vector(7 downto 0); -- SpaceWire Link Config TxDivCnt
	end record t_comm_spw_link_config_wr_reg;

	-- SpaceWire Link Status Register
	type t_comm_spw_link_status_rd_reg is record
		spw_link_running    : std_logic; -- SpaceWire Link Running
		spw_link_connecting : std_logic; -- SpaceWire Link Connecting
		spw_link_started    : std_logic; -- SpaceWire Link Started
		spw_err_disconnect  : std_logic; -- SpaceWire Error Disconnect
		spw_err_parity      : std_logic; -- SpaceWire Error Parity
		spw_err_escape      : std_logic; -- SpaceWire Error Escape
		spw_err_credit      : std_logic; -- SpaceWire Error Credit
	end record t_comm_spw_link_status_rd_reg;

	-- SpaceWire Timecode Config Register
	type t_comm_spw_timecode_wr_reg is record
		timecode_clear : std_logic;     -- SpaceWire Timecode Clear
		timecode_en    : std_logic;     -- SpaceWire Timecode Enable
	end record t_comm_spw_timecode_wr_reg;

	-- SpaceWire Timecode Status Register
	type t_comm_spw_timecode_rd_reg is record
		timecode_time    : std_logic_vector(5 downto 0); -- SpaceWire Timecode Time
		timecode_control : std_logic_vector(1 downto 0); -- SpaceWire Timecode Control
	end record t_comm_spw_timecode_rd_reg;

	-- FEE Buffers Device Address Register
	type t_comm_fee_buffers_dev_addr_wr_reg is record
		fee_buffers_dev_base_addr : std_logic_vector(31 downto 0); -- FEE Buffers Device Base Address
	end record t_comm_fee_buffers_dev_addr_wr_reg;

	-- FEE Machine Config Register
	type t_comm_fee_machine_config_wr_reg is record
		fee_machine_clear      : std_logic; -- FEE Machine Clear
		fee_machine_stop       : std_logic; -- FEE Machine Stop
		fee_machine_start      : std_logic; -- FEE Machine Start
		fee_buffer_overflow_en : std_logic; -- FEE Buffer Overflow Enable
		fee_digitalise_en      : std_logic; -- FEE Digitalise Enable
		fee_readout_en         : std_logic; -- FEE Readout Enable
		fee_windowing_en       : std_logic; -- FEE Windowing Enable
		fee_statistics_clear   : std_logic; -- FEE Statistics Clear
	end record t_comm_fee_machine_config_wr_reg;

	-- FEE Machine Statistics Register
	type t_comm_fee_machine_statistics_rd_reg is record
		fee_incoming_pkts_cnt       : std_logic_vector(31 downto 0); -- FEE Incoming Packets Counter
		fee_incoming_bytes_cnt      : std_logic_vector(31 downto 0); -- FEE Incoming Bytes Counter
		fee_outgoing_pkts_cnt       : std_logic_vector(31 downto 0); -- FEE Outgoing Packets Counter
		fee_outgoing_bytes_cnt      : std_logic_vector(31 downto 0); -- FEE Outgoing Bytes Counter
		fee_spw_link_escape_err_cnt : std_logic_vector(31 downto 0); -- FEE SpW Link Escape Errors Counter
		fee_spw_link_credit_err_cnt : std_logic_vector(31 downto 0); -- FEE SpW Link Credit Errors Counter
		fee_spw_link_parity_err_cnt : std_logic_vector(31 downto 0); -- FEE SpW Link Parity Errors Counter
		fee_spw_link_disconnect_cnt : std_logic_vector(31 downto 0); -- FEE SpW Link Disconnects Counter
		fee_spw_eep_cnt             : std_logic_vector(31 downto 0); -- FEE SpaceWire EEPs Counter
	end record t_comm_fee_machine_statistics_rd_reg;

	-- FEE Buffers Config Register
	type t_comm_fee_buffers_config_wr_reg is record
		fee_right_buffer_size : std_logic_vector(3 downto 0); -- Windowing Right Buffer Size Config
		fee_left_buffer_size  : std_logic_vector(3 downto 0); -- Windowing Left Buffer Size Config
	end record t_comm_fee_buffers_config_wr_reg;

	-- FEE Buffers Status Register
	type t_comm_fee_buffers_status_rd_reg is record
		fee_right_buffer_empty : std_logic; -- Windowing Right Buffer Empty
		fee_left_buffer_empty  : std_logic; -- Windowing Left Buffer Empty
		fee_right_machine_busy : std_logic; -- FEE Right Machine Busy
		fee_left_machine_busy  : std_logic; -- FEE Left Machine Busy
	end record t_comm_fee_buffers_status_rd_reg;

	-- FEE Buffers IRQ Control Register
	type t_comm_fee_buffers_irq_control_wr_reg is record
		fee_right_buffer_empty_en : std_logic; -- FEE Right Buffer Empty IRQ Enable
		fee_left_buffer_empty_en  : std_logic; -- FEE Left Buffer Empty IRQ Enable
	end record t_comm_fee_buffers_irq_control_wr_reg;

	-- FEE Buffers IRQ Flags Register
	type t_comm_fee_buffers_irq_flags_rd_reg is record
		fee_right_buffer_0_empty_flag : std_logic; -- FEE Right Buffer 0 Empty IRQ Flag
		fee_right_buffer_1_empty_flag : std_logic; -- FEE Right Buffer 1 Empty IRQ Flag
		fee_left_buffer_0_empty_flag  : std_logic; -- FEE Left Buffer 0 Empty IRQ Flag
		fee_left_buffer_1_empty_flag  : std_logic; -- FEE Left Buffer 1 Empty IRQ Flag
	end record t_comm_fee_buffers_irq_flags_rd_reg;

	-- FEE Buffers IRQ Flags Clear Register
	type t_comm_fee_buffers_irq_flags_clear_wr_reg is record
		fee_right_buffer_0_empty_flag_clear : std_logic; -- FEE Right Buffer 0 Empty IRQ Flag Clear
		fee_right_buffer_1_empty_flag_clear : std_logic; -- FEE Right Buffer 1 Empty IRQ Flag Clear
		fee_left_buffer_0_empty_flag_clear  : std_logic; -- FEE Left Buffer 0 Empty IRQ Flag Clear
		fee_left_buffer_1_empty_flag_clear  : std_logic; -- FEE Left Buffer 1 Empty IRQ Flag Clear
	end record t_comm_fee_buffers_irq_flags_clear_wr_reg;

	-- FEE Buffers IRQ Number Register
	type t_comm_fee_buffers_number_rd_reg is record
		fee_buffers_irq_number : std_logic_vector(31 downto 0); -- FEE Buffers IRQ Number/ID
	end record t_comm_fee_buffers_number_rd_reg;

	-- RMAP Device Address Register
	type t_comm_rmap_dev_addr_wr_reg is record
		rmap_dev_base_addr : std_logic_vector(31 downto 0); -- RMAP Device Base Address
	end record t_comm_rmap_dev_addr_wr_reg;

	-- RMAP Echoing Mode Config Register
	type t_comm_rmap_echoing_mode_config_wr_reg is record
		rmap_echoing_mode_enable : std_logic; -- RMAP Echoing Mode Enable
		rmap_echoing_id_enable   : std_logic; -- RMAP Echoing ID Enable
	end record t_comm_rmap_echoing_mode_config_wr_reg;

	-- RMAP Codec Config Register
	type t_comm_rmap_codec_config_wr_reg is record
		rmap_target_logical_addr : std_logic_vector(7 downto 0); -- RMAP Target Logical Address
		rmap_target_key          : std_logic_vector(7 downto 0); -- RMAP Target Key
	end record t_comm_rmap_codec_config_wr_reg;

	-- RMAP Codec Status Register
	type t_comm_rmap_codec_status_rd_reg is record
		rmap_stat_command_received    : std_logic; -- RMAP Status Command Received
		rmap_stat_write_requested     : std_logic; -- RMAP Status Write Requested
		rmap_stat_write_authorized    : std_logic; -- RMAP Status Write Authorized
		rmap_stat_read_requested      : std_logic; -- RMAP Status Read Requested
		rmap_stat_read_authorized     : std_logic; -- RMAP Status Read Authorized
		rmap_stat_reply_sended        : std_logic; -- RMAP Status Reply Sended
		rmap_stat_discarded_package   : std_logic; -- RMAP Status Discarded Package
		rmap_err_early_eop            : std_logic; -- RMAP Error Early EOP
		rmap_err_eep                  : std_logic; -- RMAP Error EEP
		rmap_err_header_crc           : std_logic; -- RMAP Error Header CRC
		rmap_err_unused_packet_type   : std_logic; -- RMAP Error Unused Packet Type
		rmap_err_invalid_command_code : std_logic; -- RMAP Error Invalid Command Code
		rmap_err_too_much_data        : std_logic; -- RMAP Error Too Much Data
		rmap_err_invalid_data_crc     : std_logic; -- RMAP Error Invalid Data CRC
	end record t_comm_rmap_codec_status_rd_reg;

	-- RMAP Memory Status Register
	type t_comm_rmap_memory_status_rd_reg is record
		rmap_last_write_addr         : std_logic_vector(31 downto 0); -- RMAP Last Write Address
		rmap_last_write_length_bytes : std_logic_vector(31 downto 0); -- RMAP Last Write Length [Bytes]
		rmap_last_read_addr          : std_logic_vector(31 downto 0); -- RMAP Last Read Address
		rmap_last_read_length_bytes  : std_logic_vector(31 downto 0); -- RMAP Last Read Length [Bytes]
	end record t_comm_rmap_memory_status_rd_reg;

	-- RMAP Memory Config Register
	type t_comm_rmap_memory_config_wr_reg is record
		rmap_win_area_offset_high_dword : std_logic_vector(31 downto 0); -- RMAP Windowing Area Offset (High Dword)
		rmap_win_area_offset_low_dword  : std_logic_vector(31 downto 0); -- RMAP Windowing Area Offset (Low Dword)
	end record t_comm_rmap_memory_config_wr_reg;

	-- RMAP Memory Area Pointer Register
	type t_comm_rmap_mem_area_ptr_wr_reg is record
		rmap_mem_area_ptr : std_logic_vector(31 downto 0); -- RMAP Memory Area Pointer
	end record t_comm_rmap_mem_area_ptr_wr_reg;

	-- RMAP IRQ Control Register
	type t_comm_rmap_irq_control_wr_reg is record
		rmap_write_config_en : std_logic; -- RMAP Write Config IRQ Enable
		rmap_write_window_en : std_logic; -- RMAP Write Window IRQ Enable
	end record t_comm_rmap_irq_control_wr_reg;

	-- RMAP IRQ Flags Register
	type t_comm_rmap_irq_flags_rd_reg is record
		rmap_write_config_flag : std_logic; -- RMAP Write Config IRQ Flag
		rmap_write_window_flag : std_logic; -- RMAP Write Config IRQ Flag
	end record t_comm_rmap_irq_flags_rd_reg;

	-- RMAP IRQ Flags Clear Register
	type t_comm_rmap_irq_flags_clear_wr_reg is record
		rmap_write_config_flag_clear : std_logic; -- RMAP Write Config IRQ Flag Clear
		rmap_write_window_flag_clear : std_logic; -- RMAP Write Config IRQ Flag Clear
	end record t_comm_rmap_irq_flags_clear_wr_reg;

	-- RMAP IRQ Number Register
	type t_comm_rmap_irq_number_rd_reg is record
		rmap_irq_number : std_logic_vector(31 downto 0); -- RMAP IRQ Number/ID
	end record t_comm_rmap_irq_number_rd_reg;

	-- Data Packet Device Channel Address Register
	type t_comm_data_packet_dev_addr_wr_reg is record
		data_packet_dev_base_addr : std_logic_vector(31 downto 0); -- Data Packet Device Base Address
	end record t_comm_data_packet_dev_addr_wr_reg;

	-- Data Packet Config Register
	type t_comm_data_packet_config_wr_reg is record
		data_pkt_ccd_x_size      : std_logic_vector(15 downto 0); -- Data Packet CCD X Size
		data_pkt_ccd_y_size      : std_logic_vector(15 downto 0); -- Data Packet CCD Y Size
		data_pkt_data_y_size     : std_logic_vector(15 downto 0); -- Data Packet Data Y Size
		data_pkt_overscan_y_size : std_logic_vector(15 downto 0); -- Data Packet Overscan Y Size
		data_pkt_ccd_v_start     : std_logic_vector(15 downto 0); -- Data Packet CCD V-Start
		data_pkt_ccd_v_end       : std_logic_vector(15 downto 0); -- Data Packet CCD V-End
		data_pkt_packet_length   : std_logic_vector(15 downto 0); -- Data Packet Packet Length
		data_pkt_logical_addr    : std_logic_vector(7 downto 0); -- Data Packet Logical Address
		data_pkt_protocol_id     : std_logic_vector(7 downto 0); -- Data Packet Protocol ID
		data_pkt_fee_mode        : std_logic_vector(4 downto 0); -- Data Packet FEE Mode
		data_pkt_ccd_number      : std_logic_vector(1 downto 0); -- Data Packet CCD Number
	end record t_comm_data_packet_config_wr_reg;

	-- Data Packet Errors Register
	type t_comm_data_packet_errors_wr_reg is record
		data_pkt_invalid_ccd_mode : std_logic; -- Data Packet Invalid CCD Mode Error
	end record t_comm_data_packet_errors_wr_reg;

	-- Data Packet Header Register
	type t_comm_data_packet_header_rd_reg is record
		data_pkt_header_length           : std_logic_vector(15 downto 0); -- Data Packet Header Length
		data_pkt_header_type             : std_logic_vector(15 downto 0); -- Data Packet Header Type
		data_pkt_header_frame_counter    : std_logic_vector(15 downto 0); -- Data Packet Header Frame Counter
		data_pkt_header_sequence_counter : std_logic_vector(15 downto 0); -- Data Packet Header Sequence Counter
	end record t_comm_data_packet_header_rd_reg;

	-- Data Packet Pixel Delay Register
	type t_comm_data_packet_pixel_delay_wr_reg is record
		data_pkt_start_delay : std_logic_vector(31 downto 0); -- Data Packet Start Delay
		data_pkt_skip_delay  : std_logic_vector(31 downto 0); -- Data Packet Skip Delay
		data_pkt_line_delay  : std_logic_vector(31 downto 0); -- Data Packet Line Delay
		data_pkt_adc_delay   : std_logic_vector(31 downto 0); -- Data Packet ADC Delay
	end record t_comm_data_packet_pixel_delay_wr_reg;

	-- Error Injection Control Register
	type t_comm_error_injection_control_wr_reg is record
		errinj_tx_disabled  : std_logic; -- Error Injection Tx Disabled Enable
		errinj_missing_pkts : std_logic; -- Error Injection Missing Packets Enable
		errinj_missing_data : std_logic; -- Error Injection Missing Data Enable
		errinj_frame_num    : std_logic_vector(1 downto 0); -- Error Injection Frame Number of Error
		errinj_sequence_cnt : std_logic_vector(15 downto 0); -- Error Injection Sequence Counter of Error
		errinj_data_cnt     : std_logic_vector(15 downto 0); -- Error Injection Data Counter of Error
		errinj_n_repeat     : std_logic_vector(15 downto 0); -- Error Injection Number of Error Repeats
	end record t_comm_error_injection_control_wr_reg;

	-- Windowing Parameters Register
	type t_comm_windowing_parameters_wr_reg is record
		windowing_packet_order_list_15 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 15
		windowing_packet_order_list_14 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 14
		windowing_packet_order_list_13 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 13
		windowing_packet_order_list_12 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 12
		windowing_packet_order_list_11 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 11
		windowing_packet_order_list_10 : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 10
		windowing_packet_order_list_9  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 9
		windowing_packet_order_list_8  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 8
		windowing_packet_order_list_7  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 7
		windowing_packet_order_list_6  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 6
		windowing_packet_order_list_5  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 5
		windowing_packet_order_list_4  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 4
		windowing_packet_order_list_3  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 3
		windowing_packet_order_list_2  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 2
		windowing_packet_order_list_1  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 1
		windowing_packet_order_list_0  : std_logic_vector(31 downto 0); -- Windowing Packet Order List Dword 0
		windowing_last_e_packet        : std_logic_vector(9 downto 0); -- Windowing Last E Packet
		windowing_last_f_packet        : std_logic_vector(9 downto 0); -- Windowing Last F Packet
		windowing_x_coordinate_error   : std_logic; -- Windowing X-Coordinate Error
		windowing_y_coordinate_error   : std_logic; -- Windowing Y-Coordinate Error
	end record t_comm_windowing_parameters_wr_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_windowing_write_registers is record
		comm_dev_addr_reg               : t_comm_comm_dev_addr_wr_reg; -- Comm Device Address Register
		comm_irq_control_reg            : t_comm_comm_irq_control_wr_reg; -- Comm IRQ Control Register
		spw_dev_addr_reg                : t_comm_spw_dev_addr_wr_reg; -- SpaceWire Device Address Register
		spw_link_config_reg             : t_comm_spw_link_config_wr_reg; -- SpaceWire Link Config Register
		spw_timecode_config_reg         : t_comm_spw_timecode_wr_reg; -- SpaceWire Timecode Config Register
		fee_buffers_dev_addr_reg        : t_comm_fee_buffers_dev_addr_wr_reg; -- FEE Buffers Device Address Register
		fee_machine_config_reg          : t_comm_fee_machine_config_wr_reg; -- FEE Machine Config Register
		fee_buffers_config_reg          : t_comm_fee_buffers_config_wr_reg; -- FEE Buffers Config Register
		fee_buffers_irq_control_reg     : t_comm_fee_buffers_irq_control_wr_reg; -- FEE Buffers IRQ Control Register
		fee_buffers_irq_flags_clear_reg : t_comm_fee_buffers_irq_flags_clear_wr_reg; -- FEE Buffers IRQ Flags Clear Register
		rmap_dev_addr_reg               : t_comm_rmap_dev_addr_wr_reg; -- RMAP Device Address Register
		rmap_echoing_mode_config_reg    : t_comm_rmap_echoing_mode_config_wr_reg; -- RMAP Echoing Mode Config Register
		rmap_codec_config_reg           : t_comm_rmap_codec_config_wr_reg; -- RMAP Codec Config Register
		rmap_memory_config_reg          : t_comm_rmap_memory_config_wr_reg; -- RMAP Memory Config Register
		rmap_mem_area_ptr_reg           : t_comm_rmap_mem_area_ptr_wr_reg; -- RMAP Memory Area Pointer Register
		rmap_irq_control_reg            : t_comm_rmap_irq_control_wr_reg; -- RMAP IRQ Control Register
		rmap_irq_flags_clear_reg        : t_comm_rmap_irq_flags_clear_wr_reg; -- RMAP IRQ Flags Clear Register
		data_packet_dev_addr_reg        : t_comm_data_packet_dev_addr_wr_reg; -- Data Packet Device Channel Address Register
		data_packet_config_reg          : t_comm_data_packet_config_wr_reg; -- Data Packet Config Register
		data_packet_errors_reg          : t_comm_data_packet_errors_wr_reg; -- Data Packet Errors Register
		data_packet_pixel_delay_reg     : t_comm_data_packet_pixel_delay_wr_reg; -- Data Packet Pixel Delay Register
		error_injection_control_reg     : t_comm_error_injection_control_wr_reg; -- Error Injection Control Register
		windowing_parameters_reg        : t_comm_windowing_parameters_wr_reg; -- Windowing Parameters Register
	end record t_windowing_write_registers;

	-- Avalon MM Read-Only Registers
	type t_windowing_read_registers is record
		spw_link_status_reg        : t_comm_spw_link_status_rd_reg; -- SpaceWire Link Status Register
		spw_timecode_status_reg    : t_comm_spw_timecode_rd_reg; -- SpaceWire Timecode Status Register
		fee_machine_statistics_reg : t_comm_fee_machine_statistics_rd_reg; -- FEE Machine Statistics Register
		fee_buffers_status_reg     : t_comm_fee_buffers_status_rd_reg; -- FEE Buffers Status Register
		fee_buffers_irq_flags_reg  : t_comm_fee_buffers_irq_flags_rd_reg; -- FEE Buffers IRQ Flags Register
		fee_buffers_irq_number_reg : t_comm_fee_buffers_number_rd_reg; -- FEE Buffers IRQ Number Register
		rmap_codec_status_reg      : t_comm_rmap_codec_status_rd_reg; -- RMAP Codec Status Register
		rmap_memory_status_reg     : t_comm_rmap_memory_status_rd_reg; -- RMAP Memory Status Register
		rmap_irq_flags_reg         : t_comm_rmap_irq_flags_rd_reg; -- RMAP IRQ Flags Register
		rmap_irq_number_reg        : t_comm_rmap_irq_number_rd_reg; -- RMAP IRQ Number Register
		data_packet_header_reg     : t_comm_data_packet_header_rd_reg; -- Data Packet Header Register
	end record t_windowing_read_registers;

end package avalon_mm_spacewire_registers_pkg;

package body avalon_mm_spacewire_registers_pkg is

end package body avalon_mm_spacewire_registers_pkg;
