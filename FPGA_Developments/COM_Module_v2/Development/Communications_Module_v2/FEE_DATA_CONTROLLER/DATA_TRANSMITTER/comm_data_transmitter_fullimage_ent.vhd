library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;
use work.comm_data_transmitter_pkg.all;

entity comm_data_transmitter_fullimage_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		comm_stop_i                    : in  std_logic;
		comm_start_i                   : in  std_logic;
		data_trans_control_i           : in  t_comm_data_trans_control;
		send_buffer_cfg_length_i       : in  std_logic_vector(15 downto 0);
		send_buffer_leftimg_status_i   : in  t_fee_dpkt_send_buffer_status;
		send_buffer_rightimg_status_i  : in  t_fee_dpkt_send_buffer_status;
		spw_tx_status_i                : in  t_comm_data_trans_spw_tx_status;
		data_trans_status_o            : out t_comm_data_trans_status;
		send_buffer_leftimg_control_o  : out t_fee_dpkt_send_buffer_control;
		send_buffer_rightimg_control_o : out t_fee_dpkt_send_buffer_control;
		spw_tx_control_o               : out t_comm_data_trans_spw_tx_control
	);
end entity comm_data_transmitter_fullimage_ent;

architecture RTL of comm_data_transmitter_fullimage_ent is

	type t_comm_data_transmitter_fullimage_fsm is (
		STOPPED,                        -- data transmitter is stopped
		IDLE,                           -- data transmitter is in idle
		WAITING_FULLIMAGE_READY,        -- wait fullimage buffer to be ready
		WAITING_FULLIMAGE_LEFT_DATA,    -- wait left fullimage buffer to have data
		FETCH_FULLIMAGE_LEFT_DATA,      -- fetch data from left fullimage buffer
		WAITING_SPW_READY_LEFT_DATA,    -- wait spw to be ready for a left data transmission
		TRANSMIT_SPW_LEFT_DATA,         -- transmit left data on the spw
		WAITING_SPW_READY_LEFT_EOP,     -- wait spw to be ready for a left eop transmission
		TRANSMIT_SPW_LEFT_EOP,          -- transmit left eop on the spw
		WAITING_FULLIMAGE_RIGHT_DATA,   -- wait right fullimage buffer to have data
		FETCH_FULLIMAGE_RIGHT_DATA,     -- fetch data from right fullimage buffer
		WAITING_SPW_READY_RIGHT_DATA,   -- wait spw to be ready for a right data transmission
		TRANSMIT_SPW_RIGHT_DATA,        -- transmit right data on the spw
		WAITING_SPW_READY_RIGHT_EOP,    -- wait spw to be ready for a right eop transmission
		TRANSMIT_SPW_RIGHT_EOP,         -- transmit right eop on the spw
		FINISH_DELAY,                   -- data transmitter finish delay (update of internal signals)
		FINISHED,                       -- data transmitter is finished
		WAITING_SPW_READY_EEP,          -- wait spw to be ready for a eep transmission
		TRANSMIT_SPW_EEP                -- transmit eep on the spw
	);

	signal s_comm_data_transmitter_fullimage_state : t_comm_data_transmitter_fullimage_fsm;

	-- header counter
	signal s_header_cnt         : natural range 0 to 10;
	-- header data
	signal s_last_packet        : std_logic;
	signal s_data_length        : std_logic_vector(15 downto 0);
	signal s_sequence_cnt       : std_logic_vector(15 downto 0);
	-- discard data	
	signal s_discard_data       : std_logic;
	-- transmitting
	signal s_left_transmitting  : std_logic;
	signal s_right_transmitting : std_logic;

begin

	p_comm_data_transmitter_fullimage : process(clk_i, rst_i) is
		variable v_comm_data_transmitter_fullimage_state : t_comm_data_transmitter_fullimage_fsm;
	begin
		if (rst_i = '1') then

			-- fsm state reset
			s_comm_data_transmitter_fullimage_state <= STOPPED;
			v_comm_data_transmitter_fullimage_state := STOPPED;

			-- internal signals reset
			s_header_cnt         <= 0;
			s_last_packet        <= '0';
			s_data_length        <= (others => '0');
			s_sequence_cnt       <= (others => '0');
			s_discard_data       <= '0';
			s_left_transmitting  <= '0';
			s_right_transmitting <= '0';

			-- outputs reset
			data_trans_status_o                   <= c_COMM_DATA_TRANS_STATUS_RST;
			send_buffer_leftimg_control_o.rdreq   <= '0';
			send_buffer_leftimg_control_o.change  <= '0';
			send_buffer_rightimg_control_o.rdreq  <= '0';
			send_buffer_rightimg_control_o.change <= '0';
			spw_tx_control_o                      <= c_COMM_DATA_TRANS_SPW_TX_CONTROL_RST;

		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_data_transmitter_fullimage_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter is stopped
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_sequence_cnt                          <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
					-- conditional state transition
					-- check if a start was issued
					if (comm_start_i = '1') then
						-- start issued, go to idle
						s_comm_data_transmitter_fullimage_state <= IDLE;
						v_comm_data_transmitter_fullimage_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- data transmitter is in idle
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= IDLE;
					v_comm_data_transmitter_fullimage_state := IDLE;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_sequence_cnt                          <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
					-- conditional state transition
					-- check if a start transmission was requested
					if (data_trans_control_i.start_transmission = '1') then
						-- a start transmission was requested
						-- set the sequence counter initial value
						s_sequence_cnt                          <= data_trans_control_i.sequence_cnt_init_val;
						-- go to wait fullimage ready
						s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_READY;
						v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_READY;
					end if;

				-- state "WAITING_FULLIMAGE_READY"
				when WAITING_FULLIMAGE_READY =>
					-- wait fullimage buffer to be ready
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_READY;
					v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_READY;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_discard_data                          <= '0';
					-- conditional state transition
					-- check if the left fullimage buffer is ready to be read
					if (send_buffer_leftimg_status_i.rdready = '1') then
						-- left send buffer ready to be read
						-- set transmitting flag
						s_left_transmitting <= '1';
						-- check if the send buffer data is fullimage data
						if ((send_buffer_leftimg_status_i.rddata_type = c_COMM_FFEE_DATA_PACKET) or (send_buffer_leftimg_status_i.rddata_type = c_COMM_FFEE_OVERSCAN_DATA)) then
							-- the send buffer data is fullimage data
							-- write fullimage data operation
							-- check if the packet is only a header (not be transmitted)
							if (send_buffer_leftimg_status_i.stat_extended_usedw = c_PKT_HEADER_SIZE) then
								-- set data to be discarded
								s_discard_data      <= '1';
								-- clear transmitting flag (empty packet, no need to transmit more data after it)
								s_left_transmitting <= '0';
							end if;
							-- update header data
							if ((send_buffer_leftimg_status_i.stat_extended_usedw /= send_buffer_cfg_length_i) or (send_buffer_leftimg_status_i.rddata_end = '1')) then
								s_last_packet       <= '1';
								-- clear transmitting flag (last package, no need to transmit more data after it)
								s_left_transmitting <= '0';
							end if;
							s_data_length                           <= std_logic_vector(unsigned(send_buffer_leftimg_status_i.stat_extended_usedw) - 10);
							-- go to wait fullimage data
							s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_LEFT_DATA;
							v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_LEFT_DATA;
						else
							-- the send buffer data is not fullimage data
							-- fullimage data finished
							-- go to finished
							s_comm_data_transmitter_fullimage_state <= FINISH_DELAY;
							v_comm_data_transmitter_fullimage_state := FINISH_DELAY;
						end if;
					-- check if the right fullimage buffer is ready to be read
					elsif (send_buffer_rightimg_status_i.rdready = '1') then
						-- right send buffer ready to be read
						-- set transmitting flag
						s_right_transmitting <= '1';
						-- check if the send buffer data is fullimage data
						if ((send_buffer_rightimg_status_i.rddata_type = c_COMM_FFEE_DATA_PACKET) or (send_buffer_rightimg_status_i.rddata_type = c_COMM_FFEE_OVERSCAN_DATA)) then
							-- the send buffer data is fullimage data
							-- write fullimage data operation
							-- check if the packet is only a header (not be transmitted)
							if (send_buffer_rightimg_status_i.stat_extended_usedw = c_PKT_HEADER_SIZE) then
								-- set data to be discarded
								s_discard_data       <= '1';
								-- clear transmitting flag (empty packet, no need to transmit more data after it)
								s_right_transmitting <= '0';
							end if;
							-- update header data
							if ((send_buffer_rightimg_status_i.stat_extended_usedw /= send_buffer_cfg_length_i) or (send_buffer_rightimg_status_i.rddata_end = '1')) then
								s_last_packet        <= '1';
								-- clear transmitting flag (last package, no need to transmit more data after it)
								s_right_transmitting <= '0';
							end if;
							s_data_length                           <= std_logic_vector(unsigned(send_buffer_rightimg_status_i.stat_extended_usedw) - 10);
							-- go to wait fullimage data
							s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_RIGHT_DATA;
							v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_RIGHT_DATA;
						else
							-- the send buffer data is not fullimage data
							-- fullimage data finished
							-- go to finished
							s_comm_data_transmitter_fullimage_state <= FINISH_DELAY;
							v_comm_data_transmitter_fullimage_state := FINISH_DELAY;
						end if;
					end if;

				-- state "WAITING_FULLIMAGE_LEFT_DATA"
				when WAITING_FULLIMAGE_LEFT_DATA =>
					-- wait left fullimage buffer to have data
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;
					-- default internal signal values
					-- conditional state transition
					-- check if left send buffer is ready for read and is not empty
					if ((send_buffer_leftimg_status_i.rdready = '1') and (send_buffer_leftimg_status_i.stat_empty = '0')) then
						-- left send buffer is ready for read and is not empty
						-- go to waiting fetch fullimage data
						s_comm_data_transmitter_fullimage_state <= FETCH_FULLIMAGE_LEFT_DATA;
						v_comm_data_transmitter_fullimage_state := FETCH_FULLIMAGE_LEFT_DATA;
					-- check if the left send buffer is empty
					elsif (send_buffer_leftimg_status_i.stat_empty = '1') then
						-- left send buffer empty
						-- go to waiting spw ready eop
						s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_LEFT_EOP;
						v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_LEFT_EOP;
					end if;

				-- state "FETCH_FULLIMAGE_LEFT_DATA"
				when FETCH_FULLIMAGE_LEFT_DATA =>
					-- fetch data from left fullimage buffer
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_LEFT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_LEFT_DATA;
				-- default internal signal values
				-- conditional state transition

				-- state "WAITING_SPW_READY_LEFT_DATA"
				when WAITING_SPW_READY_LEFT_DATA =>
					-- wait spw to be ready for a left data transmission
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_LEFT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_LEFT_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data)
					if (spw_tx_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data)
						-- go to transmit spw data
						s_comm_data_transmitter_fullimage_state <= TRANSMIT_SPW_LEFT_DATA;
						v_comm_data_transmitter_fullimage_state := TRANSMIT_SPW_LEFT_DATA;
					end if;

				-- state "TRANSMIT_SPW_LEFT_DATA"
				when TRANSMIT_SPW_LEFT_DATA =>
					-- transmit left data on the spw
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_LEFT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_LEFT_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if the header counter need to be updated
					if (s_header_cnt < 10) then
						s_header_cnt <= s_header_cnt + 1;
					end if;

				-- state "WAITING_SPW_READY_LEFT_EOP"
				when WAITING_SPW_READY_LEFT_EOP =>
					-- wait spw to be ready for a left eop transmission
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_LEFT_EOP;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_LEFT_EOP;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data)
					if (spw_tx_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data)
						-- go to transmit spw eop
						s_comm_data_transmitter_fullimage_state <= TRANSMIT_SPW_LEFT_EOP;
						v_comm_data_transmitter_fullimage_state := TRANSMIT_SPW_LEFT_EOP;
					end if;

				-- state "TRANSMIT_SPW_LEFT_EOP"
				when TRANSMIT_SPW_LEFT_EOP =>
					-- transmit left eop on the spw
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= FINISH_DELAY;
					v_comm_data_transmitter_fullimage_state := FINISH_DELAY;
					-- default internal signal values
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write data to spw
						-- update sequence counter
						s_sequence_cnt <= std_logic_vector(unsigned(s_sequence_cnt) + 1);
					end if;
					-- conditional state transition
					-- check if there is more fullimage data to be sent
					if ((s_left_transmitting = '1') or (s_right_transmitting = '1')) then
						-- there is more fullimage data to be sent
						-- go to waiting fullimage ready
						s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_READY;
						v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_READY;
					end if;

				-- state "WAITING_FULLIMAGE_RIGHT_DATA"
				when WAITING_FULLIMAGE_RIGHT_DATA =>
					-- wait right fullimage buffer to have data
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;
					-- default internal signal values
					-- conditional state transition
					-- check if right send buffer is ready for read and is not empty
					if ((send_buffer_rightimg_status_i.rdready = '1') and (send_buffer_rightimg_status_i.stat_empty = '0')) then
						-- right send buffer is ready for read and is not empty
						-- go to waiting fetch fullimage data
						s_comm_data_transmitter_fullimage_state <= FETCH_FULLIMAGE_RIGHT_DATA;
						v_comm_data_transmitter_fullimage_state := FETCH_FULLIMAGE_RIGHT_DATA;
					-- check if the right send buffer is empty
					elsif (send_buffer_rightimg_status_i.stat_empty = '1') then
						-- right send buffer empty
						-- go to waiting spw ready eop
						s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_RIGHT_EOP;
						v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_RIGHT_EOP;
					end if;

				-- state "FETCH_FULLIMAGE_RIGHT_DATA"
				when FETCH_FULLIMAGE_RIGHT_DATA =>
					-- fetch data from right fullimage buffer
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_RIGHT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_RIGHT_DATA;
				-- default internal signal values
				-- conditional state transition

				-- state "WAITING_SPW_READY_RIGHT_DATA"
				when WAITING_SPW_READY_RIGHT_DATA =>
					-- wait spw to be ready for a right data transmission
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_RIGHT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_RIGHT_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data)
					if (spw_tx_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data)
						-- go to transmit spw data
						s_comm_data_transmitter_fullimage_state <= TRANSMIT_SPW_RIGHT_DATA;
						v_comm_data_transmitter_fullimage_state := TRANSMIT_SPW_RIGHT_DATA;
					end if;

				-- state "TRANSMIT_SPW_RIGHT_DATA"
				when TRANSMIT_SPW_RIGHT_DATA =>
					-- transmit right data on the spw
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_RIGHT_DATA;
					v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_RIGHT_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if the header counter need to be updated
					if (s_header_cnt < 10) then
						s_header_cnt <= s_header_cnt + 1;
					end if;

				-- state "WAITING_SPW_READY_RIGHT_EOP"
				when WAITING_SPW_READY_RIGHT_EOP =>
					-- wait spw to be ready for a right eop transmission
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_RIGHT_EOP;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_RIGHT_EOP;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data)
					if (spw_tx_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data)
						-- go to transmit spw eop
						s_comm_data_transmitter_fullimage_state <= TRANSMIT_SPW_RIGHT_EOP;
						v_comm_data_transmitter_fullimage_state := TRANSMIT_SPW_RIGHT_EOP;
					end if;

				-- state "TRANSMIT_SPW_RIGHT_EOP"
				when TRANSMIT_SPW_RIGHT_EOP =>
					-- transmit right eop on the spw
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= FINISH_DELAY;
					v_comm_data_transmitter_fullimage_state := FINISH_DELAY;
					-- default internal signal values
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write data to spw
						-- update sequence counter
						s_sequence_cnt <= std_logic_vector(unsigned(s_sequence_cnt) + 1);
					end if;
					-- conditional state transition
					-- check if there is more fullimage data to be sent
					if ((s_left_transmitting = '1') or (s_right_transmitting = '1')) then
						-- there is more fullimage data to be sent
						-- go to waiting fullimage ready
						s_comm_data_transmitter_fullimage_state <= WAITING_FULLIMAGE_READY;
						v_comm_data_transmitter_fullimage_state := WAITING_FULLIMAGE_READY;
					end if;

				-- state "FINISH_DELAY"
				when FINISH_DELAY =>
					-- data transmitter finish delay (update of internal signals)
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= FINISHED;
					v_comm_data_transmitter_fullimage_state := FINISHED;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
				-- conditional state transition

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= FINISHED;
					v_comm_data_transmitter_fullimage_state := FINISHED;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
				-- conditional state transition

				-- state "WAITING_SPW_READY_EEP"
				when WAITING_SPW_READY_EEP =>
					-- wait spw to be ready for a eep transmission
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_EEP;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_EEP;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_sequence_cnt                          <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data)
					if (spw_tx_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data)
						-- go to transmit spw eep
						s_comm_data_transmitter_fullimage_state <= TRANSMIT_SPW_EEP;
						v_comm_data_transmitter_fullimage_state := TRANSMIT_SPW_EEP;
					end if;

				-- state "TRANSMIT_SPW_EEP"
				when TRANSMIT_SPW_EEP =>
					-- transmit eep on the spw
					-- default state transition
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;
					-- default internal signal values
					s_header_cnt                            <= 0;
					s_last_packet                           <= '0';
					s_data_length                           <= (others => '0');
					s_sequence_cnt                          <= (others => '0');
					s_discard_data                          <= '0';
					s_left_transmitting                     <= '0';
					s_right_transmitting                    <= '0';
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (comm_stop_i = '1') then
				-- a stop was issued
				-- check if the transmitter is in the middle of a transmission (have the spw mux access rights)
				if ((s_comm_data_transmitter_fullimage_state /= STOPPED) and (s_comm_data_transmitter_fullimage_state /= IDLE) and (s_comm_data_transmitter_fullimage_state /= FINISHED)) then
					-- the transmitter is in the middle of a transmission (have the spw mux access rights)
					-- transmit and eep to release the spw mux and indicate an error
					s_comm_data_transmitter_fullimage_state <= WAITING_SPW_READY_EEP;
					v_comm_data_transmitter_fullimage_state := WAITING_SPW_READY_EEP;
				else
					-- the transmitter is not the middle of a transmission (does not have the spw mux access rights)
					-- no need to release the spw mux and indicate an error, go to stopped
					s_comm_data_transmitter_fullimage_state <= STOPPED;
					v_comm_data_transmitter_fullimage_state := STOPPED;
				end if;
			-- check if a reset was requested
			elsif (data_trans_control_i.reset_transmitter = '1') then
				-- a reset was requested
				-- go to idle
				s_comm_data_transmitter_fullimage_state <= IDLE;
				v_comm_data_transmitter_fullimage_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			data_trans_status_o                   <= c_COMM_DATA_TRANS_STATUS_RST;
			send_buffer_leftimg_control_o.rdreq   <= '0';
			send_buffer_leftimg_control_o.change  <= '0';
			send_buffer_rightimg_control_o.rdreq  <= '0';
			send_buffer_rightimg_control_o.change <= '0';
			spw_tx_control_o                      <= c_COMM_DATA_TRANS_SPW_TX_CONTROL_RST;
			-- Output generation FSM
			case (v_comm_data_transmitter_fullimage_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter is stopped
					-- default output signals
					null;
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- data transmitter is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "WAITING_FULLIMAGE_READY"
				when WAITING_FULLIMAGE_READY =>
					-- wait fullimage buffer to be ready
					-- default output signals
					null;
				-- conditional output signals

				-- state "WAITING_FULLIMAGE_LEFT_DATA"
				when WAITING_FULLIMAGE_LEFT_DATA =>
					-- wait left fullimage buffer to have data
					-- default output signals
					null;
				-- conditional output signals

				-- state "FETCH_FULLIMAGE_LEFT_DATA"
				when FETCH_FULLIMAGE_LEFT_DATA =>
					-- fetch data from left fullimage buffer
					-- default output signals
					-- fetch data from send buffer
					send_buffer_leftimg_control_o.rdreq <= '1';
				-- conditional output signals

				-- state "WAITING_SPW_READY_LEFT_DATA"
				when WAITING_SPW_READY_LEFT_DATA =>
					-- wait spw to be ready for a left data transmission
					-- default output signals
					null;
				-- conditional output signals

				-- state "TRANSMIT_SPW_LEFT_DATA"
				when TRANSMIT_SPW_LEFT_DATA =>
					-- transmit left data on the spw
					-- default output signals
					-- conditional output signals
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write data to spw
						-- clear spw flag (to indicate a data)
						spw_tx_control_o.tx_flag  <= c_SPW_CODEC_DATA_ID_FLAG;
						-- fill spw data with field data
						spw_tx_control_o.tx_data  <= send_buffer_leftimg_status_i.rddata;
						-- write the spw data
						spw_tx_control_o.tx_write <= '1';
						-- check if the transmitted header need to be updated
						if (s_header_cnt = c_PKT_HEADER_LENGTH_MSB) then
							-- header in packet length (msb), length (msb) need to be updated
							spw_tx_control_o.tx_data <= s_data_length(15 downto 8);
						elsif (s_header_cnt = c_PKT_HEADER_LENGTH_LSB) then
							-- header in packet length (lsb), length (lsb) need to be updated
							spw_tx_control_o.tx_data <= s_data_length(7 downto 0);
						elsif (s_header_cnt = c_PKT_HEADER_TYPE_LSB) then
							-- header in packet type (lsb), last packet to be updated
							spw_tx_control_o.tx_data(7) <= s_last_packet;
						elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_MSB) then
							-- header in sequence counter (msb), sequence counter (msb) to be updated
							spw_tx_control_o.tx_data <= s_sequence_cnt(15 downto 8);
						elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_LSB) then
							-- header in sequence counter (lsb), sequence counter (lsb) to be updated
							spw_tx_control_o.tx_data <= s_sequence_cnt(7 downto 0);
						end if;
					end if;

				-- state "WAITING_SPW_READY_LEFT_EOP"
				when WAITING_SPW_READY_LEFT_EOP =>
					-- wait spw to be ready for a left eop transmission
					-- default output signals
					null;
				-- conditional output signals

				-- state "TRANSMIT_SPW_LEFT_EOP"
				when TRANSMIT_SPW_LEFT_EOP =>
					-- transmit left eop on the spw
					-- default output signals
					-- send a change command to the send buffer
					send_buffer_leftimg_control_o.change <= '1';
					-- conditional output signals
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write eop to spw
						-- set spw flag (to indicate a package end)
						spw_tx_control_o.tx_flag  <= c_SPW_CODEC_PKTEND_ID_FLAG;
						-- fill spw data with the eop identifier (0x00)
						spw_tx_control_o.tx_data  <= c_SPW_CODEC_EOP_ID_DATA;
						-- write the spw data
						spw_tx_control_o.tx_write <= '1';
					end if;

				-- state "WAITING_FULLIMAGE_RIGHT_DATA"
				when WAITING_FULLIMAGE_RIGHT_DATA =>
					-- wait right fullimage buffer to have data
					-- default output signals
					null;
				-- conditional output signals

				-- state "FETCH_FULLIMAGE_RIGHT_DATA"
				when FETCH_FULLIMAGE_RIGHT_DATA =>
					-- fetch data from right fullimage buffer
					-- default output signals
					-- fetch data from send buffer
					send_buffer_rightimg_control_o.rdreq <= '1';
				-- conditional output signals

				-- state "WAITING_SPW_READY_RIGHT_DATA"
				when WAITING_SPW_READY_RIGHT_DATA =>
					-- wait spw to be ready for a right data transmission
					-- default output signals
					null;
				-- conditional output signals

				-- state "TRANSMIT_SPW_RIGHT_DATA"
				when TRANSMIT_SPW_RIGHT_DATA =>
					-- transmit right data on the spw
					-- default output signals
					-- conditional output signals
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write data to spw
						-- clear spw flag (to indicate a data)
						spw_tx_control_o.tx_flag  <= c_SPW_CODEC_DATA_ID_FLAG;
						-- fill spw data with field data
						spw_tx_control_o.tx_data  <= send_buffer_rightimg_status_i.rddata;
						-- write the spw data
						spw_tx_control_o.tx_write <= '1';
						-- check if the transmitted header need to be updated
						if (s_header_cnt = c_PKT_HEADER_LENGTH_MSB) then
							-- header in packet length (msb), length (msb) need to be updated
							spw_tx_control_o.tx_data <= s_data_length(15 downto 8);
						elsif (s_header_cnt = c_PKT_HEADER_LENGTH_LSB) then
							-- header in packet length (lsb), length (lsb) need to be updated
							spw_tx_control_o.tx_data <= s_data_length(7 downto 0);
						elsif (s_header_cnt = c_PKT_HEADER_TYPE_LSB) then
							-- header in packet type (lsb), last packet to be updated
							spw_tx_control_o.tx_data(7) <= s_last_packet;
						elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_MSB) then
							-- header in sequence counter (msb), sequence counter (msb) to be updated
							spw_tx_control_o.tx_data <= s_sequence_cnt(15 downto 8);
						elsif (s_header_cnt = c_PKT_HEADER_SEQUENCE_CNT_LSB) then
							-- header in sequence counter (lsb), sequence counter (lsb) to be updated
							spw_tx_control_o.tx_data <= s_sequence_cnt(7 downto 0);
						end if;
					end if;

				-- state "WAITING_SPW_READY_RIGHT_EOP"
				when WAITING_SPW_READY_RIGHT_EOP =>
					-- wait spw to be ready for a right eop transmission
					-- default output signals
					null;
				-- conditional output signals

				-- state "TRANSMIT_SPW_RIGHT_EOP"
				when TRANSMIT_SPW_RIGHT_EOP =>
					-- transmit right eop on the spw
					-- default output signals
					-- send a change command to the send buffer
					send_buffer_rightimg_control_o.change <= '1';
					-- conditional output signals
					-- check if data does not need to be discarded
					if (s_discard_data = '0') then
						-- data does not need to be discarded, write eop to spw
						-- set spw flag (to indicate a package end)
						spw_tx_control_o.tx_flag  <= c_SPW_CODEC_PKTEND_ID_FLAG;
						-- fill spw data with the eop identifier (0x00)
						spw_tx_control_o.tx_data  <= c_SPW_CODEC_EOP_ID_DATA;
						-- write the spw data
						spw_tx_control_o.tx_write <= '1';
					end if;

				-- state "FINISH_DELAY"
				when FINISH_DELAY =>
					-- data transmitter finish delay (update of internal signals)
					-- default output signals
					null;
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default output signals
					data_trans_status_o.transmission_finished <= '1';
					data_trans_status_o.sequence_cnt_next_val <= s_sequence_cnt;
				-- conditional output signals

				-- state "WAITING_SPW_READY_EEP"
				when WAITING_SPW_READY_EEP =>
					-- wait spw to be ready for a eep transmission
					-- default output signals
					null;
				-- conditional output signals

				-- state "TRANSMIT_SPW_EEP"
				when TRANSMIT_SPW_EEP =>
					-- transmit eep on the spw
					-- default output signals
					-- set spw flag (to indicate a package end)
					spw_tx_control_o.tx_flag  <= c_SPW_CODEC_PKTEND_ID_FLAG;
					-- fill spw data with the eep identifier (0x01)
					spw_tx_control_o.tx_data  <= c_SPW_CODEC_EEP_ID_DATA;
					-- write the spw data
					spw_tx_control_o.tx_write <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_comm_data_transmitter_fullimage;

end architecture RTL;
