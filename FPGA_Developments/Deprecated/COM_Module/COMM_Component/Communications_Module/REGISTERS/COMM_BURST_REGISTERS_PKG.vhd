library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_burst_registers_pkg.all;

package comm_burst_registers_pkg is

	constant TRAN_BURST_REGISTERS_ADDRESS_OFFSET : natural := 32;
	
	type comm_burst_write_registers_type is record
		TRAN : tran_burst_write_registers_type;
	end record comm_burst_write_registers_type;

	type comm_burst_read_registers_type is record
		TRAN : tran_burst_read_registers_type;
	end record comm_burst_read_registers_type;

end package comm_burst_registers_pkg;
