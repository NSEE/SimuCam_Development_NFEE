library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- lvds signals (comm)
	signal s_spw_codec_comm_di : std_logic;
	signal s_spw_codec_comm_do : std_logic;
	signal s_spw_codec_comm_si : std_logic;
	signal s_spw_codec_comm_so : std_logic;

	-- lvds signals (dummy)
	signal s_spw_codec_dummy_di : std_logic;
	signal s_spw_codec_dummy_do : std_logic;
	signal s_spw_codec_dummy_si : std_logic;
	signal s_spw_codec_dummy_so : std_logic;

	-- spacewire clock signal
	signal s_spw_clock : std_logic;

	--dummy
	signal s_dummy_spw_rxvalid : std_logic;
	signal s_dummy_spw_rxhalff : std_logic;
	signal s_dummy_spw_rxflag  : std_logic;
	signal s_dummy_spw_rxdata  : std_logic_vector(7 downto 0);
	signal s_dummy_spw_rxread  : std_logic;

	signal s_spwcfg_autostart : std_logic;
	signal s_spwcfg_linkstart : std_logic;
	signal s_spwcfg_linkdis   : std_logic;
	signal s_spwcfg_txdivcnt  : std_logic_vector(7 downto 0);

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	spwc_spacewire_channel_top_inst : entity work.spwc_spacewire_channel_top
		port map(
			reset_i                       => rst,
			clk_100_i                     => clk100,
			clk_200_i                     => clk200,
			spw_lvds_p_data_in_i          => s_spw_codec_comm_di,
			spw_lvds_n_data_in_i          => '0',
			spw_lvds_p_strobe_in_i        => s_spw_codec_comm_si,
			spw_lvds_n_strobe_in_i        => '0',
			spw_lvds_p_data_out_o         => s_spw_codec_comm_do,
			spw_lvds_n_data_out_o         => open,
			spw_lvds_p_strobe_out_o       => s_spw_codec_comm_so,
			spw_lvds_n_strobe_out_o       => open,
			spw_rx_enable_i               => '1',
			spw_tx_enable_i               => '1',
			spw_red_status_led_o          => open,
			spw_green_status_led_o        => open,
			spw_link_command_autostart_i  => s_spwcfg_autostart,
			spw_link_command_linkstart_i  => s_spwcfg_linkstart,
			spw_link_command_linkdis_i    => s_spwcfg_linkdis,
			spw_link_command_txdivcnt_i   => s_spwcfg_txdivcnt,
			spw_timecode_tx_tick_in_i     => '0',
			spw_timecode_tx_ctrl_in_i     => (others => '0'),
			spw_timecode_tx_time_in_i     => (others => '0'),
			spw_data_rx_command_rxread_i  => '0',
			spw_data_tx_command_txwrite_i => '0',
			spw_data_tx_command_txflag_i  => '0',
			spw_data_tx_command_txdata_i  => (others => '0'),
			spw_link_status_started_o     => open,
			spw_link_status_connecting_o  => open,
			spw_link_status_running_o     => open,
			spw_link_error_errdisc_o      => open,
			spw_link_error_errpar_o       => open,
			spw_link_error_erresc_o       => open,
			spw_link_error_errcred_o      => open,
			spw_timecode_rx_tick_out_o    => open,
			spw_timecode_rx_ctrl_out_o    => open,
			spw_timecode_rx_time_out_o    => open,
			spw_data_rx_status_rxvalid_o  => open,
			spw_data_rx_status_rxhalff_o  => open,
			spw_data_rx_status_rxflag_o   => open,
			spw_data_rx_status_rxdata_o   => open,
			spw_data_tx_status_txrdy_o    => open,
			spw_data_tx_status_txhalff_o  => open
		);

	--	s_spw_codec_comm_di <= s_spw_codec_comm_do;
	--	s_spw_codec_comm_si <= s_spw_codec_comm_so;

	p_spw_cfg : process(clk100, rst) is
	begin
		if rst = '1' then
			s_spwcfg_autostart <= '0';
			s_spwcfg_linkstart <= '0';
			s_spwcfg_linkdis   <= '0';
			s_spwcfg_txdivcnt  <= x"01";
		elsif rising_edge(clk100) then
			s_spwcfg_autostart <= '1';
			s_spwcfg_linkstart <= '0';
			s_spwcfg_linkdis   <= '0';
			s_spwcfg_txdivcnt  <= x"01";
		end if;
	end process p_spw_cfg;

	s_spw_clock <= (s_spw_codec_comm_so) xor (s_spw_codec_comm_do);

	-- spw connection
	-- SpaceWire Light Codec Component 
	spw_stimuli_spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => 200000000.0,
			txclkfreq       => 0.0,
			rximpl          => impl_generic,
			rxchunk         => 1,
			tximpl          => impl_generic,
			rxfifosize_bits => 11,
			txfifosize_bits => 11
		)
		port map(
			clk        => clk200,
			rxclk      => clk200,
			txclk      => clk200,
			rst        => rst,
			autostart  => '1',
			linkstart  => '1',
			linkdis    => '0',
			txdivcnt   => x"01",
			tick_in    => '0',
			ctrl_in    => "00",
			time_in    => "000000",
			txwrite    => '0',
			txflag     => '0',
			txdata     => x"00",
			txrdy      => open,
			txhalff    => open,
			tick_out   => open,
			ctrl_out   => open,
			time_out   => open,
			rxvalid    => s_dummy_spw_rxvalid,
			rxhalff    => s_dummy_spw_rxhalff,
			rxflag     => s_dummy_spw_rxflag,
			rxdata     => s_dummy_spw_rxdata,
			rxread     => s_dummy_spw_rxread,
			started    => open,
			connecting => open,
			running    => open,
			errdisc    => open,
			errpar     => open,
			erresc     => open,
			errcred    => open,
			spw_di     => s_spw_codec_dummy_di,
			spw_si     => s_spw_codec_dummy_si,
			spw_do     => s_spw_codec_dummy_do,
			spw_so     => s_spw_codec_dummy_so
		);

	s_spw_codec_comm_di  <= s_spw_codec_dummy_do;
	s_spw_codec_comm_si  <= s_spw_codec_dummy_so;
	s_spw_codec_dummy_di <= s_spw_codec_comm_do;
	s_spw_codec_dummy_si <= s_spw_codec_comm_so;

end architecture RTL;
