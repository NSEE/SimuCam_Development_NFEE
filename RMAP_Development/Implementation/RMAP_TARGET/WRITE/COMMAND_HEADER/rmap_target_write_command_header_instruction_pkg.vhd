use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_instruction_pkg is

	procedure rmap_target_write_command_header_instruction_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_instruction_pkg;

package body rmap_target_write_command_header_instruction_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.4
	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.4.1
	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.4.2
	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.4.3
	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.4.4
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.5
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.5.1
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.5.2
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.5.3
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.5.4
	procedure rmap_target_write_command_header_instruction_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		rmap_target_write_status_var.packet_type                      := rmap_target_write_data_in_const.data(7 downto 6);
		rmap_target_write_status_var.command_write_read               := rmap_target_write_data_in_const.data(5);
		rmap_target_write_status_var.command_verify_data_before_write := rmap_target_write_data_in_const.data(4);
		rmap_target_write_status_var.command_reply                    := rmap_target_write_data_in_const.data(3);
		rmap_target_write_status_var.command_increment_address        := rmap_target_write_data_in_const.data(2);
		rmap_target_write_status_var.reply_address_length             := rmap_target_write_data_in_const.data(1 downto 0);

		if ((rmap_target_write_status_var.packet_type = "01") and (rmap_target_write_status_var.command_write_read = '1')) then -- (Command packet) and (Write command)
			rmap_target_write_status_var.error      := '0';
			rmap_target_write_status_var.next_state := '1';
		else
			rmap_target_write_status_var.error := '1';
		end if;

	end procedure rmap_target_write_command_header_instruction_procedure;

end package body rmap_target_write_command_header_instruction_pkg;
