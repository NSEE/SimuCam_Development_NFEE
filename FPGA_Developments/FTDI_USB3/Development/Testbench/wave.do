onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_top/clk100Avs
add wave -noupdate /testbench_top/clk100Ftdi
add wave -noupdate /testbench_top/rst
add wave -noupdate /testbench_top/s_umft_data_bus
add wave -noupdate /testbench_top/s_umft_reset_n_pin
add wave -noupdate /testbench_top/s_umft_rxf_n_pin
add wave -noupdate /testbench_top/s_umft_wakeup_n_pin
add wave -noupdate /testbench_top/s_umft_be_bus
add wave -noupdate /testbench_top/s_umft_txe_n_pin
add wave -noupdate /testbench_top/s_umft_gpio_bus
add wave -noupdate /testbench_top/s_umft_wr_n_pin
add wave -noupdate /testbench_top/s_umft_rd_n_pin
add wave -noupdate /testbench_top/s_umft_oe_n_pin
add wave -noupdate /testbench_top/s_umft_siwu_n_pin
add wave -noupdate /testbench_top/s_avalon_burst_slave_address
add wave -noupdate /testbench_top/s_avalon_burst_slave_read
add wave -noupdate /testbench_top/s_avalon_burst_slave_readdata
add wave -noupdate /testbench_top/s_avalon_burst_slave_waitrequest
add wave -noupdate /testbench_top/s_avalon_burst_slave_burstcount
add wave -noupdate /testbench_top/s_avalon_burst_slave_byteenable
add wave -noupdate /testbench_top/s_avalon_burst_slave_readdatavalid
add wave -noupdate /testbench_top/s_avalon_burst_slave_write
add wave -noupdate /testbench_top/s_avalon_burst_slave_writedata
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/clk_i
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/rst_i
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_wr_n_pin_i
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_rd_n_pin_i
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_oe_n_pin_i
add wave -noupdate -expand -group usb3_stimuli -radix hexadecimal /testbench_top/usb3_fifo_master_stimuli_inst/umft_data_bus_io
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_wakeup_n_pin_io
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_be_bus_io
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_gpio_bus_io
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_rxf_n_pin_o
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/umft_txe_n_pin_o
add wave -noupdate -expand -group usb3_stimuli -radix hexadecimal /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_data_out
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_wakeup_n_out
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_be_out
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_gpio_out
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_oe
add wave -noupdate -expand -group usb3_stimuli -radix hexadecimal /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_data_in
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_wakeup_n_in
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_be_in
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_umft601a_gpio_in
add wave -noupdate -expand -group usb3_stimuli /testbench_top/usb3_fifo_master_stimuli_inst/s_counter
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/clock_sink_clk
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/reset_sink_reset
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_data_bus
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_reset_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_rxf_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_clock_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_wakeup_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_be_bus
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_txe_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_gpio_bus
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_wr_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_rd_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_oe_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/umft_siwu_n_pin
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_address
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_read
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_readdata
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_waitrequest
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_burstcount
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_byteenable
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_readdatavalid
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_write
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/avalon_burst_slave_writedata
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrdata_data
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrdata_be
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrreq
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrempty
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrfull
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_tx_dc_data_fifo_wrusedw
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rdreq
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rddata_data
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rddata_be
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rdempty
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rdfull
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/s_rx_dc_data_fifo_rdusedw
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/t_loopback_mode_state
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/a_reset
add wave -noupdate -expand -group ftdi_top /testbench_top/usb_3_ftdi_top_inst/a_avs_clock
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/clk_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rst_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_rxf_n_pin_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_clock_pin_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_txe_n_pin_i
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrdata_data_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrdata_be_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrreq_i
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdreq_i
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_data_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_wakeup_n_pin_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_be_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_gpio_bus_io
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_reset_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_wr_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_rd_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_oe_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/umft_siwu_n_pin_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrempty_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrfull_o
add wave -noupdate -expand -group ftdi_controller -radix unsigned /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/tx_dc_data_fifo_wrusedw_o
add wave -noupdate -expand -group ftdi_controller -radix hexadecimal /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rddata_data_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rddata_be_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdempty_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdfull_o
add wave -noupdate -expand -group ftdi_controller -radix unsigned /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/rx_dc_data_fifo_rdusedw_o
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_umft601a_buffered_pins
add wave -noupdate -expand -group ftdi_controller -childformat {{/testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_dc_data_fifo.rdusedw -radix unsigned}} -expand -subitemconfig {/testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_dc_data_fifo.rdusedw {-height 15 -radix unsigned}} /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_dc_data_fifo
add wave -noupdate -expand -group ftdi_controller -childformat {{/testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_rx_dc_data_fifo.wrusedw -radix unsigned}} -expand -subitemconfig {/testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_rx_dc_data_fifo.wrusedw {-height 15 -radix unsigned}} /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_rx_dc_data_fifo
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_ftdi_umft601a_controller_state
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_io_inout_buffer_output_enable
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_delay_cnt
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_words_to_transfer
add wave -noupdate -expand -group ftdi_controller /testbench_top/usb_3_ftdi_top_inst/ftdi_umft601a_controller_ent_inst/s_tx_data_fetched
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88962141 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {210 us}
