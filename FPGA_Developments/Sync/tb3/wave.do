onerror {resume}
quietly set dataset_list [list sim vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/tb/clk
add wave -noupdate sim:/tb/rst
add wave -noupdate sim:/tb/s_dut_sinc_signal_in
add wave -noupdate sim:/tb/s_dut_sync_signal_spwa
add wave -noupdate sim:/tb/s_dut_sync_signal_spwb
add wave -noupdate sim:/tb/s_dut_sync_signal_spwc
add wave -noupdate sim:/tb/s_dut_sync_signal_spwd
add wave -noupdate sim:/tb/s_dut_sync_signal_spwe
add wave -noupdate sim:/tb/s_dut_sync_signal_spwf
add wave -noupdate sim:/tb/s_dut_sync_signal_spwg
add wave -noupdate sim:/tb/s_dut_sync_signal_spwh
add wave -noupdate sim:/tb/s_dut_sync_signal_out
add wave -noupdate sim:/tb/s_dut_irq
add wave -noupdate -radix hexadecimal sim:/tb/s_avalon_mm_readdata
add wave -noupdate sim:/tb/s_avalon_mm_waitrequest
add wave -noupdate sim:/tb/s_avalon_mm_address
add wave -noupdate sim:/tb/s_avalon_mm_write
add wave -noupdate sim:/tb/s_avalon_mm_writedata
add wave -noupdate sim:/tb/s_avalon_mm_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36950000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 207
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
WaveRestoreZoom {0 ps} {68357143 ps}
