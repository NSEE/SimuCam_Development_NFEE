library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mfil_config_avalon_mm_registers_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100Avs : std_logic := '0';
	signal rst       : std_logic := '1';

	-- dut signals

begin

	clk100Avs <= not clk100Avs after 5 ns; -- 100 MHz
	rst       <= '0' after 100 ns;

	mfil_memory_filler_top_inst : entity work.mfil_memory_filler_top
		generic map(
			g_MFIL_TESTBENCH_MODE => '1'
		)
		port map(
			clock_sink_clk_i                  => clk100Avs,
			reset_sink_reset_i                => rst,
			avalon_slave_config_address_i     => (others => '0'),
			avalon_slave_config_byteenable_i  => (others => '0'),
			avalon_slave_config_write_i       => '0',
			avalon_slave_config_writedata_i   => (others => '0'),
			avalon_slave_config_read_i        => '0',
			avalon_slave_config_readdata_o    => open,
			avalon_slave_config_waitrequest_o => open,
			avalon_master_data_waitrequest_i  => '1',
			avalon_master_data_address_o      => open,
			avalon_master_data_write_o        => open,
			avalon_master_data_writedata_o    => open
		);

end architecture RTL;
