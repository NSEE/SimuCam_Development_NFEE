--TODO Reestruturar / Reorganizar e comentar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_codec_controller_ent is
	port(
		clk100                              : in  std_logic;
		clk200                              : in  std_logic;
		rst                                 : in  std_logic;
		spwc_mm_write_registers             : in  spwc_mm_write_registers_type;
		spwc_mm_read_registers              : out spwc_mm_read_registers_type;
		spwc_rx_data_dc_fifo_clk200_outputs : in  spwc_rx_data_dc_fifo_clk200_outputs_type;
		spwc_rx_data_dc_fifo_clk200_inputs  : out spwc_rx_data_dc_fifo_clk200_inputs_type;
		spwc_tx_data_dc_fifo_clk200_outputs : in  spwc_tx_data_dc_fifo_clk200_outputs_type;
		spwc_tx_data_dc_fifo_clk200_inputs  : out spwc_tx_data_dc_fifo_clk200_inputs_type;
		spwc_codec_ds_encoding_rx_in        : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_out       : out spwc_codec_ds_encoding_tx_out_type
	);
end entity spwc_codec_controller_ent;

architecture spwc_codec_controller_arc of spwc_codec_controller_ent is

	signal spwc_codec_link_command_in_sig    : spwc_codec_link_command_in_type;
	signal spwc_codec_link_status_out_sig    : spwc_codec_link_status_out_type;
	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;
	signal spwc_codec_link_error_out_sig     : spwc_codec_link_error_out_type;
	signal spwc_codec_timecode_rx_out_sig    : spwc_codec_timecode_rx_out_type;
	signal spwc_codec_timecode_tx_in_sig     : spwc_codec_timecode_tx_in_type;
	signal spwc_codec_data_rx_in_sig         : spwc_codec_data_rx_in_type;
	signal spwc_codec_data_rx_out_sig        : spwc_codec_data_rx_out_type;
	signal spwc_codec_data_tx_in_sig         : spwc_codec_data_tx_in_type;
	signal spwc_codec_data_tx_out_sig        : spwc_codec_data_tx_out_type;

	signal interrupts_flags_sig : spwc_interrupt_register_type;

	signal codec_enable_sig    : std_logic := '0';
	signal codec_rx_enable_sig : std_logic := '0';
	signal codec_tx_enable_sig : std_logic := '0';
	signal loopback_mode_sig   : std_logic := '0';

	signal codec_rxread_sig      : std_logic := '0';
	signal codec_txwrite_sig     : std_logic := '0';
	signal timecode_tick_out_sig : std_logic := '0';
	signal timecode_tick_in_sig  : std_logic := '0';
	signal timecode_tick_in_flag : std_logic := '0';

	signal spwc_codec_reset_in_sig : std_logic := '0';
	signal codec_reset_sig         : std_logic := '0';

	signal rx_data : spwc_rx_data_dc_fifo_data_type;
	signal tx_data : spwc_tx_data_dc_fifo_data_type;

	signal rx_dc_fifo_wreq_sig : std_logic := '0';
	signal tx_dc_fifo_rdeq_sig : std_logic := '0';

	type codec_command_dc_fifo_type is record
		data_in     : std_logic_vector(23 downto 0);
		write       : std_logic;
		write_empty : std_logic;
		write_full  : std_logic;
		data_out    : std_logic_vector(23 downto 0);
		read        : std_logic;
		read_empty  : std_logic;
		read_full   : std_logic;
	end record codec_command_dc_fifo_type;

	signal clk100_codec_commands_dc_fifo_sig : codec_command_dc_fifo_type;
	signal clk200_codec_commands_dc_fifo_sig : codec_command_dc_fifo_type;

	signal clk100_codec_commands_valid : std_logic := '0';
	signal clk200_codec_commands_valid : std_logic := '0';

	signal clk100_codec_commands_dc_fifo_write_sig : std_logic := '0';
	signal clk200_codec_commands_dc_fifo_write_sig : std_logic := '0';

begin

	spwc_codec_ent_inst : entity work.spwc_codec_ent
		port map(
			clk_200                       => clk200,
			rst                           => spwc_codec_reset_in_sig,
			spwc_codec_link_command_in    => spwc_codec_link_command_in_sig,
			spwc_codec_link_status_out    => spwc_codec_link_status_out_sig,
			spwc_codec_ds_encoding_rx_in  => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_out => spwc_codec_ds_encoding_tx_out_sig,
			spwc_codec_link_error_out     => spwc_codec_link_error_out_sig,
			spwc_codec_timecode_rx_out    => spwc_codec_timecode_rx_out_sig,
			spwc_codec_timecode_tx_in     => spwc_codec_timecode_tx_in_sig,
			spwc_codec_data_rx_in         => spwc_codec_data_rx_in_sig,
			spwc_codec_data_rx_out        => spwc_codec_data_rx_out_sig,
			spwc_codec_data_tx_in         => spwc_codec_data_tx_in_sig,
			spwc_codec_data_tx_out        => spwc_codec_data_tx_out_sig
		);

	clk100_codec_commands_dc_fifo_inst : entity work.codec_commands_dc_fifo -- Convert from clk100 to clk200
		port map(
			aclr    => rst,
			data    => clk100_codec_commands_dc_fifo_sig.data_in,
			rdclk   => clk200,
			rdreq   => clk100_codec_commands_dc_fifo_sig.read,
			wrclk   => clk100,
			wrreq   => clk100_codec_commands_dc_fifo_sig.write,
			q       => clk100_codec_commands_dc_fifo_sig.data_out,
			rdempty => clk100_codec_commands_dc_fifo_sig.read_empty,
			rdfull  => clk100_codec_commands_dc_fifo_sig.read_full,
			wrempty => clk100_codec_commands_dc_fifo_sig.write_empty,
			wrfull  => clk100_codec_commands_dc_fifo_sig.write_full
		);

	clk200_codec_commands_dc_fifo_inst : entity work.codec_commands_dc_fifo -- Convert from clk200 to clk100
		port map(
			aclr    => rst,
			data    => clk200_codec_commands_dc_fifo_sig.data_in,
			rdclk   => clk100,
			rdreq   => clk200_codec_commands_dc_fifo_sig.read,
			wrclk   => clk200,
			wrreq   => clk200_codec_commands_dc_fifo_sig.write,
			q       => clk200_codec_commands_dc_fifo_sig.data_out,
			rdempty => clk200_codec_commands_dc_fifo_sig.read_empty,
			rdfull  => clk200_codec_commands_dc_fifo_sig.read_full,
			wrempty => clk200_codec_commands_dc_fifo_sig.write_empty,
			wrfull  => clk200_codec_commands_dc_fifo_sig.write_full
		);

		-- Operações com o clock avalon
	spwc_codec_controller_clk100_proc : process(clk100, rst) is
	begin
		if (rst = '1') then
			codec_enable_sig                         <= '0';
			codec_rx_enable_sig                      <= '0';
			codec_tx_enable_sig                      <= '0';
			loopback_mode_sig                        <= '0';
--			spwc_codec_link_command_in_sig.autostart <= '0';
--			spwc_codec_link_command_in_sig.linkstart <= '0';
--			spwc_codec_link_command_in_sig.linkdis   <= '0';
--			spwc_codec_timecode_tx_in_sig.ctrl_in    <= (others => '0');
--			spwc_codec_timecode_tx_in_sig.time_in    <= (others => '0');
			timecode_tick_in_flag                    <= '0';
			codec_reset_sig                          <= '0';
			spwc_rx_data_dc_fifo_clk200_inputs.aclr  <= '1';
			spwc_tx_data_dc_fifo_clk200_inputs.aclr  <= '1';
			clk100_codec_commands_valid              <= '0';
			clk100_codec_commands_dc_fifo_write_sig  <= '0';
		elsif rising_edge(clk100) then
			clk100_codec_commands_dc_fifo_write_sig <= '1';

			if ((clk100_codec_commands_valid = '0') and (clk200_codec_commands_dc_fifo_sig.read_empty = '0')) then
				clk100_codec_commands_valid <= '1';
			end if;

			-- Configuração da Interface
			codec_enable_sig    <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
			codec_rx_enable_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;
			codec_tx_enable_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
			loopback_mode_sig   <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT;

			-- Procedimento de Force Reset
			if (spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT = '1') then
				codec_reset_sig                         <= '1';
				spwc_rx_data_dc_fifo_clk200_inputs.aclr <= '1';
				spwc_tx_data_dc_fifo_clk200_inputs.aclr <= '1';
			else
				codec_reset_sig                         <= '0';
				spwc_rx_data_dc_fifo_clk200_inputs.aclr <= '0';
				spwc_tx_data_dc_fifo_clk200_inputs.aclr <= '0';
			end if;

			-- Atualização dos Registradores
			--			spwc_codec_link_command_in_sig.autostart                            <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
			--			spwc_codec_link_command_in_sig.linkstart                            <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
			--			spwc_codec_link_command_in_sig.linkdis                              <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
			--			spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.STARTED             <= spwc_codec_link_status_out_sig.started;
			--			spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.CONNECTING          <= spwc_codec_link_status_out_sig.connecting;
			--			spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.RUNNING             <= spwc_codec_link_status_out_sig.running;
			--			spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT <= spwc_codec_link_error_out_sig.errdisc;
			--			spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT     <= spwc_codec_link_error_out_sig.errpar;
			--			spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT     <= spwc_codec_link_error_out_sig.erresc;
			--			spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT     <= spwc_codec_link_error_out_sig.errcred;

			-- Recebimento do RX Timecode
			if (interrupts_flags_sig.TIMECODE_RECEIVED = '1') then
				--				spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS  <= spwc_codec_timecode_rx_out_sig.ctrl_out;
				--				spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE <= spwc_codec_timecode_rx_out_sig.time_out;
				--				spwc_mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT     <= '1';
			end if;

			-- Envio do TX Timecode
			timecode_tick_in_flag <= '0';
			if (spwc_mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT = '1') then
				if (timecode_tick_in_flag = '0') then
					--					spwc_codec_timecode_tx_in_sig.ctrl_in <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--					spwc_codec_timecode_tx_in_sig.time_in <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--					timecode_tick_in_flag                 <= '1';
				end if;
			end if;

			-- Operação do Interrupt de Link Error
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR = '0') then
				if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR = '1') and (interrupts_flags_sig.LINK_ERROR = '1')) then
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR <= '1';
				else
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR <= '0';
				end if;
			else
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR <= '0';
			end if;

			-- Operação do Interrupt de Timecode Received
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED = '0') then
				if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED = '1') and (interrupts_flags_sig.TIMECODE_RECEIVED = '1')) then
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '1';
				else
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '0';
				end if;
			else
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED <= '0';
			end if;

			-- Operação do Interrupt de Link Running
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING = '0') then
				if ((spwc_mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING = '1') and (interrupts_flags_sig.LINK_RUNNING = '1')) then
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING <= '1';
				else
					spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING <= '0';
				end if;
			else
				spwc_mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING <= '0';
			end if;

		end if;
	end process spwc_codec_controller_clk100_proc;

	-- Operações com o clock codec
	spwc_codec_controller_clk200_proc : process(clk200, rst) is
		variable interrupt_flag_used : spwc_interrupt_register_type;
		variable tx_dataready_flag   : std_logic := '0';
	begin
		if (rst = '1') then
			interrupt_flag_used.LINK_ERROR          := '0';
			interrupt_flag_used.TIMECODE_RECEIVED   := '0';
			interrupt_flag_used.LINK_RUNNING        := '0';
			interrupts_flags_sig.LINK_ERROR         <= '0';
			interrupts_flags_sig.TIMECODE_RECEIVED  <= '0';
			interrupts_flags_sig.LINK_RUNNING       <= '0';
			tx_dataready_flag                       := '0';
			--codec_rxread_sig                       <= '0';
			--rx_dc_fifo_wreq_sig                    <= '0';
			--codec_txwrite_sig                      <= '0';
			--tx_dc_fifo_rdeq_sig                    <= '0';
			clk200_codec_commands_valid             <= '0';
			clk200_codec_commands_dc_fifo_write_sig <= '0';
		elsif rising_edge(clk200) then
			clk200_codec_commands_dc_fifo_write_sig <= '1';

			if ((clk200_codec_commands_valid = '0') and (clk100_codec_commands_dc_fifo_sig.read_empty = '0')) then
				clk200_codec_commands_valid <= '1';
			end if;

			-- Atualiza o flag used do Interrupt de Link Error
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR = '1') then
				interrupt_flag_used.LINK_ERROR  := '0';
				interrupts_flags_sig.LINK_ERROR <= '0';
			end if;
			-- Atualização do flag do interrupt de Link Error
			if ((spwc_codec_link_error_out_sig.errdisc = '1') or (spwc_codec_link_error_out_sig.errpar = '1') or (spwc_codec_link_error_out_sig.erresc = '1') or (spwc_codec_link_error_out_sig.errcred = '1')) then
				if (interrupt_flag_used.LINK_ERROR = '0') then
					interrupts_flags_sig.LINK_ERROR <= '1';
					interrupt_flag_used.LINK_ERROR  := '1';
				end if;
			end if;

			-- Atualiza o flag used do Interrupt de Timecode Received
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED = '1') then
				interrupt_flag_used.TIMECODE_RECEIVED  := '0';
				interrupts_flags_sig.TIMECODE_RECEIVED <= '0';
			end if;
			-- Atualização do flag do interrupt de Timecode Received
			if (timecode_tick_out_sig = '1') then
				if (interrupt_flag_used.TIMECODE_RECEIVED = '0') then
					interrupts_flags_sig.TIMECODE_RECEIVED <= '1';
					interrupt_flag_used.TIMECODE_RECEIVED  := '1';
				end if;
			end if;

			-- Atualiza o flag used do Interrupt de Link Running
			if (spwc_mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING = '1') then
				interrupt_flag_used.LINK_RUNNING  := '0';
				interrupts_flags_sig.LINK_RUNNING <= '0';
			end if;
			-- Atualização do flag do interrupt de Link Running
			if (spwc_codec_link_status_out_sig.running = '1') then
				if (interrupt_flag_used.LINK_RUNNING = '0') then
					interrupts_flags_sig.LINK_RUNNING <= '1';
					interrupt_flag_used.LINK_RUNNING  := '1';
				end if;
			end if;

			-- Reseta o trigger do envido de TX Timecode
			timecode_tick_in_sig <= '0';
			if (timecode_tick_in_sig = '0') then
				if (timecode_tick_in_flag = '1') then
					timecode_tick_in_sig <= '1';
				end if;
			end if;

			-- Operação de transferencia dos dados provenientes do Codec RX
			--			codec_rxread_sig    <= '0';
			--			rx_dc_fifo_wreq_sig <= '0';
			--			if ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) then
			--				-- transfere dados da codec rx fifo para a dc rx fifo
			--				if ((spwc_codec_data_rx_out_sig.rxvalid = '1') and (spwc_rx_data_dc_fifo_clk200_outputs.wrfull = '0')) then --(existe dado disponivel na codec rx fifo) e (rx dc fifo não está cheia)
			--					rx_data.spacewire_flag <= spwc_codec_data_rx_out_sig.rxflag;
			--					rx_data.spacewire_data <= spwc_codec_data_rx_out_sig.rxdata;
			--					rx_dc_fifo_wreq_sig    <= '1';
			--					codec_rxread_sig       <= '1';
			--				else
			--					rx_dc_fifo_wreq_sig <= '0';
			--					codec_rxread_sig    <= '0';
			--
			--				end if;
			--			end if;

			-- Operação de transferencia dos dados para o Codec TX
			--			codec_txwrite_sig   <= '0';
			--			tx_dc_fifo_rdeq_sig <= '0';
			--			if ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) then
			--				-- transfere dados da dc tx fifo para a codec tx fifo
			--				if ((spwc_codec_data_tx_out_sig.txrdy = '1') and (tx_dataready_flag = '1')) then -- (codec está pronto para receber dados) e (tx_data tem dados válidos) 
			--					spwc_codec_data_tx_in_sig.txflag <= tx_data.spacewire_flag;
			--					spwc_codec_data_tx_in_sig.txdata <= tx_data.spacewire_data;
			--					codec_txwrite_sig                <= '1';
			--					tx_dataready_flag                := '0';
			--				else
			--					codec_txwrite_sig <= '0';
			--				end if;
			--				-- carrega tx_data com dados válidos, se disponível
			--				if (spwc_tx_data_dc_fifo_clk200_outputs.rdempty = '0') then -- existe dado disponível na dc fifo
			--					if (tx_dataready_flag = '0') then --tx_data não tem dado válido;
			--						tx_dc_fifo_rdeq_sig <= '1';
			--						tx_dataready_flag   := '1';
			--					end if;
			--				else                    -- não existe dado disponível na dc fifo
			--					tx_dataready_flag := '0';
			--				end if;
			--			end if;

		end if;
	end process spwc_codec_controller_clk200_proc;

	--Signals Assignments and Port Mapping

	rx_data.spacewire_flag <= spwc_codec_data_rx_out_sig.rxflag;
	rx_data.spacewire_data <= spwc_codec_data_rx_out_sig.rxdata;

	codec_rxread_sig    <= ('1') when ((spwc_codec_data_rx_out_sig.rxvalid = '1') and (spwc_rx_data_dc_fifo_clk200_outputs.wrfull = '0')) else ('0');
	rx_dc_fifo_wreq_sig <= (codec_rxread_sig) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');

	spwc_codec_data_tx_in_sig.txflag <= tx_data.spacewire_flag;
	spwc_codec_data_tx_in_sig.txdata <= tx_data.spacewire_data;

	codec_txwrite_sig   <= ('1') when ((spwc_codec_data_tx_out_sig.txrdy = '1') and (spwc_tx_data_dc_fifo_clk200_outputs.rdempty = '0')) else ('0');
	tx_dc_fifo_rdeq_sig <= (codec_txwrite_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');

	-- Enable management
	spwc_codec_data_rx_in_sig.rxread      <= (codec_rxread_sig) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');
	spwc_codec_data_tx_in_sig.txwrite     <= (codec_txwrite_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');
	timecode_tick_out_sig                 <= (spwc_codec_timecode_rx_out_sig.tick_out) when ((codec_enable_sig = '1') and (codec_rx_enable_sig = '1')) else ('0');
	--spwc_codec_timecode_tx_in_sig.tick_in <= (timecode_tick_in_sig) when ((codec_enable_sig = '1') and (codec_tx_enable_sig = '1')) else ('0');

	-- Reset management
	spwc_codec_reset_in_sig <= (codec_reset_sig) when (rst = '0') else ('1');

	-- Fifo Underflow/Overflow protection management
	spwc_rx_data_dc_fifo_clk200_inputs.wrreq <= (rx_dc_fifo_wreq_sig) when (spwc_rx_data_dc_fifo_clk200_outputs.wrfull = '0') else ('0');
	spwc_tx_data_dc_fifo_clk200_inputs.rdreq <= (tx_dc_fifo_rdeq_sig) when (spwc_tx_data_dc_fifo_clk200_outputs.rdempty = '0') else ('0');

	-- Data management
	spwc_rx_data_dc_fifo_clk200_inputs.data(8)          <= rx_data.spacewire_flag;
	spwc_rx_data_dc_fifo_clk200_inputs.data(7 downto 0) <= rx_data.spacewire_data;
	tx_data.spacewire_flag                              <= spwc_tx_data_dc_fifo_clk200_outputs.q(8);
	tx_data.spacewire_data                              <= spwc_tx_data_dc_fifo_clk200_outputs.q(7 downto 0);

	-- Loopback management
	spwc_codec_ds_encoding_rx_in_sig.spw_di <= (spwc_codec_ds_encoding_rx_in.spw_di) when (loopback_mode_sig = '0') else (spwc_codec_ds_encoding_tx_out_sig.spw_do);
	spwc_codec_ds_encoding_rx_in_sig.spw_si <= (spwc_codec_ds_encoding_rx_in.spw_si) when (loopback_mode_sig = '0') else (spwc_codec_ds_encoding_tx_out_sig.spw_so);
	spwc_codec_ds_encoding_tx_out.spw_do    <= (spwc_codec_ds_encoding_tx_out_sig.spw_do) when (loopback_mode_sig = '0') else ('0');
	spwc_codec_ds_encoding_tx_out.spw_so    <= (spwc_codec_ds_encoding_tx_out_sig.spw_so) when (loopback_mode_sig = '0') else ('0');

	-- Command Fifo Management
	-- clk100 to clk200
	clk100_codec_commands_dc_fifo_sig.data_in(0)                        <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(1)                        <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(2)                        <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(3)                        <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;
	clk100_codec_commands_dc_fifo_sig.data_in(5 downto 4)               <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS(1 downto 0);
	clk100_codec_commands_dc_fifo_sig.data_in(11 downto 6)              <= spwc_mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE(5 downto 0);
	clk100_codec_commands_dc_fifo_sig.data_in(23 downto 12)             <= (others => '0');
	spwc_codec_link_command_in_sig.autostart                            <= (clk100_codec_commands_dc_fifo_sig.data_out(0)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_link_command_in_sig.linkstart                            <= (clk100_codec_commands_dc_fifo_sig.data_out(1)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_link_command_in_sig.linkdis                              <= (clk100_codec_commands_dc_fifo_sig.data_out(2)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_timecode_tx_in_sig.tick_in                               <= (clk100_codec_commands_dc_fifo_sig.data_out(3)) when (clk200_codec_commands_valid = '1') else ('0');
	spwc_codec_timecode_tx_in_sig.ctrl_in                               <= (clk100_codec_commands_dc_fifo_sig.data_out(5 downto 4)) when (clk200_codec_commands_valid = '1') else ((others => '0'));
	spwc_codec_timecode_tx_in_sig.time_in                               <= (clk100_codec_commands_dc_fifo_sig.data_out(11 downto 6)) when (clk200_codec_commands_valid = '1') else ((others => '0'));
	-- clk200 to clk100
	clk200_codec_commands_dc_fifo_sig.data_in(0)                        <= spwc_codec_link_status_out_sig.started;
	clk200_codec_commands_dc_fifo_sig.data_in(1)                        <= spwc_codec_link_status_out_sig.connecting;
	clk200_codec_commands_dc_fifo_sig.data_in(2)                        <= spwc_codec_link_status_out_sig.running;
	clk200_codec_commands_dc_fifo_sig.data_in(3)                        <= spwc_codec_timecode_rx_out_sig.tick_out;
	clk200_codec_commands_dc_fifo_sig.data_in(5 downto 4)               <= spwc_codec_timecode_rx_out_sig.ctrl_out(1 downto 0);
	clk200_codec_commands_dc_fifo_sig.data_in(11 downto 6)              <= spwc_codec_timecode_rx_out_sig.time_out(5 downto 0);
	clk200_codec_commands_dc_fifo_sig.data_in(12)                       <= spwc_codec_link_error_out_sig.errdisc;
	clk200_codec_commands_dc_fifo_sig.data_in(13)                       <= spwc_codec_link_error_out_sig.errpar;
	clk200_codec_commands_dc_fifo_sig.data_in(14)                       <= spwc_codec_link_error_out_sig.erresc;
	clk200_codec_commands_dc_fifo_sig.data_in(15)                       <= spwc_codec_link_error_out_sig.errcred;
	clk200_codec_commands_dc_fifo_sig.data_in(23 downto 16)             <= (others => '0');
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.STARTED             <= (clk200_codec_commands_dc_fifo_sig.data_out(0)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.CONNECTING          <= (clk200_codec_commands_dc_fifo_sig.data_out(1)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.SPW_LINK_STATUS_REGISTER.RUNNING             <= (clk200_codec_commands_dc_fifo_sig.data_out(2)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT      <= (clk200_codec_commands_dc_fifo_sig.data_out(3)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS   <= (clk200_codec_commands_dc_fifo_sig.data_out(5 downto 4)) when (clk100_codec_commands_valid = '1') else ((others => '0'));
	spwc_mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE  <= (clk200_codec_commands_dc_fifo_sig.data_out(11 downto 6)) when (clk100_codec_commands_valid = '1') else ((others => '0'));
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT <= (clk200_codec_commands_dc_fifo_sig.data_out(12)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT     <= (clk200_codec_commands_dc_fifo_sig.data_out(13)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT     <= (clk200_codec_commands_dc_fifo_sig.data_out(14)) when (clk100_codec_commands_valid = '1') else ('0');
	spwc_mm_read_registers.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT     <= (clk200_codec_commands_dc_fifo_sig.data_out(15)) when (clk100_codec_commands_valid = '1') else ('0');

	clk100_codec_commands_dc_fifo_sig.read  <= ('1') when (clk100_codec_commands_dc_fifo_sig.read_empty = '0') else ('0');
	clk100_codec_commands_dc_fifo_sig.write <= (clk100_codec_commands_dc_fifo_write_sig) when (clk100_codec_commands_dc_fifo_sig.write_full = '0') else ('0');

	clk200_codec_commands_dc_fifo_sig.read  <= ('1') when (clk200_codec_commands_dc_fifo_sig.read_empty = '0') else ('0');
	clk200_codec_commands_dc_fifo_sig.write <= (clk200_codec_commands_dc_fifo_write_sig) when (clk200_codec_commands_dc_fifo_sig.write_full = '0') else ('0');

end architecture spwc_codec_controller_arc;
