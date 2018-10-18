--=============================================================================
--! @file sync_syncgen_pkg.vhd
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
-- unit name: SYNC Module Package (sync_syncgen_pkg)
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
package sync_syncgen_pkg is

	-- others
	constant c_SYNC_COUNTER_MAX_WIDTH  : integer          := 64;
	
	constant c_SYNC_COUNTER_WIDTH      : integer          := 32;
	constant c_SYNC_PULSE_NUMBER_WIDTH : integer          := 2;
	constant c_SYNC_POLARITY           : std_logic_vector := '1';

	-- general

	-- syncgen

	type t_sync_syncgen_control is record
		start : std_logic;
		stop  : std_logic;
		reset : std_logic;
	end record t_sync_syncgen_control;

	type t_sync_syncgen_flags is record
		running : std_logic;
		stopped : std_logic;
	end record t_sync_syncgen_flags;

	type t_sync_syncgen_error is record
		dummy : std_logic;
	end record t_sync_syncgen_error;

	type t_sync_syncgen_configs is record
		pulse_period : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		pulse_number : std_logic_vector((c_SYNC_PULSE_NUMBER_WIDTH - 1) downto 0);
		master_width : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		pulse_width  : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
	end record t_sync_syncgen_configs;

end package sync_syncgen_pkg;

--============================================================================
-- ! package body declaration
--============================================================================
package body sync_syncgen_pkg is

end package body sync_syncgen_pkg;
--============================================================================
-- package body end
--============================================================================