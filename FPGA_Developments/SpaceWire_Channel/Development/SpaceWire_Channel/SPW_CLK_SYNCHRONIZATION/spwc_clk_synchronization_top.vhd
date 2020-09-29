library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;
use work.spwc_errinj_pkg.all;

entity spwc_clk_synchronization_top is
	port(
		clk_avs_i                       : in  std_logic;
		clk_spw_i                       : in  std_logic;
		rst_i                           : in  std_logic;
		spw_codec_link_command_avs_i    : in  t_spwc_codec_link_command;
		spw_codec_timecode_tx_avs_i     : in  t_spwc_codec_timecode_tx;
		spw_codec_data_rx_command_avs_i : in  t_spwc_codec_data_rx_command;
		spw_codec_data_tx_command_avs_i : in  t_spwc_codec_data_tx_command;
		spw_errinj_ctrl_control_avs_i   : in  t_spwc_errinj_controller_control;
		spw_codec_link_status_spw_i     : in  t_spwc_codec_link_status;
		spw_codec_link_error_spw_i      : in  t_spwc_codec_link_error;
		spw_codec_timecode_rx_spw_i     : in  t_spwc_codec_timecode_rx;
		spw_codec_data_rx_status_spw_i  : in  t_spwc_codec_data_rx_status;
		spw_codec_data_tx_status_spw_i  : in  t_spwc_codec_data_tx_status;
		spw_errinj_ctrl_status_spw_i    : in  t_spwc_errinj_controller_status;
		spw_codec_link_status_avs_o     : out t_spwc_codec_link_status;
		spw_codec_link_error_avs_o      : out t_spwc_codec_link_error;
		spw_codec_timecode_rx_avs_o     : out t_spwc_codec_timecode_rx;
		spw_codec_data_rx_status_avs_o  : out t_spwc_codec_data_rx_status;
		spw_codec_data_tx_status_avs_o  : out t_spwc_codec_data_tx_status;
		spw_errinj_ctrl_status_avs_o    : out t_spwc_errinj_controller_status;
		spw_codec_link_command_spw_o    : out t_spwc_codec_link_command;
		spw_codec_timecode_tx_spw_o     : out t_spwc_codec_timecode_tx;
		spw_codec_data_rx_command_spw_o : out t_spwc_codec_data_rx_command;
		spw_codec_data_tx_command_spw_o : out t_spwc_codec_data_tx_command;
		spw_errinj_ctrl_control_spw_o   : out t_spwc_errinj_controller_control
	);
end entity spwc_clk_synchronization_top;

architecture RTL of spwc_clk_synchronization_top is

begin

	spwc_clk_synchronization_commands_ent_inst : entity work.spwc_clk_synchronization_commands_ent
		port map(
			clk_avs_i                 => clk_avs_i,
			clk_spw_i                 => clk_spw_i,
			rst_i                     => rst_i,
			link_command_avs_i        => spw_codec_link_command_avs_i,
			errinj_ctrl_control_avs_i => spw_errinj_ctrl_control_avs_i,
			link_command_spw_o        => spw_codec_link_command_spw_o,
			errinj_ctrl_control_spw_o => spw_errinj_ctrl_control_spw_o
		);

	spwc_clk_synchronization_status_ent_inst : entity work.spwc_clk_synchronization_status_ent
		port map(
			clk_avs_i                => clk_avs_i,
			clk_spw_i                => clk_spw_i,
			rst_i                    => rst_i,
			link_status_spw_i        => spw_codec_link_status_spw_i,
			link_error_spw_i         => spw_codec_link_error_spw_i,
			errinj_ctrl_status_spw_i => spw_errinj_ctrl_status_spw_i,
			link_status_avs_o        => spw_codec_link_status_avs_o,
			link_error_avs_o         => spw_codec_link_error_avs_o,
			errinj_ctrl_status_avs_o => spw_errinj_ctrl_status_avs_o
		);

	spwc_clk_synchronization_tx_data_ent_inst : entity work.spwc_clk_synchronization_tx_data_ent
		port map(
			clk_avs_i          => clk_avs_i,
			clk_spw_i          => clk_spw_i,
			rst_i              => rst_i,
			data_command_avs_i => spw_codec_data_tx_command_avs_i,
			data_status_spw_i  => spw_codec_data_tx_status_spw_i,
			data_status_avs_o  => spw_codec_data_tx_status_avs_o,
			data_command_spw_o => spw_codec_data_tx_command_spw_o
		);

	spwc_clk_synchronization_rx_data_ent_inst : entity work.spwc_clk_synchronization_rx_data_ent
		port map(
			clk_avs_i          => clk_avs_i,
			clk_spw_i          => clk_spw_i,
			rst_i              => rst_i,
			data_command_avs_i => spw_codec_data_rx_command_avs_i,
			data_status_spw_i  => spw_codec_data_rx_status_spw_i,
			data_status_avs_o  => spw_codec_data_rx_status_avs_o,
			data_command_spw_o => spw_codec_data_rx_command_spw_o
		);

	spwc_clk_synchronization_tx_timecode_ent_inst : entity work.spwc_clk_synchronization_tx_timecode_ent
		port map(
			clk_avs_i      => clk_avs_i,
			clk_spw_i      => clk_spw_i,
			rst_i          => rst_i,
			timecode_avs_i => spw_codec_timecode_tx_avs_i,
			timecode_spw_o => spw_codec_timecode_tx_spw_o
		);

	spwc_clk_synchronization_rx_timecode_ent_inst : entity work.spwc_clk_synchronization_rx_timecode_ent
		port map(
			clk_avs_i      => clk_avs_i,
			clk_spw_i      => clk_spw_i,
			rst_i          => rst_i,
			timecode_spw_i => spw_codec_timecode_rx_spw_i,
			timecode_avs_o => spw_codec_timecode_rx_avs_o
		);

end architecture RTL;
