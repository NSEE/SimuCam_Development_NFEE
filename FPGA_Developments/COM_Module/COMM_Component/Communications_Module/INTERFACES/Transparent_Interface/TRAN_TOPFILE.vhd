library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_mm_registers_pkg.all;
use work.tran_burst_registers_pkg.all;
use work.tran_avs_controller_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;
use work.tran_bus_controller_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;

entity tran_topfile_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_interrupt_outputs            : out std_logic;
		tran_mm_write_registers_inputs    : in  tran_mm_write_registers_type;
		tran_mm_read_registers_outputs    : out tran_mm_read_registers_type;
		tran_burst_write_registers_inputs : in  tran_burst_write_registers_type;
		tran_burst_read_registers_outputs : out tran_burst_read_registers_type;
		tran_avsdc_rx_avs_inputs          : in  tran_avsdc_rx_avs_inputs_type;
		tran_avsdc_rx_avs_outputs         : out tran_avsdc_rx_avs_outputs_type;
		tran_avsdc_tx_avs_inputs          : in  tran_avsdc_tx_avs_inputs_type;
		tran_avsdc_tx_avs_outputs         : out tran_avsdc_tx_avs_outputs_type;
		tran_rx_bc_bus_inputs             : in  tran_bc_read_bus_inputs_type;
		tran_rx_bc_bus_outputs            : out tran_bc_read_bus_outputs_type;
		tran_tx_bc_bus_inputs             : in  tran_bc_write_bus_inputs_type;
		tran_tx_bc_bus_outputs            : out tran_bc_write_bus_outputs_type
	);
end entity tran_topfile_ent;

architecture tran_topfile_arc of tran_topfile_ent is

	-- Clocks and Reset alias
	alias avalon_clock is clk;
	alias reset is rst;

	-- External/Port Mapping Signals

	-- Signals for Avalon MM Interrupt for TRAN Module
	signal tran_mm_interrupt_sig : std_logic;

	-- Signals for Avalon MM for TRAN Module Registers
	signal tran_mm_write_registers_sig : tran_mm_write_registers_type;
	signal tran_mm_read_registers_sig  : tran_mm_read_registers_type;

	-- Signals for Avalon MM for TRAN Module Data
	signal tran_burst_write_registers_sig : tran_burst_write_registers_type;
	signal tran_burst_read_registers_sig  : tran_burst_read_registers_type;

	-- Signals for RX Data BUS for TRAN Module
	signal tran_rx_bc_read_bus_inputs_sig  : tran_bc_read_bus_inputs_type;
	signal tran_rx_bc_read_bus_outputs_sig : tran_bc_read_bus_outputs_type;

	-- Signals for TX Data BUS for TRAN Module
	signal tran_tx_bc_write_bus_inputs_sig  : tran_bc_write_bus_inputs_type;
	signal tran_tx_bc_write_bus_outputs_sig : tran_bc_write_bus_outputs_type;

	-- Signals for RX AVS Data Controller for TRAN Module
	signal tran_avsdc_rx_avs_inputs_sig  : tran_avsdc_rx_avs_inputs_type;
	signal tran_avsdc_rx_avs_outputs_sig : tran_avsdc_rx_avs_outputs_type;

	-- Signals for TX AVS Data Controller for TRAN Module
	signal tran_avsdc_tx_avs_inputs_sig  : tran_avsdc_tx_avs_inputs_type;
	signal tran_avsdc_tx_avs_outputs_sig : tran_avsdc_tx_avs_outputs_type;

	-- Internal/Component Mapping Signals

	-- Signals for Data BUS Controller for TRAN Module
	signal tran_bc_control_inputs_sig : tran_bc_control_inputs_type;

	-- Signals for RX Interface Controller Interrupts for TRAN Module
	signal tran_rx_interrupt_registers_sig : tran_interrupt_register_type;

	-- Signals for TX Interface Controller Interrupts for TRAN Module
	signal tran_tx_interrupt_registers_sig : tran_interrupt_register_type;

	-- Signals for RX AVS SC FIFO for TRAN Module
	signal tran_rx_fifo_intputs_avs_sc_fifo_sig : tran_fifo_intputs_avs_sc_fifo_type;
	signal tran_rx_fifo_outputs_avs_sc_fifo_sig : tran_fifo_outputs_avs_sc_fifo_type;

	-- Signals for TX AVS SC FIFO for TRAN Module
	signal tran_tx_fifo_intputs_avs_sc_fifo_sig : tran_fifo_intputs_avs_sc_fifo_type;
	signal tran_tx_fifo_outputs_avs_sc_fifo_sig : tran_fifo_outputs_avs_sc_fifo_type;

	-- Signals for RX BUS SC FIFO for TRAN Module
	signal tran_rx_fifo_intputs_bus_sc_fifo_sig : tran_fifo_intputs_bus_sc_fifo_type;
	signal tran_rx_fifo_outputs_bus_sc_fifo_sig : tran_fifo_outputs_bus_sc_fifo_type;

	-- Signals for TX BUS SC FIFO for TRAN Module
	signal tran_tx_fifo_intputs_bus_sc_fifo_sig : tran_fifo_intputs_bus_sc_fifo_type;
	signal tran_tx_fifo_outputs_bus_sc_fifo_sig : tran_fifo_outputs_bus_sc_fifo_type;

begin

	-- RX AVS Controller Component
	tran_rx_avs_controller_ent_inst : entity work.tran_rx_avs_controller_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_burst_read_registers        => tran_burst_read_registers_sig,
			tran_rx_avsdc_rx_avs_inputs      => tran_avsdc_rx_avs_inputs_sig,
			tran_rx_avsdc_rx_avs_outputs     => tran_avsdc_rx_avs_outputs_sig,
			tran_rx_read_inputs_avs_sc_fifo  => tran_rx_fifo_outputs_avs_sc_fifo_sig.read,
			tran_rx_read_outputs_avs_sc_fifo => tran_rx_fifo_intputs_avs_sc_fifo_sig.read
		);

	-- TX AVS Controller Component
	tran_tx_avs_controller_ent_inst : entity work.tran_tx_avs_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_tx_avsdc_tx_avs_inputs       => tran_avsdc_tx_avs_inputs_sig,
			tran_tx_avsdc_tx_avs_outputs      => tran_avsdc_tx_avs_outputs_sig,
			tran_burst_write_registers        => tran_burst_write_registers_sig,
			tran_tx_write_inputs_avs_sc_fifo  => tran_tx_fifo_outputs_avs_sc_fifo_sig.write,
			tran_tx_write_outputs_avs_sc_fifo => tran_tx_fifo_intputs_avs_sc_fifo_sig.write
		);

	-- AVS SC FIFO Component
	tran_avs_sc_fifo_instantiation_ent_inst : entity work.tran_avs_sc_fifo_instantiation_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_rx_inputs_avs_sc_fifo_type  => tran_rx_fifo_intputs_avs_sc_fifo_sig,
			tran_rx_outputs_avs_sc_fifo_type => tran_rx_fifo_outputs_avs_sc_fifo_sig,
			tran_tx_inputs_avs_sc_fifo_type  => tran_tx_fifo_intputs_avs_sc_fifo_sig,
			tran_tx_outputs_avs_sc_fifo_type => tran_tx_fifo_outputs_avs_sc_fifo_sig
		);

	-- RX Interface Controller Component
	tran_rx_interface_controller_ent_inst : entity work.tran_rx_interface_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_mm_write_registers           => tran_mm_write_registers_sig,
			tran_rx_interrupt_registers       => tran_rx_interrupt_registers_sig,
			tran_rx_read_outputs_bus_sc_fifo  => tran_rx_fifo_outputs_bus_sc_fifo_sig.read,
			tran_rx_read_inputs_bus_sc_fifo   => tran_rx_fifo_intputs_bus_sc_fifo_sig.read,
			tran_rx_write_outputs_avs_sc_fifo => tran_rx_fifo_outputs_avs_sc_fifo_sig.write,
			tran_rx_write_inputs_avs_sc_fifo  => tran_rx_fifo_intputs_avs_sc_fifo_sig.write
		);

	-- TX Interface Controller Component
	tran_tx_interface_controller_ent_inst : entity work.tran_tx_interface_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_mm_write_registers           => tran_mm_write_registers_sig,
			tran_tx_interrupt_registers       => tran_tx_interrupt_registers_sig,
			tran_tx_read_outputs_avs_sc_fifo  => tran_tx_fifo_outputs_avs_sc_fifo_sig.read,
			tran_tx_read_inputs_avs_sc_fifo   => tran_tx_fifo_intputs_avs_sc_fifo_sig.read,
			tran_tx_write_outputs_bus_sc_fifo => tran_tx_fifo_outputs_bus_sc_fifo_sig.write,
			tran_tx_write_inputs_bus_sc_fifo  => tran_tx_fifo_intputs_bus_sc_fifo_sig.write
		);

	-- RX BUS Controller Component
	tran_rx_bus_controller_ent_inst : entity work.tran_rx_bus_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_rx_bc_control_inputs         => tran_bc_control_inputs_sig,
			tran_rx_bc_read_bus_inputs        => tran_rx_bc_read_bus_inputs_sig,
			tran_rx_bc_read_bus_outputs       => tran_rx_bc_read_bus_outputs_sig,
			tran_rx_write_inputs_bus_sc_fifo  => tran_rx_fifo_outputs_bus_sc_fifo_sig.write,
			tran_rx_write_outputs_bus_sc_fifo => tran_rx_fifo_intputs_bus_sc_fifo_sig.write
		);

	-- TX BUS Controller Component
	tran_tx_bus_controller_ent_inst : entity work.tran_tx_bus_controller_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_tx_bc_control_inputs        => tran_bc_control_inputs_sig,
			tran_tx_bc_write_bus_inputs      => tran_tx_bc_write_bus_inputs_sig,
			tran_tx_bc_write_bus_outputs     => tran_tx_bc_write_bus_outputs_sig,
			tran_tx_read_inputs_bus_sc_fifo  => tran_tx_fifo_outputs_bus_sc_fifo_sig.read,
			tran_tx_read_outputs_bus_sc_fifo => tran_tx_fifo_intputs_bus_sc_fifo_sig.read
		);

	-- BUS SC FIFO Component
	tran_bus_sc_fifo_instantiation_ent_inst : entity work.tran_bus_sc_fifo_instantiation_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_rx_inputs_bus_sc_fifo_type  => tran_rx_fifo_intputs_bus_sc_fifo_sig,
			tran_rx_outputs_bus_sc_fifo_type => tran_rx_fifo_outputs_bus_sc_fifo_sig,
			tran_tx_inputs_bus_sc_fifo_type  => tran_tx_fifo_intputs_bus_sc_fifo_sig,
			tran_tx_outputs_bus_sc_fifo_type => tran_tx_fifo_outputs_bus_sc_fifo_sig
		);

	--	reset_procedure_proc : process(reset) is
	--	begin
	--		if (reset = '1') then
	--		else
	--		end if;
	--	end process reset_procedure_proc;

	-- Ports / Signals Mapping

	-- Interrupt ports/signals mapping
	tran_interrupt_outputs <= tran_mm_interrupt_sig;

	-- MM Registers ports/signals mapping
	tran_mm_write_registers_sig    <= tran_mm_write_registers_inputs;
	tran_mm_read_registers_outputs <= tran_mm_read_registers_sig;

	-- Burst Registers ports/signals mapping
	tran_burst_write_registers_sig    <= tran_burst_write_registers_inputs;
	tran_burst_read_registers_outputs <= tran_burst_read_registers_sig;

	-- RX AVS Controller ports/signals mapping
	tran_avsdc_rx_avs_inputs_sig <= tran_avsdc_rx_avs_inputs;
	tran_avsdc_rx_avs_outputs    <= tran_avsdc_rx_avs_outputs_sig;

	-- TX AVS Controller ports/signals mapping
	tran_avsdc_tx_avs_inputs_sig <= tran_avsdc_tx_avs_inputs;
	tran_avsdc_tx_avs_outputs    <= tran_avsdc_tx_avs_outputs_sig;

	-- RX BUS Controller ports/signals mapping
	tran_rx_bc_read_bus_inputs_sig <= tran_rx_bc_bus_inputs;
	tran_rx_bc_bus_outputs         <= tran_rx_bc_read_bus_outputs_sig;

	-- TX BUS Controller ports/signals mapping
	tran_tx_bc_write_bus_inputs_sig <= tran_tx_bc_bus_inputs;
	tran_tx_bc_bus_outputs          <= tran_tx_bc_write_bus_outputs_sig;

	-- Signals Operations 

	-- Enable/Disable Management
	tran_bc_control_inputs_sig.bc_enable       <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT;
	tran_bc_control_inputs_sig.bc_read_enable  <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT; -- RX : bus  --> fifo (SpW --> Simucam) / -- Read  : leitura do bus
	tran_bc_control_inputs_sig.bc_write_enable <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT; -- TX : avs  --> fifo (Simucam --> SpW) / -- Write : escrita no bus

	-- TX Interrupts Flags Register Signal Assingment
	tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY <= tran_rx_interrupt_registers_sig.TX_FIFO_EMPTY;

	-- TX FIFO Status Register Fifo Empty Signal assignment
	tran_mm_read_registers_sig.TX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT <= tran_tx_fifo_outputs_avs_sc_fifo_sig.read.empty;

	-- TX FIFO Status Register Fifo Full Signal assignment
	tran_mm_read_registers_sig.TX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT <= tran_tx_fifo_outputs_avs_sc_fifo_sig.write.full;

	-- TX FIFO Status Register Space Used Signal assignment
	tran_mm_read_registers_sig.TX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE <= tran_tx_fifo_outputs_avs_sc_fifo_sig.read.usedw;

	-- RX Interrupts Flags Register Signal Assingment
	tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED <= tran_rx_interrupt_registers_sig.DATA_RECEIVED;
	tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL  <= tran_rx_interrupt_registers_sig.RX_FIFO_FULL;

	-- RX FIFO Status Register Fifo Empty Signal assignment
	tran_mm_read_registers_sig.RX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT <= tran_rx_fifo_outputs_avs_sc_fifo_sig.read.empty;

	-- RX FIFO Status Register Fifo Full Signal assignment
	tran_mm_read_registers_sig.RX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT <= tran_rx_fifo_outputs_avs_sc_fifo_sig.write.full;

	-- RX FIFO Status Register Space Used Signal assignment
	tran_mm_read_registers_sig.RX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE <= tran_rx_fifo_outputs_avs_sc_fifo_sig.read.usedw;

	--Interrupt assingment
	tran_mm_interrupt_sig <= ((tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED) or (tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL) or (tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY)) when (reset = '0') else ('0');

end architecture tran_topfile_arc;
