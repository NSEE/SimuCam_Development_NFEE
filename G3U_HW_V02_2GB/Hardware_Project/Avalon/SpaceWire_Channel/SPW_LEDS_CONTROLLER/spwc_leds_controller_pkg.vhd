library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_leds_controller_pkg is

	-- Records, Arrays and Subtypes--

	-- SpaceWire Channel - SpaceWire LEDs Channel Status Record
	type t_spwm_spw_leds_channel_status is record
		link_status_running     : std_logic;
		data_rx_command_rxread  : std_logic;
		data_tx_command_txwrite : std_logic;
	end record t_spwm_spw_leds_channel_status;

	-- SpaceWire Channel - SpaceWire LEDs Control Record
	type t_spwc_spw_leds_control is record
		red_status_led   : std_logic;
		green_status_led : std_logic;
	end record t_spwc_spw_leds_control;

	-- Constants --

end package spwc_leds_controller_pkg;

package body spwc_leds_controller_pkg is

end package body spwc_leds_controller_pkg;
