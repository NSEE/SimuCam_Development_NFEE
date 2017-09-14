library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_bus_controller_pkg.all;
use work.spwc_bus_controller_pkg.all;

entity comm_tx_bus_controller_ent is
	port(
--		clk                    : in  std_logic;
--		rst                    : in  std_logic;
		spwc_tx_bc_bus_outputs : in  spwc_bc_write_bus_outputs_type;
		spwc_tx_bc_bus_inputs  : out spwc_bc_write_bus_inputs_type;
		tran_tx_bc_bus_outputs : in  tran_bc_write_bus_outputs_type;
		tran_tx_bc_bus_inputs  : out tran_bc_write_bus_inputs_type
	);
end entity comm_tx_bus_controller_ent;

-- TX : Simucam --> SpW;

architecture comm_tx_bus_controller_arc of comm_tx_bus_controller_ent is

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

	spwc_tx_bc_bus_inputs.data <= (tran_tx_bc_bus_outputs.data) when (tran_tx_bc_bus_outputs.enabled = '1') else ((others => '0'));

	spwc_tx_bc_bus_inputs.datavalid <= (tran_tx_bc_bus_outputs.datavalid) when (tran_tx_bc_bus_outputs.enabled = '1') else ('0');
	tran_tx_bc_bus_inputs.dataused  <= (spwc_tx_bc_bus_outputs.dataused) when (spwc_tx_bc_bus_outputs.enabled = '1') else ('0');

end architecture comm_tx_bus_controller_arc;
