onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group testbench_top /testbench_top/clk200
add wave -noupdate -expand -group testbench_top /testbench_top/clk100
add wave -noupdate -expand -group testbench_top /testbench_top/rst
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_comm_di
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_comm_do
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_comm_si
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_comm_so
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_dummy_di
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_dummy_do
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_dummy_si
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_codec_dummy_so
add wave -noupdate -expand -group testbench_top /testbench_top/s_spw_clock
add wave -noupdate -expand -group testbench_top /testbench_top/s_irq_rmap
add wave -noupdate -expand -group testbench_top /testbench_top/s_irq_buffers
add wave -noupdate -expand -group testbench_top /testbench_top/s_sync
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_readdata
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_waitrequest
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_address
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_write
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_writedata
add wave -noupdate -expand -group testbench_top /testbench_top/s_config_avalon_stimuli_mm_read
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_R_stimuli_mm_waitrequest
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_R_stimuli_mm_address
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_R_stimuli_mm_write
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_R_stimuli_mm_writedata
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_L_stimuli_mm_waitrequest
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_L_stimuli_mm_address
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_L_stimuli_mm_write
add wave -noupdate -expand -group testbench_top /testbench_top/s_avalon_buffer_L_stimuli_mm_writedata
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_tx_flag
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_tx_control
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_rxvalid
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_rxhalff
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_rxflag
add wave -noupdate -expand -group testbench_top -radix hexadecimal /testbench_top/s_dummy_spw_rxdata
add wave -noupdate -expand -group testbench_top /testbench_top/s_dummy_spw_rxread
add wave -noupdate -expand -group testbench_top -expand -group p_dummy_reader /testbench_top/p_codec_dummy_read/v_time_counter
add wave -noupdate -expand -group testbench_top -expand -group p_dummy_reader /testbench_top/p_codec_dummy_read/v_data_counter
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/clk_i
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/rst_i
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_readdata_i
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_address_o
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_write_o
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/avalon_mm_read_o
add wave -noupdate -group config_stimulli /testbench_top/config_avalon_stimuli_inst/s_counter
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/clk_i
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/rst_i
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_address_o
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_write_o
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_counter
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_address_cnt
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_mask_cnt
add wave -noupdate -group R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_times_cnt
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/clk_i
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/rst_i
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/avalon_mm_address_o
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/avalon_mm_write_o
add wave -noupdate -group L_stimulli -radix hexadecimal /testbench_top/avalon_buffer_L_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/s_counter
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/s_address_cnt
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/s_mask_cnt
add wave -noupdate -group L_stimulli /testbench_top/avalon_buffer_L_stimuli_inst/s_times_cnt
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/reset_sink_reset
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/data_in
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/strobe_in
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/strobe_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/sync_channel
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/rmap_interrupt_sender_irq
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/buffers_interrupt_sender_irq
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/clock_sink_200_clk
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/clock_sink_100_clk
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_readdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_writedata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_writedata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_writedata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/rst_n
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_buffer_0_empty_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_buffer_1_empty_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_buffer_0_empty_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_buffer_1_empty_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_write_finished_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_buffer_0_empty
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_buffer_1_empty
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_buffer_0_empty
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_buffer_1_empty
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_read_readdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_read_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_write_waitrequest
add wave -noupdate -group comm_1_80 -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_1_reg {-height 15 -childformat {{/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_1_reg.data_pkt_ccd_x_size -radix unsigned} {/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_1_reg.data_pkt_ccd_y_size -radix unsigned}} -expand} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_1_reg.data_pkt_ccd_x_size {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_1_reg.data_pkt_ccd_y_size {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_2_reg {-height 15 -childformat {{/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_2_reg.data_pkt_data_y_size -radix unsigned} {/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_2_reg.data_pkt_overscan_y_size -radix unsigned}} -expand} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_2_reg.data_pkt_data_y_size {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_2_reg.data_pkt_overscan_y_size {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_3_reg {-height 15 -childformat {{/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_3_reg.data_pkt_packet_length -radix unsigned}} -expand} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_3_reg.data_pkt_packet_length {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_4_reg {-height 15 -childformat {{/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_4_reg.data_pkt_fee_mode -radix unsigned} {/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_4_reg.data_pkt_ccd_number -radix unsigned}} -expand} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_4_reg.data_pkt_fee_mode {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.data_packet_config_4_reg.data_pkt_ccd_number {-height 15 -radix unsigned}} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spacewire_read_registers
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_data
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_data_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_mask_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_mask_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_data
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_data_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_mask_write
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_mask_read
add wave -noupdate -group comm_1_80 -radix hexadecimal /testbench_top/comm_v1_01_top_inst/s_L_window_data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_rxhalff
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txrdy
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txhalff
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txwrite
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txflag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txrdy
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txwrite
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txflag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_read
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_read
add wave -noupdate -group comm_1_80 -radix hexadecimal /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_out
add wave -noupdate -group comm_1_80 -radix hexadecimal /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_ready
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txrdy
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txwrite
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txflag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_control
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_flag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_byte_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_slave_imgdata_start
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_slave_frame_counter
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_fee_slave_frame_number
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_command_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_status_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_error_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_timecode_rx_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_rx_status_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_tx_status_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_timecode_tx_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_rx_command_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_tx_command_clk200
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_spw_control
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_spw_flag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_control
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_flag
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_wr_byte_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_rd_byte_address
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_config_area
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_mem_hk_area
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_write_data_finished
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_rmap_read_data_finished
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_read_readdata
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_read_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_write_waitrequest
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_timecode_tick
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_timecode_control
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_timecode_counter
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_current_timecode
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_sync_in_trigger
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_sync_in_delayed
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_rx_channel_command
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_rx_channel_status
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_channel_command
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_channel_status
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_1_command
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_1_status
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_2_command
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_mux_tx_2_status
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_right_buffer_size
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_left_buffer_size
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_dummy_spw_mux_tx0_txhalff
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_tick_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_ctrl_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_time_out
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/a_reset
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/a_avs_clock
add wave -noupdate -group comm_1_80 /testbench_top/comm_v1_01_top_inst/a_spw_clock
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/clk_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/rst_i
add wave -noupdate -group left_windowing_buffer -radix unsigned /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_buffer_size_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/fee_start_signal_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_write_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_write_i
add wave -noupdate -group left_windowing_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -group left_windowing_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -group left_windowing_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_buffer_0_empty_o
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_buffer_1_empty_o
add wave -noupdate -group left_windowing_buffer -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control.read -expand /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control.write -expand} /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control
add wave -noupdate -group left_windowing_buffer -childformat {{/testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data.data -radix hexadecimal}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data.data {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_status
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_rd_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_status
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_rd_data
add wave -noupdate -group left_windowing_buffer -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control.read -expand /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control.write -expand} /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_wr_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_status
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_rd_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_control
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_wr_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_status
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_rd_data
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_write_data_buffer_0_active
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_write_mask_buffer_0_active
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_read_data_buffer_0_active
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_read_mask_buffer_0_active
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_0_ready
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_1_ready
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_0_ready
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_1_ready
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_0_lock
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_1_lock
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_0_lock
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_1_lock
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_window_mask_buffer_size
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_window_data_buffer_size
add wave -noupdate -group left_windowing_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_stopped_flag
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/clk_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/rst_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_size_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_clear_signal_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_stop_signal_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_start_signal_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_write_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_write_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_0_empty_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_1_empty_o
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_status
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_rd_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_status
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_rd_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_wr_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_status
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_rd_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_control
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_wr_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_status
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_rd_data
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_data_buffer_0_active
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_mask_buffer_0_active
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_data_buffer_0_active
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_mask_buffer_0_active
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_ready
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_ready
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_ready
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_ready
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_lock
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_lock
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_lock
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_lock
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_window_mask_buffer_size
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_window_data_buffer_size
add wave -noupdate -group right_windowing_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_stopped_flag
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/clk_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/rst_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_sync_signal_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_current_timecode_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_machine_clear_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_machine_stop_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_machine_start_i
add wave -noupdate -group left_master_fee_data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_data_i
add wave -noupdate -group left_master_fee_data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_mask_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_data_ready_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_mask_ready_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_hk_mem_valid_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_hk_mem_data_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_spw_tx_ready_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_ccd_x_size_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_ccd_y_size_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_data_y_size_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_overscan_y_size_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_packet_length_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_fee_mode_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_ccd_number_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_line_delay_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_column_delay_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_adc_delay_i
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_slave_imgdata_start_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_slave_frame_counter_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_slave_frame_number_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_data_read_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_window_mask_read_o
add wave -noupdate -group left_master_fee_data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_hk_mem_byte_address_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_hk_mem_read_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_spw_tx_write_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_spw_tx_flag_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_spw_tx_data_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_header_length_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_header_type_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_header_frame_counter_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_pkt_header_sequence_counter_o
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_current_frame_number
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_current_frame_counter
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_masking_machine_hold
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_masking_buffer_rdreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_masking_buffer_almost_empty
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_masking_buffer_empty
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_masking_buffer_rddata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_logical_address
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_length_field
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_mode
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_last_packet
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_ccd_side
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_ccd_number
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_frame_number
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_type_field_packet_type
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_frame_counter
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_headerdata_sequence_counter
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_header_gen_busy
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_header_gen_finished
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_header_gen_send
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_header_gen_reset
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_header_gen_wrdata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_header_gen_wrreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_housekeeping_wr_busy
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_housekeeping_wr_finished
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_housekeeping_wr_start
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_housekeeping_wr_reset
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_housekeeping_wr_wrdata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_housekeeping_wr_wrreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_wr_busy
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_wr_finished
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_wr_start
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_wr_reset
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_wr_length
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_data_wr_wrdata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_data_wr_wrreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_fee_data_loaded
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_wrdata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_wrreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_rdreq
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_stat_almost_empty
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_stat_almost_full
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_stat_empty
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_stat_full
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_rddata
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_rdready
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_send_buffer_wrready
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_transmitter_busy
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_data_transmitter_finished
add wave -noupdate -group left_master_fee_data_controller /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/s_start_masking
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/clk_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/rst_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/sync_signal_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_start_signal_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_start_masking_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_machine_hold_i
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_ccd_x_size_i
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_ccd_y_size_i
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_line_delay_i
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_column_delay_i
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_adc_delay_i
add wave -noupdate -group left_masking_machine -radix unsigned -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(7) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(6) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(5) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(4) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(3) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(2) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(1) -radix unsigned} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(0) -radix unsigned}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(7) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(6) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(5) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(4) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(3) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(2) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(1) {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i(0) {-height 15 -radix unsigned}} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i
add wave -noupdate -group left_masking_machine -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_i
add wave -noupdate -group left_masking_machine -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_ready_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_ready_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_rdreq_i
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_read_o
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_read_o
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_almost_empty_o
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_empty_o
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_rddata_o
add wave -noupdate -group left_masking_machine -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data -radix hexadecimal -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(7) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(6) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(5) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(4) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(3) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(2) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(1) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(0) -radix hexadecimal}}}} -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data {-height 15 -radix hexadecimal -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(7) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(6) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(5) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(4) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(3) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(2) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(1) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(0) -radix hexadecimal}} -expand} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(7) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(6) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(5) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(4) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(3) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(2) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(1) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo.data(0) {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_machine_state
add wave -noupdate -group left_masking_machine -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_registered_window_data
add wave -noupdate -group left_masking_machine -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_registered_window_mask
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_mask_counter
add wave -noupdate -group left_masking_machine /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_delay
add wave -noupdate -group left_masking_machine -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_fee_remaining_data_bytes
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/clk_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/rst_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_start_signal_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/sync_signal_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/current_frame_number_i
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/current_frame_counter_i
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_ccd_x_size_i
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_data_y_size_i
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_overscan_y_size_i
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_packet_length_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_fee_mode_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_ccd_number_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/fee_ccd_side_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/header_gen_finished_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/housekeeping_wr_finished_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/data_wr_finished_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/data_transmitter_finished_i
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/imgdata_start_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/masking_machine_hold_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_logical_address_o
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_length_field_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_mode_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_last_packet_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_ccd_side_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_ccd_number_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_frame_number_o
add wave -noupdate -group left_master_fee_data_manager -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_type_field_packet_type_o
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_frame_counter_o
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/headerdata_sequence_counter_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/header_gen_send_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/header_gen_reset_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/housekeeping_wr_start_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/housekeeping_wr_reset_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/data_wr_start_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/data_wr_reset_o
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/data_wr_length_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/send_buffer_fee_data_loaded_o
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/s_fee_data_manager_state
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/s_fee_remaining_data_bytes
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/s_fee_sequence_counter
add wave -noupdate -group left_master_fee_data_manager -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/s_fee_current_packet_data_size
add wave -noupdate -group left_master_fee_data_manager /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/fee_master_data_manager_ent_inst/s_last_packet_flag
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/clk_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/rst_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/fee_start_signal_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/header_gen_send_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/header_gen_reset_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_logical_address_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_length_field_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_mode_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_last_packet_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_ccd_side_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_ccd_number_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_frame_number_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_type_field_packet_type_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_frame_counter_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/headerdata_sequence_counter_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/send_buffer_stat_almost_full_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/send_buffer_stat_full_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/send_buffer_wrready_i
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/header_gen_busy_o
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/header_gen_finished_o
add wave -noupdate -group left_data_packet_header_gen -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/send_buffer_wrdata_o
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/send_buffer_wrreq_o
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/s_header_gen_state
add wave -noupdate -group left_data_packet_header_gen /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_header_gen_ent_inst/s_header_gen_next_state
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/clk_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/rst_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/fee_start_signal_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/housekeeping_wr_start_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/housekeeping_wr_reset_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/hk_mem_valid_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/hk_mem_data_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/send_buffer_stat_almost_full_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/send_buffer_stat_full_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/send_buffer_wrready_i
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/housekeeping_wr_busy_o
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/housekeeping_wr_finished_o
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/hk_mem_byte_address_o
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/hk_mem_read_o
add wave -noupdate -group left_data_packet_hk_writer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/send_buffer_wrdata_o
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/send_buffer_wrreq_o
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/s_housekeeping_writer_state
add wave -noupdate -group left_data_packet_hk_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_hk_writer_ent_inst/s_housekepping_addr
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/clk_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/rst_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/fee_start_signal_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/data_wr_start_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/data_wr_reset_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/data_wr_length_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/masking_buffer_almost_empty_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/masking_buffer_empty_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/masking_buffer_rddata_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/send_buffer_stat_almost_full_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/send_buffer_stat_full_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/send_buffer_wrready_i
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/data_wr_busy_o
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/data_wr_finished_o
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/masking_buffer_rdreq_o
add wave -noupdate -group left_data_packet_data_writer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/send_buffer_wrdata_o
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/send_buffer_wrreq_o
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/s_data_writer_state
add wave -noupdate -group left_data_packet_data_writer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_packet_data_writer_ent_inst/s_data_cnt
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/clk_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/rst_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/fee_start_signal_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/fee_data_loaded_i
add wave -noupdate -group left_send_buffer -radix unsigned /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_cfg_length_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_wrdata_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_wrreq_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_rdreq_i
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_stat_almost_empty_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_stat_almost_full_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_stat_empty_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_stat_full_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_rddata_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_rdready_o
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/buffer_wrready_o
add wave -noupdate -group left_send_buffer -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_0.data -radix hexadecimal}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_0.data {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_0
add wave -noupdate -group left_send_buffer -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.data -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.q -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.usedw -radix unsigned}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.data {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.q {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1.usedw {-height 15 -radix unsigned}} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_send_buffer_write_state
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_send_buffer_read_state
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_wr_data_buffer_selection
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_rd_data_buffer_selection
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_0_rdhold
add wave -noupdate -group left_send_buffer /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/send_buffer_ent_inst/s_data_fifo_1_rdhold
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/clk_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/rst_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/fee_clear_signal_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/fee_stop_signal_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/fee_start_signal_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/send_buffer_stat_almost_empty_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/send_buffer_stat_empty_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/send_buffer_rddata_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/send_buffer_rdready_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_ready_i
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/data_transmitter_busy_o
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/data_transmitter_finished_o
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/send_buffer_rdreq_o
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_write_o
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_flag_o
add wave -noupdate -group left_data_transmitter -radix hexadecimal -childformat {{/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(7) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(6) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(5) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(4) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(3) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(2) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(1) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(0) -radix hexadecimal}} -subitemconfig {/testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(7) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(6) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(5) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(4) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(3) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(2) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(1) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o(0) {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/spw_tx_data_o
add wave -noupdate -group left_data_transmitter /testbench_top/comm_v1_01_top_inst/left_fee_master_data_controller_top_inst/data_transmitter_ent_inst/s_data_transmitter_state
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/clk_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/rst_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_codec_rx_status_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_codec_tx_status_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_rx_0_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_0_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_1_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_2_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_codec_rx_command_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_codec_tx_command_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_rx_0_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_0_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_1_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/spw_mux_tx_2_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_mux_rx_selection
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_mux_tx_selection
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_spw_mux_state
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_tx_flag_buffer
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_tx_data_buffer
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_tx_pending_write
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_tx_channel_lock
add wave -noupdate -expand -group spw_mux /testbench_top/comm_v1_01_top_inst/spw_mux_ent_inst/s_spw_tx_fsm_command
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {138157895 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 197
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {525 us}
