--=============================================================================
--! @file sync_outen_pkg.vhd
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
		channel_1_enable : std_logic;
		channel_2_enable : std_logic;
		channel_3_enable : std_logic;
		channel_4_enable : std_logic;
		channel_5_enable : std_logic;
		channel_6_enable : std_logic;
		channel_7_enable : std_logic;
		channel_8_enable : std_logic;
	end record t_sync_outen_control;

	type t_sync_outen_output is record
		sync_out_signal  : std_logic;
		channel_1_signal : std_logic;
		channel_2_signal : std_logic;
		channel_3_signal : std_logic;
		channel_4_signal : std_logic;
		channel_5_signal : std_logic;
		channel_6_signal : std_logic;
		channel_7_signal : std_logic;
		channel_8_signal : std_logic;
	end record t_sync_outen_output;

	--=======================================
	--! Component declaration for sync_outen
	--=======================================
	component sync_outen is
		port(
			clk_i           : in  std_logic;
			reset_n_i       : in  std_logic;
			sync_signal_i   : in  std_logic;
			sync_control_i  : in  t_sync_outen_control;
			sync_pol_i      : in  std_logic;
			sync_channels_o : out t_sync_outen_output
		);
	end component sync_outen;

end package sync_outen_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_outen_pkg is
end package body sync_outen_pkg;
--============================================================================
-- package body end
--============================================================================
