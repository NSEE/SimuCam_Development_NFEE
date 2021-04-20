library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk50 : std_logic := '0';
	signal rst   : std_logic := '1';

	-- dut signals

begin

	clk50 <= not clk50 after 10 ns;     -- 50 MHz
	rst   <= '0' after 100 ns;

	rst_controller_top_inst : entity work.rst_controller_top
		port map(
			avalon_slave_rst_controller_address     => (others => '0'),
			avalon_slave_rst_controller_write       => '0',
			avalon_slave_rst_controller_read        => '0',
			avalon_slave_rst_controller_writedata   => (others => '0'),
			avalon_slave_rst_controller_readdata    => open,
			avalon_slave_rst_controller_waitrequest => open,
			clock_sink_clk                          => clk50,
			reset_sink_reset                        => '0',
			reset_input_signal                      => rst,
			simucam_reset_signal                    => open,
			reset_source_rs232_reset                => open
		);

end architecture RTL;
