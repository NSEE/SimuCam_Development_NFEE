library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;

-- Register write helpers for the COM module register bank (Avalon-MM slave).
--
-- Responsibilities:
--   1) Reset writable registers to default values
--   2) Apply trigger/control "one-shot" behaviour (if you have it)
--   3) Decode Avalon writes and update the write-register record
--
package avalon_mm_spacewire_registers_write_pkg is

    procedure p_reset_avs_registers(
        signal s_avs_write_registers_o : out t_windowing_write_registers
    );

    procedure p_control_avs_triggers(
        signal s_avs_write_registers_o : inout t_windowing_write_registers
    );

    procedure p_avs_writedata(
        avs_write_address_i            : in    t_avalon_mm_spacewire_address;
        avs_writedata_i                : in    std_logic_vector((c_AVALON_MM_SPACEWIRE_DATA_SIZE - 1) downto 0);
        signal s_avs_write_registers_o : inout t_windowing_write_registers
    );

end package avalon_mm_spacewire_registers_write_pkg;

package body avalon_mm_spacewire_registers_write_pkg is

    procedure p_reset_avs_registers(
        signal s_avs_write_registers_o : out t_windowing_write_registers
    ) is
    begin
        -- If you already have default constants in avalon_mm_spacewire_registers_pkg,
        -- prefer assigning those here. Otherwise set explicit defaults field-by-field.

        -- Write Registers Reset/Default State

        -- Comm Device Address Register : Comm Device Base Address
        s_avs_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr                                            <= (others => '0');
        -- Comm IRQ Control Register : Comm Global IRQ Enable
        s_avs_write_registers_o.comm_irq_control_reg.comm_global_irq_en                                         <= '0';
        -- SpaceWire Device Address Register : SpaceWire Device Base Address
        s_avs_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr                                              <= (others => '0');
        -- SpaceWire Link Config Register : SpaceWire Link Config Enable
        s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_enable                                           <= '0';
        -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
        s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect                                       <= '0';
        -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
        s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart                                        <= '0';
        -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
        s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart                                        <= '0';
        -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
        s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                                         <= x"01";
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_clear                                          <= '0';
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_trans_en                                       <= '1';
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_trigger_en                                <= '1';
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_time_offset                                    <= (others => '0');
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en                          <= '0';
        -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value                               <= (others => '0');
        -- FEE Buffers Device Address Register : FEE Buffers Device Base Address
        s_avs_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr                              <= (others => '0');
        -- FEE Machine Config Register : FEE Machine Clear
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_clear                                        <= '0';
        -- FEE Machine Config Register : FEE Machine Stop
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_stop                                         <= '0';
        -- FEE Machine Config Register : FEE Machine Start
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_start                                        <= '0';
        -- FEE Machine Config Register : FEE Buffer Overflow Enable
        s_avs_write_registers_o.fee_machine_config_reg.fee_buffer_overflow_en                                   <= '1';
        -- FEE Machine Config Register : FEE Left Pixel Storage Size
        s_avs_write_registers_o.fee_machine_config_reg.left_pixels_storage_size                                 <= (others => '0');
        -- FEE Machine Config Register : FEE Right Pixel Storage Size
        s_avs_write_registers_o.fee_machine_config_reg.right_pixels_storage_size                                <= (others => '0');
        -- FEE Machine Config Register : FEE Digitalise Enable
        s_avs_write_registers_o.fee_machine_config_reg.fee_digitalise_en                                        <= '1';
        -- FEE Machine Config Register : FEE Readout Enable
        s_avs_write_registers_o.fee_machine_config_reg.fee_readout_en                                           <= '1';
        -- FEE Machine Config Register : FEE Window List Enable
        s_avs_write_registers_o.fee_machine_config_reg.fee_window_list_en                                       <= '1';
        -- FEE Machine Config Register : FEE Statistics Clear
        s_avs_write_registers_o.fee_machine_config_reg.fee_statistics_clear                                     <= '0';
        -- FEE Buffers Config Register : Windowing Right Buffer Size Config
        s_avs_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size                                    <= (others => '1');
        -- FEE Buffers Config Register : Windowing Left Buffer Size Config
        s_avs_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size                                     <= (others => '1');
        -- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword                   <= (others => '0');
        -- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword                    <= (others => '0');
        -- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes                         <= (others => '0');
        -- FEE Buffers Data Control Register : Right Data Read Start
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_start                                     <= '0';
        -- FEE Buffers Data Control Register : Right Data Read Reset
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_reset                                     <= '0';
        -- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword                    <= (others => '0');
        -- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword                     <= (others => '0');
        -- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes                          <= (others => '0');
        -- FEE Buffers Data Control Register : Left Data Read Start
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_start                                      <= '0';
        -- FEE Buffers Data Control Register : Left Data Read Reset
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_reset                                      <= '0';
        -- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
        s_avs_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_controller_finished_en             <= '0';
        -- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
        s_avs_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_controller_finished_en              <= '0';
        -- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
        s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_controller_finished_flag_clear <= '0';
        -- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
        s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_controller_finished_flag_clear  <= '0';
        -- RMAP Device Address Register : RMAP Device Base Address
        s_avs_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr                                            <= (others => '0');
        -- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
        s_avs_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable                           <= '0';
        -- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
        s_avs_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable                             <= '0';
        -- RMAP Codec Config Register : RMAP Target Enable
        s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_enable                                        <= '1';
        -- RMAP Codec Config Register : RMAP Target Logical Address
        s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr                                  <= x"51";
        -- RMAP Codec Config Register : RMAP Target Key
        s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_key                                           <= x"D1";
        -- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
        s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword                          <= (others => '0');
        -- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
        s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword                           <= (others => '0');
        -- RMAP Address FIFO Control Register : RMAP Address FIFO Read
        s_avs_write_registers_o.rmap_addr_fifo_control_reg.rmap_addr_fifo_read                                  <= '0';
        -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
        s_avs_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr                                         <= (others => '0');
        -- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_en                                       <= '0';
        -- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_en                                       <= '0';
        -- RMAP IRQ Control Register : RMAP Write Config IRQ Rate Limit
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_limit                               <= (others => '0');
        -- RMAP IRQ Control Register : RMAP Write Window IRQ Rate Limit
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_limit                               <= (others => '0');
        -- RMAP IRQ Control Register : RMAP Write Config IRQ Rate Counter Clear
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_count_clear                         <= '0';
        -- RMAP IRQ Control Register : RMAP Write Window IRQ Rate Counter Clear
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_count_clear                         <= '0';
        -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
        s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear                           <= '0';
        -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
        s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear                           <= '0';
        -- Data Packet Device Channel Address Register : Data Packet Device Base Address
        s_avs_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr                              <= (others => '0');
        -- Data Packet Config Register : Data Packet CCD X Size
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size                                      <= std_logic_vector(to_unsigned(2295, 16));
        -- Data Packet Config Register : Data Packet CCD Y Size
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size                                      <= std_logic_vector(to_unsigned(4560, 16));
        -- Data Packet Config Register : Data Packet Data Y Size
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_data_y_size                                     <= std_logic_vector(to_unsigned(4510, 16));
        -- Data Packet Config Register : Data Packet Overscan Y Size
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size                                 <= std_logic_vector(to_unsigned(50, 16));
        -- Data Packet Config Register : Data Packet CCD V-Start
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start                                     <= std_logic_vector(to_unsigned(0, 16));
        -- Data Packet Config Register : Data Packet CCD V-End
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end                                       <= std_logic_vector(to_unsigned(4539, 16));
        -- Data Packet Config Register : Data Packet CCD Image V-End
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end                                   <= std_logic_vector(to_unsigned(4509, 16));
        -- Data Packet Config Register : Data Packet CCD Overscan V-End
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end                                   <= std_logic_vector(to_unsigned(29, 16));
        -- Data Packet Config Register : Data Packet CCD H-Start
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start                                     <= std_logic_vector(to_unsigned(0, 16));
        -- Data Packet Config Register : Data Packet CCD H-End
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end                                       <= std_logic_vector(to_unsigned(2294, 16));
        -- Data Packet Config Register : Data Packet CCD Image Enable
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_en                                      <= '1';
        -- Data Packet Config Register : Data Packet CCD Overscan Enable
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_en                                      <= '1';
        -- Data Packet Config Register : Data Packet Packet Length
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_packet_length                                   <= std_logic_vector(to_unsigned(32768, 16));
        -- Data Packet Config Register : Data Packet Logical Address
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_logical_addr                                    <= x"50";
        -- Data Packet Config Register : Data Packet Protocol ID
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_protocol_id                                     <= x"F0";
        -- Data Packet Config Register : Data Packet FEE Mode
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_fee_mode                                        <= std_logic_vector(to_unsigned(0, 5));
        -- Data Packet Config Register : Data Packet CCD Number
        s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_number                                      <= std_logic_vector(to_unsigned(0, 2));
        -- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
        s_avs_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                                <= '0';
        -- Data Packet Pixel Delay Register : Data Packet Start Delay
        s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay                                <= std_logic_vector(to_unsigned(0, 32));
        -- Data Packet Pixel Delay Register : Data Packet Skip Delay
        s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay                                 <= std_logic_vector(to_unsigned(11000, 32));
        -- Data Packet Pixel Delay Register : Data Packet Line Delay
        s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay                                 <= std_logic_vector(to_unsigned(9000, 32));
        -- Data Packet Pixel Delay Register : Data Packet ADC Delay
        s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                                  <= std_logic_vector(to_unsigned(33, 32));
        -- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
        s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_eep_received                         <= '0';
        -- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
        s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt                         <= std_logic_vector(to_unsigned(0, 16));
        -- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
        s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat                             <= std_logic_vector(to_unsigned(0, 16));
        -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
        s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                           <= '0';
        -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
        s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                           <= '0';
        -- SpaceWire Codec Error Injection Control Register : SpaceWire Codec Error Injection Error Code
        s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_errinj_code                            <= (others => '0');
        -- RMAP Error Injection Control Register : Reset RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_reset                              <= '0';
        -- RMAP Error Injection Control Register : Trigger RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_trigger                            <= '0';
        -- RMAP Error Injection Control Register : Error ID of RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_err_id                             <= (others => '0');
        -- RMAP Error Injection Control Register : Value of RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_value                              <= (others => '0');
        -- RMAP Error Injection Control Register : Repetitions of RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_repeats                            <= (others => '0');
        -- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_tx_disabled                      <= '0';
        -- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_pkts                     <= '0';
        -- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_data                     <= '0';
        -- Transmission Error Injection Control Register : Frame Number of Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_frame_num                        <= std_logic_vector(to_unsigned(0, 2));
        -- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt                     <= std_logic_vector(to_unsigned(0, 16));
        -- Transmission Error Injection Control Register : Data Counter of Transmission Error
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt                         <= std_logic_vector(to_unsigned(0, 16));
        -- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
        s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat                         <= std_logic_vector(to_unsigned(0, 16));
        -- Left Content Error Injection Control Register : Open the Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_open               <= '0';
        -- Left Content Error Injection Control Register : Close the Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_close              <= '0';
        -- Left Content Error Injection Control Register : Clear Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_clear              <= '0';
        -- Left Content Error Injection Control Register : Write to Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_write              <= '0';
        -- Left Content Error Injection Control Register : Start Injection of Left Content Errors
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start              <= '0';
        -- Left Content Error Injection Control Register : Stop Injection of Left Content Errors
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop               <= '0';
        -- Left Content Error Injection Control Register : Start Frame of Left Content Error
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start_frame        <= (others => '0');
        -- Left Content Error Injection Control Register : Stop Frame of Left Content Error
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop_frame         <= (others => '0');
        -- Left Content Error Injection Control Register : Pixel Column (x-position) of Left Content Error
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_col          <= (others => '0');
        -- Left Content Error Injection Control Register : Pixel Row (y-position) of Left Content Error
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_row          <= (others => '0');
        -- Left Content Error Injection Control Register : Pixel Value of Left Content Error
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_value        <= (others => '0');
        -- Right Content Error Injection Control Register : Open the Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_open             <= '0';
        -- Right Content Error Injection Control Register : Close the Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_close            <= '0';
        -- Right Content Error Injection Control Register : Clear Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_clear            <= '0';
        -- Right Content Error Injection Control Register : Write to Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_write            <= '0';
        -- Right Content Error Injection Control Register : Start Injection of Right Content Errors
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start            <= '0';
        -- Right Content Error Injection Control Register : Stop Injection of Right Content Errors
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop             <= '0';
        -- Right Content Error Injection Control Register : Start Frame of Right Content Error
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start_frame      <= (others => '0');
        -- Right Content Error Injection Control Register : Stop Frame of Right Content Error
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame       <= (others => '0');
        -- Right Content Error Injection Control Register : Pixel Column (x-position) of Right Content Error
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col        <= (others => '0');
        -- Right Content Error Injection Control Register : Pixel Row (y-position) of Right Content Error
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row        <= (others => '0');
        -- Right Content Error Injection Control Register : Pixel Value of Right Content Error
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value      <= (others => '0');
        -- Header Error Injection Control Register : Open the Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_open                           <= '0';
        -- Header Error Injection Control Register : Close the Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_close                          <= '0';
        -- Header Error Injection Control Register : Clear Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_clear                          <= '0';
        -- Header Error Injection Control Register : Write to Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_write                          <= '0';
        -- Header Error Injection Control Register : Start Injection of Header Errors
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_start                          <= '0';
        -- Header Error Injection Control Register : Stop Injection of Header Errors
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_stop                           <= '0';
        -- Header Error Injection Control Register : Frame Number of Header Error
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_frame_num                      <= (others => '0');
        -- Header Error Injection Control Register : Sequence Counter of Header Error
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_sequence_cnt                   <= (others => '0');
        -- Header Error Injection Control Register : Field ID of Header Error
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_field_id                       <= (others => '0');
        -- Header Error Injection Control Register : Value of Header Error
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_value                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 15
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 14
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 13
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 12
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 11
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 10
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10                         <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 9
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 8
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 7
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 6
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 5
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 4
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 3
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 2
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 1
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Packet Order List Dword 0
        s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0                          <= (others => '0');
        -- Windowing Parameters Register : Windowing Last E Packet
        s_avs_write_registers_o.windowing_parameters_reg.windowing_last_e_packet                                <= (others => '0');
        -- Windowing Parameters Register : Windowing Last F Packet
        s_avs_write_registers_o.windowing_parameters_reg.windowing_last_f_packet                                <= (others => '0');
        -- Windowing Parameters Register : Windowing X-Coordinate Error
        s_avs_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error                           <= '0';
        -- Windowing Parameters Register : Windowing Y-Coordinate Error
        s_avs_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error                           <= '0';

        -- Add other writable regs defaulting here...
        -- spacewire_write_registers_o.some_reg.some_field <= '0';
    end procedure p_reset_avs_registers;

    procedure p_control_avs_triggers(
        signal s_avs_write_registers_o : inout t_windowing_write_registers
    ) is
    begin
        -- Use this for “one-cycle pulse” / “self-clearing” control bits, if you have them.

        -- Write Registers Triggers Reset

        -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
        s_avs_write_registers_o.spw_timecode_config_reg.timecode_clear                                          <= '0';
        -- FEE Machine Config Register : FEE Machine Clear
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_clear                                        <= '0';
        -- FEE Machine Config Register : FEE Machine Stop
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_stop                                         <= '0';
        -- FEE Machine Config Register : FEE Machine Start
        s_avs_write_registers_o.fee_machine_config_reg.fee_machine_start                                        <= '0';
        -- FEE Machine Config Register : FEE Statistics Clear
        s_avs_write_registers_o.fee_machine_config_reg.fee_statistics_clear                                     <= '0';
        -- FEE Buffers Data Control Register : Right Data Read Start
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_start                                     <= '0';
        -- FEE Buffers Data Control Register : Right Data Read Reset
        s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_reset                                     <= '0';
        -- FEE Buffers Data Control Register : Left Data Read Start
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_start                                      <= '0';
        -- FEE Buffers Data Control Register : Left Data Read Reset
        s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_reset                                      <= '0';
        -- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
        s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_controller_finished_flag_clear <= '0';
        -- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
        s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_controller_finished_flag_clear  <= '0';
        -- RMAP Address FIFO Control Register : RMAP Address FIFO Read
        s_avs_write_registers_o.rmap_addr_fifo_control_reg.rmap_addr_fifo_read                                  <= '0';
        -- RMAP IRQ Control Register : RMAP Write Config IRQ Rate Counter Clear
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_count_clear                         <= '0';
        -- RMAP IRQ Control Register : RMAP Write Window IRQ Rate Counter Clear
        s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_count_clear                         <= '0';
        -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
        s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear                           <= '0';
        -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
        s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear                           <= '0';
        -- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
        s_avs_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                                <= '0';
        -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
        s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                           <= '0';
        -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
        s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                           <= '0';
        -- RMAP Error Injection Control Register : Reset RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_reset                              <= '0';
        -- RMAP Error Injection Control Register : Trigger RMAP Error
        s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_trigger                            <= '0';
        -- Left Content Error Injection Control Register : Open the Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_open               <= '0';
        -- Left Content Error Injection Control Register : Close the Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_close              <= '0';
        -- Left Content Error Injection Control Register : Clear Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_clear              <= '0';
        -- Left Content Error Injection Control Register : Write to Left Content Error List
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_write              <= '0';
        -- Left Content Error Injection Control Register : Start Injection of Left Content Errors
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start              <= '0';
        -- Left Content Error Injection Control Register : Stop Injection of Left Content Errors
        s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop               <= '0';
        -- Right Content Error Injection Control Register : Open the Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_open             <= '0';
        -- Right Content Error Injection Control Register : Close the Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_close            <= '0';
        -- Right Content Error Injection Control Register : Clear Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_clear            <= '0';
        -- Right Content Error Injection Control Register : Write to Right Content Error List
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_write            <= '0';
        -- Right Content Error Injection Control Register : Start Injection of Right Content Errors
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start            <= '0';
        -- Right Content Error Injection Control Register : Stop Injection of Right Content Errors
        s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop             <= '0';
        -- Header Error Injection Control Register : Open the Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_open                           <= '0';
        -- Header Error Injection Control Register : Close the Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_close                          <= '0';
        -- Header Error Injection Control Register : Clear Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_clear                          <= '0';
        -- Header Error Injection Control Register : Write to Header Error List
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_write                          <= '0';
        -- Header Error Injection Control Register : Start Injection of Header Errors
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_start                          <= '0';
        -- Header Error Injection Control Register : Stop Injection of Header Errors
        s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_stop                           <= '0';
        -- Windowing Parameters Register : Windowing X-Coordinate Error
        s_avs_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error                           <= '0';
        -- Windowing Parameters Register : Windowing Y-Coordinate Error
        s_avs_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error                           <= '0';

    end procedure p_control_avs_triggers;

    procedure p_avs_writedata(
        avs_write_address_i            : in    t_avalon_mm_spacewire_address;
        avs_writedata_i                : in    std_logic_vector((c_AVALON_MM_SPACEWIRE_DATA_SIZE - 1) downto 0);
        signal s_avs_write_registers_o : inout t_windowing_write_registers
    ) is
    begin
        -- Default: no write unless address matches.
        -- For each register, build v_old32 from the record, then merge bytes, then write back.

        -- Registers Write Data
        case (avs_write_address_i) is
            -- Case for access to all registers address

            when (16#00#) =>
                -- Comm Device Address Register : Comm Device Base Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#01#) =>
                -- Comm IRQ Control Register : Comm Global IRQ Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.comm_irq_control_reg.comm_global_irq_en <= avs_writedata_i(0);
            -- end if;

            when (16#02#) =>
                -- SpaceWire Device Address Register : SpaceWire Device Base Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#03#) =>
                -- SpaceWire Link Config Register : SpaceWire Link Config Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_enable <= avs_writedata_i(0);
            -- end if;

            when (16#04#) =>
                -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avs_writedata_i(0);
            -- end if;

            when (16#05#) =>
                -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart <= avs_writedata_i(0);
            -- end if;

            when (16#06#) =>
                -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart <= avs_writedata_i(0);
            -- end if;

            when (16#07#) =>
                -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#0F#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_clear <= avs_writedata_i(0);
            -- end if;

            when (16#10#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_trans_en <= avs_writedata_i(0);
            -- end if;

            when (16#11#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_trigger_en <= avs_writedata_i(0);
            -- end if;

            when (16#12#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_time_offset <= avs_writedata_i(5 downto 0);
            -- end if;

            when (16#13#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en <= avs_writedata_i(0);
            -- end if;

            when (16#14#) =>
                -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.spw_timecode_config_reg.timecode_sync_delay_value(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#17#) =>
                -- FEE Buffers Device Address Register : FEE Buffers Device Base Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#18#) =>
                -- FEE Machine Config Register : FEE Machine Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_machine_clear <= avs_writedata_i(0);
            -- end if;

            when (16#19#) =>
                -- FEE Machine Config Register : FEE Machine Stop
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_machine_stop <= avs_writedata_i(0);
            -- end if;

            when (16#1A#) =>
                -- FEE Machine Config Register : FEE Machine Start
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_machine_start <= avs_writedata_i(0);
            -- end if;

            when (16#1B#) =>
                -- FEE Machine Config Register : FEE Buffer Overflow Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_buffer_overflow_en <= avs_writedata_i(0);
            -- end if;

            when (16#1C#) =>
                -- FEE Machine Config Register : FEE Left Pixel Storage Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.left_pixels_storage_size(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.left_pixels_storage_size(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.left_pixels_storage_size(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.left_pixels_storage_size(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#1D#) =>
                -- FEE Machine Config Register : FEE Right Pixel Storage Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.right_pixels_storage_size(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.right_pixels_storage_size(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.right_pixels_storage_size(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.right_pixels_storage_size(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#1E#) =>
                -- FEE Machine Config Register : FEE Digitalise Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_digitalise_en <= avs_writedata_i(0);
            -- end if;

            when (16#1F#) =>
                -- FEE Machine Config Register : FEE Readout Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_readout_en <= avs_writedata_i(0);
            -- end if;

            when (16#20#) =>
                -- FEE Machine Config Register : FEE Window List Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_window_list_en <= avs_writedata_i(0);
            -- end if;

            when (16#21#) =>
                -- FEE Machine Config Register : FEE Statistics Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_machine_config_reg.fee_statistics_clear <= avs_writedata_i(0);
            -- end if;

            when (16#2B#) =>
                -- FEE Buffers Config Register : Windowing Right Buffer Size Config
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size <= avs_writedata_i(3 downto 0);
            -- end if;

            when (16#2C#) =>
                -- FEE Buffers Config Register : Windowing Left Buffer Size Config
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size <= avs_writedata_i(3 downto 0);
            -- end if;

            when (16#31#) =>
                -- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#32#) =>
                -- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#33#) =>
                -- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_data_length_bytes(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#34#) =>
                -- FEE Buffers Data Control Register : Right Data Read Start
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_start <= avs_writedata_i(0);
            -- end if;

            when (16#35#) =>
                -- FEE Buffers Data Control Register : Right Data Read Reset
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.right_rd_reset <= avs_writedata_i(0);
            -- end if;

            when (16#36#) =>
                -- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#37#) =>
                -- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#38#) =>
                -- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_data_length_bytes(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#39#) =>
                -- FEE Buffers Data Control Register : Left Data Read Start
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_start <= avs_writedata_i(0);
            -- end if;

            when (16#3A#) =>
                -- FEE Buffers Data Control Register : Left Data Read Reset
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_data_control_reg.left_rd_reset <= avs_writedata_i(0);
            -- end if;

            when (16#3D#) =>
                -- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_controller_finished_en <= avs_writedata_i(0);
            -- end if;

            when (16#3E#) =>
                -- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_controller_finished_en <= avs_writedata_i(0);
            -- end if;

            when (16#41#) =>
                -- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_controller_finished_flag_clear <= avs_writedata_i(0);
            -- end if;

            when (16#42#) =>
                -- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_controller_finished_flag_clear <= avs_writedata_i(0);
            -- end if;

            when (16#44#) =>
                -- RMAP Device Address Register : RMAP Device Base Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#45#) =>
                -- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable <= avs_writedata_i(0);
            -- end if;

            when (16#46#) =>
                -- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable <= avs_writedata_i(0);
            -- end if;

            when (16#47#) =>
                -- RMAP Codec Config Register : RMAP Target Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_enable <= avs_writedata_i(0);
            -- end if;

            when (16#48#) =>
                -- RMAP Codec Config Register : RMAP Target Logical Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#49#) =>
                -- RMAP Codec Config Register : RMAP Target Key
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_codec_config_reg.rmap_target_key <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#5C#) =>
                -- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#5D#) =>
                -- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#5E#) =>
                -- RMAP Address FIFO Control Register : RMAP Address FIFO Read
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_addr_fifo_control_reg.rmap_addr_fifo_read <= avs_writedata_i(0);
            -- end if;

            when (16#61#) =>
                -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#62#) =>
                -- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_en <= avs_writedata_i(0);
            -- end if;

            when (16#63#) =>
                -- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_en <= avs_writedata_i(0);
            -- end if;

            when (16#64#) =>
                -- RMAP IRQ Control Register : RMAP Write Config IRQ Rate Limit
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_limit(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_limit(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_limit(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_limit(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#65#) =>
                -- RMAP IRQ Control Register : RMAP Write Window IRQ Rate Limit
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_limit(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_limit(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_limit(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_limit(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#66#) =>
                -- RMAP IRQ Control Register : RMAP Write Config IRQ Rate Counter Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_config_rate_count_clear <= avs_writedata_i(0);
            -- end if;

            when (16#67#) =>
                -- RMAP IRQ Control Register : RMAP Write Window IRQ Rate Counter Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_control_reg.rmap_write_window_rate_count_clear <= avs_writedata_i(0);
            -- end if;

            when (16#6E#) =>
                -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear <= avs_writedata_i(0);
            -- end if;

            when (16#6F#) =>
                -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear <= avs_writedata_i(0);
            -- end if;

            when (16#71#) =>
                -- Data Packet Device Channel Address Register : Data Packet Device Base Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#72#) =>
                -- Data Packet Config Register : Data Packet CCD X Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#73#) =>
                -- Data Packet Config Register : Data Packet CCD Y Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#74#) =>
                -- Data Packet Config Register : Data Packet Data Y Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#75#) =>
                -- Data Packet Config Register : Data Packet Overscan Y Size
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#76#) =>
                -- Data Packet Config Register : Data Packet CCD V-Start
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_start(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#77#) =>
                -- Data Packet Config Register : Data Packet CCD V-End
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_v_end(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#78#) =>
                -- Data Packet Config Register : Data Packet CCD Image V-End
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_v_end(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#79#) =>
                -- Data Packet Config Register : Data Packet CCD Overscan V-End
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#7A#) =>
                -- Data Packet Config Register : Data Packet CCD H-Start
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_start(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#7B#) =>
                -- Data Packet Config Register : Data Packet CCD H-End
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_h_end(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#7C#) =>
                -- Data Packet Config Register : Data Packet CCD Image Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_img_en <= avs_writedata_i(0);
            -- end if;

            when (16#7D#) =>
                -- Data Packet Config Register : Data Packet CCD Overscan Enable
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_ovs_en <= avs_writedata_i(0);
            -- end if;

            when (16#7E#) =>
                -- Data Packet Config Register : Data Packet Packet Length
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_packet_length(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_packet_length(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#7F#) =>
                -- Data Packet Config Register : Data Packet Logical Address
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_logical_addr <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#80#) =>
                -- Data Packet Config Register : Data Packet Protocol ID
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_protocol_id <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#81#) =>
                -- Data Packet Config Register : Data Packet FEE Mode
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_fee_mode <= avs_writedata_i(4 downto 0);
            -- end if;

            when (16#82#) =>
                -- Data Packet Config Register : Data Packet CCD Number
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_config_reg.data_pkt_ccd_number <= avs_writedata_i(1 downto 0);
            -- end if;

            when (16#83#) =>
                -- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode <= avs_writedata_i(0);
            -- end if;

            when (16#88#) =>
                -- Data Packet Pixel Delay Register : Data Packet Start Delay
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_start_delay(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#89#) =>
                -- Data Packet Pixel Delay Register : Data Packet Skip Delay
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_skip_delay(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#8A#) =>
                -- Data Packet Pixel Delay Register : Data Packet Line Delay
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#8B#) =>
                -- Data Packet Pixel Delay Register : Data Packet ADC Delay
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#8C#) =>
                -- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_eep_received <= avs_writedata_i(0);
            -- end if;

            when (16#8D#) =>
                -- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#8E#) =>
                -- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.spw_error_injection_control_reg.spw_errinj_n_repeat(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#8F#) =>
                -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj <= avs_writedata_i(0);
            -- end if;

            when (16#90#) =>
                -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj <= avs_writedata_i(0);
            -- end if;

            when (16#91#) =>
                -- SpaceWire Codec Error Injection Control Register : SpaceWire Codec Error Injection Error Code
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.spw_codec_errinj_control_reg.errinj_ctrl_errinj_code <= avs_writedata_i(3 downto 0);
            -- end if;

            when (16#94#) =>
                -- RMAP Error Injection Control Register : Reset RMAP Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_reset <= avs_writedata_i(0);
            -- end if;

            when (16#95#) =>
                -- RMAP Error Injection Control Register : Trigger RMAP Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_trigger <= avs_writedata_i(0);
            -- end if;

            when (16#96#) =>
                -- RMAP Error Injection Control Register : Error ID of RMAP Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_err_id <= avs_writedata_i(7 downto 0);
            -- end if;

            when (16#97#) =>
                -- RMAP Error Injection Control Register : Value of RMAP Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_value(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_value(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_value(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_value(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#98#) =>
                -- RMAP Error Injection Control Register : Repetitions of RMAP Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_repeats(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.rmap_error_injection_control_reg.rmap_errinj_repeats(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#99#) =>
                -- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_tx_disabled <= avs_writedata_i(0);
            -- end if;

            when (16#9A#) =>
                -- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_pkts <= avs_writedata_i(0);
            -- end if;

            when (16#9B#) =>
                -- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_missing_data <= avs_writedata_i(0);
            -- end if;

            when (16#9C#) =>
                -- Transmission Error Injection Control Register : Frame Number of Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_frame_num <= avs_writedata_i(1 downto 0);
            -- end if;

            when (16#9D#) =>
                -- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#9E#) =>
                -- Transmission Error Injection Control Register : Data Counter of Transmission Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_data_cnt(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#9F#) =>
                -- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.trans_error_injection_control_reg.trans_errinj_n_repeat(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#A0#) =>
                -- Left Content Error Injection Control Register : Open the Left Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_open <= avs_writedata_i(0);
            -- end if;

            when (16#A1#) =>
                -- Left Content Error Injection Control Register : Close the Left Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_close <= avs_writedata_i(0);
            -- end if;

            when (16#A2#) =>
                -- Left Content Error Injection Control Register : Clear Left Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_clear <= avs_writedata_i(0);
            -- end if;

            when (16#A3#) =>
                -- Left Content Error Injection Control Register : Write to Left Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_write <= avs_writedata_i(0);
            -- end if;

            when (16#A4#) =>
                -- Left Content Error Injection Control Register : Start Injection of Left Content Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start <= avs_writedata_i(0);
            -- end if;

            when (16#A5#) =>
                -- Left Content Error Injection Control Register : Stop Injection of Left Content Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop <= avs_writedata_i(0);
            -- end if;

            when (16#A6#) =>
                -- Left Content Error Injection Control Register : Start Frame of Left Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start_frame(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_start_frame(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#A7#) =>
                -- Left Content Error Injection Control Register : Stop Frame of Left Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop_frame(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_stop_frame(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#A8#) =>
                -- Left Content Error Injection Control Register : Pixel Column (x-position) of Left Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_col(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_col(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#A9#) =>
                -- Left Content Error Injection Control Register : Pixel Row (y-position) of Left Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_row(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_row(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#AA#) =>
                -- Left Content Error Injection Control Register : Pixel Value of Left Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_value(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.left_content_error_injection_control_reg.left_content_errinj_pixel_value(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#AF#) =>
                -- Right Content Error Injection Control Register : Open the Right Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_open <= avs_writedata_i(0);
            -- end if;

            when (16#B0#) =>
                -- Right Content Error Injection Control Register : Close the Right Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_close <= avs_writedata_i(0);
            -- end if;

            when (16#B1#) =>
                -- Right Content Error Injection Control Register : Clear Right Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_clear <= avs_writedata_i(0);
            -- end if;

            when (16#B2#) =>
                -- Right Content Error Injection Control Register : Write to Right Content Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_write <= avs_writedata_i(0);
            -- end if;

            when (16#B3#) =>
                -- Right Content Error Injection Control Register : Start Injection of Right Content Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start <= avs_writedata_i(0);
            -- end if;

            when (16#B4#) =>
                -- Right Content Error Injection Control Register : Stop Injection of Right Content Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop <= avs_writedata_i(0);
            -- end if;

            when (16#B5#) =>
                -- Right Content Error Injection Control Register : Start Frame of Right Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start_frame(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_start_frame(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#B6#) =>
                -- Right Content Error Injection Control Register : Stop Frame of Right Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#B7#) =>
                -- Right Content Error Injection Control Register : Pixel Column (x-position) of Right Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#B8#) =>
                -- Right Content Error Injection Control Register : Pixel Row (y-position) of Right Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#B9#) =>
                -- Right Content Error Injection Control Register : Pixel Value of Right Content Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#BE#) =>
                -- Header Error Injection Control Register : Open the Header Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_open <= avs_writedata_i(0);
            -- end if;

            when (16#BF#) =>
                -- Header Error Injection Control Register : Close the Header Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_close <= avs_writedata_i(0);
            -- end if;

            when (16#C0#) =>
                -- Header Error Injection Control Register : Clear Header Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_clear <= avs_writedata_i(0);
            -- end if;

            when (16#C1#) =>
                -- Header Error Injection Control Register : Write to Header Error List
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_write <= avs_writedata_i(0);
            -- end if;

            when (16#C2#) =>
                -- Header Error Injection Control Register : Start Injection of Header Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_start <= avs_writedata_i(0);
            -- end if;

            when (16#C3#) =>
                -- Header Error Injection Control Register : Stop Injection of Header Errors
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_stop <= avs_writedata_i(0);
            -- end if;

            when (16#C4#) =>
                -- Header Error Injection Control Register : Frame Number of Header Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_frame_num <= avs_writedata_i(1 downto 0);
            -- end if;

            when (16#C5#) =>
                -- Header Error Injection Control Register : Sequence Counter of Header Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_sequence_cnt(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_sequence_cnt(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#C6#) =>
                -- Header Error Injection Control Register : Field ID of Header Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_field_id <= avs_writedata_i(3 downto 0);
            -- end if;

            when (16#C7#) =>
                -- Header Error Injection Control Register : Value of Header Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_value(7 downto 0)  <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.header_error_injection_control_reg.header_errinj_value(15 downto 8) <= avs_writedata_i(15 downto 8);
            -- end if;

            when (16#CC#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 15
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_15(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#CD#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 14
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_14(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#CE#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 13
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_13(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#CF#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 12
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_12(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D0#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 11
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_11(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D1#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 10
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_10(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D2#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 9
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_9(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D3#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 8
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_8(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D4#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 7
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_7(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D5#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 6
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_6(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D6#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 5
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_5(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D7#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 4
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_4(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D8#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 3
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_3(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#D9#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 2
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_2(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#DA#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 1
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_1(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#DB#) =>
                -- Windowing Parameters Register : Windowing Packet Order List Dword 0
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(7 downto 0)   <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(15 downto 8)  <= avs_writedata_i(15 downto 8);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(2) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(23 downto 16) <= avs_writedata_i(23 downto 16);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(3) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_packet_order_list_0(31 downto 24) <= avs_writedata_i(31 downto 24);
            -- end if;

            when (16#DC#) =>
                -- Windowing Parameters Register : Windowing Last E Packet
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_last_e_packet(7 downto 0) <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_last_e_packet(9 downto 8) <= avs_writedata_i(9 downto 8);
            -- end if;

            when (16#DD#) =>
                -- Windowing Parameters Register : Windowing Last F Packet
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_last_f_packet(7 downto 0) <= avs_writedata_i(7 downto 0);
                -- end if;
                -- if (avalon_mm_spacewire_i.byteenable(1) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_last_f_packet(9 downto 8) <= avs_writedata_i(9 downto 8);
            -- end if;

            when (16#DE#) =>
                -- Windowing Parameters Register : Windowing X-Coordinate Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_x_coordinate_error <= avs_writedata_i(0);
            -- end if;

            when (16#DF#) =>
                -- Windowing Parameters Register : Windowing Y-Coordinate Error
                -- if (avalon_mm_spacewire_i.byteenable(0) = '1') then
                s_avs_write_registers_o.windowing_parameters_reg.windowing_y_coordinate_error <= avs_writedata_i(0);
            -- end if;

            when others =>
                -- No register associated to the address, do nothing
                null;

        end case;

    end procedure p_avs_writedata;

end package body avalon_mm_spacewire_registers_write_pkg;
