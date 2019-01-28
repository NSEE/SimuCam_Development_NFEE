library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fee_master_data_controller_top is
	generic(
		g_FEE_CCD_SIDE : std_logic := '0'
	);
	port(
		clk_i                              : in  std_logic;
		rst_i                              : in  std_logic;
		-- general inputs
		fee_sync_signal_i                  : in  std_logic;
		fee_current_timecode_i             : in  std_logic_vector(7 downto 0);
		-- fee data controller control
		fee_machine_clear_i                : in  std_logic;
		fee_machine_stop_i                 : in  std_logic;
		fee_machine_start_i                : in  std_logic;
		-- fee windowing buffer status
		fee_window_data_i                  : in  std_logic_vector(63 downto 0);
		fee_window_mask_i                  : in  std_logic_vector(63 downto 0);
		fee_window_data_ready_i            : in  std_logic;
		fee_window_mask_ready_i            : in  std_logic;
		-- fee housekeeping memory status
		fee_hk_mem_valid_i                 : in  std_logic;
		fee_hk_mem_data_i                  : in  std_logic_vector(7 downto 0);
		-- fee spw codec tx status
		fee_spw_tx_ready_i                 : in  std_logic;
		-- data packet parameters
		data_pkt_ccd_x_size_i              : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_y_size_i              : in  std_logic_vector(15 downto 0);
		data_pkt_data_y_size_i             : in  std_logic_vector(15 downto 0);
		data_pkt_overscan_y_size_i         : in  std_logic_vector(15 downto 0);
		data_pkt_packet_length_i           : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_i                : in  std_logic_vector(2 downto 0);
		data_pkt_ccd_number_i              : in  std_logic_vector(1 downto 0);
		-- data delays parameters
		data_pkt_line_delay_i              : in  std_logic_vector(15 downto 0);
		data_pkt_column_delay_i            : in  std_logic_vector(15 downto 0);
		data_pkt_adc_delay_i               : in  std_logic_vector(15 downto 0);
		-- fee slave data controller control
		fee_slave_imgdata_start_o          : out std_logic;
		fee_slave_frame_counter_o          : out std_logic_vector(15 downto 0);
		fee_slave_frame_number_o           : out std_logic_vector(1 downto 0);
		-- fee windowing buffer control
		fee_window_data_read_o             : out std_logic;
		fee_window_mask_read_o             : out std_logic;
		-- fee housekeeping memory control
		fee_hk_mem_byte_address_o          : out std_logic_vector(31 downto 0);
		fee_hk_mem_read_o                  : out std_logic;
		-- fee spw codec tx control
		fee_spw_tx_write_o                 : out std_logic;
		fee_spw_tx_flag_o                  : out std_logic;
		fee_spw_tx_data_o                  : out std_logic_vector(7 downto 0);
		-- data packet header
		data_pkt_header_length_o           : out std_logic_vector(15 downto 0);
		data_pkt_header_type_o             : out std_logic_vector(15 downto 0);
		data_pkt_header_frame_counter_o    : out std_logic_vector(15 downto 0);
		data_pkt_header_sequence_counter_o : out std_logic_vector(15 downto 0)
	);
end entity fee_master_data_controller_top;

architecture RTL of fee_master_data_controller_top is

	-- general signals
	signal s_current_frame_number               : std_logic_vector(1 downto 0);
	signal s_current_frame_counter              : std_logic_vector(15 downto 0);
	-- masking machine signals
	signal s_masking_machine_hold               : std_logic;
	--	signal s_masking_buffer_clear               : std_logic;
	signal s_masking_buffer_rdreq               : std_logic;
	signal s_masking_buffer_almost_empty        : std_logic;
	signal s_masking_buffer_empty               : std_logic;
	signal s_masking_buffer_rddata              : std_logic_vector(7 downto 0);
	-- header data signals
	signal s_headerdata_logical_address         : std_logic_vector(7 downto 0);
	signal s_headerdata_length_field            : std_logic_vector(15 downto 0);
	signal s_headerdata_type_field_mode         : std_logic_vector(2 downto 0);
	signal s_headerdata_type_field_last_packet  : std_logic;
	signal s_headerdata_type_field_ccd_side     : std_logic;
	signal s_headerdata_type_field_ccd_number   : std_logic_vector(1 downto 0);
	signal s_headerdata_type_field_frame_number : std_logic_vector(1 downto 0);
	signal s_headerdata_type_field_packet_type  : std_logic_vector(1 downto 0);
	signal s_headerdata_frame_counter           : std_logic_vector(15 downto 0);
	signal s_headerdata_sequence_counter        : std_logic_vector(15 downto 0);
	-- header generator signals
	signal s_header_gen_busy                    : std_logic;
	signal s_header_gen_finished                : std_logic;
	signal s_header_gen_send                    : std_logic;
	signal s_header_gen_reset                   : std_logic;
	signal s_send_buffer_header_gen_wrdata      : std_logic_vector(7 downto 0);
	signal s_send_buffer_header_gen_wrreq       : std_logic;
	-- housekeeping writer signals
	signal s_housekeeping_wr_busy               : std_logic;
	signal s_housekeeping_wr_finished           : std_logic;
	signal s_housekeeping_wr_start              : std_logic;
	signal s_housekeeping_wr_reset              : std_logic;
	signal s_send_buffer_housekeeping_wr_wrdata : std_logic_vector(7 downto 0);
	signal s_send_buffer_housekeeping_wr_wrreq  : std_logic;
	-- data writer signals
	signal s_data_wr_busy                       : std_logic;
	signal s_data_wr_finished                   : std_logic;
	signal s_data_wr_start                      : std_logic;
	signal s_data_wr_reset                      : std_logic;
	signal s_data_wr_length                     : std_logic_vector(15 downto 0);
	signal s_send_buffer_data_wr_wrdata         : std_logic_vector(7 downto 0);
	signal s_send_buffer_data_wr_wrreq          : std_logic;
	-- send buffer signals
	signal s_send_buffer_fee_data_loaded        : std_logic;
	--	signal s_send_buffer_clear                  : std_logic;
	signal s_send_buffer_wrdata                 : std_logic_vector(7 downto 0);
	signal s_send_buffer_wrreq                  : std_logic;
	signal s_send_buffer_rdreq                  : std_logic;
	signal s_send_buffer_stat_almost_empty      : std_logic;
	signal s_send_buffer_stat_almost_full       : std_logic;
	signal s_send_buffer_stat_empty             : std_logic;
	signal s_send_buffer_stat_full              : std_logic;
	signal s_send_buffer_rddata                 : std_logic_vector(7 downto 0);
	signal s_send_buffer_rdready                : std_logic;
	signal s_send_buffer_wrready                : std_logic;
	-- data transmitter signals
	signal s_data_transmitter_busy              : std_logic;
	signal s_data_transmitter_finished          : std_logic;
	--	signal s_data_transmitter_reset             : std_logic;
	signal s_start_masking                      : std_logic;
	-- registered data pkt config signals (for the entire read-out)
	signal s_registered_fee_ccd_x_size_i        : std_logic_vector(15 downto 0);
	signal s_registered_fee_ccd_y_size_i        : std_logic_vector(15 downto 0);
	signal s_registered_fee_data_y_size_i       : std_logic_vector(15 downto 0);
	signal s_registered_fee_overscan_y_size_i   : std_logic_vector(15 downto 0);
	signal s_registered_fee_packet_length_i     : std_logic_vector(15 downto 0);
	signal s_registered_fee_fee_mode_i          : std_logic_vector(2 downto 0);
	signal s_registered_fee_ccd_number_i        : std_logic_vector(1 downto 0);

begin

	-- masking machine instantiation
	masking_machine_ent_inst : entity work.masking_machine_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			sync_signal_i                 => fee_sync_signal_i,
			fee_clear_signal_i            => fee_machine_clear_i,
			fee_stop_signal_i             => fee_machine_stop_i,
			fee_start_signal_i            => fee_machine_start_i,
			fee_start_masking_i           => s_start_masking,
			masking_machine_hold_i        => s_masking_machine_hold,
			fee_ccd_x_size_i              => s_registered_fee_ccd_x_size_i,
			fee_ccd_y_size_i              => s_registered_fee_ccd_y_size_i,
			fee_line_delay_i              => data_pkt_line_delay_i,
			fee_column_delay_i            => data_pkt_column_delay_i,
			fee_adc_delay_i               => data_pkt_adc_delay_i,
			current_timecode_i            => fee_current_timecode_i,
			window_data_i                 => fee_window_data_i,
			window_mask_i                 => fee_window_mask_i,
			window_data_ready_i           => fee_window_data_ready_i,
			window_mask_ready_i           => fee_window_mask_ready_i,
			masking_buffer_rdreq_i        => s_masking_buffer_rdreq,
			window_data_read_o            => fee_window_data_read_o,
			window_mask_read_o            => fee_window_mask_read_o,
			masking_buffer_almost_empty_o => s_masking_buffer_almost_empty,
			masking_buffer_empty_o        => s_masking_buffer_empty,
			masking_buffer_rddata_o       => s_masking_buffer_rddata
		);

	-- fee master data manager instantiation
	fee_master_data_manager_ent_inst : entity work.fee_master_data_manager_ent
		port map(
			clk_i                                => clk_i,
			rst_i                                => rst_i,
			fee_clear_signal_i                   => fee_machine_clear_i,
			fee_stop_signal_i                    => fee_machine_stop_i,
			fee_start_signal_i                   => fee_machine_start_i,
			sync_signal_i                        => fee_sync_signal_i,
			current_frame_number_i               => s_current_frame_number,
			current_frame_counter_i              => s_current_frame_counter,
			fee_ccd_x_size_i                     => s_registered_fee_ccd_x_size_i,
			fee_data_y_size_i                    => s_registered_fee_data_y_size_i,
			fee_overscan_y_size_i                => s_registered_fee_overscan_y_size_i,
			fee_packet_length_i                  => s_registered_fee_packet_length_i,
			fee_fee_mode_i                       => s_registered_fee_fee_mode_i,
			fee_ccd_number_i                     => s_registered_fee_ccd_number_i,
			fee_ccd_side_i                       => g_FEE_CCD_SIDE,
			header_gen_finished_i                => s_header_gen_finished,
			housekeeping_wr_finished_i           => s_housekeeping_wr_finished,
			data_wr_finished_i                   => s_data_wr_finished,
			data_transmitter_finished_i          => s_data_transmitter_finished,
			imgdata_start_o                      => s_start_masking,
			masking_machine_hold_o               => s_masking_machine_hold,
			headerdata_logical_address_o         => s_headerdata_logical_address,
			headerdata_length_field_o            => s_headerdata_length_field,
			headerdata_type_field_mode_o         => s_headerdata_type_field_mode,
			headerdata_type_field_last_packet_o  => s_headerdata_type_field_last_packet,
			headerdata_type_field_ccd_side_o     => s_headerdata_type_field_ccd_side,
			headerdata_type_field_ccd_number_o   => s_headerdata_type_field_ccd_number,
			headerdata_type_field_frame_number_o => s_headerdata_type_field_frame_number,
			headerdata_type_field_packet_type_o  => s_headerdata_type_field_packet_type,
			headerdata_frame_counter_o           => s_headerdata_frame_counter,
			headerdata_sequence_counter_o        => s_headerdata_sequence_counter,
			header_gen_send_o                    => s_header_gen_send,
			header_gen_reset_o                   => s_header_gen_reset,
			housekeeping_wr_start_o              => s_housekeeping_wr_start,
			housekeeping_wr_reset_o              => s_housekeeping_wr_reset,
			data_wr_start_o                      => s_data_wr_start,
			data_wr_reset_o                      => s_data_wr_reset,
			data_wr_length_o                     => s_data_wr_length,
			send_buffer_fee_data_loaded_o        => s_send_buffer_fee_data_loaded
		);

	-- data packet header generator instantiation
	data_packet_header_gen_ent_inst : entity work.data_packet_header_gen_ent
		port map(
			clk_i                                => clk_i,
			rst_i                                => rst_i,
			fee_clear_signal_i                   => fee_machine_clear_i,
			fee_stop_signal_i                    => fee_machine_stop_i,
			fee_start_signal_i                   => fee_machine_start_i,
			header_gen_send_i                    => s_header_gen_send,
			header_gen_reset_i                   => s_header_gen_reset,
			headerdata_logical_address_i         => s_headerdata_logical_address,
			headerdata_length_field_i            => s_headerdata_length_field,
			headerdata_type_field_mode_i         => s_headerdata_type_field_mode,
			headerdata_type_field_last_packet_i  => s_headerdata_type_field_last_packet,
			headerdata_type_field_ccd_side_i     => s_headerdata_type_field_ccd_side,
			headerdata_type_field_ccd_number_i   => s_headerdata_type_field_ccd_number,
			headerdata_type_field_frame_number_i => s_headerdata_type_field_frame_number,
			headerdata_type_field_packet_type_i  => s_headerdata_type_field_packet_type,
			headerdata_frame_counter_i           => s_headerdata_frame_counter,
			headerdata_sequence_counter_i        => s_headerdata_sequence_counter,
			send_buffer_stat_almost_full_i       => s_send_buffer_stat_almost_full,
			send_buffer_stat_full_i              => s_send_buffer_stat_full,
			send_buffer_wrready_i                => s_send_buffer_wrready,
			header_gen_busy_o                    => s_header_gen_busy,
			header_gen_finished_o                => s_header_gen_finished,
			send_buffer_wrdata_o                 => s_send_buffer_header_gen_wrdata,
			send_buffer_wrreq_o                  => s_send_buffer_header_gen_wrreq
		);

	-- data packet housekeeping writer instantiation
	data_packet_hk_writer_ent_inst : entity work.data_packet_hk_writer_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			housekeeping_wr_start_i        => s_housekeeping_wr_start,
			housekeeping_wr_reset_i        => s_housekeeping_wr_reset,
			hk_mem_valid_i                 => fee_hk_mem_valid_i,
			hk_mem_data_i                  => fee_hk_mem_data_i,
			send_buffer_stat_almost_full_i => s_send_buffer_stat_almost_full,
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			housekeeping_wr_busy_o         => s_housekeeping_wr_busy,
			housekeeping_wr_finished_o     => s_housekeeping_wr_finished,
			hk_mem_byte_address_o          => fee_hk_mem_byte_address_o,
			hk_mem_read_o                  => fee_hk_mem_read_o,
			send_buffer_wrdata_o           => s_send_buffer_housekeeping_wr_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_housekeeping_wr_wrreq
		);

	-- data packet data writer instantiation
	data_packet_data_writer_ent_inst : entity work.data_packet_data_writer_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			data_wr_start_i                => s_data_wr_start,
			data_wr_reset_i                => s_data_wr_reset,
			data_wr_length_i               => s_data_wr_length,
			masking_buffer_almost_empty_i  => s_masking_buffer_almost_empty,
			masking_buffer_empty_i         => s_masking_buffer_empty,
			masking_buffer_rddata_i        => s_masking_buffer_rddata,
			send_buffer_stat_almost_full_i => s_send_buffer_stat_almost_full,
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			data_wr_busy_o                 => s_data_wr_busy,
			data_wr_finished_o             => s_data_wr_finished,
			masking_buffer_rdreq_o         => s_masking_buffer_rdreq,
			send_buffer_wrdata_o           => s_send_buffer_data_wr_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_data_wr_wrreq
		);

	-- send buffer instantiation
	send_buffer_ent_inst : entity work.send_buffer_ent
		port map(
			clk_i                      => clk_i,
			rst_i                      => rst_i,
			fee_clear_signal_i         => fee_machine_clear_i,
			fee_stop_signal_i          => fee_machine_stop_i,
			fee_start_signal_i         => fee_machine_start_i,
			fee_data_loaded_i          => s_send_buffer_fee_data_loaded,
			buffer_cfg_length_i        => data_pkt_packet_length_i,
			buffer_wrdata_i            => s_send_buffer_wrdata,
			buffer_wrreq_i             => s_send_buffer_wrreq,
			buffer_rdreq_i             => s_send_buffer_rdreq,
			buffer_stat_almost_empty_o => s_send_buffer_stat_almost_empty,
			buffer_stat_almost_full_o  => s_send_buffer_stat_almost_full,
			buffer_stat_empty_o        => s_send_buffer_stat_empty,
			buffer_stat_full_o         => s_send_buffer_stat_full,
			buffer_rddata_o            => s_send_buffer_rddata,
			buffer_rdready_o           => s_send_buffer_rdready,
			buffer_wrready_o           => s_send_buffer_wrready
		);
	s_send_buffer_wrdata <= (s_send_buffer_header_gen_wrdata) or (s_send_buffer_housekeeping_wr_wrdata) or (s_send_buffer_data_wr_wrdata);
	s_send_buffer_wrreq  <= (s_send_buffer_header_gen_wrreq) or (s_send_buffer_housekeeping_wr_wrreq) or (s_send_buffer_data_wr_wrreq);

	-- data transmitter instantiation
	data_transmitter_ent_inst : entity work.data_transmitter_ent
		port map(
			clk_i                           => clk_i,
			rst_i                           => rst_i,
			fee_clear_signal_i              => fee_machine_clear_i,
			fee_stop_signal_i               => fee_machine_stop_i,
			fee_start_signal_i              => fee_machine_start_i,
			--			data_transmitter_reset_i        => s_data_transmitter_reset,
			send_buffer_stat_almost_empty_i => s_send_buffer_stat_almost_empty,
			send_buffer_stat_empty_i        => s_send_buffer_stat_empty,
			send_buffer_rddata_i            => s_send_buffer_rddata,
			send_buffer_rdready_i           => s_send_buffer_rdready,
			spw_tx_ready_i                  => fee_spw_tx_ready_i,
			data_transmitter_busy_o         => s_data_transmitter_busy,
			data_transmitter_finished_o     => s_data_transmitter_finished,
			send_buffer_rdreq_o             => s_send_buffer_rdreq,
			spw_tx_write_o                  => fee_spw_tx_write_o,
			spw_tx_flag_o                   => fee_spw_tx_flag_o,
			spw_tx_data_o                   => fee_spw_tx_data_o
		);

	-- fee frame manager
	p_fee_frame_manager : process(clk_i, rst_i) is
		variable v_full_frame_cnt : std_logic_vector(17 downto 0) := (others => '0');
		variable v_stopped_flag   : std_logic                     := '1';
	begin
		if (rst_i = '1') then
			s_current_frame_counter <= (others => '0');
			s_current_frame_number  <= (others => '0');
			v_full_frame_cnt        := (others => '0');
			v_stopped_flag          := '1';
		elsif rising_edge(clk_i) then

			--
			-- Definitions:
			--
			-- frame counter : full read-out cycle counter
			--   |  frame counter |
			--   |  15 downto  0  |
			--
			-- frame number : current frame inside a full read-out cycle
			--   |   frame number |
			--   |   1 downto  0  |
			--
			-- full frame counter:
			--   |  frame counter |   frame number |
			--   |  17 downto  2  |   1 downto  0  |
			--

			-- check if frame manager is stopped
			if (v_stopped_flag = '1') then
				-- frame manager stopped
				-- check if a clear request was received
				if (fee_machine_clear_i = '1') then
					-- clear request received
					-- clear counters
					s_current_frame_counter <= (others => '0');
					s_current_frame_number  <= (others => '0');
					v_full_frame_cnt        := (others => '0');
				end if;
				-- check if a start request was received
				if (fee_machine_start_i = '1') then
					-- start request received
					-- start frame manager
					v_stopped_flag := '0';
				end if;
			else
				-- frame manager not stopped
				-- check if a sync signal was received
				if (fee_sync_signal_i = '1') then
					-- sync signal received
					-- update counters
					v_full_frame_cnt(17 downto 2) := s_current_frame_counter;
					v_full_frame_cnt(1 downto 0)  := s_current_frame_number;
					v_full_frame_cnt              := std_logic_vector(unsigned(v_full_frame_cnt) + 1);
					s_current_frame_counter       <= v_full_frame_cnt(17 downto 2);
					s_current_frame_number        <= v_full_frame_cnt(1 downto 0);
				end if;
				-- check if a stop request was received
				if (fee_machine_stop_i = '1') then
					-- stop request received
					-- stop frame manager
					v_stopped_flag := '1';
				end if;
			end if;

		end if;
	end process p_fee_frame_manager;

	-- outputs generation
	fee_slave_imgdata_start_o <= s_start_masking;
	fee_slave_frame_counter_o <= s_current_frame_counter;
	fee_slave_frame_number_o  <= s_current_frame_number;

	-- data pkt header manager
	p_data_pkt_header_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			data_pkt_header_length_o           <= (others => '0');
			data_pkt_header_type_o             <= (others => '0');
			data_pkt_header_frame_counter_o    <= (others => '0');
			data_pkt_header_sequence_counter_o <= (others => '0');
		elsif rising_edge(clk_i) then
			-- check if a header generator send was requested
			if (s_header_gen_send = '1') then
				-- header generator send requested, update the data pkt header
				data_pkt_header_length_o             <= s_headerdata_length_field;
				data_pkt_header_type_o(15 downto 11) <= (others => '0');
				data_pkt_header_type_o(10 downto 8)  <= s_headerdata_type_field_mode;
				data_pkt_header_type_o(7)            <= s_headerdata_type_field_last_packet;
				data_pkt_header_type_o(6)            <= s_headerdata_type_field_ccd_side;
				data_pkt_header_type_o(5 downto 4)   <= s_headerdata_type_field_ccd_number;
				data_pkt_header_type_o(3 downto 2)   <= s_headerdata_type_field_frame_number;
				data_pkt_header_type_o(1 downto 0)   <= s_headerdata_type_field_packet_type;
				data_pkt_header_frame_counter_o      <= s_headerdata_frame_counter;
				data_pkt_header_sequence_counter_o   <= s_headerdata_sequence_counter;
			end if;
		end if;
	end process p_data_pkt_header_manager;

	p_register_data_pkt_config : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_registered_fee_ccd_x_size_i      <= std_logic_vector(to_unsigned(2295, 16));
			s_registered_fee_ccd_y_size_i      <= std_logic_vector(to_unsigned(4540, 16));
			s_registered_fee_data_y_size_i     <= std_logic_vector(to_unsigned(4510, 16));
			s_registered_fee_overscan_y_size_i <= std_logic_vector(to_unsigned(30, 16));
			s_registered_fee_packet_length_i   <= std_logic_vector(to_unsigned(32768, 16));
			s_registered_fee_fee_mode_i        <= std_logic_vector(to_unsigned(1, 3));
			s_registered_fee_ccd_number_i      <= std_logic_vector(to_unsigned(0, 2));
		elsif rising_edge(clk_i) then
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				s_registered_fee_ccd_x_size_i      <= data_pkt_ccd_x_size_i;
				s_registered_fee_ccd_y_size_i      <= data_pkt_ccd_y_size_i;
				s_registered_fee_data_y_size_i     <= data_pkt_data_y_size_i;
				s_registered_fee_overscan_y_size_i <= data_pkt_overscan_y_size_i;
				s_registered_fee_packet_length_i   <= data_pkt_packet_length_i;
				s_registered_fee_fee_mode_i        <= data_pkt_fee_mode_i;
				s_registered_fee_ccd_number_i      <= data_pkt_ccd_number_i;
			end if;
		end if;
	end process p_register_data_pkt_config;

end architecture RTL;
