library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bidir_pin_ent is
	generic(
		RST_STATE : std_logic
	);
	port(
		bidir_pin     : inout std_logic;
		oe            : in    std_logic;
		clk           : in    std_logic;
		rst           : in    std_logic;
		feedback_data : out   std_logic;
		output_data   : in    std_logic
	);
end bidir_pin_ent;

architecture bidir_pin_arc of bidir_pin_ent is

	signal feedback_reg : std_logic;
	signal output_reg   : std_logic;

begin

	bidir_pin_sync_proc : process(clk, rst) -- Syncronous process, data transmission
	begin
		if (rst = '1') then
			bidir_pin     <= 'Z';
			feedback_data <= RST_STATE;
		elsif (rising_edge(clk)) THEN
			feedback_data <= feedback_reg;
			output_reg    <= output_data;
		end if;
	end process bidir_pin_sync_proc;

	bidir_pin_async_proc : process(oe, bidir_pin, output_reg) --Asyncronous process, behavioral description
	begin
		if (oe = '0') then
			bidir_pin    <= 'Z';
			feedback_reg <= bidir_pin;
		else
			bidir_pin    <= output_reg;
			feedback_reg <= bidir_pin;
		end if;
	end process bidir_pin_async_proc;

end bidir_pin_arc;
