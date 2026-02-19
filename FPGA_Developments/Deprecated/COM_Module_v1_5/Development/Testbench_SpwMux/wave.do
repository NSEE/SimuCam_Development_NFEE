onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group top /testbench_top/clk100
add wave -noupdate -expand -group top /testbench_top/rst
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_rx_channel_command
add wave -noupdate -expand -group top -childformat {{/testbench_top/s_mux_rx_channel_status.rxdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/s_mux_rx_channel_status.rxdata {-height 15 -radix hexadecimal}} /testbench_top/s_mux_rx_channel_status
add wave -noupdate -expand -group top -childformat {{/testbench_top/s_mux_tx_channel_command.txdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/s_mux_tx_channel_command.txdata {-height 15 -radix hexadecimal}} /testbench_top/s_mux_tx_channel_command
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_tx_channel_status
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_rx_0_command
add wave -noupdate -expand -group top -childformat {{/testbench_top/s_mux_rx_0_status.rxdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/s_mux_rx_0_status.rxdata {-height 15 -radix hexadecimal}} /testbench_top/s_mux_rx_0_status
add wave -noupdate -expand -group top -childformat {{/testbench_top/s_mux_tx_0_command.txdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/s_mux_tx_0_command.txdata {-height 15 -radix hexadecimal}} /testbench_top/s_mux_tx_0_command
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_tx_0_status
add wave -noupdate -expand -group top -childformat {{/testbench_top/s_mux_tx_1_command.txdata -radix hexadecimal}} -expand -subitemconfig {/testbench_top/s_mux_tx_1_command.txdata {-height 15 -radix hexadecimal}} /testbench_top/s_mux_tx_1_command
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_tx_1_status
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_tx_2_command
add wave -noupdate -expand -group top -expand /testbench_top/s_mux_tx_2_status
add wave -noupdate -expand -group top -color Yellow /testbench_top/s_time_counter
add wave -noupdate -expand -group top /testbench_top/s_tx_0_counter
add wave -noupdate -expand -group top /testbench_top/s_tx_1_counter
add wave -noupdate -expand -group top /testbench_top/s_tx_2_counter
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/clk_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/rst_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_codec_rx_status_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_codec_tx_status_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_rx_0_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_0_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_1_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_2_command_i
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_codec_rx_command_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_codec_tx_command_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_rx_0_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_0_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_1_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/spw_mux_tx_2_status_o
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_mux_rx_selection
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_mux_tx_selection
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_spw_mux_state
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_tx_flag_buffer
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_tx_data_buffer
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_tx_pending_write
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_tx_channel_lock
add wave -noupdate -expand -group spw_mux /testbench_top/spw_mux_ent_inst/s_spw_tx_fsm_command
add wave -noupdate -expand /testbench_top/spw_mux_ent_inst/p_spw_mux/v_tx_channel_queue
add wave -noupdate /testbench_top/spw_mux_ent_inst/p_spw_mux/v_tx_current_queue
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2205000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 235
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
WaveRestoreZoom {0 ps} {5250 ns}
