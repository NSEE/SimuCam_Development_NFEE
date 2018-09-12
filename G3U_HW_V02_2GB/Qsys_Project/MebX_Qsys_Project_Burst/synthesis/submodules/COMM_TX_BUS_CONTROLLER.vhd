library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_bus_controller_pkg.all;
use work.spwc_bus_controller_pkg.all;
use work.tran_bus_controller_pkg.all;

entity comm_tx_bus_controller_ent is
	port(
		--		clk                    : in  std_logic;
		--		rst                    : in  std_logic;
		comm_tx_bc_bus_inputs  : in  comm_tx_bc_bus_inputs_type;
		comm_tx_bc_bus_outputs : out comm_tx_bc_bus_outputs_type
	);
end entity comm_tx_bus_controller_ent;

-- TX : Simucam --> SpW;

architecture comm_tx_bus_controller_arc of comm_tx_bus_controller_ent is

	signal spwc_tx_bc_bus_inputs_sig  : spwc_bc_read_bus_inputs_type;
	signal spwc_tx_bc_bus_outputs_sig : spwc_bc_read_bus_outputs_type;
	signal tran_tx_bc_bus_inputs_sig  : tran_bc_write_bus_inputs_type;
	signal tran_tx_bc_bus_outputs_sig : tran_bc_write_bus_outputs_type;

begin

	--	comm_tx_bus_controller_proc : process(clk, rst) is
	--	begin
	--		if (rst = '1') then
	--
	--		elsif rising_edge(clk) then
	--
	--		end if;
	--	end process comm_tx_bus_controller_proc;

	-- spwc_tx_inputs <-- tran_tx_outputs
	-- tran_tx_inputs <-- spwc_tx_outputs

	comm_tx_bc_bus_outputs.SPWC_IN <= spwc_tx_bc_bus_inputs_sig;
	spwc_tx_bc_bus_outputs_sig     <= comm_tx_bc_bus_inputs.SPWC_OUT;

	comm_tx_bc_bus_outputs.TRAN_IN <= tran_tx_bc_bus_inputs_sig;
	tran_tx_bc_bus_outputs_sig     <= comm_tx_bc_bus_inputs.TRAN_OUT;

	spwc_tx_bc_bus_inputs_sig.data      <= (tran_tx_bc_bus_outputs_sig.data) when (tran_tx_bc_bus_outputs_sig.enabled = '1') else ((others => '0'));
	spwc_tx_bc_bus_inputs_sig.datavalid <= (tran_tx_bc_bus_outputs_sig.datavalid) when (tran_tx_bc_bus_outputs_sig.enabled = '1') else ('0');

	tran_tx_bc_bus_inputs_sig.dataused <= (spwc_tx_bc_bus_outputs_sig.dataused) when (spwc_tx_bc_bus_outputs_sig.enabled = '1') else ('0');

end architecture comm_tx_bus_controller_arc;
