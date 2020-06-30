--=============================================================================
--! @file rmap_target_reply_ent.vhd
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
-- unit name: RMAP Target Reply Generation (rmap_target_reply_ent)
--
--! @brief Entity for Target RMAP Reply Generation. Handles the creation of  
--! the Reply Header fields for the Read and Write Reply and the transmission 
--! of SpaceWire data (in flag + data format). Its purpose is to create a RMAP 
--! Reply basead on the received Command, preparing all the data that need to 
--! be sent to the Initiator.
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
--! Entity declaration for RMAP Target Reply Generation
--============================================================================

entity rmap_target_reply_ent is
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i         : in  std_logic;  --! Local rmap clock
		reset_n_i     : in  std_logic;  --! Reset = '0': reset active; Reset = '1': no reset

		control_i     : in  t_rmap_target_reply_control;
		headerdata_i  : in  t_rmap_target_reply_headerdata;
		spw_flag_i    : in  t_rmap_target_spw_tx_flag;
		-- global output signals
		flags_o       : out t_rmap_target_reply_flags;
		--		error_o       : out t_rmap_target_reply_error;
		spw_control_o : out t_rmap_target_spw_tx_control
		-- data bus(es)
	);
end entity rmap_target_reply_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_reply_ent is

	-- SYMBOLIC ENCODED state machine: s_RMAP_TARGET_REPLY_STATE
	-- =========================================================
	type t_rmap_target_reply_state is (
		IDLE,
		WAITING_BUFFER_SPACE,
		FIELD_REPLY_SPW_ADDRESS,
		FIELD_INITIATOR_LOGICAL_ADDRESS,
		FIELD_PROTOCOL_IDENTIFIER,
		FIELD_INSTRUCTION,
		FIELD_STATUS,
		FIELD_TARGET_LOGICAL_ADDRESS,
		FIELD_TRANSACTION_IDENTIFIER,
		FIELD_RESERVED,
		FIELD_DATA_LEGNTH,
		FIELD_HEADER_CRC,
		FIELD_EOP,
		REPLY_FINISH_GENERATION
	);
	signal s_rmap_target_reply_state : t_rmap_target_reply_state; -- current state

	signal s_rmap_target_reply_next_state : t_rmap_target_reply_state;

	signal s_reply_header_crc : std_logic_vector(7 downto 0);

	signal s_byte_counter : natural range 0 to 11;

	signal s_reply_address_flag : std_logic;

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
	-- Begin of RMAP Target Reply Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_reply_state
	p_rmap_target_reply_FSM_state : process(clk_i, reset_n_i)
		variable v_rmap_target_reply_state : t_rmap_target_reply_state := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_rmap_target_reply_state      <= IDLE;
			v_rmap_target_reply_state      := IDLE;
			s_rmap_target_reply_next_state <= IDLE;
			s_byte_counter                 <= 0;
			-- Outputs Generation
			flags_o.reply_busy             <= '0';
			flags_o.reply_finished         <= '0';
			spw_control_o.data             <= x"00";
			spw_control_o.flag             <= '0';
			spw_control_o.write            <= '0';
			s_reply_header_crc             <= x"00";
			s_reply_address_flag           <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_reply_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals it is ready to send a reply
					-- default state transition
					s_rmap_target_reply_state      <= IDLE;
					v_rmap_target_reply_state      := IDLE;
					s_rmap_target_reply_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= 0;
					-- conditional state transition and internal signal values
					-- check if user application is ready to send a reply
					if (control_i.send_reply = '1') then
						-- user ready to send a reply
						-- check if a reply spw address is to be used
						if (headerdata_i.instructions.reply_address_length /= "00") then
							-- reply spw address is used, set next field as reply spw address
							s_rmap_target_reply_next_state <= FIELD_REPLY_SPW_ADDRESS;
							-- prepare byte counter for multi-byte reply data
							s_byte_counter                 <= 11;
						else
							-- reply spw address not used, set next field as initiator logical address
							s_rmap_target_reply_next_state <= FIELD_INITIATOR_LOGICAL_ADDRESS;
						end if;
						-- go to wating buffer space
						s_rmap_target_reply_state <= WAITING_BUFFER_SPACE;
						v_rmap_target_reply_state := WAITING_BUFFER_SPACE;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					s_rmap_target_reply_state <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state := WAITING_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_flag_i.ready = '1') then
						-- tx buffer can receive data
						-- go to next field
						s_rmap_target_reply_state <= s_rmap_target_reply_next_state;
						v_rmap_target_reply_state := s_rmap_target_reply_next_state;
					end if;

				-- state "FIELD_REPLY_SPW_ADDRESS"
				when FIELD_REPLY_SPW_ADDRESS =>
					-- reply spw address field, send reply spw address to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_REPLY_SPW_ADDRESS;
					-- default internal signal values
					s_byte_counter                 <= 0;
					-- conditional state transition and internal signal values
					-- check if the multi-byte field ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (initiator logical address)
						s_rmap_target_reply_next_state <= FIELD_INITIATOR_LOGICAL_ADDRESS;
					else
						-- there are still more bytes in the field
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
				when FIELD_INITIATOR_LOGICAL_ADDRESS =>
					-- initiator logical address field, send initiator logical address to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_PROTOCOL_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                 <= 0;
				-- conditional state transition and internal signal values

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_INSTRUCTION;
					-- default internal signal values
					s_byte_counter                 <= 0;
				-- conditional state transition and internal signal values

				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
					-- instruction field, send instruction to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_STATUS;
					-- default internal signal values
					s_byte_counter                 <= 0;
				-- conditional state transition and internal signal values

				-- state "FIELD_STATUS"
				when FIELD_STATUS =>
					-- status field, send status to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_TARGET_LOGICAL_ADDRESS;
					-- default internal signal values
					s_byte_counter                 <= 0;
				-- conditional state transition and internal signal values

				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
					-- target logical address field, send target logical address to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_TRANSACTION_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                 <= 1;
				-- conditional state transition and internal signal values

				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
					-- transaction identifier field, send transaction identifier to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_TRANSACTION_IDENTIFIER;
					-- default internal signal values
					s_byte_counter                 <= 0;
					-- conditional state transition and internal signal values
					-- check if the multi-byte field ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- check if it is a write reply or a read reply
						if (headerdata_i.instructions.command.write_read = '1') then
							-- write reply, next field to be written is the reply header crc
							s_rmap_target_reply_next_state <= FIELD_HEADER_CRC;
						else
							-- read reply, next field to be written is the reserved
							s_rmap_target_reply_next_state <= FIELD_RESERVED;
						end if;
					else
						-- there are still more bytes in the field
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_RESERVED"
				when FIELD_RESERVED =>
					-- reserved field, send reserved to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_DATA_LEGNTH;
					-- default internal signal values
					s_byte_counter                 <= 2;
				-- conditional state transition and internal signal values

				-- state "FIELD_DATA_LEGNTH"
				when FIELD_DATA_LEGNTH =>
					-- data length field, send data length to initiator
					-- default state transition
					s_rmap_target_reply_state      <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state      := WAITING_BUFFER_SPACE;
					s_rmap_target_reply_next_state <= FIELD_DATA_LEGNTH;
					-- default internal signal values
					s_byte_counter                 <= 0;
					-- conditional state transition and internal signal values
					-- check if the multi-byte field ended
					if (s_byte_counter = 0) then
						-- multi-byte field ended
						-- go to next field (header crc)
						s_rmap_target_reply_next_state <= FIELD_HEADER_CRC;
					else
						-- there are still more bytes in the field
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

				-- state "FIELD_HEADER_CRC"
				when FIELD_HEADER_CRC =>
					-- header crc field, send header crc to initiator
					-- default state transition
					s_rmap_target_reply_state <= WAITING_BUFFER_SPACE;
					v_rmap_target_reply_state := WAITING_BUFFER_SPACE;
					-- default internal signal values
					s_byte_counter            <= 0;
					-- conditional state transition and internal signal values
					-- check if it is a write reply or a read reply
					if (headerdata_i.instructions.command.write_read = '1') then
						-- write reply, next field to be written is the eop
						s_rmap_target_reply_next_state <= FIELD_EOP;
					else
						-- read reply, next field to be written is a data field
						s_rmap_target_reply_next_state <= REPLY_FINISH_GENERATION;
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to initiator
					-- default state transition
					s_rmap_target_reply_state      <= REPLY_FINISH_GENERATION;
					v_rmap_target_reply_state      := REPLY_FINISH_GENERATION;
					s_rmap_target_reply_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= 0;
				-- conditional state transition and internal signal values

				-- state "REPLY_FINISH_GENERATION"
				when REPLY_FINISH_GENERATION =>
					-- finish reply generation
					-- default state transition
					s_rmap_target_reply_state      <= REPLY_FINISH_GENERATION;
					v_rmap_target_reply_state      := REPLY_FINISH_GENERATION;
					s_rmap_target_reply_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= 0;
					-- conditional state transition and internal signal values
					-- check if user application commanded a read reset
					if (control_i.reply_reset = '1') then
						-- reply reset commanded, go back to idle
						s_rmap_target_reply_state      <= IDLE;
						v_rmap_target_reply_state      := IDLE;
						s_rmap_target_reply_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_reply_state      <= IDLE;
					v_rmap_target_reply_state      := IDLE;
					s_rmap_target_reply_next_state <= IDLE;

			end case;
			--=============================================================================
			-- Begin of RMAP Target Reply Finite State Machine
			-- (output generation)
			--=============================================================================
			-- read: s_rmap_target_reply_state, reset_n_i
			-- write:
			-- r/w:
			case (v_rmap_target_reply_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals it is ready to send a reply
					-- reset outputs
					-- default output signals
					flags_o.reply_busy     <= '0';
					flags_o.reply_finished <= '0';
					spw_control_o.data     <= x"00";
					spw_control_o.flag     <= '0';
					spw_control_o.write    <= '0';
					s_reply_header_crc     <= x"00";
					s_reply_address_flag   <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw tx write signal
					spw_control_o.write    <= '0';
				-- conditional output signals

				-- state "FIELD_REPLY_SPW_ADDRESS"
				when FIELD_REPLY_SPW_ADDRESS =>
					-- reply spw address field, send reply spw address to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					s_reply_address_flag   <= '0';
					spw_control_o.flag     <= '0';
					spw_control_o.data     <= x"00";
					spw_control_o.write    <= '0';
					-- conditional output signals
					-- check if a non-zero reply spw address data have already been detected
					if (s_reply_address_flag = '1') then
						-- reply spw address data arrived
						s_reply_address_flag <= '1';
						-- fill spw data with field data
						spw_control_o.data   <= headerdata_i.reply_spw_address(s_byte_counter);
						-- write the spw data
						spw_control_o.write  <= '1';
					else
						-- non-zero data not detected yet
						-- check if the reply spw address data is a zero
						if (headerdata_i.reply_spw_address(s_byte_counter) = x"00") then
							-- data is a zero
							-- check if the data is the last reply spw address
							if (s_byte_counter = 0) then
								-- last reply spw address
								-- send a single 0x00 as the reply spw address
								spw_control_o.data  <= x"00";
								-- write the spw data
								spw_control_o.write <= '1';
							end if;
						-- if not last reply spw address, the data is a leading zero and will be ignored
						else
							-- data is not a zero, leading zeros are over
							-- flag that a non-zero reply spw address data arrived
							s_reply_address_flag <= '1';
							-- fill spw data with field data
							spw_control_o.data   <= headerdata_i.reply_spw_address(s_byte_counter);
							-- write the spw data
							spw_control_o.write  <= '1';
						end if;
					end if;

				-- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
				when FIELD_INITIATOR_LOGICAL_ADDRESS =>
					-- initiator logical address field, send initiator logical address to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with field data
					spw_control_o.data     <= headerdata_i.initiator_logical_address;
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, headerdata_i.initiator_logical_address);
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_PROTOCOL_IDENTIFIER"
				when FIELD_PROTOCOL_IDENTIFIER =>
					-- protocol identifier field, send protocol identifier to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with the rmap protocol identifier (0x01)
					spw_control_o.data     <= x"01";
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, x"01");
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_INSTRUCTION"
				when FIELD_INSTRUCTION =>
					-- instruction field, send instruction to initiator
					-- default output signals
					flags_o.reply_busy             <= '1';
					flags_o.reply_finished         <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag             <= '0';
					-- fill spw data with field data
					-- packet type = 0b00 (reply packet)
					spw_control_o.data(7 downto 6) <= "00";
					-- same command field as the command 
					spw_control_o.data(5)          <= headerdata_i.instructions.command.write_read;
					spw_control_o.data(4)          <= headerdata_i.instructions.command.verify_data_before_write;
					spw_control_o.data(3)          <= headerdata_i.instructions.command.reply;
					spw_control_o.data(2)          <= headerdata_i.instructions.command.increment_address;
					-- same reply address length as the command
					spw_control_o.data(1 downto 0) <= headerdata_i.instructions.reply_address_length;
					-- update crc calculation
					s_reply_header_crc             <= RMAP_CalculateCRC(s_reply_header_crc, ("00" & headerdata_i.instructions.command.write_read & headerdata_i.instructions.command.verify_data_before_write & headerdata_i.instructions.command.reply & headerdata_i.instructions.command.increment_address & headerdata_i.instructions.reply_address_length));
					-- write the spw data
					spw_control_o.write            <= '1';
				-- conditional output signals

				-- state "FIELD_STATUS"
				when FIELD_STATUS =>
					-- status field, send status to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with field data
					spw_control_o.data     <= headerdata_i.status;
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, headerdata_i.status);
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_TARGET_LOGICAL_ADDRESS"
				when FIELD_TARGET_LOGICAL_ADDRESS =>
					-- target logical address field, send target logical address to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with field data
					spw_control_o.data     <= headerdata_i.target_logical_address;
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, headerdata_i.target_logical_address);
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_TRANSACTION_IDENTIFIER"
				when FIELD_TRANSACTION_IDENTIFIER =>
					-- transaction identifier field, send transaction identifier to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with the reserved field data (0x00)
					spw_control_o.data     <= headerdata_i.transaction_identifier(s_byte_counter);
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, headerdata_i.transaction_identifier(s_byte_counter));
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_RESERVED"
				when FIELD_RESERVED =>
					-- reserved field, send reserved to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with the reserved field data (0x00)
					spw_control_o.data     <= x"00";
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, x"00");
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_DATA_LEGNTH"
				when FIELD_DATA_LEGNTH =>
					-- data length field, send data length to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with the reserved field data (0x00)
					spw_control_o.data     <= headerdata_i.data_length(s_byte_counter);
					-- update crc calculation
					s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, headerdata_i.data_length(s_byte_counter));
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_HEADER_CRC"
				when FIELD_HEADER_CRC =>
					-- header crc field, send header crc to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag     <= '0';
					-- fill spw data with field data
					spw_control_o.data     <= s_reply_header_crc;
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to initiator
					-- default output signals
					flags_o.reply_busy     <= '1';
					flags_o.reply_finished <= '0';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag     <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_control_o.data     <= c_EOP_VALUE;
					-- write the spw data
					spw_control_o.write    <= '1';
				-- conditional output signals

				-- state "REPLY_FINISH_GENERATION"
				when REPLY_FINISH_GENERATION =>
					-- finish reply generation
					-- default output signals
					flags_o.reply_busy     <= '1';
					-- indicate that the reply generation is finished
					flags_o.reply_finished <= '1';
					spw_control_o.write    <= '0';
					spw_control_o.flag     <= '0';
					spw_control_o.data     <= x"00";
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_reply_FSM_state;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
