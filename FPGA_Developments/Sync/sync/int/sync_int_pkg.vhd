--=============================================================================
--! @file sync_outen_pkg.vhd
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
-- unit name: sync output enable package (sync_outen_pkg)
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
package sync_outen_pkg is

	type t_sync_outen_control is record
		sync_out_enable  : std_logic;
		channel_h_enable : std_logic;
		channel_g_enable : std_logic;
		channel_f_enable : std_logic;
		channel_e_enable : std_logic;
		channel_d_enable : std_logic;
		channel_c_enable : std_logic;
		channel_b_enable : std_logic;
		channel_a_enable : std_logic;
	end record t_sync_outen_control;

	type t_sync_outen_output is record
		sync_out_signal  : std_logic_vector(0 downto 0);
		channel_h_signal : std_logic_vector(0 downto 0);
		channel_g_signal : std_logic_vector(0 downto 0);
		channel_f_signal : std_logic_vector(0 downto 0);
		channel_e_signal : std_logic_vector(0 downto 0);
		channel_d_signal : std_logic_vector(0 downto 0);
		channel_c_signal : std_logic_vector(0 downto 0);
		channel_b_signal : std_logic_vector(0 downto 0);
		channel_a_signal : std_logic_vector(0 downto 0);
	end record t_sync_outen_output;

end package sync_outen_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_outen_pkg is
end package body sync_outen_pkg;
--============================================================================
-- package body end
--============================================================================
