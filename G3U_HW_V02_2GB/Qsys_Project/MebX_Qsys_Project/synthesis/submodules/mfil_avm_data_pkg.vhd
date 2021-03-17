library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mfil_avm_data_pkg is

	constant c_MFIL_AVM_DATA_ADRESS_SIZE : natural := 64;
	constant c_MFIL_AVM_DATA_DATA_SIZE   : natural := 256;
	constant c_MFIL_AVM_DATA_SYMBOL_SIZE : natural := 8;

	--

	--	type t_mfil_avm_data_master_rd_control is record
	--		rd_req     : std_logic;
	--		rd_address : std_logic_vector((c_MFIL_AVM_DATA_ADRESS_SIZE - 1) downto 0);
	--	end record t_mfil_avm_data_master_rd_control;
	--
	--	type t_mfil_avm_data_master_rd_status is record
	--		rd_able  : std_logic;
	--		rd_data  : std_logic_vector((c_MFIL_AVM_DATA_DATA_SIZE - 1) downto 0);
	--		rd_valid : std_logic;
	--	end record t_mfil_avm_data_master_rd_status;

	type t_mfil_avm_data_master_wr_control is record
		wr_req     : std_logic;
		wr_abort   : std_logic;
		wr_address : std_logic_vector((c_MFIL_AVM_DATA_ADRESS_SIZE - 1) downto 0);
		wr_data    : std_logic_vector((c_MFIL_AVM_DATA_DATA_SIZE - 1) downto 0);
	end record t_mfil_avm_data_master_wr_control;

	type t_mfil_avm_data_master_wr_status is record
		wr_ready : std_logic;
		wr_done  : std_logic;
	end record t_mfil_avm_data_master_wr_status;

	--	constant c_MFIL_AVM_DATA_MASTER_RD_CONTROL_RST : t_mfil_avm_data_master_rd_control := (
	--		rd_req     => '0',
	--		rd_address => (others => '0')
	--	);
	--
	--	constant c_MFIL_AVM_DATA_MASTER_RD_STATUS_RST : t_mfil_avm_data_master_rd_status := (
	--		rd_able  => '0',
	--		rd_data  => (others => '0'),
	--		rd_valid => '0'
	--	);

	constant c_MFIL_AVM_DATA_MASTER_WR_CONTROL_RST : t_mfil_avm_data_master_wr_control := (
		wr_req     => '0',
		wr_abort   => '0',
		wr_address => (others => '0'),
		wr_data    => (others => '0')
	);

	constant c_MFIL_AVM_DATA_MASTER_WR_STATUS_RST : t_mfil_avm_data_master_wr_status := (
		wr_ready => '0',
		wr_done  => '0'
	);

	--

	--	type t_mfil_avm_data_slave_rd_status is record
	--		readdata    : std_logic_vector((c_MFIL_AVM_DATA_DATA_SIZE - 1) downto 0);
	--		waitrequest : std_logic;
	--	end record t_mfil_avm_data_slave_rd_status;
	--
	--	type t_mfil_avm_data_slave_rd_control is record
	--		address : std_logic_vector((c_MFIL_AVM_DATA_ADRESS_SIZE - 1) downto 0);
	--		read    : std_logic;
	--	end record t_mfil_avm_data_slave_rd_control;

	type t_mfil_avm_data_slave_wr_status is record
		waitrequest : std_logic;
	end record t_mfil_avm_data_slave_wr_status;

	type t_mfil_avm_data_slave_wr_control is record
		address   : std_logic_vector((c_MFIL_AVM_DATA_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_MFIL_AVM_DATA_DATA_SIZE - 1) downto 0);
	end record t_mfil_avm_data_slave_wr_control;

	--	constant c_MFIL_AVM_DATA_SLAVE_RD_STATUS_RST : t_mfil_avm_data_slave_rd_status := (
	--		readdata    => (others => '0'),
	--		waitrequest => '1'
	--	);
	--
	--	constant c_MFIL_AVM_DATA_SLAVE_RD_CONTROL_RST : t_mfil_avm_data_slave_rd_control := (
	--		address => (others => '0'),
	--		read    => '0'
	--	);

	constant c_MFIL_AVM_DATA_SLAVE_WR_STATUS_RST : t_mfil_avm_data_slave_wr_status := (
		waitrequest => '1'
	);

	constant c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST : t_mfil_avm_data_slave_wr_control := (
		address   => (others => '0'),
		write     => '0',
		writedata => (others => '0')
	);

end package mfil_avm_data_pkg;

package body mfil_avm_data_pkg is

end package body mfil_avm_data_pkg;
