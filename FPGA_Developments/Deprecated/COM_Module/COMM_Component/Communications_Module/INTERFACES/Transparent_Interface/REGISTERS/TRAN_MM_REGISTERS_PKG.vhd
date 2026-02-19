library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tran_mm_registers_pkg is

	--  Interface Control and Status Register        (32 bits):
	--    31-11 : Reserved                             [-/-]
	--    10-10 : Interface Enable control bit         [R/W]
	--     9- 9 : Interface RX Enable control bit      [R/W]
	--     8- 8 : Interface TX Enable control bit      [R/W]
	--     7- 7 : Interface Error interrupt enable bit [R/W]
	--     6- 6 : Data Received interrupt enable bit   [R/W]
	--     5- 5 : RX FIFO Full interrupt enable bit    [R/W]
	--     4- 4 : TX FIFO Empty interrupt enable bit   [R/W]
	--     3- 3 : Interface Error interrupt flag       [R/-]
	--     3- 3 : Interface Error interrupt flag clear [-/W]
	--     2- 2 : Data Received interrupt flag         [R/-]
	--     2- 2 : Data Received interrupt flag clear   [-/W]
	--     1- 1 : RX FIFO Full interrupt flag          [R/-]
	--     1- 1 : RX FIFO Full interrupt flag clear    [-/W]
	--     0- 0 : TX FIFO Empty interrupt flag         [R/-]
	--     0- 0 : TX FIFO Empty interrupt flag clear   [-/W]
	--  RX Mode Control Register                     (32 bits):
	--    31-11 : Reserved                             [-/-]
	--    10- 3 : RX FIFO Used Space value             [R/-]
	--     2- 2 : RX FIFO Reset control bit            [R/W]
	--     1- 1 : RX FIFO Empty status bit             [R/-]
	--     0- 0 : RX FIFO Full status bit              [R/-]
	--  TX Mode Control Register                     (32 bits):
	--    31-11 : Reserved                             [-/-]
	--    10- 3 : TX FIFO Used Space value             [R/-]
	--     2- 2 : TX FIFO Reset control bit            [R/W]
	--     1- 1 : TX FIFO Empty status bit             [R/-]
	--     0- 0 : TX FIFO Full status bit              [R/-]

	constant TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS : natural := 0;
	constant TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS          : natural := 1;
	constant TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS          : natural := 2;

	type tran_interface_control_register_type is record
		INTERFACE_ENABLE_BIT    : std_logic;
		INTERFACE_RX_ENABLE_BIT : std_logic;
		INTERFACE_TX_ENABLE_BIT : std_logic;
	end record tran_interface_control_register_type;

	type tran_interrupt_register_type is record
		INTERFACE_ERROR : std_logic;
		DATA_RECEIVED   : std_logic;
		RX_FIFO_FULL    : std_logic;
		TX_FIFO_EMPTY   : std_logic;
	end record tran_interrupt_register_type;

	type tran_fifo_control_register_type is record
		FIFO_RESET_BIT : std_logic;
	end record tran_fifo_control_register_type;

	type tran_fifo_status_register_type is record
		FIFO_EMPTY_BIT  : std_logic;
		FIFO_FULL_BIT   : std_logic;
		FIFO_USED_SPACE : std_logic_vector(7 downto 0);
	end record tran_fifo_status_register_type;

	type tran_mm_write_registers_type is record
		INTERFACE_CONTROL_REGISTER    : tran_interface_control_register_type;
		INTERRUPT_ENABLE_REGISTER     : tran_interrupt_register_type;
		INTERRUPT_FLAG_CLEAR_REGISTER : tran_interrupt_register_type;
		RX_FIFO_CONTROL_REGISTER      : tran_fifo_control_register_type;
		TX_FIFO_CONTROL_REGISTER      : tran_fifo_control_register_type;
	end record tran_mm_write_registers_type;

	type tran_mm_read_registers_type is record
		INTERRUPT_FLAG_REGISTER : tran_interrupt_register_type;
		RX_FIFO_STATUS_REGISTER : tran_fifo_status_register_type;
		TX_FIFO_STATUS_REGISTER : tran_fifo_status_register_type;
	end record tran_mm_read_registers_type;

end package tran_mm_registers_pkg;
