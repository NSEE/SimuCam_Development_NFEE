onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group testbench /testbench_top/clk200
add wave -noupdate -group testbench /testbench_top/clk100
add wave -noupdate -group testbench /testbench_top/rst
add wave -noupdate -group testbench /testbench_top/s_spw_codec_comm_di
add wave -noupdate -group testbench /testbench_top/s_spw_codec_comm_do
add wave -noupdate -group testbench /testbench_top/s_spw_codec_comm_si
add wave -noupdate -group testbench /testbench_top/s_spw_codec_comm_so
add wave -noupdate -group testbench /testbench_top/s_spw_codec_dummy_di
add wave -noupdate -group testbench /testbench_top/s_spw_codec_dummy_do
add wave -noupdate -group testbench /testbench_top/s_spw_codec_dummy_si
add wave -noupdate -group testbench /testbench_top/s_spw_codec_dummy_so
add wave -noupdate -group testbench /testbench_top/s_spw_clock
add wave -noupdate -group testbench /testbench_top/s_irq_rmap
add wave -noupdate -group testbench /testbench_top/s_irq_buffers
add wave -noupdate -group testbench /testbench_top/s_sync
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_readdata
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_waitrequest
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_address
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_write
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_writedata
add wave -noupdate -group testbench /testbench_top/s_config_avalon_stimuli_mm_read
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_R_stimuli_mm_waitrequest
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_R_stimuli_mm_address
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_R_stimuli_mm_write
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_R_stimuli_mm_writedata
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_L_stimuli_mm_waitrequest
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_L_stimuli_mm_address
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_L_stimuli_mm_write
add wave -noupdate -group testbench /testbench_top/s_avalon_buffer_L_stimuli_mm_writedata
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_tx_flag
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_tx_control
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_rxvalid
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_rxhalff
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_rxflag
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_rxdata
add wave -noupdate -group testbench /testbench_top/s_dummy_spw_rxread
add wave -noupdate -group testbench /testbench_top/s_delay_trigger
add wave -noupdate -group testbench /testbench_top/s_delay_timer
add wave -noupdate -group testbench /testbench_top/s_delay_busy
add wave -noupdate -group testbench /testbench_top/s_delay_finished
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/clk_i
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/rst_i
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group avs_buff_R_stimulli -radix hexadecimal /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_counter
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_address_cnt
add wave -noupdate -expand -group avs_buff_R_stimulli /testbench_top/avalon_buffer_R_stimuli_inst/s_times_cnt
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/reset_sink_reset
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/data_in
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/strobe_in
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/strobe_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/sync_channel
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/rmap_interrupt_sender_irq
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/buffers_interrupt_sender_irq
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/clock_sink_200_clk
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/clock_sink_100_clk
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_readdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_writedata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_writedata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_writedata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/rst_n
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_buffer_0_empty_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_buffer_1_empty_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_buffer_0_empty_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_buffer_1_empty_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_write_finished_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_buffer_0_empty
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_buffer_1_empty
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_buffer_0_empty
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_buffer_1_empty
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_read_readdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_read_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_write_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spacewire_read_registers
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_data
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_data_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_mask_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_data
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_data_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_mask_write
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_R_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_L_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_rxhalff
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txrdy
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txhalff
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txwrite
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txflag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_data_controller_spw_txdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txrdy
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txwrite
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txflag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_spw_txdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_read
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_data_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_window_mask_ready
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txrdy
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txwrite
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txflag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_spw_txdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_flag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_data_controller_mem_rd_byte_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_mem_rd_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_fee_data_controller_mem_rd_byte_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_mem_rd_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_fee_data_controller_mem_rd_byte_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_slave_imgdata_start
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_slave_frame_counter
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_fee_slave_frame_number
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_command_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_status_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_link_error_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_timecode_rx_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_rx_status_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_tx_status_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_timecode_tx_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_rx_command_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_spw_codec_data_tx_command_clk200
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_spw_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_spw_flag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_flag
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_wr_byte_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_rd_byte_address
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_config_area
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_mem_hk_area
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_write_data_finished
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_rmap_read_data_finished
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_read_readdata
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_read_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_avalon_mm_rmap_mem_write_waitrequest
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_timecode_tick
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_timecode_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_timecode_counter
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_current_timecode
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_sync_in_trigger
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_sync_in_delayed
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_rx_channel_command
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_rx_channel_status
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_channel_command
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_channel_status
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_1_command
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_1_status
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_2_command
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_mux_tx_2_status
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_right_buffer_size
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_left_buffer_size
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_dummy_spw_mux_tx0_txhalff
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_tick_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_ctrl_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_dummy_timecode_rx_time_out
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_right_side_activated
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_left_side_activated
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_sync_channel_n
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_right_window_buffer_change
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_left_window_buffer_change
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_reset
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_avs_clock
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_spw_clock
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/clk_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/rst_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/mask_enable_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/fee_clear_signal_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_buffer_change_i
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_o
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_data_write_o
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_mask_write_o
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_data_o
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_window_data_ctn
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_waitrequest
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_data
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_rdreq
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_sclr
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_wrreq
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_empty
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_full
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_q
add wave -noupdate -expand -group R_avs_buff_write -radix unsigned /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_usedw
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_state
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_q_qword_0
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_q_qword_1
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_q_qword_2
add wave -noupdate -expand -group R_avs_buff_write -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_q_qword_3
add wave -noupdate -expand -group R_avs_buff_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_avsbuff_delay
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/clk_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/rst_i
add wave -noupdate -group R_windowing_buff -radix unsigned /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_size_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_clear_signal_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_stop_signal_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_start_signal_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_write_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_write_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_0_empty_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_1_empty_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_change_o
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_status
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_rd_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_status
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_rd_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_wr_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_status
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_rd_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_control
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_wr_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_status
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_rd_data
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_data_buffer_0_active
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_mask_buffer_0_active
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_data_buffer_0_active
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_mask_buffer_0_active
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_ready
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_ready
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_ready
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_ready
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_lock
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_lock
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_lock
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_lock
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_window_mask_buffer_size
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_window_data_buffer_size
add wave -noupdate -group R_windowing_buff /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_stopped_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13539474 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 354
configure wave -valuecolwidth 492
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
WaveRestoreZoom {0 ps} {15750 ns}
bookmark add wave bookmark0 {{0 ps} {21 us}} 0
