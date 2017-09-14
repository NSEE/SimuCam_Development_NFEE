library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_mm_registers_pkg.all;
use work.spwc_avalon_mm_pkg.all;
use work.spwc_bus_controller_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;
use work.spwc_codec_pkg.all;

entity spwc_topfile_ent is
	port(
		clk100                        : in  std_logic;
		clk200                        : in  std_logic;
		rst                           : in  std_logic;
		spwc_interrupt_outputs        : out std_logic;
		spwc_avalon_mm_write_inputs   : in  spwc_avalon_mm_write_inputs_type;
		spwc_avalon_mm_write_outputs  : out spwc_avalon_mm_write_outputs_type;
		spwc_avalon_mm_read_inputs    : in  spwc_avalon_mm_read_inputs_type;
		spwc_avalon_mm_read_outputs   : out spwc_avalon_mm_read_outputs_type;
		spwc_tx_bc_write_bus_inputs   : in  spwc_bc_write_bus_inputs_type;
		spwc_tx_bc_write_bus_outputs  : out spwc_bc_write_bus_outputs_type;
		spwc_rx_bc_read_bus_inputs    : in  spwc_bc_read_bus_inputs_type;
		spwc_rx_bc_read_bus_outputs   : out spwc_bc_read_bus_outputs_type;
		spwc_codec_ds_encoding_rx_in  : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_out : out spwc_codec_ds_encoding_tx_out_type
	);
end entity spwc_topfile_ent;

architecture spwc_topfile_arc of spwc_topfile_ent is

	alias avalon_clock is clk100;
	alias codec_clock is clk200;
	alias reset is rst;

	signal spwc_mm_write_registers_sig : spwc_mm_write_registers_type;
	signal spwc_mm_read_registers_sig  : spwc_mm_read_registers_type;

	signal spwc_avalon_mm_write_inputs_sig  : spwc_avalon_mm_write_inputs_type;
	signal spwc_avalon_mm_write_outputs_sig : spwc_avalon_mm_write_outputs_type;
	signal spwc_avalon_mm_read_inputs_sig   : spwc_avalon_mm_read_inputs_type;
	signal spwc_avalon_mm_read_outputs_sig  : spwc_avalon_mm_read_outputs_type;

	signal spwc_bc_control_inputs_sig : spwc_bc_control_inputs_type;

	signal spwc_tx_bc_write_bus_inputs_sig  : spwc_bc_write_bus_inputs_type;
	signal spwc_tx_bc_write_bus_outputs_sig : spwc_bc_write_bus_outputs_type;
	signal spwc_bc_write_fifo_inputs_sig    : spwc_bc_write_fifo_inputs_type;
	signal spwc_bc_write_fifo_outputs_sig   : spwc_bc_write_fifo_outputs_type;

	signal spwc_bc_read_fifo_inputs_sig    : spwc_bc_read_fifo_inputs_type;
	signal spwc_bc_read_fifo_outputs_sig   : spwc_bc_read_fifo_outputs_type;
	signal spwc_rx_bc_read_bus_inputs_sig  : spwc_bc_read_bus_inputs_type;
	signal spwc_rx_bc_read_bus_outputs_sig : spwc_bc_read_bus_outputs_type;

	signal spwc_rx_data_dc_fifo_clk100_inputs_sig  : spwc_rx_data_dc_fifo_clk100_inputs_type;
	signal spwc_rx_data_dc_fifo_clk100_outputs_sig : spwc_rx_data_dc_fifo_clk100_outputs_type;
	signal spwc_rx_data_dc_fifo_clk200_inputs_sig  : spwc_rx_data_dc_fifo_clk200_inputs_type;
	signal spwc_rx_data_dc_fifo_clk200_outputs_sig : spwc_rx_data_dc_fifo_clk200_outputs_type;

	signal spwc_tx_data_dc_fifo_clk100_inputs_sig  : spwc_tx_data_dc_fifo_clk100_inputs_type;
	signal spwc_tx_data_dc_fifo_clk100_outputs_sig : spwc_tx_data_dc_fifo_clk100_outputs_type;
	signal spwc_tx_data_dc_fifo_clk200_inputs_sig  : spwc_tx_data_dc_fifo_clk200_inputs_type;
	signal spwc_tx_data_dc_fifo_clk200_outputs_sig : spwc_tx_data_dc_fifo_clk200_outputs_type;

	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;

begin

	spwc_avalon_mm_write_ent_inst : entity work.spwc_avalon_mm_write_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => spwc_avalon_mm_write_inputs_sig,
			avalon_mm_outputs  => spwc_avalon_mm_write_outputs_sig,
			mm_write_registers => spwc_mm_write_registers_sig
		);

	spwc_avalon_mm_read_ent_inst : entity work.spwc_avalon_mm_read_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => spwc_avalon_mm_read_inputs_sig,
			avalon_mm_outputs  => spwc_avalon_mm_read_outputs_sig,
			mm_write_registers => spwc_mm_write_registers_sig,
			mm_read_registers  => spwc_mm_read_registers_sig
		);

	spwc_bus_controller_ent_inst : entity work.spwc_bus_controller_ent
		port map(
			clk                   => avalon_clock,
			rst                   => reset,
			bc_control_inputs     => spwc_bc_control_inputs_sig,
			bc_write_bus_inputs   => spwc_tx_bc_write_bus_inputs_sig,
			bc_write_bus_outputs  => spwc_tx_bc_write_bus_outputs_sig,
			bc_write_fifo_inputs  => spwc_bc_write_fifo_inputs_sig,
			bc_write_fifo_outputs => spwc_bc_write_fifo_outputs_sig,
			bc_read_fifo_inputs   => spwc_bc_read_fifo_inputs_sig,
			bc_read_fifo_outputs  => spwc_bc_read_fifo_outputs_sig,
			bc_read_bus_inputs    => spwc_rx_bc_read_bus_inputs_sig,
			bc_read_bus_outputs   => spwc_rx_bc_read_bus_outputs_sig
		);

	spwc_codec_controller_ent_inst : entity work.spwc_codec_controller_ent
		port map(
			clk100                              => avalon_clock,
			clk200                              => codec_clock,
			rst                                 => reset,
			spwc_mm_write_registers             => spwc_mm_write_registers_sig,
			spwc_mm_read_registers              => spwc_mm_read_registers_sig,
			spwc_rx_data_dc_fifo_clk200_outputs => spwc_rx_data_dc_fifo_clk200_outputs_sig,
			spwc_rx_data_dc_fifo_clk200_inputs  => spwc_rx_data_dc_fifo_clk200_inputs_sig,
			spwc_tx_data_dc_fifo_clk200_outputs => spwc_tx_data_dc_fifo_clk200_outputs_sig,
			spwc_tx_data_dc_fifo_clk200_inputs  => spwc_tx_data_dc_fifo_clk200_inputs_sig,
			spwc_codec_ds_encoding_rx_in        => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_out       => spwc_codec_ds_encoding_tx_out_sig
		);

	spwc_data_dc_fifo_ent_inst : entity work.spwc_data_dc_fifo_ent
		port map(
			clk100                              => avalon_clock,
			clk200                              => codec_clock,
			rst                                 => reset,
			spwc_rx_data_dc_fifo_clk100_inputs  => spwc_rx_data_dc_fifo_clk100_inputs_sig,
			spwc_rx_data_dc_fifo_clk100_outputs => spwc_rx_data_dc_fifo_clk100_outputs_sig,
			spwc_rx_data_dc_fifo_clk200_inputs  => spwc_rx_data_dc_fifo_clk200_inputs_sig,
			spwc_rx_data_dc_fifo_clk200_outputs => spwc_rx_data_dc_fifo_clk200_outputs_sig,
			spwc_tx_data_dc_fifo_clk100_inputs  => spwc_tx_data_dc_fifo_clk100_inputs_sig,
			spwc_tx_data_dc_fifo_clk100_outputs => spwc_tx_data_dc_fifo_clk100_outputs_sig,
			spwc_tx_data_dc_fifo_clk200_inputs  => spwc_tx_data_dc_fifo_clk200_inputs_sig,
			spwc_tx_data_dc_fifo_clk200_outputs => spwc_tx_data_dc_fifo_clk200_outputs_sig
		);

		--	reset_procedure_proc : process(reset) is
		--	begin
		--		if (reset = '1') then
		--		else
		--		end if;
		--	end process reset_procedure_proc;

		--Signals assignments and port mapping

		-- Avalon ports/signals mapping
	spwc_avalon_mm_write_inputs_sig <= spwc_avalon_mm_write_inputs;
	spwc_avalon_mm_write_outputs    <= spwc_avalon_mm_write_outputs_sig;
	spwc_avalon_mm_read_inputs_sig  <= spwc_avalon_mm_read_inputs;
	spwc_avalon_mm_read_outputs     <= spwc_avalon_mm_read_outputs_sig;

	-- Bus ports/signals mapping
	spwc_tx_bc_write_bus_inputs_sig <= spwc_tx_bc_write_bus_inputs;
	spwc_tx_bc_write_bus_outputs    <= spwc_tx_bc_write_bus_outputs_sig;
	spwc_rx_bc_read_bus_inputs_sig  <= spwc_rx_bc_read_bus_inputs;
	spwc_rx_bc_read_bus_outputs     <= spwc_rx_bc_read_bus_outputs_sig;

	-- Codec ports/signals mapping
	spwc_codec_ds_encoding_rx_in_sig <= spwc_codec_ds_encoding_rx_in;
	spwc_codec_ds_encoding_tx_out    <= spwc_codec_ds_encoding_tx_out_sig;

	-- Bus controller signals mapping
	spwc_bc_control_inputs_sig.bc_enable       <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
	spwc_bc_control_inputs_sig.bc_write_enable <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
	spwc_bc_control_inputs_sig.bc_read_enable  <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;

	spwc_bc_write_fifo_inputs_sig.full           <= spwc_tx_data_dc_fifo_clk100_outputs_sig.wrfull;
	spwc_tx_data_dc_fifo_clk100_inputs_sig.aclr  <= spwc_bc_write_fifo_outputs_sig.aclr;
	spwc_tx_data_dc_fifo_clk100_inputs_sig.data  <= spwc_bc_write_fifo_outputs_sig.data;
	spwc_tx_data_dc_fifo_clk100_inputs_sig.wrreq <= spwc_bc_write_fifo_outputs_sig.write;

	spwc_bc_read_fifo_inputs_sig.data            <= spwc_rx_data_dc_fifo_clk100_outputs_sig.q;
	spwc_bc_read_fifo_inputs_sig.empty           <= spwc_rx_data_dc_fifo_clk100_outputs_sig.rdempty;
	spwc_rx_data_dc_fifo_clk100_inputs_sig.aclr  <= spwc_bc_read_fifo_outputs_sig.aclr;
	spwc_rx_data_dc_fifo_clk100_inputs_sig.rdreq <= spwc_bc_read_fifo_outputs_sig.read;

	--Interrupt assingment
	spwc_interrupt_outputs <= (
		(spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.LINK_ERROR) or (spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.LINK_RUNNING) or (spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED)
	) when (reset = '0') else ('0');

end architecture spwc_topfile_arc;
