package sync_mm_registers_pkg is

	--  Sync Status Register           						(32 bits):
	--	  31-31 : Sync Internal/External_n				    [R/W]
	--    30-24 : Reserved                                  [-/-]
	--    23-16 : Sync State							    [R/W]
	--    15- 8 : Sync Error code			                [R/W]
	--     7- 0 : Sync Cycle number					        [R/W]

	--  Sync Interrupt Register           					(32 bits):
	--    31-10 : Reserved                                  [-/-]
	--     9- 9 : Sync Error interrupt enable bit           [R/W]
	--     8- 8 : Sync Blank pulse interrupt enable bit     [R/W]
	--     7- 2 : Reserved                                  [-/-]
	--     1- 1 : Sync Error interrupt flag                 [R/W]
	--     0- 0 : Sync Blank interrupt flag		            [R/W]
	
	--  Sync config registers -----------------------------------
	--  Sync Master Blank Time Register   	              	(32 bits):
	--    31-0 : Sync MBT value             				[R/W]
	
	--  Sync Blank Time Register		                    (32 bits):
	--    31-0 : Sync BT value				                [R/W]

	--  Sync Period Register			                 	(32 bits):
	--    31-0 : Sync Period value				            [R/W]

	--  Sync One Shot Time Register		                 	(32 bits):
	--    31-0 : Sync OST value					            [R/W]

	--  Sync General Config Register	                 	(32 bits):
	--    31- 9 : Reserved                                  [-/-]
	--     8- 8 : Sync signal polarity			            [R/W]
	--     7- 0 : Sync number of cycles					    [R/W]
-----------------------------------------------------------------

	--  Sync Error Injection Register	                 	(32 bits):
	--    31- 0 : Reserved (TBD)                            [R/W]

	--  Sync Control Register				                (32 bits):
	--    31-31 : Sync Internal/External(n) bit			    [R/W]
	--    30-20 : Reserved                                  [-/-]
	--    19-19 : Sync Start bit		                    [R/W]
	--    18-18 : Sync Reset bit					        [R/W]
	--    17-17 : Sync One Shot bit						    [R/W]
	--    16-16 : Sync Err_inj bit						    [R/W]
	--    15- 9 : Reserved                                  [-/-]
	--     8- 8 : Sync Sync_out  out enable bit         	[R/W]
	--     7- 7 : Sync Channel H out enable bit          	[R/W]
	--     6- 6 : Sync Channel G out enable bit          	[R/W]
	--     5- 5 : Sync Channel F out enable bit          	[R/W]
	--     4- 4 : Sync Channel E out enable bit          	[R/W]
	--     3- 3 : Sync Channel D out enable bit          	[R/W]
	--     2- 2 : Sync Channel C out enable bit          	[R/W]
	--     1- 1 : Sync Channel B out enable bit          	[R/W]
	--     0- 0 : Sync Channel A out enable bit	            [R/W]

	-- Registers Address
	constant c_SYNC_STATUS_MM_REG_ADDRESS 					: natural := 0;
	constant c_SYNC_INTERRUPT_MM_REG_ADDRESS 				: natural := 1;
	constant c_SYNC_CONFIG_MASTER_BLANK_TIME_MM_REG_ADDRESS	: natural := 2;
	constant c_SYNC_CONFIG_BLANK_TIME_MM_REG_ADDRESS		: natural := 3;
	constant c_SYNC_CONFIG_PERIOD_MM_REG_ADDRESS			: natural := 4;
	constant c_SYNC_CONFIG_ONE_SHOT_TIME_MM_REG_ADDRESS		: natural := 5;
	constant c_SYNC_CONFIG_GENERAL_MM_REG_ADDRESS			: natural := 6;
	constant c_SYNC_ERROR_INJECTION_MM_REG_ADDRESS			: natural := 7;
	constant c_SYNC_CONTROL_MM_REG_ADDRESS					: natural := 8;

	-- Registers Types
	type t_sync_status_register is record
		int_ext_n 		: std_logic;
		state			: std_logic_vector(7 downto 0);
		error_code		: std_logic_vector(7 downto 0);
		cycle_number	: std_logic_vector(7 downto 0);
	end record t_sync_status_register;

	type t_sync_interrupt_register is record
		error_isr_en			: std_logic;
		blank_pulse_isr_en		: std_logic;
		error_isr_flag			: std_logic;
		blank_pulse_isr_flag	: std_logic;
	end record t_sync_interrupt_register;

	type t_sync_general_config_register is record
		signal_polarity		: std_logic;
		number_of_cycles 	: std_logic_vector(7 downto 0);
	end record t_sync_general_config_register;

	type t_sync_config_register is record
		master_blank_time	: std_logic_vector(31 downto 0);
		blank_time 			: std_logic_vector(31 downto 0);
		period 				: std_logic_vector(31 downto 0);
		one_shot_time		: std_logic_vector(31 downto 0);
		general				: t_sync_general_config_register;
	end record t_sync_config_register;

	type t_sync_error_injection_register is record
		error_injection	: std_logic_vector(31 downto 0);
	end record t_sync_error_injection_register;

	type t_sync_control_register is record
		sync_int_ext_n      : std_logic;
		sync_start			: std_logic;
		sync_reset			: std_logic;
		sync_one_shot		: std_logic;
		sync_err_inj		: std_logic;
		sync_out_enable     : std_logic;
		channel_h_enable	: std_logic;
		channel_g_enable    : std_logic;
		channel_f_enable    : std_logic;
		channel_e_enable    : std_logic;
		channel_d_enable    : std_logic;
		channel_c_enable    : std_logic;
		channel_b_enable    : std_logic;
		channel_a_enable    : std_logic;
	end record t_sync_control_register;

	-- Avalon MM Types
	type t_sync_mm_write_registers is record
		interrupt_enable_register     	: t_sync_interrupt_register;
		interrupt_flag_register 		: t_sync_interrupt_register;
		config_register				  	: t_sync_config_register;
		error_injection_register		: t_sync_error_injection_register;
		control_register				: t_sync_control_register;
	end record t_sync_mm_write_registers;

	type t_sync_mm_read_registers is record
		status_register  				: t_sync_status_register;
		interrupt_enable_register     	: t_sync_interrupt_register;
		interrupt_flag_register 		: t_sync_interrupt_register;
		config_register				  	: t_sync_config_register;
		error_injection_register		: t_sync_error_injection_register;
		control_register				: t_sync_control_register;
	end record t_sync_mm_read_registers;

end package sync_mm_registers_pkg;

package body sync_mm_registers_pkg is
end package body sync_mm_registers_pkg;
