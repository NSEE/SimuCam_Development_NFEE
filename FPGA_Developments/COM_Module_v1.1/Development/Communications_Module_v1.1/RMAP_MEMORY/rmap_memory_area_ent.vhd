library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;

entity rmap_memory_area_ent is
	generic(
		g_MEMORY_ADDRESS_WIDTH : natural range 0 to c_WIDTH_EXTENDED_ADDRESS := 32;
		g_MEMORY_ACCESS_WIDTH  : natural range 0 to c_WIDTH_MEMORY_ACCESS    := 2 -- 32 bits data
	);
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		rmap_mem_control_i         : in  t_rmap_target_mem_control;
		rmap_mem_wr_byte_address_i : in  std_logic_vector((g_RMAP_MEMORY_ADDRESS_WIDTH + g_RMAP_MEMORY_ACCESS_WIDTH - 1) downto 0);
		rmap_mem_rd_byte_address_i : in  std_logic_vector((g_RMAP_MEMORY_ADDRESS_WIDTH + g_RMAP_MEMORY_ACCESS_WIDTH - 1) downto 0);
		rmap_mem_flag_o            : out t_rmap_target_mem_flag
	);
end entity rmap_memory_area_ent;

architecture RTL of rmap_memory_area_ent is

	type t_rmap_memory_area is array (0 to 2047) of std_logic_vector(7 downto 0);
	signal s_rmap_memory_area : t_rmap_memory_area := (others => x"00");

begin

	--rmap_mem_control_i.read.read
	--rmap_mem_control_i.write.write
	--rmap_mem_control_i.write.data
	--rmap_mem_flag_o.read.valid
	--rmap_mem_flag_o.read.error
	--rmap_mem_flag_o.read.data
	--rmap_mem_flag_o.write.ready
	--rmap_mem_flag_o.write.error

	p_rmap_memory_area : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			rmap_mem_flag_o.read.valid  <= '0';
			rmap_mem_flag_o.read.error  <= '0';
			rmap_mem_flag_o.read.data   <= (others => '0');
			rmap_mem_flag_o.write.ready <= '0';
			rmap_mem_flag_o.write.error <= '0';
			s_rmap_memory_area          <= (others => x"00");
		elsif rising_edge(clk_i) then
			rmap_mem_flag_o.read.error  <= '0';
			rmap_mem_flag_o.read.valid  <= '0';
			rmap_mem_flag_o.write.ready <= '1';
			rmap_mem_flag_o.write.error <= '0';
			-- check if a error ocurred
			if ((rmap_mem_control_i.read.read = '1') and (rmap_mem_control_i.write.write = '1')) then
				rmap_mem_flag_o.write.error <= '1';
			else
				-- write request
				if (rmap_mem_control_i.write.write = '1') then
					s_rmap_memory_area(to_integer(unsigned(rmap_mem_wr_byte_address_i))) <= rmap_mem_control_i.write.data;
					rmap_mem_flag_o.write.ready                                          <= '1';
				end if;
				-- read request
				if (rmap_mem_control_i.read.read = '1') then
					rmap_mem_flag_o.read.data  <= s_rmap_memory_area(to_integer(unsigned(rmap_mem_rd_byte_address_i)));
					rmap_mem_flag_o.read.valid <= '1';
				end if;
			end if;
		end if;
	end process p_rmap_memory_area;

end architecture RTL;
