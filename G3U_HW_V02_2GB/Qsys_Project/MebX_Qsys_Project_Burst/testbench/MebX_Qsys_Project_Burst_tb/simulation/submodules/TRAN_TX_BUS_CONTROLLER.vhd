library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_controller_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;

entity tran_tx_bus_controller_ent is
	port(
		clk                              : in  std_logic;
		rst                              : in  std_logic;
		tran_tx_bc_control_inputs        : in  tran_bc_control_inputs_type;
		tran_tx_bc_write_bus_inputs      : in  tran_bc_write_bus_inputs_type;
		tran_tx_bc_write_bus_outputs     : out tran_bc_write_bus_outputs_type;
		tran_tx_read_inputs_bus_sc_fifo  : in  tran_read_outputs_bus_sc_fifo_type;
		tran_tx_read_outputs_bus_sc_fifo : out tran_read_inputs_bus_sc_fifo_type
	);
end entity tran_tx_bus_controller_ent;

-- TX : fifo --> bus (Simucam --> SpW);

architecture tran_tx_bus_controller_arc of tran_tx_bus_controller_ent is

	-- Signals for BUS SC FIFO Control
	signal bc_tx_fifo_read_sig        : std_logic := '0';
	signal bc_tx_fifo_read_enable_sig : std_logic := '0';

	-- Signals for TX BUS Control
	signal bc_tx_bus_datavalid_sig        : std_logic := '0';
	signal bc_tx_bus_datavalid_enable_sig : std_logic := '0';

	-- Signals for BUS Controller Data
	signal bc_tx_fifo_data_sig : tran_bus_sc_fifo_data_type;
	signal bc_tx_bus_data_sig  : tran_bc_bus_data_type;

begin

	tran_tx_bus_controller_proc : process(clk, rst) is
	begin
		-- Reset Procedures
		if (rst = '1') then
			tran_tx_bc_write_bus_outputs.enabled  <= '0';
			tran_tx_read_outputs_bus_sc_fifo.sclr <= '1';
			-- Clocked Process
		elsif rising_edge(clk) then
			tran_tx_read_outputs_bus_sc_fifo.sclr <= '0';

			-- Enabled signal management
			if ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) then
				tran_tx_bc_write_bus_outputs.enabled <= '1';
			else
				tran_tx_bc_write_bus_outputs.enabled <= '0';
			end if;

		end if;
	end process tran_tx_bus_controller_proc;

	-- BUS SC FIFO Read Signal assignment
	bc_tx_fifo_read_sig <= tran_tx_bc_write_bus_inputs.dataused;

	-- BUS SC FIFO Underflow/Overflow protection
	tran_tx_read_outputs_bus_sc_fifo.rdreq <= (bc_tx_fifo_read_enable_sig) when (tran_tx_read_inputs_bus_sc_fifo.empty = '0') else ('0');

	-- TX BUS DataValid Signal assignment
	bc_tx_bus_datavalid_sig                <= not (tran_tx_read_inputs_bus_sc_fifo.empty);
	tran_tx_bc_write_bus_outputs.datavalid <= bc_tx_bus_datavalid_enable_sig;

	-- TX Enable management
	bc_tx_fifo_read_enable_sig     <= (bc_tx_fifo_read_sig) when ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) else ('0');
	bc_tx_bus_datavalid_enable_sig <= (bc_tx_bus_datavalid_sig) when ((tran_tx_bc_control_inputs.bc_enable = '1') and (tran_tx_bc_control_inputs.bc_write_enable = '1')) else ('0');

	-- BUS SC FIFO Data Signal assignment
	bc_tx_fifo_data_sig.spacewire_flag <= tran_tx_read_inputs_bus_sc_fifo.q(8);
	bc_tx_fifo_data_sig.spacewire_data <= tran_tx_read_inputs_bus_sc_fifo.q(7 downto 0);

	-- Internal Data Signal assignment
	bc_tx_bus_data_sig.spacewire_flag <= bc_tx_fifo_data_sig.spacewire_flag;
	bc_tx_bus_data_sig.spacewire_data <= bc_tx_fifo_data_sig.spacewire_data;

	-- TX BUS Data Signal assignment
	tran_tx_bc_write_bus_outputs.data(8)          <= bc_tx_bus_data_sig.spacewire_flag;
	tran_tx_bc_write_bus_outputs.data(7 downto 0) <= bc_tx_bus_data_sig.spacewire_data;

end architecture tran_tx_bus_controller_arc;
