library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;
use work.rmap_target_codec_crc_pkg.all;

entity rmap_target_codec_reply_ent is
	port(
		clk_i                : in  std_logic;
		rst_i                : in  std_logic;
		-- spw codec comunication (data transmission)
		spw_ready_i          : in  std_logic;
		spw_flag_o           : out std_logic;
		spw_data_o           : out std_logic_vector(7 downto 0);
		spw_write_o          : out std_logic;
		-- reply data
		rmap_reply_data_i    : in  rmap_target_codec_reply_data_type;
		-- error flags
		rmap_reply_error_o   : out rmap_target_codec_reply_error_type;
		-- status flags
		rmap_reply_flags_o   : out rmap_target_codec_reply_flags_type;
		-- control flags
		rmap_reply_control_i : in  rmap_target_codec_reply_control_type;
		-- busy flag
		rmap_reply_busy_o    : out std_logic
	);
end entity rmap_target_codec_reply_ent;

architecture RTL of rmap_target_codec_reply_ent is

	type rmap_reply_state_machine_type is (
		standby_state,
		waiting_buffer_space_state,
		field_reply_spw_address_state,
		field_initiator_logical_address_state,
		field_protocol_identifier_state,
		field_instruction_state,
		field_status_state,
		field_target_logical_address_state,
		field_transaction_identifier_state,
		field_reserved_state,
		field_data_legnth_state,
		field_header_crc_state,
		field_eop_state
	);

	constant SPW_EOP_CONST : std_logic := '0';
	constant SPW_EEP_CONST : std_logic := '1';

begin

	rmap_target_codec_reply_proc : process(clk_i, rst_i) is
		variable rmap_reply_error_var                    : rmap_target_codec_reply_error_type;
		variable rmap_reply_flags_var                    : rmap_target_codec_reply_flags_type;
		variable rmap_reply_state_machine_var            : rmap_reply_state_machine_type := standby_state;
		variable rmap_reply_state_machine_next_state_var : rmap_reply_state_machine_type := standby_state;
		variable rmap_reply_crc_var                      : std_logic_vector(7 downto 0)  := (others => '0');
		variable rmap_reply_byte_field_counter_var       : natural range 0 to 12         := 0;
		variable rmap_reply_reply_swp_address_flag       : std_logic_vector              := '0';

	begin
		if (rst_i = '1') then
			-- reset procedures
			-- TODO: reset procedures

			-- signals init
			-- TODO: signals init

			-- variables init
			-- TODO: variables init
			--rmap_reply_error_var
			--rmap_reply_flags_var
			rmap_reply_state_machine_var            := standby_state;
			rmap_reply_state_machine_next_state_var := standby_state;
			rmap_reply_crc_var                      := (others => '0');
			rmap_reply_byte_field_counter_var       := 0;
			rmap_reply_reply_swp_address_flag       := '0';
		elsif (rising_edge(clk_i)) then

			-- TODO: signals atribution to avoid latches and paths were no value is given to a signal
			-- TODO: variables atribution checks to avoid a path where no value is given to a variable

			case (rmap_reply_state_machine_var) is

				when standby_state =>
					-- does nothing until user application signals it is ready to send a reply
					rmap_reply_busy_o <= '0';
					-- reset internal information
					-- TODO: reset internal information
					-- keep output as is
					-- TODO: keep output as is
					-- check if user application is ready to send a reply
					if (rmap_reply_control_i.ready_to_send_reply = '1') then
						-- ready; set busy flag; go to waiting buffer space
						rmap_reply_busy_o            <= '1';
						rmap_reply_state_machine_var := waiting_buffer_space_state;
						-- check if a reply spw address is to be used
						if (rmap_reply_data_i.reply_spw_address_is_used = '1') then
							-- reply spw address is used, set next field as reply spw address
							rmap_reply_state_machine_next_state_var := field_reply_spw_address_state;
							-- prepare byte field counter for multi-field reply data
							rmap_reply_byte_field_counter_var       := 12;
						else
							-- reply spw address not used, set next field as initiator logical address
							rmap_reply_state_machine_next_state_var := field_initiator_logical_address_state;
						end if;
					else
						-- not ready; stay in standby
						rmap_reply_state_machine_var := standby_state;
					end if;

				when waiting_buffer_space_state =>
					spw_write_o <= '0';
					if (spw_ready_i = '1') then
						rmap_reply_state_machine_var := rmap_reply_state_machine_next_state_var;
					else
						rmap_reply_state_machine_var := waiting_buffer_space_state;
					end if;

				when field_reply_spw_address_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                        <= '0';
					-- fill spw data with field data
					spw_data_o                        <= rmap_reply_data_i.reply_spw_address(rmap_reply_byte_field_counter_var);
					-- the leading zeros in the reply spw address must not be sent
					-- check if address data was already found (not leading zeros)
					if (rmap_reply_reply_swp_address_flag = '1') then
						-- leading zeros already eliminated, write field data
						-- write the spw data; prepare for next field
						spw_write_o                  <= '1';
						rmap_reply_state_machine_var := waiting_buffer_space_state;
						-- update crc calculation
						rmap_reply_crc_var           := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.reply_spw_address(rmap_reply_byte_field_counter_var));
					else
						-- check if the data is a zero
						if (rmap_reply_data_i.reply_spw_address(rmap_reply_byte_field_counter_var) = x"00") then
							-- check if this is the last reply spw address field
							if (rmap_reply_byte_field_counter_var = 1) then
								-- last field, send 0x00 as the only reply spw address field data
								-- write the spw data; prepare for next field
								spw_write_o                  <= '1';
								rmap_reply_state_machine_var := waiting_buffer_space_state;
								-- update crc calculation
								rmap_reply_crc_var           := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.reply_spw_address(rmap_reply_byte_field_counter_var));
							else
								-- leading zero, does not send anything
								spw_write_o <= '0';
							end if;
						else
							-- address data (no leading zero) found, flag and write field data
							-- flag that the leading zeros are over
							rmap_reply_reply_swp_address_flag := '1';
							-- write the spw data; prepare for next field
							spw_write_o                       <= '1';
							rmap_reply_state_machine_var      := waiting_buffer_space_state;
							-- update crc calculation
							rmap_reply_crc_var                := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.reply_spw_address(rmap_reply_byte_field_counter_var));
						end if;
					end if;
					-- update byte field counter
					rmap_reply_byte_field_counter_var := rmap_reply_byte_field_counter_var - 1;
					-- check if multi-field header data ended
					if (rmap_reply_byte_field_counter_var = 0) then
						-- last byte field processed, go to next reply data
						rmap_reply_state_machine_next_state_var := field_initiator_logical_address_state;
					else
						-- more byte fields remaining
						rmap_reply_state_machine_next_state_var := field_reply_spw_address_state;
					end if;

				when field_initiator_logical_address_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with field data
					spw_data_o                              <= rmap_reply_data_i.initiator_logical_address;
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.initiator_logical_address);
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_protocol_identifier_state;

				when field_protocol_identifier_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with the rmap protocol identifier (0x01)
					spw_data_o                              <= x"01";
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, x"01");
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_instruction_state;

				when field_instruction_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with field data
					-- packet type = 0b00 (reply packet)
					spw_data_o(7 downto 6)                  <= "00";
					-- same command field as the command 
					spw_data_o(5)                           <= rmap_reply_data_i.instructions.command.write_read;
					spw_data_o(4)                           <= rmap_reply_data_i.instructions.command.verify_data_before_write;
					spw_data_o(3)                           <= rmap_reply_data_i.instructions.command.reply;
					spw_data_o(2)                           <= rmap_reply_data_i.instructions.command.increment_address;
					-- same reply address length as the command
					spw_data_o(1 downto 0)                  <= rmap_reply_data_i.instructions.reply_address_length;
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, (("00") & (rmap_reply_data_i.instructions.command.write_read) & (rmap_reply_data_i.instructions.command.verify_data_before_write) & (rmap_reply_data_i.instructions.command.reply) & (rmap_reply_data_i.instructions.command.increment_address) & (rmap_reply_data_i.instructions.reply_address_length)));
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_status_state;

				when field_status_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with field data
					spw_data_o                              <= rmap_reply_data_i.status;
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.status);
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_target_logical_address_state;

				when field_target_logical_address_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with field data
					spw_data_o                              <= rmap_reply_data_i.target_logical_address;
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.target_logical_address);
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_transaction_identifier_state;
					-- prepare byte field counter for multi-field reply data
					rmap_reply_byte_field_counter_var       := 2;

				when field_transaction_identifier_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                        <= '0';
					-- fill spw data with field data
					spw_data_o                        <= rmap_reply_data_i.transaction_identifier(rmap_reply_byte_field_counter_var);
					-- update crc calculation
					rmap_reply_crc_var                := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.transaction_identifier(rmap_reply_byte_field_counter_var));
					-- update byte field counter
					rmap_reply_byte_field_counter_var := rmap_reply_byte_field_counter_var - 1;
					-- write the spw data; prepare for next field
					spw_write_o                       <= '1';
					rmap_reply_state_machine_var      := waiting_buffer_space_state;
					-- check if multi-field header data ended
					if (rmap_reply_byte_field_counter_var = 0) then
						-- last byte field processed, go to next reply data
						-- check if it is a write reply or a read reply
						if (rmap_reply_data_i.instructions.command.write_read = '1') then
							-- write reply, next field to be written is the reply header crc
							rmap_reply_state_machine_next_state_var := field_header_crc_state;
						else
							-- read reply, next field to be written is the reserved
							rmap_reply_state_machine_next_state_var := field_reserved_state;
						end if;
					else
						-- more byte fields remaining
						rmap_reply_state_machine_next_state_var := field_transaction_identifier_state;
					end if;

				when field_reserved_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                              <= '0';
					-- fill spw data with the reserved field data (0x00)
					spw_data_o                              <= x"00";
					-- update crc calculation
					rmap_reply_crc_var                      := RMAP_CalculateCRC(rmap_reply_crc_var, x"00");
					-- write the spw data; prepare for next field
					spw_write_o                             <= '1';
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_data_legnth_state;
					-- prepare byte field counter for multi-field reply data
					rmap_reply_byte_field_counter_var       := 3;

				when field_data_legnth_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o                        <= '0';
					-- fill spw data with field data
					spw_data_o                        <= rmap_reply_data_i.data_length(rmap_reply_byte_field_counter_var);
					-- update crc calculation
					rmap_reply_crc_var                := RMAP_CalculateCRC(rmap_reply_crc_var, rmap_reply_data_i.data_length(rmap_reply_byte_field_counter_var));
					-- update byte field counter
					rmap_reply_byte_field_counter_var := rmap_reply_byte_field_counter_var - 1;
					-- write the spw data; prepare for next field
					spw_write_o                       <= '1';
					rmap_reply_state_machine_var      := waiting_buffer_space_state;
					-- check if multi-field header data ended
					if (rmap_reply_byte_field_counter_var = 0) then
						-- last byte field processed, go to next reply data
						rmap_reply_state_machine_next_state_var := field_header_crc_state;
					else
						-- more byte fields remaining
						rmap_reply_state_machine_next_state_var := field_data_legnth_state;
					end if;

				when field_header_crc_state =>
					-- clear spw flag (to indicate a data)
					spw_flag_o  <= '0';
					-- fill spw data with the reply header crc
					spw_data_o  <= rmap_reply_crc_var;
					-- write the spw data; prepare for next field
					spw_write_o <= '1';
					-- check if it is a write reply or a read reply
					if (rmap_reply_data_i.instructions.command.write_read = '1') then
						-- write reply, next field to be written is the eop
						rmap_reply_state_machine_var            := waiting_buffer_space_state;
						rmap_reply_state_machine_next_state_var := field_eop_state;
					else
						-- read reply, next field to be written is a data field
						-- indicate the end of the read reply header
						rmap_reply_flags_var.read_reply_finished := '1';
						-- update output data
						-- TODO: update output data
						-- clear busy flag, go to standby
						rmap_reply_busy_o                        <= '0';
						rmap_reply_state_machine_var             := standby_state;
					end if;

					-- prepare for next field
					rmap_reply_state_machine_var            := waiting_buffer_space_state;
					rmap_reply_state_machine_next_state_var := field_eop_state;

				when field_eop_state =>
					-- set spw flag (to indicate a package end)
					spw_flag_o                                <= '1';
					-- fill spw data with the eop identifier (0x01)
					spw_data_o(7 downto 1)                    <= (others => '0');
					spw_data_o(0)                             <= SPW_EOP_CONST;
					-- write the spw data; indicate the end of the write reply
					spw_write_o                               <= '1';
					rmap_reply_flags_var.write_reply_finished := '1';
					-- update output data
					-- TODO : update output data
					-- clear busy flag, go to standby
					rmap_reply_busy_o                         <= '0';
					rmap_reply_state_machine_var              := standby_state;

			end case;

		end if;
	end process rmap_target_codec_reply_proc;

end architecture RTL;
