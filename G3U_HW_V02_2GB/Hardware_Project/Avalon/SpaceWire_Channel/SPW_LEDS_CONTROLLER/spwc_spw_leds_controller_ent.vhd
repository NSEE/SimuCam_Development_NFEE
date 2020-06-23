library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_leds_controller_pkg.all;

entity spwc_spw_leds_controller_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		leds_channel_status_i : in  t_spwm_spw_leds_channel_status;
		leds_control_o        : out t_spwc_spw_leds_control
	);
end entity spwc_spw_leds_controller_ent;

architecture RTL of spwc_spw_leds_controller_ent is

begin

	-- SpaceWire Channel - SpaceWire LEDs Controller Process
	p_spwc_spw_leds_controller : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- outputs reset
			leds_control_o.red_status_led   <= '0';
			leds_control_o.green_status_led <= '0';
		elsif rising_edge(clk_i) then

			-- standard status leds state (both off)
			leds_control_o.red_status_led   <= '0';
			leds_control_o.green_status_led <= '0';

			-- check if the spacewire link is running
			if (leds_channel_status_i.link_status_running = '1') then
				-- spacewire link is running
				-- set status leds (green led on, red led off)
				leds_control_o.red_status_led   <= '0';
				leds_control_o.green_status_led <= '1';
			else
				-- spacewire link is not running
				-- set status leds (red led on, green led off)
				leds_control_o.red_status_led   <= '1';
				leds_control_o.green_status_led <= '0';
			end if;

			-- check if the link is receiving or sending data
			if ((leds_channel_status_i.data_rx_command_rxread = '1') or (leds_channel_status_i.data_tx_command_txwrite = '1')) then
				-- link is receiving or sending data
				-- set status leds (both on)
				leds_control_o.red_status_led   <= '1';
				leds_control_o.green_status_led <= '1';
			end if;

		end if;
	end process p_spwc_spw_leds_controller;

end architecture RTL;
