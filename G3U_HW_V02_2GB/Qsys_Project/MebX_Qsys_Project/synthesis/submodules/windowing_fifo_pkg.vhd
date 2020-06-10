library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package windowing_fifo_pkg is

	-- windowing fifo read control [in]
	type t_windowing_fifo_rd_control is record
		sclr  : std_logic;
		rdreq : std_logic;
	end record t_windowing_fifo_rd_control;

	-- windowing fifo write control [in]
	type t_windowing_fifo_wr_control is record
		sclr  : std_logic;
		wrreq : std_logic;
	end record t_windowing_fifo_wr_control;

	-- windowing fifo read status [out]
	type t_windowing_fifo_rd_status is record
		empty : std_logic;
		usedw : std_logic_vector(7 downto 0);
	end record t_windowing_fifo_rd_status;

	-- windowing fifo write status [out]
	type t_windowing_fifo_wr_status is record
		full  : std_logic;
		usedw : std_logic_vector(7 downto 0);
	end record t_windowing_fifo_wr_status;

	-- windowing fifo read data [out]
	type t_windowing_data_fifo_rd_data is record
		q : std_logic_vector(15 downto 0);
	end record t_windowing_data_fifo_rd_data;

	-- windowing fifo write data [in]
	type t_windowing_data_fifo_wr_data is record
		data : std_logic_vector(15 downto 0);
	end record t_windowing_data_fifo_wr_data;

	-- windowing fifo read data [out]
	type t_windowing_mask_fifo_rd_data is record
		q : std_logic;
	end record t_windowing_mask_fifo_rd_data;

	-- windowing fifo write data [in]
	type t_windowing_mask_fifo_wr_data is record
		data : std_logic;
	end record t_windowing_mask_fifo_wr_data;

	-- windowing fifo control [in]
	type t_windowing_fifo_control is record
		read  : t_windowing_fifo_rd_control;
		write : t_windowing_fifo_wr_control;
	end record t_windowing_fifo_control;

	-- windowing fifo status [out]
	type t_windowing_fifo_status is record
		read  : t_windowing_fifo_rd_status;
		write : t_windowing_fifo_wr_status;
	end record t_windowing_fifo_status;

end package windowing_fifo_pkg;

package body windowing_fifo_pkg is

end package body windowing_fifo_pkg;
