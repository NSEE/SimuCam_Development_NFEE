onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/s_dut_sinc_signal_in
add wave -noupdate /tb/s_dut_sync_signal_spwa
add wave -noupdate /tb/s_dut_sync_signal_spwb
add wave -noupdate /tb/s_dut_sync_signal_spwc
add wave -noupdate /tb/s_dut_sync_signal_spwd
add wave -noupdate /tb/s_dut_sync_signal_spwe
add wave -noupdate /tb/s_dut_sync_signal_spwf
add wave -noupdate /tb/s_dut_sync_signal_spwg
add wave -noupdate /tb/s_dut_sync_signal_spwh
add wave -noupdate /tb/s_dut_sync_signal_out
add wave -noupdate /tb/s_dut_irq
add wave -noupdate /tb/s_avalon_mm_readdata
add wave -noupdate /tb/s_avalon_mm_waitrequest
add wave -noupdate /tb/s_avalon_mm_address
add wave -noupdate /tb/s_avalon_mm_write
add wave -noupdate /tb/s_avalon_mm_writedata
add wave -noupdate /tb/s_avalon_mm_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {105 us}
