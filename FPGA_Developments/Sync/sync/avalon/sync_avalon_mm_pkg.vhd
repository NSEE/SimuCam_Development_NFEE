--=============================================================================
--! @file sync_avalon_mm_pkg.vhd
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
-- unit name: sync avalon mm package (sync_avalon_mm_pkg)
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
--! Package declaration for sync avalon mm package
--============================================================================
package sync_avalon_mm_pkg is

	constant c_SYNC_AVALON_MM_ADRESS_SIZE : natural := 8;
	constant c_SYNC_AVALON_MM_DATA_SIZE   : natural := 32;
	constant c_SYNC_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_sync_avalon_mm_address is natural range 0 to ((2 ** c_SYNC_AVALON_MM_ADRESS_SIZE) - 1);

	type t_sync_avalon_mm_read_i is record
		address : std_logic_vector((c_SYNC_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_sync_avalon_mm_read_i;

	type t_sync_avalon_mm_read_o is record
		readdata    : std_logic_vector((c_SYNC_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_sync_avalon_mm_read_o;

	type t_sync_avalon_mm_write_i is record
		address   : std_logic_vector((c_SYNC_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_SYNC_AVALON_MM_DATA_SIZE - 1) downto 0);
	end record t_sync_avalon_mm_write_i;

	type t_sync_avalon_mm_write_o is record
		waitrequest : std_logic;
	end record t_sync_avalon_mm_write_o;

end package sync_avalon_mm_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_avalon_mm_pkg is
end package body sync_avalon_mm_pkg;
--============================================================================
-- package body end
--============================================================================
