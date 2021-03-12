onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/clk_i
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/rst_i
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_readdata_i
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/avalon_mm_read_o
add wave -noupdate -expand -group rmap_avalon_stimuli /testbench_top/rmap_avalon_stimuli_inst/s_counter
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/reset_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/clk_100_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_address_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_write_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_read_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_readdata_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_writedata_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_waitrequest_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/avs_0_rmap_byteenable_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_wr_address_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_write_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_writedata_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_rd_address_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_read_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_wr_waitrequest_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_readdata_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_0_rmap_rd_waitrequest_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_wr_address_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_write_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_writedata_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_rd_address_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_read_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_wr_waitrequest_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_readdata_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/fee_1_rmap_rd_waitrequest_o
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_timecode_control_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_timecode_time_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_rmap_target_status_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_rmap_target_indicate_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_spw_link_escape_err_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_spw_link_credit_err_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_spw_link_parity_err_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_spw_link_disconnect_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_spw_link_running_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_frame_counter_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/channel_hk_frame_number_i
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_rmap_mem_wr_area
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_rmap_mem_rd_area
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avs_0_rmap_wr_waitrequest
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avs_0_rmap_rd_waitrequest
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_fee_wr_rmap_in
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_fee_wr_rmap_out
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_fee_rd_rmap_in
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_fee_rd_rmap_out
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avalon_mm_wr_rmap_in
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avalon_mm_wr_rmap_out
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avalon_mm_rd_rmap_in
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/s_avalon_mm_rd_rmap_out
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/a_reset
add wave -noupdate -group nrme_rmap_memory_nfee_area_top /testbench_top/nrme_rmap_memory_nfee_area_top_inst/a_avs_clock
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/clk_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/rst_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_0_wr_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_0_rd_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_1_wr_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_1_rd_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_0_mm_wr_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_0_mm_rd_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_wr_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_rd_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_mm_wr_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_mm_rd_rmap_i
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_0_wr_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_0_rd_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_1_wr_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_1_rd_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_0_mm_wr_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_0_mm_rd_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_wr_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/fee_rd_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_mm_wr_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/avalon_mm_rd_rmap_o
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_fee_rmap_waitrequest
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_avalon_mm_rmap_waitrequest
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_rmap_waitrequest
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_selected_master
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_queue
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_wr_fee_0_queued
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_wr_fee_1_queued
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_wr_avs_0_queued
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_rd_fee_0_queued
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_rd_fee_1_queued
add wave -noupdate -group nrme_rmap_mem_area_nfee_arbiter_ent /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_arbiter_ent_inst/s_master_rd_avs_0_queued
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/clk_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/rst_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/fee_rmap_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/avalon_mm_rmap_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/fee_rmap_o
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/avalon_mm_rmap_o
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/rmap_registers_wr_o
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_write /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_write_inst/s_data_acquired
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/clk_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/rst_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/fee_rmap_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/avalon_mm_rmap_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/rmap_registers_wr_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/rmap_registers_rd_i
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/fee_rmap_o
add wave -noupdate -expand -group nrme_rmap_mem_area_nfee_read /testbench_top/nrme_rmap_memory_nfee_area_top_inst/nrme_rmap_mem_area_nfee_read_inst/avalon_mm_rmap_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22463009 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {21 us}