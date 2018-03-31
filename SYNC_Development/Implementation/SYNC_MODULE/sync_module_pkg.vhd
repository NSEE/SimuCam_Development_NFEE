--=============================================================================
--! @file sync_module_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
--use work.XXX.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: SYNC Module Package (sync_module_pkg)
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
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Package declaration for SYNC Module Package
--============================================================================
package sync_module_pkg is

	-- others

	-- general

	-- syncgen

	type t_sync_module_syncgen_control is record
		start : std_logic;
		stop  : std_logic;
		reset : std_logic;
	end record t_sync_module_syncgen_control;

	type t_sync_module_syncgen_flags is record
		running : std_logic;
		stopped : std_logic;
	end record t_sync_module_syncgen_flags;

	type t_sync_module_syncgen_error is record
		dummy : std_logic;
	end record t_sync_module_syncgen_error;

	type t_sync_module_syncgen_configs is record
		wave_polarity : std_logic;
		pulse_period  : std_logic_vector(7 downto 0);
		pulse_number  : std_logic_vector(7 downto 0);
		master_width  : std_logic_vector(7 downto 0);
		pulse_width   : std_logic_vector(7 downto 0);
	end record t_sync_module_syncgen_configs;

end package sync_module_pkg;

--============================================================================
-- ! package body declaration
--============================================================================
package body sync_module_pkg is

end package body sync_module_pkg;
--============================================================================
-- package body end
--============================================================================