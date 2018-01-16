library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_bus_controller_pkg.all;
use work.spwc_bus_controller_pkg.all;
use work.tran_bus_controller_pkg.all;

entity comm_rx_bus_controller_ent is
	port(
		--		clk                    : in  std_logic;
		--		rst                    : in  std_logic;
		comm_rx_bc_bus_inputs  : in  comm_rx_bc_bus_inputs_type;
		comm_rx_bc_bus_outputs : out comm_rx_bc_bus_outputs_type
	);
end entity comm_rx_bus_controller_ent;

-- RX : SpW --> Simucam;

architecture comm_rx_bus_controller_arc of comm_rx_bus_controller_ent is

	signal spwc_rx_bc_bus_outputs_sig : spwc_bc_write_bus_outputs_type;
	signal spwc_rx_bc_bus_inputs_sig  : spwc_bc_write_bus_inputs_type;
	signal tran_rx_bc_bus_outputs_sig : tran_bc_read_bus_outputs_type;
	signal tran_rx_bc_bus_inputs_sig  : tran_bc_read_bus_inputs_type;

begin

	--	comm_rx_bus_controller_proc : process(clk, rst) is
	--	begin
	--		if (rst = '1') then
	--
	--		elsif rising_edge(clk) then
	--
	--		end if;
	--	end process comm_rx_bus_controller_proc;

	-- spwc_rx_inputs <-- tran_rx_outputs
	-- tran_rx_inputs <-- spwc_rx_outputs 

	spwc_rx_bc_bus_outputs_sig <= comm_rx_bc_bus_inputs.SPWC_OUT;
	tran_rx_bc_bus_outputs_sig <= comm_rx_bc_bus_inputs.TRAN_OUT;

	comm_rx_bc_bus_outputs.SPWC_IN <= spwc_rx_bc_bus_inputs_sig;
	comm_rx_bc_bus_outputs.TRAN_IN <= tran_rx_bc_bus_inputs_sig;

	spwc_rx_bc_bus_inputs_sig.dataused <= (tran_rx_bc_bus_outputs_sig.dataused) when (tran_rx_bc_bus_outputs_sig.enabled = '1') else ('0');

	tran_rx_bc_bus_inputs_sig.data      <= (spwc_rx_bc_bus_outputs_sig.data) when (spwc_rx_bc_bus_outputs_sig.enabled = '1') else ((others => '0'));
	tran_rx_bc_bus_inputs_sig.datavalid <= (spwc_rx_bc_bus_outputs_sig.datavalid) when (spwc_rx_bc_bus_outputs_sig.enabled = '1') else ('0');

end architecture comm_rx_bus_controller_arc;
