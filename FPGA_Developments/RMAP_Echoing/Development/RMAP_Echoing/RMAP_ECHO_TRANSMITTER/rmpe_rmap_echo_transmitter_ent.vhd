library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmpe_rmap_echoing_pkg.all;

entity rmpe_rmap_echo_transmitter_ent is
	port(
		clk_i                              : in  std_logic;
		rst_i                              : in  std_logic;
		fee_0_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_0_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_1_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_1_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_2_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_2_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_3_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_3_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_4_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_4_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_5_rmap_incoming_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		fee_5_rmap_outgoing_fifo_status_i  : in  t_rmpe_rmap_echoing_rmap_fifo_status;
		spw_codec_status_i                 : in  t_rmpe_rmap_echoing_spw_codec_status;
		fee_0_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_0_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_1_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_1_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_2_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_2_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_3_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_3_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_4_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_4_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_5_rmap_incoming_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		fee_5_rmap_outgoing_fifo_control_o : out t_rmpe_rmap_echoing_rmap_fifo_control;
		spw_codec_control_o                : out t_rmpe_rmap_echoing_spw_codec_control
	);
end entity rmpe_rmap_echo_transmitter_ent;

architecture RTL of rmpe_rmap_echo_transmitter_ent is

	type t_rmap_fifo_list is (
		fifo_none,
		fifo_incoming_fee_0,
		fifo_outgoing_fee_0,
		fifo_incoming_fee_1,
		fifo_outgoing_fee_1,
		fifo_incoming_fee_2,
		fifo_outgoing_fee_2,
		fifo_incoming_fee_3,
		fifo_outgoing_fee_3,
		fifo_incoming_fee_4,
		fifo_outgoing_fee_4,
		fifo_incoming_fee_5,
		fifo_outgoing_fee_5
	);
	signal s_selected_fifo : t_rmap_fifo_list;

	subtype t_rmap_fifo_queue_index is natural range 0 to 12;
	type t_rmap_fifo_queue is array (0 to t_rmap_fifo_queue_index'high) of t_rmap_fifo_list;
	signal s_rmap_fifo_queue : t_rmap_fifo_queue;

	signal s_fifo_incoming_fee_0_queued : std_logic;
	signal s_fifo_outgoing_fee_0_queued : std_logic;
	signal s_fifo_incoming_fee_1_queued : std_logic;
	signal s_fifo_outgoing_fee_1_queued : std_logic;
	signal s_fifo_incoming_fee_2_queued : std_logic;
	signal s_fifo_outgoing_fee_2_queued : std_logic;
	signal s_fifo_incoming_fee_3_queued : std_logic;
	signal s_fifo_outgoing_fee_3_queued : std_logic;
	signal s_fifo_incoming_fee_4_queued : std_logic;
	signal s_fifo_outgoing_fee_4_queued : std_logic;
	signal s_fifo_incoming_fee_5_queued : std_logic;
	signal s_fifo_outgoing_fee_5_queued : std_logic;

	signal s_fifo_incoming_fee_0_in_use : std_logic;
	signal s_fifo_outgoing_fee_0_in_use : std_logic;
	signal s_fifo_incoming_fee_1_in_use : std_logic;
	signal s_fifo_outgoing_fee_1_in_use : std_logic;
	signal s_fifo_incoming_fee_2_in_use : std_logic;
	signal s_fifo_outgoing_fee_2_in_use : std_logic;
	signal s_fifo_incoming_fee_3_in_use : std_logic;
	signal s_fifo_outgoing_fee_3_in_use : std_logic;
	signal s_fifo_incoming_fee_4_in_use : std_logic;
	signal s_fifo_outgoing_fee_4_in_use : std_logic;
	signal s_fifo_incoming_fee_5_in_use : std_logic;
	signal s_fifo_outgoing_fee_5_in_use : std_logic;

	type t_rmpe_rmap_echo_transmitter_fsm is (
		IDLE,                           -- in idle, waiting data in the rmap data fifo
		WAITING_RMAP_DATA,              -- waiting data in the rmap data fifo
		FETCH_RMAP_DATA,                -- fetching data from the rmap data fifo
		WRITE_RMAP_DATA                 -- write rmap packet data
	);
	signal s_rmpe_rmap_echo_transmitter_state : t_rmpe_rmap_echo_transmitter_fsm;

begin

	p_rmpe_rmap_echo_transmitter : process(clk_i, rst_i) is
		variable v_fifo_queue_index                 : t_rmap_fifo_queue_index := 0;
		variable v_rmpe_rmap_echo_transmitter_state : t_rmpe_rmap_echo_transmitter_fsm;
	begin
		if (rst_i = '1') then
			s_selected_fifo              <= fifo_none;
			s_rmap_fifo_queue            <= (others => fifo_none);
			s_fifo_incoming_fee_0_queued <= '0';
			s_fifo_outgoing_fee_0_queued <= '0';
			s_fifo_incoming_fee_1_queued <= '0';
			s_fifo_outgoing_fee_1_queued <= '0';
			s_fifo_incoming_fee_2_queued <= '0';
			s_fifo_outgoing_fee_2_queued <= '0';
			s_fifo_incoming_fee_3_queued <= '0';
			s_fifo_outgoing_fee_3_queued <= '0';
			s_fifo_incoming_fee_4_queued <= '0';
			s_fifo_outgoing_fee_4_queued <= '0';
			s_fifo_incoming_fee_5_queued <= '0';
			s_fifo_outgoing_fee_5_queued <= '0';
			s_fifo_incoming_fee_0_in_use <= '0';
			s_fifo_outgoing_fee_0_in_use <= '0';
			s_fifo_incoming_fee_1_in_use <= '0';
			s_fifo_outgoing_fee_1_in_use <= '0';
			s_fifo_incoming_fee_2_in_use <= '0';
			s_fifo_outgoing_fee_2_in_use <= '0';
			s_fifo_incoming_fee_3_in_use <= '0';
			s_fifo_outgoing_fee_3_in_use <= '0';
			s_fifo_incoming_fee_4_in_use <= '0';
			s_fifo_outgoing_fee_4_in_use <= '0';
			s_fifo_incoming_fee_5_in_use <= '0';
			s_fifo_outgoing_fee_5_in_use <= '0';
			v_fifo_queue_index           := 0;
		elsif rising_edge(clk_i) then

			-- check if fee 0 rmap incoming fifo has data available and is not queued
			if ((fee_0_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_0_queued = '0')) then
				-- fee 0 rmap incoming fifo has data available and is not queued
				-- put fee 0 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_0;
				s_fifo_incoming_fee_0_queued          <= '1';
				s_fifo_incoming_fee_0_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 1 rmap incoming fifo has data available and is not queued
			if ((fee_1_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_1_queued = '0')) then
				-- fee 1 rmap incoming fifo has data available and is not queued
				-- put fee 1 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_1;
				s_fifo_incoming_fee_1_queued          <= '1';
				s_fifo_incoming_fee_1_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 2 rmap incoming fifo has data available and is not queued
			if ((fee_2_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_2_queued = '0')) then
				-- fee 2 rmap incoming fifo has data available and is not queued
				-- put fee 2 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_2;
				s_fifo_incoming_fee_2_queued          <= '1';
				s_fifo_incoming_fee_2_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 3 rmap incoming fifo has data available and is not queued
			if ((fee_3_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_3_queued = '0')) then
				-- fee 3 rmap incoming fifo has data available and is not queued
				-- put fee 3 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_3;
				s_fifo_incoming_fee_3_queued          <= '1';
				s_fifo_incoming_fee_3_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 4 rmap incoming fifo has data available and is not queued
			if ((fee_4_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_4_queued = '0')) then
				-- fee 4 rmap incoming fifo has data available and is not queued
				-- put fee 4 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_4;
				s_fifo_incoming_fee_4_queued          <= '1';
				s_fifo_incoming_fee_4_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 5 rmap incoming fifo has data available and is not queued
			if ((fee_5_rmap_incoming_fifo_status_i.empty = '0') and (s_fifo_incoming_fee_5_queued = '0')) then
				-- fee 5 rmap incoming fifo has data available and is not queued
				-- put fee 5 rmap incoming fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_incoming_fee_5;
				s_fifo_incoming_fee_5_queued          <= '1';
				s_fifo_incoming_fee_5_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 0 rmap outgoing fifo has data available and is not queued
			if ((fee_0_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_0_queued = '0')) then
				-- fee 0 rmap outgoing fifo has data available and is not queued
				-- put fee 0 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_0;
				s_fifo_outgoing_fee_0_queued          <= '1';
				s_fifo_outgoing_fee_0_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 1 rmap outgoing fifo has data available and is not queued
			if ((fee_1_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_1_queued = '0')) then
				-- fee 1 rmap outgoing fifo has data available and is not queued
				-- put fee 1 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_1;
				s_fifo_outgoing_fee_1_queued          <= '1';
				s_fifo_outgoing_fee_1_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 2 rmap outgoing fifo has data available and is not queued
			if ((fee_2_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_2_queued = '0')) then
				-- fee 2 rmap outgoing fifo has data available and is not queued
				-- put fee 2 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_2;
				s_fifo_outgoing_fee_2_queued          <= '1';
				s_fifo_outgoing_fee_2_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 3 rmap outgoing fifo has data available and is not queued
			if ((fee_3_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_3_queued = '0')) then
				-- fee 3 rmap outgoing fifo has data available and is not queued
				-- put fee 3 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_3;
				s_fifo_outgoing_fee_3_queued          <= '1';
				s_fifo_outgoing_fee_3_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 4 rmap outgoing fifo has data available and is not queued
			if ((fee_4_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_4_queued = '0')) then
				-- fee 4 rmap outgoing fifo has data available and is not queued
				-- put fee 4 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_4;
				s_fifo_outgoing_fee_4_queued          <= '1';
				s_fifo_outgoing_fee_4_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- check if fee 5 rmap outgoing fifo has data available and is not queued
			if ((fee_5_rmap_outgoing_fifo_status_i.empty = '0') and (s_fifo_outgoing_fee_5_queued = '0')) then
				-- fee 5 rmap outgoing fifo has data available and is not queued
				-- put fee 5 rmap outgoing fifo in the queue
				s_rmap_fifo_queue(v_fifo_queue_index) <= fifo_outgoing_fee_5;
				s_fifo_outgoing_fee_5_queued          <= '1';
				s_fifo_outgoing_fee_5_in_use          <= '1';
				-- update fifo queue index
				if (v_fifo_queue_index < t_rmap_fifo_queue_index'high) then
					v_fifo_queue_index := v_fifo_queue_index + 1;
				end if;
			end if;

			-- fifo queue management
			-- case to handle the fifo queue
			case (s_rmap_fifo_queue(0)) is

				when fifo_none =>
					-- no fifo waiting at the queue
					s_selected_fifo <= fifo_none;

				when fifo_incoming_fee_0 =>
					-- fee 0 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_0;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_0_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_0_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_incoming_fee_1 =>
					-- fee 1 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_1;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_1_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_1_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_incoming_fee_2 =>
					-- fee 2 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_2;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_2_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_2_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_incoming_fee_3 =>
					-- fee 3 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_3;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_3_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_3_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_incoming_fee_4 =>
					-- fee 4 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_4;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_4_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_4_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_incoming_fee_5 =>
					-- fee 5 rmap incoming fifo at top of the queue
					s_selected_fifo <= fifo_incoming_fee_5;
					-- check if the fifo use is over
					if (s_fifo_incoming_fee_5_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_incoming_fee_5_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_0 =>
					-- fee 0 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_0;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_0_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_0_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_1 =>
					-- fee 1 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_1;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_1_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_1_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_2 =>
					-- fee 2 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_2;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_2_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_2_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_3 =>
					-- fee 3 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_3;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_3_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_3_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_4 =>
					-- fee 4 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_4;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_4_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_4_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

				when fifo_outgoing_fee_5 =>
					-- fee 5 rmap outgoing fifo at top of the queue
					s_selected_fifo <= fifo_outgoing_fee_5;
					-- check if the fifo use is over
					if (s_fifo_outgoing_fee_5_in_use = '0') then
						-- fifo use is over
						-- set fifo selection to none
						s_selected_fifo                                 <= fifo_none;
						-- remove fifo from the queue
						for index in 0 to (t_rmap_fifo_queue_index'high - 1) loop
							s_rmap_fifo_queue(index) <= s_rmap_fifo_queue(index + 1);
						end loop;
						s_rmap_fifo_queue(t_rmap_fifo_queue_index'high) <= fifo_none;
						s_fifo_outgoing_fee_5_queued                    <= '0';
						-- update fifo queue index
						if (v_fifo_queue_index > t_rmap_fifo_queue_index'low) then
							v_fifo_queue_index := v_fifo_queue_index - 1;
						end if;
					end if;

			end case;

			-- Output generation default values

			fee_0_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_0_rmap_outgoing_fifo_control_o.rdreq <= '0';
			fee_1_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_1_rmap_outgoing_fifo_control_o.rdreq <= '0';
			fee_2_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_2_rmap_outgoing_fifo_control_o.rdreq <= '0';
			fee_3_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_3_rmap_outgoing_fifo_control_o.rdreq <= '0';
			fee_4_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_4_rmap_outgoing_fifo_control_o.rdreq <= '0';
			fee_5_rmap_incoming_fifo_control_o.rdreq <= '0';
			fee_5_rmap_outgoing_fifo_control_o.rdreq <= '0';
			spw_codec_control_o.txwrite              <= '0';
			spw_codec_control_o.txflag               <= '0';
			spw_codec_control_o.txdata               <= (others => '0');

			-- States transitions FSM
			case (s_rmpe_rmap_echo_transmitter_state) is

				-- state "IDLE"
				when IDLE =>
					-- in idle, waiting a fifo be selected
					-- default state transition
					s_rmpe_rmap_echo_transmitter_state <= IDLE;
					v_rmpe_rmap_echo_transmitter_state := IDLE;
					-- default internal signal values
					-- conditional state transition
					-- check if there is a fifo was selected
					if (s_selected_fifo /= fifo_none) then
						-- a fifo was selected, go to waiting rmap data
						s_rmpe_rmap_echo_transmitter_state <= WAITING_RMAP_DATA;
						v_rmpe_rmap_echo_transmitter_state := WAITING_RMAP_DATA;
					end if;

				-- state "WAITING_RMAP_DATA"
				when WAITING_RMAP_DATA =>
					-- waiting data in the rmap data fifo
					-- default state transition
					s_rmpe_rmap_echo_transmitter_state <= WAITING_RMAP_DATA;
					v_rmpe_rmap_echo_transmitter_state := WAITING_RMAP_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if there is not a fifo selected
					if (s_selected_fifo = fifo_none) then
						-- no fifo selected (error) return to idle
						s_rmpe_rmap_echo_transmitter_state <= IDLE;
						v_rmpe_rmap_echo_transmitter_state := IDLE;
					-- check if there is space available in the spw codec and the selected fifo have data available
					elsif ((spw_codec_status_i.txrdy = '1') and (((s_selected_fifo = fifo_incoming_fee_0) and (fee_0_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_incoming_fee_1) and (fee_1_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_incoming_fee_2) and (fee_2_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_incoming_fee_3) and (fee_3_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_incoming_fee_4) and (fee_4_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_incoming_fee_5) and (fee_5_rmap_incoming_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_0) and (fee_0_rmap_outgoing_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_1) and (fee_1_rmap_outgoing_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_2) and (fee_2_rmap_outgoing_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_3) and (fee_3_rmap_outgoing_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_4) and (fee_4_rmap_outgoing_fifo_status_i.empty = '0')) or ((s_selected_fifo = fifo_outgoing_fee_5) and (fee_5_rmap_outgoing_fifo_status_i.empty = '0')))) then
						-- there is space available in the spw codec and the selected fifo have data available, fetch data
						s_rmpe_rmap_echo_transmitter_state <= FETCH_RMAP_DATA;
						v_rmpe_rmap_echo_transmitter_state := FETCH_RMAP_DATA;
						-- output generation
						-- fetch data from the selected fifo
						case (s_selected_fifo) is
							when fifo_none =>
								null;
							when fifo_incoming_fee_0 =>
								fee_0_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_incoming_fee_1 =>
								fee_1_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_incoming_fee_2 =>
								fee_2_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_incoming_fee_3 =>
								fee_3_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_incoming_fee_4 =>
								fee_4_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_incoming_fee_5 =>
								fee_5_rmap_incoming_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_0 =>
								fee_0_rmap_outgoing_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_1 =>
								fee_1_rmap_outgoing_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_2 =>
								fee_2_rmap_outgoing_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_3 =>
								fee_3_rmap_outgoing_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_4 =>
								fee_4_rmap_outgoing_fifo_control_o.rdreq <= '1';
							when fifo_outgoing_fee_5 =>
								fee_5_rmap_outgoing_fifo_control_o.rdreq <= '1';
						end case;
					end if;

				-- state "FETCH_RMAP_DATA"
				when FETCH_RMAP_DATA =>
					-- fetching data from the rmap data fifo
					-- default state transition
					s_rmpe_rmap_echo_transmitter_state <= WRITE_RMAP_DATA;
					v_rmpe_rmap_echo_transmitter_state := WRITE_RMAP_DATA;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_RMAP_DATA"
				when WRITE_RMAP_DATA =>
					-- write rmap packet data
					-- default state transition
					s_rmpe_rmap_echo_transmitter_state <= WAITING_RMAP_DATA;
					v_rmpe_rmap_echo_transmitter_state := WAITING_RMAP_DATA;
					-- default internal signal values
					-- conditional state transition
					-- check if there is not a fifo selected
					if (s_selected_fifo = fifo_none) then
						-- no fifo selected (error) return to idle
						s_rmpe_rmap_echo_transmitter_state <= IDLE;
						v_rmpe_rmap_echo_transmitter_state := IDLE;
					-- check if an end of packet was received
					elsif (((s_selected_fifo = fifo_incoming_fee_0) and (fee_0_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_incoming_fee_1) and (fee_1_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_incoming_fee_2) and (fee_2_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_incoming_fee_3) and (fee_3_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_incoming_fee_4) and (fee_4_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_incoming_fee_5) and (fee_5_rmap_incoming_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_0) and (fee_0_rmap_outgoing_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_1) and (fee_1_rmap_outgoing_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_2) and (fee_2_rmap_outgoing_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_3) and (fee_3_rmap_outgoing_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_4) and (fee_4_rmap_outgoing_fifo_status_i.rddata_flag = '1')) or ((s_selected_fifo = fifo_outgoing_fee_5) and (fee_5_rmap_outgoing_fifo_status_i.rddata_flag = '1'))) then
						-- end of packet was received, return to idle
						case (s_selected_fifo) is
							when fifo_none =>
								null;
							when fifo_incoming_fee_0 =>
								s_fifo_incoming_fee_0_in_use <= '0';
							when fifo_incoming_fee_1 =>
								s_fifo_incoming_fee_1_in_use <= '0';
							when fifo_incoming_fee_2 =>
								s_fifo_incoming_fee_2_in_use <= '0';
							when fifo_incoming_fee_3 =>
								s_fifo_incoming_fee_3_in_use <= '0';
							when fifo_incoming_fee_4 =>
								s_fifo_incoming_fee_4_in_use <= '0';
							when fifo_incoming_fee_5 =>
								s_fifo_incoming_fee_5_in_use <= '0';
							when fifo_outgoing_fee_0 =>
								s_fifo_outgoing_fee_0_in_use <= '0';
							when fifo_outgoing_fee_1 =>
								s_fifo_outgoing_fee_1_in_use <= '0';
							when fifo_outgoing_fee_2 =>
								s_fifo_outgoing_fee_2_in_use <= '0';
							when fifo_outgoing_fee_3 =>
								s_fifo_outgoing_fee_3_in_use <= '0';
							when fifo_outgoing_fee_4 =>
								s_fifo_outgoing_fee_4_in_use <= '0';
							when fifo_outgoing_fee_5 =>
								s_fifo_outgoing_fee_5_in_use <= '0';
						end case;
						s_rmpe_rmap_echo_transmitter_state <= IDLE;
						v_rmpe_rmap_echo_transmitter_state := IDLE;
					end if;
					-- output generation
					-- write data to the spw codec
					case (s_selected_fifo) is
						when fifo_none =>
							null;
						when fifo_incoming_fee_0 =>
							spw_codec_control_o.txflag  <= fee_0_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_0_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_incoming_fee_1 =>
							spw_codec_control_o.txflag  <= fee_1_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_1_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_incoming_fee_2 =>
							spw_codec_control_o.txflag  <= fee_2_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_2_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_incoming_fee_3 =>
							spw_codec_control_o.txflag  <= fee_3_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_3_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_incoming_fee_4 =>
							spw_codec_control_o.txflag  <= fee_4_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_4_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_incoming_fee_5 =>
							spw_codec_control_o.txflag  <= fee_5_rmap_incoming_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_5_rmap_incoming_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_0 =>
							spw_codec_control_o.txflag  <= fee_0_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_0_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_1 =>
							spw_codec_control_o.txflag  <= fee_1_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_1_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_2 =>
							spw_codec_control_o.txflag  <= fee_2_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_2_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_3 =>
							spw_codec_control_o.txflag  <= fee_3_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_3_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_4 =>
							spw_codec_control_o.txflag  <= fee_4_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_4_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
						when fifo_outgoing_fee_5 =>
							spw_codec_control_o.txflag  <= fee_5_rmap_outgoing_fifo_status_i.rddata_flag;
							spw_codec_control_o.txdata  <= fee_5_rmap_outgoing_fifo_status_i.rddata_data;
							spw_codec_control_o.txwrite <= '1';
					end case;

				-- all the other states (not defined)
				when others =>
					s_rmpe_rmap_echo_transmitter_state <= IDLE;
					v_rmpe_rmap_echo_transmitter_state := IDLE;

			end case;

			-- Output generation default values

			-- Output generation FSM

			case (v_rmpe_rmap_echo_transmitter_state) is

				-- state "IDLE"
				when IDLE =>
					-- in idle, waiting a fifo be selected
					-- default output signals
					-- conditional output signals

					-- state "WAITING_RMAP_DATA"
				when WAITING_RMAP_DATA =>
					-- waiting data in the rmap data fifo
					-- default output signals
					-- conditional output signals

					-- state "FETCH_RMAP_DATA"
				when FETCH_RMAP_DATA =>
					-- fetching data from the rmap data fifo
					-- default output signals
					-- conditional output signals

					-- state "WRITE_RMAP_DATA"
				when WRITE_RMAP_DATA =>
					-- write rmap packet data
					-- default output signals
					-- conditional output signals

			end case;

		end if;
	end process p_rmpe_rmap_echo_transmitter;

end architecture RTL;
