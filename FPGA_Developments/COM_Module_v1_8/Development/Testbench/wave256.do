onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group top /testbench_top/clk200
add wave -noupdate -expand -group top /testbench_top/clk100
add wave -noupdate -expand -group top /testbench_top/rst
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_comm_di
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_comm_do
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_comm_si
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_comm_so
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_dummy_di
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_dummy_do
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_dummy_si
add wave -noupdate -expand -group top /testbench_top/s_spw_codec_dummy_so
add wave -noupdate -expand -group top /testbench_top/s_spw_clock
add wave -noupdate -expand -group top /testbench_top/s_irq_rmap
add wave -noupdate -expand -group top /testbench_top/s_irq_buffers
add wave -noupdate -expand -group top /testbench_top/s_sync
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_readdata
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_waitrequest
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_address
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_write
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_writedata
add wave -noupdate -expand -group top /testbench_top/s_config_avalon_stimuli_mm_read
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_R_stimuli_mm_waitrequest
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_R_stimuli_mm_address
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_R_stimuli_mm_write
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_R_stimuli_mm_writedata
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_L_stimuli_mm_waitrequest
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_L_stimuli_mm_address
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_L_stimuli_mm_write
add wave -noupdate -expand -group top /testbench_top/s_avalon_buffer_L_stimuli_mm_writedata
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_tx_flag
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_tx_control
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_rxvalid
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_rxhalff
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_rxflag
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_rxdata
add wave -noupdate -expand -group top /testbench_top/s_dummy_spw_rxread
add wave -noupdate -expand -group top /testbench_top/s_delay_trigger
add wave -noupdate -expand -group top /testbench_top/s_delay_timer
add wave -noupdate -expand -group top /testbench_top/s_delay_busy
add wave -noupdate -expand -group top /testbench_top/s_delay_finished
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/clk_i
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/rst_i
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/s_counter
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/s_address_cnt
add wave -noupdate -expand -group R_stimuli /testbench_top/avalon_buffer_R_stimuli_inst/s_times_cnt
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
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_R_window_buffer_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/s_L_window_buffer_control
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_reset
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_avs_clock
add wave -noupdate -group comm /testbench_top/comm_v1_01_top_inst/a_spw_clock
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/clk_i
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/rst_i
add wave -noupdate -expand -group r_writew -childformat {{/testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i.address -radix unsigned} {/testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i.writedata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i.address {-height 15 -radix unsigned} /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i.writedata {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/fee_clear_signal_i
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_buffer_size_i
add wave -noupdate -expand -group r_writew -expand /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_buffer_control_i
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_buffer_control_i.locked
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_o
add wave -noupdate -expand -group r_writew /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_waitrequest
add wave -noupdate -expand -group r_writew -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_double_buffer_o(0) -expand /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_double_buffer_o(1) -expand} /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_double_buffer_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/clk_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/rst_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_clear_signal_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_stop_signal_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/fee_start_signal_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_control_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -expand -group r_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -expand -group r_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_0_empty_o
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_1_empty_o
add wave -noupdate -expand -group r_buffer -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_control.write -expand} /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_control
add wave -noupdate -expand -group r_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_wr_data
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_status
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_rd_data
add wave -noupdate -expand -group r_buffer -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_control.write -expand} /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_control
add wave -noupdate -expand -group r_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_wr_data
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_status
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_rd_data
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_stopped_flag
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_selected_read_dbuffer
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_0_empty
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_1_empty
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_0_readable
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_1_readable
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_write_state
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_read_state
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_data_cnt
add wave -noupdate -expand -group r_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_dbuffer_buffer_cnt
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/clk_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/rst_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/sync_signal_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_clear_signal_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_stop_signal_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_start_signal_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_start_masking_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_machine_hold_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_ccd_x_size_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_ccd_y_size_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_line_delay_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_column_delay_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/fee_adc_delay_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/current_timecode_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_ready_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_ready_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_rdreq_i
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_data_read_o
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/window_mask_read_o
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_almost_empty_o
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_empty_o
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/masking_buffer_rddata_o
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_fifo
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_machine_state
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_masking_machine_return_state
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_registered_window_data
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_registered_window_mask
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_mask_counter
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_delay
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_fee_remaining_data_bytes
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_adc_delay_trigger
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_adc_delay_timer
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_adc_delay_busy
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_adc_delay_finished
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_column_delay_trigger
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_column_delay_timer
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_column_delay_busy
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_column_delay_finished
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_line_delay_trigger
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_line_delay_timer
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_line_delay_busy
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_line_delay_finished
add wave -noupdate -group R_masking /testbench_top/comm_v1_01_top_inst/right_fee_master_data_controller_top_inst/masking_machine_ent_inst/s_ccd_column_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23116571 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
configure wave -valuecolwidth 403
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
WaveRestoreZoom {0 ps} {582605625 ps}
