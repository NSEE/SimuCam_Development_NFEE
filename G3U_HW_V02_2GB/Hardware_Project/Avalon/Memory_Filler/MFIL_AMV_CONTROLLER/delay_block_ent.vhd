library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_block_ent is
	generic(
		g_CLKDIV      : std_logic_vector(15 downto 0);
		g_TIMER_WIDTH : natural range 8 to 32
	);
	port(
		clk_i            : in  std_logic;
		rst_i            : in  std_logic;
		clr_i            : in  std_logic;
		delay_trigger_i  : in  std_logic;
		delay_timer_i    : in  std_logic_vector((g_TIMER_WIDTH - 1) downto 0);
		delay_busy_o     : out std_logic;
		delay_finished_o : out std_logic
	);
end entity delay_block_ent;

architecture RTL of delay_block_ent is

	signal s_clkdiv_cnt : std_logic_vector((g_CLKDIV'length - 1) downto 0);
	signal s_clkdiv_evt : std_logic;
	signal s_timer_cnt  : std_logic_vector((g_TIMER_WIDTH - 1) downto 0);
	signal s_idle       : std_logic;
	signal s_clk_evt    : std_logic;
	signal s_clk_n      : std_logic;

begin

	p_delay_block : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_timer_cnt      <= std_logic_vector(to_unsigned(0, g_TIMER_WIDTH));
			s_clkdiv_cnt     <= std_logic_vector(to_unsigned(0, g_CLKDIV'length));
			s_clkdiv_evt     <= '0';
			s_idle           <= '1';
			delay_busy_o     <= '0';
			delay_finished_o <= '0';
		elsif rising_edge(clk_i) then

			-- check if the module is in idle or in middle of a delay
			if (s_idle = '1') then
				-- module in idle, wait for a delay trigger
				s_idle           <= '1';
				delay_busy_o     <= '0';
				delay_finished_o <= '0';
				s_timer_cnt      <= std_logic_vector(to_unsigned(0, g_TIMER_WIDTH));
				s_clkdiv_evt     <= '0';
				s_clkdiv_cnt     <= std_logic_vector(to_unsigned(0, g_CLKDIV'length));
				-- check if a delay was triggered
				if (delay_trigger_i = '1') then
					-- check if the timer is 0 (no delay)
					if (delay_timer_i = std_logic_vector(to_unsigned(0, g_TIMER_WIDTH))) then
						-- no delay, just generate a finish
						delay_finished_o <= '1';
					else
						s_idle       <= '0';
						delay_busy_o <= '1';
						s_timer_cnt  <= std_logic_vector(unsigned(delay_timer_i) - 1);
						s_clkdiv_cnt <= std_logic_vector(to_unsigned(1, g_CLKDIV'length));
					end if;
				end if;
			elsif (clr_i = '1') then
				s_timer_cnt      <= std_logic_vector(to_unsigned(0, g_TIMER_WIDTH));
				s_clkdiv_cnt     <= std_logic_vector(to_unsigned(0, g_CLKDIV'length));
				s_clkdiv_evt     <= '0';
				s_idle           <= '1';
				delay_busy_o     <= '0';
				delay_finished_o <= '0';
			else
				-- module in middle of delay
				s_idle           <= '0';
				delay_busy_o     <= '1';
				delay_finished_o <= '0';

				-- generate clkdiv event
				s_clkdiv_evt <= '0';
				s_clkdiv_cnt <= std_logic_vector(unsigned(s_clkdiv_cnt) + 1);
				if (s_clkdiv_cnt = g_CLKDIV) then
					s_clkdiv_evt <= '1';
					s_clkdiv_cnt <= std_logic_vector(to_unsigned(0, g_CLKDIV'length));
				end if;

				-- check if a clkdiv event ocurred
				if (s_clk_evt = '1') then
					-- check if the timer counter finished
					if (s_timer_cnt = std_logic_vector(to_unsigned(0, g_TIMER_WIDTH))) then
						-- signal a delay finished
						delay_finished_o <= '1';
						s_idle           <= '1';
						delay_busy_o     <= '0';
						s_timer_cnt      <= std_logic_vector(to_unsigned(0, g_TIMER_WIDTH));
					else
						-- decrement timer counter
						s_timer_cnt <= std_logic_vector(unsigned(s_timer_cnt) - 1);
					end if;
				end if;
			end if;
		end if;
	end process p_delay_block;

	s_clk_evt <= ('0') when (rst_i = '1')
		else (s_clk_n) when (g_CLKDIV = x"0000")
		else (s_clkdiv_evt);

	s_clk_n <= not clk_i;

end architecture RTL;
