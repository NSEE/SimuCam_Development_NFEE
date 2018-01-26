use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_transaction_identifier_pkg is

	procedure rmap_target_write_command_header_transaction_identifier_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_transaction_identifier_pkg;

package body rmap_target_write_command_header_transaction_identifier_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.8
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.9
	procedure rmap_target_write_command_header_transaction_identifier_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		case (rmap_target_write_control_const.byte_num) is
			when 1 =>                   -- Byte 1, Most Significant
				rmap_target_write_status_var.transaction_identifier(15 downto 8) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                               := '0';
				rmap_target_write_status_var.next_state                          := '0';
			when 0 =>                   -- Byte 1, Less Significant
				rmap_target_write_status_var.transaction_identifier(7 downto 0) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                              := '0';
				rmap_target_write_status_var.next_state                         := '1';
			when others =>              -- Error in the control machine
				rmap_target_write_status_var.error := '1';
		end case;

	end procedure rmap_target_write_command_header_transaction_identifier_procedure;

end package body rmap_target_write_command_header_transaction_identifier_pkg;
