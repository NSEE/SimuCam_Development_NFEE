onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/clk_i
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/reset_n_i
add wave -noupdate -group User -expand -subitemconfig {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/flags_i.command_parsing -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/flags_i.reply_geneneration -expand} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/flags_i
add wave -noupdate -group User -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/error_i
add wave -noupdate -group User -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.target_logical_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.instructions -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.key -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.initiator_logical_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.transaction_identifier -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.extended_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.memory_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.data_length -radix hexadecimal}} -expand -subitemconfig {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.target_logical_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.instructions {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.key {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.initiator_logical_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.transaction_identifier {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.extended_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.memory_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i.data_length {-height 15 -radix hexadecimal}} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i
add wave -noupdate -group User -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i.user_key -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i.user_target_logical_address -radix hexadecimal}} -expand -subitemconfig {/rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i.user_key {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i.user_target_logical_address {-height 15 -radix hexadecimal}} /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i
add wave -noupdate -group User -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/control_o
add wave -noupdate -group User -radix decimal /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/reply_status
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_rmap_target_user_state
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_error_general_error
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_error_invalid_key
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_error_verify_buffer_overrun
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_error_rmap_command_not_implemented_or_not_authorised
add wave -noupdate -group User /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/s_error_invalid_target_logical_address
add wave -noupdate -group User -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_user_ent_inst/p_rmap_target_user_FSM_state/v_authorization_granted
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/clk_i
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/reset_n_i
add wave -noupdate -group Command -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/control_i
add wave -noupdate -group Command -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/spw_flag_i
add wave -noupdate -group Command -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/flags_o
add wave -noupdate -group Command -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/error_o
add wave -noupdate -group Command -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.target_logical_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.instructions -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.key -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.reply_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.initiator_logical_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(1) -radix hexadecimal}}} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.extended_address -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(1) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(2) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(3) -radix hexadecimal}}} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(1) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(2) -radix hexadecimal}}}} -expand -subitemconfig {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.target_logical_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.instructions {-height 15 -radix hexadecimal -expand} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.key {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.reply_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.initiator_logical_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier {-height 15 -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(1) -radix hexadecimal}} -expand} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(0) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.transaction_identifier(1) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.extended_address {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address {-height 15 -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(1) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(2) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(3) -radix hexadecimal}} -expand} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(0) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(1) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(2) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.address(3) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length {-height 15 -radix hexadecimal -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(0) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(1) -radix hexadecimal} {/rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(2) -radix hexadecimal}} -expand} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(0) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(1) {-height 15 -radix hexadecimal} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o.data_length(2) {-height 15 -radix hexadecimal}} /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o
add wave -noupdate -group Command -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/spw_control_o
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_rmap_target_command_state
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_rmap_target_command_next_state
add wave -noupdate -group Command -radix hexadecimal /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_command_header_crc
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_command_header_crc_ok
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_write_command
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_unused_packet_type
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_invalid_command_code
add wave -noupdate -group Command /rmap_testbench_top/rmap_target_top_inst/rmap_target_command_ent_inst/s_byte_counter
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/clk_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/reset_n_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/control_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/headerdata_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/spw_flag_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/mem_flag_i
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/flags_o
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/error_o
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/spw_control_o
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/mem_control_o
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_rmap_target_write_state
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_rmap_target_write_next_state
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_data_crc
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_data_crc_ok
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_address
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_byte_counter
add wave -noupdate -group Write /rmap_testbench_top/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_verify_buffer
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/clk_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/reset_n_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/control_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/headerdata_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/spw_flag_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/mem_flag_i
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/flags_o
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/spw_control_o
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/mem_control_o
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/s_rmap_target_read_state
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/s_rmap_target_read_next_state
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_data_crc
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_address
add wave -noupdate -group Read /rmap_testbench_top/rmap_target_top_inst/rmap_target_read_ent_inst/s_byte_counter
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/clk_i
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/reset_n_i
add wave -noupdate -group Reply -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/control_i
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/headerdata_i
add wave -noupdate -group Reply -expand /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_flag_i
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/flags_o
add wave -noupdate -group Reply -childformat {{/rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_control_o.data -radix hexadecimal}} -expand -subitemconfig {/rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_control_o.data {-height 15 -radix hexadecimal}} /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_control_o
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/s_rmap_target_reply_state
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/s_rmap_target_reply_next_state
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/s_reply_header_crc
add wave -noupdate -group Reply /rmap_testbench_top/rmap_target_top_inst/rmap_target_reply_ent_inst/s_byte_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10667218 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 228
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
WaveRestoreZoom {0 ps} {105 us}
