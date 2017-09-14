library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_bus_controller_pkg.all;
use work.tran_bus_controller_pkg.all;

entity comm_rx_bus_controller_ent is
	port(
--		clk                    : in  std_logic;
--		rst                    : in  std_logic;
		spwc_rx_bc_bus_outputs : in  spwc_bc_read_bus_outputs_type;
		spwc_rx_bc_bus_inputs  : out spwc_bc_read_bus_inputs_type;
		tran_rx_bc_bus_outputs : in  tran_bc_read_bus_outputs_type;
		tran_rx_bc_bus_inputs  : out tran_bc_read_bus_inputs_type
	);
end entity comm_rx_bus_controller_ent;

-- RX : SpW --> Simucam;

architecture comm_rx_bus_controller_arc of comm_rx_bus_controller_ent is

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

	spwc_rx_bc_bus_inputs.dataused <= (tran_rx_bc_bus_outputs.dataused) when (tran_rx_bc_bus_outputs.enabled = '1') else ('0');

	tran_rx_bc_bus_inputs.data      <= (spwc_rx_bc_bus_outputs.data) when (spwc_rx_bc_bus_outputs.enabled = '1') else ((others => '0'));
	tran_rx_bc_bus_inputs.datavalid <= (spwc_rx_bc_bus_outputs.datavalid) when (spwc_rx_bc_bus_outputs.enabled = '1') else ('0');

end architecture comm_rx_bus_controller_arc;
