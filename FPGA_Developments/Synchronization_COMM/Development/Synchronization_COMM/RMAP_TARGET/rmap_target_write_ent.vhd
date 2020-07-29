--=============================================================================
--! @file rmap_target_write_ent.vhd
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
-- unit name: RMAP Target Write Operation (rmap_target_write_ent)
--
--! @brief Entity for Target RMAP Write Operation. Handles the receive of  
--! SpaceWire data (in flag + data format) and the parsing of a Write Command 
--! data fields. Its purpose is to execute the Write Operation after a Write 
--! Command is received, writing the necessary data to memory and handling 
--! errors.
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
--! 09\01\2019 CB Constant redefinition and s_byte_counter load with\n
--!            (s_byte_counter_vector - 1) -> line 306\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for RMAP Target Write Operation
--============================================================================

entity rmap_target_write_ent is
	generic(
		g_VERIFY_BUFFER_WIDTH  : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 8;
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_DATA_LENGTH_WIDTH    : natural range 0 to c_WIDTH_DATA_LENGTH      := 24;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i              : in  std_logic; --! Local rmap clock
		rst_i              : in  std_logic; --! Reset = '0': no reset; Reset = '1': reset active
		--
		control_i          : in  t_rmap_target_write_control;
		headerdata_i       : in  t_rmap_target_write_headerdata;
		spw_flag_i         : in  t_rmap_target_spw_rx_flag;
		mem_flag_i         : in  t_rmap_target_mem_wr_flag;
		-- global output signals

		flags_o            : out t_rmap_target_write_flags;
		error_o            : out t_rmap_target_write_error;
		spw_control_o      : out t_rmap_target_spw_rx_control;
		mem_control_o      : out t_rmap_target_mem_wr_control;
		mem_byte_address_o : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0)
		-- data bus(es)
	);
end entity rmap_target_write_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_write_ent is

	-- SYMBOLIC ENCODED state machine: s_RMAP_TARGET_WRITE_STATE
	-- =========================================================
	type t_rmap_target_write_state is (
		IDLE,
		WAITING_BUFFER_DATA,
		FIELD_DATA,
		FIELD_DATA_CRC,
		FIELD_EOP,
		WRITE_VERIFIED_DATA,
		WRITE_DATA,
		UNEXPECTED_PACKAGE_END,
		WAITING_PACKAGE_END,
		WRITE_FINISH_OPERATION
	);
	signal s_rmap_target_write_state : t_rmap_target_write_state; -- current state

	signal s_rmap_target_write_next_state : t_rmap_target_write_state;

	signal s_write_data_crc    : std_logic_vector(7 downto 0);
	signal s_write_data_crc_ok : std_logic;

	signal s_write_error : std_logic;

	constant c_MEMORY_ACCESS_SIZE : natural := 2 ** g_MEMORY_ACCESS_WIDTH;
	signal s_write_byte_counter   : natural range 0 to (c_MEMORY_ACCESS_SIZE - 1);

	signal s_write_address : std_logic_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);

	constant c_BYTE_COUNTER_ZERO : std_logic_vector((g_DATA_LENGTH_WIDTH - 1) downto 0) := (others => '0');
	signal s_byte_counter        : std_logic_vector((g_DATA_LENGTH_WIDTH - 1) downto 0);

	type write_verify_buffer_t is array (0 to ((2 ** g_VERIFY_BUFFER_WIDTH) - 1)) of std_logic_vector(7 downto 0);
	signal s_write_verify_buffer : write_verify_buffer_t;

	signal s_write_address_vector : std_logic_vector(39 downto 0);
	signal s_byte_counter_vector  : std_logic_vector(23 downto 0);

	signal s_last_byte_written : std_logic;

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	s_write_address_vector <= headerdata_i.extended_address & headerdata_i.address(3) & headerdata_i.address(2) & headerdata_i.address(1) & headerdata_i.address(0);
	s_byte_counter_vector  <= headerdata_i.data_length(2) & headerdata_i.data_length(1) & headerdata_i.data_length(0);

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, rst_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of RMAP Target Write Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_write_state
	p_rmap_target_write_FSM_state : process(clk_i, rst_i)
		variable v_rmap_target_write_state : t_rmap_target_write_state; -- current state
		variable v_byte_counter            : std_logic_vector((g_DATA_LENGTH_WIDTH - 1) downto 0);
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_rmap_target_write_state      <= IDLE;
			v_rmap_target_write_state      := IDLE;
			s_rmap_target_write_next_state <= IDLE;
			s_write_address                <= (others => '0');
			s_write_byte_counter           <= 0;
			s_byte_counter                 <= (others => '0');
			v_byte_counter                 := (others => '0');
			s_write_data_crc               <= x"00";
			s_write_data_crc_ok            <= '0';
			s_last_byte_written            <= '0';
			-- Outputs Generation
			flags_o.write_data_indication  <= '0';
			flags_o.write_operation_failed <= '0';
			flags_o.write_data_discarded   <= '0';
			flags_o.write_busy             <= '0';
			error_o.early_eop              <= '0';
			error_o.eep                    <= '0';
			error_o.too_much_data          <= '0';
			error_o.invalid_data_crc       <= '0';
			spw_control_o.read             <= '0';
			mem_control_o.write            <= '0';
			mem_control_o.data             <= (others => '0');
			mem_byte_address_o             <= (others => '0');
			s_write_verify_buffer          <= (others => x"00");
			s_write_error                  <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_write_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals a write authorization
					-- default state transition
					s_rmap_target_write_state      <= IDLE;
					v_rmap_target_write_state      := IDLE;
					s_rmap_target_write_next_state <= IDLE;
					-- default internal signal values
					s_write_address                <= (others => '0');
					s_write_byte_counter           <= 0;
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
					s_last_byte_written            <= '0';
					-- conditional state transition and internal signal values
					-- check if user application authorized a write
					if (control_i.write_authorization = '1') then
						-- user application authorized write operation
						-- update data address
						s_write_address                <= s_write_address_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);
						-- prepare byte counter for multi-byte write data
						s_byte_counter                 <= std_logic_vector(unsigned(s_byte_counter_vector((g_DATA_LENGTH_WIDTH - 1) downto 0)) - 1);
						v_byte_counter                 := std_logic_vector(unsigned(s_byte_counter_vector((g_DATA_LENGTH_WIDTH - 1) downto 0)) - 1);
						--						-- check if the data need to be verified before written
						--						if (headerdata_i.instruction_verify_data_before_write = '1') then
						--							-- data does need to be verified to be written
						--							-- go to waiting buffer data
						--							s_rmap_target_write_state <= WAITING_BUFFER_DATA;
						--							v_rmap_target_write_state := WAITING_BUFFER_DATA;
						--						else
						--							-- data does not need to be verified to be written
						--							-- go to write memory data
						--							s_rmap_target_write_state <= WAITING_BUFFER_DATA;
						--							v_rmap_target_write_state := WAITING_BUFFER_DATA;
						--						end if;
						s_rmap_target_write_state      <= WAITING_BUFFER_DATA;
						v_rmap_target_write_state      := WAITING_BUFFER_DATA;
						-- prepare for next field (data field)
						s_rmap_target_write_next_state <= FIELD_DATA;
					-- check if a write request was not authorized by the user application
					elsif (control_i.write_not_authorized = '1') then
						-- write request not authorized
						-- discard rest of the write package
						-- go to waiting buffer data
						s_rmap_target_write_state      <= WAITING_BUFFER_DATA;
						v_rmap_target_write_state      := WAITING_BUFFER_DATA;
						-- prepare to wait for package end
						s_rmap_target_write_next_state <= WAITING_PACKAGE_END;
					end if;

				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
					-- wait until the spacewire rx buffer has data
					-- default state transition
					s_rmap_target_write_state <= WAITING_BUFFER_DATA;
					v_rmap_target_write_state := WAITING_BUFFER_DATA;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if rx buffer have valid data
					if (spw_flag_i.valid = '1') then
						-- rx buffer have valid data
						-- check if the the rx data is an end of package and not an expected eop
						if ((spw_flag_i.flag = '1') and not (((spw_flag_i.data = c_EOP_VALUE) and (s_rmap_target_write_next_state = FIELD_EOP)) or (s_rmap_target_write_next_state = WAITING_PACKAGE_END))) then
							-- rx data is an unexpected package end
							-- go to unexpected end of package					
							s_rmap_target_write_state <= UNEXPECTED_PACKAGE_END;
							v_rmap_target_write_state := UNEXPECTED_PACKAGE_END;
						else
							-- rx data is not an end of package or is expected end of package
							-- go to next field
							s_rmap_target_write_state <= s_rmap_target_write_next_state;
							v_rmap_target_write_state := s_rmap_target_write_next_state;
						end if;
					end if;

				-- state "FIELD_DATA"
				when FIELD_DATA =>
					-- data field, receive write data from the initiator
					-- default state transition
					s_rmap_target_write_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_write_state      := WAITING_BUFFER_DATA;
					s_rmap_target_write_next_state <= FIELD_DATA;
					-- default internal signal values
					s_write_byte_counter           <= 0;
					s_write_data_crc               <= RMAP_CalculateCRC(s_write_data_crc, spw_flag_i.data);
					s_write_data_crc_ok            <= '0';
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					-- conditional state transition and internal signal values
					-- check if all data has been written
					if not ((s_byte_counter = c_BYTE_COUNTER_ZERO) and (s_last_byte_written = '1')) then
						--					if ((s_byte_counter = c_BYTE_COUNTER_ZERO) and (s_last_byte_written = '1')) then
						--						-- all data written
						--						-- go to next field (data crc)
						--						s_rmap_target_write_next_state <= FIELD_DATA_CRC;
						--					else
						-- there is still more data to be written
						-- check if the data need to be verified before written
						if not (headerdata_i.instruction_verify_data_before_write = '1') then
							-- data does not need to be verified to be written
							-- go to write memory data
							s_rmap_target_write_state <= WRITE_DATA;
							v_rmap_target_write_state := WRITE_DATA;
							-- check if it is the last byte
							if (s_byte_counter /= c_BYTE_COUNTER_ZERO) then
								-- not the last byte
								-- check if memory address need to be incremented
								if (headerdata_i.instruction_increment_address = '1') then
									-- increment memory address (for next data)
									s_write_address <= std_logic_vector(unsigned(s_write_address) + 1);
								end if;
								-- check if byte counter can to be incremented (else it will be reseted)
								if (s_write_byte_counter < (c_MEMORY_ACCESS_SIZE - 1)) then
									-- can be incremented without overflowing
									s_write_byte_counter <= s_write_byte_counter + 1;
								end if;
							end if;
						end if;
						-- update byte counter (for next byte)
						if (s_byte_counter = c_BYTE_COUNTER_ZERO) then
							--						-- all data written
							--						-- go to next field (data crc)
							s_rmap_target_write_next_state <= FIELD_DATA_CRC;
							s_last_byte_written            <= '1';
						else
							s_byte_counter <= std_logic_vector(unsigned(s_byte_counter) - 1);
							v_byte_counter := std_logic_vector(unsigned(s_byte_counter) - 1);
						end if;
					end if;

				-- state "FIELD_DATA_CRC"
				when FIELD_DATA_CRC =>
					-- data crc field, receive write data crc from the initiator
					-- default state transition
					s_rmap_target_write_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_write_state      := WAITING_BUFFER_DATA;
					s_rmap_target_write_next_state <= FIELD_EOP;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
					s_last_byte_written            <= '0';
					-- conditional state transition and internal signal values
					if (s_write_data_crc = spw_flag_i.data) then
						s_write_data_crc_ok <= '1';
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, receive eop indicating the end of package
					-- default state transition
					s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
					v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
					s_rmap_target_write_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					s_write_data_crc               <= x"00";
					s_last_byte_written            <= '0';
					-- conditional state transition and internal signal values
					-- check if an end of package arrived
					if (spw_flag_i.flag = '1') then
						-- eop arrived (an eep would have been detected in WAITING_BUFFER_DATA)
						-- check if the data need to be verified before written and if the data crc checked out
						if ((headerdata_i.instruction_verify_data_before_write = '1') and (s_write_data_crc_ok = '1')) then
							-- data need to be verified and data crc checked out
							-- data can be written to memory
							-- prepare the data counter; go to verified data write
							s_byte_counter                 <= std_logic_vector(unsigned(s_byte_counter_vector((g_DATA_LENGTH_WIDTH - 1) downto 0)) - 1);
							v_byte_counter                 := std_logic_vector(unsigned(s_byte_counter_vector((g_DATA_LENGTH_WIDTH - 1) downto 0)) - 1);
							s_rmap_target_write_state      <= WRITE_VERIFIED_DATA;
							v_rmap_target_write_state      := WRITE_VERIFIED_DATA;
							s_rmap_target_write_next_state <= WRITE_FINISH_OPERATION;
						end if;
					else
						-- data arrived, not an end of package
						-- too much data error, go to waiting package end
						s_rmap_target_write_state      <= WAITING_PACKAGE_END;
						v_rmap_target_write_state      := WAITING_PACKAGE_END;
						s_rmap_target_write_next_state <= WRITE_FINISH_OPERATION;
					end if;

				-- state "WRITE_VERIFIED_DATA"
				when WRITE_VERIFIED_DATA =>
					-- write verified memory data
					-- default state transition
					s_rmap_target_write_state      <= WRITE_DATA;
					v_rmap_target_write_state      := WRITE_DATA;
					s_rmap_target_write_next_state <= WRITE_VERIFIED_DATA;
					-- default internal signal values
					s_write_byte_counter           <= 0;
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
					-- conditional state transition and internal signal values
					-- check if all data has been written
					if ((s_byte_counter = c_BYTE_COUNTER_ZERO) and (s_last_byte_written = '1')) then
						-- all data written
						-- finish write operation
						s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
						v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
						s_rmap_target_write_next_state <= IDLE;
					else
						-- there is still more data to be written
						if (s_byte_counter = c_BYTE_COUNTER_ZERO) then
							s_last_byte_written <= '1';
						else
							-- update byte counter (for next byte)
							s_byte_counter <= std_logic_vector(unsigned(s_byte_counter) - 1);
							v_byte_counter := std_logic_vector(unsigned(s_byte_counter) - 1);
							-- check if memory address need to be incremented
							if (headerdata_i.instruction_increment_address = '1') then
								-- increment memory address (for next data)
								s_write_address <= std_logic_vector(unsigned(s_write_address) + 1);
							end if;
							-- check if byte counter can to be incremented (else it will be reseted)
							if (s_write_byte_counter < (c_MEMORY_ACCESS_SIZE - 1)) then
								-- can be incremented without overflowing
								s_write_byte_counter <= s_write_byte_counter + 1;
							end if;
						end if;
					end if;

				-- state "WRITE_DATA"
				when WRITE_DATA =>
					-- write memory data, waits for the memory to be ready for new data
					s_rmap_target_write_state <= WRITE_DATA;
					v_rmap_target_write_state := WRITE_DATA;
					-- default state transition
					-- default internal signal values
					s_write_data_crc_ok       <= '0';
					-- conditional state transition and internal signal values
					-- check if a memory error occurred
					-- check if the memory is ready for more data
					if (mem_flag_i.waitrequest = '0') then
						-- memory is ready for more data
						-- check if the data need to be verified before written
						if (headerdata_i.instruction_verify_data_before_write = '1') then
							-- data need to be verified, go to write verified data
							s_rmap_target_write_state <= WRITE_VERIFIED_DATA;
							v_rmap_target_write_state := WRITE_VERIFIED_DATA;
						else
							-- data does not need to be verified, go to waiting buffer data
							s_rmap_target_write_state <= WAITING_BUFFER_DATA;
							v_rmap_target_write_state := WAITING_BUFFER_DATA;
						end if;
					-- check if and write error occured
					elsif (mem_flag_i.error = '1') then
						-- write error ocurred
						-- check if the data need to be verified before written
						if (headerdata_i.instruction_verify_data_before_write = '1') then
							-- data need to be verified, discard rest of the write data
							s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
							v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
							s_rmap_target_write_next_state <= IDLE;
						else
							-- data does not need to be verified, go to next data field
							s_rmap_target_write_state <= WAITING_BUFFER_DATA;
							v_rmap_target_write_state := WAITING_BUFFER_DATA;
						end if;

					end if;

				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
					-- unexpected package end arrived
					-- default state transition
					s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
					v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
					s_rmap_target_write_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
				-- conditional state transition and internal signal values

				-- state "WAITING_PACKAGE_END"
				when WAITING_PACKAGE_END =>
					-- wait until a package end arrives
					-- default state transition
					s_rmap_target_write_state      <= WAITING_BUFFER_DATA;
					v_rmap_target_write_state      := WAITING_BUFFER_DATA;
					s_rmap_target_write_next_state <= WAITING_PACKAGE_END;
					-- default internal signal values
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
					-- conditional state transition and internal signal values
					-- check if an end of package arrived
					if (spw_flag_i.flag = '1') then
						-- package ended
						-- go to write finish operation
						s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
						v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
						s_rmap_target_write_next_state <= IDLE;
					end if;

				-- state "WRITE_FINISH_OPERATION"
				when WRITE_FINISH_OPERATION =>
					-- finish write operation
					-- default state transition
					s_rmap_target_write_state      <= WRITE_FINISH_OPERATION;
					v_rmap_target_write_state      := WRITE_FINISH_OPERATION;
					s_rmap_target_write_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                 <= (others => '0');
					v_byte_counter                 := (others => '0');
					s_write_data_crc               <= x"00";
					s_write_data_crc_ok            <= '0';
					s_last_byte_written            <= '0';
					-- conditional state transition and internal signal values
					if (control_i.write_reset = '1') then
						-- write reset commanded, go back to idle
						s_rmap_target_write_state      <= IDLE;
						v_rmap_target_write_state      := IDLE;
						s_rmap_target_write_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_write_state      <= IDLE;
					v_rmap_target_write_state      := IDLE;
					s_rmap_target_write_next_state <= IDLE;

			end case;
			--=============================================================================
			-- Begin of RMAP Target Write Finite State Machine
			-- (output generation)
			--=============================================================================
			-- read: s_rmap_target_write_state, rst_i
			-- write:
			-- r/w:
			case (v_rmap_target_write_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals a write authorization
					-- default output signals
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					flags_o.write_busy             <= '0';
					error_o.early_eop              <= '0';
					error_o.eep                    <= '0';
					error_o.too_much_data          <= '0';
					error_o.invalid_data_crc       <= '0';
					spw_control_o.read             <= '0';
					mem_control_o.write            <= '0';
					mem_control_o.data             <= (others => '0');
					mem_byte_address_o             <= (others => '0');
					s_write_verify_buffer          <= (others => x"00");
					s_write_error                  <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_DATA"
				when WAITING_BUFFER_DATA =>
					-- wait until the spacewire rx buffer has data
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '0';
					mem_control_o.write            <= '0';
				-- conditional output signals

				-- state "FIELD_DATA"
				when FIELD_DATA =>
					-- data field, receive write data from the initiator
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '1';
					mem_control_o.write            <= '0';
					-- conditional output signals
					-- check if the data need to be verified before written
					if (headerdata_i.instruction_verify_data_before_write = '1') then
						-- data need to be verified to be written
						-- write data in verify buffer
						s_write_verify_buffer(to_integer(unsigned(s_byte_counter))) <= spw_flag_i.data;
					else
						mem_control_o.write <= '0';
						mem_control_o.data  <= spw_flag_i.data;
						-- check if memory access is more than one byte
						if (c_MEMORY_ACCESS_SIZE > 1) then
							-- memory access is more than one byte, need to send write address and byte address
							mem_byte_address_o <= s_write_address & std_logic_vector(to_unsigned(s_write_byte_counter, g_MEMORY_ACCESS_WIDTH));
						else
							-- memory access is only one byte, need to send just the write address
							mem_byte_address_o <= s_write_address;
						end if;
					end if;

				-- state "FIELD_DATA_CRC"
				when FIELD_DATA_CRC =>
					-- data crc field, receive write data crc from the initiator
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '1';
					mem_control_o.write            <= '0';
					-- conditional output signals
					-- check if error crc occured
					if not (s_write_data_crc = spw_flag_i.data) then
						-- flag the error
						error_o.invalid_data_crc <= '1';
						s_write_error            <= '1';
					end if;

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, receive eop indicating the end of package
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '1';
					mem_control_o.write            <= '0';
					-- default output signals
					-- conditional output signals
					-- check if data arrived insteady of an end of package
					if (spw_flag_i.flag = '0') then
						-- data arrived, not an end of package
						-- too much data error
						error_o.too_much_data <= '1';
						s_write_error         <= '1';
					end if;

				-- state "WRITE_VERIFIED_DATA"
				when WRITE_VERIFIED_DATA =>
					-- write verified memory data
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '0';
					-- default output signals
					mem_control_o.write            <= '0';
					mem_control_o.data             <= s_write_verify_buffer(to_integer(unsigned(v_byte_counter)));
					-- conditional output signals
					-- check if memory access is more than one byte
					if (c_MEMORY_ACCESS_SIZE > 1) then
						-- memory access is more than one byte, need to send write address and byte address
						mem_byte_address_o <= s_write_address & std_logic_vector(to_unsigned(s_write_byte_counter, g_MEMORY_ACCESS_WIDTH));
					else
						-- memory access is only one byte, need to send just the write address
						mem_byte_address_o <= s_write_address;
					end if;

				-- state "WRITE_DATA"
				when WRITE_DATA =>
					-- write memory data, waits for the memory to be ready for new data
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '0';
					mem_control_o.write            <= '1';
				-- conditional output signals

				-- state "UNEXPECTED_PACKAGE_END"
				when UNEXPECTED_PACKAGE_END =>
					-- unexpected package end arrived
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '1';
					mem_control_o.write            <= '0';
					error_o.early_eop              <= '0';
					error_o.eep                    <= '0';
					s_write_error                  <= '1';
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
					flags_o.write_busy             <= '1';
					flags_o.write_data_indication  <= '0';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '0';
					mem_control_o.write            <= '0';
					-- conditional output signals
					if (spw_flag_i.valid = '1') then
						spw_control_o.read <= '1';
					end if;

				-- state "WRITE_FINISH_OPERATION"
				when WRITE_FINISH_OPERATION =>
					-- finish write operation
					-- default output signals
					flags_o.write_busy             <= '1';
					flags_o.write_operation_failed <= '0';
					flags_o.write_data_indication  <= '0';
					flags_o.write_data_discarded   <= '0';
					spw_control_o.read             <= '0';
					mem_control_o.write            <= '0';
					-- conditional output signals
					-- check if the rest of the write package was discarded
					if (control_i.write_not_authorized = '1') then
						-- rest of the write package discarded
						flags_o.write_data_discarded <= '1';
					else
						-- write package not discarded
						-- check if a write error ocurred
						if (s_write_error = '1') then
							-- error ocurred, write operation failed
							flags_o.write_operation_failed <= '1';
						else
							-- operation successful
							flags_o.write_data_indication <= '1';
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_write_FSM_state;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
