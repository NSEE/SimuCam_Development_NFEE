--=============================================================================
--! @file rmap_target_command_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
use work.RMAP_TARGET_PKG.ALL;
use work.RMAP_TARGET_CRC_PKG.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: RMAP Target Command Parsing (rmap_target_command_ent)
--
--! @brief Entity for Target RMAP Command Parsing. Handles the receive of  
--! SpaceWire data (in flag + data format) and the parsing of all RMAP Command 
--! Header fields. Its purpose is to parse a incoming RMAP Command, collecting 
--! the header data and handling errors.
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! rmap_target_pkg
--! rmap_target_crc_pkg
--!
--! <b>References:</b>\n
--! SpaceWire - Remote memory access protocol, ECSS-E-ST-50-52C, 2010.02.05 \n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 06\02\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for RMAP Target Command Parsing
--============================================================================

entity rmap_target_command_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local rmap clock
		rst_i         : in  std_logic;  --! Reset = '0': no reset; Reset = '1': reset active
		--
		control_i     : in  t_rmap_target_command_control;
		spw_flag_i    : in  t_rmap_target_spw_rx_flag;
		-- global output signals

		flags_o       : out t_rmap_target_command_flags;
		error_o       : out t_rmap_target_command_error;
		headerdata_o  : out t_rmap_target_command_headerdata;
		spw_control_o : out t_rmap_target_spw_rx_control
		-- data bus(es)
	);
end entity rmap_target_command_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_command_ent is

	-- SYMBOLIC ENCODED state machine: s_RMAP_TARGET_COMMAND_STATE
	-- ===========================================================
	type t_rmap_target_command_state is (
		IDLE,
		WAITING_BUFFER_DATA,
		FIELD_TARGET_LOGICAL_ADDRESS,
		FIELD_PROTOCOL_IDENTIFIER,
		FIELD_INSTRUCTION,
		FIELD_KEY,
		FIELD_REPLY_ADDRESS,
		FIELD_INITIATOR_LOGICAL_ADDRESS,
		FIELD_TRANSACTION_IDENTIFIER,
		FIELD_EXTENDED_ADDRESS,
		FIELD_ADDRESS,
		FIELD_DATA_LENGTH,
		FIELD_HEADER_CRC,
		FIELD_EOP,
		ERROR_CHECK,
		UNEXPECTED_PACKAGE_END,
		WAITING_PACKAGE_END,
		NOT_RMAP_PACKAGE,
		DISCARD_PACKAGE,
		COMMAND_FINISH_OPERATION
	);
	signal s_rmap_target_command_state : t_rmap_target_command_state; -- current state

	signal s_rmap_target_command_next_state : t_rmap_target_command_state;

	signal s_command_header_crc : std_logic_vector(7 downto 0);
	--	signal s_command_header_crc_ok : std_logic;

	signal s_write_command        : std_logic;
	signal s_unused_packet_type   : std_logic;
	signal s_invalid_command_code : std_logic;

	signal s_discarted_package : std_logic;
	signal s_not_rmap_package  : std_logic;

	signal s_byte_counter : natural range 0 to 11;

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, rst_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of RMAP Target Command Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_command_state
	p_rmap_target_command_FSM_state : process(clk_i, rst_i)
		variable v_rmap_target_command_state : t_rmap_target_command_state := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_rmap_target_command_state                                <= IDLE;
			s_rmap_target_command_next_state                           <= IDLE;
			s_byte_counter                                             <= 0;
			s_write_command                                            <= '0';
			s_unused_packet_type                                       <= '0';
			s_invalid_command_code                                     <= '0';
			s_command_header_crc                                       <= x"00";
			--			s_command_header_crc_ok                                    <= '0';
			-- Outputs Generation
			flags_o.command_received                                   <= '0';
			flags_o.write_request                                      <= '0';
			flags_o.read_request                                       <= '0';
			flags_o.discarded_package                                  <= '0';
			flags_o.command_busy                                       <= '0';
			error_o.early_eop                                          <= '0';
			error_o.eep                                                <= '0';
			error_o.header_crc                                         <= '0';
			error_o.unused_packet_type                                 <= '0';
			error_o.invalid_command_code                               <= '0';
			error_o.too_much_data                                      <= '0';
			headerdata_o.target_logical_address                        <= x"00";
			headerdata_o.instructions.packet_type                      <= "00";
			headerdata_o.instructions.command.write_read               <= '0';
			headerdata_o.instructions.command.verify_data_before_write <= '0';
			headerdata_o.instructions.command.reply                    <= '0';
			headerdata_o.instructions.command.increment_address        <= '0';
			headerdata_o.instructions.reply_address_length             <= "00";
			headerdata_o.key                                           <= x"00";
			headerdata_o.reply_address                                 <= (others => x"00");
			headerdata_o.initiator_logical_address                     <= x"00";
			headerdata_o.transaction_identifier                        <= (others => x"00");
			headerdata_o.extended_address                              <= x"00";
			headerdata_o.address                                       <= (others => x"00");
			headerdata_o.data_length                                   <= (others => x"00");
			spw_control_o.read                                         <= '0';
			s_discarted_package                                        <= '0';
			s_not_rmap_package                                         <= '0';

			v_rmap_target_command_state := IDLE;

		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_command_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals it is ready to receive a command
					-- default state transition
					s_rmap_target_command_state      <= IDLE;
					v_rmap_target_command_state      := IDLE;
					s_rmap_target_command_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_write_command                  <= '0';
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= x"00";
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if user application is ready to receive a command
					if (control_i.user_ready = '1') then
						-- user application is ready to receive a command
						-- go to waiting buffer data
						s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
						v_rmap_target_command_state      := WAITING_BUFFER_DATA;
						-- prepare for next field (target logical address)
						s_rmap_target_command_next_state <= FIELD_TARGET_LOGICAL_ADDRESS;
					end if;

				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
					-- wait until the spacewire rx buffer has data
					-- default state transition
					s_rmap_target_command_state <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state := WAITING_BUFFER_DATA;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if rx buffer have valid data
					if (spw_flag_i.valid = '1') then
						-- rx buffer have valid data
						-- check if the the rx data is an end of package and not an expected eop
						if ((spw_flag_i.flag = '1') and not (((spw_flag_i.data = c_EOP_VALUE) and (s_rmap_target_command_next_state = FIELD_EOP)) or (s_rmap_target_command_next_state = WAITING_PACKAGE_END))) then
							-- rx data is an unexpected package end
							-- go to unexpected end of package					
							s_rmap_target_command_state <= UNEXPECTED_PACKAGE_END;
							v_rmap_target_command_state := UNEXPECTED_PACKAGE_END;
						else
							-- rx data is not an end of package
							-- go to next field
							s_rmap_target_command_state <= s_rmap_target_command_next_state;
							v_rmap_target_command_state := s_rmap_target_command_next_state;
						end if;
					end if;

				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
					-- target logical address field, receive command target logical address from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_PROTOCOL_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_write_command                  <= '0';
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
				--					s_command_header_crc_ok          <= '0';
				-- conditional state transition and internal signal values

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, receive command protocol identifier from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_INSTRUCTION;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_write_command                  <= '0';
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values]
					-- check if the arriving package is not a rmap package
					if not (spw_flag_i.data = c_RMAP_PROTOCOL) then
						-- not rmap package
						-- go to not rmap package
						s_rmap_target_command_state      <= NOT_RMAP_PACKAGE;
						v_rmap_target_command_state      := NOT_RMAP_PACKAGE;
						s_rmap_target_command_next_state <= IDLE;
					end if;

				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
					-- instruction field, receive command instruction from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_KEY;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if the command is for a write or a read operation
					-- check if an unused packet type error occurred
					if (spw_flag_i.data(7) = '1') then
						s_unused_packet_type <= '1';
					end if;
					-- check if an invalid command code error occurred
					if ((spw_flag_i.data(5 downto 2) = "0000") or (spw_flag_i.data(5 downto 2) = "0001") or (spw_flag_i.data(5 downto 2) = "0100") or (spw_flag_i.data(5 downto 2) = "0101") or (spw_flag_i.data(5 downto 2) = "0110")) then
						s_invalid_command_code <= '1';
					end if;
					if (spw_flag_i.data(5) = '1') then
						-- write command
						s_write_command <= '1';
					else
						-- read command
						s_write_command <= '0';
					end if;
					-- prepare byte field counter for multi-byte command field
					case (spw_flag_i.data(1 downto 0)) is
						-- reply address field not used
						when "00" =>
							s_byte_counter <= 0;
						-- reply address field has 4 bytes
						when "01" =>
							s_byte_counter <= 3;
						-- reply address field has 8 bytes
						when "10" =>
							s_byte_counter <= 7;
						-- reply address field has 12 bytes
						when "11" =>
							s_byte_counter <= 11;
						-- non-specified value
						when others =>
							s_byte_counter <= 0;
					end case;

				-- state "FIELD_KEY"
				when FIELD_KEY =>
					-- key field, receive command key from the initiator
					-- default state transition
					s_rmap_target_command_state <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state := WAITING_BUFFER_DATA;
					-- default internal signal values
					s_command_header_crc        <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok     <= '0';
					-- conditional state transition and internal signal values
					-- check if reply address is used
					if (s_byte_counter = 0) then
						-- reply address not used
						s_rmap_target_command_next_state <= FIELD_INITIATOR_LOGICAL_ADDRESS;
					else
						-- reply address used
						s_rmap_target_command_next_state <= FIELD_REPLY_ADDRESS;
					end if;

				-- state "FIELD_REPLY_ADDRESS"
				when FIELD_REPLY_ADDRESS =>
					-- reply address field, receive command reply address from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_REPLY_ADDRESS;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if multi-byte field has ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (initiator logical address)
						s_rmap_target_command_next_state <= FIELD_INITIATOR_LOGICAL_ADDRESS;
					else
						-- multi-byte field not ended
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
				when FIELD_INITIATOR_LOGICAL_ADDRESS =>
					-- initiator logical address field, receive command initiator logical address from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_TRANSACTION_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                   <= 1;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
				--					s_command_header_crc_ok          <= '0';
				-- conditional state transition and internal signal values

				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
					-- transaction identifier field, receive command transaction identifier from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_TRANSACTION_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if multi-byte field has ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (extended address)
						s_rmap_target_command_next_state <= FIELD_EXTENDED_ADDRESS;
					else
						-- multi-byte field not ended
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_EXTENDED_ADDRESS"
				when FIELD_EXTENDED_ADDRESS =>
					-- extended address field, receive command extended address from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_ADDRESS;
					-- default internal signal values
					s_byte_counter                   <= 3;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
				--					s_command_header_crc_ok          <= '0';
				-- conditional state transition and internal signal values

				-- state "FIELD_ADDRESS"
				when FIELD_ADDRESS =>
					-- address field, receive command address from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_ADDRESS;
					-- default internal signal values
					s_byte_counter                   <= 2;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if multi-byte field has ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (data length)
						s_rmap_target_command_next_state <= FIELD_DATA_LENGTH;
					else
						-- multi-byte field not ended
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_DATA_LENGTH"
				when FIELD_DATA_LENGTH =>
					-- data length field, receive command data length from the initiator
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= FIELD_DATA_LENGTH;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= RMAP_CalculateCRC(s_command_header_crc, spw_flag_i.data);
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if multi-byte field has ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (header crc)
						s_rmap_target_command_next_state <= FIELD_HEADER_CRC;
					else
						-- multi-byte field not ended
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_HEADER_CRC"
				when FIELD_HEADER_CRC =>
					-- data crc field, receive command header crc from the initiator
					-- default state transition
					s_rmap_target_command_state      <= ERROR_CHECK;
					v_rmap_target_command_state      := ERROR_CHECK;
					s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= x"00";
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					if (s_command_header_crc = spw_flag_i.data) then
						-- calculated crc matches received crc
						--						s_command_header_crc_ok <= '1';
						-- check if the command is for an read or write
						if (s_write_command = '1') then
							-- write command, next expected field is a data field; go to header error checking
							s_rmap_target_command_state      <= ERROR_CHECK;
							v_rmap_target_command_state      := ERROR_CHECK;
							s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
						else
							-- read command, next expected field is an eop
							s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
							v_rmap_target_command_state      := WAITING_BUFFER_DATA;
							s_rmap_target_command_next_state <= FIELD_EOP;
						end if;
					else
						-- crc does not match, go to discard package
						s_rmap_target_command_state      <= DISCARD_PACKAGE;
						v_rmap_target_command_state      := DISCARD_PACKAGE;
						s_rmap_target_command_next_state <= WAITING_PACKAGE_END;
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, receive eop indicating the end of package
					-- default state transition
					s_rmap_target_command_state      <= ERROR_CHECK;
					v_rmap_target_command_state      := ERROR_CHECK;
					s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= x"00";
					-- conditional state transition and internal signal values
					-- check if more data arrived, instead of an end of package (an eep would have been detected in WAITING_BUFFER_DATA)
					if not (spw_flag_i.flag = '1') then
						-- data arrived, not an end of package
						-- too much data error, go to discard package 
						s_rmap_target_command_state      <= DISCARD_PACKAGE;
						v_rmap_target_command_state      := DISCARD_PACKAGE;
						s_rmap_target_command_next_state <= WAITING_PACKAGE_END;
					end if;

				-- state "ERROR_CHECK"
				when ERROR_CHECK =>
					-- verify if the received command has an error
					s_rmap_target_command_state      <= COMMAND_FINISH_OPERATION;
					v_rmap_target_command_state      := COMMAND_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
					-- default state transition
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_command_header_crc             <= x"00";
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if an unused packet type error or if an invalid command code error occurred
					if ((s_unused_packet_type = '1') or (s_invalid_command_code = '1')) then
						-- error ocurred, go to discard package
						s_rmap_target_command_state      <= DISCARD_PACKAGE;
						v_rmap_target_command_state      := DISCARD_PACKAGE;
						s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
					end if;

				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
					-- unexpected package end arrived
					-- default state transition
					s_rmap_target_command_state      <= DISCARD_PACKAGE;
					v_rmap_target_command_state      := DISCARD_PACKAGE;
					s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= x"00";
				--					s_command_header_crc_ok          <= '0';
				-- conditional state transition and internal signal values

				-- state "WAITING_PACKAGE_END"
				when WAITING_PACKAGE_END =>
					-- wait until a package end arrives
					-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_command_state      := WAITING_BUFFER_DATA;
					s_rmap_target_command_next_state <= WAITING_PACKAGE_END;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= x"00";
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					-- check if an end of package arrived
					if (spw_flag_i.flag = '1') then
						-- package ended
						-- go to write finish operation
						s_rmap_target_command_state      <= COMMAND_FINISH_OPERATION;
						v_rmap_target_command_state      := COMMAND_FINISH_OPERATION;
						s_rmap_target_command_next_state <= IDLE;
					end if;

				-- state "NOT_RMAP_PACKAGE"
				when NOT_RMAP_PACKAGE =>
					-- incoming spw data is not a rmap package
					-- default state transition
					s_rmap_target_command_state      <= WAITING_PACKAGE_END;
					v_rmap_target_command_state      := WAITING_PACKAGE_END;
					s_rmap_target_command_next_state <= COMMAND_FINISH_OPERATION;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= x"00";
				--					s_command_header_crc_ok          <= '0';
				-- conditional state transition and internal signal values

				-- state "DISCARD_PACKAGE"
				when DISCARD_PACKAGE =>
					-- discard current spw package data
					-- default state transition
					s_rmap_target_command_state <= s_rmap_target_command_next_state;
					v_rmap_target_command_state := s_rmap_target_command_next_state;
					-- default internal signal values
					s_byte_counter              <= 0;
					s_unused_packet_type        <= '0';
					s_invalid_command_code      <= '0';
					s_command_header_crc        <= x"00";
				--					s_command_header_crc_ok     <= '0';
				-- conditional state transition and internal signal values

				-- state "COMMAND_FINISH_OPERATION"
				when COMMAND_FINISH_OPERATION =>
					-- finish command operation
					-- default state transition
					s_rmap_target_command_state      <= COMMAND_FINISH_OPERATION;
					v_rmap_target_command_state      := COMMAND_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                   <= 0;
					s_unused_packet_type             <= '0';
					s_invalid_command_code           <= '0';
					s_command_header_crc             <= x"00";
					--					s_command_header_crc_ok          <= '0';
					-- conditional state transition and internal signal values
					if (control_i.command_reset = '1') then
						-- command reset commanded, go back to idle
						s_rmap_target_command_state      <= IDLE;
						v_rmap_target_command_state      := IDLE;
						s_rmap_target_command_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_command_state      <= IDLE;
					v_rmap_target_command_state      := IDLE;
					s_rmap_target_command_next_state <= IDLE;

			end case;
			--=============================================================================
			-- Begin of RMAP Target Command Finite State Machine
			-- (output generation)
			--=============================================================================
			-- read: s_rmap_target_command_state, rst_i
			-- write:
			-- r/w:
			case (v_rmap_target_command_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals it is ready to receive a command
					-- default output signals
					flags_o.command_received                                   <= '0';
					flags_o.write_request                                      <= '0';
					flags_o.read_request                                       <= '0';
					flags_o.discarded_package                                  <= '0';
					flags_o.command_busy                                       <= '0';
					error_o.early_eop                                          <= '0';
					error_o.eep                                                <= '0';
					error_o.header_crc                                         <= '0';
					error_o.unused_packet_type                                 <= '0';
					error_o.invalid_command_code                               <= '0';
					error_o.too_much_data                                      <= '0';
					headerdata_o.target_logical_address                        <= x"00";
					headerdata_o.instructions.packet_type                      <= "00";
					headerdata_o.instructions.command.write_read               <= '0';
					headerdata_o.instructions.command.verify_data_before_write <= '0';
					headerdata_o.instructions.command.reply                    <= '0';
					headerdata_o.instructions.command.increment_address        <= '0';
					headerdata_o.instructions.reply_address_length             <= "00";
					headerdata_o.key                                           <= x"00";
					headerdata_o.reply_address                                 <= (others => x"00");
					headerdata_o.initiator_logical_address                     <= x"00";
					headerdata_o.transaction_identifier                        <= (others => x"00");
					headerdata_o.extended_address                              <= x"00";
					headerdata_o.address                                       <= (others => x"00");
					headerdata_o.data_length                                   <= (others => x"00");
					spw_control_o.read                                         <= '0';
					s_discarted_package                                        <= '0';
					s_not_rmap_package                                         <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
					-- wait until the spacewire rx buffer has data
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '0';
				-- conditional output signals

				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
					-- target logical address field, receive command target logical address from the initiator
					-- default output signals
					flags_o.command_busy                <= '1';
					flags_o.command_received            <= '0';
					flags_o.write_request               <= '0';
					flags_o.read_request                <= '0';
					flags_o.discarded_package           <= '0';
					spw_control_o.read                  <= '1';
					headerdata_o.target_logical_address <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, receive command protocol identifier from the initiator
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '1';
				-- conditional output signals

				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
					-- instruction field, receive command instruction from the initiator
					-- default output signals
					flags_o.command_busy                                       <= '1';
					flags_o.command_received                                   <= '0';
					flags_o.write_request                                      <= '0';
					flags_o.read_request                                       <= '0';
					flags_o.discarded_package                                  <= '0';
					spw_control_o.read                                         <= '1';
					headerdata_o.instructions.packet_type                      <= spw_flag_i.data(7 downto 6);
					headerdata_o.instructions.command.write_read               <= spw_flag_i.data(5);
					headerdata_o.instructions.command.verify_data_before_write <= spw_flag_i.data(4);
					headerdata_o.instructions.command.reply                    <= spw_flag_i.data(3);
					headerdata_o.instructions.command.increment_address        <= spw_flag_i.data(2);
					headerdata_o.instructions.reply_address_length             <= spw_flag_i.data(1 downto 0);
				-- conditional output signals

				-- state "FIELD_KEY"
				when FIELD_KEY =>
					-- key field, receive command key from the initiator
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '1';
					headerdata_o.key          <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_REPLY_ADDRESS"
				when FIELD_REPLY_ADDRESS =>
					-- reply address field, receive command reply address from the initiator
					-- default output signals
					flags_o.command_busy                       <= '1';
					flags_o.command_received                   <= '0';
					flags_o.write_request                      <= '0';
					flags_o.read_request                       <= '0';
					flags_o.discarded_package                  <= '0';
					spw_control_o.read                         <= '1';
					headerdata_o.reply_address(s_byte_counter) <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
				when FIELD_INITIATOR_LOGICAL_ADDRESS =>
					-- initiator logical address field, receive command initiator logical address from the initiator
					-- default output signals
					flags_o.command_busy                   <= '1';
					flags_o.command_received               <= '0';
					flags_o.write_request                  <= '0';
					flags_o.read_request                   <= '0';
					flags_o.discarded_package              <= '0';
					spw_control_o.read                     <= '1';
					headerdata_o.initiator_logical_address <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
					-- transaction identifier field, receive command transaction identifier from the initiator
					-- default output signals
					flags_o.command_busy                                <= '1';
					flags_o.command_received                            <= '0';
					flags_o.write_request                               <= '0';
					flags_o.read_request                                <= '0';
					flags_o.discarded_package                           <= '0';
					spw_control_o.read                                  <= '1';
					headerdata_o.transaction_identifier(s_byte_counter) <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_EXTENDED_ADDRESS"
				when FIELD_EXTENDED_ADDRESS =>
					-- extended address field, receive command extended address from the initiator
					-- default output signals
					flags_o.command_busy          <= '1';
					flags_o.command_received      <= '0';
					flags_o.write_request         <= '0';
					flags_o.read_request          <= '0';
					flags_o.discarded_package     <= '0';
					spw_control_o.read            <= '1';
					headerdata_o.extended_address <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_ADDRESS"
				when FIELD_ADDRESS =>
					-- address field, receive command address from the initiator
					-- default output signals
					flags_o.command_busy                 <= '1';
					flags_o.command_received             <= '0';
					flags_o.write_request                <= '0';
					flags_o.read_request                 <= '0';
					flags_o.discarded_package            <= '0';
					spw_control_o.read                   <= '1';
					headerdata_o.address(s_byte_counter) <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_DATA_LENGTH"
				when FIELD_DATA_LENGTH =>
					-- data length field, receive command data length from the initiator
					-- default output signals
					flags_o.command_busy                     <= '1';
					flags_o.command_received                 <= '0';
					flags_o.write_request                    <= '0';
					flags_o.read_request                     <= '0';
					flags_o.discarded_package                <= '0';
					spw_control_o.read                       <= '1';
					headerdata_o.data_length(s_byte_counter) <= spw_flag_i.data;
				-- conditional output signals

				-- state "FIELD_HEADER_CRC"
				when FIELD_HEADER_CRC =>
					-- data crc field, receive command header crc from the initiator
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '1';
					-- conditional output signals
					if not (s_command_header_crc = spw_flag_i.data) then
						-- flag the error
						error_o.header_crc <= '1';
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, receive eop indicating the end of package
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '1';
					error_o.too_much_data     <= '0';
					-- conditional output signals
					-- check if data arrived insteady of an end of package
					if (spw_flag_i.flag = '0') then
						-- data arrived, not an end of package
						-- too much data error
						error_o.too_much_data <= '1';
					end if;

				-- state "ERROR_CHECK"
				when ERROR_CHECK =>
					-- verify if the received command has an error
					-- default output signals
					flags_o.command_busy         <= '1';
					flags_o.command_received     <= '0';
					flags_o.write_request        <= '0';
					flags_o.read_request         <= '0';
					flags_o.discarded_package    <= '0';
					spw_control_o.read           <= '0';
					error_o.unused_packet_type   <= '0';
					error_o.invalid_command_code <= '0';
					-- conditional output signals
					-- check if an unused packet type error occurred
					if (s_unused_packet_type = '1') then
						error_o.unused_packet_type <= '1';
					end if;
					-- check if an invalid command code error occurred
					if (s_invalid_command_code = '1') then
						error_o.invalid_command_code <= '1';
					end if;

				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
					-- unexpected package end arrived
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '1';
					error_o.early_eop         <= '0';
					error_o.eep               <= '0';
					-- conditional output signals
					-- check if the unexpected package end is an early eop or and eep
					if (spw_flag_i.data = c_EOP_VALUE) then
						-- early eop error
						error_o.early_eop <= '1';
					else
						-- eep error
						error_o.eep <= '1';
					end if;

				-- state "WAITING_PACKAGE_END"
				when WAITING_PACKAGE_END =>
					-- wait until a package end arrives
					-- default output signals
					flags_o.command_busy      <= '1';
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					spw_control_o.read        <= '0';
					-- conditional output signals
					if (spw_flag_i.valid = '1') then
						spw_control_o.read <= '1';
					end if;

				-- state "NOT_RMAP_PACKAGE"
				when NOT_RMAP_PACKAGE =>
					-- incoming spw data is not a rmap package
					-- default output signals
					flags_o.command_received                                   <= '0';
					flags_o.write_request                                      <= '0';
					flags_o.read_request                                       <= '0';
					flags_o.discarded_package                                  <= '0';
					flags_o.command_busy                                       <= '1';
					error_o.early_eop                                          <= '0';
					error_o.eep                                                <= '0';
					error_o.header_crc                                         <= '0';
					error_o.unused_packet_type                                 <= '0';
					error_o.invalid_command_code                               <= '0';
					error_o.too_much_data                                      <= '0';
					headerdata_o.target_logical_address                        <= x"00";
					headerdata_o.instructions.packet_type                      <= "00";
					headerdata_o.instructions.command.write_read               <= '0';
					headerdata_o.instructions.command.verify_data_before_write <= '0';
					headerdata_o.instructions.command.reply                    <= '0';
					headerdata_o.instructions.command.increment_address        <= '0';
					headerdata_o.instructions.reply_address_length             <= "00";
					headerdata_o.key                                           <= x"00";
					headerdata_o.reply_address                                 <= (others => x"00");
					headerdata_o.initiator_logical_address                     <= x"00";
					headerdata_o.transaction_identifier                        <= (others => x"00");
					headerdata_o.extended_address                              <= x"00";
					headerdata_o.address                                       <= (others => x"00");
					headerdata_o.data_length                                   <= (others => x"00");
					spw_control_o.read                                         <= '0';
					s_not_rmap_package                                         <= '1';
				-- conditional output signals

				-- state "DISCARD_PACKAGE"
				when DISCARD_PACKAGE =>
					-- discard current spw package data
					-- default output signals
					flags_o.command_received  <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					flags_o.discarded_package <= '0';
					flags_o.command_busy      <= '1';
					spw_control_o.read        <= '0';
					s_discarted_package       <= '1';
				-- conditional output signals

				-- state "COMMAND_FINISH_OPERATION"
				when COMMAND_FINISH_OPERATION =>
					-- finish command operation
					-- default output signals
					flags_o.command_received  <= '1';
					flags_o.command_busy      <= '1';
					spw_control_o.read        <= '0';
					flags_o.discarded_package <= '0';
					flags_o.write_request     <= '0';
					flags_o.read_request      <= '0';
					-- conditional output signals
					-- check if the spw data was a rmap package
					if not (s_not_rmap_package = '1') then
						-- rmap package
						-- check if the package was discarded
						if (s_discarted_package = '1') then
							-- discarded package, set the flag
							flags_o.discarded_package <= '1';
						else
							-- package not discarded
							-- check if the request is for a write or read
							if (s_write_command = '1') then
								-- write request, set the flag
								flags_o.write_request <= '1';
							else
								-- read request, set the flag
								flags_o.read_request <= '1';
							end if;
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_command_FSM_state;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
