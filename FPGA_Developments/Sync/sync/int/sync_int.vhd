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
	generic (
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY;
		g_SYNC_DEFAULT_IRQ_POLARITY  : std_logic := c_SYNC_DEFAULT_IRQ_POLARITY
	);
	port (
		clk_i           	: in std_logic;
		reset_n_i      		: in std_logic;
		int_enable_i 		: in t_sync_int_enable;
		int_flag_clear_i	: in t_sync_int_flag_clear;
		int_watch_i			: in t_sync_int_watch; 
		
		int_flag_o 			: out t_sync_int_flag;
		irq_o				: out std_logic
	);
end entity sync_int;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_int is

	-- Aux to read back int flags outputs
	-- It´s not necessary with vhdl 2008 and further
	signal s_int_flag		: t_sync_int_flag;

--============================================================================
-- architecture begin
--============================================================================
begin
	
	-- "Copy" output int flags so they can be read back to irq logic
	-- It´s not necessary with vhdl 2008 and further
	s_int_flag <= int_flag_o;
	
	p_sync_int : process(clk_i, reset_n_i) is
	begin
		if (reset_n_i = '0') then
			-- Reset flags and irq
			int_flag_o.error_int_flag	<= '0';
			int_flag_o.blank_pulse_int_flag	<= '0';
			irq_o <= not g_SYNC_DEFAULT_IRQ_POLARITY;
			
		elsif (rising_edge(clk_i)) then
			-- Logic for error
			if (int_flag_clear_i.error_int_flag_clear = '1') then
				int_flag_o.error_int_flag	<= '0';
			else
				-- Activate error flag if: error code non zero and enable bit = 1
				if ( (int_watch_i.error_code_watch /= (others => '0')) and (int_enable_i.error_int_enable = '1') ) then
					int_flag_o.error_int_flag	<= '1';
				else
					int_flag_o.error_int_flag	<= '0';
				end if;
			end if;
		
			-- Logic for blank pulse
			if (int_flag_clear_i.blank_pulse_int_flag_clear = '1') then
				int_flag_o.blank_pulse_int_flag	<= '0';
			else	
				-- Activate blank pulse flag if: sync wave is at blank level and enable bit = 1
				if ( (int_watch_i.sync_wave_watch = int_watch_i.sync_pol_watch) and (int_enable_i.blank_pulse_int_enable = '1') ) then
					int_flag_o.blank_pulse_int_flag	<= '1';
				else
					int_flag_o.blank_pulse_int_flag	<= '0';
				end if;
			end if;
			
			-- Logic for irq
			-- For vhdl 2008 and further, use int_flag_o. If not, use s_int_flag signal
-- Use line below to keep irq active as long as int flags are active			
			if ( (int_flag_o.error_int_flag = '1') or (int_flag_o.blank_pulse_int_flag = '1') ) then
-- Use line below to generate only one clock period irq pulse per int flag active
--			if ( rising_edge(int_flag_o.error_int_flag) or rising_edge(int_flag_o.blank_pulse_int_flag) ) then
				irq_o <= g_SYNC_DEFAULT_IRQ_POLARITY;
			else
				irq_o <= not g_SYNC_DEFAULT_IRQ_POLARITY;
			end if;
		
		end if;
	end process p_sync_int;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
