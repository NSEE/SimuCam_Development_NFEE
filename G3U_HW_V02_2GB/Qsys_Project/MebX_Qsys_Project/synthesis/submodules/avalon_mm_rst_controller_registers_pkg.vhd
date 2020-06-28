library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_rst_controller_registers_pkg is

	--  SimuCam Reser Control Register                  (32 bits):
	--    31-31 : SimuCam Reset control bit              [R/W]
	--    30- 0 : SimuCam Reset Timer value              [R/W]

	--  Device Reset Control Register                  (32 bits):
	--    31-12 : Reserved                               [-/-]
	--    11-11 : FTDI Module Reset control bit          [R/W]
	--    10-10 : Sync Module Reset control bit          [R/W]
	--     9- 9 : RS232 Module Reset control bit         [R/W]
	--     8- 8 : SD Card Module Reset control bit       [R/W]
	--     7- 7 : Comm Module CH8 Reset control bit      [R/W]
	--     6- 6 : Comm Module CH7 Reset control bit      [R/W]
	--     5- 5 : Comm Module CH6 Reset control bit      [R/W]
	--     4- 4 : Comm Module CH5 Reset control bit      [R/W]
	--     3- 3 : Comm Module CH4 Reset control bit      [R/W]
	--     2- 2 : Comm Module CH3 Reset control bit      [R/W]
	--     1- 1 : Comm Module CH2 Reset control bit      [R/W]
	--     0- 0 : Comm Module CH1 Reset control bit      [R/W]

	constant c_RSTC_AVALON_MM_REG_OFFSET         : natural := 0;
	constant c_RSTC_SIMUCAM_RESET_MM_REG_ADDRESS : natural := 0;
	constant c_RSTC_DEVICE_RESET_MM_REG_ADDRESS  : natural := 1;

	type t_rstc_simucam_reset_register is record
		simucam_reset : std_logic;
		simucam_timer : std_logic_vector(30 downto 0);
	end record t_rstc_simucam_reset_register;

	type t_rstc_device_reset_register is record
		ftdi_reset     : std_logic;
		sync_reset     : std_logic;
		rs232_reset    : std_logic;
		sd_card_reset  : std_logic;
		comm_ch8_reset : std_logic;
		comm_ch7_reset : std_logic;
		comm_ch6_reset : std_logic;
		comm_ch5_reset : std_logic;
		comm_ch4_reset : std_logic;
		comm_ch3_reset : std_logic;
		comm_ch2_reset : std_logic;
		comm_ch1_reset : std_logic;
	end record t_rstc_device_reset_register;

	type t_rst_controller_write_registers is record
		simucam_reset : t_rstc_simucam_reset_register;
		device_reset  : t_rstc_device_reset_register;
	end record t_rst_controller_write_registers;

end package avalon_mm_rst_controller_registers_pkg;

package body avalon_mm_rst_controller_registers_pkg is

end package body avalon_mm_rst_controller_registers_pkg;
