library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ftdi_registers_pck is

	type ftdi_read_type is record
		DATA_REG_IN     : std_logic_vector(31 downto 0);
		BE_REG_IN       : std_logic_vector(3 downto 0);
		TXE_N_REG       : std_logic;
		RXF_N_REG       : std_logic;
		WAKEUP_N_REG_IN : std_logic;
		GPIO_REG_IN     : std_logic_vector(1 downto 0);
	end record ftdi_read_type;

	type ftdi_write_type is record
		DATA_REG_OUT     : std_logic_vector(31 downto 0);
		BE_REG_OUT       : std_logic_vector(3 downto 0);
		SIWU_N_REG       : std_logic;
		WR_N_REG         : std_logic;
		RD_N_REG         : std_logic;
		OE_N_REG         : std_logic;
		RESET_N_REG      : std_logic;
		WAKEUP_N_REG_OUT : std_logic;
		GPIO_REG_OUT     : std_logic_vector(1 downto 0);
		OE_REG           : std_logic_vector(3 downto 0);
	end record ftdi_write_type;
	
	subtype ftdi_address_type is integer range 0 to 15;
	
	constant FTDI_DATA_REG_ADDRESS           : integer := 0;
	constant FTDI_BE_REG_ADDRESS             : integer := 1;
	constant FTDI_TXE_N_REG_ADDRESS          : integer := 2;
	constant FTDI_RXF_N_REG_ADDRESS          : integer := 3;
	constant FTDI_SIWU_N_REG_ADDRESS         : integer := 4;
	constant FTDI_WR_N_REG_ADDRESS           : integer := 5;
	constant FTDI_RD_N_REG_ADDRESS           : integer := 6;
	constant FTDI_OE_N_REG_ADDRESS           : integer := 7;
	constant FTDI_RESET_N_REG_ADDRESS        : integer := 8;
	constant FTDI_WAKEUP_N_REG_ADDRESS       : integer := 9;
	constant FTDI_GPIO_REG_ADDRESS           : integer := 10;
	constant FTDI_OE_REG_ADDRESS_ADDRESS     : integer := 11;
	constant FTDI_DATA_OE_MASK_REG_ADDRESS   : integer := 12;
	constant FTDI_BE_OE_MASK_REG_ADDRESS     : integer := 13;
	constant FTDI_WAKEUP_OE_MASK_REG_ADDRESS : integer := 14;
	constant FTDI_GPIO_OE_MASK_REG_ADDRESS   : integer := 15;

end package ftdi_registers_pck;

