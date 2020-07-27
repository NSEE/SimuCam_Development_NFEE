library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;
use work.comm_data_transmitter_pkg.all;

entity comm_data_transmitter_manager_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		comm_stop_i                    : in  std_logic;
		comm_start_i                   : in  std_logic;
		channel_sync_i                 : in  std_logic;
		housekeep_only_i               : in  std_logic;
		windowing_enabled_i            : in  std_logic;
		data_trans_housekeep_status_i  : in  t_comm_data_trans_status;
		data_trans_fullimage_status_i  : in  t_comm_data_trans_status;
		data_trans_windowing_status_i  : in  t_comm_data_trans_status;
		data_trans_housekeep_control_o : out t_comm_data_trans_control;
		data_trans_fullimage_control_o : out t_comm_data_trans_control;
		data_trans_windowing_control_o : out t_comm_data_trans_control
	);
end entity comm_data_transmitter_manager_ent;

architecture RTL of comm_data_transmitter_manager_ent is

	type t_comm_data_transmitter_manager_fsm is (
		STOPPED,                        -- data transmitter is stopped
		IDLE,                           -- data transmitter is in idle
		START_AEB_HOUSEKEEP_TRANS,      -- start the aeb housekeep transmission
		WAIT_AEB_HOUSEKEEP_TRANS,       -- wait the aeb housekeep transmission to finish
		RESET_AEB_HOUSEKEEP_TRANS,      -- reset the aeb housekeep transmission
		START_DEB_HOUSEKEEP_TRANS,      -- start the deb housekeep transmission
		WAIT_DEB_HOUSEKEEP_TRANS,       -- wait the deb housekeep transmission to finish
		RESET_DEB_HOUSEKEEP_TRANS,      -- reset the deb housekeep transmission
		START_FULLIMAGE_TRANS,          -- start the fullimage transmission
		WAIT_FULLIMAGE_TRANS,           -- wait the fullimage transmission to finish
		RESET_FULLIMAGE_TRANS,          -- reset the fullimage transmission
		START_WINDOWING_TRANS,          -- start the windowing transmission
		WAIT_WINDOWING_TRANS,           -- wait the windowing transmission to finish
		RESET_WINDOWING_TRANS,          -- reset the windowing transmission
		START_OVERSCAN_TRANS,           -- start the overscan transmission
		WAIT_OVERSCAN_TRANS,            -- wait the overscan transmission to finish
		RESET_OVERSCAN_TRANS,           -- reset the overscan transmission
		FINISHED                        -- data transmitter is finished
	);

	signal s_comm_data_transmitter_manager_state : t_comm_data_transmitter_manager_fsm;

	-- header data
	signal s_sequence_cnt : std_logic_vector(15 downto 0);

begin

	p_comm_data_transmitter_manager : process(clk_i, rst_i) is
		variable v_comm_data_transmitter_manager_state : t_comm_data_transmitter_manager_fsm;
	begin
		if (rst_i = '1') then

			-- fsm state reset
			s_comm_data_transmitter_manager_state <= STOPPED;
			v_comm_data_transmitter_manager_state := STOPPED;

			-- internal signals reset
			s_sequence_cnt <= (others => '0');

			-- outputs reset
			data_trans_housekeep_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;
			data_trans_fullimage_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;
			data_trans_windowing_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;

		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_data_transmitter_manager_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter is stopped
					-- default state transition
					s_comm_data_transmitter_manager_state <= STOPPED;
					v_comm_data_transmitter_manager_state := STOPPED;
					-- default internal signal values
					s_sequence_cnt                        <= (others => '0');
					-- conditional state transition
					-- check if a start was issued
					if (comm_start_i = '1') then
						-- start issued, go to idle
						s_comm_data_transmitter_manager_state <= IDLE;
						v_comm_data_transmitter_manager_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- data transmitter is in idle
					-- default state transition
					s_comm_data_transmitter_manager_state <= IDLE;
					v_comm_data_transmitter_manager_state := IDLE;
					-- default internal signal values
					s_sequence_cnt                        <= (others => '0');
					-- conditional state transition
					-- check if a channel sync was received
					if (channel_sync_i = '1') then
						-- a channel sync was received
						-- go to start housekeep trans
						s_comm_data_transmitter_manager_state <= START_AEB_HOUSEKEEP_TRANS;
						v_comm_data_transmitter_manager_state := START_AEB_HOUSEKEEP_TRANS;
					end if;

				-- state "START_AEB_HOUSEKEEP_TRANS"
				when START_AEB_HOUSEKEEP_TRANS =>
					-- start the aeb housekeep transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_AEB_HOUSEKEEP_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_AEB_HOUSEKEEP_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_AEB_HOUSEKEEP_TRANS"
				when WAIT_AEB_HOUSEKEEP_TRANS =>
					-- wait the aeb housekeep transmission to finish
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_AEB_HOUSEKEEP_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_AEB_HOUSEKEEP_TRANS;
					-- default internal signal values
					-- conditional state transition
					-- check if the housekeep trans finished the transmission
					if (data_trans_housekeep_status_i.transmission_finished = '1') then
						-- the housekeep trans finished the transmission
						-- get the next sequence counter value
						s_sequence_cnt                        <= data_trans_housekeep_status_i.sequence_cnt_next_val;
						-- go to reset housekeep trans
						s_comm_data_transmitter_manager_state <= RESET_AEB_HOUSEKEEP_TRANS;
						v_comm_data_transmitter_manager_state := RESET_AEB_HOUSEKEEP_TRANS;
					end if;

				-- state "RESET_AEB_HOUSEKEEP_TRANS"
				when RESET_AEB_HOUSEKEEP_TRANS =>
					-- reset the aeb housekeep transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= START_DEB_HOUSEKEEP_TRANS;
					v_comm_data_transmitter_manager_state := START_DEB_HOUSEKEEP_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "START_DEB_HOUSEKEEP_TRANS"
				when START_DEB_HOUSEKEEP_TRANS =>
					-- start the deb housekeep transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_DEB_HOUSEKEEP_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_DEB_HOUSEKEEP_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_DEB_HOUSEKEEP_TRANS"
				when WAIT_DEB_HOUSEKEEP_TRANS =>
					-- wait the deb housekeep transmission to finish
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_DEB_HOUSEKEEP_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_DEB_HOUSEKEEP_TRANS;
					-- default internal signal values
					-- conditional state transition
					-- check if the housekeep trans finished the transmission
					if (data_trans_housekeep_status_i.transmission_finished = '1') then
						-- the housekeep trans finished the transmission
						-- get the next sequence counter value
						s_sequence_cnt                        <= data_trans_housekeep_status_i.sequence_cnt_next_val;
						-- go to reset housekeep trans
						s_comm_data_transmitter_manager_state <= RESET_DEB_HOUSEKEEP_TRANS;
						v_comm_data_transmitter_manager_state := RESET_DEB_HOUSEKEEP_TRANS;
					end if;

				-- state "RESET_DEB_HOUSEKEEP_TRANS"
				when RESET_DEB_HOUSEKEEP_TRANS =>
					-- reset the deb housekeep transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= FINISHED;
					v_comm_data_transmitter_manager_state := FINISHED;
					-- default internal signal values
					-- conditional state transition
					-- check if the image is to be transmitted
					if (housekeep_only_i = '0') then
						-- the image is to be transmitted
						-- check if the windowing is disabled
						if (windowing_enabled_i = '0') then
							-- the windowing is disabled	
							-- go to start fullimage trans
							s_comm_data_transmitter_manager_state <= START_FULLIMAGE_TRANS;
							v_comm_data_transmitter_manager_state := START_FULLIMAGE_TRANS;
						else
							-- the windowing is enabled
							-- go to start windowing trans
							s_comm_data_transmitter_manager_state <= START_WINDOWING_TRANS;
							v_comm_data_transmitter_manager_state := START_WINDOWING_TRANS;
						end if;
					end if;

				-- state "START_FULLIMAGE_TRANS"
				when START_FULLIMAGE_TRANS =>
					-- start the fullimage transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_FULLIMAGE_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_FULLIMAGE_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_FULLIMAGE_TRANS"
				when WAIT_FULLIMAGE_TRANS =>
					-- wait the fullimage transmission to finish
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_FULLIMAGE_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_FULLIMAGE_TRANS;
					-- default internal signal values
					-- conditional state transition
					-- check if the fullimage trans finished the transmission
					if (data_trans_fullimage_status_i.transmission_finished = '1') then
						-- the fullimage trans finished the transmission
						-- get the next sequence counter value
						s_sequence_cnt                        <= data_trans_fullimage_status_i.sequence_cnt_next_val;
						-- go to reset fullimage trans
						s_comm_data_transmitter_manager_state <= RESET_FULLIMAGE_TRANS;
						v_comm_data_transmitter_manager_state := RESET_FULLIMAGE_TRANS;
					end if;

				-- state "RESET_FULLIMAGE_TRANS"
				when RESET_FULLIMAGE_TRANS =>
					-- reset the fullimage transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= START_OVERSCAN_TRANS;
					v_comm_data_transmitter_manager_state := START_OVERSCAN_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "START_WINDOWING_TRANS"
				when START_WINDOWING_TRANS =>
					-- start the windowing transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_WINDOWING_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_WINDOWING_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_WINDOWING_TRANS"
				when WAIT_WINDOWING_TRANS =>
					-- wait the windowing transmission to finish
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_WINDOWING_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_WINDOWING_TRANS;
					-- default internal signal values
					-- conditional state transition
					-- check if the windowing trans finished the transmission
					if (data_trans_windowing_status_i.transmission_finished = '1') then
						-- the windowing trans finished the transmission
						-- get the next sequence counter value
						s_sequence_cnt                        <= data_trans_windowing_status_i.sequence_cnt_next_val;
						-- go to reset windowing trans
						s_comm_data_transmitter_manager_state <= RESET_WINDOWING_TRANS;
						v_comm_data_transmitter_manager_state := RESET_WINDOWING_TRANS;
					end if;

				-- state "RESET_WINDOWING_TRANS"
				when RESET_WINDOWING_TRANS =>
					-- reset the windowing transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= START_OVERSCAN_TRANS;
					v_comm_data_transmitter_manager_state := START_OVERSCAN_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "START_OVERSCAN_TRANS"
				when START_OVERSCAN_TRANS =>
					-- start the overscan transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_OVERSCAN_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_OVERSCAN_TRANS;
				-- default internal signal values
				-- conditional state transition

				-- state "WAIT_OVERSCAN_TRANS"
				when WAIT_OVERSCAN_TRANS =>
					-- wait the overscan transmission to finish
					-- default state transition
					s_comm_data_transmitter_manager_state <= WAIT_OVERSCAN_TRANS;
					v_comm_data_transmitter_manager_state := WAIT_OVERSCAN_TRANS;
					-- default internal signal values
					-- conditional state transition
					-- check if the overscan trans finished the transmission
					if (data_trans_fullimage_status_i.transmission_finished = '1') then
						-- the overscan trans finished the transmission
						-- get the next sequence counter value
						s_sequence_cnt                        <= data_trans_fullimage_status_i.sequence_cnt_next_val;
						-- go to reset overscan trans
						s_comm_data_transmitter_manager_state <= RESET_OVERSCAN_TRANS;
						v_comm_data_transmitter_manager_state := RESET_OVERSCAN_TRANS;
					end if;

				-- state "RESET_OVERSCAN_TRANS"
				when RESET_OVERSCAN_TRANS =>
					-- reset the overscan transmission
					-- default state transition
					s_comm_data_transmitter_manager_state <= FINISHED;
					v_comm_data_transmitter_manager_state := FINISHED;
				-- default internal signal values
				-- conditional state transition

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default state transition
					s_comm_data_transmitter_manager_state <= FINISHED;
					v_comm_data_transmitter_manager_state := FINISHED;
					-- default internal signal values
					s_sequence_cnt                        <= (others => '0');
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_comm_data_transmitter_manager_state <= STOPPED;
					v_comm_data_transmitter_manager_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (comm_stop_i = '1') then
				-- a stop was issued
				-- go to stopped
				s_comm_data_transmitter_manager_state <= STOPPED;
				v_comm_data_transmitter_manager_state := STOPPED;
			end if;

			-- Output Generation --
			-- Default output generation
			data_trans_housekeep_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;
			data_trans_fullimage_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;
			data_trans_windowing_control_o <= c_COMM_DATA_TRANS_CONTROL_RST;
			-- Output generation FSM
			case (v_comm_data_transmitter_manager_state) is

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

				-- state "START_AEB_HOUSEKEEP_TRANS"
				when START_AEB_HOUSEKEEP_TRANS =>
					-- start the aeb housekeep transmission
					-- default output signals
					data_trans_housekeep_control_o.start_transmission    <= '1';
					data_trans_housekeep_control_o.sequence_cnt_init_val <= s_sequence_cnt;
				-- conditional output signals

				-- state "WAIT_AEB_HOUSEKEEP_TRANS"
				when WAIT_AEB_HOUSEKEEP_TRANS =>
					-- wait the aeb housekeep transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "RESET_AEB_HOUSEKEEP_TRANS"
				when RESET_AEB_HOUSEKEEP_TRANS =>
					-- reset the aeb housekeep transmission
					-- default output signals
					data_trans_housekeep_control_o.reset_transmitter <= '1';
				-- conditional output signals

				-- state "START_DEB_HOUSEKEEP_TRANS"
				when START_DEB_HOUSEKEEP_TRANS =>
					-- start the deb housekeep transmission
					-- default output signals
					data_trans_housekeep_control_o.start_transmission    <= '1';
					data_trans_housekeep_control_o.sequence_cnt_init_val <= s_sequence_cnt;
				-- conditional output signals

				-- state "WAIT_DEB_HOUSEKEEP_TRANS"
				when WAIT_DEB_HOUSEKEEP_TRANS =>
					-- wait the deb housekeep transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "RESET_DEB_HOUSEKEEP_TRANS"
				when RESET_DEB_HOUSEKEEP_TRANS =>
					-- reset the deb housekeep transmission
					-- default output signals
					data_trans_housekeep_control_o.reset_transmitter <= '1';
				-- conditional output signals

				-- state "START_FULLIMAGE_TRANS"
				when START_FULLIMAGE_TRANS =>
					-- start the fullimage transmission
					-- default output signals
					data_trans_fullimage_control_o.start_transmission    <= '1';
					--					data_trans_fullimage_control_o.sequence_cnt_init_val <= s_sequence_cnt;
					data_trans_fullimage_control_o.sequence_cnt_init_val <= (others => '0');
				-- conditional output signals

				-- state "WAIT_FULLIMAGE_TRANS"
				when WAIT_FULLIMAGE_TRANS =>
					-- wait the fullimage transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "RESET_FULLIMAGE_TRANS"
				when RESET_FULLIMAGE_TRANS =>
					-- reset the fullimage transmission
					-- default output signals
					data_trans_fullimage_control_o.reset_transmitter <= '1';
				-- conditional output signals

				-- state "START_WINDOWING_TRANS"
				when START_WINDOWING_TRANS =>
					-- start the windowing transmission
					-- default output signals
					data_trans_windowing_control_o.start_transmission    <= '1';
					--					data_trans_windowing_control_o.sequence_cnt_init_val <= s_sequence_cnt;
					data_trans_windowing_control_o.sequence_cnt_init_val <= (others => '0');
				-- conditional output signals

				-- state "WAIT_WINDOWING_TRANS"
				when WAIT_WINDOWING_TRANS =>
					-- wait the windowing transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "RESET_WINDOWING_TRANS"
				when RESET_WINDOWING_TRANS =>
					-- reset the windowing transmission
					-- default output signals
					data_trans_windowing_control_o.reset_transmitter <= '1';
				-- conditional output signals

				-- state "START_OVERSCAN_TRANS"
				when START_OVERSCAN_TRANS =>
					-- start the overscan transmission
					-- default output signals
					data_trans_fullimage_control_o.start_transmission    <= '1';
					data_trans_fullimage_control_o.sequence_cnt_init_val <= s_sequence_cnt;
				-- conditional output signals

				-- state "WAIT_OVERSCAN_TRANS"
				when WAIT_OVERSCAN_TRANS =>
					-- wait the overscan transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "RESET_OVERSCAN_TRANS"
				when RESET_OVERSCAN_TRANS =>
					-- reset the overscan transmission
					-- default output signals
					data_trans_fullimage_control_o.reset_transmitter <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default output signals
					-- conditional output signals

			end case;

		end if;
	end process p_comm_data_transmitter_manager;

end architecture RTL;
