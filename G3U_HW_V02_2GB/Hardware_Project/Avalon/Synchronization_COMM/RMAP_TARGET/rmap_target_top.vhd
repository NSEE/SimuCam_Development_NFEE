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
--! 09\01\2018 CB Generics completion\n
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
		clk_i                      : in  std_logic; --! Local rmap clock
		rst_i                      : in  std_logic; --! Reset = '0': no reset; Reset = '1': reset active

		spw_flag_i                 : in  t_rmap_target_spw_flag;
		mem_flag_i                 : in  t_rmap_target_mem_flag;
		conf_target_enable_i       : in  std_logic;
		conf_target_logical_addr_i : in  std_logic_vector(7 downto 0);
		conf_target_key_i          : in  std_logic_vector(7 downto 0);
		rmap_errinj_en_i           : in  std_logic;
		rmap_errinj_id_i           : in  std_logic_vector(3 downto 0);
		rmap_errinj_val_i          : in  std_logic_vector(31 downto 0);
		-- global output signals

		spw_control_o              : out t_rmap_target_spw_control;
		mem_control_o              : out t_rmap_target_mem_control;
		mem_wr_byte_address_o      : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0);
		mem_rd_byte_address_o      : out std_logic_vector((g_MEMORY_ADDRESS_WIDTH + g_MEMORY_ACCESS_WIDTH - 1) downto 0);
		stat_command_received_o    : out std_logic;
		stat_write_requested_o     : out std_logic;
		stat_write_authorized_o    : out std_logic;
		stat_write_finished_o      : out std_logic;
		stat_read_requested_o      : out std_logic;
		stat_read_authorized_o     : out std_logic;
		stat_read_finished_o       : out std_logic;
		stat_reply_sended_o        : out std_logic;
		stat_discarded_package_o   : out std_logic;
		err_early_eop_o            : out std_logic;
		err_eep_o                  : out std_logic;
		err_header_crc_o           : out std_logic;
		err_unused_packet_type_o   : out std_logic;
		err_invalid_command_code_o : out std_logic;
		err_too_much_data_o        : out std_logic;
		err_invalid_data_crc_o     : out std_logic
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

	signal s_target_dis_rd_spw_rx_control : t_rmap_target_spw_rx_control;

	signal s_target_spw_rx_flag : t_rmap_target_spw_rx_flag;

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
			rst_i                                 => rst_i,
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
			rst_i                                  => rst_i,
			control_i                              => s_rmap_target_control.command_parsing,
			spw_flag_i                             => s_target_spw_rx_flag,
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
			rst_i                                             => rst_i,
			control_i                                         => s_rmap_target_control.write_operation,
			headerdata_i.instruction_verify_data_before_write => s_rmap_target_rmap_data.instructions.command.verify_data_before_write,
			headerdata_i.instruction_increment_address        => s_rmap_target_rmap_data.instructions.command.increment_address,
			headerdata_i.extended_address                     => s_rmap_target_rmap_data.extended_address,
			headerdata_i.address                              => s_rmap_target_rmap_data.address,
			headerdata_i.data_length                          => s_rmap_target_rmap_data.data_length,
			spw_flag_i                                        => s_target_spw_rx_flag,
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
			g_DATA_LENGTH_WIDTH    => g_DATA_LENGTH_WIDTH,
			g_MEMORY_ACCESS_WIDTH  => g_MEMORY_ACCESS_WIDTH
		)
		port map(
			clk_i                                      => clk_i,
			rst_i                                      => rst_i,
			control_i                                  => s_rmap_target_control.read_operation,
			headerdata_i.instruction_increment_address => s_rmap_target_rmap_data.instructions.command.increment_address,
			headerdata_i.extended_address              => s_rmap_target_rmap_data.extended_address,
			headerdata_i.address                       => s_rmap_target_rmap_data.address,
			headerdata_i.data_length                   => s_rmap_target_rmap_data.data_length,
			errinj_i.rmap_error_en                     => rmap_errinj_en_i,
			errinj_i.rmap_error_id                     => rmap_errinj_id_i,
			errinj_i.rmap_error_val                    => rmap_errinj_val_i,
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
			rst_i                                  => rst_i,
			control_i                              => s_rmap_target_control.reply_geneneration,
			headerdata_i.reply_spw_address         => s_rmap_target_rmap_data.reply_address,
			headerdata_i.initiator_logical_address => s_rmap_target_rmap_data.initiator_logical_address,
			headerdata_i.instructions              => s_rmap_target_rmap_data.instructions,
			headerdata_i.status                    => s_rmap_target_rmap_data.status,
			headerdata_i.target_logical_address    => s_rmap_target_rmap_data.target_logical_address,
			headerdata_i.transaction_identifier    => s_rmap_target_rmap_data.transaction_identifier,
			headerdata_i.data_length               => s_rmap_target_rmap_data.data_length,
			errinj_i.rmap_error_en                 => rmap_errinj_en_i,
			errinj_i.rmap_error_id                 => rmap_errinj_id_i,
			errinj_i.rmap_error_val                => rmap_errinj_val_i,
			spw_flag_i                             => spw_flag_i.transmitter,
			flags_o                                => s_rmap_target_flags.reply_geneneration,
			--			error_o                                => s_rmap_target_error.dummy,
			spw_control_o                          => s_rmap_target_spw_reply_tx_control
		);

	--============================================================================
	-- Beginning of p_rmap_target_top
	--! Top Process for RMAP Target Codec, responsible for general reset 
	--! and registering inputs and outputs
	--! read: clk_i, rst_i \n
	--! write: - \n
	--! r/w: - \n
	--============================================================================
	--	p_rmap_target_top_process : process(clk_i)
	--	begin
	--		if (rst_i = '1') then       -- asynchronous reset
	--			-- reset to default value
	--
	--		elsif (rising_edge(clk_i)) then -- synchronous process
	--			-- generate clock signal and LED output
	--		end if;
	--	end process p_rmap_target_top_process;

	-- RMAP Target Disabled Reader
	p_rmap_target_disabled_reader : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_target_dis_rd_spw_rx_control.read <= '0';
		elsif rising_edge(clk_i) then
			s_target_dis_rd_spw_rx_control.read <= '0';
			-- check if the target is disabled and the spw codec has valid data
			if ((conf_target_enable_i = '0') and (spw_flag_i.receiver.valid = '1')) then
				-- the target is disabled and the spw codec has valid data
				-- read spw codec data
				s_target_dis_rd_spw_rx_control.read <= '1';
			end if;
		end if;
	end process p_rmap_target_disabled_reader;

	-- signals assignments --

	-- spw rx flags signals assignments
	s_target_spw_rx_flag.valid <= (spw_flag_i.receiver.valid) and (conf_target_enable_i); -- if the target is disabled, the spw rxvalid flag will be masked
	s_target_spw_rx_flag.flag  <= spw_flag_i.receiver.flag;
	s_target_spw_rx_flag.data  <= spw_flag_i.receiver.data;
	s_target_spw_rx_flag.error <= spw_flag_i.receiver.error;

	-- error signals assignments
	s_rmap_target_rmap_error.early_eop            <= (s_rmap_target_error.command_parsing.early_eop) or (s_rmap_target_error.write_operation.early_eop);
	s_rmap_target_rmap_error.eep                  <= (s_rmap_target_error.command_parsing.eep) or (s_rmap_target_error.write_operation.eep);
	s_rmap_target_rmap_error.header_crc           <= s_rmap_target_error.command_parsing.header_crc;
	s_rmap_target_rmap_error.invalid_command_code <= s_rmap_target_error.command_parsing.invalid_command_code;
	s_rmap_target_rmap_error.unused_packet_type   <= s_rmap_target_error.command_parsing.unused_packet_type;
	s_rmap_target_rmap_error.too_much_data        <= (s_rmap_target_error.command_parsing.too_much_data) or (s_rmap_target_error.write_operation.too_much_data);
	s_rmap_target_rmap_error.invalid_data_crc     <= s_rmap_target_error.write_operation.invalid_data_crc;

	-- spw control signals assignments
	spw_control_o.receiver.read     <= (s_rmap_target_spw_command_rx_control.read) or (s_rmap_target_spw_write_rx_control.read) or (s_target_dis_rd_spw_rx_control.read);
	spw_control_o.transmitter.flag  <= (s_rmap_target_spw_read_tx_control.flag) or (s_rmap_target_spw_reply_tx_control.flag);
	spw_control_o.transmitter.data  <= (s_rmap_target_spw_read_tx_control.data) or (s_rmap_target_spw_reply_tx_control.data);
	spw_control_o.transmitter.write <= (s_rmap_target_spw_read_tx_control.write) or (s_rmap_target_spw_reply_tx_control.write);

	-- inputs assignments
	s_rmap_target_user_configs.user_key                    <= conf_target_key_i;
	s_rmap_target_user_configs.user_target_logical_address <= conf_target_logical_addr_i;

	-- outputs assignments
	stat_command_received_o    <= s_rmap_target_flags.command_parsing.command_received;
	stat_write_requested_o     <= s_rmap_target_flags.command_parsing.write_request;
	stat_write_authorized_o    <= s_rmap_target_control.write_operation.write_authorization;
	stat_write_finished_o      <= s_rmap_target_flags.write_operation.write_data_indication;
	stat_read_requested_o      <= s_rmap_target_flags.command_parsing.read_request;
	stat_read_authorized_o     <= s_rmap_target_control.read_operation.read_authorization;
	stat_read_finished_o       <= s_rmap_target_flags.read_operation.read_data_indication;
	stat_reply_sended_o        <= s_rmap_target_flags.reply_geneneration.reply_finished;
	stat_discarded_package_o   <= s_rmap_target_flags.command_parsing.discarded_package;
	--
	err_early_eop_o            <= s_rmap_target_rmap_error.early_eop;
	err_eep_o                  <= s_rmap_target_rmap_error.eep;
	err_header_crc_o           <= s_rmap_target_rmap_error.header_crc;
	err_unused_packet_type_o   <= s_rmap_target_rmap_error.unused_packet_type;
	err_invalid_command_code_o <= s_rmap_target_rmap_error.invalid_command_code;
	err_too_much_data_o        <= s_rmap_target_rmap_error.too_much_data;
	err_invalid_data_crc_o     <= s_rmap_target_rmap_error.invalid_data_crc;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
