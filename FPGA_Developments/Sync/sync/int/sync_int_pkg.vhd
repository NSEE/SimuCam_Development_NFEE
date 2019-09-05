--=============================================================================
--! @file sync_int_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
use work.sync_common_pkg.all;
-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync interrupt package (sync_int_pkg)
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
package sync_int_pkg is

	constant c_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := '1';
	
	type t_sync_int_enable is record
		error_int_enable			: std_logic;
		blank_pulse_int_enable		: std_logic;
	end record t_sync_int_enable;

	type t_sync_int_flag_clear is record
		error_int_flag_clear		: std_logic;
		blank_pulse_int_flag_clear	: std_logic;
	end record t_sync_int_flag_clear;

	type t_sync_int_flag is record
		error_int_flag				: std_logic;
		blank_pulse_int_flag		: std_logic;
	end record t_sync_int_flag;

	type t_sync_int_watch is record
		error_code_watch			: std_logic_vector(7 downto 0);
		sync_wave_watch				: std_logic;
		sync_pol_watch				: std_logic;
	end record t_sync_int_watch;

--====================================
--! Component declaration for sync_int
--====================================
component sync_int is
	generic (
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;		
		g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
	);
	port (
		clk_i           	: in std_logic;
		reset_n_i      		: in std_logic;
		int_enable_i 		: in t_sync_int_enable;
		int_flag_clear_i	: in t_sync_int_flag_clear;
		int_watch_i			: in t_sync_int_watch; 
		
		int_flag_o 			: out t_sync_int_flag;
		irq_o				: out std_logic
	);
end component sync_int;

end package sync_int_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_int_pkg is
end package body sync_int_pkg;
--============================================================================
-- package body end
--============================================================================
