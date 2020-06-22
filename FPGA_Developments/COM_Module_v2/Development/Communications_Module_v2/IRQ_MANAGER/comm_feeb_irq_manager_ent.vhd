library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_irq_manager_pkg.all;

entity comm_feeb_irq_manager_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		irq_manager_stop_i  : in  std_logic;
		irq_manager_start_i : in  std_logic;
		global_irq_en_i     : in  std_logic;
		irq_watches_i       : in  t_comm_feeb_irq_manager_watches;
		irq_flags_en_i      : in  t_comm_feeb_irq_manager_flags;
		irq_flags_clr_i     : in  t_comm_feeb_irq_manager_flags;
		irq_flags_o         : out t_comm_feeb_irq_manager_flags;
		irq_o               : out std_logic
	);
end entity comm_feeb_irq_manager_ent;

architecture RTL of comm_feeb_irq_manager_ent is

	signal s_irq_manager_started : std_logic;
	signal s_irq_watches_delayed : t_comm_feeb_irq_manager_watches;
	signal s_irq_flags           : t_comm_feeb_irq_manager_flags;

begin

	p_comm_feeb_irq_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_irq_manager_started <= '0';
			s_irq_watches_delayed <= c_COMM_FEEB_IRQ_MANAGER_WATCHES_RST;
			s_irq_flags           <= c_COMM_FEEB_IRQ_MANAGER_FLAGS_RST;

		elsif (rising_edge(clk_i)) then

			-- manage start/stop
			if (irq_manager_start_i = '1') then
				s_irq_manager_started <= '1';
			elsif (irq_manager_stop_i = '1') then
				s_irq_manager_started <= '0';
			end if;

			-- manage flags
			if (s_irq_manager_started = '0') then
				-- keep flags cleared
				s_irq_flags <= c_COMM_FEEB_IRQ_MANAGER_FLAGS_RST;
			else
				-- clear flags --
				-- check if a left buffer empty flag clear command was received
				if (irq_flags_clr_i.left_buffer_empty = '1') then
					s_irq_flags.left_buffer_empty <= '0';
				end if;
				-- check if a right buffer empty flag clear command was received
				if (irq_flags_clr_i.right_buffer_empty = '1') then
					s_irq_flags.right_buffer_empty <= '0';
				end if;
				-- set flags --
				-- check if the global interrupt is enabled
				if (global_irq_en_i = '1') then
					-- check if the left buffer empty interrupt is activated
					if (irq_flags_en_i.left_buffer_empty = '1') then
						-- detect a rising edge in left buffer empty signal
						if ((s_irq_watches_delayed.left_buffer_empty = '0') and (irq_watches_i.left_buffer_empty = '1')) then
							s_irq_flags.left_buffer_empty <= '1';
						end if;
					end if;
					-- check if the right buffer empty interrupt is activated
					if (irq_flags_en_i.right_buffer_empty = '1') then
						-- detect a rising edge in right buffer empty signal
						if ((s_irq_watches_delayed.right_buffer_empty = '0') and (irq_watches_i.right_buffer_empty = '1')) then
							s_irq_flags.right_buffer_empty <= '1';
						end if;
					end if;
				end if;
			end if;

			-- delay signals
			s_irq_watches_delayed <= irq_watches_i;

		end if;
	end process p_comm_feeb_irq_manager;

	-- irq assignment and outputs generation
	irq_flags_o <= s_irq_flags;
	irq_o       <= ('0') when (rst_i = '1')
	               else ('1') when ((s_irq_flags.left_buffer_empty = '1') or (s_irq_flags.right_buffer_empty = '1'))
	               else ('0');

end architecture RTL;
