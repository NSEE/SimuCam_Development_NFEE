library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_irq_manager_pkg.all;

entity ftdi_tx_irq_manager_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		irq_manager_stop_i  : in  std_logic;
		irq_manager_start_i : in  std_logic;
		global_irq_en_i     : in  std_logic;
		irq_watches_i       : in  t_ftdi_tx_irq_manager_watches;
		irq_flags_en_i      : in  t_ftdi_tx_irq_manager_flags;
		irq_flags_clr_i     : in  t_ftdi_tx_irq_manager_flags;
		irq_flags_o         : out t_ftdi_tx_irq_manager_flags;
		irq_o               : out std_logic
	);
end entity ftdi_tx_irq_manager_ent;

architecture RTL of ftdi_tx_irq_manager_ent is

	signal s_irq_manager_started : std_logic;
	signal s_irq_watches_delayed : t_ftdi_tx_irq_manager_watches;
	signal s_irq_flags           : t_ftdi_tx_irq_manager_flags;

begin

	p_ftdi_tx_irq_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_irq_manager_started <= '0';
			s_irq_watches_delayed <= c_FTDI_TX_IRQ_MANAGER_WATCHES_RST;
			s_irq_flags           <= c_FTDI_TX_IRQ_MANAGER_FLAGS_RST;

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
				s_irq_flags <= c_FTDI_TX_IRQ_MANAGER_FLAGS_RST;
			else
				-- clear flags --
				if (irq_flags_clr_i.tx_lut_finished = '1') then
					s_irq_flags.tx_lut_finished <= '0';
				end if;
				if (irq_flags_clr_i.tx_lut_comm_err = '1') then
					s_irq_flags.tx_lut_comm_err <= '0';
				end if;
				-- set flags --
				-- check if the global interrupt is enabled
				if (global_irq_en_i = '1') then
					if (irq_flags_en_i.tx_lut_finished = '1') then
						if ((s_irq_watches_delayed.tx_lut_transmitted = '0') and (irq_watches_i.tx_lut_transmitted = '1')) then
							s_irq_flags.tx_lut_finished <= '1';
						end if;
					end if;
					if (irq_flags_en_i.tx_lut_comm_err = '1') then
						if ((s_irq_watches_delayed.tx_lut_comm_err_state = '0') and (irq_watches_i.tx_lut_comm_err_state = '1')) then
							s_irq_flags.tx_lut_comm_err <= '1';
						end if;
					end if;
				end if;
			end if;

			-- delay signals
			s_irq_watches_delayed <= irq_watches_i;

		end if;
	end process p_ftdi_tx_irq_manager;

	-- irq assignment and outputs generation
	irq_flags_o <= s_irq_flags;
	irq_o       <= ('0') when (rst_i = '1')
	               else ('1') when ((s_irq_flags.tx_lut_finished = '1') or (s_irq_flags.tx_lut_comm_err = '1'))
	               else ('0');

end architecture RTL;
