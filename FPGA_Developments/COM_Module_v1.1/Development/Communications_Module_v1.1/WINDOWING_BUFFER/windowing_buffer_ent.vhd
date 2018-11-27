library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity windowing_buffer_ent is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity windowing_buffer_ent;

architecture RTL of windowing_buffer_ent is

	type t_windowing_data_block is array (0 to 16) of std_logic_vector(63 downto 0);
	type t_windowing_buffer is array (0 to 15) of t_windowing_data_block;
	signal s_windowing_buffer : t_windowing_buffer;

	signal s_windowing_buffer_full  : std_logic;
	signal s_windowing_buffer_empty : std_logic;
	signal s_windowing_buffer_index : std_logic_vector(3 downto 0);
	signal s_windowing_pixels_index : std_logic_vector(5 downto 0);
	signal s_pixel

	signal s_windowing_machine_started : std_logic;

begin

	p_windowing_buffer : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

		elsif rising_edge(clk_i) then

			s_windowing_machine_started <= '0';
			-- check if the windowing buffer is full (ready to process data)
			if (s_windowing_buffer_full = '1') or (s_windowing_machine_started = '1') then
				s_windowing_machine_started <= '1';

				-- sweep the windowing data block
				-- check if the pixel is masked
				if (s_windowing_buffer(to_integer(unsigned(s_windowing_buffer_index)))(16)(to_integer(unsigned(s_windowing_pixels_index))) = '1') then

					s_windowing_buffer(to_integer(unsigned(s_windowing_buffer_index)))(to_integer(unsigned(s_windowing_pixels_index(5 downto 2))))(to_integer(unsigned(s_windowing_pixels_index)))
					
				end if;

			end if;

		end if;
	end process p_windowing_buffer;

	-- buffer_index = 00; data_line_index = 00; pixel_index = 00
	-- buffer_index = 00; data_line_index = 00; pixel_index = 01
	-- buffer_index = 00; data_line_index = 00; pixel_index = 02
	-- buffer_index = 00; data_line_index = 00; pixel_index = 03
	-- buffer_index = 00; data_line_index = 01; pixel_index = 04
	-- buffer_index = 00; data_line_index = 01; pixel_index = 05
	-- buffer_index = 00; data_line_index = 01; pixel_index = 06
	-- buffer_index = 00; data_line_index = 01; pixel_index = 07
	-- buffer_index = 00; data_line_index = 02; pixel_index = 08
	-- buffer_index = 00; data_line_index = 02; pixel_index = 09
	-- buffer_index = 00; data_line_index = 02; pixel_index = 10
	-- buffer_index = 00; data_line_index = 02; pixel_index = 11
	-- buffer_index = 00; data_line_index = 03; pixel_index = 12
	-- buffer_index = 00; data_line_index = 03; pixel_index = 13
	-- buffer_index = 00; data_line_index = 03; pixel_index = 14
	-- buffer_index = 00; data_line_index = 03; pixel_index = 15
	-- buffer_index = 00; data_line_index = 04; pixel_index = 16
	-- buffer_index = 00; data_line_index = 04; pixel_index = 17
	-- buffer_index = 00; data_line_index = 04; pixel_index = 18
	-- buffer_index = 00; data_line_index = 04; pixel_index = 19
	-- buffer_index = 00; data_line_index = 05; pixel_index = 20
	-- buffer_index = 00; data_line_index = 05; pixel_index = 21
	-- buffer_index = 00; data_line_index = 05; pixel_index = 22
	-- buffer_index = 00; data_line_index = 05; pixel_index = 23
	-- buffer_index = 00; data_line_index = 06; pixel_index = 24
	-- buffer_index = 00; data_line_index = 06; pixel_index = 25
	-- buffer_index = 00; data_line_index = 06; pixel_index = 26
	-- buffer_index = 00; data_line_index = 06; pixel_index = 27
	-- buffer_index = 00; data_line_index = 07; pixel_index = 28
	-- buffer_index = 00; data_line_index = 07; pixel_index = 29
	-- buffer_index = 00; data_line_index = 07; pixel_index = 30
	-- buffer_index = 00; data_line_index = 07; pixel_index = 31
	-- buffer_index = 00; data_line_index = 08; pixel_index = 32
	-- buffer_index = 00; data_line_index = 08; pixel_index = 33
	-- buffer_index = 00; data_line_index = 08; pixel_index = 34
	-- buffer_index = 00; data_line_index = 08; pixel_index = 35
	-- buffer_index = 00; data_line_index = 09; pixel_index = 36
	-- buffer_index = 00; data_line_index = 09; pixel_index = 37
	-- buffer_index = 00; data_line_index = 09; pixel_index = 38
	-- buffer_index = 00; data_line_index = 09; pixel_index = 39
	-- buffer_index = 00; data_line_index = 10; pixel_index = 40
	-- buffer_index = 00; data_line_index = 10; pixel_index = 41
	-- buffer_index = 00; data_line_index = 10; pixel_index = 42
	-- buffer_index = 00; data_line_index = 10; pixel_index = 43
	-- buffer_index = 00; data_line_index = 11; pixel_index = 44
	-- buffer_index = 00; data_line_index = 11; pixel_index = 45
	-- buffer_index = 00; data_line_index = 11; pixel_index = 46
	-- buffer_index = 00; data_line_index = 11; pixel_index = 47
	-- buffer_index = 00; data_line_index = 12; pixel_index = 48
	-- buffer_index = 00; data_line_index = 12; pixel_index = 49
	-- buffer_index = 00; data_line_index = 12; pixel_index = 50
	-- buffer_index = 00; data_line_index = 12; pixel_index = 51
	-- buffer_index = 00; data_line_index = 13; pixel_index = 52
	-- buffer_index = 00; data_line_index = 13; pixel_index = 53
	-- buffer_index = 00; data_line_index = 13; pixel_index = 54
	-- buffer_index = 00; data_line_index = 13; pixel_index = 55
	-- buffer_index = 00; data_line_index = 14; pixel_index = 56
	-- buffer_index = 00; data_line_index = 14; pixel_index = 57
	-- buffer_index = 00; data_line_index = 14; pixel_index = 58
	-- buffer_index = 00; data_line_index = 14; pixel_index = 59
	-- buffer_index = 00; data_line_index = 15; pixel_index = 60
	-- buffer_index = 00; data_line_index = 15; pixel_index = 61
	-- buffer_index = 00; data_line_index = 15; pixel_index = 62
	-- buffer_index = 00; data_line_index = 15; pixel_index = 63
	-- buffer_index = 01; data_line_index = 00; pixel_index = 00
	-- ...

end architecture RTL;
