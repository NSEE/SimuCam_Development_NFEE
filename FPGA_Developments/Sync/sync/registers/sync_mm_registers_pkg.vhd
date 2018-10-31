package sync_mm_registers_pkg is

	--  Sync Status Register           						(32 bits):
	--    31-15 : Reserved                                  [-/-]
	--    14-14 : Sync Start control bit                    [R/W]
	--    13-13 : Sync Reset control bit                    [R/W]
	--    12-12 : Sync Running status bit                   [R/-]
	--    11-11 : Sync Error interrupt enable bit           [R/W]
	--    10-10 : Sync Master Blank interrupt enable bit    [R/W]
	--     9- 9 : Sync Blank interrupt enable bit	        [R/W]
	--     8- 8 : Sync Reseted interrupt enable bit         [R/W]
	--     7- 7 : Sync Error interrupt flag                 [R/-]
	--     6- 6 : Sync Error interrupt flag clear           [-/W]
	--     5- 5 : Sync Master Blank interrupt flag          [R/-]
	--     4- 4 : Sync Master Blank interrupt flag clear    [-/W]
	--     3- 3 : Sync Blank interrupt flag		            [R/-]
	--     2- 2 : Sync Blank interrupt flag clear		    [-/W]
	--     1- 1 : Sync Reseted interrupt flag               [R/-]
	--     0- 0 : Sync Reseted interrupt flag clear         [-/W]

	--  Sync Interrupt Register           					(32 bits):
	--    31-15 : Reserved                                  [-/-]
	--    14-14 : Sync Start control bit                    [R/W]
	--    13-13 : Sync Reset control bit                    [R/W]
	--    12-12 : Sync Running status bit                   [R/-]
	--    11-11 : Sync Error interrupt enable bit           [R/W]
	--    10-10 : Sync Master Blank interrupt enable bit    [R/W]
	--     9- 9 : Sync Blank interrupt enable bit	        [R/W]
	--     8- 8 : Sync Reseted interrupt enable bit         [R/W]
	--     7- 7 : Sync Error interrupt flag                 [R/-]
	--     6- 6 : Sync Error interrupt flag clear           [-/W]
	--     5- 5 : Sync Master Blank interrupt flag          [R/-]
	--     4- 4 : Sync Master Blank interrupt flag clear    [-/W]
	--     3- 3 : Sync Blank interrupt flag		            [R/-]
	--     2- 2 : Sync Blank interrupt flag clear		    [-/W]
	--     1- 1 : Sync Reseted interrupt flag               [R/-]
	--     0- 0 : Sync Reseted interrupt flag clear         [-/W]

	--  Sync config registers
	--  Sync Period Register			                 	(32 bits):
	--    31-0 : Sync Period value				            [R/W]
	
	--  Sync Master Blank Time Register   	              	(32 bits):
	--    31-0 : Sync MBT value             				[R/W]
	
	--  Sync Blank Time Register		                    (32 bits):
	--    31-0 : Sync BT value				                [R/W]

	--  Sync Control Register				                (32 bits):
	--    31-14 : Reserved                                  [-/-]
	--    13-12 : Sync Signal Number of Pulses value        [R/W]
	--    11-11 : Sync Signal Polarity bit                  [R/W]
	--    10-10 : Sync External/Internal(n) control bit     [R/W]
	--     9- 9 : Sync Signal Sync In enable bit            [R/W]
	--     8- 8 : Sync Signal Sync Out enable bit           [R/W]
	--     7- 7 : Sync Signal Channel A enable bit          [R/W]
	--     6- 6 : Sync Signal Channel B enable bit          [R/W]
	--     5- 5 : Sync Signal Channel C enable bit          [R/W]
	--     4- 4 : Sync Signal Channel D enable bit          [R/W]
	--     3- 3 : Sync Signal Channel E enable bit          [R/W]
	--     2- 2 : Sync Signal Channel F enable bit          [R/W]
	--     1- 1 : Sync Signal Channel G enable bit          [R/W]
	--     0- 0 : Sync Signal Channel H enable bit          [R/W]

	-- Registers Address
	constant c_SYNC_MODULE_CONTROL_STATUS_MM_REG_ADDRESS : natural := 0;
	constant c_SYNC_SIGNAL_CONFIGURATION_MM_REG_ADDRESS  : natural := 1;
	constant c_SYNC_SIGNAL_MASTER_WIDTH_MM_REG_ADDRESS   : natural := 2;
	constant c_SYNC_SIGNAL_PULSE_WIDTH_MM_REG_ADDRESS    : natural := 3;
	constant c_SYNC_SIGNAL_PULSE_PERIOD_MM_REG_ADDRESS   : natural := 4;

	-- Registers Types
	type t_sync_interrupt_register is record
		sync_error   : std_logic;
		master_start : std_logic;
		pulse_start  : std_logic;
		master_stop  : std_logic;
		pulse_stop   : std_logic;
		sync_reseted : std_logic;
	end record t_sync_interrupt_register;

	type t_sync_control_register is record
		sync_start : std_logic;
		sync_stop  : std_logic;
		sync_reset : std_logic;
	end record t_sync_control_register;

	type t_sync_status_register is record
		sync_running : std_logic;
		sync_stopped : std_logic;
	end record t_sync_status_register;

	type t_sync_config_register is record
		signal_number_pulses : std_logic_vector(1 downto 0);
		signal_polarity      : std_logic;
		sync_external        : std_logic;
		sync_in_enable       : std_logic;
		sync_out_enable      : std_logic;
		channel_A_enable     : std_logic;
		channel_B_enable     : std_logic;
		channel_C_enable     : std_logic;
		channel_D_enable     : std_logic;
		channel_E_enable     : std_logic;
		channel_F_enable     : std_logic;
		channel_G_enable     : std_logic;
		channel_H_enable     : std_logic;
	end record t_sync_config_register;

	type t_sync_master_width_register is record
		signal_master_width : std_logic_vector(31 downto 0);
	end record t_sync_master_width_register;

	type t_sync_pulse_width_register is record
		signal_pulse_width : std_logic_vector(31 downto 0);
	end record t_sync_pulse_width_register;

	type t_sync_pulse_period_register is record
		signal_pulse_period : std_logic_vector(31 downto 0);
	end record t_sync_pulse_period_register;

	-- Avalon MM Types
	type t_sync_mm_write_registers is record
		module_control_register       : t_sync_control_register;
		interrupt_enable_register     : t_sync_interrupt_register;
		interrupt_flag_clear_register : t_sync_interrupt_register;
		signal_configuration_register : t_sync_config_register;
		signal_master_width_register  : t_sync_master_width_register;
		signal_pulse_width_register   : t_sync_pulse_width_register;
		signal_pulse_period_register  : t_sync_pulse_period_register;
	end record t_sync_mm_write_registers;

	type t_sync_mm_read_registers is record
		module_status_register  : t_sync_status_register;
		interrupt_flag_register : t_sync_interrupt_register;
	end record t_sync_mm_read_registers;

end package sync_mm_registers_pkg;

package body sync_mm_registers_pkg is

end package body sync_mm_registers_pkg;
