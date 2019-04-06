library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity spw_clk_synchronization_ent is
	port(
		clk_100_i                          : in  std_logic;
		clk_200_i                          : in  std_logic;
		rst_i                              : in  std_logic;
		spw_codec_link_command_clk100_i    : in  t_spw_codec_link_command;
		spw_codec_timecode_tx_clk100_i     : in  t_spw_codec_timecode_tx;
		spw_codec_data_rx_command_clk100_i : in  t_spw_codec_data_rx_command;
		spw_codec_data_tx_command_clk100_i : in  t_spw_codec_data_tx_command;
		spw_codec_link_status_clk200_i     : in  t_spw_codec_link_status;
		spw_codec_link_error_clk200_i      : in  t_spw_codec_link_error;
		spw_codec_timecode_rx_clk200_i     : in  t_spw_codec_timecode_rx;
		spw_codec_data_rx_status_clk200_i  : in  t_spw_codec_data_rx_status;
		spw_codec_data_tx_status_clk200_i  : in  t_spw_codec_data_tx_status;
		spw_codec_link_status_clk100_o     : out t_spw_codec_link_status;
		spw_codec_link_error_clk100_o      : out t_spw_codec_link_error;
		spw_codec_timecode_rx_clk100_o     : out t_spw_codec_timecode_rx;
		spw_codec_data_rx_status_clk100_o  : out t_spw_codec_data_rx_status;
		spw_codec_data_tx_status_clk100_o  : out t_spw_codec_data_tx_status;
		spw_codec_link_command_clk200_o    : out t_spw_codec_link_command;
		spw_codec_timecode_tx_clk200_o     : out t_spw_codec_timecode_tx;
		spw_codec_data_rx_command_clk200_o : out t_spw_codec_data_rx_command;
		spw_codec_data_tx_command_clk200_o : out t_spw_codec_data_tx_command
	);
end entity spw_clk_synchronization_ent;

architecture RTL of spw_clk_synchronization_ent is

begin

	spw_codec_link_status_clk100_o     <= spw_codec_link_status_clk200_i;
	spw_codec_link_error_clk100_o      <= spw_codec_link_error_clk200_i;
	spw_codec_timecode_rx_clk100_o     <= spw_codec_timecode_rx_clk200_i;
	spw_codec_data_rx_status_clk100_o  <= spw_codec_data_rx_status_clk200_i;
	spw_codec_data_tx_status_clk100_o  <= spw_codec_data_tx_status_clk200_i;
	spw_codec_link_command_clk200_o    <= spw_codec_link_command_clk100_i;
	spw_codec_timecode_tx_clk200_o     <= spw_codec_timecode_tx_clk100_i;
	spw_codec_data_rx_command_clk200_o <= spw_codec_data_rx_command_clk100_i;
	spw_codec_data_tx_command_clk200_o <= spw_codec_data_tx_command_clk100_i;

end architecture RTL;
