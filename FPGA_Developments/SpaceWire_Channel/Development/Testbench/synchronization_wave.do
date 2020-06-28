onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/clk_avs_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/clk_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/rst_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_command_avs_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_timecode_tx_avs_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_rx_command_avs_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_tx_command_avs_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_status_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_error_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_timecode_rx_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_rx_status_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_tx_status_spw_i
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_status_avs_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_error_avs_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_timecode_rx_avs_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_rx_status_avs_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_tx_status_avs_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_link_command_spw_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_timecode_tx_spw_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_rx_command_spw_o
add wave -noupdate -group top -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spw_codec_data_tx_command_spw_o
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/clk_avs_i
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/clk_spw_i
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/rst_i
add wave -noupdate -group tx_timecode -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.tick_in -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.ctrl_in -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.time_in -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.tick_in {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.ctrl_in {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i.time_in {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_avs_i
add wave -noupdate -group tx_timecode -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.tick_in -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.ctrl_in -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.time_in -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.tick_in {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.ctrl_in {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o.time_in {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/timecode_spw_o
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/s_timecode_dc_fifo_spw_rdreq
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/s_timecode_dc_fifo_spw_rddata_ctrl
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/s_timecode_dc_fifo_spw_rddata_time
add wave -noupdate -group tx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_timecode_ent_inst/s_timecode_dc_fifo_spw_rdempty
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/clk_avs_i
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/clk_spw_i
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/rst_i
add wave -noupdate -group rx_timecode -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.tick_out -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.ctrl_out -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.time_out -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.tick_out {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.ctrl_out {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i.time_out {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_spw_i
add wave -noupdate -group rx_timecode -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.tick_out -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.ctrl_out -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.time_out -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.tick_out {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.ctrl_out {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o.time_out {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/timecode_avs_o
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/s_timecode_dc_fifo_avs_rdreq
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/s_timecode_dc_fifo_avs_rddata_ctrl
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/s_timecode_dc_fifo_avs_rddata_time
add wave -noupdate -group rx_timecode -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_timecode_ent_inst/s_timecode_dc_fifo_avs_rdempty
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/clk_avs_i
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/clk_spw_i
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/rst_i
add wave -noupdate -group tx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txwrite -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txflag -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txdata -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txwrite {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txflag {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i.txdata {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_avs_i
add wave -noupdate -group tx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_spw_i.txrdy -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_spw_i.txhalff -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_spw_i.txrdy {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_spw_i.txhalff {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_spw_i
add wave -noupdate -group tx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_avs_o.txrdy -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_avs_o.txhalff -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_avs_o.txrdy {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_avs_o.txhalff {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_status_avs_o
add wave -noupdate -group tx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txwrite -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txflag -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txdata -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txwrite {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txflag {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o.txdata {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/data_command_spw_o
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_spw_rdreq
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_spw_rddata_flag
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_spw_rddata_data
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_spw_rdempty
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_avs_wrfull
add wave -noupdate -group tx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_tx_data_ent_inst/s_data_dc_fifo_avs_wrusedw
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/clk_avs_i
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/clk_spw_i
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/rst_i
add wave -noupdate -group rx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_avs_i.rxread -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_avs_i.rxread {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_avs_i
add wave -noupdate -group rx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxvalid -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxhalff -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxflag -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxdata -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxvalid {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxhalff {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxflag {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i.rxdata {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_spw_i
add wave -noupdate -group rx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxvalid -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxhalff -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxflag -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxdata -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxvalid {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxhalff {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxflag {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o.rxdata {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_status_avs_o
add wave -noupdate -group rx_data -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_spw_o.rxread -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_spw_o.rxread {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/data_command_spw_o
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_spw_data_just_fetched
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_spw_wrreq
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_spw_wrdata_flag
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_spw_wrdata_data
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_avs_wrfull
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_avs_rdempty
add wave -noupdate -group rx_data -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_rx_data_ent_inst/s_data_dc_fifo_avs_rdusedw
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/clk_avs_i
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/clk_spw_i
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/rst_i
add wave -noupdate -group commands -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.autostart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.linkstart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.linkdis -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.txdivcnt -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.autostart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.linkstart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.linkdis {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i.txdivcnt {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_avs_i
add wave -noupdate -group commands -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.autostart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.linkstart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.linkdis -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.txdivcnt -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.autostart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.linkstart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.linkdis {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o.txdivcnt {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/link_command_spw_o
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_spw_commands_just_fetched
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrreq
add wave -noupdate -group commands -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.autostart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.linkstart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.linkdis -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.txdivcnt -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.autostart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.linkstart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.linkdis {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata.txdivcnt {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrdata
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_avs_wrfull
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rdreq
add wave -noupdate -group commands -radix hexadecimal -childformat {{/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.autostart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.linkstart -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.linkdis -radix hexadecimal} {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.txdivcnt -radix hexadecimal}} -expand -subitemconfig {/testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.autostart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.linkstart {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.linkdis {-height 15 -radix hexadecimal} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata.txdivcnt {-height 15 -radix hexadecimal}} /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rddata
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_commands_dc_fifo_spw_rdempty
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_avs_commands_vector
add wave -noupdate -group commands -radix hexadecimal /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_commands_ent_inst/s_avs_commands_vector_dly
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/clk_avs_i
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/clk_spw_i
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/rst_i
add wave -noupdate -group status -expand /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/link_status_spw_i
add wave -noupdate -group status -expand /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/link_error_spw_i
add wave -noupdate -group status -expand /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/link_status_avs_o
add wave -noupdate -group status -expand /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/link_error_avs_o
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_spw_status_waiting_write
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_spw_status_vector
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_spw_status_vector_dly
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_avs_status_just_fetched
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_spw_wrreq
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_spw_wrdata_status
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_spw_wrdata_error
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_spw_wrfull
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_avs_rdreq
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_avs_rddata_status
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_avs_rddata_error
add wave -noupdate -group status /testbench_synchronization_top/spwc_clk_synchronization_top_inst/spwc_clk_synchronization_status_ent_inst/s_status_dc_fifo_avs_rdempty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21573379 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
WaveRestoreZoom {0 ps} {105 us}