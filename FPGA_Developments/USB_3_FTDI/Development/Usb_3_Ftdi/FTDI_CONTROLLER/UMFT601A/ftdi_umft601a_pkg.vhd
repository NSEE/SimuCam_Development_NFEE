library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_umft601a_pkg is

	type t_ftdi_umft601a_control is record
		reset_n  : std_logic;
		wr_n     : std_logic;
		rd_n     : std_logic;
		oe_n     : std_logic;
		siwu_n   : std_logic;
		wakeup_n : std_logic;
		gpio     : std_logic_vector(1 downto 0);
	end record t_ftdi_umft601a_control;

	type t_ftdi_umft601a_status is record
		rxf_n    : std_logic;
		txe_n    : std_logic;
		wakeup_n : std_logic;
		gpio     : std_logic_vector(1 downto 0);
	end record t_ftdi_umft601a_status;

	type t_ftdi_umft601a_data is record
		data : std_logic_vector(31 downto 0);
		be   : std_logic_vector(3 downto 0);
	end record t_ftdi_umft601a_data;
	

end package ftdi_umft601a_pkg;

package body ftdi_umft601a_pkg is

end package body ftdi_umft601a_pkg;

	