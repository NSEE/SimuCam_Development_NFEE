onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/clk_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/rst_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_command_autostart_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_command_linkstart_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_command_linkdis_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_command_txdivcnt_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_tx_tick_in_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_tx_ctrl_in_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_tx_time_in_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_rx_command_rxread_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_tx_command_txwrite_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_tx_command_txflag_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_tx_command_txdata_i
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_status_started_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_status_connecting_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_status_running_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_error_errdisc_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_error_errpar_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_error_erresc_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_link_error_errcred_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_rx_tick_out_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_rx_ctrl_out_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_timecode_rx_time_out_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_rx_status_rxvalid_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_rx_status_rxhalff_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_rx_status_rxflag_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_rx_status_rxdata_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_tx_status_txrdy_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/spw_data_tx_status_txhalff_o
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/s_rmap_write_cmd_cnt
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/s_rmap_read_cmd_cnt
add wave -noupdate -expand -group spw_stimuli -radix hexadecimal /testbench_top/spw_controller_stimuli_inst/s_counter
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/clk_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rst_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/spw_flag_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/mem_flag_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/conf_target_enable_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/conf_target_logical_addr_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/conf_target_key_i
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/spw_control_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/mem_control_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/mem_wr_byte_address_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/mem_rd_byte_address_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_command_received_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_write_requested_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_write_authorized_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_write_finished_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_read_requested_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_read_authorized_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_read_finished_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_reply_sended_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/stat_discarded_package_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_early_eop_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_eep_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_header_crc_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_unused_packet_type_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_invalid_command_code_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_too_much_data_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/err_invalid_data_crc_o
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_flags
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_error
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_rmap_data
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_rmap_error
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_spw_command_rx_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_spw_write_rx_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_spw_read_tx_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_spw_reply_tx_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_rmap_target_user_configs
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_target_dis_rd_spw_rx_control
add wave -noupdate -expand -group rmap_top -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/s_target_spw_rx_flag
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/clk_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/rst_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/flags_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/error_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/codecdata_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/configs_i
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/control_o
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/reply_status
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/s_rmap_target_user_state
add wave -noupdate -expand -group rmap_user -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_user_ent_inst/s_data_length_vector
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/clk_i
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/rst_i
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/control_i
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/spw_flag_i
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/flags_o
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/error_o
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/headerdata_o
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/spw_control_o
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_rmap_target_command_state
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_rmap_target_command_next_state
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_command_header_crc
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_write_command
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_unused_packet_type
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_invalid_command_code
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_discarted_package
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_not_rmap_package
add wave -noupdate -expand -group rmap_command -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_command_ent_inst/s_byte_counter
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/clk_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/rst_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/control_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/headerdata_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/spw_flag_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/mem_flag_i
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/flags_o
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/error_o
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/spw_control_o
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/mem_control_o
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/mem_byte_address_o
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_rmap_target_write_state
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_rmap_target_write_next_state
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_data_crc
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_data_crc_ok
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_error
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_byte_counter
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_address
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_byte_counter
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_verify_buffer
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_write_address_vector
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_byte_counter_vector
add wave -noupdate -expand -group rmap_write -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_write_ent_inst/s_last_byte_written
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/clk_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/rst_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/control_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/headerdata_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/spw_flag_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/mem_flag_i
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/flags_o
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/spw_control_o
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/mem_control_o
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/mem_byte_address_o
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_rmap_target_read_state
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_rmap_target_read_next_state
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_data_crc
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_error
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_byte_counter
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_address
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_byte_counter
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_read_address_vector
add wave -noupdate -expand -group rmap_read -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_read_ent_inst/s_byte_counter_vector
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/clk_i
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/rst_i
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/control_i
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/headerdata_i
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_flag_i
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/flags_o
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/spw_control_o
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/s_rmap_target_reply_state
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/s_rmap_target_reply_next_state
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/s_reply_header_crc
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/s_byte_counter
add wave -noupdate -expand -group rmap_reply -radix hexadecimal /testbench_top/comm_v2_top_inst/rmap_target_top_inst/rmap_target_reply_ent_inst/s_reply_address_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 348
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
WaveRestoreZoom {0 ps} {878 ps}
