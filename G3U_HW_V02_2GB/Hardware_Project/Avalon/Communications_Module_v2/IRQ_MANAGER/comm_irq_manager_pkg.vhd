library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package comm_irq_manager_pkg is

	type t_comm_feeb_irq_manager_watches is record
		left_buffer_controller_finished  : std_logic;
		right_buffer_controller_finished : std_logic;
	end record t_comm_feeb_irq_manager_watches;

	type t_comm_feeb_irq_manager_flags is record
		left_buffer_controller_finished  : std_logic;
		right_buffer_controller_finished : std_logic;
	end record t_comm_feeb_irq_manager_flags;

	constant c_COMM_FEEB_IRQ_MANAGER_WATCHES_RST : t_comm_feeb_irq_manager_watches := (
		left_buffer_controller_finished  => '1',
		right_buffer_controller_finished => '1'
	);

	constant c_COMM_FEEB_IRQ_MANAGER_FLAGS_RST : t_comm_feeb_irq_manager_flags := (
		left_buffer_controller_finished  => '0',
		right_buffer_controller_finished => '0'
	);

	--

	type t_ftdi_comm_rmap_manager_watches is record
		rmap_write_data_finished : std_logic;
	end record t_ftdi_comm_rmap_manager_watches;

	type t_ftdi_comm_rmap_manager_contexts is record
		rmap_write_data_authorized : std_logic;
		rmap_win_area_write_flag   : std_logic;
	end record t_ftdi_comm_rmap_manager_contexts;

	type t_ftdi_comm_rmap_manager_flags is record
		rmap_write_config_flag : std_logic;
		rmap_write_window_flag : std_logic;
	end record t_ftdi_comm_rmap_manager_flags;

	type t_ftdi_comm_rmap_manager_rate_limits is record
		rmap_write_config_limit : std_logic_vector(31 downto 0);
		rmap_write_window_limit : std_logic_vector(31 downto 0);
	end record t_ftdi_comm_rmap_manager_rate_limits;

	type t_ftdi_comm_rmap_manager_rate_clears is record
		rmap_write_config_clear : std_logic;
		rmap_write_window_clear : std_logic;
	end record t_ftdi_comm_rmap_manager_rate_clears;

	type t_ftdi_comm_rmap_manager_rate_counters is record
		rmap_write_config_counter : std_logic_vector(31 downto 0);
		rmap_write_window_counter : std_logic_vector(31 downto 0);
	end record t_ftdi_comm_rmap_manager_rate_counters;

	constant c_COMM_RMAP_IRQ_MANAGER_WATCHES_RST : t_ftdi_comm_rmap_manager_watches := (
		rmap_write_data_finished => '0'
	);

	constant c_COMM_RMAP_IRQ_MANAGER_CONTEXTS_RST : t_ftdi_comm_rmap_manager_contexts := (
		rmap_write_data_authorized => '0',
		rmap_win_area_write_flag   => '0'
	);

	constant c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST : t_ftdi_comm_rmap_manager_flags := (
		rmap_write_config_flag => '0',
		rmap_write_window_flag => '0'
	);

	constant c_COMM_RMAP_IRQ_MANAGER_RATE_LIMITS_RST : t_ftdi_comm_rmap_manager_rate_limits := (
		rmap_write_config_limit => (others => '0'),
		rmap_write_window_limit => (others => '0')
	);

	constant c_COMM_RMAP_IRQ_MANAGER_RATE_CLEARS_RST : t_ftdi_comm_rmap_manager_rate_clears := (
		rmap_write_config_clear => '0',
		rmap_write_window_clear => '0'
	);

	constant c_COMM_RMAP_IRQ_MANAGER_RATE_COUNTERS_RST : t_ftdi_comm_rmap_manager_rate_counters := (
		rmap_write_config_counter => (others => '0'),
		rmap_write_window_counter => (others => '0')
	);

end package comm_irq_manager_pkg;

package body comm_irq_manager_pkg is

end package body comm_irq_manager_pkg;
