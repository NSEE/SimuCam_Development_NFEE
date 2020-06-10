--=============================================================================
--! @file sync_irq_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
use work.sync_common_pkg.all;
use work.sync_gen_pkg.all;
-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync interrupt package (sync_irq_pkg)
--
--! @brief 
--
--! @author Cassio Berni (ccberni@hotmail.com)
--
--! @date 15\11\2018
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
--! Author: 
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 15\11\2018 CB Module creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Package declaration for sync int package
--============================================================================
package sync_irq_pkg is

	constant c_SYNC_DEFAULT_IRQ_POLARITY : std_logic := '1';

	type t_sync_irq_enable is record
		error_irq_enable        : std_logic;
		blank_pulse_irq_enable  : std_logic;
		master_pulse_irq_enable : std_logic;
		normal_pulse_irq_enable : std_logic;
		last_pulse_irq_enable   : std_logic;
	end record t_sync_irq_enable;

	type t_sync_irq_flag_clear is record
		error_irq_flag_clear        : std_logic;
		blank_pulse_irq_flag_clear  : std_logic;
		master_pulse_irq_flag_clear : std_logic;
		normal_pulse_irq_flag_clear : std_logic;
		last_pulse_irq_flag_clear   : std_logic;
	end record t_sync_irq_flag_clear;

	type t_sync_irq_flag is record
		error_irq_flag        : std_logic;
		blank_pulse_irq_flag  : std_logic;
		master_pulse_irq_flag : std_logic;
		normal_pulse_irq_flag : std_logic;
		last_pulse_irq_flag   : std_logic;
	end record t_sync_irq_flag;

	type t_sync_irq_watch is record
		error_code_watch      : std_logic_vector(7 downto 0);
		sync_wave_watch       : std_logic;
		sync_pol_watch        : std_logic;
		sync_cycle_number     : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
		sync_number_of_cycles : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_sync_irq_watch;

	type t_pre_sync_irq_enable is record
		pre_blank_pulse_irq_enable  : std_logic;
		pre_master_pulse_irq_enable : std_logic;
		pre_normal_pulse_irq_enable : std_logic;
		pre_last_pulse_irq_enable   : std_logic;
	end record t_pre_sync_irq_enable;

	type t_pre_sync_irq_flag_clear is record
		pre_blank_pulse_irq_flag_clear  : std_logic;
		pre_master_pulse_irq_flag_clear : std_logic;
		pre_normal_pulse_irq_flag_clear : std_logic;
		pre_last_pulse_irq_flag_clear   : std_logic;
	end record t_pre_sync_irq_flag_clear;

	type t_pre_sync_irq_flag is record
		pre_blank_pulse_irq_flag  : std_logic;
		pre_master_pulse_irq_flag : std_logic;
		pre_normal_pulse_irq_flag : std_logic;
		pre_last_pulse_irq_flag   : std_logic;
	end record t_pre_sync_irq_flag;

	type t_pre_sync_irq_watch is record
		pre_sync_wave_watch       : std_logic;
		pre_sync_pol_watch        : std_logic;
		pre_sync_cycle_number     : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
		pre_sync_number_of_cycles : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_pre_sync_irq_watch;

	--====================================
	--! Component declaration for sync_irq
	--====================================
	component sync_irq is
		generic(
			g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;
			g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
		);
		port(
			clk_i            : in  std_logic;
			reset_n_i        : in  std_logic;
			irq_enable_i     : in  t_sync_irq_enable;
			irq_flag_clear_i : in  t_sync_irq_flag_clear;
			irq_watch_i      : in  t_sync_irq_watch;
			irq_flag_o       : out t_sync_irq_flag;
			irq_o            : out std_logic
		);
	end component sync_irq;

	--========================================
	--! Component declaration for pre_sync_irq
	--========================================
	component pre_sync_irq is
		generic(
			g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;
			g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
		);
		port(
			clk_i            : in  std_logic;
			reset_n_i        : in  std_logic;
			irq_enable_i     : in  t_pre_sync_irq_enable;
			irq_flag_clear_i : in  t_pre_sync_irq_flag_clear;
			irq_watch_i      : in  t_pre_sync_irq_watch;
			irq_flag_o       : out t_pre_sync_irq_flag;
			irq_o            : out std_logic
		);
	end component pre_sync_irq;

end package sync_irq_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_irq_pkg is
end package body sync_irq_pkg;
--============================================================================
-- package body end
--============================================================================
