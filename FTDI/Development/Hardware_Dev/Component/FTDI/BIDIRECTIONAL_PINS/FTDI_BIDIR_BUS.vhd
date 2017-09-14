library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bidir_bus_ent is
	generic(
		BUS_WIDTH : natural range 1 to 32;
		RST_STATE : std_logic
	);
	port(
		bidir_bus     : inout std_logic_vector((BUS_WIDTH - 1) downto 0);
		oe            : in    std_logic;
		clk           : in    std_logic;
		rst           : in    std_logic;
		feedback_data : out   std_logic_vector((BUS_WIDTH - 1) downto 0);
		output_data   : in    std_logic_vector((BUS_WIDTH - 1) downto 0)
	);
end bidir_bus_ent;

architecture bidir_bus_arc of bidir_bus_ent is

	signal feedback_reg : std_logic_vector((BUS_WIDTH - 1) downto 0);
	signal output_reg   : std_logic_vector((BUS_WIDTH - 1) downto 0);

begin

	bidir_bus_sync_proc : process(clk, rst) -- Syncronous process, data transmission
	begin
		if (rst = '1') then
			bidir_bus     <= (others => 'Z');
			feedback_data <= (others => RST_STATE);
		elsif (rising_edge(clk)) THEN
			feedback_data <= feedback_reg;
			output_reg    <= output_data;
		end if;
	end process bidir_bus_sync_proc;

	bidir_bus_async_proc : process(oe, bidir_bus, output_reg) --Asyncronous process, behavioral description
	begin
		if (oe = '0') then
			bidir_bus    <= (others => 'Z');
			feedback_reg <= bidir_bus;
		else
			bidir_bus    <= output_reg;
			feedback_reg <= bidir_bus;
		end if;
	end process bidir_bus_async_proc;

end bidir_bus_arc;
