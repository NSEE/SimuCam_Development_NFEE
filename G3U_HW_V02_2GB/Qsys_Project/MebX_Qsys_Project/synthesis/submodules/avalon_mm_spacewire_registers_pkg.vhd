library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_spacewire_registers_pkg is

	type t_comm_spw_link_config_status_wr_reg is record
		spw_lnkcfg_disconnect : std_logic;
		spw_lnkcfg_linkstart  : std_logic;
		spw_lnkcfg_autostart  : std_logic;
		spw_lnkcfg_txdivcnt   : std_logic_vector(7 downto 0);
	end record t_comm_spw_link_config_status_wr_reg;

	type t_comm_spw_link_config_status_rd_reg is record
		spw_link_running    : std_logic;
		spw_link_connecting : std_logic;
		spw_link_started    : std_logic;
		spw_err_disconnect  : std_logic;
		spw_err_parity      : std_logic;
		spw_err_escape      : std_logic;
		spw_err_credit      : std_logic;
	end record t_comm_spw_link_config_status_rd_reg;

	type t_comm_spw_timecode_wr_reg is record
		timecode_clear : std_logic;
	end record t_comm_spw_timecode_wr_reg;

	type t_comm_spw_timecode_rd_reg is record
		timecode_time    : std_logic_vector(5 downto 0);
		timecode_control : std_logic_vector(1 downto 0);
	end record t_comm_spw_timecode_rd_reg;

	type t_comm_fee_windowing_buffers_config_wr_reg is record
		fee_machine_clear : std_logic;
		fee_machine_stop  : std_logic;
		fee_machine_start : std_logic;
		fee_masking_en    : std_logic;
	end record t_comm_fee_windowing_buffers_config_wr_reg;

	type t_comm_fee_windowing_buffers_status_rd_reg is record
		windowing_right_buffer_empty : std_logic;
		windowing_left_buffer_empty  : std_logic;
		fee_right_machine_busy       : std_logic;
		fee_left_machine_busy        : std_logic;
	end record t_comm_fee_windowing_buffers_status_rd_reg;

	type t_comm_rmap_codec_config_wr_reg is record
		rmap_target_logical_addr : std_logic_vector(7 downto 0);
		rmap_target_key          : std_logic_vector(7 downto 0);
	end record t_comm_rmap_codec_config_wr_reg;

	type t_comm_rmap_codec_status_rd_reg is record
		rmap_stat_command_received    : std_logic;
		rmap_stat_write_requested     : std_logic;
		rmap_stat_write_authorized    : std_logic;
		rmap_stat_read_requested      : std_logic;
		rmap_stat_read_authorized     : std_logic;
		rmap_stat_reply_sended        : std_logic;
		rmap_stat_discarded_package   : std_logic;
		rmap_err_early_eop            : std_logic;
		rmap_err_eep                  : std_logic;
		rmap_err_header_crc           : std_logic;
		rmap_err_unused_packet_type   : std_logic;
		rmap_err_invalid_command_code : std_logic;
		rmap_err_too_much_data        : std_logic;
		rmap_err_invalid_data_crc     : std_logic;
	end record t_comm_rmap_codec_status_rd_reg;

	type t_comm_rmap_last_write_addr_rd_reg is record
		rmap_last_write_addr : std_logic_vector(31 downto 0);
	end record t_comm_rmap_last_write_addr_rd_reg;

	type t_comm_rmap_last_read_addr_rd_reg is record
		rmap_last_read_addr : std_logic_vector(31 downto 0);
	end record t_comm_rmap_last_read_addr_rd_reg;

	type t_comm_data_packet_config_1_wr_reg is record
		data_pkt_ccd_x_size : std_logic_vector(15 downto 0);
		data_pkt_ccd_y_size : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_config_1_wr_reg;

	type t_comm_data_packet_config_2_wr_reg is record
		data_pkt_data_y_size     : std_logic_vector(15 downto 0);
		data_pkt_overscan_y_size : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_config_2_wr_reg;

	type t_comm_data_packet_config_3_wr_reg is record
		data_pkt_packet_length : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_config_3_wr_reg;

	type t_comm_data_packet_config_4_wr_reg is record
		data_pkt_logical_addr : std_logic_vector(7 downto 0);
		data_pkt_protocol_id  : std_logic_vector(7 downto 0);
		data_pkt_fee_mode     : std_logic_vector(3 downto 0);
		data_pkt_ccd_number   : std_logic_vector(1 downto 0);
	end record t_comm_data_packet_config_4_wr_reg;

	type t_comm_data_packet_header_1_rd_reg is record
		data_pkt_header_length : std_logic_vector(15 downto 0);
		data_pkt_header_type   : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_header_1_rd_reg;

	type t_comm_data_packet_header_2_rd_reg is record
		data_pkt_header_frame_counter    : std_logic_vector(15 downto 0);
		data_pkt_header_sequence_counter : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_header_2_rd_reg;

	type t_comm_data_packet_pixel_delay_1_wr_reg is record
		data_pkt_line_delay : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_pixel_delay_1_wr_reg;

	type t_comm_data_packet_pixel_delay_2_wr_reg is record
		data_pkt_column_delay : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_pixel_delay_2_wr_reg;

	type t_comm_data_packet_pixel_delay_3_wr_reg is record
		data_pkt_adc_delay : std_logic_vector(15 downto 0);
	end record t_comm_data_packet_pixel_delay_3_wr_reg;

	type t_comm_comm_irq_control_wr_reg is record
		comm_rmap_write_command_en : std_logic;
		comm_right_buffer_empty_en : std_logic;
		comm_left_buffer_empty_en  : std_logic;
		comm_global_irq_en         : std_logic;
	end record t_comm_comm_irq_control_wr_reg;

	type t_comm_comm_irq_flags_rd_reg is record
		comm_rmap_write_command_flag : std_logic;
		comm_buffer_empty_flag       : std_logic;
	end record t_comm_comm_irq_flags_rd_reg;

	type t_comm_comm_irq_flags_clear_wr_reg is record
		comm_rmap_write_command_flag_clear : std_logic;
		comm_buffer_empty_flag_clear       : std_logic;
	end record t_comm_comm_irq_flags_clear_wr_reg;

	type t_windowing_write_registers is record
		spw_link_config_status_reg       : t_comm_spw_link_config_status_wr_reg;
		spw_timecode_reg                 : t_comm_spw_timecode_wr_reg;
		fee_windowing_buffers_config_reg : t_comm_fee_windowing_buffers_config_wr_reg;
		rmap_codec_config_reg            : t_comm_rmap_codec_config_wr_reg;
		data_packet_config_1_reg         : t_comm_data_packet_config_1_wr_reg;
		data_packet_config_2_reg         : t_comm_data_packet_config_2_wr_reg;
		data_packet_config_3_reg         : t_comm_data_packet_config_3_wr_reg;
		data_packet_config_4_reg         : t_comm_data_packet_config_4_wr_reg;
		data_packet_pixel_delay_1_reg    : t_comm_data_packet_pixel_delay_1_wr_reg;
		data_packet_pixel_delay_2_reg    : t_comm_data_packet_pixel_delay_2_wr_reg;
		data_packet_pixel_delay_3_reg    : t_comm_data_packet_pixel_delay_3_wr_reg;
		comm_irq_control_reg             : t_comm_comm_irq_control_wr_reg;
		comm_irq_flags_clear_reg         : t_comm_comm_irq_flags_clear_wr_reg;
	end record t_windowing_write_registers;

	type t_windowing_read_registers is record
		spw_link_config_status_reg       : t_comm_spw_link_config_status_rd_reg;
		spw_timecode_reg                 : t_comm_spw_timecode_rd_reg;
		fee_windowing_buffers_status_reg : t_comm_fee_windowing_buffers_status_rd_reg;
		rmap_codec_status_reg            : t_comm_rmap_codec_status_rd_reg;
		rmap_last_write_addr_reg         : t_comm_rmap_last_write_addr_rd_reg;
		rmap_last_read_addr_reg          : t_comm_rmap_last_read_addr_rd_reg;
		data_packet_header_1_reg         : t_comm_data_packet_header_1_rd_reg;
		data_packet_header_2_reg         : t_comm_data_packet_header_2_rd_reg;
		comm_irq_flags_reg               : t_comm_comm_irq_flags_rd_reg;
	end record t_windowing_read_registers;

end package avalon_mm_spacewire_registers_pkg;

package body avalon_mm_spacewire_registers_pkg is

end package body avalon_mm_spacewire_registers_pkg;
