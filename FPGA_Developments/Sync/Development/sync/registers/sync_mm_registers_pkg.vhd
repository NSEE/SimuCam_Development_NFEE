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

	--  Sync Status Register           						(32 bits):
	--	  31-31 : Internal/External_n					    [R/-]
	--    30-24 : Reserved                                  [-/-]
	--    23-16 : State									    [R/-]
	--    15- 8 : Error code				                [R/-]
	--     7- 0 : Cycle number						        [R/-]

	--  Sync Interrupt Registers -------------------------------- 
	--  Enable Register				                 	(32 bits):
	--    31- 5 : Reserved                                  [-/-]
	--     4- 4 : Error interrupt enable bit	            [R/W]
	--     3- 3 : Blank pulse interrupt enable bit		    [R/W]
	--     2- 2 : Master pulse interrupt enable bit		    [R/W]
	--     1- 1 : Normal pulse interrupt enable bit		    [R/W]
	--     0- 0 : Last pulse interrupt enable bit			[R/W]

	--  Flag Clear Register				                 	(32 bits):
	--    31- 5 : Reserved                                  [-/-]
	--     4- 4 : Error interrupt flag clear bit            [R/W]
	--     3- 3 : Blank pulse interrupt flag clear bit	    [R/W]
	--     2- 2 : Master pulse interrupt flag clear bit	    [R/W]
	--     1- 1 : Normal pulse interrupt flag clear bit	    [R/W]
	--     0- 0 : Last pulse interrupt flag clear bit		[R/W]

	--  Flag Register				                 	(32 bits):
	--    31- 5 : Reserved                                  [-/-]
	--     4- 4 : Error interrupt flag bit	  	          	[R/-]
	--     3- 3 : Blank pulse interrupt flag bit		    [R/-]
	--     2- 2 : Master pulse interrupt flag bit		    [R/-]
	--     1- 1 : Normal pulse interrupt flag bit		    [R/-]
	--     0- 0 : Last pulse interrupt flag bit				[R/-]
	-----------------------------------------------------------------

	--  Sync config registers -----------------------------------
	--  Master Blank Time Register		   	              	(32 bits):
	--    31-0 : MBT value             						[R/W]

	--  Blank Time Register				                    (32 bits):
	--    31-0 : BT value					                [R/W]

	--  Period Register					                 	(32 bits):
	--	  31-0 : Period value					            [R/W]

	--  Shot Time Register				                 	(32 bits):
	--    31-0 : OST value						            [R/W]

	--  General Config Register			                 	(32 bits):
	--    31- 9 : Reserved                                  [-/-]
	--     8- 8 : Signal polarity				            [R/W]
	--     7- 0 : Number of cycles						    [R/W]
	-----------------------------------------------------------------

	--  Sync Error Injection Register	                 	(32 bits):
	--    31- 0 : Reserved (TBD)                            [R/W]

	--  Sync Control Register				                (32 bits):
	--    31-31 : Internal/External(n) bit				    [R/W]
	--    30-20 : Reserved                                  [-/-]
	--    19-19 : Start bit				                    [R/W]
	--    18-18 : Reset bit							        [R/W]
	--    17-17 : One Shot bit							    [R/W]
	--    16-16 : Err_inj bit							    [R/W]
	--    15- 9 : Reserved                                  [-/-]
	--     8- 8 : Sync_out  out enable bit		         	[R/W]
	--     7- 7 : Channel H out enable bit      	    	[R/W]
	--     6- 6 : Channel G out enable bit          		[R/W]
	--     5- 5 : Channel F out enable bit          		[R/W]
	--     4- 4 : Channel E out enable bit         		 	[R/W]
	--     3- 3 : Channel D out enable bit         	 		[R/W]
	--     2- 2 : Channel C out enable bit          		[R/W]
	--     1- 1 : Channel B out enable bit          		[R/W]
	--     0- 0 : Channel A out enable bit	           		[R/W]

	-- Registers Address
	constant c_SYNC_STATUS_MM_REG_ADDRESS : natural := 0;

	constant c_SYNC_INTERRUPT_MM_ENABLE_REG_ADDRESS     : natural := 1;
	constant c_SYNC_INTERRUPT_MM_FLAG_CLEAR_REG_ADDRESS : natural := 2;
	constant c_SYNC_INTERRUPT_MM_FLAG_REG_ADDRESS       : natural := 3;

	constant c_SYNC_CONFIG_MASTER_BLANK_TIME_MM_REG_ADDRESS : natural := 4;
	constant c_SYNC_CONFIG_BLANK_TIME_MM_REG_ADDRESS        : natural := 5;
	constant c_SYNC_CONFIG_PERIOD_MM_REG_ADDRESS            : natural := 6;
	constant c_SYNC_CONFIG_ONE_SHOT_TIME_MM_REG_ADDRESS     : natural := 7;
	constant c_SYNC_CONFIG_GENERAL_MM_REG_ADDRESS           : natural := 8;

	constant c_SYNC_ERROR_INJECTION_MM_REG_ADDRESS : natural := 9;

	constant c_SYNC_CONTROL_MM_REG_ADDRESS : natural := 10;

	-- Registers Types
	type t_sync_status_register is record
		int_ext_n    : std_logic;
		state        : std_logic_vector(7 downto 0);
		error_code   : std_logic_vector(7 downto 0);
		cycle_number : std_logic_vector(7 downto 0);
	end record t_sync_status_register;

	type t_sync_interrupt_enable_register is record
		error_irq_enable        : std_logic;
		blank_pulse_irq_enable  : std_logic;
		master_pulse_irq_enable : std_logic;
		normal_pulse_irq_enable : std_logic;
		last_pulse_irq_enable   : std_logic;
	end record t_sync_interrupt_enable_register;

	type t_sync_interrupt_flag_clear_register is record
		error_irq_flag_clear        : std_logic;
		blank_pulse_irq_flag_clear  : std_logic;
		master_pulse_irq_flag_clear : std_logic;
		normal_pulse_irq_flag_clear : std_logic;
		last_pulse_irq_flag_clear   : std_logic;
	end record t_sync_interrupt_flag_clear_register;

	type t_sync_interrupt_flag_register is record
		error_irq_flag        : std_logic;
		blank_pulse_irq_flag  : std_logic;
		master_pulse_irq_flag : std_logic;
		normal_pulse_irq_flag : std_logic;
		last_pulse_irq_flag   : std_logic;
	end record t_sync_interrupt_flag_register;

	type t_pre_sync_interrupt_enable_register is record
		pre_blank_pulse_irq_enable  : std_logic;
		pre_master_pulse_irq_enable : std_logic;
		pre_normal_pulse_irq_enable : std_logic;
		pre_last_pulse_irq_enable   : std_logic;
	end record t_pre_sync_interrupt_enable_register;

	type t_pre_sync_interrupt_flag_clear_register is record
		pre_blank_pulse_irq_flag_clear  : std_logic;
		pre_master_pulse_irq_flag_clear : std_logic;
		pre_normal_pulse_irq_flag_clear : std_logic;
		pre_last_pulse_irq_flag_clear   : std_logic;
	end record t_pre_sync_interrupt_flag_clear_register;

	type t_pre_sync_interrupt_flag_register is record
		pre_blank_pulse_irq_flag  : std_logic;
		pre_master_pulse_irq_flag : std_logic;
		pre_normal_pulse_irq_flag : std_logic;
		pre_last_pulse_irq_flag   : std_logic;
	end record t_pre_sync_interrupt_flag_register;

	type t_sync_config_register is record
		master_blank_time : std_logic_vector(31 downto 0);
		blank_time        : std_logic_vector(31 downto 0);
		pre_blank_time    : std_logic_vector(31 downto 0);
		period            : std_logic_vector(31 downto 0);
		one_shot_time     : std_logic_vector(31 downto 0);
	end record t_sync_config_register;

	type t_sync_general_config_register is record
		signal_polarity  : std_logic;
		number_of_cycles : std_logic_vector(7 downto 0);
	end record t_sync_general_config_register;

	type t_sync_error_injection_register is record
		error_injection : std_logic_vector(31 downto 0);
	end record t_sync_error_injection_register;

	type t_sync_control_register is record
		int_ext_n        : std_logic;
		start            : std_logic;
		reset            : std_logic;
		one_shot         : std_logic;
		err_inj          : std_logic;
		out_enable       : std_logic;
		channel_1_enable : std_logic;
		channel_2_enable : std_logic;
		channel_3_enable : std_logic;
		channel_4_enable : std_logic;
		channel_5_enable : std_logic;
		channel_6_enable : std_logic;
		channel_7_enable : std_logic;
		channel_8_enable : std_logic;
	end record t_sync_control_register;

	type t_sync_irq_number_register is record
		sync_irq_number     : std_logic_vector(31 downto 0);
		pre_sync_irq_number : std_logic_vector(31 downto 0);
	end record t_sync_irq_number_register;

	-- Avalon mm types
	type t_sync_mm_write_registers is record
		sync_irq_enable_reg         : t_sync_interrupt_enable_register;
		sync_irq_flag_clear_reg     : t_sync_interrupt_flag_clear_register;
		pre_sync_irq_enable_reg     : t_pre_sync_interrupt_enable_register;
		pre_sync_irq_flag_clear_reg : t_pre_sync_interrupt_flag_clear_register;
		sync_config_reg             : t_sync_config_register;
		sync_general_config_reg     : t_sync_general_config_register;
		sync_error_injection_reg    : t_sync_error_injection_register;
		sync_control_reg            : t_sync_control_register;
	end record t_sync_mm_write_registers;

	type t_sync_mm_read_registers is record
		sync_status_reg       : t_sync_status_register;
		sync_irq_flag_reg     : t_sync_interrupt_flag_register;
		pre_sync_irq_flag_reg : t_pre_sync_interrupt_flag_register;
		sync_irq_number_reg   : t_sync_irq_number_register;
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
