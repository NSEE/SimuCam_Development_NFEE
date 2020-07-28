library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;
use work.comm_data_transmitter_pkg.all;

entity comm_data_transmitter_top is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		comm_stop_i                    : in  std_logic;
		comm_start_i                   : in  std_logic;
		channel_sync_i                 : in  std_logic;
		send_buffer_cfg_length_i       : in  std_logic_vector(15 downto 0);
		send_buffer_hkdata_status_i    : in  t_fee_dpkt_send_buffer_status;
		send_buffer_leftimg_status_i   : in  t_fee_dpkt_send_buffer_status;
		send_buffer_rightimg_status_i  : in  t_fee_dpkt_send_buffer_status;
		spw_tx_ready_i                 : in  std_logic;
		housekeep_only_i               : in  std_logic;
		windowing_enabled_i            : in  std_logic;
		windowing_packet_order_list_i  : in  std_logic_vector(511 downto 0);
		windowing_last_left_packet_i   : in  std_logic_vector(9 downto 0);
		windowing_last_right_packet_i  : in  std_logic_vector(9 downto 0);
		send_buffer_hkdata_control_o   : out t_fee_dpkt_send_buffer_control;
		send_buffer_leftimg_control_o  : out t_fee_dpkt_send_buffer_control;
		send_buffer_rightimg_control_o : out t_fee_dpkt_send_buffer_control;
		spw_tx_flag_o                  : out std_logic;
		spw_tx_data_o                  : out std_logic_vector(7 downto 0);
		spw_tx_write_o                 : out std_logic
	);
end entity comm_data_transmitter_top;

architecture RTL of comm_data_transmitter_top is

	-- comm data transmitter housekeep signals 
	signal s_data_trans_housekeep_status  : t_comm_data_trans_status;
	signal s_data_trans_housekeep_control : t_comm_data_trans_control;
	signal s_spw_tx_housekeep_control     : t_comm_data_trans_spw_tx_control;

	-- comm data transmitter fullimage signals
	signal s_data_trans_fullimage_status            : t_comm_data_trans_status;
	signal s_data_trans_fullimage_control           : t_comm_data_trans_control;
	signal s_send_buffer_leftimg_fullimage_control  : t_fee_dpkt_send_buffer_control;
	signal s_send_buffer_rightimg_fullimage_control : t_fee_dpkt_send_buffer_control;
	signal s_spw_tx_fullimage_control               : t_comm_data_trans_spw_tx_control;

	-- comm data transmitter windowing signals
	signal s_data_trans_windowing_status            : t_comm_data_trans_status;
	signal s_data_trans_windowing_control           : t_comm_data_trans_control;
	signal s_send_buffer_leftimg_windowing_control  : t_fee_dpkt_send_buffer_control;
	signal s_send_buffer_rightimg_windowing_control : t_fee_dpkt_send_buffer_control;
	signal s_spw_tx_windowing_control               : t_comm_data_trans_spw_tx_control;

begin

	-- comm data transmitter manager instantiation 
	comm_data_transmitter_manager_ent_inst : entity work.comm_data_transmitter_manager_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			comm_stop_i                    => comm_stop_i,
			comm_start_i                   => comm_start_i,
			channel_sync_i                 => channel_sync_i,
			housekeep_only_i               => housekeep_only_i,
			windowing_enabled_i            => windowing_enabled_i,
			data_trans_housekeep_status_i  => s_data_trans_housekeep_status,
			data_trans_fullimage_status_i  => s_data_trans_fullimage_status,
			data_trans_windowing_status_i  => s_data_trans_windowing_status,
			data_trans_housekeep_control_o => s_data_trans_housekeep_control,
			data_trans_fullimage_control_o => s_data_trans_fullimage_control,
			data_trans_windowing_control_o => s_data_trans_windowing_control
		);

	-- comm data transmitter housekeep instantiation
	comm_data_transmitter_housekeep_ent_inst : entity work.comm_data_transmitter_housekeep_ent
		port map(
			clk_i                        => clk_i,
			rst_i                        => rst_i,
			comm_stop_i                  => comm_stop_i,
			comm_start_i                 => comm_start_i,
			data_trans_control_i         => s_data_trans_housekeep_control,
			send_buffer_cfg_length_i     => send_buffer_cfg_length_i,
			send_buffer_hkdata_status_i  => send_buffer_hkdata_status_i,
			spw_tx_status_i.tx_ready     => spw_tx_ready_i,
			data_trans_status_o          => s_data_trans_housekeep_status,
			send_buffer_hkdata_control_o => send_buffer_hkdata_control_o,
			spw_tx_control_o             => s_spw_tx_housekeep_control
		);

	-- comm data transmitter fullimage instantiation
	comm_data_transmitter_fullimage_ent_inst : entity work.comm_data_transmitter_fullimage_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			comm_stop_i                    => comm_stop_i,
			comm_start_i                   => comm_start_i,
			data_trans_control_i           => s_data_trans_fullimage_control,
			send_buffer_cfg_length_i       => send_buffer_cfg_length_i,
			send_buffer_leftimg_status_i   => send_buffer_leftimg_status_i,
			send_buffer_rightimg_status_i  => send_buffer_rightimg_status_i,
			spw_tx_status_i.tx_ready       => spw_tx_ready_i,
			data_trans_status_o            => s_data_trans_fullimage_status,
			send_buffer_leftimg_control_o  => s_send_buffer_leftimg_fullimage_control,
			send_buffer_rightimg_control_o => s_send_buffer_rightimg_fullimage_control,
			spw_tx_control_o               => s_spw_tx_fullimage_control
		);

	-- comm data transmitter windowing instantiation	
	comm_data_transmitter_windowing_ent_inst : entity work.comm_data_transmitter_windowing_ent
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			comm_stop_i                    => comm_stop_i,
			comm_start_i                   => comm_start_i,
			data_trans_control_i           => s_data_trans_windowing_control,
			send_buffer_cfg_length_i       => send_buffer_cfg_length_i,
			send_buffer_leftimg_status_i   => send_buffer_leftimg_status_i,
			send_buffer_rightimg_status_i  => send_buffer_rightimg_status_i,
			windowing_packet_order_list_i  => windowing_packet_order_list_i,
			windowing_last_left_packet_i   => windowing_last_left_packet_i,
			windowing_last_right_packet_i  => windowing_last_right_packet_i,
			spw_tx_status_i.tx_ready       => spw_tx_ready_i,
			data_trans_status_o            => s_data_trans_windowing_status,
			send_buffer_leftimg_control_o  => s_send_buffer_leftimg_windowing_control,
			send_buffer_rightimg_control_o => s_send_buffer_rightimg_windowing_control,
			spw_tx_control_o               => s_spw_tx_windowing_control
		);

	-- signals assignments --

	-- send buffer leftimg signal assignments
	send_buffer_leftimg_control_o.rdreq  <= (s_send_buffer_leftimg_fullimage_control.rdreq) or (s_send_buffer_leftimg_windowing_control.rdreq);
	send_buffer_leftimg_control_o.change <= (s_send_buffer_leftimg_fullimage_control.change) or (s_send_buffer_leftimg_windowing_control.change);

	-- send buffer rightimg signal assignments
	send_buffer_rightimg_control_o.rdreq  <= (s_send_buffer_rightimg_fullimage_control.rdreq) or (s_send_buffer_rightimg_windowing_control.rdreq);
	send_buffer_rightimg_control_o.change <= (s_send_buffer_rightimg_fullimage_control.change) or (s_send_buffer_rightimg_windowing_control.change);

	-- spw tx signals assignments
	spw_tx_flag_o  <= (s_spw_tx_housekeep_control.tx_flag) or (s_spw_tx_fullimage_control.tx_flag) or (s_spw_tx_windowing_control.tx_flag);
	spw_tx_data_o  <= (s_spw_tx_housekeep_control.tx_data) or (s_spw_tx_fullimage_control.tx_data) or (s_spw_tx_windowing_control.tx_data);
	spw_tx_write_o <= (s_spw_tx_housekeep_control.tx_write) or (s_spw_tx_fullimage_control.tx_write) or (s_spw_tx_windowing_control.tx_write);

end architecture RTL;
