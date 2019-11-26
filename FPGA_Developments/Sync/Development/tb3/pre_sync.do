onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb /tb/clk
add wave -noupdate -group tb /tb/rst
add wave -noupdate -group tb /tb/s_dut_sinc_signal_in
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwa
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwb
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwc
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwd
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwe
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwf
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwg
add wave -noupdate -group tb /tb/s_dut_sync_signal_spwh
add wave -noupdate -group tb /tb/s_dut_sync_signal_out
add wave -noupdate -group tb /tb/s_dut_irq
add wave -noupdate -group tb /tb/s_avalon_mm_readdata
add wave -noupdate -group tb /tb/s_avalon_mm_waitrequest
add wave -noupdate -group tb /tb/s_avalon_mm_address
add wave -noupdate -group tb /tb/s_avalon_mm_write
add wave -noupdate -group tb /tb/s_avalon_mm_writedata
add wave -noupdate -group tb /tb/s_avalon_mm_read
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/clk_i
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/rst_i
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_readdata_i
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_address_o
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_write_o
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/avalon_mm_read_o
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/s_counter
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit0
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit1
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit2
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit3
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit4
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit8
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit16
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit17
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit18
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit19
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bit31
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bits_7_0
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bits_8_0
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bits_15_0
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg_bits_31_16
add wave -noupdate -expand -group avs_stimulli /tb/avs_stimuli_inst/a_wr_reg
add wave -noupdate -group sync /tb/sync_ent_inst/reset_sink_reset_i
add wave -noupdate -group sync /tb/sync_ent_inst/clock_sink_clk_i
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_syncin_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_address_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_read_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_write_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_writedata_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_byteenable_i
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_readdata_o
add wave -noupdate -group sync /tb/sync_ent_inst/avalon_slave_waitrequest_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw1_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw2_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw3_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw4_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw5_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw6_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw7_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_spw8_o
add wave -noupdate -group sync /tb/sync_ent_inst/conduit_sync_signal_syncout_o
add wave -noupdate -group sync /tb/sync_ent_inst/sync_interrupt_sender_irq_o
add wave -noupdate -group sync /tb/sync_ent_inst/pre_sync_interrupt_sender_irq_o
add wave -noupdate -group sync /tb/sync_ent_inst/s_reset_n
add wave -noupdate -group sync /tb/sync_ent_inst/s_avalon_mm_read_waitrequest
add wave -noupdate -group sync /tb/sync_ent_inst/s_avalon_mm_write_waitrequest
add wave -noupdate -group sync /tb/sync_ent_inst/s_sync_mm_write_registers
add wave -noupdate -group sync /tb/sync_ent_inst/s_sync_mm_read_registers
add wave -noupdate -group sync /tb/sync_ent_inst/s_sync_signal
add wave -noupdate -group sync /tb/sync_ent_inst/s_syncgen_signal
add wave -noupdate -group sync /tb/sync_ent_inst/s_pre_sync_signal
add wave -noupdate -group sync /tb/sync_ent_inst/s_next_cycle_number
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_byteenable
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_waitrequest
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_writedata
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_write
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_readata
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_read
add wave -noupdate -group sync /tb/sync_ent_inst/a_avalon_mm_address
add wave -noupdate -group sync /tb/sync_ent_inst/a_pre_sync_irq
add wave -noupdate -group sync /tb/sync_ent_inst/a_sync_irq
add wave -noupdate -group sync /tb/sync_ent_inst/a_clock
add wave -noupdate -group sync /tb/sync_ent_inst/a_reset
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/clk_i
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/reset_n_i
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/control_i
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/config_i
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/err_inj_i
add wave -noupdate -expand -group gen -childformat {{/tb/sync_ent_inst/sync_gen_inst/status_o.cycle_number -radix unsigned} {/tb/sync_ent_inst/sync_gen_inst/status_o.next_cycle_number -radix unsigned}} -expand -subitemconfig {/tb/sync_ent_inst/sync_gen_inst/status_o.cycle_number {-height 15 -radix unsigned} /tb/sync_ent_inst/sync_gen_inst/status_o.next_cycle_number {-height 15 -radix unsigned}} /tb/sync_ent_inst/sync_gen_inst/status_o
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/sync_gen_o
add wave -noupdate -expand -group gen -color Magenta /tb/sync_ent_inst/sync_gen_inst/pre_sync_gen_o
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/s_sync_gen_state
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/s_sync_cnt
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/s_sync_blank
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/s_sync_cycle_cnt
add wave -noupdate -expand -group gen /tb/sync_ent_inst/sync_gen_inst/s_registered_configs
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/clk_i
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/reset_n_i
add wave -noupdate -group sync_irq -expand /tb/sync_ent_inst/sync_irq_inst/irq_enable_i
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/irq_flag_clear_i
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/irq_watch_i
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/irq_flag_o
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/irq_o
add wave -noupdate -group sync_irq -expand /tb/sync_ent_inst/sync_irq_inst/s_irq_flag
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/s_irq_flag_delayed
add wave -noupdate -group sync_irq /tb/sync_ent_inst/sync_irq_inst/s_irq_flag_edge_triggered
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/clk_i
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/reset_n_i
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/irq_enable_i
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/irq_flag_clear_i
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/irq_watch_i
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/irq_flag_o
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/irq_o
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/s_irq_flag
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/s_irq_flag_delayed
add wave -noupdate -expand -group pre_sync_irq /tb/sync_ent_inst/pre_sync_irq_inst/s_irq_flag_edge_triggered
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54550781 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {0 ps} {315 us}
