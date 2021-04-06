library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- sync signal
	signal s_sync : std_logic;

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	scom_synchronization_comm_top_inst : entity work.scom_synchronization_comm_top
		generic map(
			g_SCOM_TESTBENCH_MODE => '1'
		)
		port map(
			reset_sink_reset_i                  => rst,
			clock_sink_clk_i                    => clk200,
			channel_sync_i                      => s_sync,
			avs_config_address_i                => (others => '0'),
			avs_config_byteenable_i             => "1111",
			avs_config_write_i                  => '0',
			avs_config_writedata_i              => (others => '0'),
			avs_config_read_i                   => '0',
			avs_config_readdata_o               => open,
			avs_config_waitrequest_o            => open,
			spw_link_status_started_i           => '0',
			spw_link_status_connecting_i        => '0',
			spw_link_status_running_i           => '1',
			spw_link_error_errdisc_i            => '0',
			spw_link_error_errpar_i             => '0',
			spw_link_error_erresc_i             => '0',
			spw_link_error_errcred_i            => '0',
			spw_timecode_rx_tick_out_i          => '0',
			spw_timecode_rx_ctrl_out_i          => (others => '0'),
			spw_timecode_rx_time_out_i          => (others => '0'),
			spw_data_rx_status_rxvalid_i        => '0',
			spw_data_rx_status_rxhalff_i        => '0',
			spw_data_rx_status_rxflag_i         => '0',
			spw_data_rx_status_rxdata_i         => (others => '0'),
			spw_data_tx_status_txrdy_i          => '1',
			spw_data_tx_status_txhalff_i        => '0',
			spw_link_command_autostart_o        => open,
			spw_link_command_linkstart_o        => open,
			spw_link_command_linkdis_o          => open,
			spw_link_command_txdivcnt_o         => open,
			spw_timecode_tx_tick_in_o           => open,
			spw_timecode_tx_ctrl_in_o           => open,
			spw_timecode_tx_time_in_o           => open,
			spw_data_rx_command_rxread_o        => open,
			spw_data_tx_command_txwrite_o       => open,
			spw_data_tx_command_txflag_o        => open,
			spw_data_tx_command_txdata_o        => open,
			rmm_rmap_target_wr_waitrequest_i    => '0',
			rmm_rmap_target_readdata_i          => (others => '0'),
			rmm_rmap_target_rd_waitrequest_i    => '0',
			rmm_rmap_target_wr_address_o        => open,
			rmm_rmap_target_write_o             => open,
			rmm_rmap_target_writedata_o         => open,
			rmm_rmap_target_rd_address_o        => open,
			rmm_rmap_target_read_o              => open,
			rmm_fee_hk_wr_waitrequest_i         => '0',
			rmm_fee_hk_readdata_i               => (others => '0'),
			rmm_fee_hk_rd_waitrequest_i         => '0',
			rmm_fee_hk_wr_address_o             => open,
			rmm_fee_hk_write_o                  => open,
			rmm_fee_hk_writedata_o              => open,
			rmm_fee_hk_rd_address_o             => open,
			rmm_fee_hk_read_o                   => open,
			channel_hk_timecode_control_o       => open,
			channel_hk_timecode_time_o          => open,
			channel_hk_rmap_target_status_o     => open,
			channel_hk_rmap_target_indicate_o   => open,
			channel_hk_spw_link_escape_err_o    => open,
			channel_hk_spw_link_credit_err_o    => open,
			channel_hk_spw_link_parity_err_o    => open,
			channel_hk_spw_link_disconnect_o    => open,
			channel_hk_spw_link_running_o       => open,
			channel_hk_frame_counter_o          => open,
			channel_hk_frame_number_o           => open,
			channel_hk_err_win_wrong_x_coord_o  => open,
			channel_hk_err_win_wrong_y_coord_o  => open,
			channel_hk_err_e_side_buffer_full_o => open,
			channel_hk_err_f_side_buffer_full_o => open,
			channel_hk_err_invalid_ccd_mode_o   => open,
			channel_win_mem_addr_offset_o       => open
		);

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
--				elsif ((v_sync_high = '1') and (v_sync_div_cnt = 45000)) then
				    elsif ((v_sync_high = '1') and (v_sync_div_cnt = 10000)) then
					s_sync         <= '0';
					v_sync_high    := '0';
					--					v_sync_one_shot := '1'; -- comment this line to remove one-shot
					v_sync_div_cnt := 0;
				end if;
			end if;
			v_sync_div_cnt := v_sync_div_cnt + 1;
		end if;
	end process p_sync_generator;

end architecture RTL;
