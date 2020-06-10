--=============================================================================
--! @file sync_common_pkg.vhd
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
-- unit name: sync common package (sync_common_pkg)
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
--! Package declaration for sync common package
--============================================================================
package sync_common_pkg is

	-- Sync signal default standby (inactive) polarity
	constant c_SYNC_DEFAULT_STBY_POLARITY : std_logic := '0';

end package sync_common_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_common_pkg is
end package body sync_common_pkg;
--============================================================================
-- package body end
--============================================================================
