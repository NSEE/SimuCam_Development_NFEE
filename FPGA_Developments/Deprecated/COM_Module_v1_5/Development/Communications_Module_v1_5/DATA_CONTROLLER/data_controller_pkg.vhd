library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package data_controller_pkg is

	-- data fifo read control [in]
	type t_data_fifo_rd_control is record
		sclr  : std_logic;
		rdreq : std_logic;
	end record t_data_fifo_rd_control;

	-- data fifo write control [in]
	type t_data_fifo_wr_control is record
		sclr  : std_logic;
		wrreq : std_logic;
	end record t_data_fifo_wr_control;

	-- data fifo read status [out]
	type t_data_fifo_rd_status is record
		empty  : std_logic;
		usedw : std_logic_vector(8 downto 0);
	end record t_data_fifo_rd_status;

	-- data fifo write status [out]
	type t_data_fifo_wr_status is record
		full  : std_logic;
		usedw : std_logic_vector(8 downto 0);
	end record t_data_fifo_wr_status;

	-- data fifo read data [out]
	type t_data_fifo_rd_data is record
		q : std_logic_vector(7 downto 0);
	end record t_data_fifo_rd_data;

	-- data fifo write data [in]
	type t_data_fifo_wr_data is record
		data : std_logic_vector(7 downto 0);
	end record t_data_fifo_wr_data;

	-- data fifo control [in]
	type t_data_fifo_control is record
		read  : t_data_fifo_rd_control;
		write : t_data_fifo_wr_control;
	end record t_data_fifo_control;

	-- data fifo status [out]
	type t_data_fifo_status is record
		read  : t_data_fifo_rd_status;
		write : t_data_fifo_wr_status;
	end record t_data_fifo_status;

end package data_controller_pkg;

package body data_controller_pkg is

end package body data_controller_pkg;
