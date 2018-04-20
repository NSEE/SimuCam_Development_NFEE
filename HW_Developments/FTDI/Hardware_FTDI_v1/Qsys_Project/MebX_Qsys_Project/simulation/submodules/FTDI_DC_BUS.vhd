library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dc_bus_ent is
	generic(
		BUS_WIDTH : natural range 1 TO 32;
		RST_STATE : std_logic
	);
	port(
		clk_in   : in  std_logic;
		data_in  : in  std_logic_vector((BUS_WIDTH - 1) downto 0);
		clk_out  : in  std_logic;
		data_out : out std_logic_vector((BUS_WIDTH - 1) downto 0);
		rst      : in  std_logic
	);
end entity dc_bus_ent;

architecture dc_bus_arc of dc_bus_ent is

	signal data_reg : std_logic_vector((BUS_WIDTH - 1) downto 0);

begin

	dc_bus_in_proc : process(clk_in, rst) is -- dual clock bus in
	begin
		if (rst = '1') then
			data_reg <= (others => RST_STATE);
		elsif (rising_edge(clk_in)) then
			data_reg <= data_in;
		end if;
	end process dc_bus_in_proc;

	dc_bus_out_proc : process(clk_out, rst) is -- dual clok bus out
	begin
		if (rst = '1') then
			data_out <= (others => RST_STATE);
		elsif (rising_edge(clk_out)) then
			data_out <= data_reg;
		end if;
	end process dc_bus_out_proc;

end architecture dc_bus_arc;

