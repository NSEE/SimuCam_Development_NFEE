library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_data_pkg.all;
use work.pgen_mm_data_registers_pkg.all;

entity pgen_avalon_mm_data_read_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		mm_read_registers_i            : in  t_pgen_mm_data_read_registers;
		avalon_mm_read_inputs_i        : in  t_pgen_avalon_mm_data_read_inputs;
		avalon_mm_read_outputs_o       : out t_pgen_avalon_mm_data_read_outputs
	);
end entity pgen_avalon_mm_data_read_ent;

architecture rtl of pgen_avalon_mm_data_read_ent is
begin

	p_pgen_avalon_mm_data_read : process(clk_i, rst_i) is
		procedure p_mm_readdata(mm_read_address_i : t_pgen_avalon_mm_data_address) is
		begin
			-- Registers Data Read
			case (mm_read_address_i) is
				-- Case for access to all registers address
				when others =>
					avalon_mm_read_outputs_o.readdata <= mm_read_registers_i;
			end case;
		end procedure p_mm_readdata;

		variable v_mm_read_address : t_pgen_avalon_mm_data_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_read_outputs_o.readdata    <= (others => '0');
			avalon_mm_read_outputs_o.waitrequest <= '1';
			v_mm_read_address                    := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_read_outputs_o.waitrequest <= '1';
			if (avalon_mm_read_inputs_i.read = '1') then
				avalon_mm_read_outputs_o.waitrequest <= '0';
				v_mm_read_address                    := to_integer(unsigned(avalon_mm_read_inputs_i.address));
				p_mm_readdata(v_mm_read_address);
			end if;
		end if;
	end process p_pgen_avalon_mm_data_read;

end architecture rtl;
