onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group top /testbench_top/clk100Avs
add wave -noupdate -group top /testbench_top/clk100Ftdi
add wave -noupdate -group top /testbench_top/rst
add wave -noupdate -group top -radix hexadecimal /testbench_top/s_umft_data_bus
add wave -noupdate -group top /testbench_top/s_umft_reset_n_pin
add wave -noupdate -group top /testbench_top/s_umft_rxf_n_pin
add wave -noupdate -group top /testbench_top/s_umft_wakeup_n_pin
add wave -noupdate -group top /testbench_top/s_umft_be_bus
add wave -noupdate -group top /testbench_top/s_umft_txe_n_pin
add wave -noupdate -group top /testbench_top/s_umft_gpio_bus
add wave -noupdate -group top /testbench_top/s_umft_wr_n_pin
add wave -noupdate -group top /testbench_top/s_umft_rd_n_pin
add wave -noupdate -group top /testbench_top/s_umft_oe_n_pin
add wave -noupdate -group top /testbench_top/s_umft_siwu_n_pin
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_address
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_write
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_read
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_readdata
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_writedata
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_waitrequest
add wave -noupdate -group top /testbench_top/s_avalon_slave_config_byteenable
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_address
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_write
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_read
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_writedata
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_readdata
add wave -noupdate -group top /testbench_top/s_avalon_slave_data_waitrequest
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/clk_i
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/rst_i
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_wr_n_pin_i
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_rd_n_pin_i
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_oe_n_pin_i
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_data_bus_io
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_wakeup_n_pin_io
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_be_bus_io
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_gpio_bus_io
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_rxf_n_pin_o
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/umft_txe_n_pin_o
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_data_out
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_wakeup_n_out
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_be_out
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_gpio_out
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_oe
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_data_in
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_wakeup_n_in
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_be_in
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_gpio_in
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_counter
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_counter2
add wave -noupdate -group ftdi_stimulli /testbench_top/usb3_fifo_master_stimuli_inst/s_times_cnt
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/clk_i
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/rst_i
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/avalon_mm_address_o
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/avalon_mm_write_o
add wave -noupdate -expand -group tx_data_stimulli -radix hexadecimal /testbench_top/tx_data_stimulli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/s_counter
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/s_times
add wave -noupdate -expand -group tx_data_stimulli /testbench_top/tx_data_stimulli_inst/s_wr_addr
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/clk_i
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/rst_i
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/avalon_mm_readdata_i
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group rx_data_stimulli -radix unsigned /testbench_top/rx_data_stimulli_inst/avalon_mm_address_o
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/avalon_mm_read_o
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/s_counter
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/s_times
add wave -noupdate -expand -group rx_data_stimulli /testbench_top/rx_data_stimulli_inst/s_rd_addr
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/clock_sink_clk
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/reset_sink_reset
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_data_bus
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_reset_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_rxf_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_clock_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_wakeup_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_be_bus
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_txe_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_gpio_bus
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_wr_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_rd_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_oe_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/umft_siwu_n_pin
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_address
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_write
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_read
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_readdata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_writedata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_config_byteenable
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_address
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_write
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_read
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_writedata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_readdata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/avalon_slave_data_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_config_avalon_mm_read_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_config_avalon_mm_write_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_config_write_registers
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_config_read_registers
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_data_avalon_mm_read_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_data_avalon_mm_write_waitrequest
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_data_loaded
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_wrdata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_wrreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_rdreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_change
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_stat_empty
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_stat_full
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dbuffer_rddata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrdata_data
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrdata_be
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrempty
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrfull
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_tx_dc_data_fifo_wrusedw
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_data_loaded
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_wrdata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_wrreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_rdreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_change
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_stat_empty
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_stat_full
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dbuffer_rddata
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rdreq
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rddata_data
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rddata_be
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rdempty
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rdfull
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/s_rx_dc_data_fifo_rdusedw
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/a_reset
add wave -noupdate -group ftdi_top /testbench_top/USB_3_FTDI_top_inst/a_avs_clock
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/clk_i
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/rst_i
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/ftdi_config_avalon_mm_i
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/ftdi_config_avalon_mm_o
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/ftdi_config_write_registers_i
add wave -noupdate -group config_read /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_read_ent_inst/ftdi_config_read_registers_i
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/clk_i
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/rst_i
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/ftdi_config_avalon_mm_i
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/ftdi_config_avalon_mm_o
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/ftdi_config_write_registers_o
add wave -noupdate -group config_write /testbench_top/USB_3_FTDI_top_inst/ftdi_config_avalon_mm_write_ent_inst/s_data_acquired
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/clk_i
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/rst_i
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/ftdi_tx_data_avalon_mm_i
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/buffer_stat_full_i
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/buffer_wrready_i
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/ftdi_tx_data_avalon_mm_o
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/buffer_data_loaded_o
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/buffer_wrdata_o
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/buffer_wrreq_o
add wave -noupdate -group tx_data_write /testbench_top/USB_3_FTDI_top_inst/ftdi_tx_data_avalon_mm_write_ent_inst/s_data_acquired
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/clk_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/rst_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/double_buffer_clear_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/double_buffer_stop_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/double_buffer_start_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_data_loaded_i
add wave -noupdate -expand -group tx_data_buffer -radix unsigned /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_cfg_length_i
add wave -noupdate -expand -group tx_data_buffer -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_wrdata_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_wrreq_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_rdreq_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_change_i
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/double_buffer_empty_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/double_buffer_full_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_stat_almost_empty_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_stat_almost_full_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_stat_empty_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_stat_full_o
add wave -noupdate -expand -group tx_data_buffer -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_rddata_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_rdready_o
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/buffer_wrready_o
add wave -noupdate -expand -group tx_data_buffer -childformat {{/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.data -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.q -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.usedw -radix unsigned}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.data {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.q {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0.usedw {-height 15 -radix unsigned}} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0
add wave -noupdate -expand -group tx_data_buffer -childformat {{/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.data -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.q -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.usedw -radix unsigned}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.data {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.q {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1.usedw {-height 15 -radix unsigned}} /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_buffer_write_state
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_buffer_read_state
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_wr_data_buffer_selection
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_rd_data_buffer_selection
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0_rdhold
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1_rdhold
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0_wrhold
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1_wrhold
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_0_extended_usedw
add wave -noupdate -expand -group tx_data_buffer /testbench_top/USB_3_FTDI_top_inst/tx_data_buffer_ent_inst/s_data_fifo_1_extended_usedw
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/clk_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/rst_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/data_tx_stop_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/data_tx_start_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/buffer_stat_empty_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/buffer_rddata_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/buffer_rdready_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/tx_dc_data_fifo_wrfull_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/tx_dc_data_fifo_wrusedw_i
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/buffer_rdreq_o
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/buffer_change_o
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/tx_dc_data_fifo_wrdata_data_o
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/tx_dc_data_fifo_wrdata_be_o
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/tx_dc_data_fifo_wrreq_o
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/s_ftdi_data_transmitter_state
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/s_tx_dword_0
add wave -noupdate -group tx_data_transmitter /testbench_top/USB_3_FTDI_top_inst/ftdi_data_transmitter_ent_inst/s_tx_dword_1
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/clk_i
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/rst_i
add wave -noupdate -expand -group rx_data_read -radix hexadecimal -childformat {{/testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_i.address -radix unsigned} {/testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_i.read -radix hexadecimal}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_i.address {-height 15 -radix unsigned} /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_i.read {-height 15 -radix hexadecimal}} /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_i
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/buffer_stat_empty_i
add wave -noupdate -expand -group rx_data_read -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/buffer_rddata_i
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/buffer_rdready_i
add wave -noupdate -expand -group rx_data_read -childformat {{/testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_o.readdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_o.readdata {-height 15 -radix hexadecimal}} /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/ftdi_rx_data_avalon_mm_o
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/buffer_rdreq_o
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/buffer_change_o
add wave -noupdate -expand -group rx_data_read /testbench_top/USB_3_FTDI_top_inst/ftdi_rx_data_avalon_mm_read_ent_inst/s_readdata_fetched
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/clk_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/rst_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/double_buffer_clear_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/double_buffer_stop_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/double_buffer_start_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_data_loaded_i
add wave -noupdate -expand -group rx_data_buffer -radix unsigned /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_cfg_length_i
add wave -noupdate -expand -group rx_data_buffer -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_wrdata_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_wrreq_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_rdreq_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_change_i
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/double_buffer_empty_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/double_buffer_full_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_stat_almost_empty_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_stat_almost_full_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_stat_empty_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_stat_full_o
add wave -noupdate -expand -group rx_data_buffer -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_rddata_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_rdready_o
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/buffer_wrready_o
add wave -noupdate -expand -group rx_data_buffer -radix hexadecimal -childformat {{/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.data -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.rdreq -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.sclr -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.wrreq -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.empty -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.full -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.q -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.usedw -radix hexadecimal}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.data {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.rdreq {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.sclr {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.wrreq {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.empty {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.full {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.q {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0.usedw {-height 15 -radix hexadecimal}} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0
add wave -noupdate -expand -group rx_data_buffer -radix hexadecimal -childformat {{/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.data -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.rdreq -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.sclr -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.wrreq -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.empty -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.full -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.q -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.usedw -radix hexadecimal}} -expand -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.data {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.rdreq {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.sclr {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.wrreq {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.empty {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.full {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.q {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1.usedw {-height 15 -radix hexadecimal}} /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_buffer_write_state
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_buffer_read_state
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_wr_data_buffer_selection
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_rd_data_buffer_selection
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0_rdhold
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1_rdhold
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0_wrhold
add wave -noupdate -expand -group rx_data_buffer /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1_wrhold
add wave -noupdate -expand -group rx_data_buffer -radix unsigned /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_0_extended_usedw
add wave -noupdate -expand -group rx_data_buffer -radix unsigned /testbench_top/USB_3_FTDI_top_inst/rx_data_buffer_ent_inst/s_data_fifo_1_extended_usedw
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/clk_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rst_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/data_rx_stop_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/data_rx_start_i
add wave -noupdate -expand -group rx_data_receiver -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rx_dc_data_fifo_rddata_data_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rx_dc_data_fifo_rddata_be_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rx_dc_data_fifo_rdempty_i
add wave -noupdate -expand -group rx_data_receiver -radix unsigned /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rx_dc_data_fifo_rdusedw_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/buffer_stat_full_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/buffer_wrready_i
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/rx_dc_data_fifo_rdreq_o
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/buffer_data_loaded_o
add wave -noupdate -expand -group rx_data_receiver -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/buffer_wrdata_o
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/buffer_wrreq_o
add wave -noupdate -expand -group rx_data_receiver /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/s_ftdi_data_receiver_state
add wave -noupdate -expand -group rx_data_receiver -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/s_rx_dword_0
add wave -noupdate -expand -group rx_data_receiver -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_data_receiver_ent_inst/s_rx_dword_1
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/clk_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rst_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_rxf_n_pin_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_clock_pin_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_txe_n_pin_i
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrdata_data_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrdata_be_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrreq_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdreq_i
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_data_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_wakeup_n_pin_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_be_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_gpio_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_reset_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_wr_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_rd_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_oe_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/umft_siwu_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrempty_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrfull_o
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrusedw_o
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rddata_data_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rddata_be_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdempty_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdfull_o
add wave -noupdate -expand -group ftdi_controller -radix unsigned -childformat {{/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(11) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(10) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(9) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(8) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(7) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(6) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(5) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(4) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(3) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(2) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(1) -radix hexadecimal} {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(0) -radix hexadecimal}} -subitemconfig {/testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(11) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(10) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(9) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(8) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(7) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(6) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(5) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(4) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(3) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(2) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(1) {-height 15 -radix hexadecimal} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o(0) {-height 15 -radix hexadecimal}} /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_umft601a_buffered_pins
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_dc_data_fifo
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_rx_dc_data_fifo
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_ftdi_umft601a_controller_state
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_io_inout_buffer_output_enable
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_delay_cnt
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_data_fetched
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_umft601a_clock
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_rx_wrreq_protected
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_rdreq_protected
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_be_protected
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_data_protected
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_transmit_control
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_transmit_continuous
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_priority
add wave -noupdate -expand -group ftdi_controller /testbench_top/USB_3_FTDI_top_inst/ftdi_umft601a_controller_ent_inst/s_words_to_transfer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {884074074 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 148
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
WaveRestoreZoom {0 ps} {1155 us}
