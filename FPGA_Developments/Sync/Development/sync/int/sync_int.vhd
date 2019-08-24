--=============================================================================
--! @file sync_int.vhd
--=============================================================================
--! Standard library
library ieee;
--! Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! Specific packages
use work.sync_int_pkg.all;
use work.sync_common_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync interrupt (sync_int)
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
--! Entity declaration for sync_int
--============================================================================
entity sync_int is
	generic(
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;
		g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
	);
	port(
		clk_i            : in  std_logic;
		reset_n_i        : in  std_logic;
		int_enable_i     : in  t_sync_int_enable;
		int_flag_clear_i : in  t_sync_int_flag_clear;
		int_watch_i      : in  t_sync_int_watch;
		int_flag_o       : out t_sync_int_flag;
		irq_o            : out std_logic
	);
end entity sync_int;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_int is

	constant c_ZERO : std_logic_vector(7 downto 0) := (others => '0');

	-- Aux to read back int flags outputs
	-- It is not necessary with vhdl 2008 and further
	signal s_int_flag                : t_sync_int_flag;
	signal s_int_flag_delayed        : t_sync_int_flag;
	signal s_int_flag_edge_triggered : t_sync_int_flag;

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	p_sync_int : process(clk_i, reset_n_i) is
	begin
		if (reset_n_i = '0') then
			-- Reset flags and irq
			s_int_flag                <= (others => '0');
			s_int_flag_delayed        <= (others => '0');
			s_int_flag_edge_triggered <= (others => '0');

		elsif (rising_edge(clk_i)) then

			-- Logic for error
			-- Activate error flag if: error code non zero
			if (unsigned(int_watch_i.error_code_watch) /= unsigned(c_ZERO)) then
				s_int_flag.error_int_flag <= '1';
			else
				s_int_flag.error_int_flag <= '0';
			end if;
			-- Set and clear flag
			-- Check if flag was triggered and is enabled
			if ((s_int_flag_delayed.error_int_flag = '0') and (s_int_flag.error_int_flag = '1') and (int_enable_i.error_int_enable = '1')) then
				s_int_flag_edge_triggered.error_int_flag <= '1';
			end if;
			-- check if a flag clear was issued
			if (int_flag_clear_i.error_int_flag_clear = '1') then
				s_int_flag_edge_triggered.error_int_flag <= '0';
			end if;

			-- Logic for blank pulse
			-- Activate blank pulse flag if: sync wave is at blank level
			if (int_watch_i.sync_wave_watch = int_watch_i.sync_pol_watch) then
				s_int_flag.blank_pulse_int_flag <= '1';
			else
				s_int_flag.blank_pulse_int_flag <= '0';
			end if;
			-- Set and clear flag
			-- Check if flag was triggered and is enabled
			if ((s_int_flag_delayed.blank_pulse_int_flag = '0') and (s_int_flag.blank_pulse_int_flag = '1') and (int_enable_i.blank_pulse_int_enable = '1')) then
				s_int_flag_edge_triggered.blank_pulse_int_flag <= '1';
			end if;
			-- check if a flag clear was issued
			if (int_flag_clear_i.blank_pulse_int_flag_clear = '1') then
				s_int_flag_edge_triggered.blank_pulse_int_flag <= '0';
			end if;

			-- Logic for master pulse
			-- Activate master pulse flag if: sync wave is at blank level and sync cycle number is at zero (master)
			if ((int_watch_i.sync_wave_watch = int_watch_i.sync_pol_watch) and (unsigned(int_watch_i.sync_cycle_number) = 0)) then
				s_int_flag.master_pulse_int_flag <= '1';
			else
				s_int_flag.master_pulse_int_flag <= '0';
			end if;
			-- Set and clear flag
			-- Check if flag was triggered and is enabled
			if ((s_int_flag_delayed.master_pulse_int_flag = '0') and (s_int_flag.master_pulse_int_flag = '1') and (int_enable_i.master_pulse_int_enable = '1')) then
				s_int_flag_edge_triggered.master_pulse_int_flag <= '1';
			end if;
			-- check if a flag clear was issued
			if (int_flag_clear_i.master_pulse_int_flag_clear = '1') then
				s_int_flag_edge_triggered.master_pulse_int_flag <= '0';
			end if;

			-- Logic for normal pulse
			-- check if this falg can be triggered
			if (unsigned(int_watch_i.sync_number_of_cycles) > 2) then
				-- flag can be triggered
				-- Activate normal pulse flag if: sync wave is at blank level and sync cycle number is between 0 (master) and (sync number of cicles - 1) (last)
				if ((int_watch_i.sync_wave_watch = int_watch_i.sync_pol_watch) and (unsigned(int_watch_i.sync_cycle_number) > 0) and (unsigned(int_watch_i.sync_cycle_number) < (unsigned(int_watch_i.sync_number_of_cycles) - 1))) then
					s_int_flag.normal_pulse_int_flag <= '1';
				else
					s_int_flag.normal_pulse_int_flag <= '0';
				end if;
				-- Set and clear flag
				-- Check if flag was triggered and is enabled
				if ((s_int_flag_delayed.normal_pulse_int_flag = '0') and (s_int_flag.normal_pulse_int_flag = '1') and (int_enable_i.normal_pulse_int_enable = '1')) then
					s_int_flag_edge_triggered.normal_pulse_int_flag <= '1';
				end if;
				-- check if a flag clear was issued
				if (int_flag_clear_i.normal_pulse_int_flag_clear = '1') then
					s_int_flag_edge_triggered.normal_pulse_int_flag <= '0';
				end if;
			else
				-- flag cannot be triggered
				s_int_flag.normal_pulse_int_flag                <= '0';
				s_int_flag_edge_triggered.normal_pulse_int_flag <= '0';
			end if;

			-- Logic for last pulse
			-- check if this falg can be triggered
			if (unsigned(int_watch_i.sync_number_of_cycles) > 1) then
				-- flag can be triggered
				-- Activate blank last flag if: sync wave is at blank level and sync cycle number is at (sync number of cicles - 1) (last)
				if ((int_watch_i.sync_wave_watch = int_watch_i.sync_pol_watch) and (unsigned(int_watch_i.sync_cycle_number) = (unsigned(int_watch_i.sync_number_of_cycles) - 1))) then
					s_int_flag.last_pulse_int_flag <= '1';
				else
					s_int_flag.last_pulse_int_flag <= '0';
				end if;
				-- Set and clear flag
				-- Check if flag was triggered and is enabled
				if ((s_int_flag_delayed.last_pulse_int_flag = '0') and (s_int_flag.last_pulse_int_flag = '1') and (int_enable_i.last_pulse_int_enable = '1')) then
					s_int_flag_edge_triggered.last_pulse_int_flag <= '1';
				end if;
				-- check if a flag clear was issued
				if (int_flag_clear_i.last_pulse_int_flag_clear = '1') then
					s_int_flag_edge_triggered.last_pulse_int_flag <= '0';
				end if;
			else
				-- flag cannot be triggered
				s_int_flag.last_pulse_int_flag                  <= '0';
				s_int_flag_edge_triggered.normal_pulse_int_flag <= '0';
			end if;

			-- update int_flags_delayed
			s_int_flag_delayed <= s_int_flag;

		end if;
	end process p_sync_int;

	-- generate irq_o
	irq_o <= (g_SYNC_DEFAULT_IRQ_POLARITY) when ((s_int_flag_edge_triggered.error_int_flag = '1') or (s_int_flag_edge_triggered.blank_pulse_int_flag = '1') or (s_int_flag_edge_triggered.master_pulse_int_flag = '1') or (s_int_flag_edge_triggered.normal_pulse_int_flag = '1') or (s_int_flag_edge_triggered.last_pulse_int_flag = '1')) else (not g_SYNC_DEFAULT_IRQ_POLARITY);

	-- update int_flag_o
	int_flag_o <= s_int_flag_edge_triggered;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
