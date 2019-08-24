library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_32_pkg.all;
use work.avalon_mm_32_registers_pkg.all;

entity avalon_mm_32_read_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		avalon_mm_32_i    : in  t_avalon_mm_32_read_in;
		avalon_mm_32_o    : out t_avalon_mm_32_read_out;
		write_registers_i : in  t_avstap_write_registers;
		read_registers_i  : in  t_avstap_read_registers
	);
end entity avalon_mm_32_read_ent;

architecture rtl of avalon_mm_32_read_ent is

begin

	p_avalon_mm_32_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_32_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when 0 to (c_AVSTAP_DATA_SIZE_DWORDS - 1) =>
					avalon_mm_32_o.readdata <= read_registers_i.avstap_data_reg.avstap_data(read_address_i);

				when others =>
					avalon_mm_32_o.readdata <= (others => '0');

			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_32_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_32_o.readdata    <= (others => '0');
			avalon_mm_32_o.waitrequest <= '1';
			v_read_address             := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_32_o.readdata    <= (others => '0');
			avalon_mm_32_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_32_i.read = '1') then
				v_read_address             := to_integer(unsigned(avalon_mm_32_i.address));
				avalon_mm_32_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_32_read;

end architecture rtl;
