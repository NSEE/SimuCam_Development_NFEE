library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;
use work.spwpkg.all;

use work.cbuf_tb_avs_pkg.all;
use work.comm_avm_cbuf_pkg.all;
use work.comm_cbuf_pkg.all;

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

	-- comm_tb_avs_right_read_stimuli signals
	signal s_tb_avs_right_read_stimuli_mm_readdata    : std_logic_vector(255 downto 0);
	signal s_tb_avs_right_read_stimuli_mm_waitrequest : std_logic;
	signal s_tb_avs_right_read_stimuli_mm_address     : std_logic_vector(63 downto 0);
	signal s_tb_avs_right_read_stimuli_mm_read        : std_logic;

	-- comm_tb_avs_left_read_stimuli signals
	signal s_tb_avs_left_read_stimuli_mm_readdata    : std_logic_vector(255 downto 0);
	signal s_tb_avs_left_read_stimuli_mm_waitrequest : std_logic;
	signal s_tb_avs_left_read_stimuli_mm_address     : std_logic_vector(63 downto 0);
	signal s_tb_avs_left_read_stimuli_mm_read        : std_logic;

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

	-- spw controller stimuli signals
	signal s_spw_link_status_started     : std_logic; --                 -- -- spacewire_controller.spw_link_status_started_signal
	signal s_spw_link_status_connecting  : std_logic; --                 -- --                     .spw_link_status_connecting_signal
	signal s_spw_link_status_running     : std_logic; --                 -- --                     .spw_link_status_running_signal
	signal s_spw_link_error_errdisc      : std_logic; --                 -- --                     .spw_link_error_errdisc_signal
	signal s_spw_link_error_errpar       : std_logic; --                 -- --                     .spw_link_error_errpar_signal
	signal s_spw_link_error_erresc       : std_logic; --                 -- --                     .spw_link_error_erresc_signal
	signal s_spw_link_error_errcred      : std_logic; --                 -- --                     .spw_link_error_errcred_signal
	signal s_spw_timecode_rx_tick_out    : std_logic; --                 -- --                     .spw_timecode_rx_tick_out_signal
	signal s_spw_timecode_rx_ctrl_out    : std_logic_vector(1 downto 0); -- --                     .spw_timecode_rx_ctrl_out_signal
	signal s_spw_timecode_rx_time_out    : std_logic_vector(5 downto 0); -- --                     .spw_timecode_rx_time_out_signal
	signal s_spw_data_rx_status_rxvalid  : std_logic; --                 -- --                     .spw_data_rx_status_rxvalid_signal
	signal s_spw_data_rx_status_rxhalff  : std_logic; --                 -- --                     .spw_data_rx_status_rxhalff_signal
	signal s_spw_data_rx_status_rxflag   : std_logic; --                 -- --                     .spw_data_rx_status_rxflag_signal
	signal s_spw_data_rx_status_rxdata   : std_logic_vector(7 downto 0); -- --                     .spw_data_rx_status_rxdata_signal
	signal s_spw_data_tx_status_txrdy    : std_logic; --                 -- --                     .spw_data_tx_status_txrdy_signal
	signal s_spw_data_tx_status_txhalff  : std_logic; --                 -- --                     .spw_data_tx_status_txhalff_signal
	signal s_spw_link_command_autostart  : std_logic; --                 -- --                     .spw_link_command_autostart_signal
	signal s_spw_link_command_linkstart  : std_logic; --                 -- --                     .spw_link_command_linkstart_signal
	signal s_spw_link_command_linkdis    : std_logic; --                 -- --                     .spw_link_command_linkdis_signal
	signal s_spw_link_command_txdivcnt   : std_logic_vector(7 downto 0); -- --                     .spw_link_command_txdivcnt_signal
	signal s_spw_timecode_tx_tick_in     : std_logic; --                 -- --                     .spw_timecode_tx_tick_in_signal
	signal s_spw_timecode_tx_ctrl_in     : std_logic_vector(1 downto 0); -- --                     .spw_timecode_tx_ctrl_in_signal
	signal s_spw_timecode_tx_time_in     : std_logic_vector(5 downto 0); -- --                     .spw_timecode_tx_time_in_signal
	signal s_spw_data_rx_command_rxread  : std_logic; --                 -- --                     .spw_data_rx_command_rxread_signal
	signal s_spw_data_tx_command_txwrite : std_logic; --                 -- --                     .spw_data_tx_command_txwrite_signal
	signal s_spw_data_tx_command_txflag  : std_logic; --                 -- --                     .spw_data_tx_command_txflag_signal
	signal s_spw_data_tx_command_txdata  : std_logic_vector(7 downto 0); -- --                     .spw_data_tx_command_txdata_signal

	-- cbuf signals
	signal s_avm_left_cbuffer_readdata        : std_logic_vector(255 downto 0); -- --  avalon_mm_left_cbuffer_master.readdata
	signal s_avm_left_cbuffer_waitrequest     : std_logic; --                      --                               .waitrequest
	signal s_avm_left_cbuffer_address         : std_logic_vector(63 downto 0); --  --                               .address
	signal s_avm_left_cbuffer_write           : std_logic; --                      --                               .write
	signal s_avm_left_cbuffer_writedata       : std_logic_vector(255 downto 0); -- --                               .writedata
	signal s_avm_left_cbuffer_read            : std_logic; --                      --                               .read
	signal s_avm_right_cbuffer_readdata       : std_logic_vector(255 downto 0); -- -- avalon_mm_right_cbuffer_master.readdata
	signal s_avm_right_cbuffer_waitrequest    : std_logic; --                      --                               .waitrequest
	signal s_avm_right_cbuffer_address        : std_logic_vector(63 downto 0); --  --                               .address
	signal s_avm_right_cbuffer_write          : std_logic; --                      --                               .write
	signal s_avm_right_cbuffer_writedata      : std_logic_vector(255 downto 0); -- --                               .writedata
	signal s_avm_right_cbuffer_read           : std_logic; --                      --                               .read
	signal s_left_cbuf_tb_avs_memory_area     : t_cbuf_tb_avs_memory_area;
	signal s_right_cbuf_tb_avs_memory_area    : t_cbuf_tb_avs_memory_area;
	signal s_avm_left_cbuffer_wr_waitrequest  : std_logic;
	signal s_avm_left_cbuffer_rd_waitrequest  : std_logic;
	signal s_avm_right_cbuffer_wr_waitrequest : std_logic;
	signal s_avm_right_cbuffer_rd_waitrequest : std_logic;

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

	comm_tb_avs_right_read_stimuli_inst : entity work.comm_tb_avs_right_read_stimuli
		generic map(
			g_ADDRESS_WIDTH => 64,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                       => clk200,
			rst_i                       => rst,
			avs_avalon_mm_address_i     => s_tb_avs_right_read_stimuli_mm_address,
			avs_avalon_mm_read_i        => s_tb_avs_right_read_stimuli_mm_read,
			avs_avalon_mm_readata_o     => s_tb_avs_right_read_stimuli_mm_readdata,
			avs_avalon_mm_waitrequest_o => s_tb_avs_right_read_stimuli_mm_waitrequest
		);

	comm_tb_avs_left_read_stimuli_inst : entity work.comm_tb_avs_left_read_stimuli
		generic map(
			g_ADDRESS_WIDTH => 64,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                       => clk200,
			rst_i                       => rst,
			avs_avalon_mm_address_i     => s_tb_avs_left_read_stimuli_mm_address,
			avs_avalon_mm_read_i        => s_tb_avs_left_read_stimuli_mm_read,
			avs_avalon_mm_readata_o     => s_tb_avs_left_read_stimuli_mm_readdata,
			avs_avalon_mm_waitrequest_o => s_tb_avs_left_read_stimuli_mm_waitrequest
		);

	comm_v2_top_inst : entity work.comm_v2_top
		generic map(
			g_COMM_TESTBENCH_MODE   => '1',
			g_COMM_OPERATIONAL_MODE => '0' -- '0' = N-FEE Mode / '1' = F-FEE Mode 
		)
		port map(
			reset_sink_reset_i                  => rst,
			clock_sink_clk_i                    => clk200,
			channel_sync_i                      => s_sync,
			avs_config_address_i                => (others => '0'),
			avs_config_byteenable_i             => (others => '0'),
			avs_config_write_i                  => '0',
			avs_config_writedata_i              => (others => '0'),
			avs_config_read_i                   => '0',
			avs_config_readdata_o               => open,
			avs_config_waitrequest_o            => open,
			avm_left_buffer_readdata_i          => s_tb_avs_left_read_stimuli_mm_readdata,
			avm_left_buffer_waitrequest_i       => s_tb_avs_left_read_stimuli_mm_waitrequest,
			avm_left_buffer_address_o           => s_tb_avs_left_read_stimuli_mm_address,
			avm_left_buffer_read_o              => s_tb_avs_left_read_stimuli_mm_read,
			avm_right_buffer_readdata_i         => s_tb_avs_right_read_stimuli_mm_readdata,
			avm_right_buffer_waitrequest_i      => s_tb_avs_right_read_stimuli_mm_waitrequest,
			avm_right_buffer_address_o          => s_tb_avs_right_read_stimuli_mm_address,
			avm_right_buffer_read_o             => s_tb_avs_right_read_stimuli_mm_read,
			feeb_interrupt_sender_irq_o         => s_irq_buffers,
			rmap_interrupt_sender_irq_o         => s_irq_rmap,
			spw_link_status_started_i           => s_spw_link_status_started,
			spw_link_status_connecting_i        => s_spw_link_status_connecting,
			spw_link_status_running_i           => s_spw_link_status_running,
			spw_link_error_errdisc_i            => s_spw_link_error_errdisc,
			spw_link_error_errpar_i             => s_spw_link_error_errpar,
			spw_link_error_erresc_i             => s_spw_link_error_erresc,
			spw_link_error_errcred_i            => s_spw_link_error_errcred,
			spw_timecode_rx_tick_out_i          => s_spw_timecode_rx_tick_out,
			spw_timecode_rx_ctrl_out_i          => s_spw_timecode_rx_ctrl_out,
			spw_timecode_rx_time_out_i          => s_spw_timecode_rx_time_out,
			spw_data_rx_status_rxvalid_i        => s_spw_data_rx_status_rxvalid,
			spw_data_rx_status_rxhalff_i        => s_spw_data_rx_status_rxhalff,
			spw_data_rx_status_rxflag_i         => s_spw_data_rx_status_rxflag,
			spw_data_rx_status_rxdata_i         => s_spw_data_rx_status_rxdata,
			spw_data_tx_status_txrdy_i          => s_spw_data_tx_status_txrdy,
			spw_data_tx_status_txhalff_i        => s_spw_data_tx_status_txhalff,
			spw_link_command_autostart_o        => s_spw_link_command_autostart,
			spw_link_command_linkstart_o        => s_spw_link_command_linkstart,
			spw_link_command_linkdis_o          => s_spw_link_command_linkdis,
			spw_link_command_txdivcnt_o         => s_spw_link_command_txdivcnt,
			spw_timecode_tx_tick_in_o           => s_spw_timecode_tx_tick_in,
			spw_timecode_tx_ctrl_in_o           => s_spw_timecode_tx_ctrl_in,
			spw_timecode_tx_time_in_o           => s_spw_timecode_tx_time_in,
			spw_data_rx_command_rxread_o        => s_spw_data_rx_command_rxread,
			spw_data_tx_command_txwrite_o       => s_spw_data_tx_command_txwrite,
			spw_data_tx_command_txflag_o        => s_spw_data_tx_command_txflag,
			spw_data_tx_command_txdata_o        => s_spw_data_tx_command_txdata,
			rmap_echo_echo_en_o                 => open,
			rmap_echo_echo_id_en_o              => open,
			rmap_echo_in_fifo_wrflag_o          => open,
			rmap_echo_in_fifo_wrdata_o          => open,
			rmap_echo_in_fifo_wrreq_o           => open,
			rmap_echo_out_fifo_wrflag_o         => open,
			rmap_echo_out_fifo_wrdata_o         => open,
			rmap_echo_out_fifo_wrreq_o          => open,
			rmm_rmap_target_wr_waitrequest_i    => '0',
			rmm_rmap_target_readdata_i          => (others => '1'),
			rmm_rmap_target_rd_waitrequest_i    => '0',
			rmm_rmap_target_wr_address_o        => open,
			rmm_rmap_target_write_o             => open,
			rmm_rmap_target_writedata_o         => open,
			rmm_rmap_target_rd_address_o        => open,
			rmm_rmap_target_read_o              => open,
			rmm_fee_hk_wr_waitrequest_i         => '1',
			rmm_fee_hk_readdata_i               => (others => '1'),
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
			channel_win_mem_addr_offset_o       => open,
			comm_measurements_o                 => open
		);

	spw_controller_stimuli_inst : entity work.spw_controller_stimuli
		port map(
			clk_i                         => clk200,
			rst_i                         => rst,
			spw_link_command_autostart_i  => s_spw_link_command_autostart,
			spw_link_command_linkstart_i  => s_spw_link_command_linkstart,
			spw_link_command_linkdis_i    => s_spw_link_command_linkdis,
			spw_link_command_txdivcnt_i   => s_spw_link_command_txdivcnt,
			spw_timecode_tx_tick_in_i     => s_spw_timecode_tx_tick_in,
			spw_timecode_tx_ctrl_in_i     => s_spw_timecode_tx_ctrl_in,
			spw_timecode_tx_time_in_i     => s_spw_timecode_tx_time_in,
			spw_data_rx_command_rxread_i  => s_spw_data_rx_command_rxread,
			spw_data_tx_command_txwrite_i => s_spw_data_tx_command_txwrite,
			spw_data_tx_command_txflag_i  => s_spw_data_tx_command_txflag,
			spw_data_tx_command_txdata_i  => s_spw_data_tx_command_txdata,
			spw_link_status_started_o     => s_spw_link_status_started,
			spw_link_status_connecting_o  => s_spw_link_status_connecting,
			spw_link_status_running_o     => s_spw_link_status_running,
			spw_link_error_errdisc_o      => s_spw_link_error_errdisc,
			spw_link_error_errpar_o       => s_spw_link_error_errpar,
			spw_link_error_erresc_o       => s_spw_link_error_erresc,
			spw_link_error_errcred_o      => s_spw_link_error_errcred,
			spw_timecode_rx_tick_out_o    => s_spw_timecode_rx_tick_out,
			spw_timecode_rx_ctrl_out_o    => s_spw_timecode_rx_ctrl_out,
			spw_timecode_rx_time_out_o    => s_spw_timecode_rx_time_out,
			spw_data_rx_status_rxvalid_o  => s_spw_data_rx_status_rxvalid,
			spw_data_rx_status_rxhalff_o  => s_spw_data_rx_status_rxhalff,
			spw_data_rx_status_rxflag_o   => s_spw_data_rx_status_rxflag,
			spw_data_rx_status_rxdata_o   => s_spw_data_rx_status_rxdata,
			spw_data_tx_status_txrdy_o    => s_spw_data_tx_status_txrdy,
			spw_data_tx_status_txhalff_o  => s_spw_data_tx_status_txhalff
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
					--				if ((v_sync_high = '0') and (v_sync_div_cnt = 100)) then
					s_sync         <= '1';
					v_sync_high    := '1';
					v_sync_div_cnt := 0;
				elsif ((v_sync_high = '1') and (v_sync_div_cnt = 45000)) then
					--				elsif ((v_sync_high = '1') and (v_sync_div_cnt = 100)) then
					s_sync         <= '0';
					v_sync_high    := '0';
					--					v_sync_one_shot := '1'; -- comment this line to remove one-shot
					v_sync_div_cnt := 0;
				end if;
			end if;
			v_sync_div_cnt := v_sync_div_cnt + 1;
		end if;
	end process p_sync_generator;

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

	left_cbuf_tb_avs_read_ent_inst : entity work.cbuf_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_avm_left_cbuffer_address,
			cbuf_tb_avs_avalon_mm_i.read        => s_avm_left_cbuffer_read,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_memory_area_i           => s_left_cbuf_tb_avs_memory_area,
			cbuf_tb_avs_avalon_mm_o.readdata    => s_avm_left_cbuffer_readdata,
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_avm_left_cbuffer_rd_waitrequest
		);

	left_cbuf_tb_avs_write_ent_inst : entity work.cbuf_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_avm_left_cbuffer_address,
			cbuf_tb_avs_avalon_mm_i.write       => s_avm_left_cbuffer_write,
			cbuf_tb_avs_avalon_mm_i.writedata   => s_avm_left_cbuffer_writedata,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_avm_left_cbuffer_wr_waitrequest,
			cbuf_tb_avs_memory_area_o           => s_left_cbuf_tb_avs_memory_area
		);

	s_avm_left_cbuffer_waitrequest <= (s_avm_left_cbuffer_wr_waitrequest) and (s_avm_left_cbuffer_rd_waitrequest);

	right_cbuf_tb_avs_read_ent_inst : entity work.cbuf_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_avm_right_cbuffer_address,
			cbuf_tb_avs_avalon_mm_i.read        => s_avm_right_cbuffer_read,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_memory_area_i           => s_right_cbuf_tb_avs_memory_area,
			cbuf_tb_avs_avalon_mm_o.readdata    => s_avm_right_cbuffer_readdata,
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_avm_right_cbuffer_rd_waitrequest
		);

	right_cbuf_tb_avs_write_ent_inst : entity work.cbuf_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			cbuf_tb_avs_avalon_mm_i.address     => s_avm_right_cbuffer_address,
			cbuf_tb_avs_avalon_mm_i.write       => s_avm_right_cbuffer_write,
			cbuf_tb_avs_avalon_mm_i.writedata   => s_avm_right_cbuffer_writedata,
			cbuf_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			cbuf_tb_avs_avalon_mm_o.waitrequest => s_avm_right_cbuffer_wr_waitrequest,
			cbuf_tb_avs_memory_area_o           => s_right_cbuf_tb_avs_memory_area
		);

	s_avm_right_cbuffer_waitrequest <= (s_avm_right_cbuffer_wr_waitrequest) and (s_avm_right_cbuffer_rd_waitrequest);

end architecture RTL;
