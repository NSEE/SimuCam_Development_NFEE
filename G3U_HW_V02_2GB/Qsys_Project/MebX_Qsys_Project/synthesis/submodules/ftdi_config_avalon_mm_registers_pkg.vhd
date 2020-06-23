library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_config_avalon_mm_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_CONFIG_MAX_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_CONFIG_MIN_ADDR : natural range 0 to 255 := 16#68#;

	-- Registers Types

	-- FTDI Module Control Register
	type t_ftdi_ftdi_module_control_wr_reg is record
		ftdi_module_start : std_logic;  -- Stop Module Operation
		ftdi_module_stop  : std_logic;  -- Start Module Operation
		ftdi_module_clear : std_logic;  -- Clear Module Memories
	end record t_ftdi_ftdi_module_control_wr_reg;

	-- FTDI IRQ Control Register
	type t_ftdi_ftdi_irq_control_wr_reg is record
		ftdi_global_irq_en : std_logic; -- FTDI Global IRQ Enable
	end record t_ftdi_ftdi_irq_control_wr_reg;

	-- FTDI Rx IRQ Control Register
	type t_ftdi_rx_irq_control_wr_reg is record
		rx_hccd_received_irq_en : std_logic; -- Rx Half-CCD Received IRQ Flag
		rx_hccd_comm_err_irq_en : std_logic; -- Rx Half-CCD Communication Error IRQ Enable
	end record t_ftdi_rx_irq_control_wr_reg;

	-- FTDI Rx IRQ Flag Register
	type t_ftdi_rx_irq_flag_rd_reg is record
		rx_hccd_received_irq_flag : std_logic; -- Rx Half-CCD Received IRQ Flag
		rx_hccd_comm_err_irq_flag : std_logic; -- Rx Half-CCD Communication Error IRQ Flag
	end record t_ftdi_rx_irq_flag_rd_reg;

	-- FTDI Rx IRQ Flag Clear Register
	type t_ftdi_rx_irq_flag_clear_wr_reg is record
		rx_hccd_received_irq_flag_clr : std_logic; -- Rx Half-CCD Received IRQ Flag Clear
		rx_hccd_comm_err_irq_flag_clr : std_logic; -- Rx Half-CCD Communication Error IRQ Flag Clear
	end record t_ftdi_rx_irq_flag_clear_wr_reg;

	-- FTDI Tx IRQ Control Register
	type t_ftdi_tx_irq_control_wr_reg is record
		tx_lut_finished_irq_en : std_logic; -- Tx LUT Finished Transmission IRQ Enable
		tx_lut_comm_err_irq_en : std_logic; -- Tx LUT Communication Error IRQ Enable
	end record t_ftdi_tx_irq_control_wr_reg;

	-- FTDI Tx IRQ Flag Register
	type t_ftdi_tx_irq_flag_rd_reg is record
		tx_lut_finished_irq_flag : std_logic; -- Tx LUT Finished Transmission IRQ Flag
		tx_lut_comm_err_irq_flag : std_logic; -- Tx LUT Communication Error IRQ Flag
	end record t_ftdi_tx_irq_flag_rd_reg;

	-- FTDI Tx IRQ Flag Clear Register
	type t_ftdi_tx_irq_flag_clear_wr_reg is record
		tx_lut_finished_irq_flag_clear : std_logic; -- Tx LUT Finished Transmission IRQ Flag Clear
		tx_lut_comm_err_irq_flag_clear : std_logic; -- Tx LUT Communication Error IRQ Flag Clear
	end record t_ftdi_tx_irq_flag_clear_wr_reg;

	-- FTDI Half-CCD Request Control Register
	type t_ftdi_hccd_req_control_wr_reg is record
		req_hccd_req_timeout      : std_logic_vector(15 downto 0); -- Half-CCD Request Timeout
		req_hccd_fee_number       : std_logic_vector(2 downto 0); -- Half-CCD FEE Number
		req_hccd_ccd_number       : std_logic_vector(1 downto 0); -- Half-CCD CCD Number
		req_hccd_ccd_side         : std_logic; -- Half-CCD CCD Side
		req_hccd_ccd_height       : std_logic_vector(12 downto 0); -- Half-CCD CCD Height
		req_hccd_ccd_width        : std_logic_vector(11 downto 0); -- Half-CCD CCD Width
		req_hccd_exposure_number  : std_logic_vector(15 downto 0); -- Half-CCD Exposure Number
		req_request_hccd          : std_logic; -- Request Half-CCD
		req_abort_hccd_req        : std_logic; -- Abort Half-CCD Request
		req_reset_hccd_controller : std_logic; -- Reset Half-CCD Controller
	end record t_ftdi_hccd_req_control_wr_reg;

	-- FTDI Half-CCD Reply Status Register
	type t_ftdi_hccd_reply_status_rd_reg is record
		rly_hccd_fee_number         : std_logic_vector(2 downto 0); -- Half-CCD FEE Number
		rly_hccd_ccd_number         : std_logic_vector(1 downto 0); -- Half-CCD CCD Number
		rly_hccd_ccd_side           : std_logic; -- Half-CCD CCD Side
		rly_hccd_ccd_height         : std_logic_vector(12 downto 0); -- Half-CCD CCD Height
		rly_hccd_ccd_width          : std_logic_vector(11 downto 0); -- Half-CCD CCD Width
		rly_hccd_exposure_number    : std_logic_vector(15 downto 0); -- Half-CCD Exposure Number
		rly_hccd_image_length_bytes : std_logic_vector(31 downto 0); -- Half-CCD Image Length [Bytes]
		rly_hccd_received           : std_logic; -- Half-CCD Received
		rly_hccd_controller_busy    : std_logic; -- Half-CCD Controller Busy
		rly_hccd_last_rx_buffer     : std_logic; -- Half-CCD Last Rx Buffer
	end record t_ftdi_hccd_reply_status_rd_reg;

	-- FTDI LUT Transmission Control Register
	type t_ftdi_lut_trans_control_wr_reg is record
		lut_fee_number         : std_logic_vector(2 downto 0); -- LUT FEE Number
		lut_ccd_number         : std_logic_vector(1 downto 0); -- LUT CCD Number
		lut_ccd_side           : std_logic; -- LUT CCD Side
		lut_ccd_height         : std_logic_vector(12 downto 0); -- LUT CCD Height
		lut_ccd_width          : std_logic_vector(11 downto 0); -- LUT CCD Width
		lut_exposure_number    : std_logic_vector(15 downto 0); -- LUT Exposure Number
		lut_length_bytes       : std_logic_vector(31 downto 0); -- LUT Length [Bytes]
		lut_trans_timeout      : std_logic_vector(15 downto 0); -- LUT Request Timeout
		lut_transmit           : std_logic; -- Transmit LUT
		lut_abort_transmission : std_logic; -- Abort LUT Transmission
		lut_reset_controller   : std_logic; -- Reset LUT Controller
	end record t_ftdi_lut_trans_control_wr_reg;

	-- FTDI LUT Transmission Status Register
	type t_ftdi_lut_trans_status_rd_reg is record
		lut_transmitted     : std_logic; -- LUT Transmitted
		lut_controller_busy : std_logic; -- LUT Controller Busy
	end record t_ftdi_lut_trans_status_rd_reg;

	-- FTDI Tx Data Control Register
	type t_ftdi_tx_data_control_wr_reg is record
		tx_rd_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Tx Initial Read Address [High Dword]
		tx_rd_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Tx Initial Read Address [Low Dword]
		tx_rd_data_length_bytes       : std_logic_vector(31 downto 0); -- Tx Read Data Length [Bytes]
		tx_rd_start                   : std_logic; -- Tx Data Read Start
		tx_rd_reset                   : std_logic; -- Tx Data Read Reset
	end record t_ftdi_tx_data_control_wr_reg;

	-- FTDI Tx Data Status Register
	type t_ftdi_tx_data_status_rd_reg is record
		tx_rd_busy : std_logic;         -- Tx Data Read Busy
	end record t_ftdi_tx_data_status_rd_reg;

	-- FTDI Rx Data Control Register
	type t_ftdi_rx_data_control_wr_reg is record
		rx_wr_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Rx Initial Write Address [High Dword]
		rx_wr_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Rx Initial Write Address [Low Dword]
		rx_wr_data_length_bytes       : std_logic_vector(31 downto 0); -- Rx Write Data Length [Bytes]
		rx_wr_start                   : std_logic; -- Rx Data Write Start
		rx_wr_reset                   : std_logic; -- Rx Data Write Reset
	end record t_ftdi_rx_data_control_wr_reg;

	-- FTDI Rx Data Status Register
	type t_ftdi_rx_data_status_rd_reg is record
		rx_wr_busy : std_logic;         -- Rx Data Write Busy
	end record t_ftdi_rx_data_status_rd_reg;

	-- FTDI LUT CCD1 Windowing Configuration
	type t_lut_ccd1_windowing_cfg_wr_reg is record
		ccd1_window_list_pointer       : std_logic_vector(31 downto 0); -- CCD1 Window List Pointer
		ccd1_packet_order_list_pointer : std_logic_vector(31 downto 0); -- CCD1 Packet Order List Pointer
		ccd1_window_list_length        : std_logic_vector(15 downto 0); -- CCD1 Window List Length
		ccd1_windows_size_x            : std_logic_vector(5 downto 0); -- CCD1 Windows Size X
		ccd1_windows_size_y            : std_logic_vector(5 downto 0); -- CCD1 Windows Size Y
		ccd1_last_e_packet             : std_logic_vector(9 downto 0); -- CCD1 Last E Packet
		ccd1_last_f_packet             : std_logic_vector(9 downto 0); -- CCD1 Last F Packet
	end record t_lut_ccd1_windowing_cfg_wr_reg;

	-- FTDI LUT CCD2 Windowing Configuration
	type t_lut_ccd2_windowing_cfg_wr_reg is record
		ccd2_window_list_pointer       : std_logic_vector(31 downto 0); -- CCD2 Window List Pointer
		ccd2_packet_order_list_pointer : std_logic_vector(31 downto 0); -- CCD2 Packet Order List Pointer
		ccd2_window_list_length        : std_logic_vector(15 downto 0); -- CCD2 Window List Length
		ccd2_windows_size_x            : std_logic_vector(5 downto 0); -- CCD2 Windows Size X
		ccd2_windows_size_y            : std_logic_vector(5 downto 0); -- CCD2 Windows Size Y
		ccd2_last_e_packet             : std_logic_vector(9 downto 0); -- CCD2 Last E Packet
		ccd2_last_f_packet             : std_logic_vector(9 downto 0); -- CCD2 Last F Packet
	end record t_lut_ccd2_windowing_cfg_wr_reg;

	-- FTDI LUT CCD3 Windowing Configuration
	type t_lut_ccd3_windowing_cfg_wr_reg is record
		ccd3_window_list_pointer       : std_logic_vector(31 downto 0); -- CCD3 Window List Pointer
		ccd3_packet_order_list_pointer : std_logic_vector(31 downto 0); -- CCD3 Packet Order List Pointer
		ccd3_window_list_length        : std_logic_vector(15 downto 0); -- CCD3 Window List Length
		ccd3_windows_size_x            : std_logic_vector(5 downto 0); -- CCD3 Windows Size X
		ccd3_windows_size_y            : std_logic_vector(5 downto 0); -- CCD3 Windows Size Y
		ccd3_last_e_packet             : std_logic_vector(9 downto 0); -- CCD3 Last E Packet
		ccd3_last_f_packet             : std_logic_vector(9 downto 0); -- CCD3 Last F Packet
	end record t_lut_ccd3_windowing_cfg_wr_reg;

	-- FTDI LUT CCD4 Windowing Configuration
	type t_lut_ccd4_windowing_cfg_wr_reg is record
		ccd4_window_list_pointer       : std_logic_vector(31 downto 0); -- CCD4 Window List Pointer
		ccd4_packet_order_list_pointer : std_logic_vector(31 downto 0); -- CCD4 Packet Order List Pointer
		ccd4_window_list_length        : std_logic_vector(15 downto 0); -- CCD4 Window List Length
		ccd4_windows_size_x            : std_logic_vector(5 downto 0); -- CCD4 Windows Size X
		ccd4_windows_size_y            : std_logic_vector(5 downto 0); -- CCD4 Windows Size Y
		ccd4_last_e_packet             : std_logic_vector(9 downto 0); -- CCD4 Last E Packet
		ccd4_last_f_packet             : std_logic_vector(9 downto 0); -- CCD4 Last F Packet
	end record t_lut_ccd4_windowing_cfg_wr_reg;

	-- FTDI Rx Communication Error Register
	type t_ftdi_rx_comm_error_rd_reg is record
		rx_comm_err_state              : std_logic; -- Rx Communication Error State
		rx_comm_err_code               : std_logic_vector(15 downto 0); -- Rx Communication Error Code
		err_hccd_req_nack_err          : std_logic; -- Half-CCD Request Nack Error
		err_hccd_reply_header_crc_err  : std_logic; -- Half-CCD Reply Wrong Header CRC Error
		err_hccd_reply_eoh_err         : std_logic; -- Half-CCD Reply End of Header Error
		err_hccd_reply_payload_crc_err : std_logic; -- Half-CCD Reply Wrong Payload CRC Error
		err_hccd_reply_eop_err         : std_logic; -- Half-CCD Reply End of Payload Error
		err_hccd_req_max_tries_err     : std_logic; -- Half-CCD Request Maximum Tries Error
		err_hccd_reply_ccd_size_err    : std_logic; -- Half-CCD Request CCD Size Error
		err_hccd_req_timeout_err       : std_logic; -- Half-CCD Request Timeout Error
	end record t_ftdi_rx_comm_error_rd_reg;

	-- FTDI Tx LUT Communication Error Register
	type t_ftdi_tx_comm_error_rd_reg is record
		tx_lut_comm_err_state   : std_logic; -- Tx LUT Communication Error State
		tx_lut_comm_err_code    : std_logic_vector(15 downto 0); -- Tx LUT Communication Error Code
		err_lut_transmit_nack   : std_logic; -- LUT Transmit NACK Error
		err_lut_reply_head_crc  : std_logic; -- LUT Reply Wrong Header CRC Error
		err_lut_reply_head_eoh  : std_logic; -- LUT Reply End of Header Error
		err_lut_trans_max_tries : std_logic; -- LUT Transmission Maximum Tries Error
		err_lut_payload_nack    : std_logic; -- LUT Payload NACK Error
		err_lut_trans_timeout   : std_logic; -- LUT Transmission Timeout Error
	end record t_ftdi_tx_comm_error_rd_reg;

	-- FTDI Rx Buffer Status Register
	type t_ftdi_rx_buffer_status_rd_reg is record
		rx_buffer_rdable     : std_logic; -- Rx Buffer Readable
		rx_buffer_empty      : std_logic; -- Rx Buffer Empty
		rx_buffer_used_bytes : std_logic_vector(15 downto 0); -- Rx Buffer Used [Bytes]
		rx_buffer_full       : std_logic; -- Rx Buffer Full
	end record t_ftdi_rx_buffer_status_rd_reg;

	-- FTDI Tx Buffer Status Register
	type t_ftdi_tx_buffer_status_rd_reg is record
		tx_buffer_wrable     : std_logic; -- Tx Buffer Writeable
		tx_buffer_empty      : std_logic; -- Tx Buffer Empty
		tx_buffer_used_bytes : std_logic_vector(15 downto 0); -- Tx Buffer Used [Bytes]
		tx_buffer_full       : std_logic; -- Tx Buffer Full
	end record t_ftdi_tx_buffer_status_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_ftdi_config_wr_registers is record
		ftdi_module_control_reg    : t_ftdi_ftdi_module_control_wr_reg; -- FTDI Module Control Register
		ftdi_irq_control_reg       : t_ftdi_ftdi_irq_control_wr_reg; -- FTDI IRQ Control Register
		rx_irq_control_reg         : t_ftdi_rx_irq_control_wr_reg; -- FTDI Rx IRQ Control Register
		rx_irq_flag_clear_reg      : t_ftdi_rx_irq_flag_clear_wr_reg; -- FTDI Rx IRQ Flag Clear Register
		tx_irq_control_reg         : t_ftdi_tx_irq_control_wr_reg; -- FTDI Tx IRQ Control Register
		tx_irq_flag_clear_reg      : t_ftdi_tx_irq_flag_clear_wr_reg; -- FTDI Tx IRQ Flag Clear Register
		hccd_req_control_reg       : t_ftdi_hccd_req_control_wr_reg; -- FTDI Half-CCD Request Control Register
		lut_trans_control_reg      : t_ftdi_lut_trans_control_wr_reg; -- FTDI LUT Transmission Control Register
		tx_data_control_reg        : t_ftdi_tx_data_control_wr_reg; -- FTDI Tx Data Control Register
		rx_data_control_reg        : t_ftdi_rx_data_control_wr_reg; -- FTDI Rx Data Control Register
		lut_ccd1_windowing_cfg_reg : t_lut_ccd1_windowing_cfg_wr_reg; -- FTDI LUT CCD1 Windowing Configuration
		lut_ccd2_windowing_cfg_reg : t_lut_ccd2_windowing_cfg_wr_reg; -- FTDI LUT CCD2 Windowing Configuration
		lut_ccd3_windowing_cfg_reg : t_lut_ccd3_windowing_cfg_wr_reg; -- FTDI LUT CCD3 Windowing Configuration
		lut_ccd4_windowing_cfg_reg : t_lut_ccd4_windowing_cfg_wr_reg; -- FTDI LUT CCD4 Windowing Configuration
	end record t_ftdi_config_wr_registers;

	-- Avalon MM Read-Only Registers
	type t_ftdi_config_rd_registers is record
		rx_irq_flag_reg       : t_ftdi_rx_irq_flag_rd_reg; -- FTDI Rx IRQ Flag Register
		tx_irq_flag_reg       : t_ftdi_tx_irq_flag_rd_reg; -- FTDI Tx IRQ Flag Register
		hccd_reply_status_reg : t_ftdi_hccd_reply_status_rd_reg; -- FTDI Half-CCD Reply Status Register
		lut_trans_status_reg  : t_ftdi_lut_trans_status_rd_reg; -- FTDI LUT Transmission Status Register
		tx_data_status_reg    : t_ftdi_tx_data_status_rd_reg; -- FTDI Tx Data Status Register
		rx_data_status_reg    : t_ftdi_rx_data_status_rd_reg; -- FTDI Rx Data Status Register
		rx_comm_error_reg     : t_ftdi_rx_comm_error_rd_reg; -- FTDI Rx Communication Error Register
		tx_comm_error_reg     : t_ftdi_tx_comm_error_rd_reg; -- FTDI Tx LUT Communication Error Register
		rx_buffer_status_reg  : t_ftdi_rx_buffer_status_rd_reg; -- FTDI Rx Buffer Status Register
		tx_buffer_status_reg  : t_ftdi_tx_buffer_status_rd_reg; -- FTDI Tx Buffer Status Register
	end record t_ftdi_config_rd_registers;

end package ftdi_config_avalon_mm_registers_pkg;

package body ftdi_config_avalon_mm_registers_pkg is

end package body ftdi_config_avalon_mm_registers_pkg;
