library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_mm_registers_pkg.all;
use work.tran_avalon_mm_pkg.all;
use work.tran_burst_registers_pkg.all;
use work.tran_avalon_burst_pkg.all;
use work.tran_bus_controller_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;
use work.tran_avs_controller_pkg.all;
use work.tran_avs_sc_fifo_pkg.all;

entity tran_topfile_ent is
	port(
		clk                             : in  std_logic;
		rst                             : in  std_logic;
		tran_interrupt_outputs          : out std_logic;
		tran_avalon_mm_write_inputs     : in  tran_avalon_mm_write_inputs_type;
		tran_avalon_mm_write_outputs    : out tran_avalon_mm_write_outputs_type;
		tran_avalon_mm_read_inputs      : in  tran_avalon_mm_read_inputs_type;
		tran_avalon_mm_read_outputs     : out tran_avalon_mm_read_outputs_type;
		tran_avalon_burst_write_inputs  : in  tran_avalon_burst_write_inputs_type;
		tran_avalon_burst_write_outputs : out tran_avalon_burst_write_outputs_type;
		tran_avalon_burst_read_inputs   : in  tran_avalon_burst_read_inputs_type;
		tran_avalon_burst_read_outputs  : out tran_avalon_burst_read_outputs_type;
		tran_rx_bc_read_bus_inputs      : in  tran_bc_read_bus_inputs_type;
		tran_rx_bc_read_bus_outputs     : out tran_bc_read_bus_outputs_type;
		tran_tx_bc_write_bus_inputs     : in  tran_bc_write_bus_inputs_type;
		tran_tx_bc_write_bus_outputs    : out tran_bc_write_bus_outputs_type
	);
end entity tran_topfile_ent;

architecture tran_topfile_arc of tran_topfile_ent is

	alias avalon_clock is clk;
	alias reset is rst;

	signal tran_mm_write_registers_sig      : tran_mm_write_registers_type;
	signal tran_mm_read_registers_sig       : tran_mm_read_registers_type;
	signal tran_avalon_mm_write_inputs_sig  : tran_avalon_mm_write_inputs_type;
	signal tran_avalon_mm_write_outputs_sig : tran_avalon_mm_write_outputs_type;
	signal tran_avalon_mm_read_inputs_sig   : tran_avalon_mm_read_inputs_type;
	signal tran_avalon_mm_read_outputs_sig  : tran_avalon_mm_read_outputs_type;

	signal tran_burst_write_registers_sig      : tran_burst_write_registers_type;
	signal tran_burst_read_registers_sig       : tran_burst_read_registers_type;
	signal tran_avalon_burst_write_inputs_sig  : tran_avalon_burst_write_inputs_type;
	signal tran_avalon_burst_write_outputs_sig : tran_avalon_burst_write_outputs_type;
	signal tran_avalon_burst_read_inputs_sig   : tran_avalon_burst_read_inputs_type;
	signal tran_avalon_burst_read_outputs_sig  : tran_avalon_burst_read_outputs_type;

	signal tran_bc_control_inputs_sig       : tran_bc_control_inputs_type;
	signal tran_rx_bc_read_bus_inputs_sig   : tran_bc_read_bus_inputs_type;
	signal tran_rx_bc_read_bus_outputs_sig  : tran_bc_read_bus_outputs_type;
	signal tran_tx_bc_write_bus_inputs_sig  : tran_bc_write_bus_inputs_type;
	signal tran_tx_bc_write_bus_outputs_sig : tran_bc_write_bus_outputs_type;

	signal tran_avsdc_rx_avs_outputs_sig : tran_avsdc_rx_avs_outputs_type;
	signal tran_avsdc_rx_avs_inputs_sig  : tran_avsdc_rx_avs_inputs_type;

	signal tran_rx_read_outputs_avs_sc_fifo_sig  : tran_read_outputs_avs_sc_fifo_type;
	signal tran_rx_read_inputs_avs_sc_fifo_sig   : tran_read_inputs_avs_sc_fifo_type;
	signal tran_rx_write_outputs_avs_sc_fifo_sig : tran_write_outputs_avs_sc_fifo_type;
	signal tran_rx_write_inputs_avs_sc_fifo_sig  : tran_write_inputs_avs_sc_fifo_type;

	signal tran_rx_fifo_intputs_avs_sc_fifo_sig : tran_fifo_intputs_avs_sc_fifo_type;
	signal tran_rx_fifo_outputs_avs_sc_fifo_sig : tran_fifo_outputs_avs_sc_fifo_type;

	signal tran_rx_read_outputs_bus_sc_fifo_sig  : tran_read_outputs_bus_sc_fifo_type;
	signal tran_rx_read_inputs_bus_sc_fifo_sig   : tran_read_inputs_bus_sc_fifo_type;
	signal tran_rx_write_outputs_bus_sc_fifo_sig : tran_write_outputs_bus_sc_fifo_type;
	signal tran_rx_write_inputs_bus_sc_fifo_sig  : tran_write_inputs_bus_sc_fifo_type;

	signal tran_rx_fifo_intputs_bus_sc_fifo_sig : tran_fifo_intputs_bus_sc_fifo_type;
	signal tran_rx_fifo_outputs_bus_sc_fifo_sig : tran_fifo_outputs_bus_sc_fifo_type;

	signal tran_avsdc_tx_avs_outputs_sig : tran_avsdc_tx_avs_outputs_type;
	signal tran_avsdc_tx_avs_inputs_sig  : tran_avsdc_tx_avs_inputs_type;

	signal tran_tx_read_outputs_avs_sc_fifo_sig  : tran_read_outputs_avs_sc_fifo_type;
	signal tran_tx_read_inputs_avs_sc_fifo_sig   : tran_read_inputs_avs_sc_fifo_type;
	signal tran_tx_write_outputs_avs_sc_fifo_sig : tran_write_outputs_avs_sc_fifo_type;
	signal tran_tx_write_inputs_avs_sc_fifo_sig  : tran_write_inputs_avs_sc_fifo_type;

	signal tran_tx_fifo_intputs_avs_sc_fifo_sig : tran_fifo_intputs_avs_sc_fifo_type;
	signal tran_tx_fifo_outputs_avs_sc_fifo_sig : tran_fifo_outputs_avs_sc_fifo_type;

	signal tran_tx_read_outputs_bus_sc_fifo_sig  : tran_read_outputs_bus_sc_fifo_type;
	signal tran_tx_read_inputs_bus_sc_fifo_sig   : tran_read_inputs_bus_sc_fifo_type;
	signal tran_tx_write_outputs_bus_sc_fifo_sig : tran_write_outputs_bus_sc_fifo_type;
	signal tran_tx_write_inputs_bus_sc_fifo_sig  : tran_write_inputs_bus_sc_fifo_type;

	signal tran_tx_fifo_intputs_bus_sc_fifo_sig : tran_fifo_intputs_bus_sc_fifo_type;
	signal tran_tx_fifo_outputs_bus_sc_fifo_sig : tran_fifo_outputs_bus_sc_fifo_type;

begin

	tran_avalon_mm_write_ent_inst : entity work.tran_avalon_mm_write_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => tran_avalon_mm_write_inputs_sig,
			avalon_mm_outputs  => tran_avalon_mm_write_outputs_sig,
			mm_write_registers => tran_mm_write_registers_sig
		);

	tran_avalon_mm_read_ent_inst : entity work.tran_avalon_mm_read_ent
		port map(
			clk                => avalon_clock,
			rst                => reset,
			avalon_mm_inputs   => tran_avalon_mm_read_inputs_sig,
			avalon_mm_outputs  => tran_avalon_mm_read_outputs_sig,
			mm_write_registers => tran_mm_write_registers_sig,
			mm_read_registers  => tran_mm_read_registers_sig
		);

	tran_avalon_burst_write_ent_inst : entity work.tran_avalon_burst_write_ent
		port map(
			clk                         => avalon_clock,
			rst                         => reset,
			avalon_burst_inputs         => tran_avalon_burst_write_inputs_sig,
			avalon_burst_outputs        => tran_avalon_burst_write_outputs_sig,
			burst_write_registers       => tran_burst_write_registers_sig,
			tran_avs_controller_inputs  => tran_avsdc_tx_avs_outputs_sig,
			tran_avs_controller_outputs => tran_avsdc_tx_avs_inputs_sig
		);

	tran_avalon_burst_read_ent_inst : entity work.tran_avalon_burst_read_ent
		port map(
			clk                         => avalon_clock,
			rst                         => reset,
			avalon_burst_inputs         => tran_avalon_burst_read_inputs_sig,
			avalon_burst_outputs        => tran_avalon_burst_read_outputs_sig,
			burst_read_registers        => tran_burst_read_registers_sig,
			tran_avs_controller_inputs  => tran_avsdc_rx_avs_outputs_sig,
			tran_avs_controller_outputs => tran_avsdc_rx_avs_inputs_sig
		);

	tran_rx_avs_controller_ent_inst : entity work.tran_rx_avs_controller_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_rx_avsdc_rx_avs_inputs      => tran_avsdc_rx_avs_inputs_sig,
			tran_rx_avsdc_rx_avs_outputs     => tran_avsdc_rx_avs_outputs_sig,
			burst_read_registers             => tran_burst_read_registers_sig,
			tran_rx_read_inputs_avs_sc_fifo  => tran_rx_read_outputs_avs_sc_fifo_sig,
			tran_rx_read_outputs_avs_sc_fifo => tran_rx_read_inputs_avs_sc_fifo_sig
		);

	tran_tx_avs_controller_ent_inst : entity work.tran_tx_avs_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_tx_avsdc_tx_avs_inputs       => tran_avsdc_tx_avs_inputs_sig,
			tran_tx_avsdc_tx_avs_outputs      => tran_avsdc_tx_avs_outputs_sig,
			burst_write_registers             => tran_burst_write_registers_sig,
			tran_tx_write_inputs_avs_sc_fifo  => tran_tx_write_outputs_avs_sc_fifo_sig,
			tran_tx_write_outputs_avs_sc_fifo => tran_tx_write_inputs_avs_sc_fifo_sig
		);

	tran_avs_sc_fifo_ent_inst : entity work.tran_avs_sc_fifo_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_rx_inputs_avs_sc_fifo_type  => tran_rx_fifo_intputs_avs_sc_fifo_sig,
			tran_rx_outputs_avs_sc_fifo_type => tran_rx_fifo_outputs_avs_sc_fifo_sig,
			tran_tx_inputs_avs_sc_fifo_type  => tran_tx_fifo_intputs_avs_sc_fifo_sig,
			tran_tx_outputs_avs_sc_fifo_type => tran_tx_fifo_outputs_avs_sc_fifo_sig
		);

	tran_rx_interface_controller_ent_inst : entity work.tran_rx_interface_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_rx_read_outputs_bus_sc_fifo  => tran_rx_read_outputs_bus_sc_fifo_sig,
			tran_rx_read_inputs_bus_sc_fifo   => tran_rx_read_inputs_bus_sc_fifo_sig,
			tran_rx_write_outputs_avs_sc_fifo => tran_rx_write_outputs_avs_sc_fifo_sig,
			tran_rx_write_inputs_avs_sc_fifo  => tran_rx_write_inputs_avs_sc_fifo_sig
		);

	tran_tx_interface_controller_ent_inst : entity work.tran_tx_interface_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_tx_read_outputs_avs_sc_fifo  => tran_tx_read_outputs_avs_sc_fifo_sig,
			tran_tx_read_inputs_avs_sc_fifo   => tran_tx_read_inputs_avs_sc_fifo_sig,
			tran_tx_write_outputs_bus_sc_fifo => tran_tx_write_outputs_bus_sc_fifo_sig,
			tran_tx_write_inputs_bus_sc_fifo  => tran_tx_write_inputs_bus_sc_fifo_sig
		);

	tran_rx_bus_controller_ent_inst : entity work.tran_rx_bus_controller_ent
		port map(
			clk                               => avalon_clock,
			rst                               => reset,
			tran_rx_bc_control_inputs         => tran_bc_control_inputs_sig,
			tran_rx_bc_read_bus_inputs        => tran_rx_bc_read_bus_inputs_sig,
			tran_rx_bc_read_bus_outputs       => tran_rx_bc_read_bus_outputs_sig,
			tran_rx_write_inputs_bus_sc_fifo  => tran_rx_write_outputs_bus_sc_fifo_sig,
			tran_rx_write_outputs_bus_sc_fifo => tran_rx_write_inputs_bus_sc_fifo_sig
		);

	tran_tx_bus_controller_ent_inst : entity work.tran_tx_bus_controller_ent
		port map(
			clk                              => avalon_clock,
			rst                              => reset,
			tran_tx_bc_control_inputs        => tran_bc_control_inputs_sig,
			tran_tx_bc_write_bus_inputs      => tran_tx_bc_write_bus_inputs_sig,
			tran_tx_bc_write_bus_outputs     => tran_tx_bc_write_bus_outputs_sig,
			tran_tx_read_inputs_bus_sc_fifo  => tran_tx_read_outputs_bus_sc_fifo_sig,
			tran_tx_read_outputs_bus_sc_fifo => tran_tx_read_inputs_bus_sc_fifo_sig
		);

	tran_bus_sc_fifo_ent_inst : entity work.tran_bus_sc_fifo_ent
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

		--Signals assignments and port mapping

		-- Avalon ports/signals mapping
	tran_avalon_mm_write_inputs_sig    <= tran_avalon_mm_write_inputs;
	tran_avalon_mm_write_outputs       <= tran_avalon_mm_write_outputs_sig;
	tran_avalon_mm_read_inputs_sig     <= tran_avalon_mm_read_inputs;
	tran_avalon_mm_read_outputs        <= tran_avalon_mm_read_outputs_sig;
	tran_avalon_burst_write_inputs_sig <= tran_avalon_burst_write_inputs;
	tran_avalon_burst_write_outputs    <= tran_avalon_burst_write_outputs_sig;
	tran_avalon_burst_read_inputs_sig  <= tran_avalon_burst_read_inputs;
	tran_avalon_burst_read_outputs     <= tran_avalon_burst_read_outputs_sig;

	-- Bus ports/signals mapping
	tran_tx_bc_write_bus_inputs_sig <= tran_tx_bc_write_bus_inputs;
	tran_tx_bc_write_bus_outputs    <= tran_tx_bc_write_bus_outputs_sig;
	tran_rx_bc_read_bus_inputs_sig  <= tran_rx_bc_read_bus_inputs;
	tran_rx_bc_read_bus_outputs     <= tran_rx_bc_read_bus_outputs_sig;

	-- Avs fifo signals mapping
	tran_rx_fifo_intputs_avs_sc_fifo_sig.read  <= tran_rx_read_inputs_avs_sc_fifo_sig;
	tran_rx_read_outputs_avs_sc_fifo_sig       <= tran_rx_fifo_outputs_avs_sc_fifo_sig.read;
	tran_rx_fifo_intputs_avs_sc_fifo_sig.write <= tran_rx_write_inputs_avs_sc_fifo_sig;
	tran_rx_write_outputs_avs_sc_fifo_sig      <= tran_rx_fifo_outputs_avs_sc_fifo_sig.write;

	tran_tx_fifo_intputs_avs_sc_fifo_sig.read  <= tran_tx_read_inputs_avs_sc_fifo_sig;
	tran_tx_read_outputs_avs_sc_fifo_sig       <= tran_tx_fifo_outputs_avs_sc_fifo_sig.read;
	tran_tx_fifo_intputs_avs_sc_fifo_sig.write <= tran_tx_write_inputs_avs_sc_fifo_sig;
	tran_tx_write_outputs_avs_sc_fifo_sig      <= tran_tx_fifo_outputs_avs_sc_fifo_sig.write;

	-- Bus fifo signals mapping
	tran_rx_fifo_intputs_bus_sc_fifo_sig.read  <= tran_rx_read_inputs_bus_sc_fifo_sig;
	tran_rx_read_outputs_bus_sc_fifo_sig       <= tran_rx_fifo_outputs_bus_sc_fifo_sig.read;
	tran_rx_fifo_intputs_bus_sc_fifo_sig.write <= tran_rx_write_inputs_bus_sc_fifo_sig;
	tran_rx_write_outputs_bus_sc_fifo_sig      <= tran_rx_fifo_outputs_bus_sc_fifo_sig.write;

	tran_tx_fifo_intputs_bus_sc_fifo_sig.read  <= tran_tx_read_inputs_bus_sc_fifo_sig;
	tran_tx_read_outputs_bus_sc_fifo_sig       <= tran_tx_fifo_outputs_bus_sc_fifo_sig.read;
	tran_tx_fifo_intputs_bus_sc_fifo_sig.write <= tran_tx_write_inputs_bus_sc_fifo_sig;
	tran_tx_write_outputs_bus_sc_fifo_sig      <= tran_tx_fifo_outputs_bus_sc_fifo_sig.write;

	-- Enable/Disable Management
	tran_bc_control_inputs_sig.bc_enable       <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT;
	tran_bc_control_inputs_sig.bc_read_enable  <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT; -- RX : bus  --> fifo (SpW --> Simucam) / -- Read  : leitura do bus
	tran_bc_control_inputs_sig.bc_write_enable <= tran_mm_write_registers_sig.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT; -- TX : avs  --> fifo (Simucam --> SpW) / -- Write : escrita no bus

	--Interrupt assingment
	tran_interrupt_outputs <= (
		(tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED) or (tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.INTERFACE_ERROR) or (tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL) or (tran_mm_read_registers_sig.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY)
	) when (reset = '0') else ('0');

end architecture tran_topfile_arc;
