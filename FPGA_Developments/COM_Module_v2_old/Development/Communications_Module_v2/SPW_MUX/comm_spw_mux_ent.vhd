library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;
use work.comm_spw_mux_pkg.all;

entity comm_spw_mux_ent is
	port(
		-- basic inputs
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		-- registers inputs
		-- logic inputs
		spw_mux_spw_rx_status_i      : in  t_spwl_data_rx_status;
		spw_mux_spw_rx_payload_i     : in  t_spwl_data_payload;
		spw_mux_spw_tx_status_i      : in  t_spwl_data_tx_status;
		spw_mux_channel_rx_control_i : in  t_swrd_spw_control;
		spw_mux_channel_tx_control_i : in  t_swtm_spw_control;
		spw_mux_channel_tx_payload_i : in  t_swtm_spw_payload;
		-- registers output
		-- logic outputs
		spw_mux_spw_rx_control_o     : out t_spwl_data_rx_control;
		spw_mux_spw_tx_control_o     : out t_spwl_data_tx_control;
		spw_mux_spw_tx_payload_o     : out t_spwl_data_payload;
		spw_mux_channel_rx_status_o  : out t_swrd_spw_status;
		spw_mux_channel_rx_payload_o : out t_swrd_spw_payload;
		spw_mux_channel_tx_status_o  : out t_swtm_spw_status
	);
end entity comm_spw_mux_ent;

architecture RTL of comm_spw_mux_ent is

	-- spw mux rx demux signals
	signal s_swrd_control : t_swrd_control;
	signal s_swrd_status  : t_swrd_status;

	-- spw mux tx mux signals
	signal s_swtm_control : t_swtm_control;
	signal s_swtm_status  : t_swtm_status;

begin

	-- spw mux registers
	comm_spw_mux_registers_ent_inst : entity work.comm_spw_mux_registers_ent
		port map(
			clk_i          => clk_i,
			rst_i          => rst_i,
			swrd_status_i  => s_swrd_status,
			swtm_status_i  => s_swtm_status,
			swrd_control_o => s_swrd_control,
			swtm_control_o => s_swtm_control
		);

	-- spw mux rx demux
	comm_spw_mux_rx_demux_inst : entity work.comm_spw_mux_rx_demux
		port map(
			clk_i             => clk_i,
			rst_i             => rst_i,
			control_i         => s_swrd_control,
			spw_status_i      => spw_mux_spw_rx_status_i,
			spw_payload_i     => spw_mux_spw_rx_payload_i,
			channel_control_i => spw_mux_channel_rx_control_i,
			status_o          => s_swrd_status,
			spw_control_o     => spw_mux_spw_rx_control_o,
			channel_status_o  => spw_mux_channel_rx_status_o,
			channel_payload_o => spw_mux_channel_rx_payload_o
		);

	-- spw mux tx mux
	comm_spw_mux_tx_mux_inst : entity work.comm_spw_mux_tx_mux
		port map(
			clk_i             => clk_i,
			rst_i             => rst_i,
			control_i         => s_swtm_control,
			spw_status_i      => spw_mux_spw_tx_status_i,
			channel_control_i => spw_mux_channel_tx_control_i,
			channel_payload_i => spw_mux_channel_tx_payload_i,
			status_o          => s_swtm_status,
			spw_control_o     => spw_mux_spw_tx_control_o,
			spw_payload_o     => spw_mux_spw_tx_payload_o,
			channel_status_o  => spw_mux_channel_tx_status_o
		);

end architecture RTL;
