use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_protocol_identifier_pkg is

	procedure rmap_target_write_command_header_protocol_identifier_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_protocol_identifier_pkg;

package body rmap_target_write_command_header_protocol_identifier_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.3
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.4
	procedure rmap_target_write_command_header_protocol_identifier_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		if (rmap_target_write_data_in_const.data = x"01") then -- RMAP protocol
			rmap_target_write_status_var.error      := '0';
			rmap_target_write_status_var.next_state := '1';
		else
			rmap_target_write_status_var.error := '1';
		end if;

	end procedure rmap_target_write_command_header_protocol_identifier_procedure;

end package body rmap_target_write_command_header_protocol_identifier_pkg;
