--=============================================================================
--! @file pre_sync_irq.vhd
--=============================================================================
--! Standard library
library ieee;
--! Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! Specific packages
use work.sync_irq_pkg.all;
use work.sync_common_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync interrupt (pre_sync_irq)
--
--! @brief 
--
--! @author Cassio Berni (ccberni@hotmail.com)
--
--! @date 15\11\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: 
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 15\11\2018 CB File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for pre_sync_irq
--============================================================================
entity pre_sync_irq is
	generic(
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;
		g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
	);
	port(
		clk_i            : in  std_logic;
		reset_n_i        : in  std_logic;
		irq_enable_i     : in  t_pre_sync_irq_enable;
		irq_flag_clear_i : in  t_pre_sync_irq_flag_clear;
		irq_watch_i      : in  t_pre_sync_irq_watch;
		irq_flag_o       : out t_pre_sync_irq_flag;
		irq_o            : out std_logic
	);
end entity pre_sync_irq;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of pre_sync_irq is

	constant c_ZERO : std_logic_vector(7 downto 0) := (others => '0');

	-- Aux to read back int flags outputs
	-- It is not necessary with vhdl 2008 and further
	signal s_irq_flag                : t_pre_sync_irq_flag;
	signal s_irq_flag_delayed        : t_pre_sync_irq_flag;
	signal s_irq_flag_edge_triggered : t_pre_sync_irq_flag;

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	p_pre_sync_irq : process(clk_i, reset_n_i) is
	begin
		if (reset_n_i = '0') then
			-- Reset flags and irq
			s_irq_flag                <= (others => '0');
			s_irq_flag_delayed        <= (others => '0');
			s_irq_flag_edge_triggered <= (others => '0');

		elsif (rising_edge(clk_i)) then

			-- Logic for blank pulse
			-- Activate blank pulse flag if: pre-sync wave is at blank level
			if (irq_watch_i.pre_sync_wave_watch = irq_watch_i.pre_sync_pol_watch) then
				s_irq_flag.pre_blank_pulse_irq_flag <= '1';
			else
				s_irq_flag.pre_blank_pulse_irq_flag <= '0';
			end if;
			-- Set and clear flag
			-- Check if flag was triggered and is enabled
			if ((s_irq_flag_delayed.pre_blank_pulse_irq_flag = '0') and (s_irq_flag.pre_blank_pulse_irq_flag = '1') and (irq_enable_i.pre_blank_pulse_irq_enable = '1')) then
				s_irq_flag_edge_triggered.pre_blank_pulse_irq_flag <= '1';
			end if;
			-- check if a flag clear was issued
			if (irq_flag_clear_i.pre_blank_pulse_irq_flag_clear = '1') then
				s_irq_flag_edge_triggered.pre_blank_pulse_irq_flag <= '0';
			end if;

			-- Logic for master pulse
			-- Activate master pulse flag if: pre-sync wave is at blank level and sync cycle number is at zero (master)
			if ((irq_watch_i.pre_sync_wave_watch = irq_watch_i.pre_sync_pol_watch) and (unsigned(irq_watch_i.pre_sync_cycle_number) = 0)) then
				s_irq_flag.pre_master_pulse_irq_flag <= '1';
			else
				s_irq_flag.pre_master_pulse_irq_flag <= '0';
			end if;
			-- Set and clear flag
			-- Check if flag was triggered and is enabled
			if ((s_irq_flag_delayed.pre_master_pulse_irq_flag = '0') and (s_irq_flag.pre_master_pulse_irq_flag = '1') and (irq_enable_i.pre_master_pulse_irq_enable = '1')) then
				s_irq_flag_edge_triggered.pre_master_pulse_irq_flag <= '1';
			end if;
			-- check if a flag clear was issued
			if (irq_flag_clear_i.pre_master_pulse_irq_flag_clear = '1') then
				s_irq_flag_edge_triggered.pre_master_pulse_irq_flag <= '0';
			end if;

			-- Logic for normal pulse
			-- check if this falg can be triggered
			if (unsigned(irq_watch_i.pre_sync_number_of_cycles) > 2) then
				-- flag can be triggered
				-- Activate normal pulse flag if: pre-sync wave is at blank level and sync cycle number is between 0 (master) and (sync number of cicles - 1) (last)
				if ((irq_watch_i.pre_sync_wave_watch = irq_watch_i.pre_sync_pol_watch) and (unsigned(irq_watch_i.pre_sync_cycle_number) > 0) and (unsigned(irq_watch_i.pre_sync_cycle_number) < (unsigned(irq_watch_i.pre_sync_number_of_cycles) - 1))) then
					s_irq_flag.pre_normal_pulse_irq_flag <= '1';
				else
					s_irq_flag.pre_normal_pulse_irq_flag <= '0';
				end if;
				-- Set and clear flag
				-- Check if flag was triggered and is enabled
				if ((s_irq_flag_delayed.pre_normal_pulse_irq_flag = '0') and (s_irq_flag.pre_normal_pulse_irq_flag = '1') and (irq_enable_i.pre_normal_pulse_irq_enable = '1')) then
					s_irq_flag_edge_triggered.pre_normal_pulse_irq_flag <= '1';
				end if;
				-- check if a flag clear was issued
				if (irq_flag_clear_i.pre_normal_pulse_irq_flag_clear = '1') then
					s_irq_flag_edge_triggered.pre_normal_pulse_irq_flag <= '0';
				end if;
			else
				-- flag cannot be triggered
				s_irq_flag.pre_normal_pulse_irq_flag                <= '0';
				s_irq_flag_edge_triggered.pre_normal_pulse_irq_flag <= '0';
			end if;

			-- Logic for last pulse
			-- check if this falg can be triggered
			if (unsigned(irq_watch_i.pre_sync_number_of_cycles) > 1) then
				-- flag can be triggered
				-- Activate blank last flag if: pre-sync wave is at blank level and sync cycle number is at (sync number of cicles - 1) (last)
				if ((irq_watch_i.pre_sync_wave_watch = irq_watch_i.pre_sync_pol_watch) and (unsigned(irq_watch_i.pre_sync_cycle_number) = (unsigned(irq_watch_i.pre_sync_number_of_cycles) - 1))) then
					s_irq_flag.pre_last_pulse_irq_flag <= '1';
				else
					s_irq_flag.pre_last_pulse_irq_flag <= '0';
				end if;
				-- Set and clear flag
				-- Check if flag was triggered and is enabled
				if ((s_irq_flag_delayed.pre_last_pulse_irq_flag = '0') and (s_irq_flag.pre_last_pulse_irq_flag = '1') and (irq_enable_i.pre_last_pulse_irq_enable = '1')) then
					s_irq_flag_edge_triggered.pre_last_pulse_irq_flag <= '1';
				end if;
				-- check if a flag clear was issued
				if (irq_flag_clear_i.pre_last_pulse_irq_flag_clear = '1') then
					s_irq_flag_edge_triggered.pre_last_pulse_irq_flag <= '0';
				end if;
			else
				-- flag cannot be triggered
				s_irq_flag.pre_last_pulse_irq_flag                  <= '0';
				s_irq_flag_edge_triggered.pre_normal_pulse_irq_flag <= '0';
			end if;

			-- update irq_flags_delayed
			s_irq_flag_delayed <= s_irq_flag;

		end if;
	end process p_pre_sync_irq;

	-- generate irq_o
	irq_o <= (g_SYNC_DEFAULT_IRQ_POLARITY) when ((s_irq_flag_edge_triggered.pre_blank_pulse_irq_flag = '1') or (s_irq_flag_edge_triggered.pre_master_pulse_irq_flag = '1') or (s_irq_flag_edge_triggered.pre_normal_pulse_irq_flag = '1') or (s_irq_flag_edge_triggered.pre_last_pulse_irq_flag = '1')) else (not g_SYNC_DEFAULT_IRQ_POLARITY);

	-- update irq_flag_o
	irq_flag_o <= s_irq_flag_edge_triggered;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
