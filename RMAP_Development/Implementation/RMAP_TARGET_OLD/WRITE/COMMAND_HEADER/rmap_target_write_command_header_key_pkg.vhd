use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_key_pkg is

	procedure rmap_target_write_command_header_key_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_key_pkg;

package body rmap_target_write_command_header_key_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.5
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.6
	procedure rmap_target_write_command_header_key_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		if (rmap_target_write_data_in_const.data = rmap_target_write_control_const.key) then
			rmap_target_write_status_var.error      := '0';
			rmap_target_write_status_var.next_state := '1';
		else
			rmap_target_write_status_var.error             := '1';
			rmap_target_write_status_var.discard_package   := '1';
			rmap_target_write_status_var.not_send_reply    := '0';
			rmap_target_write_status_var.invalid_key_flag  := '1';
			rmap_target_write_status_var.status_error_code := 3;
		end if;

	end procedure rmap_target_write_command_header_key_procedure;

end package body rmap_target_write_command_header_key_pkg;
