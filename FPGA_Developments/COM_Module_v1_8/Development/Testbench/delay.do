onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/clk_i
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/rst_i
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/delay_trigger_i
add wave -noupdate -expand -group delay -radix unsigned /testbench_top/delay_block_ent_inst/delay_timer_i
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/delay_busy_o
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/delay_finished_o
add wave -noupdate -expand -group delay -radix unsigned /testbench_top/delay_block_ent_inst/s_clkdiv_cnt
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/s_clkdiv_evt
add wave -noupdate -expand -group delay -radix unsigned /testbench_top/delay_block_ent_inst/s_timer_cnt
add wave -noupdate -expand -group delay /testbench_top/delay_block_ent_inst/s_idle
add wave -noupdate /testbench_top/clk200
add wave -noupdate /testbench_top/clk100
add wave -noupdate /testbench_top/rst
add wave -noupdate /testbench_top/s_spw_codec_comm_di
add wave -noupdate /testbench_top/s_spw_codec_comm_do
add wave -noupdate /testbench_top/s_spw_codec_comm_si
add wave -noupdate /testbench_top/s_spw_codec_comm_so
add wave -noupdate /testbench_top/s_spw_codec_dummy_di
add wave -noupdate /testbench_top/s_spw_codec_dummy_do
add wave -noupdate /testbench_top/s_spw_codec_dummy_si
add wave -noupdate /testbench_top/s_spw_codec_dummy_so
add wave -noupdate /testbench_top/s_spw_clock
add wave -noupdate /testbench_top/s_irq_rmap
add wave -noupdate /testbench_top/s_irq_buffers
add wave -noupdate /testbench_top/s_sync
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_readdata
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_waitrequest
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_address
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_write
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_writedata
add wave -noupdate /testbench_top/s_config_avalon_stimuli_mm_read
add wave -noupdate /testbench_top/s_avalon_buffer_R_stimuli_mm_waitrequest
add wave -noupdate /testbench_top/s_avalon_buffer_R_stimuli_mm_address
add wave -noupdate /testbench_top/s_avalon_buffer_R_stimuli_mm_write
add wave -noupdate /testbench_top/s_avalon_buffer_R_stimuli_mm_writedata
add wave -noupdate /testbench_top/s_avalon_buffer_L_stimuli_mm_waitrequest
add wave -noupdate /testbench_top/s_avalon_buffer_L_stimuli_mm_address
add wave -noupdate /testbench_top/s_avalon_buffer_L_stimuli_mm_write
add wave -noupdate /testbench_top/s_avalon_buffer_L_stimuli_mm_writedata
add wave -noupdate /testbench_top/s_dummy_spw_tx_flag
add wave -noupdate /testbench_top/s_dummy_spw_tx_control
add wave -noupdate /testbench_top/s_dummy_spw_rxvalid
add wave -noupdate /testbench_top/s_dummy_spw_rxhalff
add wave -noupdate /testbench_top/s_dummy_spw_rxflag
add wave -noupdate /testbench_top/s_dummy_spw_rxdata
add wave -noupdate /testbench_top/s_dummy_spw_rxread
add wave -noupdate /testbench_top/s_delay_trigger
add wave -noupdate /testbench_top/s_delay_timer
add wave -noupdate /testbench_top/s_delay_busy
add wave -noupdate /testbench_top/s_delay_finished
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10215000 ps} 0} {{Cursor 2} {499803736 ps} 0} {{Cursor 3} {26977688 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 297
configure wave -valuecolwidth 96
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
WaveRestoreZoom {10079005 ps} {10249247 ps}
