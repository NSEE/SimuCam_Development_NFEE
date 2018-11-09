--=============================================================================
--! @file sync_gen_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
--use work.xxx.all;
-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync generator package (sync_gen_pkg)
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
--! Package declaration for sync generator package
--============================================================================
package sync_syncgen_pkg is

	constant c_SYNC_COUNTER_MAX_WIDTH		: integer          := 64;
	constant c_SYNC_COUNTER_WIDTH			: integer          := 32;
	constant c_SYNC_STATE_WIDTH				: integer          :=  8;
	constant c_SYNC_CYCLE_NUMBER_WIDTH		: integer          :=  8;
	constant c_SYNC_DEFAULT_STBY_POLARITY	: std_logic_vector := '1';

	type t_sync_syncgen_status is record
		state			: std_logic_vector((c_SYNC_STATE_WIDTH - 1) downto 0);
		cycle_number	: std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_sync_syncgen_status;

	type t_sync_syncgen_isr is record
		blank_pulse_isr_enable	: std_logic;
		blank_pulse_isr_flag	: std_logic;
	end record t_sync_syncgen_isr;

	type t_sync_syncgen_config is record
		master_blank_time	: std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		blank_time			: std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		period				: std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		one_shot_time		: std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		signal_polarity		: std_logic;
		number_of_cycles	: std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_sync_syncgen_config;

	type t_sync_syncgen_error_injection is record
		error_injection	: std_logic_vector(31 downto 0);
	end record t_sync_syncgen_error_injection;

	type t_sync_syncgen_control is record
		start		: std_logic;
		reset		: std_logic;
		one_shot	: std_logic;
		err_inj		: std_logic;
	end record t_sync_syncgen_control;

end package sync_syncgen_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_syncgen_pkg is
end package body sync_syncgen_pkg;
--============================================================================
-- package body end
--============================================================================
