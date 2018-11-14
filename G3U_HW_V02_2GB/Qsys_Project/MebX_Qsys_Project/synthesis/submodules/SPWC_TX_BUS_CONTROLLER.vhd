library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_bus_controller_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_tx_bus_controller_ent is
	port(
		clk                                : in  std_logic;
		rst                                : in  std_logic;
		spwc_tx_bc_control_inputs          : in  spwc_bc_control_inputs_type;
		spwc_tx_bc_read_bus_inputs         : in  spwc_bc_read_bus_inputs_type;
		spwc_tx_bc_read_bus_outputs        : out spwc_bc_read_bus_outputs_type;
		spwc_tx_write_outputs_data_dc_fifo : in  spwc_tx_data_dc_fifo_clk100_outputs_type;
		spwc_tx_write_inputs_data_dc_fifo  : out spwc_tx_data_dc_fifo_clk100_inputs_type
	);
end entity spwc_tx_bus_controller_ent;

-- TX : bus --> fifo (Simucam --> SpW);

architecture spwc_tx_bus_controller_arc of spwc_tx_bus_controller_ent is

	-- Signals for TX BUS Control
	signal bc_tx_bus_dataused_sig        : std_logic := '0';
	signal bc_tx_bus_dataused_enable_sig : std_logic := '0';

	-- Signals for DATA DC FIFO Control
	signal bc_tx_fifo_write_sig        : std_logic := '0';
	signal bc_tx_fifo_write_enable_sig : std_logic := '0';

	-- Signals for BUS Controller Data	
	signal bc_tx_bus_data_sig : spwc_bc_bus_data_type;

begin

	spwc_tx_bus_controller_proc : process(clk, rst) is
	begin
		-- Reset Procedures
		if (rst = '1') then
			spwc_tx_bc_read_bus_outputs.enabled    <= '0';
			spwc_tx_write_inputs_data_dc_fifo.aclr <= '1';
			-- Clocked Process
		elsif rising_edge(clk) then
			spwc_tx_write_inputs_data_dc_fifo.aclr <= '0';

			-- Enabled signal management
			if ((spwc_tx_bc_control_inputs.bc_enable = '1') and (spwc_tx_bc_control_inputs.bc_read_enable = '1')) then
				spwc_tx_bc_read_bus_outputs.enabled <= '1';
			else
				spwc_tx_bc_read_bus_outputs.enabled <= '0';
			end if;

		end if;
	end process spwc_tx_bus_controller_proc;

	-- TX BUS DataUsed Signal assignment
	bc_tx_bus_dataused_sig               <= ('1') when ((spwc_tx_bc_read_bus_inputs.datavalid = '1') and (spwc_tx_write_outputs_data_dc_fifo.wrfull = '0')) else ('0');
	spwc_tx_bc_read_bus_outputs.dataused <= bc_tx_bus_dataused_enable_sig;

	-- DATA DC FIFO Write Signal assignment
	bc_tx_fifo_write_sig <= ('1') when ((spwc_tx_bc_read_bus_inputs.datavalid = '1') and (spwc_tx_write_outputs_data_dc_fifo.wrfull = '0')) else ('0');

	-- DATA DC FIFO Underflow/Overflow protection
	spwc_tx_write_inputs_data_dc_fifo.wrreq <= (bc_tx_fifo_write_enable_sig) when (spwc_tx_write_outputs_data_dc_fifo.wrfull = '0') else ('0');

	-- TX Enable management
	bc_tx_bus_dataused_enable_sig <= (bc_tx_bus_dataused_sig) when ((spwc_tx_bc_control_inputs.bc_enable = '1') and (spwc_tx_bc_control_inputs.bc_read_enable = '1')) else ('0');
	bc_tx_fifo_write_enable_sig   <= (bc_tx_fifo_write_sig) when ((spwc_tx_bc_control_inputs.bc_enable = '1') and (spwc_tx_bc_control_inputs.bc_read_enable = '1')) else ('0');

	-- TX BUS Data Signal assignment
	bc_tx_bus_data_sig.spacewire_flag          <= spwc_tx_bc_read_bus_inputs.data(8);
	bc_tx_bus_data_sig.spacewire_data <= spwc_tx_bc_read_bus_inputs.data(7 downto 0);

	-- DATA DC FIFO Data Signal assignment
	spwc_tx_write_inputs_data_dc_fifo.data(8)          <= bc_tx_bus_data_sig.spacewire_flag;
	spwc_tx_write_inputs_data_dc_fifo.data(7 downto 0) <= bc_tx_bus_data_sig.spacewire_data;

end architecture spwc_tx_bus_controller_arc;
