library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;
use work.comm_spw_mux_pkg.all;

entity comm_spw_mux_rx_demux is
	port(
		-- basic inputs
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		-- logic inputs
		control_i         : in  t_swrd_control;
		spw_status_i      : in  t_spwl_data_rx_status;
		spw_payload_i     : in  t_spwl_data_payload;
		channel_control_i : in  t_swrd_spw_control;
		-- logic outputs
		status_o          : out t_swrd_status;
		spw_control_o     : out t_spwl_data_rx_control;
		channel_status_o  : out t_swrd_spw_status;
		channel_payload_o : out t_swrd_spw_payload
	);
end entity comm_spw_mux_rx_demux;

architecture RTL of comm_spw_mux_rx_demux is

begin

end architecture RTL;
