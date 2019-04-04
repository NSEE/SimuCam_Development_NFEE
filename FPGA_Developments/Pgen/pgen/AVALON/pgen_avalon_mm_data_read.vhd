library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_data_pkg.all;
use work.pgen_mm_data_registers_pkg.all;
use work.pgen_data_controller_pkg.all;

entity pgen_avalon_mm_data_read is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		mm_read_registers_i            : in  t_pgen_mm_data_read_registers;
		avalon_mm_read_inputs_i        : in  t_pgen_avalon_mm_data_read_inputs;
		data_controller_read_status_i  : in  t_pgen_data_controller_read_status;
		avalon_mm_read_outputs_o       : out t_pgen_avalon_mm_data_read_outputs;
		data_controller_read_control_o : out t_pgen_data_controller_read_control
	);
end entity pgen_avalon_mm_data_read;

architecture rtl of pgen_avalon_mm_data_read is
	
	type t_read_state is (
	EMPTY_CHECK,
	FETCH,
	READ,
	FINISH
	);
	
begin
	p_pgen_avalon_mm_data_read : process(clk_i, rst_i) is
		procedure p_mm_readdata(mm_read_address_i : t_pgen_avalon_mm_data_address) is
		begin
			-- Registers Data Read
			case (mm_read_address_i) is
				-- Case for access to all registers address
				when others =>
					avalon_mm_read_outputs_o.readdata <= (mm_read_registers_i.pattern_pixel_3 & mm_read_registers_i.pattern_pixel_2 & mm_read_registers_i.pattern_pixel_1 & mm_read_registers_i.pattern_pixel_0);
			end case;
		end procedure p_mm_readdata;

		variable v_mm_read_address : t_pgen_avalon_mm_data_address := 0;
		variable v_read_state : t_read_state := EMPTY_CHECK;
	begin
		if (rst_i = '1') then
			avalon_mm_read_outputs_o.readdata    <= (others => '0');
			-- Keep waitrequest asserted - bus locked
			avalon_mm_read_outputs_o.waitrequest <= '1';
			v_mm_read_address                    := 0;
			data_controller_read_control_o.data_fetch <= '0';
			v_read_state := EMPTY_CHECK;
		elsif (rising_edge(clk_i)) then
			-- Return waitrequest to asserted level - bus locked
			avalon_mm_read_outputs_o.waitrequest <= '1';
			-- Reading requested?
			if (avalon_mm_read_inputs_i.read = '1') then
				-- Yes: TODO - create a sub state machine for fifo reading task
				-- State a) Check if there is data available inside fifo memory
				--if (data_controller_read_status_i.empty = '0') then
				-- Ok, data available, go to perform reading -> state b)
				-- State b) fetch = '1'
				--data_controller_read_control_o.data_fetch <= '1';
				-- State c) Read data
				--v_mm_read_address := to_integer(unsigned(avalon_mm_read_inputs_i.address));
				--p_mm_readdata(v_mm_read_address);
				-- State d) fetch = '0'
				--data_controller_read_control_o.data_fetch <= '0';
				-- ...and deassert waitrequest to inform reading ok: nios will deassert read signal
				--avalon_mm_read_outputs_o.waitrequest <= '0';
				-- ...and return to initial sub state

				-- Why fifo empty check must be performed inside the sub state machine?
				-- Because after a successful reading, fifo can become empty! The empty check
				-- can´t be performed outside sub state machine.
				
				-- If, at state a), fifo is empty (data unavailable),
				-- keep checking until fifo has data!!!
				-- Two possible logics: Check if generator is running, and wait;
				-- Or: provide a timeout of n clock cycles; if occurs, send dumbdata!
			end if;
		end if;
	end process p_pgen_avalon_mm_data_read;

end architecture rtl;
