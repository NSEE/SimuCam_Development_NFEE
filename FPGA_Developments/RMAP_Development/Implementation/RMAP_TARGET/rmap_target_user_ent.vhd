--=============================================================================
--! @file rmap_target_user_ent.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
use work.RMAP_TARGET_PKG.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: RMAP Target User Application (rmap_target_user_ent)
--

--! @brief Entity for the RMAP User Application operations. It is responsible 
--! for interfacing with the final user, User Application operations (such as 
--! Target ID and Key checking, Write and Read authorization, error gathering 
--! and other) and flow control for the RMAP Codec.
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
--! Entity declaration for RMAP Target User Application
--============================================================================

entity rmap_target_user_ent is
	generic(
		g_VERIFY_BUFFER_WIDTH  : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 8;
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 30;
		g_DATA_LENGTH_WIDTH    : natural range 0 to c_WIDTH_DATA_LENGTH      := 24
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i        : in  std_logic;   --! Local rmap clock
		reset_n_i    : in  std_logic;   --! Reset = '0': reset active; Reset = '1': no reset

		flags_i      : in  t_rmap_target_flags;
		error_i      : in  t_rmap_target_rmap_error;
		codecdata_i  : in  t_rmap_target_user_codecdata;
		configs_i    : in  t_rmap_target_user_configs;
		-- global output signals

		control_o    : out t_rmap_target_control;
		reply_status : out std_logic_vector(7 downto 0)
		-- data bus(es)
	);
end entity rmap_target_user_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_user_ent is

	-- SYMBOLIC ENCODED state machine: s_RMAP_TARGET_USER_STATE
	-- =========================================================
	type t_rmap_target_user_state is (
		IDLE,
		COMMAND_RECEIVED,
		DISCARDED_PACKAGE,
		WRITE_AUTHORIZATION,
		WAITING_WRITE_FINISH,
		WAITING_WRITE_DISCARD,
		WRITE_OPERATION_FINISH,
		READ_AUTHORIZATION,
		WAITING_READ_FINISH,
		READ_OPERATION_FINISH,
		SEND_REPLY,
		WAITING_REPLY_FINISH,
		FINISH_USER_OPERATION
	);
	signal s_rmap_target_user_state : t_rmap_target_user_state; -- current state

	signal s_error_general_error                                  : std_logic;
	signal s_error_invalid_key                                    : std_logic;
	signal s_error_verify_buffer_overrun                          : std_logic;
	signal s_error_rmap_command_not_implemented_or_not_authorised : std_logic;
	signal s_error_invalid_target_logical_address                 : std_logic;

	signal s_data_length_vector : std_logic_vector(23 downto 0);

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, reset_n_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of RMAP Target User Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_user_state
	p_rmap_target_user_FSM_state : process(clk_i, reset_n_i)
		variable v_authorization_granted : std_logic_vector(3 downto 0);
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_rmap_target_user_state                               <= IDLE;
			s_error_general_error                                  <= '0';
			s_error_invalid_key                                    <= '0';
			s_error_verify_buffer_overrun                          <= '0';
			s_error_rmap_command_not_implemented_or_not_authorised <= '0';
			s_error_invalid_target_logical_address                 <= '0';
			v_authorization_granted                                := (others => '0');
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_user_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a command package is received
					-- default state transition
					s_rmap_target_user_state                               <= IDLE;
					-- default internal signal values
					s_error_general_error                                  <= '0';
					s_error_invalid_key                                    <= '0';
					s_error_verify_buffer_overrun                          <= '0';
					s_error_rmap_command_not_implemented_or_not_authorised <= '0';
					s_error_invalid_target_logical_address                 <= '0';
					v_authorization_granted                                := (others => '0');
					-- conditional state transition and internal signal values
					-- check if the command parser finished parsing a command
					if (flags_i.command_parsing.command_received = '1') then
						-- command parsing finished, go to command received
						s_rmap_target_user_state <= COMMAND_RECEIVED;
					end if;

				-- state "COMMAND_RECEIVED"
				when COMMAND_RECEIVED =>
					-- treat the incoming command data
					-- default state transition
					s_rmap_target_user_state <= COMMAND_RECEIVED;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the incoming package was discarded
					if (flags_i.command_parsing.discarded_package = '1') then
						-- package discarded, go to discarded package
						s_rmap_target_user_state <= DISCARDED_PACKAGE;
					-- check if the incoming command is for a write operation
					elsif (flags_i.command_parsing.write_request = '1') then
						-- write command, go to write authorization
						s_rmap_target_user_state <= WRITE_AUTHORIZATION;
					-- check if the incoming command is for a read operation
					elsif (flags_i.command_parsing.read_request = '1') then
						-- read command, go to read authorization
						s_rmap_target_user_state <= READ_AUTHORIZATION;
					else
						-- received package was not a rmap protocol, go to finish user operation
						s_rmap_target_user_state <= FINISH_USER_OPERATION;
					end if;

				-- state "DISCARDED_PACKAGE"
				when DISCARDED_PACKAGE =>
					-- incoming package discarded, treat errors
					-- default state transition
					s_rmap_target_user_state <= FINISH_USER_OPERATION;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a reply is necessary
					if (codecdata_i.instructions.command.reply = '1') then
						-- reply requested
						-- check if an repliable error ocurred
						if (            -- (error_i.unused_packet_type = '1') or 
							(error_i.invalid_command_code = '1') or (error_i.too_much_data = '1')) then
							-- repliable error occured, send error reply
							s_rmap_target_user_state <= SEND_REPLY;
						end if;
					end if;

				-- state "WRITE_AUTHORIZATION"
				when WRITE_AUTHORIZATION =>
					-- write operation authorization
					-- default state transition
					s_rmap_target_user_state                               <= WAITING_WRITE_DISCARD;
					-- default internal signal values
					s_error_general_error                                  <= '0';
					s_error_invalid_key                                    <= '0';
					s_error_invalid_target_logical_address                 <= '0';
					s_error_rmap_command_not_implemented_or_not_authorised <= '0';
					s_error_verify_buffer_overrun                          <= '0';
					v_authorization_granted                                := (others => '0');
					v_authorization_granted(3)                             := '1';
					-- conditional state transition and internal signal values
					-- verify write command authorization
					-- check user key
					if (codecdata_i.key = configs_i.user_key) then
						-- user key matches
						v_authorization_granted(0) := '1';
					else
						-- not authorized
						s_error_invalid_key <= '1';
					end if;
					-- check user target logical address
					if (codecdata_i.target_logical_address = configs_i.user_target_logical_address) then
						-- user target logical address matches
						v_authorization_granted(1) := '1';
					else
						-- not authorized
						s_error_invalid_target_logical_address <= '1';
					end if;
					-- check if the write command data length is compatible
					-- check if data need to be verified before being written
					if (codecdata_i.instructions.command.verify_data_before_write = '1') then
						-- data need to be verified
						-- check if the verify buffer can accept the data
						if (((2 ** g_VERIFY_BUFFER_WIDTH) - 1) >= unsigned(s_data_length_vector)) then
							-- can accept the data
							v_authorization_granted(2) := '1';
						else
							-- not authorized
							s_error_verify_buffer_overrun <= '1';
						end if;
					else
						-- data does not need to be verified
						-- check if the memory can accept the data						
						if (((2 ** g_DATA_LENGTH_WIDTH) - 1) >= unsigned(s_data_length_vector)) then
							-- can accept the data
							v_authorization_granted(2) := '1';
						else
							-- not authorized
							s_error_rmap_command_not_implemented_or_not_authorised <= '1';
						end if;
					end if;
					-- check if command was authorized
					if ((v_authorization_granted(0) = '1') and (v_authorization_granted(1) = '1') and (v_authorization_granted(2) = '1') and (v_authorization_granted(3) = '1')) then
						-- authorization granted
						s_rmap_target_user_state <= WAITING_WRITE_FINISH;
					end if;

				-- state "WAITING_WRITE_FINISH"
				when WAITING_WRITE_FINISH =>
					-- wait the end of a write operation
					-- default state transition
					s_rmap_target_user_state <= WAITING_WRITE_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a write authorization was granted
					-- check if the write operation finished
					if ((flags_i.write_operation.write_data_indication = '1') or (flags_i.write_operation.write_operation_failed = '1')) then
						-- write operation finished, go to write operation finish
						s_rmap_target_user_state <= WRITE_OPERATION_FINISH;
					end if;

				-- state "WAITING_WRITE_DISCARD"
				when WAITING_WRITE_DISCARD =>
					-- write operation not authorized, wait for the write module to discard the rest of the write package
					-- default state transition
					s_rmap_target_user_state <= WAITING_WRITE_DISCARD;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the write module finished discarding the rest of the package				
					if (flags_i.write_operation.write_data_discarded = '1') then
						-- rest of the package discarded, go to write operation finish
						s_rmap_target_user_state <= WRITE_OPERATION_FINISH;
					end if;

				-- state "WRITE_OPERATION_FINISH"
				when WRITE_OPERATION_FINISH =>
					-- write operation finished, error checking and reply generation
					-- default state transition
					s_rmap_target_user_state <= FINISH_USER_OPERATION;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a write reply was requested
					if (codecdata_i.instructions.command.reply = '1') then
						-- write reply requested, go to send reply
						s_rmap_target_user_state <= SEND_REPLY;
					end if;

				-- state "READ_AUTHORIZATION"
				when READ_AUTHORIZATION =>
					-- read operation authorization
					-- default state transition
					s_rmap_target_user_state                               <= FINISH_USER_OPERATION;
					-- default internal signal values
					s_error_general_error                                  <= '0';
					s_error_invalid_key                                    <= '0';
					s_error_invalid_target_logical_address                 <= '0';
					s_error_rmap_command_not_implemented_or_not_authorised <= '0';
					s_error_verify_buffer_overrun                          <= '0';
					v_authorization_granted                                := (others => '0');
					-- conditional state transition and internal signal values
					-- verify read command authorization
					-- check user key
					if (codecdata_i.key = configs_i.user_key) then
						-- user key matches
						v_authorization_granted(0) := '1';
					else
						-- not authorized
						s_error_invalid_key <= '1';
					end if;
					-- check user target logical address
					if (codecdata_i.target_logical_address = configs_i.user_target_logical_address) then
						-- user target logical address matches
						v_authorization_granted(1) := '1';
					else
						-- not authorized
						s_error_invalid_target_logical_address <= '1';
					end if;
					-- check if an not implementend command arrived
					if ((codecdata_i.instructions.command.write_read = '0') and (codecdata_i.instructions.command.verify_data_before_write = '1') and (codecdata_i.instructions.command.reply = '1') and (codecdata_i.instructions.command.increment_address = '1')) then
						-- RWM command received
						-- not authorized 
						s_error_rmap_command_not_implemented_or_not_authorised <= '1';
					else
						-- valid command received
						v_authorization_granted(2) := '1';
					end if;
					-- check if the read command data length is compatible
					if (((2 ** g_DATA_LENGTH_WIDTH) - 1) >= unsigned(s_data_length_vector)) then
						-- can accept the data
						v_authorization_granted(3) := '1';
					else
						-- not authorized
						s_error_rmap_command_not_implemented_or_not_authorised <= '1';
					end if;
					-- check if command was authorized
					if ((v_authorization_granted(0) = '1') and (v_authorization_granted(1) = '1') and (v_authorization_granted(2) = '1') and (v_authorization_granted(3) = '1')) then
						-- authorization granted
						s_rmap_target_user_state <= SEND_REPLY;
					else
						-- authorization not granted
						-- check if a reply is needed
						if (codecdata_i.instructions.command.reply = '1') then
							-- reply needed
							s_rmap_target_user_state <= SEND_REPLY;
						end if;
					end if;

				-- state "WAITING_READ_FINISH"
				when WAITING_READ_FINISH =>
					-- wait the end of a read operation
					-- default state transition
					s_rmap_target_user_state <= WAITING_READ_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a read authorization was granted
					-- check if the read operation finished
					if ((flags_i.read_operation.read_data_indication = '1') or (flags_i.read_operation.read_operation_failed = '1')) then
						-- read operation finished, go to read operation finish
						s_rmap_target_user_state <= READ_OPERATION_FINISH;
					end if;

				-- state "READ_OPERATION_FINISH,"
				when READ_OPERATION_FINISH =>
					-- read operation finished, error checking and reply generation
					-- default state transition
					s_rmap_target_user_state <= FINISH_USER_OPERATION;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "SEND_REPLY"
				when SEND_REPLY =>
					-- send reply to initiator
					-- default state transition
					s_rmap_target_user_state <= WAITING_REPLY_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "WAITING_REPLY_FINISH"
				when WAITING_REPLY_FINISH =>
					-- wait the end of a reply generation
					-- default state transition
					s_rmap_target_user_state <= WAITING_REPLY_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the reply generation finished
					if (flags_i.reply_geneneration.reply_finished = '1') then
						-- reply generation finished
						-- check if it was a read or a write reply
						if (codecdata_i.instructions.command.write_read = '1') then
							-- write reply, go to finish user operation
							s_rmap_target_user_state <= FINISH_USER_OPERATION;
						else
							-- read reply
							-- check if a read was authorized
							if ((v_authorization_granted(0) = '1') and (v_authorization_granted(1) = '1') and (v_authorization_granted(2) = '1') and (v_authorization_granted(3) = '1')) then
								-- authorized, go to waiting read finish
								s_rmap_target_user_state <= WAITING_READ_FINISH;
							else
								-- not authorized, go to finish user operation
								s_rmap_target_user_state <= FINISH_USER_OPERATION;
							end if;
						end if;
					end if;

				-- state "FINISH_USER_OPERATION"
				when FINISH_USER_OPERATION =>
					-- finish the user module operation
					-- default state transition
					s_rmap_target_user_state <= IDLE;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_user_state <= IDLE;

			end case;
		end if;
	end process p_rmap_target_user_FSM_state;

	--=============================================================================
	-- Begin of RMAP Target User Finite State Machine
	-- (output generation)
	--=============================================================================
	-- read: s_rmap_target_user_state, reset_n_i
	-- write:
	-- r/w:
	p_rmap_target_user_FSM_output : process(s_rmap_target_user_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
			control_o.command_parsing.user_ready           <= '0';
			control_o.command_parsing.command_reset        <= '0';
			control_o.reply_geneneration.send_reply        <= '0';
			control_o.reply_geneneration.reply_reset       <= '0';
			control_o.write_operation.write_authorization  <= '0';
			control_o.write_operation.write_not_authorized <= '0';
			control_o.write_operation.write_reset          <= '0';
			control_o.read_operation.read_authorization    <= '0';
			control_o.read_operation.read_reset            <= '0';
			reply_status                                   <= x"00";
		-- output generation when s_rmap_target_user_state changes
		else
			case (s_rmap_target_user_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a command package is received
					-- default output signals
					control_o.command_parsing.user_ready           <= '1';
					control_o.command_parsing.command_reset        <= '0';
					control_o.reply_geneneration.send_reply        <= '0';
					control_o.reply_geneneration.reply_reset       <= '0';
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.write_operation.write_reset          <= '0';
					control_o.read_operation.read_authorization    <= '0';
					control_o.read_operation.read_reset            <= '0';
					reply_status                                   <= x"00";
				-- conditional output signals

				-- state "COMMAND_RECEIVED"
				when COMMAND_RECEIVED =>
					-- treat the incoming command data
					-- default output signals
					control_o.reply_geneneration.send_reply       <= '0';
					control_o.write_operation.write_authorization <= '0';
					control_o.read_operation.read_authorization   <= '0';
				-- conditional output signals

				-- state "DISCARDED_PACKAGE"
				when DISCARDED_PACKAGE =>
					-- incoming package discarded, treat errors
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "WRITE_AUTHORIZATION"
				when WRITE_AUTHORIZATION =>
					-- write operation authorization
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "WAITING_WRITE_FINISH"
				when WAITING_WRITE_FINISH =>
					-- wait the end of a write operation
					-- default output signals
					control_o.write_operation.write_authorization  <= '1';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "WAITING_WRITE_DISCARD"
				when WAITING_WRITE_DISCARD =>
					-- write operation not authorized, wait for the write module to discard the rest of the write package
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '1';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals	

				-- state "WRITE_OPERATION_FINISH,"
				when WRITE_OPERATION_FINISH =>
					-- write operation finished, error checking and reply generation
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "READ_AUTHORIZATION"
				when READ_AUTHORIZATION =>
					-- read operation authorization
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "WAITING_READ_FINISH"
				when WAITING_READ_FINISH =>
					-- wait the end of a read operation
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '1';
				-- conditional output signals

				-- state "READ_OPERATION_FINISH,"
				when READ_OPERATION_FINISH =>
					-- read operation finished, error checking and reply generation
					-- default output signals
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.read_operation.read_authorization    <= '0';
				-- conditional output signals

				-- state "SEND_REPLY"
				when SEND_REPLY =>
					-- send reply to initiator
					-- default output signals
					control_o.reply_geneneration.send_reply <= '0';
					reply_status                            <= std_logic_vector(to_unsigned(c_ERROR_CODE_COMMAND_EXECUTED_SUCCESSFULLY, 8));
					-- conditional output signals
					-- check if an error ocurred
					if (s_error_general_error = '1') then
						-- general error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_GENERAL_ERROR_CODE, 8));
					elsif ((error_i.unused_packet_type = '1') or (error_i.invalid_command_code = '1')) then
						-- unused rmap packet type or command code error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_UNUSED_RMAP_PACKET_TYPE_OR_COMMAND_CODE, 8));
					elsif (s_error_invalid_key = '1') then
						-- invalid key error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_INVALID_KEY, 8));
					elsif (error_i.invalid_data_crc = '1') then
						-- invalid data crc error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_INVALID_DATA_CRC, 8));
					elsif (error_i.early_eop = '1') then
						-- early eop error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_EARLY_EOP, 8));
					elsif (error_i.too_much_data = '1') then
						-- too much data error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_TOO_MUCH_DATA, 8));
					elsif (error_i.eep = '1') then
						-- eep error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_EEP, 8));
					elsif (s_error_verify_buffer_overrun = '1') then
						-- verify buffer overrun error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_VERIFY_BUFFER_OVERRUN, 8));
					elsif (s_error_rmap_command_not_implemented_or_not_authorised = '1') then
						-- rmap command not implemented or not authorised error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_RMAP_COMMAND_NOT_IMPLEMENTED_OR_NOT_AUTHORISED, 8));
					-- the next case is commented out because the RMW function is not implemented
					-- elsif (s_error_rmw_data_length_error = '1') then
					--   reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_RMW_DATA_LENGTH_ERROR,8));
					elsif (s_error_invalid_target_logical_address = '1') then
						-- invalid target logical address error ocurred
						reply_status <= std_logic_vector(to_unsigned(c_ERROR_CODE_INVALID_TARGET_LOGICAL_ADDRESS, 8));
					end if;

				-- state "WAITING_REPLY_FINISH"
				when WAITING_REPLY_FINISH =>
					-- wait the end of a reply generation
					-- default output signals
					control_o.reply_geneneration.send_reply <= '1';
				-- conditional output signals

				-- state "FINISH_USER_OPERATION"
				when FINISH_USER_OPERATION =>
					-- finish the user module operation
					-- default output signals
					control_o.command_parsing.user_ready           <= '0';
					control_o.command_parsing.command_reset        <= '1';
					control_o.reply_geneneration.send_reply        <= '0';
					control_o.reply_geneneration.reply_reset       <= '1';
					control_o.write_operation.write_authorization  <= '0';
					control_o.write_operation.write_not_authorized <= '0';
					control_o.write_operation.write_reset          <= '1';
					control_o.read_operation.read_authorization    <= '0';
					control_o.read_operation.read_reset            <= '1';
					reply_status                                   <= x"00";
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_user_FSM_output;

	s_data_length_vector <= codecdata_i.data_length(2) & codecdata_i.data_length(1) & codecdata_i.data_length(0);

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
