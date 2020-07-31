library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cbuf_tb_avs_pkg.all;

entity cbuf_tb_avs_read_ent is
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		cbuf_tb_avs_avalon_mm_i   : in  t_cbuf_tb_avs_avalon_mm_read_in;
		cbuf_tb_avs_memory_area_i : in  t_cbuf_tb_avs_memory_area;
		cbuf_tb_avs_avalon_mm_o   : out t_cbuf_tb_avs_avalon_mm_read_out
	);
end entity cbuf_tb_avs_read_ent;

architecture rtl of cbuf_tb_avs_read_ent is

begin

	p_cbuf_tb_avs_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_cbuf_tb_avs_avalon_mm_address) is
			variable v_rd_addr : natural range (t_cbuf_tb_avs_memory_area'low) to (t_cbuf_tb_avs_memory_area'high);
		begin

			v_rd_addr                        := to_integer(read_address_i(13 downto 5));
			cbuf_tb_avs_avalon_mm_o.readdata <= cbuf_tb_avs_memory_area_i(v_rd_addr);

			--			-- Registers Data Read
			--			case (read_address_i) is
			--				-- Case for access to all registers address
			--
			--				when 0 to 15 =>
			--					cbuf_tb_avs_avalon_mm_o.readdata <= cbuf_tb_avs_memory_area_i(to_integer(read_address_i(3 downto 0)));
			--
			--				when others =>
			--					-- No register associated to the address
			--					cbuf_tb_avs_avalon_mm_o.readdata <= (others => '1');
			--
			--			end case;

		end procedure p_readdata;

		variable v_read_address : t_cbuf_tb_avs_avalon_mm_address := (others => '0');
	begin
		if (rst_i = '1') then
			cbuf_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			cbuf_tb_avs_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := (others => '0');
		elsif (rising_edge(clk_i)) then
			cbuf_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			cbuf_tb_avs_avalon_mm_o.waitrequest <= '1';
			if (cbuf_tb_avs_avalon_mm_i.read = '1') then
				v_read_address                      := unsigned(cbuf_tb_avs_avalon_mm_i.address);
				cbuf_tb_avs_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_cbuf_tb_avs_read;

end architecture rtl;
