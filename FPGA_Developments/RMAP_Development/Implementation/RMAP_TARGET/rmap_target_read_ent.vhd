--=============================================================================
--! @file rmap_target_read_ent.vhd
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
-- unit name: RMAP Target Read Operation (rmap_target_read_ent)
--
--! @brief Entity for Target RMAP Read Operation. Handles the creation of the 
--! Read Reply Data fields and the transmission of SpaceWire data (in flag + 
--! data format). Its purpose is to execute the Read Operation after a Read 
--! Command is received, reading the necessary data from memory and sending 
--! it to the Initiator.
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
--! Entity declaration for RMAP Target Read Operation
--============================================================================

entity rmap_target_read_ent is
	generic(
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_DATA_LENGTH_WIDTH    : natural range 0 to c_WIDTH_DATA_LENGTH      := 24;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i              : in  std_logic; --! Local rmap clock
		reset_n_i          : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		control_i          : in  t_rmap_target_read_control;
		headerdata_i       : in  t_rmap_target_read_headerdata;
		spw_flag_i         : in  t_rmap_target_spw_tx_flag;
		mem_flag_i         : in  t_rmap_target_mem_rd_flag;
		-- global output signals

		flags_o            : out t_rmap_target_read_flags;
		--		error_o       : out t_rmap_target_read_error;
		spw_control_o      : out t_rmap_target_spw_tx_control;
		mem_control_o      : out t_rmap_target_mem_rd_control;
		mem_byte_address_o : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0)
		-- data bus(es)
	);
end entity rmap_target_read_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_read_ent is

	-- SYMBOLIC ENCODED state machine: s_RMAP_TARGET_READ_STATE
	-- ========================================================
	type t_rmap_target_read_state is (
		IDLE,
		WAITING_BUFFER_SPACE,
		FIELD_DATA,
		FIELD_DATA_CRC,
		FIELD_EOP,
		READ_DATA,
		READ_NOT_OK,
		READ_FINISH_OPERATION
	);
	signal s_rmap_target_read_state : t_rmap_target_read_state; -- current state

	signal s_rmap_target_read_next_state : t_rmap_target_read_state;

	signal s_read_data_crc : std_logic_vector(7 downto 0);

	signal s_read_error : std_logic;

	constant c_MEMORY_ACCESS_SIZE : natural := 2 ** c_WIDTH_MEMORY_ACCESS;
	signal s_read_address      : std_logic_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);
	signal s_read_byte_counter : natural range 0 to (c_MEMORY_ACCESS_SIZE - 1);

	constant c_BYTE_COUNTER_ZERO : std_logic_vector((g_DATA_LENGTH_WIDTH - 1) downto 0) := (others => '0');
	signal s_byte_counter        : std_logic_vector((g_DATA_LENGTH_WIDTH - 1) downto 0);

	signal s_read_address_vector : std_logic_vector(39 downto 0);
	signal s_byte_counter_vector : std_logic_vector(23 downto 0);

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	s_read_address_vector <= headerdata_i.extended_address & headerdata_i.address(3) & headerdata_i.address(2) & headerdata_i.address(1) & headerdata_i.address(0);
	s_byte_counter_vector <= headerdata_i.data_length(2) & headerdata_i.data_length(1) & headerdata_i.data_length(0);

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! FIXME Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, reset_n_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================

	--=============================================================================
	-- Begin of RMAP Target Read Finite State Machine
	-- (state transitions)
	--=============================================================================
	-- read: clk_i, s_reset_n
	-- write:
	-- r/w: s_rmap_target_read_state
	p_rmap_target_read_FSM_state : process(clk_i, reset_n_i)
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (reset_n_i = '0') then
			s_rmap_target_read_state      <= IDLE;
			s_rmap_target_read_next_state <= IDLE;
			s_read_address                <= (others => '0');
			s_read_byte_counter           <= 0;
			s_byte_counter                <= (others => '0');
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_rmap_target_read_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals a read authorization
					-- default state transition
					s_rmap_target_read_state      <= IDLE;
					s_rmap_target_read_next_state <= IDLE;
					-- default internal signal values
					s_read_address                <= (others => '0');
					s_read_byte_counter           <= 0;
					s_byte_counter                <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if user application authorized a read
					if (control_i.read_authorization = '1') then
						-- user application authorized read operation
						-- update data address
						s_read_address                <= s_read_address_vector((g_MEMORY_ADDRESS_WIDTH - 1) downto 0);
						-- prepare byte counter for multi-byte read data
						s_byte_counter                <= std_logic_vector(unsigned(s_byte_counter_vector((g_DATA_LENGTH_WIDTH - 1) downto 0)) - 1);
						-- go to wating buffer space
						s_rmap_target_read_state      <= WAITING_BUFFER_SPACE;
						-- prepare for next field (data field)
						s_rmap_target_read_next_state <= READ_DATA;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default state transition
					s_rmap_target_read_state <= WAITING_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_flag_i.ready = '1') then
						-- tx buffer can receive data
						-- go to next field
						s_rmap_target_read_state <= s_rmap_target_read_next_state;
					end if;

				-- state "FIELD_DATA"
				when FIELD_DATA =>
					-- data field, send read data to initiator
					-- default state transition
					s_rmap_target_read_state      <= WAITING_BUFFER_SPACE;
					s_rmap_target_read_next_state <= READ_DATA;
					-- default internal signal values
					s_read_byte_counter           <= 0;
					s_byte_counter                <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if all data has been read
					if (s_byte_counter = c_BYTE_COUNTER_ZERO) then
						-- all data read
						-- go to next field (data crc)
						s_rmap_target_read_next_state <= FIELD_DATA_CRC;
					else
						-- there is still more data to be read
						-- update byte counter (for next byte)
						s_byte_counter <= std_logic_vector(unsigned(s_byte_counter) - 1);
						-- check if memory address need to be incremented
						if (headerdata_i.instruction_increment_address = '1') then
							-- increment memory address (for next data)
							s_read_address <= std_logic_vector(unsigned(s_read_address) + 1);
						end if;
						-- check if byte counter can to be incremented (else it will be reseted)
						if (s_read_byte_counter < (c_MEMORY_ACCESS_SIZE - 1)) then
							-- can be incremented without overflowing
							s_read_byte_counter <= s_read_byte_counter + 1;
						end if;
					end if;

				-- state "FIELD_DATA_CRC"
				when FIELD_DATA_CRC =>
					-- data crc field, send read data crc to initiator
					-- default state transition
					s_rmap_target_read_state      <= WAITING_BUFFER_SPACE;
					s_rmap_target_read_next_state <= FIELD_EOP;
					-- default internal signal values
					s_byte_counter                <= (others => '0');
				-- conditional state transition and internal signal values

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to indicate end of package
					-- default state transition
					s_rmap_target_read_state      <= READ_FINISH_OPERATION;
					s_rmap_target_read_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                <= (others => '0');
				-- conditional state transition and internal signal values

				-- state "READ_DATA"
				when READ_DATA =>
					-- fetch memory data, wait for valid data in memory
					-- default state transition
					s_rmap_target_read_state <= READ_DATA;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if memory has valid data
					if (mem_flag_i.valid = '1') then
						-- memory has valid data
						-- go to next data field
						s_rmap_target_read_state <= FIELD_DATA;
					-- check if a read error ocurred
					elsif (mem_flag_i.error = '1') then
						-- read error occured
						-- go to read not ok state
						s_rmap_target_read_state      <= READ_NOT_OK;
						s_rmap_target_read_next_state <= IDLE;
					end if;

				-- state "READ_NOT_OK"
				when READ_NOT_OK =>
					-- error in read operation
					-- default state transition
					s_rmap_target_read_state      <= READ_FINISH_OPERATION;
					s_rmap_target_read_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                <= (others => '0');
				-- conditional state transition and internal signal values

				-- state "READ_FINISH_OPERATION"
				when READ_FINISH_OPERATION =>
					-- finish read operation
					-- default state transition
					s_rmap_target_read_state      <= READ_FINISH_OPERATION;
					s_rmap_target_read_next_state <= IDLE;
					-- default internal signal values
					s_byte_counter                <= (others => '0');
					-- conditional state transition and internal signal values
					-- check if user application commanded a read reset
					if (control_i.read_reset = '1') then
						-- read reset commanded, go back to idle
						s_rmap_target_read_state      <= IDLE;
						s_rmap_target_read_next_state <= IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_rmap_target_read_state      <= IDLE;
					s_rmap_target_read_next_state <= IDLE;

			end case;
		end if;
	end process p_rmap_target_read_FSM_state;

	--=============================================================================
	-- Begin of RMAP Target Read Finite State Machine
	-- (output generation)
	--=============================================================================
	-- read: s_rmap_target_read_state, reset_n_i
	-- write:
	-- r/w:
	p_rmap_target_read_FSM_output : process(s_rmap_target_read_state, reset_n_i)
	begin
		-- asynchronous reset
		if (reset_n_i = '0') then
			flags_o.read_busy             <= '0';
			flags_o.read_data_indication  <= '0';
			flags_o.read_operation_failed <= '0';
			spw_control_o.data            <= x"00";
			spw_control_o.flag            <= '0';
			spw_control_o.write           <= '0';
			mem_control_o.read            <= '0';
			mem_byte_address_o            <= (others => '0');
			s_read_data_crc               <= x"00";
			s_read_error                  <= '0';
		-- output generation when s_rmap_target_read_state changes
		else
			case (s_rmap_target_read_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until user application signals a read authorization
					-- default output signals
					-- reset outputs
					flags_o.read_busy             <= '0';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					spw_control_o.data            <= x"00";
					spw_control_o.flag            <= '0';
					spw_control_o.write           <= '0';
					mem_control_o.read            <= '0';
					mem_byte_address_o            <= (others => '0');
					s_read_data_crc               <= x"00";
					s_read_error                  <= '0';
				-- conditional output signals

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					-- clear spw tx write signal
					spw_control_o.write           <= '0';
				-- conditional output signals

				-- state "FIELD_DATA"
				when FIELD_DATA =>
					-- data field, send read data to initiator
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					mem_control_o.read            <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag            <= '0';
					-- fill spw data with field data
					spw_control_o.data            <= mem_flag_i.data;
					-- update crc calculation
					s_read_data_crc               <= RMAP_CalculateCRC(s_read_data_crc, mem_flag_i.data);
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "FIELD_DATA_CRC"
				when FIELD_DATA_CRC =>
					-- data crc field, send read data crc to initiator
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					-- clear spw flag (to indicate a data)
					spw_control_o.flag            <= '0';
					-- fill spw data with field data
					spw_control_o.data            <= s_read_data_crc;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "FIELD_EOP"
				when FIELD_EOP =>
					-- eop field, send eop to indicate end of package
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					-- indicate that the read operation was successful
					s_read_error                  <= '0';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag            <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_control_o.data            <= c_EOP_VALUE;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "READ_DATA"
				when READ_DATA =>
					-- fetch memory data
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					-- check if memory access is more than one byte
					if (c_MEMORY_ACCESS_SIZE > 1) then
						-- memory access is more than one byte, need to send read address and byte address
						mem_byte_address_o <= s_read_address & std_logic_vector(to_unsigned(s_read_byte_counter, g_MEMORY_ACCESS_WIDTH));
					else
						-- memory access is only one byte, need to send just the read address
						mem_byte_address_o <= s_read_address;
					end if;

					-- set memory read request
					mem_control_o.read <= '1';
				-- conditional output signals

				-- state "READ_NOT_OK"
				when READ_NOT_OK =>
					-- error in read operation
					-- finish the read reply package with an EEP
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_data_indication  <= '0';
					flags_o.read_operation_failed <= '0';
					-- set the error flag
					s_read_error                  <= '1';
					-- set spw flag (to indicate a package end)
					spw_control_o.flag            <= '1';
					-- fill spw data with the eep identifier (0x01)
					spw_control_o.data            <= c_EEP_VALUE;
					-- write the spw data
					spw_control_o.write           <= '1';
				-- conditional output signals

				-- state "READ_FINISH_OPERATION"
				when READ_FINISH_OPERATION =>
					-- finish read operation
					-- default output signals
					flags_o.read_busy             <= '1';
					flags_o.read_operation_failed <= '0';
					flags_o.read_data_indication  <= '0';
					spw_control_o.write           <= '0';
					spw_control_o.flag            <= '0';
					spw_control_o.data            <= x"00";
					mem_control_o.read            <= '0';
					-- update output information
					-- conditional output signals
					-- check if a read error ocurred
					if (s_read_error = '1') then
						-- error ocurred, write operation failed
						flags_o.read_operation_failed <= '1';
					else
						-- operation successful
						flags_o.read_data_indication <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_rmap_target_read_FSM_output;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
