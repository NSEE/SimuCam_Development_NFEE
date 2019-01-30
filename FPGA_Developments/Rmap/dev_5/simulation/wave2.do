onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/clk_i
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rst_i
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_write_i
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_writeaddr_i
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_writedata_i
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_memerror_o
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_memready_o
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_config_registers_o
add wave -noupdate /rmap_testbench_top/rmap_mem_area_nfee_write_inst/rmap_hk_registers_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8253699 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {78750 ns}
