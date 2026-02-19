library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_irq_manager_pkg.all;

entity comm_rmap_irq_manager_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		irq_manager_stop_i  : in  std_logic;
		irq_manager_start_i : in  std_logic;
		global_irq_en_i     : in  std_logic;
		irq_rate_limits_i   : in  t_ftdi_comm_rmap_manager_rate_limits;
		irq_rate_clears_i   : in  t_ftdi_comm_rmap_manager_rate_clears;
		irq_watches_i       : in  t_ftdi_comm_rmap_manager_watches;
		irq_contexts_i      : in  t_ftdi_comm_rmap_manager_contexts;
		irq_flags_en_i      : in  t_ftdi_comm_rmap_manager_flags;
		irq_flags_clr_i     : in  t_ftdi_comm_rmap_manager_flags;
		irq_rate_counters_o : out t_ftdi_comm_rmap_manager_rate_counters;
		irq_flags_o         : out t_ftdi_comm_rmap_manager_flags;
		irq_events_between_o: out t_ftdi_comm_rmap_manager_rate_counters;
		irq_o               : out std_logic
	);
end entity comm_rmap_irq_manager_ent;

architecture RTL of comm_rmap_irq_manager_ent is

	signal s_irq_manager_started : std_logic;
	signal s_irq_watches_delayed : t_ftdi_comm_rmap_manager_watches;
	signal s_irq_flags           : t_ftdi_comm_rmap_manager_flags;
	signal s_irq_pending_flags   : t_ftdi_comm_rmap_manager_flags;

	signal s_irq_rate_event_req_config   : std_logic;
	signal s_irq_rate_event_req_window   : std_logic;
	signal s_irq_rate_event_pulse_config : std_logic;
	signal s_irq_rate_event_pulse_window : std_logic;
	signal s_irq_rate_counter_config     : std_logic_vector(31 downto 0);
	signal s_irq_rate_counter_window     : std_logic_vector(31 downto 0);
	signal s_irq_events_between_config   : std_logic_vector(31 downto 0);
	signal s_irq_events_between_window   : std_logic_vector(31 downto 0);
	signal s_irq_rate_rst                : std_logic;

begin

	s_irq_rate_rst <= rst_i or (not s_irq_manager_started);

	comm_irq_rate_limiter_config_ent_inst : entity work.comm_irq_rate_limiter_ent
		port map(
			clk_i         => clk_i,
			rst_i         => s_irq_rate_rst,
			in_pulse_i    => s_irq_rate_event_req_config,
			limit_i       => irq_rate_limits_i.rmap_write_config_limit,
			count_clear_i => irq_rate_clears_i.rmap_write_config_clear,
			irq_pulse_o   => s_irq_rate_event_pulse_config,
			event_count_o => s_irq_rate_counter_config,
			event_between_o => s_irq_events_between_config
		);

	comm_irq_rate_limiter_window_ent_inst : entity work.comm_irq_rate_limiter_ent
		port map(
			clk_i         => clk_i,
			rst_i         => s_irq_rate_rst,
			in_pulse_i    => s_irq_rate_event_req_window,
			limit_i       => irq_rate_limits_i.rmap_write_window_limit,
			count_clear_i => irq_rate_clears_i.rmap_write_window_clear,
			irq_pulse_o   => s_irq_rate_event_pulse_window,
			event_count_o => s_irq_rate_counter_window,
			event_between_o => s_irq_events_between_window
		);

	p_ftdi_comm_rmap_manager : process(clk_i, rst_i) is
		variable v_irq_flags_next         : t_ftdi_comm_rmap_manager_flags;
		variable v_irq_pending_flags_next : t_ftdi_comm_rmap_manager_flags;
	begin
		if (rst_i = '1') then

			s_irq_manager_started <= '0';
			s_irq_watches_delayed <= c_COMM_RMAP_IRQ_MANAGER_WATCHES_RST;
			s_irq_flags           <= c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;
			s_irq_pending_flags   <= c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;
			s_irq_rate_event_req_config <= '0';
			s_irq_rate_event_req_window <= '0';

		elsif (rising_edge(clk_i)) then
			v_irq_flags_next         := s_irq_flags;
			v_irq_pending_flags_next := s_irq_pending_flags;

			-- default
			s_irq_rate_event_req_config <= '0';
			s_irq_rate_event_req_window <= '0';

			-- manage start/stop
			if (irq_manager_start_i = '1') then
				s_irq_manager_started <= '1';
			elsif (irq_manager_stop_i = '1') then
				s_irq_manager_started <= '0';
			end if;

			-- manage flags
			if (s_irq_manager_started = '0') then
				-- keep flags cleared
				v_irq_flags_next         := c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;
				v_irq_pending_flags_next := c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;
			else
				-- clear flags --
				if (irq_flags_clr_i.rmap_write_config_flag = '1') then
					v_irq_flags_next.rmap_write_config_flag         := '0';
					v_irq_pending_flags_next.rmap_write_config_flag := '0';
				end if;
				if (irq_flags_clr_i.rmap_write_window_flag = '1') then
					v_irq_flags_next.rmap_write_window_flag         := '0';
					v_irq_pending_flags_next.rmap_write_window_flag := '0';
				end if;

				-- capture events (with full context) --
				-- check if the global interrupt is enabled
				if (global_irq_en_i = '1') then
					-- detect a rising edge in write finished signal
					if ((s_irq_watches_delayed.rmap_write_data_finished = '0') and (irq_watches_i.rmap_write_data_finished = '1')) then
						-- check if the write was authorized (not discarded)
						if (irq_contexts_i.rmap_write_data_authorized = '1') then
							-- check if the write was to a config area
							if (irq_contexts_i.rmap_win_area_write_flag = '0') then
								-- the write was not to a windowing area
								-- check if the rmap config write finished interrupt is activated
								if (irq_flags_en_i.rmap_write_config_flag = '1') then
									v_irq_pending_flags_next.rmap_write_config_flag := '1';
									s_irq_rate_event_req_config                    <= '1';
								end if;
							else
								-- the write was to a windowing area
								-- check if the rmap window write finished interrupt is activated
								if (irq_flags_en_i.rmap_write_window_flag = '1') then
									v_irq_pending_flags_next.rmap_write_window_flag := '1';
									s_irq_rate_event_req_window                    <= '1';
								end if;
							end if;
						end if;
					end if;
				end if;

				-- release coalesced config event based on config rate limiter pulse
				if (s_irq_rate_event_pulse_config = '1') then
					if (v_irq_pending_flags_next.rmap_write_config_flag = '1') then
						if (irq_flags_clr_i.rmap_write_config_flag = '0') then
							v_irq_flags_next.rmap_write_config_flag         := '1';
							v_irq_pending_flags_next.rmap_write_config_flag := '0';
						end if;
					end if;
				end if;

				-- release coalesced window event based on window rate limiter pulse
				if (s_irq_rate_event_pulse_window = '1') then
					if (v_irq_pending_flags_next.rmap_write_window_flag = '1') then
						if (irq_flags_clr_i.rmap_write_window_flag = '0') then
							v_irq_flags_next.rmap_write_window_flag         := '1';
							v_irq_pending_flags_next.rmap_write_window_flag := '0';
						end if;
					end if;
				end if;
			end if;

			-- delay signals
			s_irq_watches_delayed <= irq_watches_i;
			s_irq_flags           <= v_irq_flags_next;
			s_irq_pending_flags   <= v_irq_pending_flags_next;

		end if;
	end process p_ftdi_comm_rmap_manager;

	-- irq assignment and outputs generation
	irq_flags_o                                <= s_irq_flags;
	irq_rate_counters_o.rmap_write_config_counter <= s_irq_rate_counter_config;
	irq_rate_counters_o.rmap_write_window_counter <= s_irq_rate_counter_window;
	irq_events_between_o.rmap_write_config_counter <= s_irq_events_between_config;
	irq_events_between_o.rmap_write_window_counter <= s_irq_events_between_window;
	irq_o       <= ('0') when (rst_i = '1')
	               else ('1') when ((s_irq_flags.rmap_write_config_flag = '1') or (s_irq_flags.rmap_write_window_flag = '1'))
	               else ('0');

end architecture RTL;
