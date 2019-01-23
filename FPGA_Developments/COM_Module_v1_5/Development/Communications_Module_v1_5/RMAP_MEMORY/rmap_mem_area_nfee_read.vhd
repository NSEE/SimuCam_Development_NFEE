library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_read is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_read_i             : in  std_logic;
		rmap_readaddr_i         : in  std_logic_vector(31 downto 0);
		avalon_mm_rmap_i        : in  t_avalon_mm_spacewire_read_in;
		rmap_write_authorized_i : in  std_logic;
		rmap_write_finished_i   : in  std_logic;
		rmap_config_registers_i : in  t_rmap_memory_config_area;
		rmap_hk_registers_i     : in  t_rmap_memory_hk_area;
		rmap_memerror_o         : out std_logic;
		rmap_datavalid_o        : out std_logic;
		rmap_readdata_o         : out std_logic_vector(7 downto 0);
		avalon_mm_rmap_o        : out t_avalon_mm_spacewire_read_out
	);
end entity rmap_mem_area_nfee_read;

architecture RTL of rmap_mem_area_nfee_read is

begin

	p_rmap_mem_area_nfee_read : process(clk_i, rst_i) is
		procedure p_nfee_mem_rd(rd_addr_i : std_logic_vector) is
		begin
			-- NFEE Memory Read
			-- Case for access to all registers
			case (rd_addr_i(31 downto 0)) is

				-- Config Area
				-- HK area

				-- others
				when others =>
					rmap_readdata_o <= (others => '0');
			end case;

		end procedure p_nfee_mem_rd;
	begin
		if (rst_i = '1') then
			rmap_memerror_o  <= '0';
			rmap_datavalid_o <= '0';
			rmap_readdata_o  <= (others => '0');
		elsif rising_edge(clk_i) then
			-- standard signals value
			rmap_memerror_o  <= '0';
			rmap_datavalid_o <= '0';
			rmap_readdata_o  <= (others => '0');
			-- check if a read request was issued
			if (rmap_read_i = '1') then
				rmap_datavalid_o <= '1';
				p_nfee_mem_rd(rmap_readaddr_i);
			end if;
		end if;
	end process p_rmap_mem_area_nfee_read;

	p_avalon_mm_rmap_read : process(clk_i, rst_i) is
		procedure p_avs_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				-- rmap config registers
				-- rmap hk registers

				when others =>
					avalon_mm_rmap_o.readdata <= (others => '0');
			end case;
		end procedure p_avs_readdata;
		variable v_read_address     : t_avalon_mm_spacewire_address := 0;
		variable v_read_timeout_cnt : natural range 0 to 15         := 15;
		variable v_read_executed    : std_logic                     := '0';
	begin
		if (rst_i = '1') then
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			v_read_address               := 0;
			v_read_timeout_cnt           := 15;
			v_read_executed              := '0';
		elsif (rising_edge(clk_i)) then
			avalon_mm_rmap_o.waitrequest <= '1';
			if (v_read_executed = 0) then
				avalon_mm_rmap_o.readdata <= (others => '0');
				if (avalon_mm_rmap_i.read = '1') then
					v_read_address := to_integer(unsigned(avalon_mm_rmap_i.address));
					-- check if the read address is in the rmap area range
					-- TODO: acertar o range do avalon
					if (v_read_address > 1) then
						-- read address is in the rmap area range 
						-- check if a rmap write is ocurring
						if (rmap_write_authorized_i = '0') then
							-- rmap write not ocurring, read register
							avalon_mm_rmap_o.waitrequest <= '0';
							p_avs_readdata(v_read_address);
							v_read_timeout_cnt           := 15;
							v_read_executed              := '1';
						else
							-- rmap write ocurring, wait to read register
							avalon_mm_rmap_o.waitrequest <= '1';
							v_read_timeout_cnt           := v_read_timeout_cnt - 1;
							-- check if the write finished or a timeout ocurred
							if ((rmap_write_finished_i = '1') or (v_read_timeout_cnt = 0)) then
								-- write finished or timeout ocurred, read register	
								avalon_mm_rmap_o.waitrequest <= '0';
								p_avs_readdata(v_read_address);
								v_read_timeout_cnt           := 15;
								v_read_executed              := '1';
							end if;
						end if;
					end if;
				end if;
			else
				v_read_executed := '0';
			end if;
		end if;
	end process p_avalon_mm_rmap_read;
	-- TODO: separar leituras do HK e Config

end architecture RTL;
