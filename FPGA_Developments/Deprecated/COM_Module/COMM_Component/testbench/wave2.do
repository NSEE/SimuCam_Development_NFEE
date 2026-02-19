onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Top /spw_testbench_top/clk_100
add wave -noupdate -expand -group Top /spw_testbench_top/clk_200
add wave -noupdate -expand -group Top /spw_testbench_top/rst
add wave -noupdate -expand -group Top /spw_testbench_top/rst_n
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_link_command_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_link_status_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_link_error_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_timecode_rx_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_timecode_tx_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_data_rx_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_data_rx_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_data_tx_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_stimuli_codec_data_tx_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_master_codec_ds_encoding_rx_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_master_codec_ds_encoding_tx_out
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_mm_write_registers
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_mm_read_registers
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_outputs
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_inputs
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_tx_data_dc_fifo_clk200_outputs
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_tx_data_dc_fifo_clk200_inputs
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_codec_ds_encoding_rx_in
add wave -noupdate -expand -group Top /spw_testbench_top/s_slave_codec_ds_encoding_tx_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/clk_100
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/clk_200
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rst
add wave -noupdate -expand -group loopback -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER -expand /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER {-height 15 -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA -radix hexadecimal}} -expand} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_read_registers
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_reset
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_command_in
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_status_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ds_encoding_rx_in
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ds_encoding_tx_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_error_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_timecode_rx_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_timecode_tx_in
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_command_in_sig
add wave -noupdate -expand -group loopback -expand /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in_loopback_sig
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_sig.rxdata -radix hexadecimal}} -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_sig.rxdata {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_loopback_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_sig
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_loopback_sig.txdata -radix hexadecimal}} -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_loopback_sig.txdata {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_loopback_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out_loopback_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/txdiv_ff1_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/txdiv_ff2_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/loopback_ff1_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/loopback_ff2_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/backdoor_ff1_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/backdoor_ff2_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/external_loopback_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/backdoor_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/delay_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/delay100tx_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/delay100rx_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/delay200tx_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/delay200rx_sig
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_control_trigger
add wave -noupdate -expand -group loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_control_trigger
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_write.data -radix hexadecimal}} -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_write.data {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_write
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_read.q -radix hexadecimal}} -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_read.q {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rx_backdoor_fifo_read
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_write.data -radix hexadecimal}} -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_write.data {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_write
add wave -noupdate -expand -group loopback -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_read.q -radix hexadecimal}} -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_read.q {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/tx_backdoor_fifo_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50297500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 372
configure wave -valuecolwidth 89
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
WaveRestoreZoom {49908049 ps} {51361211 ps}
