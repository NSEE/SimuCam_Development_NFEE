library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spw_testbench_top is
end entity spw_testbench_top;

architecture RTL of spw_testbench_top is

	signal clk_100 : std_logic := '0';
	signal clk_200 : std_logic := '0';
	signal rst     : std_logic := '1';
	signal rst_n   : std_logic;

	signal s_stimuli_codec_link_command_in : spwc_codec_link_command_in_type;
	signal s_stimuli_codec_link_status_out : spwc_codec_link_status_out_type;
	signal s_stimuli_codec_link_error_out  : spwc_codec_link_error_out_type;
	signal s_stimuli_codec_timecode_rx_out : spwc_codec_timecode_rx_out_type;
	signal s_stimuli_codec_timecode_tx_in  : spwc_codec_timecode_tx_in_type;
	signal s_stimuli_codec_data_rx_in      : spwc_codec_data_rx_in_type;
	signal s_stimuli_codec_data_rx_out     : spwc_codec_data_rx_out_type;
	signal s_stimuli_codec_data_tx_in      : spwc_codec_data_tx_in_type;
	signal s_stimuli_codec_data_tx_out     : spwc_codec_data_tx_out_type;

	signal s_master_codec_ds_encoding_rx_in  : spwc_codec_ds_encoding_rx_in_type;
	signal s_master_codec_ds_encoding_tx_out : spwc_codec_ds_encoding_tx_out_type;

	signal s_slave_mm_write_registers             : spwc_mm_write_registers_type;
	signal s_slave_mm_read_registers              : spwc_mm_read_registers_type;
	signal s_slave_rx_data_dc_fifo_clk200_outputs : spwc_rx_data_dc_fifo_clk200_outputs_type;
	signal s_slave_rx_data_dc_fifo_clk200_inputs  : spwc_rx_data_dc_fifo_clk200_inputs_type;
	signal s_slave_tx_data_dc_fifo_clk200_outputs : spwc_tx_data_dc_fifo_clk200_outputs_type;
	signal s_slave_tx_data_dc_fifo_clk200_inputs  : spwc_tx_data_dc_fifo_clk200_inputs_type;
	signal s_slave_codec_ds_encoding_rx_in        : spwc_codec_ds_encoding_rx_in_type;
	signal s_slave_codec_ds_encoding_tx_out       : spwc_codec_ds_encoding_tx_out_type;

begin

	clk_100 <= not clk_100 after 5 ns;
	clk_200 <= not clk_200 after 2.5 ns;
	rst     <= '0' after 100 ns;
	rst_n   <= not rst;

	-- "Master" Unit (External)
	spwc_codec_ent_inst : entity work.spwc_codec_ent
		port map(
			clk_200                       => clk_200,
			rst                           => rst,
			spwc_codec_link_command_in    => s_stimuli_codec_link_command_in,
			spwc_codec_link_status_out    => s_stimuli_codec_link_status_out,
			spwc_codec_ds_encoding_rx_in  => s_master_codec_ds_encoding_rx_in,
			spwc_codec_ds_encoding_tx_out => s_master_codec_ds_encoding_tx_out,
			spwc_codec_link_error_out     => s_stimuli_codec_link_error_out,
			spwc_codec_timecode_rx_out    => s_stimuli_codec_timecode_rx_out,
			spwc_codec_timecode_tx_in     => s_stimuli_codec_timecode_tx_in,
			spwc_codec_data_rx_in         => s_stimuli_codec_data_rx_in,
			spwc_codec_data_rx_out        => s_stimuli_codec_data_rx_out,
			spwc_codec_data_tx_in         => s_stimuli_codec_data_tx_in,
			spwc_codec_data_tx_out        => s_stimuli_codec_data_tx_out
		);

	-- "Slave" Unit (Internal)
	spwc_codec_controller_ent_inst : entity work.spwc_codec_controller_ent
		port map(
			clk100                              => clk_100,
			clk200                              => clk_200,
			rst                                 => rst,
			spwc_mm_write_registers             => s_slave_mm_write_registers,
			spwc_mm_read_registers              => s_slave_mm_read_registers,
			spwc_rx_data_dc_fifo_clk200_outputs => s_slave_rx_data_dc_fifo_clk200_outputs,
			spwc_rx_data_dc_fifo_clk200_inputs  => s_slave_rx_data_dc_fifo_clk200_inputs,
			spwc_tx_data_dc_fifo_clk200_outputs => s_slave_tx_data_dc_fifo_clk200_outputs,
			spwc_tx_data_dc_fifo_clk200_inputs  => s_slave_tx_data_dc_fifo_clk200_inputs,
			spwc_codec_ds_encoding_rx_in        => s_slave_codec_ds_encoding_rx_in,
			spwc_codec_ds_encoding_tx_out       => s_slave_codec_ds_encoding_tx_out
		);

	s_slave_codec_ds_encoding_rx_in.spw_di  <= s_master_codec_ds_encoding_tx_out.spw_do;
	s_slave_codec_ds_encoding_rx_in.spw_si  <= s_master_codec_ds_encoding_tx_out.spw_so;
	s_master_codec_ds_encoding_rx_in.spw_di <= s_slave_codec_ds_encoding_tx_out.spw_do;
	s_master_codec_ds_encoding_rx_in.spw_si <= s_slave_codec_ds_encoding_tx_out.spw_so;

	-- Master Stimuli
	spw_stimuli_ent_inst : entity work.spw_stimuli_ent
		port map(
			clk_200                     => clk_200,
			rst                         => rst,
			spwc_codec_link_command_out => s_stimuli_codec_link_command_in,
			spwc_codec_link_status_in   => s_stimuli_codec_link_status_out,
			spwc_codec_link_error_in    => s_stimuli_codec_link_error_out,
			spwc_codec_timecode_rx_in   => s_stimuli_codec_timecode_rx_out,
			spwc_codec_timecode_tx_out  => s_stimuli_codec_timecode_tx_in,
			spwc_codec_data_rx_out      => s_stimuli_codec_data_rx_in,
			spwc_codec_data_rx_in       => s_stimuli_codec_data_rx_out,
			spwc_codec_data_tx_out      => s_stimuli_codec_data_tx_in,
			spwc_codec_data_tx_in       => s_stimuli_codec_data_tx_out
		);

	-- Slave Stimuli
	spw_config_stimuli_ent_inst : entity work.spw_config_stimuli_ent
		port map(
			clk_100                             => clk_100,
			clk_200                             => clk_200,
			rst                                 => rst,
			spwc_mm_write_registers             => s_slave_mm_write_registers,
			spwc_mm_read_registers              => s_slave_mm_read_registers,
			spwc_rx_data_dc_fifo_clk200_inputs  => s_slave_rx_data_dc_fifo_clk200_outputs,
			spwc_rx_data_dc_fifo_clk200_outputs => s_slave_rx_data_dc_fifo_clk200_inputs,
			spwc_tx_data_dc_fifo_clk200_inputs  => s_slave_tx_data_dc_fifo_clk200_outputs,
			spwc_tx_data_dc_fifo_clk200_outputs => s_slave_tx_data_dc_fifo_clk200_inputs
		);

end architecture RTL;
