library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_bus_controller_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;

entity spwc_rx_bus_controller_ent is
	port(
		clk                               : in  std_logic;
		rst                               : in  std_logic;
		spwc_rx_bc_control_inputs         : in  spwc_bc_control_inputs_type;
		spwc_rx_bc_write_bus_inputs       : in  spwc_bc_write_bus_inputs_type;
		spwc_rx_bc_write_bus_outputs      : out spwc_bc_write_bus_outputs_type;
		spwc_rx_read_outputs_data_dc_fifo : in  spwc_rx_data_dc_fifo_clk100_outputs_type;
		spwc_rx_read_inputs_data_dc_fifo  : out spwc_rx_data_dc_fifo_clk100_inputs_type
	);
end entity spwc_rx_bus_controller_ent;

-- RX : fifo --> bus (SpW --> Simucam);

architecture spwc_rx_bus_controller_arc of spwc_rx_bus_controller_ent is

	-- Signals for RX BUS Control
	signal bc_rx_bus_datavalid_sig        : std_logic := '0';
	signal bc_rx_bus_datavalid_enable_sig : std_logic := '0';

	-- Signals for BUS SC FIFO Control
	signal bc_rx_fifo_read_sig        : std_logic := '0';
	signal bc_rx_fifo_read_enable_sig : std_logic := '0';

	-- Signals for BUS Controller Data
	signal bc_rx_bus_data_sig : spwc_bc_bus_data_type;

begin

	spwc_rx_bus_controller_proc : process(clk, rst) is
		variable bc_read_fifo_dataready_flag : std_logic := '0';
	begin
		-- Reset Procedures
		if (rst = '1') then
			spwc_rx_bc_write_bus_outputs.enabled  <= '0';
			spwc_rx_read_inputs_data_dc_fifo.aclr <= '1';
			-- Clocked Process
		elsif rising_edge(clk) then
			spwc_rx_read_inputs_data_dc_fifo.aclr <= '0';

			-- Enabled signal management
			if ((spwc_rx_bc_control_inputs.bc_enable = '1') and (spwc_rx_bc_control_inputs.bc_write_enable = '1')) then
				spwc_rx_bc_write_bus_outputs.enabled <= '1';
			else
				spwc_rx_bc_write_bus_outputs.enabled <= '0';
			end if;

		end if;
	end process spwc_rx_bus_controller_proc;

	-- DATA DC FIFO Read Signal assignment
	bc_rx_fifo_read_sig <= spwc_rx_bc_write_bus_inputs.dataused;

	-- DATA DC FIFO Underflow/Overflow protection
	spwc_rx_read_inputs_data_dc_fifo.rdreq <= (bc_rx_fifo_read_enable_sig) when (spwc_rx_read_outputs_data_dc_fifo.rdempty = '0') else ('0');

	-- RX BUS DataValid Signal assignment
	bc_rx_bus_datavalid_sig                <= not (spwc_rx_read_outputs_data_dc_fifo.rdempty);
	spwc_rx_bc_write_bus_outputs.datavalid <= bc_rx_bus_datavalid_enable_sig;

	-- RX Enable management
	bc_rx_fifo_read_enable_sig     <= (bc_rx_fifo_read_sig) when ((spwc_rx_bc_control_inputs.bc_enable = '1') and (spwc_rx_bc_control_inputs.bc_write_enable = '1')) else ('0');
	bc_rx_bus_datavalid_enable_sig <= (bc_rx_bus_datavalid_sig) when ((spwc_rx_bc_control_inputs.bc_enable = '1') and (spwc_rx_bc_control_inputs.bc_write_enable = '1')) else ('0');

	-- BUS SC FIFO Data Signal assignment
	bc_rx_bus_data_sig.spacewire_flag <= spwc_rx_read_outputs_data_dc_fifo.q(8);
	bc_rx_bus_data_sig.spacewire_data <= spwc_rx_read_outputs_data_dc_fifo.q(7 downto 0);

	-- RX BUS Data Signal assignment
	spwc_rx_bc_write_bus_outputs.data(8)          <= bc_rx_bus_data_sig.spacewire_flag;
	spwc_rx_bc_write_bus_outputs.data(7 downto 0) <= bc_rx_bus_data_sig.spacewire_data;

end architecture spwc_rx_bus_controller_arc;
