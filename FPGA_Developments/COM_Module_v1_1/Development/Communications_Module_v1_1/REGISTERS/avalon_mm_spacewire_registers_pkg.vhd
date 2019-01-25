library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_spacewire_registers_pkg is

	--  Windowing Control Register                     (32 bits):
	--    31- 9 : Reserved                               [-/-]
	--     8- 8 : Masking enable control bit             [R/W]
	--     7- 3 : Reserved                               [-/-]
	--     2- 2 : Autostart control bit                  [R/W]
	--     1- 1 : Link Start control bit                 [R/W]
	--     0- 0 : Link Disconnect control bit            [R/W]

	--  Windowing Status Register                      (32 bits):
	--    31-12 : Reserved                               [-/-]
	--    11-11 : Link Disconnect error bit              [R/-]
	--    10-10 : Link Parity error bit                  [R/-]
	--     9- 9 : Link Escape error bit                  [R/-]
	--     8- 8 : Link Credit error bit                  [R/-]
	--     7- 3 : Reserved                               [-/-]	
	--     2- 2 : Link Started status bit                [R/-]
	--     1- 1 : Link Connecting status bit             [R/-]
	--     0- 0 : Link Running status bit                [R/-]

	--  Timecode RX Register                           (32 bits):
	--    31- 9 : Reserved                               [-/-]
	--     8- 7 : RX TimeCode Control bits               [R/-]
	--     6- 1 : RX TimeCode Counter value              [R/-]
	--     0- 0 : RX TimeCode status bit                 [R/-]
	--     0- 0 : RX TimeCode status bit clear           [-/W]

	--  Timecode TX Register                           (32 bits):
	--    31- 9 : Reserved                               [-/-]
	--     8- 7 : TX TimeCode Control bits               [R/W]
	--     6- 1 : TX TimeCode Counter value              [R/W]
	--     0- 0 : TX TimeCode control bit                [R/W]

	--  Interrupt Control Register                     (32 bits):
	--    31- 9 : Reserved                               [-/-]
	--     8- 8 : Left Buffer Empty interrupt enable     [R/W]
	--     7- 1 : Reserved                               [-/-]
	--     0- 0 : Right Buffer Empty interrupt enable    [R/W]

	--  Interrupt Flag Register                        (32 bits):
	--    31- 1 : Reserved                               [-/-]
	--     0- 0 : Buffer Empty interrupt flag            [R/-]
	--     0- 0 : Buffer Empty interrupt flag clear      [-/W]

	--  Windowing Buffer Register                      (32 bits):
	--    31- 9 : Reserved                               [-/-]
	--     8- 8 : Left Buffer Empty status bit           [R/-]
	--     7- 1 : Reserved                               [-/-]
	--     0- 0 : Right Buffer Empty status bit          [R/-]

	constant c_WINDOWING_AVALON_MM_REG_OFFSET   : natural := 0;
	constant c_WINDOWING_CONTROL_MM_REG_ADDRESS : natural := 0;
	constant c_WINDOWING_STATUS_MM_REG_ADDRESS  : natural := 1;
	constant c_TIMECODE_RX_MM_REG_ADDRESS       : natural := 2;
	constant c_TIMECODE_TX_MM_REG_ADDRESS       : natural := 3;
	constant c_INTERRUPT_CONTROL_MM_REG_ADDRESS : natural := 4;
	constant c_INTERRUPT_FLAG_MM_REG_ADDRESS    : natural := 5;
	constant c_WINDOWING_BUFFER_MM_REG_ADDRESS  : natural := 6;

	type t_windowing_control_register is record
		mask_enable : std_logic;
		autostart   : std_logic;
		linkstart   : std_logic;
		linkdis     : std_logic;
	end record t_windowing_control_register;

	type t_windowing_status_register is record
		errdis     : std_logic;
		errpar     : std_logic;
		erresc     : std_logic;
		errcred    : std_logic;
		started    : std_logic;
		connecting : std_logic;
		running    : std_logic;
	end record t_windowing_status_register;

	type t_timecode_rx_register is record
		rx_control  : std_logic_vector(1 downto 0);
		rx_time     : std_logic_vector(5 downto 0);
		rx_received : std_logic;
	end record t_timecode_rx_register;

	type t_timecode_rx_flags_register is record
		rx_received_clear : std_logic;
	end record t_timecode_rx_flags_register;

	type t_timecode_tx_register is record
		tx_control : std_logic_vector(1 downto 0);
		tx_time    : std_logic_vector(5 downto 0);
		tx_send    : std_logic;
	end record t_timecode_tx_register;

	type t_interrupt_control_register is record
		R_buffer_empty_enable : std_logic;
		L_buffer_empty_enable : std_logic;
	end record t_interrupt_control_register;

	type t_interrupt_flag_register is record
		buffer_empty_flag : std_logic;
	end record t_interrupt_flag_register;

	type t_windowing_buffer_register is record
		R_buffer_empty : std_logic;
		L_buffer_empty : std_logic;
	end record t_windowing_buffer_register;

	type t_windowing_read_registers is record
		windowing_status : t_windowing_status_register;
		timecode_rx      : t_timecode_rx_register;
		interrupt_flag   : t_interrupt_flag_register;
		windowing_buffer : t_windowing_buffer_register;
	end record t_windowing_read_registers;

	type t_windowing_write_registers is record
		windowing_control    : t_windowing_control_register;
		timecode_rx_flags    : t_timecode_rx_flags_register;
		timecode_tx          : t_timecode_tx_register;
		interrupt_flag_clear : t_interrupt_flag_register;
		interrupt_control    : t_interrupt_control_register;
	end record t_windowing_write_registers;

end package avalon_mm_spacewire_registers_pkg;

package body avalon_mm_spacewire_registers_pkg is

end package body avalon_mm_spacewire_registers_pkg;