library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_config_avalon_mm_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_CONFIG_MAX_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_CONFIG_MIN_ADDR : natural range 0 to 255 := 16#4C#;

	-- Registers Types

	-- FTDI IRQ Control Register
	type t_ftdi_ftdi_irq_control_wr_reg is record
		ftdi_global_irq_en : std_logic; -- FTDI Global IRQ Enable
	end record t_ftdi_ftdi_irq_control_wr_reg;

	-- FTDI Rx IRQ Control Register
	type t_ftdi_rx_irq_control_wr_reg is record
		rx_buffer_0_rdable_irq_en    : std_logic; -- Rx Buffer 0 Readable IRQ Enable
		rx_buffer_1_rdable_irq_en    : std_logic; -- Rx Buffer 1 Readable IRQ Enable
		rx_buffer_last_rdable_irq_en : std_logic; -- Rx Last Buffer Readable IRQ Enable
		rx_buffer_last_empty_irq_en  : std_logic; -- Rx Last Buffer Empty IRQ Enable
		rx_comm_err_irq_en           : std_logic; -- Rx Communication Error IRQ Enable
	end record t_ftdi_rx_irq_control_wr_reg;

	-- FTDI Rx IRQ Flag Register
	type t_ftdi_rx_irq_flag_rd_reg is record
		rx_buffer_0_rdable_irq_flag    : std_logic; -- Rx Buffer 0 Readable IRQ Flag
		rx_buffer_1_rdable_irq_flag    : std_logic; -- Rx Buffer 1 Readable IRQ Flag
		rx_buffer_last_rdable_irq_flag : std_logic; -- Rx Last Buffer Readable IRQ Flag
		rx_buffer_last_empty_irq_flag  : std_logic; -- Rx Last Buffer Empty IRQ Flag
		rx_comm_err_irq_flag           : std_logic; -- Rx Communication Error IRQ Flag
	end record t_ftdi_rx_irq_flag_rd_reg;

	-- FTDI Rx IRQ Flag Clear Register
	type t_ftdi_rx_irq_flag_clear_wr_reg is record
		rx_buffer_0_rdable_irq_flag_clr    : std_logic; -- Rx Buffer 0 Readable IRQ Flag Clear
		rx_buffer_1_rdable_irq_flag_clr    : std_logic; -- Rx Buffer 1 Readable IRQ Flag Clear
		rx_buffer_last_rdable_irq_flag_clr : std_logic; -- Rx Last Buffer Readable IRQ Flag Clear
		rx_buffer_last_empty_irq_flag_clr  : std_logic; -- Rx Last Buffer Empty IRQ Flag Clear
		rx_comm_err_irq_flag_clr           : std_logic; -- Rx Communication Error IRQ Flag Clear
	end record t_ftdi_rx_irq_flag_clear_wr_reg;

	-- FTDI Module Control Register
	type t_ftdi_ftdi_module_control_wr_reg is record
		ftdi_module_start       : std_logic; -- Stop Module Operation
		ftdi_module_stop        : std_logic; -- Start Module Operation
		ftdi_module_clear       : std_logic; -- Clear Module Memories
		ftdi_module_loopback_en : std_logic; -- Enable Module USB Loopback
	end record t_ftdi_ftdi_module_control_wr_reg;

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

	-- FTDI Rx Buffer Status Register
	type t_ftdi_rx_buffer_status_rd_reg is record
		rx_buffer_0_rdable     : std_logic; -- Rx Buffer 0 Readable
		rx_buffer_0_empty      : std_logic; -- Rx Buffer 0 Empty
		rx_buffer_0_used_bytes : std_logic_vector(13 downto 0); -- Rx Buffer 0 Used [Bytes]
		rx_buffer_0_full       : std_logic; -- Rx Buffer 0 Full
		rx_buffer_1_rdable     : std_logic; -- Rx Buffer 1 Readable
		rx_buffer_1_empty      : std_logic; -- Rx Buffer 1 Empty
		rx_buffer_1_used_bytes : std_logic_vector(13 downto 0); -- Rx Buffer 1 Used [Bytes]
		rx_buffer_1_full       : std_logic; -- Rx Buffer 1 Full
		rx_dbuffer_rdable      : std_logic; -- Rx Double Buffer Readable
		rx_dbuffer_empty       : std_logic; -- Rx Double Buffer Empty
		rx_dbuffer_used_bytes  : std_logic_vector(13 downto 0); -- Rx Double Buffer Used [Bytes]
		rx_dbuffer_full        : std_logic; -- Rx Double Buffer Full
	end record t_ftdi_rx_buffer_status_rd_reg;

	-- FTDI Tx Buffer Status Register
	type t_ftdi_tx_buffer_status_rd_reg is record
		tx_buffer_0_wrable      : std_logic; -- Tx Buffer 0 Writeable
		tx_buffer_0_empty       : std_logic; -- Tx Buffer 0 Empty
		tx_buffer_0_space_bytes : std_logic_vector(13 downto 0); -- Tx Buffer 0 Space [Bytes]
		tx_buffer_0_full        : std_logic; -- Tx Buffer 0 Full
		tx_buffer_1_wrable      : std_logic; -- Tx Buffer 1 Writeable
		tx_buffer_1_empty       : std_logic; -- Tx Buffer 1 Empty
		tx_buffer_1_space_bytes : std_logic_vector(13 downto 0); -- Tx Buffer 1 Space [Bytes]
		tx_buffer_1_full        : std_logic; -- Tx Buffer 1 Full
		tx_dbuffer_wrable       : std_logic; -- Tx Double Buffer Writeable
		tx_dbuffer_empty        : std_logic; -- Tx Double Buffer Empty
		tx_dbuffer_space_bytes  : std_logic_vector(13 downto 0); -- Tx Double Buffer Space [Bytes]
		tx_dbuffer_full         : std_logic; -- Tx Double Buffer Full
	end record t_ftdi_tx_buffer_status_rd_reg;

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

	-- FTDI Reserved Register
	type t_ftdi_reserved_rd_reg is record
		tx_buffer_0_empty_irq    : std_logic; -- Tx Buffer 0 Empty Irq
		tx_buffer_1_empty_irq    : std_logic; -- Tx Buffer 1 Empty Irq
		lut_transmitted_irq      : std_logic; -- LUT Transmitted Irq
		tx_comm_protocol_err_irq : std_logic; -- Tx Communication Protocol Error Irq
		lut_length_bytes         : std_logic_vector(31 downto 0); -- LUT Length Bytes
		transmit_lut             : std_logic; -- Transmit LUT
		lut_last_buffer          : std_logic; -- LUT Last Buffer
		lut_transmitted          : std_logic; -- LUT Transmitted
		tx_busy                  : std_logic; -- Tx Busy
		tx_buffer_empty          : std_logic; -- Tx Buffer Empty
	end record t_ftdi_reserved_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_ftdi_config_wr_registers is record
		ftdi_irq_control_reg    : t_ftdi_ftdi_irq_control_wr_reg; -- FTDI IRQ Control Register
		rx_irq_control_reg      : t_ftdi_rx_irq_control_wr_reg; -- FTDI Rx IRQ Control Register
		rx_irq_flag_clear_reg   : t_ftdi_rx_irq_flag_clear_wr_reg; -- FTDI Rx IRQ Flag Clear Register
		ftdi_module_control_reg : t_ftdi_ftdi_module_control_wr_reg; -- FTDI Module Control Register
		hccd_req_control_reg    : t_ftdi_hccd_req_control_wr_reg; -- FTDI Half-CCD Request Control Register
	end record t_ftdi_config_wr_registers;

	-- Avalon MM Read-Only Registers
	type t_ftdi_config_rd_registers is record
		rx_irq_flag_reg       : t_ftdi_rx_irq_flag_rd_reg; -- FTDI Rx IRQ Flag Register
		hccd_reply_status_reg : t_ftdi_hccd_reply_status_rd_reg; -- FTDI Half-CCD Reply Status Register
		rx_buffer_status_reg  : t_ftdi_rx_buffer_status_rd_reg; -- FTDI Rx Buffer Status Register
		tx_buffer_status_reg  : t_ftdi_tx_buffer_status_rd_reg; -- FTDI Tx Buffer Status Register
		rx_comm_error_reg     : t_ftdi_rx_comm_error_rd_reg; -- FTDI Rx Communication Error Register
		reserved_reg          : t_ftdi_reserved_rd_reg; -- FTDI Reserved Register
	end record t_ftdi_config_rd_registers;

end package ftdi_config_avalon_mm_registers_pkg;

package body ftdi_config_avalon_mm_registers_pkg is

end package body ftdi_config_avalon_mm_registers_pkg;