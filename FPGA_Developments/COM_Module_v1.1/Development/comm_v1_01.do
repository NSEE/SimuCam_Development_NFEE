onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/reset_sink_reset
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/data_in
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/data_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/strobe_in
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/strobe_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/interrupt_sender_irq
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/clock_sink_200_clk
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_address
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_read
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_readdata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_writedata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_windowing_waitrequest
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_address
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_waitrequest
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_L_buffer_writedata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_address
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_writedata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/avalon_slave_R_buffer_waitrequest
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_buffer_empty_delayed
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_buffer_empty_delayed
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_read_waitrequest
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_avalon_mm_windwoing_write_waitrequest
add wave -noupdate -group comm_v1_01_top -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.interrupt_flag_clear -expand /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers.interrupt_control -expand} /testbench_top/comm_v1_01_top_inst/s_spacewire_write_registers
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spacewire_read_registers
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_data
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_data_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_mask_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_data_read
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_mask_read
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_data_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_mask_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_data_ready
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_R_window_mask_ready
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_data
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_data_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_mask_write
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_data_read
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_mask_read
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_data_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_mask_out
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_data_ready
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_L_window_mask_ready
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_rxvalid
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_rxhalff
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_rxflag
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_rxdata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_rxread
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_txrdy
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_txhalff
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_txwrite
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_txflag
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/s_spw_txdata
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/a_reset
add wave -noupdate -group comm_v1_01_top /testbench_top/comm_v1_01_top_inst/a_clock
add wave -noupdate -group config_write /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/clk_i
add wave -noupdate -group config_write /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/rst_i
add wave -noupdate -group config_write -expand /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/avalon_mm_spacewire_i
add wave -noupdate -group config_write -expand /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/avalon_mm_spacewire_o
add wave -noupdate -group config_write -expand /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/spacewire_write_registers_o
add wave -noupdate -group config_write /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/p_avalon_mm_spacewire_write/v_write_address
add wave -noupdate -group config_read /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/clk_i
add wave -noupdate -group config_read /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/rst_i
add wave -noupdate -group config_read /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/avalon_mm_spacewire_i
add wave -noupdate -group config_read /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/avalon_mm_spacewire_o
add wave -noupdate -group config_read /testbench_top/comm_v1_01_top_inst/avalon_mm_spacewire_write_ent_inst/spacewire_write_registers_o
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/clk_i
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/rst_i
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/mask_enable_i
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_o
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_data_write_o
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_mask_write_o
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/window_data_o
add wave -noupdate -group R_buffer_write /testbench_top/comm_v1_01_top_inst/rigth_avalon_mm_windowing_write_ent_inst/s_windown_data_ctn
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/clk_i
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/rst_i
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_write_i
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_write_i
add wave -noupdate -expand -group R_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_i
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -expand -group R_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -expand -group R_buffer -radix hexadecimal /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control
add wave -noupdate -expand -group R_buffer -childformat {{/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data.data -radix hexadecimal}} -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data.data {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_status
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_0_rd_data
add wave -noupdate -expand -group R_buffer -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control.read -expand /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control.write -expand} /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control
add wave -noupdate -expand -group R_buffer -radix hexadecimal -childformat {{/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data.data -radix hexadecimal}} -expand -subitemconfig {/testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data.data {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_status
add wave -noupdate -expand -group R_buffer -expand /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_rd_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_wr_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_status
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_data_fifo_1_rd_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_control
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_wr_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_status
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_rd_data
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_data_buffer_0_active
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_write_mask_buffer_0_active
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_data_buffer_0_active
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_read_mask_buffer_0_active
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_ready
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_ready
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_ready
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_ready
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_0_lock
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_data_buffer_1_lock
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_0_lock
add wave -noupdate -expand -group R_buffer /testbench_top/comm_v1_01_top_inst/rigth_windowing_buffer_ent_inst/s_mask_buffer_1_lock
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/clk_i
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/rst_i
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_i
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/mask_enable_i
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/avalon_mm_windowing_o
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/window_data_write_o
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/window_mask_write_o
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/window_data_o
add wave -noupdate -group L_buffer_write /testbench_top/comm_v1_01_top_inst/left_avalon_mm_windowing_write_ent_inst/s_windown_data_ctn
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/clk_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/rst_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_write_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_write_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_read_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_read_i
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_o
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_o
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_data_ready_o
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_mask_ready_o
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/window_buffer_empty_o
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_control
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_wr_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_status
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_0_rd_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_control
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_wr_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_status
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_0_rd_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_control
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_wr_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_status
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_data_fifo_1_rd_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_control
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_wr_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_status
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_windowing_mask_fifo_1_rd_data
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_write_data_buffer_0_active
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_write_mask_buffer_0_active
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_read_data_buffer_0_active
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_read_mask_buffer_0_active
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_0_ready
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_data_buffer_1_ready
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_0_ready
add wave -noupdate -group L_buffer /testbench_top/comm_v1_01_top_inst/left_windowing_buffer_ent_inst/s_mask_buffer_1_ready
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/clk_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/rst_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/mask_enable_i
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_R_i
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_R_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_R_ready_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_R_ready_i
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_L_i
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_L_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_L_ready_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_L_ready_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txrdy_i
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_R_read_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_R_read_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_data_L_read_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/window_mask_L_read_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txwrite_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txflag_o
add wave -noupdate -expand -group data_controller -radix hexadecimal -childformat {{/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(7) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(6) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(5) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(4) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(3) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(2) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(1) -radix hexadecimal} {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(0) -radix hexadecimal}} -subitemconfig {/testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(7) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(6) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(5) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(4) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(3) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(2) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(1) {-height 15 -radix hexadecimal} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o(0) {-height 15 -radix hexadecimal}} /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/spw_txdata_o
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_data_controller_state
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_registered_window_data
add wave -noupdate -expand -group data_controller -radix hexadecimal /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_registered_window_mask
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_packet_size_counter
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_mask_counter
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_windowing_buffer_side
add wave -noupdate -expand -group data_controller /testbench_top/comm_v1_01_top_inst/data_controller_ent_inst/s_next_windowing_buffer_side
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/clk_200
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/rst
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_link_command_i
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_ds_encoding_rx_i
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_timecode_tx_i
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_data_rx_command_i
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_data_tx_command_i
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_link_status_o
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_ds_encoding_tx_o
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_link_error_o
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_timecode_rx_o
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_data_rx_status_o
add wave -noupdate -group spw_codec /testbench_top/comm_v1_01_top_inst/spw_codec_ent_inst/spw_codec_data_tx_status_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45769231 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 355
configure wave -valuecolwidth 230
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
WaveRestoreZoom {0 ps} {105 us}
