library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_mm_registers_pkg is

	--  Interface Control and Status Register          (32 bits):
	--    31-13 : Reserved                               [-/-]
	--    12-12 : Backdoor Mode control bit              [R/W]
	--    11-11 : External Loopback Mode control bit     [R/W]
	--    10-10 : Codec Enable control bit               [R/W]
	--     9- 9 : Codec RX Enable control bit            [R/W]
	--     8- 8 : Codec TX Enable control bit            [R/W]
	--     7- 7 : Loopback Mode control bit              [R/W]
	--     6- 6 : Codec Force Reset control bit          [R/W]
	--     5- 5 : Link Error interrupt enable bit        [R/W]
	--     4- 4 : TimeCode Received interrupt enable bit [R/W]
	--     3- 3 : Link Running interrupt enable bit      [R/W]
	--     2- 2 : Link Error interrupt flag              [R/-]
	--     2- 2 : Link Error interrupt flag clear        [-/W]
	--     1- 1 : TimeCode Received interrupt flag       [R/-]
	--     1- 1 : TimeCode Received interrupt flag clear [-/W]
	--     0- 0 : Link Running interrupt flag            [R/-]
	--     0- 0 : Link Running interrupt flag clear      [-/W]
	--  SpW Link Control and Status Register           (32 bits):
	--    31-18 : Reserved                               [-/-]
	--    17-10 : TX Clock Divisor value                 [R/W]
	--     9- 9 : Autostart control bit                  [R/W]
	--     8- 8 : Link Start control bit                 [R/W]
	--     7- 7 : Link Disconnect control bit            [R/W]
	--     6- 6 : Link Disconnect error bit              [R/-]
	--     5- 5 : Link Parity error bit                  [R/-]
	--     4- 4 : Link Escape error bit                  [R/-]
	--     3- 3 : Link Credit error bit                  [R/-]
	--     2- 2 : Link Started status bit                [R/-]
	--     1- 1 : Link Connecting status bit             [R/-]
	--     0- 0 : Link Running status bit                [R/-]
	--  Timecode Control Register                      (32 bits):
	--    31-25 : Reserved                               [-/-]
	--    24-23 : RX TimeCode Control bits               [R/-]
	--    22-17 : RX TimeCode Counter value              [R/-]
	--    16-16 : RX TimeCode status bit                 [R/-]
	--    16-16 : RX TimeCode status bit clear           [-/W]
	--    15- 9 : Reserved                               [R/-]
	--     8- 7 : TX TimeCode Control bits               [R/W]
	--     6- 1 : TX TimeCode Counter value              [R/W]
	--     0- 0 : TX TimeCode control bit                [R/W]
	--  Backdoor Mode Control Register                 (32 bits):
	--    31-27 : Reserved                               [-/-]
	--    26-26 : RX Codec RX DataValid status bit       [R/-]
	--    25-25 : RX Codec RX Read control bit           [R/W]
	--    24-24 : RX Codec SpaceWire Flag value          [R/-]
	--    23-16 : RX Codec SpaceWire Data value          [R/-]
	--    15-11 : Reserved                               [-/-]
	--    10-10 : TX Codec TX Ready status bit           [R/-]
	--     9- 9 : TX Codec TX Write control bit          [R/W]
	--     8- 8 : TX Codec SpaceWire Flag value          [R/W]
	--     7- 0 : TX Codec SpaceWire Data value          [R/W]

	constant SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS : natural := 0;
	constant SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS  : natural := 1;
	constant SPWC_TIMECODE_CONTROL_MM_REG_ADDRESS         : natural := 2;
	constant SPWC_BACKDOOR_MODE_CONTROL_MM_REG_ADDRESS    : natural := 3;

	type spwc_backdoor_control_register_type is record
		CODEC_READ_WRITE : std_logic;
	end record spwc_backdoor_control_register_type;

	type spwc_backdoor_status_register_type is record
		CODEC_DATAVALID_READY : std_logic;
	end record spwc_backdoor_status_register_type;

	type spwc_backdoor_data_register_type is record
		CODEC_SPW_FLAG : std_logic;
		CODEC_SPW_DATA : std_logic_vector(7 downto 0);
	end record spwc_backdoor_data_register_type;

	type spwc_interface_control_register_type is record
		CODEC_ENABLE_BIT           : std_logic;
		CODEC_RX_ENABLE_BIT        : std_logic;
		CODEC_TX_ENABLE_BIT        : std_logic;
		LOOPBACK_MODE_BIT          : std_logic;
		EXTERNAL_LOOPBACK_MODE_BIT : std_logic;
		BACKDOOR_MODE_BIT          : std_logic;
		FORCE_RESET_BIT            : std_logic;
	end record spwc_interface_control_register_type;

	type spwc_interrupt_register_type is record
		LINK_ERROR        : std_logic;
		TIMECODE_RECEIVED : std_logic;
		LINK_RUNNING      : std_logic;
	end record spwc_interrupt_register_type;

	type spwc_spw_link_mode_register_type is record
		AUTOSTART_BIT       : std_logic;
		LINK_START_BIT      : std_logic;
		LINK_DISCONNECT_BIT : std_logic;
		TX_CLOCK_DIV        : std_logic_vector(7 downto 0);
	end record spwc_spw_link_mode_register_type;

	type spwc_spw_link_error_register_type is record
		DISCONNECT_ERROR_BIT : std_logic;
		PARITY_ERROR_BIT     : std_logic;
		ESCAPE_ERROR_BIT     : std_logic;
		CREDIT_ERROR_BIT     : std_logic;
	end record spwc_spw_link_error_register_type;

	type spwc_spw_link_status_register_type is record
		STARTED    : std_logic;
		CONNECTING : std_logic;
		RUNNING    : std_logic;
	end record spwc_spw_link_status_register_type;

	type spwc_timecode_register_type is record
		TIMECODE_CONTROL_BITS  : std_logic_vector(1 downto 0);
		TIMECODE_COUNTER_VALUE : std_logic_vector(5 downto 0);
		CONTROL_STATUS_BIT     : std_logic;
	end record spwc_timecode_register_type;

	type spwc_rx_timecode_clear_register_type is record
		CONTROL_STATUS_BIT : std_logic;
	end record spwc_rx_timecode_clear_register_type;

	type spwc_mm_write_registers_type is record
		INTERFACE_CONTROL_REGISTER    : spwc_interface_control_register_type;
		INTERRUPT_ENABLE_REGISTER     : spwc_interrupt_register_type;
		INTERRUPT_FLAG_CLEAR_REGISTER : spwc_interrupt_register_type;
		SPW_LINK_MODE_REGISTER        : spwc_spw_link_mode_register_type;
		RX_TIMECODE_CLEAR_REGISTER    : spwc_rx_timecode_clear_register_type;
		TX_TIMECODE_REGISTER          : spwc_timecode_register_type;
		RX_BACKDOOR_CONTROL_REGISTER  : spwc_backdoor_control_register_type;
		TX_BACKDOOR_CONTROL_REGISTER  : spwc_backdoor_control_register_type;
		TX_BACKDOOR_DATA_REGISTER     : spwc_backdoor_data_register_type;
	end record spwc_mm_write_registers_type;

	type spwc_mm_read_registers_type is record
		INTERRUPT_FLAG_REGISTER     : spwc_interrupt_register_type;
		SPW_LINK_ERROR_REGISTER     : spwc_spw_link_error_register_type;
		SPW_LINK_STATUS_REGISTER    : spwc_spw_link_status_register_type;
		RX_TIMECODE_REGISTER        : spwc_timecode_register_type;
		RX_BACKDOOR_STATUS_REGISTER : spwc_backdoor_status_register_type;
		RX_BACKDOOR_DATA_REGISTER   : spwc_backdoor_data_register_type;
		TX_BACKDOOR_STATUS_REGISTER : spwc_backdoor_status_register_type;
	end record spwc_mm_read_registers_type;

end package spwc_mm_registers_pkg;
