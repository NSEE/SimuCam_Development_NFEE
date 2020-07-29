library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;

entity avalon_mm_spacewire_write_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_write_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_write_out;
		spacewire_write_registers_o : out t_windowing_write_registers
	);
end entity avalon_mm_spacewire_write_ent;

architecture rtl of avalon_mm_spacewire_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_spacewire_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- Comm Device Address Register : Comm Device Base Address
			spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr                                <= (others => '0');
			-- Comm IRQ Control Register : Comm Global IRQ Enable
			spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en                             <= '0';
			-- SpaceWire Device Address Register : SpaceWire Device Base Address
			spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr                                  <= (others => '0');
			-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect                           <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                             <= x"01";
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_trans_en                           <= '1';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_trigger_en                    <= '1';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_time_offset                        <= (others => '0');
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en              <= '0';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value                   <= (others => '0');
			-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
			spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr                  <= (others => '0');
			-- FEE Machine Config Register : FEE Machine Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Machine Config Register : FEE Buffer Overflow Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_buffer_overflow_en                       <= '1';
			-- FEE Machine Config Register : FEE Digitalise Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_digitalise_en                            <= '1';
			-- FEE Machine Config Register : FEE Readout Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_readout_en                               <= '1';
			-- FEE Machine Config Register : FEE Window List Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_window_list_en                           <= '1';
			-- FEE Machine Config Register : FEE Statistics Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_statistics_clear                         <= '0';
			-- FEE Buffers Config Register : Windowing Right Buffer Size Config
			spacewire_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size                        <= (others => '1');
			-- FEE Buffers Config Register : Windowing Left Buffer Size Config
			spacewire_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size                         <= (others => '1');
			-- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword       <= (others => '0');
			-- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword        <= (others => '0');
			-- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes             <= (others => '0');
			-- FEE Buffers Data Control Register : Right Data Read Start
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_start                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Reset
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_reset                         <= '0';
			-- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword        <= (others => '0');
			-- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword         <= (others => '0');
			-- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes              <= (others => '0');
			-- FEE Buffers Data Control Register : Left Data Read Start
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_start                          <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Reset
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_reset                          <= '0';
			-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
			spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_empty_en               <= '0';
			-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
			spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_empty_en                <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP Device Address Register : RMAP Device Base Address
			spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr                                <= (others => '0');
			-- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
			spacewire_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable               <= '0';
			-- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
			spacewire_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable                 <= '0';
			-- RMAP Codec Config Register : RMAP Target Enable
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_enable                            <= '1';
			-- RMAP Codec Config Register : RMAP Target Logical Address
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr                      <= x"51";
			-- RMAP Codec Config Register : RMAP Target Key
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key                               <= x"D1";
			-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
			spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword              <= (others => '0');
			-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
			spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword               <= (others => '0');
			-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
			spacewire_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr                             <= (others => '0');
			-- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
			spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_config_en                           <= '0';
			-- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
			spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_window_en                           <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear               <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear               <= '0';
			-- Data Packet Device Channel Address Register : Data Packet Device Base Address
			spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr                  <= (others => '0');
			-- Data Packet Config Register : Data Packet CCD X Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size                          <= std_logic_vector(to_unsigned(2295, 16));
			-- Data Packet Config Register : Data Packet CCD Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size                          <= std_logic_vector(to_unsigned(4560, 16));
			-- Data Packet Config Register : Data Packet Data Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size                         <= std_logic_vector(to_unsigned(4510, 16));
			-- Data Packet Config Register : Data Packet Overscan Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size                     <= std_logic_vector(to_unsigned(50, 16));
			-- Data Packet Config Register : Data Packet CCD V-Start
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start                         <= std_logic_vector(to_unsigned(0, 16));
			-- Data Packet Config Register : Data Packet CCD V-End
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end                           <= std_logic_vector(to_unsigned(4539, 16));
			-- Data Packet Config Register : Data Packet CCD Image V-End
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end                       <= std_logic_vector(to_unsigned(4509, 16));
			-- Data Packet Config Register : Data Packet CCD Overscan V-End
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end                       <= std_logic_vector(to_unsigned(29, 16));
			-- Data Packet Config Register : Data Packet CCD H-Start
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start                         <= std_logic_vector(to_unsigned(0, 16));
			-- Data Packet Config Register : Data Packet CCD H-End
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end                           <= std_logic_vector(to_unsigned(2294, 16));
			-- Data Packet Config Register : Data Packet CCD Image Enable
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_en                          <= '1';
			-- Data Packet Config Register : Data Packet CCD Overscan Enable
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_en                          <= '1';
			-- Data Packet Config Register : Data Packet Packet Length
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length                       <= std_logic_vector(to_unsigned(32768, 16));
			-- Data Packet Config Register : Data Packet Logical Address
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_logical_addr                        <= x"50";
			-- Data Packet Config Register : Data Packet Protocol ID
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_protocol_id                         <= x"F0";
			-- Data Packet Config Register : Data Packet FEE Mode
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_fee_mode                            <= std_logic_vector(to_unsigned(0, 5));
			-- Data Packet Config Register : Data Packet CCD Number
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_number                          <= std_logic_vector(to_unsigned(0, 2));
			-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
			spacewire_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                    <= '0';
			-- Data Packet Pixel Delay Register : Data Packet Start Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay                    <= std_logic_vector(to_unsigned(0, 32));
			-- Data Packet Pixel Delay Register : Data Packet Skip Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay                     <= std_logic_vector(to_unsigned(11000, 32));
			-- Data Packet Pixel Delay Register : Data Packet Line Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay                     <= std_logic_vector(to_unsigned(9000, 32));
			-- Data Packet Pixel Delay Register : Data Packet ADC Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                      <= std_logic_vector(to_unsigned(33, 32));
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [High Dword]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword  <= (others => '0');
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [Low Dword]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword   <= (others => '0');
			-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Size [Bytes]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes               <= (others => '1');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [High Dword]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword <= (others => '0');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [Low Dword]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword  <= (others => '0');
			-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Size [Bytes]
			spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes              <= (others => '1');
			-- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
			spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_eep_received             <= '0';
			-- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
			spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt             <= std_logic_vector(to_unsigned(0, 16));
			-- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
			spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat                 <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_tx_disabled          <= '0';
			-- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_pkts         <= '0';
			-- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_data         <= '0';
			-- Transmission Error Injection Control Register : Frame Number of Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_frame_num            <= std_logic_vector(to_unsigned(0, 2));
			-- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt         <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Data Counter of Transmission Error
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt             <= std_logic_vector(to_unsigned(0, 16));
			-- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
			spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat             <= std_logic_vector(to_unsigned(0, 16));
			-- Windowing Parameters Register : Windowing Packet Order List Dword 15
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 14
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 13
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 12
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 11
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 10
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10             <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 9
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 8
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 7
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 6
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 5
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 4
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 3
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 2
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 1
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1              <= (others => '0');
			-- Windowing Parameters Register : Windowing Packet Order List Dword 0
			spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0              <= (others => '0');
			-- Windowing Parameters Register : Windowing Last E Packet
			spacewire_write_registers_o.windowing_parameters_reg.windowing_last_e_packet                    <= (others => '0');
			-- Windowing Parameters Register : Windowing Last F Packet
			spacewire_write_registers_o.windowing_parameters_reg.windowing_last_f_packet                    <= (others => '0');
			-- Windowing Parameters Register : Windowing X-Coordinate Error
			spacewire_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error               <= '0';
			-- Windowing Parameters Register : Windowing Y-Coordinate Error
			spacewire_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error               <= '0';

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- FEE Machine Config Register : FEE Machine Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Machine Config Register : FEE Statistics Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_statistics_clear                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Start
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_start                         <= '0';
			-- FEE Buffers Data Control Register : Right Data Read Reset
			spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_reset                         <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Start
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_start                          <= '0';
			-- FEE Buffers Data Control Register : Left Data Read Reset
			spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_reset                          <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear               <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear               <= '0';
			-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
			spacewire_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                    <= '0';
			-- Windowing Parameters Register : Windowing X-Coordinate Error
			spacewire_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error               <= '0';
			-- Windowing Parameters Register : Windowing Y-Coordinate Error
			spacewire_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error               <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Comm Device Address Register : Comm Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#01#) =>
					-- Comm IRQ Control Register : Comm Global IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#02#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#06#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_trans_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#10#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_trigger_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#11#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_time_offset <= avalon_mm_spacewire_i.writedata(5 downto 0);
					end if;

				when (16#12#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#13#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#15#) =>
					-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#16#) =>
					-- FEE Machine Config Register : FEE Machine Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#17#) =>
					-- FEE Machine Config Register : FEE Machine Stop
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#18#) =>
					-- FEE Machine Config Register : FEE Machine Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#19#) =>
					-- FEE Machine Config Register : FEE Buffer Overflow Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_buffer_overflow_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#1A#) =>
					-- FEE Machine Config Register : FEE Digitalise Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_digitalise_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#1B#) =>
					-- FEE Machine Config Register : FEE Readout Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_readout_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#1C#) =>
					-- FEE Machine Config Register : FEE Window List Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_window_list_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#1D#) =>
					-- FEE Machine Config Register : FEE Statistics Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_statistics_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#27#) =>
					-- FEE Buffers Config Register : Windowing Right Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size <= avalon_mm_spacewire_i.writedata(3 downto 0);
					end if;
					-- FEE Buffers Config Register : Windowing Left Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size <= avalon_mm_spacewire_i.writedata(11 downto 8);
					end if;

				when (16#2C#) =>
					-- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#2D#) =>
					-- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#2E#) =>
					-- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#2F#) =>
					-- FEE Buffers Data Control Register : Right Data Read Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_start <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#30#) =>
					-- FEE Buffers Data Control Register : Right Data Read Reset
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.right_rd_reset <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#31#) =>
					-- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#32#) =>
					-- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#33#) =>
					-- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#34#) =>
					-- FEE Buffers Data Control Register : Left Data Read Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_start <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#35#) =>
					-- FEE Buffers Data Control Register : Left Data Read Reset
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_data_control_reg.left_rd_reset <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#38#) =>
					-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_empty_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#39#) =>
					-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_empty_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#3E#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#3F#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#40#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#41#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#43#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#44#) =>
					-- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#45#) =>
					-- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#46#) =>
					-- RMAP Codec Config Register : RMAP Target Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_enable <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#47#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;

				when (16#5A#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#5B#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#5C#) =>
					-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#5D#) =>
					-- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_config_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#5E#) =>
					-- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_window_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#61#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#62#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#64#) =>
					-- Data Packet Device Channel Address Register : Data Packet Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#65#) =>
					-- Data Packet Config Register : Data Packet CCD X Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#66#) =>
					-- Data Packet Config Register : Data Packet Data Y Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Overscan Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#67#) =>
					-- Data Packet Config Register : Data Packet CCD V-Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD V-End
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#68#) =>
					-- Data Packet Config Register : Data Packet CCD Image V-End
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD Overscan V-End
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#69#) =>
					-- Data Packet Config Register : Data Packet CCD H-Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD H-End
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#6A#) =>
					-- Data Packet Config Register : Data Packet CCD Image Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#6B#) =>
					-- Data Packet Config Register : Data Packet CCD Overscan Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#6C#) =>
					-- Data Packet Config Register : Data Packet Packet Length
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Logical Address
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_logical_addr <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					-- Data Packet Config Register : Data Packet Protocol ID
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_protocol_id <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#6D#) =>
					-- Data Packet Config Register : Data Packet FEE Mode
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_fee_mode <= avalon_mm_spacewire_i.writedata(4 downto 0);
					end if;
					-- Data Packet Config Register : Data Packet CCD Number
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_number <= avalon_mm_spacewire_i.writedata(9 downto 8);
					end if;

				when (16#6E#) =>
					-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#71#) =>
					-- Data Packet Pixel Delay Register : Data Packet Start Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#72#) =>
					-- Data Packet Pixel Delay Register : Data Packet Skip Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#73#) =>
					-- Data Packet Pixel Delay Register : Data Packet Line Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#74#) =>
					-- Data Packet Pixel Delay Register : Data Packet ADC Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#75#) =>
					-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_high_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#76#) =>
					-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Initial Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_initial_addr_low_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#77#) =>
					-- Pixels Circular Buffer Control Register : Left Pixels Circular Buffer Size [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.left_px_cbuffer_size_bytes(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;

				when (16#78#) =>
					-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_high_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#79#) =>
					-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Initial Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_initial_addr_low_dword(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#7A#) =>
					-- Pixels Circular Buffer Control Register : Right Pixels Circular Buffer Size [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.pixels_cbuffer_control_reg.right_px_cbuffer_size_bytes(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;

				when (16#7B#) =>
					-- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_eep_received <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#7C#) =>
					-- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#7D#) =>
					-- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_tx_disabled <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#7E#) =>
					-- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_pkts <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#7F#) =>
					-- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_data <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#80#) =>
					-- Transmission Error Injection Control Register : Frame Number of Transmission Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_frame_num <= avalon_mm_spacewire_i.writedata(1 downto 0);
					end if;
					-- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#81#) =>
					-- Transmission Error Injection Control Register : Data Counter of Transmission Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#82#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 15
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#83#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 14
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#84#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 13
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#85#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 12
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#86#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 11
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#87#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 10
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#88#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 9
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#89#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 8
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8A#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 7
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8B#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 6
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8C#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 5
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8D#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 4
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8E#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 3
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#8F#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 2
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#90#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 1
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#91#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 0
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#92#) =>
					-- Windowing Parameters Register : Windowing Last E Packet
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_last_e_packet(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_last_e_packet(9 downto 8) <= avalon_mm_spacewire_i.writedata(9 downto 8);
					end if;

				when (16#93#) =>
					-- Windowing Parameters Register : Windowing Last F Packet
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_last_f_packet(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_last_f_packet(9 downto 8) <= avalon_mm_spacewire_i.writedata(9 downto 8);
					end if;

				when (16#94#) =>
					-- Windowing Parameters Register : Windowing X-Coordinate Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#95#) =>
					-- Windowing Parameters Register : Windowing Y-Coordinate Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.waitrequest <= '1';
			s_data_acquired                   <= '0';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired                   <= '0';
			if (avalon_mm_spacewire_i.write = '1') then
				v_write_address := to_integer(unsigned(avalon_mm_spacewire_i.address));
				-- check if the address is allowed
				if ((v_write_address >= c_AVALON_MM_SPACEWIRE_MIN_ADDR) and (v_write_address <= c_AVALON_MM_SPACEWIRE_MAX_ADDR)) then
					avalon_mm_spacewire_o.waitrequest <= '0';
					s_data_acquired                   <= '1';
					if (s_data_acquired = '0') then
						p_writedata(v_write_address);
					end if;
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_write;

end architecture rtl;