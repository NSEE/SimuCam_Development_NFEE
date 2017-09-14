library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dc_pin_ent is
	generic(
		RST_STATE : std_logic
	);
	port(
		clk_in   : in  std_logic;
		data_in  : in  std_logic;
		clk_out  : in  std_logic;
		data_out : out std_logic;
		rst      : in  std_logic
	);
end entity dc_pin_ent;

architecture dc_pin_arc of dc_pin_ent is

	signal data_reg : std_logic;

begin

	dc_pin_in_proc : process(clk_in, rst) is -- dual clock bus in
	begin
		if (rst = '1') then
			data_reg <= RST_STATE;
		elsif (rising_edge(clk_in)) then
			data_reg <= data_in;
		end if;
	end process dc_pin_in_proc;

	dc_pin_out_proc : process(clk_out, rst) is -- dual clok bus out
	begin
		if (rst = '1') then
			data_out <= RST_STATE;
		elsif (rising_edge(clk_out)) then
			data_out <= data_reg;
		end if;
	end process dc_pin_out_proc;

end architecture dc_pin_arc;

