library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;
use work.spwc_errinj_pkg.all;

entity testbench_synchronization_top is
end entity testbench_synchronization_top;

architecture RTL of testbench_synchronization_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals
	signal s_spw_codec_link_command_avs    : t_spwc_codec_link_command;
	signal s_spw_codec_timecode_tx_avs     : t_spwc_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_avs : t_spwc_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_avs : t_spwc_codec_data_tx_command;
	signal s_spw_codec_link_status_avs     : t_spwc_codec_link_status;
	signal s_spw_codec_link_error_avs      : t_spwc_codec_link_error;
	signal s_spw_codec_timecode_rx_avs     : t_spwc_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_avs  : t_spwc_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_avs  : t_spwc_codec_data_tx_status;

	signal s_spw_codec_link_status_spw     : t_spwc_codec_link_status;
	signal s_spw_codec_link_error_spw      : t_spwc_codec_link_error;
	signal s_spw_codec_timecode_rx_spw     : t_spwc_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_spw  : t_spwc_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_spw  : t_spwc_codec_data_tx_status;
	signal s_spw_codec_link_command_spw    : t_spwc_codec_link_command;
	signal s_spw_codec_timecode_tx_spw     : t_spwc_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_spw : t_spwc_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_spw : t_spwc_codec_data_tx_command;

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	config_spw_stimuli_inst : entity work.config_spw_stimuli
		port map(
			clk_spw_i                       => clk200,
			rst_i                           => rst,
			spw_codec_link_command_spw_i    => s_spw_codec_link_command_spw,
			spw_codec_timecode_tx_spw_i     => s_spw_codec_timecode_tx_spw,
			spw_codec_data_rx_command_spw_i => s_spw_codec_data_rx_command_spw,
			spw_codec_data_tx_command_spw_i => s_spw_codec_data_tx_command_spw,
			spw_codec_link_status_spw_o     => s_spw_codec_link_status_spw,
			spw_codec_link_error_spw_o      => s_spw_codec_link_error_spw,
			spw_codec_timecode_rx_spw_o     => s_spw_codec_timecode_rx_spw,
			spw_codec_data_rx_status_spw_o  => s_spw_codec_data_rx_status_spw,
			spw_codec_data_tx_status_spw_o  => s_spw_codec_data_tx_status_spw
		);

	config_avs_stimuli_inst : entity work.config_avs_stimuli
		port map(
			clk_avs_i                       => clk100,
			rst_i                           => rst,
			spw_codec_link_status_avs_i     => s_spw_codec_link_status_avs,
			spw_codec_link_error_avs_i      => s_spw_codec_link_error_avs,
			spw_codec_timecode_rx_avs_i     => s_spw_codec_timecode_rx_avs,
			spw_codec_data_rx_status_avs_i  => s_spw_codec_data_rx_status_avs,
			spw_codec_data_tx_status_avs_i  => s_spw_codec_data_tx_status_avs,
			spw_codec_link_command_avs_o    => s_spw_codec_link_command_avs,
			spw_codec_timecode_tx_avs_o     => s_spw_codec_timecode_tx_avs,
			spw_codec_data_rx_command_avs_o => s_spw_codec_data_rx_command_avs,
			spw_codec_data_tx_command_avs_o => s_spw_codec_data_tx_command_avs
		);

	spwc_clk_synchronization_top_inst : entity work.spwc_clk_synchronization_top
		port map(
			clk_avs_i                       => clk100,
			clk_spw_i                       => clk200,
			rst_i                           => rst,
			spw_codec_link_command_avs_i    => s_spw_codec_link_command_avs,
			spw_codec_timecode_tx_avs_i     => s_spw_codec_timecode_tx_avs,
			spw_codec_data_rx_command_avs_i => s_spw_codec_data_rx_command_avs,
			spw_codec_data_tx_command_avs_i => s_spw_codec_data_tx_command_avs,
			spw_errinj_ctrl_control_avs_i   => c_SPWC_ERRINJ_CONTROLLER_CONTROL_RST,
			spw_codec_link_status_spw_i     => s_spw_codec_link_status_spw,
			spw_codec_link_error_spw_i      => s_spw_codec_link_error_spw,
			spw_codec_timecode_rx_spw_i     => s_spw_codec_timecode_rx_spw,
			spw_codec_data_rx_status_spw_i  => s_spw_codec_data_rx_status_spw,
			spw_codec_data_tx_status_spw_i  => s_spw_codec_data_tx_status_spw,
			spw_errinj_ctrl_status_spw_i    => c_SPWC_ERRINJ_CONTROLLER_STATUS_RST,
			spw_codec_link_status_avs_o     => s_spw_codec_link_status_avs,
			spw_codec_link_error_avs_o      => s_spw_codec_link_error_avs,
			spw_codec_timecode_rx_avs_o     => s_spw_codec_timecode_rx_avs,
			spw_codec_data_rx_status_avs_o  => s_spw_codec_data_rx_status_avs,
			spw_codec_data_tx_status_avs_o  => s_spw_codec_data_tx_status_avs,
			spw_errinj_ctrl_status_avs_o    => open,
			spw_codec_link_command_spw_o    => s_spw_codec_link_command_spw,
			spw_codec_timecode_tx_spw_o     => s_spw_codec_timecode_tx_spw,
			spw_codec_data_rx_command_spw_o => s_spw_codec_data_rx_command_spw,
			spw_codec_data_tx_command_spw_o => s_spw_codec_data_tx_command_spw,
			spw_errinj_ctrl_control_spw_o   => open
		);

end architecture RTL;
