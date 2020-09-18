library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity scom_data_controller_top is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		-- general inputs
		fee_sync_signal_i           : in  std_logic;
		-- fee data controller control
		fee_machine_clear_i         : in  std_logic;
		fee_machine_stop_i          : in  std_logic;
		fee_machine_start_i         : in  std_logic;
		-- fee frame manager status	
		fee_current_frame_number_i  : in  std_logic_vector(1 downto 0);
		fee_current_frame_counter_i : in  std_logic_vector(15 downto 0);
		-- fee housekeeping memory status
		fee_hk_mem_waitrequest_i    : in  std_logic;
		fee_hk_mem_data_i           : in  std_logic_vector(7 downto 0);
		-- fee spw codec tx status
		fee_spw_tx_ready_i          : in  std_logic;
		fee_spw_link_running_i      : in  std_logic;
		-- data packet parameters
		data_pkt_packet_length_i    : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_i         : in  std_logic_vector(4 downto 0);
		data_pkt_ccd_number_i       : in  std_logic_vector(1 downto 0);
		data_pkt_protocol_id_i      : in  std_logic_vector(7 downto 0);
		data_pkt_logical_addr_i     : in  std_logic_vector(7 downto 0);
		-- fee machine status
		fee_machine_busy_o          : out std_logic;
		-- fee housekeeping memory control
		fee_hk_mem_byte_address_o   : out std_logic_vector(31 downto 0);
		fee_hk_mem_read_o           : out std_logic;
		-- fee spw codec tx control
		fee_spw_tx_write_o          : out std_logic;
		fee_spw_tx_flag_o           : out std_logic;
		fee_spw_tx_data_o           : out std_logic_vector(7 downto 0)
	);
end entity scom_data_controller_top;

architecture RTL of scom_data_controller_top is

	-- general signals
	-- fee data manager signals
	signal s_dataman_sync                    : std_logic;
	signal s_dataman_hk_only                 : std_logic;
	-- fee housekeeping data controller signals
	signal s_hkdataman_status                : t_fee_dpkt_general_status;
	signal s_hkdataman_control               : t_fee_dpkt_general_control;
	signal s_hkdata_send_buffer_control      : t_fee_dpkt_send_buffer_control;
	signal s_hkdata_send_buffer_status       : t_fee_dpkt_send_buffer_status;
	signal s_hkdata_send_double_buffer_empty : std_logic;
	-- data transmitter signals
	signal s_data_transmitter_finished       : std_logic;
	-- registered data packet parameters signals (for the entire read-out)
	signal s_registered_dpkt_params          : t_fee_dpkt_registered_params;
	-- spw write masking
	signal s_spw_tx_write                    : std_logic;
	signal s_spw_write_mask                  : std_logic;

begin

	-- fee data manager instantiation
	fee_data_manager_ent_inst : entity work.fee_data_manager_ent
		port map(
			clk_i                                    => clk_i,
			rst_i                                    => rst_i,
			fee_clear_signal_i                       => fee_machine_clear_i,
			fee_stop_signal_i                        => fee_machine_stop_i,
			fee_start_signal_i                       => fee_machine_start_i,
			fee_manager_sync_i                       => s_dataman_sync,
			fee_manager_hk_only_i                    => s_dataman_hk_only,
			fee_left_buffer_activated_i              => '0',
			fee_right_buffer_activated_i             => '0',
			hkdataman_manager_i                      => s_hkdataman_status,
			left_imgdataman_manager_i.finished       => '1',
			right_imgdataman_manager_i.finished      => '1',
			data_transmitter_finished_i              => s_data_transmitter_finished,
			hkdata_send_double_buffer_empty_i        => s_hkdata_send_double_buffer_empty,
			left_imgdata_send_double_buffer_empty_i  => '1',
			right_imgdata_send_double_buffer_empty_i => '1',
			fee_data_manager_busy_o                  => fee_machine_busy_o,
			hkdataman_manager_o                      => s_hkdataman_control,
			left_imgdataman_manager_o                => open,
			right_imgdataman_manager_o               => open
		);

	-- fee housekeeping data manager instantiation
	fee_hkdata_controller_top_inst : entity work.fee_hkdata_controller_top
		port map(
			clk_i                             => clk_i,
			rst_i                             => rst_i,
			hkdataman_start_i                 => s_hkdataman_control.start,
			hkdataman_reset_i                 => s_hkdataman_control.reset,
			fee_manager_hk_only_i             => s_dataman_hk_only,
			fee_current_frame_number_i        => fee_current_frame_number_i,
			fee_current_frame_counter_i       => fee_current_frame_counter_i,
			fee_machine_clear_i               => fee_machine_clear_i,
			fee_machine_stop_i                => fee_machine_stop_i,
			fee_machine_start_i               => fee_machine_start_i,
			fee_hk_mem_waitrequest_i          => fee_hk_mem_waitrequest_i,
			fee_hk_mem_data_i                 => fee_hk_mem_data_i,
			data_pkt_packet_length_i          => x"0400", -- 0x400 = 1024 Bytes
			data_pkt_fee_mode_i               => s_registered_dpkt_params.image.fee_mode,
			data_pkt_ccd_number_i             => s_registered_dpkt_params.image.ccd_number,
			data_pkt_ccd_side_i               => s_registered_dpkt_params.image.ccd_side_hk,
			data_pkt_protocol_id_i            => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i           => s_registered_dpkt_params.image.logical_addr,
			hkdata_send_buffer_control_i      => s_hkdata_send_buffer_control,
			hkdataman_finished_o              => s_hkdataman_status.finished,
			hkdata_headerdata_o               => open,
			fee_hk_mem_byte_address_o         => fee_hk_mem_byte_address_o,
			fee_hk_mem_read_o                 => fee_hk_mem_read_o,
			hkdata_send_buffer_status_o       => s_hkdata_send_buffer_status,
			hkdata_send_double_buffer_empty_o => s_hkdata_send_double_buffer_empty
		);

	-- data transmitter top instantiation
	comm_data_transmitter_top_inst : entity work.comm_data_transmitter_top
		port map(
			clk_i                                             => clk_i,
			rst_i                                             => rst_i,
			comm_stop_i                                       => fee_machine_stop_i,
			comm_start_i                                      => fee_machine_start_i,
			channel_sync_i                                    => fee_sync_signal_i,
			send_buffer_cfg_length_i                          => s_registered_dpkt_params.image.packet_length,
			send_buffer_hkdata_status_i                       => s_hkdata_send_buffer_status,
			send_buffer_leftimg_status_i.stat_empty           => '1',
			send_buffer_leftimg_status_i.stat_extended_usedw  => (others => '0'),
			send_buffer_leftimg_status_i.rddata               => (others => '0'),
			send_buffer_leftimg_status_i.rddata_type          => (others => '0'),
			send_buffer_leftimg_status_i.rddata_end           => '0',
			send_buffer_leftimg_status_i.rdready              => '0',
			left_imgdataman_img_finished_i                    => '1',
			left_imgdataman_ovs_finished_i                    => '1',
			left_imgdata_img_valid_i                          => '1',
			left_imgdata_ovs_valid_i                          => '1',
			send_buffer_rightimg_status_i.stat_empty          => '1',
			send_buffer_rightimg_status_i.stat_extended_usedw => (others => '0'),
			send_buffer_rightimg_status_i.rddata              => (others => '0'),
			send_buffer_rightimg_status_i.rddata_type         => (others => '0'),
			send_buffer_rightimg_status_i.rddata_end          => '0',
			send_buffer_rightimg_status_i.rdready             => '0',
			right_imgdataman_img_finished_i                   => '1',
			right_imgdataman_ovs_finished_i                   => '1',
			right_imgdata_img_valid_i                         => '1',
			right_imgdata_ovs_valid_i                         => '1',
			spw_tx_ready_i                                    => fee_spw_tx_ready_i,
			housekeep_only_i                                  => s_dataman_hk_only,
			windowing_enabled_i                               => '0',
			windowing_packet_order_list_i                     => (others => '0'),
			windowing_last_left_packet_i                      => (others => '0'),
			windowing_last_right_packet_i                     => (others => '0'),
			data_transmitter_finished_o                       => s_data_transmitter_finished,
			send_buffer_hkdata_control_o                      => s_hkdata_send_buffer_control,
			send_buffer_leftimg_control_o                     => open,
			send_buffer_rightimg_control_o                    => open,
			spw_tx_flag_o                                     => fee_spw_tx_flag_o,
			spw_tx_data_o                                     => fee_spw_tx_data_o,
			spw_tx_write_o                                    => s_spw_tx_write
		);

	-- data pkt configs register
	p_register_data_pkt_config : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_registered_dpkt_params.image.logical_addr                     <= x"50";
			s_registered_dpkt_params.image.protocol_id                      <= x"F0";
			s_registered_dpkt_params.image.ccd_x_size                       <= std_logic_vector(to_unsigned(2295, 16));
			s_registered_dpkt_params.image.ccd_y_size                       <= std_logic_vector(to_unsigned(4540, 16));
			s_registered_dpkt_params.image.data_y_size                      <= std_logic_vector(to_unsigned(4510, 16));
			s_registered_dpkt_params.image.overscan_y_size                  <= std_logic_vector(to_unsigned(30, 16));
			s_registered_dpkt_params.image.packet_length                    <= std_logic_vector(to_unsigned(32768, 16));
			s_registered_dpkt_params.image.fee_mode                         <= std_logic_vector(to_unsigned(15, 4));
			s_registered_dpkt_params.image.ccd_number                       <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_side_hk                      <= c_COMM_NFEE_CCD_SIDE_E;
			s_registered_dpkt_params.image.ccd_v_start                      <= (others => '0');
			s_registered_dpkt_params.image.ccd_v_end                        <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_v_end                    <= (others => '0');
			s_registered_dpkt_params.image.ccd_ovs_v_end                    <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_start                      <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_end                        <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_en                       <= '0';
			s_registered_dpkt_params.image.ccd_img_en                       <= '0';
			s_registered_dpkt_params.image.ccd_ovs_en                       <= '0';
			s_registered_dpkt_params.image.start_delay                      <= (others => '0');
			s_registered_dpkt_params.image.skip_delay                       <= (others => '0');
			s_registered_dpkt_params.image.line_delay                       <= (others => '0');
			s_registered_dpkt_params.image.adc_delay                        <= (others => '0');
			s_registered_dpkt_params.transmission.windowing_en              <= '0';
			s_registered_dpkt_params.transmission.pattern_en                <= '1';
			s_registered_dpkt_params.transmission.overflow_en               <= '1';
			s_registered_dpkt_params.transmission.left_pixels_storage_size  <= (others => '0');
			s_registered_dpkt_params.transmission.right_pixels_storage_size <= (others => '0');
			s_registered_dpkt_params.spw_errinj.eep_received                <= '0';
			s_registered_dpkt_params.spw_errinj.sequence_cnt                <= (others => '0');
			s_registered_dpkt_params.spw_errinj.n_repeat                    <= (others => '0');
			s_registered_dpkt_params.trans_errinj.tx_disabled               <= '0';
			s_registered_dpkt_params.trans_errinj.missing_pkts              <= '0';
			s_registered_dpkt_params.trans_errinj.missing_data              <= '0';
			s_registered_dpkt_params.trans_errinj.frame_num                 <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.trans_errinj.sequence_cnt              <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.trans_errinj.data_cnt                  <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.trans_errinj.n_repeat                  <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.windowing.packet_order_list            <= (others => '0');
			s_registered_dpkt_params.windowing.last_left_packet             <= (others => '0');
			s_registered_dpkt_params.windowing.last_right_packet            <= (others => '0');
		elsif rising_edge(clk_i) then
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- register data pkt config
				s_registered_dpkt_params.image.logical_addr        <= data_pkt_logical_addr_i;
				s_registered_dpkt_params.image.protocol_id         <= data_pkt_protocol_id_i;
				s_registered_dpkt_params.image.packet_length       <= data_pkt_packet_length_i;
				s_registered_dpkt_params.image.ccd_number          <= data_pkt_ccd_number_i;
				-- register housekeeping settings
				s_registered_dpkt_params.image.ccd_side_hk         <= c_COMM_NFEE_CCD_SIDE_E;
				-- register masking settings
				s_registered_dpkt_params.image.fee_mode            <= c_FEE_ID_ON_MODE;
				s_registered_dpkt_params.transmission.windowing_en <= '0';
				s_registered_dpkt_params.transmission.pattern_en   <= '0';
			end if;
		end if;
	end process p_register_data_pkt_config;

	p_data_manager_sync_gen : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_dataman_sync    <= '0';
			s_dataman_hk_only <= '0';
			s_spw_write_mask  <= '0';
		elsif rising_edge(clk_i) then
			s_dataman_sync <= '0';
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- sync signal was received

				-- set datament sync and hk only
				s_dataman_sync    <= '1';
				s_dataman_hk_only <= '1';

				-- check if the spw link is running
				if (fee_spw_link_running_i = '1') then
					-- the spw link is running, do not mask the codec write
					s_spw_write_mask <= '1';
				else
					-- the spw link is not running, do mask the codec write
					s_spw_write_mask <= '0';
				end if;

			end if;
		end if;
	end process p_data_manager_sync_gen;

	-- signals assingments

	-- outputs generation
	fee_spw_tx_write_o <= (s_spw_tx_write) and (s_spw_write_mask);

end architecture RTL;
