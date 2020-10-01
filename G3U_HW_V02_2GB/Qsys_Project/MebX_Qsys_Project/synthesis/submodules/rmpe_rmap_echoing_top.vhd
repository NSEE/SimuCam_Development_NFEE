-- rmpe_rmap_echoing_top.vhd

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

use work.rmpe_rmap_echoing_pkg.all;

entity rmpe_rmap_echoing_top is
	port(
		reset_i                        : in  std_logic                    := '0'; --          --                       reset_sink.reset
		clk_100_i                      : in  std_logic                    := '0'; --          --                clock_sink_100mhz.clk
		rmap_echo_0_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_0_in.echo_en_signal
		rmap_echo_0_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_0_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_0_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_0_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_0_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_0_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_0_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		rmap_echo_1_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_1_in.echo_en_signal
		rmap_echo_1_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_1_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_1_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_1_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_1_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_1_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_1_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		rmap_echo_2_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_2_in.echo_en_signal
		rmap_echo_2_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_2_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_2_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_2_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_2_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_2_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_2_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		rmap_echo_3_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_3_in.echo_en_signal
		rmap_echo_3_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_3_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_3_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_3_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_3_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_3_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_3_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		rmap_echo_4_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_4_in.echo_en_signal
		rmap_echo_4_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_4_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_4_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_4_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_4_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_4_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_4_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		rmap_echo_5_echo_en_i          : in  std_logic                    := '0'; --          --       conduit_end_rmap_echo_5_in.echo_en_signal
		rmap_echo_5_echo_id_en_i       : in  std_logic                    := '0'; --          --                                 .echo_id_en_signal
		rmap_echo_5_in_fifo_wrflag_i   : in  std_logic                    := '0'; --          --                                 .in_fifo_wrflag_signal
		rmap_echo_5_in_fifo_wrdata_i   : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .in_fifo_wrdata_signal
		rmap_echo_5_in_fifo_wrreq_i    : in  std_logic                    := '0'; --          --                                 .in_fifo_wrreq_signal
		rmap_echo_5_out_fifo_wrflag_i  : in  std_logic                    := '0'; --          --                                 .out_fifo_wrflag_signal
		rmap_echo_5_out_fifo_wrdata_i  : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .out_fifo_wrdata_signal
		rmap_echo_5_out_fifo_wrreq_i   : in  std_logic                    := '0'; --          --                                 .out_fifo_wrreq_signal
		spw_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_controller.spw_link_status_started_signal
		spw_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                 .spw_link_status_connecting_signal
		spw_link_status_running_i      : in  std_logic                    := '0'; --          --                                 .spw_link_status_running_signal
		spw_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                 .spw_link_error_errdisc_signal
		spw_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                 .spw_link_error_errpar_signal
		spw_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                 .spw_link_error_erresc_signal
		spw_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                 .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                 .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                 .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                 .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                 .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                 .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                 .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                 .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                 .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                 .spw_data_tx_status_txhalff_signal
		spw_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                 .spw_errinj_ctrl_errinj_busy_signal
		spw_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                 .spw_errinj_ctrl_errinj_ready_signal
		spw_link_command_autostart_o   : out std_logic; --                                    --                                 .spw_link_command_autostart_signal
		spw_link_command_linkstart_o   : out std_logic; --                                    --                                 .spw_link_command_linkstart_signal
		spw_link_command_linkdis_o     : out std_logic; --                                    --                                 .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                 --                                 .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_o      : out std_logic; --                                    --                                 .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                 --                                 .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                 --                                 .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_o   : out std_logic; --                                    --                                 .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_o  : out std_logic; --                                    --                                 .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_o   : out std_logic; --                                    --                                 .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                 --                                 .spw_data_tx_command_txdata_signal
		spw_errinj_ctrl_start_errinj_o : out std_logic; --                                    --                                 .spw_errinj_ctrl_start_errinj_signal
		spw_errinj_ctrl_reset_errinj_o : out std_logic; --                                    --                                 .spw_errinj_ctrl_reset_errinj_signal
		spw_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0) ---                 --                                 .spw_errinj_ctrl_errinj_code_signal
	);
end entity rmpe_rmap_echoing_top;

architecture rtl of rmpe_rmap_echoing_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock_i is clk_100_i;
	alias a_reset_i is reset_i;

	-- Constants --

	-- Signals --

	-- RMAP Data FIFO Signals
	signal s_rmap_echo_0_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_0_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_0_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_0_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_1_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_1_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_1_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_1_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_2_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_2_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_2_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_2_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_3_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_3_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_3_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_3_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_4_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_4_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_4_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_4_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_5_in_fifo_control  : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_5_in_fifo_status   : t_rmpe_rmap_echoing_rmap_fifo_status;
	signal s_rmap_echo_5_out_fifo_control : t_rmpe_rmap_echoing_rmap_fifo_control;
	signal s_rmap_echo_5_out_fifo_status  : t_rmpe_rmap_echoing_rmap_fifo_status;

begin

	-- Entities Instantiation --

	-- FEE 0 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_0_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"0",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_0_echo_en_i,
			echo_id_en_i                   => rmap_echo_0_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_0_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_0_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_0_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_0_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_0_in_fifo_status
		);

	-- FEE 1 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_1_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"1",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_1_echo_en_i,
			echo_id_en_i                   => rmap_echo_1_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_1_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_1_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_1_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_1_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_1_in_fifo_status
		);

	-- FEE 2 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_2_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"2",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_2_echo_en_i,
			echo_id_en_i                   => rmap_echo_2_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_2_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_2_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_2_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_2_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_2_in_fifo_status
		);

	-- FEE 3 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_3_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"3",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_3_echo_en_i,
			echo_id_en_i                   => rmap_echo_3_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_3_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_3_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_3_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_3_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_3_in_fifo_status
		);

	-- FEE 4 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_4_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"4",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_4_echo_en_i,
			echo_id_en_i                   => rmap_echo_4_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_4_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_4_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_4_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_4_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_4_in_fifo_status
		);

	-- FEE 5 RMAP Incoming Echo Controller Instantiation
	rmpe_rmap_echo_5_in_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"5",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_INCOMING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_5_echo_en_i,
			echo_id_en_i                   => rmap_echo_5_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_5_in_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_5_in_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_5_in_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_5_in_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_5_in_fifo_status
		);

	-- FEE 0 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_0_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"0",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_0_echo_en_i,
			echo_id_en_i                   => rmap_echo_0_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_0_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_0_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_0_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_0_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_0_out_fifo_status
		);

	-- FEE 1 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_1_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"1",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_1_echo_en_i,
			echo_id_en_i                   => rmap_echo_1_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_1_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_1_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_1_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_1_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_1_out_fifo_status
		);

	-- FEE 2 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_2_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"2",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_2_echo_en_i,
			echo_id_en_i                   => rmap_echo_2_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_2_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_2_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_2_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_2_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_2_out_fifo_status
		);

	-- FEE 3 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_3_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"3",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_3_echo_en_i,
			echo_id_en_i                   => rmap_echo_3_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_3_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_3_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_3_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_3_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_3_out_fifo_status
		);

	-- FEE 4 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_4_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"4",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_4_echo_en_i,
			echo_id_en_i                   => rmap_echo_4_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_4_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_4_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_4_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_4_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_4_out_fifo_status
		);

	-- FEE 5 RMAP Outgoing Echo Controller Instantiation
	rmpe_rmap_echo_5_out_echo_controller_ent_inst : entity work.rmpe_rmap_echo_controller_ent
		generic map(
			g_RMAP_FIFO_OVERFLOW_EN => c_RMAP_FIFO_OVERFLOW_EN,
			g_FEE_CHANNEL_ID        => x"5",
			g_RMAP_PACKAGE_ID       => c_RMAP_PACKAGE_ID_OUTGOING
		)
		port map(
			clk_i                          => a_avs_clock_i,
			rst_i                          => a_reset_i,
			echo_en_i                      => rmap_echo_5_echo_en_i,
			echo_id_en_i                   => rmap_echo_5_echo_id_en_i,
			spw_fifo_control_i.wrdata_flag => rmap_echo_5_out_fifo_wrflag_i,
			spw_fifo_control_i.wrdata_data => rmap_echo_5_out_fifo_wrdata_i,
			spw_fifo_control_i.wrreq       => rmap_echo_5_out_fifo_wrreq_i,
			rmap_fifo_control_i            => s_rmap_echo_5_out_fifo_control,
			spw_fifo_status_o              => open,
			rmap_fifo_status_o             => s_rmap_echo_5_out_fifo_status
		);

	-- RMAP Echo Transmitter Instantiation
	rmpe_rmap_echo_transmitter_ent_inst : entity work.rmpe_rmap_echo_transmitter_ent
		port map(
			clk_i                              => a_avs_clock_i,
			rst_i                              => a_reset_i,
			fee_0_rmap_incoming_fifo_status_i  => s_rmap_echo_0_in_fifo_status,
			fee_0_rmap_outgoing_fifo_status_i  => s_rmap_echo_0_out_fifo_status,
			fee_1_rmap_incoming_fifo_status_i  => s_rmap_echo_1_in_fifo_status,
			fee_1_rmap_outgoing_fifo_status_i  => s_rmap_echo_1_out_fifo_status,
			fee_2_rmap_incoming_fifo_status_i  => s_rmap_echo_2_in_fifo_status,
			fee_2_rmap_outgoing_fifo_status_i  => s_rmap_echo_2_out_fifo_status,
			fee_3_rmap_incoming_fifo_status_i  => s_rmap_echo_3_in_fifo_status,
			fee_3_rmap_outgoing_fifo_status_i  => s_rmap_echo_3_out_fifo_status,
			fee_4_rmap_incoming_fifo_status_i  => s_rmap_echo_4_in_fifo_status,
			fee_4_rmap_outgoing_fifo_status_i  => s_rmap_echo_4_out_fifo_status,
			fee_5_rmap_incoming_fifo_status_i  => s_rmap_echo_5_in_fifo_status,
			fee_5_rmap_outgoing_fifo_status_i  => s_rmap_echo_5_out_fifo_status,
			spw_codec_status_i.txrdy           => spw_data_tx_status_txrdy_i,
			spw_codec_status_i.txhalff         => spw_data_tx_status_txhalff_i,
			fee_0_rmap_incoming_fifo_control_o => s_rmap_echo_0_in_fifo_control,
			fee_0_rmap_outgoing_fifo_control_o => s_rmap_echo_0_out_fifo_control,
			fee_1_rmap_incoming_fifo_control_o => s_rmap_echo_1_in_fifo_control,
			fee_1_rmap_outgoing_fifo_control_o => s_rmap_echo_1_out_fifo_control,
			fee_2_rmap_incoming_fifo_control_o => s_rmap_echo_2_in_fifo_control,
			fee_2_rmap_outgoing_fifo_control_o => s_rmap_echo_2_out_fifo_control,
			fee_3_rmap_incoming_fifo_control_o => s_rmap_echo_3_in_fifo_control,
			fee_3_rmap_outgoing_fifo_control_o => s_rmap_echo_3_out_fifo_control,
			fee_4_rmap_incoming_fifo_control_o => s_rmap_echo_4_in_fifo_control,
			fee_4_rmap_outgoing_fifo_control_o => s_rmap_echo_4_out_fifo_control,
			fee_5_rmap_incoming_fifo_control_o => s_rmap_echo_5_in_fifo_control,
			fee_5_rmap_outgoing_fifo_control_o => s_rmap_echo_5_out_fifo_control,
			spw_codec_control_o.txwrite        => spw_data_tx_command_txwrite_o,
			spw_codec_control_o.txflag         => spw_data_tx_command_txflag_o,
			spw_codec_control_o.txdata         => spw_data_tx_command_txdata_o
		);

	-- Signals Assignments and Processes --

	-- SpaceWire Channel Codec Configuration
	p_spwc_codec_config : process(a_avs_clock_i, a_reset_i) is
	begin
		if (a_reset_i = '1') then
			spw_link_command_autostart_o   <= '0';
			spw_link_command_linkstart_o   <= '0';
			spw_link_command_linkdis_o     <= '0';
			spw_link_command_txdivcnt_o    <= x"01";
			spw_timecode_tx_tick_in_o      <= '0';
			spw_timecode_tx_ctrl_in_o      <= (others => '0');
			spw_timecode_tx_time_in_o      <= (others => '0');
			spw_errinj_ctrl_start_errinj_o <= '0';
			spw_errinj_ctrl_reset_errinj_o <= '0';
			spw_errinj_ctrl_errinj_code_o  <= (others => '0');
		elsif rising_edge(a_avs_clock_i) then
			spw_link_command_autostart_o   <= '1';
			spw_link_command_linkstart_o   <= '0';
			spw_link_command_linkdis_o     <= '0';
			spw_link_command_txdivcnt_o    <= x"01";
			spw_timecode_tx_tick_in_o      <= '0';
			spw_timecode_tx_ctrl_in_o      <= (others => '0');
			spw_timecode_tx_time_in_o      <= (others => '0');
			spw_errinj_ctrl_start_errinj_o <= '0';
			spw_errinj_ctrl_reset_errinj_o <= '0';
			spw_errinj_ctrl_errinj_code_o  <= (others => '0');
		end if;
	end process p_spwc_codec_config;

	-- SpaceWire Channel Glutton Reader
	p_spwc_codec_glutton_reader : process(a_avs_clock_i, a_reset_i) is
	begin
		if (a_reset_i = '1') then
			spw_data_rx_command_rxread_o <= '0';
		elsif rising_edge(a_avs_clock_i) then
			spw_data_rx_command_rxread_o <= '0';
			if (spw_data_rx_status_rxvalid_i = '1') then
				spw_data_rx_command_rxread_o <= '1';
			end if;
		end if;
	end process p_spwc_codec_glutton_reader;

end architecture rtl;                   -- of rmpe_rmap_echoing_top
