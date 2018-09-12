library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_mm_registers_pkg.all;
use work.spwc_bus_controller_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;
use work.spwc_codec_pkg.all;

entity spwc_topfile_ent is
	port(
		clk100                            : in  std_logic;
		clk200                            : in  std_logic;
		rst                               : in  std_logic;
		spwc_interrupt_outputs            : out std_logic;
		spwc_mm_write_registers_inputs    : in  spwc_mm_write_registers_type;
		spwc_mm_read_registers_outputs    : out spwc_mm_read_registers_type;
		spwc_rx_bc_bus_inputs             : in  spwc_bc_write_bus_inputs_type;
		spwc_rx_bc_bus_outputs            : out spwc_bc_write_bus_outputs_type;
		spwc_tx_bc_bus_inputs             : in  spwc_bc_read_bus_inputs_type;
		spwc_tx_bc_bus_outputs            : out spwc_bc_read_bus_outputs_type;
		spwc_codec_ds_encoding_rx_inputs  : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_outputs : out spwc_codec_ds_encoding_tx_out_type
	);
end entity spwc_topfile_ent;

architecture spwc_topfile_arc of spwc_topfile_ent is

	-- Clocks and Reset alias
	alias avalon_clock is clk100;
	alias codec_clock is clk200;
	alias reset is rst;

	-- External/Port Mapping Signals

	-- Signals for Avalon MM Interrupt for SPWC Module
	signal spwc_mm_interrupt_sig : std_logic;

	-- Signals for Avalon MM for SPWC Module Registers
	signal spwc_mm_write_registers_sig : spwc_mm_write_registers_type;
	signal spwc_mm_read_registers_sig  : spwc_mm_read_registers_type;

	-- Signals for RX Data BUS for SPWC Module
	signal spwc_rx_bc_write_bus_inputs_sig  : spwc_bc_write_bus_inputs_type;
	signal spwc_rx_bc_write_bus_outputs_sig : spwc_bc_write_bus_outputs_type;

	-- Signals for TX Data BUS for SPWC Module
	signal spwc_tx_bc_read_bus_inputs_sig  : spwc_bc_read_bus_inputs_type;
	signal spwc_tx_bc_read_bus_outputs_sig : spwc_bc_read_bus_outputs_type;

	-- Signals for Codec DS Encoding for SPWC Module
	signal spwc_codec_ds_encoding_rx_in_sig  : spwc_codec_ds_encoding_rx_in_type;
	signal spwc_codec_ds_encoding_tx_out_sig : spwc_codec_ds_encoding_tx_out_type;

	-- Internal/Component Mapping Signals

	-- Signals for Data BUS Controller for SPWC Module
	signal spwc_bc_control_inputs_sig : spwc_bc_control_inputs_type;

	-- Signals for RX DATA DC FIFO CLK100 for SPWC Module
	signal spwc_rx_data_dc_fifo_clk100_inputs_sig  : spwc_rx_data_dc_fifo_clk100_inputs_type;
	signal spwc_rx_data_dc_fifo_clk100_outputs_sig : spwc_rx_data_dc_fifo_clk100_outputs_type;

	-- Signals for TX DATA DC FIFO CLK100 for SPWC Module
	signal spwc_tx_data_dc_fifo_clk100_inputs_sig  : spwc_tx_data_dc_fifo_clk100_inputs_type;
	signal spwc_tx_data_dc_fifo_clk100_outputs_sig : spwc_tx_data_dc_fifo_clk100_outputs_type;

	-- Signals for RX DATA DC FIFO CLK200 for SPWC Module
	signal spwc_rx_data_dc_fifo_clk200_inputs_sig  : spwc_rx_data_dc_fifo_clk200_inputs_type;
	signal spwc_rx_data_dc_fifo_clk200_outputs_sig : spwc_rx_data_dc_fifo_clk200_outputs_type;

	-- Signals for TX DATA DC FIFO CLK200 for SPWC Module
	signal spwc_tx_data_dc_fifo_clk200_inputs_sig  : spwc_tx_data_dc_fifo_clk200_inputs_type;
	signal spwc_tx_data_dc_fifo_clk200_outputs_sig : spwc_tx_data_dc_fifo_clk200_outputs_type;

begin

	-- RX BUS Controller Component
	spwc_rx_bus_controller_ent_inst : entity work.spwc_rx_bus_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			spwc_rx_bc_control_inputs         => spwc_bc_control_inputs_sig,
			spwc_rx_bc_write_bus_inputs       => spwc_rx_bc_write_bus_inputs_sig,
			spwc_rx_bc_write_bus_outputs      => spwc_rx_bc_write_bus_outputs_sig,
			spwc_rx_read_outputs_data_dc_fifo => spwc_rx_data_dc_fifo_clk100_outputs_sig,
			spwc_rx_read_inputs_data_dc_fifo  => spwc_rx_data_dc_fifo_clk100_inputs_sig
		);

		-- TX BUS Controller Component
	spwc_tx_bus_controller_ent_inst : entity work.spwc_tx_bus_controller_ent
		port map(
			clk                                => avalon_clock,
			rst                                => reset,
			spwc_tx_bc_control_inputs          => spwc_bc_control_inputs_sig,
			spwc_tx_bc_read_bus_inputs         => spwc_tx_bc_read_bus_inputs_sig,
			spwc_tx_bc_read_bus_outputs        => spwc_tx_bc_read_bus_outputs_sig,
			spwc_tx_write_outputs_data_dc_fifo => spwc_tx_data_dc_fifo_clk100_outputs_sig,
			spwc_tx_write_inputs_data_dc_fifo  => spwc_tx_data_dc_fifo_clk100_inputs_sig
		);

		-- Codec Controller Component
	spwc_codec_controller_ent_inst : entity work.spwc_codec_controller_ent
		port map(
			clk100                              => avalon_clock,
			clk200                              => codec_clock,
			rst                                 => reset,
			spwc_mm_write_registers             => spwc_mm_write_registers_sig,
			spwc_mm_read_registers              => spwc_mm_read_registers_sig,
			spwc_rx_data_dc_fifo_clk200_inputs  => spwc_rx_data_dc_fifo_clk200_inputs_sig,
			spwc_rx_data_dc_fifo_clk200_outputs => spwc_rx_data_dc_fifo_clk200_outputs_sig,
			spwc_tx_data_dc_fifo_clk200_inputs  => spwc_tx_data_dc_fifo_clk200_inputs_sig,
			spwc_tx_data_dc_fifo_clk200_outputs => spwc_tx_data_dc_fifo_clk200_outputs_sig,
			spwc_codec_ds_encoding_rx_in        => spwc_codec_ds_encoding_rx_in_sig,
			spwc_codec_ds_encoding_tx_out       => spwc_codec_ds_encoding_tx_out_sig
		);

		-- DATA DC FIFO Component
	spwc_data_dc_fifo_instantiation_ent_inst : entity work.spwc_data_dc_fifo_instantiation_ent
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

		-- Ports / Signals Mapping

		-- Interrupt ports/signals mapping
	spwc_interrupt_outputs <= spwc_mm_interrupt_sig;

	-- MM Registers ports/signals mapping
	spwc_mm_write_registers_sig    <= spwc_mm_write_registers_inputs;
	spwc_mm_read_registers_outputs <= spwc_mm_read_registers_sig;

	-- RX BUS Controller ports/signals mapping
	spwc_rx_bc_bus_outputs          <= spwc_rx_bc_write_bus_outputs_sig;
	spwc_rx_bc_write_bus_inputs_sig <= spwc_rx_bc_bus_inputs;

	-- TX BUS Controller ports/signals mapping
	spwc_tx_bc_read_bus_inputs_sig <= spwc_tx_bc_bus_inputs;
	spwc_tx_bc_bus_outputs         <= spwc_tx_bc_read_bus_outputs_sig;

	-- Codec DS Encoding ports/signals mapping
	spwc_codec_ds_encoding_rx_in_sig  <= spwc_codec_ds_encoding_rx_inputs;
	spwc_codec_ds_encoding_tx_outputs <= spwc_codec_ds_encoding_tx_out_sig;

	-- Signals Operations

	-- Enable/Disable Management
	spwc_bc_control_inputs_sig.bc_enable       <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
	spwc_bc_control_inputs_sig.bc_write_enable <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT; -- RX : codec --> bus (SpW --> Simucam) / -- Write : escrita no bus
	spwc_bc_control_inputs_sig.bc_read_enable  <= spwc_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT; -- TX : bus --> codec (Simucam --> SpW) / -- Read  : leitura do bus

	--Interrupt assingment
	spwc_mm_interrupt_sig <= (
		(spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.LINK_ERROR) or (spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.LINK_RUNNING) or (spwc_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED)
	) when (reset = '0') else ('0');

end architecture spwc_topfile_arc;
