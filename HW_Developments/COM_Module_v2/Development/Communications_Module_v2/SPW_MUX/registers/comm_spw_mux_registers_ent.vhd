library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_mux_pkg.all;

entity comm_spw_mux_registers_ent is
	port(
		-- basic inputs
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		-- logic inputs
		swrd_status_i  : in  t_swrd_status;
		swtm_status_i  : in  t_swtm_status;
		-- logic outputs
		swrd_control_o : out t_swrd_control;
		swtm_control_o : out t_swtm_control
	);
end entity comm_spw_mux_registers_ent;

architecture RTL of comm_spw_mux_registers_ent is

begin

end architecture RTL;
