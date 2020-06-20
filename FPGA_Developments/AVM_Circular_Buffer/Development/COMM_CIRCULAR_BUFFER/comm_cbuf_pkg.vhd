library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_cbuf_pkg.all;

package comm_cbuf_pkg is

	constant c_COMM_CBUF_DATAW_SIZE : natural := 16;
	constant c_COMM_CBUF_WUSED_SIZE : natural := 16;

	--

	type t_comm_cbuf_rd_control is record
		flush       : std_logic;
		read        : std_logic;
		tail_offset : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		empty       : std_logic;
		addr_offset : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);
	end record t_comm_cbuf_rd_control;

	type t_comm_cbuf_rd_status is record
		busy      : std_logic;
		datavalid : std_logic;
		data_word : std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
	end record t_comm_cbuf_rd_status;

	type t_comm_cbuf_wr_control is record
		flush       : std_logic;
		write       : std_logic;
		data_word   : std_logic_vector((c_COMM_CBUF_DATAW_SIZE - 1) downto 0);
		head_offset : std_logic_vector((c_COMM_CBUF_WUSED_SIZE - 1) downto 0);
		full        : std_logic;
		addr_offset : std_logic_vector((c_COMM_AVM_CBUF_ADRESS_SIZE - 1) downto 0);
	end record t_comm_cbuf_wr_control;

	type t_comm_cbuf_wr_status is record
		busy  : std_logic;
		ready : std_logic;
	end record t_comm_cbuf_wr_status;

	constant c_COMM_CBUF_RD_CONTROL_RST : t_comm_cbuf_rd_control := (
		flush       => '1',
		read        => '0',
		tail_offset => (others => '0'),
		empty       => '1',
		addr_offset => (others => '0')
	);

	constant c_COMM_CBUF_RD_STATUS_RST : t_comm_cbuf_rd_status := (
		busy      => '0',
		datavalid => '0',
		data_word => (others => '0')
	);

	constant c_COMM_CBUF_WR_CONTROL_RST : t_comm_cbuf_wr_control := (
		flush       => '1',
		write       => '0',
		data_word   => (others => '0'),
		head_offset => (others => '0'),
		full        => '0',
		addr_offset => (others => '0')
	);

	constant c_COMM_CBUF_WR_STATUS_RST : t_comm_cbuf_wr_status := (
		busy  => '0',
		ready => '0'
	);

end package comm_cbuf_pkg;

package body comm_cbuf_pkg is

end package body comm_cbuf_pkg;
