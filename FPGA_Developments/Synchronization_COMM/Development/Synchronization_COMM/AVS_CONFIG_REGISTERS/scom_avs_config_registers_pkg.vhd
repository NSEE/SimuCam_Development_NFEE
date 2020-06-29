library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package scom_avs_config_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_SCOM_AVS_CONFIG_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_SCOM_AVS_CONFIG_MAX_ADDR : natural range 0 to 255 := 16#2F#;

	-- Registers Types

	-- Scom Device Address Register
	type t_scom_scom_dev_addr_wr_reg is record
		scom_dev_base_addr : std_logic_vector(31 downto 0); -- Scom Device Base Address
	end record t_scom_scom_dev_addr_wr_reg;

	-- SpaceWire Device Address Register
	type t_scom_spw_dev_addr_wr_reg is record
		spw_dev_base_addr : std_logic_vector(31 downto 0); -- SpaceWire Device Base Address
	end record t_scom_spw_dev_addr_wr_reg;

	-- SpaceWire Link Config Register
	type t_scom_spw_link_config_wr_reg is record
		spw_lnkcfg_disconnect : std_logic; -- SpaceWire Link Config Disconnect
		spw_lnkcfg_linkstart  : std_logic; -- SpaceWire Link Config Linkstart
		spw_lnkcfg_autostart  : std_logic; -- SpaceWire Link Config Autostart
		spw_lnkcfg_txdivcnt   : std_logic_vector(7 downto 0); -- SpaceWire Link Config TxDivCnt
	end record t_scom_spw_link_config_wr_reg;

	-- SpaceWire Link Status Register
	type t_scom_spw_link_status_rd_reg is record
		spw_link_running    : std_logic; -- SpaceWire Link Running
		spw_link_connecting : std_logic; -- SpaceWire Link Connecting
		spw_link_started    : std_logic; -- SpaceWire Link Started
		spw_err_disconnect  : std_logic; -- SpaceWire Error Disconnect
		spw_err_parity      : std_logic; -- SpaceWire Error Parity
		spw_err_escape      : std_logic; -- SpaceWire Error Escape
		spw_err_credit      : std_logic; -- SpaceWire Error Credit
	end record t_scom_spw_link_status_rd_reg;

	-- SpaceWire Timecode Config Register
	type t_scom_spw_timecode_wr_reg is record
		timecode_clear : std_logic;     -- SpaceWire Timecode Clear
		timecode_en    : std_logic;     -- SpaceWire Timecode Enable
	end record t_scom_spw_timecode_wr_reg;

	-- SpaceWire Timecode Status Register
	type t_scom_spw_timecode_rd_reg is record
		timecode_time    : std_logic_vector(5 downto 0); -- SpaceWire Timecode Time
		timecode_control : std_logic_vector(1 downto 0); -- SpaceWire Timecode Control
	end record t_scom_spw_timecode_rd_reg;

	-- RMAP Device Address Register
	type t_scom_rmap_dev_addr_wr_reg is record
		rmap_dev_base_addr : std_logic_vector(31 downto 0); -- RMAP Device Base Address
	end record t_scom_rmap_dev_addr_wr_reg;

	-- RMAP Echoing Mode Config Register
	type t_scom_rmap_echoing_mode_config_wr_reg is record
		rmap_echoing_mode_enable : std_logic; -- RMAP Echoing Mode Enable
		rmap_echoing_id_enable   : std_logic; -- RMAP Echoing ID Enable
	end record t_scom_rmap_echoing_mode_config_wr_reg;

	-- RMAP Codec Config Register
	type t_scom_rmap_codec_config_wr_reg is record
		rmap_target_logical_addr : std_logic_vector(7 downto 0); -- RMAP Target Logical Address
		rmap_target_key          : std_logic_vector(7 downto 0); -- RMAP Target Key
	end record t_scom_rmap_codec_config_wr_reg;

	-- RMAP Codec Status Register
	type t_scom_rmap_codec_status_rd_reg is record
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
	end record t_scom_rmap_codec_status_rd_reg;

	-- RMAP Memory Status Register
	type t_scom_rmap_memory_status_rd_reg is record
		rmap_last_write_addr         : std_logic_vector(31 downto 0); -- RMAP Last Write Address
		rmap_last_write_length_bytes : std_logic_vector(31 downto 0); -- RMAP Last Write Length [Bytes]
		rmap_last_read_addr          : std_logic_vector(31 downto 0); -- RMAP Last Read Address
		rmap_last_read_length_bytes  : std_logic_vector(31 downto 0); -- RMAP Last Read Length [Bytes]
	end record t_scom_rmap_memory_status_rd_reg;

	-- RMAP Memory Config Register
	type t_scom_rmap_memory_config_wr_reg is record
		rmap_win_area_offset_high_dword : std_logic_vector(31 downto 0); -- RMAP Windowing Area Offset (High Dword)
		rmap_win_area_offset_low_dword  : std_logic_vector(31 downto 0); -- RMAP Windowing Area Offset (Low Dword)
	end record t_scom_rmap_memory_config_wr_reg;

	-- RMAP Memory Area Pointer Register
	type t_scom_rmap_mem_area_ptr_wr_reg is record
		rmap_mem_area_ptr : std_logic_vector(31 downto 0); -- RMAP Memory Area Pointer
	end record t_scom_rmap_mem_area_ptr_wr_reg;

	-- RMAP IRQ Control Register
	type t_scom_rmap_irq_control_wr_reg is record
		rmap_write_config_en : std_logic; -- RMAP Write Config IRQ Enable
		rmap_write_window_en : std_logic; -- RMAP Write Window IRQ Enable
	end record t_scom_rmap_irq_control_wr_reg;

	-- RMAP IRQ Flags Register
	type t_scom_rmap_irq_flags_rd_reg is record
		rmap_write_config_flag : std_logic; -- RMAP Write Config IRQ Flag
		rmap_write_window_flag : std_logic; -- RMAP Write Config IRQ Flag
	end record t_scom_rmap_irq_flags_rd_reg;

	-- RMAP IRQ Flags Clear Register
	type t_scom_rmap_irq_flags_clear_wr_reg is record
		rmap_write_config_flag_clear : std_logic; -- RMAP Write Config IRQ Flag Clear
		rmap_write_window_flag_clear : std_logic; -- RMAP Write Config IRQ Flag Clear
	end record t_scom_rmap_irq_flags_clear_wr_reg;

	-- RMAP IRQ Number Register
	type t_scom_rmap_irq_number_rd_reg is record
		rmap_irq_number : std_logic_vector(31 downto 0); -- RMAP IRQ Number/ID
	end record t_scom_rmap_irq_number_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_scom_config_wr_regs is record
		scom_dev_addr_reg            : t_scom_scom_dev_addr_wr_reg; -- Scom Device Address Register
		spw_dev_addr_reg             : t_scom_spw_dev_addr_wr_reg; -- SpaceWire Device Address Register
		spw_link_config_reg          : t_scom_spw_link_config_wr_reg; -- SpaceWire Link Config Register
		spw_timecode_config_reg      : t_scom_spw_timecode_wr_reg; -- SpaceWire Timecode Config Register
		rmap_dev_addr_reg            : t_scom_rmap_dev_addr_wr_reg; -- RMAP Device Address Register
		rmap_echoing_mode_config_reg : t_scom_rmap_echoing_mode_config_wr_reg; -- RMAP Echoing Mode Config Register
		rmap_codec_config_reg        : t_scom_rmap_codec_config_wr_reg; -- RMAP Codec Config Register
		rmap_memory_config_reg       : t_scom_rmap_memory_config_wr_reg; -- RMAP Memory Config Register
		rmap_mem_area_ptr_reg        : t_scom_rmap_mem_area_ptr_wr_reg; -- RMAP Memory Area Pointer Register
		rmap_irq_control_reg         : t_scom_rmap_irq_control_wr_reg; -- RMAP IRQ Control Register
		rmap_irq_flags_clear_reg     : t_scom_rmap_irq_flags_clear_wr_reg; -- RMAP IRQ Flags Clear Register
	end record t_scom_config_wr_regs;

	-- Avalon MM Read-Only Registers
	type t_scom_config_rd_regs is record
		spw_link_status_reg     : t_scom_spw_link_status_rd_reg; -- SpaceWire Link Status Register
		spw_timecode_status_reg : t_scom_spw_timecode_rd_reg; -- SpaceWire Timecode Status Register
		rmap_codec_status_reg   : t_scom_rmap_codec_status_rd_reg; -- RMAP Codec Status Register
		rmap_memory_status_reg  : t_scom_rmap_memory_status_rd_reg; -- RMAP Memory Status Register
		rmap_irq_flags_reg      : t_scom_rmap_irq_flags_rd_reg; -- RMAP IRQ Flags Register
		rmap_irq_number_reg     : t_scom_rmap_irq_number_rd_reg; -- RMAP IRQ Number Register
	end record t_scom_config_rd_regs;

end package scom_avs_config_registers_pkg;

package body scom_avs_config_registers_pkg is

end package body scom_avs_config_registers_pkg;
