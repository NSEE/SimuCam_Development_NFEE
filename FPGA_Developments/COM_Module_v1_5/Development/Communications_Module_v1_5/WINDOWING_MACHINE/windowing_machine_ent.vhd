-- TODO: flow control for masked pixels data!!
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.windowing_machine_pkg.all;

entity windowing_machine_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		windowing_machine_control_i : in  t_windowing_machine_control;
		windowing_buffer_status_i   : in  t_windowing_buffer_status;
		windowing_data_i            : in  t_windowing_data_block;
		windowing_machine_status_o  : out t_windowing_machine_status;
		windowing_buffer_control_o  : out t_windowing_buffer_control;
		windowing_masked_pixels_o   : out std_logic_vector(15 downto 0)
	);
end entity windowing_machine_ent;

architecture RTL of windowing_machine_ent is

	type t_windowing_machine_fsm is (
		IDLE,
		WINDOWING,
		FETCHING
	);

	signal s_windowing_machine_state : t_windowing_machine_fsm;

	signal s_pixel_counter : natural range 0 to 63;

begin

	p_windowing_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

		elsif rising_edge(clk_i) then

			case s_windowing_machine_state is

				when IDLE =>
					s_windowing_machine_state <= IDLE;
					-- check if the windowing buffer is full (signal to start a windowing process)
					if (windowing_buffer_status_i.full = '1') then
						-- fetch a windown data
						windowing_buffer_control_o.fetch_data <= '1';
						s_windowing_machine_state             <= FETCHING;
					end if;

				when WINDOWING =>
					s_windowing_machine_state             <= WINDOWING;
					windowing_buffer_control_o.fetch_data <= '0';
					-- check if there are still pixels to be processed
					if (s_pixel_counter > 0) then
						-- there are more pixels to be processed
						-- check if the pixel is not masked
						if (windowing_data_i.pixels_mask(s_pixel_counter) = '1') then
							-- pixel not masked, send to data buffer
							windowing_masked_pixels_o <= windowing_data_i.pixels_data(s_pixel_counter);
						end if;
						-- update pixel counter
						s_pixel_counter <= s_pixel_counter - 1;
					else
						-- last pixel to be processed
						-- check if the last pixel is not masked
						if (windowing_data_i.pixels_mask(s_pixel_counter) = '1') then
							-- last pixel not masked, send to data buffer
							windowing_masked_pixels_o <= windowing_data_i.pixels_data(s_pixel_counter);
						end if;
						-- update pixel counter
						s_pixel_counter <= 0;
						-- no more pixel data to process
						-- check if there are more data in the windowing buffer
						if (windowing_buffer_status_i.empty = '0') then
							-- fetch more data from the windowing buffer
							windowing_buffer_control_o.fetch_data <= '1';
							s_windowing_machine_state             <= FETCHING;
						else
							-- no more data in the windowing buffer, return to idle
							s_windowing_machine_state <= IDLE;
						end if;

					end if;

				when FETCHING =>
					windowing_buffer_control_o.fetch_data <= '0';
					s_windowing_machine_state             <= WINDOWING;

			end case;

		end if;
	end process p_windowing_machine;

end architecture RTL;
