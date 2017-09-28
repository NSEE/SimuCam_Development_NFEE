library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_controller_pkg.all;
use work.tran_bus_sc_fifo_pkg.all;

entity tran_rx_bus_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		tran_rx_bc_control_inputs         : in  tran_bc_control_inputs_type;
		tran_rx_bc_read_bus_inputs        : in  tran_bc_read_bus_inputs_type;
		tran_rx_bc_read_bus_outputs       : out tran_bc_read_bus_outputs_type;
		tran_rx_write_inputs_bus_sc_fifo  : in  tran_write_outputs_bus_sc_fifo_type;
		tran_rx_write_outputs_bus_sc_fifo : out tran_write_inputs_bus_sc_fifo_type
	);
end entity tran_rx_bus_controller_ent;

-- RX : bus --> fifo (SpW --> Simucam);

architecture tran_rx_bus_controller_arc of tran_rx_bus_controller_ent is

	-- Signals for RX BUS Control
	signal bc_rx_bus_dataused_sig        : std_logic := '0';
	signal bc_rx_bus_dataused_enable_sig : std_logic := '0';

	-- Signals for BUS SC FIFO Control
	signal bc_rx_fifo_write_sig        : std_logic := '0';
	signal bc_rx_fifo_write_enable_sig : std_logic := '0';

	-- Signals for BUS Controller Data
	signal bc_rx_bus_data_sig  : tran_bc_bus_data_type;
	signal bc_rx_fifo_data_sig : tran_bus_sc_fifo_data_type;

begin

	tran_rx_bus_controller_proc : process(clk, rst) is
	begin
		-- Reset Procedures
		if (rst = '1') then
			tran_rx_bc_read_bus_outputs.enabled    <= '0';
			tran_rx_write_outputs_bus_sc_fifo.sclr <= '1';
			-- Clocked Process
		elsif rising_edge(clk) then
			tran_rx_write_outputs_bus_sc_fifo.sclr <= '0';

			-- Enabled signal management
			if ((tran_rx_bc_control_inputs.bc_enable = '1') and (tran_rx_bc_control_inputs.bc_read_enable = '1')) then
				tran_rx_bc_read_bus_outputs.enabled <= '1';
			else
				tran_rx_bc_read_bus_outputs.enabled <= '0';
			end if;

		end if;
	end process tran_rx_bus_controller_proc;

	-- RX BUS DataUsed Signal assignment
	bc_rx_bus_dataused_sig               <= ('1') when ((tran_rx_bc_read_bus_inputs.datavalid = '1') and (tran_rx_write_inputs_bus_sc_fifo.full = '0')) else ('0');
	tran_rx_bc_read_bus_outputs.dataused <= bc_rx_bus_dataused_enable_sig;

	-- BUS SC FIFO Write Signal assignment
	bc_rx_fifo_write_sig <= ('1') when ((tran_rx_bc_read_bus_inputs.datavalid = '1') and (tran_rx_write_inputs_bus_sc_fifo.full = '0')) else ('0');

	-- BUS SC FIFO Underflow/Overflow protection
	tran_rx_write_outputs_bus_sc_fifo.wrreq <= (bc_rx_fifo_write_enable_sig) when (tran_rx_write_inputs_bus_sc_fifo.full = '0') else ('0');

	-- RX Enable management
	bc_rx_bus_dataused_enable_sig <= (bc_rx_bus_dataused_sig) when ((tran_rx_bc_control_inputs.bc_enable = '1') and (tran_rx_bc_control_inputs.bc_read_enable = '1')) else ('0');
	bc_rx_fifo_write_enable_sig   <= (bc_rx_fifo_write_sig) when ((tran_rx_bc_control_inputs.bc_enable = '1') and (tran_rx_bc_control_inputs.bc_read_enable = '1')) else ('0');

	-- RX BUS Data Signal assignment
	bc_rx_bus_data_sig.spacewire_flag <= tran_rx_bc_read_bus_inputs.data(8);
	bc_rx_bus_data_sig.spacewire_data <= tran_rx_bc_read_bus_inputs.data(7 downto 0);

	-- Internal Data Signal assignment
	bc_rx_fifo_data_sig.spacewire_flag <= bc_rx_bus_data_sig.spacewire_flag;
	bc_rx_fifo_data_sig.spacewire_data <= bc_rx_bus_data_sig.spacewire_data;

	-- BUS SC FIFO Data Signal assignment
	tran_rx_write_outputs_bus_sc_fifo.data(8)          <= bc_rx_fifo_data_sig.spacewire_flag;
	tran_rx_write_outputs_bus_sc_fifo.data(7 downto 0) <= bc_rx_fifo_data_sig.spacewire_data;

end architecture tran_rx_bus_controller_arc;

