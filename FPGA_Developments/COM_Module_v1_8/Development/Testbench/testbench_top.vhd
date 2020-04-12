library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;
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

	-- irq signal
	signal s_irq_rmap    : std_logic;
	signal s_irq_buffers : std_logic;

	-- sync signal
	signal s_sync   : std_logic;
	signal s_sync_n : std_logic;

	-- config_avalon_stimuli signals
	signal s_config_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_config_avalon_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_config_avalon_stimuli_mm_address     : std_logic_vector(7 downto 0); --          .address
	signal s_config_avalon_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_config_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_config_avalon_stimuli_mm_read        : std_logic; --                                     --          .read

	-- avalon_buffer_R_stimuli signals
	signal s_avalon_buffer_R_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_buffer_R_stimuli_mm_address     : std_logic_vector(20 downto 0); --          .address
	signal s_avalon_buffer_R_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_buffer_R_stimuli_mm_writedata   : std_logic_vector(255 downto 0); -- --          .writedata

	-- avalon_buffer_L_stimuli signals
	signal s_avalon_buffer_L_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_buffer_L_stimuli_mm_address     : std_logic_vector(20 downto 0); --          .address
	signal s_avalon_buffer_L_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_buffer_L_stimuli_mm_writedata   : std_logic_vector(255 downto 0); -- --          .writedata

	--dummy
	signal s_dummy_spw_tx_flag    : t_rmap_target_spw_tx_flag;
	signal s_dummy_spw_tx_control : t_rmap_target_spw_tx_control;

	signal s_dummy_spw_rxvalid : std_logic;
	signal s_dummy_spw_rxhalff : std_logic;
	signal s_dummy_spw_rxflag  : std_logic;
	signal s_dummy_spw_rxdata  : std_logic_vector(7 downto 0);
	signal s_dummy_spw_rxread  : std_logic;

	signal s_delay_trigger  : std_logic;
	signal s_delay_timer    : std_logic_vector(7 downto 0);
	signal s_delay_busy     : std_logic;
	signal s_delay_finished : std_logic;

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	config_avalon_stimuli_inst : entity work.config_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 8,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk200,
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
			g_ADDRESS_WIDTH => 21,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                   => clk200,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_buffer_R_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_buffer_R_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_buffer_R_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_buffer_R_stimuli_mm_writedata
		);

	avalon_buffer_L_stimuli_inst : entity work.avalon_buffer_L_stimuli
		generic map(
			g_ADDRESS_WIDTH => 21,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                   => clk200,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_buffer_L_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_buffer_L_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_buffer_L_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_buffer_L_stimuli_mm_writedata
		);

	comm_v1_01_top_inst : entity work.comm_v1_80_top
		port map(
			reset_sink_reset                   => rst,
			data_in                            => s_spw_codec_comm_di,
			data_out                           => s_spw_codec_comm_do,
			strobe_in                          => s_spw_codec_comm_si,
			strobe_out                         => s_spw_codec_comm_so,
			sync_channel                       => s_sync,
			rmap_interrupt_sender_irq          => s_irq_rmap,
			buffers_interrupt_sender_irq       => s_irq_buffers,
			clock_sink_200_clk                 => clk200,
			clock_sink_100_clk                 => clk200,
			avalon_slave_windowing_address     => s_config_avalon_stimuli_mm_address,
			avalon_slave_windowing_write       => s_config_avalon_stimuli_mm_write,
			avalon_slave_windowing_read        => s_config_avalon_stimuli_mm_read,
			avalon_slave_windowing_readdata    => s_config_avalon_stimuli_mm_readdata,
			avalon_slave_windowing_writedata   => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_windowing_waitrequest => s_config_avalon_stimuli_mm_waitrequest,
			avalon_slave_windowing_byteenable  => "1111",
			avalon_slave_L_buffer_address      => s_avalon_buffer_L_stimuli_mm_address,
			avalon_slave_L_buffer_waitrequest  => s_avalon_buffer_L_stimuli_mm_waitrequest,
			avalon_slave_L_buffer_write        => s_avalon_buffer_L_stimuli_mm_write,
			avalon_slave_L_buffer_writedata    => s_avalon_buffer_L_stimuli_mm_writedata,
			avalon_slave_R_buffer_address      => s_avalon_buffer_R_stimuli_mm_address,
			avalon_slave_R_buffer_write        => s_avalon_buffer_R_stimuli_mm_write,
			avalon_slave_R_buffer_writedata    => s_avalon_buffer_R_stimuli_mm_writedata,
			avalon_slave_R_buffer_waitrequest  => s_avalon_buffer_R_stimuli_mm_waitrequest,
			measurements_channel               => open,
			fee_codec_rmap_wr_waitrequest_i    => '0',
			fee_codec_rmap_readdata_i          => (others => '0'),
			fee_codec_rmap_rd_waitrequest_i    => '0',
			fee_codec_rmap_wr_address_o        => open,
			fee_codec_rmap_write_o             => open,
			fee_codec_rmap_writedata_o         => open,
			fee_codec_rmap_rd_address_o        => open,
			fee_codec_rmap_read_o              => open,
			fee_hk_rmap_wr_waitrequest_i       => '0',
			fee_hk_rmap_readdata_i             => (others => '0'),
			fee_hk_rmap_rd_waitrequest_i       => '0',
			fee_hk_rmap_wr_address_o           => open,
			fee_hk_rmap_write_o                => open,
			fee_hk_rmap_writedata_o            => open,
			fee_hk_rmap_rd_address_o           => open,
			fee_hk_rmap_read_o                 => open,
			channel_hk_timecode_control_o      => open,
			channel_hk_timecode_time_o         => open,
			channel_hk_rmap_target_status_o    => open,
			channel_hk_rmap_target_indicate_o  => open,
			channel_hk_spw_link_escape_err_o   => open,
			channel_hk_spw_link_credit_err_o   => open,
			channel_hk_spw_link_parity_err_o   => open,
			channel_hk_spw_link_disconnect_o   => open,
			channel_hk_spw_link_running_o      => open,
			channel_hk_frame_counter_o         => open,
			channel_hk_frame_number_o          => open
		);
	s_sync_n <= not (s_sync);

	--	s_spw_codec_comm_di <= s_spw_codec_comm_do;
	--	s_spw_codec_comm_si <= s_spw_codec_comm_so;

	s_spw_clock <= (s_spw_codec_comm_so) xor (s_spw_codec_comm_do);

	p_sync_generator : process(clk200, rst) is
		variable v_sync_div_cnt  : natural   := 0;
		variable v_sync_high     : std_logic := '0';
		variable v_sync_one_shot : std_logic := '0';
	begin
		if (rst = '1') then
			s_sync          <= '0';
			v_sync_div_cnt  := 0;
			v_sync_high     := '0';
			v_sync_one_shot := '0';
		elsif rising_edge(clk100) then
			if (v_sync_one_shot = '0') then
				if ((v_sync_high = '0') and (v_sync_div_cnt = 10000)) then
					s_sync         <= '1';
					v_sync_high    := '1';
					v_sync_div_cnt := 0;
				elsif ((v_sync_high = '1') and (v_sync_div_cnt = 25000)) then
					s_sync         <= '0';
					v_sync_high    := '0';
					--					v_sync_one_shot := '1'; -- comment this line to remove one-shot
					v_sync_div_cnt := 0;
				end if;
			end if;
			v_sync_div_cnt := v_sync_div_cnt + 1;
		end if;
	end process p_sync_generator;

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
			txwrite    => s_dummy_spw_tx_control.write,
			txflag     => s_dummy_spw_tx_control.flag,
			txdata     => s_dummy_spw_tx_control.data,
			txrdy      => s_dummy_spw_tx_flag.ready,
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

	p_codec_dummy_read : process(clk200, rst) is
		variable v_time_counter : natural := 0;
		variable v_data_counter : natural := 0;
	begin
		if (rst = '1') then
			s_dummy_spw_rxread <= '0';
			s_delay_timer      <= std_logic_vector(to_unsigned(0, s_delay_timer'length));
			s_delay_trigger    <= '0';
		elsif rising_edge(clk100) then
			v_time_counter     := v_time_counter + 1;
			s_dummy_spw_rxread <= '0';
			if (s_dummy_spw_rxvalid = '1') then
				s_dummy_spw_rxread <= '1';

				-- check incoming data
				if (s_dummy_spw_rxdata = x"00") then
					-- assert false report "Wrong Spw Rx Data" severity error;
				end if;
			end if;

			if ((s_dummy_spw_rxvalid = '1') and (s_dummy_spw_rxread = '1')) then
				v_data_counter := v_data_counter + 1;
			end if;

			s_delay_timer <= std_logic_vector(to_unsigned(10, s_delay_timer'length));
			if (v_time_counter = 1000) then
				s_delay_trigger <= '1';
			else
				s_delay_trigger <= '0';
			end if;

		end if;
	end process p_codec_dummy_read;

	s_spw_codec_comm_di  <= s_spw_codec_dummy_do;
	s_spw_codec_comm_si  <= s_spw_codec_dummy_so;
	s_spw_codec_dummy_di <= s_spw_codec_comm_do;
	s_spw_codec_dummy_si <= s_spw_codec_comm_so;

	delay_block_ent_inst : entity work.delay_block_ent
		generic map(
			g_CLKDIV      => std_logic_vector(to_unsigned(1, 16)),
			g_TIMER_WIDTH => s_delay_timer'length
		)
		port map(
			clk_i            => clk200,
			rst_i            => rst,
			clr_i            => '0',
			delay_trigger_i  => s_delay_trigger,
			delay_timer_i    => s_delay_timer,
			delay_busy_o     => s_delay_busy,
			delay_finished_o => s_delay_finished
		);

end architecture RTL;
