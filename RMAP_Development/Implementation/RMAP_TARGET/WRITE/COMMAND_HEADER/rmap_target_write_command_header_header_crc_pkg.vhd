use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_header_crc_pkg is

	procedure rmap_target_write_command_header_header_crc_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_header_crc_pkg;

package body rmap_target_write_command_header_header_crc_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.12
	-- Comply with ECSS-E-ST-50-52C, Clause 5.2
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.13
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.3.4.4
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.3.4.5
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.3.4.6 (a. and b.)
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.3.4.7
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.3.4.8
	procedure rmap_target_write_command_header_header_crc_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		if (rmap_target_write_data_in_const.data = rmap_target_write_control_const.header_crc) then

			if ((rmap_target_write_control_const.packet_type = "10") or (rmap_target_write_control_const.packet_type = "11")) then -- Unused packet type
				rmap_target_write_status_var.error                                   := '1';
				rmap_target_write_status_var.discard_package                         := '1';
				rmap_target_write_status_var.not_send_reply                          := '1';
				rmap_target_write_status_var.unused_packet_type_or_command_code_flag := '1';
				rmap_target_write_status_var.status_error_code                       := 2;
			end if;

			if (((rmap_target_write_status_var.command_write_read = '0') and (rmap_target_write_status_var.command_verify_data_before_write = '0') and (rmap_target_write_status_var.command_reply = '0')) 
				or ((rmap_target_write_status_var.command_write_read = '0') and (rmap_target_write_status_var.command_verify_data_before_write = '1') and (rmap_target_write_status_var.command_reply = '0')) 
				or ((rmap_target_write_status_var.command_write_read = '0') and (rmap_target_write_status_var.command_verify_data_before_write = '1') and (rmap_target_write_status_var.command_reply = '1') and (rmap_target_write_status_var.command_increment_address = '0'))
			) then -- Invalid command code
				rmap_target_write_status_var.error                                   := '1';
				rmap_target_write_status_var.discard_package                         := '1';
				rmap_target_write_status_var.not_send_reply                          := '0';
				rmap_target_write_status_var.unused_packet_type_or_command_code_flag := '1';
				rmap_target_write_status_var.status_error_code                       := 2;
			end if;

			rmap_target_write_status_var.header_crc := rmap_target_write_control_const.header_crc;
			rmap_target_write_status_var.error      := '0';
			rmap_target_write_status_var.next_state := '1';
		else                            -- Header CRC does not match, Header CRC error
			rmap_target_write_status_var.error                 := '1';
			rmap_target_write_status_var.discard_package       := '1';
			rmap_target_write_status_var.not_send_reply        := '1';
			rmap_target_write_status_var.header_crc_error_flag := '1';
		end if;

	end procedure rmap_target_write_command_header_header_crc_procedure;

end package body rmap_target_write_command_header_header_crc_pkg;
