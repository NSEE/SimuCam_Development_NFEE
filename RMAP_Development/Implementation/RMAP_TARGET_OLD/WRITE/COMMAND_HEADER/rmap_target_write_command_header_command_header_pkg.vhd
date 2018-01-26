use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_command_header_pkg is

	procedure rmap_target_write_command_header_command_header_procedure(
		constant rmap_target_write_data_in_const  : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const  : in rmap_target_write_control_type;
		variable rmap_target_write_status_var   : out rmap_target_write_status_type;
		variable rmap_target_write_error_var    : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var : out rmap_target_write_data_out_type
	);
	
end package rmap_target_write_command_header_command_header_pkg;

package body rmap_target_write_command_header_command_header_pkg is

	procedure rmap_target_write_command_header_command_header_procedure(
		constant rmap_target_write_data_in_const  : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const  : in rmap_target_write_control_type;
		variable rmap_target_write_status_var   : out rmap_target_write_status_type;
		variable rmap_target_write_error_var    : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var : out rmap_target_write_data_out_type
	) is

	begin

	end procedure rmap_target_write_command_header_command_header_procedure;
	
end package body rmap_target_write_command_header_command_header_pkg;
