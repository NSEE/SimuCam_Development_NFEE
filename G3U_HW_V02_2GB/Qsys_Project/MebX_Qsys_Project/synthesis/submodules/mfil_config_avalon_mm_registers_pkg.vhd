library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mfil_config_avalon_mm_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_CONFIG_MAX_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_CONFIG_MIN_ADDR : natural range 0 to 255 := 16#0F#;

	-- Registers Types

	-- MFIL Data Control Register
	type t_mfil_data_control_wr_reg is record
		wr_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Initial Write Address [High Dword]
		wr_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Initial Write Address [Low Dword]
		wr_data_length_bytes       : std_logic_vector(31 downto 0); -- Write Data Length [Bytes]
		wr_data_value_dword_7      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 7]
		wr_data_value_dword_6      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 6]
		wr_data_value_dword_5      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 5]
		wr_data_value_dword_4      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 4]
		wr_data_value_dword_3      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 3]
		wr_data_value_dword_2      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 2]
		wr_data_value_dword_1      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 1]
		wr_data_value_dword_0      : std_logic_vector(31 downto 0); -- Write Data Value [Dword 0]
		wr_timeout                 : std_logic_vector(15 downto 0); -- Write Timeout
		wr_start                   : std_logic; -- Data Write Start
		wr_reset                   : std_logic; -- Data Write Reset
	end record t_mfil_data_control_wr_reg;

	-- MFIL Data Status Register
	type t_mfil_data_status_rd_reg is record
		wr_busy        : std_logic;     -- Data Write Busy
		wr_timeout_err : std_logic;     -- Write Timeout Error
	end record t_mfil_data_status_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_mfil_config_wr_registers is record
		data_control_reg : t_mfil_data_control_wr_reg; -- MFIL Data Control Register
	end record t_mfil_config_wr_registers;

	-- Avalon MM Read-Only Registers
	type t_mfil_config_rd_registers is record
		data_status_reg : t_mfil_data_status_rd_reg; -- MFIL Data Status Register
	end record t_mfil_config_rd_registers;

end package mfil_config_avalon_mm_registers_pkg;

package body mfil_config_avalon_mm_registers_pkg is

end package body mfil_config_avalon_mm_registers_pkg;
