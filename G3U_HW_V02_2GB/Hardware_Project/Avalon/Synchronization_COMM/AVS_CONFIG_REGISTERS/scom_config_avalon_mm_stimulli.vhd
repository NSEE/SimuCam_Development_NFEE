library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.scom_avs_config_pkg.all;
use work.scom_avs_config_registers_pkg.all;

entity scom_config_avalon_mm_stimulli is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avs_config_rd_regs_i        : in  t_scom_config_rd_regs;
		avs_config_wr_regs_o        : out t_scom_config_wr_regs;
		avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
		avs_config_rd_waitrequest_o : out std_logic;
		avs_config_wr_waitrequest_o : out std_logic
	);
end entity scom_config_avalon_mm_stimulli;

architecture RTL of scom_config_avalon_mm_stimulli is

begin

end architecture RTL;
