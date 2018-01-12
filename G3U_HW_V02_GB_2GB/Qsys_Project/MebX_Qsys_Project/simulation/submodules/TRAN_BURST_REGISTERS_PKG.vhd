library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tran_burst_registers_pkg is

	--  Transparent RX Burst Data Register (64 bits):
	--    63-57 : Reserved                   [-/-]
	--    56-56 : SpaceWire RX Flag 3        [R/-]
	--    55-48 : SpaceWire RX Data 3        [R/-]
	--    47-41 : Reserved                   [-/-]
	--    40-40 : SpaceWire RX Flag 2        [R/-]
	--    39-32 : SpaceWire RX Data 2        [R/-]
	--    31-25 : Reserved                   [-/-]
	--    24-24 : SpaceWire RX Flag 1        [R/-]
	--    23-16 : SpaceWire RX Data 1        [R/-]
	--    15- 9 : Reserved                   [-/-]
	--     8- 8 : SpaceWire RX Flag 0        [R/-]
	--     7- 0 : SpaceWire RX Data 0        [R/-]
	--  Transparent TX Burst Data Register (64 bits):
	--    63-57 : Reserved                   [-/-]
	--    56-56 : SpaceWire TX Flag 3        [-/W]
	--    55-48 : SpaceWire TX Data 3        [-/W]
	--    47-41 : Reserved                   [-/-]
	--    40-40 : SpaceWire TX Flag 2        [-/W]
	--    39-32 : SpaceWire TX Data 2        [-/W]
	--    31-25 : Reserved                   [-/-]
	--    24-24 : SpaceWire TX Flag 1        [-/W]
	--    23-16 : SpaceWire TX Data 1        [-/W]
	--    15- 9 : Reserved                   [-/-]
	--     8- 8 : SpaceWire TX Flag 0        [-/W]
	--     7- 0 : SpaceWire TX Data 0        [-/W]

	constant TRAN_RX_DATA_BURST_REG_ADDRESS      : natural := 0;
	constant TRAN_TX_DATA_BURST_REG_ADDRESS      : natural := 1;

	type tran_data_burst_register_type is record
		SPACEWIRE_FLAG_3 : std_logic;
		SPACEWIRE_DATA_3 : std_logic_vector(7 downto 0);
		SPACEWIRE_FLAG_2 : std_logic;
		SPACEWIRE_DATA_2 : std_logic_vector(7 downto 0);
		SPACEWIRE_FLAG_1 : std_logic;
		SPACEWIRE_DATA_1 : std_logic_vector(7 downto 0);
		SPACEWIRE_FLAG_0 : std_logic;
		SPACEWIRE_DATA_0 : std_logic_vector(7 downto 0);
	end record tran_data_burst_register_type;

	type tran_burst_read_registers_type is record
		RX_DATA_BURST_REGISTER : tran_data_burst_register_type;
	end record tran_burst_read_registers_type;

	type tran_burst_write_registers_type is record
		TX_DATA_BURST_REGISTER : tran_data_burst_register_type;
	end record tran_burst_write_registers_type;

end package tran_burst_registers_pkg;
