--=============================================================================
--! @file tb_pkg.vhd
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
-- unit name: testbench package (tb_pkg)
--
--! @brief 
--
--! @author Cassio Berni (ccberni@hotmail.com)
--
--! @date 22\11\2018
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
--! 22\11\2018 CB Module creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Package declaration for tb package
--============================================================================
package tb_pkg is

	constant c_ADDRESS_WIDTH : natural range 1 to 64 := 8;
	constant c_DATA_WIDTH    : natural range 1 to 64 := 32;

--=======================================
--! Component declaration for avs_stimuli
--=======================================
component avs_stimuli is
	generic (
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port (
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		avalon_mm_waitrequest_i : in  std_logic;

		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_write_o       : out std_logic;
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		avalon_mm_read_o        : out std_logic
	);
end component avs_stimuli;

--========================================
--! Component declaration for sync_topfile
--========================================
component sync_ent is
	port (
		reset_sink_reset            : in  std_logic                     := '0';
		clock_sink_clk              : in  std_logic                     := '0';
		conduit_sync_signal_syncin  : in  std_logic						:= '0';
		avalon_slave_address        : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_slave_read           : in  std_logic                     := '0';
		avalon_slave_write          : in  std_logic                     := '0';
		avalon_slave_writedata      : in  std_logic_vector(31 downto 0) := (others => '0');

		avalon_slave_readdata       : out std_logic_vector(31 downto 0);
		avalon_slave_waitrequest    : out std_logic;
		conduit_sync_signal_spwa    : out std_logic;
		conduit_sync_signal_spwb    : out std_logic;
		conduit_sync_signal_spwc    : out std_logic;
		conduit_sync_signal_spwd    : out std_logic;
		conduit_sync_signal_spwe    : out std_logic;
		conduit_sync_signal_spwf    : out std_logic;
		conduit_sync_signal_spwg    : out std_logic;
		conduit_sync_signal_spwh    : out std_logic;
		conduit_sync_signal_syncout : out std_logic;
		interrupt_sender_irq        : out std_logic
	);
end component sync_ent;

end package tb_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body tb_pkg is
end package body tb_pkg;
--============================================================================
-- package body end
--============================================================================
