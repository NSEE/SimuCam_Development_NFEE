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
		clk_i     : in std_logic;       --! Local rmap clock
		reset_n_i : in std_logic;        --! Reset = '0': reset active; Reset = '1': no reset

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
		IDLE                                    ,
		WAITING_BUFFER_DATA            ,
		FIELD_TARGET_LOGICAL_ADDRESS   ,
		FIELD_PROTOCOL_IDENTIFIER      ,
		FIELD_INSTRUCTION              ,
		FIELD_KEY                      ,
		FIELD_REPLY_ADDRESS            ,
		FIELD_INITIATOR_LOGICAL_ADDRESS,
		FIELD_TRANSACTION_IDENTIFIER   ,
		FIELD_EXTENDED_ADDRESS         ,
		FIELD_ADDRESS                  ,
		FIELD_DATA_LENGTH              ,
		FIELD_HEADER_CRC               ,
		FIELD_EOP                      ,
		ERROR_CHECK                    ,
		UNEXPECTED_PACKAGE_END         ,
		WAITING_PACKAGE_END            ,
		NOT_RMAP_PACKAGE               ,
		DISCARD_PACKAGE                ,
		COMMAND_FINISH_OPERATION       
	);
	signal s_rmap_target_command_state : t_rmap_target_command_state; -- current state

	signal s_rmap_target_command_next_state : t_rmap_target_command_state;

	signal s_command_data_crc : std_logic_vector(7 downto 0);

	signal s_byte_counter : natural range 0 to 11;

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
	-- Begin of RMAP Target Command Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_command_state
	p_rmap_target_command_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_command_state) is

				-- state "IDLE"
				when IDLE =>
				-- does nothing until user application signals it is ready to receive a command
				-- default state transition
					s_rmap_target_command_state      <= IDLE;
					s_rmap_target_command_next_state <= IDLE;
				-- default internal signal values
				s_byte_counter                <= 0;
				s_write_data_crc <= x"00";
				-- conditional state transition and internal signal values
				-- check if user application is ready to receive a command
				if (control_i.user_ready = '1') then
					-- user application is ready to receive a command
					-- go to waiting buffer data
					s_rmap_target_command_state <= WAITING_BUFFER_DATA;
					-- prepare for next field (target logical address)
					s_rmap_target_command_next_state <= FIELD_TARGET_LOGICAL_ADDRESS;
				end if;
				
				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
				-- wait until the spacewire rx buffer has data
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				-- default internal signal values
				-- conditional state transition and internal signal values
				-- check if rx buffer have valid data
				if (spw_flag_i.valid = '1') then
					-- rx buffer have valid data
					-- check if the the rx data is an end of package and not an expected eop
					if ((spw_flag_i.flag = '1') and not ((spw_flag_i.data = c_EOP_VALUE) and (s_rmap_target_command_next_state = FIELD_EOP))) then
						-- rx data is an unexpected package end
						-- go to unexpected end of package					
						s_rmap_target_command_state <= UNEXPECTED_PACKAGE_END;
					else
						-- rx data is not an end of package
						-- go to next field
						s_rmap_target_command_state <= s_rmap_target_write_next_state;
					end if;
				end if;
				
				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
				-- target logical address field, receive command target logical address from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_PROTOCOL_IDENTIFIER;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values
				
				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
				-- protocol identifier field, receive command protocol identifier from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_INSTRUCTION;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values]
				-- check if the arriving package is not a rmap package
				if not (spw_flag_i.data = c_RMAP_PROTOCOL) then
					-- not rmap package
					-- go to not rmap package
				s_rmap_target_command_state <= NOT_RMAP_PACKAGE;
				s_rmap_target_command_next_state <= IDLE;
				end if;
				
				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
				-- instruction field, receive command instruction from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_KEY;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values
				-- prepare byte field counter for multi-byte command field
				case (spw_flag_i.data(1 downto 0)) is
					when "00" =>
						s_byte_counter                <= 0;
					when "01" =>
						s_byte_counter                <= 4;
					when "10" =>
						s_byte_counter                <= 8;
					when "11" =>
						s_byte_counter                <= 12;
				end case;
				
				-- state "FIELD_KEY"
				when FIELD_KEY =>
				-- key field, receive command key from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				-- default internal signal values
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
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_REPLY_ADDRESS;
				-- default internal signal values
				s_byte_counter                <= 0;
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
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_TRANSACTION_IDENTIFIER;
				-- default internal signal values
				s_byte_counter                <= 1;
				-- conditional state transition and internal signal values
				
				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
				-- transaction identifier field, receive command transaction identifier from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_TRANSACTION_IDENTIFIER;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values
					-- check if multi-byte field has ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (extended address)
						s_rmap_target_read_next_state <= FIELD_EXTENDED_ADDRESS;
					else
						-- multi-byte field not ended
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;
					
				-- state "FIELD_EXTENDED_ADDRESS"
				when FIELD_EXTENDED_ADDRESS =>
				-- extended address field, receive command extended address from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_ADDRESS;
				-- default internal signal values
				s_byte_counter                <= 3;
				-- conditional state transition and internal signal values
				
				-- state "FIELD_ADDRESS"
				when FIELD_ADDRESS =>
				-- address field, receive command address from the initiator
				-- default state transition
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_ADDRESS;
				-- default internal signal values
				s_byte_counter                <= 2;
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
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_DATA_LENGTH;
				-- default internal signal values
				s_byte_counter                <= 0;
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
				s_rmap_target_command_state <= WAITING_BUFFER_DATA;
				s_rmap_target_command_next_state <= FIELD_EOP;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values
				
				-- state "FIELD_EOP"
				when FIELD_EOP =>
				-- eop field, receive eop indicating the end of package
				-- default state transition
				s_rmap_target_write_state      <= COMMAND_FINISH_OPERATION;
				s_rmap_target_write_next_state <= IDLE;
				-- default internal signal values
				s_byte_counter                <= 0;
				-- conditional state transition and internal signal values
				-- check if more data arrived, instead of an end of package arrived
				if not (spw_flag_i.flag = '1') then
					-- data arrived, not an end of package
					-- too much data error, go to waiting package end
					s_rmap_target_command_state      <= WAITING_PACKAGE_END;
					s_rmap_target_command_next_state <= WRITE_FINISH_OPERATION;
				end if;
				
				-- state "ERROR_CHECK"
				when ERROR_CHECK =>
				-- verify if the received command has an error
				-- default state transition
				-- default internal signal values
				-- conditional state transition and internal signal values
				
				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
				-- unexpected package end arrived
				-- default state transition
					s_rmap_target_command_state      <= WRITE_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
				-- default internal signal values
					s_byte_counter                <= 0;
					s_write_data_crc <= x"00";
				-- conditional state transition and internal signal values
				
				-- state "WAITING_PACKAGE_END"
				when WAITING_PACKAGE_END =>
				-- wait until a package end arrives
				-- default state transition
					s_rmap_target_command_state      <= WAITING_BUFFER_SPACE;
					s_rmap_target_command_next_state <= WAITING_PACKAGE_END;
				-- default internal signal values
				-- conditional state transition and internal signal values
				-- check if an end of package arrived
				if (spw_flag_i.flag = '1') then
					-- package ended
					-- go to write finish operation
					s_rmap_target_command_state      <= WRITE_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
				end if;
				
				-- state "NOT_RMAP_PACKAGE"
				when NOT_RMAP_PACKAGE =>
				-- incoming spw data is not a rmap package
				-- default state transition
					s_rmap_target_command_state      <= WAITING_PACKAGE_END;
					s_rmap_target_command_next_state <= WRITE_FINISH_OPERATION;
				-- default internal signal values
					s_byte_counter                <= 0;
					s_write_data_crc <= x"00";
				-- conditional state transition and internal signal values
				
				-- state "DISCARD_PACKAGE"
				when DISCARD_PACKAGE =>
				-- discard current spw package data
				-- default state transition
					s_rmap_target_command_state      <= WRITE_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
				-- default internal signal values
					s_byte_counter                <= 0;
					s_write_data_crc <= x"00";
				-- conditional state transition and internal signal values
				
				-- state "COMMAND_FINISH_OPERATION"
				when COMMAND_FINISH_OPERATION =>
				-- finish command operation
				-- default state transition
					s_rmap_target_command_state      <= COMMAND_FINISH_OPERATION;
					s_rmap_target_command_next_state <= IDLE;
				-- default internal signal values
					s_byte_counter                <= 0;
					s_write_data_crc <= x"00";
				-- conditional state transition and internal signal values
					if (control_i.command_reset = '1') then
						-- command reset commanded, go back to idle
						s_rmap_target_command_state      <= IDLE;
						s_rmap_target_command_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_command_state      <= IDLE;
					s_rmap_target_command_next_state <= IDLE;

			end case;
		end if;
	end process p_rmap_target_command_FSM_state;

	--=============================================================================
	-- Begin of RMAP Target Command Finite State Machine
	-- (output generation)
	--=============================================================================
	-- read: s_rmap_target_command_state, reset_n_i
	-- write:
	-- r/w:
	p_rmap_target_command_FSM_output : process(s_rmap_target_command_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
		-- output generation when s_rmap_target_command_state changes
		else
			case (s_rmap_target_command_state) is

				-- state "IDLE"
				when IDLE =>
				-- does nothing until user application signals it is ready to receive a command
				-- default output signals
				-- conditional output signals
				
				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
				-- wait until the spacewire rx buffer has data
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
				-- target logical address field, receive command target logical address from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
				-- protocol identifier field, receive command protocol identifier from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
				-- instruction field, receive command instruction from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_KEY"
				when FIELD_KEY =>
				-- key field, receive command key from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_REPLY_ADDRESS"
				when FIELD_REPLY_ADDRESS =>
				-- reply address field, receive command reply address from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
				when FIELD_INITIATOR_LOGICAL_ADDRESS =>
				-- initiator logical address field, receive command initiator logical address from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
				-- transaction identifier field, receive command transaction identifier from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_EXTENDED_ADDRESS"
				when FIELD_EXTENDED_ADDRESS =>
				-- extended address field, receive command extended address from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_ADDRESS"
				when FIELD_ADDRESS =>
				-- address field, receive command address from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_DATA_LENGTH"
				when FIELD_DATA_LENGTH =>
				-- data length field, receive command data length from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_HEADER_CRC"
				when FIELD_HEADER_CRC =>
				-- data crc field, receive command header crc from the initiator
				-- default output signals
				-- conditional output signals
				
				-- state "FIELD_EOP"
				when FIELD_EOP =>
				-- eop field, receive eop indicating the end of package
				-- default output signals
				-- conditional output signals
				
				-- state "ERROR_CHECK"
				when ERROR_CHECK =>
				-- verify if the received command has an error
				-- default output signals
				-- conditional output signals
				
				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
				-- unexpected package end arrived
				-- default output signals
				-- conditional output signals
				
				-- state "WAITING_PACKAGE_END"
				when WAITING_PACKAGE_END =>
				-- wait until a package end arrives
				-- default output signals
				-- conditional output signals
				
				-- state "NOT_RMAP_PACKAGE"
				when NOT_RMAP_PACKAGE =>
				-- incoming spw data is not a rmap package
				-- default output signals
				-- conditional output signals
				
				-- state "DISCARD_PACKAGE"
				when DISCARD_PACKAGE =>
				-- discard current spw package data
				-- default output signals
				-- conditional output signals
				
				-- state "COMMAND_FINISH_OPERATION"
				when COMMAND_FINISH_OPERATION =>
				-- finish command operation
				-- default output signals
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_command_FSM_output;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
