library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;
use work.comm_spw_mux_pkg.all;

entity comm_spw_mux_tx_mux is
	port(
		-- basic inputs
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		-- logic inputs
		control_i         : in  t_swtm_control;
		spw_status_i      : in  t_spwl_data_tx_status;
		channel_control_i : in  t_swtm_spw_control;
		channel_payload_i : in  t_swtm_spw_payload;
		-- logic outputs
		status_o          : out t_swtm_status;
		spw_control_o     : out t_spwl_data_tx_control;
		spw_payload_o     : out t_spwl_data_payload;
		channel_status_o  : out t_swtm_spw_status
	);
end entity comm_spw_mux_tx_mux;

architecture RTL of comm_spw_mux_tx_mux is

begin

end architecture RTL;
