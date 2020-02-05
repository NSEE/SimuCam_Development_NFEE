--=============================================================================
--! @file sync_gen_pkg.vhd
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
package sync_gen_pkg is

	constant c_SYNC_COUNTER_MAX_WIDTH  : integer := 64;
	constant c_SYNC_COUNTER_WIDTH      : integer := 32;
	constant c_SYNC_STATE_WIDTH        : integer := 8;
	constant c_SYNC_CYCLE_NUMBER_WIDTH : integer := 8;

	type t_sync_gen_status is record
		state             : std_logic_vector((c_SYNC_STATE_WIDTH - 1) downto 0);
		cycle_number      : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
		next_cycle_number : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_sync_gen_status;

	type t_sync_gen_config is record
		master_blank_time : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		blank_time        : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		last_blank_time   : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		pre_blank_time    : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		period            : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		last_period       : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		one_shot_time     : std_logic_vector((c_SYNC_COUNTER_WIDTH - 1) downto 0);
		signal_polarity   : std_logic;
		number_of_cycles  : std_logic_vector((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0);
	end record t_sync_gen_config;

	type t_sync_gen_error_injection is record
		error_injection : std_logic_vector(31 downto 0);
	end record t_sync_gen_error_injection;

	type t_sync_gen_control is record
		start    : std_logic;
		reset    : std_logic;
		one_shot : std_logic;
		err_inj  : std_logic;
	end record t_sync_gen_control;

	--=======================================
	--! Component declaration for sync_gen
	--=======================================
	component sync_gen is
		generic(
			g_SYNC_COUNTER_WIDTH         : natural range 0 to c_SYNC_COUNTER_MAX_WIDTH := c_SYNC_COUNTER_WIDTH;
			g_SYNC_CYCLE_NUMBER_WIDTH    : natural                                     := c_SYNC_CYCLE_NUMBER_WIDTH;
			g_SYNC_DEFAULT_STBY_POLARITY : std_logic                                   := c_SYNC_DEFAULT_STBY_POLARITY
		);
		port(
			clk_i          : in  std_logic;
			reset_n_i      : in  std_logic;
			control_i      : in  t_sync_gen_control;
			config_i       : in  t_sync_gen_config;
			err_inj_i      : in  t_sync_gen_error_injection;
			status_o       : out t_sync_gen_status;
			sync_gen_o     : out std_logic;
			pre_sync_gen_o : out std_logic
		);
	end component sync_gen;

end package sync_gen_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body sync_gen_pkg is
end package body sync_gen_pkg;
--============================================================================
-- package body end
--============================================================================
