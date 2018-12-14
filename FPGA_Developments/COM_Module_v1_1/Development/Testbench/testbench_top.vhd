library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';

	-- dut signals

	-- lvds signals
	signal s_di : std_logic;
	signal s_do : std_logic;
	signal s_si : std_logic;
	signal s_so : std_logic;

	-- irq signal
	signal s_irq : std_logic;

	-- config_avalon_stimuli signals
	signal s_config_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_config_avalon_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_config_avalon_stimuli_mm_address     : std_logic_vector(7 downto 0); --          .address
	signal s_config_avalon_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_config_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_config_avalon_stimuli_mm_read        : std_logic; --                                     --          .read

	-- avalon_buffer_R_stimuli signals
	signal s_avalon_buffer_R_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_buffer_R_stimuli_mm_address     : std_logic_vector(9 downto 0); --          .address
	signal s_avalon_buffer_R_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_buffer_R_stimuli_mm_writedata   : std_logic_vector(63 downto 0); -- --          .writedata

	-- avalon_buffer_L_stimuli signals
	signal s_avalon_buffer_L_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_buffer_L_stimuli_mm_address     : std_logic_vector(9 downto 0); --          .address
	signal s_avalon_buffer_L_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_buffer_L_stimuli_mm_writedata   : std_logic_vector(63 downto 0); -- --          .writedata

begin

	clk <= not clk after 2.5 ns;        -- 200 MHz
	rst <= '0' after 100 ns;

	config_avalon_stimuli_inst : entity work.config_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 8,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_config_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_config_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_config_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_config_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_config_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_config_avalon_stimuli_mm_read
		);

	avalon_buffer_R_stimuli_inst : entity work.avalon_buffer_R_stimuli
		generic map(
			g_ADDRESS_WIDTH => 10,
			g_DATA_WIDTH    => 64
		)
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_buffer_R_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_buffer_R_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_buffer_R_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_buffer_R_stimuli_mm_writedata
		);

	avalon_buffer_L_stimuli_inst : entity work.avalon_buffer_L_stimuli
		generic map(
			g_ADDRESS_WIDTH => 10,
			g_DATA_WIDTH    => 64
		)
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_buffer_L_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_buffer_L_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_buffer_L_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_buffer_L_stimuli_mm_writedata
		);

	comm_v1_01_top_inst : entity work.comm_v1_01_top
		port map(
			reset_sink_reset                   => rst,
			data_in                            => s_di,
			data_out                           => s_do,
			strobe_in                          => s_si,
			strobe_out                         => s_so,
			interrupt_sender_irq               => s_irq,
			clock_sink_200_clk                 => clk,
			avalon_slave_windowing_address     => s_config_avalon_stimuli_mm_address,
			avalon_slave_windowing_write       => s_config_avalon_stimuli_mm_write,
			avalon_slave_windowing_read        => s_config_avalon_stimuli_mm_read,
			avalon_slave_windowing_readdata    => s_config_avalon_stimuli_mm_readdata,
			avalon_slave_windowing_writedata   => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_windowing_waitrequest => s_config_avalon_stimuli_mm_waitrequest,
			avalon_slave_L_buffer_address      => s_avalon_buffer_L_stimuli_mm_address,
			avalon_slave_L_buffer_waitrequest  => s_avalon_buffer_L_stimuli_mm_waitrequest,
			avalon_slave_L_buffer_write        => s_avalon_buffer_L_stimuli_mm_write,
			avalon_slave_L_buffer_writedata    => s_avalon_buffer_L_stimuli_mm_writedata,
			avalon_slave_R_buffer_address      => s_avalon_buffer_R_stimuli_mm_address,
			avalon_slave_R_buffer_write        => s_avalon_buffer_R_stimuli_mm_write,
			avalon_slave_R_buffer_writedata    => s_avalon_buffer_R_stimuli_mm_writedata,
			avalon_slave_R_buffer_waitrequest  => s_avalon_buffer_R_stimuli_mm_waitrequest
		);

end architecture RTL;
