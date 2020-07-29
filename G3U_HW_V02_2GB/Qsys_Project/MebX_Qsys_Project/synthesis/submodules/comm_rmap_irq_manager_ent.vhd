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
		irq_watches_i       : in  t_ftdi_comm_rmap_manager_watches;
		irq_contexts_i      : in  t_ftdi_comm_rmap_manager_contexts;
		irq_flags_en_i      : in  t_ftdi_comm_rmap_manager_flags;
		irq_flags_clr_i     : in  t_ftdi_comm_rmap_manager_flags;
		irq_flags_o         : out t_ftdi_comm_rmap_manager_flags;
		irq_o               : out std_logic
	);
end entity comm_rmap_irq_manager_ent;

architecture RTL of comm_rmap_irq_manager_ent is

	signal s_irq_manager_started : std_logic;
	signal s_irq_watches_delayed : t_ftdi_comm_rmap_manager_watches;
	signal s_irq_flags           : t_ftdi_comm_rmap_manager_flags;

begin

	p_ftdi_comm_rmap_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_irq_manager_started <= '0';
			s_irq_watches_delayed <= c_COMM_RMAP_IRQ_MANAGER_WATCHES_RST;
			s_irq_flags           <= c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;

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
				s_irq_flags <= c_COMM_RMAP_IRQ_MANAGER_FLAGS_RST;
			else
				-- clear flags --
				if (irq_flags_clr_i.rmap_write_config_flag = '1') then
					s_irq_flags.rmap_write_config_flag <= '0';
				end if;
				if (irq_flags_clr_i.rmap_write_window_flag = '1') then
					s_irq_flags.rmap_write_window_flag <= '0';
				end if;
				-- set flags --
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
									s_irq_flags.rmap_write_config_flag <= '1';
								end if;
							else
								-- the write was to a windowing area
								-- check if the rmap window write finished interrupt is activated
								if (irq_flags_en_i.rmap_write_window_flag = '1') then
									s_irq_flags.rmap_write_window_flag <= '1';
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;

			-- delay signals
			s_irq_watches_delayed <= irq_watches_i;

		end if;
	end process p_ftdi_comm_rmap_manager;

	-- irq assignment and outputs generation
	irq_flags_o <= s_irq_flags;
	irq_o       <= ('0') when (rst_i = '1')
	               else ('1') when ((s_irq_flags.rmap_write_config_flag = '1') or (s_irq_flags.rmap_write_window_flag = '1'))
	               else ('0');

end architecture RTL;
