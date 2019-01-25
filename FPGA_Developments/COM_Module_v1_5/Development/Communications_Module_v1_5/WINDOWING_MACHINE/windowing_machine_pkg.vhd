package windowing_machine_pkg is

	-- Windowing process data type:
	-- -- 16 lines of 64 bits (4 pixels of 16 bits)
	-- -- 01 line of 64 bits (64 masks of 1 bit)
	-- ---- Total: 17 lines of 64 bits = 1088 bits

	type t_windowing_pixels is array (0 to 63) of std_logic_vector(15 downto 0);

	type t_windowing_data_block is record
		pixels_data : t_windowing_pixels;
		pixels_mask : std_logic_vector(63 downto 0);
	end record t_windowing_data_block;

	-- Widowing buffer:
	-- -- 16 blocks of window data (1088 bits)
	-- ---- Total : 17408 bits

	type t_windowing_data_buffer is array (0 to 15) of t_windowing_data_block;

	-- Windowing machine status [out]

	type t_windowing_machine_status is record
		idle : std_logic;
	end record t_windowing_machine_status;

	-- Windowing machine control [in]

	type t_windowing_machine_control is record
		start : std_logic;
	end record t_windowing_machine_control;

	-- Windowing buffer status [out]

	type t_windowing_buffer_status is record
		full       : std_logic;
		empty      : std_logic;
		data_valid : std_logic;
	end record t_windowing_buffer_status;

	-- Windowing buffer control [in]

	type t_windowing_buffer_control is record
		fetch_data : std_logic;
	end record t_windowing_buffer_control;

end package windowing_machine_pkg;

package body windowing_machine_pkg is

end package body windowing_machine_pkg;
