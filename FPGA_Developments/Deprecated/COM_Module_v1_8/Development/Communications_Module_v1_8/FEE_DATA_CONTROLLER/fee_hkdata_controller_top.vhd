library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_hkdata_controller_top is
	port(
		clk_i                             : in  std_logic;
		rst_i                             : in  std_logic;
		-- general inputs
		-- fee hkdata controller control
		hkdataman_start_i                 : in  std_logic;
		hkdataman_reset_i                 : in  std_logic;
		fee_manager_hk_only_i             : in  std_logic;
		fee_current_frame_number_i        : in  std_logic_vector(1 downto 0);
		fee_current_frame_counter_i       : in  std_logic_vector(15 downto 0);
		fee_ccd_side_i                    : in  std_logic;
		-- fee data controller control
		fee_machine_clear_i               : in  std_logic;
		fee_machine_stop_i                : in  std_logic;
		fee_machine_start_i               : in  std_logic;
		-- fee housekeeping memory status
		fee_hk_mem_waitrequest_i          : in  std_logic;
		fee_hk_mem_data_i                 : in  std_logic_vector(7 downto 0);
		-- data packet parameters
		data_pkt_packet_length_i          : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_i               : in  std_logic_vector(3 downto 0);
		data_pkt_ccd_number_i             : in  std_logic_vector(1 downto 0);
		data_pkt_protocol_id_i            : in  std_logic_vector(7 downto 0);
		data_pkt_logical_addr_i           : in  std_logic_vector(7 downto 0);
		-- fee hkdata send buffer control
		hkdata_send_buffer_control_i      : in  t_fee_dpkt_send_buffer_control;
		-- fee hkdata controller status
		hkdataman_finished_o              : out std_logic;
		-- fee hkdata headerdata
		hkdata_headerdata_o               : out t_fee_dpkt_headerdata;
		-- fee housekeeping memory control
		fee_hk_mem_byte_address_o         : out std_logic_vector(31 downto 0);
		fee_hk_mem_read_o                 : out std_logic;
		-- fee hkdata send buffer status
		hkdata_send_buffer_status_o       : out t_fee_dpkt_send_buffer_status;
		hkdata_send_double_buffer_empty_o : out std_logic
	);
end entity fee_hkdata_controller_top;

architecture RTL of fee_hkdata_controller_top is

	-- general signals
	-- header generator signals
	signal s_header_gen_status                  : t_fee_dpkt_general_status;
	signal s_header_gen_control                 : t_fee_dpkt_general_control;
	signal s_header_gen_headerdata              : t_fee_dpkt_headerdata;
	signal s_send_buffer_header_gen_wrdata      : std_logic_vector(7 downto 0);
	signal s_send_buffer_header_gen_wrreq       : std_logic;
	-- housekeeping writer signals
	signal s_housekeeping_wr_status             : t_fee_dpkt_general_status;
	signal s_housekeeping_wr_control            : t_fee_dpkt_general_control;
	signal s_send_buffer_housekeeping_wr_wrdata : std_logic_vector(7 downto 0);
	signal s_send_buffer_housekeeping_wr_wrreq  : std_logic;
	-- send buffer signals
	signal s_send_buffer_fee_data_loaded        : std_logic;
	signal s_send_buffer_wrdata                 : std_logic_vector(7 downto 0);
	signal s_send_buffer_wrreq                  : std_logic;
	signal s_send_buffer_stat_full              : std_logic;
	signal s_send_buffer_wrready                : std_logic;
	signal s_send_buffer_data_type_wrdata       : std_logic_vector(1 downto 0);
	signal s_send_buffer_data_type_wrreq        : std_logic;
	signal s_send_buffer_data_end_wrdata        : std_logic;
	signal s_send_buffer_data_end_wrreq         : std_logic;

begin

	-- fee housekeeping data manager instantiation
	fee_hkdata_manager_ent_inst : entity work.fee_hkdata_manager_ent
		port map(
			clk_i                         => clk_i,
			rst_i                         => rst_i,
			fee_clear_signal_i            => fee_machine_clear_i,
			fee_stop_signal_i             => fee_machine_stop_i,
			fee_start_signal_i            => fee_machine_start_i,
			fee_manager_hk_only_i         => fee_manager_hk_only_i,
			current_frame_number_i        => fee_current_frame_number_i,
			current_frame_counter_i       => fee_current_frame_counter_i,
			fee_logical_addr_i            => data_pkt_logical_addr_i,
			fee_protocol_id_i             => data_pkt_protocol_id_i,
			fee_packet_length_i           => data_pkt_packet_length_i,
			fee_fee_mode_i                => data_pkt_fee_mode_i,
			fee_ccd_number_i              => data_pkt_ccd_number_i,
			fee_ccd_side_i                => fee_ccd_side_i,
			hkdata_manager_i.start        => hkdataman_start_i,
			hkdata_manager_i.reset        => hkdataman_reset_i,
			header_gen_i                  => s_header_gen_status,
			housekeeping_wr_i             => s_housekeeping_wr_status,
			hkdata_manager_o.finished     => hkdataman_finished_o,
			headerdata_o                  => s_header_gen_headerdata,
			header_gen_o                  => s_header_gen_control,
			housekeeping_wr_o             => s_housekeeping_wr_control,
			send_buffer_fee_data_loaded_o => s_send_buffer_fee_data_loaded
		);

	-- data packet header generator instantiation
	data_packet_header_gen_ent_inst : entity work.data_packet_header_gen_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			header_gen_send_i              => s_header_gen_control.start,
			header_gen_reset_i             => s_header_gen_control.reset,
			headerdata_i                   => s_header_gen_headerdata,
			send_buffer_stat_almost_full_i => '0',
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			header_gen_finished_o          => s_header_gen_status.finished,
			send_buffer_wrdata_o           => s_send_buffer_header_gen_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_header_gen_wrreq,
			send_buffer_data_type_wrdata_o => s_send_buffer_data_type_wrdata,
			send_buffer_data_type_wrreq_o  => s_send_buffer_data_type_wrreq
		);

	-- data packet housekeeping writer instantiation
	data_packet_hk_writer_ent_inst : entity work.data_packet_hk_writer_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			fee_clear_signal_i             => fee_machine_clear_i,
			fee_stop_signal_i              => fee_machine_stop_i,
			fee_start_signal_i             => fee_machine_start_i,
			housekeeping_wr_start_i        => s_housekeeping_wr_control.start,
			housekeeping_wr_reset_i        => s_housekeeping_wr_control.reset,
			hk_mem_waitrequest_i           => fee_hk_mem_waitrequest_i,
			hk_mem_data_i                  => fee_hk_mem_data_i,
			send_buffer_stat_almost_full_i => '0',
			send_buffer_stat_full_i        => s_send_buffer_stat_full,
			send_buffer_wrready_i          => s_send_buffer_wrready,
			housekeeping_wr_busy_o         => open,
			housekeeping_wr_finished_o     => s_housekeeping_wr_status.finished,
			hk_mem_byte_address_o          => fee_hk_mem_byte_address_o,
			hk_mem_read_o                  => fee_hk_mem_read_o,
			send_buffer_wrdata_o           => s_send_buffer_housekeeping_wr_wrdata,
			send_buffer_wrreq_o            => s_send_buffer_housekeeping_wr_wrreq,
			send_buffer_data_end_wrdata_o  => s_send_buffer_data_end_wrdata,
			send_buffer_data_end_wrreq_o   => s_send_buffer_data_end_wrreq
		);

	-- send buffer instantiation
	send_buffer_ent_inst : entity work.send_buffer_ent
		generic map(
			g_1K_SEND_BUFFER_SIZE => '1' -- '0' : 32 KiB of send buffer / '1' : 1 KiB of send buffer
		)
		port map(
			clk_i                        => clk_i,
			rst_i                        => rst_i,
			fee_clear_signal_i           => fee_machine_clear_i,
			fee_stop_signal_i            => fee_machine_stop_i,
			fee_start_signal_i           => fee_machine_start_i,
			fee_data_loaded_i            => s_send_buffer_fee_data_loaded,
			buffer_cfg_length_i          => data_pkt_packet_length_i,
			buffer_wrdata_i              => s_send_buffer_wrdata,
			buffer_wrreq_i               => s_send_buffer_wrreq,
			buffer_rdreq_i               => hkdata_send_buffer_control_i.rdreq,
			buffer_change_i              => hkdata_send_buffer_control_i.change,
			data_type_wrdata_i           => s_send_buffer_data_type_wrdata,
			data_type_wrreq_i            => s_send_buffer_data_type_wrreq,
			data_end_wrdata_i            => s_send_buffer_data_end_wrdata,
			data_end_wrreq_i             => s_send_buffer_data_end_wrreq,
			buffer_stat_almost_empty_o   => open,
			buffer_stat_almost_full_o    => open,
			buffer_stat_empty_o          => hkdata_send_buffer_status_o.stat_empty,
			buffer_stat_extended_usedw_o => hkdata_send_buffer_status_o.stat_extended_usedw,
			buffer_stat_full_o           => s_send_buffer_stat_full,
			buffer_rddata_o              => hkdata_send_buffer_status_o.rddata,
			buffer_rdready_o             => hkdata_send_buffer_status_o.rdready,
			buffer_wrready_o             => s_send_buffer_wrready,
			data_type_rddata_o           => hkdata_send_buffer_status_o.rddata_type,
			data_end_rddata_o            => hkdata_send_buffer_status_o.rddata_end,
			double_buffer_empty_o        => hkdata_send_double_buffer_empty_o,
			double_buffer_wrable_o       => open
		);
	s_send_buffer_wrdata <= (s_send_buffer_header_gen_wrdata) or (s_send_buffer_housekeeping_wr_wrdata);
	s_send_buffer_wrreq  <= (s_send_buffer_header_gen_wrreq) or (s_send_buffer_housekeeping_wr_wrreq);

	-- signals assingments
	hkdata_headerdata_o <= s_header_gen_headerdata;

end architecture RTL;
