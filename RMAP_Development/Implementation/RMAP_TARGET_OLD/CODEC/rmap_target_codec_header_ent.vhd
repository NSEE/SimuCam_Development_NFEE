library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_codec_pkg.all;
use work.rmap_target_codec_crc_pkg.all;

entity rmap_target_codec_header_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		-- spw codec comunication (data receive)
		spw_valid_i           : in  std_logic;
		spw_flag_i            : in  std_logic;
		spw_data_i            : in  std_logic_vector(7 downto 0);
		spw_read_o            : out std_logic;
		spw_codec_error_o     : out std_logic;
		-- header data
		rmap_header_data_o    : out rmap_target_codec_header_data_type;
		-- error flags
		rmap_header_error_o   : out rmap_target_codec_header_error_type;
		-- status flags
		rmap_header_flags_o   : out rmap_target_codec_header_flags_type;
		-- control flags
		rmap_header_control_i : in  rmap_target_codec_header_control_type;
		-- busy flag
		rmap_header_busy_o    : out std_logic
	);
end entity rmap_target_codec_header_ent;

architecture RTL of rmap_target_codec_header_ent is

	type rmap_header_state_machine_type is (
		standby_state,
		waiting_data_state,
		field_target_logical_address_state,
		field_protocol_identifier_state,
		field_instruction_state,
		field_key_state,
		field_reply_address_state,
		field_initiator_logical_address_state,
		field_transaction_identifier_state,
		field_extended_address_state,
		field_address_state,
		field_data_length_state,
		field_header_crc_state,
		field_eop_state,
		error_check_state,
		unexpected_package_end_state,
		discard_package_state,
		not_rmap_package_state,
		waiting_package_end_state
	);

	constant SPW_EOP_CONST : std_logic := '0';
	constant SPW_EEP_CONST : std_logic := '1';

begin

	rmap_target_codec_header_proc : process(clk_i, rst_i) is
		variable rmap_header_data_var                     : rmap_target_codec_header_data_type;
		variable rmap_header_error_var                    : rmap_target_codec_header_error_type;
		variable rmap_header_flags_var                    : rmap_target_codec_header_flags_type;
		variable rmap_header_state_machine_var            : rmap_header_state_machine_type := standby_state;
		variable rmap_header_state_machine_next_state_var : rmap_header_state_machine_type := standby_state;
		variable rmap_header_crc_var                      : std_logic_vector(7 downto 0)   := (others => '0');
		variable rmap_header_byte_field_counter_var       : natural range 0 to 12          := 0;

	begin
		if (rst_i = '1') then
			-- reset procedures

			-- ports init
			-- spw codec comunication (data receive)
			spw_read_o                                   <= '0';
			spw_codec_error_o                            <= '0';
			-- header data
			rmap_header_data_o.target_logical_address    <= (others => '0');
			rmap_header_data_o.instructions              <= RMAP_INSTRUCTION_RESET;
			rmap_header_data_o.key                       <= (others => '0');
			rmap_header_data_o.reply_address             <= (others => x"00");
			rmap_header_data_o.reply_address_is_used     <= '0';
			rmap_header_data_o.initiator_logical_address <= (others => '0');
			rmap_header_data_o.transaction_identifier    <= (others => x"00");
			rmap_header_data_o.extended_address          <= (others => '0');
			rmap_header_data_o.address                   <= (others => x"00");
			rmap_header_data_o.data_length               <= (others => x"00");
			-- error flags
			rmap_header_error_o.early_eop                <= '0';
			rmap_header_error_o.eep                      <= '0';
			rmap_header_error_o.header_crc               <= '0';
			rmap_header_error_o.unused_packet_type       <= '0';
			rmap_header_error_o.invalid_command_code     <= '0';
			rmap_header_error_o.too_much_data            <= '0';
			-- status flags
			rmap_header_flags_o.command_received         <= '0';
			rmap_header_flags_o.write_request            <= '0';
			rmap_header_flags_o.read_request             <= '0';
			rmap_header_flags_o.discarded_package        <= '0';
			-- busy flag
			rmap_header_busy_o                           <= '0';

			-- signals init

			-- variables init
			-- rmap_header_data_var
			rmap_header_data_var.target_logical_address    := (others => '0');
			rmap_header_data_var.instructions              := RMAP_INSTRUCTION_RESET;
			rmap_header_data_var.key                       := (others => '0');
			rmap_header_data_var.reply_address             := (others => x"00");
			rmap_header_data_var.reply_address_is_used     := '0';
			rmap_header_data_var.initiator_logical_address := (others => '0');
			rmap_header_data_var.transaction_identifier    := (others => x"00");
			rmap_header_data_var.extended_address          := (others => '0');
			rmap_header_data_var.address                   := (others => x"00");
			rmap_header_data_var.data_length               := (others => x"00");
			-- rmap_header_error_var
			rmap_header_error_var.early_eop                := '0';
			rmap_header_error_var.eep                      := '0';
			rmap_header_error_var.header_crc               := '0';
			rmap_header_error_var.unused_packet_type       := '0';
			rmap_header_error_var.invalid_command_code     := '0';
			rmap_header_error_var.too_much_data            := '0';
			-- rmap_header_flags_var
			rmap_header_flags_var.command_received         := '0';
			rmap_header_flags_var.write_request            := '0';
			rmap_header_flags_var.read_request             := '0';
			rmap_header_flags_var.discarded_package        := '0';
			-- non-record variables
			rmap_header_state_machine_var                  := standby_state;
			rmap_header_state_machine_next_state_var       := standby_state;
			rmap_header_crc_var                            := (others => '0');
			rmap_header_byte_field_counter_var             := 0;
		elsif (rising_edge(clk_i)) then

			-- signals atribution to avoid latches and paths were no value is given to a signal
			spw_read_o          <= spw_read_o;
			spw_codec_error_o   <= spw_codec_error_o;
			rmap_header_data_o  <= rmap_header_data_o;
			rmap_header_error_o <= rmap_header_error_o;
			rmap_header_flags_o <= rmap_header_flags_o;
			rmap_header_busy_o  <= rmap_header_busy_o;

			-- variables atribution checks to avoid a path where no value is given to a variable

			case (rmap_header_state_machine_var) is

				when standby_state =>
					-- does nothing until user application signals it is ready for a new package
					rmap_header_busy_o                             <= '0';
					-- reset internal information
					-- rmap_header_data_var
					rmap_header_data_var.target_logical_address    := (others => '0');
					rmap_header_data_var.instructions              := RMAP_INSTRUCTION_RESET;
					rmap_header_data_var.key                       := (others => '0');
					rmap_header_data_var.reply_address             := (others => x"00");
					rmap_header_data_var.reply_address_is_used     := '0';
					rmap_header_data_var.initiator_logical_address := (others => '0');
					rmap_header_data_var.transaction_identifier    := (others => x"00");
					rmap_header_data_var.extended_address          := (others => '0');
					rmap_header_data_var.address                   := (others => x"00");
					rmap_header_data_var.data_length               := (others => x"00");
					-- rmap_header_error_var
					rmap_header_error_var.early_eop                := '0';
					rmap_header_error_var.eep                      := '0';
					rmap_header_error_var.header_crc               := '0';
					rmap_header_error_var.unused_packet_type       := '0';
					rmap_header_error_var.invalid_command_code     := '0';
					rmap_header_error_var.too_much_data            := '0';
					-- rmap_header_flags_var
					rmap_header_flags_var.command_received         := '0';
					rmap_header_flags_var.write_request            := '0';
					rmap_header_flags_var.read_request             := '0';
					rmap_header_flags_var.discarded_package        := '0';
					-- non-record variables
					rmap_header_crc_var                            := (others => '0');
					rmap_header_byte_field_counter_var             := 0;
					-- keep output as is
					spw_read_o                                     <= '0';
					spw_codec_error_o                              <= spw_codec_error_o;
					rmap_header_data_o                             <= rmap_header_data_o;
					rmap_header_error_o                            <= rmap_header_error_o;
					rmap_header_flags_o                            <= rmap_header_flags_o;
					-- check if user application is ready for another package
					if (rmap_header_control_i.ready_for_another_package = '1') then
						-- ready; set busy flag; go to waiting data
						rmap_header_busy_o                       <= '1';
						rmap_header_state_machine_var            := waiting_data_state;
						rmap_header_state_machine_next_state_var := field_target_logical_address_state;
					else
						-- not ready; stay in standby
						rmap_header_state_machine_var := standby_state;
					end if;

				when waiting_data_state =>
					spw_read_o <= '0';
					if (spw_valid_i = '1') then
						rmap_header_state_machine_var := rmap_header_state_machine_next_state_var;
					else
						rmap_header_state_machine_var := waiting_data_state;
					end if;

				when field_target_logical_address_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.target_logical_address := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                         := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                  <= '1';
						rmap_header_state_machine_var               := waiting_data_state;
						rmap_header_state_machine_next_state_var    := field_protocol_identifier_state;
					end if;

				when field_protocol_identifier_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- check if the arriving packages are in rmap protocol
						if (spw_data_i = RMAP_PROTOCOL_IDENTIFIER_CONST) then
							-- rmap protocol arriving
							-- update crc calculation
							rmap_header_crc_var                      := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
							-- prepare for next field arrival
							rmap_header_state_machine_var            := waiting_data_state;
							rmap_header_state_machine_next_state_var := field_instruction_state;
						else
							-- not rmap protocol, go to treatment state
							rmap_header_state_machine_var := not_rmap_package_state;
						end if;
						-- indicate that the spw data was used
						spw_read_o <= '1';
					end if;

				when field_instruction_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.instructions.packet_type                      := spw_data_i(7 downto 6);
						rmap_header_data_var.instructions.command.write_read               := spw_data_i(5);
						rmap_header_data_var.instructions.command.verify_data_before_write := spw_data_i(4);
						rmap_header_data_var.instructions.command.reply                    := spw_data_i(3);
						rmap_header_data_var.instructions.command.increment_address        := spw_data_i(2);
						rmap_header_data_var.instructions.reply_address_length             := spw_data_i(1 downto 0);
						-- update crc calculation
						rmap_header_crc_var                                                := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                                         <= '1';
						rmap_header_state_machine_var                                      := waiting_data_state;
						rmap_header_state_machine_next_state_var                           := field_key_state;
					end if;

				when field_key_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.key      := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var           := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                    <= '1';
						rmap_header_state_machine_var := waiting_data_state;
						-- prepare byte field counter for multi-field header data
						case (rmap_header_data_var.instructions.reply_address_length) is
							when "00" =>
								rmap_header_state_machine_next_state_var   := field_initiator_logical_address_state;
								rmap_header_data_var.reply_address_is_used := '0';
								rmap_header_byte_field_counter_var         := 0;
							when "01" =>
								rmap_header_state_machine_next_state_var   := field_reply_address_state;
								rmap_header_data_var.reply_address_is_used := '1';
								rmap_header_byte_field_counter_var         := 4;
							when "10" =>
								rmap_header_state_machine_next_state_var   := field_reply_address_state;
								rmap_header_data_var.reply_address_is_used := '1';
								rmap_header_byte_field_counter_var         := 8;
							when "11" =>
								rmap_header_state_machine_next_state_var   := field_reply_address_state;
								rmap_header_data_var.reply_address_is_used := '1';
								rmap_header_byte_field_counter_var         := 12;
						end case;
					end if;

				when field_reply_address_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.reply_address(rmap_header_byte_field_counter_var) := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                                                    := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- update byte field counter
						rmap_header_byte_field_counter_var                                     := rmap_header_byte_field_counter_var - 1;
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                                             <= '1';
						rmap_header_state_machine_var                                          := waiting_data_state;
						-- check if multi-field header data ended
						if (rmap_header_byte_field_counter_var = 0) then
							-- last byte field processed, go to next header data
							rmap_header_state_machine_next_state_var := field_initiator_logical_address_state;
						else
							-- more byte fields remaining
							rmap_header_state_machine_next_state_var := field_reply_address_state;
						end if;
					end if;

				when field_initiator_logical_address_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.initiator_logical_address := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                            := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                     <= '1';
						rmap_header_state_machine_var                  := waiting_data_state;
						rmap_header_state_machine_next_state_var       := field_extended_address_state;
						-- prepare byte field counter for multi-field header data
						rmap_header_byte_field_counter_var             := 2;
					end if;

				when field_transaction_identifier_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.transaction_identifier(rmap_header_byte_field_counter_var) := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                                                             := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- update byte field counter
						rmap_header_byte_field_counter_var                                              := rmap_header_byte_field_counter_var - 1;
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                                                      <= '1';
						rmap_header_state_machine_var                                                   := waiting_data_state;
						-- check if multi-field header data ended
						if (rmap_header_byte_field_counter_var = 0) then
							-- last byte field processed, go to next header data
							rmap_header_state_machine_next_state_var := field_extended_address_state;
							-- prepare byte field counter for multi-field header data
							rmap_header_byte_field_counter_var       := 3;
						else
							-- more byte fields remaining
							rmap_header_state_machine_next_state_var := field_transaction_identifier_state;
						end if;
					end if;

				when field_extended_address_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.extended_address    := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                      := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                               <= '1';
						rmap_header_state_machine_var            := waiting_data_state;
						rmap_header_state_machine_next_state_var := field_address_state;
						-- prepare byte field counter for multi-field header data
						rmap_header_byte_field_counter_var       := 4;
					end if;

				when field_address_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.address(rmap_header_byte_field_counter_var) := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                                              := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- update byte field counter
						rmap_header_byte_field_counter_var                               := rmap_header_byte_field_counter_var - 1;
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                                       <= '1';
						rmap_header_state_machine_var                                    := waiting_data_state;
						-- check if multi-field header data ended
						if (rmap_header_byte_field_counter_var = 0) then
							-- last byte field processed, go to next header data
							rmap_header_state_machine_next_state_var := field_data_length_state;
							-- prepare byte field counter for multi-field header data
							rmap_header_byte_field_counter_var       := 3;
						else
							-- more byte fields remaining
							rmap_header_state_machine_next_state_var := field_address_state;
						end if;
					end if;

				when field_data_length_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- collect field data
						rmap_header_data_var.data_length(rmap_header_byte_field_counter_var) := spw_data_i;
						-- update crc calculation
						rmap_header_crc_var                                                  := RMAP_CalculateCRC(rmap_header_crc_var, spw_data_i);
						-- update byte field counter
						rmap_header_byte_field_counter_var                                   := rmap_header_byte_field_counter_var - 1;
						-- indicate that the spw data was used; prepare for next field arrival
						spw_read_o                                                           <= '1';
						rmap_header_state_machine_var                                        := waiting_data_state;
						-- check if multi-field header data ended
						if (rmap_header_byte_field_counter_var = 0) then
							-- last byte field processed, go to next header data
							rmap_header_state_machine_next_state_var := field_header_crc_state;
						else
							-- more byte fields remaining
							rmap_header_state_machine_next_state_var := field_data_length_state;
						end if;
					end if;

				when field_header_crc_state =>
					-- check if an unexpected eop or eep arrived
					if (spw_flag_i = '1') then
						-- unexpected eop or eep, go to treatment state
						rmap_header_state_machine_var := unexpected_package_end_state;
					else
						-- expected header field
						-- check if the incoming header crc matches the calculated one
						if (spw_data_i = rmap_header_crc_var) then
							-- header crc match
							-- check if the command is for a write or a read
							if (rmap_header_data_var.instructions.command.write_read = '1') then
								-- write command, next expected field is a data field; go to header error checking
								rmap_header_state_machine_var := error_check_state;
							else
								-- read command, next expected field is an eop
								-- prepare for next field arrival
								rmap_header_state_machine_var            := waiting_data_state;
								rmap_header_state_machine_next_state_var := field_eop_state;
								-- indicate that the spw data was used
								spw_read_o                               <= '1';
							end if;
						else
							-- header crc does not match; flag the error and discard the package
							rmap_header_error_var.header_crc := '1';
							rmap_header_state_machine_var    := discard_package_state;
						end if;
					end if;

				when field_eop_state =>
					-- check if an eop or eep arrived
					if (spw_flag_i = '1') then
						if (spw_data_i = SPW_EOP_CONST) then
							-- eop arrived as expected; go to header error checking
							rmap_header_state_machine_var := error_check_state;
						elsif (spw_data_i = SPW_EEP_CONST) then
							-- unexpected eep; flag the error and discard the package
							rmap_header_error_var.eep     := '1';
							rmap_header_state_machine_var := discard_package_state;
						else
							-- spacewire codec error (impossible value)
							-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
							spw_codec_error_o             <= '1';
							spw_read_o                    <= '1';
							rmap_header_busy_o            <= '0';
							rmap_header_state_machine_var := standby_state;
						end if;
					else
						-- data characters in read command; flag the error and discard the package
						rmap_header_error_var.too_much_data := '1';
						rmap_header_state_machine_var       := discard_package_state;
					end if;

				when error_check_state =>
					-- check if an unused packet type error occurred
					if (rmap_header_data_var.instructions.packet_type(1) = '1') then
						-- error occured; flag the error and discard the package
						rmap_header_error_var.unused_packet_type := '1';
						rmap_header_state_machine_var            := discard_package_state;
					-- check if an invalid command code error occurred
					elsif ((rmap_header_data_var.instructions.command.write_read = '0') and ((rmap_header_data_var.instructions.command.reply = '0') or ((rmap_header_data_var.instructions.command.verify_data_before_write = '1') and (rmap_header_data_var.instructions.command.reply = '1') and (rmap_header_data_var.instructions.command.increment_address = '0')))) then
						-- error occured; flag the error and discard the package
						rmap_header_error_var.invalid_command_code := '1';
						rmap_header_state_machine_var              := discard_package_state;
					else
						-- no error occured
						-- update output information
						rmap_header_data_o            <= rmap_header_data_var;
						rmap_header_flags_o           <= rmap_header_flags_var;
						-- indicate that the spw data was used; clear busy flag; go to standby
						spw_read_o                    <= '1';
						rmap_header_busy_o            <= '0';
						rmap_header_state_machine_var := standby_state;
					end if;

				when unexpected_package_end_state =>
					-- verify if the unexpected package end is an eop or an eep
					-- not necessary to check the flag because it was already checked in the previous state
					if (spw_data_i = SPW_EOP_CONST) then
						-- incomplete header error; flag the error and discard the package
						rmap_header_error_var.early_eop := '1';
						rmap_header_state_machine_var   := discard_package_state;
					elsif (spw_data_i = SPW_EEP_CONST) then
						-- error end of package; flag the error and discard the package
						rmap_header_error_var.eep     := '1';
						rmap_header_state_machine_var := discard_package_state;
					else
						-- spacewire codec error (impossible value)
						-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
						spw_codec_error_o             <= '1';
						spw_read_o                    <= '1';
						rmap_header_busy_o            <= '0';
						rmap_header_state_machine_var := standby_state;
					end if;

				when discard_package_state =>
					-- reset all collected information (excepted relevant errors)
					rmap_header_data_var.target_logical_address    := (others => '0');
					rmap_header_data_var.instructions              := RMAP_INSTRUCTION_RESET;
					rmap_header_data_var.key                       := (others => '0');
					rmap_header_data_var.reply_address             := (others => x"00");
					rmap_header_data_var.reply_address_is_used     := '0';
					rmap_header_data_var.initiator_logical_address := (others => '0');
					rmap_header_data_var.transaction_identifier    := (others => x"00");
					rmap_header_data_var.extended_address          := (others => '0');
					rmap_header_data_var.address                   := (others => x"00");
					rmap_header_data_var.data_length               := (others => x"00");
					-- flag that a package was discarded; update output information;
					rmap_header_flags_var.discarded_package        := '1';
					rmap_header_data_o                             <= rmap_header_data_var;
					rmap_header_flags_o                            <= rmap_header_flags_var;
					-- go to wating package end
					rmap_header_state_machine_var                  := waiting_package_end_state;

				when not_rmap_package_state =>
					-- reset all collected information (including errors)
					rmap_header_data_var.target_logical_address    := (others => '0');
					rmap_header_data_var.instructions              := RMAP_INSTRUCTION_RESET;
					rmap_header_data_var.key                       := (others => '0');
					rmap_header_data_var.reply_address             := (others => x"00");
					rmap_header_data_var.reply_address_is_used     := '0';
					rmap_header_data_var.initiator_logical_address := (others => '0');
					rmap_header_data_var.transaction_identifier    := (others => x"00");
					rmap_header_data_var.extended_address          := (others => '0');
					rmap_header_data_var.address                   := (others => x"00");
					rmap_header_data_var.data_length               := (others => x"00");
					rmap_header_error_var.early_eop                := '0';
					rmap_header_error_var.eep                      := '0';
					rmap_header_error_var.header_crc               := '0';
					rmap_header_error_var.unused_packet_type       := '0';
					rmap_header_error_var.invalid_command_code     := '0';
					rmap_header_error_var.too_much_data            := '0';
					rmap_header_data_o                             <= rmap_header_data_var;
					rmap_header_flags_o                            <= rmap_header_flags_var;
					-- go to wating package end
					rmap_header_state_machine_var                  := waiting_package_end_state;

				when waiting_package_end_state =>
					-- check if an eop or eep arrived
					if (spw_flag_i = '1') then
						if ((spw_data_i = SPW_EOP_CONST) or (spw_data_i = SPW_EEP_CONST)) then
							-- current package ended (eop or eep arrived)
							-- indicate that the spw data was used; clear busy flag; go to standy
							spw_read_o                    <= '1';
							rmap_header_busy_o            <= '0';
							rmap_header_state_machine_var := standby_state;
						else
							-- spacewire codec error (impossible value)
							-- flag the error; indicate that the spw data was used; clear busy flag; go to standby
							spw_codec_error_o             <= '1';
							spw_read_o                    <= '1';
							rmap_header_busy_o            <= '0';
							rmap_header_state_machine_var := standby_state;
						end if;
					else
						-- not end of current package yet; keep listening
						-- indicate that the spw data was used; prepare for next byte arrival
						spw_read_o                               <= '1';
						rmap_header_state_machine_var            := waiting_data_state;
						rmap_header_state_machine_next_state_var := waiting_package_end_state;
					end if;

			end case;

		end if;
	end process rmap_target_codec_header_proc;

end architecture RTL;
