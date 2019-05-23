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

	constant c_CTR_ADDRESS_WIDTH : natural range 1 to 64 := 8;
	constant c_CTR_DATA_WIDTH    : natural range 1 to 64 := 32;

	constant c_DT_ADDRESS_WIDTH : natural range 1 to 64 := 10;
	constant c_DT_DATA_WIDTH    : natural range 1 to 64 := 64;

--=======================================
--! Component declaration for avs_stimuli
--=======================================
component avs_stimuli is
	generic (
		g_CTR_ADDRESS_WIDTH : natural range 1 to 64 := 8;
		g_CTR_DATA_WIDTH    : natural range 1 to 64 := 32;
		
		g_DT_ADDRESS_WIDTH : natural range 1 to 64 := 10;
		g_DT_DATA_WIDTH    : natural range 1 to 64 := 64
	);
	port (
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		-- Data port 64-bit
		avalon_mm_d_readdata_i    : in  std_logic_vector((g_DT_DATA_WIDTH - 1) downto 0);
		avalon_mm_d_waitrequest_i : in  std_logic;
		avalon_mm_d_address_o     : out std_logic_vector((g_DT_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_d_read_o        : out std_logic;
		-- Control port 32-bit
		avalon_mm_c_readdata_i    : in  std_logic_vector((g_CTR_DATA_WIDTH - 1) downto 0);
		avalon_mm_c_waitrequest_i : in  std_logic;
		avalon_mm_c_address_o     : out std_logic_vector((g_CTR_ADDRESS_WIDTH - 1) downto 0);
		avalon_mm_c_write_o       : out std_logic;
		avalon_mm_c_writedata_o   : out std_logic_vector((g_CTR_DATA_WIDTH - 1) downto 0);
		avalon_mm_c_read_o        : out std_logic
	);
end component avs_stimuli;

--========================================
--! Component declaration for dut topfile
--========================================
component pgen_component_ent is
	port (
		clock_i                               : in  std_logic                     := '0';
		reset_i                               : in  std_logic                     := '0';
		-- data port 64-bit
		avalon_mm_data_slave_address_i        : in  std_logic_vector(9 downto 0)  := (others => '0');
		avalon_mm_data_slave_read_i           : in  std_logic                     := '0';
		avalon_mm_data_slave_readdata_o       : out std_logic_vector(63 downto 0);
		avalon_mm_data_slave_waitrequest_o    : out std_logic;
		-- control port 32-bit
		avalon_mm_control_slave_address_i     : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_mm_control_slave_write_i       : in  std_logic                     := '0';
		avalon_mm_control_slave_writedata_i   : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_mm_control_slave_read_i        : in  std_logic                     := '0';
		avalon_mm_control_slave_readdata_o    : out std_logic_vector(31 downto 0);
		avalon_mm_control_slave_waitrequest_o : out std_logic
	);
end component pgen_component_ent;

end package tb_pkg;

--============================================================================
--! package body declaration
--============================================================================
package body tb_pkg is
end package body tb_pkg;
--============================================================================
-- package body end
--============================================================================
