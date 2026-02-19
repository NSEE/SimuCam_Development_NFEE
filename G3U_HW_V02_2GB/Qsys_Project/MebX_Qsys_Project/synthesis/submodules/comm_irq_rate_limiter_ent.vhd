library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comm_irq_rate_limiter_ent is
	port(
		clk_i            : in  std_logic;
		rst_i            : in  std_logic;
		in_pulse_i       : in  std_logic;
		limit_i          : in  std_logic_vector(31 downto 0);
		count_clear_i    : in  std_logic;
		irq_pulse_o      : out std_logic;
		event_count_o    : out std_logic_vector(31 downto 0);
		event_between_o  : out std_logic_vector(31 downto 0)
	);
end entity comm_irq_rate_limiter_ent;

architecture RTL of comm_irq_rate_limiter_ent is

	signal s_in_pulse_delayed : std_logic;
	signal s_in_pulse_rise    : std_logic;
	signal s_event_count      : unsigned(31 downto 0);
	signal s_event_between    : unsigned(31 downto 0);
	signal s_event_between_l  : unsigned(31 downto 0);
	signal s_timer_running    : std_logic;
	signal s_timer            : unsigned(31 downto 0);
	signal s_pending          : std_logic;
	signal s_irq_pulse        : std_logic;

begin

	p_comm_irq_rate_limiter : process(clk_i, rst_i) is
		variable v_limit_u : unsigned(31 downto 0);
		variable v_irq_pulse : std_logic;
		variable v_between_next : unsigned(31 downto 0);
	begin
		if (rst_i = '1') then

			s_in_pulse_delayed <= '0';
			s_in_pulse_rise    <= '0';
			s_event_count      <= (others => '0');
			s_event_between    <= (others => '0');
			s_event_between_l  <= (others => '0');
			s_timer_running    <= '0';
			s_timer            <= (others => '0');
			s_pending          <= '0';
			s_irq_pulse        <= '0';

		elsif (rising_edge(clk_i)) then

			-- defaults
			v_irq_pulse := '0';
			v_limit_u   := unsigned(limit_i);

			-- detect rising edge
			s_in_pulse_delayed <= in_pulse_i;
			s_in_pulse_rise    <= in_pulse_i and (not s_in_pulse_delayed);

			-- saturating event counter
			if (count_clear_i = '1') then
				s_event_count <= (others => '0');
			elsif (s_in_pulse_rise = '1') then
				if (s_event_count /= x"FFFF_FFFF") then
					s_event_count <= s_event_count + 1;
				end if;
			end if;

			-- timer handling
			if (s_timer_running = '1') then
				if (s_timer /= 0) then
					s_timer <= s_timer - 1;
				else
					-- cooldown expired
					if (s_pending = '1') then
						v_irq_pulse := '1';
						s_pending   <= '0';

						if (v_limit_u > 0) then
							s_timer <= v_limit_u - 1;
						else
							s_timer <= (others => '0');
						end if;

						s_timer_running <= '1';
					else
						s_timer_running <= '0';
					end if;
				end if;
			end if;

			-- irq generation / coalescing
			if (s_in_pulse_rise = '1') then
				if (s_timer_running = '0') then
					v_irq_pulse     := '1';
					s_pending       <= '0';
					s_timer_running <= '1';

					if (v_limit_u > 0) then
						s_timer <= v_limit_u - 1;
					else
						s_timer <= (others => '0');
					end if;
				else
					s_pending <= '1';
				end if;
			end if;

			-- Accumulate events between IRQ pulses and latch on IRQ generation.
			v_between_next := s_event_between;
			if (s_in_pulse_rise = '1') then
				if (s_event_between /= x"FFFF_FFFF") then
					v_between_next := s_event_between + 1;
				end if;
			end if;

			if (v_irq_pulse = '1') then
				s_event_between_l <= v_between_next;
				s_event_between   <= (others => '0');
			else
				s_event_between <= v_between_next;
			end if;

			s_irq_pulse <= v_irq_pulse;

		end if;
	end process p_comm_irq_rate_limiter;

	irq_pulse_o   <= s_irq_pulse;
	event_count_o <= std_logic_vector(s_event_count);
	event_between_o <= std_logic_vector(s_event_between_l);

end architecture RTL;
