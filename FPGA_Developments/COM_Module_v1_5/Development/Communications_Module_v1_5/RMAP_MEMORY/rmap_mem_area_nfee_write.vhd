library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_write is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		rmap_write_i            : in  std_logic;
		rmap_writeaddr_i        : in  std_logic_vector(31 downto 0);
		rmap_writedata_i        : in  std_logic_vector(7 downto 0);
		avalon_mm_rmap_i        : in  t_avalon_mm_spacewire_write_in;
		rmap_write_authorized_i : in  std_logic;
		rmap_write_finished_i   : in  std_logic;
		rmap_read_authorized_i  : in  std_logic;
		rmap_read_finished_i    : in  std_logic;
		rmap_memerror_o         : out std_logic;
		rmap_memready_o         : out std_logic;
		avalon_mm_rmap_o        : out t_avalon_mm_spacewire_write_out;
		rmap_config_registers_o : out t_rmap_memory_config_area;
		rmap_hk_registers_o     : out t_rmap_memory_hk_area
	);
end entity rmap_mem_area_nfee_write;

architecture RTL of rmap_mem_area_nfee_write is

begin

	p_rmap_mem_area_nfee_write : process(clk_i, rst_i) is
		procedure p_nfee_reg_reset is
		begin
			-- Config Area
			-- HK Area
		end procedure p_nfee_reg_reset;

		procedure p_nfee_mem_wr(wr_addr_i : std_logic_vector) is
		begin
			-- NFEE Memory Write
			-- Case for access to all registers
			case (wr_addr_i(31 downto 0)) is

				-- Config Area

				-- Others
				when others =>
					null;
			end case;

		end procedure p_nfee_mem_wr;
	begin
		if (rst_i = '1') then
			rmap_memerror_o <= '0';
			rmap_memready_o <= '0';
			p_nfee_reg_reset;
		elsif rising_edge(clk_i) then

			-- standard signals value
			rmap_memerror_o <= '0';
			rmap_memready_o <= '1';
			-- check if a write request was issued
			if (rmap_write_i = '1') then
				rmap_memready_o <= '1';
				p_nfee_mem_wr(rmap_writeaddr_i);
			end if;

		end if;
	end process p_rmap_mem_area_nfee_write;

	p_avalon_mm_rmap_write : process(clk_i, rst_i) is
		procedure p_avs_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				-- rmap config registers
				-- rmap hk registers

				when others =>
					null;
			end case;
		end procedure p_avs_writedata;
		variable v_write_address     : t_avalon_mm_spacewire_address := 0;
		variable v_write_timeout_cnt : natural range 0 to 15         := 15;
		variable v_write_executed    : std_logic                     := '0';
	begin
		if (rst_i = '1') then
			avalon_mm_rmap_o.waitrequest <= '1';
			v_write_address              := 0;
			v_write_timeout_cnt          := 15;
			v_write_executed             := '0';
		elsif (rising_edge(clk_i)) then
			avalon_mm_rmap_o.waitrequest <= '1';
			if (v_write_executed = 0) then
				if (avalon_mm_rmap_i.write = '1') then
					v_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
					-- check if the write address is in the rmap area range
					-- TODO: acertar o range do avalon
					if (v_write_address > 1) then
						-- write address is in the rmap area range 
						-- check if a rmap write or a rmap read is ocurring
						if ((rmap_write_authorized_i = '0') or (rmap_read_authorized_i = '0')) then
							-- rmap write or a rmap read not ocurring, write register
							avalon_mm_rmap_o.waitrequest <= '0';
							p_avs_writedata(v_write_address);
							v_write_timeout_cnt          := 15;
							v_write_executed             := '1';
						else
							-- rmap write or rmap read ocurring, wait to write register
							avalon_mm_rmap_o.waitrequest <= '1';
							v_write_timeout_cnt          := v_write_timeout_cnt - 1;
							-- check if the write or read finished or a timeout ocurred
							if (((rmap_write_finished_i = '1') and (rmap_write_authorized_i = '1')) or ((rmap_read_finished_i = '1') and (rmap_read_authorized_i = '1')) or (v_write_timeout_cnt = 0)) then
								-- write or read finished or timeout ocurred, write register	
								avalon_mm_rmap_o.waitrequest <= '0';
								p_avs_writedata(v_write_address);
								v_write_timeout_cnt          := 15;
								v_write_executed             := '1';
							end if;
						end if;
					end if;
				end if;
			else
				v_write_executed := '0';
			end if;
		end if;
	end process p_avalon_mm_rmap_write;
	-- TODO: separar escritas do HK e Config

end architecture RTL;
