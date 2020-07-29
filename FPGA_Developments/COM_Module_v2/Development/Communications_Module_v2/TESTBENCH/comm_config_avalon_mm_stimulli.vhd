library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_registers_pkg.all;
use work.fee_data_controller_pkg.all;

entity comm_config_avalon_mm_stimulli is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avs_config_rd_regs_i        : in  t_windowing_read_registers;
		avs_config_wr_regs_o        : out t_windowing_write_registers;
		avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
		avs_config_rd_waitrequest_o : out std_logic;
		avs_config_wr_waitrequest_o : out std_logic
	);
end entity comm_config_avalon_mm_stimulli;

architecture RTL of comm_config_avalon_mm_stimulli is

	signal s_counter : natural := 0;
	signal s_times   : natural := 0;

begin

	p_comm_config_avalon_mm_stimulli : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- Comm Device Address Register : Comm Device Base Address
			avs_config_wr_regs_o.comm_dev_addr_reg.comm_dev_base_addr                                <= (others => '0');
			-- Comm IRQ Control Register : Comm Global IRQ Enable
			avs_config_wr_regs_o.comm_irq_control_reg.comm_global_irq_en                             <= '0';
			-- SpaceWire Device Address Register : SpaceWire Device Base Address
			avs_config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr                                  <= (others => '0');
			-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
			avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect                           <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
			avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
			avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
			avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                             <= x"01";
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_trans_en                           <= '1';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_trigger_en                    <= '1';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_time_offset                        <= (others => '0');
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en              <= '0';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_delay_value                   <= (others => '0');
			-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
			avs_config_wr_regs_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr                  <= (others => '0');
			-- FEE Machine Config Register : FEE Machine Clear
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Machine Config Register : FEE Buffer Overflow Enable
			avs_config_wr_regs_o.fee_machine_config_reg.fee_buffer_overflow_en                       <= '1';
			-- FEE Machine Config Register : FEE Digitalise Enable
			avs_config_wr_regs_o.fee_machine_config_reg.fee_digitalise_en                            <= '1';
			-- FEE Machine Config Register : FEE Readout Enable
			avs_config_wr_regs_o.fee_machine_config_reg.fee_readout_en                               <= '1';
			-- FEE Machine Config Register : FEE Window List Enable
			avs_config_wr_regs_o.fee_machine_config_reg.fee_window_list_en                           <= '1';
			-- FEE Machine Config Register : FEE Statistics Clear
			avs_config_wr_regs_o.fee_machine_config_reg.fee_statistics_clear                         <= '0';
			-- FEE Buffers Config Register : Windowing Right Buffer Size Config
			avs_config_wr_regs_o.fee_buffers_config_reg.fee_right_buffer_size                        <= (others => '1');
			-- FEE Buffers Config Register : Windowing Left Buffer Size Config
			avs_config_wr_regs_o.fee_buffers_config_reg.fee_left_buffer_size                         <= (others => '1');
			-- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword       <= (others => '0');
			-- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword        <= (others => '0');
			-- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_data_length_bytes             <= (others => '0');
			-- FEE Buffers Data Control Register : Right Data Read Start
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Reset
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_reset                         <= '0';
			-- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword        <= (others => '0');
			-- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword         <= (others => '0');
			-- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_data_length_bytes              <= (others => '0');
			-- FEE Buffers Data Control Register : Left Data Read Start
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start                          <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Reset
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_reset                          <= '0';
			-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
			avs_config_wr_regs_o.fee_buffers_irq_control_reg.fee_right_buffer_empty_en               <= '0';
			-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
			avs_config_wr_regs_o.fee_buffers_irq_control_reg.fee_left_buffer_empty_en                <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP Device Address Register : RMAP Device Base Address
			avs_config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr                                <= (others => '0');
			-- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
			avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable               <= '0';
			-- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
			avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable                 <= '0';
			-- RMAP Codec Config Register : RMAP Target Enable
			avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_enable                            <= '1';
			-- RMAP Codec Config Register : RMAP Target Logical Address
			avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr                      <= x"51";
			-- RMAP Codec Config Register : RMAP Target Key
			avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_key                               <= x"D1";
			-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
			avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword              <= (others => '0');
			-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
			avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword               <= (others => '0');
			-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
			avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr                             <= (others => '0');
			-- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
			avs_config_wr_regs_o.rmap_irq_control_reg.rmap_write_config_en                           <= '0';
			-- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
			avs_config_wr_regs_o.rmap_irq_control_reg.rmap_write_window_en                           <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear               <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear               <= '0';
			-- Data Packet Device Channel Address Register : Data Packet Device Base Address
			avs_config_wr_regs_o.data_packet_dev_addr_reg.data_packet_dev_base_addr                  <= (others => '0');
			-- Data Packet Config Register : Data Packet CCD X Size
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_x_size                          <= std_logic_vector(to_unsigned(2295, 16));
			-- Data Packet Config Register : Data Packet CCD Y Size
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_y_size                          <= std_logic_vector(to_unsigned(4560, 16));
			-- Data Packet Config Register : Data Packet Data Y Size
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_data_y_size                         <= std_logic_vector(to_unsigned(4510, 16));
			-- Data Packet Config Register : Data Packet Overscan Y Size
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_overscan_y_size                     <= std_logic_vector(to_unsigned(50, 16));
			-- Data Packet Config Register : Data Packet CCD V-Start
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_start                         <= std_logic_vector(to_unsigned(0, 16));
			-- Data Packet Config Register : Data Packet CCD V-End
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_end                           <= std_logic_vector(to_unsigned(4539, 16));
			-- Data Packet Config Register : Data Packet CCD Image V-End
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_v_end                       <= std_logic_vector(to_unsigned(4509, 16));
			-- Data Packet Config Register : Data Packet CCD Overscan V-End
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end                       <= std_logic_vector(to_unsigned(29, 16));
			-- Data Packet Config Register : Data Packet CCD H-Start
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_start                         <= std_logic_vector(to_unsigned(0, 16));
			-- Data Packet Config Register : Data Packet CCD H-End
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_end                           <= std_logic_vector(to_unsigned(2294, 16));
			-- Data Packet Config Register : Data Packet CCD Image Enable
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_en                          <= '1';
			-- Data Packet Config Register : Data Packet CCD Overscan Enable
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_en                          <= '1';
			-- Data Packet Config Register : Data Packet Packet Length
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length                       <= std_logic_vector(to_unsigned(32768, 16));
			-- Data Packet Config Register : Data Packet Logical Address
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr                        <= x"50";
			-- Data Packet Config Register : Data Packet Protocol ID
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id                         <= x"F0";
			-- Data Packet Config Register : Data Packet FEE Mode
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                            <= std_logic_vector(to_unsigned(0, 5));
			-- Data Packet Config Register : Data Packet CCD Number
			avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number                          <= std_logic_vector(to_unsigned(0, 2));
			-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
			avs_config_wr_regs_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                    <= '0';
			-- Data Packet Pixel Delay Register : Data Packet Start Delay
			avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay                    <= std_logic_vector(to_unsigned(0, 32));
			-- Data Packet Pixel Delay Register : Data Packet Skip Delay
			avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay                     <= std_logic_vector(to_unsigned(11000, 32));
			-- Data Packet Pixel Delay Register : Data Packet Line Delay
			avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay                     <= std_logic_vector(to_unsigned(9000, 32));
			-- Data Packet Pixel Delay Register : Data Packet ADC Delay
			avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                      <= std_logic_vector(to_unsigned(33, 32));
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [High Dword]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword  <= (others => '0');
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [Low Dword]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword   <= (others => '0');
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Size [Bytes]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes               <= (others => '1');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [High Dword]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword <= (others => '0');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [Low Dword]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword  <= (others => '0');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Size [Bytes]
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes              <= (others => '1');
			-- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
			avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_eep_received             <= '0';
			-- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
			avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt             <= std_logic_vector(to_unsigned(0, 16));
			-- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
			avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_n_repeat                 <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_tx_disabled          <= '0';
			-- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_missing_pkts         <= '0';
			-- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_missing_data         <= '0';
			-- Transmission Error Injection Control Register : Frame Number of Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_frame_num            <= std_logic_vector(to_unsigned(0, 2));
			-- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt         <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Data Counter of Transmission Error
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_data_cnt             <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
			avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_n_repeat             <= std_logic_vector(to_unsigned(0, 16));
			-- Windowing Parameters Register : Windowing Packet Order List Dword 15
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_15             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 14
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_14             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 13
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_13             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 12
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_12             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 11
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_11             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 10
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_10             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 9
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_9              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 8
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_8              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 7
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_7              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 6
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_6              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 5
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_5              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 4
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_4              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 3
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_3              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 2
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_2              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 1
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_1              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 0
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_0              <= (others => '0');
			-- Windowing Parameters Register : Windowing Last E Packet
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_last_e_packet                    <= (others => '0');
			-- Windowing Parameters Register : Windowing Last F Packet
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_last_f_packet                    <= (others => '0');
			-- Windowing Parameters Register : Windowing X-Coordinate Error
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_x_coordinate_error               <= '0';
			-- Windowing Parameters Register : Windowing Y-Coordinate Error
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_y_coordinate_error               <= '0';

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- FEE Machine Config Register : FEE Machine Clear
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Machine Config Register : FEE Statistics Clear
			avs_config_wr_regs_o.fee_machine_config_reg.fee_statistics_clear                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Start
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Reset
			avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_reset                         <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Start
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start                          <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Reset
			avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_reset                          <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear               <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear               <= '0';
			-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
			avs_config_wr_regs_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                    <= '0';
			-- Windowing Parameters Register : Windowing X-Coordinate Error
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_x_coordinate_error               <= '0';
			-- Windowing Parameters Register : Windowing Y-Coordinate Error
			avs_config_wr_regs_o.windowing_parameters_reg.windowing_y_coordinate_error               <= '0';

		end procedure p_control_triggers;

	begin
		if (rst_i = '1') then

			s_counter                   <= 0;
			s_times                     <= 0;
			p_reset_registers;
			avs_config_rd_readdata_o    <= (others => '0');
			avs_config_rd_waitrequest_o <= '1';
			avs_config_wr_waitrequest_o <= '1';

		elsif rising_edge(clk_i) then

			s_counter                   <= s_counter + 1;
			p_control_triggers;
			avs_config_rd_readdata_o    <= (others => '0');
			avs_config_rd_waitrequest_o <= '1';
			avs_config_wr_waitrequest_o <= '1';

			-- cbuf config
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword  <= (others => '0');
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword   <= (others => '0');
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes               <= std_logic_vector(to_unsigned(64, 24));
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword <= (others => '0');
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword  <= (others => '0');
			avs_config_wr_regs_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes              <= std_logic_vector(to_unsigned(64, 24));

			case s_counter is

				when 5 =>
					-- stop the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop <= '1';

				when 10 =>
					-- clear the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '1';

				when 15 =>
					-- start the comm module
					avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '1';

				when 20 =>
					-- configure simulation parameters
					-- data packet parameters
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_x_size              <= std_logic_vector(to_unsigned(25, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_y_size              <= std_logic_vector(to_unsigned(50, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_data_y_size             <= std_logic_vector(to_unsigned(35, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_overscan_y_size         <= std_logic_vector(to_unsigned(15, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_start             <= std_logic_vector(to_unsigned(0, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_end               <= std_logic_vector(to_unsigned(49, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_v_end           <= std_logic_vector(to_unsigned(34, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end           <= std_logic_vector(to_unsigned(14, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_start             <= std_logic_vector(to_unsigned(0, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_end               <= std_logic_vector(to_unsigned(24, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length           <= std_logic_vector(to_unsigned(1024, 16));
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr            <= x"25";
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id             <= x"02";
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number              <= std_logic_vector(to_unsigned(3, 2));
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_OFF_MODE; -- N-FEE Off Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_ON_MODE; -- N-FEE On Mode
					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_PATTERN_MODE; -- N-FEE Full-Image Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_PATTERN_MODE; -- N-FEE Windowing Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_STANDBY_MODE; -- N-FEE Standby Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_MODE_PATTERN_MODE; -- N-FEE Full-Image Mode / Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_FULLIMAGE_MODE_SSD_MODE; -- N-FEE Full-Image Mode / SSD Mode
					--										avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_PATTERN_MODE; -- N-FEE Windowing Mode / Pattern Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_SSDIMG_MODE; -- N-FEE Windowing Mode / SSD Image Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_WINDOWING_MODE_SSDWIN_MODE; -- N-FEE Windowing Mode / SSD Window Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PERFORMANCE_TEST_MODE; -- N-FEE Performance Test Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_1_MODE_PUMP_MODE; -- N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_1_MODE_DATA_MODE; -- N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_2_MODE_PUMP_MODE; -- N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_PAR_TRAP_PUMP_2_MODE_DATA_MODE; -- N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_SER_TRAP_PUMP_1_MODE; -- N-FEE Serial Trap Pumping 1 Mode
					--					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode                <= c_DPKT_SER_TRAP_PUMP_2_MODE; -- N-FEE Serial Trap Pumping 2 Mode
					-- pixel delays parameters
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay        <= std_logic_vector(to_unsigned(1000, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay         <= std_logic_vector(to_unsigned(500, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay         <= std_logic_vector(to_unsigned(100, 32));
					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay          <= std_logic_vector(to_unsigned(50, 32));
					-- fee machine parameters
					avs_config_wr_regs_o.fee_machine_config_reg.fee_buffer_overflow_en           <= '0';
					avs_config_wr_regs_o.fee_machine_config_reg.fee_digitalise_en                <= '1';
					avs_config_wr_regs_o.fee_machine_config_reg.fee_readout_en                   <= '1';
					-- buffers data control
					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_data_length_bytes  <= (others => '1');
					--					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start              <= '1';
					avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_data_length_bytes <= (others => '1');
					avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start             <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_comm_config_avalon_mm_stimulli;

	avs_config_rd_readdata_o    <= (others => '0');
	avs_config_rd_waitrequest_o <= '1';
	avs_config_wr_waitrequest_o <= '1';

end architecture RTL;