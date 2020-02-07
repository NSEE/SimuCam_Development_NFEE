--=============================================================================
--! @file sync_mm_registers_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync mm registers package (sync_mm_registers_pkg)
--
--! @brief 
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Cassio Berni (ccberni@hotmail.com)
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--! 08\11\2018 CB Module optimization & revision\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Package declaration for sync mm registers package
--============================================================================
package sync_mm_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_SYNC_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_SYNC_MAX_ADDR : natural range 0 to 255 := 16#37#;

	-- Registers Types

	-- Sync Status Register
	type t_sync_status_register is record
		int_ext_n    : std_logic;       -- Internal/External_n
		state        : std_logic_vector(7 downto 0); -- State
		error_code   : std_logic_vector(7 downto 0); -- Error code
		cycle_number : std_logic_vector(7 downto 0); -- Cycle number
	end record t_sync_status_register;

	-- Sync Interrupt Enable Register
	type t_sync_interrupt_enable_register is record
		error_irq_enable        : std_logic; -- Error interrupt enable bit
		blank_pulse_irq_enable  : std_logic; -- Blank pulse interrupt enable bit
		master_pulse_irq_enable : std_logic; -- Master pulse interrupt enable bit
		normal_pulse_irq_enable : std_logic; -- Normal pulse interrupt enable bit
		last_pulse_irq_enable   : std_logic; -- Last pulse interrupt enable bit
	end record t_sync_interrupt_enable_register;

	-- Sync Interrupt Flag Clear Register
	type t_sync_interrupt_flag_clear_register is record
		error_irq_flag_clear        : std_logic; -- Error interrupt flag clear bit
		blank_pulse_irq_flag_clear  : std_logic; -- Blank pulse interrupt flag clear bit
		master_pulse_irq_flag_clear : std_logic; -- Master pulse interrupt flag clear bit
		normal_pulse_irq_flag_clear : std_logic; -- Normal pulse interrupt flag clear bit
		last_pulse_irq_flag_clear   : std_logic; -- Last pulse interrupt flag clear bit
	end record t_sync_interrupt_flag_clear_register;

	-- Sync Interrupt Flag Register
	type t_sync_interrupt_flag_register is record
		error_irq_flag        : std_logic; -- Error interrupt flag bit
		blank_pulse_irq_flag  : std_logic; -- Blank pulse interrupt flag bit
		master_pulse_irq_flag : std_logic; -- Master pulse interrupt flag bit
		normal_pulse_irq_flag : std_logic; -- Normal pulse interrupt flag bit
		last_pulse_irq_flag   : std_logic; -- Last pulse interrupt flag bit
	end record t_sync_interrupt_flag_register;

	-- Pre-Sync Interrupt Enable Register
	type t_pre_sync_interrupt_enable_register is record
		pre_blank_pulse_irq_enable  : std_logic; -- Pre-Blank pulse interrupt enable bit
		pre_master_pulse_irq_enable : std_logic; -- Pre-Master pulse interrupt enable bit
		pre_normal_pulse_irq_enable : std_logic; -- Pre-Normal pulse interrupt enable bit
		pre_last_pulse_irq_enable   : std_logic; -- Pre-Last pulse interrupt enable bit
	end record t_pre_sync_interrupt_enable_register;

	-- Pre-Sync Interrupt Flag Clear Register
	type t_pre_sync_interrupt_flag_clear_register is record
		pre_blank_pulse_irq_flag_clear  : std_logic; -- Pre-Blank pulse interrupt flag clear bit
		pre_master_pulse_irq_flag_clear : std_logic; -- Pre-Master pulse interrupt flag clear bit
		pre_normal_pulse_irq_flag_clear : std_logic; -- Pre-Normal pulse interrupt flag clear bit
		pre_last_pulse_irq_flag_clear   : std_logic; -- Pre-Last pulse interrupt flag clear bit
	end record t_pre_sync_interrupt_flag_clear_register;

	-- Pre-Sync Interrupt Flag Register
	type t_pre_sync_interrupt_flag_register is record
		pre_blank_pulse_irq_flag  : std_logic; -- Pre-Blank pulse interrupt flag bit
		pre_master_pulse_irq_flag : std_logic; -- Pre-Master pulse interrupt flag bit
		pre_normal_pulse_irq_flag : std_logic; -- Pre-Normal pulse interrupt flag bit
		pre_last_pulse_irq_flag   : std_logic; -- Pre-Last pulse interrupt flag bit
	end record t_pre_sync_interrupt_flag_register;

	-- Sync Master Blank Time Config Register
	type t_sync_config_register is record
		master_blank_time     : std_logic_vector(31 downto 0); -- MBT value
		blank_time            : std_logic_vector(31 downto 0); -- BT value
		last_blank_time       : std_logic_vector(31 downto 0); -- LBT value
		pre_blank_time        : std_logic_vector(31 downto 0); -- Pre-Blank value
		period                : std_logic_vector(31 downto 0); -- Period value
		last_period           : std_logic_vector(31 downto 0); -- Last Period value
		master_detection_time : std_logic_vector(31 downto 0); -- Master Detection Time value
		one_shot_time         : std_logic_vector(31 downto 0); -- OST value
	end record t_sync_config_register;

	-- Sync General Config Register
	type t_sync_general_config_register is record
		signal_polarity  : std_logic;   -- Signal polarity
		number_of_cycles : std_logic_vector(7 downto 0); -- Number of cycles
	end record t_sync_general_config_register;

	-- Sync Error Injection Register
	type t_sync_error_injection_register is record
		error_injection : std_logic_vector(31 downto 0); -- Reserved
	end record t_sync_error_injection_register;

	-- Sync Control Register
	type t_sync_control_register is record
		int_ext_n        : std_logic;   -- Internal/External(n) bit
		start            : std_logic;   -- Start bit
		reset            : std_logic;   -- Reset bit
		one_shot         : std_logic;   -- One Shot bit
		err_inj          : std_logic;   -- Err_inj bit
		out_enable       : std_logic;   -- Sync_out  out enable bit
		channel_1_enable : std_logic;   -- Channel 1 out enable bit
		channel_2_enable : std_logic;   -- Channel 2 out enable bit
		channel_3_enable : std_logic;   -- Channel 3 out enable bit
		channel_4_enable : std_logic;   -- Channel 4 out enable bit
		channel_5_enable : std_logic;   -- Channel 5 out enable bit
		channel_6_enable : std_logic;   -- Channel 6 out enable bit
		channel_7_enable : std_logic;   -- Channel 7 out enable bit
		channel_8_enable : std_logic;   -- Channel 8 out enable bit
	end record t_sync_control_register;

	-- Sync IRQ Number Register
	type t_sync_irq_number_register is record
		sync_irq_number     : std_logic_vector(31 downto 0); -- Sync IRQ number
		pre_sync_irq_number : std_logic_vector(31 downto 0); -- Pre-Sync IRQ number
	end record t_sync_irq_number_register;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_sync_mm_write_registers is record
		sync_irq_enable_reg         : t_sync_interrupt_enable_register; -- Sync Interrupt Enable Register
		sync_irq_flag_clear_reg     : t_sync_interrupt_flag_clear_register; -- Sync Interrupt Flag Clear Register
		pre_sync_irq_enable_reg     : t_pre_sync_interrupt_enable_register; -- Pre-Sync Interrupt Enable Register
		pre_sync_irq_flag_clear_reg : t_pre_sync_interrupt_flag_clear_register; -- Pre-Sync Interrupt Flag Clear Register
		sync_config_reg             : t_sync_config_register; -- Sync Master Blank Time Config Register
		sync_general_config_reg     : t_sync_general_config_register; -- Sync General Config Register
		sync_error_injection_reg    : t_sync_error_injection_register; -- Sync Error Injection Register
		sync_control_reg            : t_sync_control_register; -- Sync Control Register
	end record t_sync_mm_write_registers;

	-- Avalon MM Read-Only Registers
	type t_sync_mm_read_registers is record
		sync_status_reg       : t_sync_status_register; -- Sync Status Register
		sync_irq_flag_reg     : t_sync_interrupt_flag_register; -- Sync Interrupt Flag Register
		pre_sync_irq_flag_reg : t_pre_sync_interrupt_flag_register; -- Pre-Sync Interrupt Flag Register
		sync_irq_number_reg   : t_sync_irq_number_register; -- Sync IRQ Number Register
	end record t_sync_mm_read_registers;

end package sync_mm_registers_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_mm_registers_pkg is
end package body sync_mm_registers_pkg;
--============================================================================
-- package body end
--============================================================================
