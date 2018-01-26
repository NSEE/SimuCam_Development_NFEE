use work.rmap_target_write_pkg.all;

package rmap_target_write_command_header_reply_address_pkg is

	procedure rmap_target_write_command_header_reply_address_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	);

end package rmap_target_write_command_header_reply_address_pkg;

package body rmap_target_write_command_header_reply_address_pkg is

	-- Comply with ECSS-E-ST-50-52C, Clause 5.1.6
	-- Comply with ECSS-E-ST-50-52C, Clause 5.3.1.7
	procedure rmap_target_write_command_header_reply_address_procedure(
		constant rmap_target_write_data_in_const : in rmap_target_write_data_in_type;
		constant rmap_target_write_control_const : in rmap_target_write_control_type;
		variable rmap_target_write_status_var    : out rmap_target_write_status_type;
		variable rmap_target_write_error_var     : out rmap_target_write_error_type;
		variable rmap_target_write_data_out_var  : out rmap_target_write_data_out_type
	) is

	begin

		case (rmap_target_write_control_const.byte_num) is
			when 11 =>                  -- Byte 12, Most Significant if reply_address_length = 0b11
				rmap_target_write_status_var.reply_address(95 downto 88) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 10 =>                  -- Byte 11
				rmap_target_write_status_var.reply_address(87 downto 80) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 9 =>                   -- Byte 10
				rmap_target_write_status_var.reply_address(79 downto 72) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 8 =>                   -- Byte 9
				rmap_target_write_status_var.reply_address(71 downto 64) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 7 =>                   -- Byte 8, Most Significant if reply_address_length = 0b10
				rmap_target_write_status_var.reply_address(63 downto 56) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 6 =>                   -- Byte 7
				rmap_target_write_status_var.reply_address(55 downto 48) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 5 =>                   -- Byte 6
				rmap_target_write_status_var.reply_address(47 downto 40) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 4 =>                   -- Byte 5
				rmap_target_write_status_var.reply_address(39 downto 32) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 3 =>                   -- Byte 4, Most Significant if reply_address_length = 0b01
				rmap_target_write_status_var.reply_address(31 downto 24) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 2 =>                   -- Byte 3
				rmap_target_write_status_var.reply_address(23 downto 16) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                       := '0';
				rmap_target_write_status_var.next_state                  := '0';
			when 1 =>                   -- Byte 2
				rmap_target_write_status_var.reply_address(15 downto 8) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                      := '0';
				rmap_target_write_status_var.next_state                 := '0';
			when 0 =>                   -- Byte 1, Less Significant
				rmap_target_write_status_var.reply_address(7 downto 0) := rmap_target_write_data_in_const.data;
				rmap_target_write_status_var.error                     := '0';
				rmap_target_write_status_var.next_state                := '1';
			when others =>              -- Error in the control machine
				rmap_target_write_status_var.error := '1';
		end case;

	end procedure rmap_target_write_command_header_reply_address_procedure;

end package body rmap_target_write_command_header_reply_address_pkg;
