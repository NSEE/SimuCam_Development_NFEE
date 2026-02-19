onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/clk_100
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/clk_200
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/rst
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/rst_n
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_stimuli_codec_link_command_in
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_stimuli_codec_link_status_out
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_stimuli_codec_link_error_out
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_stimuli_codec_timecode_rx_out
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_stimuli_codec_timecode_tx_in
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_stimuli_codec_data_rx_in
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_stimuli_codec_data_rx_out
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_stimuli_codec_data_tx_in
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_stimuli_codec_data_tx_out
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_master_codec_ds_encoding_rx_in
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_master_codec_ds_encoding_tx_out
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_slave_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT
add wave -noupdate -expand -group Testbench_Top -expand -subitemconfig {/spw_testbench_top/s_slave_mm_write_registers.INTERFACE_CONTROL_REGISTER -expand} /spw_testbench_top/s_slave_mm_write_registers
add wave -noupdate -expand -group Testbench_Top -expand -subitemconfig {/spw_testbench_top/s_slave_mm_read_registers.SPW_LINK_ERROR_REGISTER -expand /spw_testbench_top/s_slave_mm_read_registers.SPW_LINK_STATUS_REGISTER -expand} /spw_testbench_top/s_slave_mm_read_registers
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_outputs
add wave -noupdate -expand -group Testbench_Top -childformat {{/spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_inputs.data -radix hexadecimal}} -expand -subitemconfig {/spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_inputs.data {-height 15 -radix hexadecimal}} /spw_testbench_top/s_slave_rx_data_dc_fifo_clk200_inputs
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_slave_tx_data_dc_fifo_clk200_outputs
add wave -noupdate -expand -group Testbench_Top -expand /spw_testbench_top/s_slave_tx_data_dc_fifo_clk200_inputs
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_slave_codec_ds_encoding_rx_in
add wave -noupdate -expand -group Testbench_Top /spw_testbench_top/s_slave_codec_ds_encoding_tx_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/clk_100
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/clk_200
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/rst
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_mm_write_registers
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_reset
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_command_in
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_status_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ds_encoding_rx_in
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ds_encoding_tx_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_error_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_timecode_rx_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_timecode_tx_in
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_link_command_in_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_in_loopback_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_rx_out_loopback_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_in_loopback_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_data_tx_out_loopback_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/txdiv_ff1_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/txdiv_ff2_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/loopback_ff1_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/loopback_ff2_sig
add wave -noupdate -expand -group codec_loopback /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/external_loopback
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/clk_200
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/rst
add wave -noupdate -expand -group codec -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_link_command_in.txdivcnt -radix decimal}} -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_link_command_in.txdivcnt {-radix decimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_link_command_in
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_link_status_out
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_ds_encoding_rx_in
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_ds_encoding_tx_out
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_link_error_out
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_timecode_rx_out
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_timecode_tx_in
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_rx_in
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_rx_out
add wave -noupdate -expand -group codec -childformat {{/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_tx_in.txdata -radix hexadecimal}} -expand -subitemconfig {/spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_tx_in.txdata {-height 15 -radix hexadecimal}} /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_tx_in
add wave -noupdate -expand -group codec /spw_testbench_top/spwc_codec_controller_ent_inst/spwc_codec_loopback_ent_inst/spwc_codec_ent_inst/spwc_codec_data_tx_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {100347500 ps} 0} {{Cursor 3} {100242500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
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
WaveRestoreZoom {100067578 ps} {100430236 ps}
