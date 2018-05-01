library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_mm_registers_pkg.all;
use work.tran_mm_registers_pkg.all;

package comm_mm_registers_pkg is

	constant SPWC_MM_REGISTERS_ADDRESS_OFFSET : natural := 0;
	constant TRAN_MM_REGISTERS_ADDRESS_OFFSET : natural := 32;

	type comm_mm_write_registers_type is record
		SPWC : spwc_mm_write_registers_type;
		TRAN : tran_mm_write_registers_type;
	end record comm_mm_write_registers_type;

	type comm_mm_read_registers_type is record
		SPWC : spwc_mm_read_registers_type;
		TRAN : tran_mm_read_registers_type;
	end record comm_mm_read_registers_type;

end package comm_mm_registers_pkg;
