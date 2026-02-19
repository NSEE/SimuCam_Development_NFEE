onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/clk_i
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/rst_i
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_readdata_i
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/avalon_mm_read_o
add wave -noupdate -expand -group 32_stimulli /testbench_top/avalon_32_stimuli_inst/s_counter
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/clk_i
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/rst_i
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/s_counter
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/s_address_cnt
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/s_mask_cnt
add wave -noupdate -expand -group 64_stimulli /testbench_top/avalon_64_stimuli_inst/s_times_cnt
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/reset_sink_reset
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/clock_sink_100_clk
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_address
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_write
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_read
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_readdata
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_writedata
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_32_waitrequest
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_64_address
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_64_write
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_64_writedata
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/avalon_slave_64_waitrequest
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/s_avalon_mm_32_read_waitrequest
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/s_avalon_mm_32_write_waitrequest
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/s_avstap_write_registers
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/a_reset
add wave -noupdate -expand -group avstap64 /testbench_top/avstap64_top_inst/a_avs_clock
add wave -noupdate -expand -group avstap64 -subitemconfig {/testbench_top/avstap64_top_inst/s_avstap_read_registers.avstap_data_reg -expand /testbench_top/avstap64_top_inst/s_avstap_read_registers.avstap_data_reg.avstap_data -expand} /testbench_top/avstap64_top_inst/s_avstap_read_registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30185000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
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
WaveRestoreZoom {0 ps} {52500 ns}
