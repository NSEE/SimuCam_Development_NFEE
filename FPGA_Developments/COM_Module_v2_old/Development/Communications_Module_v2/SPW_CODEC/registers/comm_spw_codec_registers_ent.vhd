library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;

entity comm_spw_codec_registers_ent is
	port(
		-- basic inputs
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		-- logic inputs
		spwl_link_status_i         : in  t_spwl_link_status;
		spwl_link_error_i          : in  t_spwl_link_error;
		spwl_timecode_rx_status_i  : in  t_spwl_timecode_rx_status;
		spwl_timecode_rx_payload_i : in  t_spwl_timecode_payload;
		-- logic outputs
		spwl_link_config_o         : out t_spwl_link_config;
		spwl_timecode_tx_control_o : out t_spwl_timecode_tx_control;
		spwl_timecode_tx_payload_o : out t_spwl_timecode_payload;
		swil_control_o             : out t_swil_control;
		swel_control_o             : out t_swel_control
	);
end entity comm_spw_codec_registers_ent;

architecture RTL of comm_spw_codec_registers_ent is

begin

end architecture RTL;
