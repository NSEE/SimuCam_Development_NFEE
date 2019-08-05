library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_bidirectional_io_ent is
	generic(
		g_IO_RST_STATE : std_logic;
		g_IO_BUS_WIDTH : natural range 1 to 256
	);
	port(
		-- generic ports
		clk_i           : in    std_logic;
		reset_i         : in    std_logic;
		-- input ports
		output_enable_i : in    std_logic;
		output_data_i   : in    std_logic_vector((g_IO_BUS_WIDTH - 1) downto 0); -- data to be write at the bus
		-- output ports
		feedback_data_o : out   std_logic_vector((g_IO_BUS_WIDTH - 1) downto 0); -- data that is being read at the bus
		-- bidirectional ports
		bidir_bus_io    : inout std_logic_vector((g_IO_BUS_WIDTH - 1) downto 0)
	);
end entity ftdi_bidirectional_io_ent;

architecture RTL of ftdi_bidirectional_io_ent is

	signal s_feedback_register : std_logic_vector((g_IO_BUS_WIDTH - 1) downto 0);
	signal s_output_register   : std_logic_vector((g_IO_BUS_WIDTH - 1) downto 0);

begin

	g_bidir_io_pin : if (g_IO_BUS_WIDTH = 1) generate
		p_bidir_io_pin_sync : process(clk_i, reset_i) -- Syncronous process, data transmission
		begin
			if (reset_i = '1') then
				bidir_bus_io(0)    <= 'Z';
				feedback_data_o(0) <= g_IO_RST_STATE;
			elsif (rising_edge(clk_i)) then
				feedback_data_o(0)   <= s_feedback_register(0);
				s_output_register(0) <= output_data_i(0);
			end if;
		end process p_bidir_io_pin_sync;

		p_bidir_io_pin_async : process(output_enable_i, bidir_bus_io, s_output_register) --Asyncronous process, behavioral description
		begin
			if (output_enable_i = '0') then
				-- output disabled, bidir bus goes to high impedance state
				bidir_bus_io(0)        <= 'Z';
				s_feedback_register(0) <= bidir_bus_io(0);
			else
				-- output enabled, bidir bus receive output value
				bidir_bus_io(0)        <= s_output_register(0);
				s_feedback_register(0) <= bidir_bus_io(0);
			end if;
		end process p_bidir_io_pin_async;
	end generate g_bidir_io_pin;

	g_bidir_io_bus : if (g_IO_BUS_WIDTH > 1) generate
		p_bidir_io_bus_sync : process(clk_i, reset_i) -- Syncronous process, data transmission
		begin
			if (reset_i = '1') then
				bidir_bus_io    <= (others => 'Z');
				feedback_data_o <= (others => g_IO_RST_STATE);
			elsif (rising_edge(clk_i)) then
				feedback_data_o   <= s_feedback_register;
				s_output_register <= output_data_i;
			end if;
		end process p_bidir_io_bus_sync;

		p_bidir_io_bus_async : process(output_enable_i, bidir_bus_io, s_output_register) --Asyncronous process, behavioral description
		begin
			if (output_enable_i = '0') then
				-- output disabled, bidir bus goes to high impedance state
				bidir_bus_io        <= (others => 'Z');
				s_feedback_register <= bidir_bus_io;
			else
				-- output enabled, bidir bus receive output value
				bidir_bus_io        <= s_output_register;
				s_feedback_register <= bidir_bus_io;
			end if;
		end process p_bidir_io_bus_async;
	end generate g_bidir_io_bus;

end architecture RTL;
