-- comm_v1_50_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avalon_mm_windowing_pkg.all;
use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.spw_codec_pkg.all;
use work.rmap_target_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity comm_v1_50_top is
	port(
		reset_sink_reset                   : in  std_logic                     := '0'; --          --               reset_sink.a_reset
		data_in                            : in  std_logic                     := '0'; --          --          spw_conduit_end.data_in_signal
		data_out                           : out std_logic; --                                     --                         .data_out_signal
		strobe_in                          : in  std_logic                     := '0'; --          --                         .strobe_in_signal
		strobe_out                         : out std_logic; --                                     --                         .strobe_out_signal
		sync_channel                       : in  std_logic                     := '0'; --          --         sync_conduit_end.sync_channel_signal
		rmap_interrupt_sender_irq          : out std_logic; --                                     --    rmap_interrupt_sender.irq
		buffers_interrupt_sender_irq       : out std_logic; --                                     -- buffers_interrupt_sender.irq
		clock_sink_200_clk                 : in  std_logic                     := '0'; --          --           clock_sink_200.clk
		clock_sink_100_clk                 : in  std_logic                     := '0'; --          --           clock_sink_100.clk
		avalon_slave_windowing_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); --   avalon_slave_windowing.address
		avalon_slave_windowing_write       : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_windowing_read        : in  std_logic                     := '0'; --          --                         .read
		avalon_slave_windowing_readdata    : out std_logic_vector(31 downto 0); --                 --                         .readdata
		avalon_slave_windowing_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_windowing_waitrequest : out std_logic; --                                     --                         .waitrequest
		avalon_slave_L_buffer_address      : in  std_logic_vector(9 downto 0)  := (others => '0'); --    avalon_slave_L_buffer.address
		avalon_slave_L_buffer_waitrequest  : out std_logic; --                                     --                         .waitrequest
		avalon_slave_L_buffer_write        : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_L_buffer_writedata    : in  std_logic_vector(63 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_R_buffer_address      : in  std_logic_vector(9 downto 0)  := (others => '0'); --    avalon_slave_R_buffer.address
		avalon_slave_R_buffer_write        : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_R_buffer_writedata    : in  std_logic_vector(63 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_R_buffer_waitrequest  : out std_logic --                                      --                         .waitrequest
	);
end entity comm_v1_50_top;

architecture rtl of comm_v1_50_top is

	-- dummy ports
	alias a_spw_clock is clock_sink_200_clk;
	alias a_avs_clock is clock_sink_100_clk;
	alias a_reset is reset_sink_reset;

	-- constants

	-- signals

	signal rst_n : std_logic;

	-- interrupt edge detection signals
	signal s_R_buffer_empty_delayed      : std_logic;
	signal s_L_buffer_empty_delayed      : std_logic;
	signal s_rmap_write_finished_delayed : std_logic;

	-- windowing avalon mm read signals
	signal s_avalon_mm_windwoing_read_readdata    : std_logic_vector(31 downto 0);
	signal s_avalon_mm_windwoing_read_waitrequest : std_logic;

	-- windowing avalon mm write signals
	signal s_avalon_mm_windwoing_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_spacewire_write_registers : t_windowing_write_registers;
	signal s_spacewire_read_registers  : t_windowing_read_registers;

	-- rigth avalon mm windowing write signals
	signal s_R_window_data : std_logic_vector(63 downto 0);

	-- rigth windowing buffer signals
	signal s_R_window_data_write : std_logic;
	signal s_R_window_mask_write : std_logic;
	signal s_R_window_data_read  : std_logic;
	signal s_R_window_mask_read  : std_logic;
	signal s_R_window_data_out   : std_logic_vector(63 downto 0);
	signal s_R_window_mask_out   : std_logic_vector(63 downto 0);
	signal s_R_window_data_ready : std_logic;
	signal s_R_window_mask_ready : std_logic;

	-- left avalon mm windowing signals
	signal s_L_window_data : std_logic_vector(63 downto 0);

	-- left windowing buffer signals
	signal s_L_window_data_write : std_logic;
	signal s_L_window_mask_write : std_logic;
	signal s_L_window_data_read  : std_logic;
	signal s_L_window_mask_read  : std_logic;
	signal s_L_window_data_out   : std_logic_vector(63 downto 0);
	signal s_L_window_mask_out   : std_logic_vector(63 downto 0);
	signal s_L_window_data_ready : std_logic;
	signal s_L_window_mask_ready : std_logic;

	-- data controller signals

	-- spw codec signals
	--	signal s_spw_rxvalid : std_logic;
	--	signal s_spw_rxhalff : std_logic;
	--	signal s_spw_rxflag  : std_logic;
	--	signal s_spw_rxdata  : std_logic_vector(7 downto 0);
	--	signal s_spw_rxread  : std_logic;
	signal s_data_controller_spw_txrdy   : std_logic;
	signal s_data_controller_spw_txhalff : std_logic;
	signal s_data_controller_spw_txwrite : std_logic;
	signal s_data_controller_spw_txflag  : std_logic;
	signal s_data_controller_spw_txdata  : std_logic_vector(7 downto 0);

	-- spw codec clock synchronization signals
	signal s_spw_codec_link_command_clk200    : t_spw_codec_link_command;
	signal s_spw_codec_link_status_clk200     : t_spw_codec_link_status;
	signal s_spw_codec_link_error_clk200      : t_spw_codec_link_error;
	signal s_spw_codec_timecode_rx_clk200     : t_spw_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_clk200  : t_spw_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_clk200  : t_spw_codec_data_tx_status;
	signal s_spw_codec_timecode_tx_clk200     : t_spw_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_clk200 : t_spw_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_clk200 : t_spw_codec_data_tx_command;

	-- rmap signals (TEMP)

	signal s_rmap_spw_control : t_rmap_target_spw_control;
	signal s_rmap_spw_flag    : t_rmap_target_spw_flag;

	signal s_rmap_mem_control : t_rmap_target_mem_control;
	signal s_rmap_mem_flag    : t_rmap_target_mem_flag;

	signal s_rmap_mem_wr_byte_address : std_logic_vector((32 + 0 - 1) downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector((32 + 0 - 1) downto 0);

	signal s_rmap_mem_config_area : t_rmap_memory_config_area;
	signal s_rmap_mem_hk_area     : t_rmap_memory_hk_area;

	signal s_rmap_write_data_finished : std_logic;
	signal s_rmap_read_data_finished  : std_logic;

	-- rmap avalon mm read signals
	signal s_avalon_mm_rmap_mem_read_readdata    : std_logic_vector(31 downto 0);
	signal s_avalon_mm_rmap_mem_read_waitrequest : std_logic;

	-- rmap avalon mm write signals
	signal s_avalon_mm_rmap_mem_write_waitrequest : std_logic;

	-- timecode manager
	signal s_timecode_tick    : std_logic;
	signal s_timecode_control : std_logic_vector(1 downto 0);
	signal s_timecode_counter : std_logic_vector(5 downto 0);

	-- spw mux
	signal s_mux_rx_channel_command : t_spw_codec_data_rx_command;
	signal s_mux_rx_channel_status  : t_spw_codec_data_rx_status;
	signal s_mux_tx_channel_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_channel_status  : t_spw_codec_data_tx_status;

begin

	rst_n <= not a_reset;

	-- windowing avalon mm read instantiation
	avalon_mm_spacewire_read_ent_inst : entity work.avalon_mm_spacewire_read_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_windowing_address,
			avalon_mm_spacewire_i.read        => avalon_slave_windowing_read,
			avalon_mm_spacewire_o.readdata    => s_avalon_mm_windwoing_read_readdata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_read_waitrequest,
			spacewire_write_registers_i       => s_spacewire_write_registers,
			spacewire_read_registers_i        => s_spacewire_read_registers
		);

	-- windowing avalon mm write instantiation
	avalon_mm_spacewire_write_ent_inst : entity work.avalon_mm_spacewire_write_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_windowing_address,
			avalon_mm_spacewire_i.write       => avalon_slave_windowing_write,
			avalon_mm_spacewire_i.writedata   => avalon_slave_windowing_writedata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_write_waitrequest,
			spacewire_write_registers_o       => s_spacewire_write_registers
		);

	-- rigth avalon mm windowing write instantiation
	rigth_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_windowing_i.address     => avalon_slave_R_buffer_address,
			avalon_mm_windowing_i.write       => avalon_slave_R_buffer_write,
			avalon_mm_windowing_i.writedata   => avalon_slave_R_buffer_writedata,
			mask_enable_i                     => s_spacewire_write_registers.fee_windowing_buffers_config_reg.fee_masking_en,
			avalon_mm_windowing_o.waitrequest => avalon_slave_R_buffer_waitrequest,
			window_data_write_o               => s_R_window_data_write,
			window_mask_write_o               => s_R_window_mask_write,
			window_data_o                     => s_R_window_data
		);

	-- rigth windowing buffer instantiation
	rigth_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			window_data_write_i   => s_R_window_data_write,
			window_mask_write_i   => s_R_window_mask_write,
			window_data_i         => s_R_window_data,
			window_data_read_i    => s_R_window_data_read,
			window_mask_read_i    => s_R_window_mask_read,
			window_data_o         => s_R_window_data_out,
			window_mask_o         => s_R_window_mask_out,
			window_data_ready_o   => s_R_window_data_ready,
			window_mask_ready_o   => s_R_window_mask_ready,
			window_buffer_empty_o => s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_right_buffer_empty
		);

	-- left avalon mm windowing write instantiation
	left_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_windowing_i.address     => avalon_slave_L_buffer_address,
			avalon_mm_windowing_i.write       => avalon_slave_L_buffer_write,
			avalon_mm_windowing_i.writedata   => avalon_slave_L_buffer_writedata,
			mask_enable_i                     => s_spacewire_write_registers.fee_windowing_buffers_config_reg.fee_masking_en,
			avalon_mm_windowing_o.waitrequest => avalon_slave_L_buffer_waitrequest,
			window_data_write_o               => s_L_window_data_write,
			window_mask_write_o               => s_L_window_mask_write,
			window_data_o                     => s_L_window_data
		);

	-- left windowing buffer instantiation
	left_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			window_data_write_i   => s_L_window_data_write,
			window_mask_write_i   => s_L_window_mask_write,
			window_data_i         => s_L_window_data,
			window_data_read_i    => s_L_window_data_read,
			window_mask_read_i    => s_L_window_mask_read,
			window_data_o         => s_L_window_data_out,
			window_mask_o         => s_L_window_mask_out,
			window_data_ready_o   => s_L_window_data_ready,
			window_mask_ready_o   => s_L_window_mask_ready,
			window_buffer_empty_o => s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_left_buffer_empty
		);

	-- data controller instantiation
	data_controller_ent_inst : entity work.data_controller_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			mask_enable_i         => s_spacewire_write_registers.fee_windowing_buffers_config_reg.fee_masking_en,
			window_data_R_i       => s_R_window_data_out,
			window_mask_R_i       => s_R_window_mask_out,
			window_data_R_ready_i => s_R_window_data_ready,
			window_mask_R_ready_i => s_R_window_mask_ready,
			window_data_L_i       => s_L_window_data_out,
			window_mask_L_i       => s_L_window_mask_out,
			window_data_L_ready_i => s_L_window_data_ready,
			window_mask_L_ready_i => s_L_window_mask_ready,
			spw_txrdy_i           => s_data_controller_spw_txrdy,
			spw_txhalff_i         => s_data_controller_spw_txhalff,
			window_data_R_read_o  => s_R_window_data_read,
			window_mask_R_read_o  => s_R_window_mask_read,
			window_data_L_read_o  => s_L_window_data_read,
			window_mask_L_read_o  => s_L_window_mask_read,
			spw_txwrite_o         => s_data_controller_spw_txwrite,
			spw_txflag_o          => s_data_controller_spw_txflag,
			spw_txdata_o          => s_data_controller_spw_txdata
		);

	-- RMAP (TEMP)
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => 8,
			g_MEMORY_ADDRESS_WIDTH => 32,
			g_DATA_LENGTH_WIDTH    => 8,
			g_MEMORY_ACCESS_WIDTH  => 0
		)
		port map(
			clk_i                      => a_avs_clock,
			reset_n_i                  => rst_n,
			spw_flag_i                 => s_rmap_spw_flag,
			mem_flag_i                 => s_rmap_mem_flag,
			spw_control_o              => s_rmap_spw_control,
			conf_target_logical_addr_i => s_spacewire_write_registers.rmap_codec_config_reg.rmap_target_logical_addr,
			conf_target_key_i          => s_spacewire_write_registers.rmap_codec_config_reg.rmap_target_key,
			mem_control_o              => s_rmap_mem_control,
			mem_wr_byte_address_o      => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o      => s_rmap_mem_rd_byte_address,
			stat_command_received_o    => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_command_received,
			stat_write_requested_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_requested,
			stat_write_authorized_o    => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			stat_write_finished_o      => s_rmap_write_data_finished,
			stat_read_requested_o      => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_requested,
			stat_read_authorized_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized,
			stat_read_finished_o       => s_rmap_read_data_finished,
			stat_reply_sended_o        => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_reply_sended,
			stat_discarded_package_o   => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_discarded_package,
			err_early_eop_o            => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_early_eop,
			err_eep_o                  => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_eep,
			err_header_crc_o           => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_header_crc,
			err_unused_packet_type_o   => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_unused_packet_type,
			err_invalid_command_code_o => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_invalid_command_code,
			err_too_much_data_o        => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_too_much_data,
			err_invalid_data_crc_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_invalid_data_crc
		);

	rmap_mem_area_nfee_read_inst : entity work.rmap_mem_area_nfee_read
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			rmap_read_i                  => s_rmap_mem_control.read.read,
			rmap_readaddr_i              => s_rmap_mem_rd_byte_address,
			rmap_config_registers_i      => s_rmap_mem_config_area,
			rmap_hk_registers_i          => s_rmap_mem_hk_area,
			avalon_mm_rmap_i.address     => avalon_slave_windowing_address,
			avalon_mm_rmap_i.read        => avalon_slave_windowing_read,
			rmap_write_authorized_i      => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			rmap_write_finished_i        => s_rmap_write_data_finished,
			rmap_memerror_o              => s_rmap_mem_flag.read.error,
			rmap_datavalid_o             => s_rmap_mem_flag.read.valid,
			rmap_readdata_o              => s_rmap_mem_flag.read.data,
			avalon_mm_rmap_o.readdata    => s_avalon_mm_rmap_mem_read_readdata,
			avalon_mm_rmap_o.waitrequest => s_avalon_mm_rmap_mem_read_waitrequest
		);

	rmap_mem_area_nfee_write_inst : entity work.rmap_mem_area_nfee_write
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			rmap_write_i                 => s_rmap_mem_control.write.write,
			rmap_writeaddr_i             => s_rmap_mem_wr_byte_address,
			rmap_writedata_i             => s_rmap_mem_control.write.data,
			avalon_mm_rmap_i.address     => avalon_slave_windowing_address,
			avalon_mm_rmap_i.write       => avalon_slave_windowing_write,
			avalon_mm_rmap_i.writedata   => avalon_slave_windowing_writedata,
			rmap_write_authorized_i      => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			rmap_write_finished_i        => s_rmap_write_data_finished,
			rmap_read_authorized_i       => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized,
			rmap_read_finished_i         => s_rmap_read_data_finished,
			rmap_memerror_o              => s_rmap_mem_flag.write.error,
			rmap_memready_o              => s_rmap_mem_flag.write.ready,
			avalon_mm_rmap_o.waitrequest => s_avalon_mm_rmap_mem_write_waitrequest,
			rmap_config_registers_o      => s_rmap_mem_config_area,
			rmap_hk_registers_o          => s_rmap_mem_hk_area
		);

	-- spw mux
	-- tx 0 / rx 0 -> rmap
	-- tx 1        -> data controller 
	spw_mux_ent_inst : entity work.spw_mux_ent
		port map(
			clk_i                          => a_avs_clock,
			rst_i                          => a_reset,
			spw_codec_rx_status_i          => s_mux_rx_channel_status,
			spw_codec_tx_status_i          => s_mux_tx_channel_status,
			spw_mux_rx_0_command_i.rxread  => s_rmap_spw_control.receiver.read,
			spw_mux_tx_0_command_i.txwrite => s_rmap_spw_control.transmitter.write,
			spw_mux_tx_0_command_i.txflag  => s_rmap_spw_control.transmitter.flag,
			spw_mux_tx_0_command_i.txdata  => s_rmap_spw_control.transmitter.data,
			spw_mux_tx_1_command_i.txwrite => s_data_controller_spw_txwrite,
			spw_mux_tx_1_command_i.txflag  => s_data_controller_spw_txflag,
			spw_mux_tx_1_command_i.txdata  => s_data_controller_spw_txdata,
			spw_codec_rx_command_o         => s_mux_rx_channel_command,
			spw_codec_tx_command_o         => s_mux_tx_channel_command,
			spw_mux_rx_0_status_o.rxvalid  => s_rmap_spw_flag.receiver.valid,
			spw_mux_rx_0_status_o.rxhalff  => s_spw_rxhalff,
			spw_mux_rx_0_status_o.rxflag   => s_rmap_spw_flag.receiver.flag,
			spw_mux_rx_0_status_o.rxdata   => s_rmap_spw_flag.receiver.data,
			spw_mux_tx_0_status_o.txrdy    => s_rmap_spw_flag.transmitter.ready,
			spw_mux_tx_0_status_o.txhalff  => open,
			spw_mux_tx_1_status_o.txrdy    => s_data_controller_spw_txrdy,
			spw_mux_tx_1_status_o.txhalff  => s_data_controller_spw_txhalff
		);

	-- spw codec clock domain synchronization
	spw_clk_synchronization_ent_inst : entity work.spw_clk_synchronization_ent
		port map(
			clk_100_i                                 => a_avs_clock,
			clk_200_i                                 => a_spw_clock,
			rst_i                                     => a_reset,
			spw_codec_link_command_clk100_i.autostart => s_spacewire_write_registers.spw_link_config_status_reg.spw_lnkcfg_autostart,
			spw_codec_link_command_clk100_i.linkstart => s_spacewire_write_registers.spw_link_config_status_reg.spw_lnkcfg_linkstart,
			spw_codec_link_command_clk100_i.linkdis   => s_spacewire_write_registers.spw_link_config_status_reg.spw_lnkcfg_disconnect,
			spw_codec_link_command_clk100_i.txdivcnt  => s_spacewire_write_registers.spw_link_config_status_reg.spw_lnkcfg_txdivcnt,
			spw_codec_timecode_tx_clk100_i.tick_in    => s_timecode_tick,
			spw_codec_timecode_tx_clk100_i.ctrl_in    => s_timecode_control,
			spw_codec_timecode_tx_clk100_i.time_in    => s_timecode_counter,
			spw_codec_data_rx_command_clk100_i        => s_mux_rx_channel_command,
			spw_codec_data_tx_command_clk100_i        => s_mux_tx_channel_command,
			spw_codec_link_status_clk200_i            => s_spw_codec_link_status_clk200,
			spw_codec_link_error_clk200_i             => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_clk200_i            => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_clk200_i         => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_clk200_i         => s_spw_codec_data_tx_status_clk200,
			spw_codec_link_status_clk100_o.started    => s_spacewire_read_registers.spw_link_config_status_reg.spw_link_started,
			spw_codec_link_status_clk100_o.connecting => s_spacewire_read_registers.spw_link_config_status_reg.spw_link_connecting,
			spw_codec_link_status_clk100_o.running    => s_spacewire_read_registers.spw_link_config_status_reg.spw_link_running,
			spw_codec_link_error_clk100_o.errdisc     => s_spacewire_read_registers.spw_link_config_status_reg.spw_err_disconnect,
			spw_codec_link_error_clk100_o.errpar      => s_spacewire_read_registers.spw_link_config_status_reg.spw_err_parity,
			spw_codec_link_error_clk100_o.erresc      => s_spacewire_read_registers.spw_link_config_status_reg.spw_err_escape,
			spw_codec_link_error_clk100_o.errcred     => s_spacewire_read_registers.spw_link_config_status_reg.spw_err_credit,
			spw_codec_timecode_rx_clk100_o.tick_out   => open,
			spw_codec_timecode_rx_clk100_o.ctrl_out   => open,
			spw_codec_timecode_rx_clk100_o.time_out   => open,
			spw_codec_data_rx_status_clk100_o         => s_mux_rx_channel_status,
			spw_codec_data_tx_status_clk100_o         => s_mux_tx_channel_status,
			spw_codec_link_command_clk200_o           => s_spw_codec_link_command_clk200,
			spw_codec_timecode_tx_clk200_o            => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_clk200_o        => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_clk200_o        => s_spw_codec_data_tx_command_clk200
		);

	-- spw codec instantiation 
	spw_codec_ent_inst : entity work.spw_codec_ent
		port map(
			clk_200_i                         => a_spw_clock,
			rst_i                             => a_reset,
			spw_codec_link_command_i          => s_spw_codec_link_command_clk200,
			spw_codec_ds_encoding_rx_i.spw_di => data_in,
			spw_codec_ds_encoding_rx_i.spw_si => strobe_in,
			spw_codec_timecode_tx_i           => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_i       => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_i       => s_spw_codec_data_tx_command_clk200,
			spw_codec_link_status_o           => s_spw_codec_link_status_clk200,
			spw_codec_ds_encoding_tx_o.spw_do => data_out,
			spw_codec_ds_encoding_tx_o.spw_so => strobe_out,
			spw_codec_link_error_o            => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_o           => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_o        => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_o        => s_spw_codec_data_tx_status_clk200
		);

	avalon_slave_windowing_readdata    <= ((s_avalon_mm_windwoing_read_readdata) or (s_avalon_mm_rmap_mem_read_readdata)) when (a_reset = '0') else (x"00000000");
	avalon_slave_windowing_waitrequest <= ((s_avalon_mm_windwoing_read_waitrequest) and (s_avalon_mm_windwoing_write_waitrequest) and (s_avalon_mm_rmap_mem_read_waitrequest) and (s_avalon_mm_rmap_mem_write_waitrequest)) when (a_reset = '0') else ('1');

	p_rmap_last_addr : process(a_avs_clock, a_reset) is
		variable v_write_authorized : std_logic := '0';
		variable v_read_authorized  : std_logic := '0';
	begin
		if (a_reset) = '1' then
			s_spacewire_read_registers.rmap_last_write_addr_reg.rmap_last_write_addr <= (others => '0');
			s_spacewire_read_registers.rmap_last_read_addr_reg.rmap_last_read_addr   <= (others => '0');
			v_write_authorized                                                       := '0';
			v_read_authorized                                                        := '0';
		elsif rising_edge(a_avs_clock) then
			if (v_write_authorized = '1') then
				if (s_rmap_mem_control.write.write = '1') then
					s_spacewire_read_registers.rmap_last_write_addr_reg.rmap_last_write_addr <= s_rmap_mem_wr_byte_address;
					v_write_authorized                                                       := '0';
				end if;
			else
				if (s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized = '1') then
					v_write_authorized := '1';
				end if;
			end if;
			if (v_read_authorized = '1') then
				if (s_rmap_mem_control.read.read = '1') then
					s_spacewire_read_registers.rmap_last_read_addr_reg.rmap_last_read_addr <= s_rmap_mem_rd_byte_address;
					v_read_authorized                                                      := '0';
				end if;
			else
				if (s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized = '1') then
					v_read_authorized := '1';
				end if;
			end if;
		end if;
	end process p_rmap_last_addr;

	p_timecode_manager : process(a_avs_clock, a_reset) is
		variable v_timecode_sended : std_logic := '0';
	begin
		if (a_reset) = '1' then
			s_timecode_tick    <= '0';
			s_timecode_control <= (others => '0');
			s_timecode_counter <= (others => '0');
			v_timecode_sended  := '0';
		elsif rising_edge(a_avs_clock) then
			s_timecode_tick <= '0';
			if (sync_channel = '1') then
				if (v_timecode_sended = '0') then
					v_timecode_sended  := '1';
					s_timecode_tick    <= '1';
					s_timecode_control <= (others => '0');
					if (s_timecode_counter = "111111") then
						s_timecode_counter <= (others => '0');
					else
						s_timecode_counter <= std_logic_vector(unsigned(s_timecode_counter) + 1);
					end if;
				end if;
			else
				v_timecode_sended := '0';
			end if;
		end if;
	end process p_timecode_manager;

	p_fee_buffers_irq_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_spacewire_read_registers.comm_irq_flags_reg.comm_buffer_empty_flag <= '0';
			s_R_buffer_empty_delayed                                             <= '0';
			s_L_buffer_empty_delayed                                             <= '0';
		elsif rising_edge(a_avs_clock) then
			-- flag clear
			if (s_spacewire_write_registers.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear = '1') then
				s_spacewire_read_registers.comm_irq_flags_reg.comm_buffer_empty_flag <= '0';
			end if;
			-- check if the global interrupt is enabled
			if (s_spacewire_write_registers.comm_irq_control_reg.comm_global_irq_en = '1') then
				-- check if the R empty buffer interrupt is activated
				if (s_spacewire_write_registers.comm_irq_control_reg.comm_right_buffer_empty_en = '1') then
					-- detect a rising edge in of the R buffer empty signals
					if (((s_R_buffer_empty_delayed = '0') and (s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_right_buffer_empty = '1'))) then
						s_spacewire_read_registers.comm_irq_flags_reg.comm_buffer_empty_flag <= '1';
					end if;
				end if;
				-- check if the L empty buffer interrupt is activated
				if (s_spacewire_write_registers.comm_irq_control_reg.comm_left_buffer_empty_en = '1') then
					-- detect a rising edge in of the L buffer empty signals
					if (((s_L_buffer_empty_delayed = '0') and (s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_left_buffer_empty = '1'))) then
						s_spacewire_read_registers.comm_irq_flags_reg.comm_buffer_empty_flag <= '1';
					end if;
				end if;
			end if;
			-- delay signals
			s_R_buffer_empty_delayed <= s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_right_buffer_empty;
			s_L_buffer_empty_delayed <= s_spacewire_read_registers.fee_windowing_buffers_status_reg.windowing_left_buffer_empty;
		end if;
	end process p_fee_buffers_irq_manager;
	buffers_interrupt_sender_irq <= s_spacewire_read_registers.comm_irq_flags_reg.comm_buffer_empty_flag;

	p_rmap_write_irq_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_spacewire_read_registers.comm_irq_flags_reg.comm_rmap_write_command_flag <= '0';
			s_rmap_write_finished_delayed                                              <= '0';
		elsif rising_edge(a_avs_clock) then
			-- flag clear
			if (s_spacewire_write_registers.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear = '1') then
				s_spacewire_read_registers.comm_irq_flags_reg.comm_rmap_write_command_flag <= '0';
			end if;
			-- check if the global interrupt is enabled
			if (s_spacewire_write_registers.comm_irq_control_reg.comm_global_irq_en = '1') then
				-- check if the rmap write finished interrupt is activated
				if (s_spacewire_write_registers.comm_irq_control_reg.comm_rmap_write_command_en = '1') then
					-- detect a rising edge in write finished signal
					if (((s_rmap_write_finished_delayed = '0') and (s_rmap_write_data_finished = '1'))) then
						s_spacewire_read_registers.comm_irq_flags_reg.comm_rmap_write_command_flag <= '1';
					end if;
				end if;
			end if;
			-- delay signals
			s_rmap_write_finished_delayed <= s_rmap_write_data_finished;
		end if;
	end process p_rmap_write_irq_manager;
	rmap_interrupt_sender_irq <= s_spacewire_read_registers.comm_irq_flags_reg.comm_rmap_write_command_flag;

end architecture rtl;                   -- of comm_v1_50_top
