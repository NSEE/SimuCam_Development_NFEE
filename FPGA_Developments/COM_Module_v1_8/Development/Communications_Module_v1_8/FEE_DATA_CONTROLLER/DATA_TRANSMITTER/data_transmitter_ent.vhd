library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity data_transmitter_ent is
	port(
		clk_i                                 : in  std_logic;
		rst_i                                 : in  std_logic;
		-- general inputs
		fee_clear_signal_i                    : in  std_logic;
		fee_stop_signal_i                     : in  std_logic;
		fee_start_signal_i                    : in  std_logic;
		-- others
		send_buffer_cfg_length_i              : in  std_logic_vector(15 downto 0);
		hkdata_send_buffer_status_i           : in  t_fee_dpkt_send_buffer_status;
		hkdata_send_buffer_data_type_i        : in  std_logic_vector(1 downto 0);
		left_imgdata_send_buffer_status_i     : in  t_fee_dpkt_send_buffer_status;
		left_imgdata_send_buffer_data_type_i  : in  std_logic_vector(1 downto 0);
		left_imgdata_send_buffer_data_end_i   : in  std_logic;
		right_imgdata_send_buffer_status_i    : in  t_fee_dpkt_send_buffer_status;
		right_imgdata_send_buffer_data_type_i : in  std_logic_vector(1 downto 0);
		right_imgdata_send_buffer_data_end_i  : in  std_logic;
		spw_tx_ready_i                        : in  std_logic;
		windowing_enabled_i                   : in  std_logic;
		windowing_packet_order_list_i         : in  std_logic_vector(511 downto 0);
		windowing_last_left_packet_i          : in  std_logic_vector(9 downto 0);
		windowing_last_right_packet_i         : in  std_logic_vector(9 downto 0);
		data_transmitter_busy_o               : out std_logic;
		data_transmitter_finished_o           : out std_logic;
		hkdata_send_buffer_control_o          : out t_fee_dpkt_send_buffer_control;
		left_imgdata_send_buffer_control_o    : out t_fee_dpkt_send_buffer_control;
		right_imgdata_send_buffer_control_o   : out t_fee_dpkt_send_buffer_control;
		spw_tx_write_o                        : out std_logic;
		spw_tx_flag_o                         : out std_logic;
		spw_tx_data_o                         : out std_logic_vector(7 downto 0)
	);
end entity data_transmitter_ent;

architecture RTL of data_transmitter_ent is

	constant c_PKT_HEADER_LOGICAL_ADDR     : natural range 0 to 9 := 0;
	constant c_PKT_HEADER_PROTOCOL_ID      : natural range 0 to 9 := 1;
	constant c_PKT_HEADER_LENGTH_MSB       : natural range 0 to 9 := 2;
	constant c_PKT_HEADER_LENGTH_LSB       : natural range 0 to 9 := 3;
	constant c_PKT_HEADER_TYPE_MSB         : natural range 0 to 9 := 4;
	constant c_PKT_HEADER_TYPE_LSB         : natural range 0 to 9 := 5;
	constant c_PKT_HEADER_FRAME_CNT_MSB    : natural range 0 to 9 := 6;
	constant c_PKT_HEADER_FRAME_CNT_LSB    : natural range 0 to 9 := 7;
	constant c_PKT_HEADER_SEQUENCE_CNT_MSB : natural range 0 to 9 := 8;
	constant c_PKT_HEADER_SEQUENCE_CNT_LSB : natural range 0 to 9 := 9;

	constant c_PKT_HEADER_SIZE : std_logic_vector((left_imgdata_send_buffer_status_i.stat_extended_usedw'length - 1) downto 0) := x"000A";

	type t_data_transmitter_fsm is (
		STOPPED,
		IDLE,
		WAITING_DATA_BUFFER_SPACE,
		FETCH_DATA,
		DELAY,
		TRANSMIT_DATA,
		WAITING_EOP_BUFFER_SPACE,
		TRANSMIT_EOP,
		DATA_TRANSMITTER_FINISH,
		WAITING_EEP_BUFFER_SPACE,
		TRANSMIT_EEP
	);
	signal s_data_transmitter_state : t_data_transmitter_fsm; -- current state

	-- header counter
	signal s_header_cnt   : natural range 0 to 10;
	signal s_last_packet  : std_logic;
	signal s_data_length  : std_logic_vector(15 downto 0);
	signal s_sequence_cnt : std_logic_vector(15 downto 0);

	-- discard data	
	signal s_discard_data : std_logic;

	-- windowing counters
	subtype t_packet_order_list_cnt is natural range 0 to (windowing_packet_order_list_i'length);
	signal s_packet_order_list_cnt : t_packet_order_list_cnt;
	signal s_left_packet_cnt       : std_logic_vector((windowing_last_left_packet_i'length - 1) downto 0);
	signal s_right_packet_cnt      : std_logic_vector((windowing_last_right_packet_i'length - 1) downto 0);

begin

	p_data_transmitter_FSM : process(clk_i, rst_i)
		variable v_data_transmitter_state : t_data_transmitter_fsm := IDLE; -- current state
		variable v_hkdata_active          : std_logic;
		variable v_left_imgdata_active    : std_logic;
		variable v_right_imgdata_active   : std_logic;
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_data_transmitter_state                   <= STOPPED;
			v_data_transmitter_state                   := STOPPED;
			s_header_cnt                               <= 0;
			s_last_packet                              <= '0';
			s_data_length                              <= (others => '0');
			s_sequence_cnt                             <= (others => '0');
			s_discard_data                             <= '0';
			s_packet_order_list_cnt                    <= 0;
			s_left_packet_cnt                          <= (others => '0');
			s_right_packet_cnt                         <= (others => '0');
			v_hkdata_active                            := '0';
			v_left_imgdata_active                      := '0';
			v_right_imgdata_active                     := '0';
			-- Outputs Generation
			data_transmitter_busy_o                    <= '0';
			data_transmitter_finished_o                <= '0';
			hkdata_send_buffer_control_o.rdreq         <= '0';
			left_imgdata_send_buffer_control_o.rdreq   <= '0';
			right_imgdata_send_buffer_control_o.rdreq  <= '0';
			spw_tx_write_o                             <= '0';
			spw_tx_flag_o                              <= '0';
			spw_tx_data_o                              <= x"00";
			hkdata_send_buffer_control_o.change        <= '0';
			left_imgdata_send_buffer_control_o.change  <= '0';
			right_imgdata_send_buffer_control_o.change <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_transmitter_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_transmitter_state                   <= STOPPED;
					v_data_transmitter_state                   := STOPPED;
					s_header_cnt                               <= 0;
					s_last_packet                              <= '0';
					s_data_length                              <= (others => '0');
					s_sequence_cnt                             <= (others => '0');
					s_discard_data                             <= '0';
					s_packet_order_list_cnt                    <= 0;
					s_left_packet_cnt                          <= (others => '0');
					s_right_packet_cnt                         <= (others => '0');
					v_hkdata_active                            := '0';
					v_left_imgdata_active                      := '0';
					v_right_imgdata_active                     := '0';
					-- Outputs Generation
					data_transmitter_busy_o                    <= '0';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_data_transmitter_state <= IDLE;
						v_data_transmitter_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the send buffer signals that is ready to be read
					-- default state transition
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;
					s_header_cnt             <= 0;
					s_last_packet            <= '0';
					s_data_length            <= (others => '0');
					s_discard_data           <= '0';
					v_hkdata_active          := '0';
					v_left_imgdata_active    := '0';
					v_right_imgdata_active   := '0';
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the hkdata send buffer is ready to be read
					if (hkdata_send_buffer_status_i.rdready = '1') then
						-- hkdata send buffer ready to be read
						-- activate hk data source
						v_hkdata_active          := '1';
						-- check if the packet is only a header (not be transmitted)
						if (c_PKT_HEADER_SIZE = hkdata_send_buffer_status_i.stat_extended_usedw) then
							-- set data to be discarded
							s_discard_data <= '1';
						end if;
						-- update packet information
						if (send_buffer_cfg_length_i /= hkdata_send_buffer_status_i.stat_extended_usedw) then
							s_last_packet <= '1';
						end if;
						s_data_length            <= std_logic_vector(unsigned(hkdata_send_buffer_status_i.stat_extended_usedw) - 10);
						-- go to fetch data, then waiting data buffer space 
						s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
						v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					else
						-- hkdata send buffer is not ready to be read
						-- check if the windowing is disabled
						if (windowing_enabled_i = '0') then
							-- windowing disabled, full-image operation
							-- check if the left imgdata send buffer is ready to be read
							if (left_imgdata_send_buffer_status_i.rdready = '1') then
								-- left imgdata send buffer ready to be read
								-- activate left img data source
								v_left_imgdata_active    := '1';
								-- check if the packet is only a header (not be transmitted)
								if (c_PKT_HEADER_SIZE = left_imgdata_send_buffer_status_i.stat_extended_usedw) then
									-- set data to be discarded
									s_discard_data <= '1';
								end if;
								-- update packet information
								if ((send_buffer_cfg_length_i /= left_imgdata_send_buffer_status_i.stat_extended_usedw) or (left_imgdata_send_buffer_data_end_i = '1')) then
									s_last_packet <= '1';
								end if;
								s_data_length            <= std_logic_vector(unsigned(left_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
								-- go to fetch data, then waiting data buffer space 
								s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
								v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
							-- check if the right imgdata send buffer is ready to be read
							elsif (right_imgdata_send_buffer_status_i.rdready = '1') then
								-- right imgdata send buffer ready to be read
								-- activate right img data source
								v_right_imgdata_active   := '1';
								-- check if the packet is only a header (not be transmitted)
								if (c_PKT_HEADER_SIZE = right_imgdata_send_buffer_status_i.stat_extended_usedw) then
									-- set data to be discarded
									s_discard_data <= '1';
								end if;
								-- update packet information
								if ((send_buffer_cfg_length_i /= right_imgdata_send_buffer_status_i.stat_extended_usedw) or (right_imgdata_send_buffer_data_end_i = '1')) then
									s_last_packet <= '1';
								end if;
								s_data_length            <= std_logic_vector(unsigned(right_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
								-- go to fetch data, then waiting data buffer space 
								s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
								v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
							end if;
						else
							-- windowing enabled, windowing operation
							-- check if there are more packets to be transmitted (packet order list has not reached the end)
							if (s_packet_order_list_cnt < t_packet_order_list_cnt'high) then
								-- there are more packets to be transmitted (packet order list has not reached the end)
								-- check if the packet order list index is for a left side
								if (windowing_packet_order_list_i(511 - s_packet_order_list_cnt) = c_PKTORDER_LEFT_PACKET) then
									-- packet order list index is for a left side
									-- check if the last left packet was reached or the buffer is filled with overscan data
									if ((s_left_packet_cnt = windowing_last_left_packet_i) or ((left_imgdata_send_buffer_status_i.rdready = '1') and (left_imgdata_send_buffer_data_type_i = c_OVERSCAN_DATA))) then
										-- last left packet was reached or the buffer is filled with overscan data, skip left packet
										-- increment packet order list index
										s_packet_order_list_cnt <= s_packet_order_list_cnt + 1;
									else
										-- last left packet was not reached, send left packet
										-- check if the left imgdata send buffer is ready to be read
										if (left_imgdata_send_buffer_status_i.rdready = '1') then
											-- left imgdata send buffer ready to be read
											-- check if imgdata content is data or overscan
											if (left_imgdata_send_buffer_data_type_i = c_DATA_PACKET) then
												-- imgdata content is data, send packet
												-- activate left img data source
												v_left_imgdata_active    := '1';
												-- check if the packet is only a header (not be transmitted)
												if (c_PKT_HEADER_SIZE = left_imgdata_send_buffer_status_i.stat_extended_usedw) then
													-- set data to be discarded
													s_discard_data <= '1';
												end if;
												-- update packet information
												if ((send_buffer_cfg_length_i /= left_imgdata_send_buffer_status_i.stat_extended_usedw) or (left_imgdata_send_buffer_data_end_i = '1')) then
													s_last_packet <= '1';
												end if;
												s_data_length            <= std_logic_vector(unsigned(left_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
												-- go to fetch data, then waiting data buffer space 
												s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
												v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
												-- increment packet order list index and left packet counter
												s_packet_order_list_cnt  <= s_packet_order_list_cnt + 1;
												s_left_packet_cnt        <= std_logic_vector(unsigned(s_left_packet_cnt) + 1);
											else
												-- imgdata content is overscan, skip packet
												-- increment packet order list index
												s_packet_order_list_cnt <= s_packet_order_list_cnt + 1;
											end if;
										end if;
									end if;
								else
									-- packet order list index is for a right side
									-- check if the last right packet was reached or the buffer is filled with overscan data
									if ((s_right_packet_cnt = windowing_last_right_packet_i) or ((right_imgdata_send_buffer_status_i.rdready = '1') and (right_imgdata_send_buffer_data_type_i = c_OVERSCAN_DATA))) then
										-- last right packet was reached or the buffer is filled with overscan data, skip right packet
										-- increment packet order list index
										s_packet_order_list_cnt <= s_packet_order_list_cnt + 1;
									else
										-- last right packet was not reached, send right packet
										-- check if imgdata content is data or overscan
										if (right_imgdata_send_buffer_data_type_i = c_DATA_PACKET) then
											-- imgdata content is data, send packet
											-- check if the right imgdata send buffer is ready to be read
											if (right_imgdata_send_buffer_status_i.rdready = '1') then
												-- right imgdata send buffer ready to be read
												-- activate right img data source
												v_right_imgdata_active   := '1';
												-- check if the packet is only a header (not be transmitted)
												if (c_PKT_HEADER_SIZE = right_imgdata_send_buffer_status_i.stat_extended_usedw) then
													-- set data to be discarded
													s_discard_data <= '1';
												end if;
												-- update packet information
												if ((send_buffer_cfg_length_i /= right_imgdata_send_buffer_status_i.stat_extended_usedw) or (right_imgdata_send_buffer_data_end_i = '1')) then
													s_last_packet <= '1';
												end if;
												s_data_length            <= std_logic_vector(unsigned(right_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
												-- go to fetch data, then waiting data buffer space 
												s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
												v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
												-- increment packet order list index and right packet counter
												s_packet_order_list_cnt  <= s_packet_order_list_cnt + 1;
												s_right_packet_cnt       <= std_logic_vector(unsigned(s_right_packet_cnt) + 1);
											else
												-- imgdata content is overscan, skip packet
												-- increment packet order list index
												s_packet_order_list_cnt <= s_packet_order_list_cnt + 1;
											end if;
										end if;
									end if;
								end if;
							else
								-- no more packets to be transmitted (packet order list has not reached the end). Overscan packets will be transmitted
								-- check if the left imgdata send buffer is ready to be read
								if (left_imgdata_send_buffer_status_i.rdready = '1') then
									-- left imgdata send buffer ready to be read
									-- activate left img data source
									v_left_imgdata_active    := '1';
									-- check if the packet is only a header (not be transmitted)
									if (c_PKT_HEADER_SIZE = left_imgdata_send_buffer_status_i.stat_extended_usedw) then
										-- set data to be discarded
										s_discard_data <= '1';
									end if;
									-- check if imgdata content is data
									if (left_imgdata_send_buffer_data_type_i = c_DATA_PACKET) then
										-- imgdata content is data, discard packet
										s_discard_data <= '1';
									end if;
									-- update packet information
									if ((send_buffer_cfg_length_i /= left_imgdata_send_buffer_status_i.stat_extended_usedw) or (left_imgdata_send_buffer_data_end_i = '1')) then
										s_last_packet <= '1';
									end if;
									s_data_length            <= std_logic_vector(unsigned(left_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
									-- go to fetch data, then waiting data buffer space 
									s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
									v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
								-- check if the right imgdata send buffer is ready to be read
								elsif (right_imgdata_send_buffer_status_i.rdready = '1') then
									-- right imgdata send buffer ready to be read
									-- activate right img data source
									v_right_imgdata_active   := '1';
									-- check if the packet is only a header (not be transmitted)
									if (c_PKT_HEADER_SIZE = right_imgdata_send_buffer_status_i.stat_extended_usedw) then
										-- set data to be discarded
										s_discard_data <= '1';
									end if;
									-- check if imgdata content is data
									if (right_imgdata_send_buffer_data_type_i = c_DATA_PACKET) then
										-- imgdata content is data, discard packet
										s_discard_data <= '1';
									end if;
									-- update packet information
									if ((send_buffer_cfg_length_i /= right_imgdata_send_buffer_status_i.stat_extended_usedw) or (right_imgdata_send_buffer_data_end_i = '1')) then
										s_last_packet <= '1';
									end if;
									s_data_length            <= std_logic_vector(unsigned(right_imgdata_send_buffer_status_i.stat_extended_usedw) - 10);
									-- go to fetch data, then waiting data buffer space 
									s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
									v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
								end if;
							end if;
						end if;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_DATA_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for data and there is data available
					-- default state transition
					s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if hk data source is active
					if (v_hkdata_active = '1') then
						-- check if tx buffer can receive data and hkdata send buffer is ready for read and is not empty
						if ((spw_tx_ready_i = '1') and (hkdata_send_buffer_status_i.rdready = '1') and (hkdata_send_buffer_status_i.stat_empty = '0')) then
							-- tx buffer can receive data
							-- go to transmit data
							s_data_transmitter_state <= FETCH_DATA;
							v_data_transmitter_state := FETCH_DATA;
						-- check if the hkdata send buffer is empty
						elsif (hkdata_send_buffer_status_i.stat_empty = '1') then
							-- hkdata send buffer empty, go to waiting eop buffer space
							s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
							v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
						end if;
					-- check if left img data source is active
					elsif (v_left_imgdata_active = '1') then
						-- check if tx buffer can receive data and left imgdata send buffer is ready for read and is not empty
						if ((spw_tx_ready_i = '1') and (left_imgdata_send_buffer_status_i.rdready = '1') and (left_imgdata_send_buffer_status_i.stat_empty = '0')) then
							-- tx buffer can receive data
							-- go to transmit data
							s_data_transmitter_state <= FETCH_DATA;
							v_data_transmitter_state := FETCH_DATA;
						-- check if the left imgdata send buffer is empty
						elsif (left_imgdata_send_buffer_status_i.stat_empty = '1') then
							-- left imgdata send buffer empty, go to waiting eop buffer space
							s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
							v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
						end if;
					-- check if right img data source is active
					elsif (v_right_imgdata_active = '1') then
						-- check if tx buffer can receive data and right imgdata send buffer is ready for read and is not empty
						if ((spw_tx_ready_i = '1') and (right_imgdata_send_buffer_status_i.rdready = '1') and (right_imgdata_send_buffer_status_i.stat_empty = '0')) then
							-- tx buffer can receive data
							-- go to transmit data
							s_data_transmitter_state <= FETCH_DATA;
							v_data_transmitter_state := FETCH_DATA;
						-- check if the right imgdata send buffer is empty
						elsif (right_imgdata_send_buffer_status_i.stat_empty = '1') then
							-- right imgdata send buffer empty, go to waiting eop buffer space
							s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
							v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
						end if;
					else
						-- no data source selected, go to stopped 
						s_data_transmitter_state <= STOPPED;
						v_data_transmitter_state := STOPPED;
					end if;

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the send buffer
					-- default state transition
					s_data_transmitter_state <= DELAY;
					v_data_transmitter_state := DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "DELAY"
				when DELAY =>
					-- default state transition
					s_data_transmitter_state <= DELAY;
					v_data_transmitter_state := DELAY;
					-- default internal signal values
					-- conditional state transition
					-- check if spw codec can receive data
					if (spw_tx_ready_i = '1') then
						-- spw codec can receive data
						s_data_transmitter_state <= TRANSMIT_DATA;
						v_data_transmitter_state := TRANSMIT_DATA;
					end if;

				-- state "TRANSMIT_DATA"
				when TRANSMIT_DATA =>
					-- transmit data from the send buffer to the spw codec
					-- default state transition
					s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the header counter need to be updated
					if (s_header_cnt < 10) then
						s_header_cnt <= s_header_cnt + 1;
					end if;

				-- state "WAITING_EOP_BUFFER_SPACE"
				when WAITING_EOP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eop
					-- default state transition
					s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_tx_ready_i = '1') then
						-- tx buffer can receive data
						-- go to transmit data
						s_data_transmitter_state <= TRANSMIT_EOP;
						v_data_transmitter_state := TRANSMIT_EOP;
					end if;

				-- state "TRANSMIT_EOP"
				when TRANSMIT_EOP =>
					-- transmit eop to the spw codec
					-- default state transition
					s_data_transmitter_state <= DATA_TRANSMITTER_FINISH;
					v_data_transmitter_state := DATA_TRANSMITTER_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "DATA_TRANSMITTER_FINISH"
				when DATA_TRANSMITTER_FINISH =>
					-- finish data transmitter
					-- default state transition
					s_data_transmitter_state <= DATA_TRANSMITTER_FINISH;
					v_data_transmitter_state := DATA_TRANSMITTER_FINISH;
					-- default internal signal values
					v_hkdata_active          := '0';
					v_left_imgdata_active    := '0';
					v_right_imgdata_active   := '0';
					-- check if the data was not discarded
					if (s_discard_data = '0') then
						-- data was not discarded, increment sequence counter
						-- check if sequence counter will overflow
						if (s_sequence_cnt = x"FFFF") then
							-- sequence counter will overflow
							-- clear sequence counter
							s_sequence_cnt <= (others => '0');
						else
							-- sequence counter will not overflow
							-- increment sequence counter
							s_sequence_cnt <= std_logic_vector(unsigned(s_sequence_cnt) + 1);
						end if;
					end if;
					-- conditional state transition and internal signal values
					-- check if a data transmitter reset was requested
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;

				-- state "WAITING_EEP_BUFFER_SPACE"
				when WAITING_EEP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eep
					-- default state transition
					s_data_transmitter_state <= WAITING_EEP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EEP_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_tx_ready_i = '1') then
						-- tx buffer can receive data
						-- go to transmit data
						s_data_transmitter_state <= TRANSMIT_EEP;
						v_data_transmitter_state := TRANSMIT_EEP;
					end if;

				-- state "TRANSMIT_EEP"
				when TRANSMIT_EEP =>
					-- transmit eep to the spw codec
					-- default state transition
					s_data_transmitter_state <= STOPPED;
					v_data_transmitter_state := STOPPED;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;

			end case;

			-- output generation
			case (v_data_transmitter_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the send buffer signals that is ready to be read
					-- reset outputs
					-- default output signals
					data_transmitter_busy_o                    <= '0';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "WAITING_DATA_BUFFER_SPACE"
				when WAITING_DATA_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for data and there is data available
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- clear spw tx write signal
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the send buffer
					-- reset outputs
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					-- fetch data from send buffer
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- check if hk data source is active
					if (v_hkdata_active = '1') then
						hkdata_send_buffer_control_o.rdreq <= '1';
					-- check if left img data source is active
					elsif (v_left_imgdata_active = '1') then
						left_imgdata_send_buffer_control_o.rdreq <= '1';
					-- check if right img data source is active
					elsif (v_right_imgdata_active = '1') then
						right_imgdata_send_buffer_control_o.rdreq <= '1';
					end if;
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "DELAY"
				when DELAY =>
					-- default state transition
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					-- fetch data from send buffer
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- default internal signal values
				-- conditional state transition

				-- state "TRANSMIT_DATA"
				when TRANSMIT_DATA =>
					-- transmit data from the send buffer to the spw codec
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- clear spw flag (to indicate a data)
					spw_tx_flag_o                              <= '0';
					-- fill spw data with field data
					spw_tx_data_o                              <= (others => '0');
					-- check if hk data source is active
					if (v_hkdata_active = '1') then
						spw_tx_data_o <= hkdata_send_buffer_status_i.rddata;
					-- check if left img data source is active
					elsif (v_left_imgdata_active = '1') then
						spw_tx_data_o <= left_imgdata_send_buffer_status_i.rddata;
					-- check if right img data source is active
					elsif (v_right_imgdata_active = '1') then
						spw_tx_data_o <= right_imgdata_send_buffer_status_i.rddata;
					end if;
					-- write the spw data
					-- check if data need to be discarded
					if (s_discard_data = '1') then
						spw_tx_write_o <= '0';
					else
						spw_tx_write_o <= '1';
					end if;
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
					-- conditional output signals
					-- check if the transmitted header need to be updated
					if (s_header_cnt = c_PKT_HEADER_LENGTH_MSB) then
						-- header in packet length (msb), length (msb) need to be updated
						spw_tx_data_o <= s_data_length(15 downto 8);
					elsif (s_header_cnt = c_PKT_HEADER_LENGTH_LSB) then
						-- header in packet length (lsb), length (lsb) need to be updated
						spw_tx_data_o <= s_data_length(7 downto 0);
					elsif (s_header_cnt = c_PKT_HEADER_TYPE_LSB) then
						-- header in packet type (lsb), last packet to be updated
						spw_tx_data_o(7) <= s_last_packet;
					elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_MSB) then
						-- header in sequence counter (msb), sequence counter (msb) to be updated
						spw_tx_data_o <= s_sequence_cnt(15 downto 8);
					elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_LSB) then
						-- header in sequence counter (lsb), sequence counter (lsb) to be updated
						spw_tx_data_o <= s_sequence_cnt(7 downto 0);
					end if;

				-- state "WAITING_EOP_BUFFER_SPACE"
				when WAITING_EOP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eop
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- clear spw tx write signal
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "TRANSMIT_EOP"
				when TRANSMIT_EOP =>
					-- transmit eop to the spw codec
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- set spw flag (to indicate a package end)
					spw_tx_flag_o                              <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_tx_data_o                              <= x"00";
					-- write the spw data
					-- check if data need to be discarded
					if (s_discard_data = '1') then
						spw_tx_write_o <= '0';
					else
						spw_tx_write_o <= '1';
					end if;
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "DATA_TRANSMITTER_FINISH"
				when DATA_TRANSMITTER_FINISH =>
					-- finish data transmitter
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					-- indicate that the data transmitter is finished
					data_transmitter_finished_o                <= '1';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
					-- check if hk data source is active
					if (v_hkdata_active = '1') then
						hkdata_send_buffer_control_o.change <= '1';
					-- check if left img data source is active
					elsif (v_left_imgdata_active = '1') then
						left_imgdata_send_buffer_control_o.change <= '1';
					-- check if right img data source is active
					elsif (v_right_imgdata_active = '1') then
						right_imgdata_send_buffer_control_o.change <= '1';
					end if;
				-- conditional output signals

				-- state "WAITING_EEP_BUFFER_SPACE"
				when WAITING_EEP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eep
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- clear spw tx write signal
					spw_tx_write_o                             <= '0';
					spw_tx_flag_o                              <= '0';
					spw_tx_data_o                              <= x"00";
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- state "TRANSMIT_EEP"
				when TRANSMIT_EEP =>
					-- transmit eep to the spw codec
					-- default output signals
					data_transmitter_busy_o                    <= '1';
					data_transmitter_finished_o                <= '0';
					hkdata_send_buffer_control_o.rdreq         <= '0';
					left_imgdata_send_buffer_control_o.rdreq   <= '0';
					right_imgdata_send_buffer_control_o.rdreq  <= '0';
					-- set spw flag (to indicate a package end)
					spw_tx_flag_o                              <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_tx_data_o                              <= x"01";
					-- write the spw data
					spw_tx_write_o                             <= '1';
					hkdata_send_buffer_control_o.change        <= '0';
					left_imgdata_send_buffer_control_o.change  <= '0';
					right_imgdata_send_buffer_control_o.change <= '0';
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				-- check if the transmitter is in the middle of a transmission (have the spw mux access rights)
				if ((s_data_transmitter_state /= STOPPED) and (s_data_transmitter_state /= IDLE) and (s_data_transmitter_state /= DATA_TRANSMITTER_FINISH)) then
					-- transmit and eep to release the spw mux and indicate an error
					s_data_transmitter_state <= WAITING_EEP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EEP_BUFFER_SPACE;
				else
					-- no need to release the spw mux and indicate an erro, go to stopped
					s_data_transmitter_state <= STOPPED;
					v_data_transmitter_state := STOPPED;
				end if;
			end if;

		end if;
	end process p_data_transmitter_FSM;

end architecture RTL;
