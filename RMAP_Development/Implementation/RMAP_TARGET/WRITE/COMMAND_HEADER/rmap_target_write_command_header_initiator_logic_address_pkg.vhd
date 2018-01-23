use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_initiator_logic_address_pkg is

	procedure rmap_target_write_command_header_initiator_logic_address_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_initiator_logic_address_pkg;

package body rmap_target_write_command_header_initiator_logic_address_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.7
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.8
	procedure rmap_target_write_command_header_initiator_logic_address_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		rmap_target_write_status_var.initiator_logic_address := rmap_target_write_data_in_const.data;
		rmap_target_write_status_var.error                   := '0';
		rmap_target_write_status_var.next_state              := '1';

	end procedure rmap_target_write_command_header_initiator_logic_address_procedure;

end package body rmap_target_write_command_header_initiator_logic_address_pkg;
