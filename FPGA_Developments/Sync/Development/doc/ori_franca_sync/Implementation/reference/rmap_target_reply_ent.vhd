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
        clk_i            : in  std_logic; --! Local rmap clock
        rst_i            : in  std_logic; --! Reset = '0': no reset; Reset = '1': reset active
        --
        control_i        : in  t_rmap_target_reply_control;
        headerdata_i     : in  t_rmap_target_reply_headerdata;
        errinj_rst_i     : in  std_logic;
        errinj_control_i : in  t_rmap_errinj_control;
        spw_flag_i       : in  t_rmap_target_spw_tx_flag;
        -- global output signals
        flags_o          : out t_rmap_target_reply_flags;
        errinj_status_o  : out t_rmap_errinj_status;
        --		error_o       : out t_rmap_target_reply_error;
        spw_control_o    : out t_rmap_target_spw_tx_control
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

    signal s_registered_rmap_errinj_control : t_rmap_errinj_control;
    signal s_registered_rmap_errinj_status  : t_rmap_errinj_status;

    signal s_spw_control_write_enable : std_logic;

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
    -- Begin of RMAP Target Reply Finite State Machine
    -- (state transitions)
    --=============================================================================
    -- read: clk_i, s_reset_n
    -- write:
    -- r/w: s_rmap_target_reply_state
    p_rmap_target_reply_FSM_state : process(clk_i, rst_i)
        variable v_rmap_target_reply_state : t_rmap_target_reply_state := IDLE; -- current state
        variable v_output_headerdata       : t_rmap_target_reply_headerdata;
    begin
        -- on asynchronous reset in any state we jump to the idle state
        if (rst_i = '1') then
            s_rmap_target_reply_state                                         <= IDLE;
            v_rmap_target_reply_state                                         := IDLE;
            s_rmap_target_reply_next_state                                    <= IDLE;
            s_byte_counter                                                    <= 0;
            s_registered_rmap_errinj_control                                  <= c_RMAP_ERRINJ_CONTROL_RST;
            s_registered_rmap_errinj_status                                   <= c_RMAP_ERRINJ_STATUS_RST;
            s_spw_control_write_enable                                        <= '1';
            v_output_headerdata.target_logical_address                        := x"00";
            v_output_headerdata.instructions.packet_type                      := "00";
            v_output_headerdata.instructions.command.write_read               := '0';
            v_output_headerdata.instructions.command.verify_data_before_write := '0';
            v_output_headerdata.instructions.command.reply                    := '0';
            v_output_headerdata.instructions.command.increment_address        := '0';
            v_output_headerdata.instructions.reply_address_length             := "00";
            v_output_headerdata.status                                        := x"00";
            v_output_headerdata.initiator_logical_address                     := x"00";
            v_output_headerdata.transaction_identifier                        := (others => x"00");
            v_output_headerdata.data_length                                   := (others => x"00");
            -- Outputs Generation
            flags_o.reply_busy                                                <= '0';
            flags_o.reply_finished                                            <= '0';
            errinj_status_o                                                   <= c_RMAP_ERRINJ_STATUS_RST;
            spw_control_o.data                                                <= x"00";
            spw_control_o.flag                                                <= '0';
            spw_control_o.write                                               <= '0';
            s_reply_header_crc                                                <= x"00";
            s_reply_address_flag                                              <= '0';
        -- state transitions are always synchronous to the clock
        elsif (rising_edge(clk_i)) then
            case (s_rmap_target_reply_state) is

                -- state "IDLE"
                when IDLE =>
                    -- does nothing until user application signals it is ready to send a reply
                    -- default state transition
                    s_rmap_target_reply_state       <= IDLE;
                    v_rmap_target_reply_state       := IDLE;
                    s_rmap_target_reply_next_state  <= IDLE;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                    s_spw_control_write_enable      <= '1';
                    -- conditional state transition and internal signal values
                    -- check if the rmap error injection was enabled
                    if (errinj_control_i.rmap_error_trg = '1') then
                        -- the rmap error injection was enabled
                        -- check if the error can be activated in a reply and register the error
                        case (errinj_control_i.rmap_error_id) is
                            when (c_RMAP_ERRINJ_ERR_ID_INIT_LOG_ADDR) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INSTRUCTIONS) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_PKT_TYPE) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_WRITE_READ) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_VERIF_DATA) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_REPLY) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_INC_ADDR) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_INS_REPLY_ADDR_LEN) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_STATUS) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_TARG_LOG_ADDR) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_TRANSACTION_ID) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_DATA_LENGTH) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_HEADER_CRC) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_HEADER_EEP) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when (c_RMAP_ERRINJ_ERR_ID_MISSING_RESPONSE) =>
                                s_registered_rmap_errinj_control <= errinj_control_i;
                            when others =>
                                s_registered_rmap_errinj_control <= c_RMAP_ERRINJ_CONTROL_RST;
                        end case;
                    end if;
                    -- check if user application is ready to send a reply
                    if (control_i.send_reply = '1') then
                        -- user ready to send a reply
                        -- register the output headerdata
                        v_output_headerdata                          := headerdata_i;
                        v_output_headerdata.instructions.packet_type := "00";
                        -- check there is a registered error enabled
                        if (s_registered_rmap_errinj_control.rmap_error_trg = '1') then
                            -- there is a registered error enabled
                            -- apply and clear the registered error
                            case (s_registered_rmap_errinj_control.rmap_error_id) is
                                when (c_RMAP_ERRINJ_ERR_ID_INIT_LOG_ADDR) =>
                                    v_output_headerdata.initiator_logical_address      := s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_PKT_TYPE) =>
                                    v_output_headerdata.instructions.packet_type       := s_registered_rmap_errinj_control.rmap_error_val(1 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_WRITE_READ) =>
                                    v_output_headerdata.instructions.command.write_read := s_registered_rmap_errinj_control.rmap_error_val(0);
                                    s_registered_rmap_errinj_control                    <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied  <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_VERIF_DATA) =>
                                    v_output_headerdata.instructions.command.verify_data_before_write := s_registered_rmap_errinj_control.rmap_error_val(0);
                                    s_registered_rmap_errinj_control                                  <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied                <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_REPLY) =>
                                    v_output_headerdata.instructions.command.reply     := s_registered_rmap_errinj_control.rmap_error_val(0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_CMD_INC_ADDR) =>
                                    v_output_headerdata.instructions.command.increment_address := s_registered_rmap_errinj_control.rmap_error_val(0);
                                    s_registered_rmap_errinj_control                           <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied         <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_INS_REPLY_ADDR_LEN) =>
                                    v_output_headerdata.instructions.reply_address_length := s_registered_rmap_errinj_control.rmap_error_val(1 downto 0);
                                    s_registered_rmap_errinj_control                      <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied    <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_STATUS) =>
                                    v_output_headerdata.status                         := s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_TARG_LOG_ADDR) =>
                                    v_output_headerdata.target_logical_address         := s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_TRANSACTION_ID) =>
                                    v_output_headerdata.transaction_identifier(1)      := s_registered_rmap_errinj_control.rmap_error_val(15 downto 8);
                                    v_output_headerdata.transaction_identifier(0)      := s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_DATA_LENGTH) =>
                                    v_output_headerdata.data_length(2)                 := s_registered_rmap_errinj_control.rmap_error_val(23 downto 16);
                                    v_output_headerdata.data_length(1)                 := s_registered_rmap_errinj_control.rmap_error_val(15 downto 8);
                                    v_output_headerdata.data_length(0)                 := s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when (c_RMAP_ERRINJ_ERR_ID_MISSING_RESPONSE) =>
                                    s_spw_control_write_enable                         <= '0';
                                    s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                                    s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                                when others => null;
                            end case;
                        end if;
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
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    -- default internal signal values
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
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
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_REPLY_SPW_ADDRESS;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
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
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_PROTOCOL_IDENTIFIER;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_PROTOCOL_IDENTIFIER"
                when FIELD_PROTOCOL_IDENTIFIER =>
                    -- protocol identifier field, send protocol identifier to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_INSTRUCTION;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_INSTRUCTION"
                when FIELD_INSTRUCTION =>
                    -- instruction field, send instruction to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_STATUS;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_STATUS"
                when FIELD_STATUS =>
                    -- status field, send status to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_TARGET_LOGICAL_ADDRESS;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_TARGET_LOGICAL_ADDRESS"
                when FIELD_TARGET_LOGICAL_ADDRESS =>
                    -- target logical address field, send target logical address to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_TRANSACTION_IDENTIFIER;
                    -- default internal signal values
                    s_byte_counter                  <= 1;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_TRANSACTION_IDENTIFIER"
                when FIELD_TRANSACTION_IDENTIFIER =>
                    -- transaction identifier field, send transaction identifier to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_TRANSACTION_IDENTIFIER;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
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
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_DATA_LEGNTH;
                    -- default internal signal values
                    s_byte_counter                  <= 2;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "FIELD_DATA_LEGNTH"
                when FIELD_DATA_LEGNTH =>
                    -- data length field, send data length to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    s_rmap_target_reply_next_state  <= FIELD_DATA_LEGNTH;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
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
                    s_rmap_target_reply_state       <= WAITING_BUFFER_SPACE;
                    v_rmap_target_reply_state       := WAITING_BUFFER_SPACE;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                    -- conditional state transition and internal signal values
                    -- check if it is a write reply or a read reply
                    if (headerdata_i.instructions.command.write_read = '1') then
                        -- write reply, next field to be written is the eop
                        s_rmap_target_reply_next_state <= FIELD_EOP;
                    else
                        -- read reply, next field to be written is a data field
                        -- check if the read command was authorized
                        if (headerdata_i.status = c_ERROR_CODE_COMMAND_EXECUTED_SUCCESSFULLY) then
                            -- the read command was authorized
                            -- next field to be written is a data field, go to reply finish generation
                            s_rmap_target_reply_next_state <= REPLY_FINISH_GENERATION;
                        else
                            -- the read command was not authorized
                            -- reply will not have a data field, go to field eop
                            s_rmap_target_reply_next_state <= FIELD_EOP;
                        end if;
                    end if;

                -- state "FIELD_EOP"
                when FIELD_EOP =>
                    -- eop field, send eop to initiator
                    -- default state transition
                    s_rmap_target_reply_state       <= REPLY_FINISH_GENERATION;
                    v_rmap_target_reply_state       := REPLY_FINISH_GENERATION;
                    s_rmap_target_reply_next_state  <= IDLE;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
                -- conditional state transition and internal signal values

                -- state "REPLY_FINISH_GENERATION"
                when REPLY_FINISH_GENERATION =>
                    -- finish reply generation
                    -- default state transition
                    s_rmap_target_reply_state       <= REPLY_FINISH_GENERATION;
                    v_rmap_target_reply_state       := REPLY_FINISH_GENERATION;
                    s_rmap_target_reply_next_state  <= IDLE;
                    -- default internal signal values
                    s_byte_counter                  <= 0;
                    s_registered_rmap_errinj_status <= c_RMAP_ERRINJ_STATUS_RST;
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

            -- check if an error injection reset was requested
            if (errinj_rst_i = '1') then
                -- an error injection reset was requested
                -- clear the registered error injection control 
                s_registered_rmap_errinj_control <= c_RMAP_ERRINJ_CONTROL_RST;
            end if;

            --=============================================================================
            -- Begin of RMAP Target Reply Finite State Machine
            -- (output generation)
            --=============================================================================
            -- read: s_rmap_target_reply_state, rst_i
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
                    errinj_status_o        <= s_registered_rmap_errinj_status;
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
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw tx write signal
                    spw_control_o.write    <= '0';
                -- conditional output signals

                -- state "FIELD_REPLY_SPW_ADDRESS"
                when FIELD_REPLY_SPW_ADDRESS =>
                    -- reply spw address field, send reply spw address to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
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
                        spw_control_o.data   <= v_output_headerdata.reply_spw_address(s_byte_counter);
                        -- write the spw data
                        spw_control_o.write  <= s_spw_control_write_enable;
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
                                spw_control_o.write <= s_spw_control_write_enable;
                            end if;
                        -- if not last reply spw address, the data is a leading zero and will be ignored
                        else
                            -- data is not a zero, leading zeros are over
                            -- flag that a non-zero reply spw address data arrived
                            s_reply_address_flag <= '1';
                            -- fill spw data with field data
                            spw_control_o.data   <= v_output_headerdata.reply_spw_address(s_byte_counter);
                            -- write the spw data
                            spw_control_o.write  <= s_spw_control_write_enable;
                        end if;
                    end if;

                -- state "FIELD_INITIATOR_LOGICAL_ADDRESS"
                when FIELD_INITIATOR_LOGICAL_ADDRESS =>
                    -- initiator logical address field, send initiator logical address to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with field data
                    spw_control_o.data     <= v_output_headerdata.initiator_logical_address;
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, v_output_headerdata.initiator_logical_address);
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_PROTOCOL_IDENTIFIER"
                when FIELD_PROTOCOL_IDENTIFIER =>
                    -- protocol identifier field, send protocol identifier to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with the rmap protocol identifier (0x01)
                    spw_control_o.data     <= x"01";
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, x"01");
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_INSTRUCTION"
                when FIELD_INSTRUCTION =>
                    -- instruction field, send instruction to initiator
                    -- default output signals
                    flags_o.reply_busy             <= '1';
                    flags_o.reply_finished         <= '0';
                    errinj_status_o                <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag             <= '0';
                    -- fill spw data with field data
                    -- packet type = 0b00 (reply packet)
                    spw_control_o.data(7 downto 6) <= v_output_headerdata.instructions.packet_type;
                    -- same command field as the command 
                    spw_control_o.data(5)          <= v_output_headerdata.instructions.command.write_read;
                    spw_control_o.data(4)          <= v_output_headerdata.instructions.command.verify_data_before_write;
                    spw_control_o.data(3)          <= v_output_headerdata.instructions.command.reply;
                    spw_control_o.data(2)          <= v_output_headerdata.instructions.command.increment_address;
                    -- same reply address length as the command
                    spw_control_o.data(1 downto 0) <= v_output_headerdata.instructions.reply_address_length;
                    -- update crc calculation
                    s_reply_header_crc             <= RMAP_CalculateCRC(s_reply_header_crc, ("00" & v_output_headerdata.instructions.command.write_read & v_output_headerdata.instructions.command.verify_data_before_write & v_output_headerdata.instructions.command.reply & v_output_headerdata.instructions.command.increment_address & v_output_headerdata.instructions.reply_address_length));
                    -- write the spw data
                    spw_control_o.write            <= s_spw_control_write_enable;
                    -- conditional output signals
                    -- check if a rmap error injection is enabled and is for the entire instructions field
                    if ((s_registered_rmap_errinj_control.rmap_error_trg = '1') and (s_registered_rmap_errinj_control.rmap_error_id = c_RMAP_ERRINJ_ERR_ID_INSTRUCTIONS)) then
                        -- a rmap error injection is enabled and is for the entire instructions field
                        -- inject error at instruction field
                        spw_control_o.data                                 <= s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                        -- update crc calculation
                        s_reply_header_crc                                 <= RMAP_CalculateCRC(s_reply_header_crc, s_registered_rmap_errinj_control.rmap_error_val(7 downto 0));
                        -- clear the registered error control
                        s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                        -- set the registered error applied
                        s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                    end if;

                -- state "FIELD_STATUS"
                when FIELD_STATUS =>
                    -- status field, send status to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with field data
                    spw_control_o.data     <= v_output_headerdata.status;
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, v_output_headerdata.status);
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_TARGET_LOGICAL_ADDRESS"
                when FIELD_TARGET_LOGICAL_ADDRESS =>
                    -- target logical address field, send target logical address to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with field data
                    spw_control_o.data     <= v_output_headerdata.target_logical_address;
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, v_output_headerdata.target_logical_address);
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_TRANSACTION_IDENTIFIER"
                when FIELD_TRANSACTION_IDENTIFIER =>
                    -- transaction identifier field, send transaction identifier to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with the reserved field data (0x00)
                    spw_control_o.data     <= v_output_headerdata.transaction_identifier(s_byte_counter);
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, v_output_headerdata.transaction_identifier(s_byte_counter));
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_RESERVED"
                when FIELD_RESERVED =>
                    -- reserved field, send reserved to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with the reserved field data (0x00)
                    spw_control_o.data     <= x"00";
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, x"00");
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_DATA_LEGNTH"
                when FIELD_DATA_LEGNTH =>
                    -- data length field, send data length to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with the reserved field data (0x00)
                    spw_control_o.data     <= v_output_headerdata.data_length(s_byte_counter);
                    -- update crc calculation
                    s_reply_header_crc     <= RMAP_CalculateCRC(s_reply_header_crc, v_output_headerdata.data_length(s_byte_counter));
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                -- conditional output signals

                -- state "FIELD_HEADER_CRC"
                when FIELD_HEADER_CRC =>
                    -- header crc field, send header crc to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- clear spw flag (to indicate a data)
                    spw_control_o.flag     <= '0';
                    -- fill spw data with field data
                    spw_control_o.data     <= s_reply_header_crc;
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                    -- conditional output signals
                    -- check if a rmap error injection is enabled and is for header crc
                    if ((s_registered_rmap_errinj_control.rmap_error_trg = '1') and (s_registered_rmap_errinj_control.rmap_error_id = c_RMAP_ERRINJ_ERR_ID_HEADER_CRC)) then
                        -- a rmap error injection is enabled and is for header crc
                        -- inject error at header crc
                        spw_control_o.data                                 <= s_registered_rmap_errinj_control.rmap_error_val(7 downto 0);
                        -- clear the registered error control
                        s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                        -- set the registered error applied
                        s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                    end if;

                -- state "FIELD_EOP"
                when FIELD_EOP =>
                    -- eop field, send eop to initiator
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    flags_o.reply_finished <= '0';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
                    -- set spw flag (to indicate a package end)
                    spw_control_o.flag     <= '1';
                    -- fill spw data with the eop identifier (0x00)
                    spw_control_o.data     <= c_EOP_VALUE;
                    -- write the spw data
                    spw_control_o.write    <= s_spw_control_write_enable;
                    -- conditional output signals
                    -- check if a rmap error injection is enabled and is to send a header eep
                    if ((s_registered_rmap_errinj_control.rmap_error_trg = '1') and (s_registered_rmap_errinj_control.rmap_error_id = c_RMAP_ERRINJ_ERR_ID_HEADER_EEP)) then
                        -- a rmap error injection is enabled and is to send a header eep
                        -- inject header eep error
                        spw_control_o.data                                 <= c_EEP_VALUE;
                        -- clear the registered error control
                        s_registered_rmap_errinj_control                   <= c_RMAP_ERRINJ_CONTROL_RST;
                        -- set the registered error applied
                        s_registered_rmap_errinj_status.rmap_error_applied <= '1';
                    end if;

                -- state "REPLY_FINISH_GENERATION"
                when REPLY_FINISH_GENERATION =>
                    -- finish reply generation
                    -- default output signals
                    flags_o.reply_busy     <= '1';
                    -- indicate that the reply generation is finished
                    flags_o.reply_finished <= '1';
                    errinj_status_o        <= s_registered_rmap_errinj_status;
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
