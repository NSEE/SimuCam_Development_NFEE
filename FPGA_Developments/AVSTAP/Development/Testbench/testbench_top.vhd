library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- avalon_32_stimuli signals
	signal s_avalon_32_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_avalon_32_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_avalon_32_stimuli_mm_address     : std_logic_vector(11 downto 0); --          .address
	signal s_avalon_32_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_32_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_avalon_32_stimuli_mm_read        : std_logic; --                                     --          .read

	-- avalon_64_stimuli signals
	signal s_avalon_64_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_64_stimuli_mm_address     : std_logic_vector(10 downto 0); --          .address
	signal s_avalon_64_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_64_stimuli_mm_writedata   : std_logic_vector(63 downto 0); -- --          .writedata

begin

	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

		avalon_32_stimuli_inst : entity work.avalon_32_stimuli
			generic map(
				g_ADDRESS_WIDTH => 12,
				g_DATA_WIDTH    => 32
			)
			port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_avalon_32_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_avalon_32_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_32_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_32_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_32_stimuli_mm_writedata,
			avalon_mm_read_o        => s_avalon_32_stimuli_mm_read
			);
		

	avalon_64_stimuli_inst : entity work.avalon_64_stimuli
		generic map(
			g_ADDRESS_WIDTH => 11,
			g_DATA_WIDTH    => 64
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_64_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_64_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_64_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_64_stimuli_mm_writedata
		);

	avstap64_top_inst : entity work.avstap64_top
		port map(
			reset_sink_reset            => rst,
			clock_sink_100_clk          => clk100,
			avalon_slave_32_address     => s_avalon_32_stimuli_mm_address,
			avalon_slave_32_write       => s_avalon_32_stimuli_mm_write,
			avalon_slave_32_read        => s_avalon_32_stimuli_mm_read,
			avalon_slave_32_readdata    => s_avalon_32_stimuli_mm_readdata,
			avalon_slave_32_writedata   => s_avalon_32_stimuli_mm_writedata,
			avalon_slave_32_waitrequest => s_avalon_32_stimuli_mm_waitrequest,
			avalon_slave_64_address     => s_avalon_64_stimuli_mm_address,
			avalon_slave_64_write       => s_avalon_64_stimuli_mm_write,
			avalon_slave_64_writedata   => s_avalon_64_stimuli_mm_writedata,
			avalon_slave_64_waitrequest => s_avalon_64_stimuli_mm_waitrequest
		);
	
end architecture RTL;
