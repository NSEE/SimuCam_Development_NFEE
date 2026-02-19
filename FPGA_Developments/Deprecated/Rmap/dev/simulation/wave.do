onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rmap_testbench_top/clk
add wave -noupdate /rmap_testbench_top/rst
add wave -noupdate /rmap_testbench_top/rst_n
add wave -noupdate /rmap_testbench_top/s_stimuli_spw_tx_flag
add wave -noupdate /rmap_testbench_top/s_stimuli_spw_tx_control
add wave -noupdate /rmap_testbench_top/s_rmap_spw_control
add wave -noupdate /rmap_testbench_top/s_rmap_spw_flag
add wave -noupdate /rmap_testbench_top/s_rmap_mem_control
add wave -noupdate /rmap_testbench_top/s_rmap_mem_flag
add wave -noupdate /rmap_testbench_top/s_rmap_mem_wr_byte_address
add wave -noupdate /rmap_testbench_top/s_rmap_mem_rd_byte_address
add wave -noupdate -radix hexadecimal /rmap_testbench_top/s_rmap_write_memory
add wave -noupdate /rmap_testbench_top/s_rmap_write_memory_data
add wave -noupdate /rmap_testbench_top/s_rmap_write_memory_address
add wave -noupdate -radix hexadecimal /rmap_testbench_top/s_rmap_read_memory
add wave -noupdate /rmap_testbench_top/s_rmap_read_memory_data
add wave -noupdate /rmap_testbench_top/s_rmap_read_memory_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 198
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {20197287 ps}
