library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_32_pkg.all;
use work.avalon_mm_32_registers_pkg.all;

entity avalon_mm_32_write_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		avalon_mm_32_i    : in  t_avalon_mm_32_write_in;
		avalon_mm_32_o    : out t_avalon_mm_32_write_out;
		write_registers_o : out t_avstap_write_registers
	);
end entity avalon_mm_32_write_ent;

architecture rtl of avalon_mm_32_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_32_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			write_registers_o.avstap_control.avstap_clear <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			write_registers_o.avstap_control.avstap_clear <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_32_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					write_registers_o.avstap_control.avstap_clear <= avalon_mm_32_i.writedata(0);
				when others =>
					null;

			end case;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_32_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_32_o.waitrequest <= '1';
			s_data_acquired            <= '0';
			v_write_address            := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_32_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_32_i.write = '1') then
				v_write_address            := to_integer(unsigned(avalon_mm_32_i.address));
				avalon_mm_32_o.waitrequest <= '0';
				s_data_acquired            <= '1';
				if (s_data_acquired = '1') then
					p_writedata(v_write_address);
					s_data_acquired <= '0';
				end if;
			end if;
		end if;
	end process p_avalon_mm_32_write;

end architecture rtl;
