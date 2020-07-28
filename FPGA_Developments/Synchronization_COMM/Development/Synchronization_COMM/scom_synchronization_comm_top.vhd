-- scom_synchronization_comm_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.scom_avs_config_pkg.all;
use work.scom_avs_config_registers_pkg.all;
use work.rmap_target_pkg.all;

entity scom_synchronization_comm_top is
	generic(
		g_SCOM_TESTBENCH_MODE : std_logic := '0'
	);
	port(
		reset_sink_reset_i                  : in  std_logic                     := '0'; --          --                              reset_sink.reset
		clock_sink_clk_i                    : in  std_logic                     := '0'; --          --                              clock_sink.clk
		channel_sync_i                      : in  std_logic                     := '0'; --          --                conduit_end_channel_sync.sync_signal
		avs_config_address_i                : in  std_logic_vector(7 downto 0)  := (others => '0'); --                  avalon_mm_config_slave.address
		avs_config_byteenable_i             : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                        .byteenable
		avs_config_write_i                  : in  std_logic                     := '0'; --          --                                        .write
		avs_config_writedata_i              : in  std_logic_vector(31 downto 0) := (others => '0'); --                                        .writedata
		avs_config_read_i                   : in  std_logic                     := '0'; --          --                                        .read
		avs_config_readdata_o               : out std_logic_vector(31 downto 0); --                 --                                        .readdata
		avs_config_waitrequest_o            : out std_logic; --                                     --                                        .waitrequest
		spw_link_status_started_i           : in  std_logic                     := '0'; --          --        conduit_end_spacewire_controller.spw_link_status_started_signal
		spw_link_status_connecting_i        : in  std_logic                     := '0'; --          --                                        .spw_link_status_connecting_signal
		spw_link_status_running_i           : in  std_logic                     := '0'; --          --                                        .spw_link_status_running_signal
		spw_link_error_errdisc_i            : in  std_logic                     := '0'; --          --                                        .spw_link_error_errdisc_signal
		spw_link_error_errpar_i             : in  std_logic                     := '0'; --          --                                        .spw_link_error_errpar_signal
		spw_link_error_erresc_i             : in  std_logic                     := '0'; --          --                                        .spw_link_error_erresc_signal
		spw_link_error_errcred_i            : in  std_logic                     := '0'; --          --                                        .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_i          : in  std_logic                     := '0'; --          --                                        .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_i          : in  std_logic_vector(1 downto 0)  := (others => '0'); --                                        .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_i          : in  std_logic_vector(5 downto 0)  := (others => '0'); --                                        .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_i        : in  std_logic                     := '0'; --          --                                        .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_i        : in  std_logic                     := '0'; --          --                                        .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_i         : in  std_logic                     := '0'; --          --                                        .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_i         : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                        .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_i          : in  std_logic                     := '0'; --          --                                        .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_i        : in  std_logic                     := '0'; --          --                                        .spw_data_tx_status_txhalff_signal
		spw_link_command_autostart_o        : out std_logic; --                                     --                                        .spw_link_command_autostart_signal
		spw_link_command_linkstart_o        : out std_logic; --                                     --                                        .spw_link_command_linkstart_signal
		spw_link_command_linkdis_o          : out std_logic; --                                     --                                        .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_o         : out std_logic_vector(7 downto 0); --                  --                                        .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_o           : out std_logic; --                                     --                                        .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_o           : out std_logic_vector(1 downto 0); --                  --                                        .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_o           : out std_logic_vector(5 downto 0); --                  --                                        .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_o        : out std_logic; --                                     --                                        .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_o       : out std_logic; --                                     --                                        .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_o        : out std_logic; --                                     --                                        .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_o        : out std_logic_vector(7 downto 0); --                  --                                        .spw_data_tx_command_txdata_signal
		rmm_rmap_target_wr_waitrequest_i    : in  std_logic                     := '0'; --          -- conduit_end_rmap_mem_master_rmap_target.wr_waitrequest_signal
		rmm_rmap_target_readdata_i          : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                        .readdata_signal
		rmm_rmap_target_rd_waitrequest_i    : in  std_logic                     := '0'; --          --                                        .rd_waitrequest_signal
		rmm_rmap_target_wr_address_o        : out std_logic_vector(31 downto 0); --                 --                                        .wr_address_signal
		rmm_rmap_target_write_o             : out std_logic; --                                     --                                        .write_signal
		rmm_rmap_target_writedata_o         : out std_logic_vector(7 downto 0); --                  --                                        .writedata_signal
		rmm_rmap_target_rd_address_o        : out std_logic_vector(31 downto 0); --                 --                                        .rd_address_signal
		rmm_rmap_target_read_o              : out std_logic; --                                     --                                        .read_signal
		rmm_fee_hk_wr_waitrequest_i         : in  std_logic                     := '0'; --          --      conduit_end_rmap_mem_master_fee_hk.wr_waitrequest_signal
		rmm_fee_hk_readdata_i               : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                        .readdata_signal
		rmm_fee_hk_rd_waitrequest_i         : in  std_logic                     := '0'; --          --                                        .rd_waitrequest_signal
		rmm_fee_hk_wr_address_o             : out std_logic_vector(31 downto 0); --                 --                                        .wr_address_signal
		rmm_fee_hk_write_o                  : out std_logic; --                                     --                                        .write_signal
		rmm_fee_hk_writedata_o              : out std_logic_vector(7 downto 0); --                  --                                        .writedata_signal
		rmm_fee_hk_rd_address_o             : out std_logic_vector(31 downto 0); --                 --                                        .rd_address_signal
		rmm_fee_hk_read_o                   : out std_logic; --                                     --                                        .read_signal
		channel_hk_timecode_control_o       : out std_logic_vector(1 downto 0); --                  --              conduit_end_channel_hk_out.timecode_control_signal
		channel_hk_timecode_time_o          : out std_logic_vector(5 downto 0); --                  --                                        .timecode_time_signal
		channel_hk_rmap_target_status_o     : out std_logic_vector(7 downto 0); --                  --                                        .rmap_target_status_signal
		channel_hk_rmap_target_indicate_o   : out std_logic; --                                     --                                        .rmap_target_indicate_signal
		channel_hk_spw_link_escape_err_o    : out std_logic; --                                     --                                        .spw_link_escape_err_signal
		channel_hk_spw_link_credit_err_o    : out std_logic; --                                     --                                        .spw_link_credit_err_signal
		channel_hk_spw_link_parity_err_o    : out std_logic; --                                     --                                        .spw_link_parity_err_signal
		channel_hk_spw_link_disconnect_o    : out std_logic; --                                     --                                        .spw_link_disconnect_signal
		channel_hk_spw_link_running_o       : out std_logic; --                                     --                                        .spw_link_running_signal
		channel_hk_frame_counter_o          : out std_logic_vector(15 downto 0); --                 --                                        .frame_counter_signal
		channel_hk_frame_number_o           : out std_logic_vector(1 downto 0); --                  --                                        .frame_number_signal
		channel_hk_err_win_wrong_x_coord_o  : out std_logic; --                                     --                                        .err_win_wrong_x_coord_signal
		channel_hk_err_win_wrong_y_coord_o  : out std_logic; --                                     --                                        .err_win_wrong_y_coord_signal
		channel_hk_err_e_side_buffer_full_o : out std_logic; --                                     --                                        .err_e_side_buffer_full_signal
		channel_hk_err_f_side_buffer_full_o : out std_logic; --                                     --                                        .err_f_side_buffer_full_signal
		channel_hk_err_invalid_ccd_mode_o   : out std_logic; --                                     --                                        .err_invalid_ccd_mode_signal
		channel_win_mem_addr_offset_o       : out std_logic_vector(63 downto 0) ---                 --        conduit_end_rmap_avm_configs_out.win_mem_addr_offset_signal
	);
end entity scom_synchronization_comm_top;

architecture rtl of scom_synchronization_comm_top is

	-- basic alias
	alias a_avs_clock is clock_sink_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- constants

	-- signals

	-- avs config signals
	signal s_avs_config_read_waitrequest  : std_logic;
	signal s_avs_config_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_config_wr_regs : t_scom_config_wr_regs;
	signal s_config_rd_regs : t_scom_config_rd_regs;

	-- sync manager signals
	signal s_ch_sync_trigger : std_logic;
	signal s_ch_sync_clear   : std_logic;

	-- frame manager signals
	signal s_frame_counter : std_logic_vector(15 downto 0);
	signal s_frame_number  : std_logic_vector(1 downto 0);

	-- timecode manager signals
	signal s_tx_timecode_tick    : std_logic;
	signal s_rx_timecode_tick    : std_logic;
	signal s_rx_timecode_control : std_logic_vector(1 downto 0);
	signal s_rx_timecode_counter : std_logic_vector(5 downto 0);

	-- rmap target top signals
	signal s_rmap_spw_control         : t_rmap_target_spw_control;
	signal s_rmap_spw_flag            : t_rmap_target_spw_flag;
	signal s_rmap_mem_control         : t_rmap_target_mem_control;
	signal s_rmap_mem_flag            : t_rmap_target_mem_flag;
	signal s_rmap_mem_wr_byte_address : std_logic_vector(31 downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector(31 downto 0);

begin

	-- SCOM AVS Config Read Instantiation
	scom_avs_config_read_ent_inst : entity work.scom_avs_config_read_ent
		port map(
			clk_i                    => a_avs_clock,
			rst_i                    => a_reset,
			avs_config_i.address     => avs_config_address_i,
			avs_config_i.read        => avs_config_read_i,
			avs_config_i.byteenable  => avs_config_byteenable_i,
			avs_config_o.readdata    => avs_config_readdata_o,
			avs_config_o.waitrequest => s_avs_config_read_waitrequest,
			config_wr_regs_i         => s_config_wr_regs,
			config_rd_regs_i         => s_config_rd_regs
		);

	-- SCOM AVS Config Write Instantiation
	scom_avs_config_write_ent_inst : entity work.scom_avs_config_write_ent
		port map(
			clk_i                    => a_avs_clock,
			rst_i                    => a_reset,
			avs_config_i.address     => avs_config_address_i,
			avs_config_i.write       => avs_config_write_i,
			avs_config_i.writedata   => avs_config_writedata_i,
			avs_config_i.byteenable  => avs_config_byteenable_i,
			avs_config_o.waitrequest => s_avs_config_write_waitrequest,
			config_wr_regs_o         => s_config_wr_regs
		);

	-- SCOM Sync Manager Instantiation
	scom_sync_manager_ent_inst : entity work.scom_sync_manager_ent
		port map(
			clk_i             => a_avs_clock,
			rst_i             => a_reset,
			channel_sync_i    => channel_sync_i,
			ch_sync_trigger_o => s_ch_sync_trigger,
			ch_sync_clear_o   => s_ch_sync_clear
		);

	-- SCOM Frame Manager Instantiation
	scom_frame_manager_ent_inst : entity work.scom_frame_manager_ent
		port map(
			clk_i             => a_avs_clock,
			rst_i             => a_reset,
			ch_sync_trigger_i => s_ch_sync_trigger,
			frame_clear_i     => s_config_wr_regs.spw_timecode_config_reg.timecode_clear,
			frame_counter_o   => s_frame_counter,
			frame_number_o    => s_frame_number
		);

	-- SCOM Timecode Manager Instantiation
	scom_timecode_manager_ent_inst : entity work.scom_timecode_manager_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			ch_sync_trigger_i     => s_ch_sync_trigger,
			tx_timecode_clear_i   => s_config_wr_regs.spw_timecode_config_reg.timecode_clear,
			tx_timecode_en_i      => s_config_wr_regs.spw_timecode_config_reg.timecode_en,
			rx_timecode_tick_i    => s_rx_timecode_tick,
			rx_timecode_control_i => s_rx_timecode_control,
			rx_timecode_counter_i => s_rx_timecode_counter,
			tx_timecode_tick_o    => s_tx_timecode_tick,
			tx_timecode_control_o => s_config_rd_regs.spw_timecode_status_reg.timecode_control,
			tx_timecode_counter_o => s_config_rd_regs.spw_timecode_status_reg.timecode_time
		);

	-- RMAP Target Top Instantiation
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => 8,
			g_MEMORY_ADDRESS_WIDTH => 32,
			g_DATA_LENGTH_WIDTH    => 24,
			g_MEMORY_ACCESS_WIDTH  => 0
		)
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			spw_flag_i                 => s_rmap_spw_flag,
			mem_flag_i                 => s_rmap_mem_flag,
			spw_control_o              => s_rmap_spw_control,
			conf_target_logical_addr_i => s_config_wr_regs.rmap_codec_config_reg.rmap_target_logical_addr,
			conf_target_key_i          => s_config_wr_regs.rmap_codec_config_reg.rmap_target_key,
			mem_control_o              => s_rmap_mem_control,
			mem_wr_byte_address_o      => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o      => s_rmap_mem_rd_byte_address,
			stat_command_received_o    => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_command_received,
			stat_write_requested_o     => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_write_requested,
			stat_write_authorized_o    => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_write_authorized,
			stat_write_finished_o      => open,
			stat_read_requested_o      => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_read_requested,
			stat_read_authorized_o     => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_read_authorized,
			stat_read_finished_o       => open,
			stat_reply_sended_o        => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_reply_sended,
			stat_discarded_package_o   => s_config_rd_regs.rmap_codec_status_reg.rmap_stat_discarded_package,
			err_early_eop_o            => s_config_rd_regs.rmap_codec_status_reg.rmap_err_early_eop,
			err_eep_o                  => s_config_rd_regs.rmap_codec_status_reg.rmap_err_eep,
			err_header_crc_o           => s_config_rd_regs.rmap_codec_status_reg.rmap_err_header_crc,
			err_unused_packet_type_o   => s_config_rd_regs.rmap_codec_status_reg.rmap_err_unused_packet_type,
			err_invalid_command_code_o => s_config_rd_regs.rmap_codec_status_reg.rmap_err_invalid_command_code,
			err_too_much_data_o        => s_config_rd_regs.rmap_codec_status_reg.rmap_err_too_much_data,
			err_invalid_data_crc_o     => s_config_rd_regs.rmap_codec_status_reg.rmap_err_invalid_data_crc
		);

	-- Signals Assigments --

	-- AVS Config Signals Assigments
	avs_config_waitrequest_o <= ((s_avs_config_read_waitrequest) and (s_avs_config_write_waitrequest)) when (a_reset = '0') else ('1');

	-- RMAP Memory Area Signals Assigments
	-- RMAP Master Target Read Inputs
	s_rmap_mem_flag.read.error        <= '0';
	s_rmap_mem_flag.read.data         <= rmm_rmap_target_readdata_i;
	s_rmap_mem_flag.read.waitrequest  <= rmm_rmap_target_rd_waitrequest_i;
	-- RMAP Master Target Write Inputs
	s_rmap_mem_flag.write.error       <= '0';
	s_rmap_mem_flag.write.waitrequest <= rmm_rmap_target_wr_waitrequest_i;
	-- RMAP Master Target Read Outputs
	rmm_rmap_target_rd_address_o      <= s_rmap_mem_rd_byte_address;
	rmm_rmap_target_read_o            <= s_rmap_mem_control.read.read;
	-- RMAP Master Target Write Outputs
	rmm_rmap_target_wr_address_o      <= s_rmap_mem_wr_byte_address;
	rmm_rmap_target_write_o           <= s_rmap_mem_control.write.write;
	rmm_rmap_target_writedata_o       <= s_rmap_mem_control.write.data;
	-- RMAP Master Hk Read Outputs
	rmm_fee_hk_rd_address_o           <= (others => '0');
	rmm_fee_hk_read_o                 <= '0';
	-- RMAP Master Hk Write Outputs
	rmm_fee_hk_wr_address_o           <= (others => '0');
	rmm_fee_hk_write_o                <= '0';
	rmm_fee_hk_writedata_o            <= (others => '0');

	-- SpaceWire Controller Signals Assignments
	s_config_rd_regs.spw_link_status_reg.spw_link_started    <= spw_link_status_started_i;
	s_config_rd_regs.spw_link_status_reg.spw_link_connecting <= spw_link_status_connecting_i;
	s_config_rd_regs.spw_link_status_reg.spw_link_running    <= spw_link_status_running_i;
	s_config_rd_regs.spw_link_status_reg.spw_err_disconnect  <= spw_link_error_errdisc_i;
	s_config_rd_regs.spw_link_status_reg.spw_err_parity      <= spw_link_error_errpar_i;
	s_config_rd_regs.spw_link_status_reg.spw_err_escape      <= spw_link_error_erresc_i;
	s_config_rd_regs.spw_link_status_reg.spw_err_credit      <= spw_link_error_errcred_i;
	s_rx_timecode_tick                                       <= spw_timecode_rx_tick_out_i;
	s_rx_timecode_control                                    <= spw_timecode_rx_ctrl_out_i;
	s_rx_timecode_counter                                    <= spw_timecode_rx_time_out_i;
	s_rmap_spw_flag.receiver.valid                           <= spw_data_rx_status_rxvalid_i;
	s_rmap_spw_flag.receiver.flag                            <= spw_data_rx_status_rxflag_i;
	s_rmap_spw_flag.receiver.data                            <= spw_data_rx_status_rxdata_i;
	s_rmap_spw_flag.transmitter.ready                        <= spw_data_tx_status_txrdy_i;
	spw_link_command_autostart_o                             <= s_config_wr_regs.spw_link_config_reg.spw_lnkcfg_autostart;
	spw_link_command_linkstart_o                             <= s_config_wr_regs.spw_link_config_reg.spw_lnkcfg_linkstart;
	spw_link_command_linkdis_o                               <= s_config_wr_regs.spw_link_config_reg.spw_lnkcfg_disconnect;
	spw_link_command_txdivcnt_o                              <= s_config_wr_regs.spw_link_config_reg.spw_lnkcfg_txdivcnt;
	spw_timecode_tx_tick_in_o                                <= s_tx_timecode_tick;
	spw_timecode_tx_ctrl_in_o                                <= s_config_rd_regs.spw_timecode_status_reg.timecode_control;
	spw_timecode_tx_time_in_o                                <= s_config_rd_regs.spw_timecode_status_reg.timecode_time;
	spw_data_rx_command_rxread_o                             <= s_rmap_spw_control.receiver.read;
	spw_data_tx_command_txwrite_o                            <= s_rmap_spw_control.transmitter.write;
	spw_data_tx_command_txflag_o                             <= s_rmap_spw_control.transmitter.flag;
	spw_data_tx_command_txdata_o                             <= s_rmap_spw_control.transmitter.data;

	-- Channel Hk Signals Assigments
	channel_hk_timecode_control_o       <= s_config_rd_regs.spw_timecode_status_reg.timecode_control;
	channel_hk_timecode_time_o          <= s_config_rd_regs.spw_timecode_status_reg.timecode_time;
	channel_hk_rmap_target_status_o     <= x"00";
	channel_hk_rmap_target_indicate_o   <= '0';
	channel_hk_spw_link_escape_err_o    <= s_config_rd_regs.spw_link_status_reg.spw_err_escape;
	channel_hk_spw_link_credit_err_o    <= s_config_rd_regs.spw_link_status_reg.spw_err_credit;
	channel_hk_spw_link_parity_err_o    <= s_config_rd_regs.spw_link_status_reg.spw_err_parity;
	channel_hk_spw_link_disconnect_o    <= s_config_rd_regs.spw_link_status_reg.spw_err_disconnect;
	channel_hk_spw_link_running_o       <= s_config_rd_regs.spw_link_status_reg.spw_link_running;
	channel_hk_frame_counter_o          <= s_frame_counter;
	channel_hk_frame_number_o           <= s_frame_number;
	channel_hk_err_win_wrong_x_coord_o  <= '0';
	channel_hk_err_win_wrong_y_coord_o  <= '0';
	channel_hk_err_e_side_buffer_full_o <= '0';
	channel_hk_err_f_side_buffer_full_o <= '0';
	channel_hk_err_invalid_ccd_mode_o   <= '0';

	-- Channel Memory Offset Signals Assigments
	channel_win_mem_addr_offset_o(63 downto 32) <= s_config_wr_regs.rmap_memory_config_reg.rmap_win_area_offset_high_dword;
	channel_win_mem_addr_offset_o(31 downto 0)  <= s_config_wr_regs.rmap_memory_config_reg.rmap_win_area_offset_low_dword;

end architecture rtl;                   -- of scom_synchronization_comm_top
