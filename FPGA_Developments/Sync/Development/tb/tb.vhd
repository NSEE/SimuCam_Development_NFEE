library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb is
end entity tb;

architecture rtl of tb is
	-- clk and rst signals
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';

	-- dut signals
	-- dut inputs
	signal s_dut_sinc_signal_in : std_logic := '0';

	-- dut outputs
	signal s_dut_sync_signal_spwa : std_logic;
	signal s_dut_sync_signal_spwb : std_logic;
	signal s_dut_sync_signal_spwc : std_logic;
	signal s_dut_sync_signal_spwd : std_logic;
	signal s_dut_sync_signal_spwe : std_logic;
	signal s_dut_sync_signal_spwf : std_logic;
	signal s_dut_sync_signal_spwg : std_logic;
	signal s_dut_sync_signal_spwh : std_logic;

	signal s_dut_sync_signal_out : std_logic;

	signal s_dut_irq : std_logic;

	-- avs_stimuli signals
	signal s_avalon_mm_readdata    : std_logic_vector((c_DATA_WIDTH - 1) downto 0);
	signal s_avalon_mm_waitrequest : std_logic;
	signal s_avalon_mm_address     : std_logic_vector((c_ADDRESS_WIDTH - 1) downto 0);
	signal s_avalon_mm_write       : std_logic;
	signal s_avalon_mm_writedata   : std_logic_vector((c_DATA_WIDTH - 1) downto 0);
	signal s_avalon_mm_read        : std_logic;

begin
	-- Clock: 50 MHz
	clk                  <= not clk after 10 ns;
	-- Initial rst active level, release after that
	rst                  <= '0' after 100 ns;
	-- Sync in signal emulation
	s_dut_sinc_signal_in <= not s_dut_sinc_signal_in after 250 ns;

	-- avs_stimuli instantiation
	avs_stimuli_inst : entity work.avs_stimuli
		generic map(
			g_ADDRESS_WIDTH => c_ADDRESS_WIDTH,
			g_DATA_WIDTH    => c_DATA_WIDTH
		)
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_avalon_mm_readdata,
			avalon_mm_waitrequest_i => s_avalon_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_mm_address,
			avalon_mm_write_o       => s_avalon_mm_write,
			avalon_mm_writedata_o   => s_avalon_mm_writedata,
			avalon_mm_read_o        => s_avalon_mm_read
		);

	-- dut instantiation
	sync_ent_inst : entity work.sync_ent
		port map(
			reset_sink_reset_i               => rst,
			clock_sink_clk_i                 => clk,
			conduit_sync_signal_syncin_i     => s_dut_sinc_signal_in,
			conduit_sync_signal_syncin_en_i  => '1',
			conduit_sync_signal_syncout_en_i => '1',
			avalon_slave_address_i           => s_avalon_mm_address,
			avalon_slave_read_i              => s_avalon_mm_read,
			avalon_slave_write_i             => s_avalon_mm_write,
			avalon_slave_writedata_i         => s_avalon_mm_writedata,
--			avalon_slave_byteenable_i        => (others => '1'),
			avalon_slave_readdata_o          => s_avalon_mm_readdata,
			avalon_slave_waitrequest_o       => s_avalon_mm_waitrequest,
			conduit_sync_signal_spw1_o       => s_dut_sync_signal_spwa,
			conduit_sync_signal_spw2_o       => s_dut_sync_signal_spwb,
			conduit_sync_signal_spw3_o       => s_dut_sync_signal_spwc,
			conduit_sync_signal_spw4_o       => s_dut_sync_signal_spwd,
			conduit_sync_signal_spw5_o       => s_dut_sync_signal_spwe,
			conduit_sync_signal_spw6_o       => s_dut_sync_signal_spwf,
			conduit_sync_signal_spw7_o       => s_dut_sync_signal_spwg,
			conduit_sync_signal_spw8_o       => s_dut_sync_signal_spwh,
			conduit_sync_signal_syncout_o    => s_dut_sync_signal_out,
			sync_interrupt_sender_irq_o      => s_dut_irq,
			pre_sync_interrupt_sender_irq_o  => open
		);

end architecture rtl;
