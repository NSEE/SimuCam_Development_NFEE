--=============================================================================
--! @file rmap_target_top.vhd
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
-- unit name: RMAP Target Top (rmap_target_top)
--
--! @brief Top entity for the RMAP Target Codec developed to be used at  
--! Simucam. Suports Write and Read operations.
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
--! Entity declaration for RMAP Target Top
--============================================================================

entity rmap_target_top is
	generic(
		g_VERIFY_BUFFER_WIDTH  : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 8;
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_DATA_LENGTH_WIDTH    : natural range 0 to c_WIDTH_DATA_LENGTH      := 24;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2 -- 32 bits data
	);
	port(
		-- Global input signals
		--! Local clock used by the RMAP Codec
		clk_i                 : in  std_logic; --! Local rmap clock
		reset_n_i             : in  std_logic; --! Reset = '0': reset active; Reset = '1': no reset

		spw_flag_i            : in  t_rmap_target_spw_flag;
		mem_flag_i            : in  t_rmap_target_mem_flag;
		-- global output signals

		spw_control_o         : out t_rmap_target_spw_control;
		mem_control_o         : out t_rmap_target_mem_control;
		mem_wr_byte_address_o : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0);
		mem_rd_byte_address_o : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0)
		-- data bus(es)
	);
end entity rmap_target_top;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of rmap_target_top is

	signal s_rmap_target_control : t_rmap_target_control;
	signal s_rmap_target_flags   : t_rmap_target_flags;
	signal s_rmap_target_error   : t_rmap_target_error;

	signal s_rmap_target_rmap_data  : t_rmap_target_rmap_data;
	signal s_rmap_target_rmap_error : t_rmap_target_rmap_error;

	signal s_rmap_target_spw_command_rx_control : t_rmap_target_spw_rx_control;
	signal s_rmap_target_spw_write_rx_control   : t_rmap_target_spw_rx_control;
	signal s_rmap_target_spw_read_tx_control    : t_rmap_target_spw_tx_control;
	signal s_rmap_target_spw_reply_tx_control   : t_rmap_target_spw_tx_control;

	signal s_rmap_target_user_configs : t_rmap_target_user_configs;

	--============================================================================
	-- architecture begin
	--============================================================================
begin

	rmap_target_user_ent_inst : entity work.rmap_target_user_ent
		generic map(
			g_VERIFY_BUFFER_WIDTH  => g_VERIFY_BUFFER_WIDTH,
			g_MEMORY_ADDRESS_WIDTH => g_MEMORY_ADDRESS_WIDTH,
			g_DATA_LENGTH_WIDTH    => g_DATA_LENGTH_WIDTH
		)
		port map(
			clk_i                                 => clk_i,
			reset_n_i                             => reset_n_i,
			flags_i                               => s_rmap_target_flags,
			error_i                               => s_rmap_target_rmap_error,
			codecdata_i.target_logical_address    => s_rmap_target_rmap_data.target_logical_address,
			codecdata_i.instructions              => s_rmap_target_rmap_data.instructions,
			codecdata_i.key                       => s_rmap_target_rmap_data.key,
			codecdata_i.initiator_logical_address => s_rmap_target_rmap_data.initiator_logical_address,
			codecdata_i.transaction_identifier    => s_rmap_target_rmap_data.transaction_identifier,
			codecdata_i.extended_address          => s_rmap_target_rmap_data.extended_address,
			codecdata_i.memory_address            => s_rmap_target_rmap_data.address,
			codecdata_i.data_length               => s_rmap_target_rmap_data.data_length,
			configs_i                             => s_rmap_target_user_configs,
			control_o                             => s_rmap_target_control,
			reply_status                          => s_rmap_target_rmap_data.status
		);

	rmap_target_command_ent_inst : entity work.rmap_target_command_ent
		port map(
			clk_i                                  => clk_i,
			reset_n_i                              => reset_n_i,
			control_i                              => s_rmap_target_control.command_parsing,
			spw_flag_i                             => spw_flag_i.receiver,
			flags_o                                => s_rmap_target_flags.command_parsing,
			error_o                                => s_rmap_target_error.command_parsing,
			headerdata_o.target_logical_address    => s_rmap_target_rmap_data.target_logical_address,
			headerdata_o.instructions              => s_rmap_target_rmap_data.instructions,
			headerdata_o.key                       => s_rmap_target_rmap_data.key,
			headerdata_o.reply_address             => s_rmap_target_rmap_data.reply_address,
			headerdata_o.initiator_logical_address => s_rmap_target_rmap_data.initiator_logical_address,
			headerdata_o.transaction_identifier    => s_rmap_target_rmap_data.transaction_identifier,
			headerdata_o.extended_address          => s_rmap_target_rmap_data.extended_address,
			headerdata_o.address                   => s_rmap_target_rmap_data.address,
			headerdata_o.data_length               => s_rmap_target_rmap_data.data_length,
			spw_control_o                          => s_rmap_target_spw_command_rx_control
		);

	rmap_target_write_ent_inst : entity work.rmap_target_write_ent
		generic map(
			g_VERIFY_BUFFER_WIDTH  => g_VERIFY_BUFFER_WIDTH,
			g_MEMORY_ADDRESS_WIDTH => g_MEMORY_ADDRESS_WIDTH,
			g_DATA_LENGTH_WIDTH    => g_DATA_LENGTH_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => g_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i                                             => clk_i,
			reset_n_i                                         => reset_n_i,
			control_i                                         => s_rmap_target_control.write_operation,
			headerdata_i.instruction_verify_data_before_write => s_rmap_target_rmap_data.instructions.command.verify_data_before_write,
			headerdata_i.instruction_increment_address        => s_rmap_target_rmap_data.instructions.command.increment_address,
			headerdata_i.extended_address                     => s_rmap_target_rmap_data.extended_address,
			headerdata_i.address                              => s_rmap_target_rmap_data.address,
			headerdata_i.data_length                          => s_rmap_target_rmap_data.data_length,
			spw_flag_i                                        => spw_flag_i.receiver,
			mem_flag_i                                        => mem_flag_i.write,
			flags_o                                           => s_rmap_target_flags.write_operation,
			error_o                                           => s_rmap_target_error.write_operation,
			spw_control_o                                     => s_rmap_target_spw_write_rx_control,
			mem_control_o                                     => mem_control_o.write,
			mem_byte_address_o                                => mem_wr_byte_address_o
		);

	rmap_target_read_ent_inst : entity work.rmap_target_read_ent
		generic map(
			g_MEMORY_ADDRESS_WIDTH => g_MEMORY_ADDRESS_WIDTH,
			g_DATA_LENGTH_WIDTH    => g_DATA_LENGTH_WIDTH
		)
		port map(
			clk_i                                      => clk_i,
			reset_n_i                                  => reset_n_i,
			control_i                                  => s_rmap_target_control.read_operation,
			headerdata_i.instruction_increment_address => s_rmap_target_rmap_data.instructions.command.increment_address,
			headerdata_i.extended_address              => s_rmap_target_rmap_data.extended_address,
			headerdata_i.address                       => s_rmap_target_rmap_data.address,
			headerdata_i.data_length                   => s_rmap_target_rmap_data.data_length,
			spw_flag_i                                 => spw_flag_i.transmitter,
			mem_flag_i                                 => mem_flag_i.read,
			flags_o                                    => s_rmap_target_flags.read_operation,
			--			error_o                                    => s_rmap_target_error.dummy,
			spw_control_o                              => s_rmap_target_spw_read_tx_control,
			mem_control_o                              => mem_control_o.read,
			mem_byte_address_o                         => mem_rd_byte_address_o
		);

	rmap_target_reply_ent_inst : entity work.rmap_target_reply_ent
		port map(
			clk_i                                  => clk_i,
			reset_n_i                              => reset_n_i,
			control_i                              => s_rmap_target_control.reply_geneneration,
			headerdata_i.reply_spw_address         => s_rmap_target_rmap_data.reply_address,
			headerdata_i.initiator_logical_address => s_rmap_target_rmap_data.initiator_logical_address,
			headerdata_i.instructions              => s_rmap_target_rmap_data.instructions,
			headerdata_i.status                    => s_rmap_target_rmap_data.status,
			headerdata_i.target_logical_address    => s_rmap_target_rmap_data.target_logical_address,
			headerdata_i.transaction_identifier    => s_rmap_target_rmap_data.transaction_identifier,
			headerdata_i.data_length               => s_rmap_target_rmap_data.data_length,
			spw_flag_i                             => spw_flag_i.transmitter,
			flags_o                                => s_rmap_target_flags.reply_geneneration,
			--			error_o                                => s_rmap_target_error.dummy,
			spw_control_o                          => s_rmap_target_spw_reply_tx_control
		);

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, reset_n_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================
	p_rmap_target_top_process : process(clk_i)
	begin
		if (reset_n_i = '0') then       -- asynchronous reset
			-- reset to default value
			s_rmap_target_user_configs.user_key                    <= x"00";
			s_rmap_target_user_configs.user_target_logical_address <= x"FE";
		elsif (rising_edge(clk_i)) then -- synchronous process
			-- generate clock signal and LED output
		end if;
	end process p_rmap_target_top_process;

	-- signals assingment

	-- error signals
	s_rmap_target_rmap_error.early_eop            <= (s_rmap_target_error.command_parsing.early_eop) or (s_rmap_target_error.write_operation.early_eop);
	s_rmap_target_rmap_error.eep                  <= (s_rmap_target_error.command_parsing.eep) or (s_rmap_target_error.write_operation.eep);
	s_rmap_target_rmap_error.header_crc           <= s_rmap_target_error.command_parsing.header_crc;
	s_rmap_target_rmap_error.invalid_command_code <= s_rmap_target_error.command_parsing.invalid_command_code;
	s_rmap_target_rmap_error.unused_packet_type   <= s_rmap_target_error.command_parsing.unused_packet_type;
	s_rmap_target_rmap_error.too_much_data        <= (s_rmap_target_error.command_parsing.too_much_data) or (s_rmap_target_error.write_operation.too_much_data);
	s_rmap_target_rmap_error.invalid_data_crc     <= s_rmap_target_error.write_operation.invalid_data_crc;

	-- spw control signals
	spw_control_o.receiver.read     <= (s_rmap_target_spw_command_rx_control.read) or (s_rmap_target_spw_write_rx_control.read);
	spw_control_o.transmitter.flag  <= (s_rmap_target_spw_read_tx_control.flag) or (s_rmap_target_spw_reply_tx_control.flag);
	spw_control_o.transmitter.data  <= (s_rmap_target_spw_read_tx_control.data) or (s_rmap_target_spw_reply_tx_control.data);
	spw_control_o.transmitter.write <= (s_rmap_target_spw_read_tx_control.write) or (s_rmap_target_spw_reply_tx_control.write);

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
